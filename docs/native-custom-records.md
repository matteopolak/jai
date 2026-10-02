# Native custom record regression tests

## What it is

`crates/jai-codegen/tests/custom_records.rs` checks custom record layouts from self-authored Jai source through module loading, semantic resolution, LLVM lowering, object emission, linking, and native execution. It covers packed records, explicit field alignment reductions, increased record alignment, nested records, arrays, global union constants with string relocations, aliases, initializer order, and aggregate value snapshots.

## How it works

`static_layouts.rs` independently constructs validated `StaticDataBuilder` graphs with packed, reduced-alignment, and over-aligned records nested in arrays. It follows actual cyclic field-pointer relocations through native globals and compares the result with VM storage. Static field addresses use semantic byte offsets; custom record constants share the typed payload constructor used by ordinary globals. A separate custom union test checks zero-offset member pointers through an unaligned holder relocation. Nonzero union alternatives are not supported by the current static-graph value schema; ordinary global union constants are covered by the source fixtures.

Each fixture resolves with the selected native target's layout policy. The test compares LLVM storage size, alignment, field offsets, and array stride with the semantic layout engine using `TypeLowerer::verify_layout`; custom record layouts also have independent expected size, alignment, and offset assertions.

The emitted program checks byte offsets and pointer alias effects against explicit source expectations. Packed and reduced-alignment scalar fixtures also inspect the unoptimized IR's projected load/store alignment. Every program must return `42` at both LLVM `O0` and `O2`. Programs are linked from newly emitted objects with trusted Clang, run with a five-second deadline, and removed with their temporary source and objects when the test finishes. These tests never execute reference binaries or load reference native libraries.

## How to change it

For source fixtures, add a test calling `check(source, expected_layouts)`. For static graphs, reserve objects before assigning symbolic addresses, then publish through `StaticDataBuilder` validation. List the expected `(size, alignment, field_offsets)` for every source record with custom layout metadata; order is irrelevant. Keep the source program deterministic and make each failed runtime assertion return a distinct non-`42` exit code. Offset and stride checks should use byte pointers so they do not assume Rust's host representation.

Use explicit union alternatives in source initializers. A naturally aligned child inside a packed parent retains its own internal offsets while the parent may place it at an unaligned address; exercise both levels when changing field projection or access alignment.

## Configuration

```sh
LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-codegen --test custom_records --locked -j1
LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-codegen --test static_layouts --locked -j1
```

`LLVM_SYS_221_PREFIX` selects the installed LLVM 22 toolchain. Tests use the shared [native test tool selector](native-test-tools.md), including an explicit `JAI_RS_CLANG` override and canonical protected-path checks. macOS tests pass `-Wl,-no_fixup_chains`: the default Mach-O chained fixup encoding rejects pointers stored at unaligned packed offsets. Apple's [linker implementation](https://github.com/apple-oss-distributions/ld64/blob/main/src/ld/Options.cpp) provides this switch; ordinary relocation opcodes preserve these pointers without changing record offsets or disabling PIE. Source `#no_padding`, record `#align`, and field `#align` declarations determine the layouts under test.

## Dependencies

Static graph fixtures use `jai-ir` directly and compare against `jai-vm`. Source fixtures use workspace `jai-modules`, `jai-sema`, `jai-types`, `jai-codegen`, and `jai-vm`'s no-effects adapter, LLVM through Inkwell, the installed trusted Clang driver, and Rust's standard library. No reference compiler, reference runtime, additional crate, or external service is required.
