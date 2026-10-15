# Default generic pointee construction and binding

The authorized NEW portable file-watcher description reports that a default
generic pointee fails a nominal constraint with `Box is not an instance of Box`,
while explicit `Box(void)` works. The user named
`../stdlib/pending/default-generic-pointer-constraint.jai`; reading that exact
path failed because it is absent in this snapshot. No alternate peer path was
searched. Only the named producer document's relevant description was read;
all new fixtures here are independently authored reductions. The identical
nominal-instance error is reproduced in `target/generic-pointers-red.log`.

## Cause and implementation

A bare all-default generic type in an ordinary type position already instantiates
its defaults. Pointer construction instead always interned a pointer to the
generic source descriptor. Such a source descriptor is not a concrete instance,
so nominal constraint matching correctly rejected it. `*Parcel` and
`*Parcel(void)` also had different type identities before the fix.

`sema/expr.rs` now constructs default pointees through the existing instance
binder/cache. `sema/structs.rs::poly_struct_has_defaults` centralizes the same
all-parameters-have-defaults rule used by `operand_as_type` in `sema/decls.rs`.
Required arguments still leave source descriptors available for generic patterns;
no nominal matcher, conversion ranking or diagnostic fallback is relaxed.
Default evaluation, dependent bindings and canonical instance interning reuse
the existing general machinery. Aliases retain the original declaration and
pointer/type/procedure-instance identity.

An independent negative control also exposed integer values accepted for an
unused `Type` parameter. `struct_arg_value` now validates such bindings through
the ordinary type-operand conversion before inserting their values/cache keys.
This applies to explicit/default/nested arguments and variadic Type elements;
it does not wait for a body/field to happen to use the parameter. Invalid bindings
retain `expected a type` errors. No public API or module-name check is added.

## Original regressions and evidence

Core `cleanroom_generic_pointers.rs` covers implicit/explicit void defaults,
aliases and nested pointer identity, dependent defaults, nested Type arguments,
nondefault instances, actual constraint-based field access and specialization
identity. Reflection verifies shared canonical pointee descriptors and shared
generic-source provenance while source and concrete instance remain distinct.
Invalid Type arguments/defaults, unrelated nominal records, nonpointer arguments
and mismatched explicit specializations remain errors.

`tests/compiler-semantics/default-generic-pointers.jai` is the positive standalone
fixture. LLVM's independent harness executes it natively on this ARM64 host and
as memory64 WASM under Node, both at O0/O2. Every failure code is decisive.
WASM memory intrinsics actually copy/fill memory; unexpected runtime imports
throw instead of fabricating successful results. This is focused backend
execution, not integrated portable File_Watcher or Windows/Linux runtime coverage.

Initial expanded-test setup corrections are separately retained:
`target/generic-pointers-expanded.log` used context-requiring helpers from a C-call
entry and put reflection definitions in main rather than the prelude. Helpers
are explicitly context-free and the scoped reviewed bootstrap is now registered
as the prelude. `target/generic-pointers-expanded-corrected.log` then exposed an
incorrect new oracle equating `type_info` of an all-default bare name with its
generic source. Existing type positions instantiate defaults; source provenance
is checked via `polymorph_source_struct` of two concrete instances instead.
Pointer descriptor equality and source/instance distinction remain required.
No implementation or assertion was weakened to accommodate these setup mistakes.

Focused commands:

```
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm PATH=/opt/homebrew/opt/llvm/bin:$PATH CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic -p jaic-llvm --test cleanroom_generic_pointers
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm PATH=/opt/homebrew/opt/llvm/bin:$PATH JAIC_STDLIB=$PWD/target/runtime-configuration-candidate/stdlib CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic -p jaic-llvm --all-targets --no-fail-fast
```

Full/focused verification and checkpoint status are recorded in compiler progress.
`target/generic-pointers-focused-final.log`: seven core cases plus native/WASM
O0/O2 execution pass. `target/generic-pointers-full-suite.log`: 325 pass, zero
failures, one inherited corpus sweep ignored. `target/generic-pointers-clippy.log`:
host core/LLVM all-target clippy -D warnings passes. Scoped rustfmt/item-spacing
and standalone fixture jaifmt --check pass. Strict linter uses rebuilt own tools
with the independent staged prelude, not any original library fallback.
`target/generic-pointers-jailint.log` records successful verbose strict lint of
the complete standalone fixture with no exclusions/suppressions.
No optimizer, assertion reporting hook, LSP recovery, peer source, Extensions,
reference implementation or quarantined input is changed/accessed.

## Bounds

The exact producer source could not be executed because it is missing at the
authorized path; the independently reproduced identical defect is fixed and
covered. Producer integration must rerun its actual restored fixture and watcher
checks. Required generic arguments are not invented; a bare source descriptor
does not become a concrete runtime object. No new rules for null Type arguments,
variadic-only implicit instantiation, arbitrary restriction expressions or
parameterized reflected-name spelling are claimed. Source/instance reflection
and existing constraint behavior remain as tested; wider contracts need reviewed
evidence rather than inferred convenience APIs. There is no new workaround,
unsafe operation, public export or performance fallback in the implemented scope.
