// An on-screen view of the profile: a report table (draw) and per-zone history lines (draw_graph).
// Iprof does not render anything itself; it calls the procedures in Config, so any renderer works.
//
// Coordinates: (sx, sy) is the top-left corner of the area and y grows upward (as in Simp), so the
// area spans sx..sx+width horizontally and sy-height..sy vertically.

Config :: struct {
    // Required: how to draw and measure. The defaults draw nothing.
    draw_text: (x: float, y: float, str: string, color: Vector4) = ignore_text;
    text_width: (s: string) -> float = guess_text_width;
    draw_rectangle: (x0: float, y0: float, x1: float, y1: float, color: Vector4) = ignore_rectangle;
    draw_line: (p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, color: Vector4) = ignore_quad; // A filled quad, corners in order.
    graph_begin: (x: float, y: float, width: float, height: float) = ignore_region; // E.g. to set a scissor rect.
    graph_end: (x: float, y: float, width: float, height: float) = ignore_region;

    // Font metrics in pixels; set these to match your font.
    line_spacing: s32 = 8;
    font_character_height: s32 = 8;
    text_y_offset: s32 = 0; // Added to the baseline of every text draw.

    zone_time_precision_digits: s32 = 2;

    // Colors (RGBA).
    title_background_color := Vector4.{ .06, .06, .08, .96 };
    title_text_color := Vector4.{ .75, .75, .75, 1 };
    header_color_unhilit := Vector4.{ .55, .55, .6, 1 };
    header_color_hilit := Vector4.{ 1, .95, .65, 1 };
    zone_text_color_cold := Vector4.{ .85, .2, .2, 1 }; // Steady zones...
    zone_text_color_hot := Vector4.{ 1, .92, .9, 1 }; // ...blend toward this as heat rises.
    bar_color_a := Vector4.{ .1, .02, .04, .92 }; // Alternating row backgrounds.
    bar_color_b := Vector4.{ .15, .05, .07, .92 };
    selected_bar_whiten_amount := 0.35;

    graph_zone_under_cursor_text_color := Vector4.{ .8, 1, 1, 1 };
    graph_zone_under_cursor_background_color := Vector4.{ 0, 0, .12, .9 };
    graph_current_time_marker_color := Vector4.{ 1, 1, .9, 1 };
    graph_current_time_history_color := Vector4.{ 1, .35, .3, .75 }; // The whole-frame line.
    graph_time_cursor_color := Vector4.{ 1, 1, .9, .5 };
    selected_graph_color := Vector4.{ 1, 1, 1, 1 };

    graph_colors: [] Vector4; // One per zone, cycled. Left empty, draw_graph fills it on first use.

    user_data: *void; // Not used by Iprof.
}

// Vertical scale of a graph: the top of the graph is full_scale_ms, eased toward a power of two
// just above the largest visible sample.
Graph_Scaling :: struct {
    full_scale_ms: float64 = 1;
    target_scale_ms: float64 = 1;
}

zone_under_cursor: *Zone; // Zone whose graph line is nearest the mouse.
current_graph_window_selected_sample := -1; // Frames-ago under the mouse, or -1 when outside the graph.

set_cursor_screen_coordinates :: (x: s32, y: s32) {
    mouse_x = x;
    mouse_y = y;
}

// Jump to the frame under the mouse and focus the call graph on the zone under it.
graph_select_sample :: () {
    if current_graph_window_selected_sample < 0 return;
    set_frame(current_graph_window_selected_sample);
    if zone_under_cursor focus_zone(zone_under_cursor);
}

get_current_graph_scaling :: () -> *Graph_Scaling {
    if graph_shows_self() return *self_scaling;
    return *hier_scaling;
}

draw :: (sx: float, sy: float, full_width: float, height: float, config: *Config) {
    report := create_report();
    line := cast(float) config.line_spacing;
    if line <= 0 return;

    // Value columns on the right, sized for the widest number we expect; the name takes the rest.
    column_w := config.text_width("00000.000") + line;
    name_right := sx + full_width - column_w * (NUM_HEADER - 1);

    y := sy;
    config.draw_rectangle(sx, y - line, sx + full_width, y, config.title_background_color);
    text_at(config, sx + line * .5, y - line, report.title, config.title_text_color);
    if report.title_right {
        w := config.text_width(report.title_right);
        text_at(config, sx + full_width - w - line * .5, y - line, report.title_right, config.title_text_color);
    }
    y -= line;

    config.draw_rectangle(sx, y - line, sx + full_width, y, config.title_background_color);
    for col: 0..NUM_HEADER - 1 {
        color := ifx col == report.hilit_header then config.header_color_hilit else config.header_color_unhilit;
        label := report.header[col];
        if col == 0 text_at(config, sx + line * .5, y - line, label, color);
        else text_right(config, name_right + column_w * col, y - line, label, color);
    }
    y -= line;

    bottom := sy - height;
    for report.records {
        if y - line < bottom break;

        bar := ifx it_index & 1 then config.bar_color_b else config.bar_color_a;
        if it_index == report.hilight bar = lighten(bar, config.selected_bar_whiten_amount);
        config.draw_rectangle(sx, y - line, sx + full_width, y, bar);

        color := lerp(config.zone_text_color_cold, config.zone_text_color_hot, cast(float) it.heat);
        label := it.name;
        if it.prefix != #char " " && it.prefix != 0 label = tprint("% %", string.{ 1, *it.prefix }, it.name);
        indent := line * (.5 + cast(float) it.indent);
        text_at(config, sx + indent, y - line, label, color);

        digits := config.zone_time_precision_digits;
        if it.value_flag & VALUE_SELF text_right(config, name_right + column_w, y - line, number_text(it.self_time, digits), color);
        if it.value_flag & VALUE_HIER text_right(config, name_right + column_w * 2, y - line, number_text(it.hier_time, digits), color);
        if it.value_flag & VALUE_CALLS text_right(config, name_right + column_w * 3, y - line, number_text(it.calls, -1), color);
        y -= line;
    }
}

// History lines: one per zone (self or hierarchical time depending on the report mode), oldest
// frame on the left. Also tracks the zone and frame under the mouse for graph_select_sample().
draw_graph :: (sx: float, sy: float, width: float, height: float, config: *Config) {
    config.graph_begin(sx, sy, width, height);
    defer config.graph_end(sx, sy, width, height);
    config.draw_rectangle(sx, sy - height, sx + width, sy, config.title_background_color);

    zone_under_cursor = null;
    current_graph_window_selected_sample = -1;

    #if DO_HISTORY {
        if !live || frames_recorded == 0 return;
        if !config.graph_colors make_graph_colors(config);

        frames := min(frames_recorded, NUM_FRAME_SLOTS);
        self := graph_shows_self();
        scaling := get_current_graph_scaling();

        // Rescale to fit the tallest visible sample.
        tallest: float64 = 0;
        for *zones {
            if !it.entered || it == *zones[0] continue;
            for f: 0..frames - 1 tallest = max(tallest, history_value(it, f, self));
        }
        target: float64 = 0.125;
        while target < tallest target *= 2;
        scaling.target_scale_ms = target;
        scaling.full_scale_ms += (target - scaling.full_scale_ms) * .25;
        full := max(scaling.full_scale_ms, 0.001);

        step := width / cast(float) max(NUM_FRAME_SLOTS - 1, 1);
        x_of := (frames_ago: s64, sx: float, width: float, step: float) -> float {
            return sx + width - step * cast(float) frames_ago;
        };
        y_of := (ms: float64, sy: float, height: float, full: float64) -> float {
            return sy - height + height * cast(float) min(ms / full, 1.0);
        };

        // Mouse position as a frame and a height in milliseconds.
        mx := cast(float) mouse_x;
        my := cast(float) mouse_y;
        mouse_inside := mx >= sx && mx <= sx + width && my >= sy - height && my <= sy;
        mouse_frame := -1;
        if mouse_inside {
            mouse_frame = cast(s64) ((sx + width - mx) / step + .5);
            if mouse_frame >= frames mouse_frame = -1;
        }
        nearest := FLOAT32_MAX;

        color_index := 0;
        for *zone: zones {
            if !zone.entered continue;
            is_root := zone == *zones[0];
            color := config.graph_colors[color_index % config.graph_colors.count];
            if !is_root color_index += 1;
            if is_root color = config.graph_current_time_history_color;
            if zone == graph_focus color = config.selected_graph_color;
            thickness := ifx zone == graph_focus then 2.5 else 1.0;

            for f: 0..frames - 2 {
                a := Vector2.{ x_of(f + 1, sx, width, step), y_of(history_value(zone, f + 1, self), sy, height, full) };
                b := Vector2.{ x_of(f, sx, width, step), y_of(history_value(zone, f, self), sy, height, full) };
                thick_segment(config, a, b, thickness, color);
            }

            if mouse_frame >= 0 && !is_root {
                gap := abs(y_of(history_value(zone, mouse_frame, self), sy, height, full) - my);
                if gap < nearest {
                    nearest = gap;
                    zone_under_cursor = zone;
                }
            }
        }

        if display_frame > 0 {
            x := x_of(display_frame, sx, width, step);
            config.draw_rectangle(x - .5, sy - height, x + .5, sy, config.graph_current_time_marker_color);
        }

        if mouse_frame >= 0 {
            current_graph_window_selected_sample = mouse_frame;
            x := x_of(mouse_frame, sx, width, step);
            config.draw_rectangle(x - .5, sy - height, x + .5, sy, config.graph_time_cursor_color);
            if zone_under_cursor {
                label := tprint("% (% ms)", zone_under_cursor.name, number_text(history_value(zone_under_cursor, mouse_frame, self), config.zone_time_precision_digits));
                line := cast(float) config.line_spacing;
                w := config.text_width(label) + line;
                left := min(mx + line, sx + width - w);
                config.draw_rectangle(left, my, left + w, my + line, config.graph_zone_under_cursor_background_color);
                text_at(config, left + line * .5, my, label, config.graph_zone_under_cursor_text_color);
            }
        }
    }
}

#scope_module

mouse_x: s32;
mouse_y: s32;
self_scaling: Graph_Scaling;
hier_scaling: Graph_Scaling;

graph_shows_self :: () -> bool {
    return displayed_quantity == .SELF_TIME || displayed_quantity == .CALL_COUNT;
}

#if DO_HISTORY {
    history_value :: (zone: *Zone, frames_ago: s64, self: bool) -> float64 {
        h := *zone.history[history_slot(frames_ago)];
        return ifx self then cast(float64) h.self_ms else cast(float64) h.hier_ms;
    }
}

text_at :: (config: *Config, x: float, y: float, s: string, color: Vector4) {
    // Centre the glyphs vertically in the row.
    pad := (cast(float) config.line_spacing - cast(float) config.font_character_height) * .5;
    config.draw_text(x, y + pad + cast(float) config.text_y_offset, s, color);
}

text_right :: (config: *Config, right: float, y: float, s: string, color: Vector4) {
    text_at(config, right - config.text_width(s), y, s, color);
}

lighten :: (c: Vector4, amount: float) -> Vector4 {
    result := c;
    result.x += (1 - c.x) * amount;
    result.y += (1 - c.y) * amount;
    result.z += (1 - c.z) * amount;
    return result;
}

thick_segment :: (config: *Config, a: Vector2, b: Vector2, thickness: float, color: Vector4) {
    half := thickness * .5;
    config.draw_line(Vector2.{ a.x, a.y - half }, Vector2.{ b.x, b.y - half }, Vector2.{ b.x, b.y + half }, Vector2.{ a.x, a.y + half }, color);
}

// Distinct, readable hues: step around the colour wheel by the golden angle.
make_graph_colors :: (config: *Config) {
    COUNT :: 24;
    colors := NewArray(COUNT, Vector4);
    hue := 0.1;
    for *colors {
        it.* = hue_to_rgb(hue);
        hue += 0.618034;
        if hue >= 1 hue -= 1;
    }
    config.graph_colors = colors;
}

hue_to_rgb :: (hue: float) -> Vector4 {
    channel :: (h: float) -> float {
        t := h - floor(h);
        v := abs(t * 6 - 3) - 1;
        return .35 + .6 * clamp(v, 0, 1);
    }
    return .{ channel(hue), channel(hue + 2.0 / 3.0), channel(hue + 1.0 / 3.0), 1 };
}

ignore_text :: (x: float, y: float, str: string, color: Vector4) {}
ignore_rectangle :: (x0: float, y0: float, x1: float, y1: float, color: Vector4) {}
ignore_quad :: (p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, color: Vector4) {}
ignore_region :: (x: float, y: float, width: float, height: float) {}
guess_text_width :: (s: string) -> float {
    return cast(float) s.count * 8;
}

#import "Basic";
#import "Math";
