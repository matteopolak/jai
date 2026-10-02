# Corpus feature inventory and acceptance contracts

## What it is

Two complementary tools track compatibility without executing supplied tooling. `tools/inventory_corpus_features.py` inventories feature spellings in pinned source; `tools/check_feature_matrix.py` asserts small self-written language contracts using our Rust compiler and, when selected, generated native programs.

Neither tool establishes full standard-library compilation, SDK availability or successful upstream project builds. The full pinned corpus remains covered by the separate [staged corpus harness](corpus-acceptance.md).

## How it works

The static inventory verifies every source SHA-256 against `corpus/reference-inputs.json` and `corpus/upstreams.json`, then scans 702 supplied reference sources and 1,440 upstream sources. It masks nested comments and ordinary quoted strings, preserving line numbers. The report records patterns, per-project file counts, per-source counts, and samples containing only source IDs, line numbers, revisions and hashes. It contains no source excerpts and performs no compiler invocation or upload.

This is a lexical inventory: it does not build ASTs for unsupported source. Custom here-string bodies can cause false positives, and invalid legacy UTF-8 bytes are replaced solely for scanning. Those limitations are recorded in the output. A static spelling match never means the feature parses, checks or executes correctly.

The 2026-10-01 fingerprint-verified inventory found these file counts:

| Feature spelling | Files |
| --- | ---: |
| Module parameters | 53 |
| Conditional compilation | 388 |
| Compile-time `#run` | 411 |
| Compile-time `#assert` | 173 |
| Source insertion | 161 |
| Polymorphic variables | 304 |
| Structs / unions / enums | 971 / 145 / 412 |
| Fixed arrays / slices / dynamic arrays | 595 / 462 / 389 |
| Pointer type or address / dereference | 1,434 / 527 |
| Floating types / string types | 503 / 824 |
| Context / foreign ABI | 190 / 387 |
| Reflection / compiler workspace API | 445 / 79 |

`tests/corpus/manifest.json` independently defines handwritten fixtures and their exact source fingerprints. These are acceptance contracts, not extracted reference programs. The core suite covers integer control flow, short circuit effects and recursion. The expanded suite covers floats, aggregates, sequences, pointers, generics, overloads, named/default calls, multiple results, enums, unions, `using`, compile-time calls, reflection, insertion, conditional source, parameterized imports and deferred cleanup. Expanded failures identify missing behavior; there is no unsupported-feature waiver.

Positive fixtures must pass the selected stages in order: lex, parse, check, LLVM generation, trusted native build and exact runtime assertions. Generated programs return small exit codes rather than requiring `Basic`, printing helpers or SDKs. Runtime requires a regular nonsymlink executable whose SHA-256 matches successful BUILD evidence, checks the same hash again after execution, and verifies exit code, stdout and stderr independently with a timeout. A stale, replaced or nonexecutable artifact fails without being treated as runtime evidence. Native execution is bounded host execution; it is not a VM isolation guarantee. Only the small reviewed generated fixture is executed. The harness never runs upstream build scripts or supplied binaries, objects or libraries.

Negative fixtures assert specific unknown runtime/compiler/reflection names, unknown named arguments, illegal assignment places, malformed strings and explicitly named unknown directives. The unknown-directive contracts require a specific located diagnostic and now pass on the recorded baseline; a generic parser error does not satisfy them. A rejection at an earlier stage, unrelated diagnostic, crash or timeout fails the contract. Selecting fewer stages than the intended negative rejection cannot produce a successful negative result. Unknown compile-time/compiler calls are expected to reject, rather than becoming a generic successful “unsupported” outcome.

The runner reuses staged evidence and classification from `tools/check_corpus.py`, but native behavior belongs only to the fixture runner. Corpus runtime remains blocked under its own review policy. Both reports retain `project_build_successes: 0`.

The 2026-10-02 baseline on repository-built CLI SHA-256 `056ff16f254c41b179c5d5c0fe69990c3960aa01b348752c76f72cda88305d5c` passed all 27 positive contracts through exact native assertions and all 10 intended negative diagnostics. The local evidence is `artifacts/feature-matrix-2026-10-02.json`. The expanded 40-contract matrix subsequently passed on the same immutable binary snapshot: 30 positives through exact native assertions and 10 intended negative rejections. Its local report is `artifacts/feature-matrix-expanded-current.json`, including ordered-results and context/C-callback contracts. The fresh integrated CLI SHA-256 `737a864b5ae08c2fe5bc94e5454ba72eadd0b23118dc0fd2625857ad2fe8a73b` checked all 34 positive contracts and passed 33 through exact native behavior; all 10 intended negatives passed. Baked record defaults and operator overloads now passed native execution. One short-circuit fixture failed LLVM verification with a terminator inside `cast.pass`; the parent owns the code-generation fix and the unchanged exit-code-12 contract remains required. The preserved local report is `artifacts/feature-matrix-737a864b-current.json`. These results establish small fixture behavior only; [newer-project requirements](project-requirements.md) and full standard-library/project gates remain independent.

The later immutable CLI SHA-256 `8a52b33b52753562e987b37ec8274548e019aa62b7b611d5c432c0f5c3e00489` checked all 36 positive contracts and passed 35 through exact native behavior; all 10 intended negative contracts passed. The unchanged short-circuit contract now passed with exit code 12. The remaining native failure was the indexed getter/setter update contract, which expected 11 and returned 0 on this snapshot. Its subsequent lowering changes require a new compiler build and acceptance run. The preserved report is `artifacts/feature-matrix-8a52b33b.json`; full project builds remain independent and unverified.

The fresh immutable CLI SHA-256 `43b1705dd388ff63d71089ea0d542ac713da9e2bf547b86908d94d81ea66be64` passes all 46 active contracts: 36 positives through exact native behavior and 10 intended rejections. The unchanged indexed update fixture now returns 11 with its required evaluation order. The preserved report is `artifacts/feature-matrix-43b1705d.json`. This complete feature matrix remains separate from the unfinished full-library and application gates.

The unchanged 46-contract matrix now passes on immutable CLI SHA-256 `43b1705dd388ff63d71089ea0d542ac713da9e2bf547b86908d94d81ea66be64`: 36 positives through exact native behavior and 10 intended negatives at their required stages. The indexed getter/setter update returns its required 11. The preserved report is `artifacts/feature-matrix-43b1705d.json`, including matching successful BUILD and RUN fingerprints. This does not establish full library or project builds.

## How to change it

`tests/corpus-proposals/manifest.json` keeps additional independently authored contracts outside the active matrix. Each proposal records exact source SHA-256, an assigned owner, intended observable behavior and pinned related source evidence. The six initial proposals cover direct short lambdas, lexical `using` mutation, void-pointer byte distance, embedded-NUL string equality, implicit `ifx` true values and runtime record metadata. Their intended outputs are not compiler or native acceptance evidence. Review and run every stage before moving a proposal into `tests/corpus/`; the active manifest's dependency allowlist deliberately excludes this separate directory. The local `artifacts/feature-contract-audit-8a52b33b.json` audits all 46 active fingerprints, their recorded stages, sixteen broader requirement groups and these proposal fingerprints against all 2,142 source pins.

Two subsequent structural-interface proposals add a positive member-access result and a missing-member semantic negative. Both wait for the frontend restricted-type AST and canonical polymorphic matcher. The negative's exact matcher text is intentionally pending its owner; it is not an executable acceptance case, and an unsupported parser diagnostic never counts as its intended rejection. Keep the immutable audit's original six-proposal fingerprint separate from later proposal-manifest revisions.

Add a small independently written `.jai` fixture under `tests/corpus/positive/` or `negative/`, then add its manifest row with the SHA-256 of the exact UTF-8 bytes. Use `support_sources` to fingerprint any self-written transitive source dependency, and explicitly review the whole reachable fixture before setting `host_build_reviewed: true`. Do not add SDK bindings, corpus objects, foreign libraries or upstream scripts to these host fixtures.

Use `suite: expanded` for a new desired feature contract until it is demonstrated through the CLI stages. Keep `suite: core` small and proven before enabling it in CI. Do not promote a fixture based only on a flat parser, direct semantic unit test or static corpus occurrence. CI can separately invoke the core matrix through `run`, and precise negatives through `check`; enabling the full expanded suite requires its actual observed acceptance.

Update `FEATURES` in the static scanner for new inventory spellings and document false-positive limits. If AST-level inventory is added later, record parse failures and lexical fallback separately; do not call a fallback AST evidence. Keep upstream source references pinned to their manifest revision rather than silently substituting older documentation examples.

## Configuration

```sh
python3 tools/inventory_corpus_features.py
python3 tools/check_feature_matrix.py --suite core --through run
python3 tools/check_feature_matrix.py --suite negative --through check
python3 tools/check_feature_matrix.py --suite expanded --through check
python3 tools/check_feature_matrix.py --select reflection-layout --through run
python3 -m unittest discover -s tools -p test_feature_matrix.py
```

Static output defaults to `artifacts/corpus-features.json`. Matrix output defaults to `artifacts/feature-matrix.json`; both accept `--report`. Matrix `--compiler` must resolve to our `target/.../jai-rs`, `--through` defaults to `check`, `--suite` defaults to `all`, and repeated `--select` values select exact fixture IDs. `--timeout` defaults to ten seconds per invocation. These pure feature fixtures use the recorded diagnostic profile with `JAI_RS_PRELOAD=off` and `JAI_RS_RUNTIME_SUPPORT=off`; actual supplied Preload/runtime and standard-module acceptance use separate corpus gates. Host builds inherit the staged harness's trusted `/usr/bin/clang` override. Reports cannot overwrite reference/upstream sources; matrix reports also cannot overwrite fixtures.

Source and binary fingerprints are independent: they do not prove that a stale binary was built from the current sources. Rebuild the Rust CLI before claiming current matrix acceptance. Static inventory and Python harness tests do not require the compiler to build.

## Dependencies

Python standard library, the pinned corpus manifests, `tools/check_corpus.py`, and the self-written fixture manifest. Actual compiler stages require the repository-built Rust CLI; native stages require a trusted host C/LLVM toolchain. No external Python library, original compiler, original linker, supplied library or supplied object is used.
