# Compiler build profiles

## What it is

The workspace uses small Rust development and test artifacts by default. An optional `rust-debug` profile preserves Rust debugger information when debugging the compiler itself.

## How it works

The `dev` and `test` Cargo profiles disable Rust debug information and incremental compilation. Repeated parallel feature builds previously exhausted local storage with compiler test binaries and incremental caches, preventing builds and even source edits. Optimization and Rust assertions retain their normal development settings.

These settings affect the Rust implementation. Jai debug information is generated separately through LLVM and remains controlled by the source compiler's native options. Release benchmarks retain Cargo's release profile.

Build-only checkpoints keep an immutable compiler copy at `target/standard-library-snapshots/<sha256>/jai-rs` with mode `0555` and verified bytes. Their local receipt records the Cargo command, explicit environment, tool versions, disk observations, and input hashes before and after the build. Inputs include Cargo manifests/lock, the toolchain and Cargo configuration, Rust source, the authored LLVM C++ shim/build script, and the four Python proof tools embedded by the CLI. A build checkpoint establishes a binary, independently of subsequent feature or runtime acceptance.

On APFS, `/bin/cp -c` can preserve the snapshot through copy-on-write while giving it a separate inode. Verify the inode differs from the mutable build output, recheck both byte fingerprints, and apply the read-only mode to the snapshot. Never hardlink a checkpoint to `target/debug/jai-rs`: later writes or permission changes would share that file identity.

A conservative source-tree observation can include unregistered helpers and `cfg(test)` modules. Preserve its changed flag and exact changed-file list when those files move during a build. A separate observation may use the fresh final-target Cargo dep-info to select compiled repository inputs, together with declared configuration/build-support inputs; its matching hashes must not erase the broader observation. These records describe the measured input set, rather than claiming complete reproduction of external toolchains or Cargo's dependency cache. Later source repairs require a new checkpoint even when the earlier compiler bytes remain intact.

## How to change it

Change the workspace profile definitions in `Cargo.toml`. Coordinate profile changes with running builds because Cargo rebuilds artifacts when their flags change. Never delete source, reference inputs or acceptance receipts when reclaiming generated build caches.

Reserve one coordinated build slot when creating a checkpoint. Bound disk growth before building and copying, retain failed build logs, and release the slot after the immutable copy and receipt are saved. Feature/corpus runs should name that exact frozen binary rather than inherit a mutable `target/debug/jai-rs`. See [source-free stage reports](corpus-stage-reports.md) for consumption of measured evidence.

## Configuration

```sh
cargo test --workspace --locked
cargo build -p jai-cli --profile rust-debug --locked
```

Use the ordinary LLVM setup and dependency-age policy for either profile. Explicit Cargo profile environment overrides still take precedence; recording those overrides is necessary when comparing compiler build sizes or performance. Independent temporary Cargo manifests do not inherit this workspace's profile definitions.

## Dependencies

Cargo profile support, the pinned Rust toolchain, and the trusted LLVM installation used by the backend. See [LLVM setup](llvm-backend.md) and [dependency policy](dependency-policy.md).
