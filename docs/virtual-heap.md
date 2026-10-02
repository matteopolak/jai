# Virtual C allocator storage

## What it is

`HeapAbiProcedure` adapts the selected source allocator's actual `malloc`, `realloc`, and `free` foreign declarations to bounded VM storage. Ordinary allocator wrappers keep their source bodies; the VM never calls a native allocator through these declarations.

## How it works

The trusted source binder supplies a receipt for the configured source graph, type registry, and target. `HeapAuthority` then checks the exact procedure IDs, canonical source `libc` library metadata, foreign origin and fixed C signatures. Matching a symbol spelling alone grants no capability.

`VirtualHeap` records canonical VM allocation roots and byte sizes. Source pointers are provenance-carrying `*void` casts of those roots. Freeing requires exact live ledger membership at byte offset zero; frame storage, static data, FILE tokens, shifted pointers, foreign-memory pointers, and stale pointers cannot satisfy that proof. A private, non-cloneable retirement proof authorizes release.

Backing uses the VM's aligned sequence-byte allocation with an immutable internal length. Its byte image starts uninitialized. Reallocation creates a fresh allocation, copies the retained prefix with initialization holes and complete virtual-handle relocations, then retires the old root. Failures before publication leave the original allocation live. Copying pointer bytes does not expose host addresses or invent provenance.

`malloc(0)` returns a distinct non-null zero-length allocation. `free(null)` does nothing. `realloc(null, n)` follows malloc; `realloc(nonnull, 0)` releases that allocation and returns null. Heap ledgers are cloned alongside VM memory snapshots for transaction rollback, while allocation identities remain monotonic.

The scheduler-private `fork_bounds` hook charges the retained root-table capacity and header before inspecting pointer metadata. Its returned bound includes that backing plus retained pointer projections, even when a formerly populated table is empty. Heap byte payloads stay in private `Memory` and are accounted there; the ledger does not charge those bytes again. The scheduler must admit the returned cells and charge clone work before copying branch state.

The latest full VM test run passed 518 tests, including both heap fork-bound fixtures: retained empty table capacity with early low-fuel rejection, and live-root metadata accounting without duplicating heap payload. This verifies the private ledger accounting hook; unchanged File source acceptance remains separately gated.

## How to change it

Change signature authorization in `heap_abi.rs`, ownership and size policy in `virtual_heap.rs`, and private byte-backing operations in `memory/host_heap.rs`. Any new operation needs a verified source receipt and a full ABI check. Extend `work_cost` before introducing new allocation, image conversion, or metadata copying.

The helper deliberately allocates replacement storage before releasing old storage. A realloc can therefore fail against the VM's transient allocation or cell budget even when its final live size would fit; the original allocation remains valid. Preserve this failure atomicity if implementing an in-place optimization.

## Configuration

`HeapLimits` defaults to 1,024 live allocations and 16 MiB of live heap bytes. VM `Limits.allocations`, `Limits.value_cells`, and fuel remain additional bounds. Byte backing contributes its retained bytes and metadata to the cumulative memory budget, and work is preflighted before mutation or image cloning.

No environment variable or source symbol enables this adapter. Production availability is selected through trusted Rust source binding and the VM's typed procedure-availability ledger.

## Dependencies

The adapter depends on `jai-ir` foreign-library metadata and procedure identities, `jai-types` C signatures and target layouts, and VM `Memory`/`ByteImage` provenance and snapshot behavior. It has no native library, filesystem, process, or network dependency.
