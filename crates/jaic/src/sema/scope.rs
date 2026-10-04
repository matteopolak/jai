//! Scopes, entities and name lookup.
use super::*;
use crate::types::TypeId;

#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug, PartialOrd, Ord)]
pub struct ScopeId(pub u32);
#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug, PartialOrd, Ord)]
pub struct EntityId(pub u32);

/// Result of a full name lookup.
pub enum Found {
    Entities(Vec<EntityId>),
    /// The name is a member reached through a `using` entry.
    Using(UsingEntry, Sym),
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ScopeKind {
    Root,
    Module,
    File,
    Struct(TypeId),
    /// Polymorphic struct parameter scope (before instantiation).
    StructParams,
    Proc,
    Block,
    /// Macro expansion body: lookups for backticked names go to the caller.
    Macro,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum PendingState {
    Waiting,
    Expanding,
    Done,
}

/// A conditional or generated top-level item whose declarations are not yet known.
pub struct Pending {
    pub stmt: ast::Stmt,
    pub exported: bool,
    /// File scope used for `#scope_file` declarations inside the item.
    pub file_scope: ScopeId,
    pub state: PendingState,
}

#[derive(Clone)]
pub struct ImportEntry {
    pub import: Rc<ast::Import>,
    pub module: Option<ModuleId>,
    pub loading: bool,
    /// The file that wrote the import (for relative paths and parameter evaluation).
    pub from_scope: ScopeId,
}

/// `using x;` inside a body/struct: names are looked up as members of `value`.
#[derive(Clone)]
pub enum UsingEntry {
    /// Members of a struct value at a place (address held in the current function).
    Place {
        ty: TypeId,
        entity: EntityId,
    },
    /// Constants of a type (struct constants, enum members).
    Type(TypeId),
    Module(ModuleId),
}

pub struct Scope {
    pub kind: ScopeKind,
    pub parent: Option<ScopeId>,
    pub module: ModuleId,
    pub file: Option<FileId>,
    pub names: HashMap<Sym, Vec<EntityId>>,
    pub imports: Vec<ImportEntry>,
    pub pending: Vec<Pending>,
    pub usings: Vec<UsingEntry>,
    /// Procedure whose body this scope belongs to (locals are only visible inside it).
    pub proc_depth: u32,
}

#[derive(Clone, Debug)]
pub enum Builtin {
    Type(TypeId),
    /// `size_of`, `type_of`, ... handled specially by the call checker.
    Proc(BuiltinProc),
    /// Compiler-defined constants that depend on Preload (`OS`, `CPU`, ...).
    TargetConstant(Sym),
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum BuiltinProc {
    SizeOf,
    TypeOf,
    TypeInfo,
    InitializerOf,
    IsConstant,
    AlignOf,
    OffsetOf,
    IsValueType,
}

#[derive(Clone, Debug)]
pub enum EntityKind {
    /// Global or struct-level constant/variable from source.
    Decl {
        decl: Rc<ast::Decl>,
        index: usize,
    },
    /// `Name :: #import "X"`.
    Import(Rc<ast::Import>),
    Builtin(Builtin),
    /// A runtime local living at `addr` in the procedure being lowered.
    Local {
        ty: TypeId,
        addr: ir::Val,
        depth: u32,
    },
    /// A known constant (polymorphic bindings, module parameters, enum members...).
    Const {
        value: Value,
        ty: TypeId,
    },
    /// `#placeholder` name awaiting a later definition.
    Placeholder,
}

#[derive(Clone, Debug)]
pub enum Resolved {
    Const { value: Value, ty: TypeId },
    Proc(ProcId),
    Global { global: ir::GlobalId, ty: TypeId },
    Module(ModuleId),
    Library(value::LibraryId),
    PolyStruct(value::PolyStructId),
}

#[derive(Clone, Debug)]
pub enum EntityState {
    Unresolved,
    Resolving,
    Done(Resolved),
}

pub struct Entity {
    pub name: Sym,
    pub span: Span,
    pub scope: ScopeId,
    /// Scope declarations are resolved in (the declaring file's scope for module-level names).
    pub home: ScopeId,
    pub exported: bool,
    pub kind: EntityKind,
    pub state: EntityState,
    /// Declared after `#scope_file` in a module file.
    pub file_private: bool,
    /// A constant declared without a type whose value is an untyped literal (`X :: 5`):
    /// uses of it convert like the literal would.
    pub untyped_const: bool,
}

/// A procedure-valued declaration can join an overload set.
fn decl_is_proc(decl: &ast::Decl) -> bool {
    decl.kind == ast::DeclKind::Const
        && matches!(
            decl.value.as_ref().map(|v| &v.kind),
            Some(ast::ExprKind::Proc(_))
        )
}

impl Compiler {
    pub fn new_scope(
        &mut self,
        kind: ScopeKind,
        parent: Option<ScopeId>,
        module: ModuleId,
        file: Option<FileId>,
    ) -> ScopeId {
        let proc_depth = parent.map_or(0, |p| self.scopes[p.0 as usize].proc_depth)
            + u32::from(kind == ScopeKind::Proc);
        self.scopes.push(Scope {
            kind,
            parent,
            module,
            file,
            names: HashMap::new(),
            imports: Vec::new(),
            pending: Vec::new(),
            usings: Vec::new(),
            proc_depth,
        });
        ScopeId(self.scopes.len() as u32 - 1)
    }
    pub fn scope(&self, id: ScopeId) -> &Scope {
        &self.scopes[id.0 as usize]
    }
    pub fn scope_mut(&mut self, id: ScopeId) -> &mut Scope {
        &mut self.scopes[id.0 as usize]
    }
    pub fn entity(&self, id: EntityId) -> &Entity {
        &self.entities[id.0 as usize]
    }
    pub fn entity_mut(&mut self, id: EntityId) -> &mut Entity {
        &mut self.entities[id.0 as usize]
    }

    pub fn add_entity(
        &mut self,
        scope: ScopeId,
        name: Sym,
        span: Span,
        kind: EntityKind,
        exported: bool,
    ) -> EntityId {
        let id = EntityId(self.entities.len() as u32);
        self.entities.push(Entity {
            name,
            span,
            scope,
            home: scope,
            exported,
            kind,
            state: EntityState::Unresolved,
            file_private: false,
            untyped_const: false,
        });
        self.scope_mut(scope)
            .names
            .entry(name)
            .or_default()
            .push(id);
        id
    }

    /// Declare a constant whose value is already known.
    pub fn add_const(
        &mut self,
        scope: ScopeId,
        name: Sym,
        span: Span,
        value: Value,
        ty: TypeId,
    ) -> EntityId {
        let id = self.add_entity(
            scope,
            name,
            span,
            EntityKind::Const {
                value: value.clone(),
                ty,
            },
            true,
        );
        self.entity_mut(id).state = EntityState::Done(Resolved::Const {
            value,
            ty,
        });
        id
    }

    pub(super) fn declare_builtins(&mut self) {
        let root = self.root_scope;
        let types: &[(&str, TypeId)] = &[
            ("void", TypeId::VOID),
            ("bool", TypeId::BOOL),
            ("s8", TypeId::S8),
            ("s16", TypeId::S16),
            ("s32", TypeId::S32),
            ("s64", TypeId::S64),
            ("int", TypeId::S64),
            ("u8", TypeId::U8),
            ("u16", TypeId::U16),
            ("u32", TypeId::U32),
            ("u64", TypeId::U64),
            ("float", TypeId::F32),
            ("float32", TypeId::F32),
            ("float64", TypeId::F64),
            ("string", TypeId::STRING),
            ("Type", TypeId::TYPE),
            ("Any", TypeId::ANY),
            ("Code", TypeId::CODE),
            // `#asm` register parameters of macros bind to the caller's operand expression.
            ("__reg", TypeId::CODE),
        ];
        for &(name, ty) in types {
            self.add_const(
                root,
                Sym::intern(name),
                Span::default(),
                Value::Type(ty),
                TypeId::TYPE,
            );
        }
        let procs: &[(&str, BuiltinProc)] = &[
            ("size_of", BuiltinProc::SizeOf),
            ("type_of", BuiltinProc::TypeOf),
            ("type_info", BuiltinProc::TypeInfo),
            ("initializer_of", BuiltinProc::InitializerOf),
            ("is_constant", BuiltinProc::IsConstant),
            ("align_of", BuiltinProc::AlignOf),
            ("offset_of", BuiltinProc::OffsetOf),
        ];
        for &(name, p) in procs {
            let id = self.add_entity(
                root,
                Sym::intern(name),
                Span::default(),
                EntityKind::Builtin(Builtin::Proc(p)),
                true,
            );
            let _ = id;
        }
        for name in [
            "OS",
            "CPU",
            "BUILD_OS",
            "BUILD_CPU",
            "TEMPORARY_STORAGE_SIZE",
            "LANGUAGE_VERSION_MAJOR",
            "LANGUAGE_VERSION_MINOR",
        ] {
            self.add_entity(
                root,
                Sym::intern(name),
                Span::default(),
                EntityKind::Builtin(Builtin::TargetConstant(Sym::intern(name))),
                true,
            );
        }
    }

    pub fn entity_is_overloadable(&self, id: EntityId) -> bool {
        match &self.entity(id).kind {
            EntityKind::Decl {
                decl, ..
            } => decl_is_proc(decl),
            EntityKind::Const {
                value: Value::Proc(_),
                ..
            } => true,
            _ => false,
        }
    }

    /// Expand pending conditional items of a scope (each at most once).
    pub fn expand_pending(&mut self, scope: ScopeId) -> Result<()> {
        let mut i = 0;
        while i < self.scope(scope).pending.len() {
            // Items expand in source order: a re-entrant expansion (from inside an
            // item's own condition or lookup) must not run later items early.
            if self.scope(scope).pending[i].state == PendingState::Expanding {
                return Ok(());
            }
            if self.scope(scope).pending[i].state == PendingState::Waiting {
                self.scope_mut(scope).pending[i].state = PendingState::Expanding;
                let stmt = self.scope(scope).pending[i].stmt.clone();
                let exported = self.scope(scope).pending[i].exported;
                let file_scope = self.scope(scope).pending[i].file_scope;
                let result = self.expand_pending_item(scope, file_scope, &stmt, exported);
                self.scope_mut(scope).pending[i].state = PendingState::Done;
                result?;
            }
            i += 1;
        }
        Ok(())
    }

    /// Look up `name` starting at `scope`, ignoring `using` struct members.
    pub fn lookup(&mut self, scope: ScopeId, name: Sym) -> Result<Vec<EntityId>> {
        match self.lookup_full(scope, name)? {
            Found::Entities(ids) => Ok(ids),
            Found::Using(..) => Ok(Vec::new()),
        }
    }

    /// Full lookup. Procedures from several scopes merge into one overload
    /// set; any other binding shadows everything outside it. `using` entries
    /// of a scope are consulted after its own names.
    pub fn lookup_full(&mut self, scope: ScopeId, name: Sym) -> Result<Found> {
        let mut found: Vec<EntityId> = Vec::new();
        let mut current = Some(scope);
        while let Some(sid) = current {
            self.expand_pending(sid)?;
            if let Some(ids) = self.scope(sid).names.get(&name).cloned() {
                let ids: Vec<EntityId> = ids
                    .into_iter()
                    .filter(|&e| {
                        !matches!(self.entity(e).kind, EntityKind::Placeholder) || found.is_empty()
                    })
                    .collect();
                if !ids.is_empty() && self.collect(&mut found, &ids) {
                    return Ok(Found::Entities(found));
                }
            }
            for entry in self.scope(sid).usings.clone() {
                match &entry {
                    UsingEntry::Module(m) => {
                        let ids = self.module_exports(*m, name)?;
                        if !ids.is_empty() && self.collect(&mut found, &ids) {
                            return Ok(Found::Entities(found));
                        }
                    }
                    UsingEntry::Place {
                        ty, ..
                    }
                    | UsingEntry::Type(ty) => {
                        if found.is_empty() && self.type_has_member(*ty, name)? {
                            return Ok(Found::Using(entry.clone(), name));
                        }
                    }
                }
            }
            let imports = self.scope(sid).imports.len();
            for i in 0..imports {
                if let Some(module) = self.import_module(sid, i)? {
                    let ids = self.module_exports(module, name)?;
                    if !ids.is_empty() && self.collect(&mut found, &ids) {
                        return Ok(Found::Entities(found));
                    }
                }
            }
            // Preload and Runtime_Support are implicitly visible to every module.
            if self.scope(sid).kind == ScopeKind::Module {
                for implicit in [self.preload, self.runtime_support].into_iter().flatten() {
                    if self.scope(sid).module == implicit {
                        continue;
                    }
                    let ids = self.module_exports(implicit, name)?;
                    if !ids.is_empty() && self.collect(&mut found, &ids) {
                        return Ok(Found::Entities(found));
                    }
                }
            }
            current = self.scope(sid).parent;
        }
        Ok(Found::Entities(found))
    }

    /// Merge `ids` into `found`; returns true when the lookup must stop
    /// (a non-procedure binding shadows everything outside it).
    fn collect(&self, found: &mut Vec<EntityId>, ids: &[EntityId]) -> bool {
        let overloadable = ids.iter().all(|&e| self.entity_is_overloadable(e));
        if found.is_empty() {
            found.extend_from_slice(ids);
            return !overloadable;
        }
        if overloadable {
            for &id in ids {
                if !found.contains(&id) {
                    found.push(id);
                }
            }
        }
        false
    }

    /// Exported names of a module (after expanding its pending items).
    pub fn module_exports(&mut self, module: ModuleId, name: Sym) -> Result<Vec<EntityId>> {
        let scope = self.modules[module.0 as usize].scope;
        self.expand_pending(scope)?;
        Ok(self
            .scope(scope)
            .names
            .get(&name)
            .map(|ids| {
                ids.iter()
                    .copied()
                    .filter(|&e| self.entity(e).exported)
                    .collect()
            })
            .unwrap_or_default())
    }

    /// Names visible inside a module from one of its files (export + module scope).
    pub fn module_member(&mut self, module: ModuleId, name: Sym) -> Result<Vec<EntityId>> {
        self.module_exports(module, name)
    }
}
