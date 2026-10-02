//! Native compiler slots become source facts while the selected frame is live.
use super::compiler_quotes::{CompilerQuoteBinding, CompilerQuoteSource, CompilerQuoteTemplate};
use super::*;
use jai_ir::ConstantValue;
use jai_vm::{CompilerCodeSelection, CompilerEffects, Limits, ProcedureProvider, Vm};

#[derive(Clone)]
pub(crate) struct PublishedCompilerQuote {
    body: syntax::CodeBody,
    source: CompilerQuoteSource,
    frames: Vec<Vec<(Symbol, PublishedBinding)>>,
    lexical: crate::local_declarations::LocalScopes,
}

#[derive(Clone)]
enum PublishedBinding {
    Static(Binding),
    Native(ConstantValue),
}

impl Resolver<'_> {
    pub(crate) fn selected_compiler_quote<P, E>(
        &self,
        template: &CompilerQuoteTemplate,
        lexical: &crate::local_declarations::LocalScopes,
        vm: &Vm<'_, P, E>,
        selected: &CompilerCodeSelection<'_>,
        limits: Limits,
    ) -> Result<PublishedCompilerQuote, jai_vm::Error>
    where
        P: ProcedureProvider + ?Sized,
        E: CompilerEffects,
    {
        if selected.site() != template.site()
            || selected.frame().plan() != template.plan()
            || selected.captures() != template.captures()
        {
            return Err(jai_vm::Error::InvalidIr(
                "compiler quotation belongs to another selected plan or frame",
            ));
        }
        let inputs = selected
            .captures()
            .iter()
            .map(|&slot| {
                let (ty, value) = selected.native_value(slot)?;
                Ok((slot, ty, value))
            })
            .collect::<Result<Vec<_>, jai_vm::Error>>()?;
        let snapshots: HashMap<_, _> = crate::compile_time::materialize_compiler_captures(
            vm, self.types, &inputs, limits,
        )?
        .into_iter()
        .collect();
        let mut frames = Vec::with_capacity(template.frames().len());
        for frame in template.frames() {
            let mut published = Vec::with_capacity(frame.len());
            for (name, binding) in frame {
                let binding = match binding {
                    CompilerQuoteBinding::Static(binding) => PublishedBinding::Static(binding.clone()),
                    CompilerQuoteBinding::Lexical(storage) => PublishedBinding::Static(Binding::Storage(*storage)),
                    CompilerQuoteBinding::Native { slot, ty } => {
                        let value = snapshots.get(slot).ok_or(jai_vm::Error::InvalidIr(
                            "selected compiler quotation capture is absent",
                        ))?;
                        if value.ty != *ty {
                            return Err(jai_vm::Error::InvalidIr(
                                "selected compiler quotation capture type changed",
                            ));
                        }
                        PublishedBinding::Native(value.clone())
                    }
                };
                published.push((*name, binding));
            }
            frames.push(published);
        }
        Ok(PublishedCompilerQuote {
            body: template.body().clone(),
            source: template.source().clone(),
            frames,
            lexical: lexical.clone(),
        })
    }

    /// Called only after the VM's sole transaction commit. This allocates a
    /// compiler Code identity, with no VM value or native procedure signature.
    pub(crate) fn retain_compiler_quote(
        &mut self,
        quote: PublishedCompilerQuote,
    ) -> Result<CodeValueId, Diagnostic> {
        let source = quote.source;
        let mut frames = vec![];
        for frame in quote.frames {
            let mut bindings = HashMap::new();
            for (name, binding) in frame {
                let binding = match binding {
                    PublishedBinding::Static(binding) => binding,
                    PublishedBinding::Native(value) => crate::compile_time::materialized_binding(
                        value, None, source.location.span, self.meta,
                    )?,
                };
                bindings.insert(name, binding);
            }
            frames.push(bindings);
        }
        let previous_scopes = std::mem::replace(&mut self.scopes, frames);
        let previous_lexical = std::mem::replace(&mut self.local_scopes, quote.lexical);
        let previous_scope = self.graph_scope;
        self.graph_scope = previous_scope.map(|scope| scope.in_file(source.file));
        let previous_source = self.debug.replace_source(Some(source.location.source));
        let previous_checks = std::mem::replace(&mut self.checks, source.checks);
        let result = (|| {
            let mut key = self.capture_key(source.location.span)?;
            let mut capture = self.capture_scope(source.location.span)?;
            key.source_file = source.source_file;
            key.debug = source.debug;
            key.expansion_origins = source.origins.iter().map(|origin| (origin.source, origin.span.start, origin.span.end)).collect();
            capture.source_file = source.source_file;
            capture.debug = source.debug;
            capture.expansion_origins = source.origins;
            Ok(self.meta.codes.capture(key, quote.body, capture))
        })();
        self.scopes = previous_scopes;
        self.local_scopes = previous_lexical;
        self.graph_scope = previous_scope;
        self.debug.replace_source(previous_source);
        self.checks = previous_checks;
        result
    }
}
