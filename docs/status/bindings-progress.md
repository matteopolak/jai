# Bindings worker progress

Active implementation; full integration/corpus/release verification remains
coordinator-owned. Last committed checkpoint before this batch: `b8e492b`.

2026-10-14 current batch:

- Fixed distinct-shape association with per-CPU inventory availability. A sole
  shape within an OS is shared by that OS's declared CPUs; distinct CPU shapes
  remain separate. No borrowing across OS boundaries. 34 generator regressions
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
