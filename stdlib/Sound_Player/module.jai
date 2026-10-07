// Sound_Player mixes any number of playing sounds (16-bit PCM WAV, IMA ADPCM WAV and Ogg Vorbis)
// into the default output device, with per-category levels and listener-relative panning.
//
// Layout: load.jai turns files into Sound_Data, spatial.jai computes loudness and speaker gains,
// block_cache.jai decodes compressed sounds a block at a time, mixer.jai renders the live streams
// and runs the background worker, and os/*.jai talks to the platform's audio API.
//
// OFFLINE := true skips the platform device entirely: nothing is played, and the program pulls the
// mix itself with render_offline (useful for tests and for rendering to a file).
#module_parameters (MAX_SOUND_CATEGORIES := DEFAULT_MAX_SOUND_CATEGORIES, VERBOSE := false, OFFLINE := false, OFFLINE_CHANNELS := 2) {
    DEFAULT_MAX_SOUND_CATEGORIES :: 64;
}

#scope_module
#import "Basic";
#import "Math";
#import "Thread";
#import "Atomics";

#load "load.jai";
#load "spatial.jai";
#load "block_cache.jai";
#load "mixer.jai";

#if OFFLINE {
    #load "os/offline.jai";
} else #if OS == .WINDOWS {
    #load "os/win32.jai";
} else #if OS == .LINUX {
    #load "os/alsa.jai";
} else #if OS == .MACOS {
    #load "os/core_audio.jai";
} else #if OS == .ANDROID {
    #load "os/aaudio.jai";
} else {
    #load "os/offline.jai";
}

#scope_export

Audio_Channel :: enum u16 {
    FRONT_LEFT :: 0;
    FRONT_RIGHT :: 1;
    CENTER :: 2;
    SUBWOOFER :: 3;
    REAR_LEFT :: 4;
    REAR_RIGHT :: 5;
    EXTEND_LEFT :: 6;
    EXTEND_RIGHT :: 7;
}

ACHANNEL_MAX :: 8;
OUTPUT_CHANNELS_MAX :: ACHANNEL_MAX;
MAX_CHANNELS_PER_SOUND :: 8;

Sound_Category :: enum u32 {
    GENERAL_SFX :: 0;
    AMBIENCES :: 1;
    FOOTSTEPS :: 2;
    UI :: 3;
    MUSIC :: 4;
}

// Where a channel of a multichannel recording was meant to be heard.
Source_Direction :: enum u16 {
    MONO :: 0;
    LEFT :: 1;
    RIGHT :: 2;
    FRONT_LEFT :: 3;
    FRONT_RIGHT :: 4;
    REAR_LEFT :: 5;
    REAR_RIGHT :: 6;
    CENTER_FORWARD :: 7;
    SUBWOOFER_CENTER_FORWARD :: 8;
    EXTEND_LEFT :: 9;
    EXTEND_RIGHT :: 10;
}

NUM_SOURCE_DIRECTIONS :: 11;

SOUND_INNER_RADIUS_DEFAULT :: 10.0;
SOUND_OUTER_RADIUS_DEFAULT :: 150.0;

// When true (and the worker thread runs), compressed blocks are decoded on the worker instead of
// inside update().
CACHED_OGG_DECODE_THREADED :: true;

// One playing instance of a Sound_Data. Games own the identification and control fields and may
// change them between updates; the mixer reads them under its lock.
Sound_Stream :: struct {
    user_data_u64: u64;
    user_data_pointer: *void;
    manager_id: s64;
    entity_id: s64;
    sound_name: string;

    user_flags: enum u32 {
        REPEATING :: 0x1;
        SPATIALIZED :: 0x2;
        MUSIC :: 0x10;
        IS_FOOTSTEP :: 0x40;
        DO_NOT_KILL :: 0x80;
        PAUSED_DUE_TO_MENU :: 0x100;
        WAS_PAUSED_DUE_TO_MENU :: 0x200;
        AMBIENT :: 0x400;
    }

    num_channels: s32 = 2;
    sound_data: *Sound_Data;
    category: Sound_Category;

    // Loop region in frames; the end defaults to the length of the sound.
    repeat_start_position: s64;
    repeat_end_position: s64 = -1;

    universe_volume_scale := 1.0;
    user_volume_scale := 1.0;
    rate_scale := 1.0;

    // Position in source frames. Negative while a repeat's leading silence plays.
    play_cursor: float64 = 0;

    // Cleared by pre_entity_update; see post_entity_update.
    marked := false;
    // Set by every update when the stream is too far away or too quiet to hear.
    inaudible := false;

    position: Vector3;
    orientation: Quaternion;
    inner_radius := 0.5;
    outer_radius := 10.0;

    // Source frames advanced per output frame. `desired_rate` is recomputed from rate_scale on every
    // update; `current_rate` glides toward it while mixing.
    current_rate: float = 1;
    desired_rate: float = 1;

    voice: Voice; // Mixer bookkeeping.
}

Sound_Player_Config :: struct {
    update_from_a_thread := true; // Mix and decode on a background worker.
    audible_when_window_is_not_in_focus := false; // Honoured where the API has the notion (DirectSound).
    keep_sounds_alive_by_default := true; // If false, streams not marked each frame are stopped.
    seconds_to_fill_ahead := 2.4 / 60.0; // How much mixed audio the device is kept ahead by.
    set_async_thread_priority: () -> (); // Called once on the worker thread.
    release_asset: (stream: *Sound_Stream, data: *Sound_Data); // Called as each stream is freed.
}

Output_Device :: struct {
    name: string;
    hints: [] string;
    device_index: s64;
}

// Opens the output device. Returns true if it was already running.
sound_player_init :: (given_config: Sound_Player_Config) -> bool {
    if player.running return true;

    channels, rate, opened := output_open(given_config);
    if !opened return false;

    player.config = given_config;
    player.out_channels = min(channels, OUTPUT_CHANNELS_MAX);
    player.out_rate = rate;
    init(*player.lock, "Sound_Player");
    for *category_volume it.* = 1;
    update_listener(.{}, Quaternion_Identity);
    build_speaker_ring(player.out_channels);

    player.running = true;
    output_start();

    if given_config.update_from_a_thread && !start_worker() {
        log_error("Sound_Player: could not start the mixing thread.\n");
        sound_player_shutdown();
        return false;
    }
    return true;
}

// Stops the device and frees every stream (calling release_asset for each).
sound_player_shutdown :: () {
    if !player.running return;
    stop_worker(); // From here on nothing else touches the streams.

    lock(*player.lock);
    cancel_queued_decodes();
    for player.voices release_voice(it);
    array_reset(*player.voices);
    unlock(*player.lock);

    output_close();
    destroy(*player.lock);
    player.running = false;
}

get_devices :: () -> [] Output_Device {
    return output_devices();
}

get_audio_sampling_rate :: () -> s64 {
    return player.out_rate;
}

set_master_volume :: (value: float) {
    master_volume = value;
}

// A new stream for `data`, not yet playing. Returns null for data that was not loaded or that has
// an unsupported layout. Hand it to start_playing; the player frees it when it ends or is stopped.
make_stream :: (data: *Sound_Data, category := Sound_Category.GENERAL_SFX) -> *Sound_Stream {
    if !data || !data.loaded return null;

    cache: *Block_Cache;
    if data.type == {
        case .LINEAR_SAMPLE_ARRAY;
            if !data.samples || data.nchannels < 1 || data.nchannels > MAX_CHANNELS_PER_SOUND return null;
        case .OGG_COMPRESSED;
            cache = open_vorbis_cache(data);
            if !cache return null;
        case .ADPCM_COMPRESSED;
            cache = open_adpcm_cache(data);
            if !cache return null;
        case;
            return null;
    }

    stream := New(Sound_Stream);
    stream.sound_data = data;
    stream.sound_name = data.name;
    stream.category = category;
    stream.marked = true;
    stream.voice.cache = cache;
    stream.num_channels = cast(s32) ifx cache then cache.channels else data.nchannels;
    stream.repeat_end_position = stream_length(stream);
    if player.running stream.desired_rate = rate_for(stream);
    stream.current_rate = stream.desired_rate;
    return stream;
}

start_playing :: (stream: *Sound_Stream) {
    if !stream || !player.running return;
    lock(*player.lock);
    defer unlock(*player.lock);
    if array_find(player.voices, stream) return;
    refresh_voice(stream);
    array_add(*player.voices, stream);
}

set_repeating :: (stream: *Sound_Stream, repeating: bool) {
    if !stream return;
    guard := player.running;
    if guard lock(*player.lock);
    if repeating {
        stream.user_flags |= .REPEATING;
        stream.repeat_end_position = stream_length(stream);
    } else {
        stream.user_flags &= ~ .REPEATING;
    }
    if guard unlock(*player.lock);
}

stop_stream_abruptly :: (id: s64) {
    stop_where((s: *Sound_Stream, key: s64, data: *Sound_Data) -> bool {
        return s.entity_id == key;
    }, id);
}

stop_stream_abruptly :: (data: *Sound_Data) {
    stop_where((s: *Sound_Stream, key: s64, data: *Sound_Data) -> bool {
        return s.sound_data == data;
    }, 0, data);
}

stop_all_sounds_abruptly :: (manager_id: s64) {
    stop_where((s: *Sound_Stream, key: s64, data: *Sound_Data) -> bool {
        return s.manager_id == key;
    }, manager_id);
}

// The playing stream with these ids, or null.
find :: (entity_id: s64, manager_id: s64) -> *Sound_Stream {
    for player.voices if it.entity_id == entity_id && it.manager_id == manager_id return it;
    return null;
}

// The entity-update protocol: call pre_entity_update, set `marked` on every stream that should
// keep playing, then call post_entity_update. Unmarked streams are stopped unless
// keep_sounds_alive_by_default is set or they carry DO_NOT_KILL.
pre_entity_update :: () {
    if !player.running return;
    lock(*player.lock);
    for player.voices it.marked = false;
    unlock(*player.lock);
}

post_entity_update :: (dt: float) {
    if !player.running return;
    lock(*player.lock);
    defer unlock(*player.lock);
    reap := !player.config.keep_sounds_alive_by_default;
    index := 0;
    while index < player.voices.count {
        stream := player.voices[index];
        if reap && !stream.marked && !(stream.user_flags & .DO_NOT_KILL) {
            remove_voice_at(index);
            continue;
        }
        refresh_voice(stream);
        index += 1;
    }
}

// Call once per frame: applies changed stream parameters and, without a worker thread, also mixes.
update :: (dt := FLOAT32_INFINITY) {
    if !player.running return;
    lock(*player.lock);
    for player.voices refresh_voice(it);
    unlock(*player.lock);
    if !player.worker_running top_up_output();
}

samples_to_bytes :: (stream: *Sound_Stream, num_samples: s64) -> s64 {
    return num_samples * stream.sound_data.nchannels * size_of(s16);
}

// Streams that have been stopped but still wait for a background decode before they can be freed.
count_retired_decoders :: () -> s64 {
    return streams_waiting_on_decodes;
}

#scope_module

Player_State :: struct {
    running: bool;
    config: Sound_Player_Config;
    out_channels: s32;
    out_rate: s32;

    // Guards `voices`, every stream's fields while mixing, the block caches and the decode queue.
    lock: Mutex;
    voices: [..] *Sound_Stream;

    worker: Thread;
    worker_running: bool;
    worker_quit: bool;
    worker_wake: Semaphore;
}

player: Player_State;

master_volume: float = 1;
category_volume: [MAX_SOUND_CATEGORIES] float;

// Mixer-side state of a stream.
Voice :: struct {
    cache: *Block_Cache; // Null for sounds stored as plain samples.

    // Gains from source channel to output channel, flattened as [source * OUTPUT_CHANNELS_MAX + output].
    // `gain` is what the mixer applies, `aim` what the last update asked for, and `slope` the
    // per-frame step that walks one to the other without clicks.
    gain: [MAX_CHANNELS_PER_SOUND * OUTPUT_CHANNELS_MAX] float;
    aim: [MAX_CHANNELS_PER_SOUND * OUTPUT_CHANNELS_MAX] float;
    slope: [MAX_CHANNELS_PER_SOUND * OUTPUT_CHANNELS_MAX] float;
    gains_settled: bool; // False until the first update, which jumps straight to `aim`.
}

stream_length :: (stream: *Sound_Stream) -> s64 {
    if stream.voice.cache return stream.voice.cache.length;
    data := stream.sound_data;
    if data.nchannels == 0 return 0;
    return data.nsamples_times_nchannels / data.nchannels;
}

rate_for :: (stream: *Sound_Stream) -> float {
    if player.out_rate <= 0 return 1;
    source_rate := cast(float) stream.sound_data.sampling_rate;
    if stream.voice.cache source_rate = cast(float) stream.voice.cache.rate;
    return source_rate * stream.rate_scale / player.out_rate;
}

// Re-derives everything that depends on the game-controlled fields. Lock held.
refresh_voice :: (stream: *Sound_Stream) {
    if !stream.sound_data return;
    stream.desired_rate = rate_for(stream);
    aim_gains(stream);
    if stream.voice.cache keep_blocks_near_cursor(stream);
}

stop_where :: (matches: (s: *Sound_Stream, key: s64, data: *Sound_Data) -> bool, key: s64, data: *Sound_Data = null) {
    if !player.running return;
    lock(*player.lock);
    defer unlock(*player.lock);
    index := 0;
    while index < player.voices.count {
        if matches(player.voices[index], key, data) remove_voice_at(index);
        else index += 1;
    }
}

remove_voice_at :: (index: s64) {
    stream := player.voices[index];
    array_unordered_remove_by_index(*player.voices, index);
    release_voice(stream);
}

// Frees a stream that left the live list. A stream whose blocks are still being decoded is parked
// on its cache and freed by the worker when the last decode lands. Lock held.
release_voice :: (stream: *Sound_Stream) {
    cache := stream.voice.cache;
    stream.voice.cache = null;
    if cache && cache.in_flight > 0 {
        cache.parked_stream = stream;
        streams_waiting_on_decodes += 1;
        return;
    }
    if cache close_block_cache(cache);
    give_back(stream);
}

give_back :: (stream: *Sound_Stream) {
    if player.config.release_asset player.config.release_asset(stream, stream.sound_data);
    free(stream);
}

streams_waiting_on_decodes: s64;
