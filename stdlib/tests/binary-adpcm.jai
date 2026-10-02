#import "Adpcm";
witness :: () -> bool {
    state: ADPCM_State;
    if IMA_ADPCM_nibble(*state, 7) != 11 || state.index != 8 return false;
    if IMA_ADPCM_nibble(*state, 7) != 41 || state.index != 16 return false;
    state.sample = 32760;
    state.index = 88;
    if IMA_ADPCM_nibble(*state, 7) != 32767 return false;
    if IMA_ADPCM_nibble(*state, 15) != -28669 return false;
    input := u8.[0, 0, 0, 0, 0, 0, 0, 0];
    output: [18] u8;
    info: Adpcm_Info;
    info.nChannels = 1;
    info.nBlockAlign = 8;
    info.wSamplesPerBlock = 9;
    if IMA_ADPCM_decode(info, input, output) != 18 return false;
    for byte: output if byte != 0 return false;
    input[2] = 89;
    output[0] = 123;
    if IMA_ADPCM_decode(info, input, output) != 0 || output[0] != 123 return false;
    return true;
}
#assert(witness());
