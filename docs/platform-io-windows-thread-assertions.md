# Windows Thread operations and optional assertions

Mailbox ownership is Windows only. Reviewed inputs are `modules/thread.md` and
`modules/basic.md`, plus own independent implementations and SDK ABI contracts.
The findings are production implementation defects: optional diagnostic
arguments contained critical-section initialization, ResumeThread, CloseHandle,
ReleaseSemaphore, Windows group-worker creation and performance-clock queries.
Discarding an assertion argument can remove those effects entirely. Moving
essential calls out of assertions is required regardless of current default
assertion configuration. Pure debug checks and Unix operations were not changed.

## Production correction

Windows native calls now execute before their result is checked. Private
`windows_thread_check` calls Basic.assert_helper unconditionally on failure;
it is not itself an optional assertion. This preserves the default fatal
diagnostic and permits a returning custom assertion handler without fabricating
successful cleanup. Thread start marks started only after successful resume.
Thread deinit checks completion, closes successfully, then resets state/releases
storage. Failed resume/close returns with ownership retained. Semaphore destruction
likewise resets its handle only after successful close. Condition-variable and
semaphore SDK failures diagnose even when optional assertions are disabled.

Only Windows branches of common lifecycle/group sources were changed. Windows
group creation and clock failure terminate after reporting if a custom handler
returns: their void/scalar APIs cannot return a valid group/time on failure.
This retains fail-closed behavior rather than a fabricated clock value or an
unusable partially initialized group. Default fatal termination reclaims process
resources; no partial-group rollback/recovery is promised. Generic/Unix assertion
side effects remain the portable owner's separate work.

## Public test and an explicit coverage gap

`windows-thread-noassert.jai` imports Basic with ENABLE_ASSERT=false, first
proves that its optional assert does not evaluate a side effect, then checks all
results with ordinary if/exit checks. It exercises a gated public thread,
context/index propagation, mutex/condition wake, semaphore timeout/consumption,
completion/deinit, and a queued-work group with shutdown. It also supplies the
SDK's null handle to a signal operation and protects a real completed thread handle
against close under a scoped returning assertion handler. It requires exact
failure diagnostics/count, retained handle/index/temporary storage, restores
the handler, removes protection and successfully retries thread deinit.
The test avoids HANDLE(-1), which is also a process pseudo-handle: CloseHandle
on that value is documented as having no effect, not a reliable failure oracle.
This is an independent SDK-negative
safety test, not a claim that invalid-handle use is normal public lifecycle use.

Runner coverage: Windows x64/ARM64 -check -no_dce, interpreter with/without --,
and native O0/O2. On macOS the runner only checks/cross-builds this Windows test.
All existing strict named-thread and group output tests remain enabled.

Important limit found by inspecting original emitted IR: caller Basic(false)
and Thread's unconfigured internal Basic are distinct module instances. The
former disables the caller's assertions; it does not currently disable the
latter's assertions. Even the pre-fix baseline IR therefore contains SDK calls.
The new public test is caller-disabled lifecycle coverage, **not proof that
Thread's own optional assertions have been disabled**. No fake staged Basic
source, new Thread parameter, root-constant leak, or module-name compiler special
case was introduced. A narrow reviewed configuration audit is recorded in
`docs/specs/stdlib/platform-io-questions.md`. Full internal-disabled coverage is
pending that answer; the production side-effect dependency is removed now.

## Evidence and remaining native work

The fault-test checkpoint is 8ede5a2. Local full host interpreter/native O0/O2,
cross-checks and x64 Windows executable builds pass after the production changes.
The updated test's exact negative-path and lifecycle behavior still needs actual
Windows CI on both CPUs. Four-target strict lint and source-built formatting
cover the new test and changed private sources. Native compiler-thread-handle/
SetThreadDescription interoperability remains a separate compiler handoff;
this change does not whitelist warning output or claim it resolved.

SDK contracts: [ResumeThread](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-resumethread),
[CloseHandle](https://learn.microsoft.com/en-us/windows/win32/api/handleapi/nf-handleapi-closehandle),
[ReleaseSemaphore](https://learn.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-releasesemaphore),
[InitializeCriticalSectionEx](https://learn.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-initializecriticalsectionex).
No new public API or OS minimum is introduced.
