# Jai in Rust


The Rust workspace currently includes source diagnostics and symbol IDs, typed lexical/syntax tags, semantic resolution into typed IR, an LLVM backend, a CLI and allocation-aware benchmarks. See [developer documentation](docs/README.md) for current coverage, acceptance criteria, dependency policy and binary execution restrictions.

The supplied distribution stays outside public Git history. A public checkout can run compiler checks with `cargo test --workspace --locked -- --skip lex_entire_reference_without_executing_it --skip supplied_executable_is_rejected_before_backend_execution` and benchmark smoke checks with `--test --skip reference_lex`. The separately dispatched [static inspection workflow](docs/github-analysis.md) runs the distribution-dependent checks with hashed data inputs.

```sh
# Python 3.11+ is required for repository tools.
python3 tools/check_dependency_age.py
cargo test --workspace --locked
python3 -m unittest discover -s tools -p 'test_*.py'
cargo bench -p jai-bench --bench compiler --locked -- --test
```

Fetch the pinned recent source corpus with `python3 tools/fetch_upstreams.py`, verify it with `python3 tools/verify_upstreams.py`, then run `cargo test -p jai-lexer --test upstream --locked -- --ignored`. Save performance/allocation measurements with `python3 tools/benchmark.py --upstream`.

Use `jai-rs build file.jai output` for the implemented signed-integer/Boolean subset. This requires independently installed LLVM/Clang. Never point `JAI_RS_CLANG` at a supplied executable. The Jai compiler and bundled native libraries remain unexecuted pending inspection and explicit approval.
