// Independently normalized ABI contract. No reference procedure bodies or binaries.
load_audio_file :: ( filename : string , optional := false ) -> Sound_Data {
    bytes, read_ok := read_entire_file(filename, log_errors = !optional);
    if !read_ok return .{};
    defer free(bytes);
    result := load_audio_data(filename, bytes);
    result.full_path = copy_string(filename);
    return result;
}
load_audio_data :: ( name_for_error_reporting : string , data : string ) -> Sound_Data {
    result: Sound_Data;
    result.name = copy_string(name_for_error_reporting);
    if data.count < 4 return result;
    owned := copy_string(data);
    if !owned.data return result;
    magic := get_magic4(owned, 0);
    if magic == 0x46464952 {
        format, samples, valid, extra := get_waveformatex_header(owned);
        if !valid || format.nChannels < 1 || format.nChannels > MAX_CHANNELS_PER_SOUND || format.nSamplesPerSec <= 0 {
            free(owned); return result;
        }
        result.nchannels = cast(u16) format.nChannels;
        result.sampling_rate = cast(u32) format.nSamplesPerSec;
        if format.wFormatTag == WAVE_FORMAT_PCM {
            if format.wBitsPerSample != 16 || samples.count % (2*format.nChannels) != 0 { free(owned); return result; }
            result.type = .LINEAR_SAMPLE_ARRAY;
            result.nsamples_times_nchannels = samples.count / 2;
        } else if format.wFormatTag == WAVE_FORMAT_DVI_ADPCM {
            if format.nBlockAlign <= 0 || extra.wSamplesPerBlock <= 0 { free(owned); return result; }
            result.type = .ADPCM_COMPRESSED;
            result.nBlockAlign = format.nBlockAlign;
            result.wSamplesPerBlock = extra.wSamplesPerBlock;
            frames := (samples.count / format.nBlockAlign) * extra.wSamplesPerBlock;
            if extra.wSamplesAccordingToFactChunk > 0 frames = min(frames, cast(s64) extra.wSamplesAccordingToFactChunk);
            result.nsamples_times_nchannels = frames * result.nchannels;
        } else { free(owned); return result; }
        result.samples = cast(*s16) samples.data;
    } else if magic == 0x5367674f {
        frames, channels, rate := get_compressed_rate_channels_and_size(owned);
        if frames <= 0 || channels < 1 || channels > MAX_CHANNELS_PER_SOUND || rate <= 0 { free(owned); return result; }
        result.type = .OGG_COMPRESSED;
        result.nchannels = cast(u16) channels;
        result.sampling_rate = cast(u32) rate;
        result.nsamples_times_nchannels = frames * channels;
    } else { free(owned); return result; }
    result.buffer = owned;
    result.loaded = true;
    if result.nchannels == 1 result.source_directions[0] = .MONO;
    else {
        result.source_directions[0] = .FRONT_LEFT;
        result.source_directions[1] = .FRONT_RIGHT;
        if result.nchannels > 2 result.source_directions[2] = .CENTER_FORWARD;
        if result.nchannels > 3 result.source_directions[3] = .SUBWOOFER_CENTER_FORWARD;
        if result.nchannels > 4 result.source_directions[4] = .REAR_LEFT;
        if result.nchannels > 5 result.source_directions[5] = .REAR_RIGHT;
        if result.nchannels > 6 result.source_directions[6] = .EXTEND_LEFT;
        if result.nchannels > 7 result.source_directions[7] = .EXTEND_RIGHT;
        if result.nchannels == 4 { result.source_directions[2] = .REAR_LEFT; result.source_directions[3] = .REAR_RIGHT; }
        if result.nchannels == 5 { result.source_directions[3] = .REAR_LEFT; result.source_directions[4] = .REAR_RIGHT; }
        if result.type == .OGG_COMPRESSED {
            if result.nchannels == 3 || result.nchannels >= 5 {
                result.source_directions[1] = .CENTER_FORWARD;
                result.source_directions[2] = .FRONT_RIGHT;
            }
            if result.nchannels == 4 { result.source_directions[2] = .REAR_LEFT; result.source_directions[3] = .REAR_RIGHT; }
            if result.nchannels == 5 || result.nchannels == 6 {
                result.source_directions[3] = .REAR_LEFT; result.source_directions[4] = .REAR_RIGHT;
                if result.nchannels == 6 result.source_directions[5] = .SUBWOOFER_CENTER_FORWARD;
            }
            if result.nchannels == 7 { result.source_directions[3] = .EXTEND_LEFT; result.source_directions[4] = .EXTEND_RIGHT; result.source_directions[5] = .CENTER_FORWARD; result.source_directions[6] = .SUBWOOFER_CENTER_FORWARD; }
            if result.nchannels == 8 { result.source_directions[3] = .EXTEND_LEFT; result.source_directions[4] = .EXTEND_RIGHT; result.source_directions[5] = .REAR_LEFT; result.source_directions[6] = .REAR_RIGHT; result.source_directions[7] = .SUBWOOFER_CENTER_FORWARD; }
        }
    }
    return result;
}
get_magic4 :: ( data : string , base : s64 ) -> u32 {
    assert(base >= 0 && base <= data.count - 4);
    word: u32 = 0;
    offset: s64 = 0;
    while offset < 4 {
        word |= cast(u32) data[base+offset] << cast(u32) (offset*8);
        offset += 1;
    }
    return word;
}


#scope_module
#import "File";
#import "Wav_File";
