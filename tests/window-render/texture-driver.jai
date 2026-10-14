#import "Basic";
S :: #import "Simp";
GL :: #import "GL";

probe :: #library "window_gl_probe";
begin_context :: () -> *void #foreign probe "window_gl_probe_begin";
end_context :: (context: *void) #foreign probe "window_gl_probe_end";

verify_pixels :: (texture: *S.Texture, bitmap: *S.Bitmap) {
    size := bitmap.width * bitmap.height * 4;
    pixels := cast(*u8) alloc(size);

    defer free(pixels);
    GL.gl.glBindTexture(GL.GL_TEXTURE_2D, texture.gl_handle);
    GL.gl.glGetTexImage(GL.GL_TEXTURE_2D, 0, GL.GL_RGBA, GL.GL_UNSIGNED_BYTE, pixels);
    assert(GL.gl.glGetError() == GL.GL_NO_ERROR);

    for row: 0..bitmap.height - 1 {
        assert(memcmp(pixels + row * bitmap.width * 4, bitmap.data.data + row * bitmap.stride, bitmap.width * 4) == 0);
    }
}

main :: () {
    native_context := begin_context();

    assert(native_context != null, "actual native OpenGL 4.1 context is required");
    defer end_context(native_context);
    assert(S.is_supported(.RGBA8));
    bitmap: S.Bitmap;

    S.bitmap_alloc(*bitmap, 3, 2, .RGBA8);
    defer S.deinit(*bitmap);
    for *byte, index: bitmap.data byte.* = cast(u8) (index * 7);

    sentinel: u32;

    GL.gl.glGenTextures(1, *sentinel);
    defer GL.gl.glDeleteTextures(1, *sentinel);
    GL.gl.glBindTexture(GL.GL_TEXTURE_2D, sentinel);
    pbo: u32;

    GL.gl.glGenBuffers(1, *pbo);
    defer GL.gl.glDeleteBuffers(1, *pbo);
    GL.gl.glBindBuffer(GL.GL_PIXEL_UNPACK_BUFFER, pbo);
    GL.gl.glBufferData(GL.GL_PIXEL_UNPACK_BUFFER, 128, null, GL.GL_DYNAMIC_DRAW);
    GL.gl.glPixelStorei(GL.GL_UNPACK_ALIGNMENT, 8);
    GL.gl.glPixelStorei(GL.GL_UNPACK_ROW_LENGTH, 7);
    GL.gl.glPixelStorei(GL.GL_UNPACK_SKIP_PIXELS, 1);
    GL.gl.glPixelStorei(GL.GL_UNPACK_SKIP_ROWS, 1);
    GL.gl.glPixelStorei(GL.GL_UNPACK_SWAP_BYTES, 1);
    assert(GL.gl.glGetError() == GL.GL_NO_ERROR);

    texture: S.Texture;

    assert(S.texture_load_from_bitmap(*texture, *bitmap));
    assert(texture.gl_handle != 0 && texture.width == 3 && texture.height == 2);
    check: s32;

    GL.gl.glGetIntegerv(GL.GL_TEXTURE_BINDING_2D, *check);
    assert(cast(u32) check == sentinel);
    GL.gl.glGetIntegerv(GL.GL_PIXEL_UNPACK_BUFFER_BINDING, *check);
    assert(cast(u32) check == pbo);
    GL.gl.glGetIntegerv(GL.GL_UNPACK_ALIGNMENT, *check);
    assert(check == 8);
    GL.gl.glGetIntegerv(GL.GL_UNPACK_ROW_LENGTH, *check);
    assert(check == 7);
    GL.gl.glGetIntegerv(GL.GL_UNPACK_SKIP_PIXELS, *check);
    assert(check == 1);
    GL.gl.glGetIntegerv(GL.GL_UNPACK_SKIP_ROWS, *check);
    assert(check == 1);
    GL.gl.glGetIntegerv(GL.GL_UNPACK_SWAP_BYTES, *check);
    assert(check == 1);
    verify_pixels(*texture, *bitmap);
    original_name := texture.gl_handle;

    for *byte: bitmap.data byte.* = 255 - byte.*;

    S.backend_update_texture(*texture, *bitmap);
    assert(texture.gl_handle == original_name);
    verify_pixels(*texture, *bitmap);
    S.deinit(*bitmap);
    S.bitmap_alloc(*bitmap, 5, 3, .RGBA8);
    for *byte, index: bitmap.data byte.* = cast(u8) (index * 3);

    S.backend_realloc_texture(*texture, *bitmap);
    assert(texture.gl_handle == original_name && texture.width == 5 && texture.height == 3);
    verify_pixels(*texture, *bitmap);
    S.bitmap_build_mipmaps(*bitmap);
    assert(S.texture_load_from_bitmap(*texture, *bitmap));
    assert(texture.mipmap_count == bitmap.mipmap_count && texture.mipmap_count == 3);
    GL.gl.glBindTexture(GL.GL_TEXTURE_2D, texture.gl_handle);
    mip_width: s32;

    GL.gl.glGetTexLevelParameteriv(GL.GL_TEXTURE_2D, 2, GL.GL_TEXTURE_WIDTH, *mip_width);
    assert(mip_width == 1 && GL.gl.glGetError() == GL.GL_NO_ERROR);
    original_name = texture.gl_handle;
    S.texture_destroy(*texture);
    assert(texture.gl_handle == 0);
    assert(!GL.gl.glIsTexture(original_name));
    assert(GL.gl.glGetError() == GL.GL_NO_ERROR);
    print("ok\n");
}
