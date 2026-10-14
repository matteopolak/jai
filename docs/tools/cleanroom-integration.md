# Clean-room integration verification

This is the replacement independent integration workspace. Only the sanitized baseline, manifest producer refs, reviewed specs and independently authored sources are implementation inputs. Quarantined integration code/history/transcripts and vendored corpus modules are not inputs. No reference binary, subagent, publishing or credential access is authorized.

## Integrated snapshots

Exact source OIDs are recorded in [the manifest](../integration-inputs.json). Merge order: compiler, portable stdlib, foundations, bindings, numerics, window/render, LSP, SDL3. Each has a separate merge commit. Foundation builder/formatter/scalar/File_Utilities implementations supersede overlapping portable versions; portable argument initialization remains loaded and exported. LSP IDE recovery retains the compiler's canonical bootstrap entry constant. SDL3 merge references issue #2.

At startup `docs/implementation-ownership.md` was absent. The permitted compiler snapshot supplies it; it was read before integration. Latest reviewed startup guidance and 26 edited spec pages were preserved in ignored artifacts and restored after merges. Existing Extensions are unchanged except the new SDL3 directory. Upstream SDL license whitespace is preserved verbatim.

## Verification commands and results

Pending combined-tree verification; producer staging passes are not production proof.

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm TMPDIR="$PWD/artifacts/integration-clean/tmp" RUSTC_WRAPPER= cargo build --locked -p jaic-cli -p jailint -p jai-language-server
```

Build exited zero (11.22s). Output: `artifacts/integration-clean/build.log`.

`JAIC_STDLIB="$PWD/stdlib" target/debug/jaic jaifmt/main.jai -O2 -exe "$PWD/target/jaifmt"` exited zero, using unchanged repository tool sources and production dependencies. No numerics tool-bootstrap helpers or fixture library overlay was used.

## Required external verification

Coordinator must run full original public corpus with opaque vendored sources and return filtered results/minimal independent reproducers. Local checks must use unchanged permitted application entry sources with vendor-free staging and explicit provenance. No unrestricted corpus/application fetcher is permitted here. Native Windows/macOS x64 and other unavailable targets require actual CI execution; source checks do not establish runtime support. Focus must be built/launched by coordinator after full tests and accepted by user, including issue #1 signed mouse-wheel propagation, before v0.17.1 publication. No release or historical rebuild is authorized here.

See [integration audit](../status/integration-deviations.md), [plan](../plans/cleanroom-integration.md) and [requests](../integration-requests.md).

Latest coordinator guidance supersedes the human acceptance sentence above:
human Focus review is optional while the user is away. Coordinator still builds,
launches and tests Focus after the full corpus. All release builds/publication
remain on hold; no release or CI dispatch is performed by this worker.

## Refreshed checkpoint verification

Four newer approved OIDs in `docs/integration-refresh.json` are merged with
separate commits. Source-built compiler atomics pass five focused core and four
LLVM tests, including native O0/O2 and shared-memory Wasm contention.

`tests/numerics/intrinsic_f32_reproducer.jai`, the reflected-alignment reproducer
and the original Deep_Copy graph fixture pass interpreter and native O0/O2.
Results: `artifacts/integration-clean/f32-alignment-native.json`. Compiler fixes
use IR floating width and completed struct layout rather than library guesses.
The alignment and graph fixtures are promoted from pending into the portable
runner. Remaining Deep_Copy contracts are documented separately.

`python3 tests/numerics/run.py --compiler target/debug/jaic --stdlib stdlib --canonical-dependencies`
reports 40/83 checks passed. Failures remain real: absent AppKit, unsupported
platform backends and Wasm formatting imports. `cargo clippy --locked --workspace
--all-targets -- -D warnings` passes after the floating/alignment changes.

`JAIC_STDLIB="$PWD/stdlib" target/debug/jaic tests/window-render/signed-wheel-windows.jai
-check -no_dce -os windows -cpu x64` passes. Actual Windows execution remains pending.

`python3 tools/native_bindings/generate.py --module POSIX --formatter target/jaifmt`
regenerates the newly reviewed itimerval shapes. The next macOS x64 error is
unknown timeval; this shape-selection contradiction is retained for review.

Compiler-record and Jai_Lexer generators now normalize output with the actual
repository formatter and check a second pass for idempotence. `--check` compares
without writing. Both generators pass `--check`; the helper regression passes
using the real tool. SDL3 native CI now builds the unchanged formatter from
production dependencies before its six-target regeneration gate, matching local
normalization instead of comparing raw generated text to formatted sources.

Refreshed broad runs: full workspace 583 passed, 80 failed, one inherited ignored
across 51 suites/15 failed targets (`workspace-refreshed.log`); original stdlib
473 cases, interpreter 264/209 pass/fail and native 256/209 plus eight
compile-time-only (`stdlib-refreshed.log`). Portable supported runner reports
82/83 ordinary cases plus parent/fault/startup checks; runtime-temp-default and
SMTP/MIME fail the explicit runtime singleton conflict (`portable-refreshed.log`).
No assertion, stale inventory failure, unsupported API or platform was removed.

Refreshed quality scope is 532 new Jai files: formatting/check pass; 40/143
per-directory checks fail, retaining unsupported platforms and fragment-context
failures. `quality-refreshed.json` records every command, tool/source hash and
incomplete compilation. A combined lint run is required to assess fragments in
their actual loading modules, rather than treating those failures as clean.

## Compiler corrections verified

`cargo test --locked -p jaic --lib --test cleanroom_modules --test cleanroom_literals --test cleanroom_layout` passed: 150 core unit, 39 module, five literal and three layout tests. `cargo clippy --locked -p jaic --lib --tests -- -D warnings` exited zero. Scoped rustfmt ran over the five modified Rust files. Red/green logs are retained for protection-change SIGBUS, bundled parameter checking and IDE entry admission. Runtime_Support retains its exact reviewed three parameters.

Initial `cargo test --locked --workspace --no-fail-fast` reports 21 failed targets (one raced the newly added runtime regression before its fix). All failures remain in `workspace-all.log`, including native ABI, missing reviewed modules, LSP facade metadata and Wasm runtime dependencies. Doctests also fail under this repository custom-build artifact arrangement; this is not waived. Full rerun follows corrections.

## Subsequent integrated verification

- Core array regression: seven literal tests pass, including typed array element preservation and type-only array-field indexing. Unicode table construction now uses u8 as its element type; the original UTF-8 table fixture runs and unused-code checking passes. Source-built Socket loopback runs; all-code checking exposes the separate enum forward-reference blocker recorded in requests.
- Partial edits: fixtures/tour 40 files, 6,621 edits, 370,320 assertions, zero harness failures; full stdlib (including preserved Extensions) 516 files, 5,710 edits, 1,037,619 assertions, zero harness failures. Reports retain baseline errors. These are editor resilience checks, not conformance passes.
- All integrated new Jai sources: 493 files formatted and --check passed. Combined jailint -v -D warnings ran without a crash: nine lint errors in five files, 85 incomplete compilations across 327 checked programs. Per-directory audit is also retained (37/136 failed checks). No partial compilation is counted as passing. Thread lint findings were fixed, with actual interpreter/native lifecycle/group/condition/shutdown checks.
- SDL3 macOS arm64: production linked ABI/headless/callback/entry tests pass, 1,329 runtime exports/artifact hashes and 95 GPU exports audited. GPU/device runtime not exercised. Nineteen Python tests pass. All six generated target profiles pass normalized regeneration after canonicalizing redundant Clang anonymous-union diagnostic spelling; no layout/signature change.
- SDL2 official 2.0.1 header probe was source-built. Production native event/bitmap test passes; unchanged ABI test fails with SIGABRT, reporting RWops 48 versus 72 bytes and UserEvent eight versus 32 bytes. No assertion was changed. macOS x64 unused-code remains failing; sdl2-production.json records both failures. Safe caller-owned RWops adapters remain required.
- Production binding sweep: 57 failed/unimplemented desktop checks, 58 configuration/mobile failures. Native full setup exposes an invalid X11 generated-header URL (404); it is not a full-native pass. A new explicit --library option builds only that native unit and its pinned source closure; default full-manifest validation remains unchanged.
- Portable production runner: 74/75 ordinary cases pass interpreter/native, plus parent lifetime, fault rejection and native startup ON/OFF checks. Runtime explicit configuration conflict and SMTP/MIME integration remain failures. Production --stdlib performs no source overlay. Windows-specific runtime fixture is retained for a Windows host and cross-target checking.
- Foundations: 17 supported cases plus four runtime rejection cases pass interpreter/native O0/O2; real jaifmt CLI/format/lint checks pass. Six target checks pass, macOS x64 fails POSIX.itimerval. Windows is checked, never claimed executed.
- Full workspace retry in isolated normal target/integration-validation: 560 tests passed, 90 failed, one existing ignored; 16 failed targets. Doctests pass in this independent build directory. Initial doctest missing-artifact errors arose while independent build/check invocations reused target outputs; no source/tool/test repair or doctest exclusion was used. Full failures remain in workspace-final.log. Workspace clippy --all-targets -D warnings passes; full Rust formatting and item spacing checks pass.
