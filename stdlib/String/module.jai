// Authored byte-string algorithms. Returned views borrow the input bytes.
#scope_export
#load "byte-core.jai";
#scope_file
Basic :: #import "Basic";
#scope_export
sprint :: (format: string, args: ..Any) -> string { return Basic.sprint(format, ..args); }
tprint :: (format: string, args: ..Any) -> string { return Basic.tprint(format, ..args); }
to_string :: (value: Any) -> string { return Basic.sprint("%", value); }
to_string :: (data: *u8, count: int) -> string { return .{count = count, data = data}; }
to_c_string :: (value: string) -> *u8 { return Basic.to_c_string(value); }
copy_string :: (value: string) -> string { return Basic.copy_string(value); }
String_Builder :: struct {
    data: *u8;
    count: int;
    allocated: int;
}
init_string_builder :: (builder: *String_Builder) { builder.* = .{}; }
free_buffers :: (builder: *String_Builder) {
    Basic.free(builder.data); builder.* = .{};
}
append_bytes :: (builder: *String_Builder, data: *u8, count: int) -> bool {
    if count < 0 || builder.count > 0x7fff_ffff_ffff_ffff-count return false;
    needed := builder.count + count;
    source := data;
    if needed > builder.allocated {
        capacity := Basic.max(64, builder.allocated);
        while capacity < needed {
            if capacity > 0x3fff_ffff_ffff_ffff { capacity = needed; break; }
            capacity *= 2;
        }
        memory := cast(*u8) Basic.alloc(capacity);
        if !memory return false;
        for i: 0..builder.count-1 memory[i] = builder.data[i];
        if builder.data && source >= builder.data && source < builder.data+builder.count {
            source = memory + (source-builder.data);
        }
        Basic.free(builder.data); builder.data = memory; builder.allocated = capacity;
    }
    for i: 0..count-1 builder.data[builder.count+i] = source[i];
    builder.count = needed;
    return true;
}
append :: (builder: *String_Builder, value: Any) -> bool {
    text := to_string(value);
    result := append_bytes(builder, text.data, text.count);
    Basic.free(text);
    return result;
}
append :: (builder: *String_Builder, value: string) -> bool { return append_bytes(builder, value.data, value.count); }
append :: (builder: *String_Builder, value: u8) -> bool { c := value; return append_bytes(builder, *c, 1); }
append :: (builder: *String_Builder, data: *u8, count: int) -> bool { return append_bytes(builder, data, count); }
print_to_builder :: (builder: *String_Builder, format: string, args: ..Any) -> bool {
    text := sprint(format, ..args);
    result := append(builder, text); Basic.free(text);
    return result;
}
builder_string_length :: (builder: *String_Builder) -> int { return builder.count; }
builder_to_string :: (builder: *String_Builder, allocator := Basic.temp) -> string {
    result: string = .{count = builder.count, data = cast(*u8) Basic.alloc(builder.count, allocator=allocator)};
    if !result.data && builder.count > 0 return "";
    for i: 0..result.count-1 result.data[i] = builder.data[i];
    return result;
}

USE_SIMD :: false;
SIMD_WIDTH :: 16;

split :: (value: string, separator: $T) -> [] string {
    result: [..] string;
    #if T == string if separator.count == 0 { Basic.array_add(*result, value); return result; }
    rest := value;
    while true {
        found, left, right := split_from_left(rest, separator);
        Basic.array_add(*result, left);
        if !found break;
        rest = right;
    }
    return result;
}

to_lower_copy :: (value: string) -> string { r := copy_string(value); to_lower_in_place(r); return r; }
to_upper_copy :: (value: string) -> string { r := copy_string(value); to_upper_in_place(r); return r; }
to_lower_copy_new :: to_lower_copy;
to_upper_copy_new :: to_upper_copy;
replace :: (value: string, old: string, new: string) -> string {
    if old.count == 0 return copy_string(value);
    builder: String_Builder; start := 0;
    while true {
        i := find_index_from_left(value, old, start);
        if i < 0 {
            if !append(*builder, slice(value, start, value.count-start)) { free_buffers(*builder); return ""; }
            break;
        }
        if !append(*builder, slice(value, start, i-start)) || !append(*builder, new) { free_buffers(*builder); return ""; }
        start = i + old.count;
    }
    result := builder_to_string(*builder); free_buffers(*builder); return result;
}
join :: (values: .. string, separator := "", before_first := false, after_last := false) -> string {
    builder: String_Builder;
    if values.count > 0 && before_first && !append(*builder, separator) { free_buffers(*builder); return ""; }
    for i: 0..values.count-1 {
        if i > 0 && !append(*builder, separator) { free_buffers(*builder); return ""; }
        if !append(*builder, values[i]) { free_buffers(*builder); return ""; }
    }
    if values.count > 0 && after_last && !append(*builder, separator) { free_buffers(*builder); return ""; }
    result := builder_to_string(*builder); free_buffers(*builder); return result;
}
normalize_line_endings :: (s: *string) {
    write := 0; read := 0;
    while read < s.count {
        c := s.data[read]; read += 1;
        if c == 13 { if read < s.count && s.data[read] == 10 read += 1; c = 10; }
        s.data[write] = c; write += 1;
    }
    s.count = write;
}
normalize_line_endings :: (s: string) -> string #must { r := copy_string(s); normalize_line_endings(*r); return r; }

path_ensure_extension :: (path: string, extension: string) -> string {
    if ends_with(path, extension) return path;
    if begins_with(extension, ".") return join(path, extension);
    return join(path, ".", extension);
}

parse_enum :: (line: *string, $T: Type, delimiters := DEFAULT_DELIMITERS, spaces := DEFAULT_SPACES) -> value: T, success: bool {
    cursor := line.*; token, ok := parse_token(*cursor, delimiters, spaces);
    if !ok return cast(T) 0, false;
    info := cast(*Type_Info_Enum) type_info(T);
    for i: 0..info.names.count-1 if equal(token, info.names[i]) { line.* = cursor; return cast(T) info.values[i], true; }
    return cast(T) 0, false;
}
parse_int :: (line: *string, $T: Type, spaces := " \t", delimiters := DEFAULT_DELIMITERS) -> value: T, success: bool {
    cursor := line.*; token, ok := parse_token(*cursor, delimiters, spaces);
    if !ok return cast(T) 0, false;
    n, valid := string_to_int(token); if !valid return cast(T) 0, false;
    info := cast(*Type_Info_Integer) type_info(T);
    bits := info.runtime_size*8;
    if bits <= 0 || bits > 64 return cast(T) 0, false;
    if info.signed {
        if bits < 64 {
            lower := -(cast(s64) 1 << (bits-1));
            upper := (cast(s64) 1 << (bits-1))-1;
            if n < lower || n > upper return cast(T) 0, false;
        }
    } else {
        if n < 0 return cast(T) 0, false;
        if bits < 63 && cast(u64) n > (cast(u64) 1 << bits)-1 return cast(T) 0, false;
    }
    result := cast(T) n;
    line.* = cursor; return result, true;
}

parse_float :: (line: *string, delimiters := DEFAULT_DELIMITERS, spaces := DEFAULT_SPACES) -> value: float, success: bool {
    cursor := line.*; token, ok := parse_token(*cursor, delimiters, spaces);
    if !ok return 0, false;
    n, valid := string_to_float(token); if !valid return 0, false;
    line.* = cursor; return cast(float) n, true;
}
parse_int :: (value: *string) -> int, bool {
    number, success := parse_int(value, int);
    return number, success;
}
