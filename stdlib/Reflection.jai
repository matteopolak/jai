// Runtime operations on the compiler-owned Type_Info descriptor ABI.
get_array_count_and_data :: (pointer: *void, info: *Type_Info_Array) -> (count: s64, data: *void) {
    assert(info && info.type == .ARRAY);
    if info.array_type != .FIXED {
        storage := cast(*Resizable_Array) pointer;
        return storage.count, storage.data;
    }
    return info.array_count, pointer;
}

set_value_from_string :: (any: Any, text: string) -> bool {
    cursor := text;
    return set_value_from_string(any, *cursor);
}

// Cursor updates commit only after a successful conversion and store.
set_value_from_string :: (any: Any, text: *string) -> bool {
    if !any.type || !any.value_pointer || !text return false;
    cursor := text.*;
    if any.type.type == .INTEGER {
        valid, magnitude, negative, remaining := read_integer(cursor);
        if !valid return false;
        descriptor := cast(*Type_Info_Integer) any.type;
        if descriptor.signed {
            if (!negative && magnitude > 0x7fff_ffff_ffff_ffff) || (negative && magnitude > 0x8000_0000_0000_0000) return false;
            bits := ifx negative then 0 - magnitude else magnitude;
            accepted, low, high := range_check_and_store(cast,no_check(s64) bits, descriptor, any.value_pointer);
            if !accepted return false;
        } else {
            if negative && magnitude != 0 return false;
            accepted, low, high := range_check_and_store(magnitude, descriptor, any.value_pointer);
            if !accepted return false;
        }
        text.* = remaining;
        return true;
    }
    if any.type.type == .ENUM {
        enumeration := cast(*Type_Info_Enum) any.type;
        proxy := any;
        proxy.type = enumeration.internal_type;
        if set_value_from_string(proxy, *cursor) {
            text.* = cursor;
            return true;
        }
        end: s64;
        while end < cursor.count && identifier_byte(cursor[end]) end += 1;
        name := string.{ end, cursor.data };
        for entry, index: enumeration.names {
            if entry == name {
                set_enum_value(any.value_pointer, enumeration, enumeration.values[index]);
                text.* = string.{ cursor.count - end, cursor.data + end };
                return true;
            }
        }
        return false;
    }
    if any.type.type == .BOOL {
        value: bool;
        consumed: s64;
        if has_prefix(cursor, "true") {
            value = true;
            consumed = 4;
        } else if has_prefix(cursor, "false") {
            consumed = 5;
        } else return false;
        if consumed < cursor.count && identifier_byte(cursor[consumed]) return false;
        if any.type.runtime_size != 1 return false;
        (cast(*bool) any.value_pointer).* = value;
        text.* = string.{ cursor.count - consumed, cursor.data + consumed };
        return true;
    }
    if any.type.type == .STRING {
        if cursor.count < 2 || cursor[0] != #char "\"" return false;
        end: s64 = 1;
        while end < cursor.count && cursor[end] != #char "\"" end += 1;
        if end == cursor.count return false;
        (cast(*string) any.value_pointer).* = .{ end - 1, cursor.data + 1 };
        text.* = string.{ cursor.count - end - 1, cursor.data + end + 1 };
        return true;
    }
    if any.type.type == .FLOAT {
        if any.type.runtime_size == 4 {
            value, success, remaining := string_to_float(cursor);
            if !success return false;
            (cast(*float) any.value_pointer).* = value;
            text.* = remaining;
            return true;
        }
        if any.type.runtime_size == 8 {
            value, success, remaining := string_to_float64(cursor);
            if !success return false;
            (cast(*float64) any.value_pointer).* = value;
            text.* = remaining;
            return true;
        }
    }
    return false;
}

range_check_and_store :: (value: $T, info: *Type_Info_Integer, pointer: *void) -> (success: bool, low: T, high: T) {
    #assert T == u64 || T == s64;
    low: T;
    high: T;
    #if T == u64 {
        low, high = unsigned_integer_range_from_size(info.runtime_size);
    } else {
        low, high = signed_integer_range_from_size(info.runtime_size);
    }
    if value < low || value > high return false, low, high;
    if info.runtime_size == 1 {
        (cast(*u8) pointer).* = cast,no_check(u8) value;
    } else if info.runtime_size == 2 {
        (cast(*u16) pointer).* = cast,no_check(u16) value;
    } else if info.runtime_size == 4 {
        (cast(*u32) pointer).* = cast,no_check(u32) value;
    } else if info.runtime_size == 8 {
        (cast(*u64) pointer).* = cast,no_check(u64) value;
    } else return false, low, high;
    return true, low, high;
}

signed_integer_range_from_size :: (size_in_bytes: int) -> (low: s64, high: s64) #no_aoc {
    if size_in_bytes == 1 return -128, 127;
    if size_in_bytes == 2 return -32768, 32767;
    if size_in_bytes == 4 return -2147483648, 2147483647;
    assert(size_in_bytes == 8);
    return cast,no_check(s64) 0x8000_0000_0000_0000, 0x7fff_ffff_ffff_ffff;
}

unsigned_integer_range_from_size :: (size_in_bytes: int) -> (low: u64, high: u64) #no_aoc {
    if size_in_bytes == 1 return 0, 255;
    if size_in_bytes == 2 return 0, 65535;
    if size_in_bytes == 4 return 0, 0xffff_ffff;
    assert(size_in_bytes == 8);
    return 0, 0xffff_ffff_ffff_ffff;
}

get_struct_field_info :: (info: *Type_Info_Struct, name: string) -> *Type_Info_Struct_Member {
    for member, index: info.members if member.name == name return *info.members[index];
    return null;
}

enum_name_to_value :: ($T: Type, name: string) -> T, bool {
    descriptor := type_info(T);
    #assert type_of(descriptor.*) == Type_Info_Enum;
    for entry, index: descriptor.names if entry == name return cast,no_check(T) descriptor.values[index], true;
    return cast,no_check(T) 0, false;
}

enum_value_to_name :: (e_value: $Enum) -> string {
    descriptor := type_info(Enum);
    #assert type_of(descriptor.*) == Type_Info_Enum;
    for value, index: descriptor.values if value == cast(s64) e_value return descriptor.names[index];
    return "";
}

get_enum_value :: (data: *void, info: *Type_Info_Enum) -> s64 {
    if info.internal_type.signed {
        if info.runtime_size == 1 return (cast(*s8) data).*;
        if info.runtime_size == 2 return (cast(*s16) data).*;
        if info.runtime_size == 4 return (cast(*s32) data).*;
        if info.runtime_size == 8 return (cast(*s64) data).*;
    } else {
        if info.runtime_size == 1 return (cast(*u8) data).*;
        if info.runtime_size == 2 return (cast(*u16) data).*;
        if info.runtime_size == 4 return (cast(*u32) data).*;
        if info.runtime_size == 8 return cast,no_check(s64) (cast(*u64) data).*;
    }
    assert(false);
    return 0;
}

set_enum_value :: (data: *void, info: *Type_Info_Enum, value: s64) {
    if info.runtime_size == 1 {
        (cast(*u8) data).* = cast,no_check(u8) value;
    } else if info.runtime_size == 2 {
        (cast(*u16) data).* = cast,no_check(u16) value;
    } else if info.runtime_size == 4 {
        (cast(*u32) data).* = cast,no_check(u32) value;
    } else if info.runtime_size == 8 {
        (cast(*u64) data).* = cast,no_check(u64) value;
    } else assert(false);
}

#scope_module
#import "Basic";

has_prefix :: (text: string, prefix: string) -> bool {
    if text.count < prefix.count return false;
    for byte, index: prefix if text[index] != byte return false;
    return true;
}
identifier_byte :: (byte: u8) -> bool {
    return (byte >= #char "a" && byte <= #char "z") || (byte >= #char "A" && byte <= #char "Z") || (byte >= #char "0" && byte <= #char "9") || byte == #char "_";
}
read_integer :: (text: string) -> (ok: bool, magnitude: u64, negative: bool, remaining: string) #no_aoc {
    cursor: s64;
    negative := false;
    while cursor < text.count && (text[cursor] == #char " " || text[cursor] == #char "\t" || text[cursor] == #char "\r" || text[cursor] == #char "\n") cursor += 1;
    if cursor < text.count && (text[cursor] == #char "+" || text[cursor] == #char "-") {
        negative = text[cursor] == #char "-";
        cursor += 1;
    }
    base: u64 = 10;
    if cursor + 1 < text.count && text[cursor] == #char "0" {
        prefix := text[cursor + 1];
        if prefix == #char "x" || prefix == #char "X" {
            base = 16;
            cursor += 2;
        } else if prefix == #char "b" || prefix == #char "B" {
            base = 2;
            cursor += 2;
        }
    }
    digits: s64;
    magnitude: u64;
    while cursor < text.count {
        byte := text[cursor];
        if byte == #char "_" {
            cursor += 1;
            continue;
        }
        value: u64 = 16;
        if byte >= #char "0" && byte <= #char "9" value = byte - #char "0";
        else if byte >= #char "a" && byte <= #char "f" value = byte - #char "a" + 10;
        else if byte >= #char "A" && byte <= #char "F" value = byte - #char "A" + 10;
        if value >= base break;
        if magnitude > (0xffff_ffff_ffff_ffff - value) / base return false, 0, false, text;
        magnitude = magnitude * base + value;
        digits += 1;
        cursor += 1;
    }
    if digits == 0 return false, 0, false, text;
    return true, magnitude, negative, string.{ text.count - cursor, text.data + cursor };
}
