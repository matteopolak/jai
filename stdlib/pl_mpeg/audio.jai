// Independent declaration normalization; see docs/stdlib/native-bindings.md.
FRAME_SYNC :: 0x7ff;

MPEG_2_5 :: 0x0;
MPEG_2 :: 0x2;
MPEG_1 :: 0x3;

LAYER_III :: 0x1;
LAYER_II  :: 0x2;
LAYER_I   :: 0x3;

Audio_Mode :: enum u8 {
    STEREO       :: 0x0;
    JOINT_STEREO :: 0x1;
    DUAL_CHANNEL :: 0x2;
    MONO         :: 0x3;
}

QUANT_LUT_STEP_1 :: ([16]u8).[

	.[ 0,  0,  1,  1,  1,  2,  2,  2,  2,  2,  2,  2,  2,  2, 0, 0 ],

	.[ 0,  0,  0,  0,  0,  0,  1,  1,  1,  2,  2,  2,  2,  2, 0, 0 ]
];

QUANT_TAB_A : u8 : (27 | 64);
QUANT_TAB_B : u8 : (30 | 64);
QUANT_TAB_C : u8 : 8;
QUANT_TAB_D : u8 : 12;

QUANT_LUT_STEP_2 :: ([3] u8).[

	.[ QUANT_TAB_C, QUANT_TAB_C, QUANT_TAB_D ],
	.[ QUANT_TAB_A, QUANT_TAB_A, QUANT_TAB_A ],
	.[ QUANT_TAB_B, QUANT_TAB_A, QUANT_TAB_B ]
];

QUANT_LUT_STEP_3 :: ([32] u8).[

	.[
		0x44,0x44,
		0x34,0x34,0x34,0x34,0x34,0x34,0x34,0x34,0x34,0x34,

        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	],

	.[
		0x43,0x43,0x43,
		0x42,0x42,0x42,0x42,0x42,0x42,0x42,0x42,
		0x31,0x31,0x31,0x31,0x31,0x31,0x31,0x31,0x31,0x31,0x31,0x31,
		0x20,0x20,0x20,0x20,0x20,0x20,0x20,

        0x00, 0x00
	],

	.[
		0x45,0x45,0x45,0x45,
		0x34,0x34,0x34,0x34,0x34,0x34,0x34,
		0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24,
		0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24,
        0x00, 0x00
	]
];

QUANT_LUT_STEP4 :: ([16] u8).[
	.[ 0, 1, 2, 17, 0, 0, 0,  0,  0,  0,  0,  0,  0,  0,  0, 0 ],
	.[ 0, 1, 2,  3, 4, 5, 6, 17,  0,  0,  0,  0,  0,  0,  0, 0 ],
	.[ 0, 1, 2,  3, 4, 5, 6,  7,  8,  9, 10, 11, 12, 13, 14, 17 ],
	.[ 0, 1, 3,  5, 6, 7, 8,  9, 10, 11, 12, 13, 14, 15, 16, 17 ],
	.[ 0, 1, 2,  4, 5, 6, 7,  8,  9, 10, 11, 12, 13, 14, 15, 17 ],
	.[ 0, 1, 2,  3, 4, 5, 6,  7,  8,  9, 10, 11, 12, 13, 14, 15 ]
];

Quantizer_Spec :: struct {
	levels: u16;
	group:  u8;
	bits:   u8;
}

Audio :: struct {
	time: float64;

	samples_decoded: s32;
	samplerate_index: s32;
	bitrate_index: s32;
	version: s32;
	layer: s32;

	mode: Audio_Mode;
	bound: s32;
	v_pos: s32;
	next_frame_data_size: s32;

	has_header := false;

	buffer: *Buffer;
	destroy_buffer_when_done: bool;

    allocation: [2][32] *Quantizer_Spec;

    scale_factor_info: [2][32] u8;

    scale_factor: [2][32][3] s32;
	sample:       [2][32][3] s32;

	samples: Samples;
	D: [1024]    float;
	V: [2][1024] float;
	U: [32]      float;
}

audio_create_with_buffer :: (buffer: *Buffer, destroy_when_done: bool) -> *Audio {
    result := wrap_audio(raw_plm_audio_create_with_buffer(native_buffer(buffer), 0));
    if result {
        entry := audio_state(result);
        entry.own_native = true;
        result.destroy_buffer_when_done = destroy_when_done;
    }
    return result;
}

audio_destroy :: (audio: *Audio) {
    entry := audio_state(audio);
    assert(entry.own_native, "A borrowed decoder is owned by its parent");
    raw_plm_audio_destroy(entry.native);
    if audio.destroy_buffer_when_done buffer_destroy(audio.buffer);
    forget_audio(audio);
}

audio_has_header :: (audio: *Audio) -> bool {
    entry := audio_state(audio);
    push_audio(entry);
    result := raw_plm_audio_has_header(entry.native);
    pull_audio(entry);
    return result != 0;
}

audio_get_samplerate :: (audio: *Audio) -> u16 {
    entry := audio_state(audio);
    push_audio(entry);
    result := raw_plm_audio_get_samplerate(entry.native);
    pull_audio(entry);
    return cast(u16) result;
}

audio_set_time :: (audio: *Audio, time: float64) {
    entry := audio_state(audio);
    push_audio(entry);
    raw_plm_audio_set_time(entry.native, time);
    pull_audio(entry);
}

audio_rewind :: (audio: *Audio) {
    entry := audio_state(audio);
    push_audio(entry);
    raw_plm_audio_rewind(entry.native);
    pull_audio(entry);
}

audio_has_ended :: (audio: *Audio) -> bool {
    entry := audio_state(audio);
    push_audio(entry);
    result := raw_plm_audio_has_ended(entry.native);
    pull_audio(entry);
    return result != 0;
}

audio_decode :: (audio: *Audio) -> *Samples {
    entry := audio_state(audio);
    push_audio(entry);
    result := raw_plm_audio_decode(entry.native);
    pull_audio(entry);
    return result;
}

audio_find_frame_sync :: (audio: *Audio) -> bool {
    entry := audio_state(audio);
    push_audio(entry);
    result := raw_plm_audio_find_frame_sync(entry.native);
    pull_audio(entry);
    return result != 0;
}

audio_decode_header :: (audio: *Audio) -> s32 {
    entry := audio_state(audio);
    push_audio(entry);
    result := raw_plm_audio_decode_header(entry.native);
    pull_audio(entry);
    return result;
}

audio_decode_frame :: (audio: *Audio) {
    entry := audio_state(audio);
    push_audio(entry);
    raw_plm_audio_decode_frame(entry.native);
    pull_audio(entry);
}

audio_read_allocation :: (audio: *Audio, sb: s32, tab3: u8) -> *Quantizer_Spec {
    entry := audio_state(audio);
    push_audio(entry);
    result := raw_plm_audio_read_allocation(entry.native, sb, tab3);
    pull_audio(entry);
    return result;
}

audio_read_samples :: (audio: *Audio, ch: s32, sb: s32, part: s32) {
    entry := audio_state(audio);
    push_audio(entry);
    raw_plm_audio_read_samples(entry.native, ch, sb, part);
    pull_audio(entry);
}

audio_matrix_transform :: (s: [32][3] s32, ss: s32, d: *float, dp: s32) {
    raw_plm_audio_idct36(*s[0], ss, d, dp);
}
