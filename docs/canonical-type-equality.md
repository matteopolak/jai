# Canonical Type equality

## What it is

Runtime `Type` equality compares the nominal type represented by a certified
descriptor. Immutable descriptors from different reflection revisions can
represent the same type while occupying different physical addresses.

The implementation and proofs are staged for coordinated integration with
native runtime-info publication. Acceptance remains pending until that window
activates the IR and both execution consumers together.

## How it works

`BoolExpr::CompareTypes` accepts two ordinary `Type` expressions. Semantic
resolution retains those typed operands rather than converting them into
descriptor pointers. Each operand producer runs once, from left to right.

The VM resolves a nonnull cell through its registered descriptor allocation and
exact header byte offset, then compares the receipt's represented `TypeId`.
Receipt identity includes immutable backing storage and target policy, but
those details do not change nominal equality. Unregistered, dangling, wrongly
typed or foreign-target descriptor storage cannot supply a represented type.

LLVM records each admitted descriptor's actual header relocation in private
module metadata. After lazy static emission and runtime-info snapshot preflight,
it publishes a private table mapping those addresses to canonical registry
indices. All immutable revisions enter this table. The index is an internal
comparison token, never the stored representation of a source `Type` cell.
Unknown nonnull addresses trap instead of acquiring identity from matching
header bytes or symbol names. Exact static-object ownership receipts also
prevent source extern declarations from claiming generated descriptor storage.

Two null Type values compare equal, and a null value differs from every
represented type, including `void`. Both nonnull operands must be valid even
when their addresses agree. Explicit casts to `*Type_Info` continue to expose
physical header addresses and use ordinary pointer equality.

```jai
first: Type = First_Record;
second: Type = Second_Record;
same := first == first; // Nominal Type equality.
addresses_same := cast(*Type_Info) first == cast(*Type_Info) second;
```

## How to change it

Keep `jai-ir/src/expressions.rs`, the expression verifier and structural walks
in agreement when changing the comparison operation. Source lowering lives in
`jai-sema/src/runtime_type_values.rs`. The direct and resumable VM consumers
share the receipt comparison in `jai-vm/src/execute/runtime_types.rs`.

Native comparison and identity publication live in
`jai-codegen/src/type_equality.rs`; descriptor admission and exact storage
ownership live under `jai-codegen/src/static_data`. Finish descriptor emission
before publishing the identity table, and publish that table before
runtime-info measures all owned globals. A later lazy descriptor producer must
extend this ordering rather than omit its receipt from the sealed table.

Proofs should retain old descriptor storage across a real reflection policy
change, then compare it with the newer descriptor for the same nominal type.
Also cover equally shaped nominal twins, explicit pointer comparisons, nulls,
`Type` and `*Type`, once-only context effects, both VM paths and native `-O0` /
`-O2`. The selected-target proof checks pointer-sized Type cells on 32-bit and
64-bit layouts; only generated host programs are executed.

## Configuration

The selected target layout controls the descriptor projection and Type cell
width. Null uses internal token zero; admitted nominal indices use `index + 1`,
so the registry's first represented type cannot alias null. There are no new
source flags or environment variables, and the public Type/Type_Info ABI stays
pointer-based.

## Dependencies

This feature relies on canonical `jai-types` nominal identities, checked
immutable descriptor bindings in `jai-ir`, VM allocation receipts, LLVM module
metadata and the native runtime-info publication order. It introduces no
external runtime service or library dependency.
