#scope_export
#load "advanced-layouts.jai";
begin_scrollable_region :: (r: Rect, theme: *Scrollable_Region_Theme = null, identifier: s64 = 0, loc := #caller_location) -> (state: *Scrollable_Region_State, inside: Rect) {
    if !theme theme = *default_overall_theme.scrollable_region_theme;
    state = find_or_create_state(Scrollable_Region_State, get_hash(loc, identifier));
    state.outer_rect = r;
    state.theme = theme.*;
    vertical := (theme.direction & .VERTICAL) != 0;
    bar_size := max(theme.scrollbar_size * render_target_height, 1.0);
    state.bar_rect = r;
    state.inner_rect = r;
    if vertical {
        state.bar_rect.x += max(r.w - bar_size, 0.0);
        state.bar_rect.w = min(bar_size, r.w);
        state.inner_rect.w = max(r.w - bar_size, 0.0);
    } else {
        #if GETRECT_Y_UP {
            state.bar_rect.h = min(bar_size, r.h);
            state.inner_rect.y += state.bar_rect.h;
            state.inner_rect.h = max(r.h - state.bar_rect.h, 0.0);
        } else {
            state.bar_rect.y += max(r.h - bar_size, 0.0);
            state.bar_rect.h = min(bar_size, r.h);
            state.inner_rect.h = max(r.h - bar_size, 0.0);
        }
    }
    rounded_rectangle(state.inner_rect, theme.region_background.shape, theme.region_background.color, theme.region_background.frame_color);
    inside = state.inner_rect;
    margin_x := theme.horizontal_margin_size * render_target_height;
    margin_y := theme.vertical_margin_size * render_target_height;
    if theme.margin_flags & .Horizontal {
        inside.x += margin_x;
        inside.w = max(inside.w - 2 * margin_x, 0.0);
    }
    if theme.margin_flags & .Vertical {
        inside.y += margin_y;
        inside.h = max(inside.h - 2 * margin_y, 0.0);
    }
    state.inner_rect = inside;
    push_scissor(inside);
    return state, inside;
}
#if GETRECT_Y_UP {
    end_scrollable_region :: (state: *Scrollable_Region_State, max_x: float, min_y: float, scroll_value: *float) {
        end_scrollable_region_shared(state, max_x, min_y, scroll_value);
    }
} else {
    end_scrollable_region :: (state: *Scrollable_Region_State, max_x: float, max_y: float, scroll_value: *float) {
        end_scrollable_region_shared(state, max_x, max_y, scroll_value);
    }
}
#scope_module
// y_limit is the content's lowest edge (y-up) or highest extent (y-down).
end_scrollable_region_shared :: (state: *Scrollable_Region_State, max_x: float, y_limit: float, scroll_value: *float) {
    assert(state && scroll_value);
    if !state || !scroll_value return;
    pop_scissor();
    defer stop_using_state(state);
    theme := *state.theme;
    vertical := (theme.direction & .VERTICAL) != 0;
    viewport := ifx vertical then state.inner_rect.h else state.inner_rect.w;
    before := scroll_value.*;
    content := max((ifx vertical then (ifx GETRECT_Y_UP then state.inner_rect.y + state.inner_rect.h - y_limit else y_limit - state.inner_rect.y) else max_x - state.inner_rect.x) + before, viewport);
    extent := max(content - viewport, 0.0);
    track := ifx vertical then state.bar_rect.h else state.bar_rect.w;
    breadth := ifx vertical then state.bar_rect.w else state.bar_rect.h;
    nib_size := min(track, max(breadth * theme.minimum_nib_size, ifx content > 0 then track * viewport / content else track));
    travel := max(track - nib_size, 0.0);
    if has_focus(state.outer_rect) for event, index: events_to_handle_this_frame if left_event_window(index) == state.window && event.type == .MOUSE_WHEEL {
        scroll_value.* -= event.wheel_delta * theme.mouse_wheel_increment * render_target_height;
    }
    nib := state.bar_rect;
    position := ifx vertical then mouse_y_float else mouse_x_float;
    origin := ifx vertical then nib.y else nib.x;
    #if GETRECT_Y_UP {
        nib = right_scroll_nib(state.bar_rect, vertical, viewport, content, scroll_value.*, theme.minimum_nib_size);
    } else {
        fraction := ifx extent > 0 then clamp(scroll_value.* / extent, 0.0, 1.0) else 0.0;
        if vertical {
            nib.y += fraction * travel;
            nib.h = nib_size;
        } else {
            nib.x += fraction * travel;
            nib.w = nib_size;
        }
    }
    status := get_status_flags(nib, state);
    if status & .PRESSED {
        state.dragging = true;
        active_widget_add(state, true);
    }
    if state.dragging && travel > 0 scroll_value.* = extent * scroll_fraction(state.bar_rect, vertical, nib_size, position, origin, travel);
    if mouse_button_left_state & .END {
        state.dragging = false;
        active_widget_remove(state);
    }
    if !state.dragging {
        track_status := get_status_flags(state.bar_rect, state);
        if track_status & .PRESSED {
            state.teleporting = true;
            scroll_value.* = extent * scroll_fraction(state.bar_rect, vertical, nib_size, position, origin, travel);
        } else state.teleporting = false;
    }
    scroll_value.* = clamp(scroll_value.*, 0.0, extent);
    rounded_rectangle(state.bar_rect, theme.scrollbar_background.shape, theme.scrollbar_background.color, theme.scrollbar_background.frame_color);
    if state.dragging status |= .DOWN;
    core_draw_button(shrink(nib, breadth * theme.nib_margin), "", *state.nib_state, status, *theme.scrollbar_nib_theme, null);
}
// Pointer position along the scrollbar track as a 0..1 fraction (the y-up track runs bottom to top).
scroll_fraction :: (bar: Rect, vertical: bool, nib_size: float, position: float, origin: float, travel: float) -> float {
    if GETRECT_Y_UP return right_scroll_fraction(bar, vertical, nib_size, position);
    return clamp((position - origin - nib_size / 2) / max(travel, 1.0), 0.0, 1.0);
}
#scope_export
slidable_region :: (r: Rect, theme: *Slidable_Region_Theme = null, identifier: s64 = 0, loc := #caller_location) -> (state: *Slidable_Region_State, left_or_top_rect: Rect, right_or_bottom_rect: Rect, divider_rect: Rect) {
    if !theme theme = *default_overall_theme.slidable_region_theme;
    state, created := find_or_create_state(Slidable_Region_State, get_hash(loc, identifier));
    state.theme = theme;
    horizontal := theme.orientation == .HORIZONTAL;
    dimension := ifx horizontal then r.w else r.h;
    thickness := clamp(get_float_parameter(r, theme.divider_thickness_type, theme.divider_thickness, global_divider_thickness_in_pixels), 0.0, dimension);
    if created state.divider_t = clamp(get_float_parameter(r, theme.initial_divider_position_type, theme.initial_divider_position, global_initial_divider_position_in_pixels) / max(dimension, 1.0), 0.0, 1.0);
    first, divider, second := compute_rects(r, state, thickness);
    status := get_status_flags(divider, state);
    if status & .PRESSED {
        state.dragging = true;
        active_widget_add(state, true);
    }
    if state.dragging {
        point := ifx horizontal then mouse_x_float - r.x else (ifx GETRECT_Y_UP then r.y + r.h - mouse_y_float else mouse_y_float - r.y);
        state.divider_t = clamp((point - thickness / 2) / max(dimension - thickness, 1.0), 0.0, 1.0);
        first, divider, second = compute_rects(r, state, thickness);
        status |= .DOWN;
        if mouse_button_left_state & .END {
            state.dragging = false;
            active_widget_remove(state);
        }
    }
    state.left_or_top_rect = first;
    state.right_or_bottom_rect = second;
    state.divider_rect = divider;
    rounded_rectangle(first, theme.first_background.shape, theme.first_background.color, theme.first_background.frame_color);
    rounded_rectangle(second, theme.second_background.shape, theme.second_background.color, theme.second_background.frame_color);
    core_draw_button(divider, "", *state.divider_state, status, *theme.divider_theme, null);
    push_scissor(first);
    return state, first, second, divider;
}
compute_rects :: (r: Rect, state: *Slidable_Region_State, divider_thickness_in_pixels: float) -> (top: Rect, divider: Rect, bottom: Rect) {
    if GETRECT_Y_UP return right_divider_rects(r, state.theme.orientation == .HORIZONTAL, state.divider_t, divider_thickness_in_pixels);
    top := r;
    divider := r;
    bottom := r;
    thickness := max(divider_thickness_in_pixels, 0.0);
    if state.theme.orientation == .HORIZONTAL {
        top.w = max(r.w - thickness, 0.0) * state.divider_t;
        divider.x += top.w;
        divider.w = min(thickness, r.w);
        bottom.x = divider.x + divider.w;
        bottom.w = max(r.x + r.w - bottom.x, 0.0);
    } else {
        top.h = max(r.h - thickness, 0.0) * state.divider_t;
        divider.y += top.h;
        divider.h = min(thickness, r.h);
        bottom.y = divider.y + divider.h;
        bottom.h = max(r.y + r.h - bottom.y, 0.0);
    }
    return top, divider, bottom;
}
switch_to_second_rect :: (state: *Slidable_Region_State) {
    pop_scissor();
    push_scissor(state.right_or_bottom_rect);
}
switch_to_first_rect :: (state: *Slidable_Region_State) {
    pop_scissor();
    push_scissor(state.left_or_top_rect);
}
finish :: (state: *Slidable_Region_State) {
    pop_scissor();
    stop_using_state(state);
}
number_input :: (_r: Rect, text: string, value: *$T, min_value: T, max_value: T, theme: *Number_Input_Theme, identifier: s64 = 0, loc := #caller_location,parse_proc: (string) -> (T, bool) = null) -> bool {
    if !value || max_value < min_value return false;
    if !theme theme = *left_default_number_theme;
    state, created := find_or_create_state(Number_Input_State, get_hash(loc, identifier));
    defer stop_using_state(state);
    start_using_state(*state.text_input_state);
    defer stop_using_state(*state.text_input_state);
    actions, input, input_state := left_text_input_body(_r, text, *theme.text_input_theme, *state.text_input_state, created, 0, .{});
    state.inputting_text = input_state.active;
    if !(actions & .ENTERED) return false;
    candidate: T;
    success: bool;
    if parse_proc candidate, success = parse_proc(input);
    else {
        #if type_info(T).type == .FLOAT {
            parsed, ok := string_to_float(input);
            candidate = cast(T) parsed;
            success = ok;
        } else {
            parsed, ok := string_to_int(input);
            candidate = cast(T) parsed;
            success = ok;
        }
    }
    if !success return false;
    if theme.clamp_low candidate = max(candidate, min_value);
    if theme.clamp_high candidate = min(candidate, max_value);
    changed := candidate != value.*;
    value.* = candidate;
    return changed;
}
add_subwindow :: (info: *Subwindow_Info, theme: *Subwindow_Theme = null, identifier: s64 = 0, loc := #caller_location,z: s32 = 0) -> (state: *Subwindow_State) {
    assert(info != null);
    if !info return null;
    if !theme theme = *default_overall_theme.subwindow_theme;
    state := find_or_create_state(Subwindow_State, get_hash(loc, identifier));
    state.info = info;
    state.theme = theme.*;
    state.hash = get_hash(loc, identifier);
    state.wants_draw = info.open;
    if state.render_target_width > 0 && state.render_target_height > 0 && (state.render_target_width != render_target_width || state.render_target_height != render_target_height) info.rect = rescale(info.rect, state.render_target_width, state.render_target_height);
    state.render_target_width = render_target_width;
    state.render_target_height = render_target_height;
    order := left_subwindow_order(state);
    order.z = z;
    order.frame = current_getrect_frame;
    if info.wants_a_raise || state.wants_a_raise {
        raise(state);
        info.wants_a_raise = false;
        state.wants_a_raise = false;
    }
    if info.open {
        add_popup(left_subwindow_popup, state, z);
        position: s32;
        for other: left_subwindow_orders if other.rank < order.rank position += 1;
        popups[popups.count - 1].serial = position;
    }
    stop_using_state(state);
    return state;
}
draw_subwindow :: (state: *Subwindow_State) {
    if !state.info || !state.info.open return;
    start_using_state(state);
    defer stop_using_state(state);
    occluder_start(state, state.info.rect);
    defer occluder_finish(state, state.info.rect);
    theme := *state.theme;
    info := state.info;
    full := info.rect;
    title_height := ifx theme.subwindow_flags & .TITLE_BAR then get_title_bar_height(theme) else 0.0;
    if info.fixed_aspect_ratio > 0 full.h = full.w / info.fixed_aspect_ratio;
    title := full;
    title.h = min(title_height, full.h);
    if GETRECT_Y_UP title.y = full.y + full.h - title.h;
    state.title_bar_rect = title;
    controls := adjust_resize_control(theme, state, left_resize_hit(full, theme, mouse_x_float, mouse_y_float));
    if controls != 0 {
        outer := shrink(full, -max(theme.drag_extrusion_east, max(theme.drag_extrusion_west, max(theme.drag_extrusion_north, theme.drag_extrusion_south))) * render_target_height);
        resize_status := get_status_flags(outer, state, ignore = .SCISSOR | .TOOLTIP);
        if resize_status & .PRESSED {
            state.dragging = .RESIZE;
            state.dragging_resize_control = controls;
            start_resizing(state, full);
            active_widget_add(state, true);
            raise(state);
        }
        left_request_cursor(get_pointer_from_resize_control(controls), state);
    }
    title_status := get_status_flags(title, state);
    if title_status & .PRESSED {
        state.dragging = .TITLE;
        state.dragging_last = .{ mouse_x_float, mouse_y_float };
        active_widget_add(state, true);
        raise(state);
    }
    edge_margin := theme.resize_rect_size * render_target_height;
    corner := Rect.{ full.x + max(full.w - edge_margin, 0.0), full.y + ifx GETRECT_Y_UP then 0.0 else max(full.h - edge_margin, 0.0), min(edge_margin, full.w), min(edge_margin, full.h) };
    corner_status := get_status_flags(corner, state);
    if corner_status & .PRESSED && (theme.resize_controls & (.CORNER_SE | .SE)) {
        state.dragging = .RESIZE;
        state.dragging_resize_control = .SE;
        start_resizing(state, full);
        active_widget_add(state, true);
    }
    update_dragging(state, *full);
    info.rect = full;
    title = full;
    title.h = min(title_height, full.h);
    if GETRECT_Y_UP title.y = full.y + full.h - title.h;
    state.title_bar_rect = title;
    content := full;
    if !GETRECT_Y_UP content.y += title.h;
    content.h = max(content.h - title.h, 0.0);
    #if GETRECT_Y_UP {
        title, state.content_rect = right_subwindow_rects(full, title_height, theme.horizontal_margin_size * render_target_height, theme.vertical_margin_size * render_target_height);
        corner = .{ full.x + max(full.w - edge_margin, 0.0), full.y, min(edge_margin, full.w), min(edge_margin, full.h) };
    } else {
        state.content_rect = shrink_xy(content, theme.horizontal_margin_size * render_target_height, theme.vertical_margin_size * render_target_height);
    }
    if theme.subwindow_flags & .FRINGE rounded_rectangle(shrink(full, -theme.fringe_thickness * render_target_height), theme.region_background.shape, theme.fringe_color, .{});
    rounded_rectangle(content, theme.region_background.shape, theme.region_background.color, theme.region_background.frame_color);
    if title.h > 0 core_draw_button(title, info.title_text, *state.base, title_status, *theme.title_bar, null);
    if theme.subwindow_flags & .CLOSE_BUTTON && title.h > 0 {
        close := Rect.{ title.x + title.w - title.h * (theme.close_button_width + theme.close_button_right_margin), title.y + (title.h - title.h * theme.close_button_height) / 2, title.h * theme.close_button_width, title.h * theme.close_button_height };
        pressed, button_state, released := button(close, "x", *theme.close_button, cast(s64) state.hash + 1);
        if pressed {
            info.open = false;
            state.wants_draw = false;
            active_widget_remove(state);
            return;
        }
    }
    if theme.subwindow_flags & .VISIBLE_RESIZE_CORNER draw_resize_corner(theme, state, corner);
    #if GETRECT_Y_UP {
        state.draw_proc_adjusted_y = false;
        if info.draw {
            push_scissor(state.content_rect);
            info.draw(state, state.content_rect, info.user_data);
            pop_scissor();
        }
        if state.draw_proc_adjusted_y {
            // The callback reports a new content bottom; the outer top remains anchored.
            full = right_content_bottom(full, state.draw_proc_new_y1, theme.vertical_margin_size * render_target_height, title.h);
            state.draw_proc_adjusted_y = false;
            info.rect = full;
            title, state.content_rect = right_subwindow_rects(full, title_height, theme.horizontal_margin_size * render_target_height, theme.vertical_margin_size * render_target_height);
        }
    } else {
        if info.draw {
            push_scissor(state.content_rect);
            info.draw(state.content_rect, info.user_data);
            pop_scissor();
        }
    }
}
get_title_bar_height :: (theme: *Subwindow_Theme, override_render_target_height: s32 = 0) -> float {
    return theme.title_bar_size * (ifx override_render_target_height > 0 then override_render_target_height else render_target_height);
}
subwindow_rect_from_content_rect :: (content_rect: Rect, theme: *Subwindow_Theme, override_render_target_height: s32 = 0) -> Rect {
    height := ifx override_render_target_height > 0 then override_render_target_height else render_target_height;
    result := content_rect;
    mx := theme.horizontal_margin_size * height;
    my := theme.vertical_margin_size * height;
    title := ifx theme.subwindow_flags & .TITLE_BAR then get_title_bar_height(theme, override_render_target_height) else 0.0;
    result.x -= mx;
    result.y -= my + ifx GETRECT_Y_UP then 0.0 else title;
    result.w += 2 * mx;
    result.h += 2 * my + title;
    return result;
}
raise :: (state: *Subwindow_State) {
    left_raise_serial += 1;
    left_subwindow_order(state).rank = left_raise_serial;
}
start_resizing :: (state: *Subwindow_State, f: Rect) {
    state.dragging_last = .{ mouse_x_float, mouse_y_float };
    state.dragging_start = state.dragging_last;
    state.resizing_aspect = ifx f.h > 0 then f.w / f.h else 1.0;
}
update_dragging :: (state: *Subwindow_State, full: *Rect) {
    if active_widget != state return;
    delta := xy(mouse_x_float, mouse_y_float) - state.dragging_last;
    state.dragging_last = .{ mouse_x_float, mouse_y_float };
    if state.dragging == .TITLE {
        full.x += delta.x;
        full.y += delta.y;
    } else if state.dragging == .RESIZE {
        control := state.dragging_resize_control;
        anchored_top := full.y + full.h;
        #if GETRECT_Y_UP {
            full.* = right_resize_edges(full.*, delta, (control & .WEST) != 0, (control & .EAST) != 0, (control & .NORTH) != 0, (control & .SOUTH) != 0, state.theme.resize_minimum_size.x * render_target_height, state.theme.resize_minimum_size.y * render_target_height);
        } else {
            if control & .EAST full.w += delta.x;
            if control & .SOUTH full.h += delta.y;
            if control & .WEST {
                full.x += delta.x;
                full.w -= delta.x;
            }
            if control & .NORTH {
                full.y += delta.y;
                full.h -= delta.y;
            }
            full.w = max(full.w, state.theme.resize_minimum_size.x * render_target_height);
            full.h = max(full.h, state.theme.resize_minimum_size.y * render_target_height);
        }
        aspect := state.info.fixed_aspect_ratio;
        if aspect <= 0 && control & .PROPORTIONAL aspect = state.resizing_aspect;
        if aspect > 0 full.h = full.w / aspect;
        snap := state.theme.resize_snap_margin * render_target_height;
        if control & .SNAP_EW && abs(full.w - state.info.snap_to_size.x) < snap full.w = state.info.snap_to_size.x;
        if control & .SNAP_NS && abs(full.h - state.info.snap_to_size.y) < snap full.h = state.info.snap_to_size.y;
        #if GETRECT_Y_UP {
            if control & .SOUTH full.y = anchored_top - full.h;
        }
    }
    if mouse_button_left_state & .END active_widget_remove(state);
}
rescale :: (r: Rect, old_w: s32, old_h: s32) -> Rect {
    if old_w <= 0 || old_h <= 0 return r;
    return .{ r.x * render_target_width / old_w, r.y * render_target_height / old_h, r.w * render_target_width / old_w, r.h * render_target_height / old_h };
}
rescale :: (v: Vector2, old_w: s32, old_h: s32) -> Vector2 {
    if old_w <= 0 || old_h <= 0 return v;
    return .{ v.x * render_target_width / old_w, v.y * render_target_height / old_h };
}
draw_resize_corner :: (theme: *Subwindow_Theme, state: *Subwindow_State, r: Rect) {
    draw_procs.set_shader_for_color(true);
    for line: 1..3 {
        offset := r.w * line / 4;
        width := max(r.w * theme.resize_corner_line_thickness, 1.0);
        stripe := Rect.{ r.x + r.w - offset, ifx GETRECT_Y_UP then r.y + offset - width else r.y + r.h - offset, offset, width };
        p0, p1, p2, p3 := get_quad(stripe);
        draw_procs.immediate_quad(p0, p1, p2, p3, theme.resize_corner_color);
    }
}
#scope_module
left_default_number_theme: Number_Input_Theme;
left_subwindow_popup :: (data: *void) {
    draw_subwindow(cast(*Subwindow_State) data);
}
shrink_xy :: (r: Rect, x: float, y: float) -> Rect {
    return .{ r.x + x, r.y + y, max(r.w - 2 * x, 0.0), max(r.h - 2 * y, 0.0) };
}

Left_Subwindow_Order :: struct {
    state: *Subwindow_State;
    z: s32;
    rank: u64;
    frame: u64;
}
left_subwindow_orders: [..] *Left_Subwindow_Order;
left_raise_serial: u64;
left_subwindow_order :: (state: *Subwindow_State) -> *Left_Subwindow_Order {
    for order: left_subwindow_orders if order.state == state return order;
    order := New(Left_Subwindow_Order);
    order.state = state;
    left_raise_serial += 1;
    order.rank = left_raise_serial;
    array_add(*left_subwindow_orders, order);
    return order;
}
left_subwindow_hit :: (window: Window_Type, x: float, y: float) -> *Active_Widget {
    best: *Left_Subwindow_Order;
    for order: left_subwindow_orders if order.frame == current_getrect_frame && order.state.window == window && order.state.info && order.state.info.open {
        theme := *order.state.theme;
        margin := max(theme.fringe_thickness, max(theme.drag_extrusion_east, max(theme.drag_extrusion_west, max(theme.drag_extrusion_north, theme.drag_extrusion_south)))) * render_target_height;
        if is_inside(x, y, shrink(order.state.info.rect, -margin)) && (!best || order.z > best.z || (order.z == best.z && order.rank > best.rank)) best = order;
    }
    if best return *best.state.widget;
    return null;
}
left_resize_hit :: (r: Rect, theme: *Subwindow_Theme, x: float, y: float) -> Resize_Controls {
    result: Resize_Controls;
    height := cast(float) render_target_height;
    lo_ext := ifx GETRECT_Y_UP then theme.drag_extrusion_south else theme.drag_extrusion_north;
    hi_ext := ifx GETRECT_Y_UP then theme.drag_extrusion_north else theme.drag_extrusion_south;
    lo_intr := ifx GETRECT_Y_UP then theme.drag_intrusion_south else theme.drag_intrusion_north;
    hi_intr := ifx GETRECT_Y_UP then theme.drag_intrusion_north else theme.drag_intrusion_south;
    lo_flag := ifx GETRECT_Y_UP then Resize_Controls.SOUTH else Resize_Controls.NORTH;
    hi_flag := ifx GETRECT_Y_UP then Resize_Controls.NORTH else Resize_Controls.SOUTH;
    if y >= r.y - lo_ext * height && y <= r.y + r.h + hi_ext * height {
        if x >= r.x - theme.drag_extrusion_west * height && x <= r.x + theme.drag_intrusion_west * height result |= .WEST;
        if x >= r.x + r.w - theme.drag_intrusion_east * height && x <= r.x + r.w + theme.drag_extrusion_east * height result |= .EAST;
    }
    if x >= r.x - theme.drag_extrusion_west * height && x <= r.x + r.w + theme.drag_extrusion_east * height {
        if y >= r.y + r.h - hi_intr * height && y <= r.y + r.h + hi_ext * height result |= hi_flag;
        if y >= r.y - lo_ext * height && y <= r.y + lo_intr * height result |= lo_flag;
    }
    result &= theme.resize_controls;
    if theme.resize_controls & .CORNER_SE && is_inside(x, y, .{ r.x + r.w - theme.resize_rect_size * height, ifx GETRECT_Y_UP then r.y else r.y + r.h - theme.resize_rect_size * height, theme.resize_rect_size * height, theme.resize_rect_size * height }) result |= .SE;
    if result != 0 result |= theme.resize_controls & (.PROPORTIONAL | .SNAP);
    return result;
}
#scope_export
get_pointer_from_resize_control :: (flags: Resize_Controls) -> Pointer_Image {
    if flags & .EW && flags & .NS {
        if flags & .NE == .NE || flags & .SW == .SW return .DRAGGING_NE_SW;
        return .DRAGGING_NW_SE;
    }
    if flags & .EW return .DRAGGING_HORIZONTAL;
    if flags & .NS return .DRAGGING_VERTICAL;
    return .NORMAL;
}

#scope_export
#if GETRECT_Y_UP {
    draw_proc_adjust_y1 :: (state: *Subwindow_State, new_y1: float) {
        assert(state && state.info, "Subwindow content adjustment needs a live subwindow");
        if !state || !state.info return;
        state.draw_proc_new_y1 = new_y1;
        state.draw_proc_adjusted_y = true;
    }
}
