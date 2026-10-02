# LLVM type lowering

## What it is

`jai-codegen::types::TypeLowerer` translates frozen `jai_types::Types` identities into Inkwell storage types and internal LLVM procedure signatures. It also compares registry layouts against LLVM target data before a caller relies on those layouts.

## How it works

Each lowerer belongs to one LLVM context and one immutable registry. It caches storage types by the full `TypeId`, checking registry provenance before any cache lookup. It predeclares a named opaque LLVM structure for every nominal record, then installs struct bodies in iterative dependency order. Recursive source pointers retain their pointee identity in the registry; LLVM 22 stores them as opaque pointers. Distinct nominal structs remain distinct LLVM named types even when their fields match.

Integers and enum representations use fixed-width LLVM integers, booleans use `i1`, and floats use LLVM `float` or `double`. Signedness remains a semantic property rather than an LLVM integer type property. Fixed arrays preserve element type and count. Strings and slices use `{ count: s64, data: pointer }`; dynamic arrays use `{ count: s64, data: pointer, allocated: s64, allocator: { procedure: pointer, data: pointer } }`.

`function` accepts the internal Jai convention with no implicit context and at most one result. It supports LLVM basic storage types as parameters and results. It does not classify foreign aggregate ABIs. Foreign conventions, implicit contexts, multiple results, unions by value, metatype storage, void storage, and fixed-array counts above the Inkwell `u32` array-length limit return structured errors. A pointer to an unsupported value type remains representable because its source pointee is retained independently. Procedure values occupy opaque pointer storage even when their call signature needs unsupported ABI work.

`layout_policy(context, target_data)` derives primitive sizes and ABI alignments from LLVM, then validates them through `LayoutPolicy::new`. `verify_layout` uses this policy in `LayoutEngine` and compares storage size, alignment, declaration-order field offsets, and array stride against LLVM's values. The target data should come from the selected LLVM target machine. No Rust host layout assumptions or hand-written LLVM IR are involved.

The checked scalar emitter creates one shared lowerer for globals, local allocation, and procedure declarations. Arithmetic continues to use checked semantic integer types for signed comparisons, extension, and casts. Type availability in this module does not imply source parsing, checked expressions, field access, allocation, or runtime ownership support for every represented type.

## How to change it

Add a `TypeKind` storage case in `TypeLowerer::basic` and the corresponding `LayoutEngine` policy behavior together. Add by-value dependencies to the iterative walk for types containing other storage values. Keep pointers and descriptors independent of the pointee's storage lowering so recursive pointer types remain finite.

Implement an explicit union representation and field-addressing strategy before accepting unions by value. Introduce ABI classification before extending `function` to foreign conventions, hidden context parameters, or multiple results. Do not assume an LLVM basic type alone establishes a platform calling convention.

Tests live in `crates/jai-codegen/src/types.rs`. They construct the shared registry directly and verify LLVM modules, actual native target layouts, a 32-bit target-data profile, recursive pointers, nominal identity, descriptors, float and enum representations, unsupported operations, and a 4,096-record dependency chain. The package's native integration suite separately verifies source-level scalar execution.

## Configuration

The lowerer itself takes no environment variables. Build and test against the trusted installed LLVM toolchain configured by the repository; on this macOS environment:

```sh
LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-codegen --locked -j1
```

`TargetData` is caller supplied. The native test derives it from a native target machine; the 32-bit test uses the explicit profile `e-p:32:32-i64:32-f64:32` to exercise different pointer and double alignment.

## Dependencies

The module depends on `jai-types` for frozen identity, definitions, and layout policy, and on the workspace's Inkwell/LLVM 22 dependency for native type construction, verification, and target data. The frontend is not needed to construct or inspect these type representations. It loads no original Jai reference compiler, runtime library, or reference object file.
