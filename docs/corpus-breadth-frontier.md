# Corpus breadth frontier

## What it is

This records the next complete source sweep after the [earlier baseline](corpus-breadth-baseline.md). It measures language stages separately; it does not establish full standard-library or application builds.

## How it works

The frozen cohort contains 702 supplied reference files, 1,440 files from seven pinned upstream projects, and 461 independently authored library/prelude inputs. All 2,603 input identities and bytes match the earlier cohort. Parser010 uses the real compiler executable with SHA256 `fb3f1df155920006414fd6894d8af5c6b5fdfb546c86fa4a0e92a563a6292aca` and compiler-source manifest `3ef446d7ad056b01d9a2025d422ef5188c1c35e3257b065f7dbfeb19f133723c`. The parser implementation is included in compiler commit `2fd03f13084cefec0af811455d968ecd54a86547`; that commit also integrates browser, ABI and fuzz work, so its binary is not asserted identical to the earlier sweep executable.

| Stage and cohort | Earlier baseline | Parser010 |
| --- | ---: | ---: |
| Full tokenization, all inputs | 2,603 / 2,603 | 2,603 / 2,603 |
| Complete AST, reference and upstream inputs | 1,799 / 2,142 | 1,862 / 2,142 |
| Complete AST, authored library/prelude inputs | 436 / 461 | 448 / 461 |
| Complete AST, combined | 2,235 / 2,603 | 2,310 / 2,603 |
| Body checks, reference and upstream inputs | 101 / 2,142 | 103 / 2,142 |
| Pinned library roots accepted | 43 / 253 | 44 / 253 |
| Authored library roots accepted | 19 / 128 | 19 / 128 |

The AST improvement is 75 files with no regressions against the intervening Parser005 sweep. The 293 raw AST rejections include two explicit negative witnesses; they are retained as failures at their observed stage. Parser success alone does not establish correct rejection at a later stage, platform support, or executable behavior.

The reference/upstream body sweep has 103 passes, 1,758 failures, one expected negative, and 280 files blocked by parsing. These are separate single-file graph checks with NoEffects and the supplied Preload. They are not the independently authored bootstrap profile and do not count successful project builds. The authored 128-root check remains at 19 passes. Full authored-library execution and all seven upstream application builds remain incomplete.

The 461 authored inputs are the frozen compatibility snapshot, which includes work held for integration. They are not a claim that every file in that private snapshot is present in the public compiler checkout. Source snapshots and supplied input bytes remain local.

## How to change it

Implement a coherent grammar or semantic feature, build a real immutable compiler snapshot, then rerun `tools/check_corpus.py` against the same frozen inputs. Compare source hashes and compiler build receipts before comparing counts. Add a new cohort explicitly when source inputs change; never silently shrink the denominator or reinterpret an unsupported result as acceptance.

The local evidence is `artifacts/agent-packets/driver-parser-bake-20261003/corpus-010/complete-cohort-proof.json` (SHA256 `930aacd694741600abed06a986f8de646bd1797ef0c3a802cbbd260f5e0b4e6c`). Its adjacent reports retain actual per-file commands and diagnostics. The independent grammar census groups the 293 rejections into 58 feature families for implementation; that classification adds no successful compilation claims.

## Configuration

Use the pinned project manifests and target/profile selections documented in [corpus acceptance](corpus-acceptance.md). Lexer/parser sweeps perform no reference-binary execution. Body/library checks retain NoEffects, the selected bootstrap mode, explicit platform parameters and execution budgets. A successful dormant branch or one host profile does not prove other profiles.

## Dependencies

The harness uses the repository's owned `jai-cli`, Python 3.11 or newer, source snapshots and pinned upstream manifests. Supplied reference files are external compatibility inputs. See [upstream corpus](upstream-corpus.md), [standard-library API coverage](stdlib/api-coverage.md), and [dependency policy](dependency-policy.md) for source provenance and the separate library/dependency requirements.
