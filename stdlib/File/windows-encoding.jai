// Internal ownership bridge to the maintained Windows_Utf8 tuple contracts.
#scope_module
Encoding_Utf8 :: #import "Windows_Utf8";
os_utf8_to_wide :: (text: string) -> *u16 {
    if text.count == 0 {
        empty := cast(*u16) alloc(2, temp);
        if empty empty.* = 0;
        return empty;
    }
    source, success, bytes := Encoding_Utf8.utf8_to_wide(text);
    if !success return null;
    defer free(source);
    destination := cast(*u16) alloc(cast(s64) bytes + 2, temp);
    if destination memcpy(destination, source, cast(s64) bytes + 2);
    return destination;
}
os_wide_to_utf8 :: (data: *u16, length: s32 = -1, temporary := true) -> string {
    source, success := Encoding_Utf8.wide_to_utf8(data, length);
    if !success return "";
    if !temporary return source;
    result := copy_temporary_string(source);
    free(source);
    return result;
}
