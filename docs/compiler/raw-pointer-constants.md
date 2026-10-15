# Opaque pointer values and compile-time capture

Reviewed [Windows_Registry](../specs/stdlib/modules/windows-registry.md) declares
immutable `cast(HKEY) 0x800000xx` values, and reviewed Windows declares HKEY as a
HANDLE alias. These positive values must remain positive pointer bit patterns,
not sign-extended SDK macros, mutable replacements or fabricated allocations.
This work uses only reviewed declarations and original own scalar reductions;
no producer implementation or reference source was read.

## General fix

Nonzero integer-to-pointer casts missed scalar constant folding. Constant
evaluation consequently executed them and tried to freeze their pointees.
For *void that demanded a size which opaque handles do not have, causing
`a compile-time value holds a pointer to memory of unknown size`.

`sema/convert.rs` now folds integer-derived raw pointer constants as typed
scalar bits, masked using the language target pointer width. Zero retains the
canonical null value. Aliases retain the same canonical pointer type. No memory
probe, relocation or invented pointee allocation is needed to represent a raw
scalar address. Pointer-to-integer round trips and checked narrowing use the
existing constant conversion/range rules; trunc/no_check remains explicit.

An additional original regression caught a necessary consequence of representing
raw pointers as scalar constants: baked binders re-inferred the storage payload
as int. Procedure/struct binding now retains the checked operand type (or the
natural type of an untyped literal). Polymorphic cache keys explicitly pair
canonical TypeId with the value, so a pointer, integer and differently typed
pointer with equal bits cannot reuse the wrong instance. Struct reflection
arguments remain values in their existing order, separate from typed cache keys;
the existing relocation-aware variadic view keys are retained. Changes are in
calls.rs, structs.rs, procs.rs and the private cache-key helper in sema/mod.rs,
without changing Compiler field/drop order or any optimizer/runtime feature.

`sema/consteval.rs` reads opaque non-global #run pointer results as scalar values.
Aggregate capture preserves pointer bits when the pointee has no extent, rather
than claiming unknown bounds or reading data. Actual program-global addresses
still become relocations before this branch. Typed memory snapshots with known
extent retain their existing behavior. This removes no read/store/view checks
and introduces no unchecked dereference fallback. No interpreter runtime,
optimizer, reporting hook, LSP or public module implementation is changed.

## Original verification

`tests/compiler-semantics/raw-pointer-constants.jai` independently declares the
public alias shape HANDLE::*void, HKEY::HANDLE and immutable positive handles.
It tests globals, struct-field defaults, procedure defaults, comparisons,
integer round trips, #run scalar/record results, typed raw pointer constants,
and relocation/dereference of a real own global. Core tests also cover high
64-bit addresses, -1, null, explicit trunc/no_check and checked narrowing.
They assert that raw handle values create no frozen pointee storage.

Invalid low-address reads/writes still trap; a forged string with nonzero count
and unreadable data fails safe compiler-owned capture. These remain decisive
negative assertions. The tests never dereference a Registry handle value.

LLVM tests execute a C ABI driver on this native ARM64 host at O0/O2 and execute
memory64 WASM in Node at O0/O2. They inspect exact 8-byte global literal contents
and absence of pointee relocations, then a C caller verifies the returned value
is exactly 0x80000001. WASM memcpy/memset actually operate on memory; unexpected
failure imports throw. Existing real global relocations execute successfully.
The initial harness wrongly assumed #program_export applied to data globals;
own source only supports that directive on procedures. The assertion failure
remains in `target/raw-pointers-focused.log`; a C-call exported getter now
observes the same initializer, which is still inspected independently. No
production export behavior or immutable public constant was changed to evade it.

Evidence:

- `target/raw-pointers-red.log`: three original failures with the reported error.
- `target/raw-pointers-focused-final.log`: four core and two LLVM cases pass,
  including four actual native/WASM O0/O2 executions.
- `target/raw-pointers-baked-red.log`: original typed baked argument loses HKEY
  identity; `target/raw-pointers-baked-final.log`: five core cases pass after
  retaining types and separating typed procedure/struct instance cache keys.
- `target/raw-pointers-full-suite.log`: full available core/backend suite,
  331 pass, zero failures, one inherited corpus sweep ignored.
- `target/raw-pointers-full-suite-final.log`: after the typed-binding/key repair,
  332 pass, zero failures, one inherited corpus sweep ignored. Five core and
  two LLVM cases include native/WASM O0/O2 baked-value/cache controls.
- `target/raw-pointers-wasm-runtime.log`: actual wasm32 compiler host preserves
  high 64-bit pointer values, repeated fixture execution, low-pointer trap and
  unreadable view/range diagnostics.
- `target/raw-pointers-clippy.log`: host core/LLVM all-target clippy -D warnings.
  Scoped rustfmt/item spacing and jaifmt --check pass; rebuilt own jaic/jailint
  build and verbose fixture jailint -D warnings pass without exclusions
  (`target/raw-pointers-tool-build.log`, `target/raw-pointers-jailint.log`).

Final rebuilt-tool/clippy/wasm32 evidence after the semantic cache repair uses
the corresponding `*-final.log` files: raw-pointers-clippy-final,
raw-pointers-tool-build-final, raw-pointers-wasm-runtime-final and
raw-pointers-jailint-final. No passing pre-repair run substitutes for these checks.

Two draft generic tests had setup errors, recorded separately: `$value` without
a name-colon is a generic type pattern rather than a baked named parameter, so
the inferred baked test now uses `$value:`. Returning a runtime Type without
the reflection prelude also requires descriptors; a scalar result now directly
checks the inferred type without that unrelated dependency. The original
`$value:$T` regression already failed for actual identity loss. The final cache
controls compare multiple identical-bit arguments in one procedure and struct,
and remain decisive. No generic assertion is skipped or replaced with success.

Commands:

```
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm PATH=/opt/homebrew/opt/llvm/bin:$PATH CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic -p jaic-llvm --test cleanroom_raw_pointers
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm PATH=/opt/homebrew/opt/llvm/bin:$PATH JAIC_STDLIB=$PWD/target/runtime-configuration-candidate/stdlib CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic -p jaic-llvm --all-targets --no-fail-fast
JAIC_STDLIB=$PWD/target/runtime-configuration-candidate/stdlib CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo build --locked -p jai-wasm --target wasm32-unknown-unknown
node tools/check_raw_pointers_wasm.mjs target/wasm32-unknown-unknown/debug/jai_wasm.wasm
```

## Limits and follow-up

All supported language/backend targets are 64-bit: x64, ARM64 and WASM memory64.
The regression explicitly requires i686 Windows/Linux and wasm32 output to
diagnose unsupported architecture. Actual wasm32 compiler hosting is supported
and tested, but still compiles the 64-bit language model. This is not evidence
of 32-bit program code generation; adding that requires coherent layout, IR,
ABI, interpreter and backend work rather than changing a size field or silently
selecting a 64-bit backend. Constant folding uses the target size, not usize.

Raw pointer bits do not establish ownership, validity, bounds or lifetime.
Non-global opaque addresses escaping #run stay raw numeric addresses, not
portable relocations or lifetime-extended native allocations. Only known globals
are relocated; foreign/temporary opaque storage requires an explicit supported
lifetime/relocation contract. Typed #run snapshots retain the existing capture
policy; no new pointer-provenance model is claimed.

Interpreter general loads/stores retain native-style raw accesses above the
existing null/procedure-address checks. Arbitrary unmapped non-low dereferences
can still produce a host fault; this batch does not claim complete memory safety
or add fault-catching machinery. Compiler-owned capture uses its existing safe
probe and invalid views diagnose. Broader fault containment is a separate runtime
gap, documented rather than disguised as a passing high-address dereference.

Full Windows_Registry producer/native API integration and native Windows/Linux
execution remain coordinator/platform gates. No Registry-name exception, public
parameter change, SDK-value substitution, blanket suppression or publication.
