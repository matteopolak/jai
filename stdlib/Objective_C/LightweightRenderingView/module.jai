// An NSView subclass for drawing with a GPU API inside an AppKit window.
#import "Objective_C";
#import "Objective_C/AppKit";
LightweightRenderingView :: struct {
    #as using nsview: NSView;
    swapBuffers :: (self: *void) {
        get_context: (sdk_receiver: *void, sdk_selector: SEL) -> *NSOpenGLContext #c_call;
        get_context = cast(type_of(get_context)) objc_msgSend;
        glc := get_context(self, sel_registerName(cast(*u8) "openGLContext\0"));
        flush: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        flush = cast(type_of(flush)) objc_msgSend;
        flush(cast(*void) glc, sel_registerName(cast(*u8) "flushBuffer\0"));
    }
}
LightweightOpenGLView :: struct {
    #as using lightweightrenderingview: LightweightRenderingView;
    glContext :: (self: *LightweightOpenGLView) -> *NSOpenGLContext {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSOpenGLContext #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "openGLContext\0"));
    }
    setGlContext :: (self: *LightweightOpenGLView, glc: *NSOpenGLContext) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, value: *NSOpenGLContext) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setOpenGLContext:\0"), glc);
    }
}
LightweightMetalView :: struct {
    using lightweightrenderingview: LightweightRenderingView;
}
init_lightweight_rendering_view :: () {
    _sel.glContext = cast(Selector) sel_registerName(cast(*u8) "glContext\0");
    _sel.setGlContext_ = cast(Selector) sel_registerName(cast(*u8) "setGlContext:\0");
    _sel.swapBuffers = cast(Selector) sel_registerName(cast(*u8) "swapBuffers\0");
}
#scope_file
_sel: struct {
    swapBuffers: Selector;
    setGlContext_: Selector;
    glContext: Selector;
}
QuartzCore :: #system_library "QuartzCore";
