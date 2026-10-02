// Explicit legacy contract: aligned arenas, retained blocks, and large objects.
#module_parameters ()(USE_UNMAPPING_ALLOCATOR := false);
#assert !USE_UNMAPPING_ALLOCATOR;
#scope_file;
#import "Basic";
#scope_export;

POOL_BUCKET_SIZE_DEFAULT :: 65536;
POOL_OVERSIZED_SIZE_DEFAULT :: 6554;
STAMP :: 0xcc;
HEADER_SIZE :: size_of(Memblock);

Pool :: struct {
    memblock_size: s64 = POOL_BUCKET_SIZE_DEFAULT;
    oversized_size: s64 = POOL_OVERSIZED_SIZE_DEFAULT;
    alignment := 8;
    current_memblock: *Memblock;
    current_pos: *u8;
    bytes_left: s64;
    block_allocator: Allocator;
    unused_memblocks: *Memblock;
    used_memblocks: *Memblock;
    first_used_memblock: *Memblock;
    out_of_band_allocations: *Memblock;
    overwrite_memory := false;
    free_memblocks_on_reset := false;
    logging_options: enum_flags u32 {
        LOG_OVERSIZED_ALLOCATIONS :: 0x1;
        LOG_OVERSIZED_ALLOCATIONS_AS_ERRORS :: 0x2;
        LOG_OVERSIZED_ALLOCATIONS_STACK_TRACE :: 0x4;
    }
}

set_allocators :: (pool: *Pool, block_allocator: Allocator = .{}) {
    assert(pool != null);
    assert(pool.used_memblocks == null && pool.unused_memblocks == null && pool.out_of_band_allocations == null);
    if !block_allocator.proc block_allocator = context.allocator;
    assert(block_allocator.proc != pool_allocator_proc || block_allocator.data != pool);
    pool.block_allocator = block_allocator;
}

get :: (pool: *Pool, nbytes: s64) -> *void {
    assert(pool != null && nbytes >= 0);
    assert(pool.alignment > 0 && (pool.alignment & (pool.alignment - 1)) == 0);
    assert(pool.oversized_size > 0);
    if !pool.block_allocator.proc set_allocators(pool);
    slack := pool.alignment - 1;
    assert(pool.memblock_size > HEADER_SIZE + slack);
    assert(nbytes <= 0x7fff_ffff_ffff_ffff - HEADER_SIZE - slack);
    if nbytes >= pool.oversized_size || nbytes > pool.memblock_size - HEADER_SIZE - slack {
        block := allocate_block(pool, HEADER_SIZE + slack + nbytes);
        block.next = pool.out_of_band_allocations;
        block.used_size = nbytes;
        pool.out_of_band_allocations = block;
        if (pool.logging_options & .LOG_OVERSIZED_ALLOCATIONS) != 0 {
            if (pool.logging_options & .LOG_OVERSIZED_ALLOCATIONS_AS_ERRORS) != 0 log_error("Pool oversized allocation: % bytes\n", nbytes);
            else log_warning("Pool oversized allocation: % bytes\n", nbytes);
            if (pool.logging_options & .LOG_OVERSIZED_ALLOCATIONS_STACK_TRACE) != 0 log_stack_trace(context.stack_trace);
        }
        return payload(pool, block);
    }
    bump: s64;
    if pool.current_pos bump = alignment_padding(pool.current_pos, pool.alignment);
    if !pool.current_memblock || bump > pool.bytes_left || nbytes > pool.bytes_left - bump {
        previous: *Memblock;
        block := pool.unused_memblocks;
        while block && cast(s64)(cast(*u8)block + block.allocation_size) - cast(s64)payload(pool, block) < nbytes {
            previous = block;
            block = block.next;
        }
        if block {
            if previous previous.next = block.next;
            else pool.unused_memblocks = block.next;
        } else block = allocate_block(pool, pool.memblock_size);
        block.next = pool.used_memblocks;
        block.used_size = 0;
        pool.used_memblocks = block;
        if !pool.first_used_memblock pool.first_used_memblock = block;
        pool.current_memblock = block;
        pool.current_pos = payload(pool, block);
        pool.bytes_left = cast(s64)(cast(*u8)block + block.allocation_size) - cast(s64)pool.current_pos;
        bump = 0;
    }
    result := pool.current_pos + bump;
    pool.current_pos += bump + nbytes;
    pool.bytes_left -= bump + nbytes;
    pool.current_memblock.used_size = cast(s64)pool.current_pos - cast(s64)payload(pool, pool.current_memblock);
    return result;
}

reset :: (pool: *Pool) {
    assert(pool != null);
    free_block_list(pool, pool.out_of_band_allocations);
    pool.out_of_band_allocations = null;
    if pool.free_memblocks_on_reset {
        free_block_list(pool, pool.used_memblocks);
        free_block_list(pool, pool.unused_memblocks);
        pool.unused_memblocks = null;
    } else {
        block := pool.used_memblocks;
        while block {
            next := block.next;
            if pool.overwrite_memory stamp_block(pool, block);
            block.used_size = 0;
            block.next = pool.unused_memblocks;
            pool.unused_memblocks = block;
            block = next;
        }
    }
    pool.used_memblocks = null;
    pool.first_used_memblock = null;
    pool.current_memblock = null;
    pool.current_pos = null;
    pool.bytes_left = 0;
}

release :: (pool: *Pool) {
    assert(pool != null);
    free_block_list(pool, pool.used_memblocks);
    free_block_list(pool, pool.unused_memblocks);
    free_block_list(pool, pool.out_of_band_allocations);
    pool.used_memblocks = null;
    pool.unused_memblocks = null;
    pool.out_of_band_allocations = null;
    pool.first_used_memblock = null;
    pool.current_memblock = null;
    pool.current_pos = null;
    pool.bytes_left = 0;
}

calculate_used_memory :: (pool: Pool) -> inband_size: s64, outband_count: s64 {
    bytes: s64;
    count: s64;
    cursor := pool.used_memblocks;
    while cursor { bytes += cursor.used_size; cursor = cursor.next; }
    cursor = pool.out_of_band_allocations;
    while cursor { count += 1; cursor = cursor.next; }
    return bytes, count;
}

pool_allocator_proc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void {
    pool := cast(*Pool)allocator_data;
    assert(pool != null);
    if mode == .ALLOCATE return get(pool, requested_size);
    if mode == .RESIZE {
        assert(requested_size >= 0 && old_size >= 0);
        if old_memory && requested_size <= old_size return old_memory;
        replacement := get(pool, requested_size);
        if old_memory && old_size > 0 memcpy(replacement, old_memory, old_size);
        return replacement;
    }
    if mode == .FREE return null;
    if mode == .STARTUP {
        if !pool.block_allocator.proc set_allocators(pool);
        return null;
    }
    if mode == .SHUTDOWN { release(pool); return null; }
    if mode == .CAPS return cast(*void)cast(u64)(Allocator_Caps.HINT_I_AM_A_FAST_BUMP_ALLOCATOR | .IS_THIS_YOURS);
    if mode == .IS_THIS_YOURS {
        return cast(*void)cast(u64)(list_owns(pool, pool.used_memblocks, old_memory) || list_owns(pool, pool.unused_memblocks, old_memory) || list_owns(pool, pool.out_of_band_allocations, old_memory));
    }
    assert(false, "Legacy Pool does not support this allocator mode");
    return null;
}

CAPS_VERSION_STRING :: "modules/Pool";

#scope_file;

Memblock :: struct {
    next: *Memblock;
    allocation_size: s64;
    used_size: s64;
    payload_address: *u8;
    data: void;
}

alignment_padding :: (address: *u8, alignment: s64) -> s64 {
    mask := cast(u64)(alignment - 1);
    return cast(s64)((cast(u64)0 - cast(u64)address) & mask);
}

payload :: (pool: *Pool, block: *Memblock) -> *u8 {
    return block.payload_address;
}

allocate_block :: (pool: *Pool, allocation_size: s64) -> *Memblock {
    block := cast(*Memblock)alloc(allocation_size, pool.block_allocator);
    assert(block != null);
    memset(block, 0, HEADER_SIZE);
    block.allocation_size = allocation_size;
    begin := cast(*u8)block + HEADER_SIZE;
    block.payload_address = begin + alignment_padding(begin, pool.alignment);
    return block;
}

stamp_block :: (pool: *Pool, block: *Memblock) {
    begin := payload(pool, block);
    count := cast(s64)(cast(*u8)block + block.allocation_size) - cast(s64)begin;
    memset(begin, STAMP, count);
}

free_block_list :: (pool: *Pool, blocks: *Memblock) {
    cursor := blocks;
    while cursor {
        next := cursor.next;
        if pool.overwrite_memory stamp_block(pool, cursor);
        free(cursor, pool.block_allocator);
        cursor = next;
    }
}

list_owns :: (pool: *Pool, blocks: *Memblock, address: *void) -> bool {
    if address == null return false;
    cursor := blocks;
    while cursor {
        if cast(u64)address >= cast(u64)payload(pool, cursor) && cast(u64)address < cast(u64)cursor + cast(u64)cursor.allocation_size return true;
        cursor = cursor.next;
    }
    return false;
}
