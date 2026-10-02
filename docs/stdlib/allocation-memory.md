# Allocation, memory, and hashing

## What it is

These are independently authored Jai implementations of allocation wrappers, temporary storage, byte operations, reflection-driven copying, and compatibility hashes. Their public contracts are compared with the supplied module sources and the maintained OpenJai source; neither source tree is loaded as executable implementation.

The machine-readable [coverage report](../../stdlib/.coverage/allocation-memory.json) distinguishes authored bodies, parsing, and executed behavior. The Meow hash module is missing; no replacement hash is passed off as Meow.

## How it works

`Basic/allocation.jai` sends requests through the selected `Allocator`. Its default parameters use `context.allocator`. The temporary allocator pads requests to eight bytes and keeps overflow pages in a stack. Marks restore the cursor and free newer pages through the allocator recorded in each page. A supplied initial buffer is borrowed; `deinit_temporary_storage(..., free_original=true)` explicitly releases an owned initial buffer.

`Default_Allocator` obtains byte storage through genuine system C `malloc`, `realloc`, and `free` declarations. An independently implemented Jai ledger records each live pointer, size, and heap. A compare-and-swap lock protects the ledger. Separate heaps have separate linked lists, destruction frees their allocations, and ownership queries require an exact allocation pointer. A failed replacement leaves the old allocation live. The C declarations require a trusted source receipt before the VM may route them to its own bounded virtual heap.

`Overwriting_Allocator` records allocation sizes in `Table(*void,u64)`, detects invalid pointers and double frees, and writes the configured poison byte before releasing storage. Resize allocates a different block, copies the retained prefix, poisons the old block, then frees it. Its table is protected by the authored `Thread.Mutex` API.

`Unmapping_Allocator` uses POSIX `mmap` and `mprotect`. It places the end of each allocation immediately before a guard page. Freeing changes the entire mapping to inaccessible memory and retains its address reservation. This catches writes beyond the end and accesses through retired pointers in a native process. Reservations deliberately survive allocator deinitialization; this diagnostic allocator can consume substantial virtual address space. The VM does not have an authorized mapping/protection adapter for these declarations, so this behavior remains unverified there.

`Memory.copy` uses memmove semantics. It detects overlap with pointer equality at byte offsets, avoiding conversion of VM addresses into portable integers. Disjoint ranges use the checked `memcpy` intrinsic. Overlapping byte ranges copy in the appropriate direction. Overlap containing virtual pointer/procedure relocations still needs separate acceptance evidence.

`Bit_Operations` uses byte reversal and integer bit masks rather than assembly. `Hash` implements SDBM, DJB2, FNV-1a, and Knuth recurrences. Pointer `get_hash` returns the seed, so pointer keys remain correct under equality while sharing a hash bucket; this avoids exposing VM address encodings and costs distribution. `xxHash` streams bytes into a block buffer and updates its four lanes when the buffer fills. Its little-endian reads are explicit.

`Deep_Copy` first records each old/new allocation pair, then visits reflected members. This preserves exact-pointer aliasing and cycles. Strings may use the configured mapper, dynamic arrays get new backing, fixed arrays visit their elements, and `NoDeepCopy` members remain shallow. `Any`, procedure pointers, void pointers, and pointers into the interior of a previously copied block remain shallow or outside the supported alias model. Allocation failure can leave a partially copied graph; the routine does not provide rollback. `Remap_Context` matches fields by name and runtime size, recursively handling the `base` record, and then restores the local context descriptor.

## How to change it

Keep allocator dispatch in Jai. Add a host primitive only when its exact signature and source identity can be authorized by the Rust binder and both backend implementations have real behavior. A symbol name alone must not grant access to native or VM resources.

Heap ownership changes belong in `Default_Allocator/module.jai`; temporary lifetime changes belong in `Basic/allocation.jai`. Keep the `Temporary_Storage` layout synchronized with the independent `Runtime_Support` schema. Guard-page ports need the target's actual mapping flags and page-size query; do not substitute poison bytes for memory protection.

The maintained source conflicts with the older source in three places. `crc64` uses CRC-64/ECMA-182; `crc64_we` explicitly preserves the older CRC-64/WE convention. Default `NewArray(count,T)` returns a single view, while the older tuple overload requires an explicit baked `initialized` argument. The maintained `get_capabilities` returns `(bool,string)`; `get_capabilities_info` retains the allocator flag result. The current `xxHash` state layouts omit the older reserved fields and its update declarations use `input_ptr:*u8`.

Run the portable source acceptance fixture with the independently authored prelude:

```sh
JAI_RS_STDLIB="$PWD/stdlib" JAI_RS_PRELOAD="$PWD/prelude/Preload.jai" \
  target/debug/jai-rs check tests/stdlib/allocation-memory.jai
```

The fixture executes CRC vectors, known string hashes, empty xxHash vectors, multi-block split streaming, and both overlapping byte-copy directions through `#assert #run`. `tests/stdlib/bit-operations.jai` and `tests/stdlib/default-allocator.jai` are separate acceptance gates. The frozen compiler checks the portable fixture successfully but blocks bit expansion results and allocator foreign-call authorization. No native guard-page, mutex, deep-copy graph, or remapped-context behavior is claimed as verified.

## Configuration

`Default_Allocator` retains `ENABLE_ASSERTS=true` and `ENABLE_VALIDATE_ARGS=true`. `Memory` accepts `with_candidates=false` and `with_unwraps=false`; selecting either unimplemented experiment fails explicitly. `Overwriting_Allocator` defaults `overwrite_byte` to `0xcd` and defaults an empty base allocator to the active context allocator.

Temporary poisoning follows Basic's `TEMP_ALLOCATOR_POISON_FREED_MEMORY`. `NewArray`'s current single-result forms support the default alignment only; positive custom alignment requires the explicit initialized tuple form, whose returned base must be retained for freeing. `Deep_Copy` exposes `DC_DEBUG=false`, `DEBUG_PRINT=false`, debug depth/allocation counters, and `follow_struct_pointers=true`. Its legacy `time_total` field is retained but elapsed-time instrumentation is not implemented. `Remap_Context` retains `VERBOSE=true`, which announces remapping through contextless runtime output; detailed per-field diagnostics are not implemented.

## Dependencies

The modules depend on the independent prelude for allocator, reflection, and memory/atomic intrinsic contracts. Allocation wrappers depend on `Runtime_Support` context and temporary storage; debug allocators and deep copying additionally depend on authored Basic, Hash_Table, and Thread. Default allocation binds system `libc` or Windows `msvcrt` declarations, while guard pages currently require macOS, Linux, or Android POSIX APIs. No bundled native library, reference executable, vendored allocator source, or Meow hash implementation is included.
