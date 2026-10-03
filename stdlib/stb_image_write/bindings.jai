// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
stbi_write_tga_with_rle: s32 #elsewhere stb_image_write;
stbi_write_png_compression_level: s32 #elsewhere stb_image_write;
stbi_write_force_png_filter: s32 #elsewhere stb_image_write;

stbi_write_png :: (filename: *u8, w: s32, h: s32, comp: s32, data: *void, stride_in_bytes: s32) -> s32 #foreign stb_image_write;
stbi_write_bmp :: (filename: *u8, w: s32, h: s32, comp: s32, data: *void) -> s32 #foreign stb_image_write;
stbi_write_tga :: (filename: *u8, w: s32, h: s32, comp: s32, data: *void) -> s32 #foreign stb_image_write;
stbi_write_hdr :: (filename: *u8, w: s32, h: s32, comp: s32, data: *float) -> s32 #foreign stb_image_write;
stbi_write_jpg :: (filename: *u8, x: s32, y: s32, comp: s32, data: *void, quality: s32) -> s32 #foreign stb_image_write;

stbi_write_func :: #type (_context: *void, data: *void, size: s32) -> void #c_call;

stbi_write_png_to_func :: (func: stbi_write_func, _context: *void, w: s32, h: s32, comp: s32, data: *void, stride_in_bytes: s32) -> s32 #foreign stb_image_write;
stbi_write_bmp_to_func :: (func: stbi_write_func, _context: *void, w: s32, h: s32, comp: s32, data: *void) -> s32 #foreign stb_image_write;
stbi_write_tga_to_func :: (func: stbi_write_func, _context: *void, w: s32, h: s32, comp: s32, data: *void) -> s32 #foreign stb_image_write;
stbi_write_hdr_to_func :: (func: stbi_write_func, _context: *void, w: s32, h: s32, comp: s32, data: *float) -> s32 #foreign stb_image_write;
stbi_write_jpg_to_func :: (func: stbi_write_func, _context: *void, x: s32, y: s32, comp: s32, data: *void, quality: s32) -> s32 #foreign stb_image_write;

stbi_flip_vertically_on_write :: (flip_boolean: s32) -> void #foreign stb_image_write;

#scope_file

#if OS == .WINDOWS {
    stb_image_write :: #system_library "stb_image_write";
} else #if OS == .LINUX {
    stb_image_write :: #system_library "stb_image_write";
} else #if OS == .MACOS {
    stb_image_write :: #system_library "stb_image_write";
} else #if OS == .ANDROID {
    #if CPU == .X64 {
        stb_image_write :: #system_library "stb_image_write";
    } else #if CPU == .ARM64 {
        stb_image_write :: #system_library "stb_image_write";
    }
} else #if OS == .PS5 {
    stb_image_write :: #system_library "stb_image_write";
} else {
    #assert false;
}
