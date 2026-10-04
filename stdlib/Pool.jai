// Maintained four-field record; real blocks carry private backing metadata.
#scope_file;
#import "Basic";
#scope_export;

POOL_BUCKET_SIZE_DEFAULT :: 65536;

Pool :: struct {
    memblock_size: int;
    bytes_left: int;
    current_block: *void;
    current_pos: int;
}

set_allocators :: (pool: *Pool) {
    if !pool return;
    assert(pool.current_block == null);
    pool.memblock_size = POOL_BUCKET_SIZE_DEFAULT;
    pool.bytes_left = 0;
    assert(initialize_pool(pool, context.allocator));
}

// Compatible convenience overload for selecting a source allocator explicitly.
set_allocators :: (pool: *Pool, block_allocator: Allocator) {
    if !pool return;
    assert(pool.current_block == null);
    pool.memblock_size = POOL_BUCKET_SIZE_DEFAULT;
    pool.bytes_left = 0;
    assert(initialize_pool(pool, block_allocator));
}

get :: (pool: *Pool, size: int) -> *void {
    if !pool || size < 0 || size > MAX_ALLOCATION_SIZE return null;
    if pool.memblock_size <= 0 pool.memblock_size = POOL_BUCKET_SIZE_DEFAULT;
    if !pool.current_block && !initialize_pool(pool, context.allocator) return null;
    active := block_header(pool.current_block);
    position := (pool.current_pos + 7) & ~7;
    if position < BLOCK_START position = BLOCK_START;
    if position > active.capacity || size > active.capacity - position {
        previous := active;
        candidate := previous.next;
        while candidate && (candidate.capacity < BLOCK_START || size > candidate.capacity - BLOCK_START) {
            previous = candidate;
            candidate = candidate.next;
        }
        if !candidate {
            capacity := pool.memblock_size;
            if capacity < size + BLOCK_START capacity = size + BLOCK_START;
            candidate = allocate_block(capacity, previous.allocator);
            if !candidate return null;
            candidate.previous = previous;
            previous.next = candidate;
        }
        active = candidate;
        position = BLOCK_START;
    }
    pool.current_block = block_memory(active);
    pool.current_pos = position + size;
    pool.bytes_left = active.capacity - pool.current_pos;
    return cast(*u8)pool.current_block + position;
}

reset :: (pool: *Pool) {
    if !pool return;
    if !pool.current_block { pool.current_pos = 0; pool.bytes_left = 0; return; }
    first := first_block(block_header(pool.current_block));
    if first.capacity == 0 && first.next first = first.next;
    pool.current_block = block_memory(first);
    pool.current_pos = 0;
    pool.bytes_left = 0;
    if first.capacity > 0 {
        pool.current_pos = BLOCK_START;
        pool.bytes_left = first.capacity - BLOCK_START;
    }
}

release :: (pool: *Pool) {
    if !pool return;
    cursor: *Pool_Block;
    if pool.current_block cursor = first_block(block_header(pool.current_block));
    while cursor {
        next := cursor.next;
        allocator := cursor.allocator;
        free(cursor, allocator);
        cursor = next;
    }
    pool.current_block = null;
    pool.current_pos = 0;
    pool.bytes_left = 0;
}

pool_allocator_proc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void {
    if mode == .CAPS {
        if old_memory { name := cast(*string)old_memory; name.* = "modules/Pool"; }
        return cast(*void)cast(u64)(Allocator_Caps.HINT_I_AM_A_FAST_BUMP_ALLOCATOR | .IS_THIS_YOURS);
    }
    if mode == .FREE return null;
    pool := cast(*Pool)allocator_data;
    assert(pool != null);
    if mode == .ALLOCATE return get(pool, requested_size);
    if mode == .RESIZE {
        if requested_size < 0 || old_size < 0 || requested_size > MAX_ALLOCATION_SIZE return null;
        if old_memory && requested_size <= old_size return old_memory;
        replacement := get(pool, requested_size);
        if replacement && old_memory && old_size > 0 memcpy(replacement, old_memory, old_size);
        return replacement;
    }
    if mode == .STARTUP {
        if !pool.current_block {
            if pool.memblock_size <= 0 pool.memblock_size = POOL_BUCKET_SIZE_DEFAULT;
            assert(initialize_pool(pool, context.allocator));
        }
        return null;
    }
    if mode == .SHUTDOWN { release(pool); return null; }
    if mode == .IS_THIS_YOURS {
        if !old_memory || !pool.current_block return null;
        cursor := first_block(block_header(pool.current_block));
        while cursor {
            begin := block_memory(cursor) + BLOCK_START;
            if cursor.capacity >= BLOCK_START && cast(u64)old_memory >= cast(u64)begin && cast(u64)old_memory - cast(u64)begin < cast(u64)(cursor.capacity - BLOCK_START) return cast(*void)1;
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
    previous: *Pool_Block;
    capacity: int;
    allocator: Allocator;
}

PRIVATE_HEADER_SIZE :: (size_of(Pool_Block) + 7) & ~7;
BLOCK_START :: (size_of(*void) + 7) & ~7;
MAX_ALLOCATION_SIZE :: 0x7fff_ffff_ffff_ffff - PRIVATE_HEADER_SIZE - BLOCK_START;

block_header :: (memory: *void) -> *Pool_Block {
    return cast(*Pool_Block)(cast(*u8)memory - PRIVATE_HEADER_SIZE);
}

block_memory :: (block: *Pool_Block) -> *u8 { return cast(*u8)block + PRIVATE_HEADER_SIZE; }

first_block :: (block: *Pool_Block) -> *Pool_Block {
    while block.previous block = block.previous;
    return block;
}

allocate_block :: (capacity: int, allocator: Allocator) -> *Pool_Block {
    if capacity < 0 || capacity > MAX_ALLOCATION_SIZE return null;
    allocated := capacity;
    if allocated < BLOCK_START allocated = BLOCK_START;
    block := cast(*Pool_Block)alloc(PRIVATE_HEADER_SIZE + allocated, allocator);
    if !block return null;
    memset(block, 0, PRIVATE_HEADER_SIZE);
    block.capacity = capacity;
    block.allocator = allocator;
    return block;
}

initialize_pool :: (pool: *Pool, allocator: Allocator) -> bool {
    if !allocator.proc || (allocator.proc == pool_allocator_proc && allocator.data == pool) allocator = context.default_allocator;
    if !allocator.proc || (allocator.proc == pool_allocator_proc && allocator.data == pool) return false;
    // A real zero-capacity root retains the backing allocator before context switches.
    root := allocate_block(0, allocator);
    if !root return false;
    pool.current_block = block_memory(root);
    pool.current_pos = 0;
    pool.bytes_left = 0;
    return true;
}
