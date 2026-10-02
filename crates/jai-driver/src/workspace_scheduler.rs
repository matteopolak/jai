//! Rebuild actual module graphs from committed compile-time workspace inputs.
use crate::{
    BuildInput, BuildSettings, CompilationUnit, CompilerSession, EffectReplayCache, Error,
    ReplayEffects, ReplayLimits,
};
use jai_modules::{BootstrapOptions, GraphOptions, SourceOverlay};
use jai_types::BuildTarget;
use jai_vm::{
    CompilerEffects, CompilerEvent, CompilerPhase, Limits, SourceOrigin, TargetTriple, WorkspaceId,
};
use std::{
    collections::{BTreeMap, HashMap},
    fmt, fs,
    path::{Path, PathBuf},
};

#[derive(Clone, Copy, Debug)]
pub struct SchedulerLimits {
    pub passes: usize,
    pub workspaces: usize,
    pub inputs: usize,
    pub generated_bytes: usize,
}
impl Default for SchedulerLimits {
    fn default() -> Self {
        Self {
            passes: 128,
            workspaces: 256,
            inputs: 10_000,
            generated_bytes: 64 * 1024 * 1024,
        }
    }
}
#[derive(Clone, Debug)]
pub struct SchedulerOptions {
    pub target: BuildTarget,
    /// Exact backend triple corresponding to `target`; other triples need a new scheduler.
    pub target_triple: TargetTriple,
    pub compile_time_limits: Limits,
    pub limits: SchedulerLimits,
    pub replay_limits: ReplayLimits,
}
pub enum WorkspaceOutput {
    Checked {
        unit: Box<CompilationUnit>,
        library: Box<jai_sema::Library>,
        settings: BuildSettings,
    },
    AwaitingInputs,
}
pub struct ScheduledWorkspace {
    pub id: WorkspaceId,
    pub name: String,
    pub output: WorkspaceOutput,
}
pub struct ScheduledBuild {
    pub root: WorkspaceId,
    pub workspaces: Vec<ScheduledWorkspace>,
    pub passes: usize,
}
#[derive(Clone, Debug)]
pub struct SchedulerPending {
    pub workspace: WorkspaceId,
    pub source: jai_sema::LibraryPending,
}
pub enum SchedulerReadiness {
    Complete(ScheduledBuild),
    Pending(SchedulerPending),
}
impl ScheduledBuild {
    pub fn workspace(&self, id: WorkspaceId) -> Option<&ScheduledWorkspace> {
        self.workspaces.iter().find(|workspace| workspace.id == id)
    }
}
#[derive(Debug)]
pub enum SchedulerError {
    Driver(Error),
    CompilerEffect(jai_vm::Error),
    Limit(&'static str),
    PhysicalSourceChanged(PathBuf),
    VirtualPathCollision(PathBuf),
    UnsupportedTarget {
        workspace: WorkspaceId,
        requested: TargetTriple,
        selected: TargetTriple,
    },
    DifferentSession,
    NonUtf8Path(PathBuf),
    Pending(Box<SchedulerPending>),
    ChangedPendingSession,
}
impl fmt::Display for SchedulerError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Driver(error) => error.fmt(formatter),
            Self::CompilerEffect(error) => error.fmt(formatter),
            Self::Limit(name) => write!(formatter, "workspace scheduler {name} limit exceeded"),
            Self::PhysicalSourceChanged(path) => write!(
                formatter,
                "{} changed during this compiler session; start a fresh scheduler and session",
                path.display()
            ),
            Self::VirtualPathCollision(path) => write!(
                formatter,
                "generated source path already exists: {}",
                path.display()
            ),
            Self::UnsupportedTarget {
                workspace,
                requested,
                selected,
            } => write!(
                formatter,
                "workspace {} requests target {}, but this scheduler is configured for {}",
                workspace.get(),
                requested.as_str(),
                selected.as_str()
            ),
            Self::DifferentSession => {
                formatter.write_str("workspace scheduler belongs to a different compiler session")
            }
            Self::NonUtf8Path(path) => write!(
                formatter,
                "source #load path cannot be represented as UTF-8: {}",
                path.display()
            ),
            Self::Pending(pending) => write!(
                formatter,
                "workspace {} is suspended on {:?}",
                pending.workspace.get(),
                pending.source.dependencies
            ),
            Self::ChangedPendingSession => formatter.write_str(
                "the committed compiler session changed while a source job was suspended",
            ),
        }
    }
}
impl std::error::Error for SchedulerError {}
impl From<Error> for SchedulerError {
    fn from(error: Error) -> Self {
        Self::Driver(error)
    }
}
impl From<jai_vm::Error> for SchedulerError {
    fn from(error: jai_vm::Error) -> Self {
        Self::CompilerEffect(error)
    }
}

/// Owns source snapshots and effect replay for one compiler session.
/// Checked outputs describe semantic compilation only; no native tool is invoked.
pub struct WorkspaceScheduler {
    root: PathBuf,
    root_text: String,
    graph_options: GraphOptions,
    bootstrap: BootstrapOptions,
    options: SchedulerOptions,
    physical: HashMap<PathBuf, Vec<u8>>,
    replay: EffectReplayCache,
    session: Option<WorkspaceId>,
    build: Option<BuildState>,
}
struct BuildState {
    pass: usize,
    before: Vec<Snapshot>,
    next: usize,
    results: BTreeMap<u64, ScheduledWorkspace>,
    failure: Option<Error>,
    active: Option<ActiveWorkspaceJob>,
}
struct ActiveWorkspaceJob {
    workspace: Snapshot,
    revision: u64,
    job: ActiveSourceJob,
}
struct WorkspaceSources {
    entry: PathBuf,
    options: crate::SemanticDiscoveryOptions,
    provider: SourceOverlay,
    virtual_paths: Vec<PathBuf>,
}
enum ActiveSourceJob {
    Discovery {
        job: crate::PreparedGraphJob,
        virtual_paths: Vec<PathBuf>,
    },
    Binding(crate::PreparedWorkspaceJob),
}
impl ActiveSourceJob {
    #[cfg(test)]
    fn suspended_origins(&self) -> Vec<SourceOrigin> {
        match self {
            Self::Discovery { job, .. } => job.suspended_origins(),
            Self::Binding(job) => job.suspended_origins(),
        }
    }
    fn cancel(&mut self) -> Result<(), jai_vm::Error> {
        match self {
            Self::Discovery { job, .. } => job.cancel(),
            Self::Binding(job) => job.cancel(),
        }
    }
    fn service_pending(
        &mut self,
        scheduler: &mut WorkspaceScheduler,
    ) -> Result<bool, SchedulerError> {
        match self {
            Self::Discovery { job, .. } => job.service_pending(scheduler),
            Self::Binding(job) => job.service_pending(scheduler),
        }
    }
}
#[derive(Clone, PartialEq, Eq)]
struct Snapshot {
    id: WorkspaceId,
    name: String,
    inputs: Vec<BuildInput>,
    settings: BuildSettings,
}
fn snapshots(session: &CompilerSession) -> Vec<Snapshot> {
    session
        .workspaces()
        .map(|workspace| Snapshot {
            id: workspace.id(),
            name: workspace.name().into(),
            inputs: workspace.inputs().into(),
            settings: workspace.settings().clone(),
        })
        .collect()
}
fn io(path: &Path, cause: std::io::Error) -> SchedulerError {
    Error::Io {
        path: path.into(),
        cause,
    }
    .into()
}

impl WorkspaceScheduler {
    pub fn new(
        root: &Path,
        graph_options: GraphOptions,
        options: SchedulerOptions,
    ) -> Result<Self, SchedulerError> {
        Self::new_with_bootstrap(root, graph_options, BootstrapOptions::disabled(), options)
    }
    pub fn new_with_bootstrap(
        root: &Path,
        graph_options: GraphOptions,
        bootstrap: BootstrapOptions,
        options: SchedulerOptions,
    ) -> Result<Self, SchedulerError> {
        let root = fs::canonicalize(root).map_err(|cause| io(root, cause))?;
        let bytes = fs::read(&root).map_err(|cause| io(&root, cause))?;
        let root_text = jai_lexer::decode_source(&bytes)
            .map_err(|diagnostic| Error::Decode {
                path: root.clone(),
                diagnostic,
            })?
            .into_owned();
        let replay = EffectReplayCache::new(options.replay_limits);
        Ok(Self {
            root: root.clone(),
            root_text,
            graph_options,
            bootstrap,
            options,
            physical: HashMap::from([(root, bytes)]),
            replay,
            session: None,
            build: None,
        })
    }
    pub fn replay_cache(&self) -> &EffectReplayCache {
        &self.replay
    }
    pub fn resolve(
        &mut self,
        session: &mut CompilerSession,
    ) -> Result<ScheduledBuild, SchedulerError> {
        match self.resolve_resumable(session)? {
            SchedulerReadiness::Complete(build) => Ok(build),
            SchedulerReadiness::Pending(pending) => Err(SchedulerError::Pending(Box::new(pending))),
        }
    }

    /// Retains a genuinely suspended source job for the next readiness drive.
    pub fn resolve_resumable(
        &mut self,
        session: &mut CompilerSession,
    ) -> Result<SchedulerReadiness, SchedulerError> {
        if self.session.is_some_and(|id| id != session.root()) {
            return Err(SchedulerError::DifferentSession);
        }
        self.session = Some(session.root());
        let mut state = self.build.take().unwrap_or_else(|| BuildState {
            pass: 1,
            before: snapshots(session),
            next: 0,
            results: BTreeMap::new(),
            failure: None,
            active: None,
        });
        let mut replay = std::mem::take(&mut self.replay);
        let result = self.drive_build(session, &mut replay, &mut state);
        self.replay = replay;
        if matches!(&result, Ok(SchedulerReadiness::Pending(_))) {
            self.build = Some(state);
        }
        result
    }

    pub fn cancel_pending(&mut self) -> Result<(), jai_vm::Error> {
        if let Some(mut state) = self.build.take()
            && let Some(active) = &mut state.active
        {
            active.job.cancel()?;
        }
        Ok(())
    }

    fn drive_build(
        &mut self,
        session: &mut CompilerSession,
        replay: &mut EffectReplayCache,
        state: &mut BuildState,
    ) -> Result<SchedulerReadiness, SchedulerError> {
        loop {
            if state.pass > self.options.limits.passes {
                return Err(SchedulerError::Limit("passes"));
            }
            self.check_physical()?;
            self.check_limits(&state.before)?;
            while state.next < state.before.len() || state.active.is_some() {
                let mut active = if let Some(active) = state.active.take() {
                    if session.committed_revision() != active.revision {
                        return Err(SchedulerError::ChangedPendingSession);
                    }
                    active
                } else {
                    let workspace = state.before[state.next].clone();
                    state.next += 1;
                    if session.workspace(workspace.id).is_none() {
                        continue;
                    }
                    if workspace.id != session.root() && workspace.inputs.is_empty() {
                        state.results.insert(
                            workspace.id.get(),
                            ScheduledWorkspace {
                                id: workspace.id,
                                name: workspace.name,
                                output: WorkspaceOutput::AwaitingInputs,
                            },
                        );
                        continue;
                    }
                    let WorkspaceSources {
                        entry,
                        options,
                        provider,
                        virtual_paths,
                    } = self.source_snapshot(&workspace, session)?;
                    ActiveWorkspaceJob {
                        workspace,
                        revision: session.committed_revision(),
                        job: ActiveSourceJob::Discovery {
                            job: crate::PreparedGraphJob::new(
                                entry,
                                options,
                                provider,
                                session.clone(),
                                replay.fork_committed(),
                            ),
                            virtual_paths,
                        },
                    }
                };
                loop {
                    if let ActiveSourceJob::Discovery { job, virtual_paths } = &mut active.job {
                        match job.poll()? {
                            crate::GraphJobProgress::Pending(source) => {
                                if active.job.service_pending(self)? {
                                    continue;
                                }
                                let pending = SchedulerPending {
                                    workspace: active.workspace.id,
                                    source,
                                };
                                state.active = Some(active);
                                return Ok(SchedulerReadiness::Pending(pending));
                            }
                            crate::GraphJobProgress::Failed(error) => {
                                if let Some((compiler, traces)) = job.take_terminal_journals() {
                                    *session = compiler;
                                    *replay = traces;
                                }
                                state.failure.get_or_insert(error);
                                break;
                            }
                            crate::GraphJobProgress::Complete(result) => {
                                let crate::GraphJobResult {
                                    unit,
                                    compiler,
                                    replay: traces,
                                } = *result;
                                self.retain_physical(unit.graph(), virtual_paths)?;
                                let options = jai_sema::ResolveOptions {
                                    target: Some(self.options.target.clone()),
                                    compile_time_limits: self.options.compile_time_limits,
                                    compiler: Some(jai_sema::CompilerBindingContext::from_graph(
                                        unit.graph(),
                                        &self.graph_options.import_dirs,
                                        active.workspace.id,
                                    )),
                                    ..Default::default()
                                };
                                active.job =
                                    ActiveSourceJob::Binding(crate::PreparedWorkspaceJob::new(
                                        unit, options, compiler, traces,
                                    ));
                                continue;
                            }
                        }
                    }
                    let ActiveSourceJob::Binding(job) = &mut active.job else {
                        unreachable!()
                    };
                    match job.poll()? {
                        crate::WorkspaceJobProgress::Pending(source) => {
                            if active.job.service_pending(self)? {
                                continue;
                            }
                            let pending = SchedulerPending {
                                workspace: active.workspace.id,
                                source,
                            };
                            state.active = Some(active);
                            return Ok(SchedulerReadiness::Pending(pending));
                        }
                        crate::WorkspaceJobProgress::Failed(error) => {
                            // Completed source runs validated their publication;
                            // their input delta can produce the next graph round.
                            if let Some((compiler, traces)) = job.take_terminal_journals() {
                                *session = compiler;
                                *replay = traces;
                            }
                            state.failure.get_or_insert(error);
                            break;
                        }
                        crate::WorkspaceJobProgress::Complete(result) => {
                            let crate::WorkspaceJobResult {
                                unit,
                                library,
                                compiler,
                                replay: traces,
                            } = *result;
                            let workspace = active.workspace;
                            drop(active.job);
                            let unit = std::sync::Arc::try_unwrap(unit).map_err(|_| {
                                jai_vm::Error::InvalidIr(
                                    "completed workspace source still has an active owner",
                                )
                            })?;
                            *session = compiler;
                            *replay = traces;
                            state.results.insert(
                                workspace.id.get(),
                                ScheduledWorkspace {
                                    id: workspace.id,
                                    name: workspace.name,
                                    output: WorkspaceOutput::Checked {
                                        unit: Box::new(unit),
                                        library,
                                        settings: workspace.settings,
                                    },
                                },
                            );
                            break;
                        }
                    }
                }
            }
            self.check_physical()?;
            let after = snapshots(session);
            self.check_limits(&after)?;
            if state.before == after {
                if let Some(error) = session.error() {
                    return Err(Error::CompilerReport(error.clone()).into());
                }
                if let Some(error) = state.failure.take() {
                    return Err(error.into());
                }
                return Ok(SchedulerReadiness::Complete(ScheduledBuild {
                    root: session.root(),
                    workspaces: std::mem::take(&mut state.results).into_values().collect(),
                    passes: state.pass,
                }));
            }
            state.pass += 1;
            state.before = after;
            state.next = 0;
            state.results.clear();
            state.failure = None;
        }
    }
    /// Advance subscribed child work in this source job's private preview.
    /// Native outputs remain pending until their actual backend job completes.
    pub fn service_suspended(
        &mut self,
        session: &mut CompilerSession,
        origin: &SourceOrigin,
    ) -> Result<bool, SchedulerError> {
        let mut replay = std::mem::take(&mut self.replay);
        let result = self.advance_suspended(session, &mut replay, origin);
        self.replay = replay;
        result
    }
    pub(crate) fn advance_suspended(
        &mut self,
        session: &mut CompilerSession,
        replay: &mut EffectReplayCache,
        origin: &SourceOrigin,
    ) -> Result<bool, SchedulerError> {
        if self.session.is_some_and(|id| id != session.root()) {
            return Err(SchedulerError::DifferentSession);
        }
        self.session = Some(session.root());
        self.check_physical()?;
        let receivers = replay.suspended_workspaces(origin);
        let mut preview = replay.preview_suspended(origin, session)?;
        let mut branch = replay.fork_suspended_replay(origin)?;
        let mut events = vec![];
        for pass in 1..=self.options.limits.passes {
            let before = snapshots(&preview);
            self.check_limits(&before)?;
            events.clear();
            let mut failure = None;
            for id in &receivers {
                // A parent's suspended body can only resume its own VM. It is
                // never restarted as a workspace job in its private preview.
                if *id == origin.workspace {
                    continue;
                }
                let workspace = before
                    .iter()
                    .find(|workspace| workspace.id == *id)
                    .filter(|_| preview.workspace(*id).is_some());
                let Some(workspace) = workspace else {
                    if preview.is_destroyed(*id) {
                        events.push(CompilerEvent::Complete {
                            workspace: *id,
                            error: jai_vm::CompilerCompletion::CompilerShutdown,
                        });
                    }
                    continue;
                };
                if *id != preview.root() && workspace.inputs.is_empty() {
                    continue;
                }
                let unit = match self.load(workspace, &mut preview, &mut branch) {
                    Ok(unit) => unit,
                    Err(SchedulerError::Driver(error)) => {
                        failure.get_or_insert(error);
                        continue;
                    }
                    Err(error) => return Err(error),
                };
                let options = jai_sema::ResolveOptions {
                    target: Some(self.options.target.clone()),
                    compile_time_limits: self.options.compile_time_limits,
                    compiler: Some(jai_sema::CompilerBindingContext::from_graph(
                        unit.graph(),
                        &self.graph_options.import_dirs,
                        workspace.id,
                    )),
                    ..Default::default()
                };
                let resolved = {
                    let mut effects = SchedulingEffects {
                        scheduler: self,
                        effects: ReplayEffects::new(&mut preview, &mut branch),
                    };
                    jai_sema::resolve_library_with_options(unit.graph(), &options, &mut effects)
                };
                if let Err(diagnostic) = resolved {
                    failure.get_or_insert_with(|| unit.located(diagnostic));
                    continue;
                }
                // Retirement during a child recipe cancels this actual job.
                if preview.is_destroyed(*id) {
                    events.push(CompilerEvent::Complete {
                        workspace: *id,
                        error: jai_vm::CompilerCompletion::CompilerShutdown,
                    });
                } else {
                    events.push(CompilerEvent::Phase {
                        workspace: *id,
                        phase: CompilerPhase::SourceParsed,
                    });
                    events.push(CompilerEvent::Phase {
                        workspace: *id,
                        phase: CompilerPhase::Typechecked { pending_count: 0 },
                    });
                    let completed = preview.workspace(*id).expect("surviving child");
                    if completed.status() == jai_vm::WorkspaceStatus::Failed {
                        events.push(CompilerEvent::Complete {
                            workspace: *id,
                            error: jai_vm::CompilerCompletion::CompilationFailed,
                        });
                    } else if completed.settings().output_kind == jai_types::BuildOutputKind::None {
                        // An explicit NO_OUTPUT recipe has no backend/write
                        // job. This event is published only at the stable
                        // source-and-compile-time fixed point below.
                        events.push(CompilerEvent::Complete {
                            workspace: *id,
                            error: jai_vm::CompilerCompletion::None,
                        });
                    }
                }
            }
            self.check_physical()?;
            let after = snapshots(&preview);
            self.check_limits(&after)?;
            if before == after {
                if let Some(error) = failure {
                    return Err(error.into());
                }
                replay.prepare_suspended_preview_with_replay(origin, preview, branch)?;
                let mut ready = false;
                for event in events {
                    ready |= replay.publish_suspended_event(origin, event)?;
                }
                return Ok(ready);
            }
            if pass == self.options.limits.passes {
                return Err(SchedulerError::Limit("passes"));
            }
        }
        Err(SchedulerError::Limit("passes"))
    }
    fn check_limits(&self, workspaces: &[Snapshot]) -> Result<(), SchedulerError> {
        if workspaces.len() > self.options.limits.workspaces {
            return Err(SchedulerError::Limit("workspaces"));
        }
        let inputs = workspaces.iter().try_fold(0usize, |count, workspace| {
            count.checked_add(workspace.inputs.len())
        });
        if inputs.is_none_or(|count| count > self.options.limits.inputs) {
            return Err(SchedulerError::Limit("inputs"));
        }
        let bytes = workspaces
            .iter()
            .flat_map(|workspace| &workspace.inputs)
            .try_fold(0usize, |count, input| {
                count.checked_add(match input {
                    BuildInput::Source(source) | BuildInput::SourceAt { source, .. } => {
                        source.len()
                    }
                    _ => 0,
                })
            });
        if bytes.is_none_or(|count| count > self.options.limits.generated_bytes) {
            return Err(SchedulerError::Limit("generated bytes"));
        }
        for workspace in workspaces {
            if let Some(requested) = &workspace.settings.target
                && requested != &self.options.target_triple
            {
                return Err(SchedulerError::UnsupportedTarget {
                    workspace: workspace.id,
                    requested: requested.clone(),
                    selected: self.options.target_triple.clone(),
                });
            }
        }
        Ok(())
    }
    fn check_physical(&self) -> Result<(), SchedulerError> {
        for (path, expected) in &self.physical {
            let actual = fs::read(path).map_err(|cause| io(path, cause))?;
            if actual != *expected {
                return Err(SchedulerError::PhysicalSourceChanged(path.clone()));
            }
        }
        Ok(())
    }
    fn source_snapshot(
        &self,
        workspace: &Snapshot,
        session: &CompilerSession,
    ) -> Result<WorkspaceSources, SchedulerError> {
        let root = session.root();
        let base = self
            .root
            .parent()
            .expect("canonical source has a parent")
            .to_owned();
        let mut overlay = SourceOverlay::new();
        let mut virtual_paths = vec![];
        let entry = if workspace.id == root {
            self.root.clone()
        } else {
            base.join(format!(
                ".jai-workspace-{}-{}.jai",
                root.get(),
                workspace.id.get()
            ))
        };
        if workspace.id != root {
            self.check_virtual(&entry)?;
        }
        let mut source = if workspace.id == root {
            self.root_text.clone()
        } else {
            String::new()
        };
        // A trailing line comment in the physical source must not swallow loads.
        source.push('\n');
        for (index, input) in workspace.inputs.iter().enumerate() {
            let path = match input {
                BuildInput::Source(text) | BuildInput::SourceAt { source: text, .. } => {
                    let path = base.join(format!(
                        ".jai-generated-{}-{}-{index}.jai",
                        root.get(),
                        workspace.id.get()
                    ));
                    self.check_virtual(&path)?;
                    let path = overlay
                        .insert(&path, text.as_bytes().into())
                        .map_err(|cause| io(&path, cause))?;
                    virtual_paths.push(path.clone());
                    path
                }
                BuildInput::File(path) => {
                    if path.is_absolute() {
                        path.clone()
                    } else {
                        base.join(path)
                    }
                }
                BuildInput::FileAt { path, location } => {
                    if path.is_absolute() {
                        path.clone()
                    } else {
                        let origin = if location.path.is_absolute() {
                            location.path.clone()
                        } else {
                            base.join(&location.path)
                        };
                        origin.parent().unwrap_or(&base).join(path)
                    }
                }
            };
            append_load(&mut source, &path)?;
        }
        let entry = overlay
            .insert(&entry, source.into_bytes())
            .map_err(|cause| io(&entry, cause))?;
        virtual_paths.push(entry.clone());
        let mut bootstrap = self.bootstrap.clone();
        if let Some(runtime) = &mut bootstrap.runtime_support {
            runtime.parameters = workspace.settings.runtime_support_parameters();
        }
        let discovery_options = crate::SemanticDiscoveryOptions {
            graph: self.graph_options.clone(),
            bootstrap,
            target: self.options.target.clone(),
            workspace: workspace.id,
            limits: self.options.compile_time_limits,
            effect_policy: crate::DiscoveryEffectPolicy::CompilerSession,
        };
        Ok(WorkspaceSources {
            entry,
            options: discovery_options,
            provider: overlay,
            virtual_paths,
        })
    }
    fn load(
        &mut self,
        workspace: &Snapshot,
        session: &mut CompilerSession,
        replay: &mut EffectReplayCache,
    ) -> Result<CompilationUnit, SchedulerError> {
        let WorkspaceSources {
            entry,
            options,
            provider,
            virtual_paths,
        } = self.source_snapshot(workspace, session)?;
        let graph = {
            let mut effects = SchedulingEffects {
                scheduler: self,
                effects: ReplayEffects::new(session, replay),
            };
            crate::source_discovery::discover_graph_with_effects(
                &entry,
                options,
                &provider,
                &mut effects,
            )
        }?;
        self.retain_physical(&graph, &virtual_paths)?;
        Ok(CompilationUnit {
            graph,
            options: self.graph_options.clone(),
        })
    }
    fn retain_physical(
        &mut self,
        graph: &jai_modules::ModuleGraph,
        virtual_paths: &[PathBuf],
    ) -> Result<(), SchedulerError> {
        for record in graph.sources().records() {
            if virtual_paths.contains(&record.path().to_owned()) {
                continue;
            }
            let path = record.path();
            let bytes = fs::read(path).map_err(|cause| io(path, cause))?;
            let text = jai_lexer::decode_source(&bytes).map_err(|diagnostic| Error::Decode {
                path: path.into(),
                diagnostic,
            })?;
            if text.as_ref() != record.text()
                || self.physical.get(path).is_some_and(|old| *old != bytes)
            {
                return Err(SchedulerError::PhysicalSourceChanged(path.into()));
            }
            self.physical.entry(path.into()).or_insert(bytes);
        }
        Ok(())
    }
    fn check_virtual(&self, path: &Path) -> Result<(), SchedulerError> {
        if path.try_exists().map_err(|cause| io(path, cause))? {
            Err(SchedulerError::VirtualPathCollision(path.into()))
        } else {
            Ok(())
        }
    }
}
struct SchedulingEffects<'a> {
    scheduler: &'a mut WorkspaceScheduler,
    effects: ReplayEffects<'a>,
}
impl CompilerEffects for SchedulingEffects<'_> {
    fn set_source_origin(&mut self, origin: SourceOrigin) {
        self.effects.set_source_origin(origin);
    }
    fn begin(&mut self) {
        self.effects.begin();
    }
    fn suspend(&mut self) -> Result<(), jai_vm::Error> {
        self.effects.suspend()
    }
    fn resume(&mut self) -> Result<(), jai_vm::Error> {
        self.effects.resume()
    }
    fn service_pending(
        &mut self,
        dependencies: &[jai_vm::Dependency],
    ) -> Result<bool, jai_vm::Error> {
        if !dependencies
            .iter()
            .any(|dependency| matches!(dependency, jai_vm::Dependency::Effect(_)))
        {
            return Ok(false);
        }
        let scheduler = &mut self.scheduler;
        self.effects.service_suspended(|session, replay, origin| {
            scheduler
                .advance_suspended(session, replay, origin)
                .map_err(|error| jai_vm::Error::EffectRejected(error.to_string()))
        })
    }
    fn poll_request(
        &mut self,
        request: &jai_vm::CompilerRequest,
        key: jai_vm::EffectKey,
    ) -> jai_vm::EffectOutcome {
        self.effects.poll_request(request, key)
    }
    fn request(&mut self, request: jai_vm::CompilerRequest) -> jai_vm::EffectOutcome {
        self.effects.request(request)
    }
    fn finish(&mut self, commit: bool) -> Result<(), jai_vm::Error> {
        self.effects.finish(commit)
    }
}
fn append_load(source: &mut String, path: &Path) -> Result<(), SchedulerError> {
    let path = path
        .to_str()
        .ok_or_else(|| SchedulerError::NonUtf8Path(path.into()))?;
    source.push_str("#load \"");
    for character in path.chars() {
        match character {
            '\\' => source.push_str("\\\\"),
            '"' => source.push_str("\\\""),
            '\n' => source.push_str("\\n"),
            '\r' => source.push_str("\\r"),
            '\t' => source.push_str("\\t"),
            other => source.push(other),
        }
    }
    source.push_str("\";\n");
    Ok(())
}

#[cfg(test)]
mod tests;

#[cfg(test)]
#[path = "workspace_scheduler/continuation_tests.rs"]
mod continuation_tests;
