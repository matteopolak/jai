// Fiber stacks: one anonymous mapping each, with the lowest pages made inaccessible so that a fiber
// that overflows its stack faults instead of writing into its neighbour's memory.

Stack :: struct {
    // Lowest address of the mapping, which is the start of the guard region.
    base: *void;
    // Bytes mapped, guard included.
    size: s64;
    guard: s64;
}

#if OS == .WINDOWS {
    kernel32 :: #system_library "kernel32";
    VirtualAlloc :: (address: *void, size: u64, allocation_type: u32, protect: u32) -> *void #foreign kernel32;
    VirtualProtect :: (address: *void, size: u64, new_protect: u32, old_protect: *u32) -> s32 #foreign kernel32;
    VirtualFree :: (address: *void, size: u64, free_type: u32) -> s32 #foreign kernel32;

    MEM_COMMIT :: 0x1000;
    MEM_RESERVE :: 0x2000;
    MEM_RELEASE :: 0x8000;
    PAGE_NOACCESS :: 0x01;
    PAGE_READWRITE :: 0x04;

    // Windows pages are 4 KiB on x64 and arm64 alike.
    page_bytes :: () -> s64 {
        return 4096;
    }

    map_stack :: (size: s64, guard: s64) -> *void {
        base := VirtualAlloc(null, cast(u64) size, MEM_RESERVE | MEM_COMMIT, PAGE_READWRITE);
        if !base return null;

        previous: u32;
        if !VirtualProtect(base, cast(u64) guard, PAGE_NOACCESS, *previous) {
            VirtualFree(base, 0, MEM_RELEASE);
            return null;
        }

        return base;
    }

    unmap_stack :: (base: *void, size: s64) {
        VirtualFree(base, 0, MEM_RELEASE);
    }

    DiscardVirtualMemory :: (address: *void, size: u64) -> u32 #foreign kernel32;

    // The contents of the pages are not needed again; their memory goes back to the system.
    discard_pages :: (address: *void, size: s64) {
        DiscardVirtualMemory(address, cast(u64) size);
    }
} else {
    libc :: #system_library "libc";
    getpagesize :: () -> s32 #foreign libc;
    mmap :: (address: *void, length: u64, protection: s32, flags: s32, descriptor: s32, offset: s64) -> *void #foreign libc;
    mprotect :: (address: *void, length: u64, protection: s32) -> s32 #foreign libc;
    munmap :: (address: *void, length: u64) -> s32 #foreign libc;

    page_bytes :: () -> s64 {
        return cast(s64) getpagesize();
    }

    map_stack :: (size: s64, guard: s64) -> *void {
        // MAP_PRIVATE | MAP_ANONYMOUS, not reserving swap (MAP_NORESERVE); Linux also gets MAP_STACK.
        #if OS == .MACOS flags: s32 = 0x1002 | 0x40;
        else flags: s32 = 0x22 | 0x4000 | 0x20000;
        base := mmap(null, cast(u64) size, 3, flags, -1, 0);
        if base == cast(*void) -1 return null;

        if mprotect(base, cast(u64) guard, 0) != 0 {
            munmap(base, cast(u64) size);
            return null;
        }

        return base;
    }

    unmap_stack :: (base: *void, size: s64) {
        munmap(base, cast(u64) size);
    }

    madvise :: (address: *void, length: u64, advice: s32) -> s32 #foreign libc;

    // The contents of the pages are not needed again; their memory goes back to the system (a
    // later touch finds zero pages). macOS ignores MADV_DONTNEED for anonymous memory, so it asks
    // for MADV_FREE_REUSABLE, which also takes the pages out of the resident size at once.
    discard_pages :: (address: *void, size: s64) {
        #if OS == .MACOS advice: s32 = 7;
        else advice: s32 = 4;

        madvise(address, cast(u64) size, advice);
    }
}

// A stack of at least `bytes` bytes (rounded up to whole pages), or a zero `base`.
stack_allocate :: (bytes: s64) -> Stack {
    page := page_bytes();
    guard := max(page, 16384);
    guard = (guard + page - 1) / page * page;

    size := (max(bytes, guard + page * 4) + page - 1) / page * page;
    base := map_stack(size, guard);

    stack: Stack;

    if base stack = .{ base, size, guard };

    return stack;
}

stack_release :: (stack: Stack) {
    if stack.base unmap_stack(stack.base, stack.size);
}

// How far below the stack pointer a page must lie before `stack_discard_dead` takes it: the callee's
// own frames and the registers a context switch saves live just below the caller's frame.
DISCARD_MARGIN :: 1024;

// Gives the memory of the stack's dead part back to the system: whole pages that lie below the
// running code's frames, which an earlier deep call touched and which nothing will read again (a
// stack is written before it is read). Never the guard region, and never anything at or above the
// current frame. The pages come back as zeros when the fiber calls deeper again.
stack_discard_dead :: (stack: Stack) {
    marker: u8;

    page := page_bytes();
    here := cast(s64) *marker;
    first := cast(s64) stack.base + stack.guard;

    // A sanitizer can move locals to a heap-allocated fake stack; then there is no stack pointer
    // to be had from a local, and nothing is released.
    if here < first || here >= cast(s64) stack.base + stack.size return;

    limit := (here - DISCARD_MARGIN) / page * page;

    if limit - first < page return;

    discard_pages(cast(*void) first, limit - first);
}
