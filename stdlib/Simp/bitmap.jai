Bitmap :: struct {
    width: s32;
    height: s32;
    mipmap_count: s32 = 1;
    data: [] u8;
    stride: s32;
    flags: enum_flags u32 {
        FREE_DATA_ON_DEINIT :: 0x1;
        IS_SRGB :: 0x2;
    }
    format := Texture_Format.BGRA8;
}

bitmap_alloc :: (using bitmap: *Bitmap, w: s32, h: s32, _format: Texture_Format) {
    assert(w >= 0 && h >= 0);
    bytes, stride := get_image_size(_format, w, h);
    assert(bytes >= 0 && stride <= 0x7fff_ffff && (bytes > 0 || w == 0 || h == 0), "Unsupported or overflowing bitmap dimensions");
    if bytes == 0 && w > 0 && h > 0 return;
    deinit(bitmap);
    data := NewArray(bytes, u8, true);
    if bytes > 0 && !data.data {
        bitmap.* = .{};
        assert(false, "Could not allocate bitmap storage");
        return;
    }
    bitmap.* = .{ width = w, height = h, data = data, stride = cast(s32) stride, format = _format };
    bitmap.flags = .FREE_DATA_ON_DEINIT;
}

deinit :: (bitmap: *Bitmap) {
    if bitmap.flags & .FREE_DATA_ON_DEINIT array_free(bitmap.data);
    bitmap.* = .{};
}

// Codec procedures are native bindings; their system adapter must be supplied.
bitmap_load :: (bitmap: *Bitmap, filepath: string) -> bool {
    w, h, channels: s32;
    pixels := Image.stbi_load(temp_c_string(filepath), *w, *h, *channels, 0);
    if !pixels return false;
    defer Image.stbi_image_free(pixels);
    return bitmap_take_decoded(bitmap, pixels, w, h, channels);
}

bitmap_load_from_memory :: (bitmap: *Bitmap, memory: [] u8) -> bool {
    if memory.count <= 0 || memory.count > 0x7fff_ffff return false;
    w, h, channels: s32;
    pixels := Image.stbi_load_from_memory(memory.data, cast(s32) memory.count, *w, *h, *channels, 0);
    if !pixels return false;
    defer Image.stbi_image_free(pixels);
    return bitmap_take_decoded(bitmap, pixels, w, h, channels);
}

bitmap_save :: (bitmap: *Bitmap, filepath: string, save_alpha := false) -> bool {
    if !bitmap || bitmap.width <= 0 || bitmap.height <= 0 return false;
    if bitmap.format != .RGB8 && bitmap.format != .RGBA8 return false;
    channels: s32 = 3;
    if bitmap.format == .RGBA8 channels = 4;
    name := temp_c_string(filepath);
    extension := Strings.path_extension(filepath);
    if extension == "png" return Image_Write.stbi_write_png(name, bitmap.width, bitmap.height, channels, bitmap.data.data, bitmap.stride) != 0;
    if bitmap.stride != bitmap.width * channels return false;
    if extension == "bmp" return Image_Write.stbi_write_bmp(name, bitmap.width, bitmap.height, channels, bitmap.data.data) != 0;
    if extension == "tga" return Image_Write.stbi_write_tga(name, bitmap.width, bitmap.height, channels, bitmap.data.data) != 0;
    if extension == "jpg" return Image_Write.stbi_write_jpg(name, bitmap.width, bitmap.height, channels, bitmap.data.data, 80) != 0;
    return false;
}

bitmap_build_mipmaps :: (bitmap: *Bitmap) {
    assert(bitmap.width > 0 && bitmap.height > 0 && bitmap.mipmap_count == 1);
    channels := get_image_bytes_per_texel(bitmap.format);
    assert(bitmap.format == .R8 || bitmap.format == .RG8 || bitmap.format == .RGB8 || bitmap.format == .RGBA8 || bitmap.format == .BGRA8, "Mipmaps require an 8-bit component format");
    w := bitmap.width;
    h := bitmap.height;
    levels: s32 = 1;
    bytes: int = cast(int) w * h * channels;
    while w > 1 || h > 1 {
        w = max(w / 2, 1);
        h = max(h / 2, 1);
        bytes += cast(int) w * h * channels;
        levels += 1;
    }
    output := NewArray(bytes, u8, true);
    for y: 0..bitmap.height - 1 memcpy(output.data + y * bitmap.width * channels, bitmap.data.data + y * bitmap.stride, bitmap.width * channels);
    source := output.data;
    source_w := bitmap.width;
    source_h := bitmap.height;
    dest := source + source_w * source_h * channels;
    for level: 1..levels - 1 {
        dest_w := max(source_w / 2, 1);
        dest_h := max(source_h / 2, 1);
        for y: 0..dest_h - 1 for x : 0..dest_w - 1 for c : 0..channels - 1 {
            sum: float64;
            samples: int;
            for dy: 0..1 for dx : 0..1 {
                sx := min(2 * x + dx, source_w - 1);
                sy := min(2 * y + dy, source_h - 1);
                value := cast(float64) source[(sy * source_w + sx) * channels + c] / 255;
                if bitmap.flags & .IS_SRGB && !(channels == 4 && c == 3) value = pow(value, 2.2);
                sum += value;
                samples += 1;
            }
            value := sum / cast(float64) samples;
            if bitmap.flags & .IS_SRGB && !(channels == 4 && c == 3) value = pow(value, 1 / 2.2);
            dest[(y * dest_w + x) * channels + c] = cast(u8) clamp(floor(value * 255 + 0.5), 0.0, 255.0);
        }
        source = dest;
        source_w = dest_w;
        source_h = dest_h;
        dest += dest_w * dest_h * channels;
    }
    if bitmap.flags & .FREE_DATA_ON_DEINIT array_free(bitmap.data);
    bitmap.data = output;
    bitmap.stride = cast(s32) (bitmap.width * channels);
    bitmap.mipmap_count = levels;
    bitmap.flags |= .FREE_DATA_ON_DEINIT;
}

#scope_file
Image :: #import "stb_image";
Image_Write :: #import "stb_image_write";

bitmap_take_decoded :: (bitmap: *Bitmap, pixels: *u8, w: s32, h: s32, channels: s32) -> bool {
    if w <= 0 || h <= 0 || channels < 1 || channels > 4 return false;
    formats := Texture_Format.[.R8, .RG8, .RGB8, .RGBA8];
    bitmap_alloc(bitmap, w, h, formats[channels - 1]);
    memcpy(bitmap.data.data, pixels, bitmap.data.count);
    return true;
}
