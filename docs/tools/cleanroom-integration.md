# Clean-room integration verification

## Current integrated evidence

Exact approved heads are in `docs/integration-refresh.json`, integrated with
separate logical merges. The current source-built compiler/LSP/jailint and
unchanged repository jaifmt use the combined production stdlib. Existing
Extensions remain byte-identical outside new SDL3. Historical results below
are retained evidence, superseded only by the results in this section.

| Scope / command | Actual result |
| --- | --- |
| `cargo test --locked --workspace --no-fail-fast` with `CARGO_TARGET_DIR=target/integration-validation` | 612 passed, 73 failed, one inherited ignored; 55 suites, 14 failed targets (`workspace-refresh4.log`) |
| Public-language runner | All 11 reviewed fixtures pass |
| `tests/stdlib-contract/run.py --jaic "$PWD/target/debug/jaic" --stdlib-root "$PWD/stdlib" --mode interp` and `--mode native` | All 45 reviewed fixtures pass in each mode |
| `tools/check_portable_stdlib.py --jaic target/debug/jaic --stdlib stdlib --native --keep-going` | 92/92 ordinary cases pass; faults/rejections, parent/startup, ten real SMTP cases and four 2,048-packet channel pairings also pass |
| `tools/check_foundations.py --jaic target/debug/jaic --stdlib stdlib --wasm --cross` | 24 host cases/five runtime rejections pass interpreter/O0/O2; 19 WASI cases pass O0/O2; six profiles pass, macOS x64 fails POSIX.timeval |
| `tests/numerics/run.py --compiler target/debug/jaic --stdlib stdlib --canonical-dependencies` | 107/123 production checks pass; remaining target/font/cursor gaps retained |
| `tools/check_window_render.py --jaic target/debug/jaic --stdlib stdlib --native-libs target/window-native --font /System/Library/Fonts/Helvetica.ttc` | Fourteen macOS cases pass interpreter/O0/O2, including real GL textures/shaders, windows/events/clipboard/fonts; Linux-target interpreter cases pass; Windows File-dependent checks fail |
| Production binding verifier and configuration runner | 65 failed/unimplemented desktop and 58 alternative/mobile checks retained |
| SDL `--module SDL --runtime --native-libs artifacts/integration-clean/native-sdl-refresh4` | Real events/bitmap and safe WM-info adapter pass; original ABI assertions fail RWops 48/72 and UserEvent 8/32; macOS x64 also fails |
| Objective-C `--module Objective_C --runtime` | Real Objective-C/AppKit native tests pass; target/privacy failures retained |
| Binding `generate.py --check --formatter target/jaifmt`, compiler/lexer `--check`, SDL3 `--jaifmt target/jaifmt --check` | All regeneration/idempotence checks pass, including six SDL3 profiles |
| Workspace `cargo clippy --all-targets -- -D warnings`, wasm32 jai-wasm clippy and repository Rust format check | Pass; Windows/Linux core source checks pass, not native execution |
| `tools/check_cleanroom_quality.py --baseline e1e8d19d0e6792ebc895c12fabe49ba919ef0226 --format --report artifacts/integration-clean/quality-final.json` | 587 new Jai files format/check pass; 33/148 checks fail. Source stability is recorded. Combined lint retains one finding and incomplete compilations across 396 programs |
| Original stdlib runtime sweep, interpreter/native | 479 cases: interpreter 269 passed/210 failed; native 262 passed/209 failed/eight compile-time-only. Stale skip inventory remains fatal; nothing removed |

Evidence is under ignored `artifacts/integration-clean`, including exact commands,
source/tool hashes and all earlier failures. No logs/native outputs are committed.
The actual tool source was not patched to bypass library gaps. Nonverbose jailint
exit-zero incomplete compilation is rejected; scoped Basic/runtime lint passes,
whole-scope lint does not. An earlier quality run raced test relocation and failed
at the old path; that failure remains recorded, with a subsequent stable-scope run.

The 537-file partial-edit sweep exercised 14,257 edits/2,563,157 assertions and
retains one runtime-startup recovery failure; a focused current retry still fails
three assertions. The refreshed 558-file sweep is running. No public-application
staging/full-corpus pass is claimed: full opaque vendor corpus remains coordinator-
run, with filtered failures/minimal independent reproducers returned here.

Temporary branch safety: release jobs trigger tags/manual dispatch; browser
release and benchmarks are manual. Native SDL3/Windows/compiler jobs perform
verification. Package-manager jobs install published artifacts and are not new
clean-room evidence. Coordinator must hold release builds/publication and review
all triggered jobs before pushing `codex/cleanroom-integration`. Native Windows,
macOS x64, Linux/device execution and coordinator Focus testing remain open.

Inventory: 101/135 module facades, plus contextual AppKit, 34 absent and one
supporting table page. Integration-certified complete modules: zero; presence
and passing subsets are not complete API/behavior/platform certification.

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

## Second approved refresh

Compiler ec7e23e, foundations 44cca8b, portable 04205ed and window e7e719a are
merged. Context conflict resolution keeps runtime cleanup semantics together with
IDE statement recovery. Treemap/temporary stamping additions retain production
runner selection; no automatic peer-source overlay was imported.

Production rebuild succeeds. The unchanged jaifmt O2 build initially reproduced
the new scratch-context panic; shared initialization at three creation sites fixes
it. Nine core context, five layout/metadata, 39 module and 20 partial-edit Rust
tests pass, together with native/Wasm context O0/O2 execution. The hidden-procedure
reflection marker is fixed generally; actual GL execution remains AppKit-blocked.

All 11 public-language and 41 public stdlib contract cases pass; the latter pass
both interpreter and native. Canonical numerics is 46/83. Portable production is
88/91 ordinary cases; the failures are two generic-default reflection cases and
the explicit runtime configuration case. SMTP/MIME now passes all ten real
interpreter/native cases after the ordinary runtime import fix. Foundation WASI
executes 34/38 checks; only the two generic-default cases fail at both O0/O2.

The actual unchanged formatter builds and checks new owned sources. Foundation
lint's old nonverbose exit-zero claim is superseded: the runner now rejects
incomplete compilation and reports three Windows-only files checked as host roots.
Combined/per-directory quality commands retain those diagnostics. Workspace
clippy --all-targets -D warnings passes. Earlier reports/logs remain evidence,
not deleted or relabelled as successful production integration.

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
