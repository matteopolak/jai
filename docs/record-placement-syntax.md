# Record placement syntax

## What it is

The production record parser preserves ordered `#place` members and distinct `#overlay` field attributes with original source spans. [Ordered record source metadata](ordered-record-source-metadata.md) describes checked layout publication and the remaining construction and overlay policy boundaries.

## How it works

The helper consumes `#place info;` into `RecordPlacementSyntax { target, span }`. The target uses the existing structural `PlaceSyntax`; its span contains only the target, while the placement span includes the directive and semicolon. The following member remains unread. Calls and scalar values are rejected as anchors, and an initializer after an anchor is rejected rather than converted into a field declaration.

The syntax preserves qualified and indexed targets without proving that they name a legal earlier field. Checked layout must establish that identity and explicitly reject unsupported target categories. Placement changes a record layout cursor; it does not allocate independent storage for overlaid members or determine which overlapping defaults write bytes.

The book's `13.1_unions.jai` rewinds to an earlier scalar or `void` field. The supplied Thread module rewinds to `info` before a padding array initialized with `---`. These examples establish anchor syntax, but they do not justify treating uninitialized padding as a zero write over the existing information field. See [Thread placement acceptance](thread-placement-acceptance.md) for the separate VM/native layout fixtures.

The field prefix parser preserves the newer field prefix `#overlay(anchor) alias:Type;` as `FieldPlacementSyntax::Overlay { target, span }`. Its parentheses belong to the overlay span, and line breaks do not join the directive to a fabricated field name. `#as` and `using` qualifiers may surround the overlay and retain their separate meanings. This prefix is distinct from record-body `#place`; the supplied aliases do not establish how an overlay changes the cursor for a later ordinary field.

## How to change it

Update `crates/jai-syntax/src/record_placement.rs` and its boundary tests when extending the anchor grammar. Activate the record-member variant and dispatch only with exhaustive selected-member consumers, canonical field identity binding, layout extent handling, and initialization-write policy. Preserve source ordering and original anchor spans through generic specialization and inactive branch selection.

The field prefix parser is `field_placement.rs`. Its typed AST is accepted independently of the checked overlay cursor policy. Semantic binding reports the explicit unsupported boundary; do not substitute a record-body placement node.

Run the focused tests with `RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-syntax --lib --locked --offline -j1 record_placement::tests`.

## Configuration

There are no parser configuration flags. The scalar compatibility parser explicitly rejects placement because it has no checked layout binding.

## Dependencies

The lexer directive token, existing expression and place parsers, source spans, and the forthcoming checked record layout/default consumers. Syntax tests use authored strings; source evidence is read without executing supplied native assets.
