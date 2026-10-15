# Mac Extensions dependency repairs

This worker owns Json/Http production and tests, Byte_Search test dependencies,
and Io tests. Io production lifecycle and standard-library/compiler contracts
remain unchanged. Builds use this worktree's isolated `artifacts/T7` target.

The first checkout inspection found neither the named
`docs/status/mac-integration-baseline.json` nor a worker inbox/T7 path assignment.
The coordinator was asked for these missing inputs; the named failure classes
were reproduced directly meanwhile, without seeking another checkout or raw logs.

Reproduced failures include Json's removed private decimal interfaces, Http's
obsolete compare-exchange name, Byte_Search's Apollo subtraction, Io test-only
qualified atomic names, and Json's actual cleanup assertion failure. The cleanup
failure occurs even for an empty input: an error owns a non-null heap allocation
for an empty path, but cleanup tested its length. `free_json(Json_Error)` now
releases both owned strings by pointer and resets the error. The full existing
leak sweep passes interpreted with its allocator assertions unchanged.

Http uses canonical `compare_and_swap`, retaining real sequentially consistent
state publication. Io tests use reviewed `atomic_read`/`atomic_write` aliases.
Timer tests use checked nanosecond conversions before subtracting monotonic
timestamps; Http date conversion subtracts the canonical 128-bit Apollo fields
with a borrow before checked `to_seconds`, preserving the fractional boundary.

Json numeric migration and full scoped verification are in progress. No partial
numeric result is accepted as correctness evidence. Remaining numerical and
platform limits will be recorded with actual outcomes before handoff.
