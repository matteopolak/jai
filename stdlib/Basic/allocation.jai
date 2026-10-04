// Allocator selection remains ordinary Jai source and follows the active context.
alloc :: (size: s64, allocator := context.allocator) -> *void {
    if size < 0 || !allocator.proc return null;
    memory := allocator.proc(.ALLOCATE, size, 0, null, allocator.data);
    #if MEMORY_DEBUGGER {
        Memory_Debugger.check_alloc(allocator, memory, size);
    }
    return memory;
}

free :: (ptr: *void, allocator := context.allocator) {
    if !ptr return;
    assert(allocator.proc != null, "free requires an allocator");
    #if MEMORY_DEBUGGER {
        Memory_Debugger.check_free(allocator, ptr);
    }
    allocator.proc(.FREE, 0, 0, ptr, allocator.data);
}

free :: inline (s: string, allocator := context.allocator) {
    free(s.data, allocator);
}

realloc :: (memory: *void, size: s64, old_size: s64, allocator := context.allocator) -> *void {
    if size < 0 || old_size < 0 || !allocator.proc return null;
    replacement := allocator.proc(.RESIZE, size, old_size, memory, allocator.data);
    #if MEMORY_DEBUGGER {
        Memory_Debugger.check_realloc(allocator, memory, old_size, replacement, size);
    }
    return replacement;
}

create_heap :: (a: Allocator) -> Allocator {
    caps, name := get_capabilities_info(a);
    assert(caps & .CREATE_HEAP, "allocator does not support separate heaps");
    heap: Allocator = .{a.proc, a.proc(.CREATE_HEAP, 0, 0, null, a.data)};
    #if MEMORY_DEBUGGER {
        Memory_Debugger.check_create_heap(heap);
    }
    return heap;
}

destroy_heap :: (b: Allocator) {
    #if MEMORY_DEBUGGER {
        Memory_Debugger.check_destroy_heap(b);
    }
    b.proc(.DESTROY_HEAP, 0, 0, null, b.data);
}

get_capabilities_info :: (b: Allocator) -> (caps: Allocator_Caps, name: string) {
    name: string;
    if !b.proc return cast(Allocator_Caps) 0, name;
    raw := b.proc(.CAPS, 0, 0, *name, b.data);
    return cast,no_check(Allocator_Caps) raw, name;
}

get_capabilities :: (allocator: Allocator) -> (caps: Allocator_Caps, name: string) {
    return get_capabilities_info(allocator);
}

alloc_string :: (count: int, allocator := context.allocator) -> string {
    assert(count >= 0, "negative string size");
    if count == 0 return "";
    memory := alloc(count, allocator);
    if !memory return "";
    return .{count, cast(*u8) memory};
}

talloc_string :: (count: int) -> string {
    return alloc_string(count, temp);
}

push_allocator :: (allocator: Allocator) #expand #no_debug {
    previous := context.allocator;
    context.allocator = allocator;
    `defer context.allocator = previous;
}

push_allocator :: (proc: Allocator_Proc, data: *void) #expand #no_debug {
    push_allocator(Allocator.{proc, data});
}

Initialize :: (memory: *$T) {
    initial_value: T;
    memory.* = initial_value;
}

New :: ($T: Type, $initialized := true, allocator := context.allocator) -> *T {
    pointer := cast(*T) alloc(size_of(T), allocator);
    #if initialized if pointer Initialize(pointer);
    return pointer;
}

// Allocates from context.allocator. With `alignment`, the array starts at that alignment
// inside a slightly larger block; free `unaligned_base`, not `result.data`.
NewArray :: (count: s64, $T: Type, $initialized := true, alignment: s32 = -1) -> (result: [] T, unaligned_base: *void) {
    if count <= 0 return .[], null;
    extra: s64 = 0;
    if alignment > 0 extra = alignment;
    if size_of(T) != 0 && count > (0x7fff_ffff_ffff_ffff - extra) / size_of(T) return .[], null;
    base := alloc(count * size_of(T) + extra);
    if !base return .[], null;
    data := base;
    if alignment > 0 data = cast(*void) align_forward(cast(s64) base, alignment);
    result: [] T;
    result.count = count;
    result.data = cast(*T) data;
    #if initialized {
        index: s64 = 0;
        while index < count {
            Initialize(*result[index]);
            index += 1;
        }
    }
    return result, base;
}

align_forward :: (orig_size: s64, alignment: s64) -> s64 {
    assert(alignment > 0, "alignment must be positive");
    remainder := orig_size % alignment;
    if remainder == 0 return orig_size;
    return orig_size + alignment - remainder;
}

talloc :: inline (size: s64) -> *void {
    return temporary_allocator_proc(.ALLOCATE, size, 0, null, null);
}
temporary_alloc :: inline (size: s64) -> *void { return talloc(size); }
temp :: Allocator.{temporary_allocator_proc, null};
__temporary_allocator :: temp;
temporary_allocator :: temp;

Temporary_Storage_State :: struct {
    top_overflow_page: *Temporary_Page;
    current_page_bytes_occupied: s64;
    total_bytes_occupied: s64;
}

temporary_allocator_proc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void {
    storage := context.temporary_storage;
    if mode == .CAPS {
        if old_memory {
            name := cast(*string) old_memory;
            name.* = "independent temporary arena";
        }
        return cast(*void) cast(u64) Allocator_Caps.HINT_I_AM_PER_FRAME_TEMPORARY_STORAGE;
    }
    if mode == .IS_THIS_YOURS {
        if !storage || !old_memory return null;
        arena := temporary_arena(storage);
        if temporary_range_contains(arena.original_data, arena.original_size, old_memory) return cast(*void) 1;
        page := arena.overflow_pages;
        while page {
            start := cast(*u8) page + ALIGNED_OVERFLOW_PAGE_ALLOCATION;
            if temporary_range_contains(start, page.size, old_memory) return cast(*void) 1;
            page = page.next;
        }
        return null;
    }
    if mode == .FREE return null;
    if mode != .ALLOCATE && mode != .RESIZE return null;
    if requested_size < 0 || requested_size > 0x7fff_ffff_ffff_fff8 return null;
    if !storage {
        fallback := context.allocator;
        if fallback.proc == temporary_allocator_proc fallback = Context_Base.default_allocator;
        if mode == .ALLOCATE return alloc(requested_size, fallback);
        return realloc(old_memory, requested_size, old_size, fallback);
    }
    if mode == .RESIZE && old_memory && requested_size <= align_forward(old_size, 8) return old_memory;
    arena := temporary_arena(storage);
    size := align_forward(requested_size, 8);
    if size > storage.size - arena.current_page_bytes_occupied {
        if !add_temporary_page(storage, size) return null;
    }
    result := storage.data + arena.current_page_bytes_occupied;
    if mode == .RESIZE && old_memory {
        retained := old_size;
        if requested_size < retained retained = requested_size;
        if retained > 0 memcpy(result, old_memory, retained);
    }
    arena.current_page_bytes_occupied += size;
    storage.total_bytes_occupied += size;
    if storage.total_bytes_occupied > storage.high_water_mark storage.high_water_mark = storage.total_bytes_occupied;
    return result;
}

get_temporary_storage_mark :: inline () -> Temporary_Storage_State {
    storage := context.temporary_storage;
    if !storage return .{};
    arena := temporary_arena(storage);
    return .{arena.overflow_pages, arena.current_page_bytes_occupied, storage.total_bytes_occupied};
}

set_temporary_storage_mark :: inline (state: Temporary_Storage_State, loc := #caller_location) {
    storage := context.temporary_storage;
    if !storage return;
    if !release_temporary_pages(storage, state.top_overflow_page) return;
    arena := temporary_arena(storage);
    page := state.top_overflow_page;
    if page {
        storage.data = cast(*u8) page + ALIGNED_OVERFLOW_PAGE_ALLOCATION;
        storage.size = page.size;
    } else {
        storage.data = arena.original_data;
        storage.size = arena.original_size;
    }
    assert(state.current_page_bytes_occupied >= 0 && state.current_page_bytes_occupied <= storage.size, "invalid temporary storage mark");
    arena.current_page_bytes_occupied = state.current_page_bytes_occupied;
    storage.total_bytes_occupied = state.total_bytes_occupied;
    storage.last_set_mark_location = loc;
    #if TEMP_ALLOCATOR_POISON_FREED_MEMORY memset(storage.data + arena.current_page_bytes_occupied, SET_STORAGE_MARK_STAMP, storage.size - arena.current_page_bytes_occupied);
}

reset_temporary_storage :: () {
    storage := context.temporary_storage;
    if !storage return;
    state: Temporary_Storage_State;
    set_temporary_storage_mark(state);
    storage.high_water_mark = 0;
    #if TEMP_ALLOCATOR_POISON_FREED_MEMORY memset(storage.data, RESET_STORAGE_STAMP, storage.size);
}

auto_release_temp :: (loc := #caller_location) #expand {
    mark := get_temporary_storage_mark();
    `defer set_temporary_storage_mark(mark, loc);
}

init_temporary_storage :: (ts: *Temporary_Storage, size: s64 = 16384, starting_storage: *u8 = null, allocator := context.allocator) -> bool {
    if size < 0 return false;
    ts.* = .{};
    data := starting_storage;
    if !data && size > 0 data = cast(*u8) alloc(size, allocator);
    if !data && size > 0 return false;
    ts.data = data;
    ts.size = size;
    arena := temporary_arena(ts);
    arena.original_data = data;
    arena.original_size = size;
    arena.overflow_allocator = allocator;
    return true;
}

deinit_temporary_storage :: (ts: *Temporary_Storage, allocator := context.allocator, free_original := false) {
    release_temporary_pages(ts, null);
    if free_original free(temporary_arena(ts).original_data, allocator);
    ts.* = .{};
}

#scope_module
ALIGNED_OVERFLOW_PAGE_ALLOCATION :: 32;

// Temporary_Storage (Runtime_Support) has only the public fields plus an opaque
// `implementation_data` blob, as in Jai 0.2.029+; the arena bookkeeping inside it belongs to Basic.
// Overflow pages come straight from the overflow allocator, so the memory debugger never sees them.
Temporary_Page :: struct {
    next: *Temporary_Page;
    allocator: Allocator;
    size: s64;
}
Temporary_Arena :: struct {
    current_page_bytes_occupied: s64;
    overflow_allocator: Allocator;
    overflow_pages: *Temporary_Page;
    original_data: *u8;
    original_size: s64;
}
#assert size_of(Temporary_Arena) <= size_of(type_of(Temporary_Storage.implementation_data));

temporary_arena :: (ts: *Temporary_Storage) -> *Temporary_Arena {
    arena := cast(*Temporary_Arena) ts.implementation_data.data;
    // The runtime only fills `data`/`size`; adopt them as the original page on first use.
    if !arena.original_data && !arena.overflow_pages {
        arena.original_data = ts.data;
        arena.original_size = ts.size;
    }
    return arena;
}

temporary_range_contains :: (base: *u8, size: s64, pointer: *void) -> bool {
    p := cast(*u8) pointer;
    return base != null && p >= base && p < base + size;
}

add_temporary_page :: (storage: *Temporary_Storage, required: s64) -> bool {
    arena := temporary_arena(storage);
    capacity := arena.original_size;
    if capacity < 16384 capacity = 16384;
    if capacity < required capacity = required;
    allocator := arena.overflow_allocator;
    if !allocator.proc || allocator.proc == temporary_allocator_proc allocator = Context_Base.default_allocator;
    base := allocator.proc(.ALLOCATE, capacity + ALIGNED_OVERFLOW_PAGE_ALLOCATION, 0, null, allocator.data);
    if !base return false;
    page := cast(*Temporary_Page) base;
    page.next = arena.overflow_pages;
    page.allocator = allocator;
    page.size = capacity;
    arena.overflow_pages = page;
    storage.data = cast(*u8) base + ALIGNED_OVERFLOW_PAGE_ALLOCATION;
    storage.size = capacity;
    arena.current_page_bytes_occupied = 0;
    return true;
}

release_temporary_pages :: (storage: *Temporary_Storage, stop: *Temporary_Page) -> bool {
    arena := temporary_arena(storage);
    probe := arena.overflow_pages;
    while probe != stop {
        if !probe {
            assert(false, "temporary mark belongs to a different storage arena");
            return false;
        }
        probe = probe.next;
    }
    while arena.overflow_pages != stop {
        page := arena.overflow_pages;
        arena.overflow_pages = page.next;
        allocator := page.allocator;
        #if TEMP_ALLOCATOR_POISON_FREED_MEMORY memset(cast(*u8) page + ALIGNED_OVERFLOW_PAGE_ALLOCATION, FREE_PAGE_STAMP, page.size);
        allocator.proc(.FREE, 0, page.size + ALIGNED_OVERFLOW_PAGE_ALLOCATION, page, allocator.data);
    }
    return true;
}
#scope_export
