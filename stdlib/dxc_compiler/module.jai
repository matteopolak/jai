// Independently normalized ABI contract. No reference procedure bodies or binaries.
Shader_Type :: enum {
    Vertex ;
    Fragment ;
    Compute ;
    Hull ;
    Domain ;
    Mesh ;
    Amplification ;
    Library ;
}
Dxc_Shader_Compiler_Args :: struct {
    shader_name : string ;
    shader_source : string ;
    shader_model_version : string ;
    shader_type : Shader_Type ;
    entry_point : string ;
    defines : [ ] string ;
    extra_args : [ ] string ;
    add_debug_info : bool ;
    warnings_as_error : bool ;
    skip_optimization : bool ;
    compile_as_spirv : bool ;
    use_spirv_1_4 : bool ;
}
#scope_module
CLSID_DxcUtils :: #run uid ( "6245D6AF-66E0-48FD-80B4-4D271796748C" ) ;
CLSID_DxcCompiler :: #run uid ( "73E22D93-E6CE-47F3-B5BF-F0664F39C1B0" ) ;
IDxcUtils_UID :: #run uid ( "4605C4CB-2019-492A-ADA4-65F20BB7D67F" ) ;
IDxcCompiler3_UID :: #run uid ( "228B4687-5A6A-4730-900C-9702B2203F54" ) ;
IDxcResult_UID :: #run uid ( "58346CDA-DDE7-4497-9461-6F87AF5E0659" ) ;
IDxcBlobUtf8_UID :: #run uid ( "3DA636C9-BA71-4024-A301-30CBF125305B" ) ;
#scope_module
IMalloc :: struct {
}
;
IStream :: struct {
}
;
BSTR :: struct {
}
;
#load "dxc_compiler_bindings.jai" ;
#import "Windows_Utf8" ;
#import "Windows" ;
#import "d3d12" ;


#load "compile-helpers.jai";
