//! Retain original alias requests and constants across genuine type readiness.
//! The cursor owns original declaration IDs and the evaluator for one graph.
use super::*;
use aggregates::parameterized::{PendingType, TypePreparation};

/// Only the preparation controller can create this source dependency.
/// VM dependencies remain separate in LibraryPending.dependencies.
#[derive(Clone, Copy, Debug)]
pub struct SourcePreparationPending {
    cause: PendingType,
}

impl SourcePreparationPending {
    pub(crate) fn new(cause: PendingType) -> Self {
        Self { cause }
    }

    pub fn location(self) -> SourceSpan {
        self.cause.location()
    }

    pub fn placeholder(self) -> Option<jai_modules::PlaceholderId> {
        match self.cause {
            PendingType::Placeholder(demand) => Some(demand.placeholder),
            PendingType::RecordModifier(_) => None,
        }
    }

    pub fn diagnostic(self, graph: &ModuleGraph) -> LocatedDiagnostic {
        self.cause.diagnostic(graph)
    }

    pub(crate) fn cause(self) -> PendingType {
        self.cause
    }
}

pub(super) enum AliasProgress {
    Complete,
    Pending(SourcePreparationPending),
}

pub(super) enum SelectedAliasProgress {
    Ready,
    NotAlias,
    Pending(SourcePreparationPending),
}

/// The owning phase supplies its retained nominal/type registries. The cursor
/// keeps the original graph identities and evaluator, and advances only after
/// the alias helper has published a real Ready representation.
pub(super) struct PendingAliases<'graph> {
    graph: &'graph ModuleGraph,
    constants: Constants<'graph>,
    sources: Vec<DeclarationId>,
    next: usize,
    pending: Option<SourcePreparationPending>,
}

impl<'graph> PendingAliases<'graph> {
    pub(super) fn new(graph: &'graph ModuleGraph, constants: Constants<'graph>) -> Self {
        let sources = graph
            .declarations()
            .iter()
            .filter_map(|source| {
                matches!(
                    source.syntax().kind,
                    FileDeclarationKind::TypeAlias(_) | FileDeclarationKind::Constant(_)
                )
                .then_some(source.id())
            })
            .collect();
        Self {
            graph,
            constants,
            sources,
            next: 0,
            pending: None,
        }
    }

    pub(super) fn drive(
        &mut self,
        declarations: &mut ScopedDeclarations<'graph>,
        types: &mut TypeRegistry,
        meta: &mut crate::reflection::MetaContext,
    ) -> Result<AliasProgress, LocatedDiagnostic> {
        self.check_graph(declarations)?;
        while let Some(&source) = self.sources.get(self.next) {
            let outcome = declarations.nominals.prepare_alias(
                self.graph,
                source,
                types,
                &mut meta.record_specializations,
                &mut |file, expression| self.constants.prepare_evaluate_lazy(file, expression),
            )?;
            match outcome {
                None | Some(TypePreparation::Ready(_)) => {
                    self.pending = None;
                    self.next += 1;
                }
                Some(TypePreparation::Pending(cause)) => {
                    let pending = SourcePreparationPending::new(cause);
                    self.pending = Some(pending);
                    return Ok(AliasProgress::Pending(pending));
                }
            }
        }
        Ok(AliasProgress::Complete)
    }

    pub(super) fn prepare_global_annotations(
        &mut self,
        declarations: &mut ScopedDeclarations<'graph>,
        types: &mut TypeRegistry,
        meta: &mut crate::reflection::MetaContext,
    ) -> Result<AliasProgress, LocatedDiagnostic> {
        for source in self.graph.declarations() {
            let FileDeclarationKind::Global(global) = &source.syntax().kind else { continue };
            let annotation = match &global.declaration {
                syntax::Declaration::UnresolvedExplicit { ty, .. }
                | syntax::Declaration::External { ty, .. } => ty,
                _ => continue,
            };
            match aggregates::parameterized::prepare_type_paired(
                self.graph,
                aggregates::parameterized::TypeRequest::new(source.file(), annotation, global.span),
                types, &declarations.nominals, &mut meta.record_specializations,
                &mut |file, expression| self.constants.prepare_evaluate_lazy(file, expression),
            )? {
                TypePreparation::Ready(ty) => { declarations.nominals.value_types.insert(source.id(), ty); }
                TypePreparation::Pending(cause) => {
                    let pending = SourcePreparationPending::new(cause);
                    self.pending = Some(pending);
                    return Ok(AliasProgress::Pending(pending));
                }
            }
        }
        Ok(AliasProgress::Complete)
    }

    /// A checked prerequisite may request a later original alias without
    /// advancing the blocked prefix or replacing its retained wait cause.
    pub(super) fn drive_selected(
        &mut self,
        source: DeclarationId,
        declarations: &mut ScopedDeclarations<'graph>,
        types: &mut TypeRegistry,
        meta: &mut crate::reflection::MetaContext,
    ) -> Result<SelectedAliasProgress, LocatedDiagnostic> {
        self.check_graph(declarations)?;
        if !self.sources.contains(&source) {
            return Err(self.lifecycle_error("selected alias is not an original alias candidate"));
        }
        match declarations.nominals.prepare_alias(
            self.graph,
            source,
            types,
            &mut meta.record_specializations,
            &mut |file, expression| self.constants.prepare_evaluate_lazy(file, expression),
        )? {
            None => Ok(SelectedAliasProgress::NotAlias),
            Some(TypePreparation::Ready(_)) => Ok(SelectedAliasProgress::Ready),
            Some(TypePreparation::Pending(cause)) => Ok(SelectedAliasProgress::Pending(
                SourcePreparationPending::new(cause),
            )),
        }
    }

    fn check_graph(
        &self,
        declarations: &ScopedDeclarations<'graph>,
    ) -> Result<(), LocatedDiagnostic> {
        if std::ptr::eq(self.graph, declarations.graph) {
            Ok(())
        } else {
            Err(self.lifecycle_error("alias continuation belongs to another source graph"))
        }
    }

    fn lifecycle_error(&self, message: &str) -> LocatedDiagnostic {
        let location = self
            .pending
            .map(SourcePreparationPending::location)
            .or_else(|| {
                self.sources
                    .get(self.next)
                    .and_then(|&source| self.graph.declaration(source))
                    .map(|source| source.location())
            })
            .unwrap_or_else(|| SourceSpan {
                source: self
                    .graph
                    .file(self.graph.module(self.graph.root()).unwrap().entry())
                    .unwrap()
                    .source(),
                span: Span::default(),
            });
        LocatedDiagnostic {
            location,
            message: message.into(),
        }
    }

    pub(super) fn constants_mut(&mut self) -> &mut Constants<'graph> {
        &mut self.constants
    }

    pub(super) fn pending(&self) -> Option<SourcePreparationPending> {
        self.pending
    }

    /// Annotation requests retain their defining declaration; no representation
    /// or primitive fact is published until the paired evaluator is ready.
    pub(super) fn prepare_annotations(
        &mut self,
        declarations: &mut ScopedDeclarations<'graph>,
        types: &mut TypeRegistry,
        meta: &mut crate::reflection::MetaContext,
    ) -> Result<AliasProgress, LocatedDiagnostic> {
        for source in self.graph.declarations() {
            let FileDeclarationKind::Constant(constant) = &source.syntax().kind else {
                continue;
            };
            let Some(annotation) = &constant.ty else {
                continue;
            };
            if self.constants.annotation(source.id()).is_some() {
                continue;
            }
            match aggregates::parameterized::prepare_type_paired(
                self.graph,
                aggregates::parameterized::TypeRequest::new(
                    source.file(),
                    annotation,
                    constant.span,
                ),
                types,
                &declarations.nominals,
                &mut meta.record_specializations,
                &mut |file, expression| self.constants.prepare_evaluate_lazy(file, expression),
            )? {
                TypePreparation::Ready(ty) => {
                    self.constants
                        .register_annotation(source.id(), ty, types)
                        .map_err(|error| {
                            located(
                                self.graph,
                                source.file(),
                                Diagnostic::new(constant.span, error.to_string()),
                            )
                        })?;
                    declarations.nominals.value_types.insert(source.id(), ty);
                }
                TypePreparation::Pending(cause) => {
                    let pending = SourcePreparationPending::new(cause);
                    self.pending = Some(pending);
                    return Ok(AliasProgress::Pending(pending));
                }
            }
        }
        Ok(AliasProgress::Complete)
    }

    pub(super) fn prepare_independent_headers(
        &mut self,
        declarations: &mut ScopedDeclarations<'graph>,
        types: &mut TypeRegistry,
        meta: &mut crate::reflection::MetaContext,
    ) -> Result<Option<SourcePreparationPending>, LocatedDiagnostic> {
        let mut pending = None;
        for source in procedure_headers::ordered_sources(self.graph, &declarations.callable_aliases)? {
            if declarations.source_procedures.get(source.id()).is_none()
                || declarations.signatures.contains_key(&source.id())
            { continue; }
            if procedure_headers::source_dependencies(self.graph, &declarations.callable_aliases, source)
                .iter().any(|dependency| !declarations.signatures.contains_key(dependency))
            { continue; }
            let (parameters, results) = match &source.syntax().kind {
                FileDeclarationKind::Procedure(procedure) => (&procedure.parameters, &procedure.results),
                FileDeclarationKind::ProcedurePrototype(prototype) => (&prototype.parameters, &prototype.results),
                _ => continue,
            };
            let mut ready = true;
            let annotations = parameters.iter().filter_map(|parameter| {
                match &parameter.binding {
                    syntax::ParameterBinding::RequiredType(ty)
                    | syntax::ParameterBinding::DefaultedType { ty: Some(ty), .. } => Some((ty, parameter.span)),
                    _ => None,
                }
            }).chain(results.iter().filter_map(|result| match &result.binding {
                syntax::ResultBinding::Typed { ty, .. } => Some((ty, result.span)),
                _ => None,
            }));
            for (annotation, span) in annotations {
                match aggregates::parameterized::prepare_type_paired(
                    self.graph,
                    aggregates::parameterized::TypeRequest::new(source.file(), annotation, span),
                    types,
                    &declarations.nominals,
                    &mut meta.record_specializations,
                    &mut |file, expression| self.constants.prepare_evaluate_lazy(file, expression),
                )? {
                    TypePreparation::Ready(_) => {}
                    TypePreparation::Pending(cause) => {
                        ready = false;
                        pending.get_or_insert(SourcePreparationPending::new(cause));
                        break;
                    }
                }
            }
            if ready {
                procedure_headers::register_selected(
                    self.graph, source, types, declarations, &mut self.constants, meta,
                )?;
            }
        }
        Ok(pending)
    }

    pub(super) fn prepare_scalars(
        &mut self,
        declarations: &mut ScopedDeclarations<'graph>,
        deferred: &std::collections::HashSet<DeclarationId>,
        consumed: &std::collections::HashSet<DeclarationId>,
        nominal: &std::collections::HashSet<DeclarationId>,
    ) -> Result<AliasProgress, LocatedDiagnostic> {
        for source in self.graph.declarations() {
            if !matches!(source.syntax().kind, FileDeclarationKind::Constant(_))
                || declarations.values.contains_key(&source.id())
                || declarations.nominals.is_type_alias(self.graph, source.id())
                || consumed.contains(&source.id())
                || declarations.callable_aliases.contains_key(&source.id())
                || deferred.contains(&source.id())
                || nominal.contains(&source.id())
                || self.constants.has_typed_annotation(source.id())
                || sequence_constants::is_sequence_constant(self.graph, source)
            {
                continue;
            }
            match self
                .constants
                .prepare_value(source.id(), source.location())?
            {
                constants::ScalarPreparation::Ready(value) => {
                    declarations
                        .values
                        .insert(source.id(), Binding::Constant(value));
                }
                constants::ScalarPreparation::Pending(cause) => {
                    let pending = SourcePreparationPending::new(cause);
                    self.pending = Some(pending);
                    return Ok(AliasProgress::Pending(pending));
                }
            }
        }
        Ok(AliasProgress::Complete)
    }

    /// Finishing an incomplete cursor returns its original retained state.
    /// The controller must not discard unfinished requests or their evaluator.
    pub(super) fn into_constants(self) -> Result<Constants<'graph>, Self> {
        if self.next == self.sources.len() {
            Ok(self.constants)
        } else {
            Err(self)
        }
    }
}
