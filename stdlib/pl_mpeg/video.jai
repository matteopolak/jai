// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
Picture_Type :: enum {
    INTRA      :: 1;
    PREDICTIVE :: 2;
    B          :: 3;
}

Start_Code :: enum u8 {
    SEQUENCE    :: 0xB3;
    SLICE_FIRST :: 0x01;
    SLICE_LAST  :: 0xAF;
    PICTURE     :: 0x00;
    EXTENSION   :: 0xB5;
    USER_DATA   :: 0xB2;

    PACK   :: 0xBA;
    END    :: 0xB9;
    SYSTEM :: 0xBB;

    PRIVATE :: 0xBD;
    AUDIO_1 :: 0xC0;
    AUDIO_2 :: 0xC1;
    AUDIO_3 :: 0xC2;
    AUDIO_4 :: 0xC3;
    VIDEO_1 :: 0xE0;

    NOT_FOUND :: 0xFF;
}

IS_SLICE :: (c: Start_Code) -> bool #foreign codec_adapter "jai_stdlib_pl_mpeg_video_IS_SLICE_1";

Video_Motion :: struct {
	full_px: s32;
	is_set: s32;
	r_size: s32;
	h: s32;
	v: s32;
}

Video :: struct {
	framerate: float64;
	time: float64;
	frames_decoded: s32;
	width: s32;
	height: s32;
	mb_width: s32;
	mb_height: s32;
	mb_size: s32;

	luma_width: s32;
	luma_height: s32;

	chroma_width: s32;
	chroma_height: s32;

	start_code:   Start_Code;
	picture_type: Picture_Type;

	motion_forward:  Video_Motion;
	motion_backward: Video_Motion;

	has_sequence_header := false;

	quantizer_scale: s32;
	slice_begin := false;
	macroblock_address: s32;

	mb_row: s32;
	mb_col: s32;

	macroblock_type:  s32;
	macroblock_intra: s32;

	dc_predictor: [3] s32;

	buffer: *Buffer;
	destroy_buffer_when_done: bool;

	frame_current:  Frame;
	frame_forward:  Frame;
	frame_backward: Frame;

	frames_data: *u8;

	block_data: [64] s32;
	intra_quant_matrix:     [64] u8;
	non_intra_quant_matrix: [64] u8;

	has_reference_frame := false;
	assume_no_b_frames  := false;
}

clamp :: (n: s32) -> u8 #foreign codec_adapter "jai_stdlib_pl_mpeg_video_clamp_1";

video_create_with_buffer :: (buffer: *Buffer, destroy_when_done: bool) -> *Video #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_create_with_buffer_1";

video_destroy :: (video: *Video) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_destroy_1";

video_get_framerate :: (video: *Video) -> float64 #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_get_framerate_1";

video_set_no_delay :: (video: *Video, no_delay: bool) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_set_no_delay_1";

video_set_time :: (video: *Video, time: float64) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_set_time_1";

video_rewind :: (video: *Video) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_rewind_1";

video_has_ended :: (video: *Video) -> bool #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_has_ended_1";

video_decode :: (video: *Video) -> *Frame #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_decode_1";

video_has_header :: (video: *Video) -> bool #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_has_header_1";

video_decode_sequence_header :: (video: *Video) -> bool #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_decode_sequence_header_1";

video_init_frame :: (video: *Video, frame: *Frame, base: *u8) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_init_frame_1";

video_decode_picture :: (video: *Video) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_decode_picture_1";

video_decode_slice :: (video: *Video, slice: Start_Code) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_decode_slice_1";

video_decode_macroblock :: (video: *Video) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_decode_macroblock_1";

video_decode_motion_vectors :: (video: *Video) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_decode_motion_vectors_1";

video_decode_motion_vector :: (video: *Video, r_size: s32, motion: s32) -> s32 #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_decode_motion_vector_1";

video_predict_macroblock :: (using video: *Video) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_predict_macroblock_1";

video_copy_macroblock :: (video: *Video, motion_h: s32, motion_v: s32, d: *Frame) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_copy_macroblock_1";

video_interpolate_macroblock :: (video: *Video, motion_h: s32, motion_v: s32, d: *Frame) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_interpolate_macroblock_1";

BLOCK_SET :: (dest: *u8, dest_width: s32, source_width: s32, block_size: s32, code: Code) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_BLOCK_SET_1";

video_process_macroblock :: (video: *Video, d: *u8, s: *u8, motion_h: s32, motion_v: s32, block_size: s32, interpolate: bool) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_process_macroblock_1";

video_decode_block :: (video: *Video, block: s32) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_decode_block_1";

video_idct :: (block: *s32) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_video_idct_1";

PUT_PIXEL :: (RI: s32, GI: s32, BI: s32, y_offset: s32, dest_offset: s32) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_PUT_PIXEL_1";

convert_function :: (frame: *Frame, dest: *u8, stride: s32,
                     BYTES_PER_PIXEL: s32, RI: s32, GI: s32, BI: s32) #foreign codec_adapter "jai_stdlib_pl_mpeg_video_convert_function_1";

frame_to_rgb :: (frame: *Frame, dest: *u8, stride: s32) {
    convert_function(frame, dest, stride, 3, 0, 1, 2);
}
frame_to_bgr :: (frame: *Frame, dest: *u8, stride: s32) {
    convert_function(frame, dest, stride, 3, 2, 1, 0);
}
frame_to_rgba :: (frame: *Frame, dest: *u8, stride: s32) {
    convert_function(frame, dest, stride, 4, 0, 1, 2);
}
frame_to_bgra :: (frame: *Frame, dest: *u8, stride: s32) {
    convert_function(frame, dest, stride, 4, 2, 1, 0);
}
frame_to_argb :: (frame: *Frame, dest: *u8, stride: s32) {
    convert_function(frame, dest, stride, 4, 1, 2, 3);
}
frame_to_abgr :: (frame: *Frame, dest: *u8, stride: s32) {
    convert_function(frame, dest, stride, 4, 3, 2, 1);
}

#scope_file
codec_adapter :: #system_library "jai_pl_mpeg_adapter";
