// Legacy public layouts are separated from authored UI behavior.
using Basic;

#scope_module
Input :: #import "Input";
WT :: #import "Window_Type";
Simp :: #import "Simp";
String :: #import "String";
Tables :: #import "Hash_Table";

using Input;
using Tables;

#scope_export
#if Type_Indicator == void {
    USE_SIMP :: true;
    Window_Type :: WT.Window_Type;
    Font :: Simp.Dynamic_Font;
    Font_Effects :: Simp.Font_Effects;
    Texture :: Simp.Texture;
} else {
    USE_SIMP :: false;
    Window_Type :: Type_Indicator.Window_Type;
    Font :: Type_Indicator.Font;
    Font_Effects :: Type_Indicator.Font_Effects;
    Texture :: Type_Indicator.Texture;
}

#load "legacy-layouts.jai";
#load "orientation.jai";

#if GETRECT_Y_UP {
    #load "assets.jai";
}

#load "regions.jai";
#load "colors.jai";
#load "text-interaction.jai";
#load "text-flow.jai";
#load "theme-presets.jai";
#load "compatibility.jai";
#load "occlusion.jai";
#load "cursors.jai";

#if GETRECT_Y_UP {
    #add_context getrect_current_window: Window_Type = WT.INVALID_WINDOW;
} else {
    #add_context getrect_current_window: Window_Type = cast(Window_Type) 0;
}

// Widget states, their text and every list below outlive a frame, so they come from the heap rather
// than the caller's context.allocator: a program may run with `context.allocator = temp` and reset
// temporary storage every frame.
GETRECT_HEAP :: Context_Base.default_allocator;
default_overall_theme: Overall_Theme;
draw_procs: Draw_Procs;
scissor_stack: [..] Rect = .{ allocator = GETRECT_HEAP };
this_frame_per_window_states: [..] Per_Window_State = .{ allocator = GETRECT_HEAP };
last_frame_per_window_states: [..] Per_Window_State = .{ allocator = GETRECT_HEAP };
mouse_x: s32;
mouse_y: s32;
mouse_x_float: float;
mouse_y_float: float;
mouse_delta_x_float: float;
mouse_delta_y_float: float;
mouse_button_left_state: Key_Current_State;
mouse_button_right_state: Key_Current_State;
shift_key_state: Key_Current_State;
current_time: float64;
last_current_time: float64;
current_dt: float;
current_getrect_frame: u64;
render_target_width: s32;
render_target_height: s32;
current_tooltip: Tooltip;
active_tooltip: Tooltip;
some_widget_received_left_mouse_button: bool;
active_widget: *Active_Widget;
active_widget_is_grabbing: bool;
state_stack: [..] *Active_Widget = .{ allocator = GETRECT_HEAP };
state_table: Table(u64, *Active_Widget) = .{ allocator = GETRECT_HEAP };
popups: [..] Popup_Info = .{ allocator = GETRECT_HEAP };
events_to_handle_this_frame: [..] Event = .{ allocator = GETRECT_HEAP };
default_font_data: string;

ui_init :: (default_font := "", procs: *Draw_Procs = null) {
    if procs draw_procs = procs.*;
    #if USE_SIMP {
        if !draw_procs.texture_load_from_memory draw_procs.texture_load_from_memory = Simp.texture_load_from_memory;
        if !draw_procs.set_scissor draw_procs.set_scissor = left_set_scissor;
        if !draw_procs.clear_scissor draw_procs.clear_scissor = Simp.clear_scissor;
        if !draw_procs.set_shader_for_color draw_procs.set_shader_for_color = left_shader_color;
        if !draw_procs.set_shader_for_images draw_procs.set_shader_for_images = Simp.set_shader_for_images;
        if !draw_procs.prepare_text draw_procs.prepare_text = left_prepare_text;
        if !draw_procs.draw_prepared_text draw_procs.draw_prepared_text = left_draw_text;
        if !draw_procs.get_mouse_pointer_position draw_procs.get_mouse_pointer_position = left_get_pointer;
        if !draw_procs.get_font_at_size draw_procs.get_font_at_size = left_get_font;
        if !draw_procs.immediate_triangle draw_procs.immediate_triangle = left_triangle;
        if !draw_procs.immediate_quad draw_procs.immediate_quad = left_quad;
        if !draw_procs.immediate_flush draw_procs.immediate_flush = Simp.immediate_flush;
        if !draw_procs.set_pointer_image draw_procs.set_pointer_image = getrect_set_pointer_image;
    }
    assert(draw_procs.set_scissor && draw_procs.clear_scissor && draw_procs.set_shader_for_color && draw_procs.immediate_quad && draw_procs.immediate_flush, "GetRect drawing callbacks are required");
    #if GETRECT_Y_UP {
        if default_font.count > 0 default_font_data = default_font;
        else {
            memory, loaded := right_cached_asset(4);
            assert(loaded && memory.count > 0, "Default font resource is required");
            if !loaded || memory.count == 0 return;
            default_font_data = memory;
        }
    } else {
        default_font_data = default_font;
    }
    initialized = true;
}

set_default_theme :: (theme: Overall_Theme) {
    default_overall_theme = theme;
}

// A size set here stays fixed; sizes never set follow the render target (see switch_window).
set_global_rounding_radius_in_pixels :: (value: float) {
    pin_size(*global_rounding_radius_in_pixels, .ROUNDING_RADIUS, value);
}

set_global_frame_thickness_in_pixels :: (value: float) {
    pin_size(*global_frame_thickness_in_pixels, .FRAME_THICKNESS, value);
}

set_global_divider_thickness_in_pixels :: (value: float) {
    pin_size(*global_divider_thickness_in_pixels, .DIVIDER_THICKNESS, value);
}

set_global_initial_divider_position_in_pixels :: (value: float) {
    pin_size(*global_initial_divider_position_in_pixels, .DIVIDER_POSITION, value);
}

set_global_slider_nub_thickness_in_pixels :: (value: float) {
    pin_size(*global_slider_nub_thickness_in_pixels, .SLIDER_NUB, value);
}

get_float_parameter :: (r: Rect, type: Size_Computation, local: float, global: float, override: float = FLOAT32_INFINITY) -> float {
    if override != FLOAT32_INFINITY return override;
    if type == .RELATIVE_TO_HEIGHT return r.h * local;
    if type == .RELATIVE_TO_WIDTH return r.w * local;
    if type == .ABSOLUTE_FROM_THEME_FIELD return local;
    return global;
}

tooltip :: (text := "", pointer_data: *void = null, int_data := 0) {
    current_tooltip = .{ text, pointer_data, int_data };
}

get_active_tooltip :: () -> Tooltip {
    return active_tooltip;
}

ui_get_button_state :: (key: Key_Code) -> Key_Current_State {
    return input_button_states[key];
}

windows_per_frame_update :: () {
    Swap(*last_frame_per_window_states, *this_frame_per_window_states);
    this_frame_per_window_states.count = 0;
}

ui_per_frame_update :: (window: Window_Type, _render_target_width: s32, _render_target_height: s32, _current_time: float64) -> (background_occluded: bool, is_active: bool) {
    if !initialized ui_init();
    assert(state_stack.count == 0 && scissor_stack.count == 0, "Finish all widgets and scissors before beginning a frame");
    if active_widget && active_widget.last_getrect_frame + 1 < current_getrect_frame active_widget_deactivate_all();
    last_current_time = current_time;
    current_time = _current_time;
    current_dt = cast(float) max(current_time - last_current_time, 0.0);
    if current_getrect_frame == 0 current_dt = 0;
    current_getrect_frame += 1;
    active_tooltip = .{};
    current_tooltip = .{};
    some_widget_received_left_mouse_button = false;
    context.getrect_current_window = window;
    windows_per_frame_update();
    popups_per_frame_update();
    occlusion_per_frame_update();
    events_per_frame_update();
    mouse_button_left_state, mouse_button_right_state, shift_key_state = sample_tracked_keys();
    return switch_window(window, _render_target_width, _render_target_height);
}

switch_window :: (window: Window_Type, _render_target_width: s32, _render_target_height: s32) -> (background_occluded: bool, is_active: bool) {
    render_target_height = max(_render_target_height, 1);
    render_target_width = max(_render_target_width, 1);
    context.getrect_current_window = window;
    size_unpinned_metrics(cast(float) render_target_width, cast(float) render_target_height);
    if draw_procs.get_mouse_pointer_position track_platform_mouse(window);
    if left_scoped_input {
        buttons := left_buttons(window);
        mouse_button_left_state = buttons.left;
        mouse_button_right_state = buttons.right;
        shift_key_state = buttons.shift;
    }
    occlusion_per_window_update(window);
    events_per_window_update(window);
    return active_widget_is_grabbing, active_widget != null;
}

getrect_handle_event :: (event: Event) {
    getrect_handle_event(event, context.getrect_current_window);
}

getrect_handle_event :: (event: Event, window: Window_Type) {
    array_add(*events_to_handle_this_frame, event);
    array_add(*left_event_windows, window);
    if left_scoped_input && event.type == .KEYBOARD {
        buttons := left_buttons(window);
        if event.key_code == .MOUSE_BUTTON_LEFT left_update_key(*buttons.left, event);
        if event.key_code == .MOUSE_BUTTON_RIGHT left_update_key(*buttons.right, event);
        if event.key_code == .SHIFT left_update_key(*buttons.shift, event);
    }
}

events_per_frame_update :: () {
    events_to_handle_this_frame.count = 0;
    left_event_windows.count = 0;
    for *buttons: left_window_buttons {
        buttons.left &= .DOWN;
        buttons.right &= .DOWN;
        buttons.shift &= .DOWN;
    }
    if Input.routed_events_this_frame.count > 0 left_scoped_input = true;
    if left_scoped_input {
        for routed: Input.routed_events_this_frame getrect_handle_event(routed.event, cast(Window_Type) routed.window);
        for event: Input.unrouted_events_this_frame getrect_handle_event(event);
    } else for event: events_this_frame getrect_handle_event(event);
}

events_per_window_update :: (window: Window_Type) {
    if !active_widget || active_widget.window != window || !active_widget.serial_events_proc return;
    filtered: [..] Event;
    for event, index: events_to_handle_this_frame if left_event_window(index) == window array_add(*filtered, event);
    active_widget.serial_events_proc(active_widget, filtered);
    array_reset(*filtered);
}

find_or_create_state :: ($T: Type, hash: u64, start_using := true) -> (*T, created: bool) {
    if state_stack.count > 0 hash = combine_hashes(hash, cast, no_check(u64) state_stack[state_stack.count - 1]);
    for widget, key: state_table {
        if key == hash && widget.widget_type == T {
            if start_using start_using_state(widget);
            return cast(*T) widget, false;
        }
    }
    result := New(T, allocator = GETRECT_HEAP);
    result.widget_type = T;
    Tables.table_add(*state_table, hash, cast(*Active_Widget) result);
    if start_using start_using_state(cast(*Active_Widget) result);
    return result, true;
}

start_using_state :: (widget: *Active_Widget) {
    assert(!widget.is_on_state_stack, "A widget state is already on the draw stack");
    widget.window = context.getrect_current_window;
    widget.exists_on_occluder = occluder_being_drawn;
    if !occluder_being_drawn && state_stack.count > 0 {
        parent := state_stack[state_stack.count - 1];
        widget.exists_on_occluder = ifx parent.widget_type == Subwindow_State then parent else parent.exists_on_occluder;
    }
    widget.cosmetic_dt = cast(float) max(current_time - widget.last_update_time, 0.0);
    if widget.last_getrect_frame == 0 widget.cosmetic_dt = 0;
    widget.last_update_time = current_time;
    widget.last_getrect_frame = current_getrect_frame;
    widget.is_on_state_stack = true;
    array_add(*state_stack, widget);
}

stop_using_state :: (widget: *Active_Widget) {
    assert(state_stack.count > 0 && state_stack[state_stack.count - 1] == widget, "GetRect widget stack must unwind in order");
    if state_stack.count > 0 state_stack.count -= 1;
    widget.is_on_state_stack = false;
}

active_widget_add :: (widget: *Active_Widget, is_grabbing := false) {
    if active_widget != widget active_widget_deactivate_all(widget);
    active_widget = widget;
    active_widget_is_grabbing = is_grabbing;
}

deactivate :: (widget: *Active_Widget) {
    if widget && widget.deactivate_proc widget.deactivate_proc(widget);
}

active_widget_remove :: (widget: *Active_Widget) {
    if active_widget == widget {
        deactivate(widget);
        active_widget = null;
        active_widget_is_grabbing = false;
    }
}

active_widget_deactivate_all :: (except: *Active_Widget = null) {
    if active_widget && active_widget != except && !active_widget.is_on_state_stack {
        deactivate(active_widget);
        active_widget = null;
        active_widget_is_grabbing = false;
    }
}

active_widgets_per_frame_update :: () {
    if active_widget && active_widget.last_getrect_frame + 1 < current_getrect_frame active_widget_deactivate_all();
}

get_status_flags :: (r: Rect, widget_if_querying_outside_of_render_time: *Active_Widget = null, ignore := Status_Flags_Ignore.NOTHING) -> Status_Flags {
    status: Status_Flags;
    if events_occluded(widget_if_querying_outside_of_render_time) return status;
    occluder := left_subwindow_hit(context.getrect_current_window, mouse_x_float, mouse_y_float);
    query := widget_if_querying_outside_of_render_time;
    if !query && state_stack.count > 0 query = state_stack[state_stack.count - 1];
    if occluder && query != occluder && (!query || query.exists_on_occluder != occluder) return status;
    if !(ignore & .SCISSOR) && !is_visible_in_scissor(mouse_x_float, mouse_y_float) return status;
    if active_widget_is_grabbing && active_widget != widget_if_querying_outside_of_render_time {
        own := false;
        for widget: state_stack if widget == active_widget own = true;
        if !own return status;
    }
    if is_inside(mouse_x_float, mouse_y_float, r) {
        status |= .OVER;
        if !(ignore & .TOOLTIP) active_tooltip = current_tooltip;
        if !(ignore & .LEFT_CLICK) && mouse_button_left_state & .START && !some_widget_received_left_mouse_button {
            status |= .PRESSED;
            some_widget_received_left_mouse_button = true;
        }
    }
    if !(ignore & .TOOLTIP) current_tooltip = .{};
    return status;
}

has_focus :: (rect: Rect) -> bool {
    r := rect;
    return (get_status_flags(r, ignore = .LEFT_CLICK | .TOOLTIP) & .OVER) != 0;
}

push_scissor :: (_rect: Rect) {
    r := _rect;
    clipped := r;
    if scissor_stack.count > 0 clipped = intersect(r, scissor_stack[scissor_stack.count - 1]);
    array_add(*scissor_stack, clipped);
    draw_procs.set_scissor(cast(s32) floor(clipped.x), cast(s32) floor(clipped.y), cast(s32) ceil(clipped.x + clipped.w), cast(s32) ceil(clipped.y + clipped.h));
}

pop_scissor :: () {
    assert(scissor_stack.count > 0, "GetRect scissor stack is empty");
    if scissor_stack.count == 0 return;
    scissor_stack.count -= 1;
    if scissor_stack.count == 0 draw_procs.clear_scissor();
    else {
        r := scissor_stack[scissor_stack.count - 1];
        draw_procs.set_scissor(cast(s32) r.x, cast(s32) r.y, cast(s32) (r.x + r.w), cast(s32) (r.y + r.h));
    }
}

is_visible_in_scissor :: (x: float, y: float) -> bool {
    if scissor_stack.count == 0 return true;
    return is_inside(x, y, scissor_stack[scissor_stack.count - 1]);
}

is_visible_in_scissor :: (using rect: Rect) -> bool {
    r := rect;
    if scissor_stack.count == 0 return true;
    overlap := intersect(r, scissor_stack[scissor_stack.count - 1]);
    return overlap.w > 0 && overlap.h > 0;
}

get_default_font_at_size :: (fsize: float) -> *Font {
    if default_overall_theme.font return default_overall_theme.font;
    if !default_font_data || !draw_procs.get_font_at_size return null;
    return draw_procs.get_font_at_size(cast([] u8) default_font_data, max(cast(int) floor(fsize + 0.5), 1));
}

em :: (x: float, font: *Font) -> float {
    if !font return 0;
    return x * font.em_width;
}

text_size :: (font: *Font, text: string) -> (width: float, height: float) {
    if !font return 0, 0;
    return cast(float) draw_procs.prepare_text(font, text, 0), cast(float) (font.max_ascender + font.max_descender);
}

text_origin :: (theme: *Label_Theme, font: *Font, r: Rect, text_width: float) -> (x: float, y: float) {
    x := r.x + em(theme.alignment_pad_ems, font);
    if theme.alignment == .Center x = r.x + (r.w - text_width) * 0.5;
    if theme.alignment == .Right x = r.x + r.w - text_width - em(theme.alignment_pad_ems, font);
    position := theme.text_baseline_vertical_position;
    if position == FLOAT32_INFINITY position = default_text_baseline(font, r.h);
    else position *= r.h;
    return floor(x + 0.5), floor(r.y + position + 0.5);
}

default_text_baseline :: (font: *Font, height: float) -> float {
    if !font return 0;
    return (height - font.max_ascender - font.max_descender) * 0.5 + ifx GETRECT_Y_UP then font.max_descender else font.max_ascender;
}

label :: (r: Rect, text: string, theme: *Label_Theme, do_scissor := true) -> desired_width: float {
    if !theme theme = *default_overall_theme.label_theme;
    font := theme.font;
    if !font font = get_default_font_at_size(r.h * 0.65);
    if !font || !draw_procs.prepare_text || !draw_procs.draw_prepared_text return 0;
    width := cast(float) draw_procs.prepare_text(font, text, theme.effects);
    if do_scissor push_scissor(r);
    defer if do_scissor pop_scissor();
    x, y := text_origin(theme, font, r, width);
    draw_procs.draw_prepared_text(font, cast(s64) x, cast(s64) y, theme.text_color, theme.effects);
    return width;
}

label_from_prepared_text :: (r: Rect, font: *Font, theme: *Label_Theme, do_scissor := true) {
    if !font return;
    #if USE_SIMP {
        width := cast(float) Simp.get_prepared_text_width(font);
        x, y := text_origin(theme, font, r, width);
        if do_scissor push_scissor(r);
        defer if do_scissor pop_scissor();
        draw_procs.draw_prepared_text(font, cast(s64) x, cast(s64) y, theme.text_color, theme.effects);
    } else {
        assert(false, "Custom fonts must implement their own prepared-label measurement");
    }
}

rounded_rectangle :: (r: Rect, shape: Rectangle_Shape, color: Vector4, frame_color: Vector4, frame_thickness_override := FLOAT32_INFINITY) -> (frame_pixels: float, actual_roundedness: float) {
    radius := clamp(get_float_parameter(r, shape.roundedness_type, shape.roundedness, global_rounding_radius_in_pixels), 0.0, min(r.w, r.h) * 0.5);
    thickness := clamp(get_float_parameter(r, shape.frame_thickness_type, shape.frame_thickness, global_frame_thickness_in_pixels, frame_thickness_override), 0.0, min(r.w, r.h) * 0.5);
    draw_procs.set_shader_for_color(true);
    if frame_color.w > 0 && thickness > 0 left_round_fill(r, shape, radius, frame_color);
    inner := r;
    if frame_color.w > 0 {
        inner = shrink(r, thickness);
    }
    if color.w > 0 left_round_fill(inner, shape, max(radius - thickness, 0.0), color);
    return thickness, radius;
}

update_over_state :: (state: *Button_State, theme: *Button_Theme, status: Status_Flags, dt: float) {
    over := ifx status & .OVER then 1.0 else 0.0;
    down := ifx status & .DOWN then 1.0 else 0.0;
    state.over_effect_t = move_toward(state.over_effect_t, over, dt * (ifx over > 0 then theme.over_fade_in_speed else theme.over_fade_out_speed));
    state.down_effect_t = move_toward(state.down_effect_t, down, dt * (ifx down > 0 then theme.down_fade_in_speed else theme.down_fade_out_speed));
    if over > 0 state.over_duration += dt;
    else state.over_duration = 0;
    if down > 0 state.down_duration += dt;
    else state.down_duration = 0;
}

update_action_durations :: (state: *Button_State, theme: *Button_Theme, begin: bool, dt: float) -> (pressed_flash_factor: float) {
    if begin {
        state.action_duration = 0;
        state.action_duration_2 = 0;
    }
    if state.action_duration_2 >= 0 state.action_duration_2 += dt;
    if state.action_duration < 0 return 0;
    state.action_duration += dt;
    factor := 1 - state.action_duration / max(theme.press_duration, 0.001);
    if factor <= 0 {
        state.action_duration = -1;
        return 0;
    }
    return factor * factor;
}

update_production_value_button :: (r: Rect, changed: bool, state: *Button_State, status: Status_Flags, theme: *Button_Theme) {
    update_over_state(state, theme, status, current_dt);
    state.over_factor = state.over_effect_t;
    state.pressed_factor = update_action_durations(state, theme, changed, current_dt);
}

get_colors_and_thickness_for_button :: (theme: *Button_Theme, state: *Button_State) -> (surface_color: Vector4, frame_color: Vector4, frame_thickness: float) {
    surface_color = lerp(lerp(lerp(theme.surface_color, theme.surface_color_over, state.over_factor), theme.surface_color_down, state.down_effect_t), theme.surface_color_flash, state.pressed_factor);
    frame_color = lerp(lerp(lerp(theme.frame_color, theme.frame_color_over, state.over_factor), theme.frame_color_down, state.down_effect_t), theme.frame_color_flash, state.pressed_factor);
    frame_thickness = FLOAT32_INFINITY;
    if theme.enable_variable_frame_thickness frame_thickness = lerp(lerp(lerp(theme.rectangle_shape.frame_thickness, theme.frame_thickness_over, state.over_factor), theme.frame_thickness_down, state.down_effect_t), theme.frame_thickness_flash, state.pressed_factor);
}

core_draw_button :: (r: Rect, text: string, state: *Button_State, status: Status_Flags, theme: *Button_Theme, texture: *Texture) {
    update_production_value_button(r, (status & .PRESSED) != 0, state, status, theme);
    if theme.properties & .DO_NOT_DRAW || !is_visible_in_scissor(r) return;
    surface, frame, thickness := get_colors_and_thickness_for_button(theme, state);
    state.frame_pixels = rounded_rectangle(r, theme.rectangle_shape, surface, frame, thickness);
    if text.count > 0 core_draw_button_label(r, text, state, theme);
    if texture && draw_procs.set_shader_for_images {
        p0, p1, p2, p3 := get_quad(r);
        draw_procs.set_shader_for_images(texture);
        draw_procs.immediate_quad(p0, p1, p2, p3, theme.text_color);
    }
}

button :: (r: Rect, text: string, theme: *Button_Theme = null, identifier: s64 = 0, loc := #caller_location , texture: *Texture = null, disable_over := false, disable_press := false) -> (was_just_pressed: bool, state: *Button_State, was_just_released: bool) {
    if !theme theme = *default_overall_theme.button_theme;
    state = find_or_create_state(Button_State, get_hash(loc, identifier));
    defer stop_using_state(state);
    state.rect = r;
    state.hash = get_hash(loc, identifier);
    status := get_status_flags(r);
    if disable_over status &= ~Status_Flags.OVER;
    if disable_press status &= ~Status_Flags.PRESSED;
    was_just_pressed = (status & .PRESSED) != 0;
    was_just_released = state.pressed && (mouse_button_left_state & .END) != 0;
    if theme.properties & .TOGGLE {
        if was_just_pressed state.pressed = !state.pressed;
    } else {
        if was_just_pressed state.pressed = true;
        if was_just_released state.pressed = false;
    }
    if state.pressed status |= .DOWN;
    state.status = status;
    core_draw_button(r, text, state, status, theme, texture);
    if theme.draw_callback theme.draw_callback(r, text, theme, texture, state);
    return was_just_pressed, state, was_just_released;
}

base_checkbox :: (_r: Rect, text: string, selected: bool, theme: *Checkbox_Theme = null, identifier: s64 = 0, loc := #caller_location) -> changed: bool, checkbox_state: Checkbox_State {
    r := _r;
    if !theme theme = *default_overall_theme.checkbox_theme;
    state := find_or_create_state(Checkbox_State, get_hash(loc, identifier));
    defer stop_using_state(state);
    status := get_status_flags(r);
    changed := (status & .PRESSED) != 0;
    state.selected_t = move_toward(state.selected_t, ifx selected then 1.0 else 0.0, current_dt / max(theme.press_duration, 0.001));
    box := r;
    box.w = min(r.h, r.w);
    inner := shrink(box, max(box.h * 0.15, 1.0));
    draw_procs.set_shader_for_color(true);
    color := theme.surface_color;
    if status & .OVER color = theme.surface_color_over;
    rounded_rectangle(box, theme.rectangle_shape, color, theme.frame_color);
    if selected left_round_fill(inner, theme.rectangle_shape, inner.h * (ifx theme.is_radio_button then 0.5 else 0.1), theme.button_color_selected);
    label_rect := r;
    label_rect.x += box.w;
    label_rect.w -= box.w;
    label_theme := theme.label_theme;
    label_theme.text_color = ifx selected then theme.text_color_selected else theme.text_color;
    label(label_rect, text, *label_theme);
    return changed, state.*;
}

checkbox :: (r: Rect, text: string, value: *bool, theme: *Checkbox_Theme = null, identifier: s64 = 0, loc := #caller_location) -> changed: bool, state: Checkbox_State {
    changed, state = base_checkbox(r, text, value.*, theme, identifier, loc);
    if changed value.* = !value.*;
}

radio_button :: (r: Rect, text: string, current_value: *$Enum, button_value: Enum, theme: *Checkbox_Theme = null, identifier: s64 = 0, loc := #caller_location) -> changed: bool, checkbox_state: Checkbox_State {
    changed, checkbox_state = base_checkbox(r, text, current_value.* == button_value, theme, identifier, loc);
    if changed current_value.* = button_value;
}

radio_button :: (r: Rect, current_value: *$Enum, button_value: Enum, theme: *Checkbox_Theme = null, identifier: s64 = 0, loc := #caller_location) -> changed: bool, checkbox_state: Checkbox_State {
    return radio_button(r, tprint("%", button_value), current_value, button_value, theme, identifier, loc);
}

checkbox_flags :: (r: Rect, text: string, current_value: *$Enum, button_value: Enum, theme: *Checkbox_Theme = null, identifier: s64 = 0, loc := #caller_location) -> changed: bool, checkbox_state: Checkbox_State {
    changed, checkbox_state = base_checkbox(r, text, (current_value.* & button_value) != 0, theme, identifier, loc);
    if changed current_value.* ^= button_value;
}

checkbox_flags :: (r: Rect, current_value: *$Enum, button_value: Enum, theme: *Checkbox_Theme = null, identifier: s64 = 0, loc := #caller_location) -> changed: bool, checkbox_state: Checkbox_State {
    return checkbox_flags(r, tprint("%", button_value), current_value, button_value, theme, identifier, loc);
}

dropdown :: (r: Rect, choices: [] string, current_value_pointer: *s32, theme: *Dropdown_Theme = null, identifier: s64 = 0, z: s32 = 100, loc := #caller_location) -> changed: bool, Dropdown_State {
    if !theme theme = *default_overall_theme.dropdown_theme;
    state := find_or_create_state(Dropdown_State, get_hash(loc, identifier));
    defer stop_using_state(state);
    // Refresh everything the popup needs, since it draws later (from the popup list) and only
    // has the state to go on.
    state.loc, state.z = loc, z;
    state.current_value_pointer = current_value_pointer;
    state.theme = theme.*;
    state.base_rect, state.choices = r, choices;
    status := get_status_flags(r, state);
    state.status = status;
    if status & .PRESSED {
        state.open = !state.open;
        if state.open active_widget_add(state);
        else active_widget_remove(state);
    }
    text := "";
    if current_value_pointer.* >= 0 && current_value_pointer.* < choices.count text = choices[current_value_pointer.*];
    base := find_or_create_state(Button_State, get_hash(loc, identifier + 1));
    core_draw_button(r, text, base, status, *theme.theme_for_current_value, null);
    stop_using_state(base);
    if state.open add_popup(draw_dropdown_popup, state, z);
    before := current_value_pointer.*;
    if active_widget == cast(*Active_Widget) state {
        for event, event_index: events_to_handle_this_frame if event.type == .KEYBOARD && event.key_pressed && left_event_window(event_index) == state.window {
            if event.key_code == .ESCAPE state.open = false;
            if choices.count > 0 && event.key_code == .ARROW_DOWN current_value_pointer.* = cast(s32) min(cast(int) current_value_pointer.* + 1, choices.count - 1);
            if choices.count > 0 && event.key_code == .ARROW_UP current_value_pointer.* = cast(s32) max(cast(int) current_value_pointer.* - 1, 0);
        }
    }
    return current_value_pointer.* != before, state.*;
}

dropdown_deactivate :: (widget: *Active_Widget) {
    (cast(*Dropdown_State) widget).open = false;
}

add_popup :: (proc: (*void) -> (), data: *void, z: s32) {
    array_add(*popups, .{ proc, data, z, cast(s32) popups.count });
}

popups_per_frame_update :: () {
    popups.count = 0;
}

draw_popups :: () {
    // Stable insertion ordering handles equal-z popups without dependence on a sort library.
    for i: 1..popups.count - 1 {
        value := popups[i];
        j := i;
        while j > 0 && (popups[j - 1].z > value.z || (popups[j - 1].z == value.z && popups[j - 1].serial > value.serial)) {
            popups[j] = popups[j - 1];
            j -= 1;
        }
        popups[j] = value;
    }
    drawing_popups = true;
    for popup: popups if popup.proc popup.proc(popup.data);
    drawing_popups = false;
    if mouse_button_left_state & .START && !some_widget_received_left_mouse_button active_widget_deactivate_all();
    pointer_end_frame();
    draw_procs.immediate_flush();
}

require_texture :: (data: string, loc := #caller_location) -> *Texture {
    if !draw_procs.texture_load_from_memory return null;
    texture := New(Texture);
    if !draw_procs.texture_load_from_memory(texture, cast([] u8) data, false, false) {
        free(texture);
        return null;
    }
    return texture;
}

// Host cursor handling is an explicit hook; there is no fake native implementation.
pointer_image_sink: (image: Pointer_Image, widget: *Active_Widget) = null;

pointer_end_frame :: () {
    if !left_pointer_requested && draw_procs.set_pointer_image draw_procs.set_pointer_image(.NORMAL, null);
    left_pointer_requested = false;
}

get_selection_indices :: (state: *Text_Input_State) -> start: int, end: int {
    if !state.selection.active return state.insert_point, state.insert_point;
    return clamp(min(state.selection.start_character, state.selection.end_character), 0, state.text.count), clamp(max(state.selection.start_character, state.selection.end_character), 0, state.text.count);
}

get_selection :: (state: *Text_Input_State) -> string {
    start, end := get_selection_indices(state);
    return .{ end - start, state.text.data + start };
}

get_result :: (using state: *Text_Input_State) -> string {
    return state.text;
}

deselect :: (using selection: *Selection) {
    selection.active = false;
}

selection_was_modified :: (using selection: *Selection) {
    if selection.start_character == selection.end_character selection.active = false;
}

nonempty :: (selection: Selection) -> bool {
    return selection.active && selection.start_character != selection.end_character;
}

select_all :: (using state: *Text_Input_State) {
    state.selection = .{ start_line = 0, end_line = 0, start_character = 0, end_character = state.text.count, active = state.text.count > 0 };
    state.insert_point = state.text.count;
}

clamp_insert_point :: (state: *Text_Input_State) {
    state.insert_point = clamp(state.insert_point, 0, state.text.count);
}

set_input :: (using state: *Text_Input_State, _s: string) {
    size := min(_s.count, Text_Input_State.MAX_BUFFER_SIZE);
    // Do not split a UTF-8 codepoint when trimming a fixed-size buffer.
    while size > 0 && size < _s.count && (_s[size] & 0xc0) == 0x80 size -= 1;
    source := copy_string(string.{ size, _s.data });
    defer free(source.data);
    if size > 0 memcpy(*state.input_buffer[0], source.data, size);
    state.text = .{ size, *state.input_buffer[0] };
    state.insert_point = size;
    state.selection.active = false;
}

set_last_inert_text :: (state: *Text_Input_State, text: string) {
    saved := copy_string(text,, GETRECT_HEAP);
    free(state.last_inert_text.data, GETRECT_HEAP);
    state.last_inert_text = saved;
}

set_text :: (state: *Text_Input_State, s: string, replace_pre_modification_text := true) {
    set_input(state, s);
    if replace_pre_modification_text {
        saved := copy_string(state.text,, GETRECT_HEAP);
        free(state.pre_modification_text.data, GETRECT_HEAP);
        state.pre_modification_text = saved;
    }
}

clear_text :: (using state: *Text_Input_State) {
    set_input(state, "");
    state.pending_result_actions |= .TEXT_MODIFIED;
}

replace_selection :: (state: *Text_Input_State, s: string) {
    start, end := get_selection_indices(state);
    new_count := state.text.count - (end - start) + s.count;
    if new_count > Text_Input_State.MAX_BUFFER_SIZE return;
    replacement := copy_string(s);
    defer free(replacement.data);
    old_count := state.text.count;
    shift := s.count - (end - start);
    if shift > 0 {
        i := old_count;
        while i > end {
            i -= 1;
            state.input_buffer[i + shift] = state.input_buffer[i];
        }
    } else if shift < 0 {
        for i: end..old_count - 1 state.input_buffer[i + shift] = state.input_buffer[i];
    }
    for byte, index: replacement state.input_buffer[start + index] = byte;
    state.text = .{ new_count, *state.input_buffer[0] };
    state.insert_point = start + s.count;
    state.selection.active = false;
    state.pending_result_actions |= .TEXT_MODIFIED;
}

insert_text :: (using state: *Text_Input_State, s: string) -> bool {
    start, end := get_selection_indices(state);
    if state.text.count - (end - start) + s.count > Text_Input_State.MAX_BUFFER_SIZE return false;
    replace_selection(state, s);
    return true;
}

append_text :: (using state: *Text_Input_State, s: string) {
    state.insert_point = state.text.count;
    state.selection.active = false;
    insert_text(state, s);
}

seek_left_one_utf8_character :: (s: string, _point: int) -> int {
    point := clamp(_point, 0, s.count);
    if point == 0 return 0;
    point -= 1;
    while point > 0 && (s[point] & 0xc0) == 0x80 point -= 1;
    return point;
}

seek_right_one_utf8_character :: (s: string, point: int) -> int {
    next := clamp(point + 1, 0, s.count);
    while next < s.count && (s[next] & 0xc0) == 0x80 next += 1;
    return next;
}

move_cursor_to :: (state: *Text_Input_State, point: int, want_selection: bool) {
    if want_selection {
        if !state.selection.active {
            state.selection.start_character = state.insert_point;
            state.selection.active = true;
        }
        state.selection.end_character = point;
        selection_was_modified(*state.selection);
    } else state.selection.active = false;
    state.insert_point = point;
}

move_cursor_left :: (using state: *Text_Input_State, want_selection := false) {
    move_cursor_to(state, seek_left_one_utf8_character(state.text, state.insert_point), want_selection);
}

move_cursor_right :: (state: *Text_Input_State, want_selection := false) {
    move_cursor_to(state, seek_right_one_utf8_character(state.text, state.insert_point), want_selection);
}

move_cursor_to_beginning :: (state: *Text_Input_State, want_selection := false) {
    move_cursor_to(state, 0, want_selection);
}

move_cursor_to_end :: (state: *Text_Input_State, want_selection := false) {
    move_cursor_to(state, state.text.count, want_selection);
}

backspace_from_cursor :: (using state: *Text_Input_State, by_word := false) {
    if nonempty(state.selection) {
        replace_selection(state, "");
        return;
    }
    if state.insert_point == 0 return;
    state.selection = .{ start_character = ifx by_word then seek_left_one_word(state.text, state.insert_point) else seek_left_one_utf8_character(state.text, state.insert_point), end_character = state.insert_point, active = true };
    replace_selection(state, "");
}

delete_from_cursor :: (using state: *Text_Input_State, by_word := false) {
    if nonempty(state.selection) {
        replace_selection(state, "");
        return;
    }
    if state.insert_point >= state.text.count return;
    state.selection = .{ start_character = state.insert_point, end_character = ifx by_word then seek_right_one_word(state.text, state.insert_point) else seek_right_one_utf8_character(state.text, state.insert_point), active = true };
    replace_selection(state, "");
}

activate :: (using state: *Text_Input_State) {
    if state.disabled return;
    if !state.active {
        saved := copy_string(state.text,, GETRECT_HEAP);
        free(state.pre_modification_text.data, GETRECT_HEAP);
        state.pre_modification_text = saved;
    }
    state.active = true;
    state.widget.window = context.getrect_current_window;
    active_widget_add(state);
}

reset :: (using state: *Text_Input_State) {
    set_input(state, "");
    state.active = false;
    state.selection.active = false;
    state.pending_result_actions = 0;
    active_widget_remove(state);
}

text_input_deactivate :: (widget: *Active_Widget) {
    state := cast(*Text_Input_State) widget;
    state.active = false;
    state.selection.active = false;
}

text_input_serial_events :: (widget: *Active_Widget, events: [] Event) {
    state := cast(*Text_Input_State) widget;
    if !state.active || state.disabled return;
    for event: events handle_event(state, event);
}

text_input_check_for_activation :: (widget: *Active_Widget, event: Event) -> bool {
    state := cast(*Text_Input_State) widget;
    return !state.disabled && event.type == .KEYBOARD && event.key_pressed && event.key_code == .MOUSE_BUTTON_LEFT && is_inside(mouse_x_float, mouse_y_float, state.rect);
}

handle_event :: (state: *Text_Input_State, event: Event) {
    if !state.active || state.disabled return;
    state.last_keypress_time = current_time;
    if event.type == .TEXT_INPUT && event.utf32 >= 32 && event.utf32 != 127 {
        bytes: [4] u8;
        size: int;
        code := event.utf32;
        if code < 0x80 {
            bytes[0] = cast(u8) code;
            size = 1;
        } else if code < 0x800 {
            bytes[0] = cast(u8) (0xc0 | (code >> 6));
            bytes[1] = cast(u8) (0x80 | (code & 63));
            size = 2;
        } else if code < 0x10000 && !(code >= 0xd800 && code <= 0xdfff) {
            bytes[0] = cast(u8) (0xe0 | (code >> 12));
            bytes[1] = cast(u8) (0x80 | ((code >> 6) & 63));
            bytes[2] = cast(u8) (0x80 | (code & 63));
            size = 3;
        } else if code <= 0x10ffff {
            bytes[0] = cast(u8) (0xf0 | (code >> 18));
            bytes[1] = cast(u8) (0x80 | ((code >> 12) & 63));
            bytes[2] = cast(u8) (0x80 | ((code >> 6) & 63));
            bytes[3] = cast(u8) (0x80 | (code & 63));
            size = 4;
        }
        if size > 0 insert_text(state, string.{ size, *bytes[0] });
    }
    if event.type != .KEYBOARD || !event.key_pressed return;
    if event.key_code == .ARROW_LEFT {
        if event.ctrl_pressed || event.cmd_meta_pressed move_cursor_left_by_word(state, event.shift_pressed);
        else move_cursor_left(state, event.shift_pressed);
    }
    if event.key_code == .ARROW_RIGHT {
        if event.ctrl_pressed || event.cmd_meta_pressed move_cursor_right_by_word(state, event.shift_pressed);
        else move_cursor_right(state, event.shift_pressed);
    }
    if event.key_code == .HOME move_cursor_to_beginning(state, event.shift_pressed);
    if event.key_code == .END move_cursor_to_end(state, event.shift_pressed);
    if event.key_code == .BACKSPACE backspace_from_cursor(state, event.ctrl_pressed || event.cmd_meta_pressed);
    if event.key_code == .DELETE delete_from_cursor(state, event.ctrl_pressed || event.cmd_meta_pressed);
    if cast(s32) event.key_code == 65 && (event.ctrl_pressed || event.cmd_meta_pressed) select_all(state);
    if event.key_code == .TAB {
        press_tab(state, event.shift_pressed);
        return;
    }
    if event.key_code == .ARROW_UP navigate_history_backward(state);
    if event.key_code == .ARROW_DOWN navigate_history_forward(state);
    if (event.ctrl_pressed || event.cmd_meta_pressed) && cast(s32) event.key_code == 67 copy_selection_to_clipboard(state);
    if (event.ctrl_pressed || event.cmd_meta_pressed) && cast(s32) event.key_code == 88 copy_selection_to_clipboard(state, true);
    if (event.ctrl_pressed || event.cmd_meta_pressed) && cast(s32) event.key_code == 86 left_paste_clipboard(state);
    if event.key_code == .ENTER press_enter(state, event.shift_pressed);
    if event.key_code == .ESCAPE press_escape(state);
}

draw_text_input_background :: (r: Rect, theme: *Text_Input_Theme, state: *Text_Input_State, active := false, changed := false) {
    status := get_status_flags(r, *state.widget, ignore = .LEFT_CLICK | .TOOLTIP);
    if active status |= .DOWN;
    if changed status |= .PRESSED;
    core_draw_button(r, "", *state.base, status, *theme.button_theme, null);
}

text_input :: (_r: Rect, inert_text: string, theme: *Text_Input_Theme, identifier: s64 = 0, loc := #caller_location , input_action: Text_Input_Action = 0, auto_complete: Auto_Complete = .{}) -> (result_action: Text_Result_Action, new_string: string, state: *Text_Input_State) {
    state, created := find_or_create_state(Text_Input_State, get_hash(loc, identifier));
    defer stop_using_state(state);
    return left_text_input_body(_r, inert_text, theme, state, created, input_action, auto_complete);
}

#scope_module
left_text_input_body :: (_r: Rect, inert_text: string, theme: *Text_Input_Theme, state: *Text_Input_State, created: bool, input_action: Text_Input_Action, auto_complete: Auto_Complete) -> Text_Result_Action, string, *Text_Input_State {
    if !theme theme = *default_overall_theme.text_input_theme;
    state.rect = _r;
    state.auto_complete = auto_complete;
    if created {
        set_text(state, inert_text);
        set_last_inert_text(state, inert_text);
    }
    if !state.active && state.last_inert_text != inert_text {
        set_text(state, inert_text);
        set_last_inert_text(state, inert_text);
    }
    status := get_status_flags(_r, state);
    if status & .PRESSED && !state.disabled activate(state);
    if input_action & .ACTIVATE activate(state);
    if input_action & .DEACTIVATE {
        state.active = false;
        active_widget_remove(state);
    }
    result_action := state.pending_result_actions;
    state.pending_result_actions = 0;
    if result_action & .ESCAPED {
        if !theme.maintain_text_after_escape set_input(state, state.pre_modification_text);
        state.active = false;
        active_widget_remove(state);
    }
    if result_action & .ENTERED && theme.deactivate_on_enter {
        state.active = false;
        active_widget_remove(state);
    }
    draw_text_input_background(_r, theme, state, state.active, (result_action & .TEXT_MODIFIED) != 0);
    label_theme := theme.label_theme;
    if !label_theme.font label_theme.font = get_default_font_at_size(_r.h * 0.65);
    left_text_pointer(state, theme, label_theme.font, status);
    left_draw_input_contents(_r, theme, state);
    new_string := state.text;
    return result_action, new_string, state;
}
#scope_export

draw :: (using state: *Text_Input_State, r: Rect, theme: *Text_Input_Theme = null, identifier: s64 = 0, loc := #caller_location) {
    if !theme theme = *default_overall_theme.text_input_theme;
    state.rect = r;
    draw_text_input_background(r, theme, state, state.active);
    left_draw_input_contents(r, theme, state);
}

slider :: (_r: Rect, value: *$T, min_value: T, max_value: T, spinbox_step: T, theme: *Slider_Theme, prefix := "", suffix := "", identifier: s64 = 0, loc := #caller_location) -> bool {
    if !theme theme = *default_overall_theme.slider_theme;
    if max_value < min_value || !value return false;
    state := find_or_create_state(Slider_State, get_hash(loc, identifier));
    defer stop_using_state(state);
    runtime := left_slider_runtime(state);
    state.value_type = type_info(T);
    before := value.*;
    candidate := cast(float64) before;
    r := _r;
    if theme.use_spinboxes {
        width := min(_r.h * theme.spinbox_button_width, _r.w / 3);
        minus := Rect.{ _r.x, _r.y, width, _r.h };
        plus := Rect.{ _r.x + _r.w - width, _r.y, width, _r.h };
        pressed, button_state, released := button(minus, "-", *theme.spinbox_theme, identifier + 301, loc);
        if pressed candidate -= cast(float64) spinbox_step;
        pressed, button_state, released = button(plus, "+", *theme.spinbox_theme, identifier + 302, loc);
        if pressed candidate += cast(float64) spinbox_step;
        r.x += width;
        r.w = max(r.w - 2 * width, 0.0);
    }
    state.background.rect = r;
    status := get_status_flags(r, state);
    if status & .PRESSED && !state.inputting_text {
        twice := current_time - runtime.last_click <= theme.text_input_theme.multiclick_delay_max && length(xy(mouse_x_float, mouse_y_float) - runtime.last_position) < max(r.h / 4, 1.0);
        runtime.last_click = current_time;
        runtime.last_position = .{ mouse_x_float, mouse_y_float };
        if theme.text_editable && twice {
            initial: string;
            info := type_info(T);
            if info.type == .FLOAT initial = theme.format_text_float("", "", cast(float64) value.*, theme, state, .EDITING);
            else initial = theme.format_text_int("", "", cast(s64) value.*, theme, state, .EDITING);
            set_text(*runtime.editor, initial);
            set_last_inert_text(*runtime.editor, initial);
            state.inputting_text = true;
            runtime.editor.active = true;
            active_widget_add(*runtime.editor);
        } else {
            set_initial_value(state, value.*);
            state.sliding = true;
            state.sliding_is_relative = theme.sliding_is_relative;
            active_widget_add(state, true);
        }
    }
    if state.sliding {
        if state.sliding_is_relative || (theme.sliding_becomes_relative_by_pressing_shift && (shift_key_state & .DOWN) != 0) {
            factor := theme.relative_slide_factor;
            if shift_key_state & .DOWN factor = theme.relative_slide_factor_modified;
            candidate += mouse_delta_x_float * factor;
        } else if r.w > 0 candidate = cast(float64) min_value + (cast(float64) max_value - min_value) * clamp((mouse_x_float - r.x) / r.w, 0.0, 1.0);
        if mouse_button_left_state & .END {
            state.sliding = false;
            active_widget_remove(state);
        }
    }
    if status & .OVER && !state.inputting_text for event, event_index: events_to_handle_this_frame if left_event_window(event_index) == state.window && event.type == .KEYBOARD && event.key_pressed {
        if event.key_code == .ARROW_LEFT candidate -= cast(float64) spinbox_step;
        if event.key_code == .ARROW_RIGHT candidate += cast(float64) spinbox_step;
    }
    info := type_info(T);
    entered := false;
    if state.inputting_text {
        start_using_state(*runtime.editor);
        defer stop_using_state(*runtime.editor);
        actions, text, editor := left_text_input_body(r, runtime.editor.last_inert_text, *theme.text_input_theme, *runtime.editor, false, 0, .{});
        if actions & .ENTERED {
            success: bool;
            if info.type == .FLOAT {
                parsed, valid := theme.parse_text_float(text, theme, state);
                success = parsed;
                candidate = valid;
            } else {
                parsed, valid := theme.parse_text_int(text, theme, state);
                success = parsed;
                candidate = cast(float64) valid;
            }
            entered = success;
            if !success candidate = cast(float64) before;
            state.inputting_text = false;
        }
        if actions & .ESCAPED || !runtime.editor.active state.inputting_text = false;
    }
    if info.type == .INTEGER candidate = round(candidate);
    clamp_drag := true;
    if state.sliding && (state.sliding_is_relative || shift_key_state & .DOWN) && !theme.do_clamp_if_we_are_relative_dragging_but_started_outside_the_clamp_range {
        initial := get_initial_value(state, T);
        clamp_drag = initial >= min_value && initial <= max_value;
    }
    if (entered && theme.clamp_text_input_low) || (!entered && clamp_drag) candidate = max(candidate, cast(float64) min_value);
    if (entered && theme.clamp_text_input_high) || (!entered && clamp_drag) candidate = min(candidate, cast(float64) max_value);
    value.* = cast(T) candidate;
    fraction := 0.0;
    if max_value > min_value fraction = cast(float) ((candidate - min_value) / (cast(float64) max_value - min_value));
    state.current_slide_setting = clamp(fraction, 0.0, 1.0);
    state.changed_this_frame = value.* != before;
    if state.sliding status |= .DOWN;
    state.background.status = status;
    state.foreground.status = status;
    foreground := shrink(r, r.h * theme.surface_margin);
    state.surface_margin_this_frame_in_pixels = r.h * theme.surface_margin;
    if theme.surface_style == .EXTEND_FROM_LEFT foreground.w *= state.current_slide_setting;
    else {
        width := get_float_parameter(r, theme.nub_thickness_type, theme.nub_thickness, global_slider_nub_thickness_in_pixels);
        foreground.x += state.current_slide_setting * max(foreground.w - width, 0.0);
        foreground.w = min(width, foreground.w);
    }
    if !state.inputting_text {
        if theme.draw_background theme.draw_background(r, theme, state);
        if theme.draw_foreground theme.draw_foreground(r, foreground, theme, state);
        text: string;
        if info.type == .FLOAT {
            if theme.format_text_float text = theme.format_text_float(prefix, suffix, cast(float64) value.*, theme, state, .DISPLAY);
        } else {
            if theme.format_text_int text = theme.format_text_int(prefix, suffix, cast(s64) value.*, theme, state, .DISPLAY);
        }
        label(r, text, *theme.foreground.label_theme);
    }
    return state.changed_this_frame;
}

slider_draw_background_default :: (r: Rect, theme: *Slider_Theme, state: *Slider_State) {
    core_draw_button(r, "", *state.background, state.background.status, *theme.background, null);
}

slider_draw_foreground_default :: (r_background: Rect, r_foreground: Rect, theme: *Slider_Theme, state: *Slider_State) {
    core_draw_button(r_foreground, "", *state.foreground, state.foreground.status, *theme.foreground, null);
}

slider_format_text_float_default :: (prefix: string, suffix: string, value: float64, theme: *Slider_Theme, state: *Slider_State, mode: Slider_Format_Text_Mode) -> string {
    formatted := tprint("%", Basic.formatFloat(value, trailing_width = clamp(theme.decimals, 0, 18), zero_removal = .NO));
    if mode == .EDITING return formatted;
    return tprint("%%%", prefix, formatted, suffix);
}

slider_format_text_int_default :: (prefix: string, suffix: string, value: s64, theme: *Slider_Theme, state: *Slider_State, mode: Slider_Format_Text_Mode) -> string {
    if mode == .EDITING return tprint("%", value);
    return tprint("%%%", prefix, value, suffix);
}

slider_parse_text_float_default :: (text: string, theme: *Slider_Theme, state: *Slider_State) -> (success: bool, value: float64) {
    parsed, valid := string_to_float(text);
    return valid, parsed;
}

slider_parse_text_int_default :: (text: string, theme: *Slider_Theme, state: *Slider_State) -> (success: bool, value: s64) {
    parsed, valid := string_to_int(text);
    return valid, parsed;
}

#scope_module
initialized: bool;
drawing_popups: bool;
global_rounding_radius_in_pixels: float = 9;
global_frame_thickness_in_pixels: float = 4;
global_divider_thickness_in_pixels: float = 4;
global_initial_divider_position_in_pixels: float = 32;
global_slider_nub_thickness_in_pixels: float = 32;

// Which of the sizes above the program fixed with a set_global_* call.
Pinned_Size :: enum_flags u8 {
    ROUNDING_RADIUS;
    FRAME_THICKNESS;
    DIVIDER_THICKNESS;
    DIVIDER_POSITION;
    SLIDER_NUB;
}

pinned_sizes: Pinned_Size;

pin_size :: (target: *float, which: Pinned_Size, value: float) {
    target.* = value;
    pinned_sizes |= which;
}

// Unpinned sizes scale with the render target: mostly fractions of its height, except the
// divider's starting position, which is a quarter of its width.
size_unpinned_metrics :: (width: float, height: float) {
    follow :: (target: *float, which: Pinned_Size, value: float) #expand {
        if !(pinned_sizes & which) target.* = value;
    }
    follow(*global_slider_nub_thickness_in_pixels, .SLIDER_NUB, height * 0.03);
    follow(*global_initial_divider_position_in_pixels, .DIVIDER_POSITION, width * 0.25);
    follow(*global_divider_thickness_in_pixels, .DIVIDER_THICKNESS, height / 100);
    follow(*global_frame_thickness_in_pixels, .FRAME_THICKNESS, height / 540);
    follow(*global_rounding_radius_in_pixels, .ROUNDING_RADIUS, height / 180);
}

sample_tracked_keys :: () -> (left: Key_Current_State, right: Key_Current_State, shift: Key_Current_State) {
    return ui_get_button_state(.MOUSE_BUTTON_LEFT), ui_get_button_state(.MOUSE_BUTTON_RIGHT), ui_get_button_state(.SHIFT);
}

// Reads the pointer through the host callback and derives this frame's motion from the
// position recorded for the same window last frame (zero for a window not seen before).
track_platform_mouse :: (window: Window_Type) {
    px, py, ok := draw_procs.get_mouse_pointer_position(window, GETRECT_Y_UP);
    if !ok return;
    mouse_x, mouse_y = cast(s32) px, cast(s32) py;
    mouse_x_float, mouse_y_float = cast(float) px, cast(float) py;
    mouse_delta_x_float, mouse_delta_y_float = 0, 0;
    for last_frame_per_window_states {
        if it.window != window continue;
        mouse_delta_x_float = mouse_x_float - it.mouse_x_float;
        mouse_delta_y_float = mouse_y_float - it.mouse_y_float;
        break;
    }
    array_add(*this_frame_per_window_states, .{ window, mouse_x_float, mouse_y_float });
}

left_round_fill :: (r: Rect, shape: Rectangle_Shape, radius: float, color: Vector4) {
    if r.w <= 0 || r.h <= 0 || color.w <= 0 return;
    radius = min(radius, min(r.w, r.h) * 0.5);
    points: [..] Vector2;
    center := xy(r.x + r.w * 0.5, r.y + r.h * 0.5);
    corners := Vector2.[.{ r.x + radius, r.y + radius }, .{ r.x + r.w - radius, r.y + radius }, .{ r.x + r.w - radius, r.y + r.h - radius }, .{ r.x + radius, r.y + r.h - radius }];
    flags := ifx GETRECT_Y_UP then Rectangle_Shape.Rounding_Flags.[.SOUTHWEST, .SOUTHEAST, .NORTHEAST, .NORTHWEST] else Rectangle_Shape.Rounding_Flags.[.NORTHWEST, .NORTHEAST, .SOUTHEAST, .SOUTHWEST];
    segments := max(cast(int) ceil(radius * PI * 0.5 / max(shape.pixels_per_edge_segment, 1.0)), 1);
    for corner: 0..3 {
        if !(shape.rounding_flags & flags[corner]) {
            x := ifx corner == 0 || corner == 3 then r.x else r.x + r.w;
            y := ifx corner < 2 then r.y else r.y + r.h;
            array_add(*points, .{ x, y });
            continue;
        }
        for step: 0..segments {
            angle := (cast(float) corner - 2) * PI * 0.5 + cast(float) step / segments * PI * 0.5;
            array_add(*points, corners[corner] + xy(cos(angle), sin(angle)) * radius);
        }
    }
    for i: 0..points.count - 1 {
        next := (i + 1) % points.count;
        draw_procs.immediate_triangle(.{ center.x, center.y, 0 }, .{ points[i].x, points[i].y, 0 }, .{ points[next].x, points[next].y, 0 }, color, color, color);
    }
    array_reset(*points);
}

#scope_export
// Lays the choices out as a column of buttons stacked away from the closed dropdown, one
// row per choice. Picking one stores its index and closes the list.
draw_dropdown_popup :: (_state: *void) {
    dropdown := cast(*Dropdown_State) _state;
    if dropdown.open {
        start_using_state(dropdown);
        draw_dropdown_choices(dropdown);
        stop_using_state(dropdown);
    }
}

draw_dropdown_choices :: (dropdown: *Dropdown_State) {
    step := dropdown.base_rect.h;
    if GETRECT_Y_UP step = -step;
    row := dropdown.base_rect;
    for dropdown.choices {
        row.y = dropdown.base_rect.y + step * (it_index + 1);
        highlighted := it_index == dropdown.current_value_pointer.*;
        look := ifx highlighted then *dropdown.theme.theme_for_current_choice else *dropdown.theme.theme_for_each_choice;
        if button(row, it, look, it_index + 100, dropdown.loc) {
            dropdown.current_value_pointer.* = cast(s32) it_index;
            dropdown.open = false;
            active_widget_remove(dropdown);
        }
    }
}
#scope_module

#if USE_SIMP {
    left_shader_color :: (enable_blend := false) {
        Simp.set_shader_for_color(enable_blend);
    }

    left_prepare_text :: (font: *Font, text: string, effects: Font_Effects = 0) -> s64 {
        return Simp.prepare_text(font, text, effects);
    }

    left_draw_text :: (font: *Font, x: s64, y: s64, text_color: Vector4, effects: Font_Effects = 0) {
        Simp.draw_prepared_text(font, x, left_flip_y(y), text_color, effects);
    }

    left_get_font :: (memory: [] u8, pixel_height: int) -> *Font {
        return Simp.get_font_at_size(memory, pixel_height);
    }

    // Simp and the window layer are y-up; y-down modules flip at the render target height.
    left_flip_y :: (y: $T) -> T {
        if GETRECT_Y_UP return y;
        return render_target_height - y;
    }

    #if GETRECT_Y_UP {
        Right_Windows :: #import "Window_Creation";

        left_get_pointer :: (window: Window_Type, right_handed: bool) -> x: int, y: int, success: bool {
            return Right_Windows.get_mouse_pointer_position(window, right_handed);
        }
    } else {
        left_get_pointer :: (window: Window_Type, right_handed: bool) -> x: int, y: int, success: bool {
            if !Input.input_pointer_source return 0, 0, false;
            px, py := Input.get_input_pointer_position(window, true);
            if right_handed py = render_target_height - py;
            return cast(int) px, cast(int) py, true;
        }
    }

    left_set_scissor :: (x0: s32, y0: s32, x1: s32, y1: s32) {
        #if GETRECT_Y_UP Simp.set_scissor(x0, y0, x1, y1);
        else Simp.set_scissor(x0, render_target_height - y1, x1, render_target_height - y0);
    }

    left_triangle :: (p0: Vector3, p1: Vector3, p2: Vector3, c0 := Vector4.{ 1, 1, 1, 1 }, c1 := Vector4.{ 1, 1, 1, 1 }, c2 := Vector4.{ 1, 1, 1, 1 }, uv0 := Vector2.{}, uv1 := Vector2.{}, uv2 := Vector2.{}, normal := Vector3.{ z = 1 }) {
        a := p0;
        b := p1;
        c := p2;
        a.y = left_flip_y(a.y);
        b.y = left_flip_y(b.y);
        c.y = left_flip_y(c.y);
        Simp.immediate_triangle(a, b, c, c0, c1, c2, uv0, uv1, uv2, normal);
    }

    left_quad :: (p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, color := Vector4.{ 1, 1, 1, 1 }, uv0 := Vector2.{ 0, 0 }, uv1 := Vector2.{ 1, 0 }, uv2 := Vector2.{ 1, 1 }, uv3 := Vector2.{ 0, 1 }) {
        a := p0;
        b := p1;
        c := p2;
        d := p3;
        a.y = left_flip_y(a.y);
        b.y = left_flip_y(b.y);
        c.y = left_flip_y(c.y);
        d.y = left_flip_y(d.y);
        Simp.immediate_quad(a, b, c, d, color, uv0, uv1, uv2, uv3);
    }
}

#scope_module
left_event_windows: [..] Window_Type = .{ allocator = GETRECT_HEAP };
left_scoped_input: bool;

Left_Window_Buttons :: struct {
    window: Window_Type;
    left: Key_Current_State;
    right: Key_Current_State;
    shift: Key_Current_State;
}

left_window_buttons: [..] Left_Window_Buttons = .{ allocator = GETRECT_HEAP };

left_buttons :: (window: Window_Type) -> *Left_Window_Buttons {
    for *buttons: left_window_buttons if buttons.window == window return buttons;
    return array_add(*left_window_buttons, .{ window = window });
}

left_event_window :: (index: int) -> Window_Type {
    if index < left_event_windows.count return left_event_windows[index];
    return context.getrect_current_window;
}

left_update_key :: (state: *Key_Current_State, event: Event) {
    if event.key_pressed {
        state.* |= .DOWN;
        if !event.repeat state.* |= .START;
    } else {
        state.* &= ~Key_Current_State.DOWN;
        state.* |= .END;
    }
}

Left_Slider_Runtime :: struct {
    state: *Slider_State;
    editor: Text_Input_State;
    last_click: float64 = -1;
    last_position: Vector2;
}

left_slider_runtimes: [..] *Left_Slider_Runtime = .{ allocator = GETRECT_HEAP };

left_slider_runtime :: (state: *Slider_State) -> *Left_Slider_Runtime {
    for runtime: left_slider_runtimes if runtime.state == state return runtime;
    runtime := New(Left_Slider_Runtime, allocator = GETRECT_HEAP);
    runtime.state = state;
    runtime.editor.widget_type = Text_Input_State;
    array_add(*left_slider_runtimes, runtime);
    return runtime;
}

#scope_export
ui_deinit :: () {
    assert(state_stack.count == 0 && scissor_stack.count == 0, "Finish drawing before UI teardown");
    active_widget_deactivate_all();
    for runtime: left_slider_runtimes {
        left_release_text_state(*runtime.editor);
        free(runtime, GETRECT_HEAP);
    }
    array_reset(*left_slider_runtimes);
    array_reset(*left_text_views);
    for order: left_subwindow_orders free(order, GETRECT_HEAP);
    array_reset(*left_subwindow_orders);
    left_raise_serial = 0;
    for widget: state_table {
        if widget.widget_type == Text_Input_State left_release_text_state(cast(*Text_Input_State) widget);
        if widget.widget_type == Number_Input_State left_release_text_state(*(cast(*Number_Input_State) widget).text_input_state);
        if widget.widget_type == Color_Picker_State array_reset(*(cast(*Color_Picker_State) widget).stashed_colors);
        if widget.widget_type == Color_Animation_Editor_State {
            state := cast(*Color_Animation_Editor_State) widget;
            array_reset(*state.color_keyframes);
            array_reset(*state.color_samples);
        }
        free(widget, GETRECT_HEAP);
    }
    array_reset(*occlusions_current_frame);
    array_reset(*occlusions_next_frame);
    array_reset(*left_occluder_stack);
    occluder_under_the_cursor = null;
    occluder_being_drawn = null;
    Tables.deinit(*state_table);
    array_reset(*state_stack);
    array_reset(*scissor_stack);
    array_reset(*popups);
    array_reset(*events_to_handle_this_frame);
    array_reset(*left_event_windows);
    array_reset(*left_window_buttons);
    array_reset(*this_frame_per_window_states);
    array_reset(*last_frame_per_window_states);
    #if GETRECT_Y_UP {
        default_font_data = "";
        right_release_assets();
        right_release_asset_root();
    }
    active_widget = null;
    active_widget_is_grabbing = false;
    initialized = false;
    left_scoped_input = false;
}

#scope_module
left_release_text_state :: (state: *Text_Input_State) {
    reset_auto_complete(state);
    free(state.last_inert_text.data, GETRECT_HEAP);
    free(state.pre_modification_text.data, GETRECT_HEAP);
    free(state.last_saved_input.data, GETRECT_HEAP);
    for command: state.command_history free(command.data, GETRECT_HEAP);
    array_reset(*state.command_history);
    array_reset(*state.buffered_events);
}
