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

The named stable baseline JSON was absent. These totals are direct affected
catalogue results, not a fabricated correlation against its unavailable19+1
failure inventory. The missing report and exact external T7 path question remain
in [the questions document](../specs/questions/extensions-mac-repairs.md).
No Linux/Windows/WASM runtime verification or optional performance sweeps were
performed. [Architecture, replay commands and evidence limits](../extensions/mac-dependency-repairs.md)
record the precise boundaries and durable report locations.
