// Independently normalized ABI contract. No reference procedure bodies or binaries.
#scope_file
#import "POSIX" ;
alsa :: #system_library "asound" ;
LITTLE_ENDIAN :: 0 ;
BIG_ENDIAN :: 1 ;
CPU_BYTE_ORDER :: LITTLE_ENDIAN ;
snd_pcm_t :: struct {
}
snd_pcm_info_t :: struct {
}
snd_pcm_hw_params_t :: struct {
}
snd_pcm_sw_params_t :: struct {
}
snd_pcm_stream_t :: u32 ;
snd_pcm_access_t :: u32 ;
snd_pcm_format_t :: u32 ;
SND_PCM_ACCESS_RW_INTERLEAVED :: 3 ;
SND_PCM_FORMAT_S16_LE :: 2 ;
SND_PCM_FORMAT_S16_BE :: 3 ;
#if CPU_BYTE_ORDER == LITTLE_ENDIAN {
    SND_PCM_FORMAT_S16_MY_ENDIAN :: SND_PCM_FORMAT_S16_LE ;
}
else {
    SND_PCM_FORMAT_S16_MY_ENDIAN :: SND_PCM_FORMAT_S16_BE ;
}
snd_pcm_uframes_t :: u64 ;
snd_pcm_sframes_t :: s64 ;
snd_pcm_open :: ( pcm : * * snd_pcm_t , name : * u8 , stream : snd_pcm_stream_t , mode : s32 ) -> s32 #foreign alsa ;
snd_pcm_close :: ( pcm : * snd_pcm_t ) -> s32 #foreign alsa ;
snd_pcm_delay :: ( pcm : * snd_pcm_t , delayp : * snd_pcm_sframes_t ) -> s32 #foreign alsa ;
snd_pcm_prepare :: ( pcm : * snd_pcm_t ) -> s32 #foreign alsa ;
snd_pcm_writei :: ( pcm : * snd_pcm_t , buf : * void , size : snd_pcm_uframes_t ) -> snd_pcm_sframes_t #foreign alsa ;
snd_pcm_avail :: ( pcm : * snd_pcm_t ) -> snd_pcm_sframes_t #foreign alsa ;
snd_pcm_avail_update :: ( pcm : * snd_pcm_t ) -> snd_pcm_sframes_t #foreign alsa ;
snd_pcm_start :: ( pcm : * snd_pcm_t ) -> s32 #foreign alsa ;
snd_pcm_recover :: ( pcm : * snd_pcm_t , err : s32 , silent : s32 ) -> s32 #foreign alsa ;
snd_pcm_drop :: ( pcm : * snd_pcm_t ) -> s32 #foreign alsa ;
snd_pcm_state_t :: enum u32 {
    SND_PCM_STATE_OPEN :: 0 ;
    SND_PCM_STATE_SETUP ;
    SND_PCM_STATE_PREPARED ;
    SND_PCM_STATE_RUNNING ;
    SND_PCM_STATE_XRUN ;
    SND_PCM_STATE_DRAINING ;
    SND_PCM_STATE_PAUSED ;
    SND_PCM_STATE_SUSPENDED ;
    SND_PCM_STATE_DISCONNECTED ;
}
snd_pcm_state :: ( pcm : * snd_pcm_t ) -> snd_pcm_state_t #foreign alsa ;
snd_pcm_set_params :: ( pcm : * snd_pcm_t , format : snd_pcm_format_t , access : snd_pcm_access_t , channels : u32 , rate : u32 , soft_resample : s32 , latency : u32 ) -> s32 #foreign alsa ;
snd_pcm_hw_params :: ( pcm : * snd_pcm_t , params : * snd_pcm_hw_params_t ) -> s32 #foreign alsa ;
snd_pcm_hw_params_any :: ( pcm : * snd_pcm_t , params : * snd_pcm_hw_params_t ) -> s32 #foreign alsa ;
snd_pcm_hw_params_get_channels_max :: ( params : * snd_pcm_hw_params_t , val : * u32 ) -> s32 #foreign alsa ;
snd_pcm_hw_params_set_format :: ( pcm : * snd_pcm_t , params : * snd_pcm_hw_params_t , val : snd_pcm_format_t ) -> s32 #foreign alsa ;
snd_pcm_hw_params_set_access :: ( pcm : * snd_pcm_t , params : * snd_pcm_hw_params_t , access : snd_pcm_access_t ) -> s32 #foreign alsa ;
snd_pcm_hw_params_set_period_size :: ( pcm : * snd_pcm_t , params : * snd_pcm_hw_params_t , val : snd_pcm_uframes_t , dir : s32 ) -> s32 #foreign alsa ;
snd_pcm_hw_params_set_rate_near :: ( pcm : * snd_pcm_t , params : * snd_pcm_hw_params_t , val : * u32 , dir : * s32 ) -> s32 #foreign alsa ;
snd_pcm_hw_params_set_channels :: ( pcm : * snd_pcm_t , params : * snd_pcm_hw_params_t , val : u32 ) -> s32 #foreign alsa ;
snd_pcm_hw_params_get_rate :: ( params : * snd_pcm_hw_params_t , val : * u32 , dir : * s32 ) -> s32 #foreign alsa ;
snd_pcm_hw_params_get_channels :: ( params : * snd_pcm_hw_params_t , val : * u32 ) -> s32 #foreign alsa ;
snd_pcm_hw_params_get_buffer_size :: ( params : * snd_pcm_hw_params_t , val : * snd_pcm_uframes_t ) -> s32 #foreign alsa ;
snd_pcm_hw_params_get_periods :: ( params : * snd_pcm_hw_params_t , val : * u32 , dir : * s32 ) -> s32 #foreign alsa ;
snd_pcm_hw_params_get_period_size :: ( params : * snd_pcm_hw_params_t , frames : * snd_pcm_uframes_t , dir : * s32 ) -> s32 #foreign alsa ;
snd_pcm_hw_params_malloc :: ( ptr : * * snd_pcm_hw_params_t ) -> s32 #foreign alsa ;
snd_pcm_hw_params_free :: ( obj : * snd_pcm_hw_params_t ) -> void #foreign alsa ;
snd_pcm_sw_params :: ( pcm : * snd_pcm_t , params : * snd_pcm_sw_params_t ) -> s32 #foreign alsa ;
snd_pcm_sw_params_malloc :: ( ptr : * * snd_pcm_sw_params_t ) -> s32 #foreign alsa ;
snd_pcm_sw_params_free :: ( obj : * snd_pcm_sw_params_t ) -> void #foreign alsa ;
snd_pcm_sw_params_current :: ( pcm : * snd_pcm_t , params : * snd_pcm_sw_params_t ) -> s32 #foreign alsa ;
snd_pcm_sw_params_get_start_threshold :: ( params : * snd_pcm_sw_params_t , val : * snd_pcm_uframes_t ) -> s32 #foreign alsa ;
snd_pcm_sw_params_set_start_threshold :: ( pcm : * snd_pcm_t , params : * snd_pcm_sw_params_t , val : snd_pcm_uframes_t ) -> s32 #foreign alsa ;
snd_pcm_sw_params_set_avail_min :: ( pcm : * snd_pcm_t , params : * snd_pcm_sw_params_t , val : snd_pcm_uframes_t ) -> s32 #foreign alsa ;
sound_error_name :: ( errnum : s32 ) -> string {
    text := Native_AlsaStrError(errnum);
    if !text return "Unknown ALSA error";
    count: s64 = 0;
    while text[count] != 0 count += 1;
    return to_string(text, count);
}
check_for_alsa_error :: ( name : string , errnum : s32 ) {
    if errnum < 0 print("ALSA % failed: %\n", name, sound_error_name(errnum));
}
snd_pcm_channel_area_t :: struct {
    addr : * void ;
    first : u32 ;
    step : u32 ;
}
snd_pcm_mmap_begin :: ( pcm : * snd_pcm_t , areas : * * snd_pcm_channel_area_t , offset : * snd_pcm_uframes_t , frames : * snd_pcm_uframes_t ) -> s32 #foreign alsa ;
snd_pcm_mmap_commit :: ( pcm : * snd_pcm_t , offset : snd_pcm_uframes_t , frames : snd_pcm_uframes_t ) -> snd_pcm_sframes_t #foreign alsa ;
snd_pcm_mmap_writei :: ( pcm : * snd_pcm_t , buffer : * void , size : snd_pcm_uframes_t ) -> snd_pcm_sframes_t #foreign alsa ;
snd_pcm_mmap_readi :: ( pcm : * snd_pcm_t , buffer : * void , size : snd_pcm_uframes_t ) -> snd_pcm_sframes_t #foreign alsa ;
snd_pcm_mmap_writen :: ( pcm : * snd_pcm_t , buffer : * * void , size : snd_pcm_uframes_t ) -> snd_pcm_sframes_t #foreign alsa ;
snd_pcm_mmap_readn :: ( pcm : * snd_pcm_t , buffer : * * void , size : snd_pcm_uframes_t ) -> snd_pcm_sframes_t #foreign alsa ;
snd_device_name_hint :: ( card : s32 , iface : * u8 , hints : * * * void ) -> s32 #foreign alsa ;
snd_device_name_free_hint :: ( hints : * * void ) -> s32 #foreign alsa ;
snd_device_name_get_hint :: ( hint : * void , id : * u8 ) -> * u8 #foreign alsa ;
#scope_export
MY_SAMPLING_RATE :: 48000 ;
backend_get_devices :: ( ) -> [ ] Output_Device {
    if enumerated_output_devices.count > 0 return enumerated_output_devices;
    hints: **void;
    if snd_device_name_hint(-1, "pcm", *hints) < 0 return enumerated_output_devices;
    defer snd_device_name_free_hint(hints);
    index: s64 = 0;
    while hints[index] {
        hint := hints[index];
        name := snd_device_name_get_hint(hint, "NAME");
        direction := snd_device_name_get_hint(hint, "IOID");
        input_only := false;
        if direction {
            length: s64 = 0; while direction[length] != 0 length += 1;
            input_only = to_string(direction, length) == "Input";
            Native_C_Free(direction);
        }
        if name && !input_only {
            length: s64 = 0; while name[length] != 0 length += 1;
            device: Output_Device;
            device.name = copy_string(to_string(name, length));
            device.device_index = enumerated_output_devices.count;
            description := snd_device_name_get_hint(hint, "DESC");
            if description {
                length = 0; while description[length] != 0 length += 1;
                device.hints = NewArray(1, string);
                device.hints[0] = copy_string(to_string(description, length));
                Native_C_Free(description);
            }
            array_add(*enumerated_output_devices, device);
        }
        if name Native_C_Free(name);
        index += 1;
    }
    return enumerated_output_devices;
}
backend_init :: ( config : Sound_Player_Config ) -> Backend_Properties {
    properties: Backend_Properties;
    if pcm_device return properties;
    result := snd_pcm_open(*pcm_device, "default", 0, 0);
    if result < 0 { check_for_alsa_error("open", result); pcm_device = null; return properties; }
    num_channels = 2;
    latency := cast(u32) (max(0.02, config.seconds_to_fill_ahead)*1000000.0);
    result = snd_pcm_set_params(pcm_device, SND_PCM_FORMAT_S16_MY_ENDIAN, SND_PCM_ACCESS_RW_INTERLEAVED,
        cast(u32) num_channels, MY_SAMPLING_RATE, 1, latency);
    if result < 0 { check_for_alsa_error("set parameters", result); backend_shutdown(); return properties; }
    temporary_buffer_size_in_frames = MY_SAMPLING_RATE;
    temporary_buffer = alloc_string(temporary_buffer_size_in_frames*num_channels*BYTES_PER_SAMPLE);
    if !temporary_buffer.data { backend_shutdown(); return properties; }
    period_size_in_frames = cast(s64) (MY_SAMPLING_RATE*max(config.seconds_to_fill_ahead, 0.01));
    base_delay_in_frames = max(1, period_size_in_frames);
    array_add(*channel_names, "Front Left", "Front Right");
    properties.initted = true;
    properties.num_channels = num_channels;
    properties.output_sampling_rate = MY_SAMPLING_RATE;
    properties.channel_names = channel_names;
    return properties;
}
backend_lock_fill_regions :: ( bytes_to_lock : s64 ) -> Fill_Region_Result , bool {
    result: Fill_Region_Result;
    if !pcm_device || !temporary_buffer.data || alsa_fill_locked || bytes_to_lock <= 0 return result, false;
    available := snd_pcm_avail_update(pcm_device);
    if available < 0 {
        if snd_pcm_recover(pcm_device, cast(s32) available, 1) < 0 return result, false;
        available = snd_pcm_avail_update(pcm_device);
    }
    frame_bytes := num_channels*BYTES_PER_SAMPLE;
    frames := min(bytes_to_lock/frame_bytes, temporary_buffer_size_in_frames);
    frames = min(frames, max(0, available));
    if frames <= 0 return result, false;
    result.buffer0 = to_string(temporary_buffer.data, frames*frame_bytes);
    alsa_fill_locked = true;
    return result, true;
}
backend_release_fill_regions :: ( result : Fill_Region_Result ) {
    assert(alsa_fill_locked);
    defer alsa_fill_locked = false;
    frames := result.buffer0.count/(num_channels*BYTES_PER_SAMPLE);
    cursor: s64 = 0;
    recovery_attempts: s32 = 0;
    while cursor < frames {
        written := snd_pcm_writei(pcm_device, result.buffer0.data+cursor*num_channels*BYTES_PER_SAMPLE,
            cast(u64) (frames-cursor));
        if written < 0 {
            recovery_attempts += 1;
            if recovery_attempts > 2 || snd_pcm_recover(pcm_device, cast(s32) written, 1) < 0 {
                check_for_alsa_error("write", cast(s32) written); break;
            }
            continue;
        }
        if written == 0 break;
        recovery_attempts = 0;
        cursor += written;
    }
    buffer_consumed += cast(u64) cursor;
}
backend_count_buffered_bytes :: ( ) -> ( buffered_bytes : s64 , minimum_prebuffered_bytes : s64 ) {
    if !pcm_device return 0, 0;
    delay: snd_pcm_sframes_t;
    result := snd_pcm_delay(pcm_device, *delay);
    if result < 0 delay = 0;
    frame_bytes := num_channels*BYTES_PER_SAMPLE;
    return max(0, delay)*frame_bytes, base_delay_in_frames*frame_bytes;
}
backend_shutdown :: ( ) {
    if pcm_device { snd_pcm_drop(pcm_device); snd_pcm_close(pcm_device); pcm_device = null; }
    free(temporary_buffer); temporary_buffer = "";
    array_free(channel_names); channel_names = .{};
    num_channels = 0; alsa_fill_locked = false;
    buffer_consumed = 0;
}
backend_needs_async_update_from_main_thread :: ( ) -> bool {
    // ALSA PCM I/O has no application event-loop affinity.
    return false;
}
backend_play :: ( ) {
    if !pcm_device return;
    state := snd_pcm_state(pcm_device);
    if state == .SND_PCM_STATE_SETUP || state == .SND_PCM_STATE_XRUN || state == .SND_PCM_STATE_SUSPENDED
        check_for_alsa_error("prepare", snd_pcm_prepare(pcm_device));
    // snd_pcm_writei starts the prepared stream at its configured threshold.
}
#scope_file
;
num_channels : s32 ;
channel_names : [ .. ] string ;
pcm_device : * snd_pcm_t ;
temporary_buffer_size_in_frames : s64 ;
buffer_consumed : snd_pcm_uframes_t ;
period_size_in_frames : s64 ;
periods : u32 = 3 ;
base_delay_in_frames : s64 ;
temporary_buffer : string ;
enumerated_output_devices : [ .. ] Output_Device ;


#scope_file
Native_AlsaStrError :: (error: s32) -> *u8 #foreign alsa "snd_strerror";
Native_C_Library :: #system_library "c";
Native_C_Free :: (pointer: *void) #foreign Native_C_Library "free";
alsa_fill_locked := false;
