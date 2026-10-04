# Memory, allocators and hashing

## What it is

Allocation wrappers and temporary storage (`Basic/allocation.jai`), the system-heap allocator (`Default_Allocator`), bump and diagnostic allocators (`Pool`, `Flat_Pool`, `Overwriting_Allocator`, `Unmapping_Allocator`), byte copying (`Memory`), reflection-driven copying (`Deep_Copy`, `Remap_Context`) and the checksum/hash modules (`Hash`, `Crc`, `xxHash`).

## How it works

`Basic/allocation.jai` routes `alloc`/`free`/`NewArray` through the `Allocator` in `context.allocator`. The temporary allocator pads requests to 8 bytes and keeps overflow pages on a stack; `set_temporary_storage_mark` and `reset_temporary_storage` restore it. A caller-supplied initial buffer is borrowed.

`Default_Allocator` calls libc `malloc`/`realloc`/`free` and keeps a ledger of live pointers per heap behind a compare-and-swap lock, so double frees and foreign pointers are caught (`ENABLE_ASSERTS`). `Overwriting_Allocator` (`get_overwriting_allocator(base, overwrite_byte := 0xcd)`) records sizes in a `Table`, rejects invalid pointers and double frees, and poisons memory before releasing it. `Unmapping_Allocator` uses `mmap`/`mprotect` to place each allocation against a guard page and makes freed blocks inaccessible; it keeps the address reservation, so it can use a lot of virtual address space. It needs a POSIX target.

`Pool` is a bump allocator: 65536-byte blocks from `block_allocator` (default `context.allocator`), each with an 8-byte link header; requests of 6554 bytes or more are allocated separately (`out_of_band_allocations`); `reset` returns blocks to an unused list and `release` also frees them; frees through the pool are ignored. Its public fields (`memblock_size`, `bytes_left`, ...) are printed by programs, so keep order and defaults. `Flat_Pool` is a five-field record (`memblock_size`, `bytes_left`, `current_block`, `current_pos`, `alignment`) with `init`, `get`, `reset`, `fini` and `flat_pool_allocator_proc`. `stdlib/legacy/Pool.jai` and `legacy/Flat_Pool.jai` are older implementations used by the memory debugger.

`Memory.copy(dest, src, count)` has memmove semantics: overlap is detected by pointer comparison and the copy direction is chosen accordingly.

`Deep_Copy` first records old-to-new allocation pairs, then walks the reflected members, so aliasing and cycles are preserved. Strings and dynamic arrays get new backing, `NoDeepCopy` members stay shallow, and `Any`, procedure pointers and `*void` stay shallow. There is no rollback on allocation failure. `Remap_Context` maps a foreign `#Context` onto the local one by member name and size.

Hashes: `Hash` has `sdbm_hash`, `djb2_hash`, `fnv1a_hash` and the `get_hash` overloads. Pointer keys hash to the seed (all collide, equality still correct). `Crc` has `crc64` (CRC-64/ECMA-182) and `crc64_we`. `xxHash` is scalar XXH32/XXH64 with streaming state.

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
- Tests: `tests/stdlib/allocation-memory.jai`, `default-allocator.jai`, `pool-standard-behavior.jai`, `storage-*-contract.jai`, `memory-debugger-*.jai`, `bit-operations.jai`.
- Gotchas: `crc64` follows the maintained ECMA contract; use `crc64_we` for the older convention. `stdlib/meow_hash` holds only the version constants and default seed; callers pick a fallback hash, since the real one needs x64 AES instructions.

## Configuration

`Default_Allocator(ENABLE_ASSERTS=true, ENABLE_VALIDATE_ARGS=true)`. `Memory(with_candidates=false, with_unwraps=false)`; setting either fails at compile time. `Pool(USE_UNMAPPING_ALLOCATOR=false)` must stay false. `Basic(TEMP_ALLOCATOR_POISON_FREED_MEMORY)` poisons freed temporary memory. Per-pool fields: `memblock_size`, `oversized_size`, `alignment`, `overwrite_memory`, `free_memblocks_on_reset`. `Deep_Copy(DC_DEBUG=false, DEBUG_PRINT=false)` are module parameters; `follow_struct_pointers` is a field of its config.

## Dependencies

`Basic`, `Hash_Table` and `Thread` (the diagnostic allocators), libc (`malloc`, `mmap`), the prelude's allocator and reflection types.
