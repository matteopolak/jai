# Normal HTTP CI setup and case coverage

Filtered candidate449 feedback reports four Mac setup-unit failures comparing
lexical `/var/folders` paths with their canonical `/private/var/folders` identities.
The helper intentionally returns canonical paths. Only test expectations now
call `resolve()`: helper arguments keep their original paths, so the symlinked
TMPDIR run still tests canonicalization. Exact provider existence, full source
profile, cache invalidation, cleanup failures and complete-before-partial path
ordering remain checked. `tools/http_native.py` and the native builder are
unchanged; there is no production fallback.

The reviewed HTTP inventory has eleven module cases and one standalone
roundtrip regression. Current shared catalogue discovery already includes
`extensions/http-codec-roundtrip` exactly once. No duplicate discovery entry was
added. Instead, `HTTP_CONFORMANCE_CASE_IDS` declares the exact twelve required
IDs, HTTP invokes them with `--case`, and a preflight fails if any ID is absent.
Self-tests enforce both actual discovery and the production invocation. This
replaces two broad substring filters whose successful exit could not prove that
the standalone regression was selected. It does not remove another HTTP module
case: a discovery-versus-inventory assertion catches future unclassified cases.

## Reviewed capabilities and accounting

| Cases | interp/native | wasm-interp/wasm-native |
| --- | --- | --- |
| chunking, llhttp, smuggling, codec | Required | Required |
| standalone http-codec-roundtrip | Required | Required |
| client, https, server_connections, server_extractors, server_responses, server_routing, testing | Required | Platform unavailable: native Io providers and fiber context switching |

The seven individual Io/fiber IDs receive explicit `unsupported_modes` and
`required_capabilities` metadata. No family, directory or name-pattern exclusion
was added. Existing `unavailable_reason` and runtime accounting consume it:
unavailable rows retain `passed: null`, increment `platform_unavailable`, and do
not increment passed. Native interp/executable modes remain eligible for all
twelve cases; missing native providers and genuine supported failures still fail.
The real production Io WASM guard is unchanged and independently verified to
reject an actual import with its original fiber diagnostic.

## Focused verification

- A symlinked own-T7 TMPDIR reproduced all four original setup failures before
  changing expectations. That RED capture is preserved.
- Normal and symlinked TMPDIR runs each pass the twelve setup units, six new HTTP
  catalogue/dispatch/accounting units, and twelve existing runtime harness units.
  The standard `test_http_native.py` normal-CI entry point now loads the six new
  coverage units too (eighteen tests), so the self-tests are enforced without
  requiring a separate workflow edit.
  These are policy tests; SDK and dispatch mocks are not native functionality
  evidence. The dispatch unit uses an existing test file only for the harness's
  file preflight; it never executes that path as a compiler.
- An actual production runtime-harness run selects all twelve cases in the two
  WASM modes: **5 passed, 0 failed, 7 platform unavailable per mode**. This covers
  all four portable module cases plus roundtrip: five interpreter executions and
  five real WASI O0 builds/executions. The fourteen unavailable rows are separate
  from those ten positive outcomes.
- Supported-failure and missing-ID controls prove failures remain fatal. The
  accounting policy unit verifies native dispatch for all twelve IDs and all
  four modes for the five portable cases; it does not execute native programs.
- Ruff checks the four changed Python sources. New/changed unit tests pass Ruff
  format checks; scoped whitespace checks pass. Existing catalogue/conformance
  formatting outside the edited blocks was retained.

All captures, the real/symlinked temporary roots and source-built compiler inputs
are under assigned T7 `platform-io/target/http-ci-coverage` (the compiler is an
unchanged own source-built tool pinned in the preceding termination cohort).
[Exact ready manifest](../status/http-ci-coverage-ready.json) records hashes and
commands. No network HTTPS, echo server, global application, native application,
Linux/Windows native test, or native lease was used. Provided449 Linux's eleven
interpreter plus eleven native positives remain separate earlier CI evidence;
this follow-up makes no new native execution claim. Normal combined CI remains
the coordinator's gate.

The [02fe termination receipt](../status/http-wasm-termination-ready.json) remains
byte-identical, including its 31-command and six-browser proof. No production
HTTP date, Basic, compiler, Io guard or provider implementation was changed.
The earlier missing-exit/clock failures and initial metadata/setup RED evidence
remain preserved rather than retroactively counted passing. Initial policy-unit
setup hit the runtime's genuine host/compiler-file preflights; the unit was
corrected to use the actual host and a real existing file with mocked dispatch,
without weakening either production preflight. Integration alone stages and
commits the scoped handoff and selective README entry; no remote actions occurred.
