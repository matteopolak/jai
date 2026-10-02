# Compile-time Type values

## What it is

Runtime `Type` values are pointer-sized cells naming real immutable reflection descriptors. The VM recovers represented language types through certified descriptor identities, never by encoding a `TypeId` as an integer address.

## How it works

The registry binds one nominal `Type_Info` header through `RuntimeTypeSchema`. Reflection publication defines descriptor objects with a checked relation between the represented type and its exact header address. `RuntimeTypeConstant` has a private identity payload and derives its address from that relation; freely annotating a pointer with a represented type cannot create this proof.

During static publication the VM reserves all new objects, registers their certified header pointers, then initializes and freezes their values. Registration precedes initialization so same-graph cyclic descriptor references work. The reverse map uses allocation identity and target-layout byte offset, allowing a descriptor's root and leading header to share their physical identity.

`Value::Type { descriptor: Option<Pointer> }` holds an actual descriptor pointer. `None` is null. Nonnull values require the bound header type and an exact canonical reverse-map entry. `Vm::runtime_type_identity` returns the opaque `jai_ir::RuntimeTypeIdentity`; its `ty()` identifies the represented type only after the pointer and registry checks pass. Null identity queries fail explicitly.

The byte codec stores the same complete data-pointer relocation used by ordinary `*Type_Info` cells. Reading a `Type` through a raw descriptor alias preserves that pointer, while Memory validates its canonical identity. An otherwise identical mutable header copy cannot become a runtime type. Arbitrary bytes, shredded relocations, and integer guesses cannot create descriptor provenance. Nested records, arrays, unions, globals, and context constants hydrate their descriptor storage through actual VM execution.

Memory validates `Type` values when they enter storage, leave storage, or cross procedure argument/result boundaries. Materialization checks nonnull identities before publication. Transaction rollback restores descriptor registrations with their allocations and static publication caches; abandoned pointers become dangling. Successful `VmState` transfers retain the bindings.

`Vm::runtime_type_constant_value` turns a validated nonnull runtime value into a certified `RuntimeTypeConstant`. The VM retains the newest immutable `Arc<StaticData>` prefix for each published arena, allowing results read through raw aliases or nested storage to recover the actual descriptor graph. Prefix retention copies only the shared graph handle; state transfer and rollback keep it synchronized with virtual descriptor allocations. Source `#run` publication invokes this converter inside its validation callback before committing effects. Null `Type` results use a typed zero constant.

## How to change it

The canonical binding and constant constructors live in `jai-ir/runtime_types.rs` and `static_data.rs`; the registry schema lives in `jai-types/runtime_types.rs`. VM reverse-map checks live in `memory/runtime_types.rs`, while `execute/runtime_types.rs` exposes identity recovery. `execute/constant_values.rs` hydrates nested constants and `execute/static_data.rs` registers new descriptor objects. The codec represents `Type` cells as ordinary pointer relocations rather than introducing numeric identities.

When adding a new consumer, recover identity through the VM helper and keep the result opaque until using `ty()`. Source modifiers and constant publication must perform these checks before committing compiler effects. Preserve the private IR certification boundary and add regressions for raw aliases, forged header copies, rollback, and nested storage.

## Configuration

`ByteTarget` selects descriptor cell width, layout, and byte order. Certified identities retain their reflection target layout; the VM rejects a different selected layout before allocating descriptor storage. `Limits` bounds graph allocations, live values, encoded images, canonical registrations, traversal, and execution fuel. The registry must bind a ready header schema before nonnull runtime `Type` storage is used. Null byte-codec storage does not invent a header when none is bound.

## Dependencies

This feature depends on the `jai-types` runtime schema and reflection graph, `jai-ir` immutable static objects and certified runtime constants, and VM memory, byte storage, transactions, and state transfer. It uses no native descriptor addresses or host reflection services.
