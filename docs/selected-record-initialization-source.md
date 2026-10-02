# Selected record initialization source

## What it is

A record retains its exact successfully selected body as an immutable source sidecar. Construction uses that body to preserve declaration defaults and body overrides as distinct actions, including repeated writes to overlapping storage.

## How it works

Module, static, anonymous and generic materialization publishes an `Arc` of selected `RecordMember` values only after successful shape and namespace materialization. It retains the actual canonical owner, defining file, source location and original specialization substitution. A retry borrows the retained sequence instead of selecting conditions again. Borrowed source requires one owned copy; an expanded owned body moves into the sidecar.

Local records retain the original `LocalDeclarationId`, canonical owner, selected body and actual captured `SourceEnvironment`. The sidecar and namespace share the same environment `Arc`; this includes lexical bindings, source, substitution, checks and procedure ownership. The field-only path also publishes the sidecar after successful default preparation.

The staged `record_initialization_source.rs` journal validates each actual `FieldId` path before any initializer evaluation. It retains member ordinals rather than sorting spans. Explicit action expressions borrow their exact original AST; they are not copied or reconstructed from final field values. A declaration-site `---` produces a distinct `NoWrite` action, while an implicit default retains its actual target type. An override `field = ---` remains a source-located unsupported boundary.

For `a:int=1; b:int=2; a=42;`, the journal retains `a=1`, `b=2`, `a=42`. This establishes source chronology, but does not itself establish typed per-action values or resumable preparation receipts. The journal remains unregistered until the paired ordered recipe producers and consumers activate. Four actual parser/type-registry tests pass in a standalone harness with warnings denied; integrated sidecar and source-to-VM/native checks remain separate gates.

## How to change it

`modules/aggregates/parameterized/state.rs` owns module sidecars; `materialize.rs` publishes them. Local registry and `local_declarations/namespaces.rs` own local publication. Preserve successful publication boundaries and the original captured environment when changing retries, branch selection or insertion expansion.

Extend the staged journal with new canonical path categories deliberately. It currently requires struct intermediates and rejects union intermediates, runtime index paths and unselected/unexpanded bodies. The eventual preparation ledger must retain an original receipt for every default and override at its actual evaluation boundary. A completed final per-field default cache cannot recover overwritten values or their write order.

## Configuration

There are no new flags or environment variables. Selected member retention and journal actions are bounded at 65,536 entries. Canonical journal paths are bounded at 128 steps and one million cumulative path steps. Existing source parsing and semantic admission limits remain applicable.

## Dependencies

The sidecars depend on source selection, `jai-syntax` record members, canonical `jai-types` ownership, original `FileInstanceId` and `LocalDeclarationId`, specialization substitutions and captured semantic source environments. Ordered recipe integration depends on [ordered record initialization](ordered-record-initialization.md); literal projection remains covered by [promoted record literals](promoted-record-literals.md).
