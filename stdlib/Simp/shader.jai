// Shader handle plus the vertex attribute locations the immediate renderer feeds.
// `*_loc` is -1 for an attribute the shader does not declare.
Shader_Platform :: struct {
    gl_handle: GLuint;
    position_loc: GLint = -1;
    color_scale_loc: GLint = -1;
    normal_loc: GLint = -1;
    tangent_loc: GLint = -1;
    uv_0_loc: GLint = -1;
    uv_1_loc: GLint = -1;
    rect_center_loc: GLint = -1;
    rect_size_loc: GLint = -1;
    rect_corner_radius_loc: GLint = -1;
    rect_edge_softness_loc: GLint = -1;
    diffuse_texture_loc: GLint = -1;
    alpha_blend := false;
}
Shader :: struct { using platform: Shader_Platform; }
Extra_Draw_Info :: struct { is_background := false; is_translucent_on_the_right := false; }
shader_text: Shader;
shader_color: Shader;
shader_color_with_blend: Shader;
shader_sprite_right_handed: Shader;
shader_sprite_left_handed: Shader;
shader_rounded_rect: Shader;
shader_gradient: Shader;

// Flat-colored triangles; `enable_blend` composites with the destination using the vertex alpha.
set_shader_for_color :: (enable_blend := false, $extra_draw_info := Extra_Draw_Info.{}) {
    bind_builtin_shader(ifx enable_blend then *shader_color_with_blend else *shader_color);
}
// Glyph quads: the bound texture is a coverage mask that scales the vertex color's alpha.
set_shader_for_text :: () {
    bind_builtin_shader(*shader_text);
}
// Textured quads modulated by the vertex color. Which corner the uv origin lands on follows the
// coordinate system: bottom-left when right-handed, top-left when left-handed.
set_shader_for_images :: (texture: *Texture) {
    CheckInit();
    sprite := *shader_sprite_right_handed;
    if context.simp.coordinate_system == .LEFT_HANDED sprite = *shader_sprite_left_handed;
    // Vertices already queued were meant for the previous image even when the program stays.
    immediate_flush();
    bind_builtin_shader(sprite);
    immediate_set_texture(texture);
}
// Rounded rectangles: see immediate_rounded_rect.
set_shader_for_rects :: ($extra_draw_info := Extra_Draw_Info.{}) {
    bind_builtin_shader(*shader_rounded_rect);
}
// A color field over `rect` (x, y, width, height). `mode` picks the channels (0..5 for the plane
// varying two channels with the third fixed at `value`; 16+ for a single ramp, +32 for horizontal).
set_shader_for_gradient :: (rect: Vector4, mode: u8, value: float) {
    CheckInit(); immediate_flush();
    context.simp.specific.gradient_rect = rect;
    context.simp.specific.gradient_mode = mode;
    context.simp.specific.gradient_value = value;
    bind_builtin_shader(*shader_gradient);
    #if render_api == .OPENGL { gl_set_gradient(rect, mode, value); }
}
// Pushes the pixel-space projection for whatever is being drawn into (a texture target or the
// current window) to the bound shader. Needed again after the target changes size.
set_projection :: () {
    CheckInit();
    width, height := render_target_extent();
    immediate_set_2d_projection(width, height);
}
// Uniforms of the shader that is currently in use. With the CPU backend they are ignored.
set_parameter :: (shader: *Shader, name: string, m: Matrix4) {
    #if render_api == .OPENGL {
        location := get_uniform_location(shader.gl_handle, name);
        if location < 0 log_error("Unknown parameter: '%'\n", name);
        else gl_api.glUniformMatrix4fv(location, 1, true, *m._11);
    }
}
set_parameter :: (shader: *Shader, name: *u8, m: Matrix4) { set_parameter(shader, to_string(name), m); }
set_parameter :: (shader: *Shader, name: string, v: Vector4) {
    #if render_api == .OPENGL {
        location := get_uniform_location(shader.gl_handle, name);
        if location < 0 log_error("Unknown parameter: '%'\n", name);
        else gl_api.glUniform4f(location, v.x, v.y, v.z, v.w);
    }
}
set_parameter :: (shader: *Shader, name: string, value: float) {
    #if render_api == .OPENGL {
        location := get_uniform_location(shader.gl_handle, name);
        if location < 0 log_error("Unknown parameter: '%'\n", name);
        else gl_api.glUniform1f(location, value);
    }
}
set_parameter :: (shader: *Shader, name: string, value: s32) {
    #if render_api == .OPENGL {
        location := get_uniform_location(shader.gl_handle, name);
        if location < 0 log_error("Unknown parameter: '%'\n", name);
        else gl_api.glUniform1i(location, value);
    }
}
get_uniform_location :: (gl_handle: GLuint, name: string) -> GLint {
    #if render_api == .OPENGL {
        if !gl_api return -1;
        return gl_api.glGetUniformLocation(gl_handle, temp_c_string(name));
    }
    return -1;
}
#scope_module
// Rebinding the program that is already active would flush and redo the projection for nothing.
bind_builtin_shader :: (program: *Shader) {
    CheckInit();
    if context.simp.current_shader == program return;
    immediate_set_shader(program);
    set_projection();   // A newly bound program has not seen this target's projection.
}
render_target_extent :: () -> s32, s32 {
    texture := context.simp.texture_render_target;
    if texture return texture.width, texture.height;
    window := *context.simp.current_window_info;
    return window.window_width, window.window_height;
}
#scope_export
// Blend state of the built-in shaders; the CPU backend reads it too.
shaders_set_defaults :: () {
    shader_color_with_blend.alpha_blend = true;
    shader_text.alpha_blend = true;
    shader_sprite_right_handed.alpha_blend = true;
    shader_sprite_left_handed.alpha_blend = true;
    shader_rounded_rect.alpha_blend = true;
}
