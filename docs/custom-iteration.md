# Custom iteration

## What it is

Custom iteration compiles a user-defined source `#expand` procedure with a typed source argument, a captured `Code` body, and a flags value. A default custom loop selects `for_expansion`; `for :walk value, index: source` selects a named expansion.

## How it works

The protocol follows the source examples in `reference/how_to/730_for_expansions.jai`, including the Holder expansion, named alternatives, exported iterator bindings, pointer arguments, and controlled iteration flags. Pinned recent source also uses this protocol in Focus's `src/utils/array.jai` and `ring_buffer.jai`, and Vk-Engine's `Source/Core/Physics/collision_mesh.public.jai`. The latter forwards parenthesized flags with `for *=(flags & .POINTER != 0) <=(flags & .REVERSE != 0)`. Selection uses an actual module or lexical source expansion, including scoped imported namespaces. A lexical expansion retains its defining types, imports, and storage bindings. Ordinary builtin sequence iteration uses its normal lowering unless an explicit expansion was selected.

```jai
For_Flags :: enum_flags u8 { POINTER :: 1; REVERSE :: 2; }
Container :: struct { values: [2]int; }

for_expansion :: (source: Container, body: Code, flags: For_Flags) #expand {
    for value, slot: source.values {
        `it := value;
        `it_index := slot;
        #insert body;
    }
}

main :: () -> int {
    source: Container = .{values=.[20,21]};
    sum := 0;
    for value, index: source sum += value;
    return sum + 1; // 42
}
```

Source storage is captured once before macro bindings enter scope. A pointer parameter gets the source address; a value parameter aliases its captured storage. A pointer source may auto-dereference for a value parameter. A temporary source gets typed temporary storage. Source expressions and storage projections with side effects execute once. A by-value alias of a read-only sequence element retains that restriction through its captured address; creating a mutable pointer parameter from such an element rejects.

Generic collection formals use the ordinary pure overload matcher and canonical record-template origins. A source formal such as `*Array($T,$N)` infers typed arguments from the actual record specialization; a same-shaped record from another declaration cannot match that origin. Multiple default or named expansions are selected by that same matcher: disjoint collection origins reject one another, exact source bindings outrank an address or dereference adaptation, and equal applicable candidates remain ambiguous. Invalid defining annotations are reported rather than treated as inapplicable overloads. The inferred immutable substitution belongs to the expansion definition. Its type and constant bindings enter before the private runtime formals, and caller names cannot supply missing definition bindings.

The body retains its caller's lexical storage and defining file. Backtick declarations export their checked bindings into inserted caller code; `it` and `it_index` map to the caller's selected iterator names. A builtin loop can export its bindings directly with ``for `it, `it_index: source.values``. Additional exported names retain their original spelling. Export overlays are scoped to the expansion invocation, and both required iterator names must be exported even if the expansion never inserts the body.

The flags parameter must be an actual flags enum with `POINTER` and `REVERSE` members. Its constant value uses those source-declared members. `for < * source` supplies both flags; a macro can forward them with `for *=cast(bool)(flags & .POINTER), <=cast(bool)(flags & .REVERSE) source.values`. Modifier values use typed compile-time evaluation, with runtime storage and calls rejected unless explicitly evaluated through `#run`.

Break and continue statements in an inserted body use the enclosing loops in the source expansion. User defers preserve their caller bindings and follow existing cleanup rules. [Insertion loop control](insertion-loop-control.md) supports explicit `#insert(break=break outer, remove={...}) body` replacements while retaining the caller's nested-loop scope and the replacement's definition bindings.

Current boundaries are explicit: overload selection for ordinary expanded procedure calls, constrained type patterns such as `*$T/Table`, baked/using/variadic/discarded parameters, default parameters, expansion results, and exported bindings of nested custom loops are not implemented. Captured lexical runtime storage cannot escape its defining procedure. The source and matched parameter share a concrete type identity with optional single pointer auto-address/dereference; implicit conversion-field paths are not applied to this binding. No empty procedure body or fabricated intrinsic substitutes for a rejected expansion.

## How to change it

`jai-sema/src/metaprogram/iteration.rs` constructs source aliases, captures the caller body, creates typed flags constants, and brackets the export remap and macro cycle guard. `iteration_protocol.rs` validates the protocol and selects real candidates retained by `expansion_candidates.rs`. `formal_matching.rs` delegates generic formals to the shared matcher. `expansion_scope.rs` shortens the resolver borrow so a stack-owned inference result can supply the defining file overlay while retaining the same procedure, storage, cleanup, loop, and debug identities. Generic macro binding and body resolution live in `metaprogram/expansion.rs`; `local_macros.rs` owns lexical definition identities and captures; exported overlays live in `metaprogram/exports.rs`. Preserve declaration identity and the captured source file when extending lookup, and restore remap/cycle state on errors.

The syntax parser preserves explicit expansion paths and compile-time modifier expressions in the loop AST. Backtick declarations wrap their original statement and span in `CallerExport`. `jai-syntax/tests/custom-iteration.rs` verifies both wrapper and inner ranges. `jai-codegen/tests/custom_iteration.rs` covers sparse containers, named remapping, extra exports, pointer mutation, source snapshots, flags forwarding, body defers, and loop exits. Its 16 valid fixtures compare the Rust VM with generated native programs; two invalid-input groups check located protocol and read-only alias errors. Lexical and imported fixtures also verify that formal types and macro storage come from the definition while inserted code preserves caller shadowing. These are bounded implementation tests, not original-compiler parity evidence.

## Configuration

No new compiler flags. Imported expansions use the normal configured import directories. Each supported expansion has exactly three explicitly typed parameters, no results, and no runtime calling convention boundary. Procedure safety-check overrides apply to its expanded source body. Expansion depth and cycles use the shared macro registry's limits. Inactive compile-time branches are skipped before rejecting source expansion returns; an inserted caller body can still return from its caller.

## Dependencies

`jai-syntax` supplies source procedures and retained body syntax; `jai-modules` supplies scoped declaration identities; `jai-types` supplies concrete source and enum identities. Generic `Code` capture/export insertion in `jai-sema` constructs ordinary `jai-ir` blocks and storage. Both the Rust VM and LLVM backend execute those checked operations.
