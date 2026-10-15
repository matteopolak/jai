# Bindings worker progress

Active implementation; full integration/corpus/release verification remains
coordinator-owned. POSIX/WGL checkpoint: `79af73e`; safe SDL/iOS/X11 checkpoint:
`fddae00`.

2026-10-14 current batch:

- Fixed distinct-shape association with per-CPU inventory availability. A sole
  shape within an OS is shared by that OS's declared CPUs; distinct CPU shapes
  remain separate. No borrowing across OS boundaries. 35 generator regressions
  pass. POSIX unresolved declarations reduced from 67 to 8 by emitting actual
  reviewed records/enums, including all missing macOS x64 declarations.
- Implemented `GL.wgl_create_context` through private native WGL setup. It
  bootstraps driver functions on the target display, selects/reuses a window
  pixel format, queries actual multisampling, creates/shares real contexts and
  restores the previously current context. Windows x64/ARM64 source checks
  pass; native Windows execution remains required, not claimed.
- Refreshed only safe producer `../compiler`; ordinary compiler/linter build
  passes. The actual `jaifmt/main.jai` now builds against current foundations
  without a compiler patch. Added foundations' new `internal/native-path` to
  staging. Strict lint of GL/POSIX/new WGL internals/all native tests passes.
- New host public C SDK probe passes seven POSIX sizes and seven offsets, plus
  a real `getitimer` call. POSIX declaration/public-name checks pass on both
  Linux CPUs and both macOS CPUs. Linux cross-target checks are source evidence.
- Both macOS CPUs now execute source-built C/Jai ABI and ordinary POSIX tests:
  all 12 checks pass, with x64 running through OS translation on this ARM64
  host. Evidence: `.work/posix-sdk-both-cpus.json`.
- Safe SDL RWops adapters preserve the public 48-byte record and Jai callback
  ABI. Complete private C storage, custom UNKNOWN tagging, range checks and a
  synchronized live-address registry prevent native overreads and copied-file
  callback overreads. Real BMP/custom-stream/canary/file/close/copy tests pass;
  original RWops/UserEvent ABI mismatch assertions remain active failures.
- Four X11 window/UI helpers have real bodies and Linux source checks. Real
  X-server drawing/pixel tests are supplied but not executed on this host.
- Android EGL has a real ES2/config/MSAA/context/surface implementation with
  checked native calls and retained failure handles. Neither Android type
  checking nor device execution is claimed while the compiler rejects its OS.
- All iOS helpers now obey iOS-only public visibility. Eighteen desktop absence
  checks and the private native SDK/pipe/cache unit pass; two required iOS CPU
  source checks still fail on unsupported compiler targets.

Evidence: `.work/posix-wgl-current.json` retains the initial WGL array-literal
failure; that syntax was corrected and both Windows CPU checks pass afterward.
Expanded current runtime/matrix report: `.work/posix-wgl-native-current.json`.
That report has six failures, all public-name checks for the unresolved generic
GL helper; every recorded native build/run passes, including real GL shaders,
NSOpenGL, POSIX and procedure-reflection regressions with the ordinary compiler.
All 40 production formatting/regeneration/regression/strict-lint checks pass;
full commands/results: `.work/production-owned-tool-checks.json`.
Native C probe: `tests/native-bindings/posix_abi_probe.c`; executable regression:
`tests/native-bindings/posix-abi.jai`. Native SDL mismatch tests stay active.

Next: finish broad format/lint and current matrix, then remaining owned wrappers
and configuration gaps. Eight Android shape associations, general GL dispatcher,
rpmalloc, enabled telemetry, Objective-C class helpers, D3D/DXC convenience
wrappers and X11 helpers remain required. See deviations/questions for exact
limitations; declaration counts are not a claim of native completeness.

Current source ledger: 28,397 declared, 1,262 forwarded, 547 generated bodies,
45 manual bodies, 120 unresolved, one duplicate. Manual includes unverified
Android code; no native completion is inferred. Configurations still have 58
required failures. The intermediate broad matrix recorded 1,200 symbols passed,
45 native checks passed and two native failures (invalid host iOS expectation
and retained SDL layout mismatch). It preceded the iOS fix and straddled an
X11 fixture update; two X11 source failures are an incoherent intermediate
snapshot, not current source results. Preserve `.work/current-owned-full.json`;
rerun a stable fresh snapshot before reporting final broad counts.
Current reports: `.work/checkpoint-2-production-tools.json` (40 passed),
`.work/sdl-rwops-native-final.json`, `.work/ios-sdk-paths-current.json`,
`.work/adapter-privacy-current.json`, `.work/windows-render-current.json`.
The actual Windows renderer remains blocked by the independent fixed-array
literal reproducer in NEW producer Unicode, after integrating the File owner.

Subsequent reviewed progress:

- Eight Android POSIX records now come from complete pinned official Bionic
  headers, with all field sizes/offsets and record sizes/alignments asserted
  for both C targets. Explicit reviewed target shapes always take precedence;
  no new names or cross-OS guessed layouts. POSIX has zero unresolved source
  declarations; Android Jai/device verification remains unavailable/required.
- Fixed generic nested C++ member ownership tracking. `TextFilter.TextRange.split`
  replaces the invalid flattened verifier expectation, preserving the API.
  Added a real Jai-to-SDK native constructor/split test with three sizes/five
  offsets checked first. Added the missing C++ runtime dependency, shared by
  ImGui/NVTT/meshoptimizer with platform-correct default native runtimes.
- SDK-focused matrix: 50 source checks, 10 native checks, 549 symbols passed;
  zero failures. Both macOS CPU ABI/runtime probes still pass. All 41 current
  production tool checks and 41 Python regressions pass.

Evidence: `.work/sdk-delegates-and-cpp-current.json`,
`.work/posix-sdk-delegates-both-cpus.json`, `.work/checkpoint-3-production-tools.json`,
`.work/android-posix-header-regeneration.json`.
Stable checkpoint-2 full report is `.work/stable-checkpoint-2-full.json`:
240 source checks passed/36 failed, 47 native passed/one retained SDL ABI failure,
96 privacy passed/two blocked by D3D, 1,200 symbols passed. It predates the six
corrected ImGui namespace checks, which now pass in the scoped report.

Next stable checkpoint: Linux ARM64 `stat`, `lstat`, and `fstat` now use a
private 128-byte kernel record and real target syscall numbers from pinned
official Linux UAPI headers, then copy successful results into the unchanged
144-byte public record. Null buffers and failures retain native error behavior;
failed operations leave the public output unchanged. General LP64 C record
translation is shared with the Android delegate instead of duplicated.

Evidence: `.work/checkpoint-4-tool-checks.json` has six successful production
format/strict-lint/regeneration/regression commands, including 43 Python tests.
`.work/posix-stat-current-foundations.json` passes four Unix source targets and
host native regressions. `.work/posix-stat-sdk-both-cpus.json` passes all 16
macOS C-oracle/build/runtime checks on both CPUs. Linux ARM64 headers/layouts
are cross-compiled and every field asserted; Linux ARM64 execution is still
required and is not inferred from macOS execution. The current NEW foundations
dependency `internal/basic-context` is staged; the actual formatter was rebuilt
successfully against it without a compiler patch.

Ledger: 28,397 declared, 1,262 forwarded, 544 generated bodies, 48 manual
bodies, 120 unresolved and one duplicate. This reclassifies three existing
unsafe stat forwarders as real adapters; it does not manufacture a coverage
increase. The 58 configuration failures and retained SDL public ABI mismatch
remain required work. Next: remaining reviewed wrappers and refreshed compiler
configuration verification.

Refreshed reviewed GL behavior now supports the exact generic current-context
wrapper. It creates real WGL/GLX/NSOpenGL contexts, attaches the macOS view and
makes the context current, retaining the reviewed native caller lifetime model.
Six desktop source targets, all eighteen GL alternative configurations, and
eight host native build/run checks pass (`.work/gl-dispatch-current.json`,
`.work/gl-dispatch-configurations.json`). The complete configuration matrix now
has **40 failures**, reduced from 58 by actual GL implementation. D3D forward
overlay, rpmalloc, enabled telemetry and mobile target failures remain required.

Refreshed SDL review explicitly requires actual SDK-owned RWops pointer
identity and does not support Jai-created callback tables. Removed the prior
custom owner/registry/context adapter, restored real native foreign symbols,
and replaced unsupported custom-table tests with symbol identity, genuine file
operations, BMP success/failure, exact native close counts and both freesrc
modes. `.work/sdl-native-pointer-current.json`: twelve source, seven native,
twenty-four privacy and 299 symbol checks pass. The one retained native failure
is the unchanged public RWops/UserEvent ABI mismatch test.

Current producer compiler and linter were rebuilt from safe NEW sources.
Production formatter rebuilt unchanged and complete owned formatting/regeneration
and 43 Python tests pass. Refreshed jailint now rejects incomplete roots rather
than reporting a misleading pass. The broad retry records 25 successful commands
and 16 incomplete lint scopes (native target guards, private-root import context,
and real declaration gaps). Fresh-staged host GL/SDL/POSIX and changed native
tests pass strict lint. Full target-aware lint is still required; no suppression
or alternate target constant was introduced. See native/lint-target-context.md.

Source ledger: 28,399 declared, 1,262 forwarded, 544 generated bodies, 47 manual,
119 unresolved, one duplicate. Broad source/native matrix is running against a
stable staged snapshot; scoped results above are not full integration evidence.

Stable full checkpoint-5 completed: 262 source passed/24 failed, 51 native
build/run passed/one retained SDL layout failure/one unsupported public iOS
host case, 96 privacy passed/two blocked by D3D, 1,200 symbols passed. All
required failures remain active. Evidence: `.work/stable-checkpoint-5-full.json`.

Subsequent work: X11 modal message box now has native UI/event handling for
all seven styles, keyboard/button/WM-close/destruction paths and other-window
event preservation. Both Linux CPUs source-check the real-server automated
test; Linux native execution is still required. Private helpers remain hidden.
Pinned complete official X.Org protocol header assertions pass both C targets.
Formatting/regeneration/43 Python tests pass; strict lint still reports the
real host target guard instead of claiming Linux bodies visited.

`DXC_Reflect` now has a real checked COM forwarding body and an actual native
DXC compile/reflection test. Its Jai source is blocked before body validation
by the general D3D12 forward-overlay issue; no source/native DXC pass is claimed.
Complete pinned Microsoft SDK headers/source confirm native buffer handling;
SDK buffer/COM scalar layout assertions pass both macOS C++ CPU compilations.
These host adapter probes are not Windows ABI/runtime execution. Ledger now
records 49 manual authored bodies and 117 unresolved; unverified authored code
is explicitly not completed functionality. Next: remaining DXC compile helper
and supported reviewed convenience work; compiler/target/native gaps stay open.

Next batch: `DXC_Compile` has complete real SDK routing, checked HRESULTs,
include handling, native diagnostic bytes, owned result copying and COM cleanup.
Its private compile route and strict UTF-16 conversion each source-check both
Windows CPUs. The pure argument serialization unit builds/runs on the host and
passes production strict lint. The public DXC program still fails at unchanged
D3D12 forward overlays; native Windows execution and target-aware lint are not
claimed. Declaration source is shared rather than replacing SDK interfaces with
test sketches. Native HLSL/SPIR-V and invalid-source executable tests stay active.
Evidence: `.work/dxc-final-source-and-units.json`,
`.work/dxc-compile-production-tools.json`, native/dxc-compilation.md.

A new actual SDL native regression found 64-bit freesrc truncation to C int:
`0x1_0000_0000` failed to close a genuine SDK file. A thin scalar adapter now
normalizes every public nonzero flag to native 1, keeping the same SDK-owned
pointer. The native before report has two failures; after repair only the
original record layout failure remains. Actual BMP/file/close-lifetime tests
pass. Factory symbol identity is unchanged; loader adapter address difference
is documented. No custom callback/owner registry returned.

Formatting, regeneration, 44 Python regressions and strict host SDL/serializer
lint pass (`.work/checkpoint-7-production-tools.json`). Latest SDK C++ buffer
and interface-header layout assertions pass both host CPU compilations. Strict
Windows lint still reports actual target guards in the fully staged dependency
tree. Current root ledger: 28,398 declared, 1,262 forwarded, 544 generated,
51 manual authored, 116 unresolved, one duplicate. Counts do not imply native
completion. Full matrix/configuration reruns are running against a stable
current snapshot; preceding full result remains explicitly historical.

Current stable reruns completed (`.work/checkpoint-7-full.json`,
`.work/checkpoint-7-configurations.json`): 268 source passed/26 failed,
53 native build/run passed/one retained SDL layout failure, 102 privacy
passed/ten blocked by D3D, and 1,200 symbols passed. Configurations retain
40 failures. Totals include explicitly labeled private SDK/argv units, not
extra public API/native Windows claims. Two added source failures are the
required public DXC executable on both Windows CPUs, blocked at D3D12; eight
added privacy failures expose that existing dependency blocker. Six new X11
private helper privacy checks pass. No required checks were removed to improve
totals.

Latest implementation commit: `854405b`, after `4137f3c`, `40e37e9` and
`1afd394`. Remaining declarations: rpmalloc 80, enabled telemetry 14,
Objective_C 8, Android 7, X11 4, d3d_compiler 2, DXC version string 1.
Additional declared/native ABI discrepancies, target-aware lint and unavailable
native executions remain required. Questions/deviations distinguish missing
contracts from code/compiler work; the scope is not reported complete.
