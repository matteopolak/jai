# Clean-room integration verification

## Stable combined native ARM64 replay, 2026-10-15

Stable workspace at53ecb3d3 completes852 passed/two failed/one inherited ignore
across101 Cargo binaries. Remaining failures are the WASI tour and target ledger;
constructor, ABI, ownership, CLI and LSP suites pass in that command. Focused new
producer checks:137/147 commands pass; ten failures traced to one missing
value-emission load after facade reconciliation. The production facade now loads
the seven reviewed value emitters from `Bindings_Generator/value-emission.jai`
with private algorithms in internal/developer-tools. All21 affected commands
then pass, including real generated Jai round trips, negative Check callbacks
and all seven module lints. This is scoped follow-up evidence; the original147
result remains failed, without a projected full-green aggregate.

SDK inputs for Debug_Info were generated from original C/COFF/ELF/PDB sources
using the official installed LLVM tools. The existing private msf-wire unit uses
an unchanged copied private source in target; that diagnostic unit is separate
from public parser proof and does not replace or repair production library code.
New Debug/Debug_Info, object/archive and three Android serialization/project
fixtures pass actual interpreter/native ARM64 O0 in the focused run. Controlled
Android SDK/ADB orchestration and actual device/build execution remain separate
unverified gates; neither fake path sentinels nor source checks certify an APK.

Restricted application follow-up at17ab409a completed before coordinator corpus
takeover:337 configured entries source checked by unchanged jailint,296 complete,
41 failures,63/400 unexecuted; zero native output claims. IDE diagnostics reported
706/776 permitted files,271 errored,70 unreported; Vk-Engine stopped at180.005s
with33/101 reported. Full original corpus is now externally coordinator-owned;
only metadata reports are retained as handoff, not raw diagnostic/source inputs.
See [entry checks](../status/application-entry-checks-baseline.json),
[type facts](../status/application-typefacts-baseline.json) and
[overall corpus limits](../status/public-corpus-baseline.json).

Application staging audit: the coordinator's1044-file allowlist includes249
manifest paths under blocked module/library directories. No excluded bodies
were opened. `tools/stage_application_corpus.py` additionally excludes library
entry files and other vendor-directory spellings before any source filesystem
access:776 unchanged application/tutorial files staged,268 excluded. Six actual
filesystem/provenance/traversal tests pass. The stage records original revisions,
SHA256 and exact exclusions in ignored durable artifacts. Diagnostics/type facts
against production stdlib are the next gate; they do not establish all400
upstream configurations compiled or native Focus execution. Missing excluded
dependencies stay real errors; no copied vendor library or symlink fills them.

Candidate worktree: `artifacts/integration-clean/thread-fixtures`, branch
`integration/thread-fixtures`, measured production snapshot
`ad575d161e8705d839e7253f52a06c10b45d1732`. Older refresh sections below are historical.
`cargo test --locked --workspace --all-targets --no-fail-fast` completed with
840 passing tests, two failures and one inherited ignore across 98 Cargo test binaries (102 raw
summaries include four child-process repeats). Failures remain enabled:
`wasm_target::wasm_tour_runs_as_a_wasi_command` imports native-only Thread;
`every_stdlib_module_checks_for_every_target` reports 186 ledger differences,
mixing stale diagnostics/successes and real missing platform functionality.
No unsupported platform assertion is accepted as a completed implementation.

The 414-case catalogue completed against this same production snapshot:
`python3 tools/stdlib_runtime.py --jaic <own-root-target>/debug/jaic --modes interp,native --opt O0 --jobs 2 --timeout 180 --verbose`.
Both commands select this worktree's production `JAIC_STDLIB`, actual source-built
native dependencies, owned TMPDIR, and the catalogue additionally supplies a real
system Arial font and native clipboard restoration guard. Exact environment,
counts and failure classifications are maintained in
[`mac-integration-baseline.json`](../status/mac-integration-baseline.json).
Interpreter: 390 passed/13 failed; native ARM64 O0: 380 passed/12 failed,
11 compile-time-only. Each mode has five precise negative passes and six
explicit unavailable platform cases. Json numbers interpreter exceeds 180s;
the runner discarded actual elapsed, so only the deadline/lower bound is known.
No timeout is counted as passing. The own macOS event fixture was then corrected
to pump its frame after native resize/close notifications; its unchanged size,
window identity and close assertions pass interpreter/native O0 in a focused
replay. This is a follow-up, not an arithmetic projection of a green full run.
The root tracking branch has not been moved. Full opaque public corpus and Focus
build/launch, signed mouse-wheel regression and user acceptance remain required
coordinator gates. Windows/Linux native verification remains required later.

## Current combined refresh twelve

Source checkpoint d485811 contains every approved refresh-twelve snapshot,
including the new audio/developer-tools refs and authorized native CI candidate
e8c312d. Subsequent integration repairs below are ordinary independent commits.
Publication is held; this worker performs no push, CI dispatch or release action.
Coordinator runs the opaque full public corpus and Focus build/launch; a human
Focus check is optional under latest steering.

| Executed command/scope | Result and limits |
| --- | --- |
| Source-built jaic/jailint/jailsp; unchanged jaifmt O2 against production stdlib | Builds pass; no tool-only library repairs or overlays |
| cargo test --locked --workspace --no-fail-fast | Full refresh12 completes; failures retained in workspace-refresh12.log; focused canonical runtime/plugin/private-lint tests pass |
| cargo clippy --locked --workspace --all-targets -- -D warnings | Pass; actual wasm32 jai-wasm clippy also passes |
| jaifmt --check on835 new/changed Jai files | Pass; relocated SDL regression separately format/lint checked; broad quality first retry has stale moved-path and real target/body failures |
| check_foundations.py --jaic target/debug/jaic --stdlib stdlib --jaifmt target/jaifmt --jailint target/debug/jailint --cross --wasm | Pass:43 host cases interpreter/nativeO0/O2,35 WASI O0/O2, seven unused-code profiles, strict four-target lint union116 positive files and one required binding rejection; parent log retains exact execution |
| check_platform_io.py --jaic target/debug/jaic --stdlib stdlib --native --cross-check --windows-build x64 --windows-process --windows-crash | Host cases/arguments and four-target source checks pass; x64 nativeC and18 startup/fault/named-fault cross-builds pass; Windows execution not claimed |
| format_platform_io.py --check / --lint with actual tools and --stdlib stdlib | Pass:49 positive owned Jai files across four profiles, one invalid runtime fixture rejects both Windows CPUs |
| check_window_render.py --jaic target/debug/jaic --stdlib stdlib --native-libs target/window-native |167 invocations pass/zero fail, real host GL/codec/clipboard/lifecycle; caller-font increment pending; Windows native lifecycle/driver evidence remains required |
| audio_verify.py | Four tests pass interpreter/nativeO0/O2, six source targets and strict formatting/lint; controlled kernels only, no playback/device claim |
| check_developer_tools.py | Real C11 headers/layout/call/rejection and measured compiler-performance plugin pass interpreter/nativeO0/O2, strict formatting/lint, three source targets; documented subset |
| check_portable_stdlib.py --jaic target/debug/jaic --stdlib stdlib --native --keep-going plus four targets |133/134 ordinary cases pass; real bundle/plist/Meow/FSEvents sanitizers,22 fault cases,10 negative gates,10 SMTP/TLS and4x2048 IPC checks pass. Plist harness correction and optimized compiler float retry underway; Windows Socket/shared-memory backends remain genuine failures |
| native_bindings/verify.py --module SDL --runtime --compiler target/debug/jaic --stdlib stdlib --native-libs artifacts/integration-clean/native-sdk | Six source targets and actual native factory/BMP/close/WM-info pass; SDK layout aggregate remains red RWops48/72, UserEvent8/32. Relocated RWops also passes interpreter/nativeO2 and strict lint |
| native_bindings/generate.py --check --formatter target/jaifmt | All bindings generation/idempotence pass |
| sdl3_gen.py --source artifacts/sdl3/SDL3-3.4.18 --jaifmt target/jaifmt --check | Six profiles pass with1486/1488 ABI assertions retained;20 Python units pass after portable path fix, actual Windows CI rerun pending |
| Production runtime allocation.jai -os wasm -cpu x64 at O0/O2 + tools/run_foundations_wasm.mjs | Both actual WASI executions print ok; configured65536 size, original/data identity and last-byte access |
| build_scripting_wasm.py --release --output artifacts/integration-clean/browser-refresh12; node tools/check_jai_format_wasm.mjs artifacts/integration-clean/browser-refresh12 | Actual wasm32 source build and24 formatter goldens plus414-line source pass; broader browser/API suite is not green |
| tests/numerics/run.py --compiler target/debug/jaic --stdlib stdlib --output artifacts/integration-clean/numerics-refresh12 |129/143 checks pass;14 actual failures retained |
| stdlib_runtime.py --jaic target/debug/jaic --modes interp,native --strict --jobs 4 --timeout 120 --verbose |482 current cases execute: interpreter275pass207fail; native269pass205fail8compile-time-only, zero skips. Includes two newly library-owned fixtures; argument/dependency requirements are distinct from invalid legacy public APIs and genuine compatibility failures |
| lsp_partial_edits.py --stdlib stdlib --max-lines 8 --jobs 4 --timeout 60 --report artifacts/integration-clean/lsp-refresh12.json stdlib |639-file full sweep in progress; do not report final totals until complete |

All logs/reports are under artifacts/integration-clean unless a secondary
artifact path is stated. The module inventory records111 present facades out
of135 reviewed modules;24 are absent and the136th spec row is an MPEG constant
supplement. Zero modules are certified fully complete by integration. Windows
Socket/shared-memory, remaining developer modules, wide-integer guard contract,
SIMD revised semantics, native ABI failures and target/runtime gaps are explicit.
Source declarations and partial-editor resilience are not behavior coverage.
All historical checkpoints below retain their original outcomes.

## Sixth refresh checkpoint

Source checkpoint d9aa140 integrates the seven approved sixth-refresh heads and
the safe editor CI correction 767130b, preserves the latest four Windows public
contract clarifications, and fixes declaring-file interface lookup, runtime
startup target/configuration behavior and test production boundaries. Results:

- Workspace: 631 passed/68 failed/one inherited ignored, 59 suites, 14 failed
  targets (`workspace-refresh6.log`). Core interfaces, mixed variadics and all
  41 module cases pass; actual production runtime option regressions pass.
- Portable: 101 ordinary cases pass in both requested modes, plus faults,
  rejections/SMTP/channels/startup. Additional Windows checking fails at the
  Basic sleep fixture's unconditional POSIX test-clock import; no overall pass
  is claimed (`portable-refresh6.log`). The later keep-going repair preserves
  all independent target failures rather than stopping at the first one.
- Foundations: all 27 host and 21 WASI O0/O2 cases and strict rejection gates
  pass; macOS x64 still fails POSIX.timeval (`foundations-refresh6.log`).
- Platform I/O: four host contract cases and Unicode arguments pass interpreter/
  O0/O2; Windows x64/arm64, Linux x64 and macOS arm64 source checks pass. Private
  Process all-code checks use an actual library-owned entry without staging.
  File also passes real WASI O0/O2 (`platform-io-refresh6-{green,wasm}.log`).
- Production GL SDK: native C oracle, reflection native/interpreter and real
  context/shader/buffer checks pass with no source overlays/compiler proposal.
  Debug callback capability is explicitly unavailable, so the aggregate fails
  (`gl-sdk-production-refresh6.json`).
- Window runner: 145 invocations pass/four fail; new host public fonts, text,
  GPU rendering/readback/lifetime cases pass interpreter/native O0/O2. Windows
  WGL dependency failures remain (`window-refresh6.log`). Numerics: 126/143
  (`numerics-refresh6.log`).
- Quality: all 663 sources format/check pass; sources stable; 38/155 checks fail
  (`quality-refresh6.json`). Required incomplete-compilation failures stay fatal.
  This is not a complete lint pass.

All earlier evidence below is historical. Seventh approved heads are now
available; their integration/reverification is underway. No native Windows
runtime/corpus/Focus or release completion is claimed. See the deviations audit
for every staged-tool substitute discovered and removed, and remaining gaps.

## Current fifth refresh

Approved compiler 890329b, portable c8d1f5d, foundations a11c0c8, bindings
a565ab0, numerics 4acc846, window 7fc1d6a, LSP e3ec426, SDL3 bb3eaaa and
platform-io eb5d83d are merged. Reviewed CI candidate 159ca65 is also merged;
the worker never pushed or dispatched it. Producer handoffs/status/deviations
were read, including the new platform I/O and debugger/Autorun reports.

The following are production runs in this checkout, with `JAIC_STDLIB` selecting
its actual library and source-built tools under its own target directory:

| Command / scope | Result / evidence under `artifacts/integration-clean` |
| --- | --- |
| `cargo build --locked -p jaic-cli -p jailint -p jai-language-server` with pinned LLVM | Pass, `build-refresh5.log` |
| Unchanged `jaifmt/main.jai -O2` build | Pass, `formatter-refresh5.log` |
| `tools/check_portable_stdlib.py --jaic target/debug/jaic --stdlib stdlib --native --keep-going` | 96/96 ordinary cases; faults/rejections, ten SMTP cases, four 2,048-packet interprocess combinations and actual startup ON/OFF pass, `portable-refresh5-final.log` |
| `tools/check_foundations.py --jaic target/debug/jaic --stdlib stdlib --wasm --cross` | All 26 host and 21 WASI cases pass O0/O2, including selected debugger type identity/hooks. Six profiles pass; macOS x64 POSIX.timeval and invalid unused-interface acceptance remain failures, `foundations-refresh5.log` |
| `tools/check_platform_io.py --jaic target/debug/jaic --stdlib stdlib --native --cross-check --wasm` | Host interpreter/native O0/O2; Windows x64/arm64, Linux x64 and macOS arm64 all-code checking; Wasm all-code/interpreter and real WASI O0/O2 pass, `platform-io-refresh5-wasi.log` |
| `cargo test --locked --manifest-path fuzz/harness/Cargo.toml` | All ten regression targets pass, `fuzz-refresh5.log`; formatter failure before the WASI boundary fix retained in `fuzz-formatter-red.log` |
| Public contract runner, interpreter/native | All 45 reviewed fixtures pass in each mode, `contracts-refresh5-{interp,native}.log` |
| Workspace clippy all targets, warnings denied; repository Rust format check; wasm32 jai-wasm clippy | Pass, `clippy-matrix-final.log`, `rustfmt-matrix-final.log`, `clippy-wasm-refresh5.log` |
| File shared/WASI implementation and unchanged File fixture, actual jaifmt check and verbose jailint warnings denied | Complete pass, `file-wasi-{format,lint}.log` |
| `python3 -m unittest discover -s tools -p test_portable_crash.py` | One nonmutation property test passes, `startup-harness-unit.log`; subprocess is mocked only here, never in runtime evidence |
| `cargo test --locked --workspace --no-fail-fast` | 619 passed/68 failed/one inherited ignored, 55 suites and 14 failed targets, `workspace-refresh5-final.log`; subsequent nested-target coverage is tested separately below |
| `cargo test --locked -p jaic-cli --test stdlib_targets -- --nocapture` | Nested discovery regression passes; all 117 public/bootstrap/extension module entries run seven profiles (819 checks), retaining 341 expected-error inventory differences, `target-matrix-isolated-final.log` |
| `tools/check_cleanroom_quality.py --baseline e1e8d19d0e6792ebc895c12fabe49ba919ef0226 --format --report artifacts/integration-clean/quality-refresh5-final.json` | 607 new Jai files format/check pass; source stable, no changed inputs; 34/152 checks fail. Combined lint: zero ordinary findings, 61 incomplete compilations among 411 programs. This is a failed lint gate |
| `tools/stdlib_runtime.py --jaic target/debug/jaic --modes interp,native --jobs 6 --verbose` | 479 cases: interpreter 270 passed/209 failed; native 263 passed/208 failed/eight compile-time-only. Stale skip inventory remains fatal, `stdlib-refresh5.log` |
| Production window runner with real FreeType font and pinned native libs | All 128 source/program invocations pass, `window-refresh5.log`; fourteen host cases execute interpreter/O0/O2, other records include source checks/Linux-target interpretation |
| `/opt/homebrew/bin/python3 tests/numerics/run.py --compiler target/debug/jaic --stdlib stdlib --canonical-dependencies` | 107/123 checks pass; unsupported Wasm window/editor/font paths remain failures, `numerics-refresh5.log` |
| Bindings/compiler/lexer normalized regeneration with actual jaifmt; SDL3 six-profile regeneration | All pass, `{bindings,compiler,lexer,sdl3}-regeneration-refresh5.log` |
| `tools/build_scripting_wasm.py --release --output artifacts/integration-clean/browser-current` then actual Node engine/formatter checks | Real wasm32 compiler builds; formatter 24 golden cases and 414-line source pass. Broader engine check fails the tour's unsupported Thread import; `browser-{build,formatter,engine}-refresh5.log`. This is not a full browser pass |

`tools/check_portable_crash.py` previously copied sibling compiler facades even
with an explicit production library. Those implicit copies/default sibling paths
are removed. Earlier aggregate startup passes below do not establish a run without
overlays; the current 95-case run and native startup rerun do. The mock regression
is input-integrity coverage only. The discovery, scope and original failures are
retained in [the deviations audit](../status/integration-deviations.md).

The frozen 558-file LSP sweep completed 14,835 edits/2,600,590 assertions, with
one runtime-startup recovery failure (`lsp-final.json`). The twelve fifth-refresh
facade/backend/debugger sources pass 317 edits/33,577 assertions (`lsp-refresh5.json`);
the subsequent three Socket sources pass 81 edits/5,698 assertions
(`lsp-socket-final.json`). This is incremental coverage, not a full current-tree
LSP pass. Full opaque
public application corpus and Focus remain coordinator work; no local full
application corpus pass is claimed.

The full workspace still fails auto_import/features/links/refactor/resilience/
semantic LSP targets; jai-wasm lib; CLI cli/diagnostics/native/objc_selectors/
optimized_split/stdlib_targets; and jailint rules. Browser fixture corrections
preserve C input/EOF/exit/allocation assertions with reviewed API boundaries;
jai-wasm is now 26 passed/three failed. Missing reviewed logging, unsupported
Thread and IDE expansion failures are retained. Exact migration reasons are in
[legacy-contract-audit.md](legacy-contract-audit.md).

Filtered coordinator native CI candidate 159ca65 results: real Windows x64 AND
arm64 File interpreter/native O0/O2 and signed-wheel interpreter/native pass.
The overall workflow failed on runtime/platform/missing-module gaps. The feedback
does not certify native fonts, GL, full Process/Thread/System, or Focus. The
independent formatter fuzz failure is reproduced and fixed through a private
WASI C file ABI; POSIX guards and Extensions remain unchanged. Native macOS x64,
Linux/device and further Windows execution still require CI. Release workflows
and publication remain held.

Inventory: 102/135 module facades, plus contextual AppKit, 33 absent and one
supporting table page. Integration-certified complete modules: zero. Presence
and supported passing subsets are distinct from full contract/platform coverage.

## Previous fourth-refresh evidence

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

Coordinator must run full original public corpus with opaque vendored sources and return filtered results/minimal independent reproducers. Local checks must use unchanged permitted application entry sources with vendor-free staging and explicit provenance. No unrestricted corpus/application fetcher is permitted here. Native Windows/macOS x64 and other unavailable targets require actual CI execution; source checks do not establish runtime support. Focus must be built/launched by coordinator after full tests with issue #1 signed mouse-wheel propagation verified; latest steering makes the human check optional before publication. No release or historical rebuild is authorized here.

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
# Combined refresh-nine checkpoint

Implementation source `9cd757a` integrates the manifest saved at `4fe1aa4` and
general root fixes. Producer handoffs/deviations were inspected for compiler,
foundations, portable, platform I/O and window/render updates. Earlier reports for
unchanged bindings/numerics/LSP/SDL3 remain applicable. No peer checkout writes,
vendor bodies, quarantined history, push or CI dispatch were used.

Executed against the production `stdlib` without dependency overlays:

```
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= cargo build --locked -p jaic-cli --bin jaic -p jailint -p jai-language-server
JAIC_STDLIB="$PWD/stdlib" target/debug/jaic jaifmt/main.jai -O2 -exe "$PWD/target/jaifmt"
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= cargo test --locked -p jaic --lib --test cleanroom_modules --test cleanroom_runtime_contract -p jailint -p jai-language-server --test auto_import
```

Builds pass; focused test totals are 155 core units, 50 modules, 2 runtime options,
25 LSP units, 15 auto-import cases and 11 jailint units, all passing. Logs are
`artifacts/integration-clean/{build-refresh9-fixed,formatter-refresh9-fixed,core-refresh9-fixed}.log`.
The protected-memory red test first reproduced two child crashes and a fabricated
comparison; the fixed tests retain all original probe assertions and add real
overlap/zero-length behavior. Windows VirtualProtect execution awaits native CI.

The production runtime now uses the reviewed public crash facade directly;
superseded private startup/crash wrappers are removed. Original conflicting runtime
imports remain negative tests. The default initializer fixture stays positive;
explicit ON/OFF system-entry behavior is tested by the real workspace metaprogram.
Jailint's generic target/private-library-root/incomplete-compilation repairs are
integrated without relaxing application import privacy or changing its rules.

This is a source checkpoint for normal temporary CI, not a completion claim.
Broad suite outcomes and newly settled foundation discrepancies are pending below
and in integration-requests.md. Historical evidence is retained in the sections
that follow.

## Refresh eleven canonical runtime and source checkpoint

Merged compiler72bdba5, foundationsf9cd1c3, portable43f1d1f, bindings40e37e9, windowbfd1c5c and platforme40c412 with prior numerics/LSP/SDL3, plus authorized coordinator CI candidatee8c312d. Latest manifest may contain newer pending heads; it is not a claim of consumption. Production runtime configuration failed before consumer adoption, then passed:

```sh
JAIC_STDLIB="$PWD/stdlib" target/debug/jaic tests/compiler-semantics/runtime-configuration/allocation.jai -interp
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= cargo test --locked -p jaic-cli --test cleanroom_runtime_config
```

Actual canonical library, no overlays: 65536-byte allocation and last-byte access, zero/null and131072 child allocations, late child update of root size, nativeO0/O2 and interpreter all pass (secondary artifacts/runtime-config-production-tests.log; prior rejection retained). No native Windows or production WASI allocation claim yet. Compiler/LSP/jailint production source build passes (secondary artifacts/build-refresh11.log). Native SDL pointer correction is integrated; broad new tests and final integrated lint remain pending. Coordinator CIe8c312d proves wheelbothCPUs and ARM64 crash12cases, while x64 crash, thread output and WGLshared lifecycle failures and ARM64driver capability remain real gates. Full opaque corpus is coordinator-only.

## Refresh12 settled evidence after checkpoint ef5be13

The complete639-file LSP sweep reports17073edits/2762443assertions/zero failed
files (lsp-refresh12.json). Full workspace completes698aggregate passes/56failures,
one inherited ignored across75 result summaries; this includes child-process
output rather than a unique-case count. All11 failed targets remain in
workspace-refresh12.log. Four real caller-font cases plus Linux FreeType execution
pass21 extra invocations (window-font-refresh12/results.json).

The source-built release compiler passes all2300 exact intervals in interpreter,
nativeO0/O2 and WASIO0/O2 (float-power-release-refresh12.log). Full portable retry
now134/134ordinary cases passes, preserving six Windows backend/fixture-target
failures (portable-release-refresh12.log). Broad frozen quality reports833files,
52/171failed checks and unchanged source hashes; full lint is not green.

Latest reviewed SDL prefix policy is implemented with stronger independent public
and native-record checks plus canaries. Actual SDK verifier reports zero failures
(sdl-prefix-verified.json); prefix fixture interpreter/nativeO0/O2 and strict lint
pass (sdl-prefix-modes.log/sdl-prefix-lint.log). Historical equality failures remain.
See native/sdl-native-abi.md. Native other-platform execution remains required.
Latest manifest13 adds compiler Windows unwind and portable SIMD/CAPS/adoption
snapshots; these are pending consumption, not covered by refresh12 totals.

## Refresh14 complete broad-run evidence

Checkpoint ee4de74 consumes compiler3084377, portable2f54d0c, bindings204f6f6,
foundationsad84008 and platform2d36a08. Unchanged production compiler/jailint/
jailsp/jaifmt builds pass; all860 integrated Jai files format/check; full Rust
formatting/item-spacing passes. SDL SDK verification reports zero failures with
separate exact public-prefix/private-native oracles and high-bit close lifetime
coverage. No source overlay or tool-only repair was used.

Full workspace:704 aggregate passes/54failures/one inherited ignored test in77
summaries/nine failed targets (workspace-refresh14.log). Full483-case stdlib
behavior run: interpreter281pass/202fail; native274pass/201fail/eight compile-time
only, zero skips (stdlib-refresh14.log). Broad quality:51/174 failed checks over
860files, stable hashes (quality-refresh14.json). Full foundation behavior/cross
run executes independently despite strict lint stopping at genuine missing APIs;
both required positives remain failures (foundations-behavior-refresh14.log).
These are failure inventories, not completion/platform certification. Subsequent
editor corrections and required API requests are tracked in integration reports.


## Reviewed-test migration checkpoint (2026-10-15, integration role)

Explicit user-authorized replacement retires143 inherited stdlib compatibility
fixtures plus one tracked object artifact, preserves328 source/assets (296
compiler including37 helper modules,14 native including one MPEG asset,9
Extensions,9 graphics). Per-file hashes/reasons and consumer changes are recorded
in stdlib-test-migration.json. No stdlib/Extensions implementation was changed.

Operational Rust/Python/Node/workflow/release-fixture/PGO reads use new paths.
Legacy skip and numeric coverage baselines are removed by authorization;
reachability is informational and cannot establish functionality completion.
Standard CI runs reviewed contracts, compiler/Extensions/ABI/graphics/module
catalogue and separate NEW producer suites against actual production. Windows
ARM64 graphics execution follows actual Mesa build; pinned PyYAML6.0.3 added to
its isolated environment. These workflow edits are prepared, not CI-executed.

Executed evidence:6 catalogue/negative-runner unit tests PASS; precise Hash
privacy rejection and positive baseline PASS through contract and aggregate
runners; sweep negative PASS; native C++ hidden-result-pointer original fixture
PASS O0/O2; C structs-by-value real C test PASS with explicit overlay assertions.
Source-built unchanged jaifmt rewrite/check PASS59 contract/adapted ABI files.
Strict positive-contract jailint originally FAIL49files: two legitimate fixture
lint findings corrected (assert actual first locator, remove redundant alias);
storage-time missing seconds_since_init requires pending portable checkpoint,
not a tool repair. Original failure evidence retained.

Audit/risk/long-term work: retired generator wrappers are no longer compatibility
gates; full reviewed tooling coverage remains incomplete. C++ regression disables
only Clang's return-type-c-linkage warning because an intentionally C-named
C++ non-POD return tests ABI; native result/value assertions remain strict.
Ordered-atomics compiler regression now declares own intrinsic protocol directly,
retaining LLVM order checks plus exact result; no unreviewed Atomics API added.
Long-double presentation casts narrow only formatter arguments, retaining every
wide C ABI/precision comparison; generator-only tail is retired. Struct overlay
formatting no longer assumes an omitted reflected field, while all scalar/array
overlay values are asserted.

Remaining verification: full replacement catalogue and producer/native/browser/
Rust workspace checks still required after pending stable merges. Generic
module fixtures requiring font/SDK helper arguments need actual preparation;
their failures remain visible, no fabricated inputs/pass substitution. Some
producer drivers/builders remain macOS/POSIX-specific; source matrices do not
establish native Windows/Linux execution. Browser reports explicit unavailable
foreign/native SDK cases separately, never passed. Root contract coverage is
bounded, not equivalent to deleted suite or complete reviewed API coverage.
Coordinator alone runs opaque original public corpus, Focus and ordinary native
CI. Release/publication remains held. No push/dispatch performed.

## Production refresh17 validation and scoped repairs

At combined producer head7aec510, cargo test --locked --workspace --all-targets
recorded85 summaries742 aggregatepasses32 failures/one inheritedignored result.
The raw own-source log is retained under ignoredartifacts/integration-clean.
Do not interpret those aggregates as distinct tests or green integration.
Production jaifmt/check covered1052 files; quality-refresh17.json records
58/187 failed strictlint gates and source_stable=true.

Assertion transport correction is committed29ec8f9. Exact focused commands:
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= cargo test --locked
-p jaic --test cleanroom_interpreter_hook (fourPASS), and cargo test --locked
-p jaic-cli --test cleanroom_interpreter_assertions (one test/four scenariosPASS).
The existing module/native-check/runtime-configuration batch passed57 tests.
Workspace clippy --all-targets -- -D warnings PASS. Diagnostics25cases now22PASS/
threeFAIL; remaining failures are retained, not hidden.

python3 tests/stdlib-contract/run.py --jaic "$PWD/target/debug/jaic"
--stdlib-root "$PWD/stdlib" --mode native --opt O0, repeatedO2:54PASS each.
Interpreter54PASS. Counts include declared precise negative checks; these are
bounded spec contracts, not54 distinct native behavior executions.

python3 tools/native_bindings/verify.py --compiler "$PWD/target/debug/jaic"
--stdlib "$PWD/stdlib" --native-libs "$PWD/artifacts/integration-clean/native-sdk"
--module SDL --runtime --report artifacts/integration-clean/sdl-sdk-refresh17.json:
zero failures,30targets24privacy299symbols/nine native-interpreter phases.
Canonical module-owned fixture discovery fixes stale migration paths. Temporary
private test placement restores preexisting bytes/modes and removes added files/
directories even on exceptions; original fixture bytes remain unchanged.

Integration duplicate get_magic4 and User_Event declarations were removed,
retaining the stronger existing magic bounds check and identical SDL layout.
Public skip_this_output_channel restored to its reviewed visibility. Scoped
real jailint -v -D warnings --config jailint.toml on Sound_Player/module.jai plus
changed loaded fragments, Runtime_Support, SDLnative and correctedAudio/codec
contracts PASS; earlier contextless/duplicate-helper failures retained.
Scoped actualjaifmt formatting/check PASS, unchangedjaifmt rebuilt against
production tree. Audio contract successful-buffer test now supplies valid
loaded PCM and asserts actual pointer identity. No default-value assertion lost.

Native source builder now extracts complete verified archives afresh, restoring
transitive headers and removing injected cached files as well as validating
primary pinned files. This deliberately costs extractionI/O per build for
integrity; no nativepin weakened. Seven builder/verifier input regressionsPASS.
Full SDK dependency setup still fails officialX.org connectionreset; scopedSDL,
rpmalloc andFSEvents probes source-build successfully, not all-dependency proof.

## Refresh18 merged production checkpoint and actual gates

Available implementation source head8e561e0 includes reviewed CIe223538 and
SDL3/audio/bindings/tools/portable merges; private assertion fix29ec8f9 retained.
Current focused follow-up repairs are separately committed. Commands/results:

- cargo test --locked --workspace --all-targets --no-fail-fast:
  755aggregatepasses27failures/one inheritedignored; sevenfailedtargets. An
  earlier command without --no-fail-fast stopped after LSP and is not full proof.
- python3 tools/check_cleanroom_quality.py --baseline e1e8d19d0e6792ebc895c12fabe49ba919ef0226
  --format --report artifacts/integration-clean/quality-refresh18.json:
  1107format/checkPASS,56/190strictlintgatesFAIL,source_stable=true.
- python3 tools/audio_build_native.py then audio_verify.py --jaic <ownjaic>
  --stdlib <productionstdlib> --jaifmt <unchangedformatter> --jailint <ownlint>
  --require-device --require-multichannel:27fixturesPASS interpreter/nativeO0/O2,
  six desktop source targets/strictformatlint/privacy, real silent2/6/8SDKstreams.
- python3 tools/check_developer_tools.py:39fixtures/C/C++consumers PASS, real
  native Debug and MSF tool outputs; Windows cross-build distinct from execution.
- python3 tools/native_bindings/build_dependencies.py --output artifacts/integration-clean/native-sdk
  --library binding_rpmalloc_callbacks --library binding_callback_context
  --library rpmalloc_callback_probe --library rpmalloc_sdk_probe
  --library rpmalloc_storage_probe: real scopedsourcebuildPASS. verify.py
  --module rpmalloc --runtime with explicit productionroot/compiler/SDKpath:
  36source96privacy10nativephasesPASS, sixmissingpublicnamesFAIL.
- python3 tools/window_render_native.py then check_window_render.py --jaic <ownjaic>
  --stdlib <productionstdlib> --native-libs <root>/target/window-native
  --font /System/Library/Fonts/Supplemental/Arial.ttf:188invocationsPASS including
  actual hostGL/clipboard/fonts and requiredsource/privacy checks. Prior missing
  test-probe run158PASS18FAIL retained.
- python3 tools/check_stdlib_suites.py with --suite foundations --suite portable
  --suite platform --suite numerics --suite numerics-native and explicit real
  productiontools/native directory: only numerics-native PASS25/25; otherfour
  fail. Foundations stops on actual returnedPool lifetime fault, not an invalid
  expected-output change. Portable failures retained with keep-going. No whole
  producer success from each owner's staged historical results.
- stdlib_runtime.py --modes interp,native,wasm-interp,wasm-native --jobs4 --timeout60
  --verbose:394cases, results detailed in integration-deviations. Dependencies
  incomplete and realAPI/compiler errors remain. Five expectednegativechecks
  and22WASMunavailableSDKcases reported separately, not passed.
- lsp_partial_edits.py stdlib tests/stdlib-contract tests/compiler-regressions
  --stdlib <productionstdlib> --max-lines8 --jobs2 --timeout60
  --report artifacts/integration-clean/partial-edits-refresh18.json: running
  1086ownfiles, no corpus/vendor imports/fetchers. No success claim yet.

Module inventory now135 modulepages plus one constant-table supplement:124
facadespresent,11missing. Presence does not certify bodies/API completion; all
remain unverified as whole modules. Portable alone has253missingpublicrows.
Original corpus opaque input and Focus remain coordinator-owned; no fetch of
vendored Jai bodies or access to original/quarantined histories. Release HOLD.

## Target/context lint adoption

Compiler4de36d6 merged as021c00f. Source/target/runtimeOptions clone across real
contexts and workspaces; strict imports/required bindings/failed bodies retained.
Existing --add and checked-files support remains; new structured --manifest is
the coverage oracle. Actual38producer jailint tests plus retained root testsPASS.
No staged compiler or repaired library is used by the integrated tools.

tools/check_cleanroom_quality.py --contexts tools/cleanroom-lint-contexts.json
uses49 actual reviewed positive programs and seven source targets. Explicit
MSVC and WASI triples preserve ABI selection. Four coverage protocol unitsPASS.
Host pilot command retains1137ownedformat/checkPASS and207clean-complete covered
files;930uncovered/fourcontextfailures cause a nonzero gate. It is incomplete,
not certified lint coverage or a replacement green CI result. Context JSON
records pending negative/fault cases, which remain precise contract-runner
checks and cannot be called successful body lint. Old uncontextualized mode is
explicitly labeled diagnostic isolation, not target/context completeness.
Expand real producer/configuration/private-unit contexts before claiming full
coverage. No global rule suppression, source patching or artificial defaults.

Source build after latest merged headsPASSallthreeRusttools and unchangedjaifmt;
workspaceclippy warnings deniedPASS. Real SDLnative verifier againzero failures.
macOS FSEvents private ABI verifier nowzero failures after normal system-library
lookup and legitimate temporary input placement/restoration. ScopedrpmallocSDK
build includes both separately prefixed statistics profiles, actualcallbackSDK
dependency closure and consistent flags. Public verifier retains six genuine
missing-name failures; successful nativephase counts remain separate.
Developer tools48effectfixtures interpreter/nativeO0/O2 and C/C++consumersPASS;
1176SDKlayout/enumcomparisons/360symbolresolutions are separate evidence, with
symbol lookup explicitly not invocation. NativeWindows/alltooling scope incomplete.

## Partial-edit probe boundary correction

The 1,086-file refresh18 sweep retained two failures: truncating a conditional import or `#add_context` legally captured the synthetic trailing declaration. A new generic directive regression reproduced the loss of tail symbols, types, definitions and hints. The harness now inserts an empty statement outside the edited source before its independent tail probe. Original cut points and every assertion remain enabled; no compiler recovery or application input was changed.

Verification: `cargo test --locked -p jai-language-server --test edit_corpus` passes all three tests; the new case failed before the boundary correction. `cargo clippy --locked -p jai-language-server --all-targets -- -D warnings` passes. Retrying both actual failing files with `tools/lsp_partial_edits.py --retry-report ... --stdlib stdlib --max-lines 8 --jobs 2 --timeout 60` passes 38 edits and 1,448 assertions. A full owned-source rerun remains required.

## Refresh20 merged production verification

Consumed exact producer OIDs are recorded in integration-refresh.json. Compiler093712a (15 new focused core/backend tests plus9 preserved literal tests), portablee81f1a5 (Pool/Thread, Machine wrappers, SHA and Apollo), developer4f87fd6, window387efe2 and CI172558a are merged with semantic conflict review. Source-built CLI/lint/LSP build passes. `python3 tools/check_developer_tools.py` passes56 actual interpreter/native O0/O2 fixtures and native C/C++/SDK checks. `cargo test --locked --offline --manifest-path fuzz/Cargo.toml -p jai-fuzz-harness` passes2 harness and10 replay tests. `target/mesa-verification-venv/bin/python -m unittest discover -s tests/window-render -p 'test_mesa_*.py'` passes16 infrastructure tests.

`python3 tools/check_integrated_lifecycles.py` passes50 actual production-source executions: four Pool/leak cases and three Thread cases under enabled/disabled assertions, interpreter and host ARM64/translated x64 native O0/O2. The workspace uses public remap_import to reexport canonical Basic(false); no library copying/default rewriting. Real Mach error retention verifies assertion-handler count0 versus1. Production source hashes are unchanged. `jailint -v -D warnings --context tests/portable-stdlib/thread-configured/production-context.jai --manifest ... stdlib/Thread stdlib/internal/thread stdlib/Basic stdlib/internal/basic tests/portable-stdlib/thread-configured` passes; inactive inputs remain explicitly unvisited.

Full lint/behavior/corpus/platform verification remains incomplete. A new forward-enum reduction reproduces the Socket ADDRCONFIG failure; original diagnostics are retained. Approved SDL3/WGL narrow build repairs await safe-ref synchronization. The full partial-edit sweep is running against the frozen own e2f9e22 worktree; interrupted mutable-source sweep is not a pass. No forbidden corpus vendors were read and no release/push/CI dispatch was performed.

## Per-target lint coverage expansion

The context manifest now selects368 unmodified contract/producer sources (2576 target jobs) and factors122 shared library paths without changing the actual inputs. Six protocol unit tests pass, including the regression that host coverage must not cover an inactive Windows file. The report keeps each target's uncovered files separate; all seven profiles remain required conservatively. Conditional-file applicability, deliberately invalid test roots, real parameterized callers and platform-native compile-time operations still need precise classification. These are unresolved coverage requirements, not thousands of asserted independent implementation bugs or a lint pass. No denied/incomplete context establishes clean coverage.

The expanded run began as diagnostic integration evidence. Subsequent legitimate source fixes and compiler builds mean it cannot be final unchanged-source/tool proof; a stable rerun is required. Earlier343-job results remain unchanged evidence:19 denied/incomplete runs,891 files without any clean complete context.

## Refresh21 verified checkpoint

The frozen e2f9e22 worktree full partial-edit run passes1091 files,28912 exercised edits and3310574 assertions, zero failed files. Command: `LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= JAIC_STDLIB=<own-frozen-stdlib> python3 tools/lsp_partial_edits.py <own-frozen-stdlib> <own-frozen-contracts> <own-frozen-compiler-regressions> --stdlib <own-frozen-stdlib> --max-lines 8 --jobs 4 --timeout 60 --report artifacts/integration-clean/partial-edits-frozen-e2f9e22.json`. Only our committed inputs/unchanged Extensions were read; this is not public-corpus proof or a claim for later source changes.

SDL3 packaging rebuild: `python3 tools/sdl3_native.py --platform macos-arm64 --out artifacts/integration-clean/native-sdk-sdl3-refresh21 --offline --jobs 4` passes the real pinned SDK build and all four relocated C/C++ static/shared consumer executions. Mesa19 and SDL3 Python40 tests pass. Filtered coordinator report attributes six-target SDL3 native CI and fuzz passes to candidate2fa2bc2; broader Windows CI is not green. Ordinary branch triggers were reviewed as read-only test/artifact workflows; release tag/manual publication remains held.

Five focused native regressions now pass via `cargo test --locked -p jaic-cli --test native <name>`: compiler_and_abi_regressions_run_natively, windows_runtime_program, stdin_lines_are_read_natively, empty_workspaces_write_no_output and stack_traces. Canonical workspace dispatch is a real compiler repair. Legacy fixture corrections retain typed alignment/contents, use the NewArray allocation-base result, preserve actual POSIX sentinel bits with required macOS casts, use File_Utilities ownership and void thread_start, and preserve pipe/CRLF/empty-line/final-EOF behavior through File.file_read. Runtime assertion traces now print available frame locations; a private helper is explicitly #no_debug, and all available frames remain walked. Exact unreviewed text/path presentation expectations are retired, with meaningful location/depth/termination checks retained.

Full refresh20 workspace evidence is792 passes/16 failures/one ignored; five individually repaired failures are not a new full-suite pass. The [concise compiler handoff](../compiler/integration-refresh21-requests.md) classifies remaining work and contains an original forward-enum reduction. The expanded lint diagnostic run was interrupted after legitimate source/tool updates; it is not stable final proof.

## Refresh22 combined checkpoint

`LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= cargo test --locked
--workspace --all-targets --no-fail-fast` on the actual production library finishes
94 summaries:810 passed,10 failed,one inherited ignored. Failed targets: CLI,
native and target ledger. Browser library tests now pass. Remaining failures are
Default_Metaprogram, old Build_Options expectations, browser Thread test setup,
legacy interpreted Thread assumptions, Extensions fiber/two WASI formatter
dependencies, WASI tour, Socket enum dependency and target classification.
Original refresh22 failure evidence remains; this is not a green workspace.

`python3 tools/native_bindings/build_rpmalloc.py --output
artifacts/integration-clean/native-sdk` and scoped `build_dependencies.py` now
share native construction. Real public heap interpreter/native execution and
relocation with complete callback-context dependencies pass without loader
overrides. All70 bindings Python tests pass using owned `.work/tmp`; five focused
profile/input-scope/failed-launch checks pass. The production selector never
silently rewrites private profile source. The complete heap sweep must rerun after
correcting stale probe/temp-directory/cleanup-caller failures. Target-aware lint
now includes changed existing/untracked fixtures and records stable
HEAD/source/tool/config/context fingerprints; full quality gates remain open.

## Refresh23 production reexports and data integration

`cargo test --locked -p jaic --test cleanroom_modules` passes52 tests after the
original anonymous filtered export regression fails before the fix. Separate
`-p jaic -p jaic-llvm --test cleanroom_enum_dependencies` passes6 core/one backend
tests. Source-built CLI/lint/LSP and unchanged jaifmt rebuild pass; workspace
Rust formatting and clippy with warnings denied pass after scoped formatting.
The real resolver command and storage contract are described in
[foreign-data-reexports](../compiler/foreign-data-reexports.md). No immutable
binding semantics were broadened and no library/path-specific compiler rule exists.

`python3 tests/portable-data/run.py --native-libs artifacts/native-libs/macos-arm64`
passes all supported host interpreter/nativeO0/O2, portable WASI, SDK resource/wire
consumers and seven target lint/body-check contexts. Windows native readback and
discovery/+Icon effects remain unexecuted host gates; ordinary x64/ARM64 CI now
registers them with actual source-built tools and pinned SDK DLL construction.
Only the five scoped data producer commits were consumed, sourceb1c6b1a5 through
localefcb29fe, without importing producer base integration history.

`python3 tools/native_bindings/verify_rpmalloc_heaps.py --compiler target/debug/jaic
--formatter target/jaifmt --stdlib stdlib --native-libs
artifacts/integration-clean/native-sdk --report
artifacts/integration-clean/rpmalloc-heaps-production-refresh22-complete.json`
finishes71 checks with zero failures on actual production Root stdlib. Includes
host ASan/UBSan C probes, six desktop public layout targets, real private/native
counter/callback programs, strict scoped format/lint and70 Python tests. This is
the explicit private false heap profile only, not raw/options/all-platform proof.

Latest reviewed CodeView sentinels regenerate normally with zero pending aliases.
`python3 tools/check_developer_tools.py` passes61 actual interpreter/nativeO0/O2
fixtures, real C/C++ round trips and scoped strict formatting/lint, including the
new seven-value canonical-name/width test.1176 SDK layout/enum comparisons and
360 symbol resolutions remain distinct from invocation coverage. Host SDK23 and
prepared Windows Debug cross-builds do not establish SDK21/native Windows proof.
Whole current-head workspace/catalogue/quality/partial-edit proof remains open.

## Refresh21 catalogue and resource diagnostics

The394-case owned catalogue completed with313 interpreter positives/76 failures and308 nativeO0 positives/74 failures, plus5 precise negatives each and7 native compile-only cases. This diagnostic run occurred during edits and included a harness false failure: malformed lexer diagnostics were merged into expected stdout. The corrected runner keeps both streams exact, requires a separate strict source check before compile-only classification, never reclassifies timeouts, and propagates cleanup errors. Nine runner tests pass; original classification failures remain in artifacts. A complete54-contract rerun now passes49 positives plus5 expected negatives in each interpreter/nativeO0 mode. No broad catalogue green claim follows.

Foundations rerun passes the previously failing leak-report/graph cases, then stops on canonical visualization channel acquisition. Independent official SDK diagnostic creates/maps/releases a unique own channel, but canonical O_EXCL creation fails errno17. Existing channel ownership is unknown; no data was opened/read/unlinked and no public constant was renamed. This requires coordinator native isolation. Portable suite completed real watcher/bundle/IPC/runtime checks, then exposed stale MPEG asset paths; those six authored fixtures now use the unchanged migrated input, and the PTS fault reaches its intended checked diagnostic. Whole suites remain failed until rerun.
# Frozen native Mac measurement

On 2026-10-15, candidate `integration/thread-fixtures` at full source head
`90fea8ab84fa881b96a327d2bb117541e83429b4` was measured without source edits during
either command. Candidate path:
`artifacts/integration-clean/thread-fixtures` under the clean integration root.
The [JSON report](../status/mac-integration-baseline.json) contains exact commands,
environment, aggregate counts, all failure names and diagnostic classifications.
Workspace exited 101: 822 passed/seven failed/one ignored across 97 summaries.
Catalogue exited 1: 408 cases, interpreter 327/76 plus five expected negatives;
native ARM64 O0 320/76 plus seven compile-time-only and five expected negatives.
Neither command timed out. No optional profile or second native architecture
catalogue was launched. Existing complete workspace tests retain their target,
ABI, ownership, native optimizer and precise negative checks.

Rust sources were rebuilt from this candidate using the existing own root target
cache. Production stdlib and fresh rpmalloc SDK were selected explicitly; no
library overlay or tool-only repair was used. Raw logs are durable ignored
`artifacts/mac-baseline/{workspace,catalogue}.log`, with SHA256 in the report.
All seven workspace failures remain enabled. Failure classifications are triage,
not expected-failure exemptions. No original application/vendor source was read.
# Focused repairs after the frozen measurement

Shared source checkpoint7467b49d integrates the six newly supplied portable,
compiler, profiler and generator/tooling snapshots with canonical state once.
Rust CLI/LSP/linter source rebuild passes. Actual production canonical generator
and model-helper fixtures print ok. Producer staging scripts are not executed as
production proof; Default/Project/Example drivers now use this stdlib directly.
Example actual O0 callbacks/workspaces and strict lint pass; Default behavior
cases pass but its mandatory full lint still fails missing Check factory. Project
behavior/artifacts pass before mandatory sandbox executable-path lint failure.
Both failures remain active. Reviewed duplicate Context fields still reject.

The migrated Default CLI test explicitly calls build, requests reviewed -no_check,
executes the native child and retains precise unknown/missing/unsupported option
checks. Unsupported legacy -os/-cpu/-no_output options are not invented. Diagnostics
may use either stream where the contract does not choose one. Whole-module default
Check functionality is not claimed from this supported subset.

Actual root-library main-thread affinity is now decided before its first foreign
call, removing symbol-name activation. Library-neutral C regression has red/green
evidence. Original SDL WM and all19 CLI tests pass. Workspace Clippy with warnings
denied, Rustfmt and scoped Jai formatting pass. Broader native ABI/callback/fork
and full stable workspace/catalogue replay remain required after committing.

Approved Extensions34c06fa3 and graphics7a5cce7a are merged through e026e5f3 and
b99d2f02; inbox/control guidance was excluded and latest authoritative specs
preserved. Against committed b99d2f02, all28 affected Extensions cases pass native
ARM64 O0, while interpreter gives27 passes/one120-second timeout in Json numbers.
All independent cases finish; that timeout remains a failure. See the JSON report.

Mac clipboard catalogue cases require `JAIC_CLIPBOARD_GUARD` naming the actual
source-built guard (`clang -Wall -Wextra -Werror -fobjc-arc
tests/window-render/clipboard-guard.m -framework AppKit -o <owned-output>`).
The guard restores actual materialized clipboard bytes even after child failure
or its native deadline. The runner serializes those cases and gives restoration
30 seconds beyond the child budget. Timeout cleanup is tested with a real hanging
C child: expected124, actual native restoration verification, measured0.188s for
a50ms child deadline. No source-library overlay or dummy video/clipboard exists.
Use repeatable `--case <catalogue-id>` to rerun exact affected source entries;
unknown IDs fail instead of silently reducing coverage. Native services remain
required. The private sandbox token fixture is explicitly WASM-only.

Another genuine unused-code defect was Unix Socket.select's unresolved TIMEVAL
spelling. The generator now supplies a file-private alias to canonical POSIX
timeval, matching the reviewed Unix declarations and installed official SDK
select prototype. Public TIMEVAL remains Windows-only; no new Unix export, copied
record or renamed reflected type was introduced. The unchanged public facade and
ledger regenerate byte-for-byte. New real zero-timeout select/canary/visibility
fixture passes interpreter/native ARM64 O0; full unused-code host checking,
contextual strict lint and the original complete host C ABI regression pass.
Regeneration equality covers all three generated outputs. Other native platforms
are not inferred passed from this host evidence.

Unused-code baseline also exposed a genuine general System facade error:
its reviewed CPU-X64 `M64 :: #import "Machine_X64"` alias was forwarded through
a backend that did not export it on Windows. The facade now imports the canonical
module directly, preserving reflected type/enum identity and the CPU condition.
The new positive/absence fixture passes host interpreter/native ARM64 O0 and
strict lint. Windows-x64 `-check -no_dce` reproduced the error before and passes
after; Android/Toolchain's original Windows-x64 unused-code check also passes.
These are source checks, not native Windows executions. No new export was invented.

Corrected storage/immutability review eaf39199 contributes only reviewed net tests
and documentation; existing proper production registration57cb0b51 is retained.
Unsupported live-alias commits are not merged. Exact selected file provenance is
in `docs/integration-refresh.json`. The original52 module cases plus six corrected
core storage/constant regressions pass; workspace Clippy remains warnings-denied
green. New LLVM native/WASM64, jailint target and actual wasm32 test sources are
present but their extra matrix execution remains outstanding, not passed. The
producer's minimal test bootstrap is explicitly not a second production prelude.

Catalogue preparation now supplies isolated real scratch-file/directory arguments
for Io worker, resource and SDL RWops programs; glyph atlas requires the explicit
`JAIC_TEST_FONT_PATH` environment variable naming a real file. Missing fonts remain
failures. Runtime platform labels must match the host. Six explicit Linux/Windows
fixtures are reported platform-unavailable on Mac, with required native execution
still outstanding; they are not positive or negative passes. All original source
guards and the seven-target unused-code test remain unchanged. Nine runner tests
pass, covering strict negatives, timeouts, inputs and platform classifications.

Actual prepared-input runs pass Io workers and glyph atlas in interpreter/native
ARM64 O0. Portable-data selection passes two local programs in each mode and
reports four Windows programs unavailable. Build the real SDL C probes with
`python3 tools/native_bindings/build_dependencies.py --output artifacts/native-sdk
--library sdl_abi_probe --library sdl_runtime_abi_probe`. All three SDL fixtures
pass native ARM64 O0; layout and RWops also pass interpreted execution. Interpreted
WM remains failed at actual `SDL_Init` with `No available video device`, after
passing the size/offset/union/null-window/canary checks. The fixture now reports
assertion locations and SDL errors instead of an unexplained libc abort, preserving
every check. No SDK/dummy video or memory-only substitute was added.

Compiler-options follow-up: full `cargo test --locked -p jaic-cli --test cli`
reports17 passed/one failed/zero ignored; only Default_Metaprogram remains in
that suite. Original interception totals and continuable-error behavior pass;
alternate backend, raw LLVM and Natvis requests have precise rejection tests.
Natvis implementation is still missing and now diagnosed rather than ignored.
Scoped production Compiler lint, jaifmt, Rustfmt and workspace warnings-denied
Clippy pass. The frozen full-workspace totals are not arithmetically rewritten
from focused tests.

The original `sandbox_threads_wake_waiters_and_report_deadlocks` test now passes
all three scenarios against the actual private SandboxHost pthread/condition
provider. Returned-worker and blocked-worker cases still require the precise
deadlock diagnostic and empty stdout; the timed case requires ETIMEDOUT followed
by successful signaling, busy-wait progress, and a successful join. Public Thread's
WASM guard is intact. These fixtures describe the compiler's private token protocol
and are never native pthread ABI declarations. Strict contextual WASM lint,
jaifmt, Rustfmt and workspace Clippy with warnings denied pass. This repairs a
third focused baseline failure; no aggregate green claim follows from it.

All seven `tests/compiler-regressions/threads-*.jai` now pass interpreter and
native ARM64 O0 through `tools/stdlib_runtime.py --filter compiler/threads-`.
The original Rust `interpreted_threads` test also passes, retaining its exact
`ok` stdout assertion. Group fixtures explicitly select `logging = false`;
the production public default is unchanged. The real Debug helper was built
with `python3 tools/build_developer_debug.py`; original
`backtrace_sees_compiled_callers` passes its original O0/O2 caller assertions.
Scoped jaifmt check and strict verbose jailint over all seven roots pass.
Logs/manifests are in ignored `artifacts/mac-baseline/`.

Migration details and unresolved old invalid-state assumptions are recorded in
`docs/specs/questions/cleanroom-integration.md`; those assumptions are not counted
as supported negative tests. The frozen full-workspace/catalogue counts remain
unchanged until a new complete snapshot is measured. This closes two focused
workspace failures, not the remaining integration gaps.
