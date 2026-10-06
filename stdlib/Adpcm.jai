// Independent IMA/DVI ADPCM decoder for WAVE channel packets.
ADPCM_CHANNELS_MAX :: 9;
Adpcm_Info :: struct {
    nChannels: s32;
    nBlockAlign: s32;
    wSamplesPerBlock: s32;
};
ADPCM_State :: struct {
    sample: s32;
    index: s8;
};

// Standard IMA quantizer step sizes and four-bit index adjustments.
step_table: [89] s32: .[
    7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 19, 21, 23, 25, 28, 31,
    34, 37, 41, 45, 50, 55, 60, 66, 73, 80, 88, 97, 107, 118, 130,
    143, 157, 173, 190, 209, 230, 253, 279, 307, 337, 371, 408, 449,
    494, 544, 598, 658, 724, 796, 876, 963, 1060, 1166, 1282, 1411,
    1552, 1707, 1878, 2066, 2272, 2499, 2749, 3024, 3327, 3660,
    4026, 4428, 4871, 5358, 5894, 6484, 7132, 7845, 8630, 9493,
    10442, 11487, 12635, 13899, 15289, 16818, 18500, 20350, 22385,
    24623, 27086, 29794, 32767
];
index_table: [16] s8: .[-1, -1, -1, -1, 2, 4, 6, 8, -1, -1, -1, -1, 2, 4, 6, 8];

IMA_ADPCM_nibble :: inline (state: *ADPCM_State, nybble: u8) -> s32 {
    if !state return 0;
    if state.index < 0 state.index = 0;
    if state.index > 88 state.index = 88;
    code := nybble & 15;
    step := step_table[state.index];
    change := step / 8;
    if (code & 1) != 0 change += step / 4;
    if (code & 2) != 0 change += step / 2;
    if (code & 4) != 0 change += step;
    if (code & 8) != 0 change = -change;
    next := cast(s64) state.sample + change;
    if next < -32768 next = -32768;
    if next > 32767 next = 32767;
    state.sample = cast(s32) next;
    state.index += index_table[code];
    return state.sample;
}

Fill_IMA_ADPCM_block :: (dest: [] u8, dest_start_index: s32, encoded: [4] u8, channel: s32, numchannels: s32, state: *ADPCM_State) {
    if !state || numchannels <= 0 || channel < 0 || channel >= numchannels || dest_start_index < 0 return;
    last := cast(s64) dest_start_index + channel * 2 + cast(s64) 14 * numchannels + 1;
    if last >= dest.count return;
    output := cast(s64) dest_start_index + channel * 2;
    for i: 0..7 {
        code := encoded[i / 2];
        if (i & 1) != 0 code >>= 4;
        sample := IMA_ADPCM_nibble(state, code & 15);
        dest[output] = cast,trunc(u8) sample;
        dest[output + 1] = cast,trunc(u8) (sample >> 8);
        output += numchannels * 2;
    }
}

IMA_ADPCM_decode :: (info: Adpcm_Info, input_block: [] u8, dest_buffer: [] u8) -> s32 {
    channels := info.nChannels;
    align := info.nBlockAlign;
    if channels <= 0 || channels > ADPCM_CHANNELS_MAX return 0;
    if input_block.count < 0 || dest_buffer.count < 0 || input_block.count > 0x7fff_ffff return 0;
    if input_block.count > 0 && !input_block.data return 0;
    headers := channels * 4;
    if align < headers || (align - headers) % headers != 0 return 0;
    groups := (align - headers) / headers;
    if info.wSamplesPerBlock != 1 + cast(s64) groups * 8 return 0;
    blocks := input_block.count / align;
    tail := input_block.count % align;
    if tail != 0 && tail != headers return 0;
    required := blocks * cast(s64) info.wSamplesPerBlock * channels * 2;
    if tail != 0 required += channels * 2;
    if required > dest_buffer.count || required > 0x7fff_ffff return 0;
    if required > 0 && !dest_buffer.data return 0;
    total_blocks := blocks;
    if tail != 0 total_blocks += 1;
    // Validate all header indices before modifying the destination.
    for b: 0..total_blocks-1 {
        for c: 0..channels-1 {
            if input_block[b * align + c * 4 + 2] > 88 return 0;
        }
    }
    written: s32 = 0;
    states: [ADPCM_CHANNELS_MAX] ADPCM_State;
    for b: 0..total_blocks-1 {
        start := b * align;
        for c: 0..channels-1 {
            p := input_block.data + start + c * 4;
            value := (cast(u16) p[0]) | ((cast(u16) p[1]) << 8);
            states[c].sample = cast,no_check(s16) value;
            states[c].index = cast(s8) p[2];
            dest_buffer[written] = p[0];
            dest_buffer[written + 1] = p[1];
            written += 2;
        }
        if b == blocks break;
        for g: 0..groups-1 {
            for c: 0..channels-1 {
                packet: [4] u8;
                for k: 0..3 packet[k] = input_block[start + headers + (g * channels + c) * 4 + k];
                Fill_IMA_ADPCM_block(dest_buffer, written, packet, c, channels, *states[c]);
            }
            written += channels * 16;
        }
    }
    return written;
}
