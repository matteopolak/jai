#load "../generator.jai";
#load "../../PCG/transition.jai";
PCG_DEFAULT_MULTIPLIER_64 :: 6364136223846793005;
PCG_DEFAULT_INCREMENT_64 :: 1442695040888963407;
random_sequence_cases :: () -> bool {
    state: Random_State;
    random_seed(*state,42);
    if random_get(*state)!=2035591762260617220 return false;
    if random_get(*state)!=11122429259955245428 return false;
    if random_get(*state)!=3597186161380831872 return false;
    if random_get(*state)!=4063032141588118201 return false;
    saved:=state;
    first:=random_get(*state);
    random_seed(*state,saved);
    if random_get(*state)!=first return false;
    for 0..15 {
        closed:=random_get_zero_to_one(*state);
        opened:=random_get_zero_to_one_open(*state);
        if closed<0 || closed>1 || opened<0 || opened>=1 return false;
        wide:=random_get_zero_to_one_open_new(*state);
        if wide<0 || wide>=1 return false;
    }
    pcg_state: u64=42;
    if random_get(*pcg_state)!=0 return false;
    if random_get(*pcg_state)!=1971522493 return false;
    if random_get(*pcg_state)!=242089394 return false;
    if random_get(*pcg_state)!=3457789919 return false;
    return true;
}
#assert #run random_sequence_cases();
