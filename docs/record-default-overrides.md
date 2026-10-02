# Record default overrides

## What it is

A plain assignment inside a record body overrides a field's construction default for that record. The supplied Compiler source uses `base.kind = .DECLARATION;` after a `#as using` field; the override is part of the record definition rather than an executable statement.

## How it works

`RecordMember::DefaultOverride` preserves the target as `PlaceSyntax`, its value as an expression, and its complete original span. Overrides remain ordered alongside fields, declarations, assertions, and conditional branches. Nested paths such as `base.details.flags` retain each source name; the parser assigns no field or nominal type identity.

The syntax parser accepts plain `=` and requires a syntactic place. Calls as targets, missing path names, missing values, and missing terminators are rejected. Semantic selection retains active assignments in their original order. Each named target resolves to canonical physical field projections; `using` and anonymous record fields may contribute multiple physical steps. Ambiguity, cycles, unavailable metadata, invalid field ownership, and depth limits produce diagnostics.

The module/template default evaluator checks the assigned expression in the owning record's definition file and baked substitution. The local-record binder checks it in the captured lexical namespace. Both replace an owned root-field constant through the same typed projection writer. Changing a derived record's defaults therefore does not mutate the canonical defaults of a shared nested record type. Explicit construction values still take precedence over defaults. Inactive conditional and case branches retain syntax without applying assignments.

Direct quoted record insertion preserves assignments before branch selection. The current typed paths accept direct or promoted named struct fields. Index, pointer, and union paths receive source-located diagnostics. Failures do not publish partially updated default constants; retries use the existing source and field identities.

## How to change it

`jai-syntax/src/record_defaults.rs` owns the place/value parser, and `record_members.rs` connects it to the canonical ordered body. Tests use the actual Compiler inherited-default shape and a conditional nested path. Preserve overrides when selecting branches, converting inserted record members, or inspecting record metadata; a field-only iterator is insufficient to describe the whole record definition.

`jai-syntax/tests/local-record-boundaries.rs` also checks local records containing defaults, overrides, and methods whose parameter defaults construct that same record. The method body, record body, and enclosing procedure retain distinct closing boundaries and source spans.

`modules/aggregates/parameterized/default_overrides.rs` resolves selected targets and stores ordered assignments under their root `FieldId`. `modules/aggregates/defaults.rs` evaluates module and template defaults; `local_declarations/default_overrides.rs` publishes local defaults after all selected assignments succeed. `record_default_overrides.rs` validates promotion paths and reconstructs immutable constants. Keep the owner's field identities distinct from descendant type defaults. Extend target support deliberately rather than reinterpreting source paths as module namespaces.

## Configuration

There are no syntax flags or environment variables. Existing record selection and constant depth/cell limits apply. Physical promotion traversal is bounded by 65,536 visited or queued declarations and the constant depth budget.

## Dependencies

The feature uses the ordered record AST, expression parser, structural `PlaceSyntax`, original source spans, and semantic record/default registries. It adds no external dependency and executes no supplied compiler artifact.
