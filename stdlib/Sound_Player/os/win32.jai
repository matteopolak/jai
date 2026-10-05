// Windows output through DirectSound: one looping secondary buffer used as a ring. We remember
// where our own writing stopped; DirectSound reports where playback is and how far ahead of it
// is still unsafe to touch.

#scope_module

output_open :: (config: Sound_Player_Config) -> channels: s32, rate: s32, ok: bool {
    if device return 0, 0, false;
    if DirectSoundCreate8(null, *device, null) < 0 {
        device = null;
        log_error("Sound_Player: DirectSound is not available.\n");
        return 0, 0, false;
    }
    window := GetActiveWindow();
    if !window window = GetDesktopWindow();
    if device.vtable.SetCooperativeLevel(device, window, DSSCL_NORMAL) < 0 {
        output_close();
        return 0, 0, false;
    }

    format: Waveformatex;
    format.wFormatTag      = WAVE_FORMAT_PCM;
    format.nChannels       = DS_CHANNELS;
    format.nSamplesPerSec  = DS_RATE;
    format.wBitsPerSample  = 16;
    format.nBlockAlign     = DS_FRAME_BYTES;
    format.nAvgBytesPerSec = DS_RATE * DS_FRAME_BYTES;

    description: Buffer_Description;
    description.size         = size_of(Buffer_Description);
    description.flags        = DSBCAPS_GETCURRENTPOSITION2;
    description.buffer_bytes = RING_BYTES;
    description.format       = *format;
    if config.audible_when_window_is_not_in_focus description.flags |= DSBCAPS_GLOBALFOCUS;
    if device.vtable.CreateSoundBuffer(device, *description, *ring, null) < 0 {
        log_error("Sound_Player: DirectSound refused the output buffer.\n");
        output_close();
        return 0, 0, false;
    }

    // Start from silence; the buffer's initial contents are undefined.
    first, second: *void;
    first_bytes, second_bytes: u32;
    if ring.vtable.Lock(ring, 0, RING_BYTES, *first, *first_bytes, *second, *second_bytes, 0) >= 0 {
        memset(first, 0, first_bytes);
        if second memset(second, 0, second_bytes);
        ring.vtable.Unlock(ring, first, first_bytes, second, second_bytes);
    }
    written_up_to = 0;
    return DS_CHANNELS, DS_RATE, true;
}

output_start :: () {
    if !ring return;
    status: u32;
    if ring.vtable.GetStatus(ring, *status) >= 0 && (status & DSBSTATUS_BUFFERLOST) != 0 ring.vtable.Restore(ring);
    ring.vtable.Play(ring, 0, 0, DSBPLAY_LOOPING);
}

output_close :: () {
    if ring {
        ring.vtable.Stop(ring);
        release_com(ring);
        ring = null;
    }
    if device {
        release_com(device);
        device = null;
    }
}

output_frames_queued :: () -> queued: s64, at_least: s64 {
    if !ring return S64_MAX, 0;
    play, safe: u32;
    if ring.vtable.GetCurrentPosition(ring, *play, *safe) < 0 return S64_MAX, 0;
    ours := ring_distance(written_up_to, play);
    unsafe := ring_distance(safe, play);
    // If playback overtook us, continue from the first position that is safe to write.
    if ours < unsafe {
        written_up_to = safe;
        ours = unsafe;
    }
    return ours / DS_FRAME_BYTES, unsafe / DS_FRAME_BYTES + 1;
}

output_write :: (frames: s64) {
    if !ring return;
    queued, _ := output_frames_queued();
    room := (RING_BYTES / DS_FRAME_BYTES) - queued - 1;
    count := min(frames, room);
    if count <= 0 return;

    first, second: *void;
    first_bytes, second_bytes: u32;
    if ring.vtable.Lock(ring, cast(u32) written_up_to, cast(u32) (count * DS_FRAME_BYTES), *first, *first_bytes, *second, *second_bytes, 0) < 0 return;
    mix_into(as_samples(first, first_bytes));
    if second mix_into(as_samples(second, second_bytes));
    if ring.vtable.Unlock(ring, first, first_bytes, second, second_bytes) >= 0 {
        written_up_to = (written_up_to + first_bytes + second_bytes) % RING_BYTES;
    }
}

output_devices :: () -> [] Output_Device {
    if listed_devices.count return listed_devices;
    gathered: Device_Gathering;
    gathered.caller_context = context;
    DirectSoundEnumerateA(on_device_found, *gathered);
    listed_devices = gathered.devices;
    return listed_devices;
}

#scope_file
#import "Windows";
#import "Wav_File";

DS_RATE        :: 44100;
DS_CHANNELS    :: 2;
DS_FRAME_BYTES :: DS_CHANNELS * size_of(s16);
RING_BYTES     :: 24000 * DS_FRAME_BYTES;   // A bit over half a second.

device: *Direct_Sound;
ring: *Sound_Buffer;
written_up_to: s64;   // Byte offset in the ring where the next write goes.
listed_devices: [..] Output_Device;

ring_distance :: (ahead: s64, behind: s64) -> s64 {
    d := ahead - behind;
    if d < 0 d += RING_BYTES;
    return d;
}

as_samples :: (memory: *void, bytes: u32) -> [] s16 {
    view: [] s16;
    view.data = cast(*s16) memory;
    view.count = bytes / size_of(s16);
    return view;
}

release_com :: (object: *void) {
    unknown := cast(*IUnknown) object;
    unknown.vtable.Release(unknown);
}

Device_Gathering :: struct {
    caller_context: #Context;
    devices: [..] Output_Device;
}

on_device_found :: (guid: *GUID, description: *u8, module_name: *u8, user: *void) -> s32 #c_call {
    gathered := cast(*Device_Gathering) user;
    push_context gathered.caller_context {
        device: Output_Device;
        device.device_index = gathered.devices.count;
        if description device.name = copy_string(to_string(description));
        if module_name {
            device.hints = NewArray(1, string);
            device.hints[0] = copy_string(to_string(module_name));
        }
        array_add(*gathered.devices, device);
    }
    return 1;   // Keep enumerating.
}

// DirectSound declarations. Only the methods we call are typed; `skipN` arrays stand in for the
// methods between them so the vtable offsets stay right.
DSSCL_NORMAL                :: 1;
DSBCAPS_GLOBALFOCUS         :: 0x8000;
DSBCAPS_GETCURRENTPOSITION2 :: 0x10000;
DSBPLAY_LOOPING             :: 1;
DSBSTATUS_BUFFERLOST        :: 2;

Buffer_Description :: struct {
    size:         u32;
    flags:        u32;
    buffer_bytes: u32;
    reserved:     u32;
    format:       *Waveformatex;
    algorithm_3d: GUID;
}

Direct_Sound :: struct { vtable: *Direct_Sound_Calls; }
Direct_Sound_Calls :: struct {
    using unknown: IUnknown_VTable;
    CreateSoundBuffer:   (self: *Direct_Sound, description: *Buffer_Description, buffer: **Sound_Buffer, outer: *void) -> HRESULT #c_call;
    skip1:               [2] *void;
    SetCooperativeLevel: (self: *Direct_Sound, window: HWND, level: u32) -> HRESULT #c_call;
    skip2:               [5] *void;
}

Sound_Buffer :: struct { vtable: *Sound_Buffer_Calls; }
Sound_Buffer_Calls :: struct {
    using unknown: IUnknown_VTable;
    skip1:              [1] *void;
    GetCurrentPosition: (self: *Sound_Buffer, play: *u32, write: *u32) -> HRESULT #c_call;
    skip2:              [4] *void;
    GetStatus:          (self: *Sound_Buffer, status: *u32) -> HRESULT #c_call;
    skip3:              [1] *void;
    Lock:               (self: *Sound_Buffer, offset: u32, bytes: u32, first: **void, first_bytes: *u32, second: **void, second_bytes: *u32, flags: u32) -> HRESULT #c_call;
    Play:               (self: *Sound_Buffer, reserved: u32, priority: u32, flags: u32) -> HRESULT #c_call;
    skip4:              [5] *void;
    Stop:               (self: *Sound_Buffer) -> HRESULT #c_call;
    Unlock:             (self: *Sound_Buffer, first: *void, first_bytes: u32, second: *void, second_bytes: u32) -> HRESULT #c_call;
    Restore:            (self: *Sound_Buffer) -> HRESULT #c_call;
}

dsound :: #system_library "dsound";
DirectSoundCreate8    :: (device_guid: *GUID, result: **Direct_Sound, outer: *void) -> HRESULT #foreign dsound;
DirectSoundEnumerateA :: (callback: (guid: *GUID, description: *u8, module_name: *u8, user: *void) -> s32 #c_call, user: *void) -> HRESULT #foreign dsound;
