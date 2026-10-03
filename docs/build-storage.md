# Build storage

## What it is

Local Jai compiler builds use a dedicated Cargo cache on the T7 SSD. Sources and verification receipts remain in the repository; the cache contains reproducible build artifacts.

## How it works

The active target is `/Volumes/CodexBuilds/targets/jai`. `CodexBuilds` is an APFS volume backed by `/Volumes/T7/codex-builds/build-cache.sparsebundle`. This keeps Cargo's filesystem operations on APFS while storing the cache on the external SSD. Fresh and cached native builds, plus fresh and cached Wasm builds and a Node execution probe, passed on this volume.

The direct ExFAT cache produced a zero-header cached Wasm artifact during another project's checks. Its cause is unresolved; the APFS cache is the verified build location. The previous internal shared target was removed. Its compatibility link and global Cargo configuration point to the separate Lodestone target, so Jai commands must supply their own target override.

```sh
export CARGO_TARGET_DIR=/Volumes/CodexBuilds/targets/jai
export CARGO_INCREMENTAL=0
cargo check --workspace --all-targets --offline --locked -j1
python3 tools/benchmark.py --offline --smoke --skip-reference --target-dir /Volumes/CodexBuilds/targets/jai
python3 tools/build_scripting_wasm.py --target-dir /Volumes/CodexBuilds/targets/jai
```

Keep builds sharing a target serialized. Separate project targets may build concurrently within available CPU and memory. Performance measurements taken during other builds must record that contention.

The benchmark and wasm build tools share `tools/cargo_build_paths.py`. Resolution follows `--target-dir`, then a nonempty `CARGO_TARGET_DIR`, then the repository-pinned Cargo's actual `metadata --format-version 1 --no-deps --locked --offline` result. Python does not merge Cargo configuration itself. Both tools use installed `rustup run <pinned-channel> cargo`, pass the resolved absolute directory in `--target-dir` and the environment, and locate compiled artifacts there. An isolated benchmark source copy therefore cannot select another target cache. Receipts record the directory, selection source, metadata command when used, and build command; wasm staging also records compiled/staged paths and the module hash.

Relative CLI/environment targets are anchored to the repository root and canonicalized. Empty or whitespace-only environment values are invalid when selected. Targets inside protected original inputs, including symlink aliases, are rejected before build. A metadata error does not trigger an internal-storage fallback. The fuzz runner delegates its existing directory selection to this helper while preserving its trusted-tool and sanitizer flow. The wasm preflight checks the source, selected build and staging volumes against the 2 GiB free-space floor.

## How to change it

Set `CARGO_TARGET_DIR` to another writable build volume before invoking Cargo or build tooling. Check both source and target free space, and verify a fresh build followed by a cached build before accepting the location. Do not place targets inside protected reference inputs.

If the SSD has been disconnected, mount its existing image before building:

```sh
hdiutil attach -nobrowse /Volumes/T7/codex-builds/build-cache.sparsebundle
```

Do not remove the image, clear an active cache, or detach the SSD while builders use it. Source checkpoints belong under `artifacts/source-checkpoints/`, independently of disposable target caches.

Change shared path resolution in `tools/cargo_build_paths.py`, keep artifact lookup and recorded command paths consistent, and retain the helper in `benchmark.source_files` so isolated benchmark/fuzz tools can import it. Helper tests cover external configured targets, empty settings, protected aliases, mocked wasm staging and low target-volume space. They establish no Cargo build or APFS proof. The existing independently verified host setup above remains the storage authority.

## Configuration

`--target-dir` on the benchmark/wasm tools overrides `CARGO_TARGET_DIR`, which overrides Cargo's configured target. On this machine Jai must still supply its own APFS override; the global default belongs to Lodestone, and the tools do not invent a portable Jai-specific default. The machine-specific path is an invocation setting, not a portable repository default. Use the pinned toolchain in `rust-toolchain.toml` and the dependency-age policy in `.cargo/config.toml`; moving the cache does not change either policy.

## Dependencies

The mounted T7 SSD, macOS APFS and `hdiutil`, Python 3.11+ standard-library TOML/JSON support, independently installed Rustup/Cargo, and the repository's [source checkpoint workflow](source-checkpoints.md). Native compiler checks additionally require the installed LLVM and Clang toolchains documented by their component tests.
