// No device: the program pulls the mix with render_offline. Also used on targets without an audio
// backend, where it simply produces nothing unless asked.

OFFLINE_SAMPLING_RATE :: 48000;

// Mixes the next out.count / channels frames into `out`. Returns the number of frames written.
render_offline :: (out: [] s16) -> s64 {
    if !player.running return 0;
    mix_into(out);
    return out.count / player.out_channels;
}

#scope_module

output_open :: (config: Sound_Player_Config) -> channels: s32, rate: s32, ok: bool {
    channels := clamp(cast(s32) OFFLINE_CHANNELS, 1, OUTPUT_CHANNELS_MAX);
    return channels, OFFLINE_SAMPLING_RATE, true;
}
output_start :: () {}
output_close :: () {}
// Report the queue as permanently full so top_up_output never mixes on its own.
output_frames_queued :: () -> queued: s64, at_least: s64 {
    return S64_MAX, 0;
}
output_write :: (frames: s64) {}
output_devices :: () -> [] Output_Device {
    return .[];
}
