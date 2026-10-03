# Bounded compiler and interpreter fuzzing

## What it is

`fuzz/` is a standalone cargo-fuzz workspace for the LLVM-free compiler core and checked interpreter. It combines raw mutated source with structured, valid typed programs and independent result oracles. Fuzzing complements behavior tests and benchmarks; a short completed campaign does not establish exhaustive coverage or language compatibility.

## How it works

| Target | Input and checks |
| --- | --- |
| `lexer_utf8` | Raw bytes, source decoding, Unicode token/error span boundaries, ordered spans and deterministic lexing |
| `parser` | Mutated UTF-8/UTF-16 source admitted under the parser budget, successful AST construction or source-valid diagnostics |
| `module_vfs` | Up to four NUL-separated virtual source files, closed module loading, semantic diagnostics with actual `SourceSpan`, bounded compile-time execution and Runtime-phase VM execution |
| `constant_sema` | Structured constant aliases, Boolean conditional arithmetic and a pure `#run` loop; independent integer checksum and repeated isolated script execution |
| `checked_ir_vm` | Typed record construction/copy/projection, bounded arithmetic expressions, mandatory IR verification, host/browser byte layouts, reused VM cleanup and separate low-fuel rollback |

`module_vfs` names the first file `main.jai` and subsequent files `part-1.jai` through `part-3.jai`. It uses the runtime's closed `SourceBundle` provider, which never falls back to the host filesystem. Semantic evaluation and VM execution use `NoEffects`; no filesystem roots, process registrations, foreign-function adapters or native libraries are granted. Jai inputs execute exclusively in the bounded interpreter. The dependency graph excludes the native LLVM backend and driver, so no attacker-controlled Jai source is lowered, loaded, linked or executed as native code. The trusted Rust/libFuzzer/AddressSanitizer tooling is distinct from Jai execution.

Raw sources are limited to 128 KiB total. Parser admission additionally allows at most 256 tokens and 32 tokens that can introduce recursion. This conservative harness filter is explicit; it is not a compiler rejection rule or a proof that unrestricted parsing is safe. Lexer fuzzing still accepts the larger token/depth inputs. VM limits are 50,000 fuel, stack depth 32, evaluation depth 64, 64 allocations and 4,096 value cells. Structured generators limit aliases/operations to 16 and record fields to eight. Source errors, pending dependencies and resource rejection are valid raw-input outcomes; structured success oracles must complete with their calculated result.

Authored seeds live in `fuzz/seeds/`. Deterministic tests invoke the exact same public harness entrypoints. `tools/run_fuzz.py` freezes authored compiler/prelude/harness inputs into its own source snapshot, verifies dependency ages, fetches the locked graph and invokes cargo-fuzz with AddressSanitizer. cargo-fuzz 0.13.2 has no locked-build option, so a temporary Cargo adapter adds `--locked --offline` to its internal build/metadata calls. The adapter delegates to the independently installed real Cargo and changes no source behavior. Each campaign copies seeds into a separate writable working corpus; it never mutates committed seeds.

The runner requires at least 2 GiB free on both the source-artifact and target-cache volumes before building, during active builds/runs, and after each target. `--target-dir` may select a separate build volume; both paths are recorded in the campaign metadata. It retains commands, source hashes, driver hash, own executable copies/hashes, output logs, generated corpora and crash inputs in `artifacts/fuzz/<timestamp>/`. A run becomes valid only after libFuzzer reports actual completed executions for every selected target. Compilation alone cannot satisfy that check. Source/tool/lock changes invalidate a campaign; live-tree edits after snapshot capture are recorded separately. Initial invalid metadata survives failed builds. CI bounds each target by 1,000 runs or 15 seconds, limits individual inputs to three seconds and RSS to 1,024 MiB, and uploads only logs/metadata and own generated input findings, excluding source snapshots and executables.

Source capture shares `benchmark.source_hashes` and its verified copy routine, including the compiler-owned prelude and build-path helper. Fuzz-file exclusions are relative to the `fuzz/` directory, so a retained checkout under `artifacts/` still captures its real `Cargo.lock`, targets and authored seeds. Generated `fuzz/target`, `fuzz/corpus` and `fuzz/artifacts` outputs stay excluded. Build directory selection shares the [build storage](build-storage.md) helper; no private artifact ROOT override belongs in the production runner.

## How to change it

Change harness logic under `fuzz/src/`, the small engine entrypoints under `fuzz/fuzz_targets/`, and authored seeds together. Keep typed generators within proof boundaries and calculate expected results independently of VM helpers. Preserve closed providers, `NoEffects`, interpreter-only execution and explicit resource limits. Do not add original distribution sources or native artifacts to seed directories.

Minimize a confirmed finding with cargo-fuzz `tmin`, replay it with the retained own executable, then add a small deterministic regression and an authored/minimized seed. Keep resource-limit findings distinct from semantic failures. The raw parser filter intentionally excludes some deep/large inputs; extend it only with parser depth/resource support and corresponding bounded regressions. The module provider can follow the shared platform VFS through `SourceBundle` without granting native host capabilities.

## Configuration

```sh
# Before any dependency build script runs:
python3 tools/check_dependency_age.py --lockfile fuzz/Cargo.lock
python3 tools/check_cargo_fuzz_age.py
cargo install cargo-fuzz --version '=0.13.2' --locked -j 1

# Deterministic seed replay; no LLVM installation is needed.
RUSTC_WRAPPER= CARGO_INCREMENTAL=0 \
  cargo test --manifest-path fuzz/Cargo.toml --locked -j 1

# All targets, or select --target lexer_utf8/parser/module_vfs/constant_sema/checked_ir_vm.
RUSTC_WRAPPER= python3 tools/run_fuzz.py --runs 1000 --seconds 15 --rss-mb 1024
```

Use the repository's pinned nightly. `--target-dir` overrides `CARGO_TARGET_DIR` and Cargo’s configured target directory. Without an override, the runner follows those Cargo settings, including an external SSD target; it does not force an internal `target/fuzz` directory. Serialize builds that share a cache and keep aggregate CPU/RAM bounded when using separate targets. Protected original input trees cannot be used as the cache. `fuzz/Cargo.lock` is separate from the main workspace lock; generate it with the native 14-day Cargo policy and verify it again whenever dependencies change. Generated default cargo-fuzz corpus, artifacts, coverage and target paths are gitignored. `.github/workflows/fuzz.yml` runs bounded checks for relevant changes and supports reviewed manual invocation; it has no performance or coverage threshold.

The retained seed-PASS source checkpoint based on `8bb` completed all five AddressSanitizer targets on 2026-10-03: 1,000 executions each for lexer, parser, module VFS and checked IR/VM, plus 47 constant-semantic executions before its 15-second limit. All targets exited successfully with no crash artifacts; `artifacts/integration-recovery/fuzz-asan-20261003/verification-summary.json` records the exact source, runner, lock and tool hashes. This is evidence for that frozen checkpoint, not a later HEAD or exhaustive coverage. The coalesced build-path/snapshot tooling separately passes 37 Python tests, including nine runner tests; those tests do not execute Cargo or libFuzzer.

## Dependencies

The runner and age tools require Python 3.11 or newer. The latest eligible releases verified against official crates.io records on 2026-10-02 are `libfuzzer-sys` 0.4.13 (published 2026-06-04) and cargo-fuzz 0.13.2 (published 2026-06-09). The standalone lockfile's ten external packages passed the full publication-age checker before building. `check_cargo_fuzz_age.py` validated the official tool archive checksum and all 100 embedded locked registry dependencies; CI repeats that check before installing the tool. Independently installed Clang/Clang++ build libFuzzer; LLVM backend libraries are not needed for the Jai core. The runner refuses build tools inside protected original trees and clears injected compiler/header/library flags.

Workflow/reference documentation: [Rust Fuzz Book setup](https://rust-fuzz.github.io/book/cargo-fuzz/setup.html), [cargo-fuzz guide](https://rust-fuzz.github.io/book/cargo-fuzz/guide.html), [structured fuzzing](https://rust-fuzz.github.io/book/cargo-fuzz/structure-aware-fuzzing.html) and [libFuzzer options](https://llvm.org/docs/LibFuzzer.html#options). See [dependency policy](dependency-policy.md), [scripting interpreter](scripting-runtime.md) and [benchmarks](benchmarks.md) for the separate execution, dependency and performance evidence boundaries.
