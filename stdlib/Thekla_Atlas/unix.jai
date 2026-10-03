// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
Atlas_Charter :: enum u32 {
    Witness :: 0;
    Extract :: 1;
    Default :: 0;
}

Atlas_Mapper :: enum u32 {
    LSCM    :: 0;
    Default :: 0;
}

Atlas_Packer :: enum u32 {
    Witness :: 0;
    Default :: 0;
}

Atlas_Options :: struct {
    mesh_options:    struct {
        fix_nonmanifold_meshes: bool;
    };

    charter:         Atlas_Charter;
    charter_options: union {
        witness: struct {
            proxy_fit_metric_weight:    float;
            roundness_metric_weight:    float;
            straightness_metric_weight: float;
            normal_seam_metric_weight:  float;
            texture_seam_metric_weight: float;
            max_chart_area:             float;
            max_boundary_length:        float;
        };

        extract: struct {
            __empty_struct_padding: u8;
        };
    };

    mapper:          Atlas_Mapper;
    mapper_options:  struct {
        preserve_uvs:      bool;
        preserve_boundary: bool;
    };

    packer:          Atlas_Packer;
    packer_options:  union {
        witness: struct {
            packing_quality: s32;
            texels_per_unit: float;
            block_align:     bool;
            conservative:    bool;
        };
    };
}

Atlas_Input_Vertex :: struct {
    position:      Vector3;
    normal:        Vector3;
    uv:            Vector2;
    first_colocal: s32;
}

Atlas_Input_Face :: struct {
    vertex_index:   [3] s32;
    material_index: s32;
}

Atlas_Input_Mesh :: struct {
    vertex_count: s32;
    face_count:   s32;
    vertex_array: *Atlas_Input_Vertex;
    face_array:   *Atlas_Input_Face;
}

Atlas_Output_Vertex :: struct {
    uv:   Vector2;
    xref: s32;
}

Atlas_Output_Mesh :: struct {
    atlas_width:  s32;
    atlas_height: s32;
    vertex_count: s32;
    index_count:  s32;
    vertex_array: *Atlas_Output_Vertex;
    index_array:  *s32;
}

Atlas_Error :: enum u32 {
    Success                   :: 0;
    Invalid_Args              :: 1;
    Invalid_Options           :: 2;
    Invalid_Mesh              :: 3;
    Invalid_Mesh_Non_Manifold :: 4;
    Chart_Failure             :: 5;
    Parameterization_Failure  :: 6;
    Not_Implemented           :: 7;
}

Atlas_Error_Subtype :: enum u32 {
    Duplicate_Edge_Or_Face :: 0;
    None                   :: 1;
}

Atlas_Error_Data :: struct {
    error_subtype: Atlas_Error_Subtype;
    index_count:   s32;
    index_array:   *s32;
}

Atlas_Message_Callback :: #type (msg: *u8, _context: *void) -> void #c_call;
atlas_set_message_callback :: (callback: Atlas_Message_Callback, _context: *void) -> void {
    atlas_message_callback = callback;
    atlas_message_context = _context;
    native_atlas_set_debug_output(atlas_debug_output);
}

Atlas_Assert_Callback :: #type (exp: *u8, file: *u8, line: s32, func: *u8, msg: *u8, _context: *void) -> void #c_call;
atlas_set_assert_callback :: (callback: Atlas_Assert_Callback, _context: *void) -> void {
    atlas_assert_callback = callback;
    atlas_assert_context = _context;
}

atlas_set_default_options :: (options: *Atlas_Options) -> void {
    native: Native_Atlas_Options;
    native_atlas_default_options(*native);
    options.* = .{};
    options.charter = native.charter;
    options.charter_options.witness.proxy_fit_metric_weight = native.charter_options.witness.proxy_fit_metric_weight;
    options.charter_options.witness.roundness_metric_weight = native.charter_options.witness.roundness_metric_weight;
    options.charter_options.witness.straightness_metric_weight = native.charter_options.witness.straightness_metric_weight;
    options.charter_options.witness.normal_seam_metric_weight = native.charter_options.witness.normal_seam_metric_weight;
    options.charter_options.witness.texture_seam_metric_weight = native.charter_options.witness.texture_seam_metric_weight;
    options.charter_options.witness.max_chart_area = native.charter_options.witness.max_chart_area;
    options.charter_options.witness.max_boundary_length = native.charter_options.witness.max_boundary_length;
    options.mapper = native.mapper;
    options.mapper_options.preserve_uvs = native.mapper_options.preserve_uvs;
    options.mapper_options.preserve_boundary = native.mapper_options.preserve_boundary;
    options.packer = native.packer;
    options.packer_options.witness.packing_quality = native.packer_options.witness.packing_quality;
    options.packer_options.witness.texels_per_unit = native.packer_options.witness.texels_per_unit;
    options.packer_options.witness.block_align = native.packer_options.witness.block_align;
    options.packer_options.witness.conservative = native.packer_options.witness.conservative;
}

atlas_generate :: (input: *Atlas_Input_Mesh, options: *Atlas_Options, error: *Atlas_Error, error_data: **Atlas_Error_Data) -> *Atlas_Output_Mesh {
    return generate_with_current_atlas(input, options, error, error_data);
}

atlas_free :: (output: *Atlas_Output_Mesh) -> void {
    native_atlas_free(output);
}
atlas_free :: (output: *Atlas_Error_Data) -> void {
    if !output return;
    Basic.free(output.index_array);
    Basic.free(output);
}

#scope_file

#import "Basic";

#if OS == .LINUX {

} else #if OS == .MACOS {

} else {
    #assert false;
}
