# Platform I/O compiler/tool integration handoff

No compiler source was modified in this worker's production changes. These are
general semantic/tool gaps; do not fix them by matching module or fixture names.

## Suspended CRT threads in the Windows interpreter

Original reproducer: `tests/platform-io/pending/windows-crt-suspended-thread.jai`.
Run `jaic -interp` on native Windows after integrating the independent stdlib.
The required behavior is an actual gated thread, an initial timeout, ResumeThread
returning the previous suspend count, then completion and handle cleanup.

The current compiler producer's `interp/threads/win32.rs` intercepts CreateThread
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

## Linter private-library roots and target selection

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
