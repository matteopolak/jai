// Independent procedure lookup and version/extension queries. A current GL
// context is required before loading its context-owned procedure addresses.
gl_parse_version :: (version: string) -> major: s32, minor: s32 {
    at: s64 = 0;
    while at < version.count && (version[at] < 48 || version[at] > 57) at += 1;
    major: s32 = 0;
    minor: s32 = 0;
    while at < version.count && version[at] >= 48 && version[at] <= 57 {
        major = major * 10 + cast(s32)(version[at] - 48);
        at += 1;
    }
    if at < version.count && (version[at] == 46 || version[at] == 95) at += 1;
    while at < version.count && version[at] >= 48 && version[at] <= 57 {
        minor = minor * 10 + cast(s32)(version[at] - 48);
        at += 1;
    }
    return major, minor;
}

gl_get_version :: () -> major: s32, minor: s32 {
    text := gl.glGetString(GL_VERSION);
    if !text return 0, 0;
    return gl_parse_version(_gl_string(text));
}

gl_supports_extension :: (ext: string) -> bool {
    return _gl_has_extension(*gl, ext);
}

#if ENABLE_ALL_EXTENSIONS {
    #load "load-all.jai";
} else {
    #load "load-core.jai";
}

#scope_module
_gl_string :: (data: *u8) -> string {
    if !data return "";
    count: s64 = 0;
    while data[count] != 0 count += 1;
    result: string;
    result.data = data;
    result.count = count;
    return result;
}

_gl_has_extension :: (procs: *GL_Procedures, wanted: string) -> bool {
    if wanted.count == 0 return false;
    for wanted if it == 32 return false;
    if procs.gl_version_major >= 3 && procs.glGetStringi != null {
        count: GLint = 0;
        procs.glGetIntegerv(GL_NUM_EXTENSIONS, *count);
        if count <= 0 return false;
        for index: 0..count - 1 {
            name := procs.glGetStringi(GL_EXTENSIONS, cast(GLuint) index);
            if name && _gl_string(name) == wanted return true;
        }
        return false;
    }
    names := procs.glGetString(GL_EXTENSIONS);
    if !names return false;
    text := _gl_string(names);
    begin: s64 = 0;
    while begin < text.count {
        while begin < text.count && text[begin] == 32 begin += 1;
        end := begin;
        while end < text.count && text[end] != 32 end += 1;
        portion: string;
        portion.data = text.data + begin;
        portion.count = end - begin;
        if portion == wanted return true;
        begin = end;
    }
    return false;
}

_gl_platform_get_proc :: (name: *u8) -> *void #c_call {
    #if OS == .WINDOWS {
        result := _gl_wgl_resolver(name);
        if cast(u64) result > 3 && cast(u64) result != 0xffff_ffff_ffff_ffff return result;
        if !__gl_library_handle __gl_library_handle = _gl_win_open(cast(*u8) "opengl32.dll\0");
        if !__gl_library_handle return null;
        return _gl_win_symbol(__gl_library_handle, name);
    } else #if OS == .LINUX {
        return _gl_x11_resolver(name);
    } else #if OS == .MACOS {
        return _gl_symbol(cast(*void) -2, name);
    } else #if OS == .ANDROID {
        return _gl_egl_resolver(name);
    } else {
        return null;
    }
}

#if OS == .WINDOWS {
    __gl_library_handle: *void;
    _gl_wgl_resolver :: (name: *u8) -> *void #foreign _gl_platform_library "wglGetProcAddress";
    _gl_win_open :: (name: *u8) -> *void #foreign _gl_kernel_library "LoadLibraryA";
    _gl_win_symbol :: (library: *void, name: *u8) -> *void #foreign _gl_kernel_library "GetProcAddress";
    _gl_platform_library :: #system_library "opengl32";
    _gl_kernel_library :: #system_library "kernel32";
} else #if OS == .LINUX {
    _gl_x11_resolver :: (name: *u8) -> *void #foreign _gl_platform_library "glXGetProcAddressARB";
    _gl_platform_library :: #system_library "GL";
} else #if OS == .MACOS {
    _gl_symbol :: (library: *void, name: *u8) -> *void #foreign _gl_platform_library "dlsym";
    _gl_platform_library :: #system_library "c";
} else #if OS == .ANDROID {
    _gl_egl_resolver :: (name: *u8) -> *void #foreign _gl_platform_library "eglGetProcAddress";
    _gl_platform_library :: #system_library "EGL";
}

#if OS == .LINUX && !ENABLE_ALL_EXTENSIONS {
    // The retained EXT field returns s32; the SDK function itself returns void.
    // Its compatibility result is zero after making the actual void call.
    __gl_swap_interval_ext: (display: *Display, drawable: GLXDrawable, interval: s32) #c_call;
    __gl_swap_interval_mesa: (interval: u32) -> s32 #c_call;
    _gl_swap_interval_ext_compat :: (display: *Display, drawable: GLXDrawable, interval: s32) -> s32 #c_call {
        __gl_swap_interval_ext(display, drawable, interval);
        return 0;
    }
    _gl_swap_interval_mesa_compat :: (interval: s32) -> s32 #c_call {
        return __gl_swap_interval_mesa(cast(u32) interval);
    }
}
