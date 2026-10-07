// Base64 and base64url encode/decode; base64_decode takes an optional 256-entry decoder table.
#scope_file
Basic :: #import "Basic";

#scope_export
BASE64_ENCODER_TABLE :: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
BASE64URL_ENCODER_TABLE :: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";
BASE64_ALPHABET :: BASE64_ENCODER_TABLE;
BASE64URL_ALPHABET :: BASE64URL_ENCODER_TABLE;
WHITESPACE :: 64;
EQUALS :: 65;
INVALID :: 66;

base64_encode :: (input: string, table: string = BASE64_ENCODER_TABLE, pad := true) -> string #must {
    return base64_encode_with_alphabet(input, table, pad);
}

base64url_encode :: (input: string) -> string {
    return base64_encode_with_alphabet(input, BASE64URL_ALPHABET, false);
}

base64_encode_with_alphabet :: (input: string, alphabet: string, padding: bool) -> string {
    if alphabet.count != 64 return "";
    for i: 0..63 for j : 0..i - 1 if alphabet[i] == alphabet[j] return "";
    builder: Basic.String_Builder;
    i := 0;
    while i < input.count {
        a := input[i];
        b: u8 = 0;
        c: u8 = 0;
        left := input.count - i;
        if left > 1 b = input[i + 1];
        if left > 2 c = input[i + 2];
        Basic.append(*builder, alphabet[a >> 2]);
        Basic.append(*builder, alphabet[((a & 3) << 4) | (b >> 4)]);
        if left > 1 Basic.append(*builder, alphabet[((b & 15) << 2) | (c >> 6)]);
        else if padding Basic.append(*builder, cast(u8) 61);
        if left > 2 Basic.append(*builder, alphabet[c & 63]);
        else if padding Basic.append(*builder, cast(u8) 61);
        i += 3;
    }
    if builder.failed {
        Basic.reset(*builder);
        return "";
    }
    return Basic.builder_to_string(*builder);
}

base64_index_of :: (c: u8, alphabet: string) -> int, bool {
    for i: 0..alphabet.count - 1 if alphabet[i] == c return i, true;
    return -1, false;
}

base64_decode_with_alphabet :: (text: string, alphabet: string) -> string, bool {
    if alphabet.count != 64 return "", false;
    table: [256] u8;
    for *item: table item.* = INVALID;
    for i: 0..63 {
        if table[alphabet[i]] != INVALID return "", false;
        table[alphabet[i]] = cast(u8) i;
    }
    table[9] = WHITESPACE;
    table[10] = WHITESPACE;
    table[13] = WHITESPACE;
    table[32] = WHITESPACE;
    table[61] = EQUALS;
    return base64_decode(text, table);
}

base64_decode :: (input: string, table: [256] u8 = BASE64_DECODER_TABLE) -> string #must, success: bool {
    builder: Basic.String_Builder;
    bits: u32 = 0;
    bit_count := 0;
    symbols := 0;
    padding := 0;
    ended := false;
    for c: input {
        value := table[c];
        if value == WHITESPACE continue;
        if value == EQUALS {
            ended = true;
            padding += 1;
            if padding > 2 {
                Basic.reset(*builder);
                return "", false;
            }
            continue;
        }
        if value >= 64 || ended {
            Basic.reset(*builder);
            return "", false;
        }
        bits = (bits << 6) | value;
        bit_count += 6;
        symbols += 1;
        if bit_count >= 8 {
            bit_count -= 8;
            Basic.append(*builder, cast(u8) ((bits >> bit_count) & 255));
            bits &= (1 << bit_count) - 1;
        }
    }
    remainder := symbols % 4;
    if remainder == 1 || bits != 0 || (padding > 0 && (symbols + padding) % 4 != 0)
        || (padding == 1 && remainder != 3) || (padding == 2 && remainder != 2) {
        Basic.reset(*builder);
        return "", false;
    }
    if builder.failed {
        Basic.reset(*builder);
        return "", false;
    }
    return Basic.builder_to_string(*builder), true;
}

base64url_decode :: (input: string) -> string, success: bool {
    return base64_decode(input, BASE64URL_DECODER_TABLE);
}

test_base64_module :: () {
    encoded := base64_encode("foobar");
    Basic.assert(encoded == "Zm9vYmFy");
    decoded, ok := base64_decode(encoded);
    Basic.assert(ok && decoded == "foobar");
    Basic.free(encoded);
    Basic.free(decoded);
}

BASE64_DECODER_TABLE :: u8.[
    66, 66, 66, 66, 66, 66, 66, 66, 66, 64, 64, 66, 66, 64, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    64, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 62, 66, 66, 66, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 66, 66, 66, 65, 66, 66,
    66, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 66, 66, 66, 66, 66,
    66, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
];

BASE64URL_DECODER_TABLE :: u8.[
    66, 66, 66, 66, 66, 66, 66, 66, 66, 64, 64, 66, 66, 64, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    64, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 62, 66, 66,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 66, 66, 66, 65, 66, 66,
    66, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 66, 66, 66, 66, 63,
    66, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
];
