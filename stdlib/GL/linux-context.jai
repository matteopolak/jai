// Independent GLX context creation against the system X11/GL implementations.
#if OS == .LINUX {
    glx_create_context :: (window: Window_Type, major_version: s32 = 0, minor_version: s32 = 0, compatibility := false, debug := false, wanted_msaa: s32 = DEFAULT_MSAA) -> GLXContext, GLXFBConfig, chosen_msaa: s32 {
        return _glx_create_context_with_msaa(window, major_version, minor_version, compatibility, debug, wanted_msaa);
    }

    #scope_module
    _glx_create_context_with_msaa :: (window: Window_Type, major_version: s32, minor_version: s32, compatibility: bool, debug: bool, wanted_msaa: s32) -> GLXContext, GLXFBConfig, chosen_msaa: s32 {
        if window == 0 || major_version < 0 || minor_version < 0 || wanted_msaa < 0 return null, null, 0;
        if major_version == 0 && minor_version != 0 return null, null, 0;
        NativeGLX.init_global_display();
        display := NativeGLX.x_global_display;
        if !display return null, null, 0;

        // Serialize this module's temporary process-wide Xlib error handler.
        // Applications must also serialize any independent XSetErrorHandler use.
        while GLXAtomics.atomic_swap(*_glx_error_guard, 1) != 0 sleep_milliseconds(1);
        defer GLXAtomics.atomic_write(*_glx_error_guard, 0);
        NativeGLX.XLockDisplay(display);
        defer NativeGLX.XUnlockDisplay(display);
        NativeGLX.XSync(display, NativeGLX.False);
        _glx_error_display = display;
        _glx_error_first_serial = NativeGLX.XNextRequest(display);
        _glx_error_observed = false;
        _glx_previous_handler = NativeGLX.XSetErrorHandler(_glx_context_error);
        defer {
            NativeGLX.XSync(display, NativeGLX.False);
            NativeGLX.XSetErrorHandler(_glx_previous_handler);
        }

        window_attributes: NativeGLX.XWindowAttributes;
        if NativeGLX.XGetWindowAttributes(display, window, *window_attributes) == 0 || _glx_error_observed return null, null, 0;
        screen := NativeGLX.XScreenNumberOfScreen(window_attributes.screen);
        visual_id := NativeGLX.XVisualIDFromVisual(window_attributes.visual);
        glx_major, glx_minor: s32;
        if _glx_context_query_version(display, *glx_major, *glx_minor) == 0 return null, null, 0;
        if glx_major < 1 || (glx_major == 1 && glx_minor < 3) return null, null, 0;
        extensions := _glx_context_extensions(display, screen);
        multisampling := glx_major > 1 || (glx_major == 1 && glx_minor >= 4) || _gl_context_extension(extensions, "GLX_ARB_multisample");

        create_attribs: (dpy: *NativeGLX.Display, config: GLXFBConfig, sharing: GLXContext, direct: s32, attributes: *s32) -> GLXContext #c_call;
        if _gl_context_extension(extensions, "GLX_ARB_create_context") {
            create_attribs = cast(type_of(create_attribs)) _glx_context_get_proc(cast(*u8) "glXCreateContextAttribsARB\0");
        }
        needs_attributes := major_version != 0 || debug;
        needs_profile := major_version > 3 || (major_version == 3 && minor_version >= 2);
        if needs_attributes && !create_attribs return null, null, 0;
        if needs_profile && !_gl_context_extension(extensions, "GLX_ARB_create_context_profile") return null, null, 0;

        // An existing X Window cannot acquire a new visual. Filter by its visual
        // and verify the framebuffer's samples against that visual's GLX values.
        requirements: [7] s32 = .[NativeGLX.GLX_X_RENDERABLE, 1,
            NativeGLX.GLX_DRAWABLE_TYPE, NativeGLX.GLX_WINDOW_BIT,
            NativeGLX.GLX_RENDER_TYPE, NativeGLX.GLX_RGBA_BIT, 0];
        count: s32 = 0;
        configurations := NativeGLX.glXChooseFBConfig(display, screen, requirements.data, *count);
        if !configurations return null, null, 0;
        defer NativeGLX.XFree(configurations);
        if count <= 0 return null, null, 0;
        chosen: GLXFBConfig;
        chosen_samples: s32 = 0;
        chosen_distance: s64 = 0x7fff_ffff_ffff_ffff;
        for index: 0..count - 1 {
            config := configurations[index];
            info := _glx_context_visual(display, config);
            if !info continue;
            if info.visualid != visual_id || info.screen != screen {
                NativeGLX.XFree(info);
                continue;
            }
            buffered: s32 = 0;
            if NativeGLX.glXGetFBConfigAttrib(display, config, NativeGLX.GLX_DOUBLEBUFFER, *buffered) != 0 || buffered == 0 {
                NativeGLX.XFree(info);
                continue;
            }
            sample_buffers, samples, visual_buffers, visual_samples: s32;
            usable := true;
            if multisampling {
                usable = NativeGLX.glXGetFBConfigAttrib(display, config, NativeGLX.GLX_SAMPLE_BUFFERS, *sample_buffers) == 0 &&
                    NativeGLX.glXGetFBConfigAttrib(display, config, NativeGLX.GLX_SAMPLES, *samples) == 0 &&
                    NativeGLX.glXGetConfig(display, info, NativeGLX.GLX_SAMPLE_BUFFERS, *visual_buffers) == 0 &&
                    NativeGLX.glXGetConfig(display, info, NativeGLX.GLX_SAMPLES, *visual_samples) == 0;
                if sample_buffers == 0 samples = 0;
                if visual_buffers == 0 visual_samples = 0;
                if sample_buffers != visual_buffers || samples != visual_samples usable = false;
            }
            NativeGLX.XFree(info);
            if !usable || _glx_error_observed continue;
            distance := cast(s64) samples - wanted_msaa;
            if distance < 0 distance = -distance;
            // Prefer no overshoot when two compatible configurations are tied.
            if !chosen || distance < chosen_distance || (distance == chosen_distance && samples < chosen_samples) {
                chosen = config;
                chosen_samples = samples;
                chosen_distance = distance;
            }
        }
        if !chosen || _glx_error_observed return null, null, 0;

        previous_context := NativeGLX.glXGetCurrentContext();
        previous_display := _glx_context_current_display();
        previous_draw := _glx_context_current_drawable();
        previous_read := _glx_context_current_read_drawable();
        created: GLXContext;
        if create_attribs {
            attributes: [9] s32;
            at: s32 = 0;
            if major_version != 0 {
                attributes[at] = NativeGLX.GLX_CONTEXT_MAJOR_VERSION_ARB;
                attributes[at + 1] = major_version;
                at += 2;
                attributes[at] = NativeGLX.GLX_CONTEXT_MINOR_VERSION_ARB;
                attributes[at + 1] = minor_version;
                at += 2;
            }
            if debug {
                attributes[at] = NativeGLX.GLX_CONTEXT_FLAGS_ARB;
                attributes[at + 1] = NativeGLX.GLX_CONTEXT_DEBUG_BIT_ARB;
                at += 2;
            }
            if needs_profile {
                attributes[at] = NativeGLX.GLX_CONTEXT_PROFILE_MASK_ARB;
                attributes[at + 1] = NativeGLX.GLX_CONTEXT_CORE_PROFILE_BIT_ARB;
                if compatibility attributes[at + 1] = NativeGLX.GLX_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB;
                at += 2;
            }
            attributes[at] = 0;
            created = create_attribs(display, chosen, null, NativeGLX.True, attributes.data);
        } else {
            created = _glx_context_create_legacy(display, chosen, _GLX_RGBA_TYPE, null, NativeGLX.True);
        }
        NativeGLX.XSync(display, NativeGLX.False);
        if !created return null, null, 0;
        complete := false;
        binding_attempted := false;
        defer {
            if !complete {
                if binding_attempted {
                    if previous_context && previous_display {
                        _glx_context_make_current(previous_display, previous_draw, previous_read, previous_context);
                    } else {
                        NativeGLX.glXMakeCurrent(display, 0, null);
                    }
                }
                NativeGLX.glXDestroyContext(display, created);
            }
        }
        if _glx_error_observed return null, null, 0;
        binding_attempted = true;
        bound := NativeGLX.glXMakeCurrent(display, window, created);
        NativeGLX.XSync(display, NativeGLX.False);
        if bound == 0 || _glx_error_observed return null, null, 0;
        complete = true;
        return created, chosen, chosen_samples;
    }

    #scope_file
    NativeGLX :: #import "X11";
    GLXAtomics :: #import "Atomics";
    _glx_error_guard: s32;
    _glx_error_display: *NativeGLX.Display;
    _glx_error_first_serial: u64;
    _glx_error_observed: bool;
    _glx_previous_handler: NativeGLX.XErrorHandler;
    _glx_context_error :: (display: *NativeGLX.Display, event: *NativeGLX.XErrorEvent) -> s32 #c_call {
        if display == _glx_error_display && event.serial >= _glx_error_first_serial {
            _glx_error_observed = true;
            return 0;
        }
        if _glx_previous_handler return _glx_previous_handler(display, event);
        return 0;
    }

    // SDK entry points missing from the retained X11 surface stay module-private.
    _glx_context_library :: #system_library "GL";
    _GLX_RGBA_TYPE :: 0x8014;
    _glx_context_query_version :: (display: *NativeGLX.Display, major: *s32, minor: *s32) -> s32 #foreign _glx_context_library "glXQueryVersion";
    _glx_context_extensions :: (display: *NativeGLX.Display, screen: s32) -> *u8 #foreign _glx_context_library "glXQueryExtensionsString";
    _glx_context_visual :: (display: *NativeGLX.Display, config: GLXFBConfig) -> *NativeGLX.XVisualInfo #foreign _glx_context_library "glXGetVisualFromFBConfig";
    _glx_context_create_legacy :: (display: *NativeGLX.Display, config: GLXFBConfig, render_type: s32, share: GLXContext, direct: s32) -> GLXContext #foreign _glx_context_library "glXCreateNewContext";
    _glx_context_current_display :: () -> *NativeGLX.Display #foreign _glx_context_library "glXGetCurrentDisplay";
    _glx_context_current_drawable :: () -> NativeGLX.GLXDrawable #foreign _glx_context_library "glXGetCurrentDrawable";
    _glx_context_current_read_drawable :: () -> NativeGLX.GLXDrawable #foreign _glx_context_library "glXGetCurrentReadDrawable";
    _glx_context_make_current :: (display: *NativeGLX.Display, draw: NativeGLX.GLXDrawable, read: NativeGLX.GLXDrawable, context: GLXContext) -> s32 #foreign _glx_context_library "glXMakeContextCurrent";
    _glx_context_get_proc :: (name: *u8) -> *void #foreign _glx_context_library "glXGetProcAddressARB";
}
