//! Declaration queries retain compiler Code and validate its graph transport.
use super::*;

pub(super) fn evaluate(
    request: &jai_modules::DeclarationInsertionRequest,
    context: &crate::compile_time::Context<'_>,
    declarations: &ScopedDeclarations<'_>,
    types: &mut TypeRegistry,
    places: &mut PlaceRegistry,
    meta: &mut crate::reflection::MetaContext,
) -> Result<jai_modules::DeclarationInsertionCode, LocatedDiagnostic> {
    let expression = &request.directive.value;
    if !request.directive.replacements.is_empty() {
        return Err(LocatedDiagnostic {
            location: request.location,
            message: "file declaration insertion cannot replace procedural loop controls".into(),
        });
    }
    if !matches!(
        expression.kind,
        syntax::ExpressionKind::Code(_)
            | syntax::ExpressionKind::Name(_)
            | syntax::ExpressionKind::QualifiedName(_)
    ) {
        return Err(LocatedDiagnostic {
            location: request.location,
            message: "declaration insertion producer requires a retained compiler Code query; effectful Code producers are not available in this phase".into(),
        });
    }
    discovery_conditions::with_source_resolver(
        discovery_conditions::SourceRequest {
            file: request.file,
            purpose: discovery_conditions::SourceRequestPurpose::Condition,
            expression,
            lexical: None,
            assertion: None,
            substitution: None,
        },
        context,
        declarations,
        types,
        places,
        meta,
        |resolver| {
            let crate::Expr::Code(id) = resolver.expr(expression)? else {
                return Err(Diagnostic::at_source(
                    request.location,
                    "declaration insertion requires a captured Code value",
                ));
            };
            let code = resolver.declaration_insertion_code(
                id,
                request.visibility,
                request.directive.scope,
                request.directive.span,
            )?;
            declarations
                .graph
                .validate_insertion_code(request.file, &code)
                .map_err(|error| Diagnostic::at_source(request.location, error.to_string()))?;
            Ok(code)
        },
    )
}
