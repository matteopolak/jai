// Historical logical headers over heap allocations with private ownership metadata.
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
    assert(pool != null && !pool.block_allocator.proc);
    assert(pool.used_memblocks == null && pool.unused_memblocks == null && pool.out_of_band_allocations == null);
    if !block_allocator.proc block_allocator = context.allocator;
    if !block_allocator.proc || (block_allocator.proc == pool_allocator_proc && block_allocator.data == pool) block_allocator = context.default_allocator;
    assert(block_allocator.proc != null && (block_allocator.proc != pool_allocator_proc || block_allocator.data != pool));
    pool.block_allocator = block_allocator;
}

get :: (pool: *Pool, nbytes: s64) -> *void {
    assert(pool != null && nbytes >= 0);
    assert(pool.alignment > 0 && (pool.alignment & (pool.alignment - 1)) == 0);
    assert(pool.oversized_size > 0);
    if !pool.block_allocator.proc set_allocators(pool);
    slack := pool.alignment - 1;
    assert(pool.memblock_size > HEADER_SIZE + slack && pool.memblock_size <= MAX_LOGICAL_SIZE);
    assert(nbytes <= MAX_LOGICAL_SIZE - HEADER_SIZE - slack);
    if nbytes >= pool.oversized_size || nbytes > pool.memblock_size - HEADER_SIZE - slack {
        block := allocate_block(pool, HEADER_SIZE + slack + nbytes);
        if !block return null;
        block.next = pool.out_of_band_allocations;
        pool.out_of_band_allocations = block;
        if (pool.logging_options & .LOG_OVERSIZED_ALLOCATIONS) != 0 {
            if (pool.logging_options & .LOG_OVERSIZED_ALLOCATIONS_AS_ERRORS) != 0 log_error("Pool oversized allocation: % bytes\n", nbytes);
            else log_warning("Pool oversized allocation: % bytes\n", nbytes);
            if (pool.logging_options & .LOG_OVERSIZED_ALLOCATIONS_STACK_TRACE) != 0 log_stack_trace(context.stack_trace);
        }
        begin := block_data(block);
        return begin + alignment_padding(begin, pool.alignment);
    }
    bump: s64;
    if pool.current_pos bump = alignment_padding(pool.current_pos, pool.alignment);
    if !pool.current_memblock || bump > pool.bytes_left || nbytes > pool.bytes_left - bump {
        previous: *Memblock;
        block := pool.unused_memblocks;
        while block && block_header(block).logical_size < pool.memblock_size {
            previous = block;
            block = block.next;
        }
        if block {
            if previous previous.next = block.next;
            else pool.unused_memblocks = block.next;
        } else {
            block = allocate_block(pool, pool.memblock_size);
            if !block return null;
        }
        block.next = pool.used_memblocks;
        pool.used_memblocks = block;
        if !pool.first_used_memblock pool.first_used_memblock = block;
        pool.current_memblock = block;
        pool.current_pos = block_data(block);
        pool.bytes_left = pool.memblock_size - HEADER_SIZE;
        bump = alignment_padding(pool.current_pos, pool.alignment);
    }
    result := pool.current_pos + bump;
    pool.current_pos += bump + nbytes;
    pool.bytes_left -= bump + nbytes;
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
    } else if pool.used_memblocks {
        cursor := pool.used_memblocks;
        tail: *Memblock;
        while cursor {
            if pool.overwrite_memory stamp_block(cursor);
            tail = cursor;
            cursor = cursor.next;
        }
        tail.next = pool.unused_memblocks;
        pool.unused_memblocks = pool.used_memblocks;
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
    block_count: s64;
    object_count: s64;
    cursor := pool.used_memblocks;
    while cursor { block_count += 1; cursor = cursor.next; }
    assert(pool.memblock_size > 0 && block_count <= 0x7fff_ffff_ffff_ffff / pool.memblock_size);
    reserved := block_count * pool.memblock_size;
    assert(reserved >= pool.bytes_left);
    cursor = pool.out_of_band_allocations;
    while cursor { object_count += 1; cursor = cursor.next; }
    return reserved - pool.bytes_left, object_count;
}

pool_allocator_proc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void {
    if mode == .CAPS {
        if old_memory { name := cast(*string)old_memory; name.* = CAPS_VERSION_STRING; }
        return cast(*void)cast(u64)(Allocator_Caps.HINT_I_AM_A_FAST_BUMP_ALLOCATOR | .IS_THIS_YOURS);
    }
    if mode == .FREE || mode == .STARTUP || mode == .SHUTDOWN return null;
    pool := cast(*Pool)allocator_data;
    assert(pool != null);
    if mode == .ALLOCATE return get(pool, requested_size);
    if mode == .RESIZE {
        assert(requested_size >= 0 && old_size >= 0);
        replacement := get(pool, requested_size);
        count := old_size;
        if count > requested_size count = requested_size;
        if replacement && old_memory && count > 0 memcpy(replacement, old_memory, count);
        return replacement;
    }
    if mode == .IS_THIS_YOURS {
        return cast(*void)cast(u64)(list_owns(pool.used_memblocks, old_memory) || list_owns(pool.unused_memblocks, old_memory) || list_owns(pool.out_of_band_allocations, old_memory));
    }
    assert(false, "Legacy Pool does not support this allocator mode");
    return null;
}

CAPS_VERSION_STRING :: "modules/Pool";

#scope_file;

Memblock :: struct {
    next: *Memblock;
    data: void;
}

Block_Allocation :: struct {
    raw: *void;
    allocator: Allocator;
    logical_size: s64;
}

PRIVATE_HEADER_SIZE :: (size_of(Block_Allocation) + 7) & ~7;
MAX_LOGICAL_SIZE :: 0x7fff_ffff_ffff_ffff - PRIVATE_HEADER_SIZE;

block_header :: (block: *Memblock) -> *Block_Allocation {
    return cast(*Block_Allocation)(cast(*u8)block - PRIVATE_HEADER_SIZE);
}

block_data :: (block: *Memblock) -> *u8 {
    return cast(*u8)block + HEADER_SIZE;
}

alignment_padding :: (address: *u8, alignment: s64) -> s64 #no_aoc {
    mask := cast(u64)(alignment - 1);
    return cast(s64)((cast(u64)0 - cast(u64)address) & mask);
}

allocate_block :: (pool: *Pool, logical_size: s64) -> *Memblock {
    assert(logical_size >= HEADER_SIZE && logical_size <= MAX_LOGICAL_SIZE);
    allocator := pool.block_allocator;
    raw := alloc(PRIVATE_HEADER_SIZE + logical_size, allocator);
    if !raw return null;
    header := cast(*Block_Allocation)raw;
    header.raw = raw;
    header.allocator = allocator;
    header.logical_size = logical_size;
    block := cast(*Memblock)(cast(*u8)raw + PRIVATE_HEADER_SIZE);
    block.next = null;
    if pool.overwrite_memory stamp_block(block);
    return block;
}

stamp_block :: (block: *Memblock) {
    count := block_header(block).logical_size - HEADER_SIZE;
    memset(block_data(block), STAMP, count);
}

free_block_list :: (pool: *Pool, blocks: *Memblock) {
    cursor := blocks;
    while cursor {
        next := cursor.next;
        if pool.overwrite_memory stamp_block(cursor);
        header := block_header(cursor);
        raw := header.raw;
        allocator := header.allocator;
        free(raw, allocator);
        cursor = next;
    }
}

list_owns :: (blocks: *Memblock, address: *void) -> bool {
    if address == null return false;
    cursor := blocks;
    while cursor {
        begin := block_data(cursor);
        end := cast(*u8)cursor + block_header(cursor).logical_size;
        candidate := cast(*u8)address;
        if candidate >= begin && candidate < end return true;
        cursor = cursor.next;
    }
    return false;
}
