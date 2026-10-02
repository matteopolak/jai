# Positional record literals

## What it is

A positional record literal initializes a struct's fields in declaration order. The type can be explicit (`Pair.{40, 2}`) or supplied by the surrounding declaration (`value: Pair = .{40, 2}`).

## How it works

Semantic resolution obtains the canonical record metadata and pairs each value with its corresponding stored field. It then uses the same typed record constructor as named literals, retaining source evaluation order, field conversions, callback signatures, and default initialization.

```jai
Pair :: struct { left: int; right: int = 2; }
value: Pair = .{40}; // right uses its declaration default
```

Each explicit runtime value captures into an immutable expression binding before the pure canonical construction plan groups fields. This preserves callback source contracts, including `#must`, through temporary values and copies. Checked literal constants enter the plan directly; arithmetic, loads and calls retain their written evaluation position. Each explicit value evaluates once. Omitted trailing fields use their source defaults; extra values produce a diagnostic. Positional values address the struct's own stored fields, including embedded fields, in the declaration's order.

Immutable declaration defaults use the same ordering through `Defaults::expression`; callback members preserve their actual `ProcedureId` and canonical signature. A union initializer must specify an alternative by name because positional storage alone does not identify its active member.

Runtime string and slice descriptor literals use actual `SequenceField` slots in `count, data` order, and dynamic arrays additionally use `allocated`. Their values keep typed descriptor construction and capture order; they are never reinterpreted as nominal records. Explicit named descriptor aliases use the same checked target type, for example `Slice.{count=2,data=*items[0]}`. The allocator slot awaits the coordinated descriptor carrier extension. Immutable descriptor pointer construction needs separate checked constant support.

## How to change it

The syntax node is `PositionalStructLiteral` in `jai-syntax/src/types.rs`. Canonical path planning and capture lowering live in `modules/aggregates/promoted_literals/positional.rs` and its shared source helper. Runtime dispatch lives in `Resolver::positional_record_literal` and `expr_expected` in `jai-sema/src/modules/aggregates/mod.rs`; immutable construction lives in `modules/aggregates/defaults.rs`. Sequence descriptor construction lives in `sequences/positional_literals.rs` and uses the canonical sequence field rules.

Keep field selection tied to canonical record metadata rather than spelling-based type recovery or flattened promoted fields. Update literal classification, dependency traversal, and inference in `modules/sequence_constants.rs` when adding another immutable literal form. Local and specialized records must use their own metadata overlays so field identities and declaration defaults remain consistent.

## Configuration

There are no new flags or environment variables. The explicit type or surrounding expected type selects the nominal record; an anonymous literal without a type context produces a diagnostic.

## Dependencies

This feature depends on the syntax literal parser, canonical record/field identities, module and lexical record metadata, and the existing typed aggregate constructors. Source acceptance and located required-result diagnostics are in `jai-sema/tests/result-obligations.rs`. VM/native parity fixtures are in `jai-codegen/tests/procedure_values.rs`.
