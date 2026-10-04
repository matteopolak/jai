# Completion and acceptance plan

## What it is

The goal is a complete independent Jai implementation with verified standard-library, reference-example and recent-project compatibility. Passing focused feature tests does not complete that goal.

## How it works

Track what compiles (`jaic check`) separately from what runs correctly (`jaic run` and native builds). The live status, per-project results and open work are kept in `HANDOFF.md`; this page only records how acceptance is judged.

| Gate | Evidence | Command |
| --- | --- | --- |
| Compiler unit tests | `crates/jaic` parser/sema/interpreter tests | `cargo test --workspace` |
| Regression programs | `tests/corpus` (expected output) and `tests/stdlib` (each exits 0) | `python3 tools/jaic-sweep.py corpus stdlib` |
| Upstream projects | Entry points of the pinned projects in `corpus/upstream` listed in `tools/upstream-cases.json` | `python3 tools/jaic-sweep.py upstream --timeout 900` |
| Reference examples | `reference/how_to` programs, check only | `python3 tools/jaic-sweep.py howto` |
| Browser | Real Wasm module, worker and language service | `tools/build_scripting_wasm.py --release`, then `node tools/check_playground_worker.mjs` and `node tools/check_browser_release.mjs` |

Only `getrect-rh-negative-control` is expected to fail the sweeps; it is a deliberate negative control.

Remaining areas are listed under "Open work" in `HANDOFF.md`: the libclang-based `Bindings_Generator`, native libraries for the larger projects, Windows-only APIs, SIMD and threading in the browser build, and float printing details.

## How to change it

When behavior is implemented and verified, update `HANDOFF.md` and the subsystem page in this folder. Keep unavailable SDK or hardware cases explicit rather than recording passes. Do not mark the goal complete while required work remains; standard-library and real project builds, metaprogramming and compiler API behavior, and native/runtime tests are all required. Support files need not have a `main`, and deliberately failing examples need their intended diagnostics. See [reference compatibility](reference-compatibility.md).

## Configuration

Pinned upstream revisions ([upstream corpus](upstream-corpus.md)), platform SDKs, build parameters and Cargo's dependency-age policy affect acceptance. Original native binaries under `reference/` are never executed; reading its modules and docs for semantics is fine.

## Dependencies

`crates/jaic`, `crates/jaic-cli`, the corpus manifests, `tools/jaic-sweep.py`, and for native/browser gates LLVM 22 or the `wasm32-unknown-unknown` target and Node.
