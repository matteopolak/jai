# Staged corpus acceptance

## What it is

`tools/check_corpus.py` inventories every pinned reference and recent upstream Jai source and attempts explicitly selected roots with this repository's Rust compiler. Lexical acceptance never counts as compilation; ordinary module checks, program builds, deliberately rejected programs and runtime evidence are separate results.

## How it works

Build our CLI with `cargo build -p jai-cli --locked`, then run:

```sh
python3 tools/check_corpus.py --report artifacts/corpus-acceptance.json
python3 tools/check_corpus.py --all --through parse
python3 tools/check_corpus.py --all --through check
python3 tools/check_corpus.py --select 'reference:how_to/001_first.jai' --through codegen
python3 -m unittest discover -s tools -p test_check_corpus.py
```

The default manifest selects reference tutorials, a standard module, metaprogram roots and roots from all seven pinned upstream projects. `--all` attempts every inventoried source, including support files; it is a diagnostic sweep, not proof that each file is an independent project. The driver resolves recursive loads and unparameterized imports with independent module/file visibility. Parameterized and conditional dependencies remain unsupported. No synthetic replacement source or import stubs are supplied.

Each report retains all 2,142 source rows, even when a smaller selection is attempted. Unselected rows are `not-run`, missing or modified selected sources are `blocked`, unsupported syntax is `failed`. Stages stop after a failure. Manifest entries with `kind: module` use `check-library`, which checks all reachable bodies without an application entrypoint. Program checks still require an application-owned `main`; LLVM output, linking and project builds have separate requirements. `jai-rs parse SOURCE` decodes source with the shared decoder and calls the file parser with a source registry and shared symbol interner. It validates syntax and records imports, loads and visibility directives without resolving dependencies, reading loaded files or executing metaprograms. A parse pass is syntax evidence only. Graph-aware semantic resolution powers `check`, `check-library`, `emit-llvm` and `build`; successful syntax parsing does not imply support for all declared types or compile-time behavior.

Negative cases specify a diagnostic substring per stage. Only exit code 1 with that substring is `expected-rejection`; an unrelated unsupported construct, crash, timeout or incorrect successful acceptance fails the case. The book's polymorphic type mismatch and OpenJai's false assertion currently fail before their intended diagnostics, so neither is a successful negative test.

Reports record exact commands, exit codes, bounded stderr, source and compiler binary SHA-256 values, input manifests and compiler-source fingerprints. Compiler stdout is not retained because lex/IR output can reproduce source material. Successful generated artifacts have their own hashes. Binary and current source fingerprints are recorded independently: this does not prove a stale binary was built from those exact sources. Outputs live in a temporary directory outside the corpus and are removed afterward. Reports remain local; this tool uploads nothing.

The harness executes only `target/.../jai-rs`. It never executes reference tools or upstream build scripts. Runtime is blocked pending isolated execution with actual behavior assertions. Host linking requires an explicit, reviewed `host_build_reviewed` manifest entry: review the source and transitive loads for pure generated IR, foreign declarations, native objects, metaprogram behavior, SDKs and target requirements first. No current corpus entry has this approval. Approved builds invoke our CLI with `/usr/bin/clang` as the backend, overriding inherited `JAI_RS_CLANG`; missing tooling is a blocker. Platform and graphics projects remain unverified until genuine dependencies and appropriate target SDKs exist.

The report intentionally has zero `project_build_successes`: current per-root CLI output cannot yet establish upstream workspace builds and target correctness. A future workspace integration must earn those counts from complete build evidence. The refreshed local baseline selected 13 roots: 13 lexical passes, 13 file-parser failures, zero check/codegen/build/runtime successes, with 2,129 unattempted source rows. Checking stopped after parser failures, so all 2,142 check rows are `not-run`; this must not be reported as 13 check failures. This is a point-in-time actionable baseline, not a corpus compilation claim; regenerate after compiler changes.

A subsequent full-inventory syntax sweep of this checkpoint recorded 2,142 lexical passes and 70 parser passes, with 2,072 parser failures. Checking and code generation were not attempted in that sweep. These are syntax counts, not successfully compiled files or projects; the local report is `artifacts/corpus-parse-current.json`.

## How to change it

The manifest and report formats are documented by `corpus/acceptance.schema.json` and `corpus/acceptance-report.schema.json`. The harness checks critical manifest constraints without adding a JSON Schema runtime dependency. Add reviewed roots to `corpus/acceptance.json` using exact `repository:path` IDs from the pinned manifests. Keep metaprogram roots instead of substituting their eventual generated programs. Add dependency and target metadata, and explain any negative expectation. Update `evaluate` and its tests when introducing a separately observable stage or real workspace acceptance. Do not infer successful stages from diagnostics or skip unsupported constructs to improve totals.

The first blockers are the remaining file-parser grammar, parameterized/conditional module dependencies, compile-time assertion diagnostics, aggregate semantics and compiler workspaces. Once those work, extend curated roots through LLVM output before approving native linking. A whole-corpus run is optional while those foundational blockers dominate.

## Configuration

`--compiler` selects a repository `target/.../jai-rs`; `--manifest` selects an acceptance JSON manifest; `--report` selects local output. `--through` is `lex`, `parse`, `check`, `codegen` or `build` (default `check`). `--select` repeats exact source IDs and overrides the default case selection; `--all` selects all pinned sources when no explicit selections exist. `--timeout` bounds each subprocess (default ten seconds). Read-only source roots cannot contain report output. Module search paths can be supplied through platform-separated `JAI_RS_MODULE_PATH`. Target/workspace configuration is still pending; dependency/target metadata describe acceptance requirements rather than proven SDK availability.

## Dependencies

Python 3.11+ standard library, our Rust CLI, `corpus/reference-inputs.json`, `corpus/upstreams.json`, read-only `reference/` and fetched `corpus/upstream/`. No new Python or Cargo dependency is needed. Approved native builds additionally need trusted `/usr/bin/clang`. SDKs, genuine native bindings and Compiler workspace APIs remain project-specific blockers. See [reference compatibility](reference-compatibility.md) and [upstream corpus](upstream-corpus.md).
