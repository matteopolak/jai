# Aggregate literal source targets

## What it is

This coordinated frontend change preserves explicit literal types and relative field targets without replacing them with resolved IDs. The proposed schema is tested in a private syntax prototype and is not yet published in the production AST.

## How it works

Production literals currently store an optional named type path and single-symbol field names. The prepared schema changes both named and positional literal targets to `Option<TypeSyntax>` and changes `StructLiteralField.name` to `target: PlaceSyntax`. Values, field spans, and source order remain authoritative.

The isolated parser preserves forms such as `Namespace.Message(Payload,N=2).{data._u64=xx tid}` and `([]arr.T).{count=2,data=pointer}`. A field target may contain relative member and index operations, including `color_formats[next()]=.RGBA32UInt`. It must originate at a relative name; runtime call roots, dereferences, and inserted place roots do not become field names. Named and positional members cannot mix.

Parsing retains an index expression rather than evaluating it. Semantic construction must establish the actual owning fields and array storage, preserve index-before-value effects and checked bounds, and report unsupported targets before those effects run. The syntax prototype alone does not establish source compilation, VM execution, or native acceptance.

## How to change it

The staged parser is `crates/jai-syntax/src/aggregate_literals.rs`; its integration fixtures remain under `tests/pending/`. Driver publishes the schema only with coordinated constructor, default, callback-contract, specialization, and indexed-storage consumers. The machine-readable inventory is `artifacts/frontend-literal-producer-readiness.json`, including source hashes and the consumer audit list.

Move the old literal parser out of `types.rs` when activating the staged module, update the postfix target conversion in `expressions.rs`, and promote the pending fixtures only in that same window. Visitors must inspect type-application arguments and field-index expressions as well as values; retaining an AST child while dropping its dependencies or effects is not sufficient.

## Configuration

There are no new runtime flags or environment variables. The independent prototype uses a frozen source-only component workspace under `/private/tmp`, a separate Cargo target, and a hash receipt; it does not publish schema changes or run the main integration gate.

## Dependencies

The unresolved `TypeSyntax`, application arguments, `PlaceSyntax`, source spans, canonical record metadata, and sequence storage lowering. Result-obligation, polymorphism, generic-record, local-declaration, and sequence owners coordinate with Driver for production acceptance.
