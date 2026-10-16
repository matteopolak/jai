# Passive selected-analysis metadata

This additive audit API follows the completed current native proof; it does not
hold or replace that acceptance. On exact guarded 603 + stable LSP patches,
fresh native requests passed 118/118 (42 phases, six sequential servers).
See [current acceptance](lsp-current-source-acceptance.md).

## API and provenance

SemanticCoverage now has analysis: SemanticAnalysisContext. The existing
context_id and counters are unchanged. The context exposes optional observations:

| Field | Actual observation |
| --- | --- |
| root | Root argument used to create the cached Analysis. This remains the outer analysis origin if focus selects a generated workspace. |
| entry | The directly observed compile_program entry argument for the selected program. It swaps with that compiler during focus. Generated-workspace entries are unknown and remain None. |
| import_dirs | Exact selected compiler.options.import_paths, preserving order and native spelling; observed empty is Some(empty), not unknown. |
| workspace_id | Actual selected compiler.workspace. Interpret together with context_id; IDs are not globally unique. |

Root and entry are source-file paths, not the entry-point function name. They
come from the actual analysis/compile invocation, never the scanner CLI default,
caller leaf filename, loaded-source ordering or a guessed symbol. Import paths
and workspace ID come from the compiler currently selected by existing focus.
No new filesystem lookup, environment-options callback, typecheck, metaprogram
execution or selection rule is introduced. Cache identity, namespace/privacy,
URI normalization, diagnostics and compiler behavior are unchanged.

SemanticPath exposes path: PathBuf to trusted Rust consumers and identity: String
for audit output. Both serde serialization and Debug omit raw paths. Serialized
paths are objects containing only identity, so existing redacted scanner report
serialization remains safe without a new report.redact branch. Non-redacted
consumers must explicitly project path if they want native paths in their output.
Do not add that projection to redacted output or diagnostic strings.

Identities use a domain-separated existing non-cryptographic hash over native
Path data, without filename case folding or filesystem canonicalization. They
are opaque audit/change-detection values, not cryptographic anonymity, release
hashes, authorization or proof of filesystem alias equivalence. Potential hash
collisions must not determine symbol lookup/privacy. Use actual paths locally
for classification and existing filesystem-proven URI identity for navigation.

No semantic environment returns the existing None coverage result; no fake
analysis is created. Unobserved fields remain None, serialized as null. In
particular, never fill an unknown generated entry from outer root or CLI intent
just to classify it as a real-root analysis.

## Compiler/scanner handoff

The prior shared SemanticCoverage scaffold already exists in frozen 603. Producer
commit 5fe3fb95 only synchronizes that prerequisite into the older owned baseline;
do not apply it twice to the shared tree. Apply the subsequent metadata change
over the existing scaffold. Only LSP semantic.rs/lib.rs and original tests change;
no scanner, parser, decls, scope filter or other Core file is modified here.

Scanner consumers should inspect coverage.analysis and distinguish:

- actual entry equal to the queried file: a directly observed entry analysis;
- actual entry different from a loaded queried file: a leaf reached under that entry;
- missing entry: unknown, including generated workspace entries currently unavailable.

Use native Path values already present in memory; metadata acquisition must not
trigger a fresh compile or filesystem resolution. Compare against the scanner's
existing filesystem-proven input/URI normalization, preserving filename case;
raw spelling differences alone do not disprove a proven alias. Preserve context_id plus
workspace_id when comparing selected contexts. Root denotes cache provenance,
so do not silently substitute it for a missing selected entry.

The current scanner's synthetic SemanticCoverage literal in
examples/ide_coverage/report.rs must add analysis: Default::default(). This is
unknown data in a synthetic unit fixture, not a fabricated production context.
A suggested one-hunk patch is in owned T7
context-observability-60321c1d-20261016/scanner-synthetic-fixture-handoff.patch;
it has not been applied to the peer scanner. Main/compiler owner handles that
consumer update and any new classification policy. No whole 603 audit restart
is required; use the metadata for the next candidate.

Core coordination request: current ide_selected_entry is private and has no
read-only accessor. If generated workspace entries are required, compiler owner
can expose the already-recorded Option<PathBuf> through a reviewed passive
accessor. This worker does not change Core fields or infer missing entries.

## Tests and source identity

Original tests/semantic_context.rs uses real Session analyses of original
VirtualFs documents. A leaf under jai.toml's configured entry is compared with
standalone analysis of that same leaf. Assertions inspect actual root/entry and
options-derived import paths, not only nonempty IDs. Changing the options path by
the actual selected root proves the caller leaf is not used to guess it.

The other cases verify unchanged compile/options-call counters after warm-up,
stable repeated observations, serialized/Debug path redaction, null unknown
fields and no semantic context or compile in syntax-only sessions. Generated
workspace execution is not part of this new focused test scope; its entry stays
explicitly unknown rather than being counted as implemented observation.

All receipts: assigned T7 scratch/context-observability-60321c1d-20261016.

- context-red.log: initial fixture byte-array conversion compile error, not a feature result.
- context-red-fixture.log: three valid focused cases fail before metadata implementation.
- context-green.log: initial focused cases pass after implementation.
- context-focused-final.log: 59 checks pass (36 library, four context, four URI,
  four qualified values and 11 named arguments).
- context-clippy.log: scoped LSP library/tests warnings-denied Clippy passes.
- Scoped rustfmt check passes; no intentionally incomplete Jai document is
  claimed as a formatter/linter pass.
- context-summary.json and context-source-hashes.json: accepted 603 base is
  preserved; only LSP semantic.rs/lib.rs and the new original test differ.

Effective metadata source/test/config fingerprint:
e8b9aa8a93d97231f4465fe717f04f03e47808400aa1c5dc9d59cd3b8667d79a.
No unexpected base drift or Core changes. No native suite rerun, broad corpus
replay, busy-loop/compiler fix, benchmark, release, remote action or peer write.
Native Windows and final integrated scanner/CI verification remain required.
