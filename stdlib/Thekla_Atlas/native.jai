// Independent compatibility logic over the reviewed official Atlas header.
#scope_module
Native_Atlas_Options :: struct {
    charter: Atlas_Charter;
    charter_options: union {
        witness: struct {
            proxy_fit_metric_weight: float;
            roundness_metric_weight: float;
            straightness_metric_weight: float;
            normal_seam_metric_weight: float;
            texture_seam_metric_weight: float;
            max_chart_area: float;
            max_boundary_length: float;
        };
        extract: struct {
            __empty_struct_padding: u8;
        };
    };
    mapper: Atlas_Mapper;
    mapper_options: struct {
        preserve_uvs: bool;
        preserve_boundary: bool;
    };
    packer: Atlas_Packer;
    packer_options: union {
        witness: struct {
            packing_quality: s32;
            texels_per_unit: float;
            block_align: bool;
            conservative: bool;
        };
    };
}
atlas_message_callback: Atlas_Message_Callback;
atlas_message_context: *void;
atlas_assert_callback: Atlas_Assert_Callback;
atlas_assert_context: *void;
atlas_debug_output :: (message: *u8) #c_call {
    if atlas_message_callback atlas_message_callback(message, atlas_message_context);
}
atlas_notify_invalid :: () {
    if atlas_assert_callback atlas_assert_callback(atlas_invalid_expression.data, atlas_empty_string.data, 0, atlas_function_name.data,
                                                  atlas_invalid_message.data, atlas_assert_context);
}
to_current_options :: (source: *Atlas_Options) -> Native_Atlas_Options {
    result: Native_Atlas_Options;
    result.charter = source.charter;
    result.charter_options.witness.proxy_fit_metric_weight = source.charter_options.witness.proxy_fit_metric_weight;
    result.charter_options.witness.roundness_metric_weight = source.charter_options.witness.roundness_metric_weight;
    result.charter_options.witness.straightness_metric_weight = source.charter_options.witness.straightness_metric_weight;
    result.charter_options.witness.normal_seam_metric_weight = source.charter_options.witness.normal_seam_metric_weight;
    result.charter_options.witness.texture_seam_metric_weight = source.charter_options.witness.texture_seam_metric_weight;
    result.charter_options.witness.max_chart_area = source.charter_options.witness.max_chart_area;
    result.charter_options.witness.max_boundary_length = source.charter_options.witness.max_boundary_length;
    result.mapper = source.mapper;
    result.mapper_options.preserve_uvs = source.mapper_options.preserve_uvs;
    result.mapper_options.preserve_boundary = source.mapper_options.preserve_boundary;
    result.packer = source.packer;
    result.packer_options.witness.packing_quality = source.packer_options.witness.packing_quality;
    result.packer_options.witness.texels_per_unit = source.packer_options.witness.texels_per_unit;
    result.packer_options.witness.block_align = source.packer_options.witness.block_align;
    result.packer_options.witness.conservative = source.packer_options.witness.conservative;
    return result;
}
atlas_error_from_current :: (native_error: s32) -> Atlas_Error {
    if native_error == 5 return .Not_Implemented;
    return cast(Atlas_Error) native_error;
}
generate_with_current_atlas :: (input: *Atlas_Input_Mesh, options: *Atlas_Options,
                                error: *Atlas_Error, error_data: **Atlas_Error_Data) -> *Atlas_Output_Mesh {
    if error_data error_data.* = null;
    if error error.* = .Success;
    valid := input != null && options != null;
    if valid valid = input.vertex_count >= 0 && input.face_count >= 0 &&
                      (input.vertex_count == 0 || input.vertex_array != null) &&
                      (input.face_count == 0 || input.face_array != null);
    if valid {
        for face: 0..input.face_count - 1 {
            for corner: 0..2 {
                index := input.face_array[face].vertex_index[corner];
                if index < 0 || index >= input.vertex_count valid = false;
            }
        }
    }
    if !valid {
        if error error.* = .Invalid_Args;
        atlas_notify_invalid();
        return null;
    }
    native_options := to_current_options(options);
    native_error: s32;
    result := native_atlas_generate(input, *native_options, *native_error);
    // The old mesh repair option is implemented independently by isolating the
    // faces only when the upstream engine rejects their shared topology.
    if !result && native_error == 4 && options.mesh_options.fix_nonmanifold_meshes {
        result, native_error = atlas_retry_isolated_faces(input, *native_options);
    }
    if error error.* = atlas_error_from_current(native_error);
    // Current upstream provides an error enum, but no rich native error record.
    return result;
}
atlas_retry_isolated_faces :: (input: *Atlas_Input_Mesh, options: *Native_Atlas_Options) -> (*Atlas_Output_Mesh, s32) {
    if input.face_count > S32_MAX / 3 return null, 3;
    count := input.face_count * 3;
    vertices := cast(*Atlas_Input_Vertex) Basic.alloc(cast(s64) count * size_of(Atlas_Input_Vertex));
    faces := cast(*Atlas_Input_Face) Basic.alloc(cast(s64) input.face_count * size_of(Atlas_Input_Face));
    if !vertices || !faces {
        Basic.free(vertices);
        Basic.free(faces);
        return null, 3;
    }
    defer Basic.free(vertices);
    defer Basic.free(faces);
    for face: 0..input.face_count - 1 {
        faces[face].material_index = input.face_array[face].material_index;
        for corner: 0..2 {
            vertex := face * 3 + corner;
            original := input.face_array[face].vertex_index[corner];
            vertices[vertex] = input.vertex_array[original];
            vertices[vertex].first_colocal = vertex;
            faces[face].vertex_index[corner] = vertex;
        }
    }
    isolated: Atlas_Input_Mesh = .{ count, input.face_count, vertices, faces };
    error: s32;
    result := native_atlas_generate(*isolated, options, *error);
    if result {
        for index: 0..result.vertex_count - 1 {
            clone := result.vertex_array[index].xref;
            Basic.assert(clone >= 0 && clone < count);
            result.vertex_array[index].xref = input.face_array[clone / 3].vertex_index[clone % 3];
        }
    }
    return result, error;
}

#scope_module
atlas_upstream :: #system_library "thekla_atlas";
#if OS == .WINDOWS {
    native_atlas_set_debug_output :: (callback: #type (message: *u8) #c_call) #foreign atlas_upstream "?atlas_set_debug_output@Thekla@@YAXP6AXPEBD@Z@Z";
    native_atlas_default_options :: (options: *Native_Atlas_Options) #foreign atlas_upstream "?atlas_set_default_options@Thekla@@YAXPEAUAtlas_Options@1@@Z";
    native_atlas_generate :: (input: *Atlas_Input_Mesh, options: *Native_Atlas_Options, error: *s32) -> *Atlas_Output_Mesh #foreign atlas_upstream "?atlas_generate@Thekla@@YAPEAUAtlas_Output_Mesh@1@PEBUAtlas_Input_Mesh@1@PEBUAtlas_Options@1@PEAW4Atlas_Error@1@@Z";
    native_atlas_free :: (output: *Atlas_Output_Mesh) #foreign atlas_upstream "?atlas_free@Thekla@@YAXPEAUAtlas_Output_Mesh@1@@Z";
} else {
    native_atlas_set_debug_output :: (callback: #type (message: *u8) #c_call) #foreign atlas_upstream "_ZN6Thekla22atlas_set_debug_outputEPFvPKcE";
    native_atlas_default_options :: (options: *Native_Atlas_Options) #foreign atlas_upstream "_ZN6Thekla25atlas_set_default_optionsEPNS_13Atlas_OptionsE";
    native_atlas_generate :: (input: *Atlas_Input_Mesh, options: *Native_Atlas_Options, error: *s32) -> *Atlas_Output_Mesh #foreign atlas_upstream "_ZN6Thekla14atlas_generateEPKNS_16Atlas_Input_MeshEPKNS_13Atlas_OptionsEPNS_11Atlas_ErrorE";
    native_atlas_free :: (output: *Atlas_Output_Mesh) #foreign atlas_upstream "_ZN6Thekla10atlas_freeEPNS_17Atlas_Output_MeshE";
}

#scope_module
atlas_invalid_expression :: "valid mesh inputs\0";
atlas_empty_string :: "\0";
atlas_function_name :: "atlas_generate\0";
atlas_invalid_message :: "Invalid mesh counts, pointers or vertex indices\0";
