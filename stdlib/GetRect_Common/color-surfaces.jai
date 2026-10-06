#scope_module
left_sv_surface :: (r: Rect, state: *Color_Picker_State, warp: bool) {
    center := xy(r.x + r.w / 2, r.y + r.h / 2);
    radius := min(r.w, r.h) / 2;
    if radius <= 0 return;
    draw_procs.set_shader_for_color(true);
    if warp {
        for radial: 0..7 for angular : 0..31 {
            a := angular * 2 * PI / 32;
            b := (angular + 1) * 2 * PI / 32;
            near := cast(float) radial / 8;
            far := cast(float) (radial + 1) / 8;
            q0 := xy(cos(a), sin(a)) * near;
            q1 := xy(cos(a), sin(a)) * far;
            q2 := xy(cos(b), sin(b)) * far;
            q3 := xy(cos(b), sin(b)) * near;
            p0 := left_sv_point(r, q0, true);
            p1 := left_sv_point(r, q1, true);
            p2 := left_sv_point(r, q2, true);
            p3 := left_sv_point(r, q3, true);
            c0 := left_sv_color(state, q0, true);
            c1 := left_sv_color(state, q1, true);
            c2 := left_sv_color(state, q2, true);
            c3 := left_sv_color(state, q3, true);
            draw_procs.immediate_triangle(to_vec3(p0), to_vec3(p1), to_vec3(p2), c0, c1, c2);
            draw_procs.immediate_triangle(to_vec3(p0), to_vec3(p2), to_vec3(p3), c0, c2, c3);
        }
    } else {
        for y: 0..15 for x : 0..15 {
            p0 := xy(r.x + r.w * x / 16, r.y + r.h * y / 16);
            p1 := xy(r.x + r.w * (x + 1) / 16, p0.y);
            p2 := xy(p1.x, r.y + r.h * (y + 1) / 16);
            p3 := xy(p0.x, p2.y);
            dy := ifx GETRECT_Y_UP then -0.125 else 0.125;
            q0 := xy(cast(float) x / 8 - 1, ifx GETRECT_Y_UP then 1 - cast(float) y / 8 else cast(float) y / 8 - 1);
            q1 := q0 + xy(0.125, 0);
            q2 := q0 + xy(0.125, dy);
            q3 := q0 + xy(0, dy);
            c0 := left_sv_color(state, q0, false);
            c1 := left_sv_color(state, q1, false);
            c2 := left_sv_color(state, q2, false);
            c3 := left_sv_color(state, q3, false);
            draw_procs.immediate_triangle(to_vec3(p0), to_vec3(p1), to_vec3(p2), c0, c1, c2);
            draw_procs.immediate_triangle(to_vec3(p0), to_vec3(p2), to_vec3(p3), c0, c2, c3);
        }
    }
    marker := state.disc_point;
    if !warp marker = .{ state.current_hsv_color.y * 2 - 1, 1 - state.current_hsv_color.z * 2 };
    point := left_sv_point(r, marker, warp);
    left_color_fill(.{ point.x - 3, point.y - 3, 6, 6 }, .{ 0, 0, 0, 1 });
    left_color_fill(.{ point.x - 2, point.y - 2, 4, 4 }, .{ 1, 1, 1, 1 });
}
left_sv_color :: (state: *Color_Picker_State, point: Vector2, warp: bool) -> Vector4 {
    q := left_disc_square(point, warp);
    return hsv_to_argb(.{ state.current_hsv_color.x, (q.x + 1) / 2, (1 - q.y) / 2 });
}
left_sv_drag :: (r: Rect, state: *Color_Picker_State, warp: bool) {
    center := xy(r.x + r.w / 2, r.y + r.h / 2);
    radius := min(r.w, r.h) / 2;
    if radius <= 0 return;
    point := left_sv_normalized(r, xy(mouse_x_float, mouse_y_float), warp);
    q := left_disc_square(point, warp);
    hsv := state.current_hsv_color;
    hsv.y = clamp((q.x + 1) / 2, 0.0, 1.0);
    hsv.z = clamp((1 - q.y) / 2, 0.0, 1.0);
    set_current_color_hsv(state, hsv, false);
}
// Saturation/value surface <-> screen mapping; y-up modules use the pure helpers in orientation.jai.
left_sv_point :: (r: Rect, q: Vector2, warp: bool) -> Vector2 {
    if GETRECT_Y_UP return right_sv_point(r, q, warp);
    if warp {
        center := xy(r.x + r.w / 2, r.y + r.h / 2);
        return center + q * (min(r.w, r.h) / 2);
    }
    return xy(r.x + (q.x + 1) * r.w / 2, r.y + (q.y + 1) * r.h / 2);
}
left_sv_normalized :: (r: Rect, point: Vector2, warp: bool) -> Vector2 {
    if GETRECT_Y_UP return right_sv_normalized(r, point, warp);
    if warp {
        center := xy(r.x + r.w / 2, r.y + r.h / 2);
        return (point - center) / (min(r.w, r.h) / 2);
    }
    return xy((point.x - r.x) * 2 / max(r.w, 1.0) - 1, (point.y - r.y) * 2 / max(r.h, 1.0) - 1);
}
