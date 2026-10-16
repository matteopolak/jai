# Workspace object targets

The CLI LLVM backend now selects a child workspace's native OS and CPU instead
of silently emitting host objects. An explicit CLI target retains its existing
precedence; otherwise an explicit workspace LLVM triple wins over its OS/CPU.
An explicit host CLI target is also retained. A native OS with a WASM CPU is
rejected rather than silently selecting a native architecture.

`cleanroom_workspace_targets` creates real public Compiler workspaces and checks
their emitted ELF64 ET_REL machine62/183, Mach-O64 MH_OBJECT CPU types, COFF
machine types and WASM headers. Linux x64 failed with a Mach-O header before the
repair. All seven target pairs now pass on the native ARM64 Mac host. These are
cross-object checks, not Linux/Windows native execution or complete ABI proof.

Verification uses the immutable production stdlib from candidate06e8ea96:

```
cargo test --locked --offline -p jaic-cli --bin jaic --test cleanroom_workspace_targets -- --test-threads=1
cargo clippy --locked --offline -p jaic-cli --all-targets -- -D warnings
cargo fmt --all -- --check
```

Environment: `LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm`, empty
`RUSTC_WRAPPER`, `CARGO_BUILD_JOBS=2`, integration's exclusive Cargo target and
`JAIC_STDLIB=artifacts/shared-integration/frozen-06e8ea96/stdlib` (absolute).
The first command reports10 CLI unit tests plus1 regression containing seven
object emissions, with no failures or ignored tests. Clippy and rustfmt pass.

Frontend target ABI selection is a separate compiler-owned boundary:
`crates/jaic/src/build.rs::new_compiler` applies workspace OS/CPU but does not
derive frontend ABI settings from an explicit workspace LLVM triple. This
repair does not establish mixed CLI/workspace or custom-triple C ABI coherence.
The compiler owner's host-mode clock and inherited record-default fixes remain
separate pending checkpoints. Existing full failed baselines remain unchanged.
