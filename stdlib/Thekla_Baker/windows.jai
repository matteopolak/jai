// Independent declaration normalization; see docs/stdlib/native-bindings.md.
Baker_Sampling_Mode :: enum s32 {
    Fragment_Sampling :: 0;
    Vertex_Sampling_Randomized :: 1;
    Vertex_Sampling_Uniform :: 2;
}

Baker_Input_Info :: struct {
    index_first: s32;
    index_count: s32;
    sampling_mode: Baker_Sampling_Mode;
    sampling_factor: float;
}

Baker_Input_Mesh :: struct {
    vertex_count: s32;
    position_stride: s32;
    normal_stride: s32;
    uv_stride: s32;
    position_ptr: *float;
    normal_ptr: *float;
    uv_ptr: *float;

    index_count: s32;
    index_array: *u32;

    info_count: s32;
    info_array: *Baker_Input_Info;

    lightmap_width: s32;
    lightmap_height: s32;
    mesh_hash: s32;
}

Baker_Input_Points :: struct {
    vertex_count: s32;
    position_ptr: *float;
    position_stride: s32;
    normal_ptr: *float;
    normal_stride: s32;
    uv_ptr: *float;
    uv_stride: s32;
}

Baker_Input_Transform :: struct {
    obj_to_world: Matrix4;
    obj_to_world_normal: Matrix4;
}

Baker_Frame :: struct {

    position: Vector3;
    normal: Vector3;
    tangent: Vector3;
}

Baker_Lightmap :: struct {
    width: s32;
    height: s32;

    data: *void = null;

    data_l0: *void = null;
    data_l1: [3] *void;
}

Baker_Options :: struct {

    atlas_width: s32 = 1024;
    atlas_height: s32 = 1024;
    atlas_count: s32 = 2;

    hemicube_size: s32 = 32;
    quality_factor: float;
    sampling_distance: float;
    smoothing_factor: float;

    output_occlusion_map := false;
    max_occlusion_distance: float = 1.0;
    occlusion_power: float = 2.0;
    add_floor_plane := false;

    Output_Type :: enum s32 {
        NON_DIRECTIONAL_LIGHTMAP :: 0;
        DIRECTIONAL_LIGHTMAP :: 1;
        OCCLUSION_MAP :: 2;
    }

    output_type: Output_Type = .NON_DIRECTIONAL_LIGHTMAP;

    super_sampling := true;
    subpixel_sampling := false;
    generate_edge_samples := true;
    post_process_lightmap := true;
    compress_lightmap := false;

    use_cache := true;
    enable_neighbor_clamping := false;
    random_rotation := true;
    random_seed: u32 = 0;

    ignore_tangent_threshold := false;

    disable_sample_normal_correction := false;

    render_hemicubes: #type (atlas_idx: s32, frame_array: *Baker_Frame, frame_count: s32) -> void #c_call;
    read_hemicubes: #type (atlas_idx: s32, data: *void) -> void #c_call;
    save_lightmap: #type (lightmap: *Baker_Lightmap) -> void #c_call;
    debug_sample: #type (atlas_idx: s32, sample: s32, confidence: float, color: *[3] float, radius: float) -> void #c_call;
}

Log_Print :: #type (unknown0: *u8) -> void #c_call;

baker_init :: (printer: Log_Print) -> void #foreign thekla_baker "?baker_init@Thekla@@YAXP6AXPEBD@Z@Z";
baker_shut :: () -> void #foreign thekla_baker "?baker_shut@Thekla@@YAXXZ";

baker_start :: (input: *Baker_Input_Mesh, xform: *Baker_Input_Transform, options: *Baker_Options) -> void #foreign thekla_baker "?baker_start@Thekla@@YAXPEBUBaker_Input_Mesh@1@PEBUBaker_Input_Transform@1@PEBUBaker_Options@1@@Z";
baker_get_total_number_of_samples :: (inputs: *Baker_Input_Mesh, options: *Baker_Options, num_meshes: s32, total_number_of_samples: *s32) -> void #foreign thekla_baker "?baker_get_total_number_of_samples@Thekla@@YAXPEAUBaker_Input_Mesh@1@PEAUBaker_Options@1@HPEAH@Z";

baker_get_hemicube_viewport :: (idx: s32, face: s32, viewport: *[4] s32) -> void #foreign thekla_baker "?baker_get_hemicube_viewport@Thekla@@YAXHHQEAH@Z";

baker_render_done :: (atlas_idx: s32) -> void #foreign thekla_baker "?baker_render_done@Thekla@@YAXH@Z";
baker_progress :: () -> float #foreign thekla_baker "?baker_progress@Thekla@@YAMXZ";
baker_get_current_mesh_sample_count :: () -> s32 #foreign thekla_baker "?baker_get_current_mesh_sample_count@Thekla@@YAHXZ";

#scope_file

thekla_baker :: #system_library "thekla_baker";
