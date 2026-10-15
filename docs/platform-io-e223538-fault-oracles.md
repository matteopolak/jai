# e223538 fault-test review

Input is only the coordinator-filtered own-test bytes in
`docs/native-fault-output-e223538.json`. That evidence remains unmodified.
No raw CI, vendor implementation, old library, or reference inputs were used.

## Classification before implementation

Six x64 O0 mismatches are incorrect test oracles: the address-1 Jai store exits
1 with the explicit near-null write diagnostic, before any hardware exception.
Changing production guards would invalidate a genuine safety check. The original
store is retained in `tests/platform-io/windows-nullguard.jai`. The runner checks
its exact diagnostic and exit 1 separately at O0 under OFF, ON and untouched
default startup settings. This is O0 compiler-guard coverage; it does not assert
that O2 currently emits this guard.

The other two x64 O2 mismatches are stale symbol expectations. The own fixture
declares `fault_leaf` and `fault_middle`; `platform_io_fault_*` are its PE export
aliases. Actual e223538 traces resolve both declared names, then main,
runtime_entry and native startup frames, with access-violation status. The new
oracle requires exact declared-name tokens on actual frame lines, rather than
requiring export aliases or accepting arbitrary substring matches. No symbols
are synthesized or renamed in production.

## Hardware-fault replacement and retained gates

`windows-fault-sdk.c` is an original test-only native helper compiled from source
against Windows SDK headers. It reserves/commits a one-byte request with
`PAGE_NOACCESS` (the SDK rounds to a page), checks allocation failure, then
performs a volatile byte store. It does not call RaiseException, rely on Jai
pointer lowering, or alter compiler/runtime guard settings. Unexpected setup or
return/cleanup results reach the Jai caller and fail the runner. Normal crashing
process teardown reclaims the allocation; runtime handler cleanup is tested
separately by the retained SDK lifecycle fixtures.

Both simple and named SEH fixtures call this DLL. Named Jai functions remain
non-inline and perform work after each call to retain real caller frames even
at O2. x64 RtlLookupFunctionEntry checks remain. The runner source-builds the DLL
for the selected CPU, links the fixture, and copies the real dependency beside
each child. This dependency is test-only and never substitutes a production
module. The same `--windows-crash` runner works with `--windows-build x64` and
`--windows-build arm64`; it adds three O0 guard cases to the previous 18 cases.

Native expectations remain strict: actual access-violation status, empty stdout,
OFF stderr empty, ON/default exception/stack headers, multiple real frames,
exact named callers where requested, and no unwind failure, cycle, unavailable
stack or truncation notice. Native SDK symbol-session and cleanup probes remain.

Official ABI basis: [VirtualAlloc](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualalloc)
documents rounding and checked failure; [memory protection constants](https://learn.microsoft.com/en-us/windows/win32/memory/memory-protection-constants)
documents PAGE_NOACCESS causing access violations. This test helper adds no
new production OS minimum. Existing modern thread naming and ARM64 unwind-export
requirements remain documented in the platform deviations report.

## Verification boundary

Six Python protocol tests pass, including rejection of SEH status for guard
failures and of symbol substring impostors. Source-built formatter/check and
strict four-target lint pass for all 50 owned Jai files. These are local checks,
not native Windows execution. The next coordinator native run must execute the
new helper and all guard/SEH/named-frame/cleanup cases on both CPUs at O0/O2.
The full local host interpreter/native O0/O2 and cross-check runner exits 0;
all 21 Windows children cross-build. DLL disassembly verifies a real volatile
byte-store instruction after VirtualAlloc, and O2 Jai wrapper disassembly retains
both caller functions and post-call work. These do not prove a Windows exception.
Earlier ARM64 native positives remain evidence for their earlier candidate;
they do not establish that this changed fixture matrix passes. No CI was
dispatched and the active ARM64 Mesa job was not superseded.
