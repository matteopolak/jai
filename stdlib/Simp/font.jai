#scope_module
File :: #import "File";
FT :: #import "freetype-2.12.1";
#scope_export
FT_Face :: FT.FT_Face;
Font_Effects :: enum_flags u32 { SMALLCAPS :: 1; LINING_FIGURES :: 2; NO_KERNING :: 4; LEFT_JUSTIFIED :: 8; }
Glyph_Data :: struct {
    utf32: u32;
    glyph_index_within_font: u32;
    x0, y0: s16;
    width, height: u32;
    offset_x, offset_y: s16;
    ascent: s16;
    advance: s16;
    page: *Font_Page;
}
Font_Quad :: struct { p0,p1,p2,p3: Vector2; u0,v0,u1,v1: float; glyph: *Glyph_Data; }
Dynamic_Font :: struct {
    name: string;
    face: FT_Face;
    glyph_lookup: Table(u64,*Glyph_Data);
    character_height: int;
    default_line_spacing: int;
    max_ascender: int;
    max_descender: int;
    typical_ascender: int;
    typical_descender: int;
    em_width: int;
    x_advance: int;
    y_offset_for_centering: int;
    glyph_conversion_failed: bool;
    glyph_index_for_unknown_character: u32;
    utf32_for_unknown_character := 0xfffd;
    // Fields of the original layout. This implementation has no OpenType feature substitution, so they stay empty.
    latin_font: *Dynamic_Font;
    character_range_low, character_range_high: int;
    y_offset_for_my_latin_characters: float;
    use_other_font_for_latin_always: bool;
    reversed: bool;
    features: [..] Font_Feature;
    feature_smallcaps, feature_ligatures, feature_lining_numbers: *Font_Feature;
    temporary_glyphs_byte_offsets: [..] int;
    temporary_glyphs_width_in_pixels: s64;
    temporary_glyphs: [..] *Glyph_Data;
    temporary_glyphs.allocator = temp;
    current_quads: [..] Font_Quad;
    loaded: *Loaded_Font;   // The file or memory this font was made from.
}
Loaded_Font :: struct { name: string; face: FT_Face; data: [] u8; }
Font_Range_Record :: struct { start, end: s32; start_coverage_index: s32; }
Font_Coverage_Table :: struct {
    format: s64;
    glyphs: [] u16;                        // format 1
    range_records: [] Font_Range_Record;   // format 2
}
Font_Sequence_Table_Entry :: struct { glyphs: [] u16; }
Font_Lookup_Subtable :: struct {
    format: s64;
    coverage_table: *Font_Coverage_Table;
    delta_glyph_id: s64;
    glyphs: [] u16;
    sequence_table: [] Font_Sequence_Table_Entry;
}
Font_Lookup_Table :: struct { lookup_type: s32; lookup_flags: u32; subtables: [] Font_Lookup_Subtable; }
Font_Feature :: struct {
    feature_tag: u32;
    feature_tables_pointer: *u8;
    expanded: bool;
    lookup_lists: [] u16;
    lookup_tables: [] Font_Lookup_Table;
}
Font_Page :: struct { texture: Texture; bitmap_data: *Bitmap; line_cursor_y: s16; lines: [..] *Font_Line; dirty := false; }
Font_Line :: struct { page: *Font_Page; bitmap_cursor_x: s16; bitmap_cursor_y: s16; height: int; }
Code_Line :: struct { line: string; start_offset: s32; tab_spaces: s32; tokens: [] u8; }
Offset_Range :: struct { start,end: s32; }
init_fonts :: (_page_size_x: s32 = -1, _page_size_y: s32 = -1) {
    assert(!fonts_initted, "Simp font library is already initialized");
    if fonts_initted return;
    if _page_size_x != -1 || _page_size_y != -1 {
        assert(_page_size_x >= 64 && _page_size_y >= 64 && _page_size_x <= 32767 && _page_size_y <= 32767);
        page_size_x=_page_size_x; page_size_y=_page_size_y;
    }
    error := FT.FT_Init_FreeType(*ft_library);
    assert(error == 0, "FreeType initialization failed: %", error);
    fonts_initted = error == 0;
}
ensure_fonts_are_initted :: () { if !fonts_initted init_fonts(); }
is_latin :: (utf32: u32) -> bool { return utf32 <= 0x24f || (utf32 >= 0x2000 && utf32 <= 0x218f); }
// Fonts are cached by name and pixel height; `path` and `name` are joined to find the file.
get_font_at_size :: (path: string, name: string, pixel_height: int) -> *Dynamic_Font {
    ensure_fonts_are_initted(); if !fonts_initted return null;
    for dynamic_fonts if it.character_height == pixel_height && it.name == name return it;
    result := load_font(path, name, pixel_height);
    if !result log_error("Unable to load font '%' from '%'. Returning null.\n", name, path);
    return result;
}
// The memory must stay alive as long as the font is used.
get_font_at_size :: (memory: [] u8, pixel_height: int) -> *Dynamic_Font {
    ensure_fonts_are_initted(); if !fonts_initted return null;
    loaded: *Loaded_Font;
    for loaded_memory_fonts if it.data.count == memory.count && it.data.data == memory.data { loaded = it; break; }
    if !loaded {
        loaded = make_loaded_font("", memory);
        if !loaded return null;
        array_add(*loaded_memory_fonts, loaded);
    }
    for dynamic_fonts if it.character_height == pixel_height && it.loaded == loaded return it;
    return create_dynamic_font(loaded, "", pixel_height);
}
load_font_part_2 :: (result: *Dynamic_Font, loaded_font: Loaded_Font, pixel_height: int) {
    assert(result != null && result.face != null && pixel_height > 0);
    if !result || !result.face || pixel_height <= 0 return;
    error := FT.FT_Set_Pixel_Sizes(result.face, 0, cast(u32) pixel_height);
    assert(error == 0, "FreeType pixel sizing failed: %", error);
    if error return;
    result.character_height = pixel_height;
    metrics := result.face.size.metrics;
    result.default_line_spacing = max(cast(int) (metrics.height >> 6), pixel_height);
    result.max_ascender = cast(int) (metrics.ascender >> 6); result.max_descender = cast(int) (-metrics.descender >> 6);
    result.typical_ascender = result.max_ascender; result.typical_descender = result.max_descender;
    result.em_width = pixel_height; result.x_advance = max(pixel_height / 2, 1);
    result.y_offset_for_centering = (result.max_ascender - result.max_descender) / 2;
    result.glyph_index_for_unknown_character = FT.FT_Get_Char_Index(result.face, 0xfffd);
    space := find_or_create_glyph(result, 32); if space result.x_advance = space.advance;
}
create_dynamic_font :: (loaded: *Loaded_Font, name: string, pixel_height: int) -> *Dynamic_Font {
    if !loaded || pixel_height <= 0 || pixel_height > 32767 return null;
    font := New(Dynamic_Font);
    error := FT.FT_New_Memory_Face(ft_library, loaded.data.data, cast(s32) loaded.data.count, 0, *font.face);
    if error { free(font); return null; }
    if FT.FT_Set_Pixel_Sizes(font.face, 0, cast(u32) pixel_height) { FT.FT_Done_Face(font.face); free(font); return null; }
    font.name = copy_string(name); font.loaded = loaded;
    record := New(Font_Record); record.font = font;
    array_add(*font_records, record); array_add(*dynamic_fonts, font);
    load_font_part_2(font, loaded.*, pixel_height);
    return font;
}
set_unknown_character :: (font: *Dynamic_Font, utf32: u32) -> bool {
    if !font || !font.face return false;
    index:=FT.FT_Get_Char_Index(font.face,utf32); if !index return false;
    font.glyph_index_for_unknown_character=index; return true;
}
convert_to_temporary_glyphs :: (font: *Dynamic_Font, s: string, effect_flags: Font_Effects = 0) -> width_in_pixels: s64 { return prepare_text(font,s,effect_flags); }
prepare_text :: (font: *Dynamic_Font, text: string, effect_flags: Font_Effects = 0) -> width: s64 {
    effects := effect_flags;
    if !font return 0;
    assert((effects & ~Font_Effects.NO_KERNING) == 0, "Legacy SMALLCAPS/LINING_FIGURES/LEFT_JUSTIFIED substitutions are not implemented");
    record:=font_record(font); if !record return 0;
    font.temporary_glyphs = .{}; font.temporary_glyphs.allocator = temp;
    record.starts.count=0; record.byte_offsets.count=0; record.lcd_keys.count=0;
    font.glyph_conversion_failed=false;
    pos:int; previous:u32; width:s64;
    while pos < text.count {
        offset:=pos; codepoint:=decode_utf8(text,*pos);
        if FT.FT_Get_Char_Index(font.face,codepoint)==0 font.glyph_conversion_failed=true;
        glyph:=find_or_create_glyph(font,codepoint);
        if !glyph { font.glyph_conversion_failed=true; continue; }
        if previous && !(effects & .NO_KERNING) && font.face.face_flags & FT.FT_FACE_FLAG_KERNING {
            delta:FT.FT_Vector;
            if FT.FT_Get_Kerning(font.face,previous,glyph.glyph_index_within_font,0,*delta) == 0 width+=delta.x>>6;
        }
        array_add(*record.starts,width); array_add(*record.byte_offsets,cast(s32)offset);
        array_add(*record.lcd_keys,font_anti_aliasing == .lcd);
        array_add(*font.temporary_glyphs,glyph);
        width+=glyph.advance; previous=glyph.glyph_index_within_font;
        if glyph.glyph_index_within_font == 0 font.glyph_conversion_failed=true;
    }
    record.width=width; record.text_bytes=cast(s32)text.count;
    return width;
}
get_text_width :: (font: *Dynamic_Font,s: string) -> width: s64 { return prepare_text(font,s); }
get_prepared_text_width :: (font: *Dynamic_Font) -> s64 { record:=font_record(font); if !record return 0; return record.width; }
get_cursor_pos_for_width :: (font: *Dynamic_Font,s: string,requested_width: s64) -> pos: s32 {
    prepare_text(font,s); record:=font_record(font); if !record return 0;
    for glyph,i:font.temporary_glyphs if requested_width < record.starts[i]+glyph.advance/2 return record.byte_offsets[i];
    return cast(s32)s.count;
}
generate_quads_for_prepared_text :: (font: *Dynamic_Font,x: s64,y: s64,effects: Font_Effects = 0) {
    if !font return;
    record:=font_record(font); if !record return;
    font.current_quads.count=0;
    left_handed := context.simp && context.simp.coordinate_system == .LEFT_HANDED;
    for glyph,i:font.temporary_glyphs {
        if !glyph.page || glyph.width == 0 || glyph.height == 0 continue;
        width:=cast(float)glyph.width; if record.lcd_keys[i] width/=3;
        x0:=cast(float)(x+record.starts[i]+glyph.offset_x); x1:=x0+width;
        page:=glyph.page.bitmap_data;
        // The page stores each glyph with its top row first. In the y-up system the quad's
        // lower edge carries the glyph's bottom rows; y-down is the other way round.
        top_v:=cast(float)glyph.y0/page.height; bottom_v:=(cast(float)glyph.y0+cast(float)glyph.height)/page.height;
        quad:Font_Quad; quad.glyph=glyph;
        quad.u0=cast(float)glyph.x0/page.width; quad.u1=(cast(float)glyph.x0+width)/page.width;
        if left_handed {
            y0:=cast(float)(y-glyph.ascent); y1:=y0+cast(float)glyph.height;
            quad.p0=.{x0,y0}; quad.p1=.{x1,y0}; quad.p2=.{x1,y1}; quad.p3=.{x0,y1};
            quad.v0=top_v; quad.v1=bottom_v;
        } else {
            y1:=cast(float)(y+glyph.ascent); y0:=y1-cast(float)glyph.height;
            quad.p0=.{x0,y0}; quad.p1=.{x1,y0}; quad.p2=.{x1,y1}; quad.p3=.{x0,y1};
            quad.v0=bottom_v; quad.v1=top_v;
        }
        array_add(*font.current_quads,quad);
    }
}
draw_generated_quads :: (font: *Dynamic_Font,color: u8) {
    if color >= COLOR_MAP.count return; draw_generated_quads(font,COLOR_MAP[color]);
}
draw_generated_quads :: (font: *Dynamic_Font,color := Vector4.{1,1,1,1}) {
    if !font return;
    CheckInit();
    if context.simp.current_shader immediate_flush();
    set_shader_for_text();
    immediate_begin();
    for quad:font.current_quads {
        page:=quad.glyph.page;
        if page.bitmap_data.width <= 1 || page.bitmap_data.height <= 1 continue;
        if page.dirty {
            page.texture.nearest = true;  // Glyph pixels map one to one onto screen pixels; do not blur them.
            if !texture_load_from_bitmap(*page.texture,page.bitmap_data) return;
            page.dirty=false;
        }
        immediate_set_texture(*page.texture); immediate_letter_quad(quad,color);
    }
    immediate_flush();
}
draw_text_with_highlights :: (font: *Dynamic_Font,x: s64,y: s64,text: string,highlights: [] bool,color: u8,highlight_color: u8) -> width: s64 {
    if color >= COLOR_MAP.count || highlight_color >= COLOR_MAP.count return 0;
    width:=prepare_text(font,text); generate_quads_for_prepared_text(font,x,y);
    set_shader_for_text();
    for quad,i:font.current_quads {
        page:=quad.glyph.page;
        if page.dirty { if !texture_load_from_bitmap(*page.texture,page.bitmap_data) return width; page.dirty=false; }
        immediate_set_texture(*page.texture);
        index:=color; if i < highlights.count && highlights[i] index=highlight_color;
        immediate_letter_quad(quad,COLOR_MAP[index]);
    }
    immediate_flush(); return width;
}
draw_code :: (font: *Dynamic_Font,x: s64,y: s64,char_x_advance: float,line_height: float,visible_lines: [] Code_Line,selections: [] Offset_Range = .[],tab_size: s64 = 4,start_col := 0,$is_colored := true) {
    if !font return;
    tab_size=max(tab_size,1);
    for line,row:visible_lines {
        cursor:=start_col+line.tab_spaces; pos:int;
        while pos < line.line.count {
            offset:=pos; codepoint:=decode_utf8(line.line,*pos);
            if codepoint == 9 { cursor += tab_size-cursor%tab_size; continue; }
            fragment:=string.{pos-offset,line.line.data+offset};
            color:u8=0;
            #if is_colored { if offset < line.tokens.count color=line.tokens[offset]; }
            selected:=false; for range:selections if line.start_offset+offset >= range.start && line.start_offset+offset <= range.end selected=true;
            if selected && COLOR_MAP.count > 1 {
                set_shader_for_color(true);
                immediate_quad(cast(float)x+cursor*char_x_advance,cast(float)y-row*line_height-font.max_descender,
                    cast(float)x+(cursor+1)*char_x_advance,cast(float)y-row*line_height+font.max_ascender,COLOR_MAP[1]);
            }
            draw_text(font,cast(s64)(x+cursor*char_x_advance),cast(s64)(y-row*line_height),fragment,color);
            cursor+=1;
        }
    }
}
// Explicit lifecycle addition; font data and glyph pointers live until this call.
deinit :: (font: *Dynamic_Font) {
    record:=font_record(font); if !record return;
    for glyph:font.glyph_lookup.values free(glyph);
    deinit(*font.glyph_lookup); array_reset(*font.current_quads);
    // temporary_glyphs uses temp storage, which is released by its allocator.
    font.temporary_glyphs = .{};
    if font.face FT.FT_Done_Face(font.face);
    free(font.name.data);
    for dynamic_fonts if it == font { array_unordered_remove_by_index(*dynamic_fonts, it_index); break; }
    array_reset(*record.starts); array_reset(*record.byte_offsets); array_reset(*record.lcd_keys);
    record.font=null; font.*=.{};
}
deinit_fonts :: () {
    immediate_flush();
    for record:font_records {
        if record.font { font:=record.font; deinit(font); free(font); }
        free(record);
    }
    array_reset(*font_records); array_reset(*dynamic_fonts);
    for loaded:loaded_file_fonts { FT.FT_Done_Face(loaded.face); free(loaded.data.data); destroy(loaded); free(loaded); }
    for loaded:loaded_memory_fonts { FT.FT_Done_Face(loaded.face); destroy(loaded); free(loaded); }
    array_reset(*loaded_file_fonts); array_reset(*loaded_memory_fonts);
    for page:font_pages {
        deinit(*page.texture); deinit(page.bitmap_data); free(page.bitmap_data);
        for line:page.lines free(line);
        array_reset(*page.lines); free(page);
    }
    array_reset(*font_pages);
    if ft_library FT.FT_Done_FreeType(ft_library);
    ft_library=null; fonts_initted=false;
}

glyph_id_to_hash_key :: (x: u32) -> int { return -cast(int) x; }
isdigit :: (utf32: u32) -> bool { return utf32 >= #char "0" && utf32 <= #char "9"; }

// True if the `length` bytes at `source` form one well-formed UTF-8 sequence.
isLegalUTF8 :: (source: *u8, length: s64) -> bool {
    if length < 1 || length > 4 return false;
    first := source[0];
    expected: s64;
    if first < 0x80 expected = 1;
    else if first >= 0xc2 && first <= 0xdf expected = 2;
    else if first >= 0xe0 && first <= 0xef expected = 3;
    else if first >= 0xf0 && first <= 0xf4 expected = 4;
    else return false;
    if expected != length return false;
    for 1..length-1 if (source[it] & 0xc0) != 0x80 return false;
    if first == 0xe0 && source[1] < 0xa0 return false;   // overlong
    if first == 0xed && source[1] > 0x9f return false;   // surrogates
    if first == 0xf0 && source[1] < 0x90 return false;   // overlong
    if first == 0xf4 && source[1] > 0x8f return false;   // above U+10FFFF
    return true;
}

loaded_file_fonts: [..] *Loaded_Font;

find_loaded_font :: (filename: string) -> *Loaded_Font {
    for loaded_file_fonts if it.name == filename return it;
    return null;
}

make_loaded_font :: (name: string, data: [] u8) -> *Loaded_Font {
    ensure_fonts_are_initted();
    face: FT_Face;
    error := FT.FT_New_Memory_Face(ft_library, data.data, cast(s32) data.count, 0, *face);
    assert(error == 0, "FreeType could not open the font '%' (error %)", name, error);
    if error return null;

    loaded := New(Loaded_Font);
    loaded.name = copy_string(name);
    loaded.face = face;
    loaded.data = data;
    return loaded;
}

// Reads the file and remembers it, so find_loaded_font(filename) finds it afterwards.
make_loaded_font :: (filename: string) -> (font: *Loaded_Font) {
    contents, success := File.read_entire_file(filename);
    if !success return null;

    loaded := make_loaded_font(filename, cast([] u8) contents);
    if loaded array_add(*loaded_file_fonts, loaded);
    return loaded;
}

destroy :: (font: *Loaded_Font) { free(font.name.data); }

get_glyph_width_in_pixels :: (glyph: *Glyph_Data) -> s64 {
    if !glyph return 0;
    return glyph.advance;
}

// `utf8` points at the first byte of one character.
get_character_width_in_pixels :: (font: *Dynamic_Font, utf8: *u8, effect_flags: Font_Effects) -> u32 {
    lead := utf8[0];
    length := 1;
    if lead >= 0xf0 length = 4; else if lead >= 0xe0 length = 3; else if lead >= 0xc0 length = 2;
    pos: int;
    glyph := find_or_create_glyph(font, decode_utf8(string.{length, utf8}, *pos));
    if !glyph return 0;
    return cast(u32) glyph.advance;
}

accumulate_glyphs_from_font :: (source: *Dynamic_Font, dest: *Dynamic_Font) {
    for source.temporary_glyphs {
        array_add(*dest.temporary_glyphs, it);
        array_add(*dest.temporary_glyphs_byte_offsets, -1);
    }
}

// Loads `<path>/<basename>` at the given pixel height, as a new font (get_font_at_size caches).
load_font :: (path: string, basename: string, pixel_height: int) -> font: *Dynamic_Font {
    ensure_fonts_are_initted();
    font_name := tprint("%/%", path, basename);

    loaded := find_loaded_font(font_name);
    if !loaded loaded = make_loaded_font(font_name);
    if !loaded return null;

    return create_dynamic_font(loaded, basename, pixel_height);
}

release_font :: (font: *Dynamic_Font) {}  // Fonts are cached for the program's lifetime; see deinit_fonts().

get_baseline_height :: (font: *Dynamic_Font) -> s64 { return font.character_height / 4; }

#scope_module
Font_Record :: struct { font:*Dynamic_Font; starts:[..]s64; byte_offsets:[..]s32; lcd_keys:[..]bool; width:s64; text_bytes:s32; }
font_records:[..]*Font_Record;
dynamic_fonts:[..]*Dynamic_Font;
loaded_memory_fonts:[..]*Loaded_Font;
font_pages:[..]*Font_Page;
fonts_initted:=false;
ft_library:FT.FT_Library;
page_size_x:s32=2048; page_size_y:s32=1024;
font_record :: (font:*Dynamic_Font)->*Font_Record { for record:font_records if record.font==font return record; return null; }
glyph_hash :: (utf32:u32,anti_aliasing:Font_Anti_Aliasing,hinting:bool)->u64 { return cast(u64)utf32 | (cast(u64)anti_aliasing<<32) | (cast(u64)hinting<<40); }
find_or_create_glyph :: (font:*Dynamic_Font,utf32:u32)->*Glyph_Data {
    key:=glyph_hash(utf32,font_anti_aliasing,font_hinting)^(cast(u64)font.glyph_index_for_unknown_character<<41);
    pointer:=table_find_pointer(*font.glyph_lookup,key); if pointer return pointer.*;
    index:=FT.FT_Get_Char_Index(font.face,utf32);
    if index==0 index=font.glyph_index_for_unknown_character;
    flags:s32=0; if !font_hinting flags|=FT.FT_LOAD_NO_HINTING;
    if FT.FT_Load_Glyph(font.face,index,flags) return null;
    mode:=FT.FT_Render_Mode.NORMAL; if font_anti_aliasing==.lcd mode=.LCD;
    if FT.FT_Render_Glyph(font.face.glyph,mode) return null;
    slot:=font.face.glyph; bitmap:=slot.bitmap;
    if bitmap.pixel_mode!=cast(u8)FT.FT_Pixel_Mode.GRAY && bitmap.pixel_mode!=cast(u8)FT.FT_Pixel_Mode.LCD && bitmap.width>0 return null;
    glyph:=New(Glyph_Data);
    glyph.utf32=utf32; glyph.glyph_index_within_font=index; glyph.width=bitmap.width; glyph.height=bitmap.rows;
    glyph.offset_x=cast(s16)slot.bitmap_left; glyph.ascent=cast(s16)slot.bitmap_top; glyph.offset_y=cast(s16)(slot.bitmap_top-cast(s32)bitmap.rows);
    glyph.advance=cast(s16)((slot.advance.x+32)>>6);
    if bitmap.width>0 && bitmap.rows>0 {
        width:=cast(int)bitmap.width; if mode==.LCD width/=3;
        line:=get_font_line(width,bitmap.rows); if !line { free(glyph); return null; }
        glyph.page=line.page; glyph.x0=line.bitmap_cursor_x; glyph.y0=line.bitmap_cursor_y;
        atlas:=line.page.bitmap_data;
        for y:0..cast(int)bitmap.rows-1 {
            source:=bitmap.buffer+y*bitmap.pitch;
            if bitmap.pitch<0 source=bitmap.buffer+(cast(int)bitmap.rows-1-y)*(-bitmap.pitch);
            dest:=atlas.data.data+(glyph.y0+y)*atlas.stride+glyph.x0*3;
            for x:0..width-1 {
                if mode==.LCD { dest[x*3]=source[x*3]; dest[x*3+1]=source[x*3+1]; dest[x*3+2]=source[x*3+2]; }
                else { dest[x*3]=source[x]; dest[x*3+1]=source[x]; dest[x*3+2]=source[x]; }
            }
        }
        line.bitmap_cursor_x+=cast(s16)(width+1); line.page.dirty=true;
    }
    table_add(*font.glyph_lookup,key,glyph); return glyph;
}
get_font_line :: (width:int,height:int)->*Font_Line {
    if width+2>page_size_x || height+2>page_size_y return null;
    for page:font_pages {
        for line:page.lines if line.height>=height+1 && line.bitmap_cursor_x+width+1<page_size_x return line;
        if page.line_cursor_y+height+2<page_size_y return new_font_line(page,height);
    }
    page:=New(Font_Page); page.bitmap_data=New(Bitmap);
    bitmap_alloc(page.bitmap_data,page_size_x,page_size_y,.RGB8);
    array_add(*font_pages,page); return new_font_line(page,height);
}
new_font_line :: (page:*Font_Page,height:int)->*Font_Line {
    line:=New(Font_Line); line.page=page; line.height=height+1;
    line.bitmap_cursor_x=1; line.bitmap_cursor_y=page.line_cursor_y+1;
    page.line_cursor_y+=cast(s16)(height+2); array_add(*page.lines,line); return line;
}
decode_utf8 :: (text:string,pos:*int)->u32 {
    first:=text[pos.*]; pos.*+=1;
    if first<128 return first;
    continuation:int; result:u32; minimum:u32;
    if first>=0xc2 && first<=0xdf { continuation=1; result=first&31; minimum=0x80; }
    else if first>=0xe0 && first<=0xef { continuation=2; result=first&15; minimum=0x800; }
    else if first>=0xf0 && first<=0xf4 { continuation=3; result=first&7; minimum=0x10000; }
    else return 0xfffd;
    for i:0..continuation-1 {
        if pos.*>=text.count || (text[pos.*]&0xc0)!=0x80 return 0xfffd;
        result=(result<<6)|(text[pos.*]&63); pos.*+=1;
    }
    if result<minimum || result>0x10ffff || (result>=0xd800 && result<=0xdfff) return 0xfffd;
    return result;
}
