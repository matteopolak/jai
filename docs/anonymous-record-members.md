# Anonymous record members

## What it is

A record body can contain an unnamed `struct` or `union` member. The supplied Compiler source uses an anonymous union for alternative pointer-literal payloads; Focus language-token records use the same structure for alternative token categories.

## How it works

`RecordMember::AnonymousRecord` owns the nested `RecordTypeSyntax` without assigning a source name. It preserves struct/union kind, ordered nested members, layout attributes, notes, and original span. A following semicolon is optional: unchanged Compiler definitions include it, while pinned Focus token definitions omit it. Braces still delimit the nested member and keep surrounding fields in source order.

This member describes nested physical storage with implicit field promotion. It is distinct from a named nested type declaration and from a named field with an inline record type. The checked layout and namespace phases must retain that distinction: flattening union alternatives into sibling struct fields would change offsets, size, and aliasing. Symbol lookup must follow promoted checked field paths rather than invent an identifier for anonymous storage.

The specialization and lexical resolvers enumerate physical members in source order. `FieldSource` retains either the original named field declaration or the anonymous record node. `FieldMetadata.name` and reflected field names are optional; identities and types remain mandatory. Promoted lookup, using parameters, module interfaces, callback metadata, and layout all consume that same checked schema. Duplicate visible names and by-value cycles are rejected.

Unnamed structs keep declaration-site defaults. An anonymous union defaults to zero storage only when every real alternative has a checked zero default, including nested structs. Conflicting or nonzero defaults require an explicit active alternative; named union defaults retain their existing policy. A declaration with `= ---` can be assigned through promoted fields and then read through another view of the same bytes. This uses actual union storage without inventing an anonymous field name. Positional initialization constructs physical fields directly by ID: for an unnamed struct child, `value: Owner = .{.{20, 22}}` supplies that child without synthesizing a field name.

## How to change it

`jai-syntax/src/anonymous_records.rs` parses this record-body form through the shared record-type parser. `record_members.rs` dispatches unnamed keywords before ordinary field declarations. Its parser regressions cover supplied Compiler pointer alternatives, Focus's omitted semicolon, nested anonymous structs inside unions, definition order, and incomplete bodies. Independently authored semantic and native fixtures cover defaults, overlapping union views, surrounding fields, using parameters, specialization defaults and recursive pointers, lexical shadowing, duplicate promotions, and cycles. The owned metadata regression checks absent names, real field IDs, child types, and target offsets.

Extend semantic layout through the canonical physical field metadata, keeping optional source names separate from field identity. Update record selection, local namespaces, scoped dependency traversal, inserted record members, and reflection together; all retain the same ordered body.

The current source suite passes ten tests, including nine VM results of `42` and six rejection cases grouped in one test. Eight native fixtures pass at both O0 and O2, producing sixteen independently generated executions with exit code `42`. These fixtures use our own source and generated output; original project acceptance is tracked separately.

## Configuration

There are no syntax flags or environment variables. Target layout policy and normal record attributes govern physical layout downstream.

## Dependencies

The feature uses `jai-syntax` record/type AST, `jai-source` original spans, canonical type and physical field registries, and checked field-promotion metadata. It adds no external dependency and executes no supplied compiler artifact.

## Project evidence

The unchanged pinned book source `examples/12/12.13_anonymous_struct.jai` and Jaison `generic.jai` both use this form. The fresh integrated snapshot `8a52b33b` records genuine Jails and book entrypoint attempts with actual Preload and Basic module discovery in `artifacts/corpus-8a52b33b-inline-project-roots.json`. Jails and hello-sailor advance to Basic's caller-export syntax at line 181; the anonymous-struct example stops at its inline runtime type value. The separate original book inlining program passes all stages through native execution, as recorded in `artifacts/native-book-inlining-8a52b33b.json`. These distinct results do not establish a successful Jails project build. See [Newer project entrypoints](newer-project-entrypoints.md) for source and snapshot provenance.
