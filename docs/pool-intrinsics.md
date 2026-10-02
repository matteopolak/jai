# Pool and Flat_Pool intrinsics

The supplied OpenJai `Pool` and `Flat_Pool` modules declare six compiler intrinsics. Their declarations now bind to checked IR identities and execute through an owned VM block ledger or typed LLVM runtime bodies. The supplied compiler's empty pool helpers are not used as behavioral evidence.

## Source contract and policy

`Pool` has four fields in order: `memblock_size:s64`, `bytes_left:s64`, `current_block:*void`, and `current_pos:s64`. `Flat_Pool` adds `alignment:s64`. Each operation retains the exact nominal record `TypeId`; an identical record layout does not make a copied descriptor an owner.

| Module | Operation | Checked signature |
| --- | --- | --- |
| Pool | `get` | `(*Pool,s64)->*void` |
| Pool | `reset` | `(*Pool)->void` |
| Pool | `release` | `(*Pool)->void` |
| Flat_Pool | `get` | `(*Flat_Pool,s64)->*void` |
| Flat_Pool | `reset` | `(*Flat_Pool,bool)->void` |
| Flat_Pool | `fini` | `(*Flat_Pool)->void` |

Binding requires an explicit `#intrinsic` marker, the complete storage schema, a fixed Jai signature without context, and a selected target layout. Ordinary procedures with these names retain their own bodies. Canonical context omission is an independent compiler binding rule.

The unchanged `Pool.set_allocators` body chooses 65,536 bytes. The supplied LP64 examples consume 136 bytes for two 64-byte allocations, supporting one pointer-sized block reservation followed by aligned payloads. The Flat_Pool example uses alignment 8 and shows `reset(true)` poisoning retained bytes with `0xCC`.

Some details are unspecified by those sources. This implementation chooses zero-filled new blocks, a 65,536-byte fallback when capacity is zero, alignment 8 when the Flat_Pool field is zero, and a larger dedicated block when a request exceeds configured capacity. Pool alignment uses the larger of target pointer and s64 alignment. Reservation, offsets, and capacity checks use the selected target; no LP64 constant is used for pointer width. A zero-size `get` returns a null pointer without inspecting its descriptor.

## Ownership and lifetime

The VM key contains memory identity, descriptor allocation generation, canonical byte offset, and nominal pool type. Aliases to one descriptor share its state. Copying public cursor fields into another descriptor cannot adopt the original blocks. Public counters and block pointer must match the ledger before an operation proceeds.

In the VM, `get` returns a pointer bounded to the requested payload, and casts cannot widen that region to the complete byte-buffer allocation. Native results are ordinary machine pointers; callers must respect the requested extent. Blocks are retained until `release` or `fini`; returned pointers become dangling after that operation. The cursor fields are cleared, while capacity and alignment configuration remain available for a subsequent fresh allocation.

Reset rewinds retained blocks. `reset(true)` also fills their bytes with `0xCC`, removing overlapping opaque pointer, procedure, and runtime-type provenance. Existing byte pointers remain addressable; overwritten objects must be initialized before their pointer-bearing fields can be read as values. The VM never interprets poison bytes as forged handles.

A block containing a live nested pool descriptor cannot be reset or released. Finish the inner pool first. Likewise, the VM rejects releasing a descriptor's allocation while its pool is live. Native callers must finish a pool before the descriptor's lifetime ends or before externally freeing its storage; native machine pointers do not carry VM allocation generations. This explicit lifetime rule prevents an abandoned descriptor address from silently adopting a previous ledger.

VM mutations use `Memory.snapshot` and `restore`, including the pool ledger. Failure leaves blocks and cursors unchanged. Allocation IDs and virtual addresses remain monotonic across rollback. Capacity, allocation count, and cumulative payload/ledger cell limits are checked before allocating a block or cloning the transaction snapshot.

## Native implementation

`native_pools/ledger.rs`, `allocate.rs`, and `lifecycle.rs` generate LLVM functions with Inkwell and checked pointer-builder APIs. No textual IR is parsed. A nominal token belonging to each checked record guards the descriptor's native ledger identity. Tokens are local to the emitted compilation unit; cross-unit pool APIs should be supplied by the unit that owns their nominal declaration.

The runtime allocates zeroed payloads and metadata with selected-target `calloc(size_t,size_t)`. Each block retains its original allocation separately from its aligned data pointer. Release frees every original payload, block node, and pool node exactly once. Reset retains those allocations. A shared atomic lock serializes ledger operations across threads, and release checks all nested descriptors before freeing any block.

The `jai.pool.` native helper namespace is reserved. A colliding source foreign/export declaration is diagnosed before helper construction; a matching symbol spelling cannot replace a generated pool implementation.

Typed LLVM verification covers 32- and 64-bit metadata and `size_t` layouts. Executed native fixtures use the supported host C ABI. The VM and catalog separately exercise LP64 and ILP32 policies; these checks do not claim complete native source support for every 32-bit target.

## How to change it

Extend `jai-ir/src/runtime_intrinsics/pools.rs` for a new source signature or descriptor schema. Preserve exact nominal identity rather than selecting by function name alone. Update VM dispatch, `memory/pools.rs`, and native wrappers together.

The VM work estimator reads only bounded configuration scalars before charging fuel, including sealed aggregate storage without materializing a cold root. Configuration containing address-derived integers is rejected. Include complete descriptor roots, snapshot tables, retained metadata, and any new or poisoned buffer in cost estimates. New ledger metadata must contribute to `Memory.cells`, snapshot/restore, and Swap's snapshot estimate. Never clone the complete `Memory` object to roll back an operation.

Keep lifetime regressions for descriptor aliases/copies, nested owners, poison provenance, region casts, failed operations, and released pointers. Source parity fixtures import the unchanged module files. Native tests count real allocation/free calls and exercise concurrent allocation from one pool.

The two unchanged-module parity fixtures require the optional supplied corpus. Run them explicitly with `cargo test -p jai-codegen --test runtime_intrinsics_source -- --include-ignored`. The remaining independently authored fixtures run without that corpus.

## Configuration and dependencies

`Limits.fuel`, `Limits.allocations`, `Limits.value_cells`, and the selected `ByteTarget` bound VM execution. Source fields configure block capacity and Flat_Pool alignment. Alignment must be a positive power of two representable by u32. Native allocation failure and malformed runtime descriptors trap.

Dependencies are `jai-types` target layouts, the closed `jai-ir` intrinsic catalog, VM byte images and address provenance, and LLVM/Inkwell plus the target C allocator. Native tests use the installed Clang selected by `JAI_RS_CLANG` or `LLVM_SYS_221_PREFIX`.

The exported integer allocator IDs 2 and 3 and the many OpenJai Basic `#foreign` declarations are separate interfaces. These six operations do not reinterpret integers as procedure handles or grant foreign declarations execution rights by name. Full standard-library acceptance is tracked by the [source library workflow](open-jai-libraries.md).
