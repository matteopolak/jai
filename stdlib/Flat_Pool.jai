// Maintained five-field record; aligned heap blocks carry private metadata.
#scope_file;
#import "Basic";
#scope_export;

Flat_Pool :: struct {
    memblock_size: int;
    bytes_left: int;
    current_block: *void;
    current_pos: int;
    alignment: int = 8;
}

// OpenJai permits a zero-initialized pool; first get initializes it lazily.
init :: (pool: *Flat_Pool, reserve: int = 65536) {
    assert(pool != null && pool.current_block == null && reserve > 0);
    alignment := effective_alignment(pool);
    block := allocate_block(reserve, alignment, backing_allocator(pool));
    assert(block != null);
    pool.current_block = block.memory;
    pool.memblock_size = reserve;
    pool.bytes_left = reserve;
    pool.current_pos = 0;
}

get :: (pool: *Flat_Pool, size: int) -> *void {
    if !pool || size < 0 || size > MAX_ALLOCATION_SIZE || pool.memblock_size < 0 return null;
    alignment := effective_alignment(pool);
    if pool.memblock_size == 0 pool.memblock_size = 65536;
    active: *Flat_Block;
    if pool.current_block active = block_header(pool.current_block);
    position := aligned_position(pool.current_pos, alignment);
    if !active || active.alignment < alignment || position > active.capacity || size > active.capacity - position {
        previous := active;
        candidate: *Flat_Block;
        if previous candidate = previous.next;
        while candidate && (candidate.alignment < alignment || candidate.capacity < size) {
            previous = candidate;
            candidate = candidate.next;
        }
        if !candidate {
            capacity := pool.memblock_size;
            if capacity < size capacity = size;
            allocator := backing_allocator(pool);
            if previous allocator = previous.allocator;
            candidate = allocate_block(capacity, alignment, allocator);
            if !candidate return null;
            candidate.previous = previous;
            if previous previous.next = candidate;
        }
        active = candidate;
        position = 0;
    }
    pool.current_block = active.memory;
    pool.current_pos = position + size;
    pool.bytes_left = active.capacity - pool.current_pos;
    return cast(*u8)pool.current_block + position;
}

reset :: (pool: *Flat_Pool, overwrite_memory := false) {
    if !pool return;
    if !pool.current_block { pool.current_pos = 0; pool.bytes_left = 0; return; }
    first := first_block(block_header(pool.current_block));
    if overwrite_memory {
        cursor := first;
        while cursor { memset(cursor.memory, 0xcc, cursor.capacity); cursor = cursor.next; }
    }
    pool.current_block = first.memory;
    pool.current_pos = 0;
    pool.bytes_left = first.capacity;
}

fini :: (pool: *Flat_Pool) {
    if !pool return;
    cursor: *Flat_Block;
    if pool.current_block cursor = first_block(block_header(pool.current_block));
    while cursor {
        next := cursor.next;
        raw := cursor.raw;
        allocator := cursor.allocator;
        free(raw, allocator);
        cursor = next;
    }
    pool.current_block = null;
    pool.current_pos = 0;
    pool.bytes_left = 0;
}

flat_pool_allocator_proc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void {
    if mode == .CAPS {
        if old_memory { name := cast(*string)old_memory; name.* = "modules/Flat_Pool"; }
        return cast(*void)cast(u64)(Allocator_Caps.HINT_I_AM_A_FAST_BUMP_ALLOCATOR | .IS_THIS_YOURS);
    }
    if mode == .FREE return null;
    pool := cast(*Flat_Pool)allocator_data;
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
        if !pool.current_block assert(get(pool, 0) != null);
        return null;
    }
    if mode == .SHUTDOWN { fini(pool); return null; }
    if mode == .IS_THIS_YOURS {
        if !old_memory || !pool.current_block return null;
        cursor := first_block(block_header(pool.current_block));
        while cursor {
            if cast(u64)old_memory >= cast(u64)cursor.memory && cast(u64)old_memory - cast(u64)cursor.memory < cast(u64)cursor.capacity return cast(*void)1;
            cursor = cursor.next;
        }
        return null;
    }
    assert(false, "Flat_Pool does not support this allocator mode");
    return null;
}

#scope_file;

Flat_Block :: struct {
    next: *Flat_Block;
    previous: *Flat_Block;
    raw: *void;
    memory: *void;
    capacity: int;
    alignment: int;
    allocator: Allocator;
}

PRIVATE_HEADER_SIZE :: (size_of(Flat_Block) + 7) & ~7;
MAX_ALLOCATION_SIZE :: 0x7fff_ffff_ffff_ffff - PRIVATE_HEADER_SIZE;

block_header :: (memory: *void) -> *Flat_Block {
    return cast(*Flat_Block)(cast(*u8)memory - PRIVATE_HEADER_SIZE);
}

first_block :: (block: *Flat_Block) -> *Flat_Block {
    while block.previous block = block.previous;
    return block;
}

effective_alignment :: (pool: *Flat_Pool) -> int {
    if pool.alignment == 0 pool.alignment = 8;
    assert(pool.alignment > 0 && (pool.alignment & (pool.alignment - 1)) == 0);
    return pool.alignment;
}

aligned_position :: (position: int, alignment: int) -> int {
    assert(position >= 0 && position <= 0x7fff_ffff_ffff_ffff - alignment + 1);
    return (position + alignment - 1) & ~(alignment - 1);
}

backing_allocator :: (pool: *Flat_Pool) -> Allocator {
    allocator := context.allocator;
    if !allocator.proc || (allocator.proc == flat_pool_allocator_proc && allocator.data == pool) allocator = context.default_allocator;
    assert(allocator.proc != null && (allocator.proc != flat_pool_allocator_proc || allocator.data != pool));
    return allocator;
}

allocate_block :: (capacity: int, alignment: int, allocator: Allocator) -> *Flat_Block {
    block_alignment := alignment;
    if block_alignment < 8 block_alignment = 8;
    slack := block_alignment - 1;
    if capacity < 0 || capacity > MAX_ALLOCATION_SIZE - slack return null;
    raw := alloc(PRIVATE_HEADER_SIZE + slack + capacity, allocator);
    if !raw return null;
    after_header := cast(*u8)raw + PRIVATE_HEADER_SIZE;
    misalignment := cast(u64)after_header & cast(u64)slack;
    padding := cast(int)((cast(u64)block_alignment - misalignment) & cast(u64)slack);
    memory := after_header + padding;
    block := block_header(memory);
    memset(block, 0, PRIVATE_HEADER_SIZE);
    block.raw = raw;
    block.memory = memory;
    block.capacity = capacity;
    block.alignment = block_alignment;
    block.allocator = allocator;
    return block;
}
