// OpenGL procedure loading and per-platform context setup.
#if OS == .WINDOWS {
    #import "Windows";
}
#if OS == .LINUX {
    #import "X11";
}
#if ENABLE_ALL_EXTENSIONS {
    #load "glad_all.jai";
} else {
    #load "glad_core.jai";
}
#import "Basic";
#import "String";
#import "Window_Type";
#if OS == .NN_SWITCH {
    #import "NintendoSDK";
}
using gl;
#scope_export
GetProcAddressFunction :: #type (proc: *u8) -> *void #c_call;

_glGetActiveAttrib :: (program: GLuint, index: GLuint, bufSize: GLsizei, length: *GLsizei, size: *GLint, type: *GLenum, $$name: string) {
    assert(bufSize >= 0 && cast(s64) bufSize <= name.count, "GL name buffer is smaller than bufSize");
    assert(bufSize == 0 || name.data != null, "GL name buffer is null");
    gl.glGetActiveAttrib(program, index, bufSize, length, size, type, cast(*GLchar) name.data);
}
_glGetActiveUniform :: (program: GLuint, index: GLuint, bufSize: GLsizei, length: *GLsizei, size: *GLint, type: *GLenum, $$name: string) {
    assert(bufSize >= 0 && cast(s64) bufSize <= name.count, "GL name buffer is smaller than bufSize");
    assert(bufSize == 0 || name.data != null, "GL name buffer is null");
    gl.glGetActiveUniform(program, index, bufSize, length, size, type, cast(*GLchar) name.data);
}

#if OS == .WINDOWS {}
#if OS == .LINUX {}
#if OS == .MACOS {
    #import "Objective_C";
    #import "Objective_C/AppKit";
    #import "Objective_C/LightweightRenderingView";
    Window_Creation :: #import "Window_Creation";
    #scope_file
    _gl_framework_image: *void;
    #scope_export
    nsgl_get_proc_address :: (name: string) -> *void {
        return _gl_symbol(cast(*void) -2, temp_c_string(name));
    }
}
#scope_file


#scope_export


#scope_file
