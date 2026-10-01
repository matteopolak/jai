# Compiler benchmarks

## What it is

`jai-bench` measures compiler-stage time, source throughput, allocation counts/bytes, reallocations and maximum live allocation footprint. It provides baselines for later work on allocations and compiler speed.

## How it works

Generated workloads contain 4, 64 or 1,024 procedures, with locals, loops, scalar arguments and short-circuit logic. Benchmarks cover lexing, parsing (including lexing), semantic resolution, LLVM rendering and the full source-to-IR pipeline. Resolution and rendering reuse prepared immutable inputs outside the timed section.

Two additional benchmarks lex all local reference sources and all pinned recent upstream sources. Corpus loading and decoding happen before timing. These measure lexical work only; no upstream or reference program executes. Corpus parsing, module resolution, native linking and compile-time execution benchmarks must be added as those stages become available.

Divan's allocation profiler wraps the system allocator only in the benchmark executable. Counts distinguish allocation, deallocation and grow operations; do not confuse maximum live bytes with total allocated bytes. Profiling adds timing overhead. These single-thread measurements do not track allocations from unmanaged threads.

## How to change it

Add a representative, correct workload to `crates/jai-bench/benches/compiler.rs` and a behavior test for the feature it exercises. Avoid timing filesystem reads, source generation, fixture preparation or failed compilations inside a successful-stage benchmark. Keep rejection-path measurements separately named.

Run `cargo bench -p jai-bench --bench compiler --locked -- --test` for smoke checks. After fetching upstream sources, run with `--test --ignored` for the optional upstream benchmark. CI performs smoke checks, without timing gates on a shared runner.

## Configuration

Run `python3 tools/benchmark.py --samples 100 --upstream` using Python 3.11+. It saves raw results, build output, environment/command metadata, input hashes and a compiler-source archive under `artifacts/benchmarks/<timestamp>/`. Omitting `--upstream` uses only the checked-in local reference and generated workloads. The script uses the repository target directory and disables an inherited compiler wrapper.

The initial 50-sample shared-host run recorded a 5.07 ms median source-to-IR pipeline for 1,024 generated procedures, 31,784 allocation operations plus 1,081 grows, and about 4.16 MB maximum live allocation. Reference and upstream lexical medians were 137.6 ms and 181.2 ms. Raw measurements are in `artifacts/benchmarks/20261001T221256.105252Z/results.txt`.

A later run after scalar-cast/compound-update work recorded 11.88 ms for the same generated workload, with identical allocation counts. Its lexical medians rose to 305.9 ms and 440.9 ms while other builds/tests shared the host. This demonstrates why these timings cannot establish a regression or improvement without controlled measurement. `artifacts/benchmarks/20261001T222905.259878Z/` also includes a compiler-source archive and corpus fingerprints. These are instrumented baselines, not optimized results or Jai compiler parity.

## Dependencies

Divan 0.1.21, selected with the native 14-day Cargo policy and verified with all 21 locked external packages before compilation. Compiler crates remain independent of Divan. See [dependency policy](dependency-policy.md).
