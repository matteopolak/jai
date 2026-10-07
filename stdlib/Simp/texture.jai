Texture_Flags :: enum_flags u16 {
    sRGB;
    Cube;
    Array;
    Volume;
    Buffer;
    Render_Target;
    Multisampled;
    No_Skip_Mipmaps;
    Display_Target;
}

// `gl_handle` is the OpenGL texture name (0 until the image reaches the GPU). `cpu` is the
// image itself for the CPU backend, and an image waiting for a graphics context in OpenGL;
// `framebuffer` belongs to render targets. Everything lives in the struct, so a Texture can be
// copied around by value like the original.
Texture_Platform_Specific :: struct {
    gl_handle: GLuint;
    framebuffer: GLuint;
    cpu: *Bitmap;
    nearest := false; // Sample without filtering (set before the first upload).
}

Texture :: struct {
    width, height, depth: s32 = 1; // Volume textures use depth; flat images leave it at 1.
    mipmap_count: u16 = 1;
    array_length: u16 = 1;
    format: Texture_Format;
    flags: Texture_Flags;
    using specific: Texture_Platform_Specific;
}

// Both loaders decode into a temporary Bitmap; the pixels end up owned by the texture (or the GPU).
texture_load_from_file :: (texture: *Texture, filename: string, srgb := false, build_mipmaps := false) -> bool {
    decoded: Bitmap;
    if !bitmap_load(*decoded, filename) return false;
    return adopt_decoded_image(texture, *decoded, srgb, build_mipmaps);
}

texture_load_from_memory :: (texture: *Texture, memory: [] u8, srgb := false, build_mipmaps := false) -> bool {
    decoded: Bitmap;
    if !bitmap_load_from_memory(*decoded, memory) return false;
    return adopt_decoded_image(texture, *decoded, srgb, build_mipmaps);
}

// Uploads the bitmap (all its mipmap levels). With OpenGL the texture stays bound to the 2D
// target afterwards, so a program can set sampling parameters right after loading. Loading
// before any window exists is fine: the image waits and goes to the GPU when it is first used.
texture_load_from_bitmap :: (using texture: *Texture, bitmap: *Bitmap) -> bool {
    if !texture || !bitmap || bitmap.width <= 0 || bitmap.height <= 0 || bitmap.mipmap_count <= 0 return false;
    if !is_supported(bitmap.format) return false;
    _, row := get_image_size(bitmap.format, bitmap.width, bitmap.height);
    if bitmap.stride < row || bitmap.data.count < bitmap.stride * bitmap.height return false;
    #if render_api == .OPENGL {
        if gl_api {
            if !gl_upload_texture(texture, bitmap) return false;
            texture_free_cpu(texture);
        } else texture_set_cpu_copy(texture, bitmap);
    } else #if render_api == .SOFTWARE {
        texture_set_cpu_copy(texture, bitmap);
    } else {
        return false;
    }
    texture.width = bitmap.width;
    texture.height = bitmap.height;
    texture.depth = 1;
    texture.mipmap_count = cast(u16) bitmap.mipmap_count;
    texture.format = bitmap.format;
    if bitmap.flags & .IS_SRGB texture.flags |= .sRGB;
    else texture.flags &= ~Texture_Flags.sRGB;
    return true;
}

// Pass a format with the pixel layout you want to draw into. The target is an ordinary texture
// afterwards (draw with it via set_shader_for_images) and is also what set_render_target takes.
texture_create_render_target :: (width: s32, height: s32, format: Texture_Format, flags: Texture_Flags = 0) -> *Texture {
    if width <= 0 || height <= 0 || !is_supported(format) return null;
    CheckInit();
    texture := New(Texture);
    texture.* = .{ format = format, flags = flags | .Render_Target, width = width, height = height };
    #if render_api == .OPENGL {
        if !gl_create_render_target(texture) {
            free(texture);
            return null;
        }
    } else #if render_api == .SOFTWARE {
        texture.cpu = New(Bitmap);
        bitmap_alloc(texture.cpu, width, height, format);
    } else {
        free(texture);
        return null;
    }
    return texture;
}

// Releases the GPU and CPU storage; the Texture struct itself belongs to the caller.
deinit :: (texture: *Texture) {
    if !texture return;
    CheckInit();
    if context.simp.texture_render_target == texture {
        immediate_flush();
        context.simp.texture_render_target = null;
    }
    #if render_api == .OPENGL {
        gl_delete_texture(texture);
    }
    texture_free_cpu(texture);
    texture.* = .{};
}

is_supported :: (format: Texture_Format) -> bool {
    #if render_api == .OPENGL {
        internal := gl_texture_format(format);
        return internal != 0;
    }
    return format == .R8 || format == .RG8 || format == .RGB8 || format == .RGBA8 || format == .BGRA8;
}

// The CPU copy of the image: the pixels of a CPU render target, or an image not yet on the GPU.
texture_bitmap :: (texture: *Texture) -> *Bitmap {
    if !texture return null;
    return texture.cpu;
}

#scope_module
adopt_decoded_image :: (texture: *Texture, decoded: *Bitmap, srgb: bool, build_mipmaps: bool) -> bool {
    if srgb decoded.flags |= .IS_SRGB;
    if build_mipmaps bitmap_build_mipmaps(decoded);
    ok := texture_load_from_bitmap(texture, decoded);
    deinit(decoded); // texture_load_from_bitmap copied or uploaded what it needs.
    return ok;
}

texture_free_cpu :: (texture: *Texture) {
    if !texture.cpu return;
    deinit(texture.cpu);
    free(texture.cpu);
    texture.cpu = null;
}

texture_set_cpu_copy :: (texture: *Texture, bitmap: *Bitmap) {
    texture_free_cpu(texture);
    copy := New(Bitmap);
    copy.* = bitmap.*;
    copy.data = array_copy(bitmap.data);
    copy.flags |= .FREE_DATA_ON_DEINIT;
    texture.cpu = copy;
}
