# Private Windows ARM64 runtime diagnostics

The coordinator decision in windows-arm64-backtrace-decision.md authorizes a
private ARM64 SDK backend, preserving public .ON/.AUTO defaults. The public
x64 CONTEXT/callback facade continues to diagnose ARM64 use. Runtime startup
selects a separate private module; no ARM64 pointer crosses the public x64 ABI.

Use native CONTEXT and RtlLookupFunctionEntry/RtlVirtualUnwind2 with real thread
stack limits, bounded walking and progress checks. RtlVirtualUnwind2 is dynamically
resolved as Microsoft documents. Missing API is an explicit initialization error;
Windows 11/Server 2022 is this backend's minimum. DbgHelp supplies symbols under
one lock. A fault uses try-lock to avoid deadlocking on interrupted symbol work.
Copy the native context before walking; preserve the fault/exit status. Duplicate
the process handle to isolate the symbol session. Reference-count initialization,
restore prior filter/error mode, SymCleanup and CloseHandle on normal shutdown.
There is no safe public ARM64 callback representation in the reviewed interface.

Execution and review checklist (inline; no subagents or CI dispatch):

- [x] Restore the original default-options reproducer as a positive fixture and
  preserve the failing ARM64 source-check output before production changes.
- [x] Implement private native C lifecycle/walking and Jai init/fini adapter;
  select it only for Windows ARM64 system entry with backtraces enabled.
- [x] Keep explicit public callback rejection and x64 behavior unchanged.
- [x] Extend real native runner with .ON/.OFF/untouched-default startup and faults,
  multi-frame trace assertions, and native C lifecycle tests.
- [x] Format/check owned Jai, strict lint all owned roots, C warnings denied,
  host interpreter/O0/O2, four-target source checks and available cross-builds.
- [x] Record exact platform limits, native execution still required, and commit
  this reviewed local checkpoint (native CI is a separate coordinator gate).

Local evidence: target/platform-io-arm64-{lint,suite}.log and
target/platform-io-default-arm64/default-backend-{red,green}.log. ARM64 native
objects compile at O0/O2 with warnings denied; no ARM64 Windows linker/runtime is
installed on this host. Native CI must run tools/check_platform_io.py with
--native --cross-check --windows-process --windows-crash on each Windows CPU.
This runner is prepared; no workflow was dispatched from the worker.

Official ABI documentation:

- [ARM64 context](https://learn.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-arm64_nt_context)
- [RtlVirtualUnwind2](https://learn.microsoft.com/en-us/windows/win32/devnotes/rtlvirtualunwind2)
- [SymInitialize](https://learn.microsoft.com/en-us/windows/win32/api/dbghelp/nf-dbghelp-syminitialize)
- [SetUnhandledExceptionFilter](https://learn.microsoft.com/en-us/windows/win32/api/errhandlingapi/nf-errhandlingapi-setunhandledexceptionfilter)
