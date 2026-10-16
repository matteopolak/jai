# Platform I/O deviations and pending verification

## Windows Thread optional assertion audit

All owned Windows essential SDK calls and their result checks now execute
independently of optional assertions. Returning custom failure handlers preserve
thread/semaphore ownership on failed close; group creation/clock failure reports
and terminates because those APIs cannot return a valid result. Partial group
recovery is not implemented or claimed; default termination reclaims resources.
Unix/generic optional-assert dependencies remain portable-owner scope.

New caller-Basic(false) public lifecycle/SDK-negative fixture is in the real
runner, not a staged substitute. It requires actual completed Thread handle
interop via SetHandleInformation, error/count/state/storage retention, protection
removal and successful deinit retry. Native/interpreter Windows execution is
pending. The current first-list Basic instance rules do not propagate the caller
flag into Thread's Basic dependency; internal-disabled coverage remains explicitly
incomplete pending reviewed configuration audit. No extra public parameter,
fake handle, hidden root-constant leak or blanket lint/test exclusion is used.
See [Thread review](../platform-io-windows-thread-assertions.md).

## e223538 test corrections, not production fixes

The former address-1 Jai hardware-fault assumption is invalid at O0 because the
new compiler guard correctly exits before SEH. The store remains in a separate
O0 safety test, not disabled. O2 guard emission is not claimed. Hardware-fault
tests now require a real source-built SDK DLL with PAGE_NOACCESS storage; all
allocation/return errors fail the test. OS crash teardown reclaims its one-page
allocation; separate lifecycle probes retain handler/symbol/handle cleanup gates.
Exact declared frame names replace stale export-alias expectations; neither
production symbol fabrication nor diagnostic relaxation is used. DLL loading,
actual exception, unwind and cleanup on this new matrix require next native CI
on both CPUs. Local formatter/strict lint and protocol tests are not substitutes.
Details: [fault-oracle review](../platform-io-e223538-fault-oracles.md).

Windows thread completion no longer treats WAIT_FAILED as success. The added
real SDK negative case captures only its expected error, asserts exact message/
flag/count, and restores the logger/data before named-thread creation. This is
targeted negative-path verification, not a warning whitelist or output weakening.
The Windows-specific branch is source/cross checked and still needs native CI;
the separate interpreter real-handle/name failure remains open.

## General Windows unwind-table and iteration fixes

- Owned compiler patch: jaic-llvm::apply_codegen_attributes requests async unwind
  tables for defined Windows ABI functions, even if nounwind is inferred. An
  original O2 exported nonleaf/stack-using fixture lacked table entries before
  the fix; fresh cross-built machine code has matching native unwind records.
  The regression fails before/passes after, with all 19 LLVM unit tests and
  strict clippy passing. This is required native ABI metadata, not an optional
  library-backtrace flag or a source/symbol special case. Risk/cost: extra Windows
  unwind metadata, unbenchmarked binary-size effect; retain ABI correctness and
  let LLVM select compact native encodings. Unix behavior is unchanged.
- The x64 iterator tolerates only an initial repeated SDK frame, then detects
  repeated PC/SP pairs across the walk. It uses a 64-pair stack array (about 1KiB)
  and bounded quadratic comparison (at most 2016 history comparisons plus the
  initial-frame check) to avoid looping or
  counting duplicate frames. This overhead is small relative to SDK/symbol calls
  but unbenchmarked, and increases crash-stack demand. Destroyed/overflowed stacks
  remain best effort; proper isolation is out-of-process reporting. No frame or
  symbol is synthesized. Limit/cycle diagnostics are explicit.
- Portable scripted-transition tests and parser tests are control/protocol unit
  evidence only. Native SDK probes, named application frames, actual fault status
  and cleanup must execute in the next Windows candidate. The first SDK result
  may be initial or caller; the probe reports actual behavior and accepts both,
  while requiring real resolved symbols and caller transitions. The original
  e8c312d exact failed output remains unavailable/requested; no current native
  x64-success or interpreter-thread fix is inferred from these local passes.

## e8c312d native follow-up (supersedes older verification statements)

- Actual private ARM64 native OFF/ON/default startup/fault O0/O2 positives now exist
  (12 cases, run38662728329). They do not establish the newly added named-symbol
  tests or later x64 cleanup behavior. x64 four enabled fault cases and both CPUs'
  interpreter thread output remain genuine open failures; exact own-output request
  is pending. No raw/vendor logs were read or native positives discarded.
- x64 had no private normal-runtime shutdown and keyed DbgHelp with the public
  pseudo-handle. The backend now keeps public identity unchanged and duplicates
  it for a unique native session; private entry cleanup restores filter/mode and
  checks SymCleanup/CloseHandle. Failed setup closes partial ownership, and failures
  remain explicit. External DbgHelp calls must still be serialized with this
  backend by the application: our lock covers our own calls, not unknown modules.
  Process-global filter/mode replacement has the same native API race/coordination
  limit as ARM64. Proper long-term crash isolation is an out-of-process reporter.
- New native SDK session-isolation/cleanup test and StackWalk first-step probe
  require execution on x64. Cross-linking proves neither unwind quality nor native
  cleanup. The added named-fault fixture uses genuine exported non-inlined functions
  and post-call work to retain both frames. Original windows-fault remains intact.
  ON checks require both named frames; no symbol names or addresses are fabricated.
- Diagnostic parser tests use explicit synthetic protocol bytes to check rejection
  of wrong status/output/truncated traces/missing symbols/failure notices. These
  are unit tests only, not successful native faults. The runner writes only own
  fixture results (raw bytes and JSON, no environment/auth/vendor logs) for precise
  coordinator filtering. Existing strict output comparison remains.
- Source evidence identifies virtual interpreter thread handles passed into a real
  SetThreadDescription call. Naming success is not stubbed, logging is not muted,
  and SET_THREAD_NAMES remains true. A minimal original SDK reproducer is retained
  in docs/repros with format/lint/source checking. Native/interpreter execution is
  pending; it is not a positive fixture claiming the compiler gap fixed. Proper
  fix is general real kernel backing, native thread identity and exactly-once handle
  closure while retaining scheduler gates/waits. No peer checkout was modified.
- Thread naming follows SDK APIs with Windows 10 version 1607 minimum (that first
  release requires KernelBase dynamic linking). Current direct Kernel32 bindings
  target modern CI Windows; no older-version guarantee is claimed. ARM64 crash
  RtlVirtualUnwind2 API minimum remains Windows 11/Server 2022, requiring the actual
  export on native ARM64 Windows; this is not an ARM64 Server SKU claim.

## 0100a1f CI / corrected execution-mode fixture assumption

- Actual evidence: signed-wheel/argv startup passes on both CPUs; ARM64 Platform
  step passes. x64 Platform step is red only for the interpreter PE assertion.
  The private ARM64 backend was not in that candidate. New SDK/native-only test
  execution and ARM64 backtraces remain pending; full matrix is not green.
- Location: tests/platform-io/crash-contract.jai previously asserted interpreted
  main and windows_context were PE code/data. Own interpreter source and an
  original host reproducer establish tagged procedure IDs and heap global storage.
  Corrected that unsupported mode assumption; kept all native assertions in
  windows-crash-native-sections.jai, run at O0/O2 by the runner. No production
  predicate alteration, false memory permissions or compiler fixture special case.
- New test dependency: windows-section-sdk.c builds a separate original SDK oracle
  DLL/import library under durable target/platform-io-tests. It supplies actual
  main-image probes and VirtualQuery/ImageNtHeader/ImageRvaToSection results for
  the shared test. It is never production stdlib code or a substitute backend.
  DLL build/load/SDK query failures fail tests. File-backed probes use the RVA API;
  interpreted/native BSS/global mapping uses actual OS allocation/protection.
  Risk: test tooling must build/package the additional oracle; the runner handles
  it and removes prior oracle artifacts before a build. Native execution remains
  required. Proper integration is the unchanged production backend plus this
  source-built fixture, not staged production source repair.
- Init/filter identity assertions are stronger than the former flag-only checks.
  Fixture cleanup restores the prior top-level filter before interpreter callback
  lifetime ends. The interpreter's independent vectored foreign-fault guard stays
  intact. Public x64 symbol state remains process-scoped with no reviewed public
  shutdown function; this test does not claim x64 SymCleanup/reinit support.
- OS minimum/capability: the new ARM64 backend requires RtlVirtualUnwind2, documented
  for Windows 11/Server 2022. That is an API minimum, not an ARM64 Server SKU claim
  or native verification on every Windows build. Missing export fails explicitly.
  Native ARM64 runtime diagnostics keep their private SDK context; public x64-shaped
  callbacks still reject ARM64. No new older-OS guarantee is made for x64/toolchain.
  Explicit matching --windows-build x64/arm64 in the next native commands avoids
  choosing a DLL from an emulated scripting host's architecture. ON/OFF/default
  fault/trace checks and ARM64 lifecycle/cleanup tests are retained.

## Private ARM64 runtime backend (supersedes older ARM64 policy statements)

- Coordinator decision windows-arm64-backtrace-decision.md authorizes this
  independent portability improvement. Runtime_Support startup uses private
  SDK CONTEXT and native unwind metadata on ARM64. Public ON/AUTO defaults and
  x64 record layouts remain unchanged; explicitly importing the public x64
  callback facade on ARM64 still diagnoses. No default/explicit provenance,
  unsafe context reinterpretation or disabled handler was invented.
- Location: internal/runtime/crash-native/runtime-windows-arm64.c and the private
  windows-arm64-crash adapter. RtlVirtualUnwind2 requires Windows 11/Server 2022.
  Missing API returns ERROR_PROC_NOT_FOUND and startup asserts; older Windows
  ARM64 backtraces are not supported by this backend. Rationale: documented
  error-returning bounded native unwind including leaf frames/PAC stripping.
  Risk: older OS deployments fail enabled startup. Proper extension: implement
  and natively validate an older-OS native unwind path with equivalent safety;
  do not silently disable ON or fabricate a trace.
- Real traces are capped at 64 frames. DbgHelp is serialized and a fault uses
  try-lock; interruption during symbol work reports stack unavailable. There is
  no alternate signal stack or out-of-process reporter, so a destroyed stack or
  recursive fault may prevent diagnostics. Proper improvement: out-of-process
  crash reporting. Original fault context and native exit status are preserved.
  An unrecoverable stderr WriteFile failure exits with ERROR_WRITE_FAULT because
  diagnostics cannot be delivered; it does not claim a successful crash report.
  SymInitialize enumerates loaded modules at every enabled process startup;
  startup cost is unbenchmarked. Proper performance work must retain real module
  registration/trace behavior rather than silently disabling diagnostics.
- The private lifecycle duplicates the process handle for a unique symbol session,
  reference-counts init/fini, SymCleanup/CloseHandle on final shutdown, and restores
  prior error mode/filter. Windows offers no atomic filter compare/exchange;
  concurrent external SetUnhandledExceptionFilter or SetErrorMode changes must
  be serialized by the application. A later filter is preserved on shutdown;
  an error-mode change during our lifetime may be overwritten by restoration.
  Proper extension: document/coordinate process-global policy with other owners.
- This backend adds a real architecture-specific crash DLL/import library to
  production packaging. The local host has no ARM64 Windows linker/runtime;
  warnings-denied ARM64 COFF object builds and source/lint checks do not establish
  native behavior. The native runner builds the real SDK DLL on each CPU and
  executes untouched defaults, ON/OFF startup/faults and ARM64 lifecycle tests.
  New argv/ARM64 backend execution remains required in coordinator native CI.
- The original default-options reproducer is promoted back into positive fixtures
  after its red x64-only diagnostic and green ARM64 source check. The expanded
  source matrix initially failed because the runner treated the CLI's intentional
  unwritten-child-executable warning as an error. It now requires that exact
  warning and zero exit/stdout for these checks; all other diagnostics fail.
  No global warning suppression or compiler diagnostic change. Original failure
  evidence: target/platform-io-arm64-source-warning-red.log. This is source-only
  testing; native child execution requires a successful actual build.

## cc07c00 follow-up (supersedes older verification/gap statements below)

- Filtered CI confirms actual x64/ARM64 Platform I/O interpreter/native O0/O2 step
  passes at cc07c00. Full jobs still fail; new argv/strict-SDK regression behavior
  is not yet natively verified. No blanket native-support claim is made from a
  cross-build or this passing subset.
- Removed an avoidable compiler workaround: its CommandLineToArgvW interception
  fabricated NULL for omitted argv. This broke strict production startup. The
  adapter now supplies the virtual executable name when no vector was supplied
  and delegates parsing/allocation/errors to Shell32. Explicit caller vectors are
  preserved. Runtime WC_ERR_INVALID_CHARS, failure checks, cleanup and context
  initialization remain unchanged. No new conversion fallback is introduced.
- The previous interpreter suspended-thread/event gap is no longer present in the
  current independent compiler producer: it has _beginthreadex/ResumeThread and
  real event backing. cc07c00's Platform step is positive execution evidence, but
  no separate pending fixture result is inferred from the filtered step summary.
  Locally staged producer sources remain independent integration inputs; the next
  candidate must include the minimal argv patch in the current producer compiler.
- ARM64 default crash policy remains unresolved and is a real failure, not a
  supported platform exclusion. Public Build_Options defaults ON/AUTO are retained;
  the current serializer has no default-versus-explicit provenance. An original
  default-option example reproduces the error and is retained in documentation
  and durable logs. Moving that pending example out of the positive .jai fixture
  inventory does not remove any corpus test or bless its failure: the full-matrix
  blocker stays open pending narrow review, then a proper policy regression/fix.

- ARM64 policy review is now resolved by the coordinator decision above; the
  original default-options reproducer has returned to the positive fixture set.
  Its initial failure is retained. Public Build_Options defaults stay ON/AUTO.
- The no-argument SDK hook is host-independent Rust tested; native UTF-16 parser,
  strict conversion and cleanup must still be exercised on both Windows CPUs.
  The SDK-negative fixture uses real API failures (unpaired surrogates and short
  buffers), not emulated success or reduced checking. Existing Windows command-line
  cache/allocation lifetime policy is unchanged by this fix.

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
  All 42 owned Jai sources are covered without blanket rule suppression. Legitimate
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
- ARM64 Windows native cross-linking is not available on this host: the real
  linker search reports no aarch64 MinGW toolchain. ARM64 startup OFF and required
  ON rejection are source-checked at both optimization settings, not counted as
  executable builds. Proper fix: coordinator native ARM64 jobs or an installed
  independent native cross toolchain; never substitute an x64 artifact.
- Startup lint uses --add with the actual output/source/optimization/backtrace
  configuration required by the original metaprogram. The linter implements this
  through ordinary ProgramSource strings, preserving module isolation. This is
  explicit build context, not a changed staged test body. No fallback definition
  or skipped assertion was added. A real no-DCE check exposed missing staged
  Program_Print/Code_Visit dependencies; producer sources were copied locally.
- Native fault fixtures set SEM_NOGPFAULTERRORBOX through the real OS API so CI
  cannot hang on an interactive error box. Access violation, stderr diagnostics,
  and native status remain asserted. No fault/safety check is disabled.
- Runner failure aggregation was tested by temporarily inserting an explicit
  false assertion in the owned runtime fixture. All three execution modes failed;
  later independent tests still executed and overall status failed. The source was
  restored and the final positive suite rerun. Evidence and durable source backup
  remain under target/platform-io-runner-negative.log and
  target/platform-io-runtime-contract-backup.jai. This verifies the runner only,
  not any additional Windows functionality.
- `internal/platform-io/windows-process.jai` previously clamped positive 64-bit
  timeouts to the maximum finite DWORD value, shortening very long waits. Removed
  that reduction: a reusable bounded loop repeats real native waits and spends the
  remaining budget only after actual WAIT_TIMEOUT results. This adds one native
  call per exhausted chunk, without wall-clock reinterpretation or fake completion.
  The initial unbounded-loop prototype generated a genuine compiler warning and
  failed the runner; the bounded budget algorithm passes without suppressing it.
  Source/cross-build and large-value quick-exit coverage exist; 49-day-plus elapsed
  exhaustion and Windows runtime behavior have not been executed locally. Proper
  remaining validation is native Windows CI and review of the budget arithmetic.
- API-created Process pipes own a private allocation whose first member is the
  public native OVERLAPPED. Module operations recover its pending/original-allocator
  fields from that managed pointer. This preserves native pointer/storage identity
  and copying, but assumes the pointer came from the module constructor; replacing
  it with an independently allocated SDK-only record is not established supported
  behavior and could read beyond that foreign record. Recorded the ownership
  question explicitly. If reviewed interoperability requires foreign allocations,
  the proper fix is separate private ownership tracking and a defined borrowed-state
  policy, with native regressions; do not silently accept an incompatible record.

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


## Remaining target accounting limits (2026-10-16)
No runtime fallback, fake provider or production change in the accounting/path-oracle batch. Dedicated runner machine-readable rows currently describe requested WASM modes only; native checks keep their existing required/fatal behavior and console reporting. External compiler-build-root/output-dir options preserve checkout defaults and explicitly isolate own source-built tools/captures. Unknown dedicated WASM cases fail review selection. Original File WASI hard-link assertion remains required and RED on own T7: independent host os.link also returns errno45. No alternate filesystem or link-copy substitute; CI must supply genuine hard-link-capable storage. Public FileUtilities.visit_files WASM availability is unresolved, with exact tour dependency/reproducer recorded; no invented exports. Actual changed Windows/Linux native behavior remains pending, separate from positive Mac/WASI fixture execution and prior Windows native evidence. See [details](../native/platform-io-target-accounting.md).
