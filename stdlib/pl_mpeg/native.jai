// Independent Jai ownership/callback/record bridge to reviewed genuine upstream pl_mpeg symbols.
// Native implementation is external. Internal helper exports/layouts require the exact reviewed header hash.
#scope_module
Native_Video_Callback :: #type (self: *Native_Plm, frame: *Frame, user: *void) #c_call;
Native_Audio_Callback :: #type (self: *Native_Plm, samples: *Samples, user: *void) #c_call;
Native_Load_Callback :: #type (self: *Native_Buffer, user: *void) #c_call;
Native_Seek_Callback :: #type (self: *Native_Buffer, offset: u64, user: *void) #c_call;
Native_Tell_Callback :: #type (self: *Native_Buffer, user: *void) -> u64 #c_call;
Native_Plm :: struct {
    demux: *Native_Demux;
    time: float64;
    has_ended: s32;
    loop: s32;
    has_decoders: s32;
    video_enabled: s32;
    video_packet_type: s32;
    video_buffer: *Native_Buffer;
    video_decoder: *Native_Video;
    audio_enabled: s32;
    audio_stream_index: s32;
    audio_packet_type: s32;
    audio_lead_time: float64;
    audio_buffer: *Native_Buffer;
    audio_decoder: *Native_Audio;
    video_decode_callback: Native_Video_Callback;
    video_decode_callback_user_data: *void;
    audio_decode_callback: Native_Audio_Callback;
    audio_decode_callback_user_data: *void;
}
Native_Buffer :: struct {
    bit_index: u64;
    capacity: u64;
    length: u64;
    total_size: u64;
    discard_read_bytes: s32;
    has_ended: s32;
    free_when_done: s32;
    close_when_done: s32;
    fh: *void;
    load_callback: Native_Load_Callback;
    seek_callback: Native_Seek_Callback;
    tell_callback: Native_Tell_Callback;
    load_callback_user_data: *void;
    bytes: *u8;
    mode: s32;
}
Native_Demux :: struct {
    buffer: *Native_Buffer;
    destroy_buffer_when_done: s32;
    system_clock_ref: float64;
    last_file_size: u64;
    last_decoded_pts: float64;
    start_time: float64;
    duration: float64;
    start_code: s32;
    has_pack_header: s32;
    has_system_header: s32;
    has_headers: s32;
    num_audio_streams: s32;
    num_video_streams: s32;
    current_packet: Native_Packet;
    next_packet: Native_Packet;
}
Native_Video :: struct {
    framerate: float64;
    pixel_aspect_ratio: float64;
    time: float64;
    frames_decoded: s32;
    width: s32;
    height: s32;
    mb_width: s32;
    mb_height: s32;
    mb_size: s32;
    luma_width: s32;
    luma_height: s32;
    chroma_width: s32;
    chroma_height: s32;
    start_code: s32;
    picture_type: s32;
    motion_forward: Video_Motion;
    motion_backward: Video_Motion;
    has_sequence_header: s32;
    quantizer_scale: s32;
    slice_begin: s32;
    macroblock_address: s32;
    mb_row: s32;
    mb_col: s32;
    macroblock_type: s32;
    macroblock_intra: s32;
    dc_predictor: [3] s32;
    buffer: *Native_Buffer;
    destroy_buffer_when_done: s32;
    frame_current: Frame;
    frame_forward: Frame;
    frame_backward: Frame;
    frames_data: *u8;
    block_data: [64] s32;
    intra_quant_matrix: [64] u8;
    non_intra_quant_matrix: [64] u8;
    has_reference_frame: s32;
    assume_no_b_frames: s32;
}
Native_Audio :: struct {
    time: float64;
    samples_decoded: s32;
    samplerate_index: s32;
    bitrate_index: s32;
    version: s32;
    layer: s32;
    mode: s32;
    bound: s32;
    v_pos: s32;
    next_frame_data_size: s32;
    has_header: s32;
    buffer: *Native_Buffer;
    destroy_buffer_when_done: s32;
    allocation: [2][32] *Quantizer_Spec;
    scale_factor_info: [2][32] u8;
    scale_factor: [2][32][3] s32;
    sample: [2][32][3] s32;
    samples: Samples;
    D: [1024] float;
    V: [2][1024] float;
    U: [32] float;
}
Native_Packet :: struct {
    type: s32;
    pts: float64;
    length: u64;
    data: *u8;
}
Video_State :: struct {
    next: *Video_State;
    public: *Video;
    native: *Native_Video;
    creator: Context;
    callback_context: Context;
    owner: *void;
    own_native: bool;
}
video_states: *Video_State;
Buffer_State :: struct {
    next: *Buffer_State;
    public: *Buffer;
    native: *Native_Buffer;
    creator: Context;
    callback_context: Context;
    owner: *void;
    own_native: bool;
    backing: *void;
    default_callback: Native_Load_Callback;
    default_user: *void;
}
buffer_states: *Buffer_State;
Plm_State :: struct {
    next: *Plm_State;
    public: *Plm;
    native: *Native_Plm;
    creator: Context;
    callback_context: Context;
    owner: *void;
    own_native: bool;
    root_buffer: *Buffer;
    release_root: bool;
}
plm_states: *Plm_State;
Demux_State :: struct {
    next: *Demux_State;
    public: *Demux;
    native: *Native_Demux;
    creator: Context;
    callback_context: Context;
    owner: *void;
    own_native: bool;
}
demux_states: *Demux_State;
Audio_State :: struct {
    next: *Audio_State;
    public: *Audio;
    native: *Native_Audio;
    creator: Context;
    callback_context: Context;
    owner: *void;
    own_native: bool;
}
audio_states: *Audio_State;
buffer_state :: (object: *Buffer) -> *Buffer_State {
    entry := buffer_states;
    while entry {
        if entry.public == object return entry;
        entry = entry.next;
    }
    assert(false, "Object was not created by the pl_mpeg bridge");
    return null;
}
native_buffer :: (object: *Buffer) -> *Native_Buffer {
    if !object return null;
    return buffer_state(object).native;
}
wrap_buffer :: (native: *Native_Buffer, owner: *void = null) -> *Buffer {
    if !native return null;
    entry := buffer_states;
    while entry {
        if entry.native == native {
            pull_buffer(entry);
            return entry.public;
        }
        entry = entry.next;
    }
    entry = New(Buffer_State);
    entry.public = New(Buffer);
    entry.native = native;
    entry.creator = context;
    entry.callback_context = context;
    entry.owner = owner;
    entry.next = buffer_states;
    buffer_states = entry;
    entry.default_callback = native.load_callback;
    entry.default_user = native.load_callback_user_data;
    if native.load_callback entry.public.load_callback = default_buffer_load;
    entry.public.load_callback_user_data = public_callback_user(native.load_callback_user_data);
    pull_buffer(entry);
    return entry.public;
}
pull_buffer :: (entry: *Buffer_State) {
    source := entry.native;
    target := entry.public;
    target.bit_index = cast(s64) source.bit_index;
    target.capacity = cast(s64) source.capacity;
    target.length = cast(s64) source.length;
    target.total_size = cast(s64) source.total_size;
    target.discard_read_bytes = source.discard_read_bytes != 0;
    target.has_ended = source.has_ended != 0;
    if !entry.backing target.free_when_done = source.free_when_done != 0;
    if !entry.backing target.free_when_done = source.free_when_done != 0;
    target.bytes = source.bytes;
    target.mode = cast,no_check(Buffer_Mode) source.mode;
}
push_buffer :: (entry: *Buffer_State) {
    source := entry.public;
    target := entry.native;
    target.bit_index = cast(u64) source.bit_index;
    target.capacity = cast(u64) source.capacity;
    target.length = cast(u64) source.length;
    target.total_size = cast(u64) source.total_size;
    target.discard_read_bytes = cast(s32) source.discard_read_bytes;
    target.has_ended = cast(s32) source.has_ended;
    if !entry.backing target.free_when_done = cast(s32) source.free_when_done;
    if !entry.backing target.free_when_done = cast(s32) source.free_when_done;
    target.bytes = source.bytes;
    target.mode = cast(s32) source.mode;
    if source.load_callback == default_buffer_load {
        raw_plm_buffer_set_load_callback(target, entry.default_callback, entry.default_user);
    } else if source.load_callback {
        raw_plm_buffer_set_load_callback(target, native_load_callback, entry);
    } else raw_plm_buffer_set_load_callback(target, null, null);
}
forget_buffer :: (object: *Buffer) {
    link := *buffer_states;
    while link.* {
        entry := link.*;
        if entry.public == object {
            link.* = entry.next;
            free(entry.public, entry.creator.allocator);
            free(entry, entry.creator.allocator);
            return;
        }
        link = *entry.next;
    }
}
demux_state :: (object: *Demux) -> *Demux_State {
    entry := demux_states;
    while entry {
        if entry.public == object return entry;
        entry = entry.next;
    }
    assert(false, "Object was not created by the pl_mpeg bridge");
    return null;
}
native_demux :: (object: *Demux) -> *Native_Demux {
    if !object return null;
    return demux_state(object).native;
}
wrap_demux :: (native: *Native_Demux, owner: *void = null) -> *Demux {
    if !native return null;
    entry := demux_states;
    while entry {
        if entry.native == native {
            pull_demux(entry);
            return entry.public;
        }
        entry = entry.next;
    }
    entry = New(Demux_State);
    entry.public = New(Demux);
    entry.native = native;
    entry.creator = context;
    entry.callback_context = context;
    entry.owner = owner;
    entry.next = demux_states;
    demux_states = entry;
    pull_demux(entry);
    return entry.public;
}
pull_demux :: (entry: *Demux_State) {
    source := entry.native;
    target := entry.public;
    target.buffer = wrap_buffer(source.buffer, entry.owner);
    target.system_clock_ref = source.system_clock_ref;
    target.last_file_size = cast(s64) source.last_file_size;
    target.last_decoded_pts = source.last_decoded_pts;
    target.start_time = source.start_time;
    target.duration = source.duration;
    target.start_code = cast,no_check(Start_Code) source.start_code;
    target.has_pack_header = source.has_pack_header != 0;
    target.has_system_header = source.has_system_header != 0;
    target.has_headers = source.has_headers != 0;
    target.num_audio_streams = source.num_audio_streams;
    target.num_video_streams = source.num_video_streams;
    target.current_packet = from_native_packet(*source.current_packet);
    target.next_packet = from_native_packet(*source.next_packet);
}
push_demux :: (entry: *Demux_State) {
    source := entry.public;
    target := entry.native;
    if source.buffer push_buffer(buffer_state(source.buffer));
    target.buffer = native_buffer(source.buffer);
    target.system_clock_ref = source.system_clock_ref;
    target.last_file_size = cast(u64) source.last_file_size;
    target.last_decoded_pts = source.last_decoded_pts;
    target.start_time = source.start_time;
    target.duration = source.duration;
    target.start_code = native_start_code(source.start_code);
    target.has_pack_header = cast(s32) source.has_pack_header;
    target.has_system_header = cast(s32) source.has_system_header;
    target.has_headers = cast(s32) source.has_headers;
    target.num_audio_streams = source.num_audio_streams;
    target.num_video_streams = source.num_video_streams;
    target.current_packet = to_native_packet(*source.current_packet);
    target.next_packet = to_native_packet(*source.next_packet);
}
forget_demux :: (object: *Demux) {
    link := *demux_states;
    while link.* {
        entry := link.*;
        if entry.public == object {
            link.* = entry.next;
            free(entry.public, entry.creator.allocator);
            free(entry, entry.creator.allocator);
            return;
        }
        link = *entry.next;
    }
}
video_state :: (object: *Video) -> *Video_State {
    entry := video_states;
    while entry {
        if entry.public == object return entry;
        entry = entry.next;
    }
    assert(false, "Object was not created by the pl_mpeg bridge");
    return null;
}
native_video :: (object: *Video) -> *Native_Video {
    if !object return null;
    return video_state(object).native;
}
wrap_video :: (native: *Native_Video, owner: *void = null) -> *Video {
    if !native return null;
    entry := video_states;
    while entry {
        if entry.native == native {
            pull_video(entry);
            return entry.public;
        }
        entry = entry.next;
    }
    entry = New(Video_State);
    entry.public = New(Video);
    entry.native = native;
    entry.creator = context;
    entry.callback_context = context;
    entry.owner = owner;
    entry.next = video_states;
    video_states = entry;
    pull_video(entry);
    return entry.public;
}
pull_video :: (entry: *Video_State) {
    source := entry.native;
    target := entry.public;
    target.framerate = source.framerate;
    target.time = source.time;
    target.frames_decoded = source.frames_decoded;
    target.width = source.width;
    target.height = source.height;
    target.mb_width = source.mb_width;
    target.mb_height = source.mb_height;
    target.mb_size = source.mb_size;
    target.luma_width = source.luma_width;
    target.luma_height = source.luma_height;
    target.chroma_width = source.chroma_width;
    target.chroma_height = source.chroma_height;
    target.start_code = cast,no_check(Start_Code) source.start_code;
    target.picture_type = cast,no_check(Picture_Type) source.picture_type;
    target.motion_forward = source.motion_forward;
    target.motion_backward = source.motion_backward;
    target.has_sequence_header = source.has_sequence_header != 0;
    target.quantizer_scale = source.quantizer_scale;
    target.slice_begin = source.slice_begin != 0;
    target.macroblock_address = source.macroblock_address;
    target.mb_row = source.mb_row;
    target.mb_col = source.mb_col;
    target.macroblock_type = source.macroblock_type;
    target.macroblock_intra = source.macroblock_intra;
    target.dc_predictor = source.dc_predictor;
    target.buffer = wrap_buffer(source.buffer, entry.owner);
    target.frame_current = source.frame_current;
    target.frame_forward = source.frame_forward;
    target.frame_backward = source.frame_backward;
    target.frames_data = source.frames_data;
    target.block_data = source.block_data;
    target.intra_quant_matrix = source.intra_quant_matrix;
    target.non_intra_quant_matrix = source.non_intra_quant_matrix;
    target.has_reference_frame = source.has_reference_frame != 0;
    target.assume_no_b_frames = source.assume_no_b_frames != 0;
}
push_video :: (entry: *Video_State) {
    source := entry.public;
    target := entry.native;
    target.framerate = source.framerate;
    target.time = source.time;
    target.frames_decoded = source.frames_decoded;
    target.width = source.width;
    target.height = source.height;
    target.mb_width = source.mb_width;
    target.mb_height = source.mb_height;
    target.mb_size = source.mb_size;
    target.luma_width = source.luma_width;
    target.luma_height = source.luma_height;
    target.chroma_width = source.chroma_width;
    target.chroma_height = source.chroma_height;
    target.start_code = native_start_code(source.start_code);
    target.picture_type = cast(s32) source.picture_type;
    target.motion_forward = source.motion_forward;
    target.motion_backward = source.motion_backward;
    target.has_sequence_header = cast(s32) source.has_sequence_header;
    target.quantizer_scale = source.quantizer_scale;
    target.slice_begin = cast(s32) source.slice_begin;
    target.macroblock_address = source.macroblock_address;
    target.mb_row = source.mb_row;
    target.mb_col = source.mb_col;
    target.macroblock_type = source.macroblock_type;
    target.macroblock_intra = source.macroblock_intra;
    target.dc_predictor = source.dc_predictor;
    if source.buffer push_buffer(buffer_state(source.buffer));
    target.buffer = native_buffer(source.buffer);
    target.frame_current = source.frame_current;
    target.frame_forward = source.frame_forward;
    target.frame_backward = source.frame_backward;
    target.frames_data = source.frames_data;
    target.block_data = source.block_data;
    target.intra_quant_matrix = source.intra_quant_matrix;
    target.non_intra_quant_matrix = source.non_intra_quant_matrix;
    target.has_reference_frame = cast(s32) source.has_reference_frame;
    target.assume_no_b_frames = cast(s32) source.assume_no_b_frames;
}
forget_video :: (object: *Video) {
    link := *video_states;
    while link.* {
        entry := link.*;
        if entry.public == object {
            link.* = entry.next;
            free(entry.public, entry.creator.allocator);
            free(entry, entry.creator.allocator);
            return;
        }
        link = *entry.next;
    }
}
audio_state :: (object: *Audio) -> *Audio_State {
    entry := audio_states;
    while entry {
        if entry.public == object return entry;
        entry = entry.next;
    }
    assert(false, "Object was not created by the pl_mpeg bridge");
    return null;
}
native_audio :: (object: *Audio) -> *Native_Audio {
    if !object return null;
    return audio_state(object).native;
}
wrap_audio :: (native: *Native_Audio, owner: *void = null) -> *Audio {
    if !native return null;
    entry := audio_states;
    while entry {
        if entry.native == native {
            pull_audio(entry);
            return entry.public;
        }
        entry = entry.next;
    }
    entry = New(Audio_State);
    entry.public = New(Audio);
    entry.native = native;
    entry.creator = context;
    entry.callback_context = context;
    entry.owner = owner;
    entry.next = audio_states;
    audio_states = entry;
    pull_audio(entry);
    return entry.public;
}
pull_audio :: (entry: *Audio_State) {
    source := entry.native;
    target := entry.public;
    target.time = source.time;
    target.samples_decoded = source.samples_decoded;
    target.samplerate_index = source.samplerate_index;
    target.bitrate_index = source.bitrate_index;
    target.version = source.version;
    target.layer = source.layer;
    target.mode = cast,no_check(Audio_Mode) source.mode;
    target.bound = source.bound;
    target.v_pos = source.v_pos;
    target.next_frame_data_size = source.next_frame_data_size;
    target.has_header = source.has_header != 0;
    target.buffer = wrap_buffer(source.buffer, entry.owner);
    target.allocation = source.allocation;
    target.scale_factor_info = source.scale_factor_info;
    target.scale_factor = source.scale_factor;
    target.sample = source.sample;
    target.samples = source.samples;
    target.D = source.D;
    target.V = source.V;
    target.U = source.U;
}
push_audio :: (entry: *Audio_State) {
    source := entry.public;
    target := entry.native;
    target.time = source.time;
    target.samples_decoded = source.samples_decoded;
    target.samplerate_index = source.samplerate_index;
    target.bitrate_index = source.bitrate_index;
    target.version = source.version;
    target.layer = source.layer;
    target.mode = cast(s32) source.mode;
    target.bound = source.bound;
    target.v_pos = source.v_pos;
    target.next_frame_data_size = source.next_frame_data_size;
    target.has_header = cast(s32) source.has_header;
    if source.buffer push_buffer(buffer_state(source.buffer));
    target.buffer = native_buffer(source.buffer);
    target.allocation = source.allocation;
    target.scale_factor_info = source.scale_factor_info;
    target.scale_factor = source.scale_factor;
    target.sample = source.sample;
    target.samples = source.samples;
    target.D = source.D;
    target.V = source.V;
    target.U = source.U;
}
forget_audio :: (object: *Audio) {
    link := *audio_states;
    while link.* {
        entry := link.*;
        if entry.public == object {
            link.* = entry.next;
            free(entry.public, entry.creator.allocator);
            free(entry, entry.creator.allocator);
            return;
        }
        link = *entry.next;
    }
}
plm_state :: (object: *Plm) -> *Plm_State {
    entry := plm_states;
    while entry {
        if entry.public == object return entry;
        entry = entry.next;
    }
    assert(false, "Object was not created by the pl_mpeg bridge");
    return null;
}
native_plm :: (object: *Plm) -> *Native_Plm {
    if !object return null;
    return plm_state(object).native;
}
wrap_plm :: (native: *Native_Plm, owner: *void = null) -> *Plm {
    if !native return null;
    entry := plm_states;
    while entry {
        if entry.native == native {
            pull_plm(entry);
            return entry.public;
        }
        entry = entry.next;
    }
    entry = New(Plm_State);
    entry.public = New(Plm);
    entry.native = native;
    entry.creator = context;
    entry.callback_context = context;
    entry.owner = owner;
    entry.next = plm_states;
    plm_states = entry;
    pull_plm(entry);
    return entry.public;
}
pull_plm :: (entry: *Plm_State) {
    source := entry.native;
    target := entry.public;
    target.demux = wrap_demux(source.demux, entry.owner);
    target.time = source.time;
    target.has_ended = source.has_ended != 0;
    target.loop = source.loop != 0;
    target.has_decoders = source.has_decoders != 0;
    target.video_enabled = source.video_enabled != 0;
    target.video_packet_type = cast,no_check(Start_Code) source.video_packet_type;
    target.video_buffer = wrap_buffer(source.video_buffer, entry.owner);
    target.video_decoder = wrap_video(source.video_decoder, entry.owner);
    target.audio_enabled = source.audio_enabled != 0;
    target.audio_stream_index = source.audio_stream_index;
    target.audio_packet_type = cast,no_check(Start_Code) source.audio_packet_type;
    target.audio_lead_time = source.audio_lead_time;
    target.audio_buffer = wrap_buffer(source.audio_buffer, entry.owner);
    target.audio_decoder = wrap_audio(source.audio_decoder, entry.owner);
}
push_plm :: (entry: *Plm_State) {
    source := entry.public;
    target := entry.native;
    if source.video_decode_callback raw_plm_set_video_decode_callback(target, native_video_callback, entry);
    else raw_plm_set_video_decode_callback(target, null, null);
    if source.audio_decode_callback raw_plm_set_audio_decode_callback(target, native_audio_callback, entry);
    else raw_plm_set_audio_decode_callback(target, null, null);
    if source.demux push_demux(demux_state(source.demux));
    target.demux = native_demux(source.demux);
    target.time = source.time;
    target.has_ended = cast(s32) source.has_ended;
    target.loop = cast(s32) source.loop;
    target.has_decoders = cast(s32) source.has_decoders;
    target.video_enabled = cast(s32) source.video_enabled;
    target.video_packet_type = native_start_code(source.video_packet_type);
    if source.video_buffer push_buffer(buffer_state(source.video_buffer));
    target.video_buffer = native_buffer(source.video_buffer);
    if source.video_decoder push_video(video_state(source.video_decoder));
    target.video_decoder = native_video(source.video_decoder);
    target.audio_enabled = cast(s32) source.audio_enabled;
    target.audio_stream_index = source.audio_stream_index;
    target.audio_packet_type = native_start_code(source.audio_packet_type);
    target.audio_lead_time = source.audio_lead_time;
    if source.audio_buffer push_buffer(buffer_state(source.audio_buffer));
    target.audio_buffer = native_buffer(source.audio_buffer);
    if source.audio_decoder push_audio(audio_state(source.audio_decoder));
    target.audio_decoder = native_audio(source.audio_decoder);
}
forget_plm :: (object: *Plm) {
    link := *plm_states;
    while link.* {
        entry := link.*;
        if entry.public == object {
            link.* = entry.next;
            free(entry.public, entry.creator.allocator);
            free(entry, entry.creator.allocator);
            return;
        }
        link = *entry.next;
    }
}

from_native_packet :: (packet: *Native_Packet) -> Packet {
    result: Packet;
    result.type = cast,no_check(Start_Code) packet.type;
    result.pts = packet.pts;
    result.data = .{ cast(s64) packet.length, packet.data };
    return result;
}
to_native_packet :: (packet: *Packet) -> Native_Packet {
    return .{ cast(s32) packet.type, packet.pts, cast(u64) packet.data.count, packet.data.data };
}
packet_result :: (object: *Demux, packet: *Native_Packet) -> *Packet {
    if !packet return null;
    object.current_packet = from_native_packet(packet);
    return *object.current_packet;
}
native_video_callback :: (native: *Native_Plm, frame: *Frame, user: *void) #c_call {
    entry := cast(*Plm_State) user;
    push_context entry.callback_context {
        pull_plm(entry);
        entry.public.video_decode_callback(entry.public, frame, entry.public.video_decode_callback_user_data);
        push_plm(entry);
    }
}
native_audio_callback :: (native: *Native_Plm, samples: *Samples, user: *void) #c_call {
    entry := cast(*Plm_State) user;
    push_context entry.callback_context {
        pull_plm(entry);
        entry.public.audio_decode_callback(entry.public, samples, entry.public.audio_decode_callback_user_data);
        push_plm(entry);
    }
}
default_buffer_load :: (buffer: *Buffer, user: *void) {
    entry := buffer_state(buffer);
    assert(entry.default_callback != null);
    entry.default_callback(entry.native, entry.default_user);
    pull_buffer(entry);
}
native_load_callback :: (native: *Native_Buffer, user: *void) #c_call {
    entry := cast(*Buffer_State) user;
    push_context entry.callback_context {
        pull_buffer(entry);
        entry.public.load_callback(entry.public, entry.public.load_callback_user_data);
        push_buffer(entry);
    }
}
file_load_callback :: (native: *Native_Buffer, user: *void) #c_call {
    entry := cast(*Buffer_State) user;
    push_context entry.creator {
        raw_plm_buffer_discard_read_bytes(native);
        bytes := cast(*u8) alloc(BUFFER_DEFAULT_SIZE);
        assert(bytes != null);
        defer free(bytes);
        success, received := file_read_checked(entry.public.fh, bytes, BUFFER_DEFAULT_SIZE);
        assert(success);
        if received != 0 raw_plm_buffer_write(native, bytes, cast(u64) received);
        else raw_plm_buffer_signal_end(native);
        pull_buffer(entry);
    }
}
file_seek_callback :: (native: *Native_Buffer, offset: u64, user: *void) #c_call {
    entry := cast(*Buffer_State) user;
    push_context entry.creator {
        assert(offset <= cast(u64) S64_MAX);
        assert(file_set_position(entry.public.fh, cast(s64) offset));
    }
}
file_tell_callback :: (native: *Native_Buffer, user: *void) -> u64 #c_call {
    entry := cast(*Buffer_State) user;
    push_context entry.creator {
        success, position := file_tell(entry.public.fh);
        assert(success && position >= 0);
        return cast(u64) position;
    }
}
release_owned_shadows :: (owner: *void) {
    buffer_entry := buffer_states;
    while buffer_entry {
        next := buffer_entry.next;
        if buffer_entry.owner == owner forget_buffer(buffer_entry.public);
        buffer_entry = next;
    }
    video_entry := video_states;
    while video_entry {
        next := video_entry.next;
        if video_entry.owner == owner forget_video(video_entry.public);
        video_entry = next;
    }
    audio_entry := audio_states;
    while audio_entry {
        next := audio_entry.next;
        if audio_entry.owner == owner forget_audio(audio_entry.public);
        audio_entry = next;
    }
    demux_entry := demux_states;
    while demux_entry {
        next := demux_entry.next;
        if demux_entry.owner == owner forget_demux(demux_entry.public);
        demux_entry = next;
    }
}

#scope_module
plm_upstream :: #system_library "pl_mpeg";
raw_plm_audio_create_with_buffer :: (buffer: *Native_Buffer, destroy_when_done: s32) -> *Native_Audio #foreign plm_upstream "plm_audio_create_with_buffer";
raw_plm_audio_decode :: (self: *Native_Audio) -> *Samples #foreign plm_upstream "plm_audio_decode";
raw_plm_audio_decode_frame :: (self: *Native_Audio) #foreign plm_upstream "plm_audio_decode_frame";
raw_plm_audio_decode_header :: (self: *Native_Audio) -> s32 #foreign plm_upstream "plm_audio_decode_header";
raw_plm_audio_destroy :: (self: *Native_Audio) #foreign plm_upstream "plm_audio_destroy";
raw_plm_audio_find_frame_sync :: (self: *Native_Audio) -> s32 #foreign plm_upstream "plm_audio_find_frame_sync";
raw_plm_audio_get_samplerate :: (self: *Native_Audio) -> s32 #foreign plm_upstream "plm_audio_get_samplerate";
raw_plm_audio_has_ended :: (self: *Native_Audio) -> s32 #foreign plm_upstream "plm_audio_has_ended";
raw_plm_audio_has_header :: (self: *Native_Audio) -> s32 #foreign plm_upstream "plm_audio_has_header";
raw_plm_audio_idct36 :: (s: *[3] s32, ss: s32, d: *float, dp: s32) #foreign plm_upstream "plm_audio_idct36";
raw_plm_audio_read_allocation :: (self: *Native_Audio, sb: s32, tab3: s32) -> *Quantizer_Spec #foreign plm_upstream "plm_audio_read_allocation";
raw_plm_audio_read_samples :: (self: *Native_Audio, ch: s32, sb: s32, part: s32) #foreign plm_upstream "plm_audio_read_samples";
raw_plm_audio_rewind :: (self: *Native_Audio) #foreign plm_upstream "plm_audio_rewind";
raw_plm_audio_set_time :: (self: *Native_Audio, time: float64) #foreign plm_upstream "plm_audio_set_time";
raw_plm_buffer_align :: (self: *Native_Buffer) #foreign plm_upstream "plm_buffer_align";
raw_plm_buffer_create_for_appending :: (initial_capacity: u64) -> *Native_Buffer #foreign plm_upstream "plm_buffer_create_for_appending";
raw_plm_buffer_create_with_callbacks :: (load_callback: Native_Load_Callback, seek_callback: Native_Seek_Callback, tell_callback: Native_Tell_Callback, length: u64, user: *void) -> *Native_Buffer #foreign plm_upstream "plm_buffer_create_with_callbacks";
raw_plm_buffer_create_with_capacity :: (capacity: u64) -> *Native_Buffer #foreign plm_upstream "plm_buffer_create_with_capacity";
raw_plm_buffer_create_with_memory :: (bytes: *u8, length: u64, free_when_done: s32) -> *Native_Buffer #foreign plm_upstream "plm_buffer_create_with_memory";
raw_plm_buffer_destroy :: (self: *Native_Buffer) #foreign plm_upstream "plm_buffer_destroy";
raw_plm_buffer_discard_read_bytes :: (self: *Native_Buffer) #foreign plm_upstream "plm_buffer_discard_read_bytes";
raw_plm_buffer_find_start_code :: (self: *Native_Buffer, code: s32) -> s32 #foreign plm_upstream "plm_buffer_find_start_code";
raw_plm_buffer_get_remaining :: (self: *Native_Buffer) -> u64 #foreign plm_upstream "plm_buffer_get_remaining";
raw_plm_buffer_get_size :: (self: *Native_Buffer) -> u64 #foreign plm_upstream "plm_buffer_get_size";
raw_plm_buffer_has :: (self: *Native_Buffer, count: u64) -> s32 #foreign plm_upstream "plm_buffer_has";
raw_plm_buffer_has_start_code :: (self: *Native_Buffer, code: s32) -> s32 #foreign plm_upstream "plm_buffer_has_start_code";
raw_plm_buffer_next_start_code :: (self: *Native_Buffer) -> s32 #foreign plm_upstream "plm_buffer_next_start_code";
raw_plm_buffer_no_start_code :: (self: *Native_Buffer) -> s32 #foreign plm_upstream "plm_buffer_no_start_code";
raw_plm_buffer_read :: (self: *Native_Buffer, count: s32) -> s32 #foreign plm_upstream "plm_buffer_read";
raw_plm_buffer_read_vlc :: (self: *Native_Buffer, table: *Vlc) -> s16 #foreign plm_upstream "plm_buffer_read_vlc";
raw_plm_buffer_read_vlc_uint :: (self: *Native_Buffer, table: *Vlc_Uint) -> u16 #foreign plm_upstream "plm_buffer_read_vlc_uint";
raw_plm_buffer_rewind :: (self: *Native_Buffer) #foreign plm_upstream "plm_buffer_rewind";
raw_plm_buffer_seek :: (self: *Native_Buffer, pos: u64) #foreign plm_upstream "plm_buffer_seek";
raw_plm_buffer_set_load_callback :: (self: *Native_Buffer, fp: Native_Load_Callback, user: *void) #foreign plm_upstream "plm_buffer_set_load_callback";
raw_plm_buffer_signal_end :: (self: *Native_Buffer) #foreign plm_upstream "plm_buffer_signal_end";
raw_plm_buffer_skip :: (self: *Native_Buffer, count: u64) #foreign plm_upstream "plm_buffer_skip";
raw_plm_buffer_skip_bytes :: (self: *Native_Buffer, v: u8) -> s32 #foreign plm_upstream "plm_buffer_skip_bytes";
raw_plm_buffer_tell :: (self: *Native_Buffer) -> u64 #foreign plm_upstream "plm_buffer_tell";
raw_plm_buffer_write :: (self: *Native_Buffer, bytes: *u8, length: u64) -> u64 #foreign plm_upstream "plm_buffer_write";
raw_plm_create_with_buffer :: (buffer: *Native_Buffer, destroy_when_done: s32) -> *Native_Plm #foreign plm_upstream "plm_create_with_buffer";
raw_plm_decode :: (self: *Native_Plm, seconds: float64) #foreign plm_upstream "plm_decode";
raw_plm_decode_audio :: (self: *Native_Plm) -> *Samples #foreign plm_upstream "plm_decode_audio";
raw_plm_decode_video :: (self: *Native_Plm) -> *Frame #foreign plm_upstream "plm_decode_video";
raw_plm_demux_buffer_seek :: (self: *Native_Demux, pos: u64) #foreign plm_upstream "plm_demux_buffer_seek";
raw_plm_demux_create :: (buffer: *Native_Buffer, destroy_when_done: s32) -> *Native_Demux #foreign plm_upstream "plm_demux_create";
raw_plm_demux_decode :: (self: *Native_Demux) -> *Native_Packet #foreign plm_upstream "plm_demux_decode";
raw_plm_demux_decode_packet :: (self: *Native_Demux, type: s32) -> *Native_Packet #foreign plm_upstream "plm_demux_decode_packet";
raw_plm_demux_decode_time :: (self: *Native_Demux) -> float64 #foreign plm_upstream "plm_demux_decode_time";
raw_plm_demux_destroy :: (self: *Native_Demux) #foreign plm_upstream "plm_demux_destroy";
raw_plm_demux_get_duration :: (self: *Native_Demux, type: s32) -> float64 #foreign plm_upstream "plm_demux_get_duration";
raw_plm_demux_get_num_audio_streams :: (self: *Native_Demux) -> s32 #foreign plm_upstream "plm_demux_get_num_audio_streams";
raw_plm_demux_get_num_video_streams :: (self: *Native_Demux) -> s32 #foreign plm_upstream "plm_demux_get_num_video_streams";
raw_plm_demux_get_packet :: (self: *Native_Demux) -> *Native_Packet #foreign plm_upstream "plm_demux_get_packet";
raw_plm_demux_get_start_time :: (self: *Native_Demux, type: s32) -> float64 #foreign plm_upstream "plm_demux_get_start_time";
raw_plm_demux_has_ended :: (self: *Native_Demux) -> s32 #foreign plm_upstream "plm_demux_has_ended";
raw_plm_demux_has_headers :: (self: *Native_Demux) -> s32 #foreign plm_upstream "plm_demux_has_headers";
raw_plm_demux_rewind :: (self: *Native_Demux) #foreign plm_upstream "plm_demux_rewind";
raw_plm_demux_seek :: (self: *Native_Demux, time: float64, type: s32, force_intra: s32) -> *Native_Packet #foreign plm_upstream "plm_demux_seek";
raw_plm_destroy :: (self: *Native_Plm) #foreign plm_upstream "plm_destroy";
raw_plm_frame_to_abgr :: (frame: *Frame, dest: *u8, stride: s32) #foreign plm_upstream "plm_frame_to_abgr";
raw_plm_frame_to_argb :: (frame: *Frame, dest: *u8, stride: s32) #foreign plm_upstream "plm_frame_to_argb";
raw_plm_frame_to_bgr :: (frame: *Frame, dest: *u8, stride: s32) #foreign plm_upstream "plm_frame_to_bgr";
raw_plm_frame_to_bgra :: (frame: *Frame, dest: *u8, stride: s32) #foreign plm_upstream "plm_frame_to_bgra";
raw_plm_frame_to_rgb :: (frame: *Frame, dest: *u8, stride: s32) #foreign plm_upstream "plm_frame_to_rgb";
raw_plm_frame_to_rgba :: (frame: *Frame, dest: *u8, stride: s32) #foreign plm_upstream "plm_frame_to_rgba";
raw_plm_get_framerate :: (self: *Native_Plm) -> float64 #foreign plm_upstream "plm_get_framerate";
raw_plm_get_height :: (self: *Native_Plm) -> s32 #foreign plm_upstream "plm_get_height";
raw_plm_get_num_video_streams :: (self: *Native_Plm) -> s32 #foreign plm_upstream "plm_get_num_video_streams";
raw_plm_get_width :: (self: *Native_Plm) -> s32 #foreign plm_upstream "plm_get_width";
raw_plm_handle_end :: (self: *Native_Plm) #foreign plm_upstream "plm_handle_end";
raw_plm_has_headers :: (self: *Native_Plm) -> s32 #foreign plm_upstream "plm_has_headers";
raw_plm_init_decoders :: (self: *Native_Plm) -> s32 #foreign plm_upstream "plm_init_decoders";
raw_plm_read_audio_packet :: (buffer: *Native_Buffer, user: *void) #foreign plm_upstream "plm_read_audio_packet";
raw_plm_read_packets :: (self: *Native_Plm, requested_type: s32) #foreign plm_upstream "plm_read_packets";
raw_plm_read_video_packet :: (buffer: *Native_Buffer, user: *void) #foreign plm_upstream "plm_read_video_packet";
raw_plm_rewind :: (self: *Native_Plm) #foreign plm_upstream "plm_rewind";
raw_plm_seek :: (self: *Native_Plm, time: float64, seek_exact: s32) -> s32 #foreign plm_upstream "plm_seek";
raw_plm_seek_frame :: (self: *Native_Plm, time: float64, seek_exact: s32) -> *Frame #foreign plm_upstream "plm_seek_frame";
raw_plm_set_audio_decode_callback :: (self: *Native_Plm, fp: Native_Audio_Callback, user: *void) #foreign plm_upstream "plm_set_audio_decode_callback";
raw_plm_set_audio_enabled :: (self: *Native_Plm, enabled: s32) #foreign plm_upstream "plm_set_audio_enabled";
raw_plm_set_audio_stream :: (self: *Native_Plm, stream_index: s32) #foreign plm_upstream "plm_set_audio_stream";
raw_plm_set_loop :: (self: *Native_Plm, loop: s32) #foreign plm_upstream "plm_set_loop";
raw_plm_set_video_decode_callback :: (self: *Native_Plm, fp: Native_Video_Callback, user: *void) #foreign plm_upstream "plm_set_video_decode_callback";
raw_plm_set_video_enabled :: (self: *Native_Plm, enabled: s32) #foreign plm_upstream "plm_set_video_enabled";
raw_plm_video_copy_macroblock :: (self: *Native_Video, s: *Frame, motion_h: s32, motion_v: s32) #foreign plm_upstream "plm_video_copy_macroblock";
raw_plm_video_create_with_buffer :: (buffer: *Native_Buffer, destroy_when_done: s32) -> *Native_Video #foreign plm_upstream "plm_video_create_with_buffer";
raw_plm_video_decode :: (self: *Native_Video) -> *Frame #foreign plm_upstream "plm_video_decode";
raw_plm_video_decode_block :: (self: *Native_Video, block: s32) #foreign plm_upstream "plm_video_decode_block";
raw_plm_video_decode_macroblock :: (self: *Native_Video) #foreign plm_upstream "plm_video_decode_macroblock";
raw_plm_video_decode_motion_vector :: (self: *Native_Video, r_size: s32, motion: s32) -> s32 #foreign plm_upstream "plm_video_decode_motion_vector";
raw_plm_video_decode_motion_vectors :: (self: *Native_Video) #foreign plm_upstream "plm_video_decode_motion_vectors";
raw_plm_video_decode_picture :: (self: *Native_Video) #foreign plm_upstream "plm_video_decode_picture";
raw_plm_video_decode_sequence_header :: (self: *Native_Video) -> s32 #foreign plm_upstream "plm_video_decode_sequence_header";
raw_plm_video_decode_slice :: (self: *Native_Video, slice: s32) #foreign plm_upstream "plm_video_decode_slice";
raw_plm_video_destroy :: (self: *Native_Video) #foreign plm_upstream "plm_video_destroy";
raw_plm_video_get_framerate :: (self: *Native_Video) -> float64 #foreign plm_upstream "plm_video_get_framerate";
raw_plm_video_has_ended :: (self: *Native_Video) -> s32 #foreign plm_upstream "plm_video_has_ended";
raw_plm_video_has_header :: (self: *Native_Video) -> s32 #foreign plm_upstream "plm_video_has_header";
raw_plm_video_idct :: (block: *s32) #foreign plm_upstream "plm_video_idct";
raw_plm_video_init_frame :: (self: *Native_Video, frame: *Frame, base: *u8) #foreign plm_upstream "plm_video_init_frame";
raw_plm_video_interpolate_macroblock :: (self: *Native_Video, s: *Frame, motion_h: s32, motion_v: s32) #foreign plm_upstream "plm_video_interpolate_macroblock";
raw_plm_video_predict_macroblock :: (self: *Native_Video) #foreign plm_upstream "plm_video_predict_macroblock";
raw_plm_video_process_macroblock :: (self: *Native_Video, s: *u8, d: *u8, mh: s32, mb: s32, bs: s32, interp: s32) #foreign plm_upstream "plm_video_process_macroblock";
raw_plm_video_rewind :: (self: *Native_Video) #foreign plm_upstream "plm_video_rewind";
raw_plm_video_set_no_delay :: (self: *Native_Video, no_delay: s32) #foreign plm_upstream "plm_video_set_no_delay";
raw_plm_video_set_time :: (self: *Native_Video, time: float64) #foreign plm_upstream "plm_video_set_time";

#scope_module
public_callback_user :: (native_user: *void) -> *void {
    entry := plm_states;
    while entry {
        if entry.native == native_user return entry.public;
        entry = entry.next;
    }
    return native_user;
}

#scope_module
native_start_code :: (code: Start_Code) -> s32 {
    if code == .NOT_FOUND return -1;
    return cast(s32) code;
}
