# Immutable byte views

## What it is

An immutable byte view exposes the storage of one real typed static object as `[]u8`. Reflection uses this for `Type_Info_Struct.constant_storage`: namespace constants occupy target-aligned typed cells, and each member identifies its cell's byte offset.

The public receipt, VM pointer-region consumer, and native constant projection are implemented. Focused tests cover selected layouts, real relocation cells, and attempts to escape a narrow view; Reflection source acceptance is tracked separately.

## How it works

`StaticDataBuilder::byte_view(object, policy, offset, length, types)` creates a sealed receipt after checking the reserved object's exact nominal type and selected `LayoutEngine` size. The receipt's `address()` produces a root-only byte projection. An ordinary static slice uses that address and a count no larger than the receipt's length. Publication still requires a complete validated typed value for every object; the receipt does not replace values with serialized zero bytes.

The backing aggregate retains real scalar values, symbolic addresses of data and Type descriptors, and checked IR procedure relocations. LLVM emits the same private constant global and an `i8` constant GEP. The VM retains a read-only typed allocation and uses its byte image, including relocation metadata. Every consumer checks the actual selected layout policy before using the receipt. Byte order comes from the execution or native target, because the receipt stores a view recipe rather than serialized scalar bytes.

A smaller view must retain a non-widening region through casts, integer receipts, and byte-image copies. It cannot use the existing leading-record-field owner promotion to regain bytes outside its range. A zero-length view may point one past the backing object but authorizes no read. Padding bytes have no source value guarantee; parity fixtures inspect actual cells and their recorded offsets.

## How to change it

The proof lives beside `jai-ir` static storage, with its constructor restricted to the builder. Extend address validation, the native static projection emitter, and the VM static projection consumer together. Keep exact object identity, type-arena ownership, target policy, and checked range proofs. Do not accept a pointer plus an unrelated `TypeId`, or move IR `ProcedureId` into `jai-types`.

Tests cover typed heterogeneous backing, real data relocations, Type descriptor identity, callable recovery, 32/64-bit target layouts, and native O0/O2 execution. Bounds, foreign/stale objects, read-only writes, target mismatch, and attempted region widening are separate negative gates. Passing these consumer tests does not establish unchanged Reflection-module source acceptance.

## Configuration

The selected target's `LayoutPolicy` controls pointer size, alignment, field offsets, and object extent. There is no implicit host-width fallback. Existing static-data object/node/depth limits apply. Native test linking uses the repository's trusted Clang helper (`JAI_RS_CLANG`, then `LLVM_SYS_221_PREFIX`, then verified platform fallback).

## Dependencies

The proof uses `jai-types` type identity and `LayoutEngine`, `jai-ir` immutable object graphs and constant verification, `jai-vm` byte images and pointer capabilities, and `jai-codegen` typed constant globals with the audited `jai-llvm` constant-GEP bridge. Reflection namespace recipes and callable ownership receipts remain separate producers.
