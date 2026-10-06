// Independent declaration normalization; see docs/stdlib/native-bindings.md.
BUFFER_DEFAULT_SIZE :: 128 * 1024;

INVALID_TS: float64 : -1.0;

Packet :: struct {
    type: Start_Code;
    pts: float64;
    data: [] u8;
}

Plane :: struct {
    width: s32;
    height: s32;
    data: *u8;
}

Frame :: struct {
    time: float64;
    width: s32;
    height: s32;

    y, cr, cb: Plane;
}

Video_Decode_Callback :: #type (self: *Plm, frame: *Frame, user: *void);

SAMPLES_PER_FRAME :: 1152;

Samples :: struct {
    time: float64;
    count: u32;

    interleaved: [SAMPLES_PER_FRAME * 2] float;

}

Audio_Decode_Callback :: #type (plm: *Plm, samples: *Samples, user: *void);

Buffer_Load_Callback :: #type (buffer: *Buffer, user: *void);

Plm :: struct {
    demux: *Demux;
    time: float64;

    has_ended: bool;
    loop: bool;
    has_decoders: bool;
    video_enabled := true;
    video_packet_type: Start_Code;

    video_buffer: *Buffer;
    video_decoder: *Video;

    audio_enabled := true;
    audio_stream_index: s32;
    audio_packet_type: Start_Code;

    audio_lead_time: float64;
    audio_buffer: *Buffer;
    audio_decoder: *Audio;

    video_decode_callback: Video_Decode_Callback;
    video_decode_callback_user_data: *void;

    audio_decode_callback: Audio_Decode_Callback;
    audio_decode_callback_user_data: *void;
}

create_with_filename :: (filename: string) -> *Plm {
    buffer := buffer_create_with_filename(filename);
    if !buffer return null;
    result := create_with_buffer(buffer, true);
    if !result buffer_destroy(buffer);
    return result;
}

create_with_file :: (fh: File, close_when_done: bool) -> *Plm {
    buffer := buffer_create_with_file(fh, close_when_done);
    if !buffer return null;
    result := create_with_buffer(buffer, true);
    if !result buffer_destroy(buffer);
    return result;
}

create_with_memory :: (memory: [] u8, free_when_done: bool) -> *Plm {
    buffer := buffer_create_with_memory(memory, free_when_done);
    if !buffer return null;
    result := create_with_buffer(buffer, true);
    if !result buffer_destroy(buffer);
    return result;
}

create_with_buffer :: (buffer: *Buffer, destroy_when_done: bool) -> *Plm {
    native := raw_plm_create_with_buffer(native_buffer(buffer), 0);
    result := wrap_plm(native, native);
    if result {
        entry := plm_state(result);
        entry.own_native = true;
        entry.root_buffer = buffer;
        entry.release_root = destroy_when_done;
    }
    return result;
}

plm_destroy :: (using self: *Plm) {
    entry := plm_state(self);
    assert(entry.own_native);
    raw_plm_destroy(entry.native);
    release_owned_shadows(entry.native);
    if entry.release_root buffer_destroy(entry.root_buffer);
    forget_plm(self);
}

has_headers :: (using self: *Plm) -> bool {
    entry := plm_state(self);
    push_plm(entry);
    result := raw_plm_has_headers(entry.native);
    pull_plm(entry);
    return result != 0;
}

set_audio_enabled :: (using self: *Plm, enabled: bool) {
    entry := plm_state(self);
    push_plm(entry);
    raw_plm_set_audio_enabled(entry.native, cast(s32) enabled);
    pull_plm(entry);
}

set_audio_stream :: (self: *Plm, stream_index: s32) {
    entry := plm_state(self);
    push_plm(entry);
    raw_plm_set_audio_stream(entry.native, stream_index);
    pull_plm(entry);
}

set_video_enabled :: (using self: *Plm, enabled: bool) {
    entry := plm_state(self);
    push_plm(entry);
    raw_plm_set_video_enabled(entry.native, cast(s32) enabled);
    pull_plm(entry);
}

get_num_video_streams :: (self: *Plm) -> s32 {
    entry := plm_state(self);
    push_plm(entry);
    result := raw_plm_get_num_video_streams(entry.native);
    pull_plm(entry);
    return result;
}

get_size :: (self: *Plm) -> (width: s32, height: s32) {
    entry := plm_state(self);
    push_plm(entry);
    width := raw_plm_get_width(entry.native);
    height := raw_plm_get_height(entry.native);
    pull_plm(entry);
    return width, height;
}

get_framerate :: (self: *Plm) -> float64 {
    entry := plm_state(self);
    push_plm(entry);
    result := raw_plm_get_framerate(entry.native);
    pull_plm(entry);
    return result;
}

rewind :: (using self: *Plm) {
    entry := plm_state(self);
    push_plm(entry);
    raw_plm_rewind(entry.native);
    pull_plm(entry);
}

set_loop :: (self: *Plm, loop: bool) {
    entry := plm_state(self);
    push_plm(entry);
    raw_plm_set_loop(entry.native, cast(s32) loop);
    pull_plm(entry);
}

set_video_decode_callback :: (self: *Plm, callback: Video_Decode_Callback, user: *void) {
    entry := plm_state(self);
    entry.callback_context = context;
    self.video_decode_callback = callback;
    self.video_decode_callback_user_data = user;
    if callback raw_plm_set_video_decode_callback(entry.native, native_video_callback, entry);
    else raw_plm_set_video_decode_callback(entry.native, null, null);
}

set_audio_decode_callback :: (self: *Plm, callback: Audio_Decode_Callback, user: *void) {
    entry := plm_state(self);
    entry.callback_context = context;
    self.audio_decode_callback = callback;
    self.audio_decode_callback_user_data = user;
    if callback raw_plm_set_audio_decode_callback(entry.native, native_audio_callback, entry);
    else raw_plm_set_audio_decode_callback(entry.native, null, null);
}

decode :: (self: *Plm, tick: float64) {
    entry := plm_state(self);
    push_plm(entry);
    raw_plm_decode(entry.native, tick);
    pull_plm(entry);
}

decode_video :: (self: *Plm) -> *Frame {
    entry := plm_state(self);
    push_plm(entry);
    result := raw_plm_decode_video(entry.native);
    pull_plm(entry);
    return result;
}

decode_audio :: (self: *Plm) -> *Samples {
    entry := plm_state(self);
    push_plm(entry);
    result := raw_plm_decode_audio(entry.native);
    pull_plm(entry);
    return result;
}

handle_end :: (self: *Plm) {
    entry := plm_state(self);
    push_plm(entry);
    raw_plm_handle_end(entry.native);
    pull_plm(entry);
}

read_video_packet :: (buffer: *Buffer, user: *void) {
    entry := buffer_state(buffer);
    push_buffer(entry);
    raw_plm_read_video_packet(entry.native, native_plm(cast(*Plm) user));
    pull_buffer(entry);
}

read_audio_packet :: (buffer: *Buffer, user: *void) {
    entry := buffer_state(buffer);
    push_buffer(entry);
    raw_plm_read_audio_packet(entry.native, native_plm(cast(*Plm) user));
    pull_buffer(entry);
}

read_packets :: (self: *Plm, requested_type: Start_Code) {
    entry := plm_state(self);
    push_plm(entry);
    raw_plm_read_packets(entry.native, cast(s32) requested_type);
    pull_plm(entry);
}

seek_frame :: (self: *Plm, time: float64, seek_exact: bool) -> *Frame {
    entry := plm_state(self);
    push_plm(entry);
    result := raw_plm_seek_frame(entry.native, time, cast(s32) seek_exact);
    pull_plm(entry);
    return result;
}

seek :: (self: *Plm, time: float64, seek_exact: bool) -> bool {
    entry := plm_state(self);
    push_plm(entry);
    result := raw_plm_seek(entry.native, time, cast(s32) seek_exact);
    pull_plm(entry);
    return result != 0;
}

#scope_module

#import "Basic";
#import "File";
#import "Math";

#load "buffer.jai";
#load "audio.jai";
#load "video.jai";
#load "demux.jai";

#scope_file

init_decoders :: (using plm: *Plm) -> bool {
    entry := plm_state(plm);
    push_plm(entry);
    result := raw_plm_init_decoders(entry.native);
    pull_plm(entry);
    return result != 0;
}


#assert size_of(*void) == 8 "This pinned native ABI contract supports 64-bit targets only.";

#scope_module
#load "native.jai";
