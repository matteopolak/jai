# LLVM type lowering

## What it is

`jai-codegen::types::TypeLowerer` translates frozen `jai_types::Types` identities into Inkwell storage types and internal LLVM procedure signatures. It also compares registry layouts against LLVM target data before a caller relies on those layouts.

## How it works

Each lowerer belongs to one LLVM context and one immutable registry. It caches storage types by the full `TypeId`, checking registry provenance before any cache lookup. It predeclares a named opaque LLVM structure for every nominal record, then installs struct bodies in iterative dependency order. Recursive source pointers retain their pointee identity in the registry; LLVM 22 stores them as opaque pointers. Distinct nominal structs remain distinct LLVM named types even when their fields match.

Integers and enum representations use fixed-width LLVM integers, booleans use `i1`, and floats use LLVM `float` or `double`. Signedness remains a semantic property rather than an LLVM integer type property. Fixed arrays preserve element type and count. Strings and slices use `{ count: s64, data: pointer }`; dynamic arrays use `{ count: s64, data: pointer, allocated: s64, allocator: { procedure: pointer, data: pointer } }`.

`function` accepts the internal Jai convention and ordered result lists. A singleton result uses its storage type directly; multiple results use a literal LLVM struct carrier. `set_context_pointer` binds the checked per-library context schema; implicit-context signatures prepend its hidden pointer. Foreign conventions use the separate [C ABI classifier](foreign-abi.md). Metatype storage, void storage, custom layouts without bound target data, unsupported alignment carriers, and arrays above the Inkwell `u32` length limit return structured errors. A pointer remains representable independently of pointee storage. Procedure values occupy opaque pointer storage.

`with_target` binds the selected LLVM `TargetData` before completing unions and custom records. Custom structs contain a zero-sized alignment carrier and a typed packed payload with explicit padding. The target must confirm the carrier alignment; unsupported target alignments report a structured error. Typed payload fields preserve pointer relocations in global constants. Custom unions use the same carrier and byte payload pattern. Named unions use a zero-length alignment carrier and a shared byte payload; their physical layout is checked against the registry. An unbound lowerer reports `UnsupportedUnion`. [Union storage](union-storage.md) describes projections, snapshots, and constant relocation handling.

`layout_policy(context, target_data)` derives primitive sizes and ABI alignments from LLVM, then validates them through `LayoutPolicy::new`. `verify_layout` uses this policy in `LayoutEngine` and compares storage size, alignment, declaration-order field offsets, and array stride against LLVM's values. For custom records it reads the actual outer/payload LLVM field offsets and maps physical ordinals back to declaration order; distinct aliases forward the underlying representation layout. The target data should come from the selected LLVM target machine. No Rust host layout assumptions or hand-written LLVM IR are involved.

The checked emitter creates one shared lowerer for globals, local allocation, procedure declarations, field projections, and whole-value loads/stores. Arithmetic continues to use checked semantic integer types for signed comparisons, extension, and casts. Type availability in this module does not imply source parsing, checked expressions, field access, allocation, or runtime ownership support for every represented type.

## How to change it

Add a `TypeKind` storage case in `TypeLowerer::basic` and the corresponding `LayoutEngine` policy behavior together. Add by-value dependencies to the iterative walk for types containing other storage values. Keep pointers and descriptors independent of the pointee's storage lowering so recursive pointer types remain finite.

Keep union storage and member addressing consistent with the common slot/value path. Extend the explicit C classifier when changing foreign conventions; do not use the internal carrier as a foreign aggregate ABI. Keep the internal result carrier consistent with call-result extraction and return snapshot construction. Do not assume an LLVM basic type alone establishes a platform calling convention.

Tests live in `crates/jai-codegen/src/types.rs`. They construct the shared registry directly and verify LLVM modules, actual native target layouts, a 32-bit target-data profile, recursive pointers, nominal identity, descriptors, float and enum representations, unsupported operations, and a 4,096-record dependency chain. The package's native integration suite separately verifies source-level scalar execution.

## Configuration

The lowerer itself takes no environment variables. Build and test against the trusted installed LLVM toolchain configured by the repository; on this macOS environment:

```sh
LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-codegen --locked -j1
```

`TargetData` is caller supplied to standalone lowerers; native emission selects and binds the native target machine. The native test derives it from a native target machine; the 32-bit test uses the explicit profile `e-p:32:32-i64:32-f64:32` to exercise different pointer and double alignment.

## Dependencies

The module depends on `jai-types` for frozen identity, definitions, and layout policy, and on the workspace's Inkwell/LLVM 22 dependency for native type construction, verification, and target data. The frontend is not needed to construct or inspect these type representations. It loads no original Jai reference compiler, runtime library, or reference object file.
