# Corpus breadth frontier

## What it is

This records the next complete source sweep after the [earlier baseline](corpus-breadth-baseline.md). It measures language stages separately; it does not establish full standard-library or application builds.

## How it works

The frozen cohort contains 702 supplied reference files, 1,440 files from seven pinned upstream projects, and 461 independently authored library/prelude inputs. All 2,603 input identities and bytes match the earlier cohort. The latest sweep uses compiler commit `210b1c53b8aee9b266b6c21a7ab1053dfa5c770d` and its immutable executable with SHA256 `fb4c0f70df0e0d481a5a788809a12ab4d09099a9683836c50b7c6dfb62fb28f2`. The exact committed tree also passed workspace/all-targets, formatting and 82 focused tests.

| Stage and cohort | Earlier baseline | Parser010 | Latest checkpoint |
| --- | ---: | ---: | ---: |
| Full tokenization, all inputs | 2,603 / 2,603 | 2,603 / 2,603 | 2,603 / 2,603 |
| Complete AST, reference and upstream inputs | 1,799 / 2,142 | 1,862 / 2,142 | 1,901 / 2,142 |
| Complete AST, authored library/prelude inputs | 436 / 461 | 448 / 461 | 448 / 461 |
| Complete AST, combined | 2,235 / 2,603 | 2,310 / 2,603 | 2,349 / 2,603 |
| Body checks, reference and upstream inputs | 101 / 2,142 | 103 / 2,142 | Not rerun |
| Pinned library roots accepted | 43 / 253 | 44 / 253 | Not rerun |
| Authored library roots accepted | 19 / 128 | 19 / 128 | Not rerun |

The latest AST sweep gains 39 files against Parser010 with no regressions, an improvement of 114 files against the original baseline. Its 254 raw AST rejections still include the two explicit negative witnesses. Counts use actual stage exit codes, without shrinking the cohort or relabeling failures as acceptance. Parser success does not establish correct rejection at a later stage, platform support or executable behavior.

The earlier reference/upstream body sweep recorded 103 passes, 1,758 failures, one expected negative and 280 parse-blocked files. These were separate single-file graph checks with NoEffects and the supplied Preload. Those results describe the earlier compiler, not a new semantic sweep of this checkpoint or the independently authored bootstrap profile. Full authored-library execution and all seven upstream application builds remain incomplete.

The 461 authored inputs are the frozen compatibility snapshot, which includes work held for integration. They are not a claim that every file in that private snapshot is present in the public compiler checkout. Source snapshots and supplied input bytes remain local.

## How to change it

Implement a coherent grammar or semantic feature, build a real immutable compiler snapshot, then rerun `tools/check_corpus.py` against the same frozen inputs. Compare source hashes and compiler build receipts before comparing counts. Add a new cohort explicitly when source inputs change; never silently shrink the denominator or reinterpret an unsupported result as acceptance.

The latest local evidence is `artifacts/integration-recovery/corpus-210b1c5-20261003/proof.json` (SHA256 `938f78a11c3e1a9546680d2151080af84c64467399b1d9c829215279e33b2d4c`). Adjacent `results.json` and `inputs-before.json` retain actual per-file commands, diagnostics and unchanged source identities. The earlier Parser010 evidence remains at `artifacts/agent-packets/driver-parser-bake-20261003/corpus-010/complete-cohort-proof.json`. Its grammar census grouped 293 rejections into 58 feature families; that classification adds no successful compilation claims and is not a fresh census of the remaining 254.

## Configuration

Use the pinned project manifests and target/profile selections documented in [corpus acceptance](corpus-acceptance.md). Lexer/parser sweeps perform no reference-binary execution. Body/library checks retain NoEffects, the selected bootstrap mode, explicit platform parameters and execution budgets. A successful dormant branch or one host profile does not prove other profiles.

## Dependencies

The harness uses the repository's owned `jai-cli`, Python 3.11 or newer, source snapshots and pinned upstream manifests. Supplied reference files are external compatibility inputs. See [upstream corpus](upstream-corpus.md), [standard-library API coverage](stdlib/api-coverage.md), and [dependency policy](dependency-policy.md) for source provenance and the separate library/dependency requirements.
