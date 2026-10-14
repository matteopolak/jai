# Platform I/O deviations and pending verification

## Refreshed-contract changes (supersede corresponding historical items below)

- Windows Process record ambiguity is resolved by the refreshed reviewed spec.
  Public records and adapter are implemented. The temporary fixture module and
  private entry fixture were removed; validation now uses the public facade.
  Native System/Thread/Process/runtime execution remains outstanding. Real File
  Windows x64/ARM64 interpreter/O0/O2 passes are confirmed only for candidate159ca65.
- Pipe operations allocate a private record beginning with the native OVERLAPPED
  and retain its allocator. The public pointer addresses that actual native member;
  buffers are drained before return and state is released through its original
  allocator. No duplicate public handle state or guessed public fields remain.
- The reviewed crash contract explicitly limits Windows native backtraces to x64
  and ties their initialization to DEFINE_SYSTEM_ENTRY_POINT. Earlier private ARM64
  runtime-backtrace support has been removed from the compatibility path. The public
  x64 adapter, SDK ABI checks and configuration regressions are implemented. ARM64
  enabled-handler rejection is required behavior, not an exclusion to hide a failure.
- The private crash DLL/import library is a production dependency. The runner now
  builds/copies it before x64 fixtures, with compiler warnings denied; coordinator
  packaging and native execution are still required. Stack walking is bounded at
  64 real frames. DbgHelp serialization avoids unsafe concurrent use; when a fault
  interrupts symbol work, an explicit stack-unavailable diagnostic replaces a
  potentially deadlocking wait. Risk: incomplete crash traces during concurrent
  symbol activity. Proper long-term improvement: out-of-process crash reporting.
- The earlier private-root/target lint workaround is replaced by generic jailint
  support, strict incomplete-check failures and per-target checked-file manifests.
  All 41 owned Jai sources are covered without blanket rule suppression. Legitimate
  x64-only crash roots are linted on x64 and checked for rejection on ARM64. Rust
  tests needed the repository's original lint fixtures/docs copied alongside the
  locally staged compiler manifests; initial missing-fixture/dependency failures
  remain in durable logs. Independent numerics Math was staged for the existing
  rule suite. This is tool/dependency staging, not production integration.
- System's reviewed public M64 import depends on Machine_X64, absent from this
  snapshot and the allowed portable producer at review time. Windows counter behavior
  is real rdtsc on x64 and QPC on ARM64, but the public M64 dependency still needs
  portable-worker completion/integration. Do not invent a partial public module.
- The new Thread_Group regression initially assumed every Worker_Info address
  was cache-line aligned. The reviewed shape puts work_steal_indices after the
  padded info, so the record stride need not be a multiple of CACHE_LINE_SIZE.
  Corrected this unsupported test assumption to check the actual aligned allocation
  base; retained record layout, all completion/worker assertions and teardown.
  This is test-contract correction, not a production alignment repair or claimed
  reference guarantee. No public layout was altered for the test.
- Thread DEBUG configuration is still unresolved: program-local DEBUG is not
  visible in imported modules, and the reviewed module has no such parameter.
  Recorded the original check in questions rather than inventing an export or
  weakening isolation/assertions. Native DEBUG/race-detector support is not claimed.
- The public Windows exception callback is implemented in Jai and installed using
  the compiler's foreign callback machinery. Native executable lifetime is valid;
  interpreter callback/library lifetime through teardown has not been verified.
  Risk: a later OS exception could call a retired interpreter trampoline. Proper
  fix belongs in generic callback/runtime lifetime handling, with an original
  interpreter teardown/fault regression on real Windows. Do not replace the
  canonical public context with a disconnected shadow state to conceal this.

Role: platform-io. Scope: owned File, Windows System/Thread/runtime internals,
private encoding, original platform I/O fixtures and runner. Updated 2026-10-14.

1. **Native Windows execution unavailable on this macOS host.** Source checks for
   both CPUs and an x64 cross-linked executable are evidence of build support
   only. Runtime, filesystem and ABI behavior need the supplied runner on real
   Windows x64/arm64. Risk: native behavior may expose failures absent in checks.
   Proper fix: coordinator native CI execution, preserving any failure evidence.
2. **Local dependency/tool staging, not production integration.** This snapshot's
   compiler still expects module.jai and Basic exports a missing top-level Buffer.
   Tests use a locally source-built compiler from the permitted independent
   compiler producer and staged foundations/bindings sources. Initial compiler
   source staging hit an in-flight Option<Sym> error, then built after taking the
   corrected independent source. Risk: coordinator merge drift. Proper fix: merge
   those producers and rerun all checks on the actual integrated tree. No reference
   binary or implementation was used, and no fixture-only library was fabricated.
3. **Path length/namespace follows native Win32 policy.** The backend does not
   silently prefix every path with an extended namespace, which would change
   normalization and reserved-name behavior. Explicit extended paths work; normal
   paths may retain the OS MAX_PATH limit without long-path manifest/OS opt-in.
   Proper long-term fix: review required namespace semantics and application
   manifest policy, then test long local and UNC paths on native Windows.
4. **Known-folder and borrowed-wrapper ambiguities.** Reviewed declarations do
   not specify the folder identity behind `get_path_os_program_data`, canonical
   path prefix normalization, empty mapping behavior, or ownership of a string
   passed to `string_to_map_file_info`. Current choices are documented and sent to
   questions; they are not asserted as established compatibility behavior. Risk:
   behavior differs from a future clarified spec. Proper fix: reviewed contract
   clarification plus focused native tests, without reading old implementation.
5. **Remaining Windows Process/public crash ABI scope.** Public Process Windows
   aggregate shapes are absent from the reviewed spec. Windows crash CONTEXT is
   specified with x64 fields/size only; arm64 contract is missing. Public Windows
   Process and the public crash-handler facade remain incomplete. Core runtime
   ENABLE_BACKTRACE_ON_CRASH now selects a private SDK-based native backend, without
   interpreting the incomplete public context layout. Proper fix for public APIs:
   reviewed shapes, then public adapters and native validation. Existing Unix-only
   implementations are not counted as Windows support.
6. **Compiler interpreter suspended CRT-thread gap.** Windows Thread uses the
   actual CRT `_beginthreadex` with CREATE_SUSPENDED and ResumeThread, preserving
   CRT thread-local cleanup and the documented gated start. Own compiler source
   only schedules CreateThread, explicitly traps CREATE_SUSPENDED, and has no
   `_beginthreadex`/ResumeThread scheduler path. Original reproducer:
   tests/platform-io/pending/windows-crt-suspended-thread.jai. Native code builds;
   Windows interpreter behavior remains blocked until compiler owner adds generic
   suspended thread handles, resumption, and the CRT entry signature. Do not replace
   these calls with fabricated handles or run foreign callbacks unsafely.
7. **Inherited Thread DEBUG/race-detector limitations.** Existing module assertions
   reject DEBUG and DO_RACE_DETECTOR; they are retained, not suppressed. Windows
   release synchronization/lifetime is implemented; full debug tracking/order
   overloads remain unsupported and need a coherent portable implementation.
8. **Native SDK private declarations.** Missing reviewed Windows declarations for
   profile, SID/registry lookup, InitializeCriticalSectionEx, CRT `_beginthreadex`,
   command-line and low-level output operations are private ABI declarations from
   official Microsoft APIs. Fixed-width DWORD/BOOL/LSTATUS, pointer-sized handles
   and uintptr_t are used for x64/arm64. CPU records are size/bounds checked before
   variable group-mask iteration. Risk: ABI mistakes cannot be ruled out without
   native tests; long-term fix is SDK C layout probes plus native CI, and reuse of
   reviewed bindings when they contain these declarations.
9. **Runtime scope limits.** Core Windows entry/output/fatal Jai fault routines and
   optional native SEH exception diagnostics are implemented. The public crash-handler
   facade remains blocked by public ABI review. Existing CRT abort on fatal bounds/cast/assertion failures is
   retained; no fault assertions were weakened. Unicode command-line conversion
   rejects malformed UTF-16 explicitly at startup rather than replacing characters.
10. **Explicit private-process unit-test staging.** The compiler correctly rejects
    running internal library sources as application entry points. To check the new
    private Windows engine before public record review, `--private-process` creates
    a test-only `Platform_IO_Process_Test` module in this checkout's target stdlib,
    loads the library-owned test and removes the wrapper afterward. No production
    facade imports the engine yet. Source-check/cross-link results are private-engine
    evidence only, never public Process support or full integration. Risk: adapter
    semantics remain untested and native engine behavior awaits Windows execution.
    Proper fix: reviewed Windows public records, public adapters and unchanged public
    behavior tests, then remove the temporary test-module wrapper.
11. **Asynchronous pipe scheduling tradeoff.** Private engine `read_pair` starts
    overlapped reads for both streams, waits for readiness/timeout, and cancels/drains
    remaining operations before returning caller-owned buffers. This preserves buffer
    lifetime but creates cancellation overhead for repeated idle reads. It uses real
    kernel events and CancelIoEx, without polling or discarded outstanding work.
    Proper optimization: persistent owned read buffers/operations once public pipe
    ownership and layout are reviewed; measure before changing lifetime behavior.
12. **Incomplete semantic lint despite exit zero.** All owned Jai paths were passed
    to source-built jailint `-D warnings`, with no suppressions. A verbose audit
    subsequently exposed private System/Process roots rejected as application
    entries, and host-only target selection. Failed bodies were not linted. Thus
    these results are partial syntax/host semantic lint evidence, NOT the requested
    complete Windows/internal semantic gate. Location, exact command and general
    tool fix are in docs/platform-io-compiler-handoff.md. Proper fix: authorized
    library-module roots, target selection and a failure gate for incomplete requested
    bodies, then rerun native Windows and integrated lint. No file is excluded to
    turn this into a claimed pass.
13. **Windows exception diagnostics production dependency and bounds.** The new
    runtime-windows.c uses real SDK x64/arm64 CONTEXT/StackWalk64/DbgHelp APIs, caps
    diagnostics at 64 frames and 1023 symbol bytes, and emits actual addresses when
    symbols cannot be resolved. One fault reporter runs; concurrent/reentrant faults
    proceed to OS handling. SymInitialize failure is explicit. Native DLL/import
    libraries must be built by tools/build_platform_io_runtime.py and placed with
    each program; a local x64 DLL and enabled-startup executable cross-link, while
    arm64 C and SDK probes compile to objects. Native Windows runtime behavior is
    unverified. Proper fix: integrate source builds into normal native CI/package
    dependencies and run the fault fixture on each CPU. The public crash facade is
    not silently replaced with a different layout.
14. **Inherited Android asset gap, outside the Windows checkpoint.** The local
    File Unix backend still does not implement the reviewed Android tagged
    filesystem/packaged-asset record and asset-manager operations. No Android File
    completion or target verification is claimed. Proper fix requires the reviewed
    asset-manager acquisition/filename-selection contract and Android native binding
    integration; this work preserves existing Unix behavior while completing Windows.
15. **Temporary strict lint wrapper.** `tools/format_platform_io.py --lint` adds a
    failing exit status when verbose jailint says a requested root did not compile.
    All tool diagnostics are preserved and no rule is disabled. This parses existing
    diagnostic text because the tool has no structured incomplete-coverage failure
    option. Risk: wording changes require wrapper updates. Proper long-term fix is
    the generic linter driver/root/target repair and structured failure gate described
    in the compiler handoff. The current wrapper intentionally fails rather than
    count partial results as production lint success.
16. **Native OS version dependencies.** Windows Thread naming uses the documented
    SetThreadDescription API (Windows 10 version 1607+); private Process pipes use
    PIPE_REJECT_REMOTE_CLIENTS (Windows 8+). Modern Windows x64/arm64 is the current
    target. Older x64 OS availability is not established by the reviewed spec or
    native tests. Proper long-term fix: review the minimum supported Windows version
    and, if older versions are required, resolve optional naming dynamically and
    implement/test an appropriate named-pipe security/version policy. No fake
    successful naming or disabled native synchronization is used.

No lint suppression, disabled assertion, fake descriptor or module-name compiler
special case was introduced in the reviewed File scope. Native OS operation
failures are returned or logged; mapped resource cleanup can be retried on failure.
