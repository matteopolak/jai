# Transactional canonical heap handle reservation

After the cache-profile checkpoint `4fa38d7`, heap acquisition reserves a typed
`HeapView` before calling the SDK heap allocator. A failed reservation sets
ENOMEM and returns null before SDK ownership mutation. SDK acquisition failure
frees the unused reservation. A successful SDK result either binds that typed
storage to its actual native heap or reuses the existing live association and
frees the reservation. Public records, nominal identity and signatures remain
unchanged; no public pointer is passed as a native heap pointer.

Lookup, typed binding and allocation are separate reusable operations. This is
a strong lifetime association maintained by actual native unmapping/retirement,
not an address-keyed substitute for object lifetime. The extra calloc/free on a
reused native heap is an explicit performance cost. A typed reservation pool
bound to SDK mapping lifetimes could amortize it; such a pool must preserve
transactional exhaustion and native retirement instead of retaining stale views.

This does not make every metadata path transactional. Publication may still
need new heap/span graph associations and remains fail-fast on allocation
exhaustion. Default-thread association creation also retains that policy.
Diagnostic snapshots already have independent transactional allocation.
Full metadata safety requires reserving graph storage before native mutations
and integrating typed reservations with mapping/unmapping lifetime transitions.
Returning a partially published graph or fabricated counters is not acceptable.

The independent C fault-injection test compiles the production adapter unchanged
and denies real libc calloc calls. It checks cold and established-domain heap
reservation failure, ENOMEM, unchanged actual SDK heap buckets, orphan lists,
active-heap counters and live metadata allocation counts, then ordinary successful
allocation/snapshot/free/finalization. The pre-fix executable aborted (signal6),
recorded in `.work/rpmalloc-heap-reservation-before.json`; the same test passes
after the change in `.work/rpmalloc-heap-reservation-after.json`. These are actual
native observations, separate from source-target and public declaration checks.

Final verification `.work/rpmalloc-heap-reservation-final.json` passes357 checks,
including22 positive Mac executions on both CPUs,66 desktop source checks,
72 real C sanitizer executions across24 native profiles,72 independent C mirror
target/layout checks, strict lint, production formatting, regeneration and68
Python tests. Source hashes include the shared helper and all private programs
and C tests. Real native mapping failure after preflight also returns null and
frees the reservation. Fresh worker static/shared builds succeeded; their
raw-enabled scope passed348 checks and failed only a stale generated ledger
hash check, which passes on actual retry after regeneration. The original
349-check report retains its failure. Final coordinator package/native
Windows/Linux verification is not established by these worker host results.
