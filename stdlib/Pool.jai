// Maintained OpenJai fields backed by reusable, independently allocated blocks.
#scope_file;
#import "Basic";
#scope_export;

POOL_BUCKET_SIZE_DEFAULT :: 65536;

Pool :: struct {
    memblock_size: int;
    bytes_left: int;
    current_block: *void;
    current_pos: int;
    blocks: *Pool_Block;
    active: *Pool_Block;
    block_allocator: Allocator;
}

set_allocators :: (pool: *Pool) {
    if !pool return;
    assert(pool.blocks == null);
    pool.memblock_size = POOL_BUCKET_SIZE_DEFAULT;
    pool.bytes_left = 0;
    pool.block_allocator = context.allocator;
}

// Compatible convenience overload for selecting a source allocator explicitly.
set_allocators :: (pool: *Pool, block_allocator: Allocator) {
    set_allocators(pool);
    if block_allocator.proc pool.block_allocator = block_allocator;
}

get :: (pool: *Pool, size: int) -> *void {
    assert(pool != null && size >= 0);
    if !pool.block_allocator.proc pool.block_allocator = context.allocator;
    assert(pool.block_allocator.proc != pool_allocator_proc || pool.block_allocator.data != pool);
    if pool.memblock_size <= 0 pool.memblock_size = POOL_BUCKET_SIZE_DEFAULT;
    if !pool.active pool.active = pool.blocks;
    position := (pool.current_pos + 7) & ~7;
    if !pool.active || position > pool.active.capacity || size > pool.active.capacity - position {
        previous := pool.active;
        candidate: *Pool_Block;
        if previous candidate = previous.next;
        while candidate && candidate.capacity < size { previous = candidate; candidate = candidate.next; }
        if !candidate {
            capacity := pool.memblock_size;
            if capacity < size capacity = size;
            candidate = New(Pool_Block, true, pool.block_allocator);
            assert(candidate != null);
            candidate.memory = alloc(capacity, pool.block_allocator);
            assert(candidate.memory != null);
            candidate.capacity = capacity;
            if previous previous.next = candidate;
            else pool.blocks = candidate;
        }
        pool.active = candidate;
        position = 0;
    }
    pool.current_block = pool.active.memory;
    pool.current_pos = position + size;
    pool.bytes_left = pool.active.capacity - pool.current_pos;
    return cast(*u8)pool.current_block + position;
}

reset :: (pool: *Pool) {
    if !pool return;
    pool.active = pool.blocks;
    pool.current_pos = 0;
    pool.current_block = null;
    pool.bytes_left = 0;
    if pool.active {
        pool.current_block = pool.active.memory;
        pool.bytes_left = pool.active.capacity;
    }
}

release :: (pool: *Pool) {
    if !pool return;
    cursor := pool.blocks;
    while cursor {
        next := cursor.next;
        free(cursor.memory, pool.block_allocator);
        free(cursor, pool.block_allocator);
        cursor = next;
    }
    pool.blocks = null;
    pool.active = null;
    pool.current_block = null;
    pool.current_pos = 0;
    pool.bytes_left = 0;
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
        cursor := pool.blocks;
        while cursor {
            if old_memory != null && cast(u64)old_memory >= cast(u64)cursor.memory && cast(u64)old_memory - cast(u64)cursor.memory < cast(u64)cursor.capacity return cast(*void)1;
            cursor = cursor.next;
        }
        return null;
    }
    assert(false, "Pool does not support this allocator mode");
    return null;
}

#scope_file;

Pool_Block :: struct {
    next: *Pool_Block;
    memory: *void;
    capacity: int;
}
