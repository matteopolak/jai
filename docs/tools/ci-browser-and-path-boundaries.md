# Browser policy, archive boundaries and filesystem aliases

The 2026-10-16 coordinator checkpoint reports all four compiler matrix jobs at
candidate833 cancelled after actual failures. No earlier local test total is a
green matrix result. This owned batch addresses three independently reproduced
consumer defects, without changing compiler semantics or diagnostic goldens.

## Archive boundary

`package_browser_release.asset_path` now excludes `protected` and `vendor` path
components alongside the existing original-input/build exclusions. The inherited
`protected/secret.jai` assertion is a valid confidentiality boundary, not a Jai
API expectation. `browser_tool` validates both lexical and resolved paths against
protected checkout subtrees before returning a tool path; no program is executed
by validation. Installed tools may still use ordinary installation symlinks.

Two inherited failures reproduced: protected archive input was accepted and a
supplied alias to a protected inert tool was accepted. New tests also cover an
ancestor-directory alias and assert neither subprocess entry point is called.
All 11 package tests pass using authored inert fixtures and mocked build/probe
calls. This is packaging protocol evidence, not a published archive or real build.

T7 produced AppleDouble files during fixture staging, causing additional initial
failures. Regular `._` sidecars are explicitly omitted from archive assets, as in
the browser request collector. Symlinks are rejected before metadata exclusion,
including `._` symlinks; unsupported real assets remain errors. The actual tour
and required assets remain exhaustively inventoried and hash-verified.

## Browser mode and capability consumption

`playground_policy.py` consumes `validated_entries`, `case_for_mode` and
`unavailable_reason` from the reviewed common catalogue. The playground runs
`wasm-interp`: its compiler target is WASM and its execution uses the interpreter.
Explicit mode overlays govern expected results as well as dispatch. Required
negative programs remain selected and must return nonzero with the exact reviewed
diagnostic. Unknown-library/unavailable diagnostics, crashes, request rejections,
timeouts and unrelated errors never become target exclusions or passing negatives.

`playground_case_result.mjs` isolates result classification for focused tests.
The real worker-host regression uses inert authored engine/catalogue transports;
it proves dispatch/accounting, not compiler or library execution. It fails on the
old host because required provider errors are promoted to unavailable, then passes
on the repaired host. Reviewed unavailable cases are excluded before creating a
worker and remain separately counted, with zero execution passes claimed.
Positive-baseline enforcement and stdout/runtime-negative checks are retained.

The d4c22ebc request collector and 16 MiB product limit are unchanged. All Jai
sources and test resources are retained. No library fixture is trimmed to pass.

Integration prerequisites are the admitted `catalogue-128-ready` foundations
capability update and canonical mode helper, plus the runtime owner overlay.
Current safe source a41b53e3 has newer numerics catalogue context; the admitted
catalogue patch does not apply verbatim there. The controlled dependency capture
inserts only its exact mode helper and overlay after the existing numerics check,
preserving that policy. Other foundations hunks and runtime overlay apply cleanly.
This adaptation is a dependency receipt, not an owned shared catalogue change.
Integration must retain its newer Debug/numerics additions when adopting it.

## Filesystem identity

Current accepted auto-import source mixes canonical physical index paths with
caller spellings in load graphs, relative edits and watched-file invalidation.
An owned T7 directory alias reproduces the five MacIntel failures unchanged:
`files_changed_on_disk_are_read_again`, `jai_toml_names_the_entry_and_import_path`,
`names_of_files_the_program_already_loads_need_no_edit`,
`unloaded_project_file_alias_keeps_its_own_declaration_environment` and
`user_module_and_project_files`. Baseline: 13 passed, 5 failed. The missing-file
assertion unwraps None; others produce incorrect relative load paths/descriptions.
No caller `/var` spelling, module or symbol is special-cased.

`canonical_key` uses the environment filesystem identity for existing paths and
an existing ancestor for unsaved/not-yet-created files. Index scans, load closure,
entry/module directory membership, relative-edit origin, open-document lookup and
watched-file invalidation use the same keys. This keeps a missing-file cache key
stable when that file is created under an aliased parent. Canonical identity does
not globally fold filename case or change private visibility eligibility.
Accepted callable-alias documentation and completion-context selection remain.
The independent alias reducer fails before the repair and checks relative edits,
loaded declarations, cache-miss creation and edits notified through another alias.
Corrected native tests: 19 auto-import, 36 library, 5 URI and 5 module tests pass;
scoped Rustfmt and LSP Clippy lib/tests with -Dwarnings pass. An additional unsaved
document alias regression fails on the baseline, then verifies stored-key source,
private hover/definition, duplicate-open rejection, UTF-16 edits and close identity.
The other loaded file cannot navigate to its file-private declaration. Baseline
source bytes are restored exactly after the temporary red control.

## Verification and remaining scope

Artifacts, temporary roots, source archive, policy inventory and logs are confined
to assigned T7 `lsp/scratch/ci-833-corrections`; dependency source is pinned to
safe independently authored producer a41b53e3 plus the admitted policy update.
The local alignment commit is a prerequisite only: root already owns its accepted
alias documentation. Apply only NEW narrow source patches, never that prerequisite
or old whole-file replacements. Integration owns its sole shared index.

Python/Node host tests use no supplied executables. LSP native tests compile/check
independent documents; no Jai runtime, exit, SDK, GUI, network or fault programs run.
Actual job833 browser replay, native Windows and the final merged matrix remain
required; source/inert-host results are not relabelled as those executions.
Prior source673 actual WASM request-boundary evidence remains scoped to d4c22ebc.
No new benchmark, performance gate change, waiver, fake result or golden refresh.
