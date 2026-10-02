# Parallel component checks

## What it is

Frozen component workspaces let owners test independent compiler components while the coordinator checks the shared workspace. A component pass applies to its captured inputs; combined compiler acceptance still requires the integration gates.

## How it works

Copy the component and its complete path-dependency closure into a fresh snapshot. Retain the original workspace dependencies, lints, profiles, and toolchain, narrowing only workspace members. Record every copied source hash and both workspace manifest hashes before testing. Use a separate target directory and offline dependency resolution.

The module checkpoint at `artifacts/component-checkpoints/modules-20261002T130457Z` contains six actual crates and 182 hashed inputs. Its authored in-memory collision/bootstrap tests pass 6/6, insertion tests pass 9/9, and production-library strict Clippy passes. `validation.json` records logs, input verification, and executable hashes. The subsequent live insertion suite contains ten tests; the frozen result covers nine. Live all-targets Clippy still encounters staged placeholder code.

The prepared byte-value checkpoint at `artifacts/component-checkpoints/module-byte-values-20261002T133702Z` captures nine source crates after applying the staged `ParameterValue::String(Box<[u8]>)` prototype in a private workspace. Its 16 focused module tests and two parser tests pass, and `jai-sema` library checking passes. A separate hashed Rust harness uses those same frozen path dependencies to compile and execute three authored Jai cases through the rewritten VM: an omitted string default, a direct FF/NUL argument, and a named FF/NUL constant. Each returns 257 from byte values 255 and 0 plus byte count 2. No supplied native artifacts are part of this setup.

`inputs.json` records original and prototype source hashes, the narrowed workspace manifest, and the offline-generated private lockfile. `validation.json` verifies all captured inputs remained unchanged during the checks and records logs, Rust test/harness executable hashes, and the harness source hashes. The same immutable inputs were checked again under the repository's pinned `nightly-2026-08-29` toolchain using an explicit `RUSTUP_TOOLCHAIN`; all 18 focused tests, semantic library checking, and all three VM cases passed. The earlier stable-toolchain runs are retained separately in the receipt. The live payload remains unchanged; `activation-migration.py` and `staged-tests/` prepare the future Driver batch. These results validate the modified prototype and its dependency closure, not full-workspace acceptance or completed insertion-effect replay. Existing staged dead-code warnings remain, so this checkpoint does not claim strict Clippy success.

## How to change it

Include every required path dependency and any fixture paths resolved through `CARGO_MANIFEST_DIR`. Keep copied sources unchanged after capture. A fix requires a new snapshot and manifest; do not silently patch the evidence copy. Report focused checks separately from full-workspace, native, and corpus acceptance.

Choose focused tests that verify behavior and can run without shared mutable fixtures. Do not copy supplied native artifacts into an executable test setup.

## Configuration

Use `RUSTC_WRAPPER=`, `CARGO_INCREMENTAL=0`, an explicit private `CARGO_TARGET_DIR`, and `--offline --locked -j1`. Generate a snapshot-local lockfile offline before locked checks. A path-only dependency closure needs no external packages; closures with external dependencies must retain the repository's release-age policy and approved locked versions.

```sh
cargo test --manifest-path <snapshot>/source/Cargo.toml \
  -p jai-modules --test nominal-import-origins --test bootstrap-policy \
  --offline --locked -j1
cargo clippy --manifest-path <snapshot>/source/Cargo.toml \
  -p jai-modules --lib --offline --locked -j1 -- -D warnings
```

## Dependencies

This workflow uses Cargo, the pinned Rust toolchain, filesystem copies, and SHA-256 manifests. The module checkpoint depends on `jai-source`, `jai-types`, `jai-lexer`, `jai-syntax`, `jai-eval`, and `jai-modules`, with no external crates. Its target directory is independent of the main integration cache.
