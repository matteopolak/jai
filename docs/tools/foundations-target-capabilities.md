# Foundations lint contexts and runtime target requirements

The ac174e80 Mac ARM64 CI failure exposed stale configuration/context fixtures
and a runtime catalogue selecting native-only APIs for WASM execution. Actual
strict-lint diagnostics were contradictory Basic PROGRAM configurations,
duplicate `print_style`, and ARM64 selection of x64 division exercises.
The runner now also makes each public import context explicit for private source
coverage; private guards were not waived to repair those fixture diagnostics.
This repair changes test orchestration and consumes separately owned fixture migrations. It does
not add a WASM `Basic.exit`, change library implementations, or reinterpret a
compiler failure as a successful test.

## Source checks

`tools/check_foundations.py` imports Basic, String, Hash, File_Utilities, File,
and Text_File_Handler in a real public program. Private implementation fragments
are requested through that context with `jailint -D warnings --context`.
Text_File_Handler is necessary for its actual loaded `text-handler.jai`; omitting
that public import produces the linter's required unvisited-file failure.
The private-import guard remains enabled. Requested target bodies include both
native file backends on their supported profiles, rather than excluding their
filenames from coverage.

Fixtures retain their separate program/module roots and actual parameters.
Exact target lists place the x64 division exercises on Linux/Windows x64,
Windows sources on Windows, and POSIX implementation/oracle files on Unix.
Every positive owned source must appear in a complete compiler context on at
least one of the four profiles. Failed contexts do not establish coverage.
The scalar and fourteen wide-conversion rejection cases remain mandatory on
every profile and are never counted as positive body coverage. The linter JSON
contexts, checked-file manifests, commands and diagnostics are retained.

Two formatter tests redundantly declared `context.print_style` after importing
Basic. Removing those two declarations preserves the canonical public field
and all original formatter assertions. Both fixtures pass strict contextual
lint on macOS ARM64, Linux x64, Windows x64 and Windows ARM64.

The original configuration fixtures initially remained required and RED:

- `basic-configuration.jai` imports contradictory Basic configurations within
  one PROGRAM. It needs separate configured program/workspace tests retaining
  the enabled/disabled assertion, builder capacity and stamping checks.
- `memory-debugger-interface.jai` mixes enabled/disabled configurations and
  uses a custom interface. A fresh minimal single configured root now passes;
  the historical ordering failure in
  [the existing question](../specs/stdlib/basic-array-context-questions.md)
  cannot be projected onto the current compiler.

Neither rejection is an accepted negative or a lint exclusion. The stdlib owner
now owns the four corrected originals plus three separate configured roots:
`basic-configuration-disabled`, `basic-configuration-isolated-combined` and
`memory-debugger-interface-disabled`. All are added to the runner's required
format, lint, interpreter/native and supported WASM case lists. Their actual
final coverage is reported in the receipt, separately from the original REDs.

A concurrent ownership error briefly mixed our provisional migration with that
owner's work. It was disclosed immediately, two originals restored from exact
pre-own-write peer bytes, and all five provisional alternative sources preserved
in T7 then removed. The owner supplies the unique combined root. No fixture-body
change is included in this foundations handoff; final lint checks use the actual
peer roots, never the discarded alternatives.

The fixture owner's separate new MAIN-only configuration boundary controls
remain explicit: competing MAIN settings reject correctly, but settings supplied
by a non-MAIN helper unexpectedly compile on six desktop targets. That required
negative remains RED and compiler-owned in
[the fixture handoff](../status/foundation-fixtures-ready.json). It is not counted
among this runner's passing binding negatives or adopted as a positive program.

To run only the four source-check profiles without executing test programs:

```sh
python3 tools/check_foundations.py \
  --jaic "$FOUNDATIONS_BUILD/debug/jaic" \
  --jailint "$FOUNDATIONS_BUILD/debug/jailint" \
  --stdlib stdlib --build-root "$FOUNDATIONS_BUILD" \
  --output-root "$FOUNDATIONS_CAPTURE" --lint-only
```

The build and output roots are explicit so isolated local workers can use their
assigned external disk. Their source/tool identities must be captured by the
caller. Existing default checkout paths remain available for CI.

## Runtime catalogue

`tools/foundations_case_capabilities.py` contains explicit reviewed case IDs.
It merges metadata into the canonical catalogue without replacing other owners'
capabilities. Selection never reads compiler output or searches source text.

| Requirement | Source basis | Target accounting |
| --- | --- | --- |
| Native Basic.exit assertion/termination paths | Reviewed Basic POSIX/Windows exports; exact unchanged fixture calls | WASM execution unavailable; native checks still required |
| Io providers/fiber stack switching | Exact Io consumers and the existing Io WASM stack-switch guard | WASM execution unavailable; native checks still required |
| Http App/Client surface | Http's explicit native-only facade loads | WASM unavailable for that consumer; codec controls remain selected |
| SDL SDK/platform services | Three SDL programs and canonical native platform guard | WASM execution unavailable; native SDK checks still required |
| Architectural x64 operations | Only `lang-asm` and `rules-simd-asm`, which execute fences/CPUID/timestamps | Require an actual x64 target; arithmetic assembly remains portable |
| Linux io_uring facade/kernel | Only the raw kernel program and facade dependency reducer | Require Linux; caller-owned-memory protocol remains eligible on Mac |

Native exit metadata expresses the fixture's declared API dependency even where
a compiler can prune a constant-false assertion path. For example the current
`type-field-constant` source check can prune its exit calls; this is not a new
public WASM exit contract. `discard-parameters` independently reproduces the
actual unknown-exit rejection on WASM.

Explicit WASM C-termination controls, portable HTTP codecs, arithmetic assembly,
portable loop tests and intentional private-export negatives remain selected.
Unknown future compiler failures remain failures, with no capability inferred.
Unsupported execution is reported unavailable and never passed. Existing
reference-rejected source identity and exact diagnostic/output checks remain
unchanged. User deferrals are not broadened.

Process/System/Thread classifications belong to platform-io; GetRect/Input
contracts belong to numerics and graphics owners. Integration owns runtime
wrapper/workflow adoption. In particular the raw io_uring program's existing
kernel-unavailable `skipped:` outcome must not be represented as kernel runtime
success by the wrapper. No thread-fault or input-parameter assertion was relaxed.

## Evidence and remaining execution

Current source-built jaic/jailint inputs and tool hashes, original failing lint
logs, complete-context manifests, source-check controls and required negative
results are pinned by [the focused receipt](../status/foundations-catalogue-lint.json).
Actual focused native results are listed separately from source checks:
`discard-parameters`, `for-loop-bounds`, and `io-fibers-context` pass interpreter
and Mac ARM64 O0/O2. The explicit termination control exits exactly 37.
Portable arithmetic assembly and loops pass Node WASI O0/O2. An initial loop
harness wrongly expected printed `ok`; the unchanged program actually asserts
success and prints nothing. Native checks were repeated with that exact contract.
Two old WASM artifacts later contained zero headers despite the initial Node
exit-zero receipts; their failed rerun is retained and its cause is unestablished.
Fresh unique outputs passed actual WASI execution with correct magic and unchanged
before/after executable hashes. No invalid artifact is used as final proof.

The final strict-lint result checks all four complete production/fixture profiles,
60 required negative rejections and every positive owned file, with a source guard.
Linux/Windows runtime and the combined catalogue CI replay remain integration
requirements. The stdlib owner's seven-fixture native evidence is a separately
owned dependency, not substituted for our focused catalogue checks.

No broad catalogue replay, GUI/fault test or performance sweep is
part of this repair. All bounded execution slots were released after child exit.
