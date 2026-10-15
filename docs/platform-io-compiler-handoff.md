# Platform I/O compiler/tool integration handoff

## General Windows async unwind metadata (implemented minimal patch)

The original exported named-fault fixture demonstrates an O2 ABI failure:
platform_io_fault_leaf pushes RBP, and platform_io_fault_middle allocates stack,
saves RBP and makes a call, yet neither had .pdata entries; O0 did. LLVM nounwind
inference must not suppress Windows SEH frame metadata. The small owned lib.rs
patch applies uwtable(async), enum value 2, to defined Windows ABI functions using
Arch classification. Public compiler options/defaults and Unix attributes stay
unchanged. Apply this minimal patch plus its original regression to the current
producer; the local staged producer is not a replacement source checkout.

The original unit fails before/passes after, all 19 LLVM library tests and scoped
clippy pass, and fresh x64 O2 PE unwind dumps now cover both real export addresses
with correct native unwind codes. Native named-fault fixture additionally calls
RtlLookupFunctionEntry for each frame function. Actual Windows quality/cleanup
execution remains required. See [evidence](platform-io-e8c312d-follow-up.md).

## e8c312d thread native-handle interoperability

The current independent producer's win32.rs::create_thread returns a synthetic
Object::Thread handle after obtaining the actual native_id. SetThreadDescription
is not intercepted, so it sees a scheduler value. Both CPUs' original named-thread
interpreter tests exit zero but fail output checking. Exact stdout/stderr/status
was requested; do not bless the warning as expected success.

Original minimal SDK reproducer:
docs/repros/platform-io-windows-thread-description.jai. It checks the public thread
HANDLE with native GetThreadDescription, Unicode data and checked LocalFree, then
retains start/wait/deinit assertions. It source-checks/lints on both Windows CPUs;
native/interpreter execution is pending. No public API or peer source was edited.

Required general compiler mechanism: retain/transfer the spawned OS thread handle,
use that actual handle as the scheduler object's key, maintain native id equality,
close it exactly once on CloseHandle or interpreter teardown, and keep scheduling,
suspended-start and managed-wait behavior. Real native query/description calls
must address the same OS thread. Do not special-case Thread module/name strings or
return fake SetThreadDescription success. Native suspension through unmanaged
duplicates has separate scheduling constraints and must be documented/diagnosed.

## Actual 0100a1f follow-up

The minimal argv repair is now verified by signed-wheel regressions on both real
Windows CPUs. ARM64's Platform step passes; the latest private ARM64 crash backend
was absent. x64's interpreter crash-contract line14 failure is an invalid assumption
that ordinary interpreted procedure IDs/heap globals are native PE code/data.
Own interpreter source and an original host reproducer establish that distinction.
No compiler pointer remapping or production predicate change is needed for this
failure. Updated original SDK/native-only fixtures preserve real ABI/section checks
and test actual repeated handler installation. The interpreter's vectored foreign
fault guard does not replace the top-level filter on each call. See
[section-query findings and next native commands](platform-io-section-query-regression.md).

## Current cc07c00 startup findings

See [the original startup reproducers](platform-io-startup-regressions.md). The
minimal patch to interp/executable_path.rs removes a deliberate NULL result from
CommandLineToArgvW and supplies virtual executable metadata only for omitted argv.
Shell32 remains responsible for parsing/ownership/errors; runtime strict Unicode
conversion and initialization are unchanged. Two tests fail before the patch and
all four executable-query tests pass afterward. Apply the local producer patch to
the current independent compiler, not the historical staged compiler as a whole.

Platform I/O execution passed on both Windows CPUs at cc07c00, while startup without `--`
wheel/renderer interpretation failed and ARM64 default backtraces blocked corpus.
The current independent producer already contains suspended CRT threads and real
event interoperation, so the older thread-gap section below is historical.

Default ARM64 crash selection still needs the narrow reviewed rule: the public
Build_Options defaults ON/AUTO and complete serialization make unchanged ON and
explicit ON identical. No guessed mask or changed default was implemented. Direct
unsupported Runtime_Support enablement must retain the x64-only diagnostic.

The coordinator decision in windows-arm64-backtrace-decision.md resolves default
ARM64 selection by authorizing a private SDK backend. ON/AUTO are unchanged; both
default and explicit ON select native ARM64 handling from Runtime_Support entry.
The public x64 callback facade still rejects ARM64. No compiler provenance or
target mask was introduced. Native Windows 11/Server 2022 ARM64 execution of the
RtlVirtualUnwind2 backend is required; source checks are positive, not runtime proof.

The worker now includes a small general IDE dependency-order fix and generic
jailint driver/rule fixes. Compiler-owned integration is required; no module/path
or symbol-name special cases were introduced. Remaining gaps below must retain
their real failures.

## Implemented strict lint and IDE repairs

`crates/jaic/tests/ide_layout.rs` is a standalone original reproducer with no stdlib
dependency. It loads a record, resolves its type before requesting its layout, then
asks IDE checking to validate unused declarations. Previously INFO_SIZE recursively
requested itself through the padding layout; the fix lays out the containing record
before resolving member constants, matching ordinary unreferenced checking. A
temporary removal of only the new ordering step reproduced the circular-dependency
failure; the fixed test passes. The real Thread lint failure also disappears.

Jailint now accepts OS/CPU targets, recognizes nested import-directory modules,
imports private library roots from virtual library-owned sources, reuses already
configured bootstrap instances, records loaded files across directories, writes a
checked-file manifest, and returns failure for incomplete compiler/IDE checking.
The virtual root does not relax application privacy or write into the library.
Canonical exported aliases are recognized by library-call rules using procedure
identity, avoiding implementation-path assumptions. Original regressions in
`tools/test_platform_io_lint.py` exercise target findings, privacy and failed bodies.
Additional program source is supported through --add, with a missing-definition
regression. This allows the startup test metaprogram to use its real build flags
during linting instead of a modified source or fabricated fallback definition.

Executed with the permitted independent producer compiler plus these local patches:
all 23 jailint Rust tests, standalone IDE regression, scoped clippy with warnings
denied, and four-target strict lint with manifest coverage of every owned source.
The commands and staging limits are in the platform progress/deviations reports.

The native CI runner now accumulates independent failures and still exits nonzero.
Thus a suspended-thread interpreter failure must remain visible, while native
O0/O2 Thread/Process/runtime fixtures still execute and report their own evidence.
The original failure-injection audit retained three actual assertion failures
(interpreter/O0/O2), continued through Thread_Group, and failed overall. The source
was restored and the complete positive run passed afterward.

## Missing portable System dependency

The reviewed System facade exports M64 on x64. Machine_X64 is absent from this
snapshot and the new portable producer at inspection time. Windows counter reads
now implement the reviewed rdtsc/QPC precedence, but the public import alias needs
that producer module before integration. Do not supply a fake partial module or
claim System's entire public inventory complete without it. Unix counter facade
coverage likewise belongs to the portable integration review.

## Historical suspended CRT-thread gap (superseded by cc07c00 follow-up)

Original reproducer: `tests/platform-io/pending/windows-crt-suspended-thread.jai`.
Run `jaic -interp` on native Windows after integrating the independent stdlib.
The required behavior is an actual gated thread, an initial timeout, ResumeThread
returning the previous suspend count, then completion and handle cleanup.

The earlier compiler producer's `interp/threads/win32.rs` intercepted CreateThread
but explicitly traps CREATE_SUSPENDED. It does not schedule `_beginthreadex` or
ResumeThread. Windows Thread now uses the documented CRT lifecycle so that CRT
thread-local resources are reclaimed. Required general fix: model suspended thread
state, suspend counts and resumption in the scheduler, recognize the CRT entry ABI,
and preserve thread-handle completion/closure behavior. Test the original reproducer
on both CPUs. Do not invoke an unscheduled interpreted callback from a foreign OS
thread or replace native handles in library code.

For private Process interpreter integration, also review native OVERLAPPED I/O
interoperation with interpreter-created event handles. A scheduler-only event cannot
be passed as hEvent to the actual native ReadFile/WriteFile APIs. The worker claims
no Windows Process interpreter validation.

## Historical linter failure evidence (superseded by repairs above)

Executed evidence:

```
JAIC_STDLIB="$PWD/target/platform-io-stdlib" target/debug/jailint -v -D warnings \
  stdlib/internal/files/native-windows.jai \
  stdlib/internal/system/windows.jai \
  stdlib/internal/platform-io/windows-process.jai \
  stdlib/internal/runtime/windows-crash.jai
```

The command exits zero but verbose output reports that the private System and
Process sources did not compile because standard-library internals are private,
and failed bodies were not linted. Ordinary lint uses CompilerOptions::host(),
so macOS checking does not establish semantic lint coverage of Windows branches.
No suppression or privacy-policy relaxation was introduced to conceal this.

Required general tool fix: recognize library module roots, compile them through
an authorized library-owned module context while preserving application import
privacy, and add explicit target OS/CPU options. For example, a virtual library-owned
wrapper in the compiler FileSystem can import the requested internal module; it
must not change application import visibility or require source-tree mutation.
Report incomplete requested-body coverage as a failing lint result rather than
quiet success. Add a small temporary standard-library fixture with a private module
and a known lint finding; verify that the finding is caught while an application
still cannot import it. Test OS-conditional findings for Windows x64/arm64.

After integration rerun the worker's complete owned scope from the progress report,
with Windows target selection or on native Windows as appropriate. The current
host exit-zero lint command is partial evidence, not the requested full semantic
Windows/internal lint gate.

The worker's `tools/format_platform_io.py --lint` runs the same source-built tool
with verbose diagnostics and fails when it reports incomplete compilation. This
temporary stricter gate preserves the original output; it does not repair missing
coverage or suppress findings. Replace the diagnostic-text check with a structured
jailint failure option when the generic driver fix is available.
