# Generator modifier implementation plan

Use the reviewed inventory and canonical records in this independent checkout.
Keep public wrappers in `stdlib/Bindings_Generator/modifiers.jai` and algorithms
in `stdlib/internal/developer-tools/generator-modifiers.jai`. Do not modify the
shared façade or canonical model/context/lifecycle files.

1. Build jaic and jailint from this checkout in assigned T7 CARGO_TARGET_DIR,
   with CARGO_BUILD_JOBS=2; compile this checkout's jaifmt.
2. Write an original failing fixture for actual libclang C++ public/protected/
   private access and explicit Function_Type va_list arguments.
3. Implement access mapping and argument scanning using canonical SDK queries
   and the existing is_va_list predicate. Preserve unrelated flags and inputs.
4. Resolve the narrow remaining reviewed behavior questions in worker-inbox;
   implement resolved contracts with tests before code. Do not invent a context.
5. Format and lint owned files with warnings denied; execute interpreter and
   host Mac native O0/O2. Check Windows/Linux source branches separately.
6. Update feature documentation, docs index, and exact machine-readable status;
   commit only owned changes with Conventional Commits and report limitations.

The user explicitly requested immediate implementation and independent routine
architecture decisions; no additional design approval gate is introduced.
