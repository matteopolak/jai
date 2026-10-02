// Independently authored drawing implementation. No supplied implementation bodies.
#module_parameters (render_api := Render_API.OPENGL) {
    Render_API :: enum { NONE; SOFTWARE; OPENGL; METAL; }
};
#import "Basic";
#import "Math";
Strings :: #import "String";
#import "Hash_Table";
#import "Window_Type";
#scope_module
GLuint :: u32;
GLint :: s32;
#scope_export
#load "texture_format.jai";
#load "bitmap.jai";
#load "texture.jai";
#load "shader.jai";
#load "immediate.jai";
#load "font.jai";
#if render_api == .OPENGL { #load "backend/gl.jai"; }

Window_Info_Platform_Specific :: struct { user_data: *void; }
Window_Info :: struct {
    window: Window_Type;
    window_width, window_height: s32;
    backend_initted_for_this_window := false;
    specific: Window_Info_Platform_Specific;
}
window_infos: [..] Window_Info;
COLOR_MAP: [] Vector4;
Font_Anti_Aliasing :: enum u8 { normal; lcd; }
font_anti_aliasing: Font_Anti_Aliasing = .lcd;
font_hinting := true;
show_tab_characters_in_selection := true;

// Additional integration points: the host owns windows and native contexts.
window_dimension_query: (window: Window_Type) -> s32, s32 = null;
software_window_target: (window: Window_Type) -> *Bitmap = null;
window_present_sink: (window: Window_Type, vsync: bool) -> bool = null;
backend_init :: (info: *Window_Info) {
    assert(info!=null); if !info return;
    CheckInit(); backend_select_window(info);
    #if render_api==.SOFTWARE {
        info.backend_initted_for_this_window=context.simp.specific.software_target!=null;
    }
}
clear_render_target :: (r: float, g: float, b: float, a: float) {
    CheckInit(); immediate_flush();
    #if render_api==.OPENGL { gl_clear_target(r,g,b,a); }
    else #if render_api==.SOFTWARE {
        target:=context.simp.specific.software_target;
        assert(target!=null,"Select a render target before clearing"); if !target return;
        assert(target.format==.RGBA8||target.format==.BGRA8,"Software clears require RGBA8/BGRA8 targets");
        if target.format!=.RGBA8&&target.format!=.BGRA8 return;
        red:=cast(u8)clamp(floor(cast(float64)r*255+0.5),0.0,255.0);
        green:=cast(u8)clamp(floor(cast(float64)g*255+0.5),0.0,255.0);
        blue:=cast(u8)clamp(floor(cast(float64)b*255+0.5),0.0,255.0);
        alpha:=cast(u8)clamp(floor(cast(float64)a*255+0.5),0.0,255.0);
        for y:0..target.height-1 for x:0..target.width-1 {
            if context.simp.specific.scissor_enabled {
                bounds:=context.simp.specific.scissor;
                if x<bounds.x||x>=bounds.z||y<bounds.y||y>=bounds.w continue;
            }
            pixel:=target.data.data+(target.height-1-y)*target.stride+x*4;
            pixel[0]=ifx target.format==.BGRA8 then blue else red;
            pixel[1]=green; pixel[2]=ifx target.format==.BGRA8 then red else blue; pixel[3]=alpha;
        }
    } else { assert(false,"Selected Simp render API has no clearing backend"); }
}
swap_buffers :: (window: Window_Type, vsync := true) {
    immediate_flush();
    assert(window_present_sink!=null,"Install Simp.window_present_sink before presenting a window");
    if !window_present_sink return;
    assert(window_present_sink(window,vsync),"The host could not present the window");
}
get_render_dimensions :: (window: Window_Type) -> (width: s32, height: s32) {
    if window_dimension_query return window_dimension_query(window);
    info := find_window_info(window);
    if info return info.window_width, info.window_height;
    return 0, 0;
}
set_window_dimensions :: (window: Window_Type, width: s32, height: s32) {
    info, added := find_or_add_window_info(window);
    info.window_width = max(width, 0); info.window_height = max(height, 0);
    if context.simp && context.simp.current_window_info.window == window {
        immediate_flush(); context.simp.current_window_info = info.*;
        set_projection();
    }
}
set_render_target :: (window: Window_Type) {
    CheckInit(); immediate_flush();
    info, added := find_or_add_window_info(window);
    if window_dimension_query {
        info.window_width, info.window_height = window_dimension_query(window);
    }
    context.simp.current_window_info = info.*;
    context.simp.texture_render_target = null;
    context.simp.current_shader = null;
    backend_select_window(info);
}
set_render_target :: (texture: *Texture) {
    assert(texture != null && (texture.flags & .Render_Target) != 0, "Simp requires a render-target texture");
    if !texture || !(texture.flags & .Render_Target) return;
    CheckInit(); immediate_flush();
    context.simp.texture_render_target = texture;
    context.simp.current_shader = null;
    backend_select_texture(texture);
}
update_window :: (window: Window_Type) {
    if !window_dimension_query return;
    width, height := window_dimension_query(window);
    set_window_dimensions(window, width, height);
}
set_color_map :: (color_map: [] Vector4) { COLOR_MAP = color_map; }
set_anti_aliasing :: (value: Font_Anti_Aliasing) { font_anti_aliasing = value; }
set_hinting :: (value: bool) { font_hinting = value; }
set_show_tab_characters_in_selection :: (value: bool) { show_tab_characters_in_selection = value; }
set_scissor :: (x0: s32, y0: s32, x1: s32, y1: s32) {
    CheckInit(); immediate_flush();
    context.simp.specific.scissor_enabled = true;
    context.simp.specific.scissor = .{cast(float)x0, cast(float)y0, cast(float)x1, cast(float)y1};
    #if render_api == .OPENGL { gl_apply_scissor(); }
}
clear_scissor :: () {
    CheckInit(); immediate_flush(); context.simp.specific.scissor_enabled = false;
    #if render_api == .OPENGL { gl_apply_scissor(); }
}
draw_text :: (font: *Dynamic_Font, x: s64, y: s64, text: string, color: u8) -> width: s64 {
    width := prepare_text(font, text); draw_prepared_text(font, x, y, color); return width;
}
draw_prepared_text :: (font: *Dynamic_Font, x: s64, y: s64, color: u8) {
    assert(color < COLOR_MAP.count, "Simp color index is outside the installed map");
    if color >= COLOR_MAP.count return;
    generate_quads_for_prepared_text(font, x, y); draw_generated_quads(font, COLOR_MAP[color]);
}
// Explicit compatibility with the older GetRect draw protocol.
draw_prepared_text :: (font: *Dynamic_Font, x: s64, y: s64, color: Vector4, effects: Font_Effects = 0) {
    assert(effects == 0 || effects == .NO_KERNING, "Legacy font substitutions are not supported");
    generate_quads_for_prepared_text(font, x, y); draw_generated_quads(font, color);
}

#scope_module
find_window_info :: (window: Window_Type) -> *Window_Info {
    for *info: window_infos if info.window == window return info;
    return null;
}
find_or_add_window_info :: (window: Window_Type) -> *Window_Info, bool {
    info := find_window_info(window); if info return info, false;
    return array_add(*window_infos, .{window = window}), true;
}
backend_select_window :: (info: *Window_Info) {
    #if render_api == .OPENGL { gl_select_window(info); }
    else #if render_api == .SOFTWARE {
        assert(software_window_target != null, "Install Simp.software_window_target before drawing a window");
        if software_window_target context.simp.specific.software_target = software_window_target(info.window);
    } else { assert(false, "Selected Simp render API has no drawing backend"); }
}
backend_select_texture :: (texture: *Texture) {
    #if render_api == .OPENGL { gl_select_texture(texture); }
    else #if render_api == .SOFTWARE { context.simp.specific.software_target = texture_bitmap(texture); }
    else { assert(false, "Selected Simp render API has no drawing backend"); }
}
