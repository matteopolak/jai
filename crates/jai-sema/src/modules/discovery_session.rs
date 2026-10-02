//! Pin one graph's semantic arenas while an actual source guard is suspended.
use super::prepared_session::{PreparedPhase, PreparedStart};
use super::*;

/// Original source requests owned by a preparation session, not rewritten bodies.
pub enum PreparedDiscoveryRequests {
    Conditions(Vec<jai_modules::DeferredCondition>),
    Cases(Vec<jai_modules::DeferredCase>),
    Using(Vec<jai_modules::FileUsingRequest>),
}

pub enum PreparedDiscoveryOutcome {
    Conditions(DiscoveryConditionOutcome),
    Cases(DiscoveryCaseOutcome),
    Using(DiscoveryUsingOutcome),
}

pub enum DiscoveryReadiness {
    Complete(PreparedDiscoveryOutcome),
    Pending(LibraryPending),
    Failed(LocatedDiagnostic),
}

/// The graph must remain immutable until completion or explicit cancellation.
pub struct PreparedDiscoverySession<'graph> {
    phase: Option<Box<PreparedPhase<'graph>>>,
    worklist: Option<compile_time::Worklist<'graph>>,
    requests: PreparedDiscoveryRequests,
    location: SourceSpan,
    terminal: Option<LocatedDiagnostic>,
}

impl<'graph> PreparedDiscoverySession<'graph> {
    pub fn new(
        graph: &'graph ModuleGraph,
        options: &crate::ResolveOptions,
        requests: PreparedDiscoveryRequests,
    ) -> Result<Self, LocatedDiagnostic> {
        let mode = match &requests {
            PreparedDiscoveryRequests::Conditions(requests) => {
                PreparedDiscovery::Conditions(requests)
            }
            PreparedDiscoveryRequests::Cases(requests) => PreparedDiscovery::Cases(requests),
            PreparedDiscoveryRequests::Using(requests) => PreparedDiscovery::Using(requests),
        };
        let PreparedStart::Phase(phase) = prepared_session::prepare(graph, options, Some(mode))?
        else {
            unreachable!("guard preparation does not resolve parameter requests")
        };
        let location = SourceSpan {
            source: graph
                .file(graph.module(graph.root()).unwrap().entry())
                .unwrap()
                .source(),
            span: Span::default(),
        };
        Ok(Self {
            phase: Some(phase),
            worklist: None,
            requests,
            location,
            terminal: None,
        })
    }

    /// Continue the exact VM checkpoint in the existing registry and source scope.
    pub fn drive(&mut self, effects: &mut dyn jai_vm::CompilerEffects) -> DiscoveryReadiness {
        if let Some(error) = &self.terminal {
            return DiscoveryReadiness::Failed(error.clone());
        }
        let effects = crate::compile_time::SharedEffects::new(effects);
        let mut jobs = match &self.requests {
            PreparedDiscoveryRequests::Conditions(requests) => {
                discovery_conditions::Jobs::new(requests)
            }
            PreparedDiscoveryRequests::Cases(requests) => {
                discovery_conditions::Jobs::new_cases(requests)
            }
            PreparedDiscoveryRequests::Using(requests) => {
                discovery_conditions::Jobs::new_using(requests)
            }
        };
        let phase = self
            .phase
            .as_mut()
            .expect("active discovery retains its arenas");
        match phase.drive_bindings(&effects, Some(&mut jobs), &mut self.worklist) {
            Ok(
                compile_time::BindingProgress::HeadersReady
                | compile_time::BindingProgress::InitializersReady,
            ) => {
                let cancellation = self
                    .worklist
                    .take()
                    .map_or(Ok(()), |worklist| worklist.cancel(&effects));
                self.phase = None;
                let mut error = self.lifecycle_error(
                    "unexpectedly stopped at header readiness during full discovery",
                );
                if let Err(cause) = cancellation {
                    error
                        .message
                        .push_str(&format!("; cancellation failed: {cause}"));
                }
                self.terminal = Some(error.clone());
                DiscoveryReadiness::Failed(error)
            }
            Ok(compile_time::BindingProgress::Pending(pending)) => {
                DiscoveryReadiness::Pending(pending)
            }
            Ok(compile_time::BindingProgress::Complete(_)) => {
                // The worklist cancels unrelated parked tokens before returning
                // Complete. Only source identities can outlive this arena.
                let specializations = phase.take_specializations();
                let outcome = match &self.requests {
                    PreparedDiscoveryRequests::Conditions(_) => {
                        PreparedDiscoveryOutcome::Conditions(DiscoveryConditionOutcome {
                            specializations,
                            decisions: jobs.decisions,
                            pending: jobs.pending,
                        })
                    }
                    PreparedDiscoveryRequests::Cases(_) => {
                        PreparedDiscoveryOutcome::Cases(DiscoveryCaseOutcome {
                            specializations,
                            decisions: jobs.case_decisions,
                            pending: jobs.case_pending,
                        })
                    }
                    PreparedDiscoveryRequests::Using(_) => {
                        PreparedDiscoveryOutcome::Using(DiscoveryUsingOutcome {
                            specializations,
                            decisions: jobs.using_decisions,
                            pending: jobs.using_pending,
                        })
                    }
                };
                self.phase = None;
                self.worklist = None;
                self.terminal = Some(self.lifecycle_error("already completed"));
                DiscoveryReadiness::Complete(outcome)
            }
            Err(error) => {
                self.phase = None;
                self.worklist = None;
                self.terminal = Some(error.clone());
                DiscoveryReadiness::Failed(error)
            }
        }
    }

    /// Retire the original checkpoint before releasing effects or changing graph.
    pub fn cancel(
        &mut self,
        effects: &mut dyn jai_vm::CompilerEffects,
    ) -> Result<(), jai_vm::Error> {
        if self.terminal.is_some() {
            return Ok(());
        }
        let effects = crate::compile_time::SharedEffects::new(effects);
        let result = self
            .worklist
            .take()
            .map_or(Ok(()), |worklist| worklist.cancel(&effects));
        self.phase = None;
        self.terminal = Some(self.lifecycle_error("was cancelled"));
        result
    }

    fn lifecycle_error(&self, state: &str) -> LocatedDiagnostic {
        LocatedDiagnostic {
            location: self.location,
            message: format!("semantic discovery session {state}"),
        }
    }
}
