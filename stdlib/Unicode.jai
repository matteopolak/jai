#scope_file
Basic :: #import "Basic";
#scope_export
#load "Unicode/utf8-core.jai";

character_utf32_to_utf8 :: (ch: u32) -> string {
    out := Basic.alloc_string(4);
    status := character_utf32_to_utf8(ch, *out);
    if status != .CONVERSION_OK {
        Basic.free(out);
        return "";
    }
    return out;
}

utf8_next_character :: (s: *string) -> code: u32, success: Unicode_Result {
    text := s;
    code, consumed, status := character_utf8_to_utf32(text.data, text.count);
    if status == .CONVERSION_OK {
        text.data += consumed;
        text.count -= consumed;
    }
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
    `it: u32;
    `it_index: s64;
    if flags & .REVERSE {
        // it_index is not tracked backwards.
        `it_index = -1;
        index := s.count;
        while index > 0 {
            end := index;
            index -= 1;
            while index > 0 && (s.data[index] & 0xC0) == 0x80 index -= 1;
            code, consumed, status := character_utf8_to_utf32(s.data + index, end - index);
            if status != .CONVERSION_OK break;
            `it = code;
            #insert body;
        }
    } else {
        cursor := s.*;
        `it_index = 0;
        while cursor.count > 0 {
            code, consumed, status := character_utf8_to_utf32(cursor.data, cursor.count);
            if status != .CONVERSION_OK break;
            `it = code;
            #insert body;
            cursor.data += consumed;
            cursor.count -= consumed;
            `it_index += 1;
        }
    }
}

// Classic UTF-8 decoding tables (the ConvertUTF names), exported for callers that
// decode by hand. Continuation-byte count for each leading byte:
trailingBytesForUTF8 :: #run -> [256] u8 {
    table: [256] u8;
    for 0..255 {
        if it >= 0xFC table[it] = 5;
        else if it >= 0xF8 table[it] = 4;
        else if it >= 0xF0 table[it] = 3;
        else if it >= 0xE0 table[it] = 2;
        else if it >= 0xC0 table[it] = 1;
    }
    return table;
};

// Payload bits of a leading byte, by continuation-byte count.
utf8_inital_byte_mask :: u8.[0x7F, 0x1F, 0x0F, 0x07, 0x03, 0x01];
// Marker bits subtracted after accumulating 6 bits per byte, by continuation-byte count.
offsetsFromUTF8: [6] u32 : .[0x0, 0x3080, 0xE2080, 0x3C82080, 0xFA082080, 0x82082080];
// Leading-byte marker for an encoding of N bytes.
firstByteMark: [7] u8 : .[0x00, 0x00, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC];
