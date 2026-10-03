# Ordered record source metadata

## What it is

Record parsing retains `#place`, field `#overlay(...)` prefixes, and source reflection reductions as typed AST metadata. Source acceptance and checked physical storage support are separate stages.

## How it works

A `RecordMember::Placement` stays in the actual body sequence, with the original structural target and directive span. `FieldAttribute::Placement` retains the distinct overlay kind, parentheses, target and span alongside `using` and `#as` qualifiers. `RecordAttribute::Reflection` retains the canonical reflection flag and original directive span. Unknown spellings and repeated settings remain diagnostics.

After conditional selection, static, parameterized, anonymous and local record producers bind `#place` anchors to earlier directly declared physical fields. Anonymous storage consumes an ordinal without receiving an invented name. The checked registry creates owner-bound `FieldId`s through `define_record_with_placements`; namespace declarations cannot supply an anchor. The existing layout engine rewinds its cursor, preserves the maximum occupied extent and verifies field ownership. Qualified, indexed and dereferenced anchors remain a checked implementation boundary.

Source reflection settings use `add_record_reflection_flags` on the original nominal identity. Procedure reduction changes descriptor edges while retaining each actual procedure field type, calling convention, context policy, physical layout and ABI. `#type_info_none` uses the same existing policy. `NoSizeComplaint` is retained; there is currently no large-metadata warning producer to suppress.

The newer overlay syntax has an explicit semantic boundary: its effect on the following ordinary field's cursor is not yet established. Binding reports `field #overlay requires a checked overlay cursor policy` at the real target. It is never silently converted into an old `#place` directive. Whole placed-record defaults and literals report `placed record construction requires an ordered storage initialization recipe`; a final independent value for each semantic field cannot represent overlapping source writes. Existing pointer projections, canonical layout and storage consumers remain separate from constructing such values.

Quoted AST traversal charges both placement forms and visits structural targets with the existing node/depth budgets. Name-retention and conditional-selection consumers keep placement nodes as metadata rather than declarations or runtime writes.

## How to change it

Update the syntax helpers, typed enums and bounded quote walker together. Route selected members through `source_placement_ordinals` before field ordinals are assigned. Extend anchor resolution only with actual canonical field identity proof. Overlay support needs a verified explicit layout mode, including later cursor behavior, extent and alignment; do not reuse cursor rewind by assumption.

Construction support must publish an ordered storage recipe and retain explicit writes, implicit defaults and `---` no-write entries in source chronology. Replace the constructor guard only after sema, IR, VM and native consumers support that recipe. The six `ordered-record-source-metadata` source tests cover shape identities, selected branches, reflection policies and honest unsupported boundaries; syntax integration tests inspect complete AST nodes, source spans and malformed inputs. These new tests are authored and pending the centralized integration gate.

## Configuration

No parser flags are required. Layout queries use the selected target policy; the focused source tests use LP64. Reflection settings belong to one canonical registry, never to matching names in another source arena. Integration uses the repository's locked offline Cargo environment, with the integration owner holding the build lease.

## Dependencies

`jai-lexer`, `jai-syntax` expression/place parsing and source spans, selected record bodies in `jai-sema`, `jai-types` owner-bound record layouts and reflection policy, and the existing bounded quote visitor. Whole original corpus parsing must be rerun with the rebuilt CLI; historical helper tests do not establish this new production packet's acceptance.
