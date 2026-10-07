// Portable authored ICO writer. Raw pixels are bottom-up BGR or BGRA.
create_ico_file_from_bitmap_filename :: (bitmap_filename: string) -> string {
    bitmap, ok := read_entire_file(bitmap_filename);
    if !ok return "";
    defer free(bitmap);
    if bitmap.count < 54 || bitmap.data[0] != 66 || bitmap.data[1] != 77 return "";
    header_size := cast(s64) ico_u32(bitmap.data + 14);
    if header_size < 40 || header_size > bitmap.count - 14 return "";
    width := cast,no_check(s32) ico_u32(bitmap.data + 18);
    signed_height := cast,no_check(s32) ico_u32(bitmap.data + 22);
    bits := ico_u16(bitmap.data + 28);
    if width <= 0 || signed_height == 0 || signed_height == -2147483648 return "";
    if ico_u16(bitmap.data + 26) != 1 || ico_u32(bitmap.data + 30) != 0 return "";
    if bits != 24 && bits != 32 return "";
    height := signed_height;
    if height < 0 height = -height;
    source_comp := cast(s32) bits / 8;
    row_bytes := (cast(s64) width * source_comp + 3) & ~cast(s64) 3;
    offset := cast(s64) ico_u32(bitmap.data + 10);
    if offset < 14 + header_size || offset > bitmap.count return "";
    if row_bytes > (bitmap.count - offset) / height return "";
    area := cast(s64) width * height;
    if area > 0x7fff_ffff / 4 return "";
    pixel_count := area * 4;
    pixels := cast(*u8) alloc(pixel_count);
    if !pixels return "";
    defer free(pixels);
    have_alpha := false;
    for row: 0..cast(s64) height - 1 {
        source_row := row;
        if signed_height < 0 source_row = height - row - 1;
        source := bitmap.data + offset + source_row * row_bytes;
        target := pixels + row * width * 4;
        for column: 0..cast(s64) width - 1 {
            for channel: 0..2 target[column * 4 + channel] = source[column * source_comp + channel];
            alpha: u8 = 255;
            if source_comp == 4 alpha = source[column * 4 + 3];
            target[column * 4 + 3] = alpha;
            if alpha != 0 have_alpha = true;
        }
    }
    // BI_RGB 32-bit BMP commonly uses its fourth byte as unused XRGB padding.
    if source_comp == 4 && !have_alpha {
        for pixel: 0..area - 1 pixels[pixel * 4 + 3] = 255;
    }
    return create_ico_file(width, height, 4, pixels);
}

// Preserve the supplied public sizing-helper arithmetic, including spare bytes.
get_bytes_for_image :: (comp: s32, size: s32) -> (image_bytes: s32, mask_bytes: s32, total_bytes: s32) {
    if comp < 0 || size < 0 return 0, 0, 0;
    area := cast(s64) size * size;
    if comp > 0 && area > (0x7fff_ffff - 40) / (cast(s64) 2 * comp) return 0, 0, 0;
    image := 2 * area * comp + 40;
    mask := area / 4;
    total := image + mask * 2;
    if total > 0x7fff_ffff return 0, 0, 0;
    return cast(s32) image, cast(s32) mask, cast(s32) total;
}

get_total_bytes_for_size :: (comp: s32, size: s32) -> s32 {
    _, _, total_bytes := get_bytes_for_image(comp, size);
    return total_bytes;
}

create_ico_file :: (x: s32, y: s32, comp: s32, image_data: *u8) -> string {
    if x <= 0 || y <= 0 || !image_data || (comp != 3 && comp != 4) return "";
    // Prevent the input address calculations from overflowing signed offsets.
    if cast(s64) x * y > 0x7fff_ffff / comp return "";
    sizes :: s32.[256, 128, 48, 32, 16];
    total: s64 = 6 + sizes.count * (16 + 40);
    for size: sizes total += get_total_bytes_for_size(comp, size);
    result := alloc_string(total);
    if !result.data return "";
    memset(result.data, 0, total);
    ico_put16(result.data + 2, 1);
    ico_put16(result.data + 4, cast(u16) sizes.count);
    offset: s64 = 6 + sizes.count * 16;
    for size, index: sizes {
        entry := result.data + 6 + index * 16;
        entry[0] = cast,trunc(u8) size;
        entry[1] = cast,trunc(u8) size;
        ico_put16(entry + 4, 1);
        ico_put16(entry + 6, cast(u16) (comp * 8));
        capacity := get_total_bytes_for_size(comp, size);
        ico_put32(entry + 8, cast(u32) capacity);
        ico_put32(entry + 12, cast(u32) offset);
        dib := result.data + offset;
        ico_put32(dib, 40);
        ico_put32(dib + 4, cast(u32) size);
        ico_put32(dib + 8, cast(u32) (size * 2));
        ico_put16(dib + 12, 1);
        ico_put16(dib + 14, cast(u16) (comp * 8));
        xor_stride := (size * comp + 3) & ~3;
        mask_stride := ((size + 31) / 32) * 4;
        ico_put32(dib + 20, cast(u32) (xor_stride * size));
        image := dib + 40;
        mask := image + xor_stride * size;
        for row: 0..size - 1 {
            source_y := cast(s64) row * y / size;
            for column: 0..size - 1 {
                source_x := cast(s64) column * x / size;
                source := image_data + (source_y * x + source_x) * comp;
                target := image + row * xor_stride + column * comp;
                for channel: 0..comp - 1 target[channel] = source[channel];
                if comp == 4 && source[3] == 0 mask[row * mask_stride + column / 8] |= cast(u8) (128 >> (column % 8));
            }
        }
        offset += capacity;
    }
    return result;
}

#scope_file
#import "Basic";
#import "File";

ico_u16 :: (p: *u8) -> u16 {
    return (cast(u16) p[0]) | ((cast(u16) p[1]) << 8);
}

ico_u32 :: (p: *u8) -> u32 {
    return (cast(u32) p[0]) | ((cast(u32) p[1]) << 8) | ((cast(u32) p[2]) << 16) | ((cast(u32) p[3]) << 24);
}

ico_put16 :: (p: *u8, value: u16) {
    p[0] = cast,trunc(u8) value;
    p[1] = cast,trunc(u8) (value >> 8);
}

ico_put32 :: (p: *u8, value: u32) {
    for i: 0..3 p[i] = cast,trunc(u8) (value >> cast(u32) (i * 8));
}
