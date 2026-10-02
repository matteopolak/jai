#import "Wav_File";
witness :: () -> bool {
    bytes := u8.[82, 73, 70, 70, 48, 0, 0, 0, 87, 65, 86, 69, 74, 85, 78, 75, 1, 0, 0, 0, 120, 0, 100, 97, 116, 97, 2, 0, 0, 0, 52, 18, 102, 109, 116, 32, 16, 0, 0, 0, 1, 0, 1, 0, 64, 31, 0, 0, 128, 62, 0, 0, 2, 0, 16, 0];
    data: string;
    data.data = bytes.data;
    data.count = bytes.count;
    wav := load_wav_file(data);
    if !wav.success || wav.format.wFormatTag != 1 || wav.format.nChannels != 1 || wav.format.nSamplesPerSec != 8000 return false;
    if wav.samples.count != 2 || wav.samples.data[0] != 52 || wav.samples.data[1] != 18 return false;
    data.count = 11;
    bad := load_wav_file(data);
    if bad.success return false;
    data.count = bytes.count;
    bytes[4] = 0;
    short := load_wav_file(data);
    if short.success return false;
    return true;
}
#assert(witness());
