// Native POSIX implementation: guard pages and retired mappings stay reserved.
#import "Basic";
#import "Hash_Table";
#import "Thread"(false);
#assert(OS == .MACOS || OS == .LINUX || OS == .ANDROID, "unmapping allocator needs a POSIX virtual-memory backend");

Unmapping_Allocator :: struct {
    table: Table(*void, u64);
    mutex: Mutex;
}

get_unmapping_allocator :: () -> Allocator {
    state := New(Unmapping_Allocator);
    if !state return .{};
    state.table.allocator = context.allocator;
    init(*state.mutex);
    return .{ unmapping_allocator_proc, state };
}

deinit_unmapping_allocator :: (a: Allocator) {
    state := cast(*Unmapping_Allocator) a.data;
    if !state return;
    allocator := state.table.allocator;
    deinit(state);
    free(state, allocator);
}

deinit :: (ua: *Unmapping_Allocator) {
    // Reservations remain in place, including live allocations, by design.
    // This matches the debugging lifetime policy: an old address is never reused.
    deinit(*ua.table);
    destroy(*ua.mutex);
}

unmapping_allocator_proc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void {
    state := cast(*Unmapping_Allocator) allocator_data;
    assert(state != null, "missing unmapping allocator state");
    if mode == .CAPS {
        if old_memory {
            name := cast(*string) old_memory;
            name.* = "independent POSIX guard-page allocator";
        }
        return cast(*void) cast(u64) (Allocator_Caps.FREE | .MULTIPLE_THREADS | .HINT_I_AM_A_DEBUG_ALLOCATOR | .HINT_I_AM_A_GENERAL_HEAP_ALLOCATOR);
    }
    if mode == .ALLOCATE || mode == .RESIZE {
        pointer := reserve_guarded(state, requested_size);
        if !pointer return null;
        if mode == .RESIZE && old_memory {
            retained := old_size;
            if retained > requested_size retained = requested_size;
            if retained > 0 memcpy(pointer, old_memory, retained);
            quarantine(state, old_memory);
        }
        return pointer;
    }
    if mode == .FREE {
        if old_memory quarantine(state, old_memory);
        return null;
    }
    if mode == .CREATE_HEAP || mode == .DESTROY_HEAP || mode == .IS_THIS_YOURS assert(false, "mode not supported by unmapping allocator");
    return null;
}

#scope_module
crt :: #system_library "libc";
getpagesize :: () -> s32 #foreign crt;
mmap :: (address: *void, length: u64, protection: s32, flags: s32, descriptor: s32, offset: s64) -> *void #foreign crt;
mprotect :: (address: *void, length: u64, protection: s32) -> s32 #foreign crt;
munmap :: (address: *void, length: u64) -> s32 #foreign crt;

reserve_guarded :: (state: *Unmapping_Allocator, size: s64) -> *void {
    if size < 0 return null;
    page_size := cast(s64) getpagesize();
    if page_size <= 0 || size > 0x7fff_ffff_ffff_ffff - page_size * 2 return null;
    readable_size := align_forward(size, page_size);
    if readable_size == 0 readable_size = page_size;
    mapping_size := readable_size + page_size;
    #if OS == .MACOS flags: s32 = 0x1002;
    else flags: s32 = 0x22;
    base := mmap(null, cast(u64) mapping_size, 3, flags, -1, 0);
    if base == cast(*void) -1 return null;
    guard := base + readable_size;
    if mprotect(guard, cast(u64) page_size, 0) != 0 {
        munmap(base, cast(u64) mapping_size);
        return null;
    }
    pointer := guard - size;
    lock(*state.mutex);
    table_set(*state.table, pointer, cast(u64) size);
    unlock(*state.mutex);
    return pointer;
}

quarantine :: (state: *Unmapping_Allocator, pointer: *void) -> bool {
    lock(*state.mutex);
    defer unlock(*state.mutex);
    found, size := table_find(*state.table, pointer);
    if !found || size == 0xffff_ffff_ffff_ffff {
        assert(false, "invalid pointer or double free in unmapping allocator");
        return false;
    }
    page_size := cast(s64) getpagesize();
    readable_size := align_forward(cast(s64) size, page_size);
    if readable_size == 0 readable_size = page_size;
    base := pointer + cast(s64) size - readable_size;
    success := mprotect(base, cast(u64) (readable_size + page_size), 0) == 0;
    if !success {
        assert(false, "failed to protect retired allocation");
        return false;
    }
    table_set(*state.table, pointer, 0xffff_ffff_ffff_ffff);
    return true;
}
