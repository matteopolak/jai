// Independently normalized ABI contract. No reference procedure bodies or binaries.
#module_parameters ( MAX_SOUND_CATEGORIES := DEFAULT_MAX_SOUND_CATEGORIES , VERBOSE := false ) {
    DEFAULT_MAX_SOUND_CATEGORIES :: 64 ;
}
#load "load.jai" ;
#load "async.jai" ;
#load "cached_decoder.jai" ;
Audio_Channel :: enum u16 {
    FRONT_LEFT :: 0 ;
    FRONT_RIGHT :: 1 ;
    CENTER :: 2 ;
    SUBWOOFER :: 3 ;
    REAR_LEFT :: 4 ;
    REAR_RIGHT :: 5 ;
    EXTEND_LEFT :: 6 ;
    EXTEND_RIGHT :: 7 ;
}
ACHANNEL_MAX :: 8 ;
OUTPUT_CHANNELS_MAX :: ACHANNEL_MAX ;
MAX_CHANNELS_PER_SOUND :: 8 ;
Sound_Category :: enum u32 {
    GENERAL_SFX :: 0 ;
    AMBIENCES :: 1 ;
    FOOTSTEPS :: 2 ;
    UI :: 3 ;
    MUSIC :: 4 ;
}
Source_Direction :: enum u16 {
    MONO :: 0 ;
    LEFT :: 1 ;
    RIGHT :: 2 ;
    FRONT_LEFT :: 3 ;
    FRONT_RIGHT :: 4 ;
    REAR_LEFT :: 5 ;
    REAR_RIGHT :: 6 ;
    CENTER_FORWARD :: 7 ;
    SUBWOOFER_CENTER_FORWARD :: 8 ;
    EXTEND_LEFT :: 9 ;
    EXTEND_RIGHT :: 10 ;
}
NUM_SOURCE_DIRECTIONS :: 11 ;
SOUND_INNER_RADIUS_DEFAULT :: 10.0 ;
SOUND_OUTER_RADIUS_DEFAULT :: 150.0 ;
CACHED_OGG_DECODE_THREADED :: true ;
Scale_Mapping :: struct {
    source_scale_for_this_output_index : [ OUTPUT_CHANNELS_MAX ] float ;
    interpolated_source_scale_for_this_output_index : [ OUTPUT_CHANNELS_MAX ] float ;
    dvolume_dsample : [ OUTPUT_CHANNELS_MAX ] float ;
}
Sound_Stream :: struct {
    user_data_u64 : u64 ;
    user_data_pointer : * void ;
    manager_id : s64 ;
    entity_id : s64 ;
    sound_name : string ;
    user_flags : enum u32 {
        REPEATING :: 0x1 ;
        SPATIALIZED :: 0x2 ;
        MUSIC :: 0x10 ;
        IS_FOOTSTEP :: 0x40 ;
        DO_NOT_KILL :: 0x80 ;
        PAUSED_DUE_TO_MENU :: 0x100 ;
        WAS_PAUSED_DUE_TO_MENU :: 0x200 ;
        AMBIENT :: 0x400 ;
    }
    internal_flags : enum u32 {
        FIRST_VOLUME_UPDATE :: 0x2 ;
        WAITING_FOR_INITIAL_DECODER_PAGES :: 0x4 ;
        FADING_OUT :: 0x8 ;
    }
    num_channels : s32 = 2 ;
    sound_data : * Sound_Data ;
    decoder : * Cached_Decoder ;
    category : Sound_Category ;
    repeat_start_position : s64 ;
    repeat_end_position : s64 = - 1 ;
    universe_volume_scale := 1.0 ;
    user_volume_scale := 1.0 ;
    play_cursor : float64 = 0 ;
    silent_samples_at_start_of_play : s64 = 0 ;
    marked := false ;
    inaudible := false ;
    position : Vector3 ;
    orientation : Quaternion ;
    inner_radius := 0.5 ;
    outer_radius := 10.0 ;
    rate_scale := 1.0 ;
    samples_streamed_since_entity_update : s64 ;
    max_gain : float ;
    last_plane_dir : Vector2 ;
    debug_display_volume : float = 0 ;
    silent_this_frame := false ;
    debug_watch := false ;
    current_rate : float = 1 ;
    desired_rate : float = 1 ;
    input_scale_mappings : [ MAX_CHANNELS_PER_SOUND ] Scale_Mapping ;
    initial_samples_fetched : s64 ;
    samples_needed_to_start_playing : s64 ;
}
;
Backend_Properties :: struct {
    initted := false ;
    num_channels : s32 ;
    channel_names : [ ] string ;
    output_sampling_rate : s32 ;
}
perceptual_to_linear :: ( x : float ) -> float {
    return pow(x, 1.660964047443681);
}
retired_decoders : [ .. ] * Cached_Decoder ;
SECONDS_TO_FETCH_OGG :: 0.4 ;
SECONDS_TO_FETCH_ADPCM :: 0.4 ;
VERY_CLOSE :: 4.0 ;
vbap_speaker_directions : [ ACHANNEL_MAX ] Vector2 ;
vbap_source_directions : [ NUM_SOURCE_DIRECTIONS ] Vector2 ;
ROOT_2_OVER_2 : float : 0.7071067 ;
Vbap_Arc :: struct {
    speaker1 : Audio_Channel ;
    speaker2 : Audio_Channel ;
    l_inverse : Matrix2 ;
}
arcs_6ch := Vbap_Arc .[ .{
    . CENTER , . FRONT_LEFT , .{
    }
}
, .{
    . FRONT_LEFT , . REAR_LEFT , .{
    }
}
, .{
    . REAR_LEFT , . REAR_RIGHT , .{
    }
}
, .{
    . REAR_RIGHT , . FRONT_RIGHT , .{
    }
}
, .{
    . FRONT_RIGHT , . CENTER , .{
    }
}
] ;
arcs_8ch := Vbap_Arc .[ .{
    . CENTER , . FRONT_LEFT , .{
    }
}
, .{
    . FRONT_LEFT , . REAR_LEFT , .{
    }
}
, .{
    . REAR_LEFT , . EXTEND_LEFT , .{
    }
}
, .{
    . EXTEND_LEFT , . EXTEND_RIGHT , .{
    }
}
, .{
    . EXTEND_RIGHT , . REAR_RIGHT , .{
    }
}
, .{
    . REAR_RIGHT , . FRONT_RIGHT , .{
    }
}
, .{
    . FRONT_RIGHT , . CENTER , .{
    }
}
] ;
arcs : [ ] Vbap_Arc ;
count_retired_decoders :: ( ) -> s64 {
    number := retired_decoders.count;
    return number;
}
invert :: ( using m : * Matrix2 , result : * Matrix2 ) {
    determinant := m._11*m._22-m._12*m._21;
    assert(abs(determinant) > 0.0000001);
    inverse: Matrix2;
    inverse._11 = m._22 / determinant;
    inverse._12 = -m._12 / determinant;
    inverse._21 = -m._21 / determinant;
    inverse._22 = m._11 / determinant;
    result.* = inverse;
}
clear_scale_accumulation :: ( stream : * Sound_Stream , index : s64 ) {
    assert(index >= 0 && index < MAX_CHANNELS_PER_SOUND);
    channel: s64 = 0;
    while channel < OUTPUT_CHANNELS_MAX {
        stream.input_scale_mappings[index].source_scale_for_this_output_index[channel] = 0;
        channel += 1;
    }
}
get_target_2_closeness :: ( stream : * Sound_Stream ) -> float {
    if (stream.user_flags & .SPATIALIZED) == 0 return 0;
    distance := length(stream.position-listener_position);
    return clamp(1.0-distance/VERY_CLOSE, 0.0, 1.0);
}
adjust_stereo_dots_by_closeness :: ( dot_left : * float , dot_right : * float , closeness : float ) {
    amount := clamp(closeness, 0.0, 1.0);
    dot_left.* = dot_left.* * (1.0-amount) + 0.5*amount;
    dot_right.* = dot_right.* * (1.0-amount) + 0.5*amount;
}
accum_scale_target_2_source_mono :: ( stream : * Sound_Stream , plane_dir : Vector2 , gain_scale : float , target : * Scale_Mapping ) {
    pan := clamp(plane_dir.y, -1.0, 1.0);
    left := 0.5*(1.0+pan);
    right := 1.0-left;
    adjust_stereo_dots_by_closeness(*left, *right, get_target_2_closeness(stream));
    target.source_scale_for_this_output_index[0] += sqrt(max(left, 0.0))*gain_scale;
    if backend.num_channels > 1 target.source_scale_for_this_output_index[1] += sqrt(max(right, 0.0))*gain_scale;
}
accum_scale_target_2_source_n :: ( stream : * Sound_Stream , plane_dir : Vector2 , n : s64 , gain_scale : float ) {
    assert(n >= 0 && n < MAX_CHANNELS_PER_SOUND);
    accum_scale_target_2_source_mono(stream, plane_dir, gain_scale, *stream.input_scale_mappings[n]);
}
add_vbap_gain_for_direction :: ( target : * Scale_Mapping , plane_dir : Vector2 , gain_scale : float ) {
    direction := normalize(plane_dir, 0.000001, Vector2.{1,0});
    for arc: arcs {
        first := arc.l_inverse._11*direction.x+arc.l_inverse._12*direction.y;
        second := arc.l_inverse._21*direction.x+arc.l_inverse._22*direction.y;
        if first < -0.00001 || second < -0.00001 continue;
        denominator := sqrt(first*first+second*second);
        if denominator <= 0 return;
        target.source_scale_for_this_output_index[cast(s64) arc.speaker1] += max(first,0.0)*gain_scale/denominator;
        target.source_scale_for_this_output_index[cast(s64) arc.speaker2] += max(second,0.0)*gain_scale/denominator;
        return;
    }
    if backend.num_channels > 0 target.source_scale_for_this_output_index[0] += gain_scale;
}
skip_this_output_channel :: ( index : Audio_Channel , stream : * Sound_Stream ) -> bool {
    if cast(s64) index >= backend.num_channels return true;
    return index == .SUBWOOFER && (stream.user_flags & .MUSIC) == 0;
}
accum_scale_target_all_source_mono :: ( stream : * Sound_Stream , plane_dir : Vector2 , gain_scale : float , target : * Scale_Mapping ) {
    if backend.num_channels <= 2 { accum_scale_target_2_source_mono(stream, plane_dir, gain_scale, target); return; }
    add_vbap_gain_for_direction(target, plane_dir, gain_scale);
}
accum_scale_target_all_source_n :: ( stream : * Sound_Stream , plane_dir : Vector2 , n : s64 , gain_scale : float ) {
    assert(n >= 0 && n < MAX_CHANNELS_PER_SOUND);
    accum_scale_target_all_source_mono(stream, plane_dir, gain_scale, *stream.input_scale_mappings[n]);
}
get_plane_dir :: ( stream : * Sound_Stream , position : Vector3 ) -> Vector2 {
    difference := position-listener_position;
    direction: Vector2 = .{dot(difference, listener_forward), dot(difference, listener_left)};
    return normalize(direction, 0.000001, Vector2.{1,0});
}
source_dir_to_target_dir :: ( source_dir_index : Source_Direction ) -> Audio_Channel , success := true {
    if source_dir_index == .LEFT || source_dir_index == .FRONT_LEFT return .FRONT_LEFT, true;
    if source_dir_index == .RIGHT || source_dir_index == .FRONT_RIGHT return .FRONT_RIGHT, true;
    if source_dir_index == .REAR_LEFT return .REAR_LEFT, true;
    if source_dir_index == .REAR_RIGHT return .REAR_RIGHT, true;
    if source_dir_index == .CENTER_FORWARD return .CENTER, true;
    if source_dir_index == .SUBWOOFER_CENTER_FORWARD return .SUBWOOFER, true;
    if source_dir_index == .EXTEND_LEFT return .EXTEND_LEFT, true;
    if source_dir_index == .EXTEND_RIGHT return .EXTEND_RIGHT, true;
    return .CENTER, false;
}
update_panning_helper_for_many_channel_music :: ( stream : * Sound_Stream , gain_scale : float ) {
    for channel: 0..stream.num_channels-1 {
        source := stream.sound_data.source_directions[channel];
        target, mapped := source_dir_to_target_dir(source);
        if mapped && cast(s64) target < backend.num_channels {
            stream.input_scale_mappings[channel].source_scale_for_this_output_index[cast(s64) target] += gain_scale;
        } else if source == .SUBWOOFER_CENTER_FORWARD {
            stream.input_scale_mappings[channel].source_scale_for_this_output_index[0] += gain_scale*0.5;
            if backend.num_channels > 1 stream.input_scale_mappings[channel].source_scale_for_this_output_index[1] += gain_scale*0.5;
        } else {
            direction := vbap_source_directions[cast(s64) source];
            accum_scale_target_all_source_n(stream, direction, channel, gain_scale);
        }
    }
}
update_panning_helper_for_locked_output :: ( stream : * Sound_Stream , gain_scale : float ) {
    update_panning_helper_for_many_channel_music(stream, gain_scale);
}
update_panning_helper :: ( stream : * Sound_Stream , gain_scale : float ) {
    if (stream.user_flags & .SPATIALIZED) == 0 {
        update_panning_helper_for_locked_output(stream, gain_scale); return;
    }
    central := get_plane_dir(stream, stream.position);
    stream.last_plane_dir = central;
    for channel: 0..stream.num_channels-1 {
        direction := central;
        if stream.num_channels > 1 {
            local := vbap_source_directions[cast(s64) stream.sound_data.source_directions[channel]];
            direction = Vector2.{central.x*local.x-central.y*local.y, central.y*local.x+central.x*local.y};
        }
        accum_scale_target_all_source_n(stream, direction, channel, gain_scale);
    }
}
update_panning :: ( stream : * Sound_Stream ) {
    if !stream || !stream.sound_data || !backend.initted return;
    for channel: 0..stream.num_channels-1 clear_scale_accumulation(stream, channel);
    volume := get_desired_volume_perceptual(stream, stream.position);
    gain := perceptual_to_linear(max(volume, 0.0));
    if (stream.internal_flags & .FADING_OUT) != 0 gain = 0;
    stream.max_gain = gain;
    stream.inaudible = gain <= 0.00001;
    if (stream.user_flags & .MUSIC) != 0 update_panning_helper_for_many_channel_music(stream, gain);
    else update_panning_helper(stream, gain);
    ramp_samples := max(1.0, cast(float) backend.output_sampling_rate * 0.01);
    for input: 0..stream.num_channels-1 {
        mapping := *stream.input_scale_mappings[input];
        for output: 0..backend.num_channels-1 {
            desired := mapping.source_scale_for_this_output_index[output];
            if (stream.internal_flags & .FIRST_VOLUME_UPDATE) != 0 mapping.interpolated_source_scale_for_this_output_index[output] = desired;
            mapping.dvolume_dsample[output] = (desired-mapping.interpolated_source_scale_for_this_output_index[output])/ramp_samples;
        }
    }
    stream.internal_flags &= ~.FIRST_VOLUME_UPDATE;
    stream.debug_display_volume = volume;
}
Sound_Player_Config :: struct {
    update_from_a_thread := true ;
    audible_when_window_is_not_in_focus := false ;
    keep_sounds_alive_by_default := true ;
    seconds_to_fill_ahead := 2.4 / 60.0 ;
    set_async_thread_priority : ( ) -> ( ) ;
    release_asset : ( stream : * Sound_Stream , data : * Sound_Data ) ;
}
Output_Device :: struct {
    name : string ;
    hints : [ ] string ;
    device_index : s64 ;
}
get_devices :: ( ) -> [ ] Output_Device {
    return backend_get_devices();
}
sound_player_init :: ( given_config : Sound_Player_Config ) -> bool {
    if backend.initted return true;
    config = given_config;
    atomic_write(*async_thread_should_exit, false);
    if !init(*sound_mutex, "sound player") return false;
    backend = backend_init(config);
    if !backend.initted { destroy(*sound_mutex); return false; }
    for *level: mix_levels level.* = 1;
    axis_forward = .{1,0,0}; axis_left = .{0,1,0}; axis_up = .{0,0,1};
    update_listener(.{}, Quaternion_Identity);
    vbap_speaker_directions[0] = .{ROOT_2_OVER_2,ROOT_2_OVER_2};
    vbap_speaker_directions[1] = .{ROOT_2_OVER_2,-ROOT_2_OVER_2};
    vbap_speaker_directions[2] = .{1,0}; vbap_speaker_directions[3] = .{1,0};
    vbap_speaker_directions[4] = .{-ROOT_2_OVER_2,ROOT_2_OVER_2};
    vbap_speaker_directions[5] = .{-ROOT_2_OVER_2,-ROOT_2_OVER_2};
    vbap_speaker_directions[6] = .{-0.9238795,0.3826834};
    vbap_speaker_directions[7] = .{-0.9238795,-0.3826834};
    for source: 0..NUM_SOURCE_DIRECTIONS-1 {
        target, mapped := source_dir_to_target_dir(cast(Source_Direction) source);
        if mapped vbap_source_directions[source] = vbap_speaker_directions[cast(s64) target];
        else vbap_source_directions[source] = .{1,0};
    }
    arcs = arcs_6ch;
    if backend.num_channels >= 8 arcs = arcs_8ch;
    for *arc: arcs {
        left := vbap_speaker_directions[cast(s64) arc.speaker1];
        right := vbap_speaker_directions[cast(s64) arc.speaker2];
        basis: Matrix2 = .{_11=left.x,_12=right.x,_21=left.y,_22=right.y};
        invert(*basis, *arc.l_inverse);
    }
    audio_samples_per_history_sample = DEFAULT_AUDIO_SAMPLES_PER_HISTORY_SAMPLE;
    init_sound_player_decode_queue();
    if !decode_queue_initted { backend_shutdown(); backend.initted = false; destroy(*sound_mutex); return false; }
    backend_play();
    if config.update_from_a_thread {
        if !thread_init(*async_thread, async_audio_update) || !thread_start(*async_thread) {
            sound_player_shutdown(); return false;
        }
    }
    return true;
}
sound_player_shutdown :: ( ) {
    if !backend.initted return;
    atomic_write(*async_thread_should_exit, true);
    thread_deinit(*async_thread);
    #if CACHED_OGG_DECODE_THREADED {
        if decode_queue_initted { signal(*decode_queue_semaphore); thread_deinit(*decode_queue_thread); }
    }
    lock(*sound_mutex);
    while true {
        page := get_next_completed_decode_queue_item();
        if !page break;
        decoder := page.owner;
        for index: 0..decoder.issued_start_addresses.count-1 if decoder.issued_start_addresses[index] == page.start_address {
            array_unordered_remove_by_index(*decoder.issued_start_addresses, index); break;
        }
        free(page.data); free(page);
    }
    free_streams(live_streams);
    array_free(live_streams); live_streams = .{};
    for decoder: retired_decoders { deinit(decoder); release_retired_audio_stream(decoder); }
    array_free(retired_decoders); retired_decoders = .{};
    array_free(audio_retired_streams); audio_retired_streams = .{};
    unlock(*sound_mutex);
    if decode_queue_initted {
        #if CACHED_OGG_DECODE_THREADED {
            array_free(decode_queue); decode_queue = .{};
            destroy(*decode_queue_semaphore); destroy(*decode_queue_lock);
        }
        array_free(completed_queue); completed_queue = .{};
        destroy(*completed_queue_lock); decode_queue_initted = false;
    }
    backend_shutdown();
    backend = .{};
    destroy(*sound_mutex);
}
samples_to_bytes :: ( stream : * Sound_Stream , num_samples : s64 ) -> s64 {
    interleaved_samples := num_samples * cast(s64) stream.sound_data.nchannels;
    return interleaved_samples * size_of(s16);
}
set_master_volume :: ( value : float ) {
    master_volume = value;
}
find :: ( entity_id : s64 , manager_id : s64 ) -> * Sound_Stream {
    index: s64 = 0;
    while index < live_streams.count {
        candidate := live_streams[index];
        if candidate.entity_id == entity_id && candidate.manager_id == manager_id return candidate;
        index += 1;
    }
    return null;
}
update_desired_rate :: ( stream : * Sound_Stream ) {
    source_rate := cast(float) stream.sound_data.sampling_rate;
    destination_rate := cast(float) backend.output_sampling_rate;
    stream.desired_rate = source_rate * stream.rate_scale / destination_rate;
}
make_stream :: ( data : * Sound_Data , category := Sound_Category . GENERAL_SFX ) -> * Sound_Stream {
    if !data || !data.loaded || data.type == .UNINITIALIZED || data.nchannels < 1 || data.nchannels > MAX_CHANNELS_PER_SOUND return null;
    stream := New(Sound_Stream);
    if !stream return null;
    stream.sound_data = data;
    stream.sound_name = data.name;
    stream.category = category;
    stream.num_channels = data.nchannels;
    stream.marked = true;
    stream.internal_flags |= .FIRST_VOLUME_UPDATE;
    stream.repeat_end_position = data.nsamples_times_nchannels/data.nchannels;
    if data.type == .OGG_COMPRESSED stream.decoder = create_ogg_decoder(data, 8000);
    if data.type == .ADPCM_COMPRESSED {
        adpcm := create_adpcm_decoder(data);
        if adpcm stream.decoder = *adpcm.base;
    }
    if data.type != .LINEAR_SAMPLE_ARRAY && !stream.decoder { free(stream); return null; }
    if stream.decoder {
        stream.decoder.stream = stream;
        stream.decoder.do_not_queue = !CACHED_OGG_DECODE_THREADED;
        stream.decoder.add_decode_queue_item = add_decode_queue_item;
        stream.internal_flags |= .WAITING_FOR_INITIAL_DECODER_PAGES;
    }
    if backend.initted update_desired_rate(stream);
    stream.current_rate = stream.desired_rate;
    return stream;
}
start_playing :: ( stream : * Sound_Stream ) {
    if !stream || !backend.initted return;
    lock(*sound_mutex);
    defer unlock(*sound_mutex);
    for candidate: live_streams if candidate == stream return;
    update_stream(stream);
    array_add(*live_streams, stream);
}
stop_stream_abruptly :: ( id : s64 ) {
    if !backend.initted return;
    lock(*sound_mutex);
    defer unlock(*sound_mutex);
    index: s64 = 0;
    while index < live_streams.count {
        stream := live_streams[index];
        if stream.entity_id == id { array_unordered_remove_by_index(*live_streams, index); free_stream(stream); }
        else index += 1;
    }
}
stop_stream_abruptly :: ( data : * Sound_Data ) {
    if !backend.initted return;
    lock(*sound_mutex);
    defer unlock(*sound_mutex);
    index: s64 = 0;
    while index < live_streams.count {
        stream := live_streams[index];
        if stream.sound_data == data { array_unordered_remove_by_index(*live_streams, index); free_stream(stream); }
        else index += 1;
    }
}
stop_all_sounds_abruptly :: ( manager_id : s64 ) {
    if !backend.initted return;
    lock(*sound_mutex);
    defer unlock(*sound_mutex);
    index: s64 = 0;
    while index < live_streams.count {
        stream := live_streams[index];
        if stream.manager_id == manager_id { array_unordered_remove_by_index(*live_streams, index); free_stream(stream); }
        else index += 1;
    }
}
get_desired_volume_perceptual :: ( stream : * Sound_Stream , position : Vector3 ) -> float {
    if !stream || !stream.sound_data return 0;
    volume := master_volume*stream.user_volume_scale*stream.universe_volume_scale*stream.sound_data.volume_scale;
    category := cast(s64) stream.category;
    if category >= 0 && category < MAX_SOUND_CATEGORIES volume *= mix_levels[category];
    if (stream.user_flags & .SPATIALIZED) != 0 && have_listener {
        distance := length(position-listener_position);
        if distance >= stream.outer_radius return 0;
        if distance > stream.inner_radius && stream.outer_radius > stream.inner_radius
            volume *= (stream.outer_radius-distance)/(stream.outer_radius-stream.inner_radius);
    }
    return max(volume, 0.0);
}
update_listener :: ( camera_position : Vector3 , camera_orientation : Quaternion ) {
    listener_position = camera_position;
    listener_orientation = camera_orientation;
    listener_forward = rotate(axis_forward, camera_orientation);
    listener_left = rotate(axis_left, camera_orientation);
    listener_up = rotate(axis_up, camera_orientation);
    listener_theta = atan2(listener_left.y, listener_left.x);
    have_listener = true;
}
get_audio_sampling_rate :: ( ) -> s64 {
    rate := backend.output_sampling_rate;
    return rate;
}
decode_queue_initted := false ;
#if CACHED_OGG_DECODE_THREADED {
    decode_queue : [ .. ] * Cached_Decoder_Page ;
    decode_queue_semaphore : Semaphore ;
    decode_queue_lock : Mutex ;
    decode_queue_thread : Thread ;
}
completed_queue : [ .. ] * Cached_Decoder_Page ;
completed_queue_lock : Mutex ;
init_sound_player_decode_queue :: ( ) {
    if decode_queue_initted return;
    if !init(*completed_queue_lock, "audio completed pages") return;
    #if CACHED_OGG_DECODE_THREADED {
        if !init(*decode_queue_lock, "audio decode pages") { destroy(*completed_queue_lock); return; }
        if !init(*decode_queue_semaphore) { destroy(*decode_queue_lock); destroy(*completed_queue_lock); return; }
        if !thread_init(*decode_queue_thread, thread_proc) || !thread_start(*decode_queue_thread) {
            thread_deinit(*decode_queue_thread);
            destroy(*decode_queue_semaphore); destroy(*decode_queue_lock); destroy(*completed_queue_lock); return;
        }
    }
    decode_queue_initted = true;
}
process_one_page :: ( page : * Cached_Decoder_Page ) {
    if !page || !page.owner return;
    page.owner.recompute_page(page.owner, page);
    lock(*completed_queue_lock);
    array_add(*completed_queue, page);
    unlock(*completed_queue_lock);
}
add_decode_queue_item :: ( page : * Cached_Decoder_Page ) {
    if !page return;
    #if CACHED_OGG_DECODE_THREADED {
        assert(decode_queue_initted);
        lock(*decode_queue_lock);
        array_add(*decode_queue, page);
        unlock(*decode_queue_lock);
        signal(*decode_queue_semaphore);
    } else process_one_page(page);
}
get_next_completed_decode_queue_item :: ( ) -> * Cached_Decoder_Page {
    if !decode_queue_initted return null;
    lock(*completed_queue_lock);
    defer unlock(*completed_queue_lock);
    if completed_queue.count == 0 return null;
    page := completed_queue[0];
    array_ordered_remove_by_index(*completed_queue, 0);
    return page;
}
#scope_file
update_stream :: ( stream : * Sound_Stream ) {
    if !stream || !stream.sound_data return;
    update_desired_rate(stream);
    update_panning(stream);
    if stream.decoder {
        decoder := stream.decoder;
        cursor := max(0, cast(s64) stream.play_cursor);
        horizon := cast(s64) (max(SECONDS_TO_FETCH_OGG, config.seconds_to_fill_ahead)*decoder.sampling_rate);
        unmark_all_pages(decoder);
        mark_relevant_pages(decoder, cursor, cursor+horizon);
        if (stream.user_flags & .REPEATING) != 0 && cursor+horizon >= stream.repeat_end_position
            mark_relevant_pages(decoder, stream.repeat_start_position, stream.repeat_start_position+horizon);
        free_unmarked_pages(decoder);
        found, _, _, _ := find_page_containing_cursor(decoder, cursor);
        if found stream.internal_flags &= ~.WAITING_FOR_INITIAL_DECODER_PAGES;
    }
    stream.samples_streamed_since_entity_update = 0;
}
#scope_export
pre_entity_update :: ( ) {
    if !backend.initted return;
    lock(*sound_mutex);
    for stream: live_streams stream.marked = false;
    unlock(*sound_mutex);
}
post_entity_update :: ( dt : float ) {
    if !backend.initted return;
    lock(*sound_mutex);
    defer unlock(*sound_mutex);
    index: s64 = 0;
    while index < live_streams.count {
        stream := live_streams[index];
        if !stream.marked && !config.keep_sounds_alive_by_default && (stream.user_flags & .DO_NOT_KILL) == 0 {
            array_unordered_remove_by_index(*live_streams, index); free_stream(stream);
        } else { update_stream(stream); index += 1; }
    }
}
update :: ( dt := FLOAT32_INFINITY ) {
    if !backend.initted return;
    lock(*sound_mutex);
    while true {
        page := get_next_completed_decode_queue_item();
        if !page break;
        decoder := page.owner;
        for index: 0..decoder.issued_start_addresses.count-1 {
            if decoder.issued_start_addresses[index] == page.start_address {
                array_unordered_remove_by_index(*decoder.issued_start_addresses, index); break;
            }
        }
        if decoder.stream array_add(*decoder.pages, page);
        else { free(page.data); free(page); }
    }
    index: s64 = 0;
    while index < retired_decoders.count {
        decoder := retired_decoders[index];
        if decoder.issued_start_addresses.count == 0 { deinit(decoder); release_retired_audio_stream(decoder); array_unordered_remove_by_index(*retired_decoders, index); }
        else index += 1;
    }
    for stream: live_streams update_stream(stream);
    last_update_time = get_time();
    unlock(*sound_mutex);
    if !config.update_from_a_thread || backend_needs_async_update_from_main_thread() update_from_async_thread(false);
}
set_repeating :: ( stream : * Sound_Stream , repeating : bool ) {
    lock(*sound_mutex);
    if repeating {
        data := stream.sound_data;
        if data && data.nchannels > 0 {
            stream.repeat_end_position = data.nsamples_times_nchannels / data.nchannels;
            stream.user_flags |= .REPEATING;
        }
    } else {
        stream.user_flags &= ~.REPEATING;
    }
    unlock(*sound_mutex);
}
#scope_file
thread_proc :: ( thread : * Thread ) -> s64 {
    #if CACHED_OGG_DECODE_THREADED {
        while true {
            if wait_for(*decode_queue_semaphore) != .SUCCESS break;
            lock(*decode_queue_lock);
            page: *Cached_Decoder_Page;
            if decode_queue.count > 0 { page = decode_queue[0]; array_ordered_remove_by_index(*decode_queue, 0); }
            quit := atomic_read(*async_thread_should_exit) && decode_queue.count == 0;
            unlock(*decode_queue_lock);
            if page process_one_page(page);
            if quit break;
        }
    }
    return 0;
}
free_streams :: ( streams : [ ] * Sound_Stream ) {
    for stream: streams free_stream(stream);
}
free_stream :: ( stream : * Sound_Stream ) {
    if !stream return;
    if stream.decoder {
        stream.decoder.stream = null;
        if stream.decoder.issued_start_addresses.count > 0 {
            array_add(*retired_decoders, stream.decoder);
            array_add(*audio_retired_streams, Audio_Retired_Stream.{stream=stream,decoder=stream.decoder});
            return;
        } else deinit(stream.decoder);
    }
    if config.release_asset config.release_asset(stream, stream.sound_data);
    free(stream);
}
last_update_time : float64 ;
#scope_module
#import "Math" ;
#import "Thread" ;
BYTES_PER_SAMPLE :: size_of ( s16 ) ;
master_volume : float = 1 ;
mix_levels : [ MAX_SOUND_CATEGORIES ] float ;
listener_position : Vector3 ;
listener_orientation : Quaternion ;
axis_forward : Vector3 ;
axis_left : Vector3 ;
axis_up : Vector3 ;
listener_forward : Vector3 ;
listener_left : Vector3 ;
listener_up : Vector3 ;
listener_theta : float ;
have_listener := false ;
update_history := false ;
Sample_Output_History :: struct {
    low : [ OUTPUT_CHANNELS_MAX ] float ;
    high : [ OUTPUT_CHANNELS_MAX ] float ;
}
HISTORY_LENGTH :: 1000 ;
DEFAULT_AUDIO_SAMPLES_PER_HISTORY_SAMPLE :: 128 ;
history : [ HISTORY_LENGTH ] Sample_Output_History ;
history_cursor : s64 ;
history_subcursor : s64 ;
audio_samples_per_history_sample : s64 ;
history_paused := false ;
stereo_base : float = 1 ;
live_streams : [ .. ] * Sound_Stream ;
async_thread : Thread ;
sound_mutex : Mutex ;
async_thread_should_exit := false ;
config : Sound_Player_Config ;
backend : Backend_Properties ;
#if OS == . WINDOWS {
    #load "os/win32.jai" ;
}
else #if OS == . LINUX {
    #load "os/alsa.jai" ;
}
else #if OS == . MACOS {
    #load "os/core_audio.jai" ;
}
else #if OS == . PS5 {
    #load "os/ps5.jai" ;
}
else #if OS == . ANDROID {
    #load "os/aaudio.jai" ;
}


#scope_file
Audio_Retired_Stream :: struct { stream: *Sound_Stream; decoder: *Cached_Decoder; }
audio_retired_streams: [..]Audio_Retired_Stream;
release_retired_audio_stream :: (decoder: *Cached_Decoder) {
    for index: 0..audio_retired_streams.count-1 {
        entry := audio_retired_streams[index];
        if entry.decoder != decoder continue;
        entry.stream.decoder = null;
        if config.release_asset config.release_asset(entry.stream, entry.stream.sound_data);
        free(entry.stream);
        array_unordered_remove_by_index(*audio_retired_streams,index);
        return;
    }
}
