# Pool implementation and safety

Canonical Pool contains the reviewed fields and defaults. Its reachable linked
headers retain next/data layout while the Memblock name stays private. Lifecycle,
allocation, accounting and mode handling live in internal/allocation/pool.jai;
the module facade loads those declarations without extra convenience exports.

| Public API | Implemented behavior |
| --- | --- |
| set_allocators | Captures explicit backing allocator or active context allocator |
| get | Aligned ordinary blocks, separately tracked oversized storage, null on backing allocation failure |
| reset | Invalidates allocations; frees oversized blocks, stamps ordinary data when requested, retains/frees ordinary blocks according to the reviewed flag |
| release | Resets then frees retained blocks |
| calculate_used_memory | Actual used-block byte accounting minus current remaining bytes, plus oversized block count |
| pool_allocator_proc | Real allocate/copy-resize/bulk lifecycle, individual FREE no-op, used-block ownership, required CAPS name/flags and rejected unsupported modes |
| example_usage | Executes actual allocation/reset/release |

The existing CAPS regression requires persistent name "Pool", exact ownership
and fast-bump flags, and null instance data for the capability query. No instance
is read before that query. Default bulk mode is implemented; USE_UNMAPPING_ALLOCATOR
true remains explicitly rejected, not silently treated as default. The reviewed
page does not settle its backing allocator ownership and exact reset/release
retention policy. That specialization is unfinished and requires review.

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
mutation API is introduced. Whole-library lint and unmapping-specialization gaps
remain distinct from this checked arithmetic fix.
