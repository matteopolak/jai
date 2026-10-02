Shader_Platform :: struct {
    gl_handle: GLuint;
    position_loc: GLint = -1;
    color_scale_loc: GLint = -1;
    uv_0_loc: GLint = -1;
    rect_center_loc: GLint = -1;
    rect_size_loc: GLint = -1;
    rect_corner_radius_loc: GLint = -1;
    rect_edge_softness_loc: GLint = -1;
    alpha_blend := false;
}
Shader :: struct { using platform: Shader_Platform; }
Extra_Draw_Info :: struct { is_background := false; is_translucent_on_the_right := false; }
shader_sprite: Shader;
shader_text_lcd: Shader;
shader_text_normal: Shader;
shader_color: Shader;
shader_color_with_blend: Shader;
shader_rounded_rect: Shader;
shader_gradient: Shader;
set_shader_for_color :: (enable_blend := false, $extra_draw_info := Extra_Draw_Info.{}) {
    CheckInit();
    shader_color_with_blend.alpha_blend = true;
    immediate_set_shader(ifx enable_blend then *shader_color_with_blend else *shader_color);
    set_projection();
}
set_shader_for_images :: (texture: *Texture) {
    shader_sprite.alpha_blend = true;
    immediate_set_shader(*shader_sprite); immediate_set_texture(texture); set_projection();
}
set_shader_for_text :: () {
    shader_text_lcd.alpha_blend = true; shader_text_normal.alpha_blend = true;
    immediate_set_shader(ifx font_anti_aliasing == .lcd then *shader_text_lcd else *shader_text_normal);
    set_projection();
}
set_shader_for_rects :: ($extra_draw_info := Extra_Draw_Info.{}) {
    shader_rounded_rect.alpha_blend = true;
    immediate_set_shader(*shader_rounded_rect); set_projection();
}
set_shader_for_gradient :: (rect: Vector4, mode: u8, value: float) {
    CheckInit(); immediate_set_shader(*shader_gradient);
    context.simp.specific.gradient_rect = rect;
    context.simp.specific.gradient_mode = mode;
    context.simp.specific.gradient_value = value;
    set_projection();
    #if render_api == .OPENGL { gl_set_gradient(rect, mode, value); }
}
set_projection :: () {
    CheckInit(); s := context.simp;
    if s.texture_render_target immediate_set_2d_projection(s.texture_render_target.width, s.texture_render_target.height);
    else immediate_set_2d_projection(s.current_window_info.window_width, s.current_window_info.window_height);
}
set_parameter :: (shader: *Shader, name: string, m: Matrix4) {
    #if render_api == .OPENGL {
        location := get_uniform_location(shader.gl_handle, name);
        if location >= 0 gl_api.glUniformMatrix4fv(location, 1, false, *m._11);
    } else { assert(false, "Custom shader parameters require OpenGL"); }
}
get_uniform_location :: (gl_handle: GLuint, name: string) -> GLint {
    #if render_api == .OPENGL {
        assert(gl_api != null, "Initialize the Simp OpenGL renderer first");
        if !gl_api return -1;
        return gl_api.glGetUniformLocation(gl_handle, temp_c_string(name));
    }
    return -1;
}
