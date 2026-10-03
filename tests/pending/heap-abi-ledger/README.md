# Restored authored allocator heap ledger

## What it is

This packet retains historical evidence for `authored_standard_allocator_runs_its_real_heap_ledger_without_stdio`. The exact witness is restored in `crates/jai-driver/tests/heap_abi.rs`; a fresh main run passed all nine allocator source tests, including the ledger, numeric CAPS/ownership storage and raw-pointer authority denials.

## How it works

`witness.rs` preserves the exact original test function; `heap-abi-original.rs` preserves its complete pre-split harness. `default-allocator.jai` and `allocator-module.jai` preserve the actual independently authored source bytes. `source-seven.log` records the actual seven-test run: six passed, one failed at the standard-library ledger assertion because `cast(*void) 1` could not materialize in the VM (`native pointer constant has no virtual allocation or code provenance`).

The allocator returns that numeric ownership sentinel deliberately, and CAPS returns numeric flags. Keep those public values unchanged. Opaque numeric pointer semantics must support their bits without granting allocation or code provenance.

## How to change it

Keep the original function, source snapshots and seven-test log unchanged. The paired VM change restored the exact witness and added two protocol/denial tests. The fresh main evidence is `/private/tmp/jai-integration-language-bulk-20261002/allocator-source9.log` (SHA-256 `1ac93f37378e7cdc42bb49b5c3e30244460b9a90ceee0fd7d4031cc46aecc1f4`): nine passed, zero failed. The historical six-pass/one-failure run remains in `source-seven.log`; it is not the current acceptance result.

## Configuration

`manifest.json` retains the original pre-restoration source hashes, the selected little-endian macOS Arm64 LP64 target, bootstrap paths, and all three disabled runtime-support parameters. The Rust test loads the actual repository stdlib via explicit roots, independently of ambient CLI environment. The corresponding CLI check must use the retained environment and a freshly built rewritten `jai-rs`, with `JAI_RS_MODULE_PATH` unset. That environment-specific CLI gate is still pending; the nine driver passes do not establish it.

## Dependencies

The witness depends on the authored `Default_Allocator`, selected source heap receipts, compile-time VM memory, and opaque numeric pointer value support. It does not authorize running, loading or linking an original supplied native binary or library.
