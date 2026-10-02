// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
FT_Init_FreeType   :: (library: **FT_Library) -> FT_Error    #foreign ft;
FT_New_Face        :: (library: *FT_Library, filepathname: *u8, face_index: FT_Long, aface: *FT_Face) -> FT_Error #foreign ft;
FT_New_Memory_Face :: (library: *FT_Library, file_base: *void, file_size: FT_Long, face_index: FT_Long, aface: *FT_Face) -> FT_Error   #foreign ft;

FT_Load_Char       :: (face: FT_Face, charcode: FT_ULong, load_flags: FT_Int) -> FT_Error #foreign ft;
FT_Load_Glyph      :: (face: FT_Face, glyph_index: FT_UInt, load_flags: s32) -> FT_Error  #foreign ft;
FT_Get_Char_Index  :: (face: FT_Face, charcode: FT_ULong) -> u32  #foreign ft;

FT_Set_Pixel_Sizes :: (face: FT_Face, pixel_width: u32, pixel_height: u32) -> FT_Error  #foreign ft;

FT_Get_Kerning     :: (face: FT_Face, left_glyph: u32, right_glyph: u32, kern_mode: u32, akerning: *FT_Vector) -> FT_Error  #foreign ft;

FT_Select_Charmap  :: (face: FT_Face, encoding: FT_Encoding) -> FT_Error #foreign ft;

FT_Load_Sfnt_Table :: (face: FT_Face, tag: FT_ULong, offset: FT_Long, buffer: *u8, length: *FT_ULong) -> FT_Error #foreign ft;

FT_Done_Face       :: (face: FT_Face) -> FT_Error #foreign ft;
FT_Done_FreeType   :: (library: *FT_Library) -> FT_Error #foreign ft;

FT_Error :: s32;
FT_Encoding :: u32;
FT_Sfnt_Tag :: u32;

FT_Err_Ok                   :: 0x00;
FT_Err_Cannot_Open_Resource :: 0x01;
FT_Err_Unknown_File_Format  :: 0x02;
FT_Err_Invalid_File_Format  :: 0x03;
FT_Err_Invalid_Version      :: 0x04;

FT_GlyphSlotRec :: struct {
    library:   *FT_Library;
    face:      FT_Face;
    next:      *FT_GlyphSlotRec;
    reserved:  FT_UInt;
    generic:   FT_Generic;

    metrics:   FT_Glyph_Metrics;
    linearHoriAdvance:  FT_Fixed;
    linearVertAdvance:  FT_Fixed;

    advance:   FT_Vector;

    format:    FT_Glyph_Format;

    bitmap:       FT_Bitmap;
    bitmap_left:  FT_Int;
    bitmap_top:   FT_Int;

    outline:   FT_Outline;

    num_subglyphs: FT_UInt;
    subglyphs:     *void;

    control_data:  *void;

    #if OS == .WINDOWS {
        control_len:   s32;
    } else {
        control_len:   s64;
    }

    lsb_delta:  FT_Pos;
    rsb_delta:  FT_Pos;

    other:    *void;

    internal: *FT_Slot_InternalRec;
}

FT_CharMapRec :: struct { }
FT_StreamRec  :: struct { }
FT_MemoryRec  :: struct { }
FT_ListNode   :: struct { }
FT_Library    :: struct { }
FT_Face_Internal :: struct { }
FT_Slot_InternalRec :: struct { }
FT_Size_InternalRec :: struct { }

FT_HAS_KERNING :: inline (face: *FT_FaceRec) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_KERNING) != 0;
}

FT_Generic :: struct {
    data:       *void;
    finalizer:  (object: *void) -> *void;
}

FT_Vector :: struct {
    x: FT_Pos; y : FT_Pos;
}

FT_LOAD_DEFAULT                      :: 0x0000;
FT_LOAD_NO_SCALE                     :: 0x0001;
FT_LOAD_NO_HINTING                   :: 0x0002;
FT_LOAD_RENDER                       :: 0x0004;
FT_LOAD_NO_BITMAP                    :: 0x0008;
FT_LOAD_VERTICAL_LAYOUT              :: 0x0010;
FT_LOAD_FORCE_AUTOHINT               :: 0x0020;
FT_LOAD_CROP_BITMAP                  :: 0x0040;
FT_LOAD_PEDANTIC                     :: 0x0080;
FT_LOAD_IGNORE_GLOBAL_ADVANCE_WIDTH  :: 0x0200;
FT_LOAD_NO_RECURSE                   :: 0x0400;
FT_LOAD_IGNORE_TRANSFORM             :: 0x0800;
FT_LOAD_MONOCHROME                   :: 0x1000;
FT_LOAD_LINEAR_DESIGN                :: 0x2000;
FT_LOAD_NO_AUTOHINT                  :: 0x8000;
FT_LOAD_COLOR                        :: 0x20000;

FT_FACE_FLAG_SCALABLE          :: 0x0000;
FT_FACE_FLAG_FIXED_SIZES       :: 0x0001;
FT_FACE_FLAG_FIXED_WIDTH       :: 0x0002;
FT_FACE_FLAG_SFNT              :: 0x0004;
FT_FACE_FLAG_HORIZONTAL        :: 0x0008;
FT_FACE_FLAG_VERTICAL          :: 0x0010;
FT_FACE_FLAG_KERNING           :: 0x0020;
FT_FACE_FLAG_FAST_GLYPHS       :: 0x0040;
FT_FACE_FLAG_MULTIPLE_MASTERS  :: 0x0080;
FT_FACE_FLAG_GLYPH_NAMES       :: 0x0100;
FT_FACE_FLAG_EXTERNAL_STREAM   :: 0x0200;
FT_FACE_FLAG_HINTER            :: 0x0400;
FT_FACE_FLAG_CID_KEYED         :: 0x0800;
FT_FACE_FLAG_TRICKY            :: 0x1000;
FT_FACE_FLAG_COLOR             :: 0x2000;

FT_KERNING_DEFAULT   : u32 : 0;
FT_KERNING_UNFITTED  : u32 : 1;
FT_KERNING_UNSCALED  : u32 : 2;

FT_ENCODING_UNICODE : u32 : 0x756E6963;

TTAG_GSUB : u32 : 0x47535542;

FT_Glyph_Metrics :: struct {
    width:  FT_Pos;
    height: FT_Pos;

    horiBearingX: FT_Pos;
    horiBearingY: FT_Pos;
    horiAdvance:  FT_Pos;

    vertBearingX: FT_Pos;
    vertBearingY: FT_Pos;
    vertAdvance:  FT_Pos;
}

FT_Glyph_Format :: enum u32 {
    PLACEHOLDER :: 0;
}

FT_Bitmap :: struct {
    rows:         s32;
    width:        s32;
    pitch:        s32;
    buffer:       *u8;
    num_grays:    s16;
    pixel_mode:   s8;
    palette_mode: s8;
    palette:      *void;
}

FT_Size_Metrics :: struct {
    x_ppem: FT_UShort;
    y_ppem: FT_UShort;

    x_scale: FT_Fixed;
    y_scale: FT_Fixed;

    ascender:    FT_Pos;
    descender:   FT_Pos;
    height:      FT_Pos;
    max_advance: FT_Pos;
}

FT_SizeRec :: struct {
    face:     FT_Face;
    generic:  FT_Generic;
    metrics:  FT_Size_Metrics;
    internal: *FT_Size_InternalRec;
}

FT_BBox :: struct {
    xMin: FT_Pos; yMin: FT_Pos;
    xMax: FT_Pos; yMax: FT_Pos;
}

FT_ListRec :: struct {
    head: *FT_ListNode;
    tail: *FT_ListNode;
}

#if OS == .WINDOWS {
    FT_Long  :: s32;
    FT_ULong :: u32;
    FT_Int  :: s32;
    FT_UInt :: u32;
    FT_UShort :: u16;
    FT_Short  :: s16;

    FT_Fixed :: u32;
    FT_Pos   :: s32;

} else {
    FT_Long  :: s64;
    FT_ULong :: u64;
    FT_UShort :: u16;
    FT_Short  :: s16;
    FT_Int  :: s32;
    FT_UInt :: u32;

    FT_Fixed :: u64;
    FT_Pos   :: s64;
}

FT_FaceRec :: struct {
    num_faces:   FT_Long;
    face_index:  FT_Long;

    face_flags:  FT_Long;
    style_flags: FT_Long;

    num_glyphs:  FT_Long;

    family_name: *u8;
    style_name:  *u8;

    num_fixed_sizes: FT_Int;
    available_sizes: *void;

    num_charmaps: FT_Int;
    charmaps:     *void;

    generic: FT_Generic;

    bbox: FT_BBox;

    units_per_EM: FT_UShort;
    ascender:     FT_Short;
    descender:    FT_Short;
    height:       FT_Short;

    max_advance_width:  FT_Short;
    max_advance_height: FT_Short;

    underline_position:  FT_Short;
    underline_thickness: FT_Short;

    glyph:   *FT_GlyphSlotRec;
    size:    *FT_SizeRec;
    charmap: *FT_CharMapRec;

    driver:  *void;
    memory:  *FT_MemoryRec;
    stream:  *FT_StreamRec;

    sizes_list: FT_ListRec;

    autohint:  FT_Generic;
    extensions: *void;

    internal: *FT_Face_Internal;

}

FT_Outline :: struct {
    n_contours: s16;
    n_points:   s16;

    points:     *FT_Vector;
    tags:       *u8;
    contours:   *s16;

    flags:      s32;
}

FT_Face :: *FT_FaceRec;

#scope_file

#if OS == .WINDOWS {
    ft :: #system_library "jai_freetype255_legacy_adapter";
} else #if OS == .LINUX || OS == .ANDROID {
    ft :: #system_library "jai_freetype255_legacy_adapter";
} else #if OS == .MACOS {
    ft :: #system_library "jai_freetype255_legacy_adapter";
} else #if OS == .PS5 {
    ft :: #system_library "jai_freetype255_legacy_adapter";
}

#assert size_of(*void) == 8 "This pinned native ABI contract supports 64-bit targets only.";
