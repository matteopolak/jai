# Public rpmalloc adapter progress

The default rewrite facade now has real lifecycle, allocation and statistics
procedures. The independently authored test imports only `rpmalloc` and `Basic`:
it initializes through the public API, grows ordinary/aligned allocations,
checks preserved bytes, frees in the matching domain, reads real counters with
canaries, and tears down thread/global state. Negative signed-size rejection
is an independent safety boundary, not a claim about unspecified reference
failure details. No native SDK initialization is hidden in this test.

The reviewed contextual rewrite Heap/Span/cache/counter records are emitted in
`stdlib/rpmalloc/context.jai`, in exact field order and with conditional fields.
They remain private nominal types. They are not aliases or casts of native
SDK heaps, and heap operations remain unfinished. Raw-only public aliases are
now guarded by USE_RAW; aggregate declarations retain their own shape guards.

The native archive has one verified cache/statistics/assertion profile. These
procedures are emitted only for matching options: HEAP_ARRAY_SIZE 47,
DEFAULT_SPAN_MAP_COUNT 64, GLOBAL_CACHE_MULTIPLIER 8, thread/global caches,
statistics/assertions/argument validation enabled, adaptive/unlimited caches,
huge pages and disabled unmapping off, and DONTNEED advice. Both CONFIGURABLE
settings can initialize with native defaults; custom config initialization is
still absent. Nonmatching options retain missing-implementation diagnostics;
they never silently execute the default archive. The ledger labels these 14
entries **partially_implemented**, not complete across module configurations.

Remaining production work includes configuration/callback/string lifetimes,
raw mode, every heap operation, allocator-procedure integration, main-thread
tracking, dump builders and nondefault native profiles. The native archive is
process-global; distinct concurrently initialized import instances need proper
isolation before mixed-profile behavior can be claimed. Public initialization
and finalization require serialized lifecycle use. No callback, raw or heap
success is inferred from the default test.

Verification: `.work/rpmalloc-public-allocation-verification.json` records six
desktop source checks, real macOS x64 and arm64 programs, actual production
formatting, scoped strict lint and regeneration. Windows/Linux source checks
are not native execution. The standard `verify.py --module rpmalloc --runtime`
also discovers this new spec-derived public test alongside the independent
native SDK/layout tests; required missing-public-name checks remain active.
Independent public-contract review remains pending. No inherited stdlib test
oracle is required or reinstated by this change.
