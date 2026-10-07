// Direct3D 11 bindings.
#module_parameters ()(INCLUDE_DEBUG_BINDINGS := false);
WKPDID_D3DDebugObjectName :: "429b8c22-9188-4b0c-8742-acb0bf85c200";

#import "dxgi";
#import "Windows";
#import "d3d_compiler";
#load "d3d11_bindings.jai";

#if INCLUDE_DEBUG_BINDINGS {
    #load "d3d11_debug_bindings.jai";
}
