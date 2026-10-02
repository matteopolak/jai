// Explicit supplied-distribution WAVEFORMATEX return contract.
Current :: #import "Wav_File";
WAVE_FORMAT_PCM :: Current.WAVE_FORMAT_PCM;
WAVE_FORMAT_DVI_ADPCM :: Current.WAVE_FORMAT_DVI_ADPCM;
Waveformatex :: Current.Waveformatex;
Wave_Extra_Info :: Current.Wave_Extra_Info;
get_wav_header :: (file_data: string) -> (format: Waveformatex, samples: string, success: bool = false, extra: Wave_Extra_Info) {
    format, samples, success, extra := Current.get_waveformatex_header(file_data);
    return format, samples, success, extra;
}
