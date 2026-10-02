// Independently normalized ABI contract. No reference procedure bodies or binaries.
#scope_export
TEST_K :: 1.0 ;
DELTA_RATE_MAX :: 18.0 * ( 1.0 / 40000.0 ) * TEST_K ;
DELTA_RATE_MIN :: - DELTA_RATE_MAX ;
the_accumulator : [ 48000 ] Audio_Dest_Sample ;
accumulator_element_size :: size_of ( Audio_Dest_Sample ) ;
Audio_Sample_Base :: struct {
    channels : [ MAX_CHANNELS_PER_SOUND ] float ;
}
Fill_Region_Result :: struct {
    buffer0 : string ;
    buffer1 : string ;
}
Audio_Source_Sample :: struct {
    using base : Audio_Sample_Base ;
}
Audio_Dest_Sample :: struct {
    using base : Audio_Sample_Base ;
}
Sound_Data :: struct {
    using resource : struct {
        name : string ;
        full_path : string ;
        loaded := false ;
        skip_load := false ;
    }
    ;
    Kind :: enum {
        UNINITIALIZED ;
        LINEAR_SAMPLE_ARRAY ;
        OGG_COMPRESSED ;
        ADPCM_COMPRESSED ;
    }
    type := Kind . UNINITIALIZED ;
    nsamples_times_nchannels : s64 ;
    nchannels : u16 = 1 ;
    sampling_rate : u32 = 44100 ;
    buffer : string ;
    samples : * s16 ;
    volume_scale : float = 1 ;
    silence_before_repeat : float = 0 ;
    filename_to_stream_from : string ;
    source_directions : [ MAX_CHANNELS_PER_SOUND ] Source_Direction ;
    nBlockAlign : s32 = 0 ;
    wSamplesPerBlock : s32 = 0 ;
}
;
Buffer_Bounds :: struct {
    start , end : s64 ;
    memory : * void ;
}
;
get_buffer_bounds :: ( stream : * Sound_Stream , data : * Sound_Data , index : s64 , result : * Buffer_Bounds ) -> success : bool , no_overflow : bool {
    if !data || !result || index < 0 return false, false;
    if data.type == .LINEAR_SAMPLE_ARRAY {
        result.start = 0;
        result.end = data.nsamples_times_nchannels/data.nchannels;
        result.memory = data.samples;
        return index < result.end, index+1 < result.end;
    }
    if !stream.decoder return false, false;
    found, start, end, memory := find_page_containing_cursor(stream.decoder, index);
    result.* = .{start=start,end=end,memory=memory};
    return found, found && index+1 < end;
}
add :: ( v0 : * Audio_Sample_Base , v1 : * Audio_Sample_Base , nchannels : s64 ) -> Audio_Sample_Base {
    result: Audio_Sample_Base;
    index: s64 = 0;
    while index < nchannels {
        result.channels[index] = v1.channels[index] + v0.channels[index];
        index += 1;
    }
    return result;
}
plus_equals :: ( v0 : * Audio_Sample_Base , v1 : * Audio_Sample_Base , nchannels : s64 ) {
    index: s64 = 0;
    while index < nchannels {
        v0.channels[index] = v0.channels[index] + v1.channels[index];
        index += 1;
    }
}
multiply :: ( v0 : * Audio_Sample_Base , v1 : * Audio_Sample_Base ) -> Audio_Sample_Base {
    product: Audio_Sample_Base;
    index: s64 = 0;
    while index < MAX_CHANNELS_PER_SOUND {
        product.channels[index] = v1.channels[index] * v0.channels[index];
        index += 1;
    }
    return product;
}
multiply :: ( v0 : * Audio_Sample_Base , k : float ) -> Audio_Sample_Base {
    scaled: Audio_Sample_Base;
    index: s64 = 0;
    while index < MAX_CHANNELS_PER_SOUND {
        scaled.channels[index] = k * v0.channels[index];
        index += 1;
    }
    return scaled;
}
multiply :: ( k : float , v0 : * Audio_Sample_Base ) -> Audio_Sample_Base {
    return multiply(v0, k);
}
times_equals :: ( v0 : * Audio_Sample_Base , k : float ) {
    index: s64 = 0;
    while index < MAX_CHANNELS_PER_SOUND {
        v0.channels[index] = k * v0.channels[index];
        index += 1;
    }
}
get_icursor_and_remainder :: ( source_cursor : float64 ) -> icursor : s64 , remainder : float64 {
    integral := cast(s64) source_cursor;
    fractional := source_cursor - cast(float64) integral;
    return integral, fractional;
}
sample_n_channels :: ( stream : * Sound_Stream , samples : * s16 , page_start : s64 , page_end : s64 , source_cursor : float64 , samples_return : [ ] float , no_overflow : bool ) {
    for *value: samples_return value.* = 0;
    if !samples || source_cursor < page_start || source_cursor >= page_end return;
    frame, fraction := get_icursor_and_remainder(source_cursor);
    next := frame+1;
    next_samples := samples;
    next_start := page_start;
    if next >= page_end {
        next = frame;
        if stream.decoder && !no_overflow {
            found, start, _, memory := find_page_containing_cursor(stream.decoder, frame+1);
            if found { next = frame+1; next_samples = cast(*s16) memory; next_start = start; }
        }
    }
    channels := min(cast(s64) stream.num_channels, samples_return.count);
    for channel: 0..channels-1 {
        first := cast(float) samples[(frame-page_start)*stream.num_channels+channel]/32768.0;
        second := cast(float) next_samples[(next-next_start)*stream.num_channels+channel]/32768.0;
        samples_return[channel] = first + cast(float) fraction*(second-first);
    }
}
mix_sample_into_output_streams :: ( stream : * Sound_Stream , source : * Audio_Source_Sample , dest : * Audio_Dest_Sample ) {
    for input: 0..stream.num_channels-1 {
        mapping := *stream.input_scale_mappings[input];
        for output: 0..backend.num_channels-1 {
            gain := mapping.interpolated_source_scale_for_this_output_index[output];
            dest.channels[output] += source.channels[input]*gain;
            desired := mapping.source_scale_for_this_output_index[output];
            delta := mapping.dvolume_dsample[output];
            updated := gain+delta;
            if delta >= 0 updated = min(updated, desired);
            else updated = max(updated, desired);
            mapping.interpolated_source_scale_for_this_output_index[output] = updated;
        }
    }
}
maybe_wrap_play_cursor :: ( stream : * Sound_Stream ) {
    if (stream.user_flags & .REPEATING) == 0 return;
    end := stream.repeat_end_position;
    start := stream.repeat_start_position;
    if end <= start return;
    silence := max(0.0, cast(float64) stream.sound_data.silence_before_repeat * stream.sound_data.sampling_rate);
    if stream.play_cursor >= end {
        excess := stream.play_cursor-cast(float64) end;
        cycle := cast(float64) (end-start)+silence;
        excess -= floor(excess/cycle)*cycle;
        if excess < silence stream.play_cursor = excess-silence;
        else stream.play_cursor = cast(float64) start+excess-silence;
    }
}
catch_up_volumes :: ( stream : * Sound_Stream ) {
    for input: 0..stream.num_channels-1 {
        mapping := *stream.input_scale_mappings[input];
        for output: 0..backend.num_channels-1 {
            mapping.interpolated_source_scale_for_this_output_index[output] = mapping.source_scale_for_this_output_index[output];
            mapping.dvolume_dsample[output] = 0;
        }
    }
}
accumulate_buffer_f :: ( accumulator : * Audio_Dest_Sample , num_samples : s64 , source_cursor : float64 , page : * void , page_start : s64 , page_end : s64 , stream : * Sound_Stream , no_overflow : bool ) -> ( cursor : float64 , samples_written : s64 ) {
    written: s64 = 0;
    result_cursor := source_cursor;
    while written < num_samples && result_cursor >= page_start && result_cursor < page_end {
        sample: Audio_Source_Sample;
        sample_n_channels(stream, cast(*s16) page, page_start, page_end, result_cursor,
            sample.channels, no_overflow);
        mix_sample_into_output_streams(stream, *sample, accumulator+written);
        change := clamp(stream.desired_rate-stream.current_rate, DELTA_RATE_MIN, DELTA_RATE_MAX);
        stream.current_rate += change;
        result_cursor += max(cast(float64) stream.current_rate, 0.000001);
        written += 1;
    }
    return result_cursor, written;
}
accumulate_stream :: ( stream : * Sound_Stream , accumulator : [ ] Audio_Dest_Sample , num_samples : s64 ) -> bool {
    if !stream || !stream.sound_data return false;
    if (stream.user_flags & .PAUSED_DUE_TO_MENU) != 0 return true;
    written: s64 = 0;
    count := min(num_samples, accumulator.count);
    while written < count {
        maybe_wrap_play_cursor(stream);
        start := stream.repeat_start_position;
        if stream.play_cursor < 0 && (stream.user_flags & .REPEATING) != 0 {
            stream.play_cursor += max(cast(float64) stream.current_rate, 0.000001);
            if stream.play_cursor >= 0 stream.play_cursor += stream.repeat_start_position;
            written += 1; continue;
        }
        total := stream.sound_data.nsamples_times_nchannels/stream.sound_data.nchannels;
        if stream.play_cursor >= total return false;
        bounds: Buffer_Bounds;
        valid, no_overflow := get_buffer_bounds(stream, stream.sound_data, cast(s64) stream.play_cursor, *bounds);
        if !valid return true;
        if (stream.user_flags & .REPEATING) != 0 bounds.end = min(bounds.end, stream.repeat_end_position);
        cursor, added := accumulate_buffer_f(accumulator.data+written, count-written, stream.play_cursor,
            bounds.memory, bounds.start, bounds.end, stream, no_overflow);
        if added == 0 return true;
        stream.play_cursor = cursor;
        stream.samples_streamed_since_entity_update += added;
        written += added;
    }
    return true;
}
advance_history_cursor :: ( ) {
    if history_paused return;
    history_subcursor += 1;
    if history_subcursor < max(1, audio_samples_per_history_sample) return;
    history_subcursor = 0;
    history_cursor = (history_cursor+1)%HISTORY_LENGTH;
    history[history_cursor] = .{};
}
fill_sample_buffer :: ( buffer : string ) {
    if !buffer.data || backend.num_channels < 1 return;
    frame_bytes := backend.num_channels*BYTES_PER_SAMPLE;
    assert(buffer.count % frame_bytes == 0);
    frames := buffer.count/frame_bytes;
    output := cast(*s16) buffer.data;
    lock(*sound_mutex);
    defer unlock(*sound_mutex);
    consumed: s64 = 0;
    while consumed < frames {
        amount := min(frames-consumed, the_accumulator.count);
        for frame: 0..amount-1 the_accumulator[frame] = .{};
        stream_index: s64 = 0;
        while stream_index < live_streams.count {
            stream := live_streams[stream_index];
            if !accumulate_stream(stream, the_accumulator, amount) {
                array_unordered_remove_by_index(*live_streams, stream_index); free_stream(stream);
            } else stream_index += 1;
        }
        for frame: 0..amount-1 {
            for channel: 0..backend.num_channels-1 {
                value := clamp(the_accumulator[frame].channels[channel], -1.0, 1.0);
                output[(consumed+frame)*backend.num_channels+channel] = cast(s16) clamp(value*32768.0, -32768.0, 32767.0);
                if update_history && !history_paused {
                    history[history_cursor].low[channel] = min(history[history_cursor].low[channel], value);
                    history[history_cursor].high[channel] = max(history[history_cursor].high[channel], value);
                }
            }
            if update_history advance_history_cursor();
        }
        consumed += amount;
    }
}
update_from_async_thread :: ( actually_async : bool ) {
    if !backend.initted return;
    buffered, minimum := backend_count_buffered_bytes();
    frame_bytes := backend.num_channels*BYTES_PER_SAMPLE;
    desired := max(minimum, cast(s64) (config.seconds_to_fill_ahead*backend.output_sampling_rate)*frame_bytes);
    bytes := max(0, desired-buffered);
    bytes -= bytes%frame_bytes;
    if bytes == 0 return;
    regions, valid := backend_lock_fill_regions(bytes);
    if !valid return;
    if regions.buffer0.count > 0 fill_sample_buffer(regions.buffer0);
    if regions.buffer1.count > 0 fill_sample_buffer(regions.buffer1);
    backend_release_fill_regions(regions);
}
async_audio_update :: ( thread : * Thread ) -> s64 {
    if config.set_async_thread_priority config.set_async_thread_priority();
    while !atomic_read(*async_thread_should_exit) {
        update_from_async_thread(true);
        sleep_milliseconds(2);
    }
    return 0;
}
