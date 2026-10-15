# Portable stdlib progress

Platform-io Windows Thread SDK effects/result checks are independent of optional
assertions; failed close/resume retains ownership. Public caller-disabled lifecycle
and protected real-thread-handle failure/retry tests are scheduled in the native
runner. Local host suite, cross checks/builds, formatter and 51-file strict lint
pass. Windows execution and internal Basic(false) configuration audit are pending;
Unix/generic operations remain portable-owner work. See platform progress.

Platform-io e223538 review: six O0 mismatches were genuine Jai guard interception,
two O2 mismatches stale export-alias symbol expectations. Added independent C
PAGE_NOACCESS fault helper and separate retained O0 guard cases without changing
production guards. Six parser tests and 50-file format/strict four-target lint
pass; new native SEH matrix still awaits both-CPU CI. See platform progress.

Platform-io checkpoints: 2cdbd9b cleanup/diagnostic gates; 7eb81e8 generic Windows
unwind metadata and bounded iterator. Separate Windows wait-error safety mapping
and exact SDK-negative logging assertions are added; new native confirmation and
the interpreter real-thread-handle/compiler handoff remain pending.

Platform-io continuation after 2cdbd9b: implemented generic Windows async unwind
metadata after an original O2 fixture exposed missing required .pdata entries;
19 LLVM unit tests/clippy and fresh PE metadata checks pass. Corrected bounded
x64 frame iteration with initial-repeat/skip/recursion/cycle unit coverage.
Actual x64 fault/thread output request and native verification remain pending;
earlier ARM64 12-case native positives stay intact. See platform progress/deviations.

Platform-io e8c312d: private ARM64 native startup/fault OFF/ON/default O0/O2 now
passes all 12 cases. x64 four enabled faults and interpreter thread output on both
CPUs remain open, with exact own-output request pending. Added private x64 session
isolation/runtime cleanup, original SDK walk/lifecycle probes, named-frame quality
tests and exact result capture. Local host/cross checks and strict 49-file lint
pass; new native behavior is not claimed verified. See
[current follow-up](../platform-io-e8c312d-follow-up.md).

Platform-io 0100a1f follow-up: actual signed-wheel/argv tests pass on both Windows
CPUs; ARM64 Platform passes. x64's interpreter PE assertion wrongly treated tagged
procedure IDs/heap globals as native image sections. Shared tests now use real SDK
probes, preserve native compiled-symbol O0/O2 assertions separately, and check
actual repeated handler installation. Host/cross checks and strict 46-file lint
pass; new fixtures/private ARM64 backend still need native CI with --windows-crash.
See [section-query evidence](../platform-io-section-query-regression.md).

Platform-io cc07c00 update: actual Windows x64/ARM64 Platform interpreter/native
O0/O2 steps passed; full jobs failed. The startup failure without `--` is isolated
and fixed in the compiler executable-query adapter, with independent red/green
regressions and strict SDK/native-CI hooks. Coordinator direction now authorizes
a private ARM64 native exception backend, implemented with unchanged ON/AUTO
defaults; public x64 callback diagnostics remain. Strict lint covers 45 owned Jai
files. New backend/native argv execution still requires coordinator Windows CI.
See [startup findings](../platform-io-startup-regressions.md).

Platform-io role continuation: public Windows Process records/adapter landed in
`700f07e`; reviewed x64 crash facade (`2b1d623`) and generic strict-lint/IDE repairs (`27b719c`) are now
implemented. Four-target strict lint covers all 42 owned sources; host interpreter/
O0/O2 and Windows source/cross-link checks pass. Later Windows native CI remains
required. See [platform progress](platform-io-progress.md) for exact commands and
[deviations](platform-io-deviations.md) for limitations and dependency staging.

Role: independent portable/high-level stdlib worker. No subagents, publication,
reference binaries or prior implementations used. Extensions and corpus preserved.

Latest committed checkpoint: `04205ed`, stable Treemap hierarchy/layout. Earlier
checkpoints cover foundations, Unix process/thread/files/system, codecs,
allocators, Soa, Xar, command/text parsing and reviewed protocol schemas; consult
[module ledger](../portable-stdlib-ledger.md) for exact partial/remaining scope.

Previously verified checkpoint: POSIX native crash diagnostics and runtime startup
flag integration. Native C builds with `-Wall -Wextra -Werror`. Actual protected
memory faults and raised SIGSEGV terminate with preserved signals and a native
stack in interpreter/native execution. Four worker threads independently initialize
and clean up stacks. Build_Options ON/OFF workspace tests pass native execution.
All 175 owned Jai files pass repo jaifmt --check and jailint -D warnings. The
expanded regression passes 58 interpreter/native cases, ten SMTP scenarios,
four parent-lifetime scenarios, four expected faults in both execution modes,
Xar reverse rejection, startup ON/OFF and selected Linux/Windows target checks.

Previously verified checkpoint: classic Zip_File_Directory parsing and ownership,
including malformed second-record cleanup under a counting allocator. The full
focused run now passes 59 interpreter/native cases and six expected faults in
both modes, retaining the SMTP, parent-lifetime, startup and target checks above.
All 181 owned Jai files pass jaifmt --check and jailint -D warnings. The ZIP field
and extension contract gaps are documented, not asserted as established behavior.

Previously verified checkpoint: CAS-based Atomics arithmetic/bitwise operations and
the exact alias declarations. The three alias intrinsics lack source-compiler
lowering; the original pending reproducer and handoff are documented. Full focused
regression passes 61 interpreter/native cases, seven expected faults in both
modes, two compile-time rejections, all prior SMTP/startup/parent checks and selected
Linux/Windows checks. All 188 owned Jai files pass format/lint. Four-worker tests
verify prior-value uniqueness, bit claims and zero-reaching decrement behavior.

Previously verified checkpoint: partial Deep_Copy scalar/string/resizable-array
operations, callback/preallocated/reused-map cases and conditional debug globals.
General graph support is blocked by reflected struct alignment 0 (versus 8),
reproduced in interpreter/native with retained assertions. It is not counted as
completed graph functionality. Full focused regression passes 63 cases in both
modes, nine expected faults in both modes, two compile-time rejections and prior
SMTP/startup/parent/target checks. All 197 owned Jai files pass format/lint.

Previously verified checkpoint: Unix BuildCpp C/C++ compile/link/archive/object and
macOS universal outputs. Native executable and dynamically loaded function return
the expected results; stale archive members disappear on rebuild; missing tool,
invalid C and wrong-target objects report real errors after cleanup. Full focused
regression passes 64 interpreter/native cases, nine runtime faults in both modes,
five compile-time rejections, and prior SMTP/startup/parent/target checks. All
203 owned Jai files pass format/lint. The runner requires zero C-helper intermediate
directories and preserves previous output after failed compilation.

Previously verified checkpoint: Treemap stable nodes, weights/sort, hierarchy,
callback borders, cached squarified geometry and shared-boundary growth fix.
Full regression passes 65 interpreter/native cases, ten runtime faults in both
modes, five compile-time rejections and prior integration checks. All 209 owned
Jai files pass format/lint; delegated Math is copied only into the integration
root. Meow is blocked by the canonical register macro compiler reproducer;
no replacement public type/hash routine was invented.

Current verified checkpoint: Unix Shared_Memory_Channel SPSC transport, ownership,
real wrap/full/corruption/max-packet behavior and captured allocator cleanup.
Full regression passes 66 interpreter/native cases, ten runtime faults in both
modes, five compile-time rejections, four interprocess pairings with 2,048 packets
each, and prior SMTP/startup/parent/target checks. All 215 owned Jai files pass
format/lint; Linux x64/arm64 channel code is separately compile-checked. Wire
details and Windows/Linux-execution gaps remain explicit. Two early failed runs
left unjournaled PID-named objects; no global deletion was attempted. Subsequent
tests journal and check cleanup of only their recorded resources.

Known workarounds and incomplete behavior are recorded in
[deviations](stdlib-deviations.md), [gaps](../portable-stdlib-gaps.md) and the
module ledger. Next: finish regression/checkpoint, then continue remaining owned
portable modules using reviewed specifications. Full corpus/release integration
remains the coordinator's responsibility.
