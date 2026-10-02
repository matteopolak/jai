// Maintained OpenJai field shape with one eager, contiguous heap allocation.
#scope_file;
#import "Basic";
#scope_export;

Flat_Pool :: struct {
    memblock_size: int;
    bytes_left: int;
    current_block: *void;
    current_pos: int;
    alignment: int = 8;
    backing_allocator: Allocator;
}

// OpenJai permits a zero-initialized pool; first get initializes it lazily.
init :: (pool: *Flat_Pool, reserve: int = 256 * 1024 * 1024) {
    assert(pool != null && pool.current_block == null && reserve > 0);
    pool.backing_allocator = context.allocator;
    assert(pool.backing_allocator.proc != flat_pool_allocator_proc || pool.backing_allocator.data != pool);
    pool.current_block = alloc(reserve, pool.backing_allocator);
    assert(pool.current_block != null);
    pool.memblock_size = reserve;
    pool.bytes_left = reserve;
    pool.current_pos = 0;
}

get :: (pool: *Flat_Pool, size: int) -> *void {
    assert(pool != null && size >= 0);
    assert(pool.alignment > 0 && (pool.alignment & (pool.alignment - 1)) == 0);
    if !pool.current_block {
        reserve := pool.memblock_size;
        if reserve <= 0 reserve = 256 * 1024 * 1024;
        init(pool, reserve);
    }
    base := cast(u64)pool.current_block;
    address := base + cast(u64)pool.current_pos;
    mask := cast(u64)(pool.alignment - 1);
    aligned := (address + mask) & ~mask;
    offset := aligned - base;
    assert(offset <= cast(u64)pool.memblock_size);
    assert(cast(u64)size <= cast(u64)pool.memblock_size - offset);
    pool.current_pos = cast(int)offset + size;
    pool.bytes_left = pool.memblock_size - pool.current_pos;
    return cast(*void)aligned;
}

reset :: (pool: *Flat_Pool, overwrite_memory := false) {
    if !pool return;
    if pool.current_block && overwrite_memory memset(pool.current_block, 0xcc, pool.current_pos);
    pool.current_pos = 0;
    pool.bytes_left = pool.memblock_size;
}

fini :: (pool: *Flat_Pool) {
    if !pool return;
    if pool.current_block free(pool.current_block, pool.backing_allocator);
    pool.current_block = null;
    pool.current_pos = 0;
    pool.bytes_left = 0;
    pool.memblock_size = 0;
    pool.backing_allocator = .{};
}

flat_pool_allocator_proc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void {
    pool := cast(*Flat_Pool)allocator_data;
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
        if !pool.current_block {
            reserve := pool.memblock_size;
            if reserve <= 0 reserve = 256 * 1024 * 1024;
            init(pool, reserve);
        }
        return null;
    }
    if mode == .SHUTDOWN { fini(pool); return null; }
    if mode == .CAPS return cast(*void)cast(u64)(Allocator_Caps.HINT_I_AM_A_FAST_BUMP_ALLOCATOR | .IS_THIS_YOURS);
    if mode == .IS_THIS_YOURS {
        ours := old_memory != null && pool.current_block != null && cast(u64)old_memory >= cast(u64)pool.current_block && cast(u64)old_memory - cast(u64)pool.current_block < cast(u64)pool.memblock_size;
        return cast(*void)cast(u64)ours;
    }
    assert(false, "Flat_Pool does not support this allocator mode");
    return null;
}
