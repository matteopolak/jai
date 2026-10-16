# SDL SDK fixture migration repair — ac174e80

Root supplied actual CI evidence: all reported macOS ARM64/Linux x64/Linux ARM64
stdlib runtime jobs stop with `FileNotFoundError` for
`tests/native-bindings/sdl-layout.jai`. The canonical retained test is now
`stdlib/SDL/tests/sdl-layout.jai`; RWops and SysWM tests moved alongside it.
This is a runner migration defect, not missing/unsupported SDL functionality.

Ownership declared to integration before edits: narrow SDL source/runtime path
selection and private-unit registration in integration-owned
`tools/native_bindings/verify.py`, new `fixture_paths.py`, focused test and docs.
Shared source/index and workflows are untouched by this worker. Integration
alone reviews/applies/stages the exported helper hunks; SDK/native execution was
not claimed while bindings/stdlib may hold the bounded execution slot.

[Exact new patch](../../patches/sdl-fixture-paths-ac174.patch), SHA256
`3854530307385a499cad7e40ce29bb9f419ab5a80bbdcf62d1a6bfe825e9c165`,
is pinned to clean source object `2a29b054c0e3bdcf686f39de446c2569970b1798`.
[Receipt](sdl-fixture-paths-ac174-receipt.json) records base/output hashes and
unchanged canonical fixture/C-oracle hashes. Later integration workflow changes
are recorded separately, not incorporated into this source patch.

## Correct path, private boundary and retained ABI checks

The explicit fixture migration inventory maps exactly these three files to
their canonical `stdlib/SDL/tests` locations: `sdl-layout.jai`, `sdl-rwops.jai`,
`sdl-wm.jai`. Both source-check and runtime loops use the same resolver. Missing
canonical files fail immediately even if a stale former path exists. Other
SDK fixture locations and their existing accounting are unchanged.

These tests use complete private SDL native records alongside reviewed public
prefixes. Register them with the verifier's existing module-local private-unit
placement. Their bytes are copied unchanged into `SDL/tests` inside the staged
private stdlib boundary and compiled with that boundary's environment. Relative
`#load` paths still point to its real internal SDL module; private imports remain
legitimate. No public testing export, visibility bypass or old-source fallback.

The canonical layout test remains unchanged: official native C size/offset and
alignment comparisons, reviewed public RWops/UserEvent prefixes, complete private
record layouts, native payload fill/readback and before/after canaries. RWops and
window-manager runtime tests and both official-header C probes are unchanged.
All six source target configurations and existing runtime case selections remain.
No empty fixture, removed assertion, fake native result, layout skip, or substitute
SDK. SDL2 module and all SDL3/GPU declarations are untouched.

## Windows cross-host dependency request and concurrent integration correction

Actual independent jobs `117150498531` and `117150498681` fail during **Linux-host
native preparation**, with fatal SDL CMake inability to find X11 or Wayland.
The host also lacks ALSA/OpenGL development dependencies. Optional feature probe
lines are not the reported fatal cause. Compiler workflow setup does not carry
over to these independent cross-host jobs.

Exact request sent to integration: in `.github/workflows/windows-native.yml`,
jobs `cross` and `cross-arm64`, execute the shared dependency installer before
`windows_cross.py build --stdlib`:

```sh
bash tools/install_ci_native_linux.sh
```

The existing installer lists the full enabled Linux native dependency closure,
including `libx11-dev`, `libwayland-dev`, `libxkbcommon-dev`, `libasound2-dev`,
`libgl-dev`, `libegl-dev`, and other SDL input/audio/video backend dependencies.
It also supplies pkg-config/build tools. Reuse that coherent setup instead of
disabling window/audio/render/GPU backends or chasing nonfatal CMake probes.

During this task integration independently added that exact call to both setup
steps, after LLVM setup and before cross-build. Confirmed from committed clean
source object `2166710449bda1652d75da913fd20a024e737b3b`; workflow hash and full
installer package list are in the receipt. No competing workflow patch exported.
This is **source confirmation only**, not a successful rerun of either job.
Windows x64/ARM64 cross toolchains/CPU arguments and produced target identities
remain unchanged; Linux-host SDL does not substitute for a Windows target library.

## Actual checks and pending native evidence

Six focused Python 3.9 tests pass: canonical resolution for all three fixtures,
fatal missing canonical input despite stale old path, unchanged unmoved fixtures,
both runner lookup sites, existing meaningful layout assertions, and byte/hash
identity after legitimate module-local staging. The original shared verifier
first fails the staging regression because the relocated units are unregistered.
Test-only filesystem strings are labeled non-executable path fixtures; no such
placeholder is installed as a production ABI test.

Python compilation, fresh patch-application/hash verification and read-only
application check against clean shared source pass. `install_ci_native_linux.sh
--list` only was executed; **no apt installation, SDK build, compiler run, native
ABI/layout/RWops/SysWM program, GUI or fault execution**. No slot was assumed from
LSP lease release. The actual canonical SDL tests must still pass in source checks
and interpreter/native modes on their supported hosts, and both Windows cross
jobs need ordinary CI reruns. Do not call this runtime green from path tests.

All fresh scratch/captures/bytecode:
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/sdl3/target/sdl-fixtures-ac174`.
Source and receipts remain durable in this worktree. Previous 2d93e38e and
b9b841ad exports are unchanged and ready for integration. Issue 2 comprehensive
SDL3/95 GPU APIs and wheel issue 1 gates remain intact. No /Users/matthew/projects/jai-reference/quarantine/
transcripts, remote credentials/logs, GitHub comments, benchmarks, dispatches,
tags, publishing or release actions.
