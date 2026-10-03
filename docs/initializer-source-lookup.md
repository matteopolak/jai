# Initializer source lookup

## What it is

An original global initializer may call source added by a root `#run`. The retained controller records that initializer's actual lookup demand and selects an independent original producer before publishing the missing source.

The coordinated source candidate passes four semantic tests, two diagnostic-receipt tests, and seven workspace tests. These gates cover direct generated callees, actual lookup receipts, builtin-type alternatives, repeated pending ownership, source publication, and failing-producer rollback. The candidate awaits checkpoint publication; its held callback-annotation and general inferred-type extensions are separate work.

## How it works

Initializer jobs keep their original declaration, file, global storage ID, expected canonical type, expression, source span, and shared auxiliary procedure owner. Ordinary call initializers enter the same retained expression binder as explicit `#run` initializers. A builtin type value whose name is genuinely absent from the defining graph scope also enters that binder. The syntax builtin catalog and canonical type registry resolve its actual type value before destination checking; an incompatible storage destination remains a hard type error.

A controller-owned lookup attempt records an original `LookupError::UnknownName` or `UnknownMember`. It retains the complete `NamePath`, existing consumer declaration, defining file, original source span, and immutable source allocation. Successful binding alternatives do not publish a demand. A failed binding must carry the exact opaque `DiagnosticMarker` attached by the authoritative failed lookup before the controller admits its proof. The receipt also matches the original source occurrence and retained graph facts. Matching source spans or diagnostic text cannot admit a demand. For example, an unavailable graph probe for `bool` may resolve through the builtin type alternative; a later type mismatch receives a new diagnostic without that probe's receipt and remains a hard failure.

`SourcePreparationPending` carries this lookup cause separately from `PendingType`. The cause owns an existing consumer; it contains no guessed declaration for the generated name and adds no VM dependency. Real effect waits remain in `LibraryPending.dependencies` beside the source cause.

A checked direct source call first requests its real callee's body if that body is unavailable. This happens before starting the initializer VM transaction. The controller can then bind that selected body, record a genuine missing lookup inside it, and run an independent original source producer. The shared body and VM caches retain their checked identities.

An explicit source prefix may service a demand only while actual original root runs remain. Each completed original run yields `Ready`, allowing the workspace driver to inspect its real private input and configuration journals. A changed graph retires the old semantic arena before preparation against the published source. Global storage still publishes in original source order after a checked value exists.

For example, `value: int = #run generated();` can wait for an original root run that adds the actual `generated` procedure. If all original producers finish without supplying that binding, the next attempt reports the original lookup as a hard failure. It cannot declare the initializer ready or retain an empty VM wait indefinitely.

## How to change it

Extend `source_lookup_demands` and the authoritative `FileScope` lookup adapter together. Retain the actual lookup failure and source occurrence; do not inspect diagnostic text or invent a placeholder reservation. The attempt registry belongs to one immutable semantic graph. Each completed retry replaces its actual owner's retained proof; successful binding or hard failure retires that proof. Repeated effect polling cannot append a lookup history. `Diagnostic::clone` and source-origin rebasing preserve an attached receipt. Ordinary diagnostic constructors create no receipt. An adapter must attach a receipt only to the lookup error it actually returns; it cannot copy one from a successful fallback probe.

Changes to initializer admission must preserve the existing `global_initializers::Jobs` ownership and publication checks. Earlier genuinely published globals may be read by a producer. A later global cannot be represented by zero storage or a fabricated `GlobalId` while the source producer runs.

The current producer covers checked direct calls and explicit global result types. General inferred result-type readiness, arbitrary indirect callee dependencies, source defaults that themselves require generated names, and global dependency cycles need their own typed requests. The executed gates do not establish those paths.

## Configuration

The workspace scheduler explicitly calls `drive_source_prefix`. Direct library driving keeps its current source ordering and does not claim to consume a source publication round. Normal target/layout options, compile-time VM limits, source-pass limits, and replay limits still apply. There is no compatibility flag or fallback type.

## Dependencies

This path uses `jai-source` diagnostic receipts, the module graph's real lookup and source allocation, original initializer jobs, checked source procedure signatures and bodies, the shared compile-time cache and callback proofs, and the workspace source-prefix controller. It builds on retained ordinary source-default readiness. Source effects use the existing private build frame and replay journal; graph publication requires cancellation and retirement of the old semantic arena.
