#import "Basic";
S :: #import "Simp";
GL :: #import "GL";

probe :: #library "window_gl_probe";
begin_context :: () -> *void #foreign probe "window_gl_probe_begin";
end_context :: (context: *void) #foreign probe "window_gl_probe_end";

main :: () {
    native := begin_context();

    assert(native != null);
    defer end_context(native);
    source := "OUT_IN vec4 color;\n#ifdef VERTEX_SHADER\nvoid main(){gl_Position=vec4(0,0,0,1);color=vec4(1);}\n#endif\n#ifdef FRAGMENT_SHADER\nout vec4 result;\nvoid main(){result=color;}\n#endif\n";
    program := S.get_shader_program(source);

    assert(program != 0);
    defer GL.gl.glDeleteProgram(program);
    linked: s32;

    GL.gl.glGetProgramiv(program, GL.GL_LINK_STATUS, *linked);
    assert(linked != 0);
    assert(GL.gl.glGetError() == GL.GL_NO_ERROR);
    print("ok\n");
}
