// Sound_Data and the loaders that fill it from WAV (16-bit PCM or IMA ADPCM) and Ogg Vorbis bytes.

#scope_export

Sound_Data :: struct {
    using resource: struct {
        name: string;
        full_path: string;
        loaded := false;
        skip_load := false;
    };

    Kind :: enum {
        UNINITIALIZED;
        LINEAR_SAMPLE_ARRAY;
        OGG_COMPRESSED;
        ADPCM_COMPRESSED;
    }
    type := Kind.UNINITIALIZED;

    nsamples_times_nchannels: s64;
    nchannels: u16 = 1;
    sampling_rate: u32 = 44100;

    buffer: string; // The file contents; owned by this Sound_Data when a loader made it.
    samples: *s16; // PCM or ADPCM payload inside `buffer`.

    volume_scale: float = 1;
    silence_before_repeat: float = 0; // Seconds of silence inserted each time a repeat wraps.
    filename_to_stream_from: string; // Ogg only: decode from this file instead of `buffer`.
    source_directions: [MAX_CHANNELS_PER_SOUND] Source_Direction;

    // IMA ADPCM packet layout, copied from the WAV header.
    nBlockAlign: s32 = 0;
    wSamplesPerBlock: s32 = 0;
}

// Reads and parses a sound file. With `optional`, a missing file is not reported as an error.
// Check `loaded` on the result.
load_audio_file :: (filename: string, optional := false) -> Sound_Data {
    bytes, ok := read_entire_file(filename, log_errors = !optional);
    if !ok return .{};
    result := load_audio_data(filename, bytes);
    free(bytes);
    result.full_path = copy_string(filename);
    return result;
}

// Parses sound file bytes (copied, so `data` may be freed afterwards). The name is only for messages.
load_audio_data :: (name_for_error_reporting: string, data: string) -> Sound_Data {
    result: Sound_Data;
    result.name = copy_string(name_for_error_reporting);

    kind := sniff_container(data);
    if kind == .UNKNOWN {
        if VERBOSE log_error("Sound_Player: '%' is neither WAV nor Ogg.\n", name_for_error_reporting);
        return result;
    }

    owned := copy_string(data);
    parsed := ifx kind == .RIFF then describe_wav(*result, owned) else describe_ogg(*result, owned);
    if !parsed {
        if VERBOSE log_error("Sound_Player: '%' uses an unsupported encoding.\n", name_for_error_reporting);
        free(owned);
        return result;
    }

    result.buffer = owned;
    result.loaded = true;
    assign_default_directions(*result);
    return result;
}

#scope_file
#import "File";
#import "Wav_File";

Container :: enum u8 {
    UNKNOWN;
    RIFF;
    OGG;
}

sniff_container :: (bytes: string) -> Container {
    if bytes.count < 4 return .UNKNOWN;
    tag := to_string(bytes.data, 4);
    if tag == "RIFF" return .RIFF;
    if tag == "OggS" return .OGG;
    return .UNKNOWN;
}

describe_wav :: (result: *Sound_Data, bytes: string) -> bool {
    format, payload, ok, extra := get_waveformatex_header(bytes);
    if !ok return false;
    channels := cast(s64) format.nChannels;
    if channels < 1 || channels > MAX_CHANNELS_PER_SOUND || format.nSamplesPerSec <= 0 return false;

    frames: s64;
    if format.wFormatTag == WAVE_FORMAT_PCM {
        if format.wBitsPerSample != 16 return false;
        result.type = .LINEAR_SAMPLE_ARRAY;
        frames = payload.count / (2 * channels);
    } else if format.wFormatTag == WAVE_FORMAT_DVI_ADPCM {
        if format.nBlockAlign <= 0 || extra.wSamplesPerBlock <= 0 return false;
        result.type = .ADPCM_COMPRESSED;
        result.nBlockAlign = format.nBlockAlign;
        result.wSamplesPerBlock = extra.wSamplesPerBlock;
        frames = (payload.count / format.nBlockAlign) * extra.wSamplesPerBlock;
        // The fact chunk knows how many frames the padded last packet really holds.
        if extra.wSamplesAccordingToFactChunk > 0 frames = min(frames, cast(s64) extra.wSamplesAccordingToFactChunk);
    } else {
        return false;
    }

    result.nchannels = cast(u16) channels;
    result.sampling_rate = cast(u32) format.nSamplesPerSec;
    result.nsamples_times_nchannels = frames * channels;
    result.samples = cast(*s16) payload.data;
    return true;
}

describe_ogg :: (result: *Sound_Data, bytes: string) -> bool {
    if bytes.count > S32_MAX return false;
    status: s32;
    handle := stb_vorbis_open_memory(bytes.data, cast(s32) bytes.count, *status, null);
    if !handle return false;
    info := stb_vorbis_get_info(handle);
    frames := cast(s64) stb_vorbis_stream_length_in_samples(handle);
    stb_vorbis_close(handle);

    if info.channels < 1 || info.channels > MAX_CHANNELS_PER_SOUND || info.sample_rate == 0 || frames <= 0 return false;
    result.type = .OGG_COMPRESSED;
    result.nchannels = cast(u16) info.channels;
    result.sampling_rate = info.sample_rate;
    result.nsamples_times_nchannels = frames * info.channels;
    return true;
}

// WAV and Vorbis order their surround channels differently, so each has its own table, indexed
// as [(channel count - 1) * 8 + channel]. Unlisted channels stay MONO.
using Source_Direction;

WAV_LAYOUTS :: Source_Direction.[
    MONO, MONO, MONO, MONO, MONO, MONO, MONO, MONO,
    FRONT_LEFT, FRONT_RIGHT, MONO, MONO, MONO, MONO, MONO, MONO,
    FRONT_LEFT, FRONT_RIGHT, CENTER_FORWARD, MONO, MONO, MONO, MONO, MONO,
    FRONT_LEFT, FRONT_RIGHT, REAR_LEFT, REAR_RIGHT, MONO, MONO, MONO, MONO,
    FRONT_LEFT, FRONT_RIGHT, CENTER_FORWARD, REAR_LEFT, REAR_RIGHT, MONO, MONO, MONO,
    FRONT_LEFT, FRONT_RIGHT, CENTER_FORWARD, SUBWOOFER_CENTER_FORWARD, REAR_LEFT, REAR_RIGHT, MONO, MONO,
    FRONT_LEFT, FRONT_RIGHT, CENTER_FORWARD, SUBWOOFER_CENTER_FORWARD, REAR_LEFT, REAR_RIGHT, EXTEND_LEFT, MONO,
    FRONT_LEFT, FRONT_RIGHT, CENTER_FORWARD, SUBWOOFER_CENTER_FORWARD, REAR_LEFT, REAR_RIGHT, EXTEND_LEFT, EXTEND_RIGHT,
];

VORBIS_LAYOUTS :: Source_Direction.[
    MONO, MONO, MONO, MONO, MONO, MONO, MONO, MONO,
    FRONT_LEFT, FRONT_RIGHT, MONO, MONO, MONO, MONO, MONO, MONO,
    FRONT_LEFT, CENTER_FORWARD, FRONT_RIGHT, MONO, MONO, MONO, MONO, MONO,
    FRONT_LEFT, FRONT_RIGHT, REAR_LEFT, REAR_RIGHT, MONO, MONO, MONO, MONO,
    FRONT_LEFT, CENTER_FORWARD, FRONT_RIGHT, REAR_LEFT, REAR_RIGHT, MONO, MONO, MONO,
    FRONT_LEFT, CENTER_FORWARD, FRONT_RIGHT, REAR_LEFT, REAR_RIGHT, SUBWOOFER_CENTER_FORWARD, MONO, MONO,
    FRONT_LEFT, CENTER_FORWARD, FRONT_RIGHT, EXTEND_LEFT, EXTEND_RIGHT, CENTER_FORWARD, SUBWOOFER_CENTER_FORWARD, MONO,
    FRONT_LEFT, CENTER_FORWARD, FRONT_RIGHT, EXTEND_LEFT, EXTEND_RIGHT, REAR_LEFT, REAR_RIGHT, SUBWOOFER_CENTER_FORWARD,
];

assign_default_directions :: (result: *Sound_Data) {
    count := cast(s64) result.nchannels;
    if count < 1 || count > 8 return;
    vorbis := result.type == .OGG_COMPRESSED;
    for 0..count - 1 {
        slot := (count - 1) * 8 + it;
        result.source_directions[it] = ifx vorbis then VORBIS_LAYOUTS[slot] else WAV_LAYOUTS[slot];
    }
}
