# Record overlays

## What it is

Newer Jai sources use `#overlay(anchor) name: Type` to declare an explicitly anchored storage alias. Preparation for this form is separate from the older [`#place` cursor directive](record-placement-layout.md); the production parser retains a distinct typed field attribute, while semantic binding requires the separately established overlay cursor policy. See [ordered record source metadata](ordered-record-source-metadata.md).

## How it works

The supplied Focus input module uses a `u32` alias over four boolean fields. Its pane record has two pointer fields, each with two pointer aliases. Other supplied sources use an array alias spanning several fields and a slice alias spanning an earlier count and pointer. These are genuine physical aliases; separate semantic record fields must retain their canonical `FieldId` identities and shared byte offsets.

The inspected examples do not establish what happens to an ordinary field after a shorter overlay, whether an overlay may extend the previous occupied extent, or how an incompatible anchor alignment is handled. The old placement kernel rewinds the ordinary cursor. A private overlay candidate instead positions one field and restores that cursor. For fields with sizes `16, 8, 8` and the middle field anchored to the first, those policies produce offsets `[0, 0, 8]` and `[0, 0, 16]` respectively. Do not select a policy merely because both produce the same Focus geometry.

Private preparation uses one placement carrier containing an owner-bound anchor and an explicit kind. It retains the existing cursor mode and a separately marked overlay candidate. Definition is transactional: forward anchors, foreign owners, and union placement are rejected before publishing a record. The candidate rejects an incompatible alias alignment instead of silently moving the alias away from its anchor; that restriction is a provisional admission boundary, not an established language rule.

The [evidence manifest](../artifacts/record-overlay-evidence.json) records source paths, line numbers, content hashes, and the unresolved policies without copying source bodies. Five private geometry tests, four symbol-binding tests, and six tests using a private copy of the actual registry/layout sources passed. They establish the candidate implementation's behavior, not source acceptance. No supplied native compiler, object, library, or executable was run or loaded.

## How to change it

Keep the field prefix's actual target syntax and span until semantic binding. Resolve the anchor structurally against earlier selected physical fields; preserve anonymous-field ordinals without inventing field names. The transactional registry should manufacture the retained `FieldId` using the actual reserved record identity. Use one canonical placement vector with an explicit kind rather than a second overlay-offset table.

Before activating a source producer, settle the cursor, extent, and alignment rules with primary evidence and run tests that distinguish them. Update the target layout walker, frozen registry proofs, VM layout-cache work accounting, native byte storage, and all source-record builders together. Pointer aliases must preserve provenance across writes and whole copies.

All overlapping constructors need the [ordered initialization recipe](ordered-record-initialization.md), including complete constructors with no `---`. Declaration defaults and later overrides cannot be collapsed to one value per field. An overlay with `---` contributes no write; it must not erase an earlier initialized alias.

## Configuration

There are no new environment variables or CLI switches. Target pointer width, scalar layouts, record packing, and explicit field alignment determine physical geometry. Production schema activation is coordinated with the compiler's shared consumer gate; staged checks do not bypass it.

## Dependencies

This feature uses `jai-syntax` field-prefix parsing, selected source members in `jai-sema`, canonical identities and target layouts in `jai-types`, ordered storage recipes in `jai-ir`, and byte-preserving VM/native record storage. The evidence comes from the supplied Focus, Vk-Engine, and sgpu sources read as text.
