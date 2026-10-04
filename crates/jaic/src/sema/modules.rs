//! Source loading: files, `#load`, `#import`, module instances and the
//! declaration pass that enters top-level statements into scopes.
use super::scope::{EntityKind, ImportEntry, Pending, PendingState, ScopeKind};
use super::*;
use std::path::Path;

/// Source access. Native builds read the filesystem; the browser supplies a
/// virtual file system containing the workspace, prelude and stdlib.
pub trait FileSystem {
    fn read(&self, path: &Path) -> Option<Vec<u8>>;
    fn is_file(&self, path: &Path) -> bool;
    fn is_dir(&self, path: &Path) -> bool;
    fn canonical(&self, path: &Path) -> PathBuf {
        normalize(path)
    }
}

pub struct NativeFs;
impl FileSystem for NativeFs {
    fn read(&self, path: &Path) -> Option<Vec<u8>> {
        std::fs::read(path).ok()
    }
    fn is_file(&self, path: &Path) -> bool {
        path.is_file()
    }
    fn is_dir(&self, path: &Path) -> bool {
        path.is_dir()
    }
    fn canonical(&self, path: &Path) -> PathBuf {
        std::fs::canonicalize(path).unwrap_or_else(|_| normalize(path))
    }
}

#[derive(Default)]
pub struct VirtualFs {
    pub files: HashMap<PathBuf, Rc<[u8]>>,
}
impl VirtualFs {
    pub fn insert(&mut self, path: impl Into<PathBuf>, bytes: impl Into<Rc<[u8]>>) {
        self.files.insert(normalize(&path.into()), bytes.into());
    }
}
impl FileSystem for VirtualFs {
    fn read(&self, path: &Path) -> Option<Vec<u8>> {
        self.files.get(&normalize(path)).map(|b| b.to_vec())
    }
    fn is_file(&self, path: &Path) -> bool {
        self.files.contains_key(&normalize(path))
    }
    fn is_dir(&self, path: &Path) -> bool {
        let p = normalize(path);
        self.files.keys().any(|k| k.starts_with(&p) && k != &p)
    }
}

/// Lexically normalize `a/./b/../c` without touching the filesystem.
pub fn normalize(path: &Path) -> PathBuf {
    let mut out = PathBuf::new();
    for component in path.components() {
        match component {
            std::path::Component::CurDir => {}
            std::path::Component::ParentDir => {
                if !out.pop() {
                    out.push("..");
                }
            }
            c => out.push(c.as_os_str()),
        }
    }
    out
}

/// Marks an import argument `.Member` whose type comes from the module parameter.
const INFERRED_PARAM: &str = "\0inferred.";

impl Compiler {
    fn read_source(&mut self, path: &Path, span: Span) -> Result<FileId> {
        let Some(bytes) = self.fs.read(path) else {
            return err(span, format!("could not read file '{}'", path.display()));
        };
        let text: Rc<str> = String::from_utf8_lossy(&bytes).into();
        Ok(self.sources.add(path.display().to_string(), text))
    }

    /// Load a file into `module`, declaring its top-level statements.
    pub fn load_file(&mut self, path: &Path, module: ModuleId, span: Span) -> Result<()> {
        let path = self.fs.canonical(path);
        if self.file_by_path.contains_key(&(path.clone(), module)) {
            return Ok(()); // `#load` of an already-loaded file is a no-op.
        }
        let file = self.read_source(&path, span)?;
        self.file_by_path
            .insert((path.clone(), module), self.files.len());
        let text = self.sources.get(file).text.clone();
        let ast = crate::parser::parse_file(file, &text).map_err(Box::new)?;
        let module_scope = self.modules[module.0 as usize].scope;
        let file_scope = self.new_scope(ScopeKind::File, Some(module_scope), module, Some(file));
        self.files.push(FileInfo {
            id: file,
            path,
            module,
            scope: file_scope,
        });
        self.modules[module.0 as usize].files.push(file);
        self.declare_stmts(module_scope, file_scope, &ast.stmts, ast::ScopeKind::Export)?;
        Ok(())
    }

    pub fn file_dir(&self, file: FileId) -> PathBuf {
        let path = PathBuf::from(&self.sources.get(file).path);
        path.parent().map(Path::to_path_buf).unwrap_or_default()
    }

    /// Create a module and load its entry file.
    pub fn load_module(
        &mut self,
        name: &str,
        entry: &Path,
        params: Vec<(Sym, Value)>,
        span: Span,
    ) -> Result<ModuleId> {
        let key = (self.fs.canonical(entry), params.clone());
        if let Some(&id) = self.module_cache.get(&key) {
            return Ok(id);
        }
        // A plain `#import "M"` joins an instance already configured elsewhere
        // (`#import "Basic"()(MEMORY_DEBUGGER=true)` in the program applies to all).
        if params.is_empty()
            && let Some(id) = self
                .module_cache
                .iter()
                .filter(|((path, _), _)| *path == key.0)
                .map(|(_, &id)| id)
                .min_by_key(|id| id.0)
        {
            return Ok(id);
        }
        let id = ModuleId(self.modules.len() as u32);
        let scope = self.new_scope(ScopeKind::Module, Some(self.root_scope), id, None);
        self.modules.push(Module {
            name: name.to_string(),
            path: Some(entry.to_path_buf()),
            scope,
            params,
            param_entities: Vec::new(),
            files: Vec::new(),
        });
        self.module_cache.insert(key, id);
        self.load_file(entry, id, span)?;
        Ok(id)
    }

    /// Find `Name.jai` or `Name/module.jai` on the import path (and next to `from_dir`).
    pub fn find_module(&self, name: &str, from_dir: &Path) -> Option<PathBuf> {
        let mut dirs: Vec<PathBuf> = vec![from_dir.join("modules")];
        dirs.extend(self.options.import_paths.iter().cloned());
        for dir in dirs {
            let file = dir.join(format!("{name}.jai"));
            if self.fs.is_file(&file) {
                return Some(file);
            }
            let entry = dir.join(name).join("module.jai");
            if self.fs.is_file(&entry) {
                return Some(entry);
            }
        }
        None
    }

    /// Declare top-level statements. Returns the visibility state at the end.
    pub fn declare_stmts(
        &mut self,
        scope: ScopeId,
        file_scope: ScopeId,
        stmts: &[ast::Stmt],
        mut vis: ast::ScopeKind,
    ) -> Result<ast::ScopeKind> {
        for stmt in stmts {
            vis = self.declare_stmt(scope, file_scope, stmt, vis)?;
        }
        Ok(vis)
    }

    fn target_scope(&self, scope: ScopeId, file_scope: ScopeId, vis: ast::ScopeKind) -> ScopeId {
        if vis == ast::ScopeKind::File && self.scope(scope).kind == ScopeKind::Module {
            file_scope
        } else {
            scope
        }
    }

    pub fn declare_stmt(
        &mut self,
        scope: ScopeId,
        file_scope: ScopeId,
        stmt: &ast::Stmt,
        vis: ast::ScopeKind,
    ) -> Result<ast::ScopeKind> {
        let target = self.target_scope(scope, file_scope, vis);
        let exported = vis == ast::ScopeKind::Export;
        let file = self.scope(file_scope).file.unwrap_or_default();
        if matches!(self.scope(scope).kind, ScopeKind::Struct(_)) {
            // Struct bodies: only constants are entities; fields are laid out separately.
            match &stmt.kind {
                ast::StmtKind::Decl(decl) if decl.kind == ast::DeclKind::Const => {
                    for (index, name) in decl.names.iter().enumerate() {
                        self.add_entity(
                            scope,
                            name.name,
                            name.span,
                            EntityKind::Decl {
                                decl: decl.clone(),
                                index,
                            },
                            true,
                        );
                    }
                }
                ast::StmtKind::StaticIf {
                    ..
                } => {
                    self.scope_mut(scope).pending.push(Pending {
                        stmt: stmt.clone(),
                        exported,
                        file_scope,
                        state: PendingState::Waiting,
                    });
                }
                _ => {}
            }
            return Ok(vis);
        }
        match &stmt.kind {
            ast::StmtKind::Scope(kind) => return Ok(*kind),
            ast::StmtKind::Decl(decl) => {
                for (index, name) in decl.names.iter().enumerate() {
                    let id = self.add_entity(
                        target,
                        name.name,
                        name.span,
                        EntityKind::Decl {
                            decl: decl.clone(),
                            index,
                        },
                        exported,
                    );
                    self.entity_mut(id).file_private = vis == ast::ScopeKind::File;
                    self.entity_mut(id).home = file_scope;
                    if let Some(ast::Expr {
                        kind: ast::ExprKind::Proc(lit),
                        ..
                    }) = &decl.value
                        && lit.header.flags.program_export.is_some()
                    {
                        self.export_entities.push(id);
                    }
                    if !decl.notes.is_empty() || decl.kind == ast::DeclKind::Const {
                        self.note_declaration(id, decl);
                    }
                }
                // A procedure's body `#import`s are visible to the whole file (`#if`-guarded
                // ones once their branch is checked).
                if let Some(ast::Expr {
                    kind: ast::ExprKind::Proc(lit),
                    ..
                }) = &decl.value
                    && let Some(body) = &lit.body
                {
                    self.hoist_body_imports(file_scope, &body.stmts, true);
                }
                if decl.using
                    && decl.kind == ast::DeclKind::Const
                    && let [name] = decl.names.as_slice()
                    && let Some(ast::Expr {
                        kind: ast::ExprKind::Enum(lit),
                        ..
                    }) = &decl.value
                    && lit.items.iter().all(|i| matches!(i, ast::EnumItem::Member(_)))
                {
                    // `using E :: enum { A; B; }`: the member names are known now, so declare
                    // `A :: E.A;` aliases at once; other declarations (even other enums'
                    // values) may refer to them before the enum itself is checked.
                    for item in &lit.items {
                        let ast::EnumItem::Member(member) = item else {
                            continue;
                        };
                        let span = member.name.span;
                        let alias = const_alias(
                            member.name,
                            ast::Expr {
                                kind: ast::ExprKind::Member(
                                    Box::new(ast::Expr {
                                        kind: ast::ExprKind::Ident(name.name),
                                        span,
                                    }),
                                    member.name,
                                ),
                                span,
                            },
                        );
                        let id = self.add_entity(
                            target,
                            member.name.name,
                            span,
                            EntityKind::Decl {
                                decl: alias,
                                index: 0,
                            },
                            exported,
                        );
                        self.entity_mut(id).file_private = vis == ast::ScopeKind::File;
                        self.entity_mut(id).home = file_scope;
                    }
                } else if decl.using
                    && decl.kind == ast::DeclKind::Const
                    && let [name] = decl.names.as_slice()
                {
                    // `using E :: enum {...}`: also bring the type's members into scope.
                    self.scope_mut(target).pending.push(Pending {
                        stmt: ast::Stmt {
                            kind: ast::StmtKind::Using {
                                value: ast::Expr {
                                    kind: ast::ExprKind::Ident(name.name),
                                    span: name.span,
                                },
                                filter: ast::UsingFilter::None,
                            },
                            span: stmt.span,
                            notes: Vec::new(),
                        },
                        exported,
                        file_scope,
                        state: PendingState::Waiting,
                    });
                }
            }
            ast::StmtKind::Import(import) => {
                if let Some(name) = import.name {
                    let id = self.add_entity(
                        target,
                        name.name,
                        name.span,
                        EntityKind::Import(import.clone()),
                        exported,
                    );
                    self.entity_mut(id).home = file_scope;
                } else {
                    self.scope_mut(target).imports.push(ImportEntry {
                        import: import.clone(),
                        module: None,
                        loading: false,
                        from_scope: file_scope,
                    });
                }
            }
            ast::StmtKind::Load {
                path,
                span,
            } => {
                let module = self.scope(scope).module;
                let full = self.file_dir(file).join(&**path);
                self.load_file(&full, module, *span)?;
            }
            ast::StmtKind::StaticIf {
                ..
            }
            | ast::StmtKind::StaticSwitch {
                ..
            }
            | ast::StmtKind::Insert {
                ..
            } => {
                self.scope_mut(target).pending.push(Pending {
                    stmt: stmt.clone(),
                    exported,
                    file_scope,
                    state: PendingState::Waiting,
                });
            }
            ast::StmtKind::Run(expr) => self.top_level_runs.push((expr.clone(), file_scope)),
            ast::StmtKind::Assert {
                cond,
                message,
            } => self
                .asserts
                .push((cond.clone(), message.clone(), file_scope)),
            ast::StmtKind::AddContext(decl) => self.add_contexts.push((decl.clone(), file_scope)),
            ast::StmtKind::ModuleParameters {
                params,
                runtime_params,
                body,
            } => {
                let module = self.scope(scope).module;
                for (position, param) in params.iter().chain(runtime_params).enumerate() {
                    self.declare_module_parameter(scope, module, position, param)?;
                }
                // The trailing block declares names the parameter defaults may use.
                if let Some(body) = body {
                    self.declare_stmts(scope, file_scope, &body.stmts, vis)?;
                }
            }
            ast::StmtKind::Placeholder(names) => {
                for name in names {
                    self.add_entity(
                        target,
                        name.name,
                        name.span,
                        EntityKind::Placeholder,
                        exported,
                    );
                }
            }
            ast::StmtKind::Directive {
                name,
                args,
                ..
            } if name.name.as_str() == "poke_name" => {
                let [
                    module,
                    ast::Expr {
                        kind: ast::ExprKind::Ident(poked),
                        ..
                    },
                ] = &args[..]
                else {
                    return err(stmt.span, "#poke_name takes a module and a name");
                };
                self.pokes.push((module.clone(), *poked, file_scope));
            }
            ast::StmtKind::Directive {
                ..
            }
            | ast::StmtKind::Empty => {}
            ast::StmtKind::Using {
                value, ..
            } => {
                // `using Module;` / `using SomeStruct;` at file scope: resolved lazily.
                self.scope_mut(target).pending.push(Pending {
                    stmt: ast::Stmt {
                        kind: ast::StmtKind::Using {
                            value: value.clone(),
                            filter: ast::UsingFilter::None,
                        },
                        span: stmt.span,
                        notes: Vec::new(),
                    },
                    exported,
                    file_scope,
                    state: PendingState::Waiting,
                });
            }
            _ => return err(stmt.span, "this statement is not allowed at file scope"),
        }
        Ok(vis)
    }

    /// Apply `#poke_name Module name;`: the declarations called `name` visible at the directive
    /// also become declarations of `Module`, joining its overload set.
    pub fn apply_pokes(&mut self) -> Result<()> {
        while let Some((module_expr, name, file_scope)) = self.pokes.pop() {
            let lower::Operand::Module(module) = self.eval_const(file_scope, &module_expr, None)?
            else {
                return err(module_expr.span, "#poke_name needs a module");
            };
            let module_scope = self.modules[module.0 as usize].scope;
            for id in self.lookup(file_scope, name)? {
                let poked = self.entity(id);
                let (span, kind, home) = (poked.span, poked.kind.clone(), poked.home);
                let copy = self.add_entity(module_scope, name, span, kind, true);
                self.entity_mut(copy).home = home;
            }
        }
        Ok(())
    }

    fn declare_module_parameter(
        &mut self,
        scope: ScopeId,
        module: ModuleId,
        position: usize,
        param: &ast::Param,
    ) -> Result<()> {
        let Some(name) = param.name else {
            return err(param.span, "module parameter needs a name");
        };
        let provided = self.modules[module.0 as usize]
            .params
            .iter()
            .find(|(n, _)| *n == name.name || n.as_str() == format!("${position}"))
            .map(|(_, v)| v.clone());
        let decl = Rc::new(ast::Decl {
            id: ast::AstId::fresh(),
            names: vec![name],
            kind: ast::DeclKind::Const,
            // `X: $I/interface T = v` takes its type from the value.
            ty: param.ty.clone().filter(|t| !procs::has_poly(t)),
            value: param.default.clone(),
            extra_values: Vec::new(),
            existing: Vec::new(),
            using_filter: None,
            foreign: None,
            union_tag: None,
            using: false,
            as_: false,
            backtick: false,
            align: None,
            flags: Vec::new(),
            notes: Vec::new(),
            span: param.span,
        });
        let id = self.add_entity(
            scope,
            name.name,
            name.span,
            EntityKind::Decl {
                decl,
                index: 0,
            },
            false,
        );
        self.modules[module.0 as usize].param_entities.push(id);
        if let Some(Value::String(text)) = &provided
            && let Some(member) = std::str::from_utf8(text)
                .ok()
                .and_then(|t| t.strip_prefix(INFERRED_PARAM))
        {
            // Typecheck `.Member` against the parameter's declared type.
            let EntityKind::Decl {
                decl, ..
            } = &mut self.entity_mut(id).kind
            else {
                unreachable!()
            };
            let decl = Rc::make_mut(decl);
            // `P := Kind.A` has no written type: use the default's (`type_of(Kind.A)`).
            if decl.ty.is_none()
                && let Some(default) = decl.value.take()
            {
                let span = default.span;
                decl.ty = Some(ast::Expr {
                    kind: ast::ExprKind::Call {
                        callee: Box::new(ast::Expr {
                            kind: ast::ExprKind::Ident(Sym::intern("type_of")),
                            span,
                        }),
                        args: vec![ast::Arg {
                            name: None,
                            target: None,
                            context: false,
                            spread: false,
                            value: default,
                        }],
                        hint: ast::CallHint::None,
                    },
                    span,
                });
            }
            decl.value = Some(ast::Expr {
                kind: ast::ExprKind::InferredMember(ast::Ident {
                    name: Sym::intern(member),
                    span: param.span,
                }),
                span: param.span,
            });
            return Ok(());
        }
        if let Some(value) = provided {
            self.entity_mut(id).kind = EntityKind::Const {
                value,
                ty: TypeId::VOID,
            };
        }
        Ok(())
    }

    /// Hook for declaration notes (e.g. `@Something` on procedures); currently informational.
    fn note_declaration(&mut self, _id: EntityId, _decl: &ast::Decl) {
    }

    /// Expand one pending item (`#if`, top-level `#insert`, file-scope `using`).
    pub(super) fn expand_pending_item(
        &mut self,
        scope: ScopeId,
        file_scope: ScopeId,
        stmt: &ast::Stmt,
        exported: bool,
    ) -> Result<()> {
        let vis = if exported {
            ast::ScopeKind::Export
        } else if scope == file_scope {
            ast::ScopeKind::File
        } else {
            ast::ScopeKind::Module
        };
        match &stmt.kind {
            ast::StmtKind::StaticIf {
                cond,
                then_branch,
                else_branch,
            } => {
                let taken =
                    self.eval_static_condition(file_scope_for_eval(self, scope, file_scope), cond)?;
                let branch = if taken {
                    then_branch
                } else {
                    else_branch
                };
                self.declare_stmts(scope, file_scope, branch, vis)?;
            }
            ast::StmtKind::StaticSwitch {
                value,
                cases,
            } => {
                let eval_scope = file_scope_for_eval(self, scope, file_scope);
                if let Some(case) = self.static_switch_case(eval_scope, value, cases)? {
                    self.declare_stmts(scope, file_scope, &case.body, vis)?;
                }
            }
            ast::StmtKind::Insert {
                value, ..
            } => {
                let stmts =
                    self.eval_insert_stmts(file_scope_for_eval(self, scope, file_scope), value)?;
                self.declare_stmts(scope, file_scope, &stmts, vis)?;
            }
            ast::StmtKind::Using {
                value, ..
            } => {
                let eval_scope = file_scope_for_eval(self, scope, file_scope);
                let entry = self.using_target(eval_scope, value)?;
                if exported
                    && let super::scope::UsingEntry::Type(ty) = &entry
                    && let crate::types::TypeKind::Enum(e) = *self.types.kind(*ty)
                {
                    // An exported `using Enum :: enum {...}` exports the members as constants.
                    let members = self.types.enum_info(e).members.clone();
                    for (name, v) in members {
                        self.add_entity(
                            scope,
                            name,
                            stmt.span,
                            EntityKind::Const {
                                value: Value::Int(v),
                                ty: *ty,
                            },
                            true,
                        );
                    }
                }
                self.scope_mut(scope).usings.push(entry);
            }
            _ => unreachable!("only conditional items are pending"),
        }
        Ok(())
    }

    /// Resolve the module behind import entry `index` of `scope`, loading it on first use.
    pub fn import_module(&mut self, scope: ScopeId, index: usize) -> Result<Option<ModuleId>> {
        let entry = self.scope(scope).imports[index].clone();
        if let Some(module) = entry.module {
            return Ok(Some(module));
        }
        if entry.loading {
            return Ok(None);
        }
        self.scope_mut(scope).imports[index].loading = true;
        let module = self.resolve_import(entry.from_scope, &entry.import)?;
        self.scope_mut(scope).imports[index].module = Some(module);
        Ok(Some(module))
    }

    pub fn resolve_import(
        &mut self,
        from_scope: ScopeId,
        import: &ast::Import,
    ) -> Result<ModuleId> {
        let file = self.scope(from_scope).file.unwrap_or_default();
        let dir = self.file_dir(file);
        let mut params = Vec::new();
        for (position, arg) in import.params.iter().enumerate() {
            // `.Member` needs the parameter's type, known only once the module is read.
            let value = match &arg.value.kind {
                ast::ExprKind::InferredMember(member) => {
                    Value::String(format!("{INFERRED_PARAM}{}", member.name).as_bytes().into())
                }
                _ => self.eval_const_value(from_scope, &arg.value)?,
            };
            let name = arg
                .name
                .map_or_else(|| Sym::intern(&format!("${position}")), |n| n.name);
            params.push((name, value));
        }
        match &import.source {
            ast::ImportSource::Module(name)
                if &**name == "Runtime_Support" && self.runtime_support.is_some() =>
            {
                // One runtime per program, whatever parameters the importer asks for.
                Ok(self.runtime_support.unwrap())
            }
            ast::ImportSource::Module(name) => {
                let Some(entry) = self.find_module(name, &dir) else {
                    return err(
                        import.span,
                        format!(
                            "module '{name}' not found (searched {} import directories)",
                            self.options.import_paths.len() + 1
                        ),
                    );
                };
                self.load_module(name, &entry, params, import.span)
            }
            ast::ImportSource::File(path) => {
                let entry = dir.join(&**path);
                self.load_module(path, &entry, params, import.span)
            }
            ast::ImportSource::Dir(path) => {
                let entry = dir.join(&**path).join("module.jai");
                self.load_module(path, &entry, params, import.span)
            }
            ast::ImportSource::String(source) => {
                let id = self.new_module("string", None, params);
                let label = format!("<import string {}>", self.sources.len());
                self.load_string(&label, source, id)?;
                Ok(id)
            }
        }
    }

    /// A fresh module with no files yet.
    pub fn new_module(
        &mut self,
        name: &str,
        path: Option<PathBuf>,
        params: Vec<(Sym, Value)>,
    ) -> ModuleId {
        let id = ModuleId(self.modules.len() as u32);
        let scope = self.new_scope(ScopeKind::Module, Some(self.root_scope), id, None);
        self.modules.push(Module {
            name: name.into(),
            path,
            scope,
            params,
            param_entities: Vec::new(),
            files: Vec::new(),
        });
        id
    }

    /// Add source text (an `#import,string` or a workspace build string) as a
    /// file of `module`. `label` names it in diagnostics.
    pub fn load_string(&mut self, label: &str, source: &str, module: ModuleId) -> Result<()> {
        let path = PathBuf::from(label);
        let file = self.sources.add(label.to_string(), source.into());
        let ast = crate::parser::parse_file(file, source).map_err(Box::new)?;
        let module_scope = self.modules[module.0 as usize].scope;
        let file_scope = self.new_scope(ScopeKind::File, Some(module_scope), module, Some(file));
        self.files.push(FileInfo {
            id: file,
            path,
            module,
            scope: file_scope,
        });
        self.modules[module.0 as usize].files.push(file);
        self.declare_stmts(module_scope, file_scope, &ast.stmts, ast::ScopeKind::Export)?;
        Ok(())
    }

    /// Load every module reachable through imports and expand all pending
    /// top-level items, until nothing changes.
    pub fn expand_all(&mut self) -> Result<()> {
        let mut scope_index = 0;
        let mut entity_index = 0;
        loop {
            while scope_index < self.scopes.len() {
                let sid = ScopeId(scope_index as u32);
                if matches!(self.scope(sid).kind, ScopeKind::Module | ScopeKind::File) {
                    self.expand_pending(sid)?;
                    for i in 0..self.scope(sid).imports.len() {
                        self.import_module(sid, i)?;
                    }
                }
                scope_index += 1;
            }
            // Named imports (`X :: #import`) load eagerly too, so every module's
            // `#add_context` is known before the Context type is laid out.
            while entity_index < self.entities.len() {
                let id = EntityId(entity_index as u32);
                entity_index += 1;
                let e = self.entity(id);
                if matches!(e.kind, EntityKind::Import(_))
                    && matches!(
                        self.scope(e.scope).kind,
                        ScopeKind::Module | ScopeKind::File
                    )
                {
                    self.resolve_entity(id)?;
                }
            }
            if scope_index == self.scopes.len() {
                return Ok(());
            }
        }
    }
}

/// Conditions inside a module-level pending item are evaluated from the file scope
/// that wrote them, so file-private names are visible.
fn file_scope_for_eval(c: &Compiler, scope: ScopeId, file_scope: ScopeId) -> ScopeId {
    if c.scope(scope).kind == ScopeKind::Module {
        file_scope
    } else {
        scope
    }
}

/// `name :: value;`, a synthesized constant declaration.
fn const_alias(name: ast::Ident, value: ast::Expr) -> Rc<ast::Decl> {
    Rc::new(ast::Decl {
        id: ast::AstId::fresh(),
        names: vec![name],
        kind: ast::DeclKind::Const,
        ty: None,
        span: value.span,
        value: Some(value),
        extra_values: Vec::new(),
        existing: Vec::new(),
        using_filter: None,
        foreign: None,
        union_tag: None,
        using: false,
        as_: false,
        backtick: false,
        align: None,
        flags: Vec::new(),
        notes: Vec::new(),
    })
}
