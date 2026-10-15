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

## Follow-up: demonstrated optimized Windows unwind metadata defect

The additional original windows-symbol-fault.jai fixture exposes a general codegen
ABI defect. At O2 its exported leaf saves RBP and its middle function saves RBP,
allocates 32 bytes and calls the leaf, yet both lacked .pdata entries. O0 produced
entries. Disassembly and full unwind/export dumps are retained in
target/platform-io-x64-unwind-red{,-assembly}.log. No native execution is inferred
from these object-format facts.

The LLVM backend did not request asynchronous unwind tables. Optimization can
infer nounwind for these functions; language-exception inference must not remove
Windows instruction-precise native frame metadata. The small general patch in
jaic-llvm::apply_codegen_attributes adds uwtable(async) to defined Windows functions,
using the existing target ABI classification. It does not name any module/symbol,
change public options/defaults, or affect Unix attributes. The original attribute
regression failed with None versus Some(2) before the patch; all 19 LLVM library
tests pass after it, as does warnings-denied scoped clippy.

Fresh O2 cross-builds now contain actual unwind entries at the exported leaf/middle
addresses, with matching RBP/stack-allocation unwind codes; evidence is in
target/platform-io-x64-unwind-green.log. The named native fixture also asserts
RtlLookupFunctionEntry finds both functions before provoking the real fault. These
native assertions remain mandatory; no frame-pointer fallback hides missing ABI
metadata. Apply the minimal patch to the current independent compiler producer,
not a wholesale replacement with local staged tool sources.

The x64 traversal control is independently corrected to preserve the captured
fault frame, tolerate exactly one initial SDK result naming that same frame,
apply skips to distinct frames, reject any later repeated PC/SP pair, and bound
output at 64 frames. The old loop failed an original portable scripted-transition
unit test on its initial-repeat case; the corrected iterator passes initial
repeat, skips, recursion with distinct SP, cycle and limit assertions. Scripted
transitions prove only control logic; the separate real SDK probe reports actual
first-step behavior on Windows. It accepts either SDK first-step convention and
requires real symbols and multiple caller transitions.

Exact failing e8c312d thread/fault outputs are still requested. These general
fixes and additional quality checks are not a claim that the four original x64
native fault failures or the interpreter naming failure are natively resolved.
The next candidate must execute unchanged original fault cases, named-frame
quality cases and SDK lifecycle/walk tests on both relevant native CPUs.

ABI/toolchain primary references:

- [Microsoft x64 function-unwind requirement](https://learn.microsoft.com/en-us/cpp/build/exception-handling-x64)
- [LLVM uwtable attribute](https://llvm.org/docs/LangRef.html#function-attributes)
- [LLVM UWTableKind values](https://llvm.org/docs/doxygen/CodeGen_8h_source.html)
- [Native RtlLookupFunctionEntry](https://learn.microsoft.com/en-us/windows/win32/api/winnt/nf-winnt-rtllookupfunctionentry)

## Separate thread completion error classification

Source review also found that the Windows thread_is_done predicate treated every
non-timeout status, including WAIT_FAILED, as completion. It now returns true only
for WAIT_OBJECT_0, false for WAIT_TIMEOUT, and logs an error/returns false for failed
or unexpected waits. This matches the existing Unix error-reporting approach and
does not alter thread records, parameter defaults or normal completion semantics.

The original thread contract adds a real Windows SDK negative wait on a null
handle, with a logger scoped to that call: it requires false plus exactly one
specific error. The original logger/data are restored before named workers are
created, so existing naming warnings still fail strict output comparison. No
positive-case logging or thread assertion is suppressed. Host/source/cross checks
pass; this new SDK-negative branch still needs actual Windows execution. No local
native red/green result is fabricated on the macOS host.

[Microsoft wait result meanings](https://learn.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-waitforsingleobject)
distinguish failure from a signaled thread. This safety correction does not claim
to resolve the current interpreter output mismatch or its kernel-handle gap.
