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

set_shader_for_color :: (enable_blend := false, $extra_draw_info := Extra_Draw_Info.{}) {
    CheckInit();
    shader := ifx enable_blend then *shader_color_with_blend else *shader_color;
    if context.simp.current_shader != shader {
        immediate_set_shader(shader);
        set_projection();
    }
}
set_shader_for_text :: () {
    CheckInit();
    if context.simp.current_shader != *shader_text {
        immediate_set_shader(*shader_text);
        set_projection();
    }
}
// The texture is drawn with the quad's uv coordinates; (0,0) is the lower-left corner of the image
// in the right-handed system and the upper-left corner in the left-handed one.
set_shader_for_images :: (texture: *Texture) {
    CheckInit();
    immediate_flush();
    target := ifx context.simp.coordinate_system == .LEFT_HANDED then *shader_sprite_left_handed else *shader_sprite_right_handed;
    if context.simp.current_shader != target {
        immediate_set_shader(target);
        set_projection();
    }
    immediate_set_texture(texture);
}
// Rounded rectangles: see immediate_rounded_rect.
set_shader_for_rects :: ($extra_draw_info := Extra_Draw_Info.{}) {
    CheckInit();
    if context.simp.current_shader != *shader_rounded_rect {
        immediate_set_shader(*shader_rounded_rect);
        set_projection();
    }
}
// A color field over `rect` (x, y, width, height). `mode` picks the channels (0..5 for the plane
// varying two channels with the third fixed at `value`; 16+ for a single ramp, +32 for horizontal).
set_shader_for_gradient :: (rect: Vector4, mode: u8, value: float) {
    CheckInit(); immediate_flush();
    context.simp.specific.gradient_rect = rect;
    context.simp.specific.gradient_mode = mode;
    context.simp.specific.gradient_value = value;
    if context.simp.current_shader != *shader_gradient {
        immediate_set_shader(*shader_gradient);
        set_projection();
    }
    #if render_api == .OPENGL { gl_set_gradient(rect, mode, value); }
}
// Installs the projection of the current render target on the current shader.
set_projection :: () {
    CheckInit();
    t := context.simp.texture_render_target;
    if t {
        immediate_set_2d_projection(t.width, t.height);
    } else {
        c := *context.simp.current_window_info;
        immediate_set_2d_projection(c.window_width, c.window_height);
    }
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
// Blend state of the built-in shaders; the CPU backend reads it too.
shaders_set_defaults :: () {
    shader_color_with_blend.alpha_blend = true;
    shader_text.alpha_blend = true;
    shader_sprite_right_handed.alpha_blend = true;
    shader_sprite_left_handed.alpha_blend = true;
    shader_rounded_rect.alpha_blend = true;
}
