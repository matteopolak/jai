# Flat_Pool core and container verification

Flat_Pool's canonical record, immutable CAPS_VERSION_STRING and native allocation
mechanisms are independently implemented under internal/allocation. No private
helper or replacement initialization API is exported.

| Public API | Implementation status |
| --- | --- |
| Flat_Pool; CAPS_VERSION_STRING | Exact reviewed field order/types/default alignment and string |
| get | macOS/Linux/Android code: aligned stable-address bump, page-wise mprotect commitment, checked extent/overflow, null on native commit failure without metadata advance |
| reset | Explicit overwrite argument supported, stamps allocated prefix then rewinds; committed pages retained. Unspecified global overwrite option remains unimplemented |
| fini | Checked native munmap, clears four pointer fields, retains alignment; empty repeat teardown accepted |
| flat_pool_allocator_proc | Real allocate/copy-resize, no-op FREE, allocated-prefix ownership query, static name/flags CAPS, initialized-instance STARTUP and actual SHUTDOWN; thread/heap modes diagnose |
| init | Not exported: oracle omits DEFAULT_VIRTUAL_MEMORY_RESERVE value/type. No guessed default or replacement signature |
| example | Not exported: requires unavailable init default |

This is partial mechanism support, **not a complete usable initialization API**.
Tests supply actual native reservations through the reviewed public fields solely
to verify supported operations. No reservation fixture is presented as production
initialization. Windows/console operations remain absent; Windows target checking
of the fixture verifies only canonical record shape. Android CLI is unsupported.

Independent policies requiring review: ownership recognizes the currently
allocated prefix, including alignment padding; it becomes empty after reset.
STARTUP requires existing reservation, SHUTDOWN releases it. Reset/fini on an
empty record are harmless. Alignment/reservation inputs are checked rather than
allowing invalid pointer arithmetic. Page size is queried on each required commit,
trading syscall overhead for simple state without changing canonical record ABI.
The global overwrite declaration/scope/value is unavailable, and only the explicit
reset argument is currently honored. These gaps must be resolved before counting
the module complete.

Original fixture tests use a real anonymous PROT_NONE reservation and check page
commit, changed alignment, stable original bytes, resize copying, static CAPS
names/flags, no-op individual FREE, stamp retention, committed-page reuse and
teardown. A read-only shared mapping of the original test source forces a real
mprotect failure without depending on an unmapped address being left unused.
The test checks unchanged metadata and releases that mapping normally. Native
O0/O2 and interpreter pass. A separate actual-reservation exhaustion case must
terminate with its exact checked diagnostic in both modes.

Initial source-path fixture used #filepath (directory) instead of #file (full
filename), causing the mapping assertion at line 61 to fail. Correcting the source
directive retained all checks. Initial full runner reached the new fault but
stopped with KeyError because its expected diagnostic was unregistered. The
expectation is now explicit; no fault/assertion is skipped. Original suite log is
target/flat-pool-suite.log; rerun is target/flat-pool-suite-final.log.

## Hash_Table audit

Existing table_find_multiple/table_remove_multiple already implement real
temporary copies/all-duplicate removal; the previous ledger understated that code.
New tests verify 128 duplicate copies independently of storage order, no alias to
values, stability across rehash, first-match set, removal preserving collision
neighbors, caller-initialized find_or_add, captured allocator cleanup, non-refilling
tombstones, collision counters and NEW foundation scalar-default hashing. Both
native optimizations and interpreter pass; Linux/Windows checks pass. No table
implementation is changed merely to satisfy old conveniences. Walk_Table remains
withheld until its caller-local expansion contract is reviewed.

Final full focused rerun: 95 positive interpreter/native cases, 23 checked faults in both modes, eight compile rejections and prior SMTP/IPC/parent/startup/Linux+Windows checks. All 290 currently owned Jai files pass jaifmt --check and jailint -D warnings.
