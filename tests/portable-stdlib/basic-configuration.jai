B :: #import "Basic";
Off :: #import "Basic"(ENABLE_ASSERT = false);
On :: #import "Basic"(ENABLE_ASSERT = true);

ENABLE_ASSERT :: false; // Root constants do not configure imported module instances.

calls: int;

effect :: () -> bool {
    calls += 1;
    return false;
}

message :: () -> string {
    calls += 1;
    return "disabled";
}

location :: () -> Source_Code_Location {
    calls += 1;
    return .{};
}

main :: () {
    B.assert(!ENABLE_ASSERT);
    B.assert(type_info(B.String_Builder) == type_info(On.String_Builder));
    B.assert(size_of(B.String_Builder.Buffer) == 32);
    B.assert(size_of(Off.String_Builder.Buffer) == 24);
    B.assert(B.STRING_BUILDER_BUFFER_SIZE == 4096 - size_of(B.String_Builder.Buffer));
    B.assert(Off.STRING_BUILDER_BUFFER_SIZE == 4096 - size_of(Off.String_Builder.Buffer));
    builder: B.String_Builder;

    defer B.free_buffers(*builder);
    buffer := B.get_current_buffer(*builder);

    B.assert(buffer.ensured_count == 0);
    memory := B.ensure_contiguous_space(*builder, 7);

    B.assert(memory != null && buffer.ensured_count == 7);
    B.advance_through_ensured_space(*builder, 3);
    B.assert(buffer.ensured_count == 4 && buffer.count == 3);
    disabled: Off.String_Builder;

    defer Off.free_buffers(*disabled);
    Off.append(*disabled, "works");
    B.assert(Off.builder_string_length(*disabled) == 5);
    Off.assert(effect(), message(), effect(), loc = location());
    B.assert(calls == 0);
    B.print("ok\n");
}
