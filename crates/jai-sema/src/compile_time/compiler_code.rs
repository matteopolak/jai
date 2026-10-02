//! Compiler Code producers retain one checked source plan and VM transaction.
use super::*;
use crate::compiler_code::CompilerCodeSourcePlan;
use crate::metaprogram::PublishedCompilerQuote;
use std::sync::Arc;

pub(super) struct SuspendedCompilerRun {
    pub(super) state: jai_vm::ContinuationState,
    pub(super) dependencies: Vec<Dependency>,
    pub(super) location: SourceSpan,
    plan: Arc<CompilerCodeSourcePlan>,
}

#[derive(Clone)]
pub(super) struct CompletedCompilerRun {
    publication: CompilerPublication,
    proof: Rc<CallbackProof>,
}

#[derive(Clone)]
enum CompilerPublication {
    Code(jai_types::CodeValueId),
    Declarations(jai_modules::DeclarationInsertionCode),
}

pub(crate) enum CompilerDestination<'a> {
    Code,
    Declarations(&'a jai_modules::DeclarationInsertionRequest),
}

pub(crate) enum CompilerRunResult {
    Code(jai_types::CodeValueId),
    Declarations(jai_modules::DeclarationInsertionCode),
}

enum SelectedPublication {
    Code(PublishedCompilerQuote),
    Declarations(jai_modules::DeclarationInsertionCode),
}

enum SourceBody<'a> {
    Anonymous(&'a [jai_syntax::Statement]),
    Named(Arc<jai_syntax::Procedure>),
}
impl SourceBody<'_> {
    fn statements(&self) -> &[jai_syntax::Statement] {
        match self {
            Self::Anonymous(body) => body,
            Self::Named(procedure) => &procedure.body,
        }
    }
}

impl crate::Resolver<'_> {
    /// `None` leaves ordinary native/scalar #run handling to its existing path.
    pub(crate) fn execute_compiler_code_run(
        &mut self,
        run: &CompileTimeRun,
        span: jai_source::Span,
        destination: CompilerDestination<'_>,
    ) -> Result<Option<CompilerRunResult>, jai_source::Diagnostic> {
        self.check_source_execution(span)?;
        let context = self.compile_time.ok_or_else(|| {
            jai_source::Diagnostic::new(span, "compiler Code requires source readiness")
        })?;
        let source = self.debug.source().unwrap_or(context.source);
        let location = SourceSpan { source, span };
        let key = RunCacheKey {
            lexical: self.run_lexical_key(span)?,
            flags: run.flags,
            // Declaration and procedural destinations validate distinct source
            // receipts before the sole compiler transaction commit.
            result_use: matches!(destination, CompilerDestination::Declarations(_))
                .then(|| vec![]),
            specialization: self.meta.source_specialization_keys.get(&self.procedure).cloned(),
            file: context.file,
            owner: context.owner,
            source,
            start: span.start,
            end: span.end,
            destination: Some(self.types.code_type()),
            cast: None,
        };
        if let Some(completed) = context.cache.compiler_values.borrow().get(&key).cloned() {
            completed.proof.validate(context, &self.meta.local_declarations, location)?;
            return self.compiler_publication_result(completed.publication, destination, location);
        }
        let retained_plan = context.cache.compiler_continuations.borrow().get(&key)
            .map(|run| Arc::clone(&run.plan));
        let resume = retained_plan.is_some();
        let plan = match retained_plan {
            Some(plan) => plan,
            None => match self.compiler_source_plan(run, location)? {
                Some(plan) => Arc::new(plan),
                None => return Ok(None),
            },
        };
        if !resume && let Some(pending) = context.cache.pending_execution() {
            context.record_pending(pending.dependencies);
            return Err(jai_source::Diagnostic::at_source(location,
                "compiler Code waits for the retained source transaction"));
        }
        let proof = context.cache.proof(&key, context, &self.meta.local_declarations);
        proof.validate(context, &self.meta.local_declarations, location)?;
        let retained_origin = context.cache.compiler_continuations.borrow().get(&key)
            .map(|run| run.state.source_origin().cloned());
        let origin = match retained_origin {
            Some(origin) => origin.ok_or_else(|| {
                jai_source::Diagnostic::at_source(location, "compiler continuation lost source origin")
            })?,
            None => self.source_run_origin(context.workspace, context.owner, source, span)?,
        };
        context.effects.set_source_origin(origin.clone());
        let mut signatures = context.signatures.clone();
        signatures.extend(context.generics.borrow().signature_snapshot());
        signatures.extend(self.meta.local_declarations.signature_snapshot());
        let mut procedures = context.procedures.clone();
        procedures.extend(self.meta.local_declarations.ready_snapshot());
        let bindings = prototypes::snapshot(context, self.meta);
        let globals = self.meta.external_globals.snapshot(context.globals)?;
        let places = self.places.snapshot();
        let provider = ReadyProcedures::new_with_context(
            self.types, &procedures, &signatures, &globals, &places, context.context,
        )
        .map(|provider| provider.with_foreign(&bindings.foreign)
            .with_storage_alignments(&self.meta.storage_alignments)
            .with_pending_global_alignments(context.pending_global_alignments)
            .with_generic_readiness(context.generics)
            .with_local_readiness(&self.meta.local_declarations)
            .with_callback_proof(&proof))
        .and_then(|provider| provider.with_compiler(context.compiler))
        .and_then(|provider| provider.with_runtime(&bindings.runtime))
        .and_then(|provider| provider.with_file_abi(&bindings.file_abi))
        .and_then(|provider| provider.with_heap_abi(&bindings.heap_abi))
        .and_then(|provider| provider.with_process_abi(&bindings.process_abi))
        .map_err(|error| jai_source::Diagnostic::at_source(location, error.to_string()))?;
        let retained = context.cache.compiler_continuations.borrow_mut().remove(&key);
        let mut vm = match retained {
            Some(run) => Vm::with_continuation(&provider, BorrowedEffects(context.effects), run.state),
            None => new_vm(&provider, BorrowedEffects(context.effects), context.limits, context.target, Some(&context.cache.state)),
        }.map_err(|error| jai_source::Diagnostic::at_source(location, error.to_string()))?;
        let mut progress = if resume { vm.resume_resumable() } else {
            vm.start_resumable_compiler_code(&plan.plan, context.owner, origin)
        };
        let publication = loop {
            match progress.outcome {
                jai_vm::ResumableOutcome::Suspended(dependencies) => {
                    match context.effects.service_pending(&dependencies) {
                        Ok(true) => { progress = vm.resume_resumable(); continue; }
                        Ok(false) => {
                            if !run.flags.stallable && dependencies.iter().any(|dependency| matches!(dependency, Dependency::Effect(_) | Dependency::Host(_))) {
                                let canceled = vm.cancel_resumable();
                                context.cache.state.replace(Some(vm.into_state()));
                                return Err(jai_source::Diagnostic::at_source(location, canceled.err().map_or_else(|| "compiler or host dependencies require #run,stallable".into(), |error| error.to_string())));
                            }
                            let state = vm.into_continuation().map_err(|error| jai_source::Diagnostic::at_source(location, error.to_string()))?;
                            context.cache.compiler_continuations.borrow_mut().insert(key, SuspendedCompilerRun { state, dependencies: dependencies.clone(), location, plan });
                            context.record_pending(dependencies);
                            return Err(jai_source::Diagnostic::at_source(location, "compiler Code is suspended with its original frame and effect transaction"));
                        }
                        Err(error) => {
                            let canceled = vm.cancel_resumable();
                            context.cache.state.replace(Some(vm.into_state()));
                            return Err(jai_source::Diagnostic::at_source(location, canceled.err().unwrap_or(error).to_string()));
                        }
                    }
                }
                jai_vm::ResumableOutcome::AwaitingPublication => {
                    let mut source_error = None;
                    let publication = vm.finish_resumable_compiler_code(|vm, selection| {
                        CallbackCheck { proof: &proof, context, locals: &self.meta.local_declarations }.validate()?;
                        let quote = plan.quotation(selection.site()).ok_or(jai_vm::Error::InvalidIr("compiler return site has no genuine source quotation"))?;
                        match &destination {
                            CompilerDestination::Code => self.selected_compiler_quote(quote, &plan.lexical, vm, selection, context.limits).map(SelectedPublication::Code),
                            CompilerDestination::Declarations(request) => {
                                let code = self.compiler_declaration_insertion_code(quote, vm, selection, request.visibility, request.directive.scope, context.limits).and_then(|code| {
                                    self.graph_scope.unwrap().validate_compiler_insertion(request.file, &code, location)?;
                                    Ok(code)
                                });
                                code.map(SelectedPublication::Declarations).map_err(|error| {
                                    let message = error.message.clone();
                                    source_error = Some(error);
                                    jai_vm::Error::IrValidation(message)
                                })
                            }
                        }
                    });
                    match publication {
                        Ok(value) => { context.cache.state.replace(Some(vm.into_state())); break value; }
                        Err(jai_vm::Error::Type(jai_types::TypeError::Incomplete(ty))) => {
                            progress = jai_vm::ResumableExecution { outcome: jai_vm::ResumableOutcome::Suspended(vec![Dependency::Type(ty)]), statistics: progress.statistics };
                        }
                        Err(error) => {
                            context.cache.state.replace(Some(vm.into_state()));
                            return Err(source_error.unwrap_or_else(|| jai_source::Diagnostic::at_source(location, error.to_string())));
                        }
                    }
                }
                jai_vm::ResumableOutcome::Failed(error) => {
                    context.cache.state.replace(Some(vm.into_state()));
                    return Err(jai_source::Diagnostic::at_source(location, error.to_string()));
                }
            }
        };
        drop(provider);
        let publication = match publication {
            SelectedPublication::Code(value) => CompilerPublication::Code(self.retain_compiler_quote(value)?),
            SelectedPublication::Declarations(code) => CompilerPublication::Declarations(code),
        };
        context.cache.proofs.borrow_mut().remove(&key);
        context.cache.compiler_values.borrow_mut().insert(key, CompletedCompilerRun { publication: publication.clone(), proof });
        self.compiler_publication_result(publication, destination, location)
    }

    fn compiler_publication_result(
        &self,
        publication: CompilerPublication,
        destination: CompilerDestination<'_>,
        location: SourceSpan,
    ) -> Result<Option<CompilerRunResult>, jai_source::Diagnostic> {
        match (publication, destination) {
            (CompilerPublication::Code(id), CompilerDestination::Code) => Ok(Some(CompilerRunResult::Code(id))),
            (CompilerPublication::Declarations(code), CompilerDestination::Declarations(_)) => {
                Ok(Some(CompilerRunResult::Declarations(code)))
            }
            _ => Err(jai_source::Diagnostic::at_source(location, "compiler source publication destination changed")),
        }
    }

    fn compiler_source_plan(&mut self, run: &CompileTimeRun, location: SourceSpan) -> Result<Option<CompilerCodeSourcePlan>, jai_source::Diagnostic> {
        let context = self.compile_time.unwrap();
        let scope = self.graph_scope.ok_or_else(|| jai_source::Diagnostic::at_source(location, "compiler Code requires its original source graph"))?;
        let (key, body, named) = match &run.body {
            CompileTimeBody::Procedure { result, body } => {
                if self.lexical_annotation(result, location.span)? != self.types.code_type() { return Ok(None); }
                let key = self.meta.compiler_code.anonymous_key(scope.code_origin().0, location)?;
                (key, SourceBody::Anonymous(body), false)
            }
            CompileTimeBody::Expression(expression) => {
                if let jai_syntax::ExpressionKind::IndirectCall { callee, args } = &expression.kind
                    && let jai_syntax::ExpressionKind::AnonymousProcedure(procedure) = &callee.kind
                {
                    let [result] = procedure.results.as_slice() else { return Ok(None); };
                    let jai_syntax::ResultBinding::Typed { ty, default } = &result.binding else { return Ok(None); };
                    if self.lexical_annotation(ty, result.span)? != self.types.code_type() { return Ok(None); }
                    if !procedure.parameters.is_empty() || !args.is_empty() || default.is_some()
                        || procedure.expands || procedure.modify.is_some()
                    {
                        return Err(jai_source::Diagnostic::at_source(location,
                            "anonymous compiler Code requires a closed checked source header"));
                    }
                    let defining = SourceSpan { source: location.source, span: callee.span };
                    let key = self.meta.compiler_code.anonymous_key(scope.code_origin().0, defining)?;
                    return self.bind_compiler_source_body(key, SourceBody::Anonymous(&procedure.body), false).map(Some);
                }
                let (path, args) = match &expression.kind {
                    jai_syntax::ExpressionKind::Call(name, args) => (jai_syntax::NamePath { root: *name, members: vec![] }, args),
                    jai_syntax::ExpressionKind::QualifiedCall(path, args) => (path.clone(), args),
                    _ => return Ok(None),
                };
                let Some(template) = scope.compiler_code_template(&path, &self.meta.compiler_code, expression.span)? else { return Ok(None); };
                if !args.is_empty() { return Err(jai_source::Diagnostic::at_source(location, "closed compiler Code procedure takes no arguments")); }
                (template.key(), SourceBody::Named(template.source), true)
            }
            _ => return Ok(None),
        };
        self.bind_compiler_source_body(key, body, named).map(Some)
    }

    fn bind_compiler_source_body(
        &mut self,
        key: crate::compiler_code::CompilerCodeSourceKey,
        body: SourceBody<'_>,
        named: bool,
    ) -> Result<CompilerCodeSourcePlan, jai_source::Diagnostic> {
        let context = self.compile_time.unwrap();
        let scope = self.graph_scope.unwrap();
        let mut no_effects = jai_vm::NoEffects;
        let effects = SharedEffects::new(&mut no_effects);
        let cache = Cache::default();
        let binding = context.compiler_plan_for_source(context.owner, key.file(), key.location().source, &cache, &effects);
        let signatures = HashMap::new();
        let globals = HashMap::new();
        let mut resolver = crate::Resolver {
            expression_owner: self.expression_owner,
            debug: crate::debug_capture::Capture::new(Some(key.location().source)),
            checks: self.checks,
            local_scopes: if named { Default::default() } else { self.local_scopes.clone() },
            context: self.context,
            context_available: self.context_available,
            meta: self.meta,
            graph_scope: Some(if named { scope.in_file(key.file()) } else { scope }),
            compile_time: Some(&binding),
            target_layout: self.target_layout,
            procedure: context.owner,
            types: self.types,
            places: self.places,
            signatures: &signatures,
            symbols: self.symbols,
            scopes: if named { vec![HashMap::new()] } else { self.scopes.clone() },
            globals: &globals,
            locals: vec![],
            span: key.location().span,
            results: &[],
            loops: vec![], next_loop: 0, cleanups: vec![], active_push: None,
            next_push: 0, deferred_scopes: vec![], cleanup_context: None,
        };
        resolver.debug.enter_policy(self.debug.policy());
        let plan = resolver.bind_compiler_code(key, body.statements(), key.location().span);
        context.merge_pending_from(&binding);
        plan
    }
}
