//! Own graph discovery and the borrowed semantic guard across genuine suspension.
use crate::{
    CompilationUnit, CompilerSession, DiscoveryEffectPolicy, DiscoveryQuery, EffectReplayCache,
    Error, PreparedGraphDiscoverySession, ReplayEffects, SemanticDiscoveryOptions,
};
use jai_modules::{DiscoveryStatus, GraphDiscovery, ModuleGraph, SourceProvider};
mod discovery;
use jai_sema::{DiscoveryReadiness, LibraryPending, PreparedDiscoveryOutcome};
use std::{
    cell::RefCell,
    future::{Future, poll_fn},
    path::PathBuf,
    pin::Pin,
    rc::Rc,
    sync::Arc,
    task::{Context, Poll, Wake, Waker},
};

pub struct GraphJobResult {
    pub unit: CompilationUnit,
    pub compiler: CompilerSession,
    pub replay: EffectReplayCache,
}

pub enum GraphJobProgress {
    Complete(Box<GraphJobResult>),
    Pending(LibraryPending),
    Failed(Error),
}

struct Journal {
    compiler: CompilerSession,
    replay: EffectReplayCache,
}
struct JobState {
    journal: Option<Journal>,
    pending: Option<LibraryPending>,
    cancellation_error: Option<jai_vm::Error>,
}
type JobFuture = Pin<Box<dyn Future<Output = Result<CompilationUnit, Error>>>>;

/// Owns the provider and graph inside a pinned future. Pending guards keep the
/// same semantic arenas and source identities until their decisions are ready.
pub struct PreparedGraphJob {
    state: Rc<RefCell<JobState>>,
    future: Option<JobFuture>,
}

impl PreparedGraphJob {
    pub fn new(
        path: PathBuf,
        options: SemanticDiscoveryOptions,
        provider: impl SourceProvider + 'static,
        compiler: CompilerSession,
        replay: EffectReplayCache,
    ) -> Self {
        let state = Rc::new(RefCell::new(JobState {
            journal: Some(Journal { compiler, replay }),
            pending: None,
            cancellation_error: None,
        }));
        let future_state = Rc::clone(&state);
        let future = Box::pin(async move {
            let graph_options = options.graph.clone();
            let graph = discovery::discover(&path, &options, &provider, future_state).await?;
            Ok(CompilationUnit {
                graph,
                options: graph_options,
            })
        });
        Self {
            state,
            future: Some(future),
        }
    }

    pub fn poll(&mut self) -> Result<GraphJobProgress, jai_vm::Error> {
        let future = self.future.as_mut().ok_or_else(|| {
            jai_vm::Error::EffectRejected("graph discovery job has already terminated".into())
        })?;
        let waker = Waker::from(Arc::new(JobWake));
        let result = future.as_mut().poll(&mut Context::from_waker(&waker));
        match result {
            Poll::Pending => Ok(GraphJobProgress::Pending(
                self.state
                    .borrow()
                    .pending
                    .as_ref()
                    .expect("suspended graph publishes typed readiness")
                    .clone(),
            )),
            Poll::Ready(result) => {
                self.future = None;
                let mut state = self.state.borrow_mut();
                if let Some(error) = state.cancellation_error.take() {
                    return Err(error);
                }
                Ok(match result {
                    Ok(unit) => {
                        let Journal { compiler, replay } = state
                            .journal
                            .take()
                            .expect("completed graph retains its private journals");
                        GraphJobProgress::Complete(Box::new(GraphJobResult {
                            unit,
                            compiler,
                            replay,
                        }))
                    }
                    Err(error) => GraphJobProgress::Failed(error),
                })
            }
        }
    }

    pub fn cancel(&mut self) -> Result<(), jai_vm::Error> {
        self.future = None;
        let mut state = self.state.borrow_mut();
        state.pending = None;
        state.journal = None;
        state.cancellation_error.take().map_or(Ok(()), Err)
    }

    pub fn suspended_origins(&self) -> Vec<jai_vm::SourceOrigin> {
        self.state
            .borrow()
            .journal
            .as_ref()
            .map(|journal| journal.replay.suspended_origins().cloned().collect())
            .unwrap_or_default()
    }

    pub fn service_pending(
        &mut self,
        scheduler: &mut crate::WorkspaceScheduler,
    ) -> Result<bool, crate::SchedulerError> {
        let origins = self.suspended_origins();
        let mut state = self.state.borrow_mut();
        let Journal { compiler, replay } = state.journal.as_mut().ok_or_else(|| {
            jai_vm::Error::EffectRejected("graph discovery job has already terminated".into())
        })?;
        let mut progress = false;
        for origin in origins {
            progress |= scheduler.advance_suspended(compiler, replay, &origin)?;
        }
        Ok(progress)
    }

    pub(crate) fn take_terminal_journals(
        &mut self,
    ) -> Option<(CompilerSession, EffectReplayCache)> {
        if self.future.is_some() {
            return None;
        }
        self.state
            .borrow_mut()
            .journal
            .take()
            .map(|Journal { compiler, replay }| (compiler, replay))
    }
}

impl Drop for PreparedGraphJob {
    fn drop(&mut self) {
        self.future = None;
    }
}

struct JobWake;
impl Wake for JobWake {
    fn wake(self: Arc<Self>) {}
}

#[cfg(test)]
#[path = "graph_job/tests.rs"]
mod tests;
