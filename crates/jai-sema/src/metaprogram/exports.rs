//! An invocation exports checked bindings to inserted caller code, with explicit name remapping.
use super::*;

/// A live caller block and its context, captured before entering the definition.
#[derive(Clone, Copy)]
pub(super) struct CallerCleanupTarget {
    procedure: jai_ir::ProcedureId,
    scope: usize,
    active_push: Option<jai_ir::PushContextId>,
    context_available: bool,
}

impl CodeRegistry {
    pub(crate) fn push_export_remap(&mut self, remap: Vec<(Symbol, Symbol)>) {
        self.exports.push(ExportFrame {
            remap: remap.into_iter().collect(),
            ..ExportFrame::default()
        });
    }

    pub(crate) fn pop_export_remap(&mut self) {
        self.exports.pop().expect("active macro export scope");
    }

    pub(crate) fn exported_named(&self, name: Symbol) -> bool {
        self.exports
            .last()
            .is_some_and(|frame| frame.names.contains(&name))
    }

    fn export(&mut self, name: Symbol, binding: Binding, span: Span) -> Result<(), Diagnostic> {
        let frame = self.exports.last_mut().ok_or_else(|| {
            Diagnostic::new(span, "caller exports require an active #expand invocation")
        })?;
        let target = frame.remap.get(&name).copied().unwrap_or(name);
        if frame.names.contains(&name) || frame.bindings.contains_key(&target) {
            return Err(Diagnostic::new(
                span,
                "duplicate caller export in one expansion invocation",
            ));
        }
        frame.names.insert(name);
        frame.bindings.insert(target, binding);
        Ok(())
    }

    pub(super) fn overlay_exports(&self, scopes: &mut Vec<HashMap<Symbol, Binding>>) {
        for frame in &self.exports {
            if !frame.bindings.is_empty() {
                scopes.push(frame.bindings.clone());
            }
        }
    }
}

impl Resolver<'_> {
    pub(super) fn prepare_caller_cleanup_export(&mut self, span: Span) -> Result<(), Diagnostic> {
        let caller_key = Arc::new(self.capture_key(span)?);
        let caller_capture = Arc::new(self.capture_scope(span)?);
        let caller_scope = self.deferred_scopes.len().checked_sub(1).ok_or_else(|| {
            Diagnostic::new(span, "macro expansion requires a caller cleanup scope")
        })?;
        // A nested macro's synthetic body is transparent to caller cleanup
        // lifetime. A real nested caller block still establishes a new target.
        let inherited = self
            .meta
            .codes
            .exports
            .iter()
            .rev()
            .skip(1)
            .find_map(|frame| {
                frame.cleanup_target.filter(|target| {
                    target.procedure == self.procedure && frame.body_scope == Some(caller_scope)
                })
            });
        let target = inherited.unwrap_or(CallerCleanupTarget {
            procedure: self.procedure,
            scope: caller_scope,
            active_push: self.active_push,
            context_available: self.context_available,
        });
        let body_scope = self.deferred_scopes.len();
        let frame = self.meta.codes.exports.last_mut().ok_or_else(|| {
            Diagnostic::new(span, "macro expansion requires an active export frame")
        })?;
        frame.cleanup_target = Some(target);
        frame.body_scope = Some(body_scope);
        frame.caller_scope = Some(caller_capture);
        frame.caller_key = Some(caller_key);
        Ok(())
    }

    pub(super) fn publish_caller_exports(&mut self, span: Span) -> Result<(), Diagnostic> {
        let frame = self.meta.codes.exports.last().ok_or_else(|| {
            Diagnostic::new(
                span,
                "caller export publication requires an active invocation",
            )
        })?;
        let mut bindings = frame
            .bindings
            .iter()
            .map(|(&name, binding)| (name, binding.clone()))
            .collect::<Vec<_>>();
        bindings.sort_by_key(|(name, _)| self.symbols.name(*name));
        // Validate the whole publication before inserting any binding. A
        // declaration may shadow an outer frame, but may not replace a name in
        // the lexical block receiving this invocation's exports.
        for &(name, _) in &bindings {
            if self
                .scopes
                .last()
                .is_some_and(|scope| scope.contains_key(&name))
                || self.local_import_alias_reserved(name)
                || self.local_using_name_reserved(name)
                || self.local_name_reserved(name)
            {
                return Err(Diagnostic::new(
                    span,
                    format!(
                        "caller export duplicates local declaration '{}'",
                        self.symbols.name(name)
                    ),
                ));
            }
        }
        let scope = self
            .scopes
            .last_mut()
            .ok_or_else(|| Diagnostic::new(span, "caller export has no active lexical block"))?;
        for (name, binding) in bindings {
            scope.insert(name, binding);
        }
        Ok(())
    }

    fn caller_export_defer(
        &mut self,
        body: &[syntax::Statement],
        span: Span,
    ) -> Result<Statement, Diagnostic> {
        let frame = self.meta.codes.exports.last().ok_or_else(|| {
            Diagnostic::new(span, "caller exports require an active #expand invocation")
        })?;
        let target = frame.cleanup_target.ok_or_else(|| {
            Diagnostic::new(
                span,
                "caller cleanup target is unavailable during expansion",
            )
        })?;
        let current_scope = self.deferred_scopes.len().checked_sub(1);
        if target.procedure != self.procedure
            || current_scope != frame.body_scope
            || current_scope.is_none_or(|scope| target.scope >= scope)
        {
            return Err(Diagnostic::new(
                span,
                "caller-exported defer requires the top-level statement list of a macro",
            ));
        }
        if self.deferred_scopes.get(target.scope).is_none() {
            return Err(Diagnostic::new(
                span,
                "caller cleanup scope is no longer active",
            ));
        }
        let active_push = std::mem::replace(&mut self.active_push, target.active_push);
        let context_available =
            std::mem::replace(&mut self.context_available, target.context_available);
        let result = self.register_defer(body);
        self.active_push = active_push;
        self.context_available = context_available;
        result?;
        let cleanup = self
            .deferred_scopes
            .last_mut()
            .and_then(Vec::pop)
            .ok_or_else(|| Diagnostic::new(span, "defer registration did not publish a cleanup"))?;
        self.deferred_scopes[target.scope].push(cleanup);
        Ok(Statement::Block(crate::Block {
            statements: Vec::new(),
            flow: crate::Flow::FallsThrough,
        }))
    }

    pub(crate) fn export_bound_name(&mut self, name: Symbol, span: Span) -> Result<(), Diagnostic> {
        let binding = self.resolve_local_name(name, span)?.ok_or_else(|| {
            Diagnostic::new(span, "caller export declaration did not bind a value")
        })?;
        self.meta.codes.export(name, binding, span)
    }

    pub(crate) fn caller_export(
        &mut self,
        statement: &syntax::Statement,
    ) -> Result<Statement, Diagnostic> {
        if self.meta.codes.exports.is_empty() {
            return Err(Diagnostic::new(
                statement.span,
                "caller exports require an active #expand invocation",
            ));
        }
        let (name, result) = match &statement.kind {
            syntax::StatementKind::Defer(body) => {
                return self.caller_export_defer(body, statement.span);
            }
            syntax::StatementKind::Declare(declaration) => {
                let result = self.statement(statement)?;
                self.debug.forward_statement();
                (declaration.name(), result)
            }
            syntax::StatementKind::Constant(constant) => {
                self.register_local_declarations(std::slice::from_ref(statement))?;
                self.resolve_local_name(constant.name, constant.span)?;
                (
                    constant.name,
                    Statement::Block(crate::Block {
                        statements: Vec::new(),
                        flow: crate::Flow::FallsThrough,
                    }),
                )
            }
            _ => {
                return Err(Diagnostic::new(
                    statement.span,
                    "caller export requires a declaration or defer",
                ));
            }
        };
        self.export_bound_name(name, statement.span)?;
        Ok(result)
    }
}
