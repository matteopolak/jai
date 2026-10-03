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

demux_create :: (buffer: *Buffer, destroy_when_done: bool) -> *Demux {
    result := wrap_demux(raw_plm_demux_create(native_buffer(buffer), 0));
    if result {
        entry := demux_state(result);
        entry.own_native = true;
        result.destroy_buffer_when_done = destroy_when_done;
    }
    return result;
}

demux_destroy :: (demux: *Demux) {
    entry := demux_state(demux);
    assert(entry.own_native, "A borrowed decoder is owned by its parent");
    raw_plm_demux_destroy(entry.native);
    if demux.destroy_buffer_when_done buffer_destroy(demux.buffer);
    forget_demux(demux);
}

demux_has_headers :: (demux: *Demux) -> bool {
    entry := demux_state(demux);
    push_demux(entry);
    result := raw_plm_demux_has_headers(entry.native);
    pull_demux(entry);
    return result != 0;
}

demux_get_num_video_streams :: (demux: *Demux) -> s32 {
    entry := demux_state(demux);
    push_demux(entry);
    result := raw_plm_demux_get_num_video_streams(entry.native);
    pull_demux(entry);
    return result;
}

demux_get_num_audio_streams :: (demux: *Demux) -> s32 {
    entry := demux_state(demux);
    push_demux(entry);
    result := raw_plm_demux_get_num_audio_streams(entry.native);
    pull_demux(entry);
    return result;
}

demux_rewind :: (demux: *Demux) {
    entry := demux_state(demux);
    push_demux(entry);
    raw_plm_demux_rewind(entry.native);
    pull_demux(entry);
}

demux_has_ended :: (demux: *Demux) -> bool {
    entry := demux_state(demux);
    push_demux(entry);
    result := raw_plm_demux_has_ended(entry.native);
    pull_demux(entry);
    return result != 0;
}

demux_buffer_seek :: (demux: *Demux, pos: s64) {
    entry := demux_state(demux);
    push_demux(entry);
    raw_plm_demux_buffer_seek(entry.native, cast(u64) pos);
    pull_demux(entry);
}

demux_get_start_time :: (demux: *Demux, type: Start_Code) -> float64 {
    entry := demux_state(demux);
    push_demux(entry);
    result := raw_plm_demux_get_start_time(entry.native, cast(s32) type);
    pull_demux(entry);
    return result;
}

demux_get_duration :: (demux: *Demux, type: Start_Code) -> float64 {
    entry := demux_state(demux);
    push_demux(entry);
    result := raw_plm_demux_get_duration(entry.native, cast(s32) type);
    pull_demux(entry);
    return result;
}

demux_seek :: (demux: *Demux, seek_time: float64, type: Start_Code, force_intra: bool) -> *Packet {
    entry := demux_state(demux);
    push_demux(entry);
    result := raw_plm_demux_seek(entry.native, seek_time, cast(s32) type, cast(s32) force_intra);
    pull_demux(entry);
    return packet_result(demux, result);
}

demux_decode :: (demux: *Demux) -> *Packet {
    entry := demux_state(demux);
    push_demux(entry);
    result := raw_plm_demux_decode(entry.native);
    pull_demux(entry);
    return packet_result(demux, result);
}

demux_decode_time :: (demux: *Demux) -> float64 {
    entry := demux_state(demux);
    push_demux(entry);
    result := raw_plm_demux_decode_time(entry.native);
    pull_demux(entry);
    return result;
}

demux_decode_packet :: (demux: *Demux, type: Start_Code) -> *Packet {
    entry := demux_state(demux);
    push_demux(entry);
    result := raw_plm_demux_decode_packet(entry.native, cast(s32) type);
    pull_demux(entry);
    return packet_result(demux, result);
}

#scope_file

get_packet :: (using demux: *Demux) -> *Packet {
    entry := demux_state(demux);
    push_demux(entry);
    result := raw_plm_demux_get_packet(entry.native);
    pull_demux(entry);
    return packet_result(demux, result);
}
