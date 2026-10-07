// Per-thread immediate-mode state lives in the Context so queueing vertices is thread safe;
// the pointer stays null (and costs nothing) for threads that never draw.
Backend_Platform_Specific :: struct {
    software_target: *Bitmap;
    texture: *Texture;
    scissor_enabled: bool;
    scissor: Vector4;
    projection: Vector2;
    gradient_rect: Vector4;
    gradient_mode: u8;
    gradient_value: float;
}

Immediate_State :: struct {
    current_window_info: Window_Info;
    coordinate_system := Simp_Coordinate_System.RIGHT_HANDED;
    current_shader: *Shader;
    texture_render_target: *Texture;
    num_vertices: s32;
    MAX_VERTICES :: 2400;
    vertices: [MAX_VERTICES] Immediate_Vertex;
    specific: Backend_Platform_Specific;
}

// The vertex is deliberately wasteful (every shader reads what it needs and ignores the rest);
// fast rendering belongs to pre-baked meshes. The rect fields feed the rounded-rectangle shader.
Immediate_Vertex :: struct {
    position: Vector2;
    color_scale: Vector4;
    uv0: Vector2;
    rect_center: Vector2;
    rect_size: Vector2;
    rect_corner_radius: float;
    rect_edge_softness: float = 1.0;
}

#add_context simp: *Immediate_State;

// Allocates this thread's drawing state on first use. Public entry points run it, so programs
// never call an init procedure themselves.
CheckInit :: () #expand {
    if !context.simp per_thread_init();
}

per_thread_init :: () {
    context.simp = New(Immediate_State);
    shaders_set_defaults();
}

// Start of an immediate-mode batch; vertices are triangles, three at a time.
immediate_begin :: () {
    CheckInit();
}

// One triangle corner. The renderer is 2D: it uses position.x/.y and the uv; the normal is ignored.
immediate_vertex :: (position: Vector3, color_scale: Vector4, uv: Vector2 = .{}, normal: Vector3 = .{}) {
    vertex := reserve_vertices(1);
    put_vertex(vertex, .{ position.x, position.y }, color_scale, uv.x, uv.y);
}

immediate_reset :: () {
    CheckInit();
    context.simp.current_shader = null;
}

immediate_set_texture :: (texture: *Texture) {
    CheckInit();
    shader := context.simp.current_shader;
    if !shader {
        log_error("Attempted to immediate_set_texture when no shader was set.\n");
        return;
    }
    if context.simp.specific.texture != texture {
        immediate_flush();
        context.simp.specific.texture = texture;
    }
    #if render_api == .OPENGL {
        backend_set_texture(shader, texture);
    }
}

immediate_set_shader :: (s: *Shader) {
    CheckInit();
    if context.simp.current_shader && context.simp.current_shader != s immediate_flush();
    context.simp.current_shader = s;
    #if render_api == .OPENGL {
        gl_find_shader_locations(s);
    }
    backend_use_shader(s);
}

immediate_flush :: () {
    CheckInit();
    state := context.simp;
    if state.num_vertices == 0 return;
    assert(state.current_shader != null, "Tried to immediate_flush when no shader was set.");
    if !state.current_shader {
        state.num_vertices = 0;
        return;
    }
    #if render_api == .OPENGL {
        gl_submit(state);
    } else #if render_api == .SOFTWARE {
        software_submit(state);
    } else {
        assert(false, "Simp backend is unavailable");
    }
    state.num_vertices = 0;
}

put_vertex :: inline (using vertex: *Immediate_Vertex, p: Vector2, color: Vector4, u: float, v: float) {
    vertex.* = .{ position = p, color_scale = color, uv0 = .{ u, v } };
}

put_vertex :: inline (using vertex: *Immediate_Vertex, p: Vector3, color: Vector4, u: float, v: float) {
    vertex.* = .{ position = .{ p.x, p.y }, color_scale = color, uv0 = .{ u, v } };
}

put_vertex :: inline (using vertex: *Immediate_Vertex, p: Vector2, color: Vector4, center: Vector2, size: Vector2, radius: float, softness: float) {
    vertex.* = .{ position = p, color_scale = color, rect_center = center, rect_size = size, rect_corner_radius = radius, rect_edge_softness = softness };
}

// Rectangle given by opposite corners (x0, y0) and (x1, y1), drawn in one color.
immediate_quad :: (x0: float, y0: float, x1: float, y1: float, color: Vector4) {
    immediate_quad(.{ x0, y0 }, .{ x1, y0 }, .{ x1, y1 }, .{ x0, y1 }, color);
}

// Convex quad listed corner by corner in one color; the uvs default to covering the whole texture.
immediate_quad :: (p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, color := Vector4.{ 1, 1, 1, 1 }, uv0 := Vector2.{ 0, 0 }, uv1 := Vector2.{ 1, 0 }, uv2 := Vector2.{ 1, 1 }, uv3 := Vector2.{ 0, 1 }) {
    immediate_quad(p0, p1, p2, p3, color, color, color, color, uv0, uv1, uv2, uv3);
}

// As above, but each corner carries its own color, blended across the two triangles.
immediate_quad :: (p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, c0: Vector4, c1: Vector4, c2: Vector4, c3: Vector4, uv0 := Vector2.{ 0, 0 }, uv1 := Vector2.{ 1, 0 }, uv2 := Vector2.{ 1, 1 }, uv3 := Vector2.{ 0, 1 }) {
    first := reserve_vertices(6);
    points := Vector2.[p0, p1, p2, p0, p2, p3];
    colors := Vector4.[c0, c1, c2, c0, c2, c3];
    uvs := Vector2.[uv0, uv1, uv2, uv0, uv2, uv3];
    for i: 0..5 put_vertex(first + i, points[i], colors[i], uvs[i].x, uvs[i].y);
}

immediate_quad :: (x0: float, y0: float, x1: float, y1: float, c00: Vector4, c01: Vector4, c10: Vector4, c11: Vector4) {
    immediate_quad(.{ x0, y0 }, .{ x1, y0 }, .{ x1, y1 }, .{ x0, y1 }, c00, c10, c11, c01);
}

// Three-dimensional spellings of the quad. The renderer is 2D, so z, the normal and the tangent are accepted and dropped.
immediate_quad :: (p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, color: Vector4, uv0 := Vector2.{ 0, 0 }, uv1 := Vector2.{ 1, 0 }, uv2 := Vector2.{ 1, 1 }, uv3 := Vector2.{ 0, 1 }, normal := Vector3.{ z = 1 }) {
    immediate_quad(.{ p0.x, p0.y }, .{ p1.x, p1.y }, .{ p2.x, p2.y }, .{ p3.x, p3.y }, color, uv0, uv1, uv2, uv3);
}

immediate_quad :: (p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, color: Vector4, uv0: Vector2, uv1: Vector2, uv2: Vector2, uv3: Vector2, st0: Vector2, st1: Vector2, st2: Vector2, st3: Vector2, normal: Vector3, tangent: Vector4) {
    immediate_quad(.{ p0.x, p0.y }, .{ p1.x, p1.y }, .{ p2.x, p2.y }, .{ p3.x, p3.y }, color, uv0, uv1, uv2, uv3);
}

immediate_rounded_rect :: (p0: Vector2, p2: Vector2, color: Vector4, center: Vector2, size: Vector2, radius: float, softness := 1.0) {
    first := reserve_vertices(6);
    points := Vector2.[p0, .{ p2.x, p0.y }, p2, p0, p2, .{ p0.x, p2.y }];
    for i: 0..5 put_vertex(first + i, points[i], color, center, size, radius, softness);
}

immediate_triangle_fan :: (base: Vector2, points: [] Vector2, color: Vector4, base_color: Vector4) {
    if points.count < 2 return;
    for i: 1..points.count - 1 {
        first := reserve_vertices(3);
        put_vertex(first, base, base_color, 0, 0);
        put_vertex(first + 1, points[i - 1], color, 0, 0);
        put_vertex(first + 2, points[i], color, 0, 0);
    }
}

// One triangle with a color per corner.
immediate_triangle :: (p0: Vector3, p1: Vector3, p2: Vector3, c0: Vector4, c1: Vector4, c2: Vector4, uv0 := Vector2.{}, uv1 := Vector2.{}, uv2 := Vector2.{}, normal := Vector3.{ z = 1 }) {
    first := reserve_vertices(3);
    put_vertex(first, p0, c0, uv0.x, uv0.y);
    put_vertex(first + 1, p1, c1, uv1.x, uv1.y);
    put_vertex(first + 2, p2, c2, uv2.x, uv2.y);
}

// One triangle in a single color.
immediate_triangle :: (p0: Vector3, p1: Vector3, p2: Vector3, color := Vector4.{ 1, 1, 1, 1 }, uv0 := Vector2.{}, uv1 := Vector2.{}, uv2 := Vector2.{}, normal := Vector3.{ z = 1 }) {
    immediate_triangle(p0, p1, p2, color, color, color, uv0, uv1, uv2, normal);
}

// Sets the orthographic projection of the current shader for a render target of this size: the
// origin is the bottom-left corner for RIGHT_HANDED and the top-left corner for LEFT_HANDED.
immediate_set_2d_projection :: (render_target_width: s32, render_target_height: s32) {
    CheckInit();
    shader := context.simp.current_shader;
    if !shader {
        assert(false, "Tried to immediate_set_2d_projection when no shader was set.");
        context.simp.num_vertices = 0;
        return;
    }
    width := cast(float) render_target_width;
    height := cast(float) render_target_height;
    context.simp.specific.projection = .{ width, height };
    m: Matrix4 = ---;
    if context.simp.coordinate_system == .LEFT_HANDED m = orthographic_projection_matrix(0, width, height, 0, -1.0, 1.0);
    else m = orthographic_projection_matrix(0, width, 0, height, -1.0, 1.0);
    backend_tweak_projection_matrix(*m);
    set_parameter(shader, "projection", m);
}

immediate_letter_quad :: (using quad: Font_Quad, color: Vector4) {
    immediate_quad(quad.p0, quad.p1, quad.p2, quad.p3, color, .{ quad.u0, quad.v0 }, .{ quad.u1, quad.v0 }, .{ quad.u1, quad.v1 }, .{ quad.u0, quad.v1 });
}

#scope_module
immediate_vertex_pointer :: inline (index: s32) -> *Immediate_Vertex {
    return context.simp.vertices.data + index;
}

reserve_vertices :: (count: s32) -> *Immediate_Vertex {
    CheckInit();
    assert(count > 0 && count <= Immediate_State.MAX_VERTICES);
    if context.simp.num_vertices + count > Immediate_State.MAX_VERTICES immediate_flush();
    result := *context.simp.vertices[context.simp.num_vertices];
    context.simp.num_vertices += count;
    return result;
}

// Rendering to a texture stores the image top row first, so the projection flips vertically:
// negating the second row negates every clip-space y.
backend_tweak_projection_matrix :: (m: *Matrix4) {
    if !context.simp.texture_render_target return;
    for column: 0..3 m.coef[1][column] = -m.coef[1][column];
}

backend_use_shader :: (s: *Shader) {
    #if render_api == .OPENGL {
        gl_use_shader(s);
    }
}

software_submit :: (state: *Immediate_State) {
    target := state.specific.software_target;
    assert(target != null, "Install a bitmap render target before drawing");
    if !target return;
    assert(target.format == .RGBA8 || target.format == .BGRA8, "CPU render targets require RGBA8 or BGRA8");
    if target.format != .RGBA8 && target.format != .BGRA8 return;
    for i: 0..state.num_vertices / 3 - 1 software_triangle(state, target, state.vertices[i * 3], state.vertices[i * 3 + 1], state.vertices[i * 3 + 2]);
}

edge :: (a: Vector2, b: Vector2, p: Vector2) -> float {
    return (b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x);
}

software_triangle :: (state: *Immediate_State, target: *Bitmap, a: Immediate_Vertex, b: Immediate_Vertex, c: Immediate_Vertex) {
    area := edge(a.position, b.position, c.position);
    if area == 0 return;
    lo := min(a.position, min(b.position, c.position));
    hi := max(a.position, max(b.position, c.position));
    x0 := max(cast(int) floor(lo.x), 0);
    y0 := max(cast(int) floor(lo.y), 0);
    x1 := min(cast(int) ceil(hi.x), target.width);
    y1 := min(cast(int) ceil(hi.y), target.height);
    if state.specific.scissor_enabled {
        x0 = max(x0, cast(int) state.specific.scissor.x);
        y0 = max(y0, cast(int) state.specific.scissor.y);
        x1 = min(x1, cast(int) state.specific.scissor.z);
        y1 = min(y1, cast(int) state.specific.scissor.w);
    }
    for y: y0..y1 - 1 for x : x0..x1 - 1 {
        p := Vector2.{ cast(float) x + 0.5, cast(float) y + 0.5 };
        wa := edge(b.position, c.position, p) / area;
        wb := edge(c.position, a.position, p) / area;
        wc := 1 - wa - wb;
        if wa < 0 || wb < 0 || wc < 0 continue;
        // Half-open ownership of triangle edges prevents double alpha on shared diagonals.
        if wa == 0 && !owns_edge(b.position, c.position, area) continue;
        if wb == 0 && !owns_edge(c.position, a.position, area) continue;
        if wc == 0 && !owns_edge(a.position, b.position, area) continue;
        color := a.color_scale * wa + b.color_scale * wb + c.color_scale * wc;
        uv := a.uv0 * wa + b.uv0 * wb + c.uv0 * wc;
        sprite := state.current_shader == *shader_sprite_right_handed || state.current_shader == *shader_sprite_left_handed;
        if sprite || state.current_shader == *shader_text {
            // The right-handed sprite shader flips v, because bitmaps are stored top row first.
            if state.current_shader == *shader_sprite_right_handed uv.y = 1 - uv.y;
            sample := software_sample(state.specific.texture, uv);
            if sprite {
                color = color * sample;
                if color.w < 0.1 continue;
            } else color.w *= (sample.x + sample.y + sample.z) / 3;
        }
        if state.current_shader == *shader_rounded_rect {
            q := abs(p - a.rect_center) - a.rect_size + xy(a.rect_corner_radius);
            distance := length(max(q, xy(0))) + min(max(q.x, q.y), 0.0) - a.rect_corner_radius;
            soft := clamp(distance / max(a.rect_edge_softness, 0.001), 0.0, 1.0);
            color.w *= 1 - soft * soft * (3 - 2 * soft);
        }
        if state.current_shader == *shader_gradient color = software_gradient(state, p, color);
        pixel := target.data.data + software_row(y, target.height) * target.stride + x * 4;
        red: int = 0;
        blue: int = 2;
        if target.format == .BGRA8 {
            red = 2;
            blue = 0;
        }
        color = saturate(color);
        if state.current_shader.alpha_blend {
            inverse := 1 - color.w;
            color.x = color.x * color.w + cast(float) pixel[red] / 255 * inverse;
            color.y = color.y * color.w + cast(float) pixel[1] / 255 * inverse;
            color.z = color.z * color.w + cast(float) pixel[blue] / 255 * inverse;
            color.w += cast(float) pixel[3] / 255 * inverse;
        }
        pixel[red] = cast(u8) (color.x * 255 + 0.5);
        pixel[1] = cast(u8) (color.y * 255 + 0.5);
        pixel[blue] = cast(u8) (color.z * 255 + 0.5);
        pixel[3] = cast(u8) (color.w * 255 + 0.5);
    }
}

owns_edge :: (a: Vector2, b: Vector2, area: float) -> bool {
    if area < 0 return owns_edge(b, a, -area);
    return b.y > a.y || (b.y == a.y && b.x < a.x);
}

software_sample :: (texture: *Texture, uv: Vector2) -> Vector4 {
    bitmap := texture_bitmap(texture);
    if !bitmap || !bitmap.data.count return .{ 1, 1, 1, 1 };
    x := clamp(cast(int) floor(uv.x * bitmap.width), 0, bitmap.width - 1);
    y := clamp(cast(int) floor(uv.y * bitmap.height), 0, bitmap.height - 1);
    bpp := get_image_bytes_per_texel(bitmap.format);
    pixel := bitmap.data.data + y * bitmap.stride + x * bpp;
    if bitmap.format == .R8 return .{ cast(float) pixel[0] / 255, 0, 0, 1 };
    if bitmap.format == .RG8 return .{ cast(float) pixel[0] / 255, cast(float) pixel[1] / 255, 0, 1 };
    result := Vector4.{ cast(float) pixel[0] / 255, cast(float) pixel[1] / 255, cast(float) pixel[2] / 255, 1 };
    if bpp == 4 result.w = cast(float) pixel[3] / 255;
    if bitmap.format == .BGRA8 {
        tmp := result.x;
        result.x = result.z;
        result.z = tmp;
    }
    return result;
}

software_gradient :: (state: *Immediate_State, p: Vector2, color: Vector4) -> Vector4 {
    rect := state.specific.gradient_rect;
    u := clamp((p.x - rect.x) / max(rect.z, 0.001), 0.0, 1.0);
    v := clamp((p.y - rect.y) / max(rect.w, 0.001), 0.0, 1.0);
    mode := state.specific.gradient_mode;
    value := state.specific.gradient_value;
    rgb: Vector3;
    base := mode & 15;
    if mode < 16 {
        if base == 0 rgb = .{ value, u, v };
        if base == 1 rgb = .{ u, value, v };
        if base == 2 rgb = .{ u, v, value };
        if base == 3 rgb = hsl_color(value, u, v);
        if base == 4 rgb = hsl_color(u, value, v);
        if base == 5 rgb = hsl_color(u, v, value);
    } else {
        t := ifx mode & 32 then u else v;
        if base == 0 rgb = .{ t, 0, 0 };
        if base == 1 rgb = .{ 0, t, 0 };
        if base == 2 rgb = .{ 0, 0, t };
        if base == 3 rgb = hsl_color(t, 1, 0.5);
        if base == 4 rgb = hsl_color(value, t, 0.5);
        if base == 5 rgb = hsl_color(value, 1, t);
        if base == 6 rgb = .{ t, t, t };
    }
    return .{ rgb.x, rgb.y, rgb.z, color.w };
}

hsl_color :: (h: float, s: float, l: float) -> Vector3 {
    amplitude := s * min(l, 1 - l);
    result: Vector3;
    offsets := float.[0, 8, 4];
    for i: 0..2 {
        k := offsets[i] + h * 12;
        k -= floor(k / 12) * 12;
        channel := l - amplitude * max(-1.0, min(k - 3, min(9 - k, 1.0)));
        if i == 0 result.x = channel;
        if i == 1 result.y = channel;
        if i == 2 result.z = channel;
    }
    return result;
}
