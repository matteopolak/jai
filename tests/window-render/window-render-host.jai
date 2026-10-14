#import "Basic";
W :: #import "Window_Creation";
I :: #import "Input";
S :: #import "Simp";
GL :: #import "GL";
O :: #import "Objective_C";

main :: () {
    window := W.create_window(320, 200, "Production public render test", 40, 200);

    assert(window != W.WT.INVALID_WINDOW);
    I.update_window_events();
    actual := S.prepare_window(window, 0);

    assert(actual == 0);
    S.set_render_target(window);
    width, height := S.get_render_dimensions(window);

    assert(width == 320 && height == 200);
    S.clear_render_target(0, 0, 0, 1);
    S.set_shader_for_color();
    S.immediate_begin();
    S.immediate_quad(0, 0, 40, 40, .{ 0, 1, 0, 1 });
    S.immediate_flush();
    pixel: [4] u8;

    GL.gl.glReadPixels(4, 4, 1, 1, GL.GL_RGBA, GL.GL_UNSIGNED_BYTE, pixel.data);
    assert(pixel[0] == 0 && pixel[1] == 255 && pixel[2] == 0 && pixel[3] == 255);
    S.swap_buffers(window, false);
    objc :: #library,system "objc";
    message :: () #foreign objc "objc_msgSend";
    Close :: #type (receiver: *void, selector: O.Selector) #c_call;
    close := cast(Close) message;

    close(window, O.selector("close"));
    O.release(window);
    print("ok\n");
}
