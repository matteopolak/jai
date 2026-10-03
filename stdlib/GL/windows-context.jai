// Independent Win32/WGL flow. Native libraries and the driver remain external.
#if OS == .WINDOWS {
    wgl_create_context :: (hwnd: HWND, share: HGLRC = null, major_version: s32 = 0, minor_version: s32 = 0, compatibility := false, debug := false, wanted_msaa: s32 = DEFAULT_MSAA) -> HGLRC, HDC, chosen_msaa: s32 {
        if !hwnd || major_version < 0 || minor_version < 0 || wanted_msaa < 0 return null, null, 0;
        if major_version == 0 && minor_version != 0 return null, null, 0;

        previous_context := NativeWGL.wglGetCurrentContext();
        previous_dc := NativeWGL.wglGetCurrentDC();
        complete := false;
        defer { if !complete NativeWGL.wglMakeCurrent(previous_dc, previous_context); }

        // The target's pixel format can only be set once. Use another window to
        // obtain driver extension addresses before committing the target format.
        placement: NativeWGL.RECT;
        NativeWGL.GetWindowRect(hwnd, *placement);
        bootstrap_window := NativeWGL.CreateWindowExA(0, cast(*u8) "STATIC\0", cast(*u8) "\0",
            NativeWGL.WS_CLIPSIBLINGS | NativeWGL.WS_CLIPCHILDREN,
            placement.left, placement.top, 1, 1, null, null, null, null);
        if !bootstrap_window return null, null, 0;
        defer NativeWGL.DestroyWindow(bootstrap_window);
        bootstrap_dc := NativeWGL.GetDC(bootstrap_window);
        if !bootstrap_dc return null, null, 0;
        defer NativeWGL.ReleaseDC(bootstrap_window, bootstrap_dc);

        descriptor := _gl_wgl_pixel_descriptor();
        bootstrap_format := NativeWGL.ChoosePixelFormat(bootstrap_dc, *descriptor);
        if bootstrap_format == 0 || NativeWGL.SetPixelFormat(bootstrap_dc, bootstrap_format, *descriptor) == 0 return null, null, 0;
        bootstrap_context := NativeWGL.wglCreateContext(bootstrap_dc);
        if !bootstrap_context return null, null, 0;
        defer {
            if NativeWGL.wglGetCurrentContext() == bootstrap_context NativeWGL.wglMakeCurrent(null, null);
            NativeWGL.wglDeleteContext(bootstrap_context);
        }
        if NativeWGL.wglMakeCurrent(bootstrap_dc, bootstrap_context) == 0 return null, null, 0;

        extension_string: *u8;
        extensions_arb: (dc: HDC) -> *u8 #c_call;
        extensions_arb = cast(type_of(extensions_arb)) _gl_wgl_context_proc(cast(*u8) "wglGetExtensionsStringARB\0");
        if extensions_arb extension_string = extensions_arb(bootstrap_dc);
        if !extension_string {
            extensions_ext: () -> *u8 #c_call;
            extensions_ext = cast(type_of(extensions_ext)) _gl_wgl_context_proc(cast(*u8) "wglGetExtensionsStringEXT\0");
            if extensions_ext extension_string = extensions_ext();
        }

        choose_format: (dc: HDC, integer_attributes: *s32, float_attributes: *float, capacity: u32, formats: *s32, count: *u32) -> NativeWGL.BOOL #c_call;
        query_format: (dc: HDC, format: s32, layer: s32, count: u32, attributes: *s32, values: *s32) -> NativeWGL.BOOL #c_call;
        create_attribs: (dc: HDC, sharing: HGLRC, attributes: *s32) -> HGLRC #c_call;
        if _gl_context_extension(extension_string, "WGL_ARB_pixel_format") {
            choose_format = cast(type_of(choose_format)) _gl_wgl_context_proc(cast(*u8) "wglChoosePixelFormatARB\0");
            query_format = cast(type_of(query_format)) _gl_wgl_context_proc(cast(*u8) "wglGetPixelFormatAttribivARB\0");
        }
        if _gl_context_extension(extension_string, "WGL_ARB_create_context") {
            create_attribs = cast(type_of(create_attribs)) _gl_wgl_context_proc(cast(*u8) "wglCreateContextAttribsARB\0");
        }
        needs_attributes := major_version != 0 || debug;
        needs_profile := major_version > 3 || (major_version == 3 && minor_version >= 2);
        if needs_attributes && !create_attribs return null, null, 0;
        if needs_profile && !_gl_context_extension(extension_string, "WGL_ARB_create_context_profile") return null, null, 0;
        multisampling := _gl_context_extension(extension_string, "WGL_ARB_multisample");
        if multisampling && !query_format return null, null, 0;

        target_dc := NativeWGL.GetDC(hwnd);
        if !target_dc return null, null, 0;
        defer { if !complete NativeWGL.ReleaseDC(hwnd, target_dc); }
        pixel_format := NativeWGL.GetPixelFormat(target_dc);
        if pixel_format == 0 {
            if choose_format {
                samples := wanted_msaa;
                if !multisampling || samples <= 1 samples = 0;
                attributes: [23] s32 = .[
                    WGL_DRAW_TO_WINDOW_ARB, 1, WGL_SUPPORT_OPENGL_ARB, 1,
                    WGL_DOUBLE_BUFFER_ARB, 1, WGL_PIXEL_TYPE_ARB, WGL_TYPE_RGBA_ARB,
                    WGL_COLOR_BITS_ARB, 24, WGL_ALPHA_BITS_ARB, 8,
                    WGL_DEPTH_BITS_ARB, 24, WGL_STENCIL_BITS_ARB, 8,
                    WGL_SAMPLE_BUFFERS_ARB, 1, WGL_SAMPLES_ARB, 0, 0, 0, 0];
                while true {
                    attributes[17] = 1;
                    attributes[19] = samples;
                    if samples == 0 {
                        // Omit unknown multisample tokens on older drivers.
                        attributes[16] = 0;
                        if multisampling { attributes[16] = WGL_SAMPLE_BUFFERS_ARB; attributes[17] = 0; }
                    }
                    count: u32 = 0;
                    if choose_format(target_dc, attributes.data, null, 1, *pixel_format, *count) == 0 pixel_format = 0;
                    if pixel_format > 0 && count > 0 break;
                    pixel_format = 0;
                    if samples == 0 break;
                    samples /= 2;
                    if samples <= 1 samples = 0;
                }
            } else {
                pixel_format = NativeWGL.ChoosePixelFormat(target_dc, *descriptor);
            }
            if pixel_format == 0 return null, null, 0;
            if NativeWGL.DescribePixelFormat(target_dc, pixel_format, cast(u32) size_of(NativeWGL.PIXELFORMATDESCRIPTOR), *descriptor) == 0 return null, null, 0;
            if NativeWGL.SetPixelFormat(target_dc, pixel_format, *descriptor) == 0 return null, null, 0;
        } else {
            if NativeWGL.DescribePixelFormat(target_dc, pixel_format, cast(u32) size_of(NativeWGL.PIXELFORMATDESCRIPTOR), *descriptor) == 0 return null, null, 0;
        }
        required_flags := NativeWGL.PFD_DRAW_TO_WINDOW | NativeWGL.PFD_SUPPORT_OPENGL | NativeWGL.PFD_DOUBLEBUFFER;
        if (descriptor.dwFlags & required_flags) != required_flags || descriptor.iPixelType != NativeWGL.PFD_TYPE_RGBA return null, null, 0;

        created: HGLRC;
        if create_attribs {
            attributes: [9] s32;
            at: s32 = 0;
            if major_version != 0 {
                attributes[at] = WGL_CONTEXT_MAJOR_VERSION_ARB; attributes[at + 1] = major_version; at += 2;
                attributes[at] = WGL_CONTEXT_MINOR_VERSION_ARB; attributes[at + 1] = minor_version; at += 2;
            }
            if debug {
                attributes[at] = WGL_CONTEXT_FLAGS_ARB; attributes[at + 1] = WGL_CONTEXT_DEBUG_BIT_ARB; at += 2;
            }
            if needs_profile {
                attributes[at] = WGL_CONTEXT_PROFILE_MASK_ARB;
                attributes[at + 1] = WGL_CONTEXT_CORE_PROFILE_BIT_ARB;
                if compatibility attributes[at + 1] = WGL_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB;
                at += 2;
            }
            attributes[at] = 0;
            created = create_attribs(target_dc, share, attributes.data);
        } else {
            created = NativeWGL.wglCreateContext(target_dc);
            if created && share && NativeWGL.wglShareLists(share, created) == 0 {
                NativeWGL.wglDeleteContext(created);
                created = null;
            }
        }
        if !created return null, null, 0;
        defer {
            if !complete {
                if NativeWGL.wglGetCurrentContext() == created NativeWGL.wglMakeCurrent(null, null);
                NativeWGL.wglDeleteContext(created);
            }
        }
        if NativeWGL.wglMakeCurrent(target_dc, created) == 0 return null, null, 0;

        actual_samples: s32 = 0;
        if multisampling && query_format {
            sample_attributes: [2] s32 = .[WGL_SAMPLE_BUFFERS_ARB, WGL_SAMPLES_ARB];
            sample_values: [2] s32;
            if query_format(target_dc, pixel_format, 0, 2, sample_attributes.data, sample_values.data) == 0 return null, null, 0;
            if sample_values[0] > 0 actual_samples = sample_values[1];
        }
        complete = true;
        return created, target_dc, actual_samples;
    }

    #scope_file
    NativeWGL :: #import "Windows";
    _gl_wgl_pixel_descriptor :: () -> NativeWGL.PIXELFORMATDESCRIPTOR {
        value: NativeWGL.PIXELFORMATDESCRIPTOR;
        value.nSize = cast(s16) size_of(NativeWGL.PIXELFORMATDESCRIPTOR);
        value.nVersion = 1;
        value.dwFlags = NativeWGL.PFD_DRAW_TO_WINDOW | NativeWGL.PFD_SUPPORT_OPENGL | NativeWGL.PFD_DOUBLEBUFFER;
        value.iPixelType = NativeWGL.PFD_TYPE_RGBA;
        value.cColorBits = 24;
        value.cAlphaBits = 8;
        value.cDepthBits = 24;
        value.cStencilBits = 8;
        value.iLayerType = NativeWGL.PFD_MAIN_PLANE;
        return value;
    }
    _gl_wgl_context_proc :: (name: *u8) -> *void {
        address := NativeWGL.wglGetProcAddress(name);
        bits := cast(u64) address;
        if bits <= 3 || bits == 0xffff_ffff_ffff_ffff return null;
        return address;
    }
}
