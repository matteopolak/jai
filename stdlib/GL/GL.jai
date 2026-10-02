// Independently normalized ABI contract. No reference procedure bodies or binaries.
#if ENABLE_ALL_EXTENSIONS {
    #load "glad_all.jai" ;
}
else {
    #load "glad_core.jai" ;
}
#import "Basic" ;
#import "Compiler" ;
#import "String" ;
#import "Window_Type" ;
#if OS == . NN_SWITCH {
    #import "NintendoSDK" ;
}
using gl ;
#scope_export
GetProcAddressFunction :: #type ( proc : * u8 ) -> * void #c_call ;

_glGetActiveAttrib :: ( program : GLuint , index : GLuint , bufSize : GLsizei , length : * GLsizei , size : * GLint , type : * GLenum , $$ name : string ) #foreign Native_Adapters ;
_glGetActiveUniform :: ( program : GLuint , index : GLuint , bufSize : GLsizei , length : * GLsizei , size : * GLint , type : * GLenum , $$ name : string ) #foreign Native_Adapters ;

#if OS == . WINDOWS {
    wgl_create_context :: ( hwnd : HWND , share : HGLRC = null , major_version : s32 = 0 , minor_version : s32 = 0 , compatibility := false , debug := false , wanted_msaa : s32 = DEFAULT_MSAA ) -> HGLRC , HDC , chosen_msaa : s32 #foreign Native_Adapters ;
}
#if OS == . LINUX {
    glx_create_context :: ( window : Window_Type , major_version : s32 = 0 , minor_version : s32 = 0 , compatibility := false , debug := false ) -> GLXContext , GLXFBConfig , chosen_msaa : s32 #foreign Native_Adapters ;
}
#if OS == . MACOS {
    #import "Objective_C" ;
    #import "Objective_C/AppKit" ;
    #import "Objective_C/LightweightRenderingView" ;
    Window_Creation :: #import "Window_Creation" ;
    #scope_file
    _gl_framework_image : * void ;
    #scope_export
    nsgl_get_proc_address :: ( name : string ) -> * void {
        return _gl_symbol(cast(*void) -2, temp_c_string(name));
    }
}
gl_create_context :: ( win : $ Window , major_version : s32 = 0 , minor_version : s32 = 0 , compatibility := false , debug := false , wanted_msaa : s32 = DEFAULT_MSAA ) #foreign Native_Adapters ;
#scope_file


#scope_export


#scope_file
Native_Adapters :: #system_library "jai-stdlib-native-adapters";
