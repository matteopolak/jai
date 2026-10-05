// A Jai ownership ledger partitions system C allocations into independent heaps.
#module_parameters(ENABLE_ASSERTS := true, ENABLE_VALIDATE_ARGS := true)();

allocator :: Allocator.{allocator_proc, null};
allocator_default_heap: *Heap;

allocator_proc :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void {
    // The common modes first: compile-time code runs this through the interpreter, where
    // every test and call counts.
    if mode == .ALLOCATE || mode == .FREE || mode == .RESIZE {
        if mode != .FREE {
            if requested_size < 0 return null;
            #if ENABLE_VALIDATE_ARGS if requested_size > 0x7fff_ffff_ffff_ffdf return null;
        }
        lock_ledger();
        defer unlock_ledger();
        heap := cast(*Heap) allocator_data;
        if !heap {
            if !allocator_default_heap allocator_default_heap = create_heap_locked();
            heap = allocator_default_heap;
            if !heap return null;
        }
        if mode == .ALLOCATE || !old_memory {
            if mode == .FREE return null;
            entry := obtain_block(requested_size);
            if !entry return null;
            if !add_allocation(heap, entry) {
                release_block(entry);
                return null;
            }
            return entry_address(entry);
        }
        slot := find_allocation(heap, old_memory);
        #if ENABLE_ASSERTS assert_owned(slot >= 0);
        if slot < 0 return null;
        entry := heap.slots[slot];
        if mode == .RESIZE && requested_size > 0 {
            replacement := regrow_block(entry, requested_size);
            if !replacement return null;
            if replacement != entry {
                remove_allocation(heap, slot);
                if !add_allocation(heap, replacement) return null;  // Out of memory for the ledger.
            }
            return entry_address(replacement);
        }
        release_block(entry);
        remove_allocation(heap, slot);
        return null;
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
        if find_allocation(heap, old_memory) >= 0 return cast(*void) 1;
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
c_calloc :: (count: u64, size: u64) -> *void #foreign crt "calloc";
c_memmove :: (destination: *void, source: *void, count: u64) -> *void #foreign crt "memmove";

#scope_module
// Alignment. Blocks of CACHE_LINE bytes or more start on a CACHE_LINE boundary; smaller ones
// keep malloc's 16. A type declared `#align 64` has a size that is a multiple of 64, so plain
// `New`/`alloc` honor it although the allocator protocol carries no alignment.
//
// Only malloc, realloc and free are used: compile-time code of a cross build calls the host's C
// library, so posix_memalign or _aligned_malloc would each be missing on some host/target pair.
// A wide block is a malloc block WIDE_SLACK bytes larger than asked, used from its first
// cache-line boundary. Its ledger entry is that boundary, plus WIDE_BLOCK and the number of
// skipped 16-byte steps in bits 0-1. Plain entries have bits 0-3 clear (malloc is 16-aligned),
// and the ledger hashes from bit 4 up, so tags never change where an entry lives.
CACHE_LINE :: 64;
WIDE_SLACK :: CACHE_LINE - 16;
WIDE_BLOCK :: 8;
ENTRY_TAGS :: 15;

entry_address :: inline (entry: *void) -> *void {
    return cast(*void) (cast(u64) entry & ~cast(u64) ENTRY_TAGS);
}
// The block malloc returned, which realloc and free want back.
entry_origin :: (entry: *void) -> *void {
    bits := cast(u64) entry;
    if !(bits & WIDE_BLOCK) return entry;
    return cast(*void) ((bits & ~cast(u64) ENTRY_TAGS) - (bits & 3) * 16);
}
// Use the malloc block at `origin` from its first cache-line boundary. The first `keep` bytes of
// the contents sit `was_at` bytes in (realloc moved them along with the block) and follow.
wide_entry :: (origin: *void, was_at: u64, keep: s64) -> *void {
    boundary := (cast(u64) origin + CACHE_LINE - 1) & ~cast(u64) (CACHE_LINE - 1);
    skipped := boundary - cast(u64) origin;
    if keep > 0 && skipped != was_at c_memmove(cast(*void) boundary, origin + cast(s64) was_at, cast(u64) keep);
    return cast(*void) (boundary | WIDE_BLOCK | (skipped / 16));
}
obtain_block :: (size: s64) -> entry: *void {
    if size < CACHE_LINE return c_malloc(cast(u64) size);
    origin := c_malloc(cast(u64) (size + WIDE_SLACK));
    if !origin return null;
    return wide_entry(origin, 0, 0);
}
release_block :: (entry: *void) {
    c_free(entry_origin(entry));
}
// A wide block stays wide when it shrinks; a plain one turns wide when it reaches a cache line.
// Either way realloc keeps at least `size` bytes past the old start of the contents, because
// the slack covers the largest skip.
regrow_block :: (entry: *void, size: s64) -> entry: *void {
    bits := cast(u64) entry;
    wide := (bits & WIDE_BLOCK) != 0;
    if !wide && size < CACHE_LINE return c_realloc(entry, cast(u64) size);
    was_at: u64 = ifx wide then (bits & 3) * 16 else 0;
    origin := c_realloc(entry_origin(entry), cast(u64) (size + WIDE_SLACK));
    if !origin return null;
    return wide_entry(origin, was_at, size);
}

// The ledger: each heap's entries in an open-addressing set (linear probing, null = empty), so
// FREE and RESIZE find their entry without walking every allocation.
Heap :: struct { slots: **void; capacity: s64; count: s64; next: *Heap; }
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
    heap.slots = null;
    heap.capacity = 0;
    heap.count = 0;
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
    for i: 0..heap.capacity-1 if heap.slots[i] release_block(heap.slots[i]);
    if heap.slots c_free(heap.slots);
    c_free(heap);
}
slot_home :: (heap: *Heap, pointer: *void) -> s64 #no_aoc {
    return cast,no_check(s64) (((cast(u64) pointer >> 4) * 11400714819323198485) >> 32) & (heap.capacity - 1);
}
// The slot holding the entry for the block at `pointer`, or -1. Tags sit below bit 4, so an
// entry hashes like its address.
find_allocation :: (heap: *Heap, pointer: *void) -> s64 {
    if !heap.capacity return -1;
    mask := heap.capacity - 1;
    slot := slot_home(heap, pointer);
    while heap.slots[slot] {
        if entry_address(heap.slots[slot]) == pointer return slot;
        slot = (slot + 1) & mask;
    }
    return -1;
}
// At most half full, so probe runs stay short.
add_allocation :: (heap: *Heap, pointer: *void) -> bool {
    if (heap.count + 1) * 2 > heap.capacity {
        old_slots := heap.slots;
        old_capacity := heap.capacity;
        capacity := ifx old_capacity then old_capacity * 2 else 64;
        slots := cast(**void) c_calloc(cast(u64) capacity, size_of(*void));
        if !slots return false;
        heap.slots = slots;
        heap.capacity = capacity;
        heap.count = 0;
        for i: 0..old_capacity-1 if old_slots[i] place_allocation(heap, old_slots[i]);
        if old_slots c_free(old_slots);
    }
    place_allocation(heap, pointer);
    return true;
}
place_allocation :: (heap: *Heap, pointer: *void) #no_aoc {
    mask := heap.capacity - 1;
    slot := cast,no_check(s64) (((cast(u64) pointer >> 4) * 11400714819323198485) >> 32) & mask;
    slots := heap.slots;
    while slots[slot] slot = (slot + 1) & mask;
    slots[slot] = pointer;
    heap.count += 1;
}
// Backward-shift deletion: later entries of the probe run move up, so lookups need no tombstones.
remove_allocation :: (heap: *Heap, slot: s64) {
    mask := heap.capacity - 1;
    hole := slot;
    heap.slots[hole] = null;
    heap.count -= 1;
    next := hole;
    while true {
        next = (next + 1) & mask;
        pointer := heap.slots[next];
        if !pointer break;
        home := slot_home(heap, pointer);
        // Stays if its home lies cyclically in (hole, next].
        stays := ifx hole <= next then hole < home && home <= next else hole < home || home <= next;
        if stays continue;
        heap.slots[hole] = pointer;
        heap.slots[next] = null;
        hole = next;
    }
}
assert_owned :: (owned: bool) {
    if owned return;
    context.handling_assertion_failure = true;
    context.assertion_failed(#location(), "pointer is not owned by this allocator heap");
    context.handling_assertion_failure = false;
}
#if OS == .WINDOWS crt :: #system_library "msvcrt";
else crt :: #system_library "libc";
