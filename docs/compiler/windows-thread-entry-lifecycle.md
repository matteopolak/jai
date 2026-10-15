# Native interpreter thread entry and ownership

The previous Windows scheduler kept the Jai result in GThread but spawned a Rust
closure returning unit. Native queries through a duplicated handle could therefore
observe the OS thread return rather than the Jai result. Windows managed workers
now start through a private CRT _beginthreadex entry with the system callback ABI.
The entry returns the actual u32 Jai result, including explicit ExitThread and
_endthreadex results, after Rust scopes and CRT cleanup unwind normally. No direct
ExitThread call skips Rust destructors. Public handles identify the real kernel
object; ordinary native duplicate queries/waits see its actual result/lifetime.

The private CRT entry contract follows the official
[_beginthreadex documentation](https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/beginthread-beginthreadex).
Its context has one owned Box and Arc. Creation failure frees them; successful
entry consumes them. CRT DOS errors are captured before cleanup and propagated,
using [_get_doserrno](https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/get-doserrno).
An unclassified CRT failure diagnoses rather than inventing an OS success/error.
The OS supplies the thread ID; _beginthreadex/normal return retain CRT cleanup.

One private join handle remains independent of public handle ownership. Closing
the public original or any native duplicate does not invalidate that private join.
Managed Windows waits now require actual OS termination, including final CRT/TLS
cleanup, rather than only the earlier Jai completion bit. Only that final interval
needs a 1ms poll; the ordinary Jai completion notification still wakes waiters.
Managed GetExitCodeThread invokes the real kernel API and preserves its actual
BOOL/result/error. Native aliases continue through the native API. The SDK defines
termination status and signaling at this boundary:
[GetExitCodeThread](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getexitcodethread),
[CreateThread lifecycle](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-createthread).

Unregistered aliases still cannot suspend/resume the managed scheduler gate.
Their identity is now checked using
[CompareObjectHandles](https://learn.microsoft.com/en-us/windows/win32/api/handleapi/nf-handleapi-compareobjecthandles),
which does not require query rights. A suspend-only alias must not evade the
existing explicit unsupported-operation diagnostic merely because GetThreadId
requires query access. No native suspend is performed as an access probe.

## Teardown and compiler ownership

Previously Shared::wait_turn parked workers forever after the interpreter died.
Shared::close now marks shutdown, wakes waiters, joins managed OS entries outside
the scheduler mutex, waits for adopted callback leases to finish, then releases
remaining public owned handles. Suspended and sleeping workers exit through a
private typed Rust unwind signal; a worker returning from finite native code does
the same before reacquiring/interpreting any state. Cancelled entries return
ERROR_CANCELLED (1223), explicitly a teardown failure rather than a successful
Jai result. OS/CRT entry and callback boundaries catch this private signal; it
never unwinds through C. Unexpected Rust panics remain errors and do not resume
normal execution. Failed callback acquisition releases its adopted lease too.

Compiler now declares interp first so its destructor joins workers before any
program/source/type fields are freed. This is a field-lifetime change only in
sema/mod.rs; no reporting-hook or LSP recovery/cache implementation was changed.
interp/mod.rs is untouched. The native compiler build requires Rust panic=unwind
for this private cancellation mechanism; panic=abort now has an explicit build
diagnostic. The wasm32 compiler uses its existing inline scheduler and has no
such native cancellation dependency.

There is no public cancellation API or new module parameter. All normal native
compiled Jai thread calls retain their original SDK path. Unsupported nondefault
interpreter security attributes/custom stack sizes and unsupported creation flags
now diagnose instead of silently becoming defaults. The existing private stack
reserve and supported zero/default arguments remain unchanged.

## Original regressions and executed evidence

- windows-worker-lifetime-red.log retains both original failures: suspended and
  sleeping workers kept scheduler Arcs after compiler teardown. Five final host
  cases pass: those two cases, finite real native poll return, waiting adopted
  callback lease release, and compiler-owned state lifetime through interpreter
  destruction. windows-worker-owner-order-red-final.log retains the real prior
  destructor-order failure; windows-worker-lifetime-owner-final.log is green.
- The creation-option test demonstrates silent prior acceptance with validation
  removed (windows-worker-options-red.log), then requires explicit diagnostics for
  valid nondefault SECURITY_ATTRIBUTES/stack and unsupported flags. No pointers to
  unowned program memory are accessed; native pause coverage calls real host poll.
- Original windows-thread-alias-lifecycle.jai checks native duplicate chains,
  denied query access, closing the original before completion, surviving duplicate
  queries, closed-handle failure, high-bit return codes, 259 after confirmed exit,
  and explicit Win32/CRT exits. The Windows Rust test executes this fixture.
  Windows-only unit cases also require real cancellation exit codes through a
  retained kernel alias and detect a suspend-only alias without query rights.
  These compile under x64/ARM64 clippy but have NOT run on this macOS host.
- Windows x64/ARM64 source checks and x64 O0/O2 PE construction pass in
  windows-worker-sdk-construction-final.log. Construction is not execution.
- Full available core/backend all-target run passes 307 cases, with the existing
  corpus sweep ignored. No passing-test filter was used. Exact command/counts and
  remaining coverage classification: full-suite-triage.md.
- Scoped Rust rustfmt/item-spacing, owned Jai jaifmt --check and rebuilt strict
  verbose jailint pass. Host core/backend/CLI all-target and Windows x64/ARM64 core
  all-target warnings-denied clippy pass. Actual rebuilt wasm32 host-target and
  canonical typed-message regressions pass, preserving browser behavior.

Native Windows CI must run:

```sh
cargo test --locked -p jaic --lib worker_lifetime_tests
cargo test --locked -p jaic --lib suspend_only_aliases_are_identified_without_query_rights
cargo test --locked -p jaic --test cleanroom_windows_thread_aliases --test cleanroom_windows_thread_description --test cleanroom_windows_threads
jaic -interp tests/compiler-semantics/windows-thread-alias-lifecycle.jai
jaic -O0 -exe windows-alias-O0.exe tests/compiler-semantics/windows-thread-alias-lifecycle.jai
./windows-alias-O0.exe
jaic -O2 -exe windows-alias-O2.exe tests/compiler-semantics/windows-thread-alias-lifecycle.jai
./windows-alias-O2.exe
```

Use the own source-built compiler and NEW integrated library; repeat on Windows
x64/ARM64. Naming/unwind execution gates remain separate and pending.

## Explicit limits and performance tradeoffs

- Arbitrary nonreturning foreign calls cannot be safely killed. Teardown waits for
  them to return; it never claims completion by parking/leaking workers. Callers
  must stop foreign work and unregister external callbacks before destroying the
  interpreter. Active native callbacks that encounter shutdown get the existing
  explicit finished-interpreter failure at the C boundary, not fabricated return
  values. Public Jai defers are not promised to execute during private interpreter
  abandonment. No general asynchronous native cancellation is claimed.
- Native cancellation requires unwind-enabled Rust builds (tested explicit abort
  diagnostic). If abort-only native builds become required, implement an explicit
  continuation/cancellation protocol; do not remove the safety diagnostic.
- Private join handles and scheduler records are retained until interpreter
  teardown, even for already completed workers. This is O(total created threads)
  ownership/metadata retention, not live parked OS threads. Future completion
  reaping should record actual OS termination and release private join resources
  earlier without losing public aliases or callback/TLS safety. No benchmark or
  unbounded-throughput claim is made.
- POSIX scheduler identifiers remain virtual and pthread_detach does not yet track
  detached state (threads.rs). This batch reclaims their managed OS workers at
  interpreter destruction, but does not claim native pthread handle/alias/detach
  conformance. Proper POSIX native entry/ownership and join/detach validation are
  separate required work; untested cases are not counted complete.
- Final Windows termination polling adds a 1ms scheduling interval only after Jai
  return; a direct safe completion notification could reduce this overhead. It
  does not provide a hard wall-clock latency guarantee.
- Unregistered alias suspend/resume control remains explicitly unsupported; full
  support needs coherent native access/suspend-count and scheduler-gate integration.
  Nondefault interpreter stack/security are explicit gaps; compiled native SDK calls
  remain available. UCRT and Kernelbase/Windows 10+ are native dependencies, and
  actual Windows Rust linking/execution remains required CI evidence.
- Initial lint caught a Windows-unused synthetic STILL_ACTIVE constant and a nested
  condition; both were repaired without suppression. One destructor-test setup
  passed &str where SourceMap requires String; corrected before recording the real
  red failure. That setup error is retained and not counted as functional evidence.

No module-specific bypass, supplied reference binary, old/quarantined/vendor Jai
body, peer write, publication or test weakening was used in this batch. The bounded
prior incident disposition remains local and must be excluded from final published
history by coordinator; no history rewrite was performed here.

Extra verification staging failure retained: windows-worker-lsp.log has 25 library
passes and 15/16 auto-import passes. The runtime-configuration CLI test was run
concurrently and rebuilds the same owned library candidate that LSP scans. This
was an avoidable verification orchestration mistake, not evidence of a compiler
fix or a test to weaken. Rerun all LSP cases serially after the CLI rebuild; keep
both logs. Do not run candidate rebuilders concurrently with their consumers.


Final follow-ups verified: the source-built POSIX entry regression rejects void,
wrong-width/argument and non-C callbacks before allocating a worker; a positive
typed-pointer callback mutates caller data and returns its actual pointer through
join. windows-worker-entry-abi-red.log preserves prior silent acceptance;
windows-worker-entry-abi-verified.log passes both cases. ABI validation is shared
with Windows; the worker no longer fabricates zero for an invalid result shape.
The POSIX start contract is from the public
[pthread_create specification](https://pubs.opengroup.org/onlinepubs/000095399/functions/pthread_create.html).
This does not establish native POSIX handle/detach interoperability.

The staging race is now repaired rather than left as a serial-only workaround.
The runtime CLI test supplies a per-process private destination to stage-candidate.py;
the helper validates that destination stays inside own target and cannot overlap
its source. Manual default staging remains available. Concurrent runtime allocation
and LSP verification pass (one CLI case and 25/16 LSP cases), and the default library
directory/file inode and modification-time witness stays unchanged. See
windows-worker-staging-isolation.log, cli-runtime-isolated.log and lsp-isolated.log.
Both initial failure and stable serial rerun logs remain. Scoped Python ruff format,
ruff check and py_compile pass; an outside-target request rejects before any write.
