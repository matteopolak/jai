// Pure XSH-RR transition; constants are supplied by module or standalone tests.
random_get :: (state: *u64) -> u32 #no_aoc {
    previous := state.*;
    state.* = previous * PCG_DEFAULT_MULTIPLIER_64 + PCG_DEFAULT_INCREMENT_64;
    shifted := cast,no_check(u32) (((previous >> 18) ^ previous) >> 27);
    rotation := cast(u32) (previous >> 59);
    if rotation == 0 return shifted;
    return (shifted >> rotation) | (shifted << (32 - rotation));
}
