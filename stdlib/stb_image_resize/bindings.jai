// Independent declaration normalization; see docs/stdlib/native-bindings.md.
STBIR_ALPHA_CHANNEL_NONE :: -1;

Resize_Flags :: enum_flags s32 {
    ALPHA_PREMULTIPLIED :: 1 << 0;

    ALPHA_USES_COLORSPACE :: 1 << 1;

    STBIR_FLAG_ALPHA_PREMULTIPLIED :: ALPHA_PREMULTIPLIED;

    STBIR_FLAG_ALPHA_USES_COLORSPACE :: ALPHA_USES_COLORSPACE;
}

stbir_resize_uint8 :: (input_pixels: *u8, input_w: s32, input_h: s32, input_stride_in_bytes: s32, output_pixels: *u8, output_w: s32, output_h: s32, output_stride_in_bytes: s32, num_channels: s32) -> s32 #foreign stb_image_resize;

stbir_resize_float :: (input_pixels: *float, input_w: s32, input_h: s32, input_stride_in_bytes: s32, output_pixels: *float, output_w: s32, output_h: s32, output_stride_in_bytes: s32, num_channels: s32) -> s32 #foreign stb_image_resize;

stbir_resize_uint8_srgb :: (input_pixels: *u8, input_w: s32, input_h: s32, input_stride_in_bytes: s32, output_pixels: *u8, output_w: s32, output_h: s32, output_stride_in_bytes: s32, num_channels: s32, alpha_channel: s32, flags: Resize_Flags) -> s32 #foreign stb_image_resize;

stbir_edge :: enum u32 {
    CLAMP :: 1;
    REFLECT :: 2;
    WRAP :: 3;
    ZERO :: 4;

    STBIR_EDGE_CLAMP :: CLAMP;
    STBIR_EDGE_REFLECT :: REFLECT;
    STBIR_EDGE_WRAP :: WRAP;
    STBIR_EDGE_ZERO :: ZERO;
}

stbir_resize_uint8_srgb_edgemode :: (input_pixels: *u8, input_w: s32, input_h: s32, input_stride_in_bytes: s32, output_pixels: *u8, output_w: s32, output_h: s32, output_stride_in_bytes: s32, num_channels: s32, alpha_channel: s32, flags: Resize_Flags, edge_wrap_mode: stbir_edge) -> s32 #foreign stb_image_resize;

stbir_filter :: enum u32 {
    DEFAULT :: 0;
    BOX :: 1;
    TRIANGLE :: 2;
    CUBICBSPLINE :: 3;
    CATMULLROM :: 4;
    MITCHELL :: 5;

    STBIR_FILTER_DEFAULT :: DEFAULT;
    STBIR_FILTER_BOX :: BOX;
    STBIR_FILTER_TRIANGLE :: TRIANGLE;
    STBIR_FILTER_CUBICBSPLINE :: CUBICBSPLINE;
    STBIR_FILTER_CATMULLROM :: CATMULLROM;
    STBIR_FILTER_MITCHELL :: MITCHELL;
}

stbir_colorspace :: enum u32 {
    COLORSPACE_LINEAR :: 0;
    COLORSPACE_SRGB :: 1;

    MAX_COLORSPACES :: 2;

    STBIR_COLORSPACE_LINEAR :: COLORSPACE_LINEAR;
    STBIR_COLORSPACE_SRGB :: COLORSPACE_SRGB;

    STBIR_MAX_COLORSPACES :: MAX_COLORSPACES;
}

stbir_resize_uint8_generic :: (input_pixels: *u8, input_w: s32, input_h: s32, input_stride_in_bytes: s32, output_pixels: *u8, output_w: s32, output_h: s32, output_stride_in_bytes: s32, num_channels: s32, alpha_channel: s32, flags: Resize_Flags, edge_wrap_mode: stbir_edge, filter: stbir_filter, space: stbir_colorspace, alloc_context: *void) -> s32 #foreign stb_image_resize;

stbir_resize_uint16_generic :: (input_pixels: *u16, input_w: s32, input_h: s32, input_stride_in_bytes: s32, output_pixels: *u16, output_w: s32, output_h: s32, output_stride_in_bytes: s32, num_channels: s32, alpha_channel: s32, flags: Resize_Flags, edge_wrap_mode: stbir_edge, filter: stbir_filter, space: stbir_colorspace, alloc_context: *void) -> s32 #foreign stb_image_resize;

stbir_resize_float_generic :: (input_pixels: *float, input_w: s32, input_h: s32, input_stride_in_bytes: s32, output_pixels: *float, output_w: s32, output_h: s32, output_stride_in_bytes: s32, num_channels: s32, alpha_channel: s32, flags: Resize_Flags, edge_wrap_mode: stbir_edge, filter: stbir_filter, space: stbir_colorspace, alloc_context: *void) -> s32 #foreign stb_image_resize;

stbir_datatype :: enum u32 {
    TYPE_UINT8 :: 0;
    TYPE_UINT16 :: 1;
    TYPE_UINT32 :: 2;
    TYPE_FLOAT :: 3;

    MAX_TYPES :: 4;

    STBIR_TYPE_UINT8 :: TYPE_UINT8;
    STBIR_TYPE_UINT16 :: TYPE_UINT16;
    STBIR_TYPE_UINT32 :: TYPE_UINT32;
    STBIR_TYPE_FLOAT :: TYPE_FLOAT;

    STBIR_MAX_TYPES :: MAX_TYPES;
}

stbir_resize :: (input_pixels: *void, input_w: s32, input_h: s32, input_stride_in_bytes: s32, output_pixels: *void, output_w: s32, output_h: s32, output_stride_in_bytes: s32, datatype: stbir_datatype, num_channels: s32, alpha_channel: s32, flags: Resize_Flags, edge_mode_horizontal: stbir_edge, edge_mode_vertical: stbir_edge, filter_horizontal: stbir_filter, filter_vertical: stbir_filter, space: stbir_colorspace, alloc_context: *void) -> s32 #foreign stb_image_resize;

stbir_resize_subpixel :: (input_pixels: *void, input_w: s32, input_h: s32, input_stride_in_bytes: s32, output_pixels: *void, output_w: s32, output_h: s32, output_stride_in_bytes: s32, datatype: stbir_datatype, num_channels: s32, alpha_channel: s32, flags: Resize_Flags, edge_mode_horizontal: stbir_edge, edge_mode_vertical: stbir_edge, filter_horizontal: stbir_filter, filter_vertical: stbir_filter, space: stbir_colorspace, alloc_context: *void, x_scale: float, y_scale: float, x_offset: float, y_offset: float) -> s32 #foreign stb_image_resize;

stbir_resize_region :: (input_pixels: *void, input_w: s32, input_h: s32, input_stride_in_bytes: s32, output_pixels: *void, output_w: s32, output_h: s32, output_stride_in_bytes: s32, datatype: stbir_datatype, num_channels: s32, alpha_channel: s32, flags: Resize_Flags, edge_mode_horizontal: stbir_edge, edge_mode_vertical: stbir_edge, filter_horizontal: stbir_filter, filter_vertical: stbir_filter, space: stbir_colorspace, alloc_context: *void, s0: float, t0: float, s1: float, t1: float) -> s32 #foreign stb_image_resize;

#scope_file

#if OS == .WINDOWS {
    stb_image_resize :: #system_library "stb_image_resize";
} else #if OS == .LINUX {
    stb_image_resize :: #system_library "stb_image_resize";
} else #if OS == .MACOS {
    stb_image_resize :: #system_library "stb_image_resize";
} else #if OS == .ANDROID {
    #if CPU == .X64 {
        stb_image_resize :: #system_library "stb_image_resize";
    } else #if CPU == .ARM64 {
        stb_image_resize :: #system_library "stb_image_resize";
    }
} else #if OS == .PS5 {
    stb_image_resize :: #system_library "stb_image_resize";
} else {
    #assert false;
}
