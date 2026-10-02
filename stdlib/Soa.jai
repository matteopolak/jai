// Indexed structure-of-arrays storage without generated named column fields.
// Named member arrays and the reference physical layout are intentionally absent.
#scope_file;
#import "Basic";
#scope_export;

Soa :: struct (T: Type, N: s64) {
    storage: [N * size_of(T)] u8;
    written: [N] bool;
    #assert N >= 0;
}

operator [] :: (soa: $S/Soa, i: int) -> S.T {
    assert(i >= 0 && i < S.N);
    result: S.T;
    if !soa.written[i] return result;
    info := cast(*Type_Info_Struct)S.T;
    assert(info.type == .STRUCT);
    assert((cast(u32)info.textual_flags & cast(u32)Struct_Textual_Flags.UNION) == 0);
    column: s64;
    previous_end: s64;
    for info.members {
        if (it.flags & .CONSTANT) != 0 continue;
        if it.offset_in_bytes < previous_end continue;
        width := it.type.runtime_size;
        assert(it.offset_in_bytes >= 0 && it.offset_in_bytes + width <= size_of(S.T));
        assert(column + S.N * width <= soa.storage.count);
        memcpy(cast(*u8)*result + it.offset_in_bytes, soa.storage.data + column + i * width, width);
        column += S.N * width;
        previous_end = it.offset_in_bytes + width;
    }
    return result;
}

operator []= :: (array: *$S/Soa, index: int, value: S.T) {
    assert(index >= 0 && index < S.N);
    info := cast(*Type_Info_Struct)S.T;
    assert(info.type == .STRUCT);
    assert((cast(u32)info.textual_flags & cast(u32)Struct_Textual_Flags.UNION) == 0);
    column: s64;
    previous_end: s64;
    for info.members {
        if (it.flags & .CONSTANT) != 0 continue;
        width := it.type.runtime_size;
        if it.offset_in_bytes < previous_end continue;
        assert(it.offset_in_bytes + width <= size_of(S.T));
        assert(column + S.N * width <= array.storage.count);
        memcpy(array.storage.data + column + index * width, cast(*u8)*value + it.offset_in_bytes, width);
        column += S.N * width;
        previous_end = it.offset_in_bytes + width;
    }
    array.written[index] = true;
}

for_expansion :: (array: *$S/Soa, body: Code, flags: For_Flags) #expand {
    REVERSE :: (flags & .REVERSE) != 0;
    POINTER :: (flags & .POINTER) != 0;
    cursor: int = 0;
    stride: int = 1;
    #if REVERSE { cursor = S.N - 1; stride = -1; }
    while cursor >= 0 && cursor < S.N {
        `it_index := cursor;
        cursor += stride;
        #if POINTER {
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
