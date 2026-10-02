// Independently normalized ABI contract. No reference procedure bodies or binaries.
#import "X11" ;
window_minimized := false ;
Saved_Window_Info :: struct {
}
toggle_fullscreen :: ( win : Window , desire_fullscreen : bool , saved : * Saved_Window_Info ) -> success : bool , width : s32 , height : s32 {
    display := x_global_display;
    if !display || !win || !x_global_net_wm_state || !x_global_net_wm_state_fullscreen return false, 0, 0;
    request: XEvent;
    request.xclient.type = ClientMessage;
    request.xclient.window = win;
    request.xclient.message_type = x_global_net_wm_state;
    request.xclient.format = 32;
    request.xclient.data.l[0] = _NET_WM_STATE_REMOVE;
    if desire_fullscreen request.xclient.data.l[0] = _NET_WM_STATE_ADD;
    request.xclient.data.l[1] = cast(s64) x_global_net_wm_state_fullscreen;
    request.xclient.data.l[3] = 1;
    accepted := XSendEvent(display, XDefaultRootWindow(display), False, SubstructureNotifyMask | SubstructureRedirectMask, *request);
    XSync(display, False);
    _, _, measured_width, measured_height, measured := get_dimensions(win, false);
    return accepted != 0 && measured, measured_width, measured_height;
}
create_window :: ( width : int , height : int , window_name : string , window_x := 0 , window_y := 0 , parent : Window_Type = None , background_color_rgb := DEFAULT_WINDOW_CREATION_COLOR , wanted_msaa : s32 = DEFAULT_MSAA ) -> Window {
    if width <= 0 || height <= 0 || width > 0x7fffffff || height > 0x7fffffff return None;
    init_global_display();
    display := x_global_display;
    if !display return None;
    XLockDisplay(display);
    defer XUnlockDisplay(display);
    attributes: [21] s32 = .[GLX_RGBA, GLX_DOUBLEBUFFER, GLX_RED_SIZE, 8, GLX_GREEN_SIZE, 8,
        GLX_BLUE_SIZE, 8, GLX_ALPHA_SIZE, 8, GLX_DEPTH_SIZE, 24, GLX_STENCIL_SIZE, 8,
        GLX_SAMPLE_BUFFERS, 1, GLX_SAMPLES, wanted_msaa, 0, 0, 0];
    if wanted_msaa <= 1 attributes[14] = 0;
    visual := glXChooseVisual(display, XDefaultScreen(display), attributes.data);
    if !visual && wanted_msaa > 1 {
        attributes[14] = 0;
        visual = glXChooseVisual(display, XDefaultScreen(display), attributes.data);
    }
    if !visual return None;
    defer XFree(visual);
    root := XDefaultRootWindow(display);
    owner := root;
    if parent != None owner = parent;
    settings: XSetWindowAttributes;
    settings.colormap = XCreateColormap(display, root, visual.visual, AllocNone);
    settings.event_mask = ExposureMask | StructureNotifyMask | KeyPressMask | KeyReleaseMask |
        ButtonPressMask | ButtonReleaseMask | PointerMotionMask | FocusChangeMask;
    rgb: [3] u8;
    for channel: 0..2 rgb[channel] = cast(u8) (clamp(background_color_rgb[channel], 0.0, 1.0)*255.0+0.5);
    settings.background_pixel = x_color_to_pixel(display, settings.colormap, x_rgb_to_color(rgb[0], rgb[1], rgb[2]));
    handle := XCreateWindow(display, owner, cast(s32) window_x, cast(s32) window_y,
        cast(u32) width, cast(u32) height, 0, visual.depth, InputOutput, visual.visual,
        CWColormap | CWEventMask | (1 << 1), *settings);
    if !handle { XFreeColormap(display, settings.colormap); return None; }
    title := to_c_string(window_name);
    if title { XStoreName(display, handle, title); free(title); }
    XSetWMProtocols(display, handle, *x_global_wm_delete_window, 1);
    if parent != None XSetTransientForHint(display, handle, parent);
    array_add(*x_global_windows, handle);
    XMapWindow(display, handle);
    XFlush(display);
    return handle;
}
get_dimensions :: ( win : Window , right_handed : bool ) -> ( x : s32 , y : s32 , width : s32 , height : s32 , success := true ) {
    if !x_global_display || !win return 0, 0, 0, 0, false;
    attributes: XWindowAttributes;
    if XGetWindowAttributes(x_global_display, win, *attributes) == 0 return 0, 0, 0, 0, false;
    origin_y := attributes.y;
    if right_handed origin_y += attributes.height;
    return attributes.x, origin_y, attributes.width, attributes.height, true;
}
get_mouse_pointer_position :: ( dpy : * Display , win : Window , right_handed : bool ) -> x : int , y : int , success : bool {
    if !dpy || !win return 0, 0, false;
    root, child: Window;
    screen_x, screen_y, local_x, local_y: s32;
    keys: u32;
    if XQueryPointer(dpy, win, *root, *child, *screen_x, *screen_y, *local_x, *local_y, *keys) == False return 0, 0, false;
    if right_handed {
        geometry: XWindowAttributes;
        if XGetWindowAttributes(dpy, win, *geometry) == 0 return local_x, local_y, false;
        local_y = geometry.height - local_y;
    }
    return local_x, local_y, true;
}
get_mouse_pointer_position :: ( win : Window , right_handed : bool ) -> x : int , y : int , success : bool {
    return get_mouse_pointer_position(x_global_display, win, right_handed);
}
get_mouse_pointer_position :: ( right_handed := false ) -> x : int , y : int , success : bool {
    if !x_global_display return 0, 0, false;
    focused: Window;
    mode: s32;
    XGetInputFocus(x_global_display, *focused, *mode);
    return get_mouse_pointer_position(x_global_display, focused, right_handed);
}
