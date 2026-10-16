# Native filesystem paths and LSP file URIs

The Windows report concerns `print` imported after `main`, with `jai.stdlib.path`
set to a native drive path. VSCode already forwards that setting as `JAIC_STDLIB`;
no extension or Basic-specific change is needed. Source tracing found incoming
`file:///c%3A/...` retained as `/c:/...`, and outgoing native paths concatenated
after `file://`. The latter also loses definitions/import links on macOS whenever
an actual path contains `#` or `%`. Both boundaries are now centralized.

## Behavior and scope

`DocumentUri::from_path` encodes actual native path bytes once. `parse` decodes
URIs once. On a Windows host, local drive paths become `C:/...` for filesystem
access and `file:///C:/...` for transport, normalizing drive letter and separators.
Supported canonical verbatim drive prefixes use the compiler's existing safe
`strip_verbatim` routine. Filesystem root URIs are representable for workspace
folders. POSIX filenames, Unicode, spaces, literal percent signs and encoded
backslashes retain their native meaning. Raw malformed URI separators, root
escapes, invalid escapes, NUL and non-UTF-8 input remain errors.

Filename case is preserved. Open buffers are identified by the environment's
filesystem canonicalization, so actual proven aliases share current text, versions,
edits and closure identity. The cached identity table is bounded by open-document
admission and invalidated on every input/file change. Source overlays, scanning,
project roots and configuration lookup use consistent canonical native keys.
There is no global lowercase mapping that would conflate case-sensitive folders.
Unproven aliases of nonexistent files are not guessed.

Definitions, reference locations, hierarchy targets, import/load links, workspace
symbols and documentation URLs now construct URIs from native paths. Expansion
documents already contain encoded URI components, so their decoder continues to
parse URI syntax instead of re-encoding native text. Ordinary completion, named
arguments, partial-edit recovery and strict compiler diagnostics remain covered.

Existing local-file policy is retained: nonempty authorities/UNC shares, unsupported
device namespaces, paths outside the UTF-8 service contract and URI lengths above
4096 are not supported. They are not redirected to another local file. This batch
does not claim a complete general-purpose URL implementation or new network access.

## Executed evidence

All outputs are under
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/lsp/scratch/file-uris-20261016/`.
Only authorized current `integration-clean` compiler/lint/LSP sources and independent
production stdlib sources were staged. Earlier cf7dd80, 5214e9c and b064be58 handoffs
are prerequisites. No peer, compiler, bootstrap, stdlib or Extensions source changed.

- **Red:** original API cross-file load/link loses encoded destinations. A separate
  filesystem-proven alias test returns no open buffer. Real source-built native LSP
  against production stdlib under `configured stdlib # % é` loses print definition,
  hierarchy and Basic import link in all four clean/damaged/repaired phases, while
  hover/completion work. Failures are in `red.log`, `alias-red.log`, `native-red.log`
  and `native-red # % é/report.json`; all failures remain effective and preserved.
- **Green:** 140 focused checks pass, including four portable codec tests, four
  original URI/API cases, named-argument/partial-edit/qualified-value regressions,
  document rendering, hierarchy, refactoring, protocol, resilience and source tests.
  [Fixture corrections](lsp-clean-fixtures.md) are classified separately from the
  production fix and committed as fc5ade0a. No assertions or CI thresholds were
  disabled. `focused-final.log` contains exact target counts.
- **Native macOS:** `native-final # % é/report.json` passes four phases, two fresh
  servers and 24 actual feature requests: print hover/completion/definition/
  hierarchy, import links and encoded local definitions, plus versioned diagnostics. Incremental
  damage/repair keeps diagnostics local and unaffected features usable. Programs
  are analyzed, never run; LSP transport shutdown is the only `exit` message.
- **Combined named completion:** `named-native-final # % é/report.json` reruns the
  production Basic/overload/privacy/edit checks against the same patched server
  and reserved-character production stdlib path: 18 phases, two fresh servers and
  32 feature requests. Combined total: 22 phases/four servers/56 feature requests.
  This is candidate integration
  evidence, not release or full-corpus acceptance.
- Scoped Rust formatting, Clippy `-D warnings` and Python syntax checks pass.
  No repository Jai file changed; malformed embedded IDE documents are test payloads,
  not formatting/lint pass claims. A needless-borrow Clippy finding was repaired;
  its original failure remains in `clippy-before-borrow-repair.log`.

The normalized input source fingerprint is
`54e154044d20746ac1d12a98c485bbf966d2a09f7208e3efe6e263591f74ca27`.
Effective candidate source/test fingerprint:
`6d6d204b7a8764b2568e8ea79f90a52c30f402a3f3d0987679b0250efaf561bf`.
Source-built final jailsp SHA-256:
`2b391cdc4ef1be2cc7373506ab48df923b711044eeb2c2227f5d772921e1024d`.
The final shared-input audit found no drift. All 797 independent Jai source copies
in the configured stdlib have identical hashes to the captured producer sources;
that count is source inventory, not a claim that every module was typechecked.
AppleDouble metadata is excluded from source identity, never actual source.

Staging audit caught a bulk overlay replacing the candidate's newer auto-import
alias documentation and `stdlib_root` discovery. The exact captured candidate
file was restored and only the owned URI patch reapplied. Final checks preserve
those independent changes. Integrators must apply narrow diffs, not replace that
file with the isolated producer's older baseline. No duplicate bootstrap fix was
made here and intermediate staging passes are not final proof.

## Reproduction and final verification requirement

After staging current safe dependencies plus owned patches, set `CARGO_TARGET_DIR`
to a unique assigned T7 target. Build and test with:

```sh
cargo test --manifest-path "$candidate/Cargo.toml" -p jai-language-server --lib \
  --test file_uris --test source --test protocol --test doc_comments --test refactor \
  --test hierarchy --test resilience --test named_arguments --test partial_edits \
  --test qualified_values
cargo clippy --manifest-path "$candidate/Cargo.toml" -p jai-language-server \
  --lib --bin jailsp --tests --no-deps -- -D warnings
cargo build --manifest-path "$candidate/Cargo.toml" -p jai-language-server --bin jailsp
PYTHONDONTWRITEBYTECODE=1 python3 tools/lsp_file_uris.py \
  --binary "$CARGO_TARGET_DIR/debug/jailsp" --stdlib "$configured_stdlib" \
  --output "$new_t7_capture"
```

**Native Windows has not been executed in this macOS workspace.** The portable
Windows-flavor codec tests prove string/path conversion only. A Windows-only
`native_windows_drive_uri_resolves_production_print` test is supplied, using real
production stdlib access, encoded lowercase drive input, diagnostics/hover and
readable native definition targets. It is excluded from macOS passing totals.
Coordinator must run it on Windows, then actual native Windows jailsp/VSCode requests
with `jai.stdlib.path` configured, drive/case/separator/Unicode variants, fresh and
incremental documents. Full final merged compiler/stdlib/LSP/corpus verification
remains mandatory. No remote action, publication, release or benchmark was run.

## Owned production files

- `src/document.rs`: central codec, native keys and portable codec tests.
- `src/session.rs`: proven open-document identity, versioned lookup, definition URI.
- `src/semantic.rs`: canonical native overlay/cache keys.
- `src/auto_import.rs`: canonical scans/project roots, workspace symbol URI output.
- `src/features.rs`, `src/hierarchy.rs`, `src/doc_view.rs`: locations, import/load,
  hierarchy, documentation and completion-documentation URI boundaries.
- `src/asm.rs`, `src/selection.rs`, `src/refactor.rs`, `src/lints.rs`: shared document
  identity for analysis/config access rather than raw URI-string map indexing.
- `tests/file_uris.rs`, `tools/lsp_file_uris.py`: original API/native regressions.

Source/test paths above are relative to `crates/jai-language-server` except the
repository-level tool. Docs/index/status/questions contain the handoff and limits.
