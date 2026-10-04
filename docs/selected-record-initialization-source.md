# Selected record initialization source

## What it is

A record retains its exact successfully selected body as an immutable source sidecar. Construction uses that body to preserve declaration defaults and body overrides as distinct actions, including repeated writes to overlapping storage.

## How it works

Module, static, anonymous and generic materialization publishes an `Arc` of selected `RecordMember` values only after successful shape and namespace materialization. It retains the actual canonical owner, defining file, source location and original specialization substitution. A retry borrows the retained sequence instead of selecting conditions again. Borrowed source requires one owned copy; an expanded owned body moves into the sidecar.

Local records retain the original `LocalDeclarationId`, canonical owner, selected body and actual captured `SourceEnvironment`. The sidecar and namespace share the same environment `Arc`; this includes lexical bindings, source, substitution, checks and procedure ownership. The field-only path also publishes the sidecar after successful default preparation.

The staged `record_initialization_source.rs` journal validates each actual `FieldId` path before any initializer evaluation. It retains member ordinals rather than sorting spans. Explicit action expressions borrow their exact original AST; they are not copied or reconstructed from final field values. A declaration-site `---` produces a distinct `NoWrite` action, while an implicit default retains its actual target type. An override `field = ---` remains a source-located unsupported boundary.

For `a:int=1; b:int=2; a=42;`, the journal retains `a=1`, `b=2`, `a=42`. This establishes source chronology, but does not itself establish typed per-action values or resumable preparation receipts. The journal remains unregistered until the paired ordered recipe producers and consumers activate. Four actual parser/type-registry tests pass in a standalone harness with warnings denied; integrated sidecar and source-to-VM/native checks remain separate gates.

Logical interop bitfields require the same original journal because their actual `FieldId` writes share a physical unit. A [held guard companion](../artifacts/bitfield-original-source-guard-readiness.json) checks actual `RecordLayout.field_bitfields` and placements at runtime literal, source constant and recursive default construction entry points before field-map/default or initializer consumption. It rejects construction until the original ordered source recipe is published. The companion is formatted and applies to its captured bases; compilation and execution remain unverified. Shape publication, physical IR zero backing and foreign pointer field access remain separate operations. A grouped final default map or an ordinal-only IR record recipe does not prove source write chronology.

The ordered constant conversion/classification patch is staged in `/private/tmp/jai-ordered-literal-consumers`, pending the matching `ConstantKind::OrderedRecord` schema. It uses the shared journal validator to check the complete actual nominal path list and its metadata budget before consuming an initializer, checks every terminal type, then preserves the owned action sequence and backing state. Concrete literal classification charges path metadata as well as RHS values. The current live classifier keeps these expressions runtime-bound. Its admission patch is held separately until native emission provides stable ordered constant backing, or source lowering supplies sealed static address/slice storage; the constant schema and converter alone do not prove an escaping array view has a valid lifetime. see `artifacts/ordered-literal-conversion-readiness.json` for hashes and the remaining source-receipt scheduler boundary.

Seven additional literal target inference/contract adapters are staged in `/private/tmp/jai-literal-inference-consumers`. Mutable lexical and parameterized sites consume the original `TypeSyntax`, and discarded argument validation uses the existing annotation preview. Readonly global/default sites still require a successful original type application proof from retained preparation; they cannot substitute an expected type or replay source effects. These adapters are formatted but await the coherent literal source schema compile.

The current small private syntax component combines literal targets with reflection settings, `#place`, and the transitional loop marker while retaining the live anonymous procedure header/lookahead. Its 180 syntax tests and three literal target tests pass; six explicitly hashed unchanged source files parse wholly. `artifacts/frontend-literal-current-syntax-proof.json` records those file counts, commands, and hashes. The combined parser evidence does not imply semantic or native acceptance.

## How to change it

`modules/aggregates/parameterized/state.rs` owns module sidecars; `materialize.rs` publishes them. Local registry and `local_declarations/namespaces.rs` own local publication. Preserve successful publication boundaries and the original captured environment when changing retries, branch selection or insertion expansion.

Extend the staged journal with new canonical path categories deliberately. It currently requires struct intermediates and rejects union intermediates, runtime index paths and unselected/unexpanded bodies. The eventual preparation ledger must retain an original receipt for every default and override at its actual evaluation boundary. A completed final per-field default cache cannot recover overwritten values or their write order.

Merge the bitfield companion's constructor guards surgically with literal target and source preparation changes. Preserve the guards ahead of default collection, plan composition and RHS checking. Replace rejection only with actual per-action source receipts and complete path preflight; do not bypass it by reconstructing a physical recipe from final field values.

## Configuration

There are no new flags or environment variables. Selected member retention and journal actions are bounded at 65,536 entries. Canonical journal paths are bounded at 128 steps and one million cumulative path steps. Existing source parsing and semantic admission limits remain applicable.

## Dependencies

The sidecars depend on source selection, `jai-syntax` record members, canonical `jai-types` ownership, original `FileInstanceId` and `LocalDeclarationId`, specialization substitutions and captured semantic source environments. Ordered recipe integration depends on [ordered record initialization](ordered-record-initialization.md); literal projection remains covered by [promoted record literals](promoted-record-literals.md).
