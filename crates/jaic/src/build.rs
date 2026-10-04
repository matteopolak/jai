//! Workspaces: the compiler side of the `Compiler` module.
//!
//! A metaprogram creates workspaces, adds files and strings to them, sets
//! their build options and (optionally) intercepts their compiler messages.
//! Each workspace is compiled by a separate [`Compiler`] sharing the file
//! system; its output (executable, library, object) is written by the
//! embedder's [`OutputBackend`] (LLVM in `jaic-cli`, none in the browser).
//!
//! Jai code reaches this module only through a few `#compiler` primitives
//! (`__jaic_*`, see [`MetaOp`]) with a scalar/string ABI; the public
//! `Compiler` module API (Build_Options, Message structs...) is written in Jai
//! on top of them in `stdlib/Compiler/module.jai`.
use crate::interp::{Host, Interp, Trap};
use crate::ir;
use crate::sema::{Compiler, FileSystem, Options, ProgramSource, TargetCpu, TargetOs};
use std::cell::RefCell;
use std::collections::VecDeque;
use std::path::PathBuf;
use std::rc::Rc;

/// What a workspace produces.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum OutputType {
    Executable,
    DynamicLibrary,
    StaticLibrary,
    ObjectFile,
    NoOutput,
}

impl OutputType {
    fn parse(s: &str) -> Option<Self> {
        Some(match s {
            "EXECUTABLE" => Self::Executable,
            "DYNAMIC_LIBRARY" => Self::DynamicLibrary,
            "STATIC_LIBRARY" => Self::StaticLibrary,
            "OBJECT_FILE" => Self::ObjectFile,
            "NO_OUTPUT" => Self::NoOutput,
            _ => return None,
        })
    }
}

/// Build settings of one workspace, as far as jaic uses them.
#[derive(Clone, Debug)]
pub struct BuildSettings {
    pub output_type: OutputType,
    /// `do_output = false` (from `set_build_options_dc`) suppresses output.
    pub do_output: bool,
    pub output_executable_name: String,
    pub output_path: String,
    /// `None`: the embedder's default import path.
    pub import_paths: Option<Vec<PathBuf>>,
    pub os: Option<TargetOs>,
    pub cpu: Option<TargetCpu>,
    /// `DEBUG`, `VERY_DEBUG`, `OPTIMIZED`, `VERY_OPTIMIZED`... as sent by the module.
    pub optimization: String,
    pub additional_linker_arguments: Vec<String>,
    pub temporary_storage_size: Option<i64>,
}

impl Default for BuildSettings {
    fn default() -> Self {
        Self {
            output_type: OutputType::Executable,
            do_output: true,
            output_executable_name: String::new(),
            output_path: String::new(),
            import_paths: None,
            os: None,
            cpu: None,
            optimization: String::new(),
            additional_linker_arguments: Vec::new(),
            temporary_storage_size: None,
        }
    }
}

/// Writes a compiled workspace's output. Returns the files written.
pub trait OutputBackend {
    fn write_output(
        &mut self,
        program: &ir::Program,
        settings: &BuildSettings,
        output: &std::path::Path,
    ) -> Result<(), String>;
}

/// Everything needed to compile a workspace besides its sources.
pub struct BuildEnv {
    pub fs: Rc<dyn FileSystem>,
    /// Base options (import path, preload, target) for new workspaces.
    pub options: Options,
    pub backend: Option<Box<dyn OutputBackend>>,
    /// Arguments after `-` on the command line (`compile_time_command_line`).
    pub command_line: Vec<String>,
    /// Host for the compile-time interpreter of each workspace.
    pub make_host: Box<dyn Fn() -> Box<dyn Host>>,
    /// Where diagnostics of workspace compilations go.
    pub report: Box<dyn FnMut(&str)>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
enum Stage {
    /// Collecting files/strings/options.
    Open,
    /// Compiled; events left to deliver.
    Delivering,
    Finished,
}

struct Workspace {
    name: String,
    sources: Vec<ProgramSource>,
    settings: BuildSettings,
    intercepted: bool,
    stage: Stage,
    events: VecDeque<Event>,
    failed: bool,
}

/// One compiler message, in primitive form.
#[derive(Clone, Debug, Default)]
pub struct Event {
    pub kind: i64,
    pub ints: Vec<i64>,
    pub strings: Vec<Vec<u8>>,
}

pub const EVENT_FILE: i64 = 1;
pub const EVENT_PHASE: i64 = 2;
pub const EVENT_COMPLETE: i64 = 3;

const PHASE_ALL_SOURCE_CODE_PARSED: i64 = 0;
const PHASE_TYPECHECKED_ALL_WE_CAN: i64 = 1;
const PHASE_ALL_TARGET_CODE_BUILT: i64 = 2;
const PHASE_PRE_WRITE_EXECUTABLE: i64 = 3;
const PHASE_POST_WRITE_EXECUTABLE: i64 = 4;

/// The workspace registry of one top-level compilation.
pub struct Workspaces {
    env: BuildEnv,
    /// Index = workspace id; 0 is unused, 1 is the top-level program.
    list: Vec<Workspace>,
    /// Workspace whose compile-time code is running.
    current: Vec<i64>,
    event: Event,
    /// Strings handed to Jai code; kept alive for the whole compilation.
    strings: Vec<Box<[u8]>>,
}

pub type SharedWorkspaces = Rc<RefCell<Workspaces>>;

/// The `#compiler` primitives, bound by name in `stdlib/Compiler`.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum MetaOp {
    WorkspaceCreate,
    CurrentWorkspace,
    AddFile,
    AddString,
    SetOption,
    BeginIntercept,
    NextEvent,
    EventInt,
    EventString,
    CommandLineCount,
    CommandLineArg,
    Report,
    CompilerVersion,
    CustomLinkComplete,
}

impl MetaOp {
    pub fn from_name(name: &str) -> Option<Self> {
        Some(match name {
            "__jaic_workspace_create" => Self::WorkspaceCreate,
            "__jaic_current_workspace" => Self::CurrentWorkspace,
            "__jaic_workspace_add_file" => Self::AddFile,
            "__jaic_workspace_add_string" => Self::AddString,
            "__jaic_workspace_set_option" => Self::SetOption,
            "__jaic_workspace_begin_intercept" => Self::BeginIntercept,
            "__jaic_workspace_next_event" => Self::NextEvent,
            "__jaic_event_int" => Self::EventInt,
            "__jaic_event_string" => Self::EventString,
            "__jaic_command_line_count" => Self::CommandLineCount,
            "__jaic_command_line_arg" => Self::CommandLineArg,
            "__jaic_report" => Self::Report,
            "__jaic_compiler_version" => Self::CompilerVersion,
            "__jaic_custom_link_complete" => Self::CustomLinkComplete,
            _ => return None,
        })
    }
}

pub const COMPILER_VERSION: &str = "beta 0.2.025, jaic";

impl Workspaces {
    /// A registry whose workspace 1 is the top-level program.
    pub fn new(env: BuildEnv) -> SharedWorkspaces {
        let blank = || Workspace {
            name: String::new(),
            sources: Vec::new(),
            settings: BuildSettings::default(),
            intercepted: false,
            stage: Stage::Open,
            events: VecDeque::new(),
            failed: false,
        };
        let mut top = blank();
        top.name = "Main Workspace".into();
        Rc::new(RefCell::new(Workspaces {
            env,
            list: vec![blank(), top],
            current: vec![1],
            event: Event::default(),
            strings: Vec::new(),
        }))
    }

    /// Settings of the top-level program (workspace 1).
    pub fn top_level_settings(&self) -> BuildSettings {
        self.list[1].settings.clone()
    }

    /// Whether any workspace compilation failed.
    pub fn any_failed(&self) -> bool {
        self.list.iter().any(|w| w.failed)
    }

    fn ws(&mut self, id: i64) -> Result<&mut Workspace, String> {
        let id = if id == 0 {
            self.current_id()
        } else {
            id
        };
        self.list
            .get_mut(id as usize)
            .filter(|_| id > 0)
            .ok_or_else(|| format!("invalid workspace {id}"))
    }

    fn current_id(&self) -> i64 {
        *self.current.last().unwrap_or(&1)
    }

    fn set_option(&mut self, id: i64, key: &str, value: &str) -> Result<(), String> {
        let s = &mut self.ws(id)?.settings;
        let flag = || value == "true";
        match key {
            "output_executable_name" => s.output_executable_name = value.into(),
            "output_path" => s.output_path = value.into(),
            "output_type" => {
                s.output_type = OutputType::parse(value)
                    .ok_or_else(|| format!("unknown output_type '{value}'"))?
            }
            "do_output" => s.do_output = flag(),
            "import_path_clear" => s.import_paths = Some(Vec::new()),
            "import_path" => s
                .import_paths
                .get_or_insert_with(Vec::new)
                .push(PathBuf::from(value)),
            "os_target" => {
                s.os = Some(match value {
                    "WINDOWS" => TargetOs::Windows,
                    "LINUX" => TargetOs::Linux,
                    "MACOS" => TargetOs::MacOS,
                    "WASM" => TargetOs::Wasm,
                    _ => return Ok(()), // Targets jaic cannot build for keep the default.
                })
            }
            "cpu_target" => {
                s.cpu = Some(match value {
                    "X64" => TargetCpu::X64,
                    "ARM64" => TargetCpu::Arm64,
                    "WASM" => TargetCpu::Wasm,
                    _ => return Ok(()),
                })
            }
            "optimization" => s.optimization = value.into(),
            "additional_linker_arguments_clear" => s.additional_linker_arguments.clear(),
            "additional_linker_argument" => s.additional_linker_arguments.push(value.into()),
            "temporary_storage_size" => s.temporary_storage_size = value.parse().ok(),
            // Accepted and ignored: checks, stack traces, added-string dumps...
            _ => {}
        }
        Ok(())
    }

    fn keep_string(&mut self, bytes: &[u8]) -> (u64, u64) {
        let boxed: Box<[u8]> = bytes.into();
        let ptr = boxed.as_ptr() as u64;
        self.strings.push(boxed);
        (bytes.len() as u64, ptr)
    }
}

/// Compile workspace `id` if it has not been, queueing its messages.
fn ensure_compiled(shared: &SharedWorkspaces, id: i64) -> Result<(), String> {
    let (sources, settings, mut options, fs, host) = {
        let mut reg = shared.borrow_mut();
        let ws = reg.ws(id)?;
        if ws.stage != Stage::Open {
            return Ok(());
        }
        ws.stage = Stage::Delivering;
        let (sources, settings) = (ws.sources.clone(), ws.settings.clone());
        let options = reg.env.options.clone();
        (
            sources,
            settings,
            options,
            reg.env.fs.clone(),
            (reg.env.make_host)(),
        )
    };
    if let Some(paths) = &settings.import_paths {
        // The module search path the metaprogram set, then the defaults (stdlib).
        let defaults = std::mem::take(&mut options.import_paths);
        options.import_paths = paths.clone();
        for d in defaults {
            if !options.import_paths.contains(&d) {
                options.import_paths.push(d);
            }
        }
    }
    if let Some(os) = settings.os {
        options.os = os;
    }
    if let Some(cpu) = settings.cpu {
        options.cpu = cpu;
    }
    if let Some(size) = settings.temporary_storage_size {
        options.temporary_storage_size = size;
    }
    let mut compiler = Compiler::new(options, fs);
    compiler.interp.host = host;
    compiler.attach_workspaces(shared.clone());
    shared.borrow_mut().current.push(id);
    let result = compiler.compile_sources(&sources);
    shared.borrow_mut().current.pop();

    let mut events = VecDeque::new();
    for file in &compiler.files {
        events.push_back(Event {
            kind: EVENT_FILE,
            ints: Vec::new(),
            strings: vec![file.path.display().to_string().into_bytes()],
        });
    }
    let phase = |p: i64| Event {
        kind: EVENT_PHASE,
        ints: vec![p, 0],
        strings: Vec::new(),
    };
    let mut failed = false;
    match result {
        Err(d) => {
            let text = compiler.render(&d);
            (shared.borrow_mut().env.report)(&text);
            failed = true;
        }
        Ok(()) => {
            events.push_back(phase(PHASE_ALL_SOURCE_CODE_PARSED));
            events.push_back(phase(PHASE_TYPECHECKED_ALL_WE_CAN));
            events.push_back(phase(PHASE_ALL_TARGET_CODE_BUILT));
            if settings.do_output && settings.output_type != OutputType::NoOutput {
                let output = output_path(&settings, &sources);
                let name = output.display().to_string().into_bytes();
                events.push_back(Event {
                    kind: EVENT_PHASE,
                    ints: vec![PHASE_PRE_WRITE_EXECUTABLE, 0],
                    strings: vec![name.clone()],
                });
                let written = {
                    let mut reg = shared.borrow_mut();
                    match reg.env.backend.as_mut() {
                        Some(backend) => {
                            backend.write_output(&compiler.program, &settings, &output)
                        }
                        None => Ok(()), // No backend (browser): checking only.
                    }
                };
                if let Err(message) = written {
                    (shared.borrow_mut().env.report)(&format!(
                        "error: writing {}: {message}",
                        output.display()
                    ));
                    failed = true;
                }
                events.push_back(Event {
                    kind: EVENT_PHASE,
                    ints: vec![PHASE_POST_WRITE_EXECUTABLE, 0],
                    strings: vec![name],
                });
            }
        }
    }
    events.push_back(Event {
        kind: EVENT_COMPLETE,
        ints: vec![failed as i64],
        strings: Vec::new(),
    });
    let mut reg = shared.borrow_mut();
    let ws = reg.ws(id)?;
    ws.events = events;
    ws.failed = failed;
    Ok(())
}

/// Where a workspace's output goes: `output_path/output_executable_name`
/// (default name: the first source file's stem).
fn output_path(settings: &BuildSettings, sources: &[ProgramSource]) -> PathBuf {
    let name = if settings.output_executable_name.is_empty() {
        sources
            .iter()
            .find_map(|s| match s {
                ProgramSource::File(p) => p.file_stem().map(|s| s.to_string_lossy().into_owned()),
                ProgramSource::String(_) => None,
            })
            .unwrap_or_else(|| "output".into())
    } else {
        settings.output_executable_name.clone()
    };
    PathBuf::from(&settings.output_path).join(name)
}

/// Compile every workspace created but never driven by a message loop
/// (Jai compiles them after the metaprogram's `#run` returns).
pub fn finish_all(shared: &SharedWorkspaces) -> Result<(), String> {
    let mut id = 2;
    loop {
        let count = shared.borrow().list.len() as i64;
        if id >= count {
            return Ok(());
        }
        ensure_compiled(shared, id)?;
        shared.borrow_mut().list[id as usize].stage = Stage::Finished;
        id += 1;
    }
}

/// Execute a primitive. `args` follow the IR calling convention: the context
/// pointer (when `has_context`), the parameters (memory types by address),
/// then result addresses for memory-typed results.
pub fn call(
    shared: &SharedWorkspaces,
    op: MetaOp,
    has_context: bool,
    args: &[u64],
    interp: &mut Interp,
) -> Result<Vec<u64>, Trap> {
    let args = if has_context {
        &args[1..]
    } else {
        args
    };
    let arg = |i: usize| args.get(i).copied().unwrap_or(0);
    let string = |interp: &Interp, i: usize| -> Vec<u8> {
        let p = arg(i);
        if p == 0 {
            return Vec::new();
        }
        let count = interp.read_u64(p) as usize;
        let data = interp.read_u64(p + 8);
        if count == 0 || data == 0 {
            Vec::new()
        } else {
            interp.read(data, count)
        }
    };
    let text = |interp: &Interp, i: usize| String::from_utf8_lossy(&string(interp, i)).into_owned();
    let trap = |message: String| Trap {
        message,
        loc: None,
    };
    let return_string = |interp: &mut Interp, bytes: &[u8], out_index: usize| {
        let (count, data) = shared.borrow_mut().keep_string(bytes);
        let out = arg(out_index);
        interp.write(out, &count.to_le_bytes());
        interp.write(out + 8, &data.to_le_bytes());
    };
    match op {
        MetaOp::WorkspaceCreate => {
            let name = text(interp, 0);
            let mut reg = shared.borrow_mut();
            let mut ws = Workspace {
                name,
                sources: Vec::new(),
                settings: BuildSettings::default(),
                intercepted: false,
                stage: Stage::Open,
                events: VecDeque::new(),
                failed: false,
            };
            ws.settings.import_paths = None;
            reg.list.push(ws);
            Ok(vec![reg.list.len() as u64 - 1])
        }
        MetaOp::CurrentWorkspace => Ok(vec![shared.borrow().current_id() as u64]),
        MetaOp::AddFile | MetaOp::AddString => {
            let id = arg(0) as i64;
            let value = text(interp, 1);
            let mut reg = shared.borrow_mut();
            let ws = reg.ws(id).map_err(trap)?;
            if ws.stage != Stage::Open {
                return Err(trap(format!(
                    "workspace '{}' was already compiled; add sources before reading its messages",
                    ws.name
                )));
            }
            ws.sources.push(if op == MetaOp::AddFile {
                ProgramSource::File(PathBuf::from(value))
            } else {
                ProgramSource::String(value)
            });
            Ok(Vec::new())
        }
        MetaOp::SetOption => {
            let (key, value) = (text(interp, 1), text(interp, 2));
            shared
                .borrow_mut()
                .set_option(arg(0) as i64, &key, &value)
                .map_err(trap)?;
            Ok(Vec::new())
        }
        MetaOp::BeginIntercept => {
            shared
                .borrow_mut()
                .ws(arg(0) as i64)
                .map_err(trap)?
                .intercepted = true;
            Ok(Vec::new())
        }
        MetaOp::NextEvent => {
            let id = arg(0) as i64;
            ensure_compiled(shared, id).map_err(trap)?;
            let mut reg = shared.borrow_mut();
            let ws = reg.ws(id).map_err(trap)?;
            match ws.events.pop_front() {
                Some(event) => {
                    let kind = event.kind;
                    if ws.events.is_empty() {
                        ws.stage = Stage::Finished;
                    }
                    reg.event = event;
                    Ok(vec![kind as u64])
                }
                None => {
                    ws.stage = Stage::Finished;
                    Ok(vec![0])
                }
            }
        }
        MetaOp::EventInt => {
            let reg = shared.borrow();
            Ok(vec![
                reg.event.ints.get(arg(0) as usize).copied().unwrap_or(0) as u64,
            ])
        }
        MetaOp::EventString => {
            let bytes = shared
                .borrow()
                .event
                .strings
                .get(arg(0) as usize)
                .cloned()
                .unwrap_or_default();
            return_string(interp, &bytes, 1);
            Ok(Vec::new())
        }
        MetaOp::CommandLineCount => Ok(vec![shared.borrow().env.command_line.len() as u64]),
        MetaOp::CommandLineArg => {
            let value = shared
                .borrow()
                .env
                .command_line
                .get(arg(0) as usize)
                .cloned()
                .unwrap_or_default();
            return_string(interp, value.as_bytes(), 1);
            Ok(Vec::new())
        }
        MetaOp::Report => {
            let (message, file) = (text(interp, 0), text(interp, 1));
            let (line, column, is_error) = (arg(2), arg(3), arg(4) & 1 != 0);
            let location = if file.is_empty() {
                String::new()
            } else {
                format!("{file}:{line}:{column}: ")
            };
            let severity = if is_error {
                "error"
            } else {
                "warning"
            };
            let rendered = format!("{location}{severity}: {}", message.trim_end());
            if is_error {
                return Err(trap(rendered));
            }
            (shared.borrow_mut().env.report)(&rendered);
            Ok(Vec::new())
        }
        MetaOp::CompilerVersion => {
            return_string(interp, COMPILER_VERSION.as_bytes(), 0);
            Ok(Vec::new())
        }
        MetaOp::CustomLinkComplete => Ok(Vec::new()),
    }
}
