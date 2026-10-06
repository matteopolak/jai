#load "../Unicode/utf8-core.jai";

utf8_scalar_vectors :: () -> bool {
    euro := u8.[0xE2, 0x82, 0xAC];
    code, length, status := character_utf8_to_utf32(euro.data, euro.count);
    if code != 0x20AC || length != 3 || status != .CONVERSION_OK return false;
    emoji := u8.[0xF0, 0x9F, 0x98, 0x80];
    emoji_code, emoji_length, emoji_status := character_utf8_to_utf32(emoji.data, emoji.count);
    if emoji_code != 0x1F600 || emoji_length != 4 || emoji_status != .CONVERSION_OK return false;
    invalid := u8.[0xC0, 0xAF];
    _, _, invalid_status := character_utf8_to_utf32(invalid.data, invalid.count);
    if invalid_status != .SOURCE_ILLEGAL return false;
    surrogate := u8.[0xED, 0xA0, 0x80];
    _, _, surrogate_status := character_utf8_to_utf32(surrogate.data, surrogate.count);
    if surrogate_status != .SOURCE_ILLEGAL return false;
    _, exhausted_length, exhausted_status := character_utf8_to_utf32(emoji.data, 3);
    if exhausted_status != .SOURCE_EXHAUSTED || exhausted_length != 0 return false;
    buffer: [4] u8;
    output: string = .{ count = 4, data = buffer.data };
    encode_status := character_utf32_to_utf8(0x1F600, *output);
    if encode_status != .CONVERSION_OK || output.count != 4 return false;
    for i: 0..3 if output[i] != emoji[i] return false;
    short: string = .{ count = 1, data = buffer.data };
    if character_utf32_to_utf8(0x20AC, *short) != .SOURCE_EXHAUSTED return false;
    if character_utf32_to_utf8(0xD800, *output) != .SOURCE_ILLEGAL return false;
    return true;
}
#assert(utf8_scalar_vectors());
