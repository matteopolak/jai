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

Json keeps its exact/Eisel-Lemire fast parsing and normal-float64 Schubfach
printing. Slow parsing now calls reviewed `string_to_float64` or
`string_to_float` at the requested width, checks consumption and explicitly
classifies non-finite output as overflow. There is no float64-to-float32 fallback
that could double-round a decimal. Float32/subnormal shortest printing calls
public `FormatFloat` in SHORTEST mode, preserves the actual boxed float width,
and normalizes decimal digits to Json's existing spelling thresholds, sign and
integral-float policy. Transient formatter allocations are freed. These helpers
are module-private; no removed Basic declaration is recreated or exported.

The number test's parsing oracle is now native C `strtod`/`strtof`, with signatures
checked in the installed Apple SDK `_stdlib.h:189–190`. Its shortest-digit
assertions compare normal-float64 Schubfach against Basic's independently
implemented public shortest formatter. For float32/subnormal formatting the
public formatter is also the implementation dependency: native parse/round-trip
and fixed expected-spelling assertions remain essential separate checks. No
shared formatter comparison is claimed as an independent subnormal oracle.
The native C oracle runs in the process's initial C numeric locale. Production
Json has no new native C import; the public parser/formatter paths are portable.
No WASM execution or non-Mac platform verification is claimed in this repair.

Actual Mac results so far: all27 existing affected catalogue tests pass native
O0/O2 (Json9, Http11, Io6, Byte_Search1), plus the new Json numeric ownership test
passes interpreter/native O0/O2. The existing complete Json number and leak
suites, typed decoder, Http client/codec, Io files and Byte_Search search pass
interpreted. All original rounding, cleanup, timer and atomic assertions remain.
Catalogue output is retained under artifacts/{Json,Http,Io,Byte_Search}-native-o*;
individual interpreter and numerical logs are under artifacts as well.

Replay the affected native groups with the source-built compiler:

```sh
JAIC_STDLIB="$PWD/stdlib" CARGO_TARGET_DIR="$PWD/artifacts/T7" python3 tools/stdlib_runtime.py --jaic artifacts/T7/debug/jaic --filter Extensions/Json/tests --modes native --opt O2 --jobs 2 --timeout 120 --verbose
```

Use Http, Io or Byte_Search in place of Json, and O0 for the other native mode.
The new numeric fixture is discovered automatically, bringing Json to10 tests.
The stable classified report remains absent; the27 existing-test total is a
direct catalogue measurement, not a fabricated replay of that missing report.

Strict lint must use actual enclosing contexts for loaded stdlib/test files.
Changed Json sources pass using the leaks/numbers contexts; changed Http sources
pass using `tests/extensions/http-dependency-consumer.jai`; changed Io/Http/
Byte_Search test files pass with their own test contexts. No rule is suppressed.
One additional context remains genuinely incomplete:

```sh
JAIC_STDLIB="$PWD/stdlib" artifacts/T7/debug/jailint -D warnings --context stdlib/Extensions/Http/tests/client.jai stdlib/Extensions/Http/client.jai
```

It reports `Json: (*Request) -> Response: cannot encode a procedure`, despite
normal source checking and the actual client test passing. The unchanged large
client fixture is the original reproducer for the compiler/linter owner. Its
incomplete lint result is not counted as success; the positive consumer context
does not replace it or claim to fix compiler generic sketches.
