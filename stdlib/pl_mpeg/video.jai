// Independent declaration normalization; see docs/stdlib/native-bindings.md.
Picture_Type :: enum {
    INTRA :: 1;
    PREDICTIVE :: 2;
    B :: 3;
}

Start_Code :: enum u8 {
    SEQUENCE :: 0xB3;
    SLICE_FIRST :: 0x01;
    SLICE_LAST :: 0xAF;
    PICTURE :: 0x00;
    EXTENSION :: 0xB5;
    USER_DATA :: 0xB2;

    PACK :: 0xBA;
    END :: 0xB9;
    SYSTEM :: 0xBB;

    PRIVATE :: 0xBD;
    AUDIO_1 :: 0xC0;
    AUDIO_2 :: 0xC1;
    AUDIO_3 :: 0xC2;
    AUDIO_4 :: 0xC3;
    VIDEO_1 :: 0xE0;

    NOT_FOUND :: 0xFF;
}

IS_SLICE :: (c: Start_Code) -> bool {
    value := cast(u8) c;
    return value >= cast(u8) Start_Code.SLICE_FIRST && value <= cast(u8) Start_Code.SLICE_LAST;
}

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

    start_code: Start_Code;
    picture_type: Picture_Type;

    motion_forward: Video_Motion;
    motion_backward: Video_Motion;

    has_sequence_header := false;

    quantizer_scale: s32;
    slice_begin := false;
    macroblock_address: s32;

    mb_row: s32;
    mb_col: s32;

    macroblock_type: s32;
    macroblock_intra: s32;

    dc_predictor: [3] s32;

    buffer: *Buffer;
    destroy_buffer_when_done: bool;

    frame_current: Frame;
    frame_forward: Frame;
    frame_backward: Frame;

    frames_data: *u8;

    block_data: [64] s32;
    intra_quant_matrix: [64] u8;
    non_intra_quant_matrix: [64] u8;

    has_reference_frame := false;
    assume_no_b_frames := false;
}

clamp :: (n: s32) -> u8 {
    return cast(u8) max(0, min(255, n));
}

video_create_with_buffer :: (buffer: *Buffer, destroy_when_done: bool) -> *Video {
    result := wrap_video(raw_plm_video_create_with_buffer(native_buffer(buffer), 0));
    if result {
        entry := video_state(result);
        entry.own_native = true;
        result.destroy_buffer_when_done = destroy_when_done;
    }
    return result;
}

video_destroy :: (video: *Video) {
    entry := video_state(video);
    assert(entry.own_native, "A borrowed decoder is owned by its parent");
    raw_plm_video_destroy(entry.native);
    if video.destroy_buffer_when_done buffer_destroy(video.buffer);
    forget_video(video);
}

video_get_framerate :: (video: *Video) -> float64 {
    entry := video_state(video);
    push_video(entry);
    result := raw_plm_video_get_framerate(entry.native);
    pull_video(entry);
    return result;
}

video_set_no_delay :: (video: *Video, no_delay: bool) {
    entry := video_state(video);
    push_video(entry);
    raw_plm_video_set_no_delay(entry.native, cast(s32) no_delay);
    pull_video(entry);
}

video_set_time :: (video: *Video, time: float64) {
    entry := video_state(video);
    push_video(entry);
    raw_plm_video_set_time(entry.native, time);
    pull_video(entry);
}

video_rewind :: (video: *Video) {
    entry := video_state(video);
    push_video(entry);
    raw_plm_video_rewind(entry.native);
    pull_video(entry);
}

video_has_ended :: (video: *Video) -> bool {
    entry := video_state(video);
    push_video(entry);
    result := raw_plm_video_has_ended(entry.native);
    pull_video(entry);
    return result != 0;
}

video_decode :: (video: *Video) -> *Frame {
    entry := video_state(video);
    push_video(entry);
    result := raw_plm_video_decode(entry.native);
    pull_video(entry);
    return result;
}

video_has_header :: (video: *Video) -> bool {
    entry := video_state(video);
    push_video(entry);
    result := raw_plm_video_has_header(entry.native);
    pull_video(entry);
    return result != 0;
}

video_decode_sequence_header :: (video: *Video) -> bool {
    entry := video_state(video);
    push_video(entry);
    result := raw_plm_video_decode_sequence_header(entry.native);
    pull_video(entry);
    return result != 0;
}

video_init_frame :: (video: *Video, frame: *Frame, base: *u8) {
    entry := video_state(video);
    push_video(entry);
    raw_plm_video_init_frame(entry.native, frame, base);
    pull_video(entry);
}

video_decode_picture :: (video: *Video) {
    entry := video_state(video);
    push_video(entry);
    raw_plm_video_decode_picture(entry.native);
    pull_video(entry);
}

video_decode_slice :: (video: *Video, slice: Start_Code) {
    entry := video_state(video);
    push_video(entry);
    raw_plm_video_decode_slice(entry.native, cast(s32) slice);
    pull_video(entry);
}

video_decode_macroblock :: (video: *Video) {
    entry := video_state(video);
    push_video(entry);
    raw_plm_video_decode_macroblock(entry.native);
    pull_video(entry);
}

video_decode_motion_vectors :: (video: *Video) {
    entry := video_state(video);
    push_video(entry);
    raw_plm_video_decode_motion_vectors(entry.native);
    pull_video(entry);
}

video_decode_motion_vector :: (video: *Video, r_size: s32, motion: s32) -> s32 {
    entry := video_state(video);
    push_video(entry);
    result := raw_plm_video_decode_motion_vector(entry.native, r_size, motion);
    pull_video(entry);
    return result;
}

video_predict_macroblock :: (using video: *Video) {
    entry := video_state(video);
    push_video(entry);
    raw_plm_video_predict_macroblock(entry.native);
    pull_video(entry);
}

video_copy_macroblock :: (video: *Video, motion_h: s32, motion_v: s32, d: *Frame) {
    entry := video_state(video);
    push_video(entry);
    raw_plm_video_copy_macroblock(entry.native, d, motion_h, motion_v);
    pull_video(entry);
}

video_interpolate_macroblock :: (video: *Video, motion_h: s32, motion_v: s32, d: *Frame) {
    entry := video_state(video);
    push_video(entry);
    raw_plm_video_interpolate_macroblock(entry.native, d, motion_h, motion_v);
    pull_video(entry);
}

// Legacy lexical contract: Code uses the caller's di/si indexes and dest/source pointers.
BLOCK_SET :: (dest: *u8, dest_width: s32, source_width: s32, block_size: s32, code: Code) #expand {
    assert(block_size >= 0 && dest_width >= block_size && source_width >= block_size);
    dest_scan := dest_width - block_size;
    source_scan := source_width - block_size;
    y: s32;
    while y < block_size {
        x: s32;
        while x < block_size {
            #insert code;
            di += 1;
            si += 1;
            x += 1;
        }
        di += dest_scan;
        si += source_scan;
        y += 1;
    }
}

video_process_macroblock :: (video: *Video, d: *u8, s: *u8, motion_h: s32, motion_v: s32, block_size: s32, interpolate: bool) {
    entry := video_state(video);
    push_video(entry);
    raw_plm_video_process_macroblock(entry.native, s, d, motion_h, motion_v, block_size, cast(s32) interpolate);
    pull_video(entry);
}

video_decode_block :: (video: *Video, block: s32) {
    entry := video_state(video);
    push_video(entry);
    raw_plm_video_decode_block(entry.native, block);
    pull_video(entry);
}

video_idct :: (block: *s32) {
    raw_plm_video_idct(block);
}

// Legacy lexical contract: caller supplies frame, y_index, d_index, dest and precomputed r/g/b chroma offsets.
// The luma coefficient comes from the upstream documented BT.601 conversion matrix.
PUT_PIXEL :: (RI: s32, GI: s32, BI: s32, y_offset: s32, dest_offset: s32) #expand {
    sample := cast(float64) frame.y.data[y_index + y_offset];
    luma := cast(s32) floor((sample - 16.0) * 1.16438);
    output_index := d_index + dest_offset;
    dest[output_index + RI] = clamp(luma + r);
    dest[output_index + GI] = clamp(luma + g);
    dest[output_index + BI] = clamp(luma + b);
}

convert_function :: (frame: *Frame, dest: *u8, stride: s32,
                     BYTES_PER_PIXEL: s32, RI: s32, GI: s32, BI: s32) {
    assert(BYTES_PER_PIXEL == 3 || BYTES_PER_PIXEL == 4);
    assert(stride >= frame.width * BYTES_PER_PIXEL);
    if BYTES_PER_PIXEL == 3 {
        if RI == 0 && GI == 1 && BI == 2 raw_plm_frame_to_rgb(frame, dest, stride);
        else if RI == 2 && GI == 1 && BI == 0 raw_plm_frame_to_bgr(frame, dest, stride);
        else assert(false, "Unsupported RGB component ordering");
    } else {
        if RI == 0 && GI == 1 && BI == 2 raw_plm_frame_to_rgba(frame, dest, stride);
        else if RI == 2 && GI == 1 && BI == 0 raw_plm_frame_to_bgra(frame, dest, stride);
        else if RI == 1 && GI == 2 && BI == 3 raw_plm_frame_to_argb(frame, dest, stride);
        else if RI == 3 && GI == 2 && BI == 1 raw_plm_frame_to_abgr(frame, dest, stride);
        else assert(false, "Unsupported four-channel component ordering");
    }
}

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
