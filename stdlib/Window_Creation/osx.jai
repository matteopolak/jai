// macOS windows through AppKit.
#import "Objective_C" ;
#import "Objective_C/AppKit" ;
#import "Objective_C/LightweightRenderingView" ;
#scope_export
application_initialized := false ;
init_mac_app :: ( ) {
    if application_initialized return;
    // Referencing a symbol of the framework makes the linker/loader bring AppKit in before any class lookup.
    app_kit_anchor := NSApplicationMain;
    if app_kit_anchor == null return;
    init_objective_c();
    init_objective_c_foundation();
    init_app_kit();
    application := NSApplication.sharedApplication();
    if !application return;
    NSApplication.setActivationPolicy(application, .NSApplicationActivationPolicyRegular);
    if macos_create_app_delegate_exists() {
        info := cast(*Type_Info_Struct) type_info(#Context);
        _, offset := get_field_with_offset(info, "_macos_create_app_delegate");
        slot := cast(**void) (cast(*u8) *context+offset);
        factory: () -> *NSApplicationDelegate;
        factory = cast(type_of(factory)) slot.*;
        if factory NSApplication.setDelegate(application, factory());
    }
    NSApplication.finishLaunching(application);
    NSApplication.activateIgnoringOtherApps(application, YES);
    application_initialized = true;
}
create_window :: ( width : int , height : int , window_name : string , window_x := - 1 , window_y := - 1 , parent : Window_Type = null , background_color_rgb := DEFAULT_WINDOW_CREATION_COLOR , wanted_msaa := DEFAULT_MSAA ) -> * NSWindow {
    if width <= 0 || height <= 0 return null;
    init_mac_app();
    if !application_initialized return null;
    screen := NSScreen.mainScreen();
    if !screen return null;
    scale := NSScreen.backingScaleFactor(screen);
    if scale <= 0 scale = 1;
    rect: NSRect;
    rect.size.width = cast(CGFloat) width/scale;
    rect.size.height = cast(CGFloat) height/scale;
    if window_x != -1 rect.origin.x = cast(CGFloat) window_x/scale;
    if window_y != -1 rect.origin.y = cast(CGFloat) window_y/scale;
    style := NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
    window := NSWindow.initWithContentRect(objc_alloc(NSWindow), rect, style, NSBackingStoreBuffered, NO);
    if !window return null;
    NSWindow.setReleasedWhenClosed(window, NO);
    NSWindow.setTitle(window, window_name);
    color_factory: (receiver: *void, selector: SEL, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> *NSColor #c_call;
    color_factory = cast(type_of(color_factory)) objc_msgSend;
    color := color_factory(cast(*void) class(NSColor), sel_registerName("colorWithCalibratedRed:green:blue:alpha:"),
        cast(CGFloat) clamp(background_color_rgb[0],0.0,1.0), cast(CGFloat) clamp(background_color_rgb[1],0.0,1.0),
        cast(CGFloat) clamp(background_color_rgb[2],0.0,1.0), 1.0);
    NSWindow.setBackgroundColor(window, color);
    attributes: [14] NSOpenGLPixelFormatAttribute = .[NSOpenGLPFADoubleBuffer, NSOpenGLPFAColorSize, 24,
        NSOpenGLPFAAlphaSize, 8, NSOpenGLPFADepthSize, 24, NSOpenGLPFAStencilSize, 8,
        NSOpenGLPFASampleBuffers, 1, NSOpenGLPFASamples, cast(u32) max(wanted_msaa,1), 0];
    if wanted_msaa <= 1 attributes[9] = 0;
    format := NSOpenGLPixelFormat.initWithAttributes(objc_alloc(NSOpenGLPixelFormat), attributes.data);
    if !format && wanted_msaa > 1 {
        attributes[9] = 0;
        format = NSOpenGLPixelFormat.initWithAttributes(objc_alloc(NSOpenGLPixelFormat), attributes.data);
    }
    if !format { release(window); return null; }
    defer release(format);
    view_init: (receiver: *void, selector: SEL, frame: NSRect, pixel_format: *NSOpenGLPixelFormat) -> *LightweightOpenGLView #c_call;
    view_init = cast(type_of(view_init)) objc_msgSend;
    view_rect := rect;
    view_rect.origin = .{};
    view := view_init(cast(*void) objc_alloc(LightweightOpenGLView),
        sel_registerName("initWithFrame:pixelFormat:"), view_rect, format);
    if !view { release(window); return null; }
    NSView.setWantsBestResolutionOpenGLSurface(view, YES);
    NSWindow.setContentView(window, view);
    NSWindow.makeFirstResponder(window, view);
    release(view);
    if macos_create_window_delegate_exists() {
        info := cast(*Type_Info_Struct) type_info(#Context);
        _, offset := get_field_with_offset(info, "_macos_create_window_delegate");
        factory: () -> id;
        factory = cast(type_of(factory)) (cast(**void) (cast(*u8) *context+offset)).*;
        if factory NSWindow.setDelegate(window, factory());
    }
    if parent {
        attach: (receiver: *void, selector: SEL, child: *NSWindow, ordering: NSInteger) #c_call;
        attach = cast(type_of(attach)) objc_msgSend;
        attach(cast(*void) parent, sel_registerName("addChildWindow:ordered:"), window, 1);
    }
    if window_x == -1 || window_y == -1 NSWindow.center(window);
    NSWindow.makeKeyAndOrderFront(window, null);
    return window;
}
swap_view_buffers :: ( win : * NSWindow ) {
    if !win return;
    render_view := NSWindow.contentView(win);
    if render_view LightweightRenderingView.swapBuffers(render_view);
}
get_dimensions :: ( window : * NSWindow , right_handed : bool ) -> ( x : s32 , y : s32 , width : s32 , height : s32 , success := true ) {
    if !window return 0, 0, 0, 0, false;
    view := NSWindow.contentView(window);
    if !view return 0, 0, 0, 0, false;
    area := NSView.convertRectToBacking(view, NSView.frame(view));
    bottom := area.origin.y;
    if right_handed bottom += area.size.height;
    return cast(s32) area.origin.x, cast(s32) bottom, cast(s32) area.size.width, cast(s32) area.size.height, true;
}
Saved_Window_Info :: struct {
    mask : NSWindowStyleMask ;
    window_frame : NSRect ;
}
toggle_fullscreen :: ( win : * NSWindow , desire_fullscreen : bool , saved : * Saved_Window_Info ) -> success : bool , width : s32 , height : s32 {
    if !win || !saved return false, 0, 0;
    if desire_fullscreen {
        screen := NSWindow.screen(win);
        if !screen screen = NSScreen.mainScreen();
        if !screen return false, 0, 0;
        saved.mask = NSWindow.styleMask(win);
        saved.window_frame = NSWindow.frame(win);
        NSWindow.setStyleMask(win, NSWindowStyleMaskBorderless);
        NSWindow.setFrame(win, NSScreen.frame(screen), YES);
    } else {
        NSWindow.setStyleMask(win, saved.mask);
        NSWindow.setFrame(win, saved.window_frame, YES);
    }
    _, _, measured_width, measured_height, measured_ok := get_dimensions(win, false);
    return measured_ok, measured_width, measured_height;
}
get_mouse_pointer_position :: ( window : * NSWindow , right_handed : bool ) -> x : int , y : int , success : bool {
    if !window return 0, 0, false;
    view := NSWindow.contentView(window);
    if !view return 0, 0, false;
    point := NSView.convertPointToBacking(view, NSWindow.mouseLocationOutsideOfEventStream(window));
    if !right_handed {
        area := NSView.convertRectToBacking(view, NSView.frame(view));
        point.y = area.size.height - point.y;
    }
    return cast(int) point.x, cast(int) point.y, true;
}
get_mouse_pointer_position :: ( right_handed := false ) -> x : int , y : int , success : bool {
    if !NSApp return 0, 0, false;
    focused := NSApplication.keyWindow(NSApp);
    return get_mouse_pointer_position(focused, right_handed);
}
#scope_file
macos_create_app_delegate_exists :: ( ) -> bool {
    info := cast(*Type_Info_Struct) type_info(#Context);
    member, offset := get_field_with_offset(info, "_macos_create_app_delegate");
    return member != null && offset >= 0;
}
macos_create_window_delegate_exists :: ( ) -> bool {
    info := cast(*Type_Info_Struct) type_info(#Context);
    member, offset := get_field_with_offset(info, "_macos_create_window_delegate");
    return member != null && offset >= 0;
}
