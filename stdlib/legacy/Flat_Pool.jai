// Explicit legacy field layout over one eager heap allocation.
#module_parameters (DEFAULT_VIRTUAL_MEMORY_RESERVE := 256 * 1024 * 1024, OVERWRITE_ALL_POOLS_ON_RESET := false);
#scope_file;
#import "Basic";
#scope_export;

Flat_Pool :: struct {
    alignment: s32 = 8;
    current_point: *u8;
    memory_base: *u8;
    first_uncommitted_page: *u8;
    address_limit: *u8;
    backing_allocator: Allocator;
}

init :: (pool: *Flat_Pool, reserve := DEFAULT_VIRTUAL_MEMORY_RESERVE) {
    assert(pool.memory_base == null);
    assert(reserve > 0);
    pool.backing_allocator = context.allocator;
    assert(pool.backing_allocator.proc != flat_pool_allocator_proc || pool.backing_allocator.data != pool);
    pool.memory_base = cast(*u8)alloc(reserve, pool.backing_allocator);
    assert(pool.memory_base != null);
    pool.current_point = pool.memory_base;
    pool.address_limit = pool.memory_base + reserve;
    pool.first_uncommitted_page = pool.address_limit;
}

get :: (pool: *Flat_Pool, nbytes: s64) -> *void {
    assert(nbytes >= 0);
    assert(pool.alignment > 0 && (pool.alignment & (pool.alignment - 1)) == 0);
    if !pool.memory_base init(pool);
    address := cast(u64)pool.current_point;
    mask := cast(u64)(pool.alignment - 1);
    aligned := (address + mask) & ~mask;
    assert(aligned <= cast(u64)pool.address_limit);
    available := cast(u64)pool.address_limit - aligned;
    assert(cast(u64)nbytes <= available);
    pool.current_point = cast(*u8)aligned + nbytes;
    return cast(*void)aligned;
}

reset :: (pool: *Flat_Pool, overwrite_memory := false) {
    if !pool.memory_base return;
    if overwrite_memory || OVERWRITE_ALL_POOLS_ON_RESET {
        used := cast(s64)pool.current_point - cast(s64)pool.memory_base;
        memset(pool.memory_base, 0xcc, used);
    }
    pool.current_point = pool.memory_base;
}

fini :: (pool: *Flat_Pool) {
    if pool.memory_base free(pool.memory_base, pool.backing_allocator);
    pool.memory_base = null;
    pool.current_point = null;
    pool.first_uncommitted_page = null;
    pool.address_limit = null;
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
        if !pool.memory_base init(pool);
        return null;
    }
    if mode == .SHUTDOWN { fini(pool); return null; }
    if mode == .CAPS return cast(*void)cast(u64)(Allocator_Caps.HINT_I_AM_A_FAST_BUMP_ALLOCATOR | .IS_THIS_YOURS);
    if mode == .IS_THIS_YOURS {
        ours := old_memory != null && cast(u64)old_memory >= cast(u64)pool.memory_base && cast(u64)old_memory < cast(u64)pool.address_limit;
        return cast(*void)cast(u64)ours;
    }
    assert(false, "Flat_Pool does not support this allocator mode");
    return null;
}

CAPS_VERSION_STRING :: "modules/Flat_Pool";
