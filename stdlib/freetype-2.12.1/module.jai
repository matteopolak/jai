// Independent declaration normalization; see docs/stdlib/native-bindings.md.
FT_HAS_HORIZONTAL :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_HORIZONTAL) != 0;
}

FT_HAS_VERTICAL :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_VERTICAL) != 0;
}

FT_HAS_KERNING :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_KERNING) != 0;
}

FT_IS_SCALABLE :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_SCALABLE) != 0;
}

FT_IS_SFNT :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_SFNT) != 0;
}

FT_IS_FIXED_WIDTH :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_FIXED_WIDTH) != 0;
}

FT_HAS_FIXED_SIZES :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_FIXED_SIZES) != 0;
}

FT_HAS_GLYPH_NAMES :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_GLYPH_NAMES) != 0;
}

FT_HAS_MULTIPLE_MASTERS :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_MULTIPLE_MASTERS) != 0;
}

FT_IS_NAMED_INSTANCE :: inline (face: FT_Face) -> bool {
    named_instance_bits := face.face_index & 0x7fff0000;
    return named_instance_bits != 0;
}

FT_IS_VARIATION :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_VARIATION) != 0;
}

FT_IS_CID_KEYED :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_CID_KEYED) != 0;
}

FT_IS_TRICKY :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_TRICKY) != 0;
}

FT_HAS_COLOR :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_COLOR) != 0;
}

FT_HAS_SVG :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_SVG) != 0;
}

FT_HAS_SBIX :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_SBIX) != 0;
}

FT_HAS_SBIX_OVERLAY :: inline (face: FT_Face) -> bool {
    flags := face.face_flags;
    return (flags & FT_FACE_FLAG_SBIX_OVERLAY) != 0;
}

TTAG_avar :u32: (#char "a" << 24) | (#char "v" << 16) | (#char "a" << 8) | (#char "r");
TTAG_BASE :u32: (#char "B" << 24) | (#char "A" << 16) | (#char "S" << 8) | (#char "E");
TTAG_bdat :u32: (#char "b" << 24) | (#char "d" << 16) | (#char "a" << 8) | (#char "t");
TTAG_BDF  :u32: (#char "B" << 24) | (#char "D" << 16) | (#char "F" << 8) | (#char " ");
TTAG_bhed :u32: (#char "b" << 24) | (#char "h" << 16) | (#char "e" << 8) | (#char "d");
TTAG_bloc :u32: (#char "b" << 24) | (#char "l" << 16) | (#char "o" << 8) | (#char "c");
TTAG_bsln :u32: (#char "b" << 24) | (#char "s" << 16) | (#char "l" << 8) | (#char "n");
TTAG_CBDT :u32: (#char "C" << 24) | (#char "B" << 16) | (#char "D" << 8) | (#char "T");
TTAG_CBLC :u32: (#char "C" << 24) | (#char "B" << 16) | (#char "L" << 8) | (#char "C");
TTAG_CFF  :u32: (#char "C" << 24) | (#char "F" << 16) | (#char "F" << 8) | (#char " ");
TTAG_CFF2 :u32: (#char "C" << 24) | (#char "F" << 16) | (#char "F" << 8) | (#char "2");
TTAG_CID  :u32: (#char "C" << 24) | (#char "I" << 16) | (#char "D" << 8) | (#char " ");
TTAG_cmap :u32: (#char "c" << 24) | (#char "m" << 16) | (#char "a" << 8) | (#char "p");
TTAG_COLR :u32: (#char "C" << 24) | (#char "O" << 16) | (#char "L" << 8) | (#char "R");
TTAG_CPAL :u32: (#char "C" << 24) | (#char "P" << 16) | (#char "A" << 8) | (#char "L");
TTAG_cvar :u32: (#char "c" << 24) | (#char "v" << 16) | (#char "a" << 8) | (#char "r");
TTAG_cvt  :u32: (#char "c" << 24) | (#char "v" << 16) | (#char "t" << 8) | (#char " ");
TTAG_DSIG :u32: (#char "D" << 24) | (#char "S" << 16) | (#char "I" << 8) | (#char "G");
TTAG_EBDT :u32: (#char "E" << 24) | (#char "B" << 16) | (#char "D" << 8) | (#char "T");
TTAG_EBLC :u32: (#char "E" << 24) | (#char "B" << 16) | (#char "L" << 8) | (#char "C");
TTAG_EBSC :u32: (#char "E" << 24) | (#char "B" << 16) | (#char "S" << 8) | (#char "C");
TTAG_feat :u32: (#char "f" << 24) | (#char "e" << 16) | (#char "a" << 8) | (#char "t");
TTAG_FOND :u32: (#char "F" << 24) | (#char "O" << 16) | (#char "N" << 8) | (#char "D");
TTAG_fpgm :u32: (#char "f" << 24) | (#char "p" << 16) | (#char "g" << 8) | (#char "m");
TTAG_fvar :u32: (#char "f" << 24) | (#char "v" << 16) | (#char "a" << 8) | (#char "r");
TTAG_gasp :u32: (#char "g" << 24) | (#char "a" << 16) | (#char "s" << 8) | (#char "p");
TTAG_GDEF :u32: (#char "G" << 24) | (#char "D" << 16) | (#char "E" << 8) | (#char "F");
TTAG_glyf :u32: (#char "g" << 24) | (#char "l" << 16) | (#char "y" << 8) | (#char "f");
TTAG_GPOS :u32: (#char "G" << 24) | (#char "P" << 16) | (#char "O" << 8) | (#char "S");
TTAG_GSUB :u32: (#char "G" << 24) | (#char "S" << 16) | (#char "U" << 8) | (#char "B");
TTAG_gvar :u32: (#char "g" << 24) | (#char "v" << 16) | (#char "a" << 8) | (#char "r");
TTAG_HVAR :u32: (#char "H" << 24) | (#char "V" << 16) | (#char "A" << 8) | (#char "R");
TTAG_hdmx :u32: (#char "h" << 24) | (#char "d" << 16) | (#char "m" << 8) | (#char "x");
TTAG_head :u32: (#char "h" << 24) | (#char "e" << 16) | (#char "a" << 8) | (#char "d");
TTAG_hhea :u32: (#char "h" << 24) | (#char "h" << 16) | (#char "e" << 8) | (#char "a");
TTAG_hmtx :u32: (#char "h" << 24) | (#char "m" << 16) | (#char "t" << 8) | (#char "x");
TTAG_JSTF :u32: (#char "J" << 24) | (#char "S" << 16) | (#char "T" << 8) | (#char "F");
TTAG_just :u32: (#char "j" << 24) | (#char "u" << 16) | (#char "s" << 8) | (#char "t");
TTAG_kern :u32: (#char "k" << 24) | (#char "e" << 16) | (#char "r" << 8) | (#char "n");
TTAG_lcar :u32: (#char "l" << 24) | (#char "c" << 16) | (#char "a" << 8) | (#char "r");
TTAG_loca :u32: (#char "l" << 24) | (#char "o" << 16) | (#char "c" << 8) | (#char "a");
TTAG_LTSH :u32: (#char "L" << 24) | (#char "T" << 16) | (#char "S" << 8) | (#char "H");
TTAG_LWFN :u32: (#char "L" << 24) | (#char "W" << 16) | (#char "F" << 8) | (#char "N");
TTAG_MATH :u32: (#char "M" << 24) | (#char "A" << 16) | (#char "T" << 8) | (#char "H");
TTAG_maxp :u32: (#char "m" << 24) | (#char "a" << 16) | (#char "x" << 8) | (#char "p");
TTAG_META :u32: (#char "M" << 24) | (#char "E" << 16) | (#char "T" << 8) | (#char "A");
TTAG_MMFX :u32: (#char "M" << 24) | (#char "M" << 16) | (#char "F" << 8) | (#char "X");
TTAG_MMSD :u32: (#char "M" << 24) | (#char "M" << 16) | (#char "S" << 8) | (#char "D");
TTAG_mort :u32: (#char "m" << 24) | (#char "o" << 16) | (#char "r" << 8) | (#char "t");
TTAG_morx :u32: (#char "m" << 24) | (#char "o" << 16) | (#char "r" << 8) | (#char "x");
TTAG_MVAR :u32: (#char "M" << 24) | (#char "V" << 16) | (#char "A" << 8) | (#char "R");
TTAG_name :u32: (#char "n" << 24) | (#char "a" << 16) | (#char "m" << 8) | (#char "e");
TTAG_opbd :u32: (#char "o" << 24) | (#char "p" << 16) | (#char "b" << 8) | (#char "d");
TTAG_OS2  :u32: (#char "O" << 24) | (#char "S" << 16) | (#char "/" << 8) | (#char "2");
TTAG_OTTO :u32: (#char "O" << 24) | (#char "T" << 16) | (#char "T" << 8) | (#char "O");
TTAG_PCLT :u32: (#char "P" << 24) | (#char "C" << 16) | (#char "L" << 8) | (#char "T");
TTAG_POST :u32: (#char "P" << 24) | (#char "O" << 16) | (#char "S" << 8) | (#char "T");
TTAG_post :u32: (#char "p" << 24) | (#char "o" << 16) | (#char "s" << 8) | (#char "t");
TTAG_prep :u32: (#char "p" << 24) | (#char "r" << 16) | (#char "e" << 8) | (#char "p");
TTAG_prop :u32: (#char "p" << 24) | (#char "r" << 16) | (#char "o" << 8) | (#char "p");
TTAG_sbix :u32: (#char "s" << 24) | (#char "b" << 16) | (#char "i" << 8) | (#char "x");
TTAG_sfnt :u32: (#char "s" << 24) | (#char "f" << 16) | (#char "n" << 8) | (#char "t");
TTAG_SING :u32: (#char "S" << 24) | (#char "I" << 16) | (#char "N" << 8) | (#char "G");
TTAG_SVG  :u32: (#char "S" << 24) | (#char "V" << 16) | (#char "G" << 8) | (#char " ");
TTAG_trak :u32: (#char "t" << 24) | (#char "r" << 16) | (#char "a" << 8) | (#char "k");
TTAG_true :u32: (#char "t" << 24) | (#char "r" << 16) | (#char "u" << 8) | (#char "e");
TTAG_ttc  :u32: (#char "t" << 24) | (#char "t" << 16) | (#char "c" << 8) | (#char " ");
TTAG_ttcf :u32: (#char "t" << 24) | (#char "t" << 16) | (#char "c" << 8) | (#char "f");
TTAG_TYP1 :u32: (#char "T" << 24) | (#char "Y" << 16) | (#char "P" << 8) | (#char "1");
TTAG_typ1 :u32: (#char "t" << 24) | (#char "y" << 16) | (#char "p" << 8) | (#char "1");
TTAG_VDMX :u32: (#char "V" << 24) | (#char "D" << 16) | (#char "M" << 8) | (#char "X");
TTAG_vhea :u32: (#char "v" << 24) | (#char "h" << 16) | (#char "e" << 8) | (#char "a");
TTAG_vmtx :u32: (#char "v" << 24) | (#char "m" << 16) | (#char "t" << 8) | (#char "x");
TTAG_VVAR :u32: (#char "V" << 24) | (#char "V" << 16) | (#char "A" << 8) | (#char "R");
TTAG_wOFF :u32: (#char "w" << 24) | (#char "O" << 16) | (#char "F" << 8) | (#char "F");
TTAG_wOF2 :u32: (#char "w" << 24) | (#char "O" << 16) | (#char "F" << 8) | (#char "2");

TTAG_0xA5kbd :: cast(u32) ((0xA5 << 24) | (#char "k" << 16) | (#char "b" << 8) | (#char "d"));

TTAG_0xA5lst :: cast(u32) ((0xA5 << 24) | (#char "l" << 16) | (#char "s" << 8) | (#char "t"));

#scope_module

ptrdiff_t :: s64;

#if OS == .WINDOWS {
    #load "windows.jai";
} else {
    #load "unix.jai";
}

#assert size_of(*void) == 8 "This pinned native ABI contract supports 64-bit targets only.";
