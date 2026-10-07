// Context convenience forms for the explicit-state generator.
#load "Random/generator.jai";

random_get :: () -> u64 {
    return random_get(*context.random_state);
}

random_seed :: (new_seed: u64) {
    random_seed(*context.random_state, new_seed);
}

random_seed :: (new_seed: Random_State) {
    random_seed(*context.random_state, new_seed);
}

random_get_zero_to_one :: () -> float {
    return random_get_zero_to_one(*context.random_state);
}

random_get_zero_to_one_open :: () -> float {
    return random_get_zero_to_one_open(*context.random_state);
}

random_get_zero_to_one_new :: () -> float64 {
    return random_get_zero_to_one_new(*context.random_state);
}

random_get_zero_to_one_open_new :: () -> float64 {
    return random_get_zero_to_one_open_new(*context.random_state);
}

random_get_within_range :: (min: float, max: float) -> float {
    return random_get_within_range(*context.random_state, min, max);
}

#scope_file
RANDRANGE: u32 : 1 << 24;
MASK :: RANDRANGE - 1;
#add_context random_state := Random_State.{ 1, 0 };
