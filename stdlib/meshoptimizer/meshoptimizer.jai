// Independent declaration normalization; see docs/stdlib/native-bindings.md.
MESHOPTIMIZER_VERSION :: 110;

MESHOPTIMIZER_EXPERIMENTAL :: true;

meshopt_Stream :: struct {
    data: *void;
    size: u64;
    stride: u64;
}

meshopt_generateVertexRemap :: (destination: *u32, indices: *u32, index_count: u64, vertices: *void, vertex_count: u64, vertex_size: u64) -> u64 #foreign meshopt_lib;

#if MESHOPTIMIZER_EXPERIMENTAL {

    meshopt_generateVertexRemapMulti :: (destination: *u32, indices: *u32, index_count: u64, vertex_count: u64, streams: *meshopt_Stream, stream_count: u64) -> u64 #foreign meshopt_lib;
}

meshopt_remapVertexBuffer :: (destination: *void, vertices: *void, vertex_count: u64, vertex_size: u64, remap: *u32) -> void #foreign meshopt_lib;

meshopt_remapIndexBuffer :: (destination: *u32, indices: *u32, index_count: u64, remap: *u32) -> void #foreign meshopt_lib;

#if MESHOPTIMIZER_EXPERIMENTAL {

    meshopt_generateShadowIndexBuffer :: (destination: *u32, indices: *u32, index_count: u64, vertices: *void, vertex_count: u64, vertex_size: u64, vertex_stride: u64) -> void #foreign meshopt_lib;

    meshopt_generateShadowIndexBufferMulti :: (destination: *u32, indices: *u32, index_count: u64, vertex_count: u64, streams: *meshopt_Stream, stream_count: u64) -> void #foreign meshopt_lib;
}

meshopt_optimizeVertexCache :: (destination: *u32, indices: *u32, index_count: u64, vertex_count: u64) -> void #foreign meshopt_lib;

meshopt_optimizeVertexCacheFifo :: (destination: *u32, indices: *u32, index_count: u64, vertex_count: u64, cache_size: u32) -> void #foreign meshopt_lib;

meshopt_optimizeOverdraw :: (destination: *u32, indices: *u32, index_count: u64, vertex_positions: *float, vertex_count: u64, vertex_positions_stride: u64, threshold: float) -> void #foreign meshopt_lib;

meshopt_optimizeVertexFetch :: (destination: *void, indices: *u32, index_count: u64, vertices: *void, vertex_count: u64, vertex_size: u64) -> u64 #foreign meshopt_lib;

meshopt_optimizeVertexFetchRemap :: (destination: *u32, indices: *u32, index_count: u64, vertex_count: u64) -> u64 #foreign meshopt_lib;

meshopt_encodeIndexBuffer :: (buffer: *u8, buffer_size: u64, indices: *u32, index_count: u64) -> u64 #foreign meshopt_lib;
meshopt_encodeIndexBufferBound :: (index_count: u64, vertex_count: u64) -> u64 #foreign meshopt_lib;

meshopt_decodeIndexBuffer :: (destination: *void, index_count: u64, index_size: u64, buffer: *u8, buffer_size: u64) -> s32 #foreign meshopt_lib;

meshopt_encodeVertexBuffer :: (buffer: *u8, buffer_size: u64, vertices: *void, vertex_count: u64, vertex_size: u64) -> u64 #foreign meshopt_lib;
meshopt_encodeVertexBufferBound :: (vertex_count: u64, vertex_size: u64) -> u64 #foreign meshopt_lib;

meshopt_decodeVertexBuffer :: (destination: *void, vertex_count: u64, vertex_size: u64, buffer: *u8, buffer_size: u64) -> s32 #foreign meshopt_lib;

#if MESHOPTIMIZER_EXPERIMENTAL {

    meshopt_simplify :: (destination: *u32, indices: *u32, index_count: u64, vertex_positions: *float, vertex_count: u64, vertex_positions_stride: u64, target_index_count: u64, target_error: float) -> u64 {
        return native_simplify(destination, indices, index_count, vertex_positions, vertex_count,
                               vertex_positions_stride, target_index_count, target_error, 0, null);
    }

    meshopt_simplifySloppy :: (destination: *u32, indices: *u32, index_count: u64, vertex_positions: *float, vertex_count: u64, vertex_positions_stride: u64, target_index_count: u64) -> u64 {
        return native_simplify_sloppy(destination, indices, index_count, vertex_positions, vertex_count,
                                      vertex_positions_stride, null, target_index_count, 1.0, null);
    }
}

meshopt_stripify :: (destination: *u32, indices: *u32, index_count: u64, vertex_count: u64, restart_index: u32) -> u64 #foreign meshopt_lib;
meshopt_stripifyBound :: (index_count: u64) -> u64 #foreign meshopt_lib;

meshopt_unstripify :: (destination: *u32, indices: *u32, index_count: u64, restart_index: u32) -> u64 #foreign meshopt_lib;
meshopt_unstripifyBound :: (index_count: u64) -> u64 #foreign meshopt_lib;

meshopt_VertexCacheStatistics :: struct {
    vertices_transformed: u32;
    warps_executed: u32;
    acmr: float;
    atvr: float;
}

meshopt_analyzeVertexCache :: (indices: *u32, index_count: u64, vertex_count: u64, cache_size: u32, warp_size: u32, primgroup_size: u32) -> meshopt_VertexCacheStatistics #foreign meshopt_lib;

meshopt_OverdrawStatistics :: struct {
    pixels_covered: u32;
    pixels_shaded: u32;
    overdraw: float;
}

meshopt_analyzeOverdraw :: (indices: *u32, index_count: u64, vertex_positions: *float, vertex_count: u64, vertex_positions_stride: u64) -> meshopt_OverdrawStatistics #foreign meshopt_lib;

meshopt_VertexFetchStatistics :: struct {
    bytes_fetched: u32;
    overfetch: float;
}

meshopt_analyzeVertexFetch :: (indices: *u32, index_count: u64, vertex_count: u64, vertex_size: u64) -> meshopt_VertexFetchStatistics #foreign meshopt_lib;

meshopt_Meshlet :: struct {
    vertices: [64] u32;
    indices: [126][3] u8;
    triangle_count: u8;
    vertex_count: u8;
}

#if MESHOPTIMIZER_EXPERIMENTAL {

    meshopt_buildMeshlets :: (destination: *meshopt_Meshlet, indices: *u32, index_count: u64, vertex_count: u64, max_vertices: u64, max_triangles: u64) -> u64 {
        assert(max_vertices >= 3 && max_vertices <= 64);
        assert(max_triangles >= 1 && max_triangles <= 126);
        assert(index_count % 3 == 0);
        if index_count == 0 return 0;
        bound := meshopt_buildMeshletsBound(index_count, max_vertices, max_triangles);
        native_meshlets := cast(*Native_Meshlet) alloc(cast(s64) (bound * size_of(Native_Meshlet)));
        vertices := cast(*u32) alloc(cast(s64) (index_count * size_of(u32)));
        triangles := cast(*u8) alloc(cast(s64) (bound * (max_triangles * 3 + 3)));
        assert(native_meshlets && vertices && triangles);
        defer free(native_meshlets);
        defer free(vertices);
        defer free(triangles);
        result := native_build_meshlets_scan(native_meshlets, vertices, triangles, indices,
                                             index_count, vertex_count, max_vertices, max_triangles);
        for meshlet_index: 0..cast(s64) result - 1 {
            source := *native_meshlets[meshlet_index];
            target := *destination[meshlet_index];
            target.* = .{};
            target.vertex_count = cast(u8) source.vertex_count;
            target.triangle_count = cast(u8) source.triangle_count;
            for vertex: 0..cast(s64) source.vertex_count - 1
                target.vertices[vertex] = vertices[source.vertex_offset + vertex];
            for triangle: 0..cast(s64) source.triangle_count - 1 {
                for corner: 0..2
                    target.indices[triangle][corner] = triangles[source.triangle_offset + triangle * 3 + corner];
            }
        }
        return result;
    }
    meshopt_buildMeshletsBound :: (index_count: u64, max_vertices: u64, max_triangles: u64) -> u64 #foreign meshopt_lib;

    meshopt_Bounds :: struct {
        center: [3] float;
        radius: float;
        cone_apex: [3] float;
        cone_axis: [3] float;
        cone_cutoff: float;
        cone_axis_s8: [3] s8;
        cone_cutoff_s8: s8;
    }

    meshopt_computeClusterBounds :: (indices: *u32, index_count: u64, vertex_positions: *float, vertex_count: u64, vertex_positions_stride: u64) -> meshopt_Bounds #foreign meshopt_lib;
    meshopt_computeMeshletBounds :: (meshlet: *meshopt_Meshlet, vertex_positions: *float, vertex_count: u64, vertex_positions_stride: u64) -> meshopt_Bounds {
        return native_compute_meshlet_bounds(*meshlet.vertices[0], *meshlet.indices[0][0],
                                              meshlet.triangle_count, vertex_positions,
                                              vertex_count, vertex_positions_stride);
    }

    meshopt_setAllocator :: (allocate: #type (a0: u64) -> *void #c_call, deallocate: #type (a0: *void) -> void #c_call) -> void #foreign meshopt_lib;
}

#scope_file

#if OS == .WINDOWS meshopt_lib :: #system_library "meshoptimizer";
#if OS == .MACOS meshopt_lib :: #system_library "meshoptimizer";
#if OS == .LINUX meshopt_lib :: #system_library "meshoptimizer";

// The public contract remains 0.11; these private calls use the reviewed 1.3 C ABI.
#scope_file
#import "Basic";
Native_Meshlet :: struct {
    vertex_offset: u32;
    triangle_offset: u32;
    vertex_count: u32;
    triangle_count: u32;
}
native_simplify :: (destination: *u32, indices: *u32, index_count: u64, vertex_positions: *float,
                     vertex_count: u64, vertex_positions_stride: u64, target_index_count: u64,
                     target_error: float, options: u32, result_error: *float) -> u64
                     #foreign meshopt_lib "meshopt_simplify";
native_simplify_sloppy :: (destination: *u32, indices: *u32, index_count: u64, vertex_positions: *float,
                            vertex_count: u64, vertex_positions_stride: u64, vertex_lock: *u8,
                            target_index_count: u64, target_error: float, result_error: *float) -> u64
                            #foreign meshopt_lib "meshopt_simplifySloppy";
native_build_meshlets_scan :: (meshlets: *Native_Meshlet, vertices: *u32, triangles: *u8,
                                indices: *u32, index_count: u64, vertex_count: u64,
                                max_vertices: u64, max_triangles: u64) -> u64
                                #foreign meshopt_lib "meshopt_buildMeshletsScan";
native_compute_meshlet_bounds :: (vertices: *u32, triangles: *u8, triangle_count: u64,
                                   vertex_positions: *float, vertex_count: u64,
                                   vertex_positions_stride: u64) -> meshopt_Bounds
                                   #foreign meshopt_lib "meshopt_computeMeshletBounds";
