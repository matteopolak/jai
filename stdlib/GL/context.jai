// The generic retained API accepts the platform's native Window_Type.
gl_create_context :: (win: $Window, major_version: s32 = 0, minor_version: s32 = 0, compatibility := false, debug := false, wanted_msaa: s32 = DEFAULT_MSAA) {
    #if OS == .WINDOWS {
        created, device, actual_samples := wgl_create_context(cast(Window_Type) win,
            major_version = major_version, minor_version = minor_version,
            compatibility = compatibility, debug = debug, wanted_msaa = wanted_msaa);
        assert(created != null, "Unable to create the requested WGL context");
        if !created return;
    } else #if OS == .LINUX {
        created, configuration, actual_samples := _glx_create_context_with_msaa(cast(Window_Type) win,
            major_version, minor_version, compatibility, debug, wanted_msaa);
        assert(created != null, "Unable to create the requested GLX context");
        if !created return;
    } else #if OS == .MACOS {
        window := cast(Window_Type) win;
        assert(window != null, "An NSWindow is required for an OpenGL context");
        if !window return;
        view := GLContextAppKit.NSWindow.contentView(window);
        assert(view != null, "An NSWindow content view is required for OpenGL");
        if !view return;
        created, actual_samples := nsgl_create_context(major_version, minor_version,
            compatibility, debug, wanted_msaa);
        assert(created != null, "Unable to create the requested NSOpenGL context");
        if !created return;
        GLContextAppKit.NSOpenGLContext.setView(created, view);
        view_class := GLContextObjC.object_getClass(cast(GLContextObjC.id) view);
        setter := GLContextObjC.sel_registerName(cast(*u8) "setOpenGLContext:\0");
        if GLContextObjC.class_respondsToSelector(view_class, setter) != 0 {
            GLContextViews.LightweightOpenGLView.setGlContext(cast(*GLContextViews.LightweightOpenGLView) view, created);
        }
        GLContextAppKit.NSOpenGLContext.update(created);
    } else {
        assert(false, "gl_create_context requires a reviewed desktop WGL, GLX, or NSOpenGL implementation");
        return;
    }
    gl_load(*gl);
    if debug gl_enable_debug_output();
}

#scope_module
// Extension names are whitespace-delimited tokens, never substrings.
_gl_context_extension :: (names: *u8, wanted: string) -> bool {
    if !names || wanted.count == 0 return false;
    at: s64 = 0;
    while names[at] != 0 {
        while names[at] == 32 at += 1;
        begin := at;
        while names[at] != 0 && names[at] != 32 at += 1;
        if at - begin == wanted.count {
            equal := true;
            for index: 0..wanted.count - 1 {
                if names[begin + index] != wanted[index] { equal = false; break; }
            }
            if equal return true;
        }
    }
    return false;
}

#scope_file
#if OS == .MACOS {
    GLContextAppKit :: #import "Objective_C/AppKit";
    GLContextObjC :: #import "Objective_C";
    GLContextViews :: #import "Objective_C/LightweightRenderingView";
}
