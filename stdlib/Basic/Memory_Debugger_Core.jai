// Independent registry core. All addresses refer to real caller memory.
Allocation :: struct {
    pointer: *void;
    size: s64;
    index: u64;
    alloc_site_trace: *Packed_Stack_Trace;
    free_site_trace: *Packed_Stack_Trace;
    thread_index: u32;
    propagates_leak_ownership := true;
    is_live: bool;
    vis_reported_freed: bool;
    visualization_update_cycle: u32;
    allocator: Allocator;
}
Packed_Stack_Trace :: struct { hash: u64; nodes: []Stack_Trace_Node; }

#scope_module
MD_Status :: enum {
    OK;
    UNKNOWN_MEMORY;
    ALREADY_FREED;
    ALREADY_LIVE;
    ALLOCATOR_MISMATCH;
    SIZE_MISMATCH;
    OUT_OF_MEMORY;
    FAILED_REALLOC;
}
MD_Record :: struct {
    allocation: Allocation;
    next: *MD_Record;
    frame_allocations: s64;
    frame_bytes: s64;
    frame_cycle: u32;
    free_cycle: u32;
    frame_frees: s64;
    frame_freed_bytes: s64;
    ignored: bool;
}
MD_Trace_Block :: struct {
    packed: Packed_Stack_Trace;
    next: *MD_Trace_Block;
}
MD_State :: struct {
    storage_allocator: Allocator;
    records: *MD_Record;
    // The newest record per address (open addressing, power-of-two count), for `md_find`.
    slots: **MD_Record;
    slot_count: s64;
    slots_used: s64;
    traces: *MD_Trace_Block;
    next_index: u64 = 1;
    first_report_index: u64 = 1;
    frame_cycle: u32 = 1;
}
MD_TRACE_BYTES :: (size_of(MD_Trace_Block) + 7) & ~7;

md_find :: (state: *MD_State, pointer: *void) -> *MD_Record {
    if !state.slot_count return null;
    mask := state.slot_count - 1;
    slot := md_slot_hash(pointer) & mask;
    while state.slots[slot] {
        if state.slots[slot].allocation.pointer == pointer return state.slots[slot];
        slot = (slot + 1) & mask;
    }
    return null;
}
md_slot_hash :: (pointer: *void) -> s64 #no_aoc {
    return cast,no_check(s64) ((cast(u64) pointer * 11400714819323198485) >> 32);
}
// Make `record` the one `md_find` returns for its address (addresses are reused after frees).
md_index :: (state: *MD_State, record: *MD_Record) -> bool {
    if (state.slots_used + 1) * 4 >= state.slot_count * 3 {
        old, old_count := state.slots, state.slot_count;
        count := ifx old_count then old_count * 2 else 1024;
        bytes := count * size_of(*MD_Record);
        slots := cast(**MD_Record) state.storage_allocator.proc(.ALLOCATE, bytes, 0, null, state.storage_allocator.data);
        if !slots return false;
        memset(slots, 0, bytes);
        state.slots, state.slot_count, state.slots_used = slots, count, 0;
        for 0..old_count - 1  if old[it]  md_index(state, old[it]);
        if old state.storage_allocator.proc(.FREE, 0, old_count * size_of(*MD_Record), old, state.storage_allocator.data);
    }
    mask := state.slot_count - 1;
    slot := md_slot_hash(record.allocation.pointer) & mask;
    while state.slots[slot] && state.slots[slot].allocation.pointer != record.allocation.pointer {
        slot = (slot + 1) & mask;
    }
    if !state.slots[slot]  state.slots_used += 1;
    state.slots[slot] = record;
    return true;
}
md_same_allocator :: (a: Allocator, b: Allocator) -> bool { return a.proc == b.proc && a.data == b.data; }
md_raw_new :: (state: *MD_State, $T: Type) -> *T {
    memory := cast(*T)state.storage_allocator.proc(.ALLOCATE, size_of(T), 0, null, state.storage_allocator.data);
    if memory { initial: T; memory.* = initial; }
    return memory;
}
md_pack_trace :: (state: *MD_State, trace: *Stack_Trace_Node) -> *Packed_Stack_Trace {
    count: s64;
    cursor := trace;
    while cursor { count += 1; cursor = cursor.next; }
    bytes := MD_TRACE_BYTES + count * size_of(Stack_Trace_Node);
    block := cast(*MD_Trace_Block)state.storage_allocator.proc(.ALLOCATE, bytes, 0, null, state.storage_allocator.data);
    if !block return null;
    block.* = .{};
    block.packed.nodes = .{count, cast(*Stack_Trace_Node)(cast(*u8)block + MD_TRACE_BYTES)};
    if trace block.packed.hash = trace.hash;
    cursor = trace;
    for i: 0..count-1 {
        block.packed.nodes[i] = cursor.*;
        block.packed.nodes[i].next = null;
        cursor = cursor.next;
    }
    block.next = state.traces;
    state.traces = block;
    return *block.packed;
}
md_trace_matches :: (a: *Packed_Stack_Trace, b: *Packed_Stack_Trace) -> bool {
    if a == b return true;
    if !a || !b || a.nodes.count != b.nodes.count return false;
    for i: 0..a.nodes.count-1 {
        left := a.nodes[i]; right := b.nodes[i];
        if left.info != right.info || left.line_number != right.line_number return false;
    }
    return true;
}
md_note_frame :: (state: *MD_State, record: *MD_Record, bytes: s64) {
    if record.frame_cycle != state.frame_cycle {
        record.frame_cycle = state.frame_cycle;
        record.frame_allocations = 0;
        record.frame_bytes = 0;
    }
    record.frame_allocations += 1;
    record.frame_bytes += bytes;
    record.allocation.visualization_update_cycle = state.frame_cycle;
}
md_note_free_frame :: (state: *MD_State, record: *MD_Record, bytes: s64) {
    if record.free_cycle != state.frame_cycle {
        record.free_cycle = state.frame_cycle;
        record.frame_frees = 0;
        record.frame_freed_bytes = 0;
    }
    record.frame_frees += 1;
    record.frame_freed_bytes += bytes;
}
md_alloc :: (state: *MD_State, allocator: Allocator, memory: *void, size: s64, trace: *Stack_Trace_Node, thread_index: u32) -> MD_Status {
    if size < 0 return .SIZE_MISMATCH;
    if !memory return .OK;
    existing := md_find(state, memory);
    if existing && existing.allocation.is_live return .ALREADY_LIVE;
    record := md_raw_new(state, MD_Record);
    if !record return .OUT_OF_MEMORY;
    captured := md_pack_trace(state, trace);
    if !captured {
        state.storage_allocator.proc(.FREE, 0, size_of(MD_Record), record, state.storage_allocator.data);
        return .OUT_OF_MEMORY;
    }
    record.allocation.pointer = memory;
    if !md_index(state, record) {
        state.storage_allocator.proc(.FREE, 0, size_of(MD_Record), record, state.storage_allocator.data);
        return .OUT_OF_MEMORY;
    }
    record.allocation.size = size;
    record.allocation.index = state.next_index;
    state.next_index += 1;
    record.allocation.alloc_site_trace = captured;
    record.allocation.thread_index = thread_index;
    record.allocation.is_live = true;
    record.allocation.allocator = allocator;
    md_note_frame(state, record, size);
    record.next = state.records;
    state.records = record;
    return .OK;
}
md_free :: (state: *MD_State, allocator: Allocator, memory: *void, trace: *Stack_Trace_Node) -> MD_Status {
    if !memory return .OK;
    record := md_find(state, memory);
    if !record return .UNKNOWN_MEMORY;
    if !record.allocation.is_live return .ALREADY_FREED;
    if !md_same_allocator(record.allocation.allocator, allocator) return .ALLOCATOR_MISMATCH;
    captured := md_pack_trace(state, trace);
    record.allocation.free_site_trace = captured;
    record.allocation.is_live = false;
    md_note_free_frame(state, record, record.allocation.size);
    if !captured return .OUT_OF_MEMORY;
    return .OK;
}
md_realloc :: (state: *MD_State, allocator: Allocator, old_memory: *void, old_size: s64, new_memory: *void, new_size: s64, trace: *Stack_Trace_Node, thread_index: u32) -> MD_Status {
    if old_size < 0 || new_size < 0 return .SIZE_MISMATCH;
    if !old_memory return md_alloc(state, allocator, new_memory, new_size, trace, thread_index);
    record := md_find(state, old_memory);
    if !record return .UNKNOWN_MEMORY;
    if !record.allocation.is_live return .ALREADY_FREED;
    if !md_same_allocator(record.allocation.allocator, allocator) return .ALLOCATOR_MISMATCH;
    if old_size != record.allocation.size return .SIZE_MISMATCH;
    if !new_memory && new_size > 0 return .FAILED_REALLOC;
    if new_memory == old_memory {
        record.allocation.size = new_size;
        if new_size > old_size md_note_frame(state, record, new_size - old_size);
        if new_size < old_size {
            record.allocation.free_site_trace = md_pack_trace(state, trace);
            md_note_free_frame(state, record, old_size - new_size);
            if !record.allocation.free_site_trace return .OUT_OF_MEMORY;
        }
        return .OK;
    }
    if new_memory {
        status := md_alloc(state, allocator, new_memory, new_size, trace, thread_index);
        // The allocator has already moved the bytes. Retire the old address
        // even if the history storage could not represent the replacement.
        if status != .OK { md_free(state, allocator, old_memory, trace); return status; }
        moved := md_find(state, new_memory);
        moved.ignored = record.ignored;
        moved.allocation.propagates_leak_ownership = record.allocation.propagates_leak_ownership;
    }
    return md_free(state, allocator, old_memory, trace);
}
md_destroy_heap :: (state: *MD_State, allocator: Allocator, trace: *Stack_Trace_Node) -> MD_Status {
    result := MD_Status.OK;
    cursor := state.records;
    while cursor {
        if cursor.allocation.is_live && md_same_allocator(cursor.allocation.allocator, allocator) {
            status := md_free(state, allocator, cursor.allocation.pointer, trace);
            if status != .OK result = status;
        }
        cursor = cursor.next;
    }
    return result;
}
md_is_leak :: (state: *MD_State, record: *MD_Record) -> bool {
    return record.allocation.is_live && !record.ignored && record.allocation.index >= state.first_report_index;
}
md_deinit :: (state: *MD_State) {
    record := state.records;
    while record {
        next := record.next;
        state.storage_allocator.proc(.FREE, 0, size_of(MD_Record), record, state.storage_allocator.data);
        record = next;
    }
    trace := state.traces;
    while trace {
        next := trace.next;
        bytes := MD_TRACE_BYTES + trace.packed.nodes.count * size_of(Stack_Trace_Node);
        state.storage_allocator.proc(.FREE, 0, bytes, trace, state.storage_allocator.data);
        trace = next;
    }
    if state.slots  state.storage_allocator.proc(.FREE, 0, state.slot_count * size_of(*MD_Record), state.slots, state.storage_allocator.data);
    allocator := state.storage_allocator;
    state.* = .{};
    state.storage_allocator = allocator;
}
