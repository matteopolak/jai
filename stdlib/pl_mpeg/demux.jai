// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
#scope_module

Demux :: struct {
	buffer: *Buffer;
	destroy_buffer_when_done := false;
	system_clock_ref: float64;

	last_file_size: s64;

	last_decoded_pts: float64;
	start_time:       float64;
	duration:         float64;

	start_code: Start_Code;

	has_pack_header: bool;
	has_system_header: bool;
	has_headers: bool;

	num_audio_streams: s32;
	num_video_streams: s32;

    current_packet: Packet;
	next_packet:    Packet;
}

demux_create :: (buffer: *Buffer, destroy_when_done: bool) -> *Demux #foreign codec_adapter "jai_stdlib_pl_mpeg_demux_demux_create_1";

demux_destroy :: (demux: *Demux) #foreign codec_adapter "jai_stdlib_pl_mpeg_demux_demux_destroy_1";

demux_has_headers :: (demux: *Demux) -> bool #foreign codec_adapter "jai_stdlib_pl_mpeg_demux_demux_has_headers_1";

demux_get_num_video_streams :: (demux: *Demux) -> s32 #foreign codec_adapter "jai_stdlib_pl_mpeg_demux_demux_get_num_video_streams_1";

demux_get_num_audio_streams :: (demux: *Demux) -> s32 #foreign codec_adapter "jai_stdlib_pl_mpeg_demux_demux_get_num_audio_streams_1";

demux_rewind :: (demux: *Demux) #foreign codec_adapter "jai_stdlib_pl_mpeg_demux_demux_rewind_1";

demux_has_ended :: (demux: *Demux) -> bool #foreign codec_adapter "jai_stdlib_pl_mpeg_demux_demux_has_ended_1";

demux_buffer_seek :: (demux: *Demux, pos: s64) #foreign codec_adapter "jai_stdlib_pl_mpeg_demux_demux_buffer_seek_1";

demux_get_start_time :: (demux: *Demux, type: Start_Code) -> float64 #foreign codec_adapter "jai_stdlib_pl_mpeg_demux_demux_get_start_time_1";

demux_get_duration :: (demux: *Demux, type: Start_Code) -> float64 #foreign codec_adapter "jai_stdlib_pl_mpeg_demux_demux_get_duration_1";

demux_seek :: (demux: *Demux, seek_time: float64, type: Start_Code, force_intra: bool) -> *Packet #foreign codec_adapter "jai_stdlib_pl_mpeg_demux_demux_seek_1";

demux_decode :: (demux: *Demux) -> *Packet #foreign codec_adapter "jai_stdlib_pl_mpeg_demux_demux_decode_1";

demux_decode_time :: (demux: *Demux) -> float64 #foreign codec_adapter "jai_stdlib_pl_mpeg_demux_demux_decode_time_1";

demux_decode_packet :: (demux: *Demux, type: Start_Code) -> *Packet #foreign codec_adapter "jai_stdlib_pl_mpeg_demux_demux_decode_packet_1";

#scope_file

get_packet :: (using demux: *Demux) -> *Packet #foreign codec_adapter "jai_stdlib_pl_mpeg_demux_get_packet_1";

#scope_file
codec_adapter :: #system_library "jai_pl_mpeg_adapter";
