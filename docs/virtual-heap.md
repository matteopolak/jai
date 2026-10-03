# Virtual C allocator storage

## What it is

`HeapAbiProcedure` adapts the selected source allocator's actual `malloc`, `realloc`, and `free` foreign declarations to bounded VM storage. Ordinary allocator wrappers keep their source bodies; the VM never calls a native allocator through these declarations.

## How it works

`FileAbiBindingContext::from_graph` selects independent stdio and default-allocator roles from the configured import roots. An allocator-only graph can retain its own heap receipt without importing POSIX or granting file I/O authority. Ordinary driver resolution, discovery and workspace binding use the narrower `allocator_from_graph` constructor, which cannot carry a stdio role and keeps the existing effects policy. Each selected allocator module instance retains its graph unit, immutable source allocation, original module entry and actual `DeclarationId` catalog for the three foreign operations. Different module parameter instances bind their own original foreign declarations and library identities; they share no replacement procedure IDs. A reloaded graph, changed source receipt or different target cannot reuse it.

The heap binder projects each selected original declaration to its checked `ProcedureId` and canonical signature, verifies that its library declaration belongs to the same selected source, then asks `HeapAuthority` to validate the exact source `libc` metadata, foreign symbol and fixed C ABI. Selection of a module path alone cannot mint a procedure adapter; matching a symbol on an unrelated declaration grants no capability. The constructor supports little-endian LP64 macOS and Linux targets.

During initial source preparation, both readiness binders validate every selected source receipt before returning early or skipping individual declarations whose original checked signatures are still pending. Stdio withholds its capability on the structured incomplete-type error for its actual reserved `FILE` definition. Neither path invents a nominal type, signature or procedure identity. The strict final binder retains the complete-header checks. Ordinary allocator dispatch, ownership tracking and heap creation/destruction still execute their authored Jai bodies; only their checked C allocation leaves use virtual storage.

`VirtualHeap` records canonical VM allocation roots and byte sizes. Source pointers are provenance-carrying `*void` casts of those roots. Freeing requires exact live ledger membership at byte offset zero; frame storage, static data, FILE tokens, shifted pointers, foreign-memory pointers, and stale pointers cannot satisfy that proof. A private, non-cloneable retirement proof authorizes release.

Backing uses the VM's aligned sequence-byte allocation with an immutable internal length. Its byte image starts uninitialized. Reallocation creates a fresh allocation, copies the retained prefix with initialization holes and complete virtual-handle relocations, then retires the old root. Failures before publication leave the original allocation live. Copying pointer bytes does not expose host addresses or invent provenance.

`malloc(0)` returns a distinct non-null zero-length allocation. `free(null)` does nothing. `realloc(null, n)` follows malloc; `realloc(nonnull, 0)` releases that allocation and returns null. Heap ledgers are cloned alongside VM memory snapshots for transaction rollback, while allocation identities remain monotonic.

The scheduler-private `fork_bounds` hook charges the retained root-table capacity and header before inspecting pointer metadata. Its returned bound includes that backing plus retained pointer projections, even when a formerly populated table is empty. Heap byte payloads stay in private `Memory` and are accounted there; the ledger does not charge those bytes again. The scheduler must admit the returned cells and charge clone work before copying branch state.

The VM ledger tests cover both heap fork-bound fixtures: retained empty table capacity with early low-fuel rejection, and live-root metadata accounting without duplicating heap payload. Six active driver source tests passed for allocator-only storage, exact receipts and ABI validation, denial of unrelated declarations, and distinct module-instance identities. The authored standard-library heap ledger remains a known failing witness in [`tests/pending/heap-abi-ledger`](../tests/pending/heap-abi-ledger/README.md): its numeric ownership sentinel currently lacks VM value support. Its original source, test, environment and seven-test diagnostic log are retained there. Reactivate it after paired opaque numeric pointer semantics and source behavior pass; unchanged File source acceptance remains separately gated.

## How to change it

Change source-role selection in `jai-sema/src/modules/file_abi_bindings.rs` and declaration-to-capability binding in its `file_abi_bindings/heap.rs` child. Keep the original graph unit, declaration IDs and immutable source receipt together. Change C signature authorization in `jai-vm/src/heap_abi.rs`, ownership and size policy in `virtual_heap.rs`, and private byte-backing operations in `memory/host_heap.rs`. Any new operation needs a verified source receipt and a full ABI check. Extend `work_cost` before introducing new allocation, image conversion, or metadata copying.

The helper deliberately allocates replacement storage before releasing old storage. A realloc can therefore fail against the VM's transient allocation or cell budget even when its final live size would fit; the original allocation remains valid. Preserve this failure atomicity if implementing an in-place optimization.

## Configuration

`HeapLimits` defaults to 1,024 live allocations and 16 MiB of live heap bytes. VM `Limits.allocations`, `Limits.value_cells`, and fuel remain additional bounds. Byte backing contributes its retained bytes and metadata to the cumulative memory budget, and work is preflighted before mutation or image cloning.

The embedding supplies the selected `BuildTarget`, configured import roots and `ResolveOptions.file_abi` context. `FileAbiBindingContext::from_graph` can select the allocator independently of stdio. CLI standard-library roots and bootstrap source configuration determine which authored modules enter the graph; they do not grant native loading or linking authority. Production availability still requires trusted Rust source binding and the VM's typed procedure-availability ledger.

## Dependencies

The adapter depends on `jai-ir` foreign-library metadata and procedure identities, `jai-types` C signatures and target layouts, and VM `Memory`/`ByteImage` provenance and snapshot behavior. It has no native library, filesystem, process, or network dependency.
