# Union storage

## What it is

The LLVM backend represents nominal unions with target-aligned shared byte storage. All checked member projections refer to offset zero, while whole-value assignment copies the complete union snapshot.

## How it works

`TypeLowerer::with_target` binds the actual LLVM `TargetData` before completing a named union body. The body contains a zero-length array of the strongest-aligned member and a byte array covering the target union size. The alignment carrier consumes no bytes; LLVM size and alignment must exactly match the registry layout engine.

A checked `FieldId` still proves the nominal owner and member type. A member place uses the same opaque LLVM pointer as its union base. Constructing a union zeroes its complete temporary storage, writes the selected member once, and loads a full union value. Reading a member from a value first snapshots the entire union, then loads the selected physical type at offset zero. Compiler-owned temporaries are allocated in function entry.

Global constants use an equivalent initialized physical layout with a zero-length alignment carrier, the active member, and trailing zero bytes. This preserves real pointer relocations without serializing addresses into integers. Nested record/array constants may similarly use equivalent physical LLVM types; target size, alignment, and field offsets are verified before they initialize globals. All later accesses retain the source nominal type through checked IR and opaque LLVM pointers.

Packed records and explicit record/field alignment currently produce a targeted unsupported diagnostic because ordinary field access and C ABI classification require additional alignment handling. Union member access does not introduce runtime active-member tags.

## How to change it

Extend `unions.rs` storage construction and extraction with the shared lowerer and common place/value paths. Do not model union members as consecutive struct fields or invent a second variable-storage representation. Changing custom-layout support requires verifying field access alignment and the foreign classifier together.

Add both layout tests and native execution cases: different member alignments/sizes, cross-member reads, nested unions, independent copies, return snapshots before deferred mutation, constant globals, and C ABI roundtrips. `tests/foreign_abi.rs` executes integer/mixed and homogeneous-float union returns against self-written C fixtures on macOS ARM64.

## Configuration

Union lowering requires a target-bound lowerer. Native `jai-codegen::lower` creates the native LLVM target, attaches its triple/data layout to the module, and binds it to the common lowerer. A standalone unbound lowerer reports `UnsupportedUnion` rather than guessing a target.

## Dependencies

This feature uses `jai-types` nominal records and layout policy, `jai-ir` checked field projections and union constructors, Inkwell/LLVM 22.1, and the common aggregate/global lowering path. LLVM APIs construct every type and instruction; no LLVM IR is handwritten.
