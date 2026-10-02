// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
BUFFER_DEFAULT_SIZE :: 128 * 1024;

INVALID_TS : float64 : -1.0;

Packet :: struct {
	type:   Start_Code;
	pts:    float64;
    data:   [] u8;
}

Plane :: struct {
    width:  s32;
    height: s32;
    data:   *u8;
}

Frame :: struct {
	time: float64;
	width:  s32;
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

    has_ended:         bool;
    loop:              bool;
    has_decoders:      bool;
    video_enabled   := true;
    video_packet_type: Start_Code;

	video_buffer:  *Buffer;
	video_decoder: *Video;

	audio_enabled   := true;
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

create_with_filename :: (filename: string) -> *Plm #foreign codec_adapter "jai_stdlib_pl_mpeg_module_create_with_filename_1";

create_with_file :: (fh: File, close_when_done: bool) -> *Plm #foreign codec_adapter "jai_stdlib_pl_mpeg_module_create_with_file_1";

create_with_memory :: (memory: [] u8, free_when_done: bool) -> *Plm #foreign codec_adapter "jai_stdlib_pl_mpeg_module_create_with_memory_1";

create_with_buffer :: (buffer: *Buffer, destroy_when_done: bool) -> *Plm #foreign codec_adapter "jai_stdlib_pl_mpeg_module_create_with_buffer_1";

plm_destroy :: (using self: *Plm) #foreign codec_adapter "jai_stdlib_pl_mpeg_module_plm_destroy_1";

has_headers :: (using self: *Plm) -> bool #foreign codec_adapter "jai_stdlib_pl_mpeg_module_has_headers_1";

set_audio_enabled :: (using self: *Plm, enabled: bool) #foreign codec_adapter "jai_stdlib_pl_mpeg_module_set_audio_enabled_1";

set_audio_stream :: (self: *Plm, stream_index: s32) #foreign codec_adapter "jai_stdlib_pl_mpeg_module_set_audio_stream_1";

set_video_enabled :: (using self: *Plm, enabled: bool) #foreign codec_adapter "jai_stdlib_pl_mpeg_module_set_video_enabled_1";

get_num_video_streams :: (self: *Plm) -> s32 #foreign codec_adapter "jai_stdlib_pl_mpeg_module_get_num_video_streams_1";

get_size :: (self: *Plm) -> (width: s32, height: s32) #foreign codec_adapter "jai_stdlib_pl_mpeg_module_get_size_1";

get_framerate :: (self: *Plm) -> float64 #foreign codec_adapter "jai_stdlib_pl_mpeg_module_get_framerate_1";

rewind :: (using self: *Plm) #foreign codec_adapter "jai_stdlib_pl_mpeg_module_rewind_1";

set_loop :: (self: *Plm, loop: bool) #foreign codec_adapter "jai_stdlib_pl_mpeg_module_set_loop_1";

set_video_decode_callback :: (self: *Plm, callback: Video_Decode_Callback, user: *void) #foreign codec_adapter "jai_stdlib_pl_mpeg_module_set_video_decode_callback_1";

set_audio_decode_callback :: (self: *Plm, callback: Audio_Decode_Callback, user: *void) #foreign codec_adapter "jai_stdlib_pl_mpeg_module_set_audio_decode_callback_1";

decode :: (self: *Plm, tick: float64) #foreign codec_adapter "jai_stdlib_pl_mpeg_module_decode_1";

decode_video :: (self: *Plm) -> *Frame #foreign codec_adapter "jai_stdlib_pl_mpeg_module_decode_video_1";

decode_audio :: (self: *Plm) -> *Samples #foreign codec_adapter "jai_stdlib_pl_mpeg_module_decode_audio_1";

handle_end :: (self: *Plm) #foreign codec_adapter "jai_stdlib_pl_mpeg_module_handle_end_1";

read_video_packet :: (buffer: *Buffer, user: *void) #foreign codec_adapter "jai_stdlib_pl_mpeg_module_read_video_packet_1";

read_audio_packet :: (buffer: *Buffer, user: *void) #foreign codec_adapter "jai_stdlib_pl_mpeg_module_read_audio_packet_1";

read_packets :: (self: *Plm, requested_type: Start_Code) #foreign codec_adapter "jai_stdlib_pl_mpeg_module_read_packets_1";

seek_frame :: (self: *Plm, time: float64, seek_exact: bool) -> *Frame #foreign codec_adapter "jai_stdlib_pl_mpeg_module_seek_frame_1";

seek :: (self: *Plm, time: float64, seek_exact: bool) -> bool #foreign codec_adapter "jai_stdlib_pl_mpeg_module_seek_1";

#scope_module

#import "Basic";
#import "File";
#import "Math";

#load "buffer.jai";
#load "audio.jai";
#load "video.jai";
#load "demux.jai";

#scope_file

init_decoders :: (using plm: *Plm) -> bool #foreign codec_adapter "jai_stdlib_pl_mpeg_module_init_decoders_1";

#scope_file
codec_adapter :: #system_library "jai_pl_mpeg_adapter";

#assert size_of(*void) == 8 "This pinned native ABI contract supports 64-bit targets only.";
