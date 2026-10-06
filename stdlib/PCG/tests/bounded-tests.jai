#import "PCG";
pcg_bound_cases :: () -> bool {
    state: u64;
    random_seed(*state, 42);
    saved := state;
    first := random_get(*state);
    state = saved;
    if random_get(*state) != first return false;
    for 0..31 {
        if random_get_within_bound(*state, 1) != 0 return false;
        if random_get_within_bound(*state, 10) >= 10 return false;
        if random_get_within_bound2(*state, 17) >= 17 return false;
        fraction := random_get_zero_to_one(*state);
        if fraction < 0 || fraction >= 1 return false;
        ranged := random_get_within_range(*state, -5, 3);
        if ranged < -5 || ranged > 3 return false;
    }
    random_seed(42);
    first_default := random_get();
    random_seed(42);
    if random_get() != first_default return false;
    return true;
}
#assert #run pcg_bound_cases();
