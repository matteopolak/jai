// Signed byte displacements use their sign bit to reserve zero for null.
#import "Basic";

Relative_Pointer :: struct (Storage_Type: Type, Pointer_To_Type: Type) {
    value: Storage_Type;
    #assert Storage_Type == s8 || Storage_Type == s16 || Storage_Type == s32 || Storage_Type == s64;
}

Relative_String :: struct (Storage_Type: Type) {
    count: Storage_Type;
    data: Storage_Type;
    #assert Storage_Type == s8 || Storage_Type == s16 || Storage_Type == s32 || Storage_Type == s64;
}

decode :: (p: *Relative_Pointer) -> (result: *p.Pointer_To_Type) {
    return cast(*p.Pointer_To_Type)decode_relative_pointer_static(p.Storage_Type, *p.value);
}

encode :: (p: *Relative_Pointer, absolute: *p.Pointer_To_Type) {
    write_relative_pointer(p.Storage_Type, *p.value, absolute);
}

decode :: (p: *Relative_String) -> string {
    assert(p.count >= 0);
    result: string;
    result.count = cast(s64)p.count;
    result.data = cast(*u8)decode_relative_pointer_static(p.Storage_Type, *p.data);
    assert(result.count == 0 || result.data != null);
    return result;
}

decode_relative_pointer :: (relative_pointer_size: s32, address: *void) -> (pointer: *void, offset: s64) {
    return decode_relative_pointer(relative_pointer_size, address, address);
}

decode_relative_pointer :: (relative_pointer_size: s32, pointer_address: *void, base_address: *void) -> (pointer: *void, offset: s64) {
    displacement, present := relative_displacement(relative_pointer_size, pointer_address);
    if !present return null, 0;
    return cast(*u8)base_address + displacement, displacement;
}

decode_relative_pointer_static :: ($type: Type, address: *void) -> (pointer: *void) {
    #assert type == s8 || type == s16 || type == s32 || type == s64;
    result, offset := decode_relative_pointer(cast(s32)size_of(type), address);
    return result;
}

write_relative_pointer :: ($type: Type, pointer_address: *void, target_address: *void) {
    write_relative_pointer(type, pointer_address, pointer_address, target_address);
}

write_relative_pointer :: ($type: Type, pointer_address: *void, base_address: *void, target_address: *void) {
    #assert type == s8 || type == s16 || type == s32 || type == s64;
    storage := cast(*type)pointer_address;
    if target_address == null { <<storage = 0; return; }
    displacement := cast(s64)target_address - cast(s64)base_address;
    SIGN :: cast(u64)1 << (size_of(type) * 8 - 1);
    #if size_of(type) < 8 {
        assert(displacement > -cast(s64)SIGN && displacement < cast(s64)SIGN);
    } else {
        assert(displacement != cast(s64)SIGN);
    }
    <<storage = cast(type)(cast(u64)displacement ^ SIGN);
    assert(<<storage != 0);
}

#scope_file;

relative_displacement :: (width: s32, address: *void) -> s64, bool {
    assert(address != null);
    if width == 1 {
        encoded := <<cast(*s8)address;
        return cast(s64)(encoded ^ cast(s8)0x80), encoded != 0;
    }
    if width == 2 {
        encoded := <<cast(*s16)address;
        return cast(s64)(encoded ^ cast(s16)0x8000), encoded != 0;
    }
    if width == 4 {
        encoded := <<cast(*s32)address;
        return cast(s64)(encoded ^ cast(s32)0x8000_0000), encoded != 0;
    }
    if width == 8 {
        encoded := <<cast(*s64)address;
        return encoded ^ cast(s64)0x8000_0000_0000_0000, encoded != 0;
    }
    assert(false, "Relative pointer width must be 1, 2, 4, or 8 bytes");
    return 0, false;
}
