# Pending authored allocator heap ledger

## What it is

This packet retains the known failing `authored_standard_allocator_runs_its_real_heap_ledger_without_stdio` source witness. Six passing allocator source gates remain active in `crates/jai-driver/tests/heap_abi.rs`.

## How it works

`witness.rs` preserves the exact original test function; `heap-abi-original.rs` preserves its complete pre-split harness. `default-allocator.jai` and `allocator-module.jai` preserve the actual independently authored source bytes. `source-seven.log` records the actual seven-test run: six passed, one failed at the standard-library ledger assertion because `cast(*void) 1` could not materialize in the VM (`native pointer constant has no virtual allocation or code provenance`).

The allocator returns that numeric ownership sentinel deliberately, and CAPS returns numeric flags. Keep those public values unchanged. Opaque numeric pointer semantics must support their bits without granting allocation or code provenance.

## How to change it

Restore the exact test function and required imports to the active driver harness after the paired VM schema and real source behavior pass. The staged nine-test companion at `/private/tmp/jai-allocator-only/heap_abi_opaque_tests.rs` includes this witness and two protocol/denial tests; it is not current passing acceptance. No test was rerun for this text-only split.

## Configuration

`manifest.json` retains original source hashes, the selected little-endian macOS Arm64 LP64 target, bootstrap paths, and all three disabled runtime-support parameters. The Rust test loads the actual repository stdlib via explicit roots, independently of ambient CLI environment. The corresponding CLI check uses the retained environment and the freshly built rewritten `jai-rs`, with `JAI_RS_MODULE_PATH` unset.

## Dependencies

The witness depends on the authored `Default_Allocator`, selected source heap receipts, compile-time VM memory, and future opaque numeric pointer value support. It does not authorize running, loading or linking an original supplied native binary or library.
