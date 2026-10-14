# LSP worker validation for 0.17.1

This branch implements current-source partial-edit recovery and selected custom
iteration navigation for coordinator integration after 0.17.0. It changes no
version, release metadata, bootstrap definitions or Extensions sources.

## Focused and existing checks

- `cargo test -p jaic --lib`: 146 passed.
- `cargo test -p jai-language-server --lib --test partial_edits --test edit_corpus
  --test source --test protocol --test framing --test stdio --test fuzz_regressions`:
  72 passed, including 20 focused regressions and two exhaustive fixture tests.
- `python3 -W error::ResourceWarning -m unittest discover -s tools
  -p test_lsp_partial_edits.py`: eight runner protocol tests passed.
- `cargo clippy -p jai-language-server --all-targets -- -D warnings`,
  `cargo fmt --all -- --check`, and `git diff --check`: passed.

Focused tests cover current-source recovery, distinct real semantic errors,
missing delimiters, multiline literals, opaque-region edits, UTF-16 changes and
restoration, deep nesting, failed pending generators, local-constant hoisting and
context-switch failures. They assert real typed facts and correct definitions,
and reject compile-time execution of damaged ordinary and macro bodies. The
strict parser and non-IDE compiler are also checked to reject malformed source.

Custom iteration tests check every character of the keyword, selected pointer
overloads, named loops, generics, aliases, imported source procedures, multiple
actual instantiations at one loop site and incomplete bodies. Operand references
retain their variable targets, and array/range loops have no expansion target.

## Corpus evidence

Reports and frozen independent source snapshots are durable under
`artifacts/lsp-edits/`. The public application fetcher uses only the pinned
application/tutorial allowlist; it downloads no other Jai implementation or
reference executable. Library inputs are separate snapshots of newly produced
independent sources, including unchanged Extensions. They are not an integrated
library release.

`verification-final.json` covers every file in the available input sets, sampling
at most three nonempty lines per file with varied suffix cuts:

| Inputs | Files | Edits | Files with baseline error diagnostics | Failed files |
| --- | ---: | ---: | ---: | ---: |
| Pinned public applications/tutorials | 1,044 | 11,547 | 755 | 0 |
| Independent stdlib snapshot | 284 | 3,205 | 199 | 0 |
| Independent compiler-owned stdlib snapshot | 225 | 2,550 | 180 | 0 |
| Tour and clean-room language fixtures | 35 | 378 | 21 | 0 |
| Original LSP fixtures | 5 | 56 | 2 | 0 |
| Total | 1,593 | 17,736 | 1,157 | 0 |

The run completed 2,588,958 assertions with no stalled workers, panics or stderr
output. Twenty-two files have baseline lexer/parser errors. These baseline gaps
remain visible, and passing independent edit probes does not establish full
application typechecking or library API compatibility.

The final exhaustive run, `exhaustive-final.json`, checks every nonempty line of
40 original, tour and clean-room fixture files: 6,621 edits, 375,856 assertions,
zero failed files. Twenty-three files report baseline error diagnostics; these
remain errors, rather than being counted as successful typechecking.

Both final correctness runners use source-built worker SHA-256
`167c678032f22faca1f403e20b3ba167c259a85e27cb172fc30d8303a90dbd63`.
They use UTF-16 ranged suffix deletions at varied scalar/byte boundaries, restore
between edits, and require independent typed features, exact definitions and
document features. Each request/stage has a 60-second stall deadline. These are
correctness checks, not the deferred benchmark phase.

The combined run is reproducible from the frozen local inputs with:

```sh
python3 tools/lsp_partial_edits.py \
  --stdlib artifacts/lsp-edits/new-stdlib-snapshot-284 \
  --max-lines 3 --jobs 4 --timeout 60 \
  --report artifacts/lsp-edits/verification-final.json \
  corpus/lsp-applications artifacts/lsp-edits/new-stdlib-snapshot-284 \
  artifacts/lsp-edits/new-compiler-stdlib-snapshot \
  examples/tour tests/cleanroom-language tests/lsp/partial
```

For the exhaustive local run, use those final three fixture paths with
`--max-lines 0` and a separate report path.

The existing identifier coverage tool was also run on the tour with the canonical
new prelude and `--no-runtime --errors`. Its durable report is
`ide-coverage-tour-current.log`; missing library contracts and dependent facts
remain visible. A successful coverage-report process does not imply all inputs
typecheck.

## Integration limits

Fresh unterminated opaque comments/here-strings without verified prior boundaries
remain conservative. Incremental edits preserve those verified lexical boundaries
without reusing previous ASTs or semantic facts. Ambiguous missing-brace scopes
and resource admission limits are documented in the
[questions and overlap notes](../specs/lsp-questions.md).

Jai fixture formatting/lint checks are blocked at tool startup: freshly built CLI
and lint tools still require the legacy `module.jai` layout. Both the local tree
and `JAIC_STDLIB` pointing to the independent canonical snapshot were tried.
`jaifmt` was not built, and fixture lint did not run; neither is claimed passing.
The existing legacy diagnostics suite also has three dependency failures in this
snapshot. No compatibility exports or duplicate bootstrap files were invented to
satisfy those expectations. Coordinator owns bootstrap integration, complete
application/library verification, formatting/lint reruns and release checks.

See [implementation and harness](lsp-partial-edits.md) for the recovery rules,
report semantics and reproducible commands.
