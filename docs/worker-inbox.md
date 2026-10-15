# Generator modifiers worker inbox

## 2026-10-15: integration and reviewed contract requests

Owned batch: add_access_flags, add_type_flags,
append_calling_convention_directives, append_type_info_directives,
function_has_a_valist_arg, check_if_foreign_function_should_be_omitted,
shared_type, should_be_moved_to_global_scope.

Façade owner: please load `modifiers.jai` from Bindings_Generator/module.jai.
The public file will load its independent private helper file. Until integration,
the original worker fixture loads the file into a scope importing the canonical
module; no canonical records or peer scaffolding will be duplicated or edited.

The reviewed `docs/specs/stdlib/modules/bindings-generator.md` contains these
eight signatures, but its Public behavior details do not define their policies.
Direct native access mapping and scanning arguments with the existing public
is_va_list operation can proceed. Narrow remaining questions:

1. shared_type/add_type_flags: does shared_type mark and return the same object,
   or allocate a shared copy? Does add_type_flags copy only SHARED inputs, clear
   SHARED on the result, retain borrowed child/template storage, and preserve
   identity when flags are already present? What owns new CType allocations?
2. append_calling_convention_directives: Function_Type contains flags but no
   calling convention field. Which flags/assume_foreign states emit which Jai
   directives? Are Objective-C methods exceptions, and is variadic printed here?
3. append_type_info_directives: define emitted directive names/order and the
   precedence when both type-info declaration flags are set.
4. check_if_foreign_function_should_be_omitted: define strip flags, inline,
   virtual/Objective-C/library exceptions, omission flag/counter/log effects and
   whether library resolution occurs here. Supply the canonical active options
   and Generator access protocol; no such context extension exists in this
   independent baseline. The worker will not create a second registry/context.
5. should_be_moved_to_global_scope: define the relevant declaration kinds,
   parent kinds, static/instance/virtual/Objective-C cases, omit flag interactions
   and the active move_struct_functions_to_global_scope option access protocol.

These requests concern public behavior, not routine internal architecture.
No original/reference source, history, peer checkout, or corpus body was read.

## 2026-10-15: tested partial handoff

`add_access_flags` and `function_has_a_valist_arg` are implemented in the public
and private files named above. Source-built T7 compiler/linter and source-built
jaifmt passed formatting, warnings-denied lint (all owned files measured), four
Windows/Linux x64/ARM64 source checks, interpreter and Mac native ARM64 O0/O2
execution with real SDK libclang access queries. Windows/Linux execution is not
claimed. A dedicated review found no demonstrated defect and confirmed that
the remaining six policies are absent from the reviewed behavior text.

See `docs/generator-modifiers.md` and `docs/status/implementation-remaining.json`.
The two helpers are ready for the coordinator-owned façade load. No shared
model/context/lifecycle file was edited. Six helpers remain absent, without
stubs, pending the narrow reviewed contracts above.
