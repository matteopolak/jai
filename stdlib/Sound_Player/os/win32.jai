// Independently normalized ABI contract. No reference procedure bodies or binaries.
#scope_module
#import "Windows" ;
#import "Wav_File" ;
#scope_export
OUTPUT_SAMPLING_RATE :: 44100 ;
PRIMARY_BUFFER_SIZE_IN_BYTES :: 0 ;
FILL_BUFFER_SIZE_IN_SAMPLES :: 24000 ;
DS_OK :: 0 ;
DSBPLAY_LOOPING :: 0x01 ;
DSBSTATUS_PLAYING :: 0x001 ;
DSBSTATUS_BUFFERLOST :: 0x002 ;
DSBSTATUS_LOOPING :: 0x004 ;
DSBSTATUS_LOCHARDWARE :: 0x008 ;
DSBSTATUS_LOCSOFTWARE :: 0x010 ;
DSBSTATUS_TERMINATED :: 0x020 ;
WAVE_FORMAT_EXTENSIBLE :: 0xFFFE ;
init_KSDATAFORMAT_SUBTYPE_PCM :: ( dest : * GUID ) {
    dest.* = .{Data1=0x00000001,Data2=0x0000,Data3=0x0010,
        Data4=.[0x80,0x00,0x00,0xaa,0x00,0x38,0x9b,0x71]};
}
SPEAKER_FRONT_LEFT :: 0x1 ;
SPEAKER_FRONT_RIGHT :: 0x2 ;
SPEAKER_FRONT_CENTER :: 0x4 ;
SPEAKER_LOW_FREQUENCY :: 0x8 ;
SPEAKER_BACK_LEFT :: 0x10 ;
SPEAKER_BACK_RIGHT :: 0x20 ;
SPEAKER_FRONT_LEFT_OF_CENTER :: 0x40 ;
SPEAKER_FRONT_RIGHT_OF_CENTER :: 0x80 ;
SPEAKER_BACK_CENTER :: 0x100 ;
SPEAKER_SIDE_LEFT :: 0x200 ;
SPEAKER_SIDE_RIGHT :: 0x400 ;
SPEAKER_TOP_CENTER :: 0x800 ;
SPEAKER_TOP_FRONT_LEFT :: 0x1000 ;
SPEAKER_TOP_FRONT_CENTER :: 0x2000 ;
SPEAKER_TOP_FRONT_RIGHT :: 0x4000 ;
SPEAKER_TOP_BACK_LEFT :: 0x8000 ;
SPEAKER_TOP_BACK_CENTER :: 0x10000 ;
SPEAKER_TOP_BACK_RIGHT :: 0x20000 ;
KSAUDIO_SPEAKER_MONO :: SPEAKER_FRONT_CENTER ;
KSAUDIO_SPEAKER_STEREO :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT ;
KSAUDIO_SPEAKER_QUAD :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT | SPEAKER_BACK_LEFT | SPEAKER_BACK_RIGHT ;
KSAUDIO_SPEAKER_SURROUND :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT | SPEAKER_FRONT_CENTER | SPEAKER_BACK_CENTER ;
KSAUDIO_SPEAKER_5POINT1 :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT | SPEAKER_FRONT_CENTER | SPEAKER_LOW_FREQUENCY | SPEAKER_BACK_LEFT | SPEAKER_BACK_RIGHT ;
KSAUDIO_SPEAKER_7POINT1 :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT | SPEAKER_FRONT_CENTER | SPEAKER_LOW_FREQUENCY | SPEAKER_BACK_LEFT | SPEAKER_BACK_RIGHT | SPEAKER_FRONT_LEFT_OF_CENTER | SPEAKER_FRONT_RIGHT_OF_CENTER ;
KSAUDIO_SPEAKER_5POINT1_SURROUND :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT | SPEAKER_FRONT_CENTER | SPEAKER_LOW_FREQUENCY | SPEAKER_SIDE_LEFT | SPEAKER_SIDE_RIGHT ;
KSAUDIO_SPEAKER_7POINT1_SURROUND :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT | SPEAKER_FRONT_CENTER | SPEAKER_LOW_FREQUENCY | SPEAKER_BACK_LEFT | SPEAKER_BACK_RIGHT | SPEAKER_SIDE_LEFT | SPEAKER_SIDE_RIGHT ;
DSSPEAKER :: enum {
    HEADPHONE :: 1 ;
    MONO :: 2 ;
    QUAD :: 3 ;
    STEREO :: 4 ;
    SURROUND :: 5 ;
    _5POINT1 :: 6 ;
    _5POINT1_BACK :: _5POINT1 ;
    _5POINT1_SURROUND :: 9 ;
    _7POINT1 :: 7 ;
    _7POINT1_SURROUND :: 8 ;
    _7POINT1_WIDE :: _7POINT1 ;
}
DSBCAPS_PRIMARYBUFFER :: 0x1 ;
DSBCAPS_CTRLVOLUME :: 0x80 ;
DSBCAPS_GLOBALFOCUS :: 0x08000 ;
DSBCAPS_GETCURRENTPOSITION2 :: 0x10000 ;
DSBUFFERCAPS :: struct {
}
IDirectSound8 :: struct {
    using vtable : * IDirectSound8Vtable ;
}
IDirectSoundBuffer8 :: struct {
    using vtable : * IDirectSoundBuffer8Vtable ;
}
IDirectSoundBuffer8Vtable :: struct {
    using base : IUnknown_VTable ;
    GetCaps : ( buffer : * IDirectSoundBuffer8 , caps : * DSBUFFERCAPS ) #c_call ;
    GetCurrentPosition : ( buffer : * IDirectSoundBuffer8 , pdwCurrentPlayCursor : * s32 , pdwCurrentWriteCursor : * s32 ) -> s32 #c_call ;
    GetFormat : * void ;
    GetVolume : * void ;
    GetPan : * void ;
    GetFrequency : * void ;
    GetStatus : ( buffer : * IDirectSoundBuffer8 , pdwStatus : * s32 ) -> s32 #c_call ;
    Initialize : * void ;
    Lock : ( buffer : * IDirectSoundBuffer8 , dwOffset : s32 , dwBytes : s32 , pvAudioPtr1 : * * void , dwAudioBytes1 : * s32 , pvAudioPtr2 : * * void , dwAudioBytes2 : * s32 , dwFlags : s32 ) -> s32 #c_call ;
    Play : ( buffer : * IDirectSoundBuffer8 , dwReserved1 : s32 , dwPriority : s32 , dwFlags : s32 ) -> s32 #c_call ;
    SetCurrentPosition : * void ;
    SetFormat : ( buffer : * IDirectSoundBuffer8 , format : * Waveformatex ) -> s32 #c_call ;
    SetVolume : * void ;
    SetPan : * void ;
    SetFrequency : * void ;
    Stop : ( buffer : * IDirectSoundBuffer8 ) -> s32 #c_call ;
    Unlock : ( buffer : * IDirectSoundBuffer8 , pvAudioPtr1 : * void , dwAudioBytes1 : s32 , pvAudioPtr2 : * void , dwAudioBytes2 : s32 ) -> s32 #c_call ;
    Restore : ( buffer : * IDirectSoundBuffer8 ) -> s32 #c_call ;
    SetFX : * void ;
    AcquireResources : * void ;
    GetObjectInPath : * void ;
}
IDirectSound8Vtable :: struct {
    using base : IUnknown_VTable ;
    CreateSoundBuffer : ( dsound : * IDirectSound8 , desc : * DSBUFFERDESC , buffer : * * IDirectSoundBuffer8 , outer : * * void = null ) -> s32 #c_call ;
    GetCaps : * void ;
    DuplicateSoundBuffer : * void ;
    SetCooperativeLevel : ( dsound : * IDirectSound8 , hwnd : HWND , level : s32 ) -> s32 #c_call ;
    Compact : * void ;
    GetSpeakerConfig : ( dsound : * IDirectSound8 , config : * s32 ) -> s32 #c_call ;
    SetSpeakerConfig : * void ;
    Initialize : * void ;
}
WAVEFORMATEXTENSIBLE :: struct {
    Format : Waveformatex ;
    wValidBitsPerSample : s16 ;
    dwChannelMask : s32 ;
    SubFormat : GUID ;
}
DSBUFFERDESC :: struct {
    dwSize : s32 ;
    dwFlags : s32 ;
    dwBufferBytes : s32 ;
    dwReserved : s32 ;
    lpwfxFormat : * Waveformatex ;
    guid3DAlgorithm : GUID ;
}
init_wave_format :: ( using w : * Waveformatex , nchannels : s16 ) {
    w.nChannels = nchannels;
    w.wBitsPerSample = 16;
    w.wFormatTag = WAVE_FORMAT_PCM;
    w.nSamplesPerSec = OUTPUT_SAMPLING_RATE;
    w.nBlockAlign = nchannels * 2;
    w.nAvgBytesPerSec = w.nBlockAlign * w.nSamplesPerSec;
}
CONFIG :: ( speaker_config : s32 ) -> DSSPEAKER {
    lower_byte := cast(u32) speaker_config & 255;
    return cast(DSSPEAKER) lower_byte;
}
GEOMETRY :: ( speaker_config : s32 ) -> u8 {
    high_word := cast(u32) speaker_config >> 16;
    return cast(u8) (high_word & 255);
}
backend_init :: ( config : Sound_Player_Config ) -> Backend_Properties {
    properties: Backend_Properties;
    if dsound return properties;
    if Native_DirectSoundCreate8(null, *dsound, null) < 0 return properties;
    owner := GetActiveWindow();
    if !owner owner = GetDesktopWindow();
    if dsound.SetCooperativeLevel(dsound, owner, 2) < 0 { backend_shutdown(); return properties; }
    num_channels = 2;
    format: Waveformatex;
    init_wave_format(*format, cast(s16) num_channels);
    primary: DSBUFFERDESC;
    primary.dwSize = size_of(DSBUFFERDESC);
    primary.dwFlags = DSBCAPS_PRIMARYBUFFER;
    if dsound.CreateSoundBuffer(dsound, *primary, *primary_buffer, null) < 0 { backend_shutdown(); return properties; }
    if primary_buffer.SetFormat(primary_buffer, *format) < 0 { backend_shutdown(); return properties; }
    fill_buffer_size_in_bytes = FILL_BUFFER_SIZE_IN_SAMPLES*num_channels*BYTES_PER_SAMPLE;
    secondary: DSBUFFERDESC;
    secondary.dwSize = size_of(DSBUFFERDESC);
    secondary.dwFlags = DSBCAPS_GETCURRENTPOSITION2;
    if config.audible_when_window_is_not_in_focus secondary.dwFlags |= DSBCAPS_GLOBALFOCUS;
    secondary.dwBufferBytes = fill_buffer_size_in_bytes;
    secondary.lpwfxFormat = *format;
    if dsound.CreateSoundBuffer(dsound, *secondary, *fill_buffer, null) < 0 { backend_shutdown(); return properties; }
    first, second: *void;
    count0, count1: s32;
    if fill_buffer.Lock(fill_buffer, 0, fill_buffer_size_in_bytes, *first, *count0, *second, *count1, 0) < 0 { backend_shutdown(); return properties; }
    first_bytes := cast(*u8) first;
    second_bytes := cast(*u8) second;
    for byte: 0..count0-1 first_bytes[byte] = 0;
    for byte: 0..count1-1 second_bytes[byte] = 0;
    fill_buffer.Unlock(fill_buffer, first, count0, second, count1);
    my_write_cursor = 0;
    minimum_prebuffered_bytes = cast(s64) (OUTPUT_SAMPLING_RATE*max(0.01, config.seconds_to_fill_ahead))*num_channels*BYTES_PER_SAMPLE;
    array_add(*channel_names, "Front Left", "Front Right");
    properties.initted = true; properties.num_channels = num_channels;
    properties.output_sampling_rate = OUTPUT_SAMPLING_RATE; properties.channel_names = channel_names;
    return properties;
}
backend_play :: ( ) {
    if !fill_buffer return;
    status: s32;
    if fill_buffer.GetStatus(fill_buffer, *status) < 0 return;
    if (status & DSBSTATUS_BUFFERLOST) != 0 {
        if fill_buffer.Restore(fill_buffer) < 0 return;
    }
    playing = fill_buffer.Play(fill_buffer, 0, 0, DSBPLAY_LOOPING) == DS_OK;
}
backend_lock_fill_regions :: ( bytes_to_lock : s64 ) -> Fill_Region_Result , bool {
    result: Fill_Region_Result;
    if !fill_buffer || bytes_to_lock <= 0 return result, false;
    buffered, _ := backend_count_buffered_bytes();
    bytes := min(bytes_to_lock, max(0, fill_buffer_size_in_bytes-buffered-num_channels*BYTES_PER_SAMPLE));
    bytes -= bytes%(num_channels*BYTES_PER_SAMPLE);
    if bytes <= 0 return result, false;
    region0, region1: *void;
    count0, count1: s32;
    code := fill_buffer.Lock(fill_buffer, cast(s32) my_write_cursor, cast(s32) bytes,
        *region0, *count0, *region1, *count1, 0);
    if code < 0 return result, false;
    result.buffer0 = to_string(cast(*u8) region0, count0);
    result.buffer1 = to_string(cast(*u8) region1, count1);
    return result, true;
}
backend_release_fill_regions :: ( result : Fill_Region_Result ) {
    if !fill_buffer return;
    code := fill_buffer.Unlock(fill_buffer, result.buffer0.data, cast(s32) result.buffer0.count,
        result.buffer1.data, cast(s32) result.buffer1.count);
    if code == DS_OK my_write_cursor = (my_write_cursor+result.buffer0.count+result.buffer1.count)%fill_buffer_size_in_bytes;
}
backend_shutdown :: ( ) {
    if fill_buffer fill_buffer.Stop(fill_buffer);
    Native_DS_Release(fill_buffer); fill_buffer = null;
    Native_DS_Release(primary_buffer); primary_buffer = null;
    Native_DS_Release(dsound); dsound = null;
    array_free(channel_names); channel_names = .{};
    playing = false; num_channels = 0; my_write_cursor = 0;
}
get_bytes_between :: ( front : $ T , rear : T , buffer_len : T ) -> T {
    difference := front - rear;
    if difference < 0 difference += buffer_len;
    return difference;
}
backend_count_buffered_bytes :: ( ) -> ( currently_buffered : s64 , minimum_prebuffered : s64 ) {
    if !fill_buffer return 0, 0;
    play, safe: s32;
    if fill_buffer.GetCurrentPosition(fill_buffer, *play, *safe) < 0 return 0, minimum_prebuffered_bytes;
    queued := get_bytes_between(my_write_cursor, cast(s64) play, cast(s64) fill_buffer_size_in_bytes);
    unsafe := get_bytes_between(cast(s64) safe, cast(s64) play, cast(s64) fill_buffer_size_in_bytes);
    if queued < unsafe { my_write_cursor = safe; queued = unsafe; }
    return queued, max(minimum_prebuffered_bytes, unsafe+num_channels*BYTES_PER_SAMPLE);
}
backend_needs_async_update_from_main_thread :: ( ) -> bool {
    // DirectSound buffer writes are independent of the GUI message pump.
    return false;
}
Enumeration_Callback_Data :: struct {
    outer_context : #Context ;
    devices : [ .. ] Output_Device ;
}
backend_get_devices :: ( ) -> [ ] Output_Device {
    if enumerated_output_devices.count > 0 return enumerated_output_devices;
    state: Enumeration_Callback_Data;
    state.outer_context = context;
    if Native_DirectSoundEnumerateA(Native_DSEnum, *state) < 0 {
        for device: state.devices {
            free(device.name); for hint: device.hints free(hint); array_free(device.hints);
        }
        array_free(state.devices); return enumerated_output_devices;
    }
    enumerated_output_devices = state.devices;
    return enumerated_output_devices;
}
#scope_file
enumeration_proc :: ( guid : * GUID , Desc : * u8 , DrvName : * u8 , pContext : * void ) #c_call {
    if !pContext return;
    data := cast(*Enumeration_Callback_Data) pContext;
    push_context data.outer_context {
    device: Output_Device;
    count: s64 = 0;
    if Desc { while Desc[count] != 0 count += 1; device.name = copy_string(to_string(Desc, count)); }
    device.device_index = data.devices.count;
    if DrvName {
        count = 0; while DrvName[count] != 0 count += 1;
        device.hints = NewArray(1, string);
        device.hints[0] = copy_string(to_string(DrvName, count));
    }
    array_add(*data.devices, device);
    }
}
dsound_lib :: #system_library "dsound" ;
playing : bool ;
fill_buffer_size_in_bytes : s32 ;
minimum_prebuffered_bytes : s64 ;
num_channels : s32 ;
channel_names : [ .. ] string ;
my_write_cursor : s64 ;
dsound : * IDirectSound8 ;
primary_buffer : * IDirectSoundBuffer8 ;
fill_buffer : * IDirectSoundBuffer8 ;
enumerated_output_devices : [ .. ] Output_Device ;


#scope_file
Native_DirectSoundCreate8 :: (guid: *GUID, result: **IDirectSound8, outer: *IUnknown) -> s32 #foreign dsound_lib "DirectSoundCreate8";
Native_DSEnum_Callback :: #type (guid: *GUID, description: *u8, driver: *u8, data: *void) -> s32 #c_call;
Native_DirectSoundEnumerateA :: (callback: Native_DSEnum_Callback, data: *void) -> s32 #foreign dsound_lib "DirectSoundEnumerateA";
Native_DSEnum :: (guid: *GUID, description: *u8, driver: *u8, data: *void) -> s32 #c_call {
    enumeration_proc(guid, description, driver, data);
    return 1;
}
Native_DS_Release :: (object: *void) {
    if !object return;
    unknown := cast(*IUnknown) object;
    unknown.vtable.Release(unknown);
}
