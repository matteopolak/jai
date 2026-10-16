# Runtime default allocator alias and x64 heap creation

Fresh833 Windows x64 upstream job 117201783379 reports TOML heap creation
failing at Basic's unchanged allocator-failed-to-create-heap assertion.
Read-only tracing found that Context_Base selected a separate private runtime
allocator implementing only malloc/realloc/free. Its CAPS omitted CREATE_HEAP
on every target and unsupported creation returned null. This path never called
rpmalloc or a generated native heap provider.

The refreshed reviewed Runtime_Support contract establishes the actual API:
runtime_support_default_allocator_proc is an entity alias of
Default_Allocator.allocator_proc, and Context_Base uses that callback with null
data. Optimized x64 except iOS (and Switch2) supports heap creation; fallback
targets do not. CREATE_HEAP ignores incoming allocator data and creates an
independent heap; Basic returns the same callback plus the resulting handle.
There is no separate MULTIPLE_HEAPS capability bit or parent/child destruction
ordering guarantee.

The repair exposes that canonical alias and removes the disconnected private
callback and its load. It adds no wrapper, parallel heap implementation,
capability fabrication or changed Basic assertion. Public callback identity,
parameters and behavior come from the same Default_Allocator entity. The
existing optimized backend performs actual allocation, ownership tracking,
resize and bulk destruction. Its implementation and native assets are unchanged.

Before the fix, the public-alias regression failed source checking because the
callback was not exported. A real baseline Mac ARM query reported CAPS33554445
and no heap. An x64 interpreter query also reported those fallback capabilities
and returned required-failure status1. These original receipts are retained.

The new public controls check:

- Canonical identity through Runtime_Support, Context_Base and Default_Allocator.
- Actual capability/name query and actual heap creation on x64.
- Two independent heap handles, including creation while incoming data contains
  another heap handle, with correct same-heap/cross-heap ownership queries.
- Allocation, grow/shrink data retention, failed resize preserving ownership,
  natural typed alignment, live-allocation bulk destroy and a genuine returned
  memory-debugger leak report followed by deinit.
- Mac ARM's absent heap capability, without making an invalid CREATE_HEAP call.

New test drafts initially guessed size-derived alignment from the obsolete
private allocator; that was not a reviewed public guarantee and was corrected
to natural typed alignment. The ARM query was corrected to capability-check
before creation, as required by the reviewed protocol. These are test-contract
corrections, separate from the production alias repair. No original TOML input,
assertion or foundation formatting fixture was modified.

Final freshly rebuilt tools match a guarded compiler snapshot. All 39 scoped
source/build/format/lint commands pass: 24 checks over Windows/Linux/Mac x64 and
ARM64, 12 complete strict-lint contexts and three formatting commands.
All 30 runtime build/run commands pass, covering 18 unique program modes:
the two new controls on Mac ARM64 and real Mac x64, interpreter/native O0/O2,
plus the two existing runtime controls on host ARM64 in all three modes.
The x64 binaries are independently confirmed Mach-O CPU0x01000007.

Actual x64 query output is CAPS33554463, CREATE_HEAP=true, heap_created=true;
Mac ARM output remains CAPS33554445, CREATE_HEAP=false. Compiler/stdlib/test
source drift is empty throughout final verification. The native slot is
released and children are reaped. Mac x64 proof is not Windows execution.

All failed receipts remain: initial x64 native build used an incomplete target
flag; initial lint requested an unrelated main file; an old smoke harness
expected ok instead of its source's runtime numeric line; the initial compiler
source changed during another owner's adoption. The matched tool was rebuilt
and the same scoped proofs repeated, rather than claiming equivalence.
The old smoke source and stdout were not changed.

[Ready manifest](status/runtime-default-allocator-ready.json) pins the exact
three production files, two new controls, reviewed contract inputs, compiler,
native executable hashes and receipts. No C/native-provider asset inputs
changed, so no native-asset rebuild is claimed or needed for this alias hunk.
Integration alone stages/commits and updates the global README link.

Remaining required verification is original Windows x64 TOML replay on fresh
integrated source, plus other applicable native CI gates. The foundations
allocator-caps fixture's old all-target fallback-bit expectation must follow
the reviewed target variant; its owner has the precise request. Do not qualify
x64 heap absence away or count a null heap as success.
