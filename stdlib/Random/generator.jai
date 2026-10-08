// Explicit-state multiplicative generator, authored without assembly.
Random_State :: struct {
    low: u64;
    high: u64;
}

random_get :: (state: *Random_State) -> u64 #no_aoc {
    // Schoolbook multiplication modulo 2^128 in base 2^16.
    multiplier := u16.[0xe605, 0x56f5, 0x58cd, 0x8664, 0xab32, 0xf4e9, 0x4e3b, 0x0fc9];
    input: [8] u16;
    output: [8] u16;
    for i: 0..3 {
        input[i] = cast,no_check(u16) (state.low >> cast(u64) (i * 16));
        input[i + 4] = cast,no_check(u16) (state.high >> cast(u64) (i * 16));
    }
    carry: u64 = 0;
    for column: 0..7 {
        sum := carry;
        for i: 0..column sum += cast(u64) input[i] * cast(u64) multiplier[column - i];
        output[column] = cast,no_check(u16) sum;
        carry = sum >> 16;
    }
    state.low = 0;
    state.high = 0;
    for i: 0..3 {
        state.low |= (cast(u64) output[i]) << cast(u64) (i * 16);
        state.high |= (cast(u64) output[i + 4]) << cast(u64) (i * 16);
    }
    return state.high;
}

random_seed :: (state: *Random_State, new_seed: u64) {
    state.low = 1;
    state.high = new_seed;
}

random_seed :: (state: *Random_State, new_seed: Random_State) {
    state.* = new_seed;
    state.low |= 1;
}

// The float32 forms use the low 24 bits of a draw.
random_get_zero_to_one :: (state: *Random_State) -> float {
    return cast(float) (random_get(state) & 0xff_ffff) / 16777215.0;
}

random_get_zero_to_one_open :: (state: *Random_State) -> float {
    return cast(float) (random_get(state) & 0xff_ffff) / 16777216.0;
}

random_get_zero_to_one_new :: (state: *Random_State) -> float64 {
    return cast(float64) (random_get(state) >> 11) / 9007199254740991.0;
}

random_get_zero_to_one_open_new :: (state: *Random_State) -> float64 {
    return cast(float64) (random_get(state) >> 11) / 9007199254740992.0;
}

random_get_within_range :: (state: *Random_State, min: float, max: float) -> float {
    fraction := random_get_zero_to_one(state);
    return min + (max - min) * fraction;
}
