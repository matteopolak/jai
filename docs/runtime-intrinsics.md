# Runtime intrinsics

Runtime intrinsics are typed operations implemented by the independent compiler and VM. A source declaration must explicitly use `#intrinsic`; a matching ordinary procedure name never acquires compiler behavior.

The typed catalog, byte operations, source declaration binding, generic prototype specialization, and VM invocation adapter are implemented and tested. Eighteen self-written source fixtures exercise direct and indirect calls, local prototypes, generic compare-and-swap and swap, required results, address-provenance guards, both memory ABIs, Pool lifetime and fuel bounds, and real `#run` execution. Six source fixtures also pass in newly emitted native executables. These results do not establish that the full Preload or Basic modules compile.

## How it works

`jai-ir/src/runtime_intrinsics.rs` contains the closed operation catalog and validates the declared signature against the selected target layout. The initial catalog follows the active declarations in the local pinned source: `Preload.jai` supplies `memcpy`, `memcmp`, `memset`, and `compare_and_swap`; `Runtime_Support.jai` declares a local procedure tagged `"llvm.debugtrap"`.

| Operation | Checked source signature | Behavior |
| --- | --- | --- |
| `memcpy` | `(*void, *void, s64) -> void` | Copy disjoint byte ranges. |
| Destination-returning `memcpy` | `(*void, *void, s64) -> *void` | Copy disjoint byte ranges and return the original destination pointer. |
| `memcmp` | `(*void, *void, s64) -> s16` | Compare unsigned bytes lexicographically. Only the sign of the result is guaranteed. |
| `memset` | `(*void, u8, s64) -> void` | Fill a byte range with the supplied byte. |
| Destination-returning `memset` | `(*void, s64, s64) -> *void` | Fill with the low eight bits of the signed value and return the destination pointer. |
| `swap` | `(*T, *T) -> void` | Swap initialized values with identical nominal types, preserving pointers and aggregate values. |
| `compare_and_swap` | `(*T, T, T) -> (bool, T)` | Return the observed value and whether replacement occurred. |
| `llvm.debugtrap` | `() -> void` | Halt VM execution with `Error::RuntimeTrap`. |

All declarations require fixed, evaluated runtime parameters in a Jai signature without implicit context. Source `using`, baked, variadic, and `#discard` formals cannot change an intrinsic's runtime argument contract. The parser normalizes an intrinsic prototype to `ContextMode::None`, and the typed catalog checks that convention again. This is an independent implementation rule; the unannotated declarations in the pinned source do not by themselves establish the original compiler's ABI.

The supplied OpenJai corpus declares the destination-returning memory signatures and generic `swap` in `modules/Basic/module.jai:126–128`. They receive separate closed catalog variants after exact signature validation. The pinned Preload declarations retain their original void-result and `u8` contracts. Source tags select a candidate only on an explicitly marked prototype; canonical parameter and result types determine which supported contract it satisfies.

The pinned `memcmp` result is declared `s16 #must`. Source result metadata retains that obligation through direct calls, inferred procedure values, and local prototypes; discarding its result is a semantic error. Usage annotations remain separate from canonical ABI type identity. See [required procedure results](result-obligations.md) for consumption rules and callback contracts.

`compare_and_swap` accepts the documented `Atomics.jai` scalar domain: bool, integer, enum, pointer, and nominal variants of those types. Its target storage must occupy 1, 2, 4, or 8 bytes. The VM checks natural atomic alignment and writable storage even when comparison would fail. Small records, floats, and procedure values are currently rejected by the checked contract.

`jai-vm/src/runtime_intrinsics.rs` dispatches a checked operation into `Memory` methods. Signed negative byte counts fail before execution. Before a nonempty range operation, the VM charges its byte count plus complete root storage, charged value/image metadata, and canonical identity-table work. A one-byte access into a large aggregate therefore cannot repeatedly clone its entire image with a one-step fuel charge. Atomic operations include their root load/store work too. Root extents and cached cell counts provide bounded work estimates without loading values. A zero-byte memory operation succeeds without reading either pointer. Nonzero ranges preserve allocation ownership, subobject bounds, read-only flags, and lifetime checks.

Address-derived integer counts are rejected before work accounting. Filling with an address-derived byte retains its provenance through subsequent copies and integer loads, including when its virtual bits are zero. Atomic integer operations reject address-derived expected, replacement, or observed values; pointer CAS continues to use canonical pointer identity. A comparison that touches address-dependent bytes returns a portable zero only when complete opaque pointer/procedure identities match and the other bytes are equal. Partial, derived, integer-origin, or nonidentical address spans produce an explicit unsupported-operation error instead of exposing virtual address ordering through `#run`.

A byte fragment of a certified procedure address has no data-allocation origins. Its provenance still survives filling and copying on both 32-bit and 64-bit layouts; an empty origin list does not make the byte portable or authorize an inverse pointer cast.

Byte writes are staged in a temporary `ByteImage`; any bounds, target, initialization, or storage-limit error leaves destination bytes and relocations unchanged. A full allocation write can initialize uninitialized storage. Typed field writes can create a partially initialized image: byte comparison rejects an unreadable range, filling initializes exactly its range, and copying propagates the source initialization mask. Copying uninitialized bytes does not make them readable. A partial raw write into an entirely uninitialized allocation still rejects until a typed write creates its image.

Whole copies preserve complete virtual pointer/procedure relocations. Partial overwrite discards overlapping relocation provenance; arbitrary nonzero bytes cannot become a valid virtual handle. Zeroing pointer storage reconstructs a null pointer. Canonical pointer identities use memory identity, allocation generation identity, and target byte offset. Their encoded bytes use a nonrecycled, target-aligned virtual allocation base plus that offset, so equivalent addresses have equal bytes even through casts or projections. Their ordering is not a statement about native address order. A target whose pointer width cannot represent another virtual region reports exhaustion explicitly.

The compile-time VM is single threaded, so compare/read/store forms one VM operation. Native code must lower compare-and-swap with sequentially consistent atomic ordering; ordinary loads and stores do not supply that guarantee.

`swap` checks writable bounds for both places and loads both values before either write. Identical initialized addresses are valid; partial overlap between distinct places is rejected. Failed stores restore a memory snapshot while preserving monotonic virtual allocation/address counters. Target-aware work accounting includes aggregate shape, root byte storage, and memory metadata, so zero-sized arrays and address-origin metadata still consume fuel. Data aliases encode the live allocation base plus their offset directly and retain no historical handle-table entries. Snapshot accounting still charges live virtual-region entries and the retained procedure-ledger capacity: repeatedly replacing one procedure cell can grow that ledger while its live byte image stays the same size. Compiler-only `Type`, captured code, and void values are outside the current swap contract.

The local pinned corpus has no SIMD intrinsic or vector type declaration. Its `Bit_Operations.jai` implementations use `#expand` and `#asm`; the commented `bit_scan_forward #intrinsic` declaration is not an active API. Their source expansion and assembly lowering require separate implementations. This catalog does not substitute name-based bit-operation shortcuts for those bodies.

The supplied OpenJai `Pool` and `Flat_Pool` modules additionally declare six checked `get`, `reset`, `release`, and `fini` operations. The VM owns their blocks in a descriptor ledger, and typed LLVM builders generate native allocation, reset, and destruction bodies. Source fixtures import and execute the unchanged modules through both backends. See [pool intrinsics](pool-intrinsics.md) for exact signatures, lifetime checks, budgets, target layouts, and the boundary between source evidence and independent policy.

| Source module | Checked pool declarations |
| --- | --- |
| `corpus/upstream/withlang-dev--open-jai/modules/Pool/module.jai` | `get(*Pool, int) -> *void`, `reset(*Pool)`, `release(*Pool)` |
| `corpus/upstream/withlang-dev--open-jai/modules/Flat_Pool/module.jai` | `get(*Flat_Pool, int) -> *void`, `reset(*Flat_Pool, bool)`, `fini(*Flat_Pool)` |

The pool allocator constants are 2 and 3, respectively; `Pool.set_allocators` sets a 65,536-byte block size, and `Flat_Pool.alignment` defaults to 8. These constants remain ordinary source values. They do not grant foreign allocator providers authority or convert integers into callable procedures. The six intrinsic identities retain their exact nominal self types and descriptor schemas.

## How to change it

`jai-sema/src/modules/runtime_intrinsics.rs` binds file, local, and specialized generic prototypes using their checked signature and explicitly selected target layout. The tag overrides the declared source name; absent a tag, the marked declaration's own name selects the catalog entry. `PrototypeOrigin::Intrinsic` carries the closed operation identity into the IR, whose publication boundary rechecks the complete signature shape without assuming a host target. VM invocation and native emission also check target-dependent storage.

Keep incomplete type errors typed when adapting catalog validation into VM errors. A staged atomic type must report its dependency to the scheduler before any memory effect; converting that error into a diagnostic string prematurely makes a resumable request fail.

Add a closed `RuntimeIntrinsic` variant and its exact signature validation first. Add execution in the VM adapter and corresponding native lowering; ensure source binding records the intrinsic identity after normal scope and overload resolution. Unknown tags must produce a source-located diagnostic.

Add tests for argument/result types, failed-operation atomicity, zero counts, bounds, provenance, read-only storage, and target-dependent layout. For operations that execute byte work, charge fuel before mutation. Generic intrinsic prototypes must bind only after the type substitution is concrete and validated.

The memory range helpers live in `jai-vm/src/memory/runtime_intrinsics.rs`; typed swap and its work bounds live in `memory/runtime_swap.rs`, and byte/atomic root accounting lives in `memory/runtime_work.rs`. `RuntimeProcedure::work_cost_for_target` is the VM budget boundary; `work_cost` remains a legacy scalar-count estimate and must not be used by an execution provider. Relocation-aware byte patches live in `jai-vm/src/byte_memory/ranges.rs`, with address overlays and comparison proofs under `byte_memory/provenance`. Preserve the distinction between disjoint `memcpy` and explicit overlapping `copy_range_within` operations.

Before estimating adapter work, the VM admits pointer layouts through `visit_pointer_layouts` and Pool field/backing layouts through `visit_additional_layouts`. These walkers borrow pointers and pass type IDs without cloning paths or collecting an uncharged demand list. Zero-byte operations and zero-size Pool allocations request no pointer or backing layout. Signature shape validation precedes preparation, while actual storage checks consume the selected target's admitted facts. Swap reads the cached decoded-cell bound instead of rewalking aggregate types on every warm call; saturated bounds still allow address-layout preparation and reject a later operation that would exceed its value budget. Cached target facts count toward `Memory.value_cells` even after their value allocations are released; operation tests must separate this retained preparation state from mutation of user storage.

## Configuration

`RuntimeIntrinsic::bind` and `validate_signature` take an explicit `LayoutPolicy`. VM storage uses `ByteTarget`, including its byte order; it does not inherit Rust host layout. `Limits::fuel`, `Limits::value_cells`, and `Limits::evaluation_depth` bound intrinsic work and values. There are no environment variables or native library dependencies for VM execution.

## Dependencies

The catalog depends on `jai-types` for nominal identities, procedure signatures, and target layouts. The VM adapter depends on `jai-ir`, `Memory`, `Value`, and `ByteImage`. Native lowering depends on the LLVM bridge. Corpus inspection is static only: no original compiler executable or bundled native code is loaded to implement or test these operations.
