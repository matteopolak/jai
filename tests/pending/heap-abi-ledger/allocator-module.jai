// A Jai ownership ledger partitions system C allocations into independent heaps.
#module_parameters(ENABLE_ASSERTS := true, ENABLE_VALIDATE_ARGS := true)();

allocator :: Allocator.{allocator_proc, null};
allocator_default_heap: *Heap;

allocator_proc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void {
    if mode == .ALLOCATE || mode == .RESIZE {
        if requested_size < 0 return null;
        #if ENABLE_VALIDATE_ARGS if requested_size > 0x7fff_ffff_ffff_ffdf return null;
    }
    if mode == .CAPS {
        if old_memory {
            name := cast(*string) old_memory;
            name.* = "independent C heap with Jai ownership ledger";
        }
        return cast(*void) cast(u64) (Allocator_Caps.MULTIPLE_THREADS | .CREATE_HEAP | .FREE | .ACTUALLY_RESIZE | .IS_THIS_YOURS | .HINT_I_AM_A_GENERAL_HEAP_ALLOCATOR);
    }
    if mode == .STARTUP {
        initialize_if_needed();
        return null;
    }
    if mode == .SHUTDOWN {
        finalize();
        return null;
    }
    if mode == .THREAD_START || mode == .THREAD_STOP return null;
    lock_ledger();
    defer unlock_ledger();
    if mode == .CREATE_HEAP return create_heap_locked();
    heap := cast(*Heap) allocator_data;
    if !heap {
        if !allocator_default_heap allocator_default_heap = create_heap_locked();
        heap = allocator_default_heap;
    }
    if !heap return null;
    if mode == .DESTROY_HEAP {
        destroy_heap_locked(heap);
        return null;
    }
    if mode == .IS_THIS_YOURS {
        if find_allocation(heap, old_memory) return cast(*void) 1;
        return null;
    }
    if mode == .ALLOCATE || (mode == .RESIZE && !old_memory) {
        pointer := c_malloc(cast(u64) requested_size);
        if !pointer return null;
        entry := cast(*Allocation) c_malloc(cast(u64) size_of(Allocation));
        if !entry {
            c_free(pointer);
            return null;
        }
        entry.pointer = pointer;
        entry.size = requested_size;
        entry.next = heap.first;
        heap.first = entry;
        return pointer;
    }
    if mode == .FREE || mode == .RESIZE {
        if !old_memory return null;
        entry := find_allocation(heap, old_memory);
        #if ENABLE_ASSERTS assert_owned(entry != null);
        if !entry return null;
        if mode == .RESIZE && requested_size > 0 {
            replacement := c_realloc(old_memory, cast(u64) requested_size);
            if !replacement return null;
            entry.pointer = replacement;
            entry.size = requested_size;
            return replacement;
        }
        c_free(old_memory);
        remove_allocation(heap, entry);
        return null;
    }
    return null;
}

initialize_if_needed :: inline () -> did_init: bool {
    lock_ledger();
    defer unlock_ledger();
    if allocator_default_heap return false;
    allocator_default_heap = create_heap_locked();
    return allocator_default_heap != null;
}

finalize :: () {
    lock_ledger();
    defer unlock_ledger();
    while heaps destroy_heap_locked(heaps);
    allocator_default_heap = null;
}

unsafe_reset :: inline () {
    // Only for the child after fork: no sibling threads exist there.
    ledger_lock = 0;
}

c_malloc :: (size: u64) -> *void #foreign crt "malloc";
c_free :: (memory: *void) #foreign crt "free";
c_realloc :: (memory: *void, size: u64) -> *void #foreign crt "realloc";

#scope_module
Heap :: struct { first: *Allocation; next: *Heap; }
Allocation :: struct { pointer: *void; size: s64; next: *Allocation; }
heaps: *Heap;
ledger_lock: s32;

lock_ledger :: () {
    while true {
        success, observed := compare_and_swap(*ledger_lock, cast(s32) 0, cast(s32) 1);
        if success return;
    }
}
unlock_ledger :: () {
    success, observed := compare_and_swap(*ledger_lock, cast(s32) 1, cast(s32) 0);
}
create_heap_locked :: () -> *Heap {
    heap := cast(*Heap) c_malloc(cast(u64) size_of(Heap));
    if !heap return null;
    heap.first = null;
    heap.next = heaps;
    heaps = heap;
    return heap;
}
destroy_heap_locked :: (heap: *Heap) {
    cursor := heaps;
    previous: *Heap;
    while cursor && cursor != heap {
        previous = cursor;
        cursor = cursor.next;
    }
    if !cursor return;
    if previous previous.next = heap.next;
    else heaps = heap.next;
    if allocator_default_heap == heap allocator_default_heap = null;
    entry := heap.first;
    while entry {
        next := entry.next;
        c_free(entry.pointer);
        c_free(entry);
        entry = next;
    }
    c_free(heap);
}
find_allocation :: (heap: *Heap, pointer: *void) -> *Allocation {
    entry := heap.first;
    while entry {
        if entry.pointer == pointer return entry;
        entry = entry.next;
    }
    return null;
}
remove_allocation :: (heap: *Heap, entry: *Allocation) {
    cursor := heap.first;
    previous: *Allocation;
    while cursor != entry {
        previous = cursor;
        cursor = cursor.next;
    }
    if previous previous.next = entry.next;
    else heap.first = entry.next;
    c_free(entry);
}
assert_owned :: (owned: bool) {
    if owned return;
    context.handling_assertion_failure = true;
    context.assertion_failed(#location(), "pointer is not owned by this allocator heap");
    context.handling_assertion_failure = false;
}
#if OS == .WINDOWS crt :: #system_library "msvcrt";
else crt :: #system_library "libc";
