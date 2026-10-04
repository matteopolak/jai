// Pool: a bump allocator for many allocations that share one lifetime.
//
// Memory comes from large blocks obtained from a "block allocator" (by default the
// context allocator at first use). Individual frees are ignored; `reset` recycles every
// block, and `release` hands them back. Requests of `oversized_size` bytes or more skip
// the blocks entirely and are served by one separate allocation each, remembered in
// `out_of_band_allocations` so reset/release can free them.
#module_parameters ()(USE_UNMAPPING_ALLOCATOR := false);
#assert !USE_UNMAPPING_ALLOCATOR "Pool: USE_UNMAPPING_ALLOCATOR is not supported by this implementation.";

POOL_BUCKET_SIZE_DEFAULT    :: 65536;
POOL_OVERSIZED_SIZE_DEFAULT :: 6554;

STAMP :: 0xcc;                       // fill byte used when overwrite_memory is on
HEADER_SIZE :: size_of(Memblock);    // bytes at the front of every block used for the list link

Pool :: struct {
    memblock_size:  s64 = POOL_BUCKET_SIZE_DEFAULT;   // full size of each block, header included
    oversized_size: s64 = POOL_OVERSIZED_SIZE_DEFAULT; // requests at least this big get their own allocation
    alignment := 8;                                    // must be a power of two (not checked)

    current_memblock: *Memblock;
    current_pos:      *u8;
    bytes_left:       s64;

    block_allocator: Allocator;

    // Bookkeeping lists, linked through Memblock.next.
    unused_memblocks:        *Memblock;
    used_memblocks:          *Memblock;
    first_used_memblock:     *Memblock;   // tail of used_memblocks, so reset can splice in O(1)
    out_of_band_allocations: *Memblock;

    overwrite_memory        := false;   // fill released/recycled memory with STAMP (debugging aid)
    free_memblocks_on_reset := false;   // give blocks back on reset instead of keeping them

    logging_options: enum_flags u32 {
        LOG_OVERSIZED_ALLOCATIONS             :: 0x1;
        LOG_OVERSIZED_ALLOCATIONS_AS_ERRORS   :: 0x2;
        LOG_OVERSIZED_ALLOCATIONS_STACK_TRACE :: 0x4;
    }
}

// Choose where the pool's blocks come from. Must happen before first use; if it is never
// called, the first `get` calls it with the context's allocator.
set_allocators :: (pool: *Pool, block_allocator: Allocator = .{}) {
    if pool.block_allocator.proc {
        log_error("Attempt to set allocators on Pool % after the Pool has already been used.\n", pool);
        return;
    }

    if block_allocator.proc {
        pool.block_allocator = block_allocator;
        return;
    }

    // Falling back to the context allocator: if that is this very pool we would recurse forever.
    if context.allocator.proc == pool_allocator_proc && context.allocator.data == pool {
        log_error("Pool % cannot take its blocks from context.allocator because that is the pool itself. Call set_allocators on the pool before making it the context allocator.\n", pool);
        assert(false);
        pool.block_allocator = context.default_allocator;
    } else {
        pool.block_allocator = context.allocator;
    }
}

get :: (pool: *Pool, nbytes: s64) -> *void {
    assert(nbytes >= 0);
    if !pool.block_allocator.proc  set_allocators(pool);

    // Large (or block-exceeding) requests are not pooled.
    if nbytes >= pool.oversized_size || nbytes + pool.alignment - 1 > pool.memblock_size - HEADER_SIZE {
        raw := cast(*Memblock) alloc(nbytes + HEADER_SIZE + pool.alignment - 1, pool.block_allocator);
        if !raw  return null;

        raw.next = pool.out_of_band_allocations;
        pool.out_of_band_allocations = raw;

        if pool.logging_options & .LOG_OVERSIZED_ALLOCATIONS {
            flags := Log_Flags.NONE;
            if pool.logging_options & .LOG_OVERSIZED_ALLOCATIONS_AS_ERRORS  flags = .ERROR;
            log("Oversized allocation of % bytes in pool %.\n", nbytes, pool, flags=flags);
            if pool.logging_options & .LOG_OVERSIZED_ALLOCATIONS_STACK_TRACE  log_stack_trace(context.stack_trace);
        }

        start := cast(*u8) *raw.data;
        return start + padding_for(start, pool.alignment);
    }

    pad := padding_for(pool.current_pos, pool.alignment);
    if pool.bytes_left < nbytes + pad {
        if !take_block(pool)  return null;
        pad = padding_for(pool.current_pos, pool.alignment);   // new block, new address
    }

    result := pool.current_pos + pad;
    pool.current_pos += nbytes + pad;
    pool.bytes_left  -= nbytes + pad;

    if pool.overwrite_memory  assert(result[0] == STAMP);
    return result;
}

// Make every block reusable; oversized allocations are freed.
reset :: (pool: *Pool) {
    if pool.overwrite_memory {
        block := pool.used_memblocks;
        while block {
            stamp(pool, block);
            block = block.next;
        }
    }

    if pool.first_used_memblock {
        assert(pool.used_memblocks != null);
        if pool.free_memblocks_on_reset {
            free_chain(pool, pool.unused_memblocks);
            free_chain(pool, pool.used_memblocks);
            pool.unused_memblocks = null;
        } else {
            // Splice the whole used chain in front of the unused chain.
            pool.first_used_memblock.next = pool.unused_memblocks;
            pool.unused_memblocks = pool.used_memblocks;
        }
        pool.used_memblocks      = null;
        pool.first_used_memblock = null;
    }

    free_chain(pool, pool.out_of_band_allocations);
    pool.out_of_band_allocations = null;

    pool.current_memblock = null;
    pool.current_pos      = null;
    pool.bytes_left       = 0;
}

// Reset, then give every block back to the block allocator.
release :: (pool: *Pool) {
    reset(pool);
    free_chain(pool, pool.unused_memblocks);
    pool.unused_memblocks = null;
}

pool_allocator_proc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void {
    if #complete mode == {
      case .FREE;
        return null;

      case .ALLOCATE; #through;
      case .RESIZE;
        pool := cast(*Pool) allocator_data;
        assert(pool != null);
        result := get(pool, requested_size);
        if mode == .RESIZE && result {
            count := min(old_size, requested_size);
            if count > 0  memcpy(result, old_memory, count);
        }
        return result;

      case .STARTUP; #through;
      case .SHUTDOWN;
        return null;

      case .THREAD_START; #through;
      case .THREAD_STOP;
        assert(false, "Multithreaded access is not supported by pool_allocator_proc.\n");
        return null;

      case .CREATE_HEAP; #through;
      case .DESTROY_HEAP;
        assert(false, "Create/Destroy heap are not supported by pool_allocator_proc.\n");
        return null;

      case .IS_THIS_YOURS;
        pool := cast(*Pool) allocator_data;
        block := pool.used_memblocks;
        while block {
            start := cast(*u8) *block.data;
            if cast(*u8) old_memory >= start && cast(*u8) old_memory <= start + pool.memblock_size  return cast(*void) 1;
            block = block.next;
        }
        // Oversized allocations are only guaranteed to lie within alignment slack of the header.
        block = pool.out_of_band_allocations;
        while block {
            start := cast(*u8) *block.data;
            if cast(*u8) old_memory >= start && cast(*u8) old_memory <= start + pool.alignment  return cast(*void) 1;
            block = block.next;
        }
        return null;

      case .CAPS;
        if old_memory  { <<cast(*string) old_memory = CAPS_VERSION_STRING; }
        return cast(*void) (Allocator_Caps.HINT_I_AM_A_FAST_BUMP_ALLOCATOR | .IS_THIS_YOURS);
    }
}

// Returns (bytes consumed inside blocks, number of oversized allocations).
calculate_used_memory :: (pool: Pool) -> inband_size: s64, outband_count: s64 {
    inband: s64;
    block := pool.used_memblocks;
    while block {
        inband += pool.memblock_size;
        block = block.next;
    }
    assert(inband >= pool.bytes_left);
    inband -= pool.bytes_left;

    outband: s64;
    block = pool.out_of_band_allocations;
    while block {
        outband += 1;
        block = block.next;
    }
    return inband, outband;
}

#scope_file

Memblock :: struct {
    next: *Memblock;
    data: void;   // address of this field marks where payload begins
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
        if !block  return false;
        if pool.overwrite_memory  stamp(pool, block);
    }

    block.next = pool.used_memblocks;
    pool.used_memblocks = block;
    if !pool.first_used_memblock  pool.first_used_memblock = block;

    pool.current_memblock = block;
    pool.current_pos      = cast(*u8) *block.data;
    pool.bytes_left       = pool.memblock_size - HEADER_SIZE;
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
