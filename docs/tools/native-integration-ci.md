# Native integration CI

## What it is

The temporary `codex/cleanroom-integration` branch exercises the combined implementation on native hosted runners. It publishes no release artifacts to GitHub Releases or external stores.

## How it works

Normal CI covers macOS and Linux x64/arm64. The Windows native workflow includes this branch and executes the File contracts in the interpreter and compiled O0/O2 programs on Windows x64 and arm64, alongside signed-wheel propagation and existing native checks. Known failures remain visible; a successful cross-check is not native runtime evidence.

## How to change it

Add behavior cases under `tests/platform-io` and keep the native runner step in both Windows jobs. Preserve the normal test gates. Review workflow triggers before pushing; release builds remain on hold.

## Configuration

`tools/check_platform_io.py --jaic <compiler> --stdlib stdlib --native` runs against production sources. The CI branch selector is separate from release tags and workflow dispatch.

## Dependencies

The integrated compiler and stdlib, pinned Rust/LLVM toolchain, Visual Studio SDK, and GitHub native runners.
