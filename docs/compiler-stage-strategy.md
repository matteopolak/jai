# Compiler stage strategy

## What it is

Compatibility work advances across the complete pinned source corpus, with separate results for tokenization, parsing, semantic checking, code generation, linking, and execution. Later stages continue in parallel while earlier stages gain coverage.

## How it works

`corpus/upstreams.json` identifies the selected recent projects and their exact source hashes. The reference sources and independently rewritten library are separate inputs. Newer project syntax and public library contracts guide compatibility when they differ from the local reference.

The progression is:

| Stage | Required evidence | Common next work |
| --- | --- | --- |
| Tokenization | Every inventoried source decodes and produces tokens | Literal forms, directives, comments, encodings |
| Parsing | Complete files produce the real AST, with no discarded suffix | Grammar, declaration forms, expression precedence |
| Semantic checking | Actual module and application roots resolve with their dependencies | Types, overloads, generics, compile-time operations, library APIs |
| Code generation | Checked programs produce verified LLVM modules or executable interpreter programs | ABI, layouts, storage, calls, lowering |
| Linking | Own generated objects link against reviewed dependencies | Platform services, source-built native libraries |
| Execution | The exact generated artifact satisfies behavior assertions | Runtime correctness, integration, performance |

Each report records the compiler fingerprint, input fingerprints, configuration, stage outcomes, and diagnostics. A support file parsed alone does not establish a valid standalone application. Negative examples need reviewed expected diagnostics; an unexpected rejection remains a failure. Missing later-stage evidence remains unattempted or blocked.

Prioritize missing features that block many files or project roots. Preserve focused regressions for newly implemented behavior, then run the combined stage sweep. Cosmetic lint fixes and isolated edge cases should not displace broad implementation unless they prevent integration or hide a correctness defect.

The editor and language server consume the same source, token, AST, and diagnostic foundations. The browser interpreter, native LLVM backend, rewritten library, and platform adapters develop concurrently; browser support does not depend on native file access.

## How to change it

Reuse `tools/check_corpus.py`, `tools/classify_corpus_failures.py`, and the stage report renderer rather than adding a competing acceptance harness. Extend their typed stage outcomes when a new stage is measurable. Group failures by their underlying language feature and retain representative source locations for implementation owners.

Keep shared schemas and dependency boundaries explicit before parallel changes. Integrate coherent groups of producers and consumers, check the registered workspace, and run the affected behavior tests together. Preserve unfinished work separately from accepted commits.

## Configuration

The corpus lock selects source revisions. Acceptance manifests select genuine project roots, targets, dependencies, and reviewed negative cases. Runner stage limits, timeouts, bootstrap configuration, and compiler snapshots determine report scope; retain them with results.

Native builds use `/Volumes/CodexBuilds/targets/jai` on the T7-backed APFS volume. Corpus inspection uses our independently built compiler. Supplied reference binaries remain outside host execution.

## Dependencies

The existing corpus runners, pinned source manifests, Rust compiler crates, independent standard library, LLVM backend, and browser runtime provide the measured stages. See [staged corpus acceptance](corpus-acceptance.md), [stage reports](corpus-stage-reports.md), and [upstream corpus](upstream-corpus.md).
