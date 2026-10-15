# Generator modifier helpers

All eight names in [implementation-scope.json](implementation-scope.json) are
implemented in `stdlib/Bindings_Generator/modifiers.jai`, with private algorithms
in `stdlib/internal/developer-tools/generator-modifiers.jai`. The clean integrator
loaded the public file in the canonical façade; tests use actual public imports.

- `add_access_flags(decl, cur)` queries libclang's C++ access specifier and adds
  PROTECTED or PRIVATE to the canonical declaration. Other flags remain intact;
  public/invalid access adds no flag. Repeated calls are idempotent. Callers
  provide a valid declaration; no new null-input contract is asserted.
- `function_has_a_valist_arg(func)` scans the represented function's parameters
  with the canonical public `is_va_list` predicate, returning true on the first
  match. It does not inspect the result type or infer va_list from VARIADIC.
  Callers provide a valid function, CType and Function_Type with valid argument
  declarations. No argument, type, or signature storage is changed.

- `shared_type(t)` sets SHARED and returns the same object. `add_type_flags(t,
  flags)` modifies unshared objects in place. Shared inputs produce separate
  shallow copies, clearing SHARED before adding the requested flags, including
  SHARED if requested. Even a zero requested flag mask copies a shared input.
  Child records and dynamic-array backing storage remain borrowed aliases.
- `append_calling_convention_directives` skips Objective-C methods, emits
  `#cpp_method` for C++ methods or `#c_call` unless foreign is assumed, then adds
  the non-POD struct-return directive according to the active options' OS.
  Windows uses constructor presence; other targets use copy/move constructor or
  destructor presence. Typedef-wrapped struct returns are resolved. Variadic
  metadata adds no directive.
- `append_type_info_directives` prefers TYPE_INFO_NONE over
  TYPE_INFO_PROCEDURES_ARE_VOID_POINTERS and emits nothing when neither is set.
- `check_if_foreign_function_should_be_omitted` tests enabled policies in order:
  va_list parameters, missing library, inline. Missing-library classification
  exempts virtual (including pure-virtual) functions and Objective-C methods;
  a later inline policy can still match. The first match sets OMIT_FROM_OUTPUT,
  increments the active generator's stripped count and optionally logs a reason.
- `should_be_moved_to_global_scope` accepts the canonical extern/elsewhere
  classification; it also accepts functions when the active movement option is
  enabled or the canonical operator predicate matches. Other declarations stay.

## Shared active state and independent policies

`Bindings_Generator/active-context.jai` imports the single
`Bindings_Generator_Context` module before context-layout-dependent imports.
That module declares exactly two borrowed pointer slots, `context.generator`
and `context.generator_options`, plus accessors. Both slots use `*void` so
different nominal TARGET_OS module instances share one pair of fields. The
private modifier helper casts each slot to its own canonical Generator/options
type and diagnoses missing required state with an assertion. No record is
duplicated and there is no secondary registry, ownership system or activation
stack. Caller activation is explicit:

```jai
generator: B.Generator;
options: B.Generate_Bindings_Options;
push_context {
    context.generator = *generator;
    context.generator_options = *options;
    // Call contextual B helpers here.
}
```

The caller retains both objects for the call duration and activates objects
from the same module instance as the helper. `push_context` restores nested
activation normally. Model/tools lifecycle owners should adopt these slots;
this batch does not edit their lifecycle implementation. That coordination is
recorded in [worker-inbox.md](worker-inbox.md).

Unspecified details are resolved independently: requested flags use the current
allocator for a shallow CType copy, whose record may be freed by that allocator
without freeing borrowed children; directive fragments include leading spaces;
the return ABI uses active `options.os`; omission counting is once per matching
invocation, including a repeat invocation on an already omitted declaration.
Diagnostic wording is private, but the reason identifies the first matched
policy. Valid canonical input records are required; no new null-input guarantee
is asserted. Existing access/va_list policies did not require correction under
the refreshed reviewed contract.

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
It checks repository jaifmt formatting and warnings-denied contextual jailint
with measured coverage of all seven changed Jai files. Two public-import
fixtures run eight Windows/Linux x64/ARM64 source checks, two interpreter
executions and four Mac ARM64 native O0/O2 executions. Existing canonical model
and real-libclang model fixtures additionally pass interpreter regression checks.
Each execution expects exactly `ok\n`; Windows/Linux checks establish source
validity only. The command/result evidence is written to
`$CARGO_TARGET_DIR/generator-modifiers-evidence.json`.

The fixture tests Windows/Mac/Linux/iOS option policies on the Mac host. The
second fixture imports default, Windows and iOS nominal module instances
together and exercises matching canonical option/generator activation and nested
restoration. An actual `-os ios -cpu arm64` source request was rejected with
`unknown OS ios`: this compiler supports linux/windows/macos/wasm target names.
There is no native iOS execution claim. Nominal iOS module source and host policy
execution are measured separately from unsupported native target selection.

## Remaining scope and deviations

No hacks, stubs, duplicate canonical records, compiler exceptions, peer
scaffolding edits or publication were introduced. The deviation from the full
assignment reported in the first batch is resolved: all eight public names are
integrated and tested. A dedicated review found no confirmed implementation
defect and prompted repeat-count, typedef-result and nominal iOS regression
coverage. Lifecycle adoption remains a handoff to its owners, not a missing
assigned helper. Machine-readable status is in
[implementation-remaining.json](status/implementation-remaining.json).
