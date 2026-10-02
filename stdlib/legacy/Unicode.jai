#scope_file
Basic :: #import "Basic";
#scope_export
// Pure UTF-8 scalar codec; no allocator or host calls.
Unicode_Result :: enum { CONVERSION_OK; SOURCE_EXHAUSTED; SOURCE_ILLEGAL; }
UNI_REPLACEMENT_CHAR :: 0xFFFD;
UNI_MAX_BMP :: 0xFFFF;
UNI_MAX_UTF16 :: 0x10FFFF;
UNI_MAX_UTF32 :: 0x7FFFFFFF;

decode_utf8_scalar_legacy :: (data: *u8, count: int) -> u32, int, Unicode_Result {
    if count <= 0 return 0, 0, .SOURCE_EXHAUSTED;
    first := data[0]; length := 0; code: u32 = 0; minimum: u32 = 0;
    if first < 0x80 return first, 1, .CONVERSION_OK;
    if first >= 0xC2 && first <= 0xDF { length = 2; code = first & 0x1F; minimum = 0x80; }
    else if first >= 0xE0 && first <= 0xEF { length = 3; code = first & 0x0F; minimum = 0x800; }
    else if first >= 0xF0 && first <= 0xF4 { length = 4; code = first & 0x07; minimum = 0x10000; }
    else return UNI_REPLACEMENT_CHAR, 1, .SOURCE_ILLEGAL;
    if count < length return 0, 0, .SOURCE_EXHAUSTED;
    for i: 1..length-1 {
        byte := data[i];
        if (byte & 0xC0) != 0x80 return UNI_REPLACEMENT_CHAR, 1, .SOURCE_ILLEGAL;
        code = (code << 6) | (byte & 0x3F);
    }
    if code < minimum || code > UNI_MAX_UTF16 || (code >= 0xD800 && code <= 0xDFFF)
        return UNI_REPLACEMENT_CHAR, 1, .SOURCE_ILLEGAL;
    return code, length, .CONVERSION_OK;
}
encode_utf8_scalar_legacy :: (codepoint: u32, out: *string) -> Unicode_Result {
    if codepoint > UNI_MAX_UTF16 || (codepoint >= 0xD800 && codepoint <= 0xDFFF) return .SOURCE_ILLEGAL;
    n := 1;
    if codepoint >= 0x80 n = 2;
    if codepoint >= 0x800 n = 3;
    if codepoint >= 0x10000 n = 4;
    if out.count < n || !out.data return .SOURCE_EXHAUSTED;
    value := codepoint;
    i := n-1;
    while i > 0 { out.data[i] = cast(u8) (0x80 | (value & 0x3F)); value >>= 6; i -= 1; }
    if n == 1 out.data[0] = cast(u8) value;
    else if n == 2 out.data[0] = cast(u8) (0xC0 | value);
    else if n == 3 out.data[0] = cast(u8) (0xE0 | value);
    else out.data[0] = cast(u8) (0xF0 | value);
    out.count = n;
    return .CONVERSION_OK;
}

character_utf32_to_utf8 :: (ch: u32) -> string {
    out := Basic.alloc_string(4);
    status := encode_utf8_scalar_legacy(ch, *out);
    if status != .CONVERSION_OK { Basic.free(out); return ""; }
    return out;
}
utf8_next_character :: (text: *string) -> u32, Unicode_Result {
    code, consumed, status := decode_utf8_scalar_legacy(text.data, text.count);
    if status == .CONVERSION_OK { text.data += consumed; text.count -= consumed; }
    return code, status;
}
unicode_next_character :: (s: *u8) -> *u8 {
    if !s return null;
    length := 1;
    if s[0] >= 0xC2 && s[0] <= 0xDF length = 2;
    else if s[0] >= 0xE0 && s[0] <= 0xEF length = 3;
    else if s[0] >= 0xF0 && s[0] <= 0xF4 length = 4;
    return s + length;
}
utf8_iter :: (s: *string, body: Code, flags: For_Flags) #expand {
    if flags & .REVERSE {
        index := s.count;
        while index > 0 {
            end := index; index -= 1;
            while index > 0 && (s.data[index] & 0xC0) == 0x80 index -= 1;
            it, consumed, status := decode_utf8_scalar_legacy(s.data+index, end-index);
            it_index := index;
            if status != .CONVERSION_OK break;
            #insert body;
        }
    } else {
        cursor := s.*; it_index := 0;
        while cursor.count > 0 {
            it, consumed, status := decode_utf8_scalar_legacy(cursor.data, cursor.count);
            if status != .CONVERSION_OK break;
            #insert body;
            cursor.data += consumed; cursor.count -= consumed; it_index += consumed;
        }
    }
}

character_utf8_to_utf32 :: (s: *u8, source_length: s64, $strict := false) -> u32, s64, Unicode_Result {
    code, consumed, status := decode_utf8_scalar_legacy(s, source_length);
    return code, consumed, status;
}
character_utf32_to_utf8 :: (ch: u32, preallocated_string: *string) {
    status := encode_utf8_scalar_legacy(ch, preallocated_string);
}
