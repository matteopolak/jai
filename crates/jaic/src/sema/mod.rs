//! Semantic analysis.
//!
//! Resolution is demand-driven: declarations are entered into scopes without
//! being checked, and each entity, struct layout, procedure signature and body
//! is resolved the first time something needs it (recursively, with cycle
//! detection). Conditional top-level code (`#if`, `#insert`) is kept as
//! *pending* scope items that are expanded before a lookup can fall through to
//! an outer scope, so names they declare are never missed.
//!
//! Expression checking lowers directly to IR (`ir::Builder`); constants fold
//! into `Operand::Const`. Compile-time evaluation (`#run`, constant aggregates,
//! global initializers) lowers a thunk procedure and runs it in `interp`.
pub mod value;

mod bake;
mod calls;
mod consteval;
mod convert;
mod decls;
mod driver;
mod expr;
mod lower;
mod modules;
mod procs;
mod scope;
mod stmt;
mod structs;
mod typeinfo;

use crate::ast;
use crate::intern::Sym;
use crate::ir;
use crate::source::{Diagnostic, FileId, SourceMap, Span};
use crate::types::{TypeId, Types};
pub use modules::{FileSystem, NativeFs, VirtualFs};
pub use scope::{EntityId, ScopeId};
use std::collections::HashMap;
use std::path::PathBuf;
use std::rc::Rc;
pub use value::{ModuleId, ProcId, Value};

pub type Result<T> = std::result::Result<T, Box<Diagnostic>>;

pub fn err<T>(span: Span, message: impl Into<String>) -> Result<T> {
    Err(Box::new(Diagnostic::error(span, message)))
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum TargetOs {
    Windows,
    Linux,
    MacOS,
    Wasm,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum TargetCpu {
    X64,
    Arm64,
    Wasm,
}

#[derive(Clone)]
pub struct Options {
    pub os: TargetOs,
    pub cpu: TargetCpu,
    /// Directories searched by `#import "Name"`, in order.
    pub import_paths: Vec<PathBuf>,
    /// Path of Preload.jai (loaded into every program).
    pub preload: Option<PathBuf>,
    /// Load Runtime_Support (entry point, context initialization) for programs.
    pub runtime_support: bool,
    pub temporary_storage_size: i64,
}

impl Options {
    pub fn host() -> Self {
        let os = if cfg!(target_os = "windows") {
            TargetOs::Windows
        } else if cfg!(target_os = "macos") {
            TargetOs::MacOS
        } else if cfg!(target_arch = "wasm32") {
            TargetOs::Wasm
        } else {
            TargetOs::Linux
        };
        let cpu = if cfg!(target_arch = "aarch64") {
            TargetCpu::Arm64
        } else if cfg!(target_arch = "wasm32") {
            TargetCpu::Wasm
        } else {
            TargetCpu::X64
        };
        Self {
            os,
            cpu,
            import_paths: Vec::new(),
            preload: None,
            runtime_support: true,
            temporary_storage_size: 32768,
        }
    }
}

/// A loaded source file and its scope.
pub struct FileInfo {
    pub id: FileId,
    pub path: PathBuf,
    pub module: ModuleId,
    pub scope: ScopeId,
}

pub struct Module {
    pub name: String,
    pub path: Option<PathBuf>,
    /// Names visible module-wide (`#scope_export` and `#scope_module`).
    pub scope: ScopeId,
    pub params: Vec<(Sym, Value)>,
    pub files: Vec<FileId>,
}

pub struct Compiler {
    pub options: Options,
    pub fs: Box<dyn FileSystem>,
    pub sources: SourceMap,
    pub types: Types,
    pub program: ir::Program,
    pub files: Vec<FileInfo>,
    file_by_path: HashMap<(PathBuf, ModuleId), usize>,
    pub modules: Vec<Module>,
    module_cache: HashMap<(PathBuf, Vec<(Sym, Value)>), ModuleId>,
    pub scopes: Vec<scope::Scope>,
    pub entities: Vec<scope::Entity>,
    pub procs: Vec<procs::ProcInfo>,
    pub poly_structs: Vec<structs::PolyStruct>,
    pub codes: Vec<Rc<ast::CodeBody>>,
    pub libraries: Vec<decls::LibraryInfo>,
    pub root_scope: ScopeId,
    pub preload: Option<ModuleId>,
    pub runtime_support: Option<ModuleId>,
    pub main_module: Option<ModuleId>,
    /// `#add_context` declarations with their declaring scope, in load order.
    pub add_contexts: Vec<(Rc<ast::Decl>, ScopeId)>,
    pub context_type: Option<TypeId>,
    pub top_level_runs: Vec<(ast::Expr, ScopeId)>,
    pub asserts: Vec<(ast::Expr, Option<ast::Expr>, ScopeId)>,
    /// Procedures that need their bodies lowered.
    pub body_queue: Vec<ProcId>,
    pub interp: crate::interp::Interp,
    /// Type_Info globals per type.
    pub type_infos: HashMap<TypeId, ir::GlobalId>,
    /// String literal globals, deduplicated.
    pub strings: HashMap<Rc<[u8]>, ir::GlobalId>,
    pub output: Vec<u8>,
    pub warnings: Vec<Diagnostic>,
    /// Struct declaration AST per struct (for layout).
    pub struct_asts: HashMap<crate::types::StructId, structs::StructSource>,
    pub entry_point: Option<ProcId>,
    pub exports: Vec<ProcId>,
    /// Procedure literals and anonymous types, per (AST node, scope).
    pub anonymous_procs: HashMap<(ast::AstId, ScopeId), ProcId>,
    pub anonymous_types: HashMap<(ast::AstId, ScopeId), TypeId>,
    /// Scope each `Code` value was written in (parallel to `codes`).
    pub code_scopes: Vec<ScopeId>,
    pub default_images: HashMap<TypeId, Option<Rc<value::Aggregate>>>,
    pub default_globals: HashMap<TypeId, ir::GlobalId>,
    pub initializers: HashMap<TypeId, ir::FuncId>,
    /// Interpreted function -> source procedure (reading back procedure values).
    pub func_procs: HashMap<ir::FuncId, ProcId>,
    pub thunk_scopes: HashMap<ScopeId, ScopeId>,
    /// Interpreter address of the compile-time `#Context`.
    pub ct_context: Option<u64>,
    /// Declarations of `#program_export` procedures (resolved by the driver).
    pub export_entities: Vec<EntityId>,
}

impl Compiler {
    pub fn new(options: Options, fs: Box<dyn FileSystem>) -> Self {
        let mut c = Compiler {
            options,
            fs,
            sources: SourceMap::default(),
            types: Types::new(),
            program: ir::Program::default(),
            files: Vec::new(),
            file_by_path: HashMap::new(),
            modules: Vec::new(),
            module_cache: HashMap::new(),
            scopes: Vec::new(),
            entities: Vec::new(),
            procs: Vec::new(),
            poly_structs: Vec::new(),
            codes: Vec::new(),
            libraries: Vec::new(),
            root_scope: ScopeId(0),
            preload: None,
            runtime_support: None,
            main_module: None,
            add_contexts: Vec::new(),
            context_type: None,
            top_level_runs: Vec::new(),
            asserts: Vec::new(),
            body_queue: Vec::new(),
            interp: crate::interp::Interp::default(),
            type_infos: HashMap::new(),
            strings: HashMap::new(),
            output: Vec::new(),
            warnings: Vec::new(),
            struct_asts: HashMap::new(),
            entry_point: None,
            exports: Vec::new(),
            anonymous_procs: HashMap::new(),
            anonymous_types: HashMap::new(),
            code_scopes: Vec::new(),
            default_images: HashMap::new(),
            default_globals: HashMap::new(),
            initializers: HashMap::new(),
            func_procs: HashMap::new(),
            thunk_scopes: HashMap::new(),
            ct_context: None,
            export_entities: Vec::new(),
        };
        c.root_scope = c.new_scope(scope::ScopeKind::Root, None, ModuleId(u32::MAX), None);
        c.declare_builtins();
        c
    }

    pub fn render(&self, d: &Diagnostic) -> String {
        d.render(&self.sources)
    }
}
