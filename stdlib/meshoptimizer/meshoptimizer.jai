// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
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

    meshopt_simplify :: (destination: *u32, indices: *u32, index_count: u64, vertex_positions: *float, vertex_count: u64, vertex_positions_stride: u64, target_index_count: u64, target_error: float) -> u64 #foreign meshopt_lib;

    meshopt_simplifySloppy :: (destination: *u32, indices: *u32, index_count: u64, vertex_positions: *float, vertex_count: u64, vertex_positions_stride: u64, target_index_count: u64) -> u64 #foreign meshopt_lib;
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
    indices: [126] [3] u8;
    triangle_count: u8;
    vertex_count: u8;
}

#if MESHOPTIMIZER_EXPERIMENTAL {

    meshopt_buildMeshlets :: (destination: *meshopt_Meshlet, indices: *u32, index_count: u64, vertex_count: u64, max_vertices: u64, max_triangles: u64) -> u64 #foreign meshopt_lib;
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
    meshopt_computeMeshletBounds :: (meshlet: *meshopt_Meshlet, vertex_positions: *float, vertex_count: u64, vertex_positions_stride: u64) -> meshopt_Bounds #foreign meshopt_lib;

    meshopt_setAllocator :: (allocate: #type (a0: u64) -> *void #c_call, deallocate: #type (a0: *void) -> void #c_call) -> void #foreign meshopt_lib;
}

#scope_file

#if OS == .WINDOWS  meshopt_lib :: #system_library "jai_meshoptimizer_0_11_adapter";
#if OS == .MACOS    meshopt_lib :: #system_library "jai_meshoptimizer_0_11_adapter";
#if OS == .LINUX    meshopt_lib :: #system_library "jai_meshoptimizer_0_11_adapter";
