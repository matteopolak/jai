# Generator modifier helpers

This independent batch owns eight public names listed in
[implementation-scope.json](implementation-scope.json). Two are implemented in
`stdlib/Bindings_Generator/modifiers.jai`, with algorithms in
`stdlib/internal/developer-tools/generator-modifiers.jai`:

- `add_access_flags(decl, cur)` queries libclang's C++ access specifier and adds
  PROTECTED or PRIVATE to the canonical declaration. Other flags remain intact;
  public/invalid access adds no flag. Repeated calls are idempotent. Callers
  provide a valid declaration; no new null-input contract is asserted.
- `function_has_a_valist_arg(func)` scans the represented function's parameters
  with the canonical public `is_va_list` predicate, returning true on the first
  match. It does not inspect the result type or infer va_list from VARIADIC.
  Callers provide a valid function, CType and Function_Type with valid argument
  declarations. No argument, type, or signature storage is changed.

The façade owner must add `#load "modifiers.jai";` to the canonical module.
Until that handoff, the fixture directly loads the exact public helper file in a
scope importing the canonical module. Consequently helper behavior is tested,
but importer visibility from an unmodified module is not claimed.

## Verification

Tools were built from this checkout using `CARGO_BUILD_JOBS=2` and the assigned
T7 `CARGO_TARGET_DIR`; jaifmt was compiled from this checkout's `jaifmt/main.jai`.
The host fixture uses the installed official LLVM SDK's libclang through an
ignored local symlink. It parses an original unsaved C++ input, covering explicit
and implicit access, existing flags, repeat application and invalid access.
The parameter cases cover empty/nonmatching lists, canonical recognized typedef
spellings, matches in every position, multiple matches, variadic-only exclusion,
return-type exclusion and preservation of argument storage.

Run `python3 tools/check_generator_modifiers.py` with the assigned target path.
It checks repository jaifmt formatting, warnings-denied jailint with measured
coverage of all three owned Jai files, Windows/Linux x64/ARM64 source branches,
interpreter execution and Mac native O0/O2 compilation and execution. Each
execution expects exactly `ok\n`; successful Windows/Linux checks establish
source validity only. The command/result evidence is written to
`$CARGO_TARGET_DIR/generator-modifiers-evidence.json`.

## Remaining contracts and deviations

`shared_type`, `add_type_flags`, `append_calling_convention_directives`,
`append_type_info_directives`, `check_if_foreign_function_should_be_omitted`
and `should_be_moved_to_global_scope` remain absent. The reviewed specification
lists their signatures but does not establish copying/ownership, emitted
directives, omission side effects or movement policy. The active generator/options
context implementation is also absent from this baseline. Exact questions and
the façade integration request are in [worker-inbox.md](worker-inbox.md).

No hacks, stubs, duplicate canonical records, compiler exceptions, peer
scaffolding edits or publication were introduced. The deviation from the full
assignment is explicit: two tested helpers are ready for façade integration;
six helpers require reviewed public behavior before faithful implementation.
The dedicated review confirmed those gaps and found no demonstrated defect in
the two implemented helpers. Machine-readable status is in
[implementation-remaining.json](status/implementation-remaining.json).
