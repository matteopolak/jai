//! Resume the retained source graph with genuine typed compiler decisions.
use crate::{CompilationUnit, CompilerSession, EffectReplayCache, Error, ReplayEffects};
use jai_modules::{
    BootstrapOptions, DiscoveryStatus, GraphDiscovery, GraphOptions, ModuleGraph, SourceProvider,
};
use jai_source::LocatedDiagnostic;
use jai_types::BuildTarget;
use jai_vm::{Limits, WorkspaceId};
use std::path::Path;

/// The caller retains the same compiler session and replay cache for final binding.
pub struct SemanticDiscoveryOptions {
    pub graph: GraphOptions,
    pub bootstrap: BootstrapOptions,
    pub target: BuildTarget,
    pub workspace: WorkspaceId,
    pub limits: Limits,
    pub effect_policy: DiscoveryEffectPolicy,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum DiscoveryEffectPolicy {
    Disabled,
    CompilerSession,
}

impl CompilationUnit {
    pub fn load_with_bootstrap_session(
        path: &Path,
        options: SemanticDiscoveryOptions,
        session: &mut CompilerSession,
        replay: &mut EffectReplayCache,
    ) -> Result<Self, Error> {
        let graph_options = options.graph.clone();
        let graph =
            discover_graph_with_session(path, options, &jai_modules::Filesystem, session, replay)?;
        Ok(Self {
            graph,
            options: graph_options,
        })
    }

    pub fn resolve_discovered_with_session(
        &self,
        layout: jai_types::LayoutPolicy,
        session: &mut CompilerSession,
        replay: &mut EffectReplayCache,
        policy: DiscoveryEffectPolicy,
    ) -> Result<jai_sema::Program, Error> {
        let options = self.resolve_options(layout, session);
        let program = match policy {
            DiscoveryEffectPolicy::Disabled => {
                jai_sema::resolve_graph_with_options(&self.graph, &options, &mut jai_vm::NoEffects)
            }
            DiscoveryEffectPolicy::CompilerSession => jai_sema::resolve_graph_with_options(
                &self.graph,
                &options,
                &mut ReplayEffects::new(session, replay),
            ),
        }
        .map_err(|diagnostic| self.located(diagnostic))?;
        if let Some(error) = session.error() {
            return Err(Error::CompilerReport(error.clone()));
        }
        Ok(program)
    }

    pub fn resolve_library_discovered_with_session(
        &self,
        layout: jai_types::LayoutPolicy,
        session: &mut CompilerSession,
        replay: &mut EffectReplayCache,
        policy: DiscoveryEffectPolicy,
    ) -> Result<jai_sema::Library, Error> {
        let options = self.resolve_options(layout, session);
        let library = match policy {
            DiscoveryEffectPolicy::Disabled => jai_sema::resolve_library_with_options(
                &self.graph,
                &options,
                &mut jai_vm::NoEffects,
            ),
            DiscoveryEffectPolicy::CompilerSession => jai_sema::resolve_library_with_options(
                &self.graph,
                &options,
                &mut ReplayEffects::new(session, replay),
            ),
        }
        .map_err(|diagnostic| self.located(diagnostic))?;
        if let Some(error) = session.error() {
            return Err(Error::CompilerReport(error.clone()));
        }
        Ok(library)
    }
}

pub fn discover_graph_with_session(
    path: &Path,
    options: SemanticDiscoveryOptions,
    provider: &dyn SourceProvider,
    session: &mut CompilerSession,
    replay: &mut EffectReplayCache,
) -> Result<ModuleGraph, Error> {
    match options.effect_policy {
        DiscoveryEffectPolicy::Disabled => {
            discover_graph_with_effects(path, options, provider, &mut jai_vm::NoEffects)
        }
        DiscoveryEffectPolicy::CompilerSession => discover_graph_with_effects(
            path,
            options,
            provider,
            &mut ReplayEffects::new(session, replay),
        ),
    }
}

/// Keep the caller's retained handler across graph decisions, including a
/// scheduler that can service the exact suspended VM job without root replay.
pub(crate) fn discover_graph_with_effects(
    path: &Path,
    options: SemanticDiscoveryOptions,
    provider: &dyn SourceProvider,
    effects: &mut dyn jai_vm::CompilerEffects,
) -> Result<ModuleGraph, Error> {
    let mut discovery = GraphDiscovery::with_bootstrap(
        path,
        options.graph.clone(),
        options.bootstrap,
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
        let requests: Vec<_> = discovery.pending_conditions().cloned().collect();
        let parameters = discovery.pending_parameter_requests();
        let cases: Vec<_> = discovery.pending_cases().cloned().collect();
        if requests.is_empty()
            && cases.is_empty()
            && parameters.is_empty()
            && using.is_empty()
            && !status.is_complete()
            && !discovery.has_dependency_templates()
        {
            let DiscoveryStatus::Awaiting { dependencies, .. } = status else {
                unreachable!()
            };
            let dependency = dependencies
                .into_iter()
                .next()
                .expect("awaiting discovery retains a dependency");
            return Err(located(discovery.graph(), dependency.diagnostic));
        }
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
        let mut parameter_failure = None;
        if !parameters.is_empty() {
            let outcome = jai_sema::resolve_discovery_parameters(
                discovery.graph(),
                &parameters,
                &resolve,
                effects,
            );
            match outcome {
                Ok(outcome) if !outcome.decisions.is_empty() => {
                    for (request, response) in outcome.decisions {
                        discovery
                            .resolve_parameter(request, response)
                            .expect("typed parameter responses retain source request identity");
                    }
                    continue;
                }
                Ok(outcome) => {
                    parameter_failure = outcome
                        .pending
                        .into_iter()
                        .next()
                        .map(|pending| pending.diagnostic)
                }
                Err(diagnostic) => parameter_failure = Some(diagnostic),
            }
        }
        let mut using_failure = None;
        if !using.is_empty() {
            let outcome =
                jai_sema::resolve_discovery_using(discovery.graph(), &using, &resolve, effects);
            match outcome {
                Ok(outcome) => {
                    let mut progressed = false;
                    for key in outcome.specializations {
                        progressed |= discovery.discover_specialization(key)?;
                    }
                    for (request, decision) in outcome.decisions {
                        discovery.resolve_using(request, decision)?;
                        progressed = true;
                    }
                    if progressed {
                        continue;
                    }
                    using_failure = outcome
                        .pending
                        .into_iter()
                        .next()
                        .map(|pending| pending.diagnostic);
                }
                Err(diagnostic) => using_failure = Some(diagnostic),
            }
        }
        let mut case_failure = None;
        if !cases.is_empty() {
            let result =
                jai_sema::resolve_discovery_cases(discovery.graph(), &cases, &resolve, effects);
            match result {
                Ok(outcome) => {
                    let mut progressed = false;
                    for key in outcome.specializations {
                        progressed |= discovery.discover_specialization(key)?;
                    }
                    for (request, choice) in outcome.decisions {
                        discovery
                            .select_case(request, choice)
                            .expect("typed case choices retain original source request identity");
                        progressed = true;
                    }
                    if progressed {
                        continue;
                    }
                    case_failure = outcome
                        .pending
                        .into_iter()
                        .next()
                        .map(|pending| pending.diagnostic);
                }
                Err(diagnostic) => case_failure = Some(diagnostic),
            }
        }
        if requests.is_empty() && !discovery.has_dependency_templates() {
            let diagnostic = case_failure
                .or(using_failure)
                .or(parameter_failure)
                .unwrap_or_else(|| LocatedDiagnostic {
                    location: cases
                        .first()
                        .map(|case| case.location)
                        .or_else(|| using.first().map(|request| request.location))
                        .unwrap_or_else(|| parameters[0].location),
                    message: "source discovery request has no ready semantic response".into(),
                });
            return Err(located(discovery.graph(), diagnostic));
        }
        let outcome = {
            let result = jai_sema::resolve_discovery_conditions(
                discovery.graph(),
                &requests,
                &resolve,
                effects,
            );
            result.map_err(|diagnostic| located(discovery.graph(), diagnostic))?
        };
        let mut progressed = false;
        for key in outcome.specializations {
            progressed |= discovery.discover_specialization(key)?;
        }
        for (request, selected) in outcome.decisions {
            discovery
                .select_condition(request, selected)
                .expect("typed decisions retain discovery request identity");
            progressed = true;
        }
        if progressed {
            continue;
        }
        if status.is_complete()
            && parameter_failure.is_none()
            && using_failure.is_none()
            && case_failure.is_none()
        {
            return Ok(discovery
                .into_graph()
                .ok()
                .expect("complete specialization discovery retains its graph"));
        }
        let diagnostic = outcome
            .pending
            .into_iter()
            .next()
            .map(|pending| pending.diagnostic)
            .or(case_failure)
            .or(using_failure)
            .or(parameter_failure)
            .or_else(|| match status {
                DiscoveryStatus::Awaiting { dependencies, .. } => dependencies
                    .into_iter()
                    .next()
                    .map(|dependency| dependency.diagnostic),
                DiscoveryStatus::Complete => None,
            })
            .unwrap_or_else(|| LocatedDiagnostic {
                location: requests
                    .first()
                    .map(|request| request.location)
                    .unwrap_or_else(|| discovery.graph().dependency_templates()[0].location()),
                message: "source specialization has no ready semantic dependency".into(),
            });
        return Err(located(discovery.graph(), diagnostic));
    }
}

pub(crate) fn located(graph: &ModuleGraph, diagnostic: LocatedDiagnostic) -> Error {
    let record = graph
        .sources()
        .get(diagnostic.location.source)
        .expect("discovery diagnostics retain defining sources");
    Error::Located {
        source: diagnostic.location.source,
        path: record.path().to_owned(),
        diagnostic: jai_source::Diagnostic::at_source(
            diagnostic.location,
            diagnostic.message.clone(),
        ),
        rendered: diagnostic.render(graph.sources()),
    }
}

#[cfg(test)]
#[path = "source_discovery/using_tests.rs"]
mod using_tests;
