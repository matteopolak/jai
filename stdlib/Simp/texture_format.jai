Texture_Format :: enum u16 {
    Unknown :: 0;
    R8 :: 1;
    RG8 :: 2;
    RGB8 :: 3;
    RGBA8 :: 4;
    BGRA8;
    B5G6R5;
    RGB10A2;
    R16;
    R16F :: 0x10;
    RG16F;
    RGBA16F;
    R32F;
    RG32F;
    RGBA32F;
    RG11B10F;
    RGB9E5F;
    R16I;
    RG16I;
    RGBA16I;
    R32I;
    RG32I;
    RGBA32I;
    BC1 :: 0x100;
    BC3;
    BC4;
    BC5;
    BC6;
    BC7;
    ETC_RGB;
    ETC_RGBA;
    ETC_R;
    ETC_RG;
    ETC_RGB_A1;
    D16;
    D24S8;
    D32F;
    D32FS8;
}

get_image_bytes_per_texel :: (tf: Texture_Format) -> int {
    if tf == .R8 return 1;
    if tf == .RG8 || tf == .B5G6R5 || tf == .R16 || tf == .R16F || tf == .R16I || tf == .D16 return 2;
    if tf == .RGB8 return 3;
    if tf == .RGBA8 || tf == .BGRA8 || tf == .RGB10A2 || tf == .RG16F || tf == .R32F || tf == .RG11B10F || tf == .RGB9E5F || tf == .RG16I || tf == .R32I || tf == .D24S8 || tf == .D32F return 4;
    if tf == .RGBA16F || tf == .RG32F || tf == .RGBA16I || tf == .RG32I || tf == .D32FS8 return 8;
    if tf == .RGBA32F || tf == .RGBA32I return 16;
    return 0;
}

get_image_bytes_per_block :: (tf: Texture_Format) -> int {
    if tf == .BC1 || tf == .BC4 || tf == .ETC_RGB || tf == .ETC_R || tf == .ETC_RGB_A1 return 8;
    if tf == .BC3 || tf == .BC5 || tf == .BC6 || tf == .BC7 || tf == .ETC_RGBA || tf == .ETC_RG return 16;
    return 0;
}

get_image_size :: (tf: Texture_Format, w: int, h: int) -> int, stride: int {
    if w < 0 || h < 0 return 0, 0;
    texel := get_image_bytes_per_texel(tf);
    if texel {
        if w > 0x7fff_ffff_ffff_ffff / texel return 0, 0;
        row_bytes := w * texel;
        if h > 0 && row_bytes > 0x7fff_ffff_ffff_ffff / h return 0, 0;
        return row_bytes * h, row_bytes;
    }
    block := get_image_bytes_per_block(tf);
    if !block return 0, 0;
    columns := w / 4;
    if w % 4 != 0 columns += 1;
    rows := h / 4;
    if h % 4 != 0 rows += 1;
    if columns > 0x7fff_ffff_ffff_ffff / block return 0, 0;
    row_bytes := columns * block;
    if rows > 0 && row_bytes > 0x7fff_ffff_ffff_ffff / rows return 0, 0;
    return row_bytes * rows, row_bytes;
}
