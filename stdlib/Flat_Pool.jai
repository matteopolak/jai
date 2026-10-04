// Flat_Pool: a bump allocator over one contiguous reservation (jai's five-field record). The reservation is a
// single heap allocation of DEFAULT_VIRTUAL_MEMORY_RESERVE bytes (with a private header in front), so the pool
// cannot grow past it; reset keeps the memory, fini frees it.
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
}

init :: (pool: *Flat_Pool, reserve := DEFAULT_VIRTUAL_MEMORY_RESERVE) {
    assert(pool != null && pool.memory_base == null && reserve > 0);
    alignment := checked_alignment(pool);
    if alignment < 8 alignment = 8;
    slack := alignment - 1;
    assert(reserve <= MAX_RESERVE_SIZE - slack - RESERVE_GRANULARITY + 1);
    reserve = (reserve + RESERVE_GRANULARITY - 1) & ~(RESERVE_GRANULARITY - 1);
    allocator := backing_allocator(pool);
    raw := alloc(PRIVATE_HEADER_SIZE + slack + reserve, allocator);
    assert(raw != null);
    after_header := cast(*u8)raw + PRIVATE_HEADER_SIZE;
    memory := after_header + alignment_padding(after_header, alignment);
    header := storage_header(memory);
    header.raw = raw;
    header.allocator = allocator;
    pool.memory_base = memory;
    pool.current_point = memory;
    pool.address_limit = memory + reserve;
    // All bytes are backed eagerly; there are no inaccessible virtual pages.
    pool.first_uncommitted_page = pool.address_limit;
}

get :: (pool: *Flat_Pool, nbytes: s64) -> *void {
    assert(pool != null && nbytes >= 0);
    alignment := checked_alignment(pool);
    if !pool.memory_base init(pool);
    padding := alignment_padding(pool.current_point, alignment);
    available := pool.address_limit - pool.current_point;
    assert(padding <= available && nbytes <= available - padding);
    result := pool.current_point + padding;
    pool.current_point = result + nbytes;
    return result;
}

reset :: (pool: *Flat_Pool, overwrite_memory := false) {
    assert(pool != null);
    if !pool.memory_base return;
    if overwrite_memory || OVERWRITE_ALL_POOLS_ON_RESET {
        used := pool.current_point - pool.memory_base;
        memset(pool.memory_base, 0xcc, used);
    }
    pool.current_point = pool.memory_base;
}

fini :: (pool: *Flat_Pool) {
    assert(pool != null);
    if pool.memory_base {
        header := storage_header(pool.memory_base);
        raw := header.raw;
        allocator := header.allocator;
        free(raw, allocator);
    }
    pool.memory_base = null;
    pool.current_point = null;
    pool.first_uncommitted_page = null;
    pool.address_limit = null;
}

flat_pool_allocator_proc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void {
    if mode == .CAPS {
        if old_memory { name := cast(*string)old_memory; name.* = CAPS_VERSION_STRING; }
        return cast(*void)cast(u64)(Allocator_Caps.HINT_I_AM_A_FAST_BUMP_ALLOCATOR | .IS_THIS_YOURS);
    }
    if mode == .FREE || mode == .STARTUP || mode == .SHUTDOWN return null;
    pool := cast(*Flat_Pool)allocator_data;
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
        if !old_memory || !pool.memory_base return null;
        address := cast(*u8)old_memory;
        ours := address >= pool.memory_base && address < pool.first_uncommitted_page;
        return cast(*void)cast(u64)ours;
    }
    assert(false, "Flat_Pool does not support this allocator mode");
    return null;
}

CAPS_VERSION_STRING :: "modules/Flat_Pool";

#scope_file;

Flat_Storage :: struct {
    raw: *void;
    allocator: Allocator;
}

PRIVATE_HEADER_SIZE :: (size_of(Flat_Storage) + 7) & ~7;
RESERVE_GRANULARITY :: 4096;
MAX_RESERVE_SIZE :: 0x7fff_ffff_ffff_ffff - PRIVATE_HEADER_SIZE;

storage_header :: (memory: *u8) -> *Flat_Storage {
    return cast(*Flat_Storage)(memory - PRIVATE_HEADER_SIZE);
}

checked_alignment :: (pool: *Flat_Pool) -> s64 {
    assert(pool.alignment > 0 && (pool.alignment & (pool.alignment - 1)) == 0);
    return pool.alignment;
}

alignment_padding :: (address: *u8, alignment: s64) -> s64 #no_aoc {
    mask := cast(u64)(alignment - 1);
    return cast(s64)((cast(u64)0 - cast(u64)address) & mask);
}

backing_allocator :: (pool: *Flat_Pool) -> Allocator {
    allocator := context.allocator;
    if !allocator.proc || (allocator.proc == flat_pool_allocator_proc && allocator.data == pool) allocator = context.default_allocator;
    assert(allocator.proc != null && (allocator.proc != flat_pool_allocator_proc || allocator.data != pool));
    return allocator;
}
