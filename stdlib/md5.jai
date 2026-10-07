// RFC 1321 digest. The returned lowercase hexadecimal string is allocator-owned.
md5 :: (input: string) -> string #must {
    if input.count < 0 return "";
    state: [4] u32 = .[0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476];
    block: [64] u8;
    position: s64 = 0;
    while input.count - position >= 64 {
        for i: 0..63 block[i] = input.data[position + i];
        md5_compress(state.data, block);
        position += 64;
    }
    remaining := input.count - position;
    for i: 0..63 block[i] = 0;
    for i: 0..remaining - 1 block[i] = input.data[position + i];
    block[remaining] = 128;
    if remaining >= 56 {
        md5_compress(state.data, block);
        for i: 0..63 block[i] = 0;
    }
    bits := cast(u64) input.count * 8;
    for i: 0..7 block[56 + i] = cast,trunc(u8) (bits >> cast(u64) (i * 8));
    md5_compress(state.data, block);
    output := alloc_string(32);
    if !output.data return "";
    digits :: "0123456789abcdef";
    for i: 0..15 {
        byte := cast,trunc(u8) (state[i / 4] >> cast(u32) ((i % 4) * 8));
        output.data[i * 2] = digits.data[byte >> 4];
        output.data[i * 2 + 1] = digits.data[byte & 15];
    }
    return output;
}

#scope_file
#import "Basic";

md5_rotations :: u32.[7, 12, 17, 22, 5, 9, 14, 20, 4, 11, 16, 23, 6, 10, 15, 21];

// Constants are the specified floor(abs(sin(i + 1)) * 2^32) values.
md5_constants :: u32.[
    0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee, 0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
    0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be, 0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
    0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa, 0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
    0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed, 0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
    0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c, 0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
    0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05, 0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
    0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039, 0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
    0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1, 0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391
];

md5_compress :: (state: *u32, block: [64] u8) {
    words: [16] u32;
    for i: 0..15 {
        p := i * 4;
        words[i] = (cast(u32) block[p]) | ((cast(u32) block[p + 1]) << 8) | ((cast(u32) block[p + 2]) << 16) | ((cast(u32) block[p + 3]) << 24);
    }
    a := state[0];
    b := state[1];
    c := state[2];
    d := state[3];
    for i: 0..63 {
        round := i / 16;
        mix: u32;
        word: s64;
        if round == 0 {
            mix = (b & c) | ((~b) & d);
            word = i;
        } else if round == 1 {
            mix = (d & b) | ((~d) & c);
            word = (i * 5 + 1) % 16;
        } else if round == 2 {
            mix = b ^ c ^ d;
            word = (i * 3 + 5) % 16;
        } else {
            mix = c ^ (b | (~d));
            word = (i * 7) % 16;
        }
        // Use u64 intermediates so overflow is explicitly modulo 2^32.
        value := cast,trunc(u32) (cast(u64) a + mix + md5_constants[i] + words[word]);
        shift := md5_rotations[round * 4 + i % 4];
        rotated := (value << shift) | (value >> (32 - shift));
        a = d;
        d = c;
        c = b;
        b = cast,trunc(u32) (cast(u64) b + rotated);
    }
    state[0] = cast,trunc(u32) (cast(u64) state[0] + a);
    state[1] = cast,trunc(u32) (cast(u64) state[1] + b);
    state[2] = cast,trunc(u32) (cast(u64) state[2] + c);
    state[3] = cast,trunc(u32) (cast(u64) state[3] + d);
}
