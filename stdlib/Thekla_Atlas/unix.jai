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
atlas_set_message_callback :: (callback: Atlas_Message_Callback, _context: *void) -> void #foreign thekla_atlas "_ZN6Thekla26atlas_set_message_callbackEPFvPKcPvES2_";

Atlas_Assert_Callback :: #type (exp: *u8, file: *u8, line: s32, func: *u8, msg: *u8, _context: *void) -> void #c_call;
atlas_set_assert_callback :: (callback: Atlas_Assert_Callback, _context: *void) -> void #foreign thekla_atlas "_ZN6Thekla25atlas_set_assert_callbackEPFvPKcS1_iS1_S1_PvES2_";

atlas_set_default_options :: (options: *Atlas_Options) -> void #foreign thekla_atlas "_ZN6Thekla25atlas_set_default_optionsEPNS_13Atlas_OptionsE";

atlas_generate :: (input: *Atlas_Input_Mesh, options: *Atlas_Options, error: *Atlas_Error, error_data: **Atlas_Error_Data) -> *Atlas_Output_Mesh #foreign thekla_atlas "_ZN6Thekla14atlas_generateEPKNS_16Atlas_Input_MeshEPKNS_13Atlas_OptionsEPNS_11Atlas_ErrorEPPNS_16Atlas_Error_DataE";

atlas_free :: (output: *Atlas_Output_Mesh) -> void #foreign thekla_atlas "_ZN6Thekla10atlas_freeEPNS_17Atlas_Output_MeshE";
atlas_free :: (output: *Atlas_Error_Data) -> void #foreign thekla_atlas "_ZN6Thekla10atlas_freeEPNS_16Atlas_Error_DataE";

#scope_file

#import "Basic";

#if OS == .LINUX {
    thekla_atlas :: #system_library "jai_thekla_atlas_adapter";
} else #if OS == .MACOS {
    thekla_atlas :: #system_library "jai_thekla_atlas_adapter";
} else {
    #assert false;
}
