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
```

Keep builds sharing a target serialized. Separate project targets may build concurrently within available CPU and memory. Performance measurements taken during other builds must record that contention.

## How to change it

Set `CARGO_TARGET_DIR` to another writable build volume before invoking Cargo or build tooling. Check both source and target free space, and verify a fresh build followed by a cached build before accepting the location. Do not place targets inside protected reference inputs.

If the SSD has been disconnected, mount its existing image before building:

```sh
hdiutil attach -nobrowse /Volumes/T7/codex-builds/build-cache.sparsebundle
```

Do not remove the image, clear an active cache, or detach the SSD while builders use it. Source checkpoints belong under `artifacts/source-checkpoints/`, independently of disposable target caches.

## Configuration

`CARGO_TARGET_DIR` overrides Cargo's configured target. The machine-specific path is an invocation setting, not a portable repository default. Use the pinned toolchain in `rust-toolchain.toml` and the dependency-age policy in `.cargo/config.toml`; moving the cache does not change either policy.

## Dependencies

The mounted T7 SSD, macOS APFS and `hdiutil`, Cargo, and the repository's [source checkpoint workflow](source-checkpoints.md). Native compiler checks additionally require the installed LLVM and Clang toolchains documented by their component tests.
