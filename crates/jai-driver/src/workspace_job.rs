//! Keep an immutable compilation unit and its borrowed preparation alive together.
use crate::{CompilationUnit, CompilerSession, EffectReplayCache, Error, ReplayEffects};
use jai_sema::{LibraryPending, LibraryReadiness, PreparedLibrarySession, ResolveOptions};
use jai_source::LocatedDiagnostic;
use std::{
    cell::RefCell,
    future::{Future, poll_fn},
    pin::Pin,
    rc::Rc,
    sync::Arc,
    task::{Context, Poll, Wake, Waker},
};

pub struct WorkspaceJobResult {
    pub unit: Arc<CompilationUnit>,
    pub library: Box<jai_sema::Library>,
    pub compiler: CompilerSession,
    pub replay: EffectReplayCache,
}

pub enum WorkspaceJobProgress {
    Complete(Box<WorkspaceJobResult>),
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

type JobFuture = Pin<Box<dyn Future<Output = Result<Box<jai_sema::Library>, LocatedDiagnostic>>>>;

/// Owns a source snapshot, private journals, and a compiler-pinned preparation.
/// Dropping a pending job synchronously cancels its exact VM continuation.
pub struct PreparedWorkspaceJob {
    unit: Arc<CompilationUnit>,
    state: Rc<RefCell<JobState>>,
    future: Option<JobFuture>,
}

impl PreparedWorkspaceJob {
    pub fn new(
        unit: CompilationUnit,
        options: ResolveOptions,
        compiler: CompilerSession,
        replay: EffectReplayCache,
    ) -> Self {
        let unit = Arc::new(unit);
        let state = Rc::new(RefCell::new(JobState {
            journal: Some(Journal { compiler, replay }),
            pending: None,
            cancellation_error: None,
        }));
        let future_unit = Arc::clone(&unit);
        let future_state = Rc::clone(&state);
        let future = Box::pin(async move {
            // Rust's pinned future retains these locals and their borrows across
            // await. The controller never constructs a self-referential struct.
            let mut session = PreparedLibrarySession::new(future_unit.graph(), &options)?;
            let guard = CancellationGuard {
                session: &mut session,
                state: future_state,
            };
            poll_fn(|_| {
                let mut state = guard.state.borrow_mut();
                let progress = {
                    let Journal { compiler, replay } = state
                        .journal
                        .as_mut()
                        .expect("running job retains private journals");
                    guard
                        .session
                        .drive(&mut ReplayEffects::new(compiler, replay))
                };
                match progress {
                    LibraryReadiness::Complete(library) => {
                        state.pending = None;
                        Poll::Ready(Ok(library))
                    }
                    LibraryReadiness::Failed(error) => {
                        state.pending = None;
                        Poll::Ready(Err(error))
                    }
                    LibraryReadiness::Pending(pending) => {
                        state.pending = Some(pending);
                        Poll::Pending
                    }
                }
            })
            .await
        });
        Self {
            unit,
            state,
            future: Some(future),
        }
    }

    pub fn unit(&self) -> &CompilationUnit {
        &self.unit
    }

    /// Polls the same pinned source job. Readiness is serviced by its controller.
    pub fn poll(&mut self) -> Result<WorkspaceJobProgress, jai_vm::Error> {
        let future = self.future.as_mut().ok_or_else(|| {
            jai_vm::Error::EffectRejected("workspace job has already terminated".into())
        })?;
        let waker = Waker::from(Arc::new(JobWake));
        let result = future.as_mut().poll(&mut Context::from_waker(&waker));
        match result {
            Poll::Pending => Ok(WorkspaceJobProgress::Pending(
                self.state
                    .borrow()
                    .pending
                    .as_ref()
                    .expect("suspended future publishes typed readiness")
                    .clone(),
            )),
            Poll::Ready(result) => {
                // Drop the cancellation guard before releasing its journals.
                self.future = None;
                let mut state = self.state.borrow_mut();
                if let Some(error) = state.cancellation_error.take() {
                    return Err(error);
                }
                Ok(match result {
                    Ok(library) => {
                        let Journal { compiler, replay } = state
                            .journal
                            .take()
                            .expect("terminated job retains private journals");
                        WorkspaceJobProgress::Complete(Box::new(WorkspaceJobResult {
                            unit: Arc::clone(&self.unit),
                            library,
                            compiler,
                            replay,
                        }))
                    }
                    Err(error) => WorkspaceJobProgress::Failed(self.unit.located(error)),
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

    /// Services only the compiler requests issued by this retained source job.
    pub fn service_pending(
        &mut self,
        scheduler: &mut crate::WorkspaceScheduler,
    ) -> Result<bool, crate::SchedulerError> {
        let mut progress = false;
        for origin in self.suspended_origins() {
            progress |= self.with_journals(|compiler, replay| {
                scheduler.advance_suspended(compiler, replay, &origin)
            })??;
        }
        Ok(progress)
    }

    pub(crate) fn with_journals<T>(
        &mut self,
        action: impl FnOnce(&mut CompilerSession, &mut EffectReplayCache) -> T,
    ) -> Result<T, jai_vm::Error> {
        let mut state = self.state.borrow_mut();
        let Journal { compiler, replay } = state.journal.as_mut().ok_or_else(|| {
            jai_vm::Error::EffectRejected("workspace job has already terminated".into())
        })?;
        Ok(action(compiler, replay))
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

impl Drop for PreparedWorkspaceJob {
    fn drop(&mut self) {
        self.future = None;
    }
}

struct CancellationGuard<'session, 'graph> {
    session: &'session mut PreparedLibrarySession<'graph>,
    state: Rc<RefCell<JobState>>,
}

impl Drop for CancellationGuard<'_, '_> {
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

struct JobWake;
impl Wake for JobWake {
    fn wake(self: Arc<Self>) {}
}

#[cfg(test)]
#[path = "workspace_job/tests.rs"]
mod tests;
