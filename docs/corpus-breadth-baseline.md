# Corpus breadth baseline

## What it is

The breadth checkpoint measures complete original source files through separate lexer, AST, body-check, application and LLVM stages. It covers all seven locked modern projects, the 702 reference Jai files, and every authored standard-library source, without replacing project roots with smaller examples.

## How it works

The 2026-10-03 checkpoint uses the integrated Rust CLI SHA-256 `54eb0fd890e880454823a7edcf7e7c4d47242a5408ca4471ce9e22970d90a49c`. Its separate successful own-build receipt records 2,302 captured inputs. The frozen executable, build receipt, captured inputs, source pins and measured source hashes were rechecked. The corpus runner's observed working-tree fingerprint remains separate from that build provenance.

`tools/check_corpus.py` inventories and runs the 2,142 pinned sources. Its existing `execute` and `evaluate` APIs also run a complete frozen source-only copy of the authored tree: 453 standard-library files and eight supplemental prelude files. Every complete file reaches the lexer and, after lexical success, the full file parser. No passing suffix, truncated AST, replacement import or skipped unsupported member counts as acceptance.

All 2,603 files tokenize. Full AST parsing passes 2,235 and fails 368. The full pinned body-check profile uses actual reference Preload, disables Runtime Support and compiler effects, and passes 101 body checks, produces one intended rejection, fails 1,697 and leaves 343 unattempted after root AST failures. Support-file body checks are diagnostic coverage, not whole-project compilation.

Genuine library roots are separate cohorts: 43 of 253 pinned roots pass checking; 19 of 128 authored entrypoint files pass with actual authored Preload. Those authored files represent 125 distinct module names; three names have both flat-file and directory entrypoints. Their actual flat-file search preference is recorded separately, and alternate entrypoint checks do not imply both are selected by an import. The authored runtime-library profile selects Runtime Support with entry disabled, initialization enabled and backtrace disabled; none of its 128 roots passes. Its exact failures remain in the report rather than being counted as successful unsupported-feature rejections.

The 13 curated pinned application/metaprogram roots have 12 full AST passes, eleven check failures and one intended negative rejection. None establishes a complete project build. The separately reviewed unchanged book `examples/30/main5.jai` passes application checking and fresh LLVM emission. The 46 authored feature controls satisfy all their stage contracts: 36 emit LLVM, and ten match intended ordinary diagnostic rejections at one lexical, three parser and six checker stages. These small controls do not establish project breadth.

Measured reports and the joined matrix are under `artifacts/agent-packets/backend-types-recovery/corpus-breadth-20261003/`. `breadth-stage-matrix.json` preserves each source, profile, stage result, command, source hash, compiler identity and prerequisite. `breadth-stage-matrix.md` gives project totals and the blocker matrix. The existing source-free renderer also produces `source-free-stage-summary.json` and `.md`.

`tools/classify_corpus_failures.py` groups exact first diagnostics and verifies their real dependency origins. The full pinned check sweep has 246 groups with no stale source locations. In that measurement, `Basic/Apollo_Time.jai:471:15` blocks 565 roots; OpenJai `Basic/module.jai:168:59` blocks 340. Similar diagnostic text can have different causes. The feature matrix uses the existing lexical scanner; a feature spelling in a failed file does not prove that feature caused its first failure.

## How to change it

Keep the pinned inventory and the acceptance contracts in their existing tools and manifests. Rebuild our integrated CLI, freeze it by its actual binary hash, then rerun the full file set and selected genuine roots. Use a new report directory when compiler or authored source bytes change. The private adapters only join existing runner APIs; do not fork a second parser or acceptance harness.

Extend explicit entrypoint manifests when a genuine application, module parameter combination or reviewed target becomes available. Preserve bootstrap profiles and target requirements separately. A downstream stage blocked by a failed prerequisite has no compiler invocation or artifact. Linking and runtime need their own reviewed providers and behavior contracts; this source/LLVM checkpoint executes neither.

Keep authored negative intent in `tests/corpus/manifest.json` with exact source fingerprints and expected stage diagnostics. An earlier dependency failure, signal, timeout or unrelated unsupported construct cannot satisfy a negative contract. Upstream or unlisted test intent remains unreviewed until a real contract is recorded.

## Configuration

Dedicated frontend subprocesses use a twelve-second bound; checking and LLVM profiles use twenty seconds per stage. Runners are sequential within each cohort. There is no Cargo invocation, native link or generated-program execution in this checkpoint.

Pinned semantic profiles retain each project's real nearby module directories followed by the reference module directory. Authored profiles select the complete frozen authored module tree and its actual Preload. Runtime Support is either explicitly disabled or selected with `JAI_RS_RUNTIME_ENTRY=0`, `JAI_RS_RUNTIME_INITIALIZATION=1` and `JAI_RS_RUNTIME_BACKTRACE=0`.

The native target is the CLI-selected host. Manifest target labels describe requirements; they do not certify other SDKs, operating systems, ABI configurations or native libraries. Modern source revisions stay locked by `corpus/upstreams.json` and remain authoritative over older incompatible syntax examples.

## Dependencies

Python's standard library, the repository-built integrated CLI, `tools/check_corpus.py`, `tools/check_standard_libraries.py`, `tools/inventory_corpus_features.py`, `tools/classify_corpus_failures.py`, and `tools/summarize_acceptance.py`. Inputs are the pinned reference/upstream manifests and actual authored source files. No reference compiler, original executable, native object, supplied library or upstream build script is used.

See [staged corpus acceptance](corpus-acceptance.md), [stage report rendering](corpus-stage-reports.md), and [recent upstream source pins](upstream-corpus.md).
