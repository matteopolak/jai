# Storage alignment

Variable declarations accept `#align` after their explicit type. The annotation raises the alignment of that declaration's allocation; it does not change the canonical value type, storage size, record layout, or array element stride.

```jai
TEMPORARY_STORAGE_SIZE :: 4096;
temporary_storage: [TEMPORARY_STORAGE_SIZE] u8 #align 64;
main :: () {
    scratch: [7] u8 #align 128 = ---;
}
```

## How it works

`jai-syntax::DeclarationAttribute::Alignment` retains the source expression. Semantic resolution evaluates it in the defining module or lexical scope and accepts only nonzero power-of-two integer constants representable as `u32`. Runtime storage, floating-point values, Boolean values, negative values, and oversized integers cannot supply alignment. Repeated annotations receive a parser diagnostic.

Typed constant arithmetic, including `size_of(u64) * 8`, uses the shared pure-constant VM evaluator after type binding. Global and local annotations can use `#run` values and constants produced by ready source procedures. Global declarations first bind their canonical types and initializers; separate annotation jobs then participate in procedure and constant readiness. A VM global allocation waits until its annotation has produced a valid request, so compile-time code cannot observe a temporary natural-alignment allocation. A request that depends on reading its own pending global produces a located cyclic-readiness diagnostic.

Checked IR carries requested alignment by exact `GlobalId` or `LocalId`, including the local's owning procedure. Metadata survives without debug names or debug information. Publication rejects unknown identities and invalid alignment values. A declaration without a request retains its natural type alignment; a smaller request preserves that natural guarantee.

Native lowering sets the actual LLVM global or entry-block `alloca` alignment and records the same guarantee on the storage slot. Projected loads and stores inherit the existing offset-based alignment rules. The compile-time VM aligns each allocation's numeric virtual base, so pointer-to-integer casts and modulo checks observe the declaration's alignment. Atomic access checks the allocation's actual guarantee and the pointer's offset, allowing explicitly aligned byte storage to hold an atomic integer. Both consumers combine the requested alignment with the type's natural alignment and check the selected target's representable address domain.

## How to change it

Change parser handling in `crates/jai-syntax/src/declaration_attributes.rs`, source evaluation in `crates/jai-sema/src/storage_alignment.rs`, and IR metadata validation in `jai-ir`. The scalar validation leaf is also used by field and record alignment adapters; their diagnostics and type-layout constraints remain separate. Preserve allocation policy separately from type layout: annotating one variable must not change another variable of the same type.

`crates/jai-sema/src/modules/storage_alignment.rs` retains a global annotation's defining declaration, file, exact storage identity, and expression span. It supplies that file scope and the ready compile-time context to the same evaluator. `modules/compile_time/alignments.rs` schedules these jobs; the VM provider's pending-global guard is required until the request is published. Retried procedure bodies clear their old local requests; anonymous `#run` bodies use a metadata snapshot and remove their temporary procedure identity before checked-library publication.

Native allocation checks live in `crates/jai-codegen/src/storage_alignment.rs`; allocation hooks live in `lower_unit`. VM allocation is the corresponding virtual-memory consumer. Extend `crates/jai-codegen/tests/storage_alignment.rs` with source, VM, emitted LLVM alignment assertions, and execution of newly generated objects. The address fixture passes actual pointers to a `no_inline` observer at O0 and O2. Tests must keep array stride and canonical type behavior independent from allocation alignment.

## Configuration

Source `#align` controls the requested alignment. Semantic target options, LLVM `TargetData`, and the VM byte target control pointer width and natural alignment; there are no environment switches for language behavior. Native tests use the repository's selected LLVM installation and trusted Clang. Object sizes and requested alignments must fit the target's signed address space.

## Dependencies

This feature uses declaration syntax, scoped constant evaluation, checked storage identities, the shared target layout policy, the VM memory allocator, and Inkwell's LLVM global and instruction alignment APIs. Record and field `#align` remain separate type-layout constraints documented in [target type layouts](type-layout.md).
