// Linux output through ALSA's "default" PCM, written with plain interleaved writes. Only as many
// frames as the device has room for are written, so the worker never blocks inside ALSA.

#scope_module

output_open :: (config: Sound_Player_Config) -> channels: s32, rate: s32, ok: bool {
    if pcm return 0, 0, false;
    status := pcm_open(*pcm, "default", PCM_PLAYBACK, 0);
    if status < 0 {
        complain("open the default device", status);
        pcm = null;
        return 0, 0, false;
    }
    latency_us := cast(u32) (max(config.seconds_to_fill_ahead, 0.02) * 1_000_000);
    status = pcm_set_params(pcm, FORMAT_S16_LE, ACCESS_RW_INTERLEAVED, ALSA_CHANNELS, ALSA_RATE, 1, latency_us);
    if status < 0 {
        complain("configure the device", status);
        output_close();
        return 0, 0, false;
    }
    return ALSA_CHANNELS, ALSA_RATE, true;
}

output_start :: () {
    if pcm pcm_prepare(pcm); // Playback begins with the first write.
}

output_close :: () {
    if pcm {
        pcm_drop(pcm);
        pcm_close(pcm);
        pcm = null;
    }
}

output_frames_queued :: () -> queued: s64, at_least: s64 {
    if !pcm return S64_MAX, 0;
    delay: s64;
    if pcm_delay(pcm, *delay) < 0 delay = 0;
    return max(delay, 0), 0;
}

output_write :: (frames: s64) {
    if !pcm return;
    room := pcm_avail_update(pcm);
    if room < 0 {
        // Usually an underrun; recover and look again.
        if pcm_recover(pcm, cast(s32) room, 1) < 0 return;
        room = pcm_avail_update(pcm);
        if room < 0 return;
    }
    remaining := min(frames, room);
    while remaining > 0 {
        count := min(remaining, STAGING_FRAMES);
        chunk: [] s16;
        chunk.data = staging.data;
        chunk.count = count * ALSA_CHANNELS;
        mix_into(chunk);
        if !write_all(chunk.data, count) return;
        remaining -= count;
    }
}

output_devices :: () -> [] Output_Device {
    if listed_devices.count return listed_devices;
    hints: **void;
    if device_name_hint(-1, "pcm", *hints) < 0 return listed_devices;
    cursor := hints;
    while cursor.* {
        name := take_hint(cursor.*, "NAME");
        direction := take_hint(cursor.*, "IOID");
        description := take_hint(cursor.*, "DESC");
        // IOID is absent for devices that do both directions.
        if name.count > 0 && direction != "Input" {
            device: Output_Device;
            device.name = name;
            device.device_index = listed_devices.count;
            if description.count > 0 {
                device.hints = NewArray(1, string);
                device.hints[0] = description;
            }
            array_add(*listed_devices, device);
        } else {
            release_hint(name);
            release_hint(description);
        }
        release_hint(direction);
        cursor += 1;
    }
    device_name_free_hint(hints);
    return listed_devices;
}

#scope_file

ALSA_RATE :: 48000;
ALSA_CHANNELS :: 2;
STAGING_FRAMES :: 2048;

pcm: *Pcm;
staging: [STAGING_FRAMES * ALSA_CHANNELS] s16;
listed_devices: [..] Output_Device = .{ allocator = SOUND_HEAP };

write_all :: (samples: *s16, frames: s64) -> bool {
    written := 0;
    retries := 0;
    while written < frames {
        result := pcm_writei(pcm, samples + written * ALSA_CHANNELS, cast(u64) (frames - written));
        if result < 0 {
            retries += 1;
            if retries > 3 || pcm_recover(pcm, cast(s32) result, 1) < 0 {
                complain("write samples", cast(s32) result);
                return false;
            }
            continue;
        }
        if result == 0 return false;
        written += result;
    }
    return true;
}

// The hint value as a string we own, or "" if absent.
take_hint :: (hint: *void, field: *u8) -> string {
    raw := device_name_get_hint(hint, field);
    if !raw return "";
    text := copy_string(to_string(raw));
    libc_free(raw);
    return text;
}

release_hint :: (text: string) {
    if text.count > 0 free(text);
}

complain :: (what: string, status: s32) {
    log_error("Sound_Player: ALSA could not %: %\n", what, to_string(alsa_error_text(status)));
}

// Opaque handle and the handful of libasound entry points used above.
Pcm :: struct {}
PCM_PLAYBACK :: 0;
FORMAT_S16_LE :: 2;
ACCESS_RW_INTERLEAVED :: 3;

libasound :: #system_library "asound";
libc :: #system_library "c";

pcm_open :: (handle: **Pcm, name: *u8, direction: s32, mode: s32) -> s32 #foreign libasound "snd_pcm_open";
pcm_close :: (handle: *Pcm) -> s32 #foreign libasound "snd_pcm_close";
pcm_drop :: (handle: *Pcm) -> s32 #foreign libasound "snd_pcm_drop";
pcm_prepare :: (handle: *Pcm) -> s32 #foreign libasound "snd_pcm_prepare";
pcm_set_params :: (handle: *Pcm, format: u32, access: u32, channels: u32, rate: u32, allow_resample: s32, latency_us: u32) -> s32 #foreign libasound "snd_pcm_set_params";
pcm_writei :: (handle: *Pcm, buffer: *void, frames: u64) -> s64 #foreign libasound "snd_pcm_writei";
pcm_avail_update :: (handle: *Pcm) -> s64 #foreign libasound "snd_pcm_avail_update";
pcm_delay :: (handle: *Pcm, frames: *s64) -> s32 #foreign libasound "snd_pcm_delay";
pcm_recover :: (handle: *Pcm, error: s32, silent: s32) -> s32 #foreign libasound "snd_pcm_recover";
alsa_error_text :: (error: s32) -> *u8 #foreign libasound "snd_strerror";
device_name_hint :: (card: s32, interface: *u8, hints: ***void) -> s32 #foreign libasound "snd_device_name_hint";
device_name_get_hint :: (hint: *void, field: *u8) -> *u8 #foreign libasound "snd_device_name_get_hint";
device_name_free_hint :: (hints: **void) -> s32 #foreign libasound "snd_device_name_free_hint";
libc_free :: (pointer: *void) #foreign libc "free";
