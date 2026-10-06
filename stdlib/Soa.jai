// Independently authored generated member columns, without hidden row storage.
#scope_file
#import "Basic";
#scope_export

Soa :: struct(T: Type, N: s64) {
    #assert N >= 0;
    #insert #run soa_columns(T, N);
}

operator [] :: (soa: $S/Soa, i: int) -> S.T {
    assert(i >= 0 && i < S.N);
    result: S.T;
    row := cast(*Type_Info_Struct) type_info(S.T);
    columns := cast(*Type_Info_Struct) type_info(S);
    for column: columns.members {
        if !soa_storage_member(*column) continue;
        member := get_field(row, column.name);
        assert(member != null);
        shape := cast(*Type_Info_Array) column.type;
        assert(shape.type == .ARRAY && shape.array_type == .FIXED && shape.array_count == S.N);
        assert(shape.element_type == member.type);
        width := member.type.runtime_size;
        destination := cast(*u8) *result + member.offset_in_bytes;
        source := cast(*u8) *soa + column.offset_in_bytes + i * width;
        memcpy(destination, source, width);
    }
    return result;
}

operator []= :: (array: *$S/Soa, index: int, value: S.T) {
    assert(index >= 0 && index < S.N);
    row := cast(*Type_Info_Struct) type_info(S.T);
    columns := cast(*Type_Info_Struct) type_info(S);
    for column: columns.members {
        if !soa_storage_member(*column) continue;
        member := get_field(row, column.name);
        assert(member != null);
        shape := cast(*Type_Info_Array) column.type;
        assert(shape.type == .ARRAY && shape.array_type == .FIXED && shape.array_count == S.N);
        assert(shape.element_type == member.type);
        width := member.type.runtime_size;
        source := cast(*u8) *value + member.offset_in_bytes;
        destination := cast(*u8) array + column.offset_in_bytes + index * width;
        memcpy(destination, source, width);
    }
}

for_expansion :: (array: *$S/Soa, body: Code, flags: For_Flags) #expand {
    cursor: int = 0;
    stride: int = 1;
    #if flags & .REVERSE {
        cursor = S.N - 1;
        stride = -1;
    }
    while cursor >= 0 && cursor < S.N {
        `it_index := cursor;
        cursor += stride;
        #if flags & .POINTER {
            temporary := (<<array)[it_index];
            `it := *temporary;
            defer (<<array)[it_index] = temporary;
            #insert body;
        } else {
            `it := (<<array)[it_index];
            #insert body;
        }
    }
}

#scope_file
soa_storage_member :: (member: *Type_Info_Struct_Member) -> bool {
    return (member.flags & (.CONSTANT | .IMPORTED)) == 0;
}

soa_columns :: (T: Type, N: s64) -> string {
    assert(N >= 0);
    info := type_info(T);
    assert(info.type == .STRUCT, "Soa requires a record type");
    record := cast(*Type_Info_Struct) info;
    selected: [..] *Type_Info_Struct_Member;
    selected.allocator = temp;
    builder: String_Builder;
    builder.allocator = temp;
    for *member: record.members {
        if !soa_storage_member(member) continue;
        assert(member.offset_in_bytes >= 0 && member.offset_in_bytes + member.type.runtime_size <= info.runtime_size);
        intersects := false;
        for previous: selected {
            if member.type.runtime_size == 0 || previous.type.runtime_size == 0 continue;
            if member.offset_in_bytes < previous.offset_in_bytes + previous.type.runtime_size &&
               previous.offset_in_bytes < member.offset_in_bytes + member.type.runtime_size {
                intersects = true;
                break;
            }
        }
        if intersects continue;
        array_add(*selected, member);
        append(*builder, member.name);
        append(*builder, ": [N] type_of(T.");
        append(*builder, member.name);
        append(*builder, ");\n");
    }
    return builder_to_string(*builder);
}
