//! Advance only after the retained semantic guard releases its graph borrow.
use super::*;

struct Guard<'session, 'graph> {
    session: &'session mut PreparedGraphDiscoverySession<'graph>,
    state: Rc<RefCell<JobState>>,
}
impl Drop for Guard<'_, '_> {
    fn drop(&mut self) {
        let mut state = self.state.borrow_mut();
        if let Some(Journal { compiler, replay }) = state.journal.as_mut()
            && let Err(error) = self
                .session
                .cancel(&mut ReplayEffects::new(compiler, replay))
        {
            state.cancellation_error = Some(error);
        }
    }
}

async fn query(
    discovery: &GraphDiscovery<'_>,
    options: &SemanticDiscoveryOptions,
    kind: DiscoveryQuery,
    state: Rc<RefCell<JobState>>,
) -> Result<PreparedDiscoveryOutcome, Error> {
    let mut session = PreparedGraphDiscoverySession::new(discovery, options, kind)
        .map_err(|error| crate::source_discovery::located(discovery.graph(), error))?;
    let guard = Guard {
        session: &mut session,
        state,
    };
    poll_fn(|_| {
        let mut state = guard.state.borrow_mut();
        let progress = {
            let Journal { compiler, replay } = state
                .journal
                .as_mut()
                .expect("running graph retains its private journals");
            guard
                .session
                .drive(&mut ReplayEffects::new(compiler, replay))
        };
        match progress {
            DiscoveryReadiness::Complete(outcome) => {
                state.pending = None;
                Poll::Ready(Ok(outcome))
            }
            DiscoveryReadiness::Failed(error) => {
                state.pending = None;
                Poll::Ready(Err(crate::source_discovery::located(
                    discovery.graph(),
                    error,
                )))
            }
            DiscoveryReadiness::Pending(pending) => {
                state.pending = Some(pending);
                Poll::Pending
            }
        }
    })
    .await
}

pub(super) async fn discover(
    path: &std::path::Path,
    options: &SemanticDiscoveryOptions,
    provider: &dyn SourceProvider,
    state: Rc<RefCell<JobState>>,
) -> Result<ModuleGraph, Error> {
    let mut discovery = GraphDiscovery::with_bootstrap(
        path,
        options.graph.clone(),
        options.bootstrap.clone(),
        provider,
        Some(options.target.clone()),
    )?;
    loop {
        let status = discovery.advance()?;
        let using = discovery.pending_using_requests();
        if status.is_complete() && !discovery.has_dependency_templates() && using.is_empty() {
            return Ok(discovery
                .into_graph()
                .ok()
                .expect("complete discovery retains its graph"));
        }
        let conditions: Vec<_> = discovery
            .pending_conditions()
            .map(|request| request.location)
            .collect();
        let parameters = discovery.pending_parameter_requests();
        let cases: Vec<_> = discovery
            .pending_cases()
            .map(|request| request.location)
            .collect();
        if conditions.is_empty()
            && parameters.is_empty()
            && cases.is_empty()
            && using.is_empty()
            && !discovery.has_dependency_templates()
        {
            let DiscoveryStatus::Awaiting { dependencies, .. } = status else {
                unreachable!()
            };
            return Err(crate::source_discovery::located(
                discovery.graph(),
                dependencies
                    .into_iter()
                    .next()
                    .expect("awaiting discovery retains a dependency")
                    .diagnostic,
            ));
        }
        let mut failure = None;
        if !parameters.is_empty() {
            let resolve = jai_sema::ResolveOptions {
                target: Some(options.target.clone()),
                compile_time_limits: options.limits,
                compiler: Some(jai_sema::CompilerBindingContext::from_graph(
                    discovery.graph(),
                    &options.graph.import_dirs,
                    options.workspace,
                )),
                ..Default::default()
            };
            let outcome = {
                let mut state = state.borrow_mut();
                let Journal { compiler, replay } = state
                    .journal
                    .as_mut()
                    .expect("running graph retains its journals");
                match options.effect_policy {
                    DiscoveryEffectPolicy::Disabled => jai_sema::resolve_discovery_parameters(
                        discovery.graph(),
                        &parameters,
                        &resolve,
                        &mut jai_vm::NoEffects,
                    ),
                    DiscoveryEffectPolicy::CompilerSession => {
                        jai_sema::resolve_discovery_parameters(
                            discovery.graph(),
                            &parameters,
                            &resolve,
                            &mut ReplayEffects::new(compiler, replay),
                        )
                    }
                }
            };
            match outcome {
                Ok(outcome) => {
                    let progressed = !outcome.decisions.is_empty();
                    for (request, response) in outcome.decisions {
                        discovery
                            .resolve_parameter(request, response)
                            .expect("typed parameter responses retain request identity");
                    }
                    if progressed {
                        continue;
                    }
                    failure = outcome
                        .pending
                        .into_iter()
                        .next()
                        .map(|pending| pending.diagnostic);
                }
                Err(error) => failure = Some(error),
            }
        }
        let mut advanced = false;
        let queries = [
            (DiscoveryQuery::Using, !using.is_empty()),
            (DiscoveryQuery::Cases, !cases.is_empty()),
            (
                DiscoveryQuery::Conditions,
                !conditions.is_empty() || discovery.has_dependency_templates(),
            ),
        ];
        for (kind, enabled) in queries {
            if !enabled {
                continue;
            }
            let outcome = match query(&discovery, options, kind, Rc::clone(&state)).await {
                Ok(outcome) => outcome,
                Err(error) if kind == DiscoveryQuery::Conditions => return Err(error),
                Err(Error::Located {
                    source, diagnostic, ..
                }) => {
                    failure = Some(jai_source::LocatedDiagnostic {
                        location: jai_source::SourceSpan {
                            source,
                            span: diagnostic.span,
                        },
                        message: diagnostic.message,
                    });
                    continue;
                }
                Err(error) => return Err(error),
            };
            let pending = match outcome {
                PreparedDiscoveryOutcome::Using(outcome) => {
                    for key in outcome.specializations {
                        advanced |= discovery.discover_specialization(key)?;
                    }
                    for (request, decision) in outcome.decisions {
                        discovery.resolve_using(request, decision)?;
                        advanced = true;
                    }
                    outcome
                        .pending
                        .into_iter()
                        .next()
                        .map(|pending| pending.diagnostic)
                }
                PreparedDiscoveryOutcome::Cases(outcome) => {
                    for key in outcome.specializations {
                        advanced |= discovery.discover_specialization(key)?;
                    }
                    for (request, choice) in outcome.decisions {
                        discovery
                            .select_case(request, choice)
                            .expect("typed case decisions retain request identity");
                        advanced = true;
                    }
                    outcome
                        .pending
                        .into_iter()
                        .next()
                        .map(|pending| pending.diagnostic)
                }
                PreparedDiscoveryOutcome::Conditions(outcome) => {
                    for key in outcome.specializations {
                        advanced |= discovery.discover_specialization(key)?;
                    }
                    for (request, selected) in outcome.decisions {
                        discovery
                            .select_condition(request, selected)
                            .expect("typed condition decisions retain request identity");
                        advanced = true;
                    }
                    outcome
                        .pending
                        .into_iter()
                        .next()
                        .map(|pending| pending.diagnostic)
                }
            };
            failure = pending.or(failure);
            if advanced {
                break;
            }
        }
        if advanced {
            continue;
        }
        if status.is_complete() && failure.is_none() {
            return Ok(discovery
                .into_graph()
                .ok()
                .expect("complete discovery retains its graph"));
        }
        let diagnostic = failure
            .or_else(|| match status {
                DiscoveryStatus::Awaiting { dependencies, .. } => dependencies
                    .into_iter()
                    .next()
                    .map(|dependency| dependency.diagnostic),
                DiscoveryStatus::Complete => None,
            })
            .unwrap_or_else(|| jai_source::LocatedDiagnostic {
                location: conditions
                    .first()
                    .copied()
                    .or_else(|| using.first().map(|request| request.location))
                    .or_else(|| cases.first().copied())
                    .or_else(|| parameters.first().map(|request| request.location))
                    .unwrap_or_else(|| discovery.graph().dependency_templates()[0].location()),
                message: "source discovery has no ready semantic dependency".into(),
            });
        return Err(crate::source_discovery::located(
            discovery.graph(),
            diagnostic,
        ));
    }
}
