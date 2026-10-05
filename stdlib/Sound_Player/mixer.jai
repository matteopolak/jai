// Rendering: the live streams are summed in float, a chunk at a time, and handed to the device as
// interleaved 16-bit frames. The device code calls mix_into on whatever memory it wants filled;
// top_up_output decides how much to ask for. With update_from_a_thread a worker thread keeps the
// device topped up and decodes queued blocks in between.

#scope_module

GAIN_GLIDE_SECONDS :: 0.01;
// Largest change of playback rate per output frame, so pitch changes slide instead of jumping.
RATE_GLIDE_PER_FRAME :: 0.00045;
// Sleep between device top-ups when the worker has nothing to decode.
WORKER_NAP_MS :: 2;
MIN_CURSOR_STEP : float64 : 0.000001;

MIX_CHUNK_FRAMES :: 512;
mix_bus: [MIX_CHUNK_FRAMES * OUTPUT_CHANNELS_MAX] float;

// Fills `out` (player.out_channels values per frame) with the next stretch of the mix. Takes
// player.lock per chunk, so updates on other threads are never held off for long.
mix_into :: (out: [] s16) {
    channels := cast(s64) player.out_channels;
    if channels <= 0 return;
    frames := out.count / channels;
    done := 0;
    while done < frames {
        count := min(frames - done, MIX_CHUNK_FRAMES);
        values := count * channels;
        memset(mix_bus.data, 0, values * size_of(float));

        lock(*player.lock);
        index := 0;
        while index < player.voices.count {
            if render_voice(player.voices[index], mix_bus.data, count) index += 1;
            else remove_voice_at(index);
        }
        unlock(*player.lock);

        dest := out.data + done * channels;
        for 0..values-1 dest[it] = cast(s16) clamp(mix_bus[it] * 32767.0, -32768.0, 32767.0);
        done += count;
    }
}

// Asks the device for enough mixed audio to stay seconds_to_fill_ahead ahead of playback.
top_up_output :: () {
    queued, at_least := output_frames_queued();
    target := max(at_least, cast(s64) (player.config.seconds_to_fill_ahead * player.out_rate));
    if target > queued output_write(target - queued);
}

// Loop region of a stream, clamped to the sound.
loop_region :: (stream: *Sound_Stream) -> start: s64, end: s64 {
    length := stream_length(stream);
    end := stream.repeat_end_position;
    if end <= 0 || end > length end = length;
    start := clamp(stream.repeat_start_position, 0, end);
    return start, end;
}

start_worker :: () -> bool {
    player.worker_quit = false;
    if !init(*player.worker_wake) return false;
    // Set before the thread exists so blocks requested from now on go to its queue.
    player.worker_running = true;
    if thread_init(*player.worker, worker_main) && thread_start(*player.worker) return true;
    player.worker_running = false;
    thread_deinit(*player.worker);
    destroy(*player.worker_wake);
    return false;
}

stop_worker :: () {
    if !player.worker_running return;
    atomic_write(*player.worker_quit, true);
    signal(*player.worker_wake);
    thread_deinit(*player.worker);   // Joins.
    destroy(*player.worker_wake);
    player.worker_running = false;
}

#scope_file

worker_main :: (thread: *Thread) -> s64 {
    if player.config.set_async_thread_priority player.config.set_async_thread_priority();
    while !atomic_read(*player.worker_quit) {
        top_up_output();
        // Keep decoding while there is a backlog; the top-up between blocks keeps the device fed.
        if decode_one_queued_block() continue;
        wait_for(*player.worker_wake, WORKER_NAP_MS);
    }
    return 0;
}

// Adds `frames` frames of one stream to `bus`. Returns false once a non-repeating stream ran off
// its end. Lock held.
render_voice :: (stream: *Sound_Stream, bus: *float, frames: s64) -> bool {
    if stream.user_flags & .PAUSED_DUE_TO_MENU return true;

    outputs  := cast(s64) player.out_channels;
    channels := cast(s64) stream.num_channels;
    length   := stream_length(stream);
    looping  := (stream.user_flags & .REPEATING) != 0;
    loop_start, loop_end := loop_region(stream);
    voice := *stream.voice;

    for frame: 0..frames-1 {
        if looping && loop_end > loop_start && stream.play_cursor >= cast(float64) loop_end wrap_into_loop(stream, loop_start, loop_end);
        if stream.play_cursor < 0 {
            // Leading silence of a repeat; when it runs out, playback resumes at the loop start.
            step_cursor(stream);
            if stream.play_cursor >= 0 stream.play_cursor += cast(float64) loop_start;
            continue;
        }
        if stream.play_cursor >= cast(float64) length return looping && length > 0;

        whole := cast(s64) stream.play_cursor;
        here := frame_at(stream, whole);
        if !here return true;   // Not decoded yet: stay put and silent until it is.

        after := whole + 1;
        if looping && after >= loop_end after = loop_start;
        there := frame_at(stream, after);
        if !there there = here;

        blend := cast(float) (stream.play_cursor - cast(float64) whole);
        mix := bus + frame * outputs;
        for source: 0..channels-1 {
            a := cast(float) here[source];
            value := (a + (cast(float) there[source] - a) * blend) * (1.0 / 32768.0);
            gains := voice.gain.data + source * OUTPUT_CHANNELS_MAX;
            for output: 0..outputs-1 mix[output] += value * gains[output];
        }

        glide_gains(voice, channels, outputs);
        step_cursor(stream);
    }
    return true;
}

wrap_into_loop :: (stream: *Sound_Stream, loop_start: s64, loop_end: s64) {
    data := stream.sound_data;
    pause := cast(float64) max(data.silence_before_repeat, 0.0) * cast(float64) data.sampling_rate;
    period := cast(float64) (loop_end - loop_start) + pause;
    past := stream.play_cursor - cast(float64) loop_end;
    past -= floor(past / period) * period;
    // Negative while the pause lasts; render_voice adds loop_start when it is over.
    resumed := past - pause;
    if resumed >= 0 resumed += cast(float64) loop_start;
    stream.play_cursor = resumed;
}

step_cursor :: (stream: *Sound_Stream) {
    gap := stream.desired_rate - stream.current_rate;
    stream.current_rate += clamp(gap, -RATE_GLIDE_PER_FRAME, RATE_GLIDE_PER_FRAME);
    stream.play_cursor += max(cast(float64) stream.current_rate, MIN_CURSOR_STEP);
}

glide_gains :: (voice: *Voice, channels: s64, outputs: s64) {
    for source: 0..channels-1 {
        base := source * OUTPUT_CHANNELS_MAX;
        for output: 0..outputs-1 {
            slot := base + output;
            slope := voice.slope[slot];
            if slope == 0 continue;
            moved := voice.gain[slot] + slope;
            aim := voice.aim[slot];
            if (slope > 0 && moved >= aim) || (slope < 0 && moved <= aim) {
                moved = aim;
                voice.slope[slot] = 0;
            }
            voice.gain[slot] = moved;
        }
    }
}

// Pointer to the interleaved samples of one source frame, or null if it is not available.
frame_at :: (stream: *Sound_Stream, frame: s64) -> *s16 {
    if frame < 0 return null;
    cache := stream.voice.cache;
    if cache {
        block := block_holding(cache, frame);
        if !block return null;
        return block.pcm + (frame - block.first) * cache.channels;
    }
    data := stream.sound_data;
    if !data.samples || frame >= stream_length(stream) return null;
    return data.samples + frame * data.nchannels;
}
