#import "Basic";
#import "Sound_Player";

main :: () {
    config: Sound_Player_Config;
    config.update_from_a_thread = false;
    set_master_volume(0);

    if !sound_player_init(config) {
        print("native-device-unavailable\nok\n");
        return;
    }

    properties := backend_init(config);

    #if #exists(EXPECTED_CHANNELS) assert(properties.num_channels == EXPECTED_CHANNELS);
    print("native-%-channel-output-opened\n", properties.num_channels);
    // Native output already holds only silence. Pull all nonzero test samples
    // directly into this controlled buffer; never submit them to the device.
    pcm := s16.[24576];
    data: Sound_Data;
    data.loaded = true;
    data.type = .LINEAR_SAMPLE_ARRAY;
    data.nchannels = 1;
    data.samples = pcm.data;
    data.nsamples_times_nchannels = 1;
    set_master_volume(1);
    a := make_stream(*data);
    b := make_stream(*data);

    set_repeating(a, true);
    set_repeating(b, true);
    start_playing(a);
    start_playing(b);
    output: [32] s16;
    bytes: string = .{ properties.num_channels * 2 * 4, cast(*u8) output.data };

    fill_sample_buffer(bytes);

    if properties.num_channels == 2 {
        for i: 0..7 assert(output[i] == 32767, "positive stereo clipping");
    } else {
        for frame: 0..3 assert(output[frame * properties.num_channels + 2] == 32767, "positive center clipping");
    }

    b.user_flags |= .PAUSED_DUE_TO_MENU;
    before := b.play_cursor;

    fill_sample_buffer(bytes);
    assert(b.play_cursor == before);
    if properties.num_channels == 2 assert(output[0] > 17000 && output[0] < 18000);
    else assert(output[2] == 24576);

    b.user_flags &= ~ .PAUSED_DUE_TO_MENU;
    pcm[0] = -24576;
    fill_sample_buffer(bytes);

    if properties.num_channels == 2 {
        for i: 0..7 assert(output[i] == -32768, "negative stereo clipping");
    } else {
        for frame: 0..3 assert(output[frame * properties.num_channels + 2] == -32768, "negative center clipping");
    }

    set_master_volume(0);
    update_panning(a);
    gain_channel := 0;
    if properties.num_channels > 2 gain_channel = 2;

    assert(a.input_scale_mappings[0].dvolume_dsample[gain_channel] < 0, "fade derivative must retain its sign");
    stop_stream_abruptly(*data);
    sound_player_shutdown();
    print("ok\n");
}
