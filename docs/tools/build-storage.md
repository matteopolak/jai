# Build storage and target directories

## What it is

Where Cargo artifacts go, and how the Python/Node build tools find them. Build output is large (LLVM-linked binaries, wasm builds), so tools never guess a target directory.

## How it works

`tools/cargo_build_paths.py` resolves the Cargo target directory for `tools/build_scripting_wasm.py` and `tools/package_browser_release.py`: `--target-dir`, then a non-empty `CARGO_TARGET_DIR`, then the result of `cargo metadata --no-deps --locked --offline` run through the pinned toolchain (`rustup run <channel> cargo`). Relative paths are anchored at the repository root; directories inside `reference/`, `corpus/` or `vendor/` are rejected. The wasm build also refuses to start with less than 2 GiB free on the volumes it uses.

Typical developer setup, with one target directory per checkout or agent so concurrent builds never share (and never leave stale) binaries:

```sh
export RUSTC_WRAPPER= CARGO_TARGET_DIR=/Volumes/CodexBuilds/targets/jai-dev
rustup run nightly-2026-08-29 cargo build -q -p jaic-cli
```

The `dev` and `test` profiles set `debug = 0` and `incremental = false` in the root `Cargo.toml` to keep artifacts small; use `--profile rust-debug` to debug the compiler itself with a Rust debugger. Jai debug information is unaffected (it comes from LLVM, not Cargo).

## How to change it

Change path resolution only in `tools/cargo_build_paths.py` and keep `tools/test_cargo_build_paths.py` passing. The machine-specific volume above is an invocation setting, not a repository default.

## Configuration

`CARGO_TARGET_DIR`, `--target-dir` (wasm build and release packaging), `CARGO_INCREMENTAL=0` in CI.

## Dependencies

Rustup with the toolchain from `rust-toolchain.toml`, Python 3.11+.
