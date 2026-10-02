# Type restriction facts

## What it is

Generic matching can inspect a record's declared `using` ancestry and its visible member types without converting its value. These facts preserve the actual supplied type and remain separate from directional `#as` conversions.

## How it works

`restriction_facts.rs` reads the same local, specialized, context, and file record metadata used by ordinary member resolution. Every inspected field is checked against its canonical `FieldId` owner and type. An ancestry query follows only fields marked `using`; unrelated fields and `#as` fields do not establish ancestry. The matcher handles pointer patterns separately, so this query never silently removes pointer levels.

The supplied `160_type_restrictions.jai` tutorial uses records embedding an `Entity` through `#as using` and contrasts a restricted generic parameter with conversion to the base record: the generic parameter retains the full supplied type. The query follows the `using` marker in that declaration; `#as` remains the separate conversion mechanism.

An interface member query inspects direct fields and fields promoted through `using`. Missing members return no match. Multiple visible paths to a name, multiple paths to a required ancestor, cycles, or invalid field metadata produce source diagnostics. The matcher compares each required member's exact type and retains the actual record type after a successful restriction.

The source/VM regressions in `jai-sema/tests/type-restriction-facts.rs` exercise nested ancestry, pointer patterns, local records, promoted interface fields, and exact member types. A derived-only field remains available inside the specialized body. Unrelated and conversion-only fields do not satisfy ancestry; missing, mismatched, and duplicate promoted members reject with original source locations.

## How to change it

Extend `restricted_nominal_ancestor` or `restricted_interface_member` when adding new restriction facts. Keep the walk immutable and preserve canonical field identities. Change the matcher in `overloads` and `polymorphism` for applicability and specialization rules; do not lower a restriction as a field projection or cast.

## Configuration

There is no feature flag. Traversal allows at most 128 ancestry levels and 4096 record or field visits per query; exceeding either bound produces a diagnostic.

## Dependencies

The helper uses `jai-types` identity and field validation, semantic record metadata, original source symbols and spans, and the generic overload matcher. It requires no external service or compiler artifact.
