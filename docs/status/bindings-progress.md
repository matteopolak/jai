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
