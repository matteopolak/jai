//! Compiler-only source lookup has no native signature adapter.
use super::*;

impl<'a> FileScope<'a> {
    pub(crate) fn compiler_code_template(
        &self,
        path: &NamePath,
        registry: &crate::compiler_code::CompilerCodeRegistry,
        span: Span,
    ) -> Result<Option<crate::compiler_code::CompilerCodeTemplate>, Diagnostic> {
        let Ok(id) = self.declaration(path, span) else {
            return Ok(None);
        };
        Ok(registry.template(id).cloned())
    }

    pub(crate) fn in_file(self, file: FileInstanceId) -> Self {
        Self {
            file,
            substitution: None,
            ..self
        }
    }

    pub(crate) fn validate_compiler_insertion(
        &self,
        file: FileInstanceId,
        code: &jai_modules::DeclarationInsertionCode,
        location: jai_source::SourceSpan,
    ) -> Result<(), Diagnostic> {
        self.declarations.graph.validate_insertion_code(file, code)
            .map_err(|error| Diagnostic::at_source(location, error.to_string()))
    }
}
