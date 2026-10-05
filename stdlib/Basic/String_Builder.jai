// An inline first segment and heap-linked spill segments keep appends stable.
STRING_BUILDER_BUFFER_SIZE :: 4096 - size_of(String_Builder.Buffer);
String_Builder :: struct {
    Buffer :: struct {
        count: s64;
        allocated: s64;
        #if ENABLE_ASSERT ensured_count: s64;
        next: *Buffer;
    }
    initialized := false;
    failed := false;
    subsequent_buffer_size := -1;
    allocator: Allocator;
    current_buffer: *Buffer;
    initial_bytes: [STRING_BUILDER_BUFFER_SIZE] u8;
}
get_base_buffer :: inline (using builder: *String_Builder) -> *String_Builder.Buffer {
    return cast(*String_Builder.Buffer) builder.initial_bytes.data;
}
get_current_buffer :: inline (using builder: *String_Builder) -> *String_Builder.Buffer {
    if current_buffer return current_buffer;
    return get_base_buffer(builder);
}
get_buffer_data :: inline (using buffer: *String_Builder.Buffer) -> *u8 {
    return cast(*u8) buffer + size_of(String_Builder.Buffer);
}
init_string_builder :: (using builder: *String_Builder, buffer_size := -1) {
    if initialized reset(builder);
    allocator = context.allocator;
    initialized = true; failed = false; subsequent_buffer_size = buffer_size;
    base := get_base_buffer(builder);
    base.* = .{};
    base.allocated = STRING_BUILDER_BUFFER_SIZE - size_of(String_Builder.Buffer);
    current_buffer = null;
}
make_builder :: (builder: *String_Builder) { init_string_builder(builder); }
free_buffers :: (using builder: *String_Builder) {
    if !initialized return;
    base := get_base_buffer(builder); segment := base.next;
    while segment {
        next := segment.next;
        free(segment, allocator=allocator);
        segment = next;
    }
    base.next = null; current_buffer = null;
}
reset :: (using builder: *String_Builder) {
    if !initialized return;
    free_buffers(builder);
    // The base buffer's storage survives a reset, and so does space ensured in it: code that
    // ensured space, converted the builder to a string and then advances still passes.
    base := get_base_buffer(builder); base.count = 0;
    failed = false;
}
free :: (builder: *String_Builder) { reset(builder); }
expand :: (using builder: *String_Builder) -> bool {
    if !initialized init_string_builder(builder);
    capacity := subsequent_buffer_size;
    if capacity <= 0 capacity = STRING_BUILDER_BUFFER_SIZE;
    storage := alloc(size_of(String_Builder.Buffer) + capacity, allocator=allocator);
    if !storage { failed = true; return false; }
    segment := cast(*String_Builder.Buffer) storage;
    segment.* = .{}; segment.allocated = capacity;
    get_current_buffer(builder).next = segment; current_buffer = segment;
    return true;
}
ensure_contiguous_space_and_return_available_range :: (using builder: *String_Builder, minimum_bytes := 1) -> [] u8 {
    if minimum_bytes < 0 return .[];
    if !initialized init_string_builder(builder);
    segment := get_current_buffer(builder);
    capacity := subsequent_buffer_size;
    if capacity <= 0 capacity = STRING_BUILDER_BUFFER_SIZE;
    if minimum_bytes > segment.allocated && minimum_bytes > capacity return .[];
    if segment.allocated-segment.count < minimum_bytes {
        if !expand(builder) return .[];
        segment = get_current_buffer(builder);
    }
    #if ENABLE_ASSERT segment.ensured_count = segment.allocated;
    return .{count = segment.allocated-segment.count, data = get_buffer_data(segment)+segment.count};
}
ensure_contiguous_space :: (using builder: *String_Builder, bytes: s64) -> pointer: *void {
    available := ensure_contiguous_space_and_return_available_range(builder, bytes);
    if available.count < bytes return null;
    #if ENABLE_ASSERT get_current_buffer(builder).ensured_count = get_current_buffer(builder).count+bytes;
    return available.data;
}
advance_through_ensured_space :: (using builder: *String_Builder, bytes: s64) {
    assert(initialized && bytes >= 0);
    segment := get_current_buffer(builder);
    assert(bytes <= segment.allocated-segment.count);
    #if ENABLE_ASSERT assert(segment.count+bytes <= segment.ensured_count);
    segment.count += bytes;
}
append :: (using builder: *String_Builder, s: *u8, length: s64) {
    assert(length >= 0);
    if !initialized init_string_builder(builder);
    remaining := length; source := s;
    while remaining > 0 {
        segment := get_current_buffer(builder);
        available := segment.allocated-segment.count;
        if available == 0 { if !expand(builder) return; continue; }
        n := min(remaining, available);
        destination := get_buffer_data(segment)+segment.count;
        if n < 16 for i: 0..n-1 destination[i] = source[i];
        else memcpy(destination, source, n);
        segment.count += n; source += n; remaining -= n;
    }
}
append :: inline (builder: *String_Builder, s: string) { append(builder, s.data, s.count); }
append :: inline (builder: *String_Builder, byte: u8) {
    if builder.initialized {
        segment := get_current_buffer(builder);
        if segment.count < segment.allocated {
            get_buffer_data(segment)[segment.count] = byte;
            segment.count += 1;
            return;
        }
    }
    local := byte;
    append(builder, *local, 1);
}
append_by_pointer :: inline (builder: *String_Builder, pointer: *$T) {
    append(builder, cast(*u8) pointer, size_of(T));
}
simple_memcpy :: inline (using builder: *String_Builder, x: $T) { append_by_pointer(builder, *x); }
builder_string_length :: (using builder: *String_Builder) -> int {
    if !initialized return 0;
    total := 0; segment := get_base_buffer(builder);
    while segment { total += segment.count; segment = segment.next; }
    return total;
}
builder_to_string :: (builder: *String_Builder, extra_bytes_to_prepend := 0, do_reset := true) -> string {
    assert(extra_bytes_to_prepend >= 0);
    count := builder_string_length(builder);
    result := alloc_string(count+extra_bytes_to_prepend);
    if !result.data && count+extra_bytes_to_prepend > 0 { builder.failed = true; return ""; }
    for i: 0..extra_bytes_to_prepend-1 result.data[i] = 0;
    offset := extra_bytes_to_prepend;
    if builder.initialized {
        segment := get_base_buffer(builder);
        while segment {
            bytes := get_buffer_data(segment);
            if segment.count > 0 memcpy(result.data + offset, bytes, segment.count);
            offset += segment.count; segment = segment.next;
        }
    }
    if do_reset reset(builder);
    return result;
}
write_builder :: (using builder: *String_Builder, do_reset := true, to_standard_error := false) -> s64 {
    written := 0;
    if initialized {
        segment := get_base_buffer(builder);
        while segment {
            view: string = .{count = segment.count, data = get_buffer_data(segment)};
            write_string(view, to_standard_error);
            written += view.count; segment = segment.next;
        }
    }
    if do_reset reset(builder);
    return written;
}
consume_u8_and_length :: (input: *string, s: *u8, length: s64) -> bool {
    if length < 0 || length > input.count return false;
    for i: 0..length-1 if input.data[i] != s[i] return false;
    input.data += length; input.count -= length;
    return true;
}
append_and_steal_buffers :: (builder: *String_Builder, steal_from: *String_Builder) {
    if builder == steal_from return;
    if !steal_from.initialized return;
    // Re-appending respects distinct allocator ownership and segment capacities.
    segment := get_base_buffer(steal_from);
    while segment { append(builder, get_buffer_data(segment), segment.count); segment = segment.next; }
    reset(steal_from);
}
