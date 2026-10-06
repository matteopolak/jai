# Memory, allocators and hashing

## What it is

Allocation wrappers and temporary storage (`Basic/allocation.jai`), the system-heap allocator (`Default_Allocator`), bump and diagnostic allocators (`Pool`, `Flat_Pool`, `Overwriting_Allocator`, `Unmapping_Allocator`), byte copying (`Memory`), reflection-driven copying (`Deep_Copy`, `Remap_Context`) and the checksum/hash modules (`Hash`, `Crc`, `xxHash`).

## How it works

`Basic/allocation.jai` routes `alloc`/`free`/`NewArray` through the `Allocator` in `context.allocator`. The temporary allocator pads requests to 8 bytes and keeps overflow pages on a stack; `set_temporary_storage_mark` and `reset_temporary_storage` restore it. A caller-supplied initial buffer is borrowed.

`Default_Allocator` calls libc `malloc`/`realloc`/`free` and keeps a ledger of live pointers per heap behind a compare-and-swap lock, so double frees and foreign pointers are caught (`ENABLE_ASSERTS`). The ledger is an open-addressing pointer set (linear probing, backward-shift deletion) kept at most half full, so `FREE` and `RESIZE` are O(1) even with many live allocations. Fresh tables come from `calloc`. `allocator_proc` tests `ALLOCATE`, `FREE` and `RESIZE` before the rare modes, because metaprograms run it in the interpreter where every test costs. Ledger entries are tagged in their low four bits (the hash starts at bit 4, so tags never move an entry); see alignment below.

`Overwriting_Allocator` (`get_overwriting_allocator(base, overwrite_byte := 0xcd)`) records sizes in a `Table`, rejects invalid pointers and double frees, and poisons memory before releasing it. `Unmapping_Allocator` (POSIX only) uses `mmap`/`mprotect` to put each allocation against a guard page and makes freed blocks inaccessible. It never releases the address reservation, so it can use a lot of virtual address space.

### Alignment

`Default_Allocator` returns blocks of 64 bytes or more on a 64-byte (cache-line) boundary, and smaller blocks at malloc's 16. The allocator protocol has no alignment parameter, so this is how `New`, `NewArray`, `array_add` growth and `realloc` honor `#align 64` types: such a type's size is a multiple of 64, so its requests always take the aligned path. Larger alignments (`#align 128`, `#align 4096`) are not guaranteed for heap objects; allocate with `NewArray(..., alignment = N)` (free the returned `unaligned_base`) or over-allocate yourself. Globals and locals do honor any alignment, natively and in the interpreter.

The aligned path uses only `malloc`/`realloc`/`free`: compile-time code of a cross build (`-os windows` on macOS) calls the host's C library, so `posix_memalign` or `_aligned_malloc` would each be missing on some host/target pair. A "wide" block is malloc'd 48 bytes larger than asked and used from its first 64-byte boundary (malloc is 16-aligned, so at most 48 bytes are skipped). Its ledger entry is the boundary address with bit 3 set and the skipped bytes / 16 in bits 0-1, which is all `free` needs to find malloc's block. `RESIZE` reallocs the malloc block (with the same slack) and `memmove`s the contents to the new boundary if the skip changed; a plain block that grows to 64 bytes becomes wide this way, and a wide block stays wide when it shrinks. Cost: 48 bytes per block of 64 bytes or more. A default-allocator block of 64+ bytes must never be passed to C `free` directly; free it through the allocator.

`rpmalloc`'s allocator proc passes alignment 64 to rpmalloc for requests of 64 bytes or more, for the same guarantee. `Overwriting_Allocator` inherits its base allocator's alignment. `Unmapping_Allocator` deliberately ends each block at its guard page, so its blocks are only as aligned as their size; do not use it for over-aligned types.

### Pools

`Pool` is a bump allocator over 65536-byte blocks from `block_allocator` (default `context.allocator`), each with an 8-byte link header. Requests of 6554 bytes or more are allocated separately (`out_of_band_allocations`). Frees through the pool are ignored; `reset` returns blocks to an unused list (newest first, so the first `get` after a reset reuses the block that was current), and `release` also frees them. `RESIZE` always copies into a fresh allocation; the thread and heap allocator modes assert. Programs print its public fields (`memblock_size`, `bytes_left`, ...), so keep their order and defaults.

`Flat_Pool` has the public five-field record (`alignment`, `current_point`, `memory_base`, `first_uncommitted_page`, `address_limit`) over one contiguous reservation. `init(pool, reserve)` or the first `get` makes a single heap allocation of `DEFAULT_VIRTUAL_MEMORY_RESERVE` bytes (default 256 MiB, committed lazily by the OS); `get` bumps `current_point` and asserts when the reservation runs out; `reset(pool, overwrite_memory)` rewinds; `fini` frees.

### Copying and hashing

`Memory.copy(dest, src, count)` has memmove semantics: overlap is detected by pointer comparison and the copy direction is chosen accordingly.


`Deep_Copy` first records old-to-new allocation pairs, then walks the reflected members, so aliasing and cycles are preserved. Strings and dynamic arrays get new backing, `NoDeepCopy` members stay shallow, and `Any`, procedure pointers and `*void` stay shallow. There is no rollback on allocation failure. `Remap_Context` maps a foreign `#Context` onto the local one by member name and size.

Hashes: `Hash` has `sdbm_hash`, `djb2_hash`, `fnv1a_hash` and the `get_hash` overloads. Pointer keys go through `knuth_hash`. `Crc` has `crc64` (CRC-64/ECMA-182) and `crc64_we`. `xxHash` is scalar XXH32/XXH64 with streaming state.

```jai
#import "Basic";
#import "Overwriting_Allocator";

main :: () {
    a := get_overwriting_allocator();
    p := alloc(16, a);
    free(p, a);   // memory is filled with 0xcd before release
}
```

## How to change it

- Dispatch stays in Jai; the interpreter provides the actual page and memory intrinsics (see [compiler architecture](../compiler/architecture.md)).
- Heap ownership changes go in `Default_Allocator/module.jai`; temporary-storage lifetime changes in `Basic/allocation.jai`. Keep `Temporary_Storage` in sync with `prelude/runtime-storage.jai` and `Runtime_Support`.
- Alignment policy: `CACHE_LINE`/`WIDE_SLACK` and `obtain_block`/`regrow_block`/`release_block` in `Default_Allocator/module.jai`. Raising the guarantee (say to 128) means raising both constants and widening the skip field (bits 0-1 hold up to 48/16); bits 0-3 of plain entries must stay clear, which relies on malloc's 16-byte alignment.
- Tests: `tests/stdlib/allocation-memory.jai`, `default-allocator.jai`, `over-aligned-allocation.jai` (also built natively by `native.rs` and on Windows by `tools/windows_cross.py`), `pool-standard-behavior.jai`, `storage-*-contract.jai`, `memory-debugger-*.jai`, `bit-operations.jai`.
- Gotchas: `crc64` follows the maintained ECMA contract; use `crc64_we` for the older convention. `stdlib/meow_hash` holds only the version constants and default seed; callers pick a fallback hash, since the real one needs x64 AES instructions.

## Configuration

`Default_Allocator(ENABLE_ASSERTS=true, ENABLE_VALIDATE_ARGS=true)`. `Memory(with_candidates=false, with_unwraps=false)`; setting either fails at compile time. `Pool(USE_UNMAPPING_ALLOCATOR=false)` must stay false. `Basic(TEMP_ALLOCATOR_POISON_FREED_MEMORY)` poisons freed temporary memory. Per-pool fields: `memblock_size`, `oversized_size`, `alignment`, `overwrite_memory`, `free_memblocks_on_reset`. `Deep_Copy(DC_DEBUG=false, DEBUG_PRINT=false)` are module parameters; `follow_struct_pointers` is a field of its config.

## Dependencies

`Basic`, `Hash_Table` and `Thread` (the diagnostic allocators), libc (`malloc`, `realloc`, `free`, `memmove`, `mmap`), the prelude's allocator and reflection types.
