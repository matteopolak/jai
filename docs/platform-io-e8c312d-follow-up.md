# Native e8c312d follow-up

Filtered run38662728329 confirms the private ARM64 crash backend's 12 native
startup/fault cases pass OFF/ON/default at O0/O2. Preserve that positive evidence.
x64 OFF/startup/compiled-section checks pass; four ON/default faults fail. Both
CPUs' thread-contract interpreter cases exit zero but fail output comparison.
Exact original-fixture output/status was requested from the coordinator before
choosing a fix. No raw/vendor logs or reference implementations were read.

Current source evidence, pending exact outputs:

- The independent compiler producer returns a scheduler Object::Thread handle.
  It records the real OS id, but does not back that public handle with a kernel
  thread handle. SetThreadDescription is not intercepted and receives that value.
  The library reports its failure through the context logger. Proper compiler fix:
  retain/transfer the actual Rust-spawned OS thread handle, register it as the
  scheduler object's key, preserve scheduling/suspension/wait semantics, and close
  it once on user CloseHandle or interpreter teardown. Generic native thread APIs
  must see that same real thread; no naming-success stub or library bypass.
- The x64 walker prints the input PC before its first StackWalk64 call, then exits
  if the next PC/SP equal the initial pair. A first SDK result naming the starting
  frame would truncate the trace. Exact failing trace/SDK-step evidence is needed
  to distinguish this from initialization, symbol or exception-status failures.

Implementation/verification plan:

1. Preserve exact bytes and individual failed predicates in own-test runner
   diagnostics. Request only the original thread/fault results, not raw CI logs.
2. Add a minimal original native thread-description interoperability reproducer;
   give the compiler owner the real-handle/lifetime requirement. Retain strict
   thread output expectations and all synchronization/ownership assertions.
3. Add original SDK x64 context-walk/lifecycle tests, real multi-frame named fault
   fixtures and diagnostic predicate regressions. Keep the already-passing ARM64
   fault source/cases unchanged; name/symbol quality tests are additional coverage.
4. Implement owned x64 private session isolation and normal-runtime cleanup using
   DuplicateHandle, serialized SymInitialize/SymCleanup, prior filter/error-mode
   restoration and checked CloseHandle. Public records/globals/signatures remain
   exact; shutdown belongs to a private Runtime_Support adapter, not a new public
   export. A separate SDK symbol session must survive private cleanup.
5. Fix the demonstrated x64 traversal cause, preserving the faulting frame,
   de-duplicating SDK initial-frame results, bounding traversal and diagnosing
   subsequent cycles. Require real named application frames in additional tests.
6. Format/lint owned Jai, warnings-denied native C builds, host interpreter/O0/O2,
   four-target checking and available cross-builds. New Windows execution remains
   the coordinator's next native CI gate; do not infer it from object/link checks.

Official native contracts used:

- [StackWalk64](https://learn.microsoft.com/en-us/windows/win32/api/dbghelp/nf-dbghelp-stackwalk64)
- [SymInitialize and session identity](https://learn.microsoft.com/en-us/windows/win32/api/dbghelp/nf-dbghelp-syminitialize)
- [SetThreadDescription](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-setthreaddescription)
- [GetThreadDescription and LocalFree ownership](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getthreaddescription)
