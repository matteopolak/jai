// Mixes through the offline output (no audio device) and checks levels, panning, looping, stream
// lifetime and the ADPCM block cache, both decoded inline and on the worker thread.
#import "Basic";
#import "Math";
#import "Sound_Player"(OFFLINE = true);

RATE :: 48000;

released: s64;

count_release :: (stream: *Sound_Stream, data: *Sound_Data) {
    released += 1;
}

put_u16 :: (b: *String_Builder, v: s64) {
    append(b, cast(u8) (v & 0xff));
    append(b, cast(u8) ((v >> 8) & 0xff));
}

put_u32 :: (b: *String_Builder, v: s64) {
    put_u16(b, v & 0xffff);
    put_u16(b, (v >> 16) & 0xffff);
}

// A mono 16-bit WAV holding `frames` copies of `value`.
pcm_wav :: (frames: s64, value: s16) -> string {
    b: String_Builder;
    append(*b, "RIFF");
    put_u32(*b, 36 + frames * 2);
    append(*b, "WAVE");
    append(*b, "fmt ");
    put_u32(*b, 16);
    put_u16(*b, 1);
    put_u16(*b, 1);
    put_u32(*b, RATE);
    put_u32(*b, RATE * 2);
    put_u16(*b, 2);
    put_u16(*b, 16);
    append(*b, "data");
    put_u32(*b, frames * 2);
    for 0..frames - 1 put_u16(*b, cast(u16) value);
    return builder_to_string(*b);
}

// A mono IMA ADPCM WAV whose packets all decode to the constant `value` (zero nibbles at step
// index 0 never move the predictor).
adpcm_wav :: (packets: s64, value: s16) -> string, frames_per_packet: s64 {
    GROUPS :: 63;
    align := 4 + GROUPS * 4;
    per_packet := 1 + GROUPS * 8;
    b: String_Builder;
    append(*b, "RIFF");
    put_u32(*b, 4 + 28 + 12 + 8 + packets * align);
    append(*b, "WAVE");
    append(*b, "fmt ");
    put_u32(*b, 20);
    put_u16(*b, 0x11);
    put_u16(*b, 1);
    put_u32(*b, RATE);
    put_u32(*b, RATE * align / per_packet);
    put_u16(*b, align);
    put_u16(*b, 4);
    put_u16(*b, 2);
    put_u16(*b, per_packet);
    append(*b, "fact");
    put_u32(*b, 4);
    put_u32(*b, packets * per_packet);
    append(*b, "data");
    put_u32(*b, packets * align);
    for 0..packets - 1 {
        put_u16(*b, cast(u16) value);
        append(*b, 0);
        append(*b, 0);
        for 0..GROUPS * 4 - 1 append(*b, 0);
    }
    return builder_to_string(*b), per_packet;
}

render :: (frames: s64) -> [] s16 {
    out := NewArray(frames * 2, s16, initialized = false);
    rendered := render_offline(out);
    assert(rendered == frames);
    return out;
}

near :: (a: s16, b: float, slack := 3.0) -> bool {
    return abs(cast(float) a - b) <= slack;
}

main :: () {
    // Loading.
    wav := pcm_wav(1000, 16384);
    data := load_audio_data("constant.wav", wav);
    assert(data.loaded && data.type == .LINEAR_SAMPLE_ARRAY);
    assert(data.nchannels == 1 && data.sampling_rate == RATE && data.nsamples_times_nchannels == 1000);
    assert(data.source_directions[0] == .MONO);
    assert(!load_audio_data("junk", "not a sound").loaded);

    config: Sound_Player_Config;
    config.update_from_a_thread = false;
    config.release_asset = count_release;
    assert(sound_player_init(config));
    assert(get_audio_sampling_rate() == RATE);

    // A centred mono sound lands on both speakers at constant power.
    half_power := 0.5 * 32767.0 * sqrt(0.5);
    stream := make_stream(*data);
    assert(stream != null && stream.repeat_end_position == 1000);
    stream.entity_id = 7;
    start_playing(stream);
    assert(find(7, 0) == stream);
    out := render(600);
    assert(near(out[0], half_power) && near(out[1], half_power));
    assert(near(out[1198], half_power) && near(out[1199], half_power));

    // It runs off its end, is removed, and its asset is released once.
    out = render(600);
    assert(near(out[2 * 399], half_power) && out[2 * 400] == 0 && out[1199] == 0);
    assert(find(7, 0) == null && released == 1);

    // Positional: a source to the listener's left, inside its inner radius, plays only on the left.
    stream = make_stream(*data);
    stream.user_flags |= .SPATIALIZED;
    stream.position = .{ 0, 20, 0 };
    stream.inner_radius = 30;
    stream.outer_radius = 60;
    start_playing(stream);
    out = render(10);
    assert(near(out[0], 0.5 * 32767.0) && near(out[1], 0));

    // Beyond the outer radius it fades out (gains glide for 10 ms, so render past that).
    stream.position = .{ 0, 100, 0 };
    update();
    assert(stream.inaudible);
    out = render(600);
    assert(out[1198] == 0 && out[1199] == 0);
    stop_stream_abruptly(stream.entity_id);
    assert(released == 2);

    // A repeating stream keeps going and its cursor stays inside the sound.
    stream = make_stream(*data, .MUSIC);
    set_repeating(stream, true);
    stream.manager_id = 3;
    start_playing(stream);
    out = render(2500);
    assert(near(out[2 * 2499], half_power));
    assert(stream.play_cursor >= 0 && stream.play_cursor < 1000);
    // Double speed gets through the loop twice as fast.
    stream.rate_scale = 2;
    update();
    assert(stream.desired_rate == 2);
    stop_all_sounds_abruptly(3);
    assert(released == 3);

    // ADPCM goes through the block cache, decoded inline without a worker thread.
    adpcm_bytes, per_packet := adpcm_wav(40, 8000);
    adpcm := load_audio_data("constant-adpcm.wav", adpcm_bytes);
    assert(adpcm.loaded && adpcm.type == .ADPCM_COMPRESSED && adpcm.wSamplesPerBlock == per_packet);
    assert(adpcm.nsamples_times_nchannels == 40 * per_packet);
    expected := 8000.0 / 32768.0 * 32767.0 * sqrt(0.5);
    stream = make_stream(*adpcm);
    assert(stream != null);
    start_playing(stream);
    out = render(3000);
    assert(near(out[0], expected) && near(out[2 * 2999 + 1], expected));
    stop_stream_abruptly(*adpcm);
    assert(released == 4 && count_retired_decoders() == 0);
    sound_player_shutdown();

    // The same with the worker thread decoding: playback holds silent until the first block lands.
    config.update_from_a_thread = true;
    assert(sound_player_init(config));
    stream = make_stream(*adpcm);
    start_playing(stream);
    heard := false;
    for 1..2000 {
        out = render(64);
        if out[0] != 0 {
            heard = near(out[0], expected);
            break;
        }
        sleep_milliseconds(1);
    }
    assert(heard);
    // Shutting down with the stream still playing releases it.
    sound_player_shutdown();
    assert(released == 5);
    print("ok\n");
}
