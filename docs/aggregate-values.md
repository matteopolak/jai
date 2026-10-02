# Aggregate values

## What it is

Record and enum expressions use the common checked value and place model. Nominal types stay distinct through local storage, globals, fields, copies, arguments, and procedure results.

## How it works

Type resolution reserves each record identity before checking its fields. Field reads and writes use registry `FieldId` projections, including promoted `using` paths and pointer-to-record member access. Assignments evaluate an aggregate value before storing it, preserving a copy when source and destination storage overlap.

A member of an addressable record retains its storage projection. This lets an inline array field decay to a view of its actual backing and lets descriptor removal publish its count to the actual field. A member of a temporary aggregate remains a value projection. Preserve this distinction when changing member reads; otherwise pointer iteration can silently modify a copied array. [Array iteration and removal](array-iteration-and-removal.md) covers the related alias and read-only rules.

Named record literals evaluate supplied expressions in source order. The checked `RecordBuild` carries `(FieldId, value)` entries, so declaration order cannot reorder calls such as `Pair.{b=bump(), a=bump()}`. Missing fields use pure checked defaults from the record's defining file. A contextual `ifx` checks both branches against the nominal type but executes only the selected runtime branch.

Defaults are typed constants. Nested records retain their field defaults, and fixed arrays repeat their element defaults. Cycles and excessive constant materialization produce diagnostics rather than recursive overflow or unbounded allocation. `enum_flags` default to representation zero even without a named zero member; the supplied Compiler module states that rule. Ordinary enums with a nonzero first member currently require an explicit initializer until their default rule is established.

Semantic bindings hold opaque handles to recursive constants in a shared context-owned pool. Reading a handle materializes the actual typed checked value; it does not allocate runtime mutable storage. Handles retain their pool identity, so a captured binding cannot silently alias a constant from a different compilation context.

Union members share storage through typed projections. A local union declaration without an initializer allocates storage without a default store, matching the supplied Input module's explicit initialization pattern. A union literal supplies exactly one alternative, represented by its nominal `FieldId` and checked payload. Default construction remains a separate boundary; initializing every alternative as if it were a struct would change shared bytes incorrectly.

## How to change it

`modules/aggregates/types.rs` owns declaration metadata and type resolution. `defaults.rs` checks declaration-site constant initialization; `modules/scope.rs` supplies body-side defaults from that metadata. Keep those paths consistent when adding a value kind.

Body lowering lives in `modules/aggregates/mod.rs`, `pointers.rs`, `sequences.rs`, and `value_conditionals.rs`. Preserve canonical type equality for nominal values. Build projections through the shared place registry, and preserve source evaluation order in explicit initializer lists. Extend the shared IR verifier before adding a new node to semantic lowering.

## Configuration

Module search paths and arguments affect name lookup and declaration identity. Constant construction uses the shared limits in `constant_limits.rs`; those limits bound materialization and recursion. Target-dependent reflection and layout use explicit resolver options.

## Dependencies

The feature uses `jai-modules` defining-file scopes, `jai-syntax` unresolved annotations and literal syntax, `jai-eval` scalar constant evaluation, `jai-types` canonical types and fields, and `jai-ir` checked values and projections. `jai-codegen` and `jai-vm` consume the same immutable checked program.
