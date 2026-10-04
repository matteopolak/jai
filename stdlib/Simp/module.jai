// Independently authored drawing implementation. No supplied implementation bodies.
#module_parameters (render_api := Render_API.OPENGL) {
    Render_API :: enum u32 { NONE; SOFTWARE; OPENGL; METAL; }
};
#import "Basic";
#import "Math";
Strings :: #import "String";
#import "Hash_Table";
#import "Window_Type";
#scope_module
GLuint :: u32;
GLint :: s32;
// Native window-system bindings are named, so they never leak into the importing program.
#if OS == .WINDOWS { Win :: #import "Windows"; }
else #if OS == .LINUX { X11 :: #import "X11"; }
else #if OS == .MACOS { ObjC :: #import "Objective_C"; AppKit :: #import "Objective_C/AppKit"; }
#scope_export
#load "texture_format.jai";
#load "bitmap.jai";
#load "texture.jai";
#load "readback.jai";
#load "shader.jai";
#load "immediate.jai";
#load "font.jai";
#if render_api == .OPENGL { #load "backend/gl.jai"; }

// Window_Info_Platform_Specific holds the per-window native state the backend needs
// (the device context on Windows, the GLX drawable on Linux). `user_data` is free for the host.
Window_Info_Platform_Specific :: struct {
    user_data: *void;
    #if render_api == .OPENGL {
        #if OS == .WINDOWS { hdc: Win.HDC; }
        #if OS == .LINUX { glx_window: X11.GLXWindow; }
    }
}
Window_Info :: struct {
    window: Window_Type;
    window_width, window_height: s32;
    wanted_msaa: s32;
    msaa: s32;
    backend_initted_for_this_window := false;
    specific: Window_Info_Platform_Specific;
}
window_infos: [..] Window_Info;
COLOR_MAP: [] Vector4;
Font_Anti_Aliasing :: enum u8 { normal; lcd; }
font_anti_aliasing: Font_Anti_Aliasing = .normal;
font_hinting := true;
show_tab_characters_in_selection := true;

// Integration points for hosts that own their windows or presentation (and for the CPU backend,
// which has no native window system): when installed they replace the native queries.
window_dimension_query: (window: Window_Type) -> s32, s32 = null;
software_window_target: (window: Window_Type) -> *Bitmap = null;
window_present_sink: (window: Window_Type, vsync: bool) -> bool = null;

// Optional call to override defaults before the first drawing: asks for a multisample count and
// creates the graphics context for the window now.
prepare_window :: (window: Window_Type, wanted_msaa: int) -> chosen_msaa: s32 {
    CheckInit();
    info, added := find_or_add_window_info(window);
    if added update_window(window);
    assert(!info.backend_initted_for_this_window, "prepare_window must come before the window is first used");
    info.wanted_msaa = cast(s32) wanted_msaa;
    backend_init(info);
    info.backend_initted_for_this_window = true;
    return info.msaa;
}
backend_init :: (info: *Window_Info) {
    assert(info != null); if !info return;
    CheckInit();
    #if render_api == .OPENGL { gl_backend_init(info); }
    else #if render_api == .SOFTWARE {
        backend_set_render_target(info);
        info.backend_initted_for_this_window = context.simp.specific.software_target != null;
    }
}
clear_render_target :: (r: float, g: float, b: float, a: float) {
    CheckInit(); immediate_flush();
    #if render_api == .OPENGL { gl_clear_target(r,g,b,a); }
    else #if render_api == .SOFTWARE {
        target := context.simp.specific.software_target;
        assert(target != null, "Select a render target before clearing"); if !target return;
        assert(target.format == .RGBA8 || target.format == .BGRA8, "Software clears require RGBA8/BGRA8 targets");
        if target.format != .RGBA8 && target.format != .BGRA8 return;
        red := cast(u8) clamp(floor(cast(float64) r*255+0.5), 0.0, 255.0);
        green := cast(u8) clamp(floor(cast(float64) g*255+0.5), 0.0, 255.0);
        blue := cast(u8) clamp(floor(cast(float64) b*255+0.5), 0.0, 255.0);
        alpha := cast(u8) clamp(floor(cast(float64) a*255+0.5), 0.0, 255.0);
        for y: 0..target.height-1 for x: 0..target.width-1 {
            if context.simp.specific.scissor_enabled {
                bounds := context.simp.specific.scissor;
                if x < bounds.x || x >= bounds.z || y < bounds.y || y >= bounds.w continue;
            }
            pixel := target.data.data + software_row(y, target.height) * target.stride + x*4;
            pixel[0] = ifx target.format == .BGRA8 then blue else red;
            pixel[1] = green; pixel[2] = ifx target.format == .BGRA8 then red else blue; pixel[3] = alpha;
        }
    } else { assert(false, "Selected Simp render API has no clearing backend"); }
}
swap_buffers :: (window: Window_Type, vsync := true) {
    CheckInit();
    if context.simp.current_shader immediate_flush();
    if window_present_sink {
        assert(window_present_sink(window, vsync), "The host could not present the window");
        return;
    }
    #if render_api == .OPENGL { gl_swap_buffers(window, vsync); }
    else { assert(false, "Install Simp.window_present_sink before presenting a window"); }
}
get_render_dimensions :: (window: Window_Type) -> (width: s32, height: s32) {
    if window_dimension_query return window_dimension_query(window);
    #if render_api == .OPENGL || render_api == .METAL {
        #if OS == .WINDOWS {
            rectangle: Win.RECT;
            if !Win.GetClientRect(window, *rectangle) return 0, 0;
            return rectangle.right - rectangle.left, rectangle.bottom - rectangle.top;
        } else #if OS == .LINUX {
            root: X11.Window; x, y: s32; width, height, border_width, depth: u32;
            X11.XGetGeometry(X11.x_global_display, window, *root, *x, *y, *width, *height, *border_width, *depth);
            return cast(s32) width, cast(s32) height;
        } else #if OS == .MACOS {
            // The backing store size is in real pixels even on high-density displays.
            view := AppKit.NSWindow.contentView(window);
            if !view return 0, 0;
            backing := AppKit.NSView.convertRectToBacking(view, AppKit.NSView.frame(view));
            return cast(s32) backing.size.width, cast(s32) backing.size.height;
        }
    }
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
// LEFT_HANDED (y down, origin at the top-left) will eventually become the default.
Simp_Coordinate_System :: enum u8 {
    LEFT_HANDED  :: 0;
    RIGHT_HANDED :: 1;
}
set_render_target :: (window: Window_Type, coords := Simp_Coordinate_System.RIGHT_HANDED) {
    CheckInit(); immediate_flush(); backend_flush();
    context.simp.current_shader = null;
    context.simp.texture_render_target = null;
    context.simp.coordinate_system = coords;
    info, added := find_or_add_window_info(window);
    if added update_window(window);
    else if window_dimension_query { info.window_width, info.window_height = window_dimension_query(window); }
    backend_set_render_target(info);
    context.simp.current_window_info = info.*;
}
set_render_target :: (texture: *Texture, coords := Simp_Coordinate_System.RIGHT_HANDED) {
    if !texture {
        log_error("Attempt to set_render_target on a null texture!\n");
        return;
    }
    assert((texture.flags & .Render_Target) != 0, "Simp requires a render-target texture");
    if !(texture.flags & .Render_Target) return;
    CheckInit(); immediate_flush(); backend_flush();
    context.simp.current_shader = null;
    context.simp.coordinate_system = coords;
    context.simp.texture_render_target = texture;
    backend_set_render_target(texture);
}
// Re-reads a window's size (call it when the window was resized); if it is the current target the
// viewport and projection follow.
update_window :: (window: Window_Type) {
    CheckInit();
    info := find_or_add_window_info(window);
    if !info return;
    window_width, window_height := get_render_dimensions(window);
    info.window_width = window_width;
    info.window_height = window_height;
    current := *context.simp.current_window_info;
    if current.window == window {
        if window_width != current.window_width || window_height != current.window_height {
            backend_resize_render_target(info.*);
            // A shader that is already set carries the old projection.
            if !context.simp.texture_render_target {
                if context.simp.current_shader immediate_set_2d_projection(window_width, window_height);
            }
        }
        context.simp.current_window_info = info.*;
    }
}
set_color_map :: (color_map: [] Vector4) { COLOR_MAP = color_map; }
set_anti_aliasing :: (value: Font_Anti_Aliasing) { font_anti_aliasing = value; }
set_hinting :: (value: bool) { font_hinting = value; }
set_show_tab_characters_in_selection :: (value: bool) { show_tab_characters_in_selection = value; }
// Coordinates follow the current coordinate system; an inverted rectangle selects nothing.
set_scissor :: (x0: s32, y0: s32, x1: s32, y1: s32) {
    CheckInit(); immediate_flush();
    context.simp.specific.scissor_enabled = true;
    context.simp.specific.scissor = .{cast(float) x0, cast(float) y0, cast(float) x1, cast(float) y1};
    #if render_api == .OPENGL { gl_apply_scissor(); }
}
set_scissor :: (p0: Vector2, p1: Vector2) { set_scissor(xx p0.x, xx p0.y, xx p1.x, xx p1.y); }
clear_scissor :: () {
    CheckInit(); immediate_flush(); context.simp.specific.scissor_enabled = false;
    #if render_api == .OPENGL { gl_apply_scissor(); }
}
draw_text :: (font: *Dynamic_Font, x: s64, y: s64, text: string, color := Vector4.{1,1,1,1}, effects: Font_Effects = 0) -> width: s64 {
    width := prepare_text(font, text, effects);
    generate_quads_for_prepared_text(font, x, y, effects);
    draw_generated_quads(font, color);
    return width;
}
draw_prepared_text :: (font: *Dynamic_Font, x: s64, y: s64, color := Vector4.{1,1,1,1}, effects: Font_Effects = 0) {
    generate_quads_for_prepared_text(font, x, y, effects);
    draw_generated_quads(font, color);
}
// Color-map variants: `color` indexes the table installed with set_color_map.
draw_text :: (font: *Dynamic_Font, x: s64, y: s64, text: string, color: u8) -> width: s64 {
    width := prepare_text(font, text); draw_prepared_text(font, x, y, color); return width;
}
draw_prepared_text :: (font: *Dynamic_Font, x: s64, y: s64, color: u8) {
    assert(color < COLOR_MAP.count, "Simp color index is outside the installed map");
    if color >= COLOR_MAP.count return;
    generate_quads_for_prepared_text(font, x, y, 0); draw_generated_quads(font, COLOR_MAP[color]);
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
// Row of a CPU render target for a draw coordinate `y`: the rows are stored top first, so the
// right-handed system (y up) counts from the bottom and the left-handed one from the top.
software_row :: (y: int, height: int) -> int {
    if context.simp && context.simp.coordinate_system == .LEFT_HANDED return y;
    return height - 1 - y;
}
backend_set_render_target :: (info: *Window_Info) {
    #if render_api == .OPENGL { gl_set_render_target(info); }
    else #if render_api == .SOFTWARE {
        assert(software_window_target != null, "Install Simp.software_window_target before drawing a window");
        if software_window_target context.simp.specific.software_target = software_window_target(info.window);
    } else { assert(false, "Selected Simp render API has no drawing backend"); }
}
backend_set_render_target :: (texture: *Texture) {
    #if render_api == .OPENGL { gl_set_render_target(texture); }
    else #if render_api == .SOFTWARE { context.simp.specific.software_target = texture_bitmap(texture); }
    else { assert(false, "Selected Simp render API has no drawing backend"); }
}
backend_flush :: () {
    #if render_api == .OPENGL { gl_flush(); }
}
backend_resize_render_target :: (info: Window_Info) {
    #if render_api == .OPENGL { gl_resize_render_target(info); }
}
