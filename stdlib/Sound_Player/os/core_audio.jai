// macOS output through the default-output AudioUnit. Core Audio pulls samples from its own
// real-time thread, so the mix is staged in a single-producer/single-consumer ring: we append
// at `produced`, the render callback consumes at `consumed`. Both only ever grow; their
// difference is what is queued, and modulo the capacity they are positions in the ring.

#scope_module

output_open :: (config: Sound_Player_Config) -> channels: s32, rate: s32, ok: bool {
    if unit return 0, 0, false;
    wanted: Component_Description;
    wanted.kind = FOUR_CC_AUOU;
    wanted.subkind = FOUR_CC_DEF_;
    wanted.manufacturer = FOUR_CC_APPL;
    component := AudioComponentFindNext(null, *wanted);
    if !component || failed("create the output unit", AudioComponentInstanceNew(component, *unit)) {
        unit = null;
        return 0, 0, false;
    }

    format: Stream_Format;
    format.sample_rate = CA_RATE;
    format.format_id = FOUR_CC_LPCM;
    format.format_flags = FORMAT_SIGNED_INTEGER | FORMAT_PACKED;
    format.bytes_per_packet = CA_FRAME_BYTES;
    format.frames_per_packet = 1;
    format.bytes_per_frame = CA_FRAME_BYTES;
    format.channels = CA_CHANNELS;
    format.bits_per_channel = 16;

    callback := Render_Callback.{ pull_samples, null };
    if failed("set the stream format", AudioUnitSetProperty(unit, PROPERTY_STREAM_FORMAT, SCOPE_INPUT, 0, *format, size_of(Stream_Format)))
    || failed("install the render callback", AudioUnitSetProperty(unit, PROPERTY_RENDER_CALLBACK, SCOPE_INPUT, 0, *callback, size_of(Render_Callback)))
    || failed("initialize the output unit", AudioUnitInitialize(unit)) {
        output_close();
        return 0, 0, false;
    }
    produced = 0;
    consumed = 0;
    return CA_CHANNELS, CA_RATE, true;
}

output_start :: () {
    if unit failed("start playback", AudioOutputUnitStart(unit));
}

output_close :: () {
    if !unit return;
    AudioOutputUnitStop(unit);
    AudioUnitUninitialize(unit);
    AudioComponentInstanceDispose(unit);
    unit = null;
}

output_frames_queued :: () -> queued: s64, at_least: s64 {
    if !unit return S64_MAX, 0;
    return atomic_read(*produced) - atomic_read(*consumed), 0;
}

output_write :: (frames: s64) {
    if !unit return;
    head := atomic_read(*produced);
    free_frames := RING_FRAMES - (head - atomic_read(*consumed));
    count := min(frames, free_frames);
    while count > 0 {
        start := head % RING_FRAMES;
        span := min(count, RING_FRAMES - start);
        view: [] s16;
        view.data = ring.data + start * CA_CHANNELS;
        view.count = span * CA_CHANNELS;
        mix_into(view);
        head += span;
        count -= span;
    }
    atomic_write(*produced, head); // Publish only after the samples are in place.
}

output_devices :: () -> [] Output_Device {
    if listed_devices.count return listed_devices;
    ids_address := Property_Address.{ FOUR_CC_DEV_, FOUR_CC_GLOB, 0 };
    bytes: u32;
    if AudioObjectGetPropertyDataSize(SYSTEM_OBJECT, *ids_address, 0, null, *bytes) != 0 || bytes == 0 return listed_devices;
    ids := NewArray(bytes / size_of(u32), u32);
    defer array_free(ids);
    if AudioObjectGetPropertyData(SYSTEM_OBJECT, *ids_address, 0, null, *bytes, ids.data) != 0 return listed_devices;

    for id: ids {
        if output_channel_count(id) == 0 continue;
        name_address := Property_Address.{ FOUR_CC_LNAM, FOUR_CC_GLOB, 0 };
        name: CFStringRef;
        name_bytes: u32 = size_of(CFStringRef);
        if AudioObjectGetPropertyData(id, *name_address, 0, null, *name_bytes, *name) != 0 || !name continue;
        device: Output_Device;
        device.name = to_string(name);
        device.device_index = id;
        CFRelease(name);
        array_add(*listed_devices, device);
    }
    return listed_devices;
}

#scope_file
#import "macos";

CA_RATE :: 44100;
CA_CHANNELS :: 2;
CA_FRAME_BYTES :: CA_CHANNELS * size_of(s16);
RING_FRAMES :: 16384;

unit: *Opaque;
ring: [RING_FRAMES * CA_CHANNELS] s16;
produced: s64; // Total frames written into the ring.
consumed: s64; // Total frames the callback has taken.
listed_devices: [..] Output_Device;

// Runs on Core Audio's thread: no allocation, no locks, no context.
pull_samples :: (user: *void, flags: *u32, timestamp: *void, bus: u32, frames: u32, data: *Buffer_List) -> s32 #c_call {
    if !data || data.count != 1 return -50;
    target := data.buffers[0];
    out := cast(*s16) target.data;
    if !out return -50;
    wanted := cast(s64) frames;
    if wanted > target.bytes / CA_FRAME_BYTES wanted = target.bytes / CA_FRAME_BYTES;

    tail := atomic_read(*consumed);
    available := atomic_read(*produced) - tail;
    if available > wanted available = wanted;
    for frame: 0..available - 1 {
        source := ((tail + frame) % RING_FRAMES) * CA_CHANNELS;
        for channel: 0..CA_CHANNELS - 1 out[frame * CA_CHANNELS + channel] = ring[source + channel];
    }
    // Underrun: pad with silence rather than replaying stale samples.
    for value: available * CA_CHANNELS..wanted * CA_CHANNELS - 1 out[value] = 0;
    // Only this callback moves `consumed`, so the exchange always succeeds; it is there for its
    // ordering (atomic_write would need a context).
    compare_and_swap(*consumed, tail, tail + available);
    if available == 0 && flags flags.* |= RENDER_OUTPUT_IS_SILENCE;
    return 0;
}

output_channel_count :: (id: u32) -> s64 {
    address := Property_Address.{ FOUR_CC_SLAY, FOUR_CC_OUTP, 0 };
    bytes: u32;
    if AudioObjectGetPropertyDataSize(id, *address, 0, null, *bytes) != 0 || bytes < size_of(Buffer_List) return 0;
    list := cast(*Buffer_List) alloc(bytes);
    defer free(list);
    if AudioObjectGetPropertyData(id, *address, 0, null, *bytes, list) != 0 return 0;
    // The struct declares one buffer; more follow it in memory.
    buffers := list.buffers.data;
    room := (cast(s64) bytes - 8) / size_of(Audio_Buffer);
    total := 0;
    for 0..min(cast(s64) list.count, room) - 1 total += buffers[it].channels;
    return total;
}

failed :: (what: string, status: s32) -> bool {
    if status == 0 return false;
    log_error("Sound_Player: Core Audio could not % (status %).\n", what, status);
    return true;
}

// Declarations for the AudioToolbox / CoreAudio calls used above.
Opaque :: struct {}

four_cc :: (text: string) -> u32 {
    return ((cast(u32) text[0]) << 24) | ((cast(u32) text[1]) << 16) | ((cast(u32) text[2]) << 8) | cast(u32) text[3];
}
FOUR_CC_AUOU :: #run four_cc("auou"); // Output unit type.
FOUR_CC_DEF_ :: #run four_cc("def "); // Default output subtype.
FOUR_CC_APPL :: #run four_cc("appl");
FOUR_CC_LPCM :: #run four_cc("lpcm");
FOUR_CC_DEV_ :: #run four_cc("dev#"); // Device list.
FOUR_CC_GLOB :: #run four_cc("glob");
FOUR_CC_OUTP :: #run four_cc("outp");
FOUR_CC_SLAY :: #run four_cc("slay"); // Stream configuration.
FOUR_CC_LNAM :: #run four_cc("lnam"); // Device name.

SYSTEM_OBJECT :: 1;
FORMAT_SIGNED_INTEGER :: 0x4;
FORMAT_PACKED :: 0x8;
PROPERTY_STREAM_FORMAT :: 8;
PROPERTY_RENDER_CALLBACK :: 23;
SCOPE_INPUT :: 1;
RENDER_OUTPUT_IS_SILENCE :: 0x10;

Component_Description :: struct {
    kind: u32;
    subkind: u32;
    manufacturer: u32;
    flags: u32;
    flags_mask: u32;
}

Stream_Format :: struct {
    sample_rate: float64;
    format_id: u32;
    format_flags: u32;
    bytes_per_packet: u32;
    frames_per_packet: u32;
    bytes_per_frame: u32;
    channels: u32;
    bits_per_channel: u32;
    reserved: u32;
}

Render_Callback :: struct {
    procedure: (user: *void, flags: *u32, timestamp: *void, bus: u32, frames: u32, data: *Buffer_List) -> s32 #c_call;
    user: *void;
}

Audio_Buffer :: struct {
    channels: u32;
    bytes: u32;
    data: *void;
}

Buffer_List :: struct {
    count: u32;
    buffers: [1] Audio_Buffer;
}

Property_Address :: struct {
    selector: u32;
    scope: u32;
    element: u32;
}

AudioToolbox :: #system_library "AudioToolbox";
CoreAudio :: #system_library "CoreAudio";

AudioComponentFindNext :: (after: *Opaque, description: *Component_Description) -> *Opaque #foreign AudioToolbox;
AudioComponentInstanceNew :: (component: *Opaque, instance: **Opaque) -> s32 #foreign AudioToolbox;
AudioComponentInstanceDispose :: (instance: *Opaque) -> s32 #foreign AudioToolbox;
AudioUnitSetProperty :: (instance: *Opaque, property: u32, scope: u32, element: u32, data: *void, bytes: u32) -> s32 #foreign AudioToolbox;
AudioUnitInitialize :: (instance: *Opaque) -> s32 #foreign AudioToolbox;
AudioUnitUninitialize :: (instance: *Opaque) -> s32 #foreign AudioToolbox;
AudioOutputUnitStart :: (instance: *Opaque) -> s32 #foreign AudioToolbox;
AudioOutputUnitStop :: (instance: *Opaque) -> s32 #foreign AudioToolbox;
AudioObjectGetPropertyDataSize :: (object: u32, address: *Property_Address, qualifier_bytes: u32, qualifier: *void, bytes: *u32) -> s32 #foreign CoreAudio;
AudioObjectGetPropertyData :: (object: u32, address: *Property_Address, qualifier_bytes: u32, qualifier: *void, bytes: *u32, data: *void) -> s32 #foreign CoreAudio;
