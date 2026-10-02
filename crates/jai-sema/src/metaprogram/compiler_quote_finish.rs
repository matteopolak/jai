//! Source capture conversion occurs while the selected compiler frame is live.
use super::compiler_quotes::{CompilerQuoteBinding, CompilerQuoteTemplate};
use super::declaration_capture::SourceBinding;
use super::*;
use jai_modules::DeclarationInsertionCode;
use jai_vm::{CompilerCodeSelection, CompilerEffects, Limits, ProcedureProvider, Vm};

impl Resolver<'_> {
    pub(crate) fn compiler_declaration_insertion_code<P, E>(
        &self,
        template: &CompilerQuoteTemplate,
        vm: &Vm<'_, P, E>,
        selected: &CompilerCodeSelection<'_>,
        visibility: syntax::Visibility,
        mode: syntax::InsertScope,
        limits: Limits,
    ) -> Result<DeclarationInsertionCode, Diagnostic>
    where
        P: ProcedureProvider + ?Sized,
        E: CompilerEffects,
    {
        let source = template.source();
        let location = source.location;
        if selected.site() != template.site()
            || selected.frame().plan() != template.plan()
            || selected.captures() != template.captures()
        {
            return Err(Diagnostic::at_source(
                location,
                "compiler quotation was selected by another plan, frame, or return site",
            ));
        }
        let items = super::declaration_members::literal_file_items(
            template.body(),
            location.source,
            visibility,
        )
        .map_err(|error| error.with_fallback_source(location.source))?;
        let mut bindings = Vec::new();
        let mut values = Vec::new();
        if mode == syntax::InsertScope::Captured {
            let mut effective = HashMap::new();
            for frame in template.frames() {
                for (name, binding) in frame.iter() {
                    effective.insert(*name, binding);
                }
            }
            let mut effective = effective.into_iter().collect::<Vec<_>>();
            effective.sort_by_key(|(name, _)| self.symbols.name(*name));
            let mut nodes = 0;
            let mut bytes = 0;
            let mut snapshots = HashMap::new();
            for (name, binding) in effective {
                lexical_keys::charge(
                    &mut nodes,
                    1,
                    lexical_keys::MAX_LEXICAL_NODES,
                    location.span,
                )?;
                let binding = match binding {
                    CompilerQuoteBinding::Static(binding) => self.source_insertion_binding(
                        binding.clone(),
                        location,
                        &mut nodes,
                        &mut bytes,
                    )?,
                    CompilerQuoteBinding::Native { slot, ty } => {
                        if let std::collections::hash_map::Entry::Vacant(entry) =
                            snapshots.entry(*slot)
                        {
                            let (actual, value) =
                                selected.native_value(*slot).map_err(|error| {
                                    Diagnostic::at_source(location, error.to_string())
                                })?;
                            if actual != *ty {
                                return Err(Diagnostic::at_source(
                                    location,
                                    "compiler quotation selected a native capture with another type",
                                ));
                            }
                            let value = crate::compile_time::materialize_compiler_capture(
                                vm, self.types, *ty, value, limits,
                            )
                            .map_err(|error| Diagnostic::at_source(location, error.to_string()))?;
                            entry.insert(value);
                        }
                        let value = snapshots.get(slot).expect("selected slot was materialized");
                        // Materialize one live slot once, but charge every
                        // retained source alias before its portable clone.
                        lexical_keys::charge_constant(
                            value,
                            &mut nodes,
                            &mut bytes,
                            location.span,
                        )?;
                        self.source_insertion_constant(value, location, &mut nodes, &mut bytes)?
                    }
                };
                match binding {
                    SourceBinding::Graph(binding) => bindings.push((name, binding)),
                    SourceBinding::Value(value) => values.push((name, value)),
                }
            }
        }
        let policy = |mode: jai_ir::CheckMode| {
            if mode.enabled() {
                syntax::CheckPolicy::Inherited
            } else {
                syntax::CheckPolicy::Disabled
            }
        };
        Ok(DeclarationInsertionCode {
            file: source.file,
            source_file: source.source_file,
            location,
            items,
            bindings,
            values,
            checks: syntax::SafetyChecks {
                array_bounds: policy(source.checks.array_bounds),
                arithmetic_overflow: policy(source.checks.arithmetic_overflow),
            },
            debug: source.debug,
            origins: source.origins.clone(),
        })
    }
}
