# HTTP test termination on WASM hosts

The [reviewed termination contract](../specs/stdlib/http-wasm-test-termination-questions.md)
confirms an existing C `exit` service in both the browser/compile-time SandboxHost
and WASI runtime. Basic does not export `exit` on WASM. The test harness now
declares that existing symbol locally under `.WASM` in exactly the two failure
support locations: `Http/tests/lib/support.jai` and the standalone codec roundtrip
test. Native targets still resolve ordinary Basic `exit`. No public module API,
production fallback, host shim, WASI-specific import or core implementation was
added.

All existing checks, failure counters, assertions, and `exit(1)` paths remain.
The first post-binding source check exposed a subsequent codec assertion using
the live native clock (`to_timespec(current_time_consensus())` and `http_date_now`).
Those statements and both checks remain intact under the same reviewed native
adapter predicate, `OS != .WASM`. Every explicit-seconds date/cache/parser check
remains unconditional on WASM. This is the reviewed native clock's test scope,
not a waiver or substitute clock. Its native execution is not re-credited here.

## Actual host evidence

`tools/check_http_wasm_termination.py` runs five source programs with strict
output/status checks: codec, smuggling, roundtrip and two new original controls.
Every program is checked with `-no_dce`, run using `-interp -os wasm`, built as
WASM at O0/O2, and actually executed by the existing `tools/wasi_run.mjs`. The
browser companion uses the real source-built `jai_wasm.wasm` and shipped
`createEngine`, instantiated under Node just like the repository's browser-runner
checks, with no supplied host-function overrides. No headed browser or GUI
session was run.

The failure control loads the actual support file, calls `check(false, ...)`,
asserts the real failure counter is one, calls `finish()`, and places an error
marker after that call. The status control calls the existing C `exit(37)` with
before/after markers. Both detect a returning/ignored exit, a fake success,
unexpected trap, or wrong status. Their expected nonzero results are successful
negative controls, not successful conformance programs.

Actual results on the current Mac-hosted WASM runners:

- **31/31 runner commands pass**: five source checks, five interpreter executions,
  ten WASM builds, ten WASI executions and one browser-driver command.
- **6/6 browser executions pass** within that driver: three conformance cases,
  exit-37 control and the failed-check control twice. Repeating failure after
  successes verifies failure counters/termination state reset.
- The failed-check control exits **1** with exactly
  `FAIL: independent WASM termination control\n1 failure(s)\n`; the status control
  exits **37** with exactly `before exit 37\n`. No continuation marker appears.
- Each conformance execution exits zero, prints exactly `ok\n`, and has no
  stderr or browser diagnostics. There are **21 actual program executions** in
  total: five CLI interpreter, ten WASI and six browser SandboxHost executions.
- Six warnings-denied Jai lint contexts pass, including native Mac source
  contexts that retain the ordinary Basic exit and native clock assertions.
  Real source jaifmt idempotence, Python Ruff and Node syntax checks pass.

The isolated fresh browser build hashes current independent Rust/Cargo and all
embedded stdlib inputs before/after: zero drift. Embedded stdlib inputs also
match after runtime verification. Stable binaries, generated WASM modules and
captures live only under assigned T7 `platform-io/target/http-wasm-termination`.
The [ready manifest](../status/http-wasm-termination-ready.json) pins exact files,
tools, runner modes, controls, browser results and source-build provenance.

## Preserved failures and limits

The earlier three missing-`exit` RED checks remain unchanged in the native-date
capture. The first post-binding capture (`source-green.json`, despite its early
filename) retains the genuine codec native-clock source failure; it was not
overwritten or counted green. Both intermediate browser build receipts remain.
No test data, assertion, failure counter, status, mode or expectation was relaxed.
The only conditional test scope added is the already reviewed native-only clock
surface, while its checks themselves remain unchanged.

The fresh Rust WASM build emits an existing `inspect_callable` dead-code warning
in `crates/jaic/src/interp/compile_calls.rs`; the warning is retained and was not
suppressed or changed in peer-owned core. A Rust warnings-denied build is not
claimed. Strict lint evidence here concerns the owned Jai/Python sources.

No native application or Linux/Windows native test ran, and the numerics native
slot was not used. The earlier native-date **9/9** Mac commands remain pinned to
their original input receipt, not projected onto this changed combined tree.
Its manifest remains byte-identical and can integrate independently. This handoff
depends on that approved native-date production boundary but does not modify it.
Windows HTTP's cross-host `bcrypt` phase question and normal full CI remain
separate coordinator gates. No whole HTTP/networking/corpus/OS acceptance is
claimed. Integration alone stages and commits the exact scoped files; no remote,
publication or index operation was performed.
