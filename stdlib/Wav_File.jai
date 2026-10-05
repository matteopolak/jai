// Authored RIFF/WAVE reader. Returned samples borrow the caller's byte storage.
WAVE_FORMAT_PCM :: 0x0001;
WAVE_FORMAT_DVI_ADPCM :: 0x0011;

Waveformatex :: struct {
    wFormatTag: s16;
    nChannels: s16;
    nSamplesPerSec: s32;
    nAvgBytesPerSec: s32;
    nBlockAlign: s16;
    wBitsPerSample: s16;
    cbSize: s16;
} #no_padding;

Wave_Extra_Info :: struct {
    wSamplesPerBlock: s32;
    wSamplesAccordingToFactChunk: s32;
}

// Current maintained-source API. Full legacy WAVEFORMATEX fields remain available
// through get_waveformatex_header and the explicit legacy/Wav_File module.
Wav_Format :: struct {
    wFormatTag: int;
    nChannels: int;
    nBlockAlign: int;
    nSamplesPerSec: int;
}
Wav_Extra :: struct {
    wSamplesPerBlock: int;
    wSamplesAccordingToFactChunk: int;
}
Wav_File :: struct {
    format: Wav_Format;
    samples: string;
    extra: Wav_Extra;
    success: bool;
}
get_wav_header :: (file_data: string) -> Wav_Format, string, bool, Wav_Extra {
    buffer := file_data;
    original, samples, success, original_extra := get_waveformatex_header(buffer);
    format: Wav_Format;
    format.wFormatTag = original.wFormatTag;
    format.nChannels = original.nChannels;
    format.nBlockAlign = original.nBlockAlign;
    format.nSamplesPerSec = original.nSamplesPerSec;
    extra: Wav_Extra;
    extra.wSamplesPerBlock = original_extra.wSamplesPerBlock;
    extra.wSamplesAccordingToFactChunk = original_extra.wSamplesAccordingToFactChunk;
    return format, samples, success, extra;
}
load_wav_file :: (buffer: string) -> Wav_File {
    result: Wav_File;
    result.format, result.samples, result.success, result.extra = get_wav_header(buffer);
    return result;
}
get_waveformatex_header :: (file_data: string) -> (format: Waveformatex, samples: string, success: bool = false, extra: Wave_Extra_Info) {
    format: Waveformatex;
    samples: string;
    extra: Wave_Extra_Info;
    if file_data.count < 12 return format, samples, false, extra;
    if !wav_id(file_data, 0, "RIFF") || !wav_id(file_data, 8, "WAVE") return format, samples, false, extra;

    declared := cast(s64) wav_u32(file_data.data + 4) + 8;
    if declared < 12 return format, samples, false, extra;
    limit := file_data.count;
    // Accommodate a RIFF length which includes a missing final file tail.
    if declared < limit limit = declared;
    pos: s64 = 12;
    have_format := false;
    have_data := false;
    while pos <= limit - 8 {
        length := cast(s64) wav_u32(file_data.data + pos + 4);
        body := pos + 8;
        if length > limit - body return format, samples, false, extra;
        if wav_id(file_data, pos, "fmt ") {
            if length < 16 return format, samples, false, extra;
            p := file_data.data + body;
            format.wFormatTag = cast,no_check(s16) wav_u16(p);
            format.nChannels = cast,no_check(s16) wav_u16(p + 2);
            format.nSamplesPerSec = cast,no_check(s32) wav_u32(p + 4);
            format.nAvgBytesPerSec = cast,no_check(s32) wav_u32(p + 8);
            format.nBlockAlign = cast,no_check(s16) wav_u16(p + 12);
            format.wBitsPerSample = cast,no_check(s16) wav_u16(p + 14);
            if length >= 18 format.cbSize = cast,no_check(s16) wav_u16(p + 16);
            if format.nChannels <= 0 || format.nSamplesPerSec <= 0 || format.nBlockAlign <= 0 return format, samples, false, extra;
            if format.wFormatTag == WAVE_FORMAT_DVI_ADPCM {
                if length < 20 || format.cbSize < 2 return format, samples, false, extra;
                extra.wSamplesPerBlock = cast(s32) wav_u16(p + 18);
                if extra.wSamplesPerBlock < 1 return format, samples, false, extra;
            } else if format.wFormatTag != WAVE_FORMAT_PCM {
                return format, samples, false, extra;
            }
            have_format = true;
        } else if wav_id(file_data, pos, "data") {
            if !have_data {
                samples.data = file_data.data + body;
                samples.count = length;
                have_data = true;
            }
        } else if wav_id(file_data, pos, "fact") {
            if length < 4 return format, samples, false, extra;
            extra.wSamplesAccordingToFactChunk = cast,no_check(s32) wav_u32(file_data.data + body);
        }
        pos = body + length;
        if (length & 1) != 0 {
            if pos == limit break;
            pos += 1;
        }
    }
    return format, samples, have_format && have_data, extra;
}

#scope_file
wav_u16 :: (p: *u8) -> u16 {
    return cast(u16) p[0] | (cast(u16) p[1] << 8);
}
wav_u32 :: (p: *u8) -> u32 {
    return cast(u32) p[0] | (cast(u32) p[1] << 8) | (cast(u32) p[2] << 16) | (cast(u32) p[3] << 24);
}
wav_id :: (data: string, offset: s64, id: string) -> bool {
    if offset < 0 || offset > data.count - 4 return false;
    for i: 0..3 if data.data[offset + i] != id.data[i] return false;
    return true;
}
