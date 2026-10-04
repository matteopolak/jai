# Corpus breadth frontier

## What it is

This records the next complete source sweep after the [earlier baseline](corpus-breadth-baseline.md). It measures language stages separately; it does not establish full standard-library or application builds.

## How it works

The frozen cohort contains 702 supplied reference files, 1,440 files from seven pinned upstream projects, and 461 independently authored library/prelude inputs. All 2,603 input identities and bytes match the earlier cohort. The latest sweep uses compiler commit `878c0eae7fbc47d3e264e8c25264964fcefe6cf3` and its immutable executable with SHA256 `5feceae460d2b7ee889f1e85e4d3899432beeba649bc33fcac75f09abeb008e8`. The exact committed tree also passed workspace/all-targets, formatting and 135 focused tests.

| Stage and cohort | Earlier baseline | Parser010 | Previous checkpoint | Latest checkpoint |
| --- | ---: | ---: | ---: | ---: |
| Full tokenization, all inputs | 2,603 / 2,603 | 2,603 / 2,603 | 2,603 / 2,603 | 2,603 / 2,603 |
| Complete AST, reference and upstream inputs | 1,799 / 2,142 | 1,862 / 2,142 | 1,901 / 2,142 | 2,001 / 2,142 |
| Complete AST, authored library/prelude inputs | 436 / 461 | 448 / 461 | 448 / 461 | 450 / 461 |
| Complete AST, combined | 2,235 / 2,603 | 2,310 / 2,603 | 2,349 / 2,603 | 2,451 / 2,603 |
| Body checks, reference and upstream inputs | 101 / 2,142 | 103 / 2,142 | Not rerun | Not rerun |
| Pinned library roots accepted | 43 / 253 | 44 / 253 | Not rerun | Not rerun |
| Authored library roots accepted | 19 / 128 | 19 / 128 | Not rerun | Not rerun |

The latest AST sweep gains 102 files against the previous checkpoint with no regressions, an improvement of 216 files against the original baseline. Its 152 raw AST rejections include negative compatibility inputs. Counts use actual stage exit codes, without shrinking the cohort or relabeling failures as acceptance. Parser success does not establish correct rejection at a later stage, platform support or executable behavior.

The broader workspace test run of this checkpoint compiled successfully and recorded 3,852 passing tests, 81 failures and eight ignored tests across 350 target summaries. The one lexer test requiring an external reference directory was explicitly filtered in that public-checkout run; all 702 reference sources were separately tokenized in the corpus sweep. Seven failing tests lacked four local corpus fixtures. The remaining failures include fixture API mismatches and compiler defects, so the full workspace is not green. Its unchanged-source proof is `artifacts/agent-packets/grammar-integration-210b1c5-20261003/revision-008/full-workspace-current-head/gate-001/proof.json` (SHA256 `2b08cee7b277b149c1200de6f06b26bff8969cac2aca658a902a869bb86d785a`).

The earlier reference/upstream body sweep recorded 103 passes, 1,758 failures, one expected negative and 280 parse-blocked files. These were separate single-file graph checks with NoEffects and the supplied Preload. Those results describe the earlier compiler, not a new semantic sweep of this checkpoint or the independently authored bootstrap profile. Full authored-library execution and all seven upstream application builds remain incomplete.

The 461 authored inputs are the frozen compatibility snapshot, which includes work held for integration. They are not a claim that every file in that private snapshot is present in the public compiler checkout. Source snapshots and supplied input bytes remain local.

## How to change it

Implement a coherent grammar or semantic feature, build a real immutable compiler snapshot, then rerun `tools/check_corpus.py` against the same frozen inputs. Compare source hashes and compiler build receipts before comparing counts. Add a new cohort explicitly when source inputs change; never silently shrink the denominator or reinterpret an unsupported result as acceptance.

The latest local evidence is `artifacts/integration-recovery/corpus-878c0ea-20261004/proof.json` (SHA256 `8c429c81cb98a561d00d1905a334868e260dfe0a540d784b14841d01b188f40c`). Adjacent `results.json` and `inputs-before.json` retain actual per-file commands, diagnostics and unchanged source identities. The earlier Parser010 evidence remains at `artifacts/agent-packets/driver-parser-bake-20261003/corpus-010/complete-cohort-proof.json`. Its grammar census grouped 293 rejections into 58 feature families; that classification adds no successful compilation claims and is not a fresh census of the remaining 152. A separate read-only classification of the same parsing results groups the 152 first diagnostics into 36 feature families; first diagnostics can hide later missing constructs.

## Configuration

Use the pinned project manifests and target/profile selections documented in [corpus acceptance](corpus-acceptance.md). Lexer/parser sweeps perform no reference-binary execution. Body/library checks retain NoEffects, the selected bootstrap mode, explicit platform parameters and execution budgets. A successful dormant branch or one host profile does not prove other profiles.

## Dependencies

The harness uses the repository's owned `jai-cli`, Python 3.11 or newer, source snapshots and pinned upstream manifests. Supplied reference files are external compatibility inputs. See [upstream corpus](upstream-corpus.md), [standard-library API coverage](stdlib/api-coverage.md), and [dependency policy](dependency-policy.md) for source provenance and the separate library/dependency requirements.
