// Independently authored scalar XXH32/64 with byte-at-a-time streaming.
XXH_VERSION_MAJOR :: 0;
XXH_VERSION_MINOR :: 7;
XXH_VERSION_RELEASE :: 0;
XXH_VERSION_NUMBER :: 700;

XXH_versionNumber :: () -> u32 {
    return XXH_VERSION_NUMBER;
}

XXH_PRIME32_1: u32 : 0x9e3779b1;
XXH_PRIME32_2: u32 : 0x85ebca77;
XXH_PRIME32_3: u32 : 0xc2b2ae3d;
XXH_PRIME32_4: u32 : 0x27d4eb2f;
XXH_PRIME32_5: u32 : 0x165667b1;
XXH_PRIME64_1: u64 : 0x9e3779b185ebca87;
XXH_PRIME64_2: u64 : 0xc2b2ae3d27d4eb4f;
XXH_PRIME64_3: u64 : 0x165667b19e3779f9;
XXH_PRIME64_4: u64 : 0x85ebca77c2b2ae63;
XXH_PRIME64_5: u64 : 0x27d4eb2f165667c5;

XXH32_state_t :: struct {
    total_len_32: u32;
    large_len: u32;
    v1: u32;
    v2: u32;
    v3: u32;
    v4: u32;
    mem32: [4] u32;
    memsize: u32;
}

XXH64_state_t :: struct {
    total_len: u64;
    v1: u64;
    v2: u64;
    v3: u64;
    v4: u64;
    mem64: [4] u64;
    memsize: u32;
}

xxh32_rotl :: (x: u32, r: u32) -> u32 {
    return (x << r) | (x >> (32 - r));
}

xxh64_rotl :: (x: u64, r: u64) -> u64 {
    return (x << r) | (x >> (64 - r));
}

xxh32_round :: (acc: u32, input: u32) -> u32 #no_aoc {
    return xxh32_rotl(acc + input * XXH_PRIME32_2, 13) * XXH_PRIME32_1;
}

xxh64_round :: (acc: u64, input: u64) -> u64 #no_aoc {
    return xxh64_rotl(acc + input * XXH_PRIME64_2, 31) * XXH_PRIME64_1;
}

xxh64_mergeRound :: (acc: u64, val: u64) -> u64 #no_aoc {
    return (acc ^ xxh64_round(0, val)) * XXH_PRIME64_1 + XXH_PRIME64_4;
}

read_u32_le :: (ptr: *u8) -> u32 {
    value: u32 = 0;
    index: u32 = 0;
    while index < 4 {
        value |= (cast(u32) ptr[index]) << (index * 8);
        index += 1;
    }
    return value;
}

read_u64_le :: (ptr: *u8) -> u64 {
    value: u64 = 0;
    index: u32 = 0;
    while index < 8 {
        value |= (cast(u64) ptr[index]) << (index * 8);
        index += 1;
    }
    return value;
}

XXH32_reset :: (state: *XXH32_state_t, seed: u32) #no_aoc {
    state.* = .{};
    state.v1 = seed + XXH_PRIME32_1 + XXH_PRIME32_2;
    state.v2 = seed + XXH_PRIME32_2;
    state.v3 = seed;
    state.v4 = seed - XXH_PRIME32_1;
}

XXH32_update :: (state: *XXH32_state_t, input: *void, len: u32) #no_aoc {
    bytes := cast(*u8) input;
    pending := cast(*u8) state.mem32.data;
    index: u32 = 0;
    while index < len {
        pending[state.memsize] = bytes[index];
        state.memsize += 1;
        state.total_len_32 += 1;
        if state.memsize == 16 {
            state.v1 = xxh32_round(state.v1, read_u32_le(pending));
            state.v2 = xxh32_round(state.v2, read_u32_le(pending + 4));
            state.v3 = xxh32_round(state.v3, read_u32_le(pending + 8));
            state.v4 = xxh32_round(state.v4, read_u32_le(pending + 12));
            state.memsize = 0;
            state.large_len = 1;
        }
        index += 1;
    }
}

XXH32_digest :: (state: *XXH32_state_t) -> u32 #no_aoc {
    hash := state.v3 + XXH_PRIME32_5;
    if state.large_len hash = xxh32_rotl(state.v1, 1) + xxh32_rotl(state.v2, 7) + xxh32_rotl(state.v3, 12) + xxh32_rotl(state.v4, 18);
    hash += state.total_len_32;
    bytes := cast(*u8) state.mem32.data;
    offset: u32 = 0;
    while offset + 4 <= state.memsize {
        hash = xxh32_rotl(hash + read_u32_le(bytes + offset) * XXH_PRIME32_3, 17) * XXH_PRIME32_4;
        offset += 4;
    }
    while offset < state.memsize {
        hash = xxh32_rotl(hash + cast(u32) bytes[offset] * XXH_PRIME32_5, 11) * XXH_PRIME32_1;
        offset += 1;
    }
    hash ^= hash >> 15;
    hash *= XXH_PRIME32_2;
    hash ^= hash >> 13;
    hash *= XXH_PRIME32_3;
    return hash ^ (hash >> 16);
}

XXH64_reset :: (state: *XXH64_state_t, seed: u64) #no_aoc {
    state.* = .{};
    state.v1 = seed + XXH_PRIME64_1 + XXH_PRIME64_2;
    state.v2 = seed + XXH_PRIME64_2;
    state.v3 = seed;
    state.v4 = seed - XXH_PRIME64_1;
}

XXH64_update :: (state: *XXH64_state_t, input: *void, len: u32) #no_aoc {
    bytes := cast(*u8) input;
    pending := cast(*u8) state.mem64.data;
    index: u32 = 0;
    while index < len {
        pending[state.memsize] = bytes[index];
        state.memsize += 1;
        state.total_len += 1;
        if state.memsize == 32 {
            state.v1 = xxh64_round(state.v1, read_u64_le(pending));
            state.v2 = xxh64_round(state.v2, read_u64_le(pending + 8));
            state.v3 = xxh64_round(state.v3, read_u64_le(pending + 16));
            state.v4 = xxh64_round(state.v4, read_u64_le(pending + 24));
            state.memsize = 0;
        }
        index += 1;
    }
}

XXH64_digest :: (state: *XXH64_state_t) -> u64 #no_aoc {
    hash := state.v3 + XXH_PRIME64_5;
    if state.total_len >= 32 {
        hash = xxh64_rotl(state.v1, 1) + xxh64_rotl(state.v2, 7) + xxh64_rotl(state.v3, 12) + xxh64_rotl(state.v4, 18);
        hash = xxh64_mergeRound(hash, state.v1);
        hash = xxh64_mergeRound(hash, state.v2);
        hash = xxh64_mergeRound(hash, state.v3);
        hash = xxh64_mergeRound(hash, state.v4);
    }
    hash += state.total_len;
    bytes := cast(*u8) state.mem64.data;
    offset: u32 = 0;
    while offset + 8 <= state.memsize {
        hash = xxh64_rotl(hash ^ xxh64_round(0, read_u64_le(bytes + offset)), 27) * XXH_PRIME64_1 + XXH_PRIME64_4;
        offset += 8;
    }
    if offset + 4 <= state.memsize {
        hash = xxh64_rotl(hash ^ (cast(u64) read_u32_le(bytes + offset) * XXH_PRIME64_1), 23) * XXH_PRIME64_2 + XXH_PRIME64_3;
        offset += 4;
    }
    while offset < state.memsize {
        hash = xxh64_rotl(hash ^ (cast(u64) bytes[offset] * XXH_PRIME64_5), 11) * XXH_PRIME64_1;
        offset += 1;
    }
    hash ^= hash >> 33;
    hash *= XXH_PRIME64_2;
    hash ^= hash >> 29;
    hash *= XXH_PRIME64_3;
    return hash ^ (hash >> 32);
}

native_XXH32 :: (input: *void, len: u32, seed: u32) -> u32 #must {
    state: XXH32_state_t;
    XXH32_reset(*state, seed);
    XXH32_update(*state, cast(*u8) input, len);
    return XXH32_digest(*state);
}

native_XXH64 :: (input: *void, len: u32, seed: u32) -> u64 #must {
    state: XXH64_state_t;
    XXH64_reset(*state, seed);
    XXH64_update(*state, cast(*u8) input, len);
    return XXH64_digest(*state);
}

memcpy_bytes :: (dst: *u8, src: *u8, count: int) {
    index: int = 0;
    while index < count {
        dst[index] = src[index];
        index += 1;
    }
}
