// PCG XSH-RR 64/32 transition and unbiased bounded sampling.
PCG_DEFAULT_MULTIPLIER_64 :: 6364136223846793005;
PCG_DEFAULT_INCREMENT_64 :: 1442695040888963407;
pcg32_state: u64 = PCG_DEFAULT_INCREMENT_64;

#load "PCG/transition.jai";

random_get :: () -> u32 {
    return random_get(*pcg32_state);
}

random_get_within_bound :: (state: *u64, range: u32) -> u32 {
    if range == 0 {
        #asm { int3; }
    }
    threshold := cast(u32) (((cast(u64) 1) << 32) % range);
    candidate := random_get(state);
    while candidate < threshold candidate = random_get(state);
    return candidate % range;
}

random_get_within_bound2 :: (state: *u64, range: u32) -> u32 {
    return random_get_within_bound(state, range);
}

random_get_within_bound :: (bound: u32) -> u32 {
    return random_get_within_bound(*pcg32_state, bound);
}

random_get_zero_to_one :: (state: *u64) -> float {
    return cast(float) (random_get(state) >> 8) / 16777216.0;
}

random_get_zero_to_one :: () -> float {
    return random_get_zero_to_one(*pcg32_state);
}

random_get_within_range :: (state: *u64, min: float, max: float) -> float {
    fraction := random_get_zero_to_one(state);
    return min * (1 - fraction) + max * fraction;
}

random_get_within_range :: (min: float, max: float) -> float {
    return random_get_within_range(*pcg32_state, min, max);
}

random_seed :: (state: *u64, new_seed: u32) {
    state.* = 0;
    random_get(state);
    state.* += new_seed;
    random_get(state);
}

random_seed :: (new_seed: u32) {
    random_seed(*pcg32_state, new_seed);
}

#scope_file
neg :: (x: u32) -> u32 #no_aoc {
    return ~x + 1;
}
