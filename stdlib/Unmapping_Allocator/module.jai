// Guard pages and retired mappings stay reserved: POSIX mmap/mprotect, or Windows
// VirtualAlloc/VirtualProtect/VirtualFree.
#import "Basic";
#import "Hash_Table";
#import "Thread"(false);

#assert(OS == .MACOS || OS == .LINUX || OS == .ANDROID || OS == .WINDOWS, "unmapping allocator needs a POSIX or Windows virtual-memory backend");

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
            name.* = "independent guard-page allocator";
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
#if OS == .WINDOWS {
    kernel32 :: #system_library "kernel32";
    VirtualAlloc :: (address: *void, size: u64, allocation_type: u32, protect: u32) -> *void #foreign kernel32;
    VirtualProtect :: (address: *void, size: u64, new_protect: u32, old_protect: *u32) -> s32 #foreign kernel32;
    VirtualFree :: (address: *void, size: u64, free_type: u32) -> s32 #foreign kernel32;

    MEM_COMMIT :: 0x1000;
    MEM_RESERVE :: 0x2000;
    MEM_DECOMMIT :: 0x4000;
    MEM_RELEASE :: 0x8000;
    PAGE_NOACCESS :: 0x01;
    PAGE_READWRITE :: 0x04;

    // Windows pages are 4 KiB on x64 and arm64 alike.
    page_bytes :: () -> s64 {
        return 4096;
    }

    // Reserve and commit `size` read-write bytes, then make the last page inaccessible.
    map_with_guard :: (size: s64, guard_size: s64) -> *void {
        base := VirtualAlloc(null, cast(u64) size, MEM_RESERVE | MEM_COMMIT, PAGE_READWRITE);
        if !base return null;
        previous: u32;
        if !VirtualProtect(base + size - guard_size, cast(u64) guard_size, PAGE_NOACCESS, *previous) {
            VirtualFree(base, 0, MEM_RELEASE);
            return null;
        }
        return base;
    }

    // Give the pages back but keep the address range reserved, so it is never handed out again
    // and any later access faults.
    retire :: (base: *void, size: s64) -> bool {
        return VirtualFree(base, cast(u64) size, MEM_DECOMMIT) != 0;
    }
} else {
    crt :: #system_library "libc";
    getpagesize :: () -> s32 #foreign crt;
    mmap :: (address: *void, length: u64, protection: s32, flags: s32, descriptor: s32, offset: s64) -> *void #foreign crt;
    mprotect :: (address: *void, length: u64, protection: s32) -> s32 #foreign crt;
    munmap :: (address: *void, length: u64) -> s32 #foreign crt;

    page_bytes :: () -> s64 {
        return cast(s64) getpagesize();
    }

    map_with_guard :: (size: s64, guard_size: s64) -> *void {
        #if OS == .MACOS flags: s32 = 0x1002;
        else flags: s32 = 0x22;
        base := mmap(null, cast(u64) size, 3, flags, -1, 0);
        if base == cast(*void) -1 return null;
        if mprotect(base + size - guard_size, cast(u64) guard_size, 0) != 0 {
            munmap(base, cast(u64) size);
            return null;
        }
        return base;
    }

    retire :: (base: *void, size: s64) -> bool {
        return mprotect(base, cast(u64) size, 0) == 0;
    }
}

reserve_guarded :: (state: *Unmapping_Allocator, size: s64) -> *void {
    if size < 0 return null;
    page_size := page_bytes();
    if page_size <= 0 || size > 0x7fff_ffff_ffff_ffff - page_size * 2 return null;
    readable_size := align_forward(size, page_size);
    if readable_size == 0 readable_size = page_size;
    mapping_size := readable_size + page_size;
    base := map_with_guard(mapping_size, page_size);
    if !base return null;
    pointer := base + readable_size - size;
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
    page_size := page_bytes();
    readable_size := align_forward(cast(s64) size, page_size);
    if readable_size == 0 readable_size = page_size;
    base := pointer + cast(s64) size - readable_size;
    if !retire(base, readable_size + page_size) {
        assert(false, "failed to protect retired allocation");
        return false;
    }
    table_set(*state.table, pointer, 0xffff_ffff_ffff_ffff);
    return true;
}
