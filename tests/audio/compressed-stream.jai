#import "Basic";
#import "File";
#import "Sound_Player";

released: int;

release :: (stream: *Sound_Stream, data: *Sound_Data) {
    released += 1;
}

main :: () {
    config: Sound_Player_Config;
    config.update_from_a_thread = false;
    config.release_asset = release;
    if !sound_player_init(config) {
        print("native-device-unavailable\nok\n");
        return;
    }

    print("native-device-opened\n");
    set_master_volume(0);
    bytes, ok := read_entire_file("fixtures/tone.ogg");

    assert(ok);
    data := load_audio_data("generated stereo", bytes);

    assert(data.loaded && data.type == .OGG_COMPRESSED && data.buffer.data == bytes.data);
    stream := make_stream(*data);

    assert(stream && stream.decoder && stream.decoder.page_size_in_samples == 8000);
    assert(data.nchannels == 2 && data.nsamples_times_nchannels == 8832);
    start_playing(stream);
    output: [256] s16;

    for i: 0..999 {
        update();
        fill_sample_buffer(.{ size_of(output), cast(*u8) output.data });
        if stream.play_cursor > 0 break;
        sleep_milliseconds(1);
    }

    assert(stream.play_cursor > 0 && !(stream.internal_flags & .WAITING_FOR_INITIAL_DECODER_PAGES));
    for sample: output assert(sample == 0, "native smoke playback must remain muted");

    stop_stream_abruptly(*data);
    assert(released == 1 && count_retired_decoders() == 0);
    sound_player_shutdown();
    free(bytes);
    print("ok\n");
}
