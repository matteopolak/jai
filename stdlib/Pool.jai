// Pool: a bump allocator for many allocations that share one lifetime.
//
// Memory comes from large blocks obtained from a "block allocator" (by default the
// context allocator at first use). Individual frees are ignored; `reset` recycles every
// block, and `release` hands them back. Requests of `oversized_size` bytes or more skip
// the blocks entirely and are served by one separate allocation each, remembered in
// `out_of_band_allocations` so reset/release can free them.
#module_parameters ()(USE_UNMAPPING_ALLOCATOR := false);

// With USE_UNMAPPING_ALLOCATOR, a pool that was not given a block allocator takes its blocks
// from one guard-page allocator shared by every such pool in the program, so a stale pointer into
// a released pool faults instead of reading recycled memory. That needs virtual memory (not wasm).
// (Reset keeps its blocks for reuse; set free_memblocks_on_reset to have reset retire them too.)
#if USE_UNMAPPING_ALLOCATOR {
    #import "Unmapping_Allocator";
    #import "Atomics";

    guard_allocator: Allocator;
    guard_state: s64; // 0 not made, 1 being made or read, 2 ready

    shared_guard_allocator :: () -> Allocator {
        while true {
            before := atomic_swap(*guard_state, 1);
            if before == 1 continue;
            if before == 0 {
                push_allocator(context.default_allocator);
                guard_allocator = get_unmapping_allocator();
            }
            result := guard_allocator;
            atomic_write(*guard_state, 2);
            return result;
        }
        return .{};
    }
}

POOL_BUCKET_SIZE_DEFAULT :: 65536;
POOL_OVERSIZED_SIZE_DEFAULT :: 6554;

STAMP :: 0xcc; // fill byte used when overwrite_memory is on
HEADER_SIZE :: size_of(Memblock); // bytes at the front of every block used for the list link

Pool :: struct {
    memblock_size: s64 = POOL_BUCKET_SIZE_DEFAULT; // full size of each block, header included
    oversized_size: s64 = POOL_OVERSIZED_SIZE_DEFAULT; // requests at least this big get their own allocation
    alignment := 8; // power of two; padding_for relies on it

    current_memblock: *Memblock;
    current_pos: *u8;
    bytes_left: s64;

    block_allocator: Allocator;

    // Bookkeeping lists, linked through Memblock.next.
    unused_memblocks: *Memblock;
    used_memblocks: *Memblock;
    first_used_memblock: *Memblock; // tail of used_memblocks, so reset can splice in O(1)
    out_of_band_allocations: *Memblock;

    overwrite_memory := false; // fill released/recycled memory with STAMP (debugging aid)
    free_memblocks_on_reset := false; // give blocks back on reset instead of keeping them

    logging_options: enum_flags u32 {
        LOG_OVERSIZED_ALLOCATIONS :: 0x1;
        LOG_OVERSIZED_ALLOCATIONS_AS_ERRORS :: 0x2;
        LOG_OVERSIZED_ALLOCATIONS_STACK_TRACE :: 0x4;
    }
}

// Pick the allocator that supplies blocks. Only valid on a fresh pool; a pool that was
// never configured adopts context.allocator on its first `get`.
set_allocators :: (pool: *Pool, block_allocator: Allocator = .{}) {
    if pool.block_allocator.proc != null {
        log_error("Pool %: set_allocators was called after the pool started handing out memory; the call is ignored.\n", pool);
        return;
    }
    supplier := block_allocator;
    #if USE_UNMAPPING_ALLOCATOR {
        if supplier.proc == null supplier = shared_guard_allocator();
    }
    if supplier.proc == null supplier = context.allocator;
    // A pool cannot feed itself: asking it for a block would ask it for a block again.
    feeds_itself := supplier.proc == pool_allocator_proc && supplier.data == pool;
    if feeds_itself {
        log_error("Pool % would have to allocate its blocks from itself. Give it a block allocator with set_allocators before installing it as context.allocator.\n", pool);
        assert(false);
        supplier = context.default_allocator;
    }
    pool.block_allocator = supplier;
}

get :: (pool: *Pool, nbytes: s64) -> *void {
    assert(nbytes >= 0);
    if !pool.block_allocator.proc set_allocators(pool);

    // Large (or block-exceeding) requests are not pooled.
    if nbytes >= pool.oversized_size || nbytes + pool.alignment - 1 > pool.memblock_size - HEADER_SIZE {
        wanted := (nbytes + HEADER_SIZE + pool.alignment - 1 + 7) & ~7; // keeps the link field aligned
        raw := cast(*Memblock) alloc(wanted, pool.block_allocator);
        if !raw return null;

        raw.next = pool.out_of_band_allocations;
        pool.out_of_band_allocations = raw;

        if pool.logging_options & .LOG_OVERSIZED_ALLOCATIONS {
            flags := Log_Flags.NONE;
            if pool.logging_options & .LOG_OVERSIZED_ALLOCATIONS_AS_ERRORS flags = .ERROR;
            log("Oversized allocation of % bytes in pool %.\n", nbytes, pool, flags = flags);
            if pool.logging_options & .LOG_OVERSIZED_ALLOCATIONS_STACK_TRACE log_stack_trace(context.stack_trace);
        }

        start := cast(*u8) *raw.data;
        return start + padding_for(start, pool.alignment);
    }

    pad := padding_for(pool.current_pos, pool.alignment);
    if pool.bytes_left < nbytes + pad {
        if !take_block(pool) return null;
        pad = padding_for(pool.current_pos, pool.alignment); // new block, new address
    }

    result := pool.current_pos + pad;
    pool.current_pos += nbytes + pad;
    pool.bytes_left -= nbytes + pad;

    if pool.overwrite_memory assert(result[0] == STAMP);
    return result;
}

// Forget everything handed out so far. Blocks are kept for reuse (or returned, with
// free_memblocks_on_reset); oversized allocations always go back to the block allocator.
reset :: (pool: *Pool) {
    // Recycled blocks keep their order, newest first, so the next `get` lands in the
    // block that was current before the reset.
    if pool.free_memblocks_on_reset {
        free_chain(pool, pool.used_memblocks);
        free_chain(pool, pool.unused_memblocks);
        pool.unused_memblocks = null;
    } else if pool.used_memblocks {
        last := pool.used_memblocks;
        while true {
            if pool.overwrite_memory stamp(pool, last);
            if !last.next break;
            last = last.next;
        }
        last.next = pool.unused_memblocks;
        pool.unused_memblocks = pool.used_memblocks;
    }
    free_chain(pool, pool.out_of_band_allocations);

    pool.used_memblocks = null;
    pool.first_used_memblock = null;
    pool.out_of_band_allocations = null;
    pool.current_memblock = null;
    pool.current_pos = null;
    pool.bytes_left = 0;
}

// Reset, then give every block back to the block allocator.
release :: (pool: *Pool) {
    reset(pool);
    free_chain(pool, pool.unused_memblocks);
    pool.unused_memblocks = null;
}

// Allocator entry point: `data` is the *Pool. FREE is a no-op; RESIZE always copies
// into a fresh allocation because a bump pointer cannot grow in place reliably.
pool_allocator_proc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void {
    pool := cast(*Pool) allocator_data;

    if mode == {
        case .ALLOCATE;
            assert(pool != null, "Pool allocator used without a Pool as its data.");
            return get(pool, requested_size);

        case .RESIZE;
            assert(pool != null, "Pool allocator used without a Pool as its data.");
            moved := get(pool, requested_size);
            keep := ifx old_size < requested_size then old_size else requested_size;
            if moved && keep > 0 memcpy(moved, old_memory, keep);
            return moved;

        case .IS_THIS_YOURS;
            if owns_address(pool, cast(*u8) old_memory) return cast(*void) 1;
            return null;

        case .CAPS;
            name_out := cast(*string) old_memory;
            if name_out name_out.* = CAPS_VERSION_STRING;
            return cast(*void) (Allocator_Caps.HINT_I_AM_A_FAST_BUMP_ALLOCATOR | .IS_THIS_YOURS);

    }

    // FREE, STARTUP and SHUTDOWN need no work. Thread and heap modes are not meaningful
    // for a single-threaded bump allocator and indicate a caller bug.
    multi := mode == .THREAD_START || mode == .THREAD_STOP || mode == .CREATE_HEAP || mode == .DESTROY_HEAP;
    assert(!multi, "Pool: allocator mode % is unsupported; a Pool is single-threaded and is not a heap factory.\n", mode);
    return null;
}

// Bytes handed out from blocks (block capacity minus what is still free in the current
// block), and how many oversized allocations are outstanding.
calculate_used_memory :: (pool: Pool) -> inband_size: s64, outband_count: s64 {
    capacity := chain_length(pool.used_memblocks) * pool.memblock_size;
    assert(capacity >= pool.bytes_left);
    return capacity - pool.bytes_left, chain_length(pool.out_of_band_allocations);
}

#scope_file

Memblock :: struct {
    next: *Memblock;
    data: void; // address of this field marks where payload begins
}

chain_length :: (chain: *Memblock) -> s64 {
    n := 0;
    link := chain;
    while link {
        n += 1;
        link = link.next;
    }
    return n;
}

// A pointer belongs to the pool if it lies inside a live block, or within the alignment
// slack at the start of an oversized allocation (that is all `get` ever returns there).
owns_address :: (pool: *Pool, address: *u8) -> bool {
    return chain_covers(pool.used_memblocks, address, pool.memblock_size)
        || chain_covers(pool.out_of_band_allocations, address, pool.alignment);
}

chain_covers :: (chain: *Memblock, address: *u8, span: s64) -> bool {
    link := chain;
    while link {
        first := cast(*u8) *link.data;
        if address >= first && address <= first + span return true;
        link = link.next;
    }
    return false;
}

free_chain :: (pool: *Pool, chain: *Memblock) {
    cursor := chain;
    while cursor {
        following := cursor.next;
        free(cursor, pool.block_allocator);
        cursor = following;
    }
}

// Move a block (recycled if possible) to the front of the used chain and make it current.
take_block :: (pool: *Pool) -> bool {
    block: *Memblock;
    if pool.unused_memblocks {
        block = pool.unused_memblocks;
        pool.unused_memblocks = block.next;
    } else {
        block = cast(*Memblock) alloc(pool.memblock_size, pool.block_allocator);
        if !block return false;
        if pool.overwrite_memory stamp(pool, block);
    }

    block.next = pool.used_memblocks;
    pool.used_memblocks = block;
    if !pool.first_used_memblock pool.first_used_memblock = block;

    pool.current_memblock = block;
    pool.current_pos = cast(*u8) *block.data;
    pool.bytes_left = pool.memblock_size - HEADER_SIZE;
    return true;
}

stamp :: (pool: *Pool, block: *Memblock) {
    memset(*block.data, STAMP, pool.memblock_size - HEADER_SIZE);
}

// Bytes to add to `address` to reach the next multiple of `alignment` (0 if already aligned).
padding_for :: (address: *u8, alignment: s64) -> s64 #no_aoc {
    mask := cast(u64) (alignment - 1);
    return cast(s64) ((cast(u64) 0 - cast(u64) address) & mask);
}

CAPS_VERSION_STRING :: "modules/Pool";

#scope_module
#import "Basic";
