# Pool implementation and safety

Canonical Pool contains the reviewed fields and defaults. Its reachable linked
headers retain next/data layout while the Memblock name stays private. Lifecycle,
allocation, accounting and mode handling live in internal/allocation/pool.jai;
the module facade loads those declarations without extra convenience exports.

| Public API | Implemented behavior |
| --- | --- |
| set_allocators | Explicit allocator wins; otherwise selected unmapping allocator with forced reset-free flag, or active context allocator; first-use guard |
| get | Aligned ordinary blocks, separately tracked oversized storage, null on backing allocation failure |
| reset | Invalidates allocations; frees oversized blocks, stamps ordinary data when requested, retains/frees ordinary blocks according to the reviewed flag |
| release | Resets then frees retained blocks |
| calculate_used_memory | Actual used-block byte accounting minus current remaining bytes, plus oversized block count |
| pool_allocator_proc | Real allocate/copy-resize/bulk lifecycle, individual FREE no-op, used-block ownership, required CAPS name/flags and rejected unsupported modes |
| example_usage | Executes actual allocation/reset/release |

The existing CAPS regression requires persistent name "Pool", exact ownership
and fast-bump flags, and null instance data for the capability query. No instance
is read before that query. The refreshed reviewed Pool policy resolves the
unmapping specialization: no explicit allocator selects get_unmapping_allocator
and forces free_memblocks_on_reset=true; an explicit allocator retains the caller
flag. Reset frees ordinary and oversized storage through that allocator. Pool
does not destroy it; caller may retain it and explicitly deinitialize its tracking
metadata later. Native mapping retention/protection remains the allocator's job.
The reviewed Unmapping_Allocator page specifies read-only retained frees; tests
preserve that precise behavior rather than claiming stale reads fault.

The public layout has no first-use field. A private address-keyed lifecycle table
preserves the reconfiguration guard even after reset frees all backing storage.
release removes its record and ends this tracked lifetime. Each record uses real
C malloc/free, avoiding recursion when this Pool itself is the context allocator.
First use can fail explicitly if metadata allocation fails. A256-bucket table and
short CAS lock protect distinct concurrent Pool instances; Pool operations on
one instance acquire no new thread-safety guarantee. Ordinary bump allocations
with existing storage bypass the registry. This is a documented allocation and
synchronization cost, not a public layout change. Failed get attempts that reach
the allocator count as use; release permits a new lifetime. Exact post-release
and failed-first-attempt reconfiguration policy is still a narrow review question.

pool-unmapping.jai exercises both block families, allocator identity, reset-free
flag, retained mapping contents, reset-time guard, explicit override without flag
mutation, release without allocator destruction, and first allocation with the
Pool installed as the context allocator. Native O2 and active strict lint pass;
full regression status is tracked separately.

An original safety regression exposed signed extent overflow: get(INT64_MAX)
forwarded a negative allocation byte count after adding alignment/header overhead.
Requests now return null before forwarding an unrepresentable extent, and backing
block allocation separately checks its private size-word overhead. This is an
independent safety improvement, not a new reference rounding/failure contract.
Ordinary representable requests still reach the supplied allocator. No allocation
is fabricated and no allocator failure is ignored.

pool-size-limits.jai verifies no invalid extent is forwarded, oversized backing
block rejection, and real allocation cleanup under a tracking allocator. A
controlled later allocation failure leaves the original allocation contents,
cursor, remaining capacity and linked state unchanged. Interpreter/native O0/O2
execute those checks; source-built strict lint checks both the public module and
fixture. Failing evidence: target/pool-size-red.log. Passing evidence:
target/pool-size-green.log, target/pool-size-native-O0.log,
target/pool-size-native-O2.log and target/pool-size-strict.log. Full portable
regression evidence is separately recorded in the progress report.

Callers must not mutate bookkeeping links, use invalid alignment/negative sizes,
or retain allocations after reset. No new synchronization guarantee or per-block
mutation API is introduced. Whole-library lint and native Windows allocator availability remain separate gaps.
