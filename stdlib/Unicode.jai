#scope_file
Basic :: #import "Basic";
#scope_export
#load "Unicode/utf8-core.jai";
character_utf32_to_utf8 :: (ch: u32) -> string {
    out := Basic.alloc_string(4);
    status := character_utf32_to_utf8(ch, *out);
    if status != .CONVERSION_OK { Basic.free(out); return ""; }
    return out;
}
utf8_next_character :: (text: *string) -> u32, Unicode_Result {
    code, consumed, status := character_utf8_to_utf32(text.data, text.count);
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
            it, consumed, status := character_utf8_to_utf32(s.data+index, end-index);
            it_index := index;
            if status != .CONVERSION_OK break;
            #insert body;
        }
    } else {
        cursor := s.*; it_index := 0;
        while cursor.count > 0 {
            it, consumed, status := character_utf8_to_utf32(cursor.data, cursor.count);
            if status != .CONVERSION_OK break;
            #insert body;
            cursor.data += consumed; cursor.count -= consumed; it_index += consumed;
        }
    }
}
