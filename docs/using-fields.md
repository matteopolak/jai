# Using record fields

## What it is

An embedded record field marked `using` exposes its members through the containing value. Semantic lookup resolves each promoted name to a path of `FieldId` identities, retaining the embedded storage location for reads and mutation.

## How it works

`using` procedure parameters also expose field names as lexical storage aliases. The resolver creates checked field projections into the parameter's storage, including paths through embedded `using` fields. A pointer parameter uses a checked dereference before projecting its fields. Writing an exposed field therefore updates the parameter's actual record storage; it does not update a detached scalar copy. Conflicting exposed names produce a diagnostic.

After all record definitions are available, the resolver validates that each `using` field contains a record value and that promotion edges are acyclic. Pointer embeddings currently report an explicit diagnostic. The validation walk is iterative and accepts forward declarations and shared dependencies.

Record validation rejects conflicting direct and promoted declarations, as demonstrated by `reference/how_to/044_using_advanced/main.jai`. Two promoted paths also conflict even if both reach the same field declaration through different embedded values. Lookup visits direct fields and recursively visits `using` fields, returning the sole matching identity path. Missing members and ambiguous promotions report source diagnostics. Advanced `using,except` clauses remain unsupported.

For `Outer :: struct { using inner: Inner; }` and `Inner :: struct { value: int; }`, `outer.value` resolves to the identities of `Outer.inner` followed by `Inner.value`. No string field tags enter the IR. Promoted member names do not create additional physical fields or alter layout.

## How to change it

Promotion validation lives in the canonical `modules/aggregates/parameterized` record engine. Executable lookup uses the shared record metadata in `local_declarations/metadata.rs`, which covers module, local, specialized, and context records; `using_bindings.rs` publishes procedure-parameter aliases. Extend these paths together rather than adding a second nominal-only lookup table. Source/VM tests in `tests/using-fields.rs` exercise actual projected mutation and ambiguity rejection. Preserve complete identity paths when adding pointer promotion, visibility rules, or record specialization. Named literal initializers currently address direct fields; promoted literal initialization requires conflict rules for overlapping embedded initializers.

## Configuration

The source `using` modifier controls promotion. There are no environment variables or global flags.

## Dependencies

This feature uses syntax field declarations, module graph source identities, the nominal record table, and `jai-types::FieldId`. It adds no external library or runtime dependency.
