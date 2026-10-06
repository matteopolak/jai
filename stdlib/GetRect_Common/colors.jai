#scope_export
#load "color-math.jai";
#load "color-compatibility.jai";
#load "color-surfaces.jai";

get_desired_aspect_ratio :: (theme: *Color_Animation_Editor_Theme) -> float {
    return 4.0 / max(1 - 2 * theme.vertical_padding, 0.1);
}

get_desired_aspect_ratio :: (theme: *Color_Picker_Theme) -> float {
    return 1.6 + theme.stashed_color_width + theme.margin_between_color_input_and_stashed_colors;
}

set_original_and_current_color_rgb :: (state: *Color_Picker_State, rgb: Vector3) {
    state.original_rgb_color = left_clip_rgb(rgb);
    set_current_color_rgb(state, null, rgb);
}

set_current_color_hsv :: (state: *Color_Picker_State, hsv: Vector3, update_zoom_hue := true) {
    state.current_hsv_color = .{ hsv.x - floor(hsv.x / 360) * 360, clamp(hsv.y, 0.0, 1.0), clamp(hsv.z, 0.0, 1.0) };
    r, g, b := hsv_to_rgb(state.current_hsv_color.x / 360, state.current_hsv_color.y, state.current_hsv_color.z);
    state.current_rgb_color = .{ r, g, b };
    if update_zoom_hue state.zoom_hue_center = state.current_hsv_color.x;
    state.disc_point = backsolve_disc_point_from_hsv(state, state.current_hsv_color.x, state.current_hsv_color.y, state.current_hsv_color.z);
    angle := state.current_hsv_color.x * PI / 180;
    state.ring_point = .{ cos(angle), sin(angle) };
}

set_current_color_rgb :: (state: *Color_Picker_State, theme: *Color_Picker_Theme, rgb: Vector3, update_hsv := true, maintain_h := FLOAT32_INFINITY, update_disc_point := true) {
    state.current_rgb_color = left_clip_rgb(rgb);
    if update_hsv {
        h, s, v := rgb_to_hsv(state.current_rgb_color.x, state.current_rgb_color.y, state.current_rgb_color.z);
        if maintain_h != FLOAT32_INFINITY h = maintain_h / 360;
        set_current_color_hsv(state, .{ h * 360, s, v });
    }
    if update_disc_point state.disc_point = backsolve_disc_point_from_hsv(state, state.current_hsv_color.x, state.current_hsv_color.y, state.current_hsv_color.z);
}

hsv_to_argb :: (hsv: Vector3) -> Vector4 {
    r, g, b := hsv_to_rgb(hsv.x / 360, hsv.y, hsv.z);
    return .{ r, g, b, 1 };
}

stash_color :: (using state: *Color_Picker_State, color: Vector3) {
    if state.stashed_colors.count >= MAX_STASHED_COLORS {
        for i: 1..state.stashed_colors.count - 1 state.stashed_colors[i - 1] = state.stashed_colors[i];
        state.stashed_colors.count -= 1;
    }
    array_add(*state.stashed_colors, left_clip_rgb(color));
}

toggle_rectangle_picker_mode :: (state: *Color_Picker_State) {
    state.hsv_picker_in_rectangle_mode = !state.hsv_picker_in_rectangle_mode;
}

toggle_circle_picker_mode :: (state: *Color_Picker_State) {
    state.circle_picker_in_warped_mode = !state.circle_picker_in_warped_mode;
    state.disc_point = backsolve_disc_point_from_rgb(state, state.current_rgb_color);
}

color_picker :: (r: Rect, input_and_output_color_rgb: *Vector3, theme: *Color_Picker_Theme = null, identifier: s64 = 0, loc := #caller_location) -> (applied: bool, still_dragging: bool, state: *Color_Picker_State) {
    if !theme theme = *default_overall_theme.color_picker_theme;
    assert(input_and_output_color_rgb != null);
    if !input_and_output_color_rgb return false, false, null;
    state, created := find_or_create_state(Color_Picker_State, get_hash(loc, identifier));
    defer stop_using_state(state);
    if created {
        set_original_and_current_color_rgb(state, input_and_output_color_rgb.*);
        state.color_pick_mode = theme.starting_color_pick_mode;
        for color: theme.initial_stashed_colors stash_color(state, color);
    }
    rounded_rectangle(r, theme.background.shape, theme.background.color, theme.background.frame_color);
    pad_x := r.w * theme.horizontal_padding;
    pad_y := r.h * theme.vertical_padding;
    content := shrink_xy(r, pad_x, pad_y);
    controls_height := max(content.h * 0.12, 18.0);
    color_area := content;
    if GETRECT_Y_UP color_area.y += controls_height * 2;
    color_area.h = max(content.h - controls_height * 2, 0.0);
    color_area.w *= 1 - theme.stashed_color_width - theme.margin_between_color_input_and_stashed_colors;
    mode_row := Rect.{ content.x, ifx GETRECT_Y_UP then color_area.y - controls_height else color_area.y + color_area.h, color_area.w, controls_height };
    modes := string.["Circle", "HSV", "RGB", "Numbers"];
    for name, index: modes {
        cell := mode_row;
        cell.w /= 4;
        cell.x += cell.w * index;
        pressed, button_state, released := button(cell, name, *theme.mode_switch_button_theme, identifier * 37 + index + 101, loc);
        if pressed state.color_pick_mode = cast(Color_Pick_Mode) index;
    }
    if state.color_pick_mode == .HSV_CIRCLE left_color_disc(color_area, theme, state);
    else if state.color_pick_mode == .HSV_SLIDERS draw_hsv_sliders(color_area, theme, state);
    else if state.color_pick_mode == .RGB_SLIDERS draw_rgb_sliders(color_area, theme, state);
    else draw_type_ins(color_area, theme, state);
    stash_area := content;
    stash_area.x = color_area.x + color_area.w + content.w * theme.margin_between_color_input_and_stashed_colors;
    stash_area.w = max(content.x + content.w - stash_area.x, 0.0);
    stash_area.h = color_area.h;
    if GETRECT_Y_UP stash_area.y = color_area.y;
    count := max(state.stashed_colors.count, 1);
    height := stash_area.h / count;
    for color, index: state.stashed_colors {
        cell := Rect.{ stash_area.x, ifx GETRECT_Y_UP then stash_area.y + stash_area.h - (index + 1) * height else stash_area.y + index * height, stash_area.w, height };
        rounded_rectangle(cell, theme.stashed_colors_shape, .{ color.x, color.y, color.z, 1 }, .{});
        if get_status_flags(cell, state) & .PRESSED set_current_color_rgb(state, theme, color);
    }
    actions := Rect.{ content.x, ifx GETRECT_Y_UP then mode_row.y - controls_height else mode_row.y + mode_row.h, content.w / 3, controls_height };
    applied := false;
    pressed, button_state, released := button(actions, theme.apply_string, *theme.apply_and_revert_button_theme, identifier * 37 + 201, loc);
    if pressed {
        input_and_output_color_rgb.* = state.current_rgb_color;
        state.original_rgb_color = state.current_rgb_color;
        applied = true;
    }
    actions.x += actions.w;
    pressed, button_state, released = button(actions, theme.revert_string, *theme.apply_and_revert_button_theme, identifier * 37 + 202, loc);
    if pressed set_current_color_rgb(state, theme, state.original_rgb_color);
    actions.x += actions.w;
    pressed, button_state, released = button(actions, "Stash", *theme.stash_button_theme, identifier * 37 + 203, loc);
    if pressed stash_color(state, state.current_rgb_color);
    dragging := state.dragging_in_ring || state.dragging_in_disc || state.dragging_in_h || state.dragging_in_s || state.dragging_in_l || state.dragging_in_r || state.dragging_in_g || state.dragging_in_b || state.dragging_in_hsv_rectangle;
    return applied, dragging, state;
}

draw_hsv_sliders :: (area: Rect, theme: *Color_Picker_Theme, state: *Color_Picker_State) {
    row := area;
    row.h /= 4;
    if GETRECT_Y_UP row.y = area.y + area.h - row.h;
    hsv := state.current_hsv_color;
    changed := slider(row, *hsv.x, theme.slider_hue_min, theme.slider_hue_max, 1.0, *default_overall_theme.slider_theme, "H ", "", 1);
    if changed set_current_color_hsv(state, hsv);
    advance_row(*row);
    zoom := state.current_hsv_color.x;
    half := max(theme.hue_range_in_zoomed_slider / 2, EPSILON);
    zoom_changed := slider(row, *zoom, state.zoom_hue_center - half, state.zoom_hue_center + half, 0.1, *default_overall_theme.slider_theme, "H zoom ", "", 4);
    if zoom_changed {
        hsv = state.current_hsv_color;
        hsv.x = zoom;
        set_current_color_hsv(state, hsv, false);
    }
    advance_row(*row);
    if state.hsv_picker_in_rectangle_mode {
        plane := row;
        if GETRECT_Y_UP plane.y = area.y;
        plane.h *= 2;
        status := get_status_flags(plane, state);
        if status & .PRESSED {
            state.dragging_in_hsv_rectangle = true;
            active_widget_add(state, true);
        }
        if state.dragging_in_hsv_rectangle left_sv_drag(plane, state, false);
        if mouse_button_left_state & .END {
            state.dragging_in_hsv_rectangle = false;
            active_widget_remove(state);
        }
        left_sv_surface(plane, state, false);
    } else {
        hsv = state.current_hsv_color;
        changed = slider(row, *hsv.y, 0.0, 1.0, 0.01, *default_overall_theme.slider_theme, "S ", "", 2);
        advance_row(*row);
        changed = slider(row, *hsv.z, 0.0, 1.0, 0.01, *default_overall_theme.slider_theme, "V ", "", 3) || changed;
        if changed set_current_color_hsv(state, hsv, false);
    }
    if mouse_button_right_state & .START && has_focus(area) toggle_rectangle_picker_mode(state);
}

draw_rgb_sliders :: (area: Rect, theme: *Color_Picker_Theme, state: *Color_Picker_State) {
    row := area;
    row.h /= 3;
    if GETRECT_Y_UP row.y = area.y + area.h - row.h;
    rgb := state.current_rgb_color;
    changed := slider(row, *rgb.x, 0.0, 1.0, 0.01, *default_overall_theme.slider_theme, "R ", "", 1);
    advance_row(*row);
    changed = slider(row, *rgb.y, 0.0, 1.0, 0.01, *default_overall_theme.slider_theme, "G ", "", 2) || changed;
    advance_row(*row);
    changed = slider(row, *rgb.z, 0.0, 1.0, 0.01, *default_overall_theme.slider_theme, "B ", "", 3) || changed;
    if changed set_current_color_rgb(state, theme, rgb);
}

draw_type_ins :: (area: Rect, theme: *Color_Picker_Theme, state: *Color_Picker_State) {
    row := area;
    row.h /= 3;
    if GETRECT_Y_UP row.y = area.y + area.h - row.h;
    rgb := state.current_rgb_color;
    changed := number_input(row, tprint("%", rgb.x), *rgb.x, 0.0, 1.0, *theme.type_ins_input_theme, 1);
    advance_row(*row);
    changed = number_input(row, tprint("%", rgb.y), *rgb.y, 0.0, 1.0, *theme.type_ins_input_theme, 2) || changed;
    advance_row(*row);
    changed = number_input(row, tprint("%", rgb.z), *rgb.z, 0.0, 1.0, *theme.type_ins_input_theme, 3) || changed;
    if changed set_current_color_rgb(state, theme, rgb);
}

set_keyframes :: (state: *Color_Animation_Editor_State, frames: [] Color_Keyframe) {
    state.color_keyframes.count = 0;
    for frame: frames array_add(*state.color_keyframes, .{ base = frame });
    state.dragging_in_strip = false;
    state.color_picker_subwindow_info.open = false;
}

get_keyframes :: (state: *Color_Animation_Editor_State) -> [] Color_Keyframe {
    sorted := get_sorted_keyframes(state);
    result := NewArray(sorted.count, Color_Keyframe,, Basic.temp);
    for frame, index: sorted result[index] = frame.base;
    return result;
}

get_sorted_keyframes :: (state: *Color_Animation_Editor_State, index_to_ignore := -1) -> [] *Augmented_Keyframe {
    result := NewArray(state.color_keyframes.count, *Augmented_Keyframe,, Basic.temp);
    // Fill before shrinking: indexing past a zeroed count would fail the bounds check.
    kept := 0;
    for *frame, index: state.color_keyframes if index != index_to_ignore {
        result[kept] = frame;
        kept += 1;
    }
    result.count = kept;
    for i: 1..result.count - 1 {
        item := result[i];
        j := i;
        while j > 0 && result[j - 1].t > item.t {
            result[j] = result[j - 1];
            j -= 1;
        }
        result[j] = item;
    }
    return result;
}

get_interpolation :: (state: *Color_Animation_Editor_State) -> Interpolation {
    return .{ cast(type_of(Interpolation.color_space)) state.interpolation_color_space_s32, cast(type_of(Interpolation.geometry)) state.interpolation_geometry_s32, state.interpolation_wrapping };
}

set_interpolation :: (using state: *Color_Animation_Editor_State, interp: Interpolation) {
    state.interpolation_color_space_s32 = cast(s32) interp.color_space;
    state.interpolation_geometry_s32 = cast(s32) interp.geometry;
    state.interpolation_wrapping = interp.wrapping;
}

generate_color_samples :: (sorted: [] *$T/interface Color_Keyframe, interp: Interpolation, output_samples: [] Vector4) {
    for *sample, index: output_samples {
        t := ifx output_samples.count > 1 then cast(float) index / (output_samples.count - 1) else 0.0;
        if sorted.count == 0 {
            sample.* = .{};
            continue;
        }
        if sorted.count == 1 {
            sample.* = sorted[0].color_rgb;
            continue;
        }
        left := 0;
        right := 1;
        position := t;
        if interp.wrapping {
            position = frac(t);
            if position < sorted[0].t {
                left = sorted.count - 1;
                right = 0;
                position += 1;
            } else if position >= sorted[sorted.count - 1].t {
                left = sorted.count - 1;
                right = 0;
            } else {
                for i: 1..sorted.count - 1 if position <= sorted[i].t {
                    left = i - 1;
                    right = i;
                    break;
                }
            }
        } else {
            if position <= sorted[0].t {
                sample.* = sorted[0].color_rgb;
                continue;
            }
            if position >= sorted[sorted.count - 1].t {
                sample.* = sorted[sorted.count - 1].color_rgb;
                continue;
            }
            for i: 1..sorted.count - 1 if position <= sorted[i].t {
                left = i - 1;
                right = i;
                break;
            }
        }
        start := sorted[left].t;
        end := sorted[right].t;
        if right == 0 end += 1;
        u := clamp((position - start) / max(end - start, 0.000001), 0.0, 1.0);
        previous := max(left - 1, 0);
        next := min(right + 1, sorted.count - 1);
        if interp.wrapping {
            previous = (left + sorted.count - 1) % sorted.count;
            next = (right + 1) % sorted.count;
        }
        p0 := left_color_space(sorted[previous].color_rgb, interp);
        p1 := left_color_space(sorted[left].color_rgb, interp);
        p2 := left_color_space(sorted[right].color_rgb, interp);
        p3 := left_color_space(sorted[next].color_rgb, interp);
        if interp.color_space == .HSV {
            while p2.x - p1.x > 0.5 p2.x -= 1;
            while p2.x - p1.x < -0.5 p2.x += 1;
            while p0.x - p1.x > 0.5 p0.x -= 1;
            while p0.x - p1.x < -0.5 p0.x += 1;
            while p3.x - p2.x > 0.5 p3.x -= 1;
            while p3.x - p2.x < -0.5 p3.x += 1;
        }
        color := lerp(p1, p2, u);
        if interp.geometry == .QUADRIC {
            tangent := (p2 - p0) * 0.5;
            color = p1 + tangent * u + (p2 - p1 - tangent) * u * u;
        }
        if interp.geometry == .HERMITE {
            a := (p2 - p0) * 0.5;
            b := (p3 - p1) * 0.5;
            u2 := u * u;
            u3 := u2 * u;
            color = p1 * (2 * u3 - 3 * u2 + 1) + a * (u3 - 2 * u2 + u) + p2 * (-2 * u3 + 3 * u2) + b * (u3 - u2);
        }
        rgb := left_color_space_inverse(color, interp);
        sample.* = .{ rgb.x, rgb.y, rgb.z, lerp(sorted[left].color_rgb.w, sorted[right].color_rgb.w, u) };
    }
}

color_animation_editor :: (r: Rect, theme: *Color_Animation_Editor_Theme = null, identifier: s64 = 0, loc := #caller_location) -> (state: *Color_Animation_Editor_State) {
    if !theme theme = *default_overall_theme.color_animation_editor_theme;
    state, created := find_or_create_state(Color_Animation_Editor_State, get_hash(loc, identifier));
    defer stop_using_state(state);
    state.theme = theme;
    if created {
        set_keyframes(state, theme.default_keyframes);
        set_interpolation(state, theme.default_interpolation);
        state.num_clipboard_samples = theme.default_num_clipboard_samples;
        state.time_view_period = theme.default_time_view_period;
    }
    rounded_rectangle(r, theme.background.shape, theme.background.color, theme.background.frame_color);
    bar := shrink_xy(r, r.w * theme.horizontal_padding, r.h * theme.vertical_padding);
    if GETRECT_Y_UP bar.y += bar.h * 0.50;
    bar.h *= 0.50;
    my_color_slider(bar, 1.0, theme, state);
    row := r;
    if GETRECT_Y_UP {
        row.h = max((bar.y - r.y) / 2, 0.0);
        row.y = bar.y - row.h;
    } else {
        row.y = bar.y + bar.h;
        row.h = (r.y + r.h - row.y) / 2;
    }
    row.w = r.w / 3;
    if theme.draw_subwidgets_flags & .INTERPOLATION_CONTROLS {
        spaces := string.["RGB", "HSV", "Oklab"];
        geometries := string.["Linear", "Quadric", "Hermite"];
        dropdown(row, spaces, *state.interpolation_color_space_s32, *theme.dropdown_theme, identifier * 41 + 1, 100, loc);
        row.x += row.w;
        dropdown(row, geometries, *state.interpolation_geometry_s32, *theme.dropdown_theme, identifier * 41 + 2, 100, loc);
        row.x += row.w;
        checkbox(row, "Wrap", *state.interpolation_wrapping, *theme.checkbox_theme, identifier * 41 + 3, loc);
    }
    row.x = r.x;
    advance_row(*row);
    if theme.draw_subwidgets_flags & .SAMPLING_CONTROLS number_input(row, tprint("%", state.num_clipboard_samples), *state.num_clipboard_samples, 1, 4096, *theme.number_input_theme, identifier * 41 + 4, loc);
    row.x += row.w;
    if theme.draw_subwidgets_flags & .TIME_VIEW {
        pressed, button_state, released := button(row, "Time view", *theme.button_theme, identifier * 41 + 5, loc);
        if pressed open_time_view(theme, state, bar);
    }
    row.x += row.w;
    if theme.draw_subwidgets_flags & .COPY_TO_CLIPBOARD {
        pressed, button_state, released := button(row, "Copy", *theme.button_theme, identifier * 41 + 6, loc);
        if pressed copy_output_to_clipboard(state, cast(Output_Type) state.output_type_s32);
    }
    draw_color_picker(theme, state);
    draw_time_view(theme, state);
    return state;
}

open_color_picker :: (theme: *Color_Animation_Editor_Theme, state: *Color_Animation_Editor_State, keyframe_index: int, bar_rect: Rect) {
    if keyframe_index < 0 || keyframe_index >= state.color_keyframes.count return;
    state.color_picker_keyframe_index = keyframe_index;
    color := state.color_keyframes[keyframe_index].color_rgb;
    state.color_picker_editing_color_applied = .{ color.x, color.y, color.z };
    info := *state.color_picker_subwindow_info;
    if !state.color_picker_subwindow_rect_initialized {
        info.rect = .{ bar_rect.x, ifx GETRECT_Y_UP then bar_rect.y - max(bar_rect.w / get_desired_aspect_ratio(*theme.color_picker_theme), 64.0) else bar_rect.y + bar_rect.h, bar_rect.w, max(bar_rect.w / get_desired_aspect_ratio(*theme.color_picker_theme), 64.0) };
        state.color_picker_subwindow_rect_initialized = true;
    }
    info.open = true;
    info.title_text = "Keyframe color";
    info.draw = draw_callback_color_picker;
    info.user_data = state;
}

draw_color_picker :: (theme: *Color_Animation_Editor_Theme, state: *Color_Animation_Editor_State) {
    if state.color_picker_subwindow_info.open add_subwindow(*state.color_picker_subwindow_info, *theme.color_picker_subwindow_theme, cast(s64) state);
}

// The subwindow draw callback takes the Subwindow_State first only in y-up modules.
#if GETRECT_Y_UP {
    draw_callback_color_picker :: (state: *Subwindow_State, r: Rect, data: *void) {
        color_picker_callback_body(r, data);
    }
} else {
    draw_callback_color_picker :: (r: Rect, data: *void) {
        color_picker_callback_body(r, data);
    }
}

#scope_module
color_picker_callback_body :: (r: Rect, data: *void) {
    editor := cast(*Color_Animation_Editor_State) data;
    applied, dragging, picker := color_picker(r, *editor.color_picker_editing_color_applied, *editor.theme.color_picker_theme, 712);
    editor.last_color_picker_state = picker;
    if applied && editor.color_picker_keyframe_index >= 0 && editor.color_picker_keyframe_index < editor.color_keyframes.count {
        color := editor.color_picker_editing_color_applied;
        editor.color_keyframes[editor.color_picker_keyframe_index].color_rgb = .{ color.x, color.y, color.z, 1 };
    }
}

#scope_export
open_time_view :: (theme: *Color_Animation_Editor_Theme, state: *Color_Animation_Editor_State, bar_rect: Rect) {
    info := *state.time_view_subwindow_info;
    info.open = true;
    info.title_text = "Color over time";
    info.draw = draw_callback_time_view;
    info.user_data = state;
    if info.rect.w <= 0 info.rect = .{ bar_rect.x, ifx GETRECT_Y_UP then bar_rect.y - max(bar_rect.h, 64.0) else bar_rect.y + bar_rect.h, bar_rect.w, max(bar_rect.h, 64.0) };
}

draw_time_view :: (theme: *Color_Animation_Editor_Theme, state: *Color_Animation_Editor_State) {
    if state.time_view_subwindow_info.open add_subwindow(*state.time_view_subwindow_info, *theme.time_view_subwindow_theme, cast(s64) state + 713);
}

#scope_export
#if GETRECT_Y_UP {
    draw_callback_time_view :: (state: *Subwindow_State, r: Rect, data: *void) {
        time_view_callback_body(r, data);
    }
} else {
    draw_callback_time_view :: (r: Rect, data: *void) {
        time_view_callback_body(r, data);
    }
}

#scope_module
time_view_callback_body :: (r: Rect, data: *void) {
    editor := cast(*Color_Animation_Editor_State) data;
    if editor.time_view_playing editor.time_view_current_time += current_dt;
    samples: [1] Vector4;
    frame := Color_Keyframe.{ t = cast(float) frac(editor.time_view_current_time / max(editor.time_view_period, 0.001)) };
    sorted := get_sorted_keyframes(editor);
    interp := get_interpolation(editor);
    // Sampling a shifted cyclic pair uses the same interpolation implementation.
    shifted := NewArray(sorted.count, *Color_Keyframe,, Basic.temp);
    storage := NewArray(sorted.count, Color_Keyframe,, Basic.temp);
    for value, index: sorted {
        storage[index] = value.base;
        storage[index].t -= frame.t;
        shifted[index] = *storage[index];
    }
    generate_color_samples(shifted, interp, samples);
    left_color_fill(r, samples[0]);
}

#scope_export
copy_output_to_clipboard :: (state: *Color_Animation_Editor_State, output_type: Output_Type) {
    builder: String_Builder;
    if output_type == .SOURCE_KEYFRAMES for frame: get_keyframes(state) append(*builder, tprint(".{.{%,%,%,%},%},\n", frame.color_rgb.x, frame.color_rgb.y, frame.color_rgb.z, frame.color_rgb.w, frame.t));
    else {
        samples := NewArray(max(state.num_clipboard_samples, 1), Vector4,, Basic.temp);
        generate_color_samples(get_sorted_keyframes(state), get_interpolation(state), samples);
        for color: samples append(*builder, tprint(".{%,%,%,%},\n", color.x, color.y, color.z, color.w));
    }
    text := builder_to_string(*builder);
    Left_Clipboard.os_clipboard_set_text(text);
    free_buffers(*builder);
}

#scope_module
Left_Clipboard :: #import "Clipboard";

left_color_fill :: (r: Rect, color: Vector4) {
    draw_procs.set_shader_for_color(true);
    p0, p1, p2, p3 := get_quad(r);
    draw_procs.immediate_quad(p0, p1, p2, p3, color);
}

left_clip_rgb :: (rgb: Vector3) -> Vector3 {
    return .{ clamp(rgb.x, 0.0, 1.0), clamp(rgb.y, 0.0, 1.0), clamp(rgb.z, 0.0, 1.0) };
}

left_color_disc :: (r: Rect, theme: *Color_Picker_Theme, state: *Color_Picker_State) {
    center := xy(r.x + r.w / 2, r.y + r.h / 2);
    radius := min(r.w, r.h) * theme.outer_circle_diameter / 2;
    inner := min(radius, min(r.w, r.h) * theme.inner_circle_diameter / 2);
    side := inner * (ifx state.circle_picker_in_warped_mode then 2.0 else 1.41421356) * theme.inner_disc_radius;
    plane := Rect.{ center.x - side / 2, center.y - side / 2, side, side };
    distance := length(xy(mouse_x_float, mouse_y_float) - center);
    status := get_status_flags(r, state);
    if status & .PRESSED {
        state.dragging_in_ring = distance >= inner && distance <= radius;
        state.dragging_in_disc = ifx state.circle_picker_in_warped_mode then distance <= side / 2 else is_inside(mouse_x_float, mouse_y_float, plane);
        if state.dragging_in_ring || state.dragging_in_disc active_widget_add(state, true);
    }
    if state.dragging_in_ring {
        angle := atan2(mouse_y_float - center.y, mouse_x_float - center.x);
        hsv := state.current_hsv_color;
        hsv.x = cast(float) (angle * 180 / PI);
        set_current_color_hsv(state, hsv);
    }
    if state.dragging_in_disc left_sv_drag(plane, state, state.circle_picker_in_warped_mode);
    if mouse_button_left_state & .END {
        state.dragging_in_ring = false;
        state.dragging_in_disc = false;
        active_widget_remove(state);
    }
    if mouse_button_right_state & .START && has_focus(r) toggle_circle_picker_mode(state);
    draw_procs.set_shader_for_color(true);
    for i: 0..47 {
        a := i * 2 * PI / 48;
        b := (i + 1) * 2 * PI / 48;
        ca := hsv_to_argb(.{ i * 360.0 / 48, 1, 1 });
        cb := hsv_to_argb(.{ (i + 1) * 360.0 / 48, 1, 1 });
        p0 := center + xy(cos(a), sin(a)) * inner;
        p1 := center + xy(cos(a), sin(a)) * radius;
        p2 := center + xy(cos(b), sin(b)) * radius;
        p3 := center + xy(cos(b), sin(b)) * inner;
        draw_procs.immediate_triangle(to_vec3(p0), to_vec3(p1), to_vec3(p2), ca, ca, cb);
        draw_procs.immediate_triangle(to_vec3(p0), to_vec3(p2), to_vec3(p3), ca, cb, cb);
    }
    left_sv_surface(plane, state, state.circle_picker_in_warped_mode);
}

left_color_space :: (rgba: Vector4, interp: Interpolation) -> Vector3 {
    rgb := Vector3.{ rgba.x, rgba.y, rgba.z };
    if interp.color_space == .HSV {
        h, s, v := rgb_to_hsv(rgb.x, rgb.y, rgb.z);
        return .{ h, s, v };
    }
    if interp.color_space == .OKLAB return linear_srgb_to_oklab(.{ left_decode_channel(rgb.x), left_decode_channel(rgb.y), left_decode_channel(rgb.z) });
    return rgb;
}

left_color_space_inverse :: (value: Vector3, interp: Interpolation) -> Vector3 {
    if interp.color_space == .HSV {
        r, g, b := hsv_to_rgb(value.x, value.y, value.z);
        return .{ r, g, b };
    }
    if interp.color_space == .OKLAB {
        linear := oklab_to_linear_srgb(value);
        return left_clip_rgb(.{ left_encode_channel(linear.x), left_encode_channel(linear.y), left_encode_channel(linear.z) });
    }
    return left_clip_rgb(value);
}

#scope_module
// Moves a row to the next one down the screen (y-up decreases y, y-down increases it).
advance_row :: (row: *Rect) {
    if GETRECT_Y_UP row.y -= row.h;
    else row.y += row.h;
}
