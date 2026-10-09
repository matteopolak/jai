#import "Basic";
#import "Hash_Table";
#import "Thread"(false);

Overwriting_Allocator :: struct {
    base_allocator: Allocator;
    table: Table(*void, u64);
    overwrite_byte: u8;
    mutex: Mutex;
}

get_overwriting_allocator :: (base_allocator: Allocator = .{}, overwrite_byte: u8 = 0xcd) -> Allocator {
    base := base_allocator;
    if !base.proc base = context.allocator;
    state := New(Overwriting_Allocator, allocator = base);
    if !state return .{};
    state.base_allocator = base;
    state.overwrite_byte = overwrite_byte;
    state.table.allocator = base;
    init(*state.mutex);
    return .{ overwriting_allocator_proc, state };
}

deinit_overwriting_allocator :: (a: Allocator) {
    state := cast(*Overwriting_Allocator) a.data;
    if !state return;
    base := state.base_allocator;
    deinit(state);
    free(state, base);
}

deinit :: (ua: *Overwriting_Allocator) {
    deinit(*ua.table);
    destroy(*ua.mutex);
}

overwriting_allocator_proc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void {
    state := cast(*Overwriting_Allocator) allocator_data;
    assert(state != null, "missing overwriting allocator state");
    base := state.base_allocator;
    if mode == .CAPS {
        if old_memory {
            name := cast(*string) old_memory;
            name.* = "independent overwriting allocator";
        }
        return cast(*void) cast(u64) (Allocator_Caps.FREE | .MULTIPLE_THREADS | .CREATE_HEAP | .IS_THIS_YOURS | .HINT_I_AM_A_GENERAL_HEAP_ALLOCATOR | .HINT_I_AM_A_DEBUG_ALLOCATOR);
    }
    if mode == .ALLOCATE || mode == .RESIZE {
        if requested_size < 0 return null;
        pointer := base.proc(.ALLOCATE, requested_size, 0, null, base.data);
        if !pointer return null;
        if mode == .RESIZE && old_memory {
            copied := old_size;
            if copied > requested_size copied = requested_size;
            if copied > 0 memcpy(pointer, old_memory, copied);
            if !retire(state, old_memory) {
                base.proc(.FREE, 0, 0, pointer, base.data);
                return null;
            }
            base.proc(.FREE, 0, 0, old_memory, base.data);
        }
        lock(*state.mutex);
        table_set(*state.table, pointer, cast(u64) requested_size);
        unlock(*state.mutex);
        return pointer;
    }
    if mode == .FREE {
        if old_memory && retire(state, old_memory) base.proc(.FREE, 0, 0, old_memory, base.data);
        return null;
    }
    if mode == .IS_THIS_YOURS {
        lock(*state.mutex);
        defer unlock(*state.mutex);
        found, size := table_find(*state.table, old_memory);
        if found && size != 0xffff_ffff_ffff_ffff return cast(*void) 1;
        return null;
    }
    if mode == .CREATE_HEAP {
        // A heap is another independent instance over the same base allocator.
        heap := New(Overwriting_Allocator, allocator = base);
        if !heap return null;
        heap.base_allocator = base;
        heap.overwrite_byte = state.overwrite_byte;
        heap.table.allocator = base;
        init(*heap.mutex);
        return heap;
    }
    if mode == .DESTROY_HEAP {
        heap := cast(*Overwriting_Allocator) old_memory;
        if !heap return null;
        deinit(heap);
        free(heap, base);
        return null;
    }
    return null;
}

#scope_module
retire :: (state: *Overwriting_Allocator, pointer: *void) -> bool {
    lock(*state.mutex);
    defer unlock(*state.mutex);
    found, size := table_find(*state.table, pointer);
    if !found || size == 0xffff_ffff_ffff_ffff {
        assert(false, "invalid pointer or double free in overwriting allocator");
        return false;
    }
    table_set(*state.table, pointer, 0xffff_ffff_ffff_ffff);
    memset(pointer, state.overwrite_byte, cast(s64) size);
    return true;
}
