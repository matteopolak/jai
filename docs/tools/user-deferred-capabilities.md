# Explicit user-deferred test capabilities

The human deferred native Windows console colors on 2026-10-16; see
[TODO](../specs/jai/README.md). The public
`Print_Color` default-Windows rejection remains active. ANSI mode is supported
and remains required. This accounting change supplies no console implementation.

`tools/case_capabilities.py` recognizes the explicit metadata capability
`native-windows-console-colors` only for a Windows target. Cases declare it in
`required_capabilities`; names, compiler output and imported-module diagnostic
strings never trigger a deferral. Mac/Linux and WASM targets acquire no deferral
from this Windows rule, including WASM execution on a Windows host.

The runtime catalogue passes the reason through its existing unavailable
accounting: `passed: null`, `platform_unavailable: USER_DEFERRED ...`, and a
separate count. Its current discovered sources contain no direct `Print_Color`
imports and no case is newly annotated. The standalone portable color fixture
is owned by `check_portable_stdlib.py`, explicitly requests ANSI and remains
unchanged. The excluded partial native-color prototype is not added to the
catalogue or this batch.

Smoke consumer facts are supplied as sanitized declaration/dependency facts by
the coordinator; no upstream application implementation bodies are inputs here.

| Consumer | Accounting |
| --- | --- |
| `unotest`, `unotest.jai` compile-time tests | Default import at application line 355; whole check unavailable on Windows. |
| `jai-format` release and stdin formatting | Main explicitly selects ANSI; both steps remain required on Windows. |
| `jai-format`, `first.jai - test` | `run_tests` constructs/submits a child workspace loading `tests/test_template.jai`, which imports default Print_Color; only this step unavailable on Windows. |

`upstream_smoke.py --list` exposes unavailable decisions before building or
running applications. `--report PATH` writes every selected check with its
status, nullable pass result and separate `pass`, `FAIL`, `skip` and
`platform_unavailable` counts. A step-specific capability suppresses only that
step; other steps still execute. The enclosing check remains unavailable, not
passed, and the JSON retains each completed/skipped/unavailable step. Any
required step failure retains the check's failure and nonzero harness exit.
Existing platform/provider/SDK checks and commands are unchanged.

The real jai-format manifest is exercised by an accounting test against an empty
independent scratch fixture with mocked step execution: Windows x64/ARM64 each
record one unavailable test step and two completed release/format steps;
Mac/Linux each dispatch all three steps. This proves metadata/dispatch behavior,
not execution of the upstream application. The coordinator supplied the final
dependency YES in the shared inbox; no application body was read by this worker.

Focused accounting tests use independent metadata and mocked execution; those
are harness policy evidence, not native functionality. Eight new tests plus
the existing nine smoke, twelve runtime, eighteen HTTP setup/coverage and six
HTTP coverage tests pass. Actual own-compiler `-no_dce -check` accepts the
unchanged ANSI fixture on Windows x64/ARM64; two independent default-import
probes retain the real unsupported diagnostic. These are source checks only.
The same default and ANSI programs also pass Mac/Linux x64/ARM64 source checks.
No native Windows, GUI, application, DLL-loader or console execution is claimed.

Captures live under own T7 `platform-io/target/deferred-windows-colors`:
`accounting-red.txt`, `step-accounting-red.txt` and `final-dependency-red.txt`
retain initial failures, including the missing final test-step annotation;
`verification.json` records exact commands and outputs. Strict lint passes for
the new Python files and catalogue. Full smoke-file Ruff still reports the
pre-existing E731 lambda in `lsp_step`, outside the owned changes; it is retained
as RED, not waived or counted as a pass. New files are Ruff formatted and
idempotent. The partial Windows color production/tests, upstream application
bodies and provider/workflow/helper closure remain excluded.

HTTP ready manifests `e87dfe59` and `02fe1479` remain byte-identical. This feature
does not modify the coordinator's ten deferred corpus IDs or Mac case counts.
Integration owns staging/commits and real Windows CI acceptance.
