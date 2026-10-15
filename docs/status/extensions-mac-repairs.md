# Extensions Mac repair status

Source-built compiler/linter: local `artifacts/T7`, actual host macOS arm64.
Normal appended commits repair Json/Http production and tests, Byte_Search test
timing, and Io test atomic dependencies. Io production and public stdlib/compiler
contracts are unchanged.

| Affected catalogue group | Native O0 | Native O2 |
| --- | --- | --- |
| Json, including new ownership regression | 10 pass | 10 pass |
| Http, including real HTTPS | 11 pass | 11 pass |
| Io tests | 6 pass | 6 pass |
| Byte_Search | 1 pass | 1 pass |

Focused interpreter runs pass: existing complete Json numbers/leaks/typed suites,
new numeric/empty-key ownership regression, Http client/codec/configured HTTPS,
Io files, Byte_Search search, and the real Http dependency consumer. Numeric
parsing uses native `strtod`/`strtof` as an independent bit-pattern oracle;
closest-shortest normal-float64 output retains the public formatter comparison
and fixed output assertions. No numeric or ownership assertions were removed.

Actual jaifmt checks pass for all 16 changed Jai files. Strict lint passes in
the documented real enclosing contexts for the changed sources and tests,
without suppression. The additional large-client-context lint check remains
incomplete with `Json: (*Request) -> Response: cannot encode a procedure`.
The exact command and original fixture are retained for the compiler/linter
owner; that failed context is not counted as passing.

## Resumed exact-context audit

The exact production client context was reproduced again with warnings denied.
This is a genuine general compiler audit defect, not invalid Http setup or a
Json requirement to encode handlers. An App POST registration creates a rejected
Client generic candidate whose handler type is inferred before its first
runtime argument is rejected. The IDE audit then checks that concrete NotNeeded
instance. The earlier "generic sketch" classification was imprecise: no stand-in
editor sketch is needed to reproduce this.

Two independent original reductions now preserve the failure: the real Http
registration and a self-contained nominal App/Client overload test without
Http/Json. Both compile and run in interpreter/native O0/O2. Their warnings-denied
audits fail, matching the production context. The compiler/linter owner request
is [recorded here](../compiler/rejected-overload-lint-request.md) and in the inbox.
No production source workaround, compiler edit or suppression is applied here.

`python3 tests/extensions/check-http-client-context.py` is a required-green replay
gate. Current result:15/18 pass, three failures (production context and the two
reduced lint contexts). All three remain failures, not expected-success skips.
Negative controls confirm that selected-generic errors and genuine unused
concrete errors still surface; the general compiler repair must retain them.
Fresh commands/stdout/stderr are durable in
`artifacts/http-client-context/results.json`.

Focused Mac behavior remains passing after a fresh source build in T7: original
Http client interpreter/native O0/O2, Json numeric/empty-key ownership native
O0/O2, Io files native O2 and Byte_Search native O2. Warnings-denied lint of those
actual test files passes in their real enclosing contexts. Both new reductions
pass actual formatting; their lint failures are intentionally retained as
blocking evidence, not certified clean. The module is still not fully green
pending an approved general compiler/linter repair checkpoint.

The named stable baseline JSON was absent in this worktree. The coordinator has
the exact names and152 failed executions and explicitly states that local
absence does not block this task. These totals are direct affected catalogue
results, not a fabricated replay of that report. T7 remains this worktree's
isolated source-built target. Earlier questions are updated in
[the questions document](../specs/questions/extensions-mac-repairs.md).
No Linux/Windows/WASM runtime verification or optional performance sweeps were
performed. [Architecture, replay commands and evidence limits](../extensions/mac-dependency-repairs.md)
record the precise boundaries and durable report locations.
