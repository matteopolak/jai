Texture_Flags :: enum_flags u16 {
    sRGB; Cube; Array; Volume; Buffer; Render_Target; Multisampled; No_Skip_Mipmaps; Display_Target;
}
Texture_Platform_Specific :: struct { gl_handle: GLuint; }
Texture :: struct {
    width, height, depth: s32 = 1;
    mipmap_count: u16 = 1;
    array_length: u16 = 1;
    format: Texture_Format;
    flags: Texture_Flags;
    using specific: Texture_Platform_Specific;
}
texture_load_from_file :: (map: *Texture, filename: string, srgb := false, build_mipmaps := false) -> bool {
    bitmap: Bitmap;
    if !bitmap_load(*bitmap, filename) return false;
    defer deinit(*bitmap);
    if srgb bitmap.flags |= .IS_SRGB;
    if build_mipmaps bitmap_build_mipmaps(*bitmap);
    return texture_load_from_bitmap(map, *bitmap);
}
texture_load_from_memory :: (texture: *Texture, memory: [] u8, srgb := false, build_mipmaps := false) -> bool {
    bitmap: Bitmap;
    if !bitmap_load_from_memory(*bitmap, memory) return false;
    defer deinit(*bitmap);
    if srgb bitmap.flags |= .IS_SRGB;
    if build_mipmaps bitmap_build_mipmaps(*bitmap);
    return texture_load_from_bitmap(texture, *bitmap);
}
texture_load_from_bitmap :: (using texture: *Texture, bitmap: *Bitmap) -> bool {
    if !texture || !bitmap || bitmap.width <= 0 || bitmap.height <= 0 || bitmap.mipmap_count <= 0 return false;
    if !is_supported(bitmap.format) return false;
    bytes, stride := get_image_size(bitmap.format, bitmap.width, bitmap.height);
    if bitmap.stride < stride || bitmap.data.count < bitmap.stride * bitmap.height return false;
    #if render_api == .OPENGL {
        if !gl_upload_texture(texture, bitmap) return false;
    } else #if render_api == .SOFTWARE {
        record := texture_record(texture, true);
        deinit(*record.bitmap);
        record.bitmap.* = bitmap.*;
        record.bitmap.data = array_copy(bitmap.data);
        record.bitmap.flags |= .FREE_DATA_ON_DEINIT;
    } else { return false; }
    texture.width = bitmap.width; texture.height = bitmap.height; texture.depth = 1;
    texture.mipmap_count = cast(u16)bitmap.mipmap_count; texture.format = bitmap.format;
    if bitmap.flags & .IS_SRGB texture.flags |= .sRGB;
    else texture.flags &= ~Texture_Flags.sRGB;
    return true;
}
texture_create_render_target :: (width: s32, height: s32, format: Texture_Format, flags: Texture_Flags = 0) -> *Texture {
    if width <= 0 || height <= 0 || !is_supported(format) return null;
    CheckInit();
    texture := New(Texture);
    texture.width = width; texture.height = height; texture.format = format;
    texture.flags = flags | .Render_Target;
    #if render_api == .OPENGL {
        if !gl_create_render_target(texture) { free(texture); return null; }
    } else #if render_api == .SOFTWARE {
        record := texture_record(texture, true); bitmap_alloc(*record.bitmap, width, height, format);
    } else { free(texture); return null; }
    return texture;
}
deinit :: (texture: *Texture) {
    if !texture return;
    CheckInit();
    if context.simp.texture_render_target == texture { immediate_flush(); context.simp.texture_render_target = null; }
    #if render_api == .OPENGL { gl_delete_texture(texture); }
    record := texture_record(texture, false);
    if record { deinit(*record.bitmap); record.texture = null; }
    texture.* = .{};
}
is_supported :: (format: Texture_Format) -> bool {
    #if render_api == .OPENGL { internal, external, type := gl_texture_format(format); return internal != 0; }
    return format == .R8 || format == .RG8 || format == .RGB8 || format == .RGBA8 || format == .BGRA8;
}
// Additional CPU inspection API, retaining the published Texture layout.
texture_bitmap :: (texture: *Texture) -> *Bitmap {
    record := texture_record(texture, false); if !record return null;
    return *record.bitmap;
}
#scope_module
Texture_Record :: struct { texture: *Texture; bitmap: Bitmap; framebuffer: u32; }
texture_records: [..] *Texture_Record;
texture_record :: (texture: *Texture, create: bool) -> *Texture_Record {
    for record: texture_records if record.texture == texture return record;
    if !create return null;
    record := New(Texture_Record); record.texture = texture;
    array_add(*texture_records, record); return record;
}
