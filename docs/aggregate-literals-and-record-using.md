# Aggregate literals and selected record using

## What it is

Aggregate literals keep their original type syntax and relative field/index targets through parsing, overload selection, declaration defaults, and typed lowering. Selected record `using` directives expose names through their actual canonical fields or enum namespace.

## How it works

`Pair(int).{left=20,right=22}`, `([]u8).{count=2,data=pointer}`, and contextual `{left=20,right=22}` retain `TypeSyntax` rather than a printed name. Each named initializer keeps a `PlaceSyntax`; field names are relative to the target, while index expressions resolve in the defining lexical environment.

The indexed path planner validates canonical owners, index bounds, duplicate paths, whole-value/projected overlap, and competing union alternatives before lowering any initializer RHS. Lowering captures nonliteral values once in written order and then composes the pure aggregate. Declaration defaults and overload baking use the same plan, including genuine field and array element defaults. A defaulted type application compares the actual template and accepted argument recipes; omitted defaults use the original declaration scope with preceding checked formals.

Fields retain `using_selection`. Direct fields remain visible, and `only`/`except` applies to names reached through the promoted child. Bare record targets retain `RecordMember::Using`; physical targets resolve actual `FieldId` paths, and nested `using Codes::enum { ... }` retains the original enum followed by its original promotion directive. Namespace preparation publishes the real checked enum values. A selected import keeps a namespace import followed by a genuine source `using` request, so discovery can validate its original selector and visibility.

Pointer-valued record promotion requires a dereference-bearing path representation; this change reports that missing producer instead of replacing it with a pointee field ID. Computed record filters retain their expressions and require checked source publication. Placed/overlaid record construction continues to require the real ordered storage recipe. Bare static record namespace exports require checked member recipes; the finite namespace producer here covers canonical enums. These are source diagnostics, not successful acceptance.

## How to change it

Declaration defaults and procedure literals share the original indexed source path validator within `modules::aggregates`. Record namespace promotion uses the existing `parameterized::members::shadow` helper, so both declarations and selected `using` update the same checked substitution. Keep these helpers scoped to their owning aggregate subsystem when adding sibling consumers.

Extend relative targets in `aggregate_literals.rs`, `overloads/record_targets.rs`, and `promoted_literals/indexed_source.rs` together. Array and record literal targets share `literal_named_type` in `array_literal_targets.rs`, so builtin spelling and qualified-name conversion stay consistent. Extend that shared conversion once rather than defining a second method on the parser. Keep field/index source spans and make every new projection pass canonical validation. Update typed lowering, default constants, applicability/baking, readiness classification, and both retained source visitors when adding a target kind.

Record visibility is shared by `record_using`, canonical field projection, annotation `type_of`, and lexical `using`. Change those consumers together; hidden names must not enter ambiguity checking or runtime shadow preparation. Namespace directives add no physical fields or writes. A caller-marked place must remain an invalid relative target when the separate caller-reference packet is combined.

The graph-only `ModuleGraph::load` entry point reports `Pending` when lexical `using` requires semantic source evaluation. The supported preparation path keeps the actual `GraphDiscovery` session, checks its pending requests with `resolve_discovery_using`, admits returned decisions through `resolve_using`, and advances the same source graph. It retains original declaration IDs and source owners rather than forcing discovery complete. The driver already performs this preparation; the aggregate fixture now uses the same public producer boundary before normal semantic checking and VM execution. If no decision or specialization progresses, the fixture reports the original pending diagnostics.

The active integration tests exercise actual `ModuleGraph` preparation and VM execution. The private packet authors these tests but does not claim they ran; integrated Cargo and corpus feedback belong to the parent build lease.

## Configuration

Existing compiler limits apply: `MAX_CONSTANT_DEPTH` bounds projection depth and `MAX_CONSTANT_CELLS` bounds literal paths and composition. Record source preparation bounds selected member and promotion traversal. There are no new environment variables or flags.

## Dependencies

The parser depends on `jai-lexer`, `jai-source`, and the existing source type/place AST. Semantic consumers use the same `TypeRegistry`, `RecordSpecializations`, `NominalView`, field defaults, and lexical scope. Composition emits existing IR `Bind`, `Record`, `Union`, and sequence values for `jai-vm`; no native Code ABI or replacement nominal identities are introduced. The declaration-list, caller-reference, enum-body/import, assertion/note, and root constant-field-projection packets have independent shared hooks that must be coalesced surgically.
