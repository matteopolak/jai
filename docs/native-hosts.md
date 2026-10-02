# Native host checks and LLVM setup

## What it is

Compiler CI selects macOS ARM64 (`macos-15`), macOS x86-64 (`macos-15-intel`), Linux x86-64 (`ubuntu-24.04`) and Linux ARM64 (`ubuntu-24.04-arm`). Only completed hosted runs establish execution on each host. Windows, mobile and WebAssembly execution remain unverified; [cross-target acceptance](cross-target-acceptance.md) checks their object emission separately.

The original macOS ARM64 and Linux x86-64 hosts passed the [integer/call/module-loading checkpoint](https://github.com/matteopolak/jai/actions/runs/36953861195). This proves the tested scalar native subset, rather than standard-library or full-project compatibility.

## How it works

Each runner enforces the existing 14-day locked Rust dependency age policy before compiling, then runs formatting, lint, Rust/native execution tests, Python policy tests and benchmark smoke checks. Before building, `tools/check_ci_sources.py` inspects literal Rust `include_str!`/`include_bytes!` inputs against the public Git inventory. It rejects private reference/corpus files, every vendor input, missing inputs, and paths escaping the checkout. The [compiler prelude](compiler-prelude.md) is repository-authored source and needs no exception. This is a literal-include audit rather than a complete Rust parser; clean-checkout compilation remains the definitive check. Optional private corpus tests use runtime reads and explicitly skip absent source inputs.

Native fixtures use this compiler's generated LLVM IR and independently installed Clang. The runner disables core dumps for deliberately trapping fixtures with `ulimit -c 0`.

macOS obtains LLVM 22 through Homebrew. Linux uses `tools/install_ci_llvm_linux.sh` to configure the official [LLVM Ubuntu archive](https://apt.llvm.org/) for Noble's version 22 branch. The script checks the archive's published primary signing-key fingerprint and scopes trust with `signed-by`; APT verifies signed metadata and package hashes. It never executes a downloaded installer. Package patch releases can change; these packages are authenticated, not byte-for-byte pinned.

The original Jai workflows remain separate macOS-only hosted experiments. Linux checks do not download or execute original Jai or transfer additional reference sources.

## How to change it

Extend `.github/workflows/ci.yml` only with concrete host setup and execution checks. Keep the age guard before Cargo builds, immutable Action commits, `contents: read`, and disabled checkout credentials. Review official key rotation before updating the fingerprint. Keep original Jai outside this matrix and developer-host execution. Add public source-input regressions to `tools/test_check_ci_sources.py`; never satisfy a failing include by uploading original source beyond the approved Preload. Missing-original tool protection tests must still reject protected paths without executing them. The mandatory rejection test stays active in hosted CI: protected nonexistent tool paths and dangling aliases fail before tool lookup. Only the full private-reference lexer remains excluded from the hosted Rust suite.

Inspect completed runs with `gh run view RUN_ID --repo matteopolak/jai`. Syntax validation or macOS success does not establish Linux execution.

## Configuration

Rust uses `rust-toolchain.toml` (`nightly-2026-08-29`); CI uses Python 3.14 and 30-minute jobs. `CARGO_INCREMENTAL=0` avoids retaining incremental compiler state on disposable runners. Linux sets `LLVM_SYS_221_PREFIX=/usr/lib/llvm-22` and prepends `/usr/lib/llvm-22/bin` to `PATH`. The installer accepts only Ubuntu 24.04 on x86-64 or ARM64 and LLVM 22.1. It selects `amd64` or `arm64` APT packages from the actual host architecture. It needs `sudo` and writes system APT configuration; use it on fresh hosted runners.

For an existing independently installed LLVM 22.1, set its prefix and add its `bin` directory to `PATH`; run the dependency age guard before `cargo test --workspace --locked`. See [LLVM setup](llvm-backend.md) for macOS commands.

## Dependencies

GitHub-hosted runners, pinned checkout/setup-python Actions, Rustup, Python, LLVM/Clang 22.1, Homebrew on macOS, and APT, curl, GnuPG and sudo on Ubuntu. Linux installs LLVM development and Polly packages for llvm-sys discovery.
