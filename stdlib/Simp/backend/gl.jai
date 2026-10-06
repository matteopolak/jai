// The OpenGL backend. Nothing here needs the application's help: the first set_render_target on a
// Window_Creation window creates a context for it (NSOpenGL, GLX or WGL), loads the procedures
// through the GL module and builds the built-in shaders. A host that owns its context can
// instead call initialize_opengl_renderer and, for several windows, install opengl_make_window_current.
#scope_module
GL :: #import "GL";
gl_api: *GL.GL_Procedures;
gl_vertex_array: u32;
gl_vertex_buffer: u32;
gl_main_framebuffer: u32;
Shader_Pointer :: *Shader;
MINIMUM_GL_MAJOR_VERSION :: 3;
MINIMUM_GL_MINOR_VERSION :: 3;

#if OS == .WINDOWS {
    the_gl_context: Win.HGLRC;
    the_hdc_for_pixel_format_cloning: Win.HDC;
} else #if OS == .LINUX {
    the_gl_context: X11.GLXContext;
    the_gl_fbc: X11.GLXFBConfig;
} else #if OS == .MACOS {
    the_gl_context: *AppKit.NSOpenGLContext;
}
gl_swap_interval: s32 = -1;

#scope_export
// A host that creates its own contexts installs this to make one window's context current.
opengl_make_window_current: (window: Window_Type) -> bool = null;
// A host that already has a current context loads the GL procedures itself and hands them over.
initialize_opengl_renderer :: (procs: *GL.GL_Procedures) -> bool {
    if !procs || !procs.glCreateShader || !procs.glShaderSource || !procs.glGenVertexArrays || !procs.glBufferData return false;
    gl_api = procs;
    return gl_init_resources();
}
shutdown_opengl_renderer :: () {
    if !gl_api return;
    for shader: gl_built_in_shaders() {
        if shader.gl_handle gl_api.glDeleteProgram(shader.gl_handle);
        shader.gl_handle = 0;
    }
    if gl_vertex_buffer gl_api.glDeleteBuffers(1, *gl_vertex_buffer);
    if gl_vertex_array gl_api.glDeleteVertexArrays(1, *gl_vertex_array);
    if gl_main_framebuffer gl_api.glDeleteFramebuffers(1, *gl_main_framebuffer);
    gl_vertex_buffer = 0;
    gl_vertex_array = 0;
    gl_main_framebuffer = 0;
    gl_api = null;
}
#scope_module

//
// Context creation and window targets.
//

gl_init_resources :: () -> bool {
    gl_api.glGenVertexArrays(1, *gl_vertex_array);
    gl_api.glGenBuffers(1, *gl_vertex_buffer);
    if !gl_vertex_array || !gl_vertex_buffer return false;
    shaders := gl_built_in_shaders();
    bodies := string.[SHADER_COLOR, SHADER_COLOR, SHADER_TEXT, SHADER_SPRITE_RIGHT_HANDED, SHADER_SPRITE_LEFT_HANDED, SHADER_ROUNDED_RECT, SHADER_GRADIENT];
    // The two color shaders differ only in blending, so they share one program.
    for shader, i: shaders {
        if i == 1 {
            shader.gl_handle = shaders[0].gl_handle;
            continue;
        }
        shader.gl_handle = gl_build_program(bodies[i]);
        if !shader.gl_handle {
            shutdown_opengl_renderer();
            return false;
        }
    }
    shaders_set_defaults();
    return true;
}
gl_built_in_shaders :: () -> [7] *Shader {
    return .[*shader_color, *shader_color_with_blend, *shader_text, *shader_sprite_right_handed, *shader_sprite_left_handed, *shader_rounded_rect, *shader_gradient];
}

// Called the first time a window is used as a render target (or by prepare_window).
gl_backend_init :: (info: *Window_Info) {
    if !gl_api {
        gl_create_native_context(info);
        assert(gl_api != null, "Simp could not create an OpenGL context for the window");
        if !gl_api return;
    } else if opengl_make_window_current {
        assert(opengl_make_window_current(info.window), "Could not make the window's graphics context current");
    } else if the_gl_context {
        gl_attach_window(info);
    }
    context.simp.current_window_info = info.*;
}

#if OS == .MACOS {
    gl_create_native_context :: (info: *Window_Info) {
        created, chosen_msaa := GL.nsgl_create_context(MINIMUM_GL_MAJOR_VERSION, MINIMUM_GL_MINOR_VERSION, wanted_msaa = info.wanted_msaa);
        if !created return;
        the_gl_context = created;
        info.msaa = chosen_msaa;
        gl_mac_attach_view(info.window);
        GL.gl_load(*GL.gl);
        gl_api = *GL.gl;
        if !gl_init_resources() {
            gl_api = null;
        }
    }
    gl_mac_attach_view :: (window: Window_Type) {
        view := AppKit.NSWindow.contentView(window);
        assert(view != null, "A Simp window needs a content view with OpenGL support (as made by Window_Creation)");
        if !view return;
        AppKit.NSView.setWantsBestResolutionOpenGLSurface(view, ObjC.YES);
        // An NSOpenGLView owns a context of its own; replace it with ours so only one is attached.
        view_class := ObjC.object_getClass(cast(ObjC.id) view);
        setter := ObjC.sel_registerName(cast(*u8) "setOpenGLContext:\0");
        if ObjC.class_respondsToSelector(view_class, setter) != 0 {
            set_context: (receiver: *void, selector: ObjC.SEL, value: *AppKit.NSOpenGLContext) #c_call;
            set_context = cast(type_of(set_context)) ObjC.objc_msgSend;
            set_context(cast(*void) view, setter, the_gl_context);
        }
        AppKit.NSOpenGLContext.setView(the_gl_context, view);
        AppKit.NSOpenGLContext.update(the_gl_context);
        AppKit.NSOpenGLContext.makeCurrentContext(the_gl_context);
    }
    gl_attach_window :: (info: *Window_Info) {
        gl_mac_attach_view(info.window);
    }
} else #if OS == .LINUX {
    gl_create_native_context :: (info: *Window_Info) {
        created, configuration, chosen_msaa := GL.glx_create_context(info.window, MINIMUM_GL_MAJOR_VERSION, MINIMUM_GL_MINOR_VERSION, wanted_msaa = info.wanted_msaa);
        if !created return;
        the_gl_context = created;
        the_gl_fbc = configuration;
        info.msaa = chosen_msaa;
        // The context is made current on a GLX wrapper window, before any glGen*.
        info.specific.glx_window = X11.glXCreateWindow(X11.x_global_display, the_gl_fbc, info.window, null);
        X11.glXMakeCurrent(X11.x_global_display, info.specific.glx_window, the_gl_context);
        GL.gl_load(*GL.gl);
        gl_api = *GL.gl;
        if !gl_init_resources() {
            gl_api = null;
        }
    }
    gl_attach_window :: (info: *Window_Info) {
        info.specific.glx_window = X11.glXCreateWindow(X11.x_global_display, the_gl_fbc, info.window, null);
        X11.glXMakeCurrent(X11.x_global_display, info.specific.glx_window, the_gl_context);
    }
} else #if OS == .WINDOWS {
    gl_create_native_context :: (info: *Window_Info) {
        created, device, chosen_msaa := GL.wgl_create_context(info.window, null, MINIMUM_GL_MAJOR_VERSION, MINIMUM_GL_MINOR_VERSION, wanted_msaa = info.wanted_msaa);
        if !created return;
        the_gl_context = created;
        the_hdc_for_pixel_format_cloning = device;
        info.msaa = chosen_msaa;
        info.specific.hdc = device;
        GL.gl_load(*GL.gl);
        gl_api = *GL.gl;
        if !gl_init_resources() {
            gl_api = null;
        }
    }
    gl_attach_window :: (info: *Window_Info) {
        // Every window of the context must use the pixel format the context was made with.
        device := Win.GetDC(info.window);
        descriptor: Win.PIXELFORMATDESCRIPTOR;
        format := Win.GetPixelFormat(the_hdc_for_pixel_format_cloning);
        assert(Win.DescribePixelFormat(the_hdc_for_pixel_format_cloning, format, size_of(Win.PIXELFORMATDESCRIPTOR), *descriptor) != 0);
        Win.SetPixelFormat(device, format, *descriptor);
        info.specific.hdc = device;
        Win.wglMakeCurrent(device, the_gl_context);
    }
} else {
    gl_create_native_context :: (info: *Window_Info) {
        assert(false, "Simp has no OpenGL context creation for this platform; use initialize_opengl_renderer");
    }
    gl_attach_window :: (info: *Window_Info) {}
}

// Makes the graphics context current for drawing into this (already initialized) window.
gl_make_window_current :: (info: *Window_Info) {
    if opengl_make_window_current {
        assert(opengl_make_window_current(info.window), "Could not make the window's graphics context current");
        return;
    }
    if !the_gl_context return;
    #if OS == .WINDOWS {
        success := Win.wglMakeCurrent(info.specific.hdc, the_gl_context);
        assert(success != 0, "wglMakeCurrent failed");
    } else #if OS == .LINUX {
        X11.XLockDisplay(X11.x_global_display);
        success := X11.glXMakeCurrent(X11.x_global_display, info.specific.glx_window, the_gl_context);
        X11.XUnlockDisplay(X11.x_global_display);
        assert(success != 0, "glXMakeCurrent failed");
    } else #if OS == .MACOS {
        view := AppKit.NSWindow.contentView(info.window);
        assert(view != null);
        if !view return;
        AppKit.NSOpenGLContext.setView(the_gl_context, view);
        AppKit.NSOpenGLContext.makeCurrentContext(the_gl_context);
    }
}
gl_set_render_target :: (info: *Window_Info) {
    if info.backend_initted_for_this_window {
        gl_make_window_current(info);
    } else {
        backend_init(info);
        info.backend_initted_for_this_window = true;
    }
    if !gl_api return;
    gl_api.glBindFramebuffer(GL.GL_FRAMEBUFFER, 0);
    gl_api.glViewport(0, 0, cast(u32) info.window_width, cast(u32) info.window_height);
    gl_api.glDrawBuffer(GL.GL_BACK);
    gl_apply_scissor();
}
gl_set_render_target :: (texture: *Texture) {
    assert(gl_api != null && texture.framebuffer != 0, "Texture has no native framebuffer");
    if !gl_api || !texture.framebuffer return;
    gl_api.glBindFramebuffer(GL.GL_FRAMEBUFFER, texture.framebuffer);
    gl_api.glViewport(0, 0, cast(u32) texture.width, cast(u32) texture.height);
    gl_apply_scissor();
}
gl_flush :: () {
    if gl_api gl_api.glFlush();
}
gl_resize_render_target :: (info: Window_Info) {
    if !gl_api return;
    if context.simp.current_window_info.window == info.window && !context.simp.texture_render_target {
        gl_api.glViewport(0, 0, cast(u32) info.window_width, cast(u32) info.window_height);
        #if OS == .MACOS {
            if the_gl_context AppKit.NSOpenGLContext.update(the_gl_context);
        }
    }
}
gl_swap_buffers :: (window: Window_Type, vsync: bool) {
    info := find_window_info(window);
    if !info || !info.backend_initted_for_this_window {
        log_error("Simp: Attempt to swap_buffers on a window that was never used as a render target!\n");
        return;
    }
    assert(the_gl_context != null, "Install Simp.window_present_sink to present windows of a host-managed OpenGL context");
    if !the_gl_context return;
    wanted_interval: s32 = ifx vsync then 1 else 0;
    #if OS == .WINDOWS {
        if gl_swap_interval != wanted_interval && gl_api.wglSwapIntervalEXT {
            gl_api.wglSwapIntervalEXT(wanted_interval);
            gl_swap_interval = wanted_interval;
        }
        Win.SwapBuffers(info.specific.hdc);
    } else #if OS == .LINUX {
        if gl_swap_interval != wanted_interval {
            if gl_api.glXSwapIntervalEXT gl_api.glXSwapIntervalEXT(X11.x_global_display, info.specific.glx_window, wanted_interval);
            else if gl_api.glXSwapIntervalMESA gl_api.glXSwapIntervalMESA(wanted_interval);
            gl_swap_interval = wanted_interval;
        }
        X11.glXSwapBuffers(X11.x_global_display, info.specific.glx_window);
    } else #if OS == .MACOS {
        // Buffer swapping belongs to the context, whose drawable is one window at a time.
        if window != context.simp.current_window_info.window {
            view := AppKit.NSWindow.contentView(window);
            if !view return;
            AppKit.NSOpenGLContext.setView(the_gl_context, view);
            AppKit.NSOpenGLContext.makeCurrentContext(the_gl_context);
        }
        if gl_swap_interval != wanted_interval {
            value: s32 = wanted_interval;
            AppKit.NSOpenGLContext.setValues(the_gl_context, *value, .NSOpenGLContextParameterSwapInterval);
            gl_swap_interval = wanted_interval;
        }
        AppKit.NSOpenGLContext.flushBuffer(the_gl_context);
    } else {
        assert(false, "Install Simp.window_present_sink to present windows on this platform");
    }
}

//
// Drawing.
//

gl_clear_target :: (r: float, g: float, b: float, a: float) {
    assert(gl_api != null, "Select a Simp render target before clearing");
    if !gl_api return;
    gl_api.glClearColor(r, g, b, a);
    gl_api.glClear(GL.GL_COLOR_BUFFER_BIT);
}
gl_use_shader :: (shader: *Shader) {
    assert(gl_api != null && shader != null && shader.gl_handle != 0, "Shader has no native program");
    if !gl_api || !shader || !shader.gl_handle return;
    gl_api.glUseProgram(shader.gl_handle);
    if shader.alpha_blend {
        gl_api.glEnable(GL.GL_BLEND);
        gl_api.glBlendFuncSeparate(GL.GL_SRC_ALPHA, GL.GL_ONE_MINUS_SRC_ALPHA, GL.GL_ONE, GL.GL_ONE_MINUS_SRC_ALPHA);
    } else gl_api.glDisable(GL.GL_BLEND);
}
gl_find_shader_locations :: (s: *Shader) {
    if !gl_api || !s.gl_handle return;
    p := s.gl_handle;
    s.position_loc = gl_attribute(p, "vert_position");
    s.color_scale_loc = gl_attribute(p, "vert_color");
    s.normal_loc = gl_attribute(p, "vert_normal");
    s.tangent_loc = gl_attribute(p, "vert_tangent");
    s.uv_0_loc = gl_attribute(p, "vert_uv0");
    s.uv_1_loc = gl_attribute(p, "vert_uv1");
    s.rect_center_loc = gl_attribute(p, "vert_rect_center");
    s.rect_size_loc = gl_attribute(p, "vert_rect_size");
    s.rect_corner_radius_loc = gl_attribute(p, "vert_rect_radius");
    s.rect_edge_softness_loc = gl_attribute(p, "vert_rect_softness");
    s.diffuse_texture_loc = get_uniform_location(p, "diffuse_texture");
    if s.diffuse_texture_loc < 0 s.diffuse_texture_loc = get_uniform_location(p, "text_sampler");
}
gl_attribute :: (program: GLuint, name: string) -> GLint {
    return gl_api.glGetAttribLocation(program, temp_c_string(name));
}
backend_set_texture :: (shader: *Shader, texture: *Texture) {
    if !gl_api || !texture return;
    gl_upload_pending(texture);
    gl_api.glActiveTexture(GL.GL_TEXTURE0);
    gl_api.glBindTexture(GL.GL_TEXTURE_2D, texture.gl_handle);
    if shader.diffuse_texture_loc >= 0 gl_api.glUniform1i(shader.diffuse_texture_loc, 0);
    else log_error("Unable to find a texture sampler ('diffuse_texture' or 'text_sampler') in the current shader.\n");
}
gl_apply_scissor :: () {
    if !gl_api || !context.simp return;
    if !context.simp.specific.scissor_enabled {
        gl_api.glDisable(GL.GL_SCISSOR_TEST);
        return;
    }
    rect := context.simp.specific.scissor;
    target := context.simp.texture_render_target;
    height := ifx target then target.height else context.simp.current_window_info.window_height;
    // Window rows count up from the bottom; a texture is stored top row first, so for
    // textures the right-handed system is the one that has to be mirrored.
    left_handed := context.simp.coordinate_system == .LEFT_HANDED;
    mirror := ifx target then !left_handed else left_handed;
    y := rect.y;
    if mirror y = cast(float) height - rect.w;
    gl_api.glEnable(GL.GL_SCISSOR_TEST);
    gl_api.glScissor(cast(s32) rect.x, cast(s32) y, cast(u32) max(rect.z - rect.x, 0.0), cast(u32) max(rect.w - rect.y, 0.0));
}
gl_vertex_format :: (shader: *Shader) {
    gl_api.glBindVertexArray(gl_vertex_array);
    gl_api.glBindBuffer(GL.GL_ARRAY_BUFFER, gl_vertex_buffer);
    gl_api.glBindBuffer(GL.GL_ELEMENT_ARRAY_BUFFER, 0);
    stride := size_of(Immediate_Vertex);
    locations := GLint.[shader.position_loc, shader.color_scale_loc, shader.uv_0_loc, shader.rect_center_loc, shader.rect_size_loc, shader.rect_corner_radius_loc, shader.rect_edge_softness_loc];
    floats := s32.[2, 4, 2, 2, 2, 1, 1];
    // The members are all floats, so each starts where the previous one ends.
    offset: s64 = 0;
    for location, i: locations {
        if location >= 0 {
            gl_api.glEnableVertexAttribArray(cast(u32) location);
            gl_api.glVertexAttribPointer(cast(u32) location, floats[i], GL.GL_FLOAT, false, cast(u32) stride, cast(*void) offset);
        }
        offset += floats[i] * size_of(float);
    }
}
gl_submit :: (state: *Immediate_State) {
    assert(gl_api != null && state.current_shader.gl_handle != 0, "Simp OpenGL renderer is not initialized");
    if !gl_api || !state.current_shader.gl_handle return;
    gl_api.glBindVertexArray(gl_vertex_array);
    gl_api.glBindBuffer(GL.GL_ARRAY_BUFFER, gl_vertex_buffer);
    gl_api.glBufferData(GL.GL_ARRAY_BUFFER, state.num_vertices * size_of(Immediate_Vertex), state.vertices.data, GL.GL_STREAM_DRAW);
    gl_api.glDisable(GL.GL_DEPTH_TEST);
    gl_api.glDisable(GL.GL_CULL_FACE);
    gl_vertex_format(state.current_shader);
    gl_api.glDrawArrays(GL.GL_TRIANGLES, 0, cast(u32) state.num_vertices);
}
gl_set_gradient :: (rect: Vector4, mode: u8, value: float) {
    if !gl_api return;
    gl_api.glUniform4f(get_uniform_location(shader_gradient.gl_handle, "gradient_rect"), rect.x, rect.y, rect.z, rect.w);
    gl_api.glUniform1i(get_uniform_location(shader_gradient.gl_handle, "gradient_mode"), mode);
    gl_api.glUniform1f(get_uniform_location(shader_gradient.gl_handle, "gradient_value"), value);
}

//
// Textures.
//

// Internal format, client format and client type for uploading or allocating a texture of this
// format; the internal format is 0 when the format cannot be created as a plain texture.
gl_texture_format :: (format: Texture_Format, srgb := false) -> u32, u32, u32 {
    if format == .R8 return GL.GL_R8, GL.GL_RED, GL.GL_UNSIGNED_BYTE;
    if format == .RG8 return GL.GL_RG8, GL.GL_RG, GL.GL_UNSIGNED_BYTE;
    if format == .RGB8 return (ifx srgb then GL.GL_SRGB8 else GL.GL_RGB8), GL.GL_RGB, GL.GL_UNSIGNED_BYTE;
    if format == .RGBA8 return (ifx srgb then GL.GL_SRGB8_ALPHA8 else GL.GL_RGBA8), GL.GL_RGBA, GL.GL_UNSIGNED_BYTE;
    if format == .BGRA8 return (ifx srgb then GL.GL_SRGB8_ALPHA8 else GL.GL_RGBA8), GL.GL_BGRA, GL.GL_UNSIGNED_BYTE;
    if format == .B5G6R5 return GL.GL_RGB, GL.GL_BGR, GL.GL_UNSIGNED_SHORT_5_6_5;
    if format == .RGB10A2 return GL.GL_RGB10_A2, GL.GL_RGBA, GL.GL_UNSIGNED_INT_10_10_10_2;
    if format == .R16 return GL.GL_R16, GL.GL_RED, GL.GL_UNSIGNED_SHORT;
    if format == .R16F return GL.GL_R16F, GL.GL_RED, GL.GL_HALF_FLOAT;
    if format == .RG16F return GL.GL_RG16F, GL.GL_RG, GL.GL_HALF_FLOAT;
    if format == .RGBA16F return GL.GL_RGBA16F, GL.GL_RGBA, GL.GL_HALF_FLOAT;
    if format == .R32F return GL.GL_R32F, GL.GL_RED, GL.GL_FLOAT;
    if format == .RG32F return GL.GL_RG32F, GL.GL_RG, GL.GL_FLOAT;
    if format == .RGBA32F return GL.GL_RGBA32F, GL.GL_RGBA, GL.GL_FLOAT;
    if format == .RG11B10F return GL.GL_R11F_G11F_B10F, GL.GL_RGB, GL.GL_UNSIGNED_INT_10F_11F_11F_REV;
    if format == .RGB9E5F return GL.GL_RGB9_E5, GL.GL_RGB, GL.GL_UNSIGNED_INT_5_9_9_9_REV;
    if format == .R16I return GL.GL_R16I, GL.GL_RED_INTEGER, GL.GL_SHORT;
    if format == .RG16I return GL.GL_RG16I, GL.GL_RG_INTEGER, GL.GL_SHORT;
    if format == .RGBA16I return GL.GL_RGBA16I, GL.GL_RGBA_INTEGER, GL.GL_SHORT;
    if format == .R32I return GL.GL_R32I, GL.GL_RED_INTEGER, GL.GL_INT;
    if format == .RG32I return GL.GL_RG32I, GL.GL_RG_INTEGER, GL.GL_INT;
    if format == .RGBA32I return GL.GL_RGBA32I, GL.GL_RGBA_INTEGER, GL.GL_INT;
    if format == .D16 return GL.GL_DEPTH_COMPONENT16, GL.GL_DEPTH_COMPONENT, GL.GL_UNSIGNED_SHORT;
    if format == .D24S8 return GL.GL_DEPTH24_STENCIL8, GL.GL_DEPTH_STENCIL, GL.GL_UNSIGNED_INT_24_8;
    if format == .D32F return GL.GL_DEPTH_COMPONENT32F, GL.GL_DEPTH_COMPONENT, GL.GL_FLOAT;
    if format == .D32FS8 return GL.GL_DEPTH32F_STENCIL8, GL.GL_DEPTH_STENCIL, GL.GL_FLOAT_32_UNSIGNED_INT_24_8_REV;
    internal := gl_compressed_format(format, srgb);
    return internal, 0, 0;
}
gl_compressed_format :: (format: Texture_Format, srgb: bool) -> u32 {
    if format == .BC1 return ifx srgb then GL.GL_COMPRESSED_SRGB_S3TC_DXT1_EXT else GL.GL_COMPRESSED_RGB_S3TC_DXT1_EXT;
    if format == .BC3 return ifx srgb then GL.GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT5_EXT else GL.GL_COMPRESSED_RGBA_S3TC_DXT5_EXT;
    if format == .BC4 return GL.GL_COMPRESSED_RED_RGTC1;
    if format == .BC5 return GL.GL_COMPRESSED_RG_RGTC2;
    if format == .BC6 return GL.GL_COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT;
    if format == .BC7 return ifx srgb then GL.GL_COMPRESSED_SRGB_ALPHA_BPTC_UNORM else GL.GL_COMPRESSED_RGBA_BPTC_UNORM;
    return 0;
}
// Uploads every mipmap level and leaves the texture bound to GL_TEXTURE_2D of unit 0. Sampling
// parameters are only chosen when the GL texture is created, so later changes by the program survive.
gl_upload_texture :: (texture: *Texture, bitmap: *Bitmap) -> bool {
    if !gl_api return false;
    srgb := (bitmap.flags & .IS_SRGB) != 0;
    internal, external, type := gl_texture_format(bitmap.format, srgb);
    if !internal return false;
    compressed := external == 0;
    created := texture.gl_handle == 0;
    if created gl_api.glGenTextures(1, *texture.gl_handle);
    if !texture.gl_handle return false;
    gl_api.glActiveTexture(GL.GL_TEXTURE0);
    gl_api.glBindTexture(GL.GL_TEXTURE_2D, texture.gl_handle);
    if created {
        // With wrapping, bilinear filtering would pull texels from the opposite edge into the border.
        gl_api.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_S, cast(s32) GL.GL_CLAMP_TO_EDGE);
        gl_api.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_T, cast(s32) GL.GL_CLAMP_TO_EDGE);
        magnify := ifx texture.nearest then GL.GL_NEAREST else GL.GL_LINEAR;
        minify := magnify;
        if bitmap.mipmap_count > 1 minify = ifx texture.nearest then GL.GL_NEAREST_MIPMAP_NEAREST else GL.GL_LINEAR_MIPMAP_LINEAR;
        gl_api.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, cast(s32) magnify);
        gl_api.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, cast(s32) minify);
    }
    gl_api.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAX_LEVEL, bitmap.mipmap_count - 1);
    gl_api.glPixelStorei(GL.GL_UNPACK_ALIGNMENT, 1);
    bpp := get_image_bytes_per_texel(bitmap.format);
    w := bitmap.width;
    h := bitmap.height;
    offset: int;
    for level: 0..bitmap.mipmap_count - 1 {
        bytes, row := get_image_size(bitmap.format, w, h);
        if level == 0 {
            row = bitmap.stride;
            bytes = row * h;
            if compressed bytes = get_image_size(bitmap.format, w, h);
        }
        if offset + bytes > bitmap.data.count {
            gl_api.glPixelStorei(GL.GL_UNPACK_ROW_LENGTH, 0);
            return false;
        }
        pixels := bitmap.data.data + offset;
        if compressed {
            gl_api.glCompressedTexImage2D(GL.GL_TEXTURE_2D, cast(s32) level, internal, cast(u32) w, cast(u32) h, 0, cast(u32) bytes, pixels);
        } else {
            gl_api.glPixelStorei(GL.GL_UNPACK_ROW_LENGTH, cast(s32) (row / bpp));
            gl_api.glTexImage2D(GL.GL_TEXTURE_2D, cast(s32) level, cast(s32) internal, cast(u32) w, cast(u32) h, 0, external, type, pixels);
        }
        offset += bytes;
        w = max(w / 2, 1);
        h = max(h / 2, 1);
    }
    gl_api.glPixelStorei(GL.GL_UNPACK_ROW_LENGTH, 0);
    return gl_api.glGetError() == GL.GL_NO_ERROR;
}
// An image loaded before there was a context goes to the GPU the first time it is needed.
gl_upload_pending :: (texture: *Texture) {
    if texture.gl_handle != 0 || !texture.cpu || (texture.flags & .Render_Target) return;
    if gl_upload_texture(texture, texture.cpu) texture_free_cpu(texture);
}
gl_create_render_target :: (texture: *Texture) -> bool {
    if !gl_api return false;
    internal, external, type := gl_texture_format(texture.format, (texture.flags & .sRGB) != 0);
    if !internal || !external return false;
    previous_texture: s32;
    previous_framebuffer: s32;
    gl_api.glActiveTexture(GL.GL_TEXTURE0);
    gl_api.glGetIntegerv(GL.GL_TEXTURE_BINDING_2D, *previous_texture);
    gl_api.glGetIntegerv(GL.GL_FRAMEBUFFER_BINDING, *previous_framebuffer);
    gl_api.glGenTextures(1, *texture.gl_handle);
    gl_api.glBindTexture(GL.GL_TEXTURE_2D, texture.gl_handle);
    gl_api.glTexImage2D(GL.GL_TEXTURE_2D, 0, cast(s32) internal, cast(u32) texture.width, cast(u32) texture.height, 0, external, type, null);
    gl_api.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAX_LEVEL, 0); // Only level 0 is ever drawn into.
    gl_api.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_S, cast(s32) GL.GL_CLAMP_TO_EDGE);
    gl_api.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_T, cast(s32) GL.GL_CLAMP_TO_EDGE);
    gl_api.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, cast(s32) GL.GL_LINEAR);
    gl_api.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, cast(s32) GL.GL_LINEAR);
    gl_api.glGenFramebuffers(1, *texture.framebuffer);
    gl_api.glBindFramebuffer(GL.GL_FRAMEBUFFER, texture.framebuffer);
    gl_api.glFramebufferTexture2D(GL.GL_FRAMEBUFFER, GL.GL_COLOR_ATTACHMENT0, GL.GL_TEXTURE_2D, texture.gl_handle, 0);
    success := gl_api.glCheckFramebufferStatus(GL.GL_FRAMEBUFFER) == GL.GL_FRAMEBUFFER_COMPLETE;
    gl_api.glBindFramebuffer(GL.GL_FRAMEBUFFER, cast(u32) previous_framebuffer);
    gl_api.glBindTexture(GL.GL_TEXTURE_2D, cast(u32) previous_texture);
    if !success gl_delete_texture(texture);
    return success;
}
gl_delete_texture :: (texture: *Texture) {
    if !gl_api return;
    if texture.framebuffer {
        gl_api.glDeleteFramebuffers(1, *texture.framebuffer);
        texture.framebuffer = 0;
    }
    if texture.gl_handle {
        gl_api.glDeleteTextures(1, *texture.gl_handle);
        texture.gl_handle = 0;
    }
}

//
// Shaders.
//

LOG_BUFFER_SIZE :: 1024;
gl_compile :: (kind: u32, prefix: string, body: string) -> u32 {
    shader := gl_api.glCreateShader(kind);
    if !shader return 0;
    sources: [2] *u8;
    lengths: [2] s32;
    sources[0] = prefix.data;
    lengths[0] = cast(s32) prefix.count;
    sources[1] = body.data;
    lengths[1] = cast(s32) body.count;
    gl_api.glShaderSource(shader, 2, sources.data, lengths.data);
    gl_api.glCompileShader(shader);
    status: s32;
    gl_api.glGetShaderiv(shader, GL.GL_COMPILE_STATUS, *status);
    if !status {
        log_data: [LOG_BUFFER_SIZE] u8;
        gl_api.glGetShaderInfoLog(shader, log_data.count, null, log_data.data);
        log_error("Simp shader failed to compile: %\n", to_string(log_data.data));
        gl_api.glDeleteShader(shader);
        return 0;
    }
    return shader;
}
gl_build_program :: (body: string) -> u32 {
    vertex := gl_compile(GL.GL_VERTEX_SHADER, "#version 330 core\n#define VERTEX_SHADER\n#define OUT_IN out\n", body);
    if !vertex return 0;
    defer gl_api.glDeleteShader(vertex);
    pixel := gl_compile(GL.GL_FRAGMENT_SHADER, "#version 330 core\n#define FRAGMENT_SHADER\n#define OUT_IN in\n", body);
    if !pixel return 0;
    defer gl_api.glDeleteShader(pixel);
    program := gl_api.glCreateProgram();
    if !program return 0;
    gl_api.glAttachShader(program, vertex);
    gl_api.glAttachShader(program, pixel);
    gl_api.glLinkProgram(program);
    linked: s32;
    gl_api.glGetProgramiv(program, GL.GL_LINK_STATUS, *linked);
    if !linked {
        log_data: [LOG_BUFFER_SIZE] u8;
        gl_api.glGetProgramInfoLog(program, log_data.count, null, log_data.data);
        log_error("Simp shader failed to link: %\n", to_string(log_data.data));
        gl_api.glDeleteProgram(program);
        return 0;
    }
    return program;
}

// Every program is one source compiled twice, once per stage, with VERTEX_SHADER or FRAGMENT_SHADER defined.
SHADER_COLOR :: #string END
OUT_IN vec4 iterated_color;
#ifdef VERTEX_SHADER
in vec2 vert_position;
in vec4 vert_color;
uniform mat4 projection;
void main() {
    gl_Position = projection * vec4(vert_position, 0.0, 1.0);
    iterated_color = vert_color;
}
#endif
#ifdef FRAGMENT_SHADER
out vec4 color;
void main() { color = iterated_color; }
#endif
END

// Glyph pages are RGB: a gray ramp for ordinary anti-aliasing, per-subpixel coverage for LCD.
// Either way the average of the three is the coverage.
SHADER_TEXT :: #string END
OUT_IN vec2 TextureCoords;
OUT_IN vec4 iterated_color;
#ifdef VERTEX_SHADER
in vec2 vert_position;
in vec4 vert_color;
in vec2 vert_uv0;
uniform mat4 projection;
void main() {
    gl_Position = projection * vec4(vert_position, 0.0, 1.0);
    iterated_color = vert_color;
    TextureCoords = vert_uv0;
}
#endif
#ifdef FRAGMENT_SHADER
out vec4 color;
uniform sampler2D text_sampler;
void main() {
    vec3 mask = texture(text_sampler, TextureCoords).rgb;
    color = vec4(iterated_color.rgb, iterated_color.a * dot(mask, vec3(1.0 / 3.0)));
}
#endif
END

// Bitmaps are stored top row first, so the right-handed (y up) variant flips v.
SHADER_SPRITE_RIGHT_HANDED :: #string END
OUT_IN vec2 TexCoords;
OUT_IN vec4 iterated_color;
#ifdef VERTEX_SHADER
in vec2 vert_position;
in vec4 vert_color;
in vec2 vert_uv0;
uniform mat4 projection;
void main() {
    TexCoords = vec2(vert_uv0.x, 1.0 - vert_uv0.y);
    gl_Position = projection * vec4(vert_position, 0.0, 1.0);
    iterated_color = vert_color;
}
#endif
#ifdef FRAGMENT_SHADER
out vec4 color;
uniform sampler2D diffuse_texture;
void main() {
    vec4 sample_color = iterated_color * texture(diffuse_texture, TexCoords);
    if (sample_color.a < 0.1) discard;
    color = sample_color;
}
#endif
END

SHADER_SPRITE_LEFT_HANDED :: #string END
OUT_IN vec2 TexCoords;
OUT_IN vec4 iterated_color;
#ifdef VERTEX_SHADER
in vec2 vert_position;
in vec4 vert_color;
in vec2 vert_uv0;
uniform mat4 projection;
void main() {
    TexCoords = vert_uv0;
    gl_Position = projection * vec4(vert_position, 0.0, 1.0);
    iterated_color = vert_color;
}
#endif
#ifdef FRAGMENT_SHADER
out vec4 color;
uniform sampler2D diffuse_texture;
void main() {
    vec4 sample_color = iterated_color * texture(diffuse_texture, TexCoords);
    if (sample_color.a < 0.1) discard;
    color = sample_color;
}
#endif
END

// The rectangle is described by its center and half size; the corner is rounded by `radius` and
// the edge fades over `softness` pixels.
SHADER_ROUNDED_RECT :: #string END
OUT_IN vec4 iterated_color;
OUT_IN vec2 point;
OUT_IN vec2 rect_center;
OUT_IN vec2 rect_size;
OUT_IN float rect_radius;
OUT_IN float rect_softness;
#ifdef VERTEX_SHADER
in vec2 vert_position;
in vec4 vert_color;
in vec2 vert_rect_center;
in vec2 vert_rect_size;
in float vert_rect_radius;
in float vert_rect_softness;
uniform mat4 projection;
void main() {
    gl_Position = projection * vec4(vert_position, 0.0, 1.0);
    iterated_color = vert_color;
    point = vert_position;
    rect_center = vert_rect_center;
    rect_size = vert_rect_size;
    rect_radius = vert_rect_radius;
    rect_softness = vert_rect_softness;
}
#endif
#ifdef FRAGMENT_SHADER
out vec4 color;
void main() {
    vec2 q = abs(point - rect_center) - rect_size + rect_radius;
    float d = length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - rect_radius;
    float soft = clamp(d / max(rect_softness, 0.001), 0.0, 1.0);
    color = vec4(iterated_color.rgb, iterated_color.a * (1.0 - soft * soft * (3.0 - 2.0 * soft)));
}
#endif
END

SHADER_GRADIENT :: #string END
OUT_IN vec4 iterated_color;
OUT_IN vec2 point;
#ifdef VERTEX_SHADER
in vec2 vert_position;
in vec4 vert_color;
uniform mat4 projection;
void main() {
    gl_Position = projection * vec4(vert_position, 0.0, 1.0);
    iterated_color = vert_color;
    point = vert_position;
}
#endif
#ifdef FRAGMENT_SHADER
out vec4 color;
uniform vec4 gradient_rect;
uniform int gradient_mode;
uniform float gradient_value;
vec3 hsl(float h, float s, float l) {
    vec3 k = mod(vec3(0.0, 8.0, 4.0) + h * 12.0, 12.0);
    float a = s * min(l, 1.0 - l);
    return l - a * max(vec3(-1.0), min(k - 3.0, min(9.0 - k, vec3(1.0))));
}
void main() {
    vec2 uv = clamp((point - gradient_rect.xy) / max(gradient_rect.zw, vec2(0.001)), 0.0, 1.0);
    float z = gradient_value;
    int kind = gradient_mode & 15;
    vec3 rgb = vec3(0.0);
    if (gradient_mode < 16) {
        if (kind == 0) rgb = vec3(z, uv);
        if (kind == 1) rgb = vec3(uv.x, z, uv.y);
        if (kind == 2) rgb = vec3(uv, z);
        if (kind == 3) rgb = hsl(z, uv.x, uv.y);
        if (kind == 4) rgb = hsl(uv.x, z, uv.y);
        if (kind == 5) rgb = hsl(uv.x, uv.y, z);
    } else {
        float t = (gradient_mode & 32) != 0 ? uv.x : uv.y;
        if (kind == 0) rgb = vec3(t, 0.0, 0.0);
        if (kind == 1) rgb = vec3(0.0, t, 0.0);
        if (kind == 2) rgb = vec3(0.0, 0.0, t);
        if (kind == 3) rgb = hsl(t, 1.0, 0.5);
        if (kind == 4) rgb = hsl(z, t, 0.5);
        if (kind == 5) rgb = hsl(z, 1.0, t);
        if (kind == 6) rgb = vec3(t);
    }
    color = vec4(rgb, iterated_color.a);
}
#endif
END
