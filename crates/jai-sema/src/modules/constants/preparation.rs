//! Retain scalar source dependencies without turning rendered text into control flow.
use super::*;
use crate::modules::aggregates::parameterized::PendingType;

pub(crate) enum ScalarPreparation {
    Ready(ScalarConstant),
    Pending(PendingType),
}

impl Constants<'_> {
    pub(super) fn prepare_value(
        &mut self,
        id: DeclarationId,
        site: SourceSpan,
    ) -> Result<ScalarPreparation, LocatedDiagnostic> {
        match self.states.get(&id) {
            Some(ConstantState::Ready(value)) => {
                return Ok(ScalarPreparation::Ready(value.clone()));
            }
            Some(ConstantState::Visiting) => {
                return self.ready(id, site).map(ScalarPreparation::Ready);
            }
            None => {}
        }
        if self
            .states
            .values()
            .filter(|state| matches!(state, ConstantState::Visiting))
            .count()
            >= 256
        {
            return Err(LocatedDiagnostic {
                location: site,
                message: "scalar preparation exceeds constant dependency depth limit".into(),
            });
        }
        let declaration = self
            .graph
            .declaration(id)
            .expect("resolved declaration exists");
        let FileDeclarationKind::Constant(constant) = &declaration.syntax().kind else {
            return self.ready(id, site).map(ScalarPreparation::Ready);
        };
        let file = declaration.file();
        let constant = constant.clone();
        let target = self
            .primitive_annotations
            .get(&id)
            .copied()
            .or(match constant.ty.as_ref() {
                Some(syntax::TypeSyntax::Builtin(syntax::BuiltinType::Scalar(ty))) => {
                    Some(PrimitiveAnnotation::Scalar(*ty))
                }
                Some(syntax::TypeSyntax::Builtin(syntax::BuiltinType::Float(ty))) => {
                    Some(PrimitiveAnnotation::Float(*ty))
                }
                _ => None,
            });
        self.states.insert(id, ConstantState::Visiting);
        let result = self.prepare_expression(file, &constant.initializer, target).and_then(|result| {
            match result {
                ScalarPreparation::Pending(cause) => Ok(ScalarPreparation::Pending(cause)),
                ScalarPreparation::Ready(value) => {
                    let value = match target {
                        Some(PrimitiveAnnotation::Scalar(ty)) => value.coerce(ty, constant.span)
                            .map_err(|error| located(self.graph, file, error))?,
                        Some(PrimitiveAnnotation::Float(_)) => value,
                        None if constant.ty.is_none() => value,
                        None => return Err(located(self.graph, file, Diagnostic::new(constant.span,
                            "typed constant annotation requires canonical semantic resolution"))),
                    };
                    Ok(ScalarPreparation::Ready(value))
                }
            }
        });
        match &result {
            Ok(ScalarPreparation::Ready(value)) => {
                self.states.insert(id, ConstantState::Ready(value.clone()));
            }
            _ => {
                self.states.remove(&id);
            }
        }
        result
    }

    pub(super) fn prepare_evaluate_lazy(
        &mut self,
        file: FileInstanceId,
        expression: &Expression,
    ) -> Result<ScalarPreparation, LocatedDiagnostic> {
        self.prepare_expression(file, expression, None)
    }

    fn prepare_expression(
        &mut self,
        file: FileInstanceId,
        expression: &Expression,
        target: Option<PrimitiveAnnotation>,
    ) -> Result<ScalarPreparation, LocatedDiagnostic> {
        let graph = self.graph;
        let mut pending = None;
        let mut lookup =
            |path: &NamePath, span: Span| match self.prepare_scalar_path(file, path, span) {
                Ok(ScalarPreparation::Ready(value)) => Ok(value),
                Ok(ScalarPreparation::Pending(cause)) => {
                    pending.get_or_insert(cause);
                    let diagnostic = cause.diagnostic(graph);
                    Err(Diagnostic::at_source(
                        diagnostic.location,
                        diagnostic.message,
                    ))
                }
                Err(error) => Err(Diagnostic::at_source(error.location, error.message)),
            };
        let result = match target {
            Some(PrimitiveAnnotation::Float(float)) => {
                jai_eval::floats::evaluate_float_paths(expression, float, &mut lookup)
                    .map(ConstantValue::Float)
            }
            _ => jai_eval::evaluate_paths_with_overflow_check(
                expression,
                jai_types::CheckMode::Enabled,
                &mut lookup,
            ),
        };
        match pending {
            Some(cause) => Ok(ScalarPreparation::Pending(cause)),
            None => result
                .map(|value| {
                    ScalarPreparation::Ready(
                        value.with_fallback_source(graph.file(file).unwrap().source()),
                    )
                })
                .map_err(|error| located(graph, file, error)),
        }
    }

    fn prepare_scalar_path(
        &mut self,
        file: FileInstanceId,
        path: &NamePath,
        span: Span,
    ) -> Result<ScalarPreparation, LocatedDiagnostic> {
        let site = SourceSpan {
            source: self.graph.file(file).unwrap().source(),
            span,
        };
        if let Err(error) = self.graph.lookup(file, path)
            && let Ok(pending) = PendingType::from_lookup(error, site)
        {
            return Ok(ScalarPreparation::Pending(pending));
        }
        if let Some(value) = self.external_value(file, path, span)? {
            return Ok(ScalarPreparation::Ready(value));
        }
        let id = declaration_id(self.graph, file, path, span)
            .map_err(|error| located(self.graph, file, error))?;
        self.prepare_value(id, site)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use jai_modules::{GraphOptions, SourceOverlay};

    fn graph(source: &str) -> ModuleGraph {
        let path = std::path::Path::new("/jai-scalar-preparation/main.jai");
        let mut overlay = SourceOverlay::new();
        overlay.insert(path, source.as_bytes().to_vec()).unwrap();
        ModuleGraph::load_with_provider(path, GraphOptions::default(), &overlay).unwrap()
    }

    #[test]
    fn nested_placeholder_keeps_its_real_identity_and_rolls_back_unfinished_visits() {
        let text = "#placeholder Later; INNER::Later+1; OUTER::INNER+1; READY::42;";
        let graph = graph(text);
        let mut constants = Constants::new(&graph);
        let outer = &graph.declarations()[1];
        for _ in 0..2 {
            let result = constants
                .prepare_value(outer.id(), outer.location())
                .unwrap();
            let ScalarPreparation::Pending(PendingType::Placeholder(demand)) = result else {
                panic!("actual source lookup must retain the placeholder dependency");
            };
            assert_eq!(demand.placeholder, graph.placeholders()[0].id());
            assert_eq!(demand.location.span.text(text), "Later");
            assert!(
                constants
                    .states
                    .values()
                    .all(|state| !matches!(state, ConstantState::Visiting))
            );
        }
        let ready = &graph.declarations()[2];
        let ScalarPreparation::Ready(ScalarConstant::Literal(value)) = constants
            .prepare_value(ready.id(), ready.location())
            .unwrap()
        else {
            panic!()
        };
        assert_eq!(value, 42);
        let _ = constants
            .prepare_value(outer.id(), outer.location())
            .unwrap();
        assert!(matches!(
            constants.states.get(&ready.id()),
            Some(ConstantState::Ready(_))
        ));
    }

    #[test]
    fn scalar_source_errors_remain_errors_and_retry_without_false_cycles() {
        let graph = graph("VALUE::UNKNOWN+1;");
        let source = &graph.declarations()[0];
        let mut constants = Constants::new(&graph);
        for _ in 0..2 {
            let error = constants
                .prepare_value(source.id(), source.location())
                .err()
                .unwrap();
            assert!(!error.message.contains("cyclic"), "{error}");
            assert!(!constants.states.contains_key(&source.id()));
        }
    }
}
