# Array iteration and removal

## What it is

Array loops traverse strings, fixed arrays, slices, and dynamic arrays with optional index bindings, reverse order, and pointer bindings. `remove;` or `remove value;` filters a mutable slice or dynamic array with an unordered removal.

## How it works

The sequence expression evaluates once before the iterator names enter scope. A descriptor source also captures its storage address once, so `for value: descriptors[next_index()]` does not call `next_index` again when removal publishes the new count. The loop uses a snapshot descriptor; an unrelated descriptor assignment in its body does not replace the captured traversal.

By-value array elements bind a read-only reference to the current indexed place, rather than a mutable copy. Access through that binding observes writes to the original element. Direct assignments, field updates, result assignments, and taking a mutable address through the binding reject. Inline fixed-array fields retain the restriction when a nested pointer loop, slice conversion, or `.data` access would expose their address. `for *value: sequence` binds a mutable pointer and permits element writes. By-value string iteration uses the same live read-only indexed reference with element type `u8`; pointer string iteration uses the checked indexed storage provided by mutable string indexing.

A runtime string descriptor can reference mutable byte storage. `for *byte: text` captures that descriptor once and updates its original backing bytes, including in reverse order. Nonempty direct string literals and constant string names reject pointer iteration. Empty literals and zero-count descriptors traverse no elements. A runtime descriptor initialized from a literal retains immutable backing: attempting to write through its iterator fails with `ReadOnlyStorage` in the VM and traps in generated native code. Descriptor copying never makes literal backing writable.

```jai
main :: () -> int {
    backing: [4]int = .[2, 4, 5, 7];
    values: []int = backing;
    for value, index: values {
        if (value & 1) == 0 remove value;
    }
    return values.count; // 2; backing starts with 7, 5
}
```

An unnamed `remove;` targets the actual innermost lexical loop. It does not skip a nested range or while loop to find an outer array; those targets reject. Named removal retains its existing explicit iterator lookup. `for #v2` selects the same captured descriptor, direction, and cleanup-latch behavior as current array iteration.

Removal copies the last remaining element into the current slot and decreases both the captured descriptor count and the source descriptor count. Its statement falls through. The forward loop latch reuses the slot after removal; reverse traversal decrements the index because the moved tail was already visited. The same forward/reverse distinction appears in the pinned Focus custom `Array` expansion at `corpus/upstream/focus-editor--focus/src/utils/array.jai`; builtin original-compiler parity has not been checked by execution.

An internal cleanup latch advances ordinary iterations after user `defer` bodies. A `continue` to an array loop runs its crossed user cleanups before that loop's latch; named outer continues advance only their target loop. `break` and procedure returns run user cleanups without advancing the target loop. Empty and negative-count descriptors do not access backing elements.

Fixed arrays have no mutable count and cannot be removed from. String iteration cannot remove elements. Removal from a deferred body, removal targeting an outer loop from a nested loop, and multiple removal statements targeting the same array loop currently reject with located diagnostics. Slice backing must be writable; a descriptor cannot make literal storage writable.

The source parser preserves explicit custom iteration selection, `for :expansion value, index: source`. [Custom iteration](custom-iteration.md) invokes the actual source macro protocol and remaps its exported iterator bindings.

## How to change it

`jai-sema/src/sequence_loops.rs` captures source storage and creates the checked indexed references, loop condition, and cleanup latch. `iteration_removal.rs` carries per-loop state, constructs removal stores, and checks read-only iterator writes. `loops.rs` attaches the latch only to continues. Keep pointer address capture before descriptor load, and preserve user cleanup ordering when changing control flow. Record member reads must retain a place when the base has storage, so inline array iteration and descriptor removal operate on the original field.

Source regressions in `jai-codegen/tests/iteration_removal.rs` compare the Rust VM with generated native execution. They cover filtering, descriptor count publication, source side effects, reverse removal, live by-value reads, inline record array storage, nested named exits, and located invalid cases. String fixtures exercise mutable backing, descriptor evaluation once, reverse pointer iteration, live reads after writes through the original byte array, immutable backing traps, and direct literal rejection. By-value string writes and mutable address-taking remain located errors. Empty and `i64::MIN` descriptor counts also skip element access. Only this implementation's generated programs are executed.

The four new String iteration fixtures pass through source compilation, the VM, and generated native execution in the bounded compiler checkpoint `artifacts/component-checkpoints/collection-source-runtime-20261002T140932Z/validation.json`. The broader integrated workspace gate remains separate.

## Configuration

No extra flags. Indices and descriptor counts use `s64`; element accesses use the active array-bound check policy. Removal changes `count` and backing elements, preserving `data` and dynamic `allocated`. `<=expression` controls reverse iteration and `*=expression` controls pointer iteration; their values must be known at compile time. Commas separate modifier expressions when needed to avoid parsing a following `<=` as a comparison.

## Dependencies

`jai-syntax` provides loop direction and removal syntax; `jai-types` provides element and descriptor types; `jai-ir` supplies places, stores, cleanup identities, and while-loop control flow. Both `jai-vm` and LLVM code generation consume the existing checked IR without a new removal intrinsic.
