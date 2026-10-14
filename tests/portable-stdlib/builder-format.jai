#import "Basic";
main :: () {
    builder: String_Builder;
    defer free_buffers(*builder);
    buffer: *String_Builder.Buffer = get_current_buffer(*builder);
    assert(buffer.count == 0);
    assert(print(*builder, "% %", -42, true));
    text := builder_to_string(*builder, do_reset=false);
    defer free(text);
    assert(text == "-42 true");
    assert(builder_string_length(*builder) == text.count);
    reset(*builder);
    missing := "% %";
    extra := "";
    assert(!print(*builder, missing, 1));
    assert(!print(*builder, extra, 1));
    assert(tprint("%:%", "temporary", 7) == "temporary:7");
    assert(tprint("%2 %1 %", "one", "two") == "two one two");
    assert(tprint("\% %0", 5) == "% 5");
    reset(*builder);
    bytes: [5000]u8;
    for *byte: bytes byte.* = cast(u8)120;
    append(*builder, bytes.data, bytes.count);
    assert(builder_string_length(*builder) == bytes.count);
    grown := builder_to_string(*builder);
    defer free(grown);
    assert(grown.count == 5000 && grown[0] == 120 && grown[4999] == 120);
    range := ensure_contiguous_space_and_return_available_range(*builder, 3);
    assert(range.count >= 3);
    range[0] = 97;
    range[1] = 98;
    range[2] = 99;
    advance_through_ensured_space(*builder, 3);
    ensured := builder_to_string(*builder);
    defer free(ensured);
    assert(ensured == "abc");
    failure: String_Builder;
    failure.allocator = .{deny_allocation, null};
    append(*failure, bytes.data, bytes.count);
    assert(failure.failed);
    assert(!print(*failure, ""));
    assert(builder_to_string(*failure) == "");
    free_buffers(*failure);
    print("ok\n");
}
deny_allocation :: (mode: Allocator_Mode, requested_size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void {
    return null;
}
