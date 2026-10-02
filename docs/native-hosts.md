# Native host checks and LLVM setup

## What it is

Compiler CI targets macOS ARM64 (`macos-15`) and Linux x86_64 (`ubuntu-24.04`). Only completed hosted runs establish support. Windows, mobile and WebAssembly execution remain unverified.

Both hosts passed the [integer/call/module-loading checkpoint](https://github.com/matteopolak/jai/actions/runs/36953861195). This proves the tested scalar native subset, rather than standard-library or full-project compatibility.

## How it works

Each runner enforces the existing 14-day locked Rust dependency age policy before compiling, then runs formatting, lint, Rust/native execution tests, Python policy tests and benchmark smoke checks. Native fixtures use this compiler's generated LLVM IR and independently installed Clang. The runner disables core dumps for deliberately trapping fixtures with `ulimit -c 0`.

macOS obtains LLVM 22 through Homebrew. Linux uses `tools/install_ci_llvm_linux.sh` to configure the official [LLVM Ubuntu archive](https://apt.llvm.org/) for Noble's version 22 branch. The script checks the archive's published primary signing-key fingerprint and scopes trust with `signed-by`; APT verifies signed metadata and package hashes. It never executes a downloaded installer. Package patch releases can change; these packages are authenticated, not byte-for-byte pinned.

The original Jai workflows remain separate macOS-only hosted experiments. Linux checks do not download or execute original Jai or transfer additional reference sources.

## How to change it

Extend `.github/workflows/ci.yml` only with concrete host setup and execution checks. Keep the age guard before Cargo builds, immutable Action commits, `contents: read`, and disabled checkout credentials. Review official key rotation before updating the fingerprint. Keep original Jai outside this matrix and developer-host execution.

Inspect completed runs with `gh run view RUN_ID --repo matteopolak/jai`. Syntax validation or macOS success does not establish Linux execution.

## Configuration

Rust uses `rust-toolchain.toml` (`nightly-2026-08-29`); CI uses Python 3.14 and 30-minute jobs. Linux sets `LLVM_SYS_221_PREFIX=/usr/lib/llvm-22` and prepends `/usr/lib/llvm-22/bin` to `PATH`. The installer accepts only Ubuntu 24.04 x86_64 and LLVM 22.1. It needs `sudo` and writes system APT configuration; use it on fresh hosted runners.

For an existing independently installed LLVM 22.1, set its prefix and add its `bin` directory to `PATH`; run the dependency age guard before `cargo test --workspace --locked`. See [LLVM setup](llvm-backend.md) for macOS commands.

## Dependencies

GitHub-hosted runners, pinned checkout/setup-python Actions, Rustup, Python, LLVM/Clang 22.1, Homebrew on macOS, and APT, curl, GnuPG and sudo on Ubuntu. Linux installs LLVM development and Polly packages for llvm-sys discovery.
