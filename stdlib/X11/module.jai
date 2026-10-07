// Xlib, GLX and XInput declarations.
x_global_display: *Display;
x_global_input_method: XIM;
x_global_input_context: XIC;
x_global_wm_delete_window: Atom;
x_global_wm_protocols: Atom;
x_global_net_wm_demands_attention: Atom;
x_global_net_wm_state: Atom;
x_global_net_wm_state_fullscreen: Atom;
x_global_xa_clipboard: Atom;
x_global_xa_utf8: Atom;
x_global_xa_targets: Atom;
x_global_xa_multiple: Atom;
x_global_xa_atom: Atom;
x_global_image_png: Atom;
x_global_image_bmp: Atom;
x_global_image_jpeg: Atom;
x_global_invisible_cursor: Cursor;
x_global_non_protocol_atom: Atom;
XdndEnter: Atom;
XdndPosition: Atom;
XdndStatus: Atom;
XdndTypeList: Atom;
XdndAware: Atom;
XdndActionMove: Atom;
XdndActionLink: Atom;
XdndActionCopy: Atom;
XdndDrop: Atom;
XdndLeave: Atom;
XdndFinished: Atom;
XdndSelection: Atom;
XdndProxy: Atom;
x_global_clipboard_buffer: struct {
    text_data: string;
    rgb_data: *u8;
    width: s32;
    height: s32;
    pitch: s32;
}
;
x_release_clipboard_data :: () {
    free(x_global_clipboard_buffer.text_data);
    free(x_global_clipboard_buffer.rgb_data);
    x_global_clipboard_buffer.text_data = "";
    x_global_clipboard_buffer.rgb_data = null;
    x_global_clipboard_buffer.width = 0;
    x_global_clipboard_buffer.height = 0;
    x_global_clipboard_buffer.pitch = 0;
}
x_global_windows: [..] Window = .{ allocator = Context_Base.default_allocator };
_NET_WM_STATE_REMOVE :: 0;
_NET_WM_STATE_ADD :: 1;
_NET_WM_STATE_TOGGLE :: 2;
Xdnd_Stage :: enum {
    DROP_IDLE :: 0;
    DROP_CONVERTING :: 1;
    DROP_ENTERED :: 2;
}
XDND_VERSION :: 5;
Xdnd_Context :: struct {
    stage := Xdnd_Stage.DROP_IDLE;
    dragging_version := 0;
    dragger_typelist: [..] Atom;
    dragger_window: Window;
    want_position := false;
    will_accept := false;
    rectangle: XRectangle;
    dropper_window: Window;
    dropper_toplevel: Window;
    root_window: Window;
    supported_action: Atom;
    desired_type: Atom;
    x: s32;
    y: s32;
    time: Time;
}
Drop_Info :: struct {
    data: [..] u8;
    x: int;
    y: int;
    return_type: Atom;
    return_action: Atom;
    user_typelist: [..] Atom;
    user_actions: [..] Atom;
}
drop_info: Drop_Info;
x_global_xdnd_context: Xdnd_Context;
xdnd_context_reset :: (dnd: *Xdnd_Context) {
    if !dnd return;
    array_free(dnd.dragger_typelist);
    dnd.* = .{};
}
init_global_display :: () {
    if x_global_display return;
    if XInitThreads() == 0 return;
    display := XOpenDisplay(null);
    if !display return;
    x_global_display = display;
    XSetLocaleModifiers("");
    x_global_input_method = XOpenIM(display, null, null, null);
    x_global_wm_delete_window = XInternAtom(display, "WM_DELETE_WINDOW", False);
    x_global_wm_protocols = XInternAtom(display, "WM_PROTOCOLS", False);
    x_global_net_wm_demands_attention = XInternAtom(display, "_NET_WM_STATE_DEMANDS_ATTENTION", False);
    x_global_net_wm_state = XInternAtom(display, "_NET_WM_STATE", False);
    x_global_net_wm_state_fullscreen = XInternAtom(display, "_NET_WM_STATE_FULLSCREEN", False);
    x_global_xa_clipboard = XInternAtom(display, "CLIPBOARD", False);
    x_global_xa_utf8 = XInternAtom(display, "UTF8_STRING", False);
    x_global_xa_targets = XInternAtom(display, "TARGETS", False);
    x_global_xa_multiple = XInternAtom(display, "MULTIPLE", False);
    x_global_xa_atom = XInternAtom(display, "ATOM", False);
    x_global_image_png = XInternAtom(display, "image/png", False);
    x_global_image_bmp = XInternAtom(display, "image/bmp", False);
    x_global_image_jpeg = XInternAtom(display, "image/jpeg", False);
    x_global_non_protocol_atom = XInternAtom(display, "JAI_SELECTION_DATA", False);
    XdndEnter = XInternAtom(display, "XdndEnter", False);
    XdndPosition = XInternAtom(display, "XdndPosition", False);
    XdndStatus = XInternAtom(display, "XdndStatus", False);
    XdndTypeList = XInternAtom(display, "XdndTypeList", False);
    XdndAware = XInternAtom(display, "XdndAware", False);
    XdndActionMove = XInternAtom(display, "XdndActionMove", False);
    XdndActionLink = XInternAtom(display, "XdndActionLink", False);
    XdndActionCopy = XInternAtom(display, "XdndActionCopy", False);
    XdndDrop = XInternAtom(display, "XdndDrop", False);
    XdndLeave = XInternAtom(display, "XdndLeave", False);
    XdndFinished = XInternAtom(display, "XdndFinished", False);
    XdndSelection = XInternAtom(display, "XdndSelection", False);
    XdndProxy = XInternAtom(display, "XdndProxy", False);
    bitmap: [1] u8;
    pixmap := XCreateBitmapFromData(display, XDefaultRootWindow(display), bitmap.data, 1, 1);
    if pixmap {
        blank: XColor;
        x_global_invisible_cursor = XCreatePixmapCursor(display, pixmap, pixmap, *blank, *blank, 0, 0);
        XFreePixmap(display, pixmap);
    }
    XFlush(display);
}
enable_drag_and_drop :: (window: Window, typelist: [] string) {
    if !x_global_display || !window return;
    version: u64 = XDND_VERSION;
    XChangeProperty(x_global_display, window, XdndAware, XA_ATOM, 32, PropModeReplace, cast(*u8) *version, 1);
    array_reset(*drop_info.user_typelist);
    for mime: typelist {
        label := to_c_string(mime);
        if !label continue;
        type_atom := XInternAtom(x_global_display, label, False);
        free(label);
        array_add(*drop_info.user_typelist, type_atom);
    }
    if drop_info.user_typelist.count > 0 XChangeProperty(x_global_display, window, XdndTypeList, XA_ATOM,
        32, PropModeReplace, cast(*u8) drop_info.user_typelist.data, cast(s32) drop_info.user_typelist.count);
    array_reset(*drop_info.user_actions);
    array_add(*drop_info.user_actions, XdndActionCopy);
    XFlush(x_global_display);
}
x_demand_attention :: (display: *Display, win: Window) {
    if !display || !win return;
    notification: XEvent;
    notification.xclient.type = ClientMessage;
    notification.xclient.window = win;
    notification.xclient.message_type = x_global_net_wm_state;
    notification.xclient.format = 32;
    notification.xclient.data.l[0] = _NET_WM_STATE_ADD;
    notification.xclient.data.l[1] = cast(s64) x_global_net_wm_demands_attention;
    notification.xclient.data.l[3] = 1;
    XSendEvent(display, XDefaultRootWindow(display), False, SubstructureNotifyMask | SubstructureRedirectMask, *notification);
    XFlush(display);
}
x_selection_notify_predicate :: (display: *Display, event: *XEvent, arg: XPointer) -> Bool #c_call {
    if event.type != SelectionNotify return False;
    expected := cast(*Window) arg;
    if !expected return False;
    if event.xselection.requestor != expected.* return False;
    return True;
}
x_window_is_ours :: (display: *Display, win: Window) -> bool {
    XLockDisplay(display);
    found := false;
    index: s64 = 0;
    while index < x_global_windows.count {
        if x_global_windows[index] == win {
            found = true;
            break;
        }
        index += 1;
    }
    XUnlockDisplay(display);
    return found;
}
#scope_file
EVENT_MASK :: ExposureMask | KeyPressMask | KeyReleaseMask | ButtonPressMask | ButtonReleaseMask | ButtonMotionMask | PointerMotionMask;
ui_id :: s32;
NOT_ACTIVE: ui_id : -1;
Ui_Context :: struct {
    hot: ui_id = NOT_ACTIVE;
    active: ui_id = NOT_ACTIVE;
    mouse_x: s32;
    mouse_y: s32;
    mouse_went_up: bool;
    mouse_went_down: bool;
}
is_inside :: (ctx: *Ui_Context, x: s32, y: s32, width: u32, height: u32) -> bool {
    horizontal := cast(s64) ctx.mouse_x - x;
    vertical := cast(s64) ctx.mouse_y - y;
    return horizontal >= 0 && vertical >= 0 && horizontal < width && vertical < height;
}
is_active :: (using ctx: *Ui_Context, id: ui_id) -> bool {
    return ctx.active == id;
}
is_hot :: (using ctx: *Ui_Context, id: ui_id) -> bool {
    return ctx.hot == id;
}
do_button :: (using ctx: *Ui_Context, id: ui_id, x: s32, y: s32, width: u32, height: u32) -> bool {
    hovered := is_inside(ctx, x, y, width, height);
    if hovered ctx.hot = id;
    else if ctx.hot == id ctx.hot = NOT_ACTIVE;
    if ctx.mouse_went_down && hovered && ctx.active == NOT_ACTIVE ctx.active = id;
    clicked := ctx.mouse_went_up && ctx.active == id && hovered;
    if ctx.mouse_went_up && ctx.active == id ctx.active = NOT_ACTIVE;
    return clicked;
}
x_toolkit_update_events :: (dpy: *Display, win: Window, ctx: *Ui_Context, window_width: *s32 = null, window_height: *s32 = null) -> should_exit: bool, should_redraw: bool {
    if !dpy || !win return true, false;
    ctx.mouse_went_up = false;
    ctx.mouse_went_down = false;
    redraw := false;
    event: XEvent;
    while XCheckWindowEvent(dpy, win, EVENT_MASK | StructureNotifyMask, *event) != False {
        if event.type == Expose redraw = true;
        if event.type == MotionNotify {
            ctx.mouse_x = event.xmotion.x;
            ctx.mouse_y = event.xmotion.y;
        }
        if event.type == ButtonPress {
            ctx.mouse_went_down = true;
            ctx.mouse_x = event.xbutton.x;
            ctx.mouse_y = event.xbutton.y;
            redraw = true;
        }
        if event.type == ButtonRelease {
            ctx.mouse_went_up = true;
            ctx.mouse_x = event.xbutton.x;
            ctx.mouse_y = event.xbutton.y;
            redraw = true;
        }
        if event.type == ConfigureNotify {
            if window_width window_width.* = event.xconfigure.width;
            if window_height window_height.* = event.xconfigure.height;
            redraw = true;
        }
        if event.type == DestroyNotify return true, redraw;
    }
    while XCheckTypedWindowEvent(dpy, win, ClientMessage, *event) != False {
        if event.xclient.message_type == x_global_wm_protocols &&
            cast(Atom) event.xclient.data.l[0] == x_global_wm_delete_window return true, redraw;
    }
    return false, redraw;
}
#import "Basic";
#scope_export
x_toolkit_create_simple_window :: (dpy: *Display, parent: Window, width: s32, height: s32, title: string) -> Window {
    if !dpy || width <= 0 || height <= 0 return None;
    if parent == None parent = XDefaultRootWindow(dpy);
    screen := XDefaultScreen(dpy);
    handle := XCreateSimpleWindow(dpy, parent, 0, 0, cast(u32) width, cast(u32) height, 0,
        XBlackPixel(dpy, screen), XWhitePixel(dpy, screen));
    if !handle return None;
    XSelectInput(dpy, handle, EVENT_MASK | StructureNotifyMask);
    label := to_c_string(title);
    if label {
        XStoreName(dpy, handle, label);
        free(label);
    }
    close_atom := XInternAtom(dpy, "WM_DELETE_WINDOW", False);
    XSetWMProtocols(dpy, handle, *close_atom, 1);
    XMapWindow(dpy, handle);
    XFlush(dpy);
    return handle;
}
X_Message_Box_Response :: enum {
    ABORT;
    CANCEL;
    CONTINUE;
    IGNORE;
    NO;
    OK;
    RETRY;
    TRY_AGAIN;
    YES;
}
X_Message_Box_Style :: enum {
    ST_ABORT_RETRY_IGNORE;
    ST_CANCEL_TRY_CONTINUE;
    ST_OK;
    ST_OK_CANCEL;
    ST_RETRY_CANCEL;
    ST_YES_NO;
    ST_YES_NO_CANCEL;
}
x_message_box :: (parent: Window, msg: string, caption: string, style: X_Message_Box_Style) -> X_Message_Box_Response {
    init_global_display();
    if !x_global_display return .CANCEL;
    // A modal dialog owns a separate connection, preserving the application's pending events.
    display := XOpenDisplay(null);
    if !display return .CANCEL;
    defer XCloseDisplay(display);
    labels: [3] string;
    responses: [3] X_Message_Box_Response;
    count: s32 = 1;
    labels[0] = "OK";
    responses[0] = .OK;
    if style == .ST_ABORT_RETRY_IGNORE {
        count = 3;
        labels = .["Abort", "Retry", "Ignore"];
        responses = .[.ABORT, .RETRY, .IGNORE];
    }
    if style == .ST_CANCEL_TRY_CONTINUE {
        count = 3;
        labels = .["Cancel", "Try Again", "Continue"];
        responses = .[.CANCEL, .TRY_AGAIN, .CONTINUE];
    }
    if style == .ST_OK_CANCEL {
        count = 2;
        labels = .["OK", "Cancel", ""];
        responses = .[.OK, .CANCEL, .CANCEL];
    }
    if style == .ST_RETRY_CANCEL {
        count = 2;
        labels = .["Retry", "Cancel", ""];
        responses = .[.RETRY, .CANCEL, .CANCEL];
    }
    if style == .ST_YES_NO {
        count = 2;
        labels = .["Yes", "No", ""];
        responses = .[.YES, .NO, .CANCEL];
    }
    if style == .ST_YES_NO_CANCEL {
        count = 3;
        labels = .["Yes", "No", "Cancel"];
        responses = .[.YES, .NO, .CANCEL];
    }
    window := x_toolkit_create_simple_window(display, None, 600, 220, caption);
    if !window return .CANCEL;
    defer XDestroyWindow(display, window);
    x_lock_window_size(display, window, 600, 220);
    if parent != None XSetTransientForHint(display, window, parent);
    ctx: Ui_Context;
    redraw := true;
    while true {
        key: XEvent;
        while XCheckTypedWindowEvent(display, window, KeyPress, *key) != False {
            symbol := XLookupKeysym(*key.xkey, 0);
            if symbol == 0xff0d return responses[0];
            if symbol == 0xff1b {
                if style == .ST_OK return .OK;
                return .CANCEL;
            }
        }
        quit, dirty := x_toolkit_update_events(display, window, *ctx);
        if quit return .CANCEL;
        redraw = redraw || dirty;
        for button: 0..count - 1 {
            x := 600 - (count * 130) + button * 130;
            if do_button(*ctx, button, x, 175, 120, 30) return responses[button];
        }
        if redraw {
            XClearWindow(display, window);
            XSetForeground(display, XDefaultGC(display, XDefaultScreen(display)), XBlackPixel(display, XDefaultScreen(display)));
            x_draw_textpanel(display, window, 16, 16, 568, 145, msg);
            for button: 0..count - 1 x_draw_button(display, window, 600 - count * 130 + button * 130, 175, 120, 30, is_active(*ctx, button), labels[button]);
            XFlush(display);
            redraw = false;
        }
        sleep_milliseconds(16);
    }
}
x_draw_textpanel :: (dpy: *Display, w: Window, x: s32, y: s32, width: s32, height: s32, msg: string) {
    if !dpy || !w || width <= 0 || height <= 0 return;
    graphics := XDefaultGC(dpy, XDefaultScreen(dpy));
    clip: XRectangle = .{ x = cast(s16) x, y = cast(s16) y, width = cast(u16) min(width, 65535), height = cast(u16) min(height, 65535) };
    XSetClipRectangles(dpy, graphics, 0, 0, *clip, 1, 0);
    defer XSetClipMask(dpy, graphics, None);
    columns := max(1, width / 8);
    offset: s64 = 0;
    baseline := y + 14;
    while offset < msg.count && baseline <= y + height {
        end := offset;
        while end < msg.count && end - offset < columns && msg[end] != 10 end += 1;
        line := to_string(msg.data + offset, end - offset);
        x_draw_string(dpy, w, x, baseline, line);
        offset = end;
        if offset < msg.count && msg[offset] == 10 offset += 1;
        baseline += 18;
    }
}
x_color_to_pixel :: (dpy: *Display, cmap: Colormap, col: XColor) -> u64 {
    selected := col;
    if XAllocColor(dpy, cmap, *selected) == 0 return 0;
    return selected.pixel;
}
x_draw_button :: (dpy: *Display, w: Window, x: s32, y: s32, width: u32, height: u32, pressed: bool, msg: string) {
    if !dpy || !w || width < 2 || height < 2 return;
    screen := XDefaultScreen(dpy);
    graphics := XDefaultGC(dpy, screen);
    gray := x_color_to_pixel(dpy, XDefaultColormap(dpy, screen), x_rgb_to_color(210, 210, 210));
    XSetForeground(dpy, graphics, gray);
    XFillRectangle(dpy, w, graphics, x, y, width, height);
    top := XWhitePixel(dpy, screen);
    bottom := XBlackPixel(dpy, screen);
    if pressed {
        temporary := top;
        top = bottom;
        bottom = temporary;
    }
    XSetForeground(dpy, graphics, top);
    XDrawLine(dpy, w, graphics, x, y, x + cast(s32) width - 1, y);
    XDrawLine(dpy, w, graphics, x, y, x, y + cast(s32) height - 1);
    XSetForeground(dpy, graphics, bottom);
    XDrawLine(dpy, w, graphics, x, y + cast(s32) height - 1, x + cast(s32) width - 1, y + cast(s32) height - 1);
    XDrawLine(dpy, w, graphics, x + cast(s32) width - 1, y, x + cast(s32) width - 1, y + cast(s32) height - 1);
    XSetForeground(dpy, graphics, XBlackPixel(dpy, screen));
    label_x := x + (cast(s32) width - cast(s32) msg.count * 8) / 2;
    label_y := y + (cast(s32) height + 12) / 2;
    if pressed {
        label_x += 1;
        label_y += 1;
    }
    x_draw_string(dpy, w, label_x, label_y, msg);
}
x_draw_string :: (dpy: *Display, d: Drawable, x: s32, y: s32, msg: string) {
    screen := XDefaultScreen(dpy);
    graphics := XDefaultGC(dpy, screen);
    XDrawString(dpy, d, graphics, x, y, msg.data, cast(s32) msg.count);
}
x_textwidth :: (font: *XFontStruct, msg: string) -> s32 {
    count := cast(s32) msg.count;
    measured := XTextWidth(font, msg.data, count);
    return measured;
}
x_lock_window_size :: (dpy: *Display, w: Window, width: s32, height: s32) {
    limits: XSizeHints;
    limits.flags = PMinSize | PMaxSize | PSize;
    limits.width, limits.min_width, limits.max_width = width, width, width;
    limits.height, limits.min_height, limits.max_height = height, height, height;
    XSetWMNormalHints(dpy, w, *limits);
}
x_rgb_to_color :: (_r: u8, _g: u8, _b: u8) -> XColor {
    color: XColor;
    color.blue = cast(u16) _b * 257;
    color.green = cast(u16) _g * 257;
    color.red = cast(u16) _r * 257;
    color.flags = DoBlue | DoGreen | DoRed;
    return color;
}
XID :: u64;
Mask :: u64;
Atom :: u64;
VisualID :: u64;
Time :: u64;
Window :: XID;
Drawable :: XID;
Font :: XID;
Pixmap :: XID;
Cursor :: XID;
Colormap :: XID;
GContext :: XID;
KeySym :: XID;
KeyCode :: u8;
InputHint :: (1 << 0);
StateHint :: (1 << 1);
IconPixmapHint :: (1 << 2);
IconWindowHint :: (1 << 3);
IconPositionHint :: (1 << 4);
IconMaskHint :: (1 << 5);
WindowGroupHint :: (1 << 6);
AllHints :: (InputHint | StateHint | IconPixmapHint | IconWindowHint | IconPositionHint | IconMaskHint | WindowGroupHint);
XUrgencyHint :: (1 << 8);
PAllHints :: PPosition | PSize | PMinSize | PMaxSize | PResizeInc | PAspect;
USPosition :: (1 << 0);
USSize :: (1 << 1);
PPosition :: (1 << 2);
PSize :: (1 << 3);
PMinSize :: (1 << 4);
PMaxSize :: (1 << 5);
PResizeInc :: (1 << 6);
PAspect :: (1 << 7);
PBaseSize :: (1 << 8);
PWinGravity :: (1 << 9);
Bool :: s32;
Status :: s32;
True :: 1;
False :: 0;
None :: 0;
Success :: 0;
BadRequest :: 1;
BadValue :: 2;
BadWindow :: 3;
BadPixmap :: 4;
BadAtom :: 5;
BadCursor :: 6;
BadFont :: 7;
BadMatch :: 8;
BadDrawable :: 9;
BadAccess :: 10;
BadAlloc :: 11;
BadColor :: 12;
BadGC :: 13;
BadIDChoice :: 14;
BadName :: 15;
BadLength :: 16;
BadImplementation :: 17;
FirstExtensionError :: 128;
LastExtensionError :: 255;
DoRed :: (1 << 0);
DoGreen :: (1 << 1);
DoBlue :: (1 << 2);
XYBitmap :: 0;
XYPixmap :: 1;
ZPixmap :: 2;
GCFunction :: (1 << 0);
GCPlaneMask :: (1 << 1);
GCForeground :: (1 << 2);
GCBackground :: (1 << 3);
GCLineWidth :: (1 << 4);
GCLineStyle :: (1 << 5);
GCCapStyle :: (1 << 6);
GCJoinStyle :: (1 << 7);
GCFillStyle :: (1 << 8);
GCFillRule :: (1 << 9);
GCTile :: (1 << 10);
GCStipple :: (1 << 11);
GCTileStipXOrigin :: (1 << 12);
GCTileStipYOrigin :: (1 << 13);
GCFont :: (1 << 14);
GCSubwindowMode :: (1 << 15);
GCGraphicsExposures :: (1 << 16);
GCClipXOrigin :: (1 << 17);
GCClipYOrigin :: (1 << 18);
GCClipMask :: (1 << 19);
GCDashOffset :: (1 << 20);
GCDashList :: (1 << 21);
GCArcMode :: (1 << 22);
GCLastBit :: 22;
ParentRelative :: 1;
CopyFromParent :: 0;
PointerWindow :: 0;
InputFocus :: 1;
PointerRoot :: 1;
AnyPropertyType :: 0;
AnyKey :: 0;
AnyButton :: 0;
AllTemporary :: 0;
CurrentTime :: 0;
NoSymbol :: 0;
GrabModeSync :: 0;
GrabModeAsync :: 1;
GrabSuccess :: 0;
AlreadyGrabbed :: 1;
GrabInvalidTime :: 2;
GrabNotViewable :: 3;
GrabFrozen :: 4;
PropModeReplace :: 0;
PropModePrepend :: 1;
PropModeAppend :: 2;
AllocNone :: 0;
AllocAll :: 1;
XA_PRIMARY :: 1;
XA_SECONDARY :: 2;
XA_ARC :: 3;
XA_ATOM :: 4;
XA_BITMAP :: 5;
XA_CARDINAL :: 6;
XA_COLORMAP :: 7;
XA_CURSOR :: 8;
XA_CUT_BUFFER0 :: 9;
XA_CUT_BUFFER1 :: 10;
XA_CUT_BUFFER2 :: 11;
XA_CUT_BUFFER3 :: 12;
XA_CUT_BUFFER4 :: 13;
XA_CUT_BUFFER5 :: 14;
XA_CUT_BUFFER6 :: 15;
XA_CUT_BUFFER7 :: 16;
XA_DRAWABLE :: 17;
XA_FONT :: 18;
XA_INTEGER :: 19;
XA_PIXMAP :: 20;
XA_POINT :: 21;
XA_RECTANGLE :: 22;
XA_RESOURCE_MANAGER :: 23;
XA_RGB_COLOR_MAP :: 24;
XA_RGB_BEST_MAP :: 25;
XA_RGB_BLUE_MAP :: 26;
XA_RGB_DEFAULT_MAP :: 27;
XA_RGB_GRAY_MAP :: 28;
XA_RGB_GREEN_MAP :: 29;
XA_RGB_RED_MAP :: 30;
XA_STRING :: 31;
XA_VISUALID :: 32;
XA_WINDOW :: 33;
XA_WM_COMMAND :: 34;
XA_WM_HINTS :: 35;
XA_WM_CLIENT_MACHINE :: 36;
XA_WM_ICON_NAME :: 37;
XA_WM_ICON_SIZE :: 38;
XA_WM_NAME :: 39;
XA_WM_NORMAL_HINTS :: 40;
XA_WM_SIZE_HINTS :: 41;
XA_WM_ZOOM_HINTS :: 42;
XA_MIN_SPACE :: 43;
XA_NORM_SPACE :: 44;
XA_MAX_SPACE :: 45;
XA_END_SPACE :: 46;
XA_SUPERSCRIPT_X :: 47;
XA_SUPERSCRIPT_Y :: 48;
XA_SUBSCRIPT_X :: 49;
XA_SUBSCRIPT_Y :: 50;
XA_UNDERLINE_POSITION :: 51;
XA_UNDERLINE_THICKNESS :: 52;
XA_STRIKEOUT_ASCENT :: 53;
XA_STRIKEOUT_DESCENT :: 54;
XA_ITALIC_ANGLE :: 55;
XA_X_HEIGHT :: 56;
XA_QUAD_WIDTH :: 57;
XA_WEIGHT :: 58;
XA_POINT_SIZE :: 59;
XA_RESOLUTION :: 60;
XA_COPYRIGHT :: 61;
XA_NOTICE :: 62;
XA_FONT_NAME :: 63;
XA_FAMILY_NAME :: 64;
XA_FULL_NAME :: 65;
XA_CAP_HEIGHT :: 66;
XA_WM_CLASS :: 67;
XA_WM_TRANSIENT_FOR :: 68;
QueuedAlready :: 0;
QueuedAfterReading :: 1;
QueuedAfterFlush :: 2;
NoEventMask :: 0;
KeyPressMask :: (1 << 0);
KeyReleaseMask :: (1 << 1);
ButtonPressMask :: (1 << 2);
ButtonReleaseMask :: (1 << 3);
EnterWindowMask :: (1 << 4);
LeaveWindowMask :: (1 << 5);
PointerMotionMask :: (1 << 6);
PointerMotionHintMask :: (1 << 7);
Button1MotionMask :: (1 << 8);
Button2MotionMask :: (1 << 9);
Button3MotionMask :: (1 << 10);
Button4MotionMask :: (1 << 11);
Button5MotionMask :: (1 << 12);
ButtonMotionMask :: (1 << 13);
KeymapStateMask :: (1 << 14);
ExposureMask :: (1 << 15);
VisibilityChangeMask :: (1 << 16);
StructureNotifyMask :: (1 << 17);
ResizeRedirectMask :: (1 << 18);
SubstructureNotifyMask :: (1 << 19);
SubstructureRedirectMask :: (1 << 20);
FocusChangeMask :: (1 << 21);
PropertyChangeMask :: (1 << 22);
ColormapChangeMask :: (1 << 23);
OwnerGrabButtonMask :: (1 << 24);
KeyPress :: 2;
KeyRelease :: 3;
ButtonPress :: 4;
ButtonRelease :: 5;
MotionNotify :: 6;
EnterNotify :: 7;
LeaveNotify :: 8;
FocusIn :: 9;
FocusOut :: 10;
KeymapNotify :: 11;
Expose :: 12;
GraphicsExpose :: 13;
NoExpose :: 14;
VisibilityNotify :: 15;
CreateNotify :: 16;
DestroyNotify :: 17;
UnmapNotify :: 18;
MapNotify :: 19;
MapRequest :: 20;
ReparentNotify :: 21;
ConfigureNotify :: 22;
ConfigureRequest :: 23;
GravityNotify :: 24;
ResizeRequest :: 25;
CirculateNotify :: 26;
CirculateRequest :: 27;
PropertyNotify :: 28;
SelectionClear :: 29;
SelectionRequest :: 30;
SelectionNotify :: 31;
ColormapNotify :: 32;
ClientMessage :: 33;
MappingNotify :: 34;
GenericEvent :: 35;
Button1 :: 1;
Button2 :: 2;
Button3 :: 3;
Button4 :: 4;
Button5 :: 5;
InputOutput :: 1;
InputOnly :: 2;
CWEventMask :: (1 << 11);
CWColormap :: (1 << 13);
ShiftMask :: (1 << 0);
LockMask :: (1 << 1);
ControlMask :: (1 << 2);
Mod1Mask :: (1 << 3);
Mod2Mask :: (1 << 4);
Mod3Mask :: (1 << 5);
Mod4Mask :: (1 << 6);
Mod5Mask :: (1 << 7);
Button1Mask :: (1 << 8);
Button2Mask :: (1 << 9);
Button3Mask :: (1 << 10);
Button4Mask :: (1 << 11);
Button5Mask :: (1 << 12);
XIMPreeditArea :: 0x0001;
XIMPreeditCallbacks :: 0x0002;
XIMPreeditPosition :: 0x0004;
XIMPreeditNothing :: 0x0008;
XIMPreeditNone :: 0x0010;
XIMStatusArea :: 0x0100;
XIMStatusCallbacks :: 0x0200;
XIMStatusNothing :: 0x0400;
XIMStatusNone :: 0x0800;
XNClientWindow :: "clientWindow".data;
XNFocusWindow :: "focusWindow".data;
XNInputStyle :: "inputStyle".data;
XBufferOverflow :: -1;
XLookupNone :: 1;
XLookupChars :: 2;
XLookupKeySym :: 3;
XLookupBoth :: 4;
XK_ISO_Left_Tab :: 0xfe20;
XK_BackSpace :: 0xff08;
XK_Tab :: 0xff09;
XK_Linefeed :: 0xff0a;
XK_Clear :: 0xff0b;
XK_Return :: 0xff0d;
XK_Pause :: 0xff13;
XK_Scroll_Lock :: 0xff14;
XK_Sys_Req :: 0xff15;
XK_Escape :: 0xff1b;
XK_Delete :: 0xffff;
XK_Home :: 0xff50;
XK_Left :: 0xff51;
XK_Up :: 0xff52;
XK_Right :: 0xff53;
XK_Down :: 0xff54;
XK_Prior :: 0xff55;
XK_Page_Up :: 0xff55;
XK_Next :: 0xff56;
XK_Page_Down :: 0xff56;
XK_End :: 0xff57;
XK_Begin :: 0xff58;
XK_F1 :: 0xffbe;
XK_F2 :: 0xffbf;
XK_F3 :: 0xffc0;
XK_F4 :: 0xffc1;
XK_F5 :: 0xffc2;
XK_F6 :: 0xffc3;
XK_F7 :: 0xffc4;
XK_F8 :: 0xffc5;
XK_F9 :: 0xffc6;
XK_F10 :: 0xffc7;
XK_F11 :: 0xffc8;
XK_L1 :: 0xffc8;
XK_F12 :: 0xffc9;
XK_L2 :: 0xffc9;
XK_F13 :: 0xffca;
XK_L3 :: 0xffca;
XK_F14 :: 0xffcb;
XK_L4 :: 0xffcb;
XK_F15 :: 0xffcc;
XK_L5 :: 0xffcc;
XK_F16 :: 0xffcd;
XK_L6 :: 0xffcd;
XK_F17 :: 0xffce;
XK_L7 :: 0xffce;
XK_F18 :: 0xffcf;
XK_L8 :: 0xffcf;
XK_F19 :: 0xffd0;
XK_L9 :: 0xffd0;
XK_F20 :: 0xffd1;
XK_L10 :: 0xffd1;
XK_F21 :: 0xffd2;
XK_R1 :: 0xffd2;
XK_F22 :: 0xffd3;
XK_R2 :: 0xffd3;
XK_F23 :: 0xffd4;
XK_R3 :: 0xffd4;
XK_F24 :: 0xffd5;
XK_R4 :: 0xffd5;
XK_F25 :: 0xffd6;
XK_R5 :: 0xffd6;
XK_F26 :: 0xffd7;
XK_R6 :: 0xffd7;
XK_F27 :: 0xffd8;
XK_R7 :: 0xffd8;
XK_F28 :: 0xffd9;
XK_R8 :: 0xffd9;
XK_F29 :: 0xffda;
XK_R9 :: 0xffda;
XK_F30 :: 0xffdb;
XK_R10 :: 0xffdb;
XK_F31 :: 0xffdc;
XK_R11 :: 0xffdc;
XK_F32 :: 0xffdd;
XK_R12 :: 0xffdd;
XK_F33 :: 0xffde;
XK_R13 :: 0xffde;
XK_F34 :: 0xffdf;
XK_R14 :: 0xffdf;
XK_F35 :: 0xffe0;
XK_R15 :: 0xffe0;
XK_Shift_L :: 0xffe1;
XK_Shift_R :: 0xffe2;
XK_Control_L :: 0xffe3;
XK_Control_R :: 0xffe4;
XK_Caps_Lock :: 0xffe5;
XK_Shift_Lock :: 0xffe6;
XK_Meta_L :: 0xffe7;
XK_Meta_R :: 0xffe8;
XK_Alt_L :: 0xffe9;
XK_Alt_R :: 0xffea;
XK_Super_L :: 0xffeb;
XK_Super_R :: 0xffec;
XK_Hyper_L :: 0xffed;
XK_Hyper_R :: 0xffee;
XK_space :: 0x0020;
XK_exclam :: 0x0021;
XK_quotedbl :: 0x0022;
XK_numbersign :: 0x0023;
XK_dollar :: 0x0024;
XK_percent :: 0x0025;
XK_ampersand :: 0x0026;
XK_apostrophe :: 0x0027;
XK_quoteright :: 0x0027;
XK_parenleft :: 0x0028;
XK_parenright :: 0x0029;
XK_asterisk :: 0x002a;
XK_plus :: 0x002b;
XK_comma :: 0x002c;
XK_minus :: 0x002d;
XK_period :: 0x002e;
XK_slash :: 0x002f;
XK_0 :: 0x0030;
XK_1 :: 0x0031;
XK_2 :: 0x0032;
XK_3 :: 0x0033;
XK_4 :: 0x0034;
XK_5 :: 0x0035;
XK_6 :: 0x0036;
XK_7 :: 0x0037;
XK_8 :: 0x0038;
XK_9 :: 0x0039;
XK_colon :: 0x003a;
XK_semicolon :: 0x003b;
XK_less :: 0x003c;
XK_equal :: 0x003d;
XK_greater :: 0x003e;
XK_question :: 0x003f;
XK_at :: 0x0040;
XK_A :: 0x0041;
XK_B :: 0x0042;
XK_C :: 0x0043;
XK_D :: 0x0044;
XK_E :: 0x0045;
XK_F :: 0x0046;
XK_G :: 0x0047;
XK_H :: 0x0048;
XK_I :: 0x0049;
XK_J :: 0x004a;
XK_K :: 0x004b;
XK_L :: 0x004c;
XK_M :: 0x004d;
XK_N :: 0x004e;
XK_O :: 0x004f;
XK_P :: 0x0050;
XK_Q :: 0x0051;
XK_R :: 0x0052;
XK_S :: 0x0053;
XK_T :: 0x0054;
XK_U :: 0x0055;
XK_V :: 0x0056;
XK_W :: 0x0057;
XK_X :: 0x0058;
XK_Y :: 0x0059;
XK_Z :: 0x005a;
XK_bracketleft :: 0x005b;
XK_backslash :: 0x005c;
XK_bracketright :: 0x005d;
XK_asciicircum :: 0x005e;
XK_underscore :: 0x005f;
XK_grave :: 0x0060;
XK_quoteleft :: 0x0060;
XK_a :: 0x0061;
XK_b :: 0x0062;
XK_c :: 0x0063;
XK_d :: 0x0064;
XK_e :: 0x0065;
XK_f :: 0x0066;
XK_g :: 0x0067;
XK_h :: 0x0068;
XK_i :: 0x0069;
XK_j :: 0x006a;
XK_k :: 0x006b;
XK_l :: 0x006c;
XK_m :: 0x006d;
XK_n :: 0x006e;
XK_o :: 0x006f;
XK_p :: 0x0070;
XK_q :: 0x0071;
XK_r :: 0x0072;
XK_s :: 0x0073;
XK_t :: 0x0074;
XK_u :: 0x0075;
XK_v :: 0x0076;
XK_w :: 0x0077;
XK_x :: 0x0078;
XK_y :: 0x0079;
XK_z :: 0x007a;
XK_braceleft :: 0x007b;
XK_bar :: 0x007c;
XK_braceright :: 0x007d;
XK_asciitilde :: 0x007e;
XK_Print :: 0xff61;
XK_Insert :: 0xff63;
XK_Menu :: 0xff67;
XK_KP_Space :: 0xff80;
XK_KP_Tab :: 0xff89;
XK_KP_Enter :: 0xff8d;
XK_KP_F1 :: 0xff91;
XK_KP_F2 :: 0xff92;
XK_KP_F3 :: 0xff93;
XK_KP_F4 :: 0xff94;
XK_KP_Home :: 0xff95;
XK_KP_Left :: 0xff96;
XK_KP_Up :: 0xff97;
XK_KP_Right :: 0xff98;
XK_KP_Down :: 0xff99;
XK_KP_Prior :: 0xff9a;
XK_KP_Page_Up :: 0xff9a;
XK_KP_Next :: 0xff9b;
XK_KP_Page_Down :: 0xff9b;
XK_KP_End :: 0xff9c;
XK_KP_Begin :: 0xff9d;
XK_KP_Insert :: 0xff9e;
XK_KP_Delete :: 0xff9f;
XK_KP_Equal :: 0xffbd;
XK_KP_Multiply :: 0xffaa;
XK_KP_Add :: 0xffab;
XK_KP_Separator :: 0xffac;
XK_KP_Subtract :: 0xffad;
XK_KP_Decimal :: 0xffae;
XK_KP_Divide :: 0xffaf;
XK_KP_0 :: 0xffb0;
XK_KP_1 :: 0xffb1;
XK_KP_2 :: 0xffb2;
XK_KP_3 :: 0xffb3;
XK_KP_4 :: 0xffb4;
XK_KP_5 :: 0xffb5;
XK_KP_6 :: 0xffb6;
XK_KP_7 :: 0xffb7;
XK_KP_8 :: 0xffb8;
XK_KP_9 :: 0xffb9;
XK_ISO_Level3_Shift :: 0xfe03;
_Xmblen :: (str: *u8, len: s32) -> s32 #foreign libX11;
XPointer :: *void;
_XExtData :: struct {
    number: s32;
    next: *_XExtData;
    free_private: #type (a0: *_XExtData) -> s32 #c_call;
    private_data: XPointer;
}
XExtData :: _XExtData;
XExtCodes :: struct {
    extension: s32;
    major_opcode: s32;
    first_event: s32;
    first_error: s32;
}
XPixmapFormatValues :: struct {
    depth: s32;
    bits_per_pixel: s32;
    scanline_pad: s32;
}
XGCValues :: struct {
    function: s32;
    plane_mask: u64;
    foreground: u64;
    background: u64;
    line_width: s32;
    line_style: s32;
    cap_style: s32;
    join_style: s32;
    fill_style: s32;
    fill_rule: s32;
    arc_mode: s32;
    tile: Pixmap;
    stipple: Pixmap;
    ts_x_origin: s32;
    ts_y_origin: s32;
    font: Font;
    subwindow_mode: s32;
    graphics_exposures: s32;
    clip_x_origin: s32;
    clip_y_origin: s32;
    clip_mask: Pixmap;
    dash_offset: s32;
    dashes: u8;
}
_XGC :: struct {
    ext_data: XExtData;
    gid: GContext;
}
GC :: *_XGC;
Visual :: struct {
    ext_data: *XExtData;
    visualid: VisualID;
    class: s32;
    red_mask: u64;
    green_mask: u64;
    blue_mask: u64;
    bits_per_rgb: s32;
    map_entries: s32;
}
Depth :: struct {
    depth: s32;
    nvisuals: s32;
    visuals: *Visual;
}
_XDisplay :: struct {}
Screen :: struct {
    ext_data: *XExtData;
    display: *_XDisplay;
    root: Window;
    width: s32;
    height: s32;
    mwidth: s32;
    mheight: s32;
    ndepths: s32;
    depths: *Depth;
    root_depth: s32;
    root_visual: *Visual;
    default_gc: GC;
    cmap: Colormap;
    white_pixel: u64;
    black_pixel: u64;
    max_maps: s32;
    min_maps: s32;
    backing_store: s32;
    save_unders: s32;
    root_input_mask: s64;
}
ScreenFormat :: struct {
    ext_data: *XExtData;
    depth: s32;
    bits_per_pixel: s32;
    scanline_pad: s32;
}
XSetWindowAttributes :: struct {
    background_pixmap: Pixmap;
    background_pixel: u64;
    border_pixmap: Pixmap;
    border_pixel: u64;
    bit_gravity: s32;
    win_gravity: s32;
    backing_store: s32;
    backing_planes: u64;
    backing_pixel: u64;
    save_under: s32;
    event_mask: s64;
    do_not_propagate_mask: s64;
    override_redirect: s32;
    colormap: Colormap;
    cursor: Cursor;
}
XWindowAttributes :: struct {
    x: s32;
    y: s32;
    width: s32;
    height: s32;
    border_width: s32;
    depth: s32;
    visual: *Visual;
    root: Window;
    class: s32;
    bit_gravity: s32;
    win_gravity: s32;
    backing_store: s32;
    backing_planes: u64;
    backing_pixel: u64;
    save_under: s32;
    colormap: Colormap;
    map_installed: s32;
    map_state: s32;
    all_event_masks: s64;
    your_event_mask: s64;
    do_not_propagate_mask: s64;
    override_redirect: s32;
    screen: *Screen;
}
XHostAddress :: struct {
    family: s32;
    length: s32;
    address: *u8;
}
XServerInterpretedAddress :: struct {
    typelength: s32;
    valuelength: s32;
    type: *u8;
    value: *u8;
}
_XImage :: struct {
    width: s32;
    height: s32;
    xoffset: s32;
    format: s32;
    data: *u8;
    byte_order: s32;
    bitmap_unit: s32;
    bitmap_bit_order: s32;
    bitmap_pad: s32;
    depth: s32;
    bytes_per_line: s32;
    bits_per_pixel: s32;
    red_mask: u64;
    green_mask: u64;
    blue_mask: u64;
    obdata: XPointer;
    funcs :: struct {
        create_image: #type (a0: *_XDisplay, a1: *Visual, a2: u32, a3: s32, a4: s32, a5: *u8, a6: u32, a7: u32, a8: s32, a9: s32) -> *_XImage #c_call;
        destroy_image: #type (a0: *_XImage) -> s32 #c_call;
        get_pixel: #type (a0: *_XImage, a1: s32, a2: s32) -> u64 #c_call;
        put_pixel: #type (a0: *_XImage, a1: s32, a2: s32, a3: u64) -> s32 #c_call;
        sub_image: #type (a0: *_XImage, a1: s32, a2: s32, a3: u32, a4: u32) -> *_XImage #c_call;
        add_pixel: #type (a0: *_XImage, a1: s64) -> s32 #c_call;
    }
    f: funcs;
}
XImage :: _XImage;
XWindowChanges :: struct {
    x: s32;
    y: s32;
    width: s32;
    height: s32;
    border_width: s32;
    sibling: Window;
    stack_mode: s32;
}
XColor :: struct {
    pixel: u64;
    red: u16;
    green: u16;
    blue: u16;
    flags: u8;
    pad: u8;
}
XSegment :: struct {
    x1: s16;
    y1: s16;
    x2: s16;
    y2: s16;
}
XPoint :: struct {
    x: s16;
    y: s16;
}
XRectangle :: struct {
    x: s16;
    y: s16;
    width: u16;
    height: u16;
}
XArc :: struct {
    x: s16;
    y: s16;
    width: u16;
    height: u16;
    angle1: s16;
    angle2: s16;
}
XKeyboardControl :: struct {
    key_click_percent: s32;
    bell_percent: s32;
    bell_pitch: s32;
    bell_duration: s32;
    led: s32;
    led_mode: s32;
    key: s32;
    auto_repeat_mode: s32;
}
XKeyboardState :: struct {
    key_click_percent: s32;
    bell_percent: s32;
    bell_pitch: u32;
    bell_duration: u32;
    led_mask: u64;
    global_auto_repeat: s32;
    auto_repeats: [32] u8;
}
XTimeCoord :: struct {
    time: Time;
    x: s16;
    y: s16;
}
XModifierKeymap :: struct {
    max_keypermod: s32;
    modifiermap: *KeyCode;
}
Display :: _XDisplay;
_XPrivate :: struct {}
_XrmHashBucketRec :: struct {}
_XPrivDisplay :: *__XPrivDisplay;
__XPrivDisplay :: struct {
    ext_data: *XExtData;
    private1: *_XPrivate;
    fd: s32;
    private2: s32;
    proto_major_version: s32;
    proto_minor_version: s32;
    vendor: *u8;
    private3: XID;
    private4: XID;
    private5: XID;
    private6: s32;
    resource_alloc: #type (a0: *_XDisplay) -> XID #c_call;
    byte_order: s32;
    bitmap_unit: s32;
    bitmap_pad: s32;
    bitmap_bit_order: s32;
    nformats: s32;
    pixmap_format: *ScreenFormat;
    private8: s32;
    release: s32;
    private9: *_XPrivate;
    private10: *_XPrivate;
    qlen: s32;
    last_request_read: u64;
    request: u64;
    private11: XPointer;
    private12: XPointer;
    private13: XPointer;
    private14: XPointer;
    max_request_size: u32;
    db: *_XrmHashBucketRec;
    private15: #type (a0: *_XDisplay) -> s32 #c_call;
    display_name: *u8;
    default_screen: s32;
    nscreens: s32;
    screens: *Screen;
    motion_buffer: u64;
    private16: u64;
    min_keycode: s32;
    max_keycode: s32;
    private17: XPointer;
    private18: XPointer;
    private19: s32;
    xdefaults: *u8;
}
XKeyEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    window: Window;
    root: Window;
    subwindow: Window;
    time: Time;
    x: s32;
    y: s32;
    x_root: s32;
    y_root: s32;
    state: u32;
    keycode: u32;
    same_screen: s32;
}
XKeyPressedEvent :: XKeyEvent;
XKeyReleasedEvent :: XKeyEvent;
XButtonEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    window: Window;
    root: Window;
    subwindow: Window;
    time: Time;
    x: s32;
    y: s32;
    x_root: s32;
    y_root: s32;
    state: u32;
    button: u32;
    same_screen: s32;
}
XButtonPressedEvent :: XButtonEvent;
XButtonReleasedEvent :: XButtonEvent;
XMotionEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    window: Window;
    root: Window;
    subwindow: Window;
    time: Time;
    x: s32;
    y: s32;
    x_root: s32;
    y_root: s32;
    state: u32;
    is_hint: u8;
    same_screen: s32;
}
XPointerMovedEvent :: XMotionEvent;
XCrossingEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    window: Window;
    root: Window;
    subwindow: Window;
    time: Time;
    x: s32;
    y: s32;
    x_root: s32;
    y_root: s32;
    mode: s32;
    detail: s32;
    same_screen: s32;
    focus: s32;
    state: u32;
}
XEnterWindowEvent :: XCrossingEvent;
XLeaveWindowEvent :: XCrossingEvent;
XFocusChangeEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    window: Window;
    mode: s32;
    detail: s32;
}
XFocusInEvent :: XFocusChangeEvent;
XFocusOutEvent :: XFocusChangeEvent;
XKeymapEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    window: Window;
    key_vector: [32] u8;
}
XExposeEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    window: Window;
    x: s32;
    y: s32;
    width: s32;
    height: s32;
    count: s32;
}
XGraphicsExposeEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    drawable: Drawable;
    x: s32;
    y: s32;
    width: s32;
    height: s32;
    count: s32;
    major_code: s32;
    minor_code: s32;
}
XNoExposeEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    drawable: Drawable;
    major_code: s32;
    minor_code: s32;
}
XVisibilityEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    window: Window;
    state: s32;
}
XCreateWindowEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    parent: Window;
    window: Window;
    x: s32;
    y: s32;
    width: s32;
    height: s32;
    border_width: s32;
    override_redirect: s32;
}
XDestroyWindowEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    event: Window;
    window: Window;
}
XUnmapEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    event: Window;
    window: Window;
    from_configure: s32;
}
XMapEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    event: Window;
    window: Window;
    override_redirect: s32;
}
XMapRequestEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    parent: Window;
    window: Window;
}
XReparentEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    event: Window;
    window: Window;
    parent: Window;
    x: s32;
    y: s32;
    override_redirect: s32;
}
XConfigureEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    event: Window;
    window: Window;
    x: s32;
    y: s32;
    width: s32;
    height: s32;
    border_width: s32;
    above: Window;
    override_redirect: s32;
}
XGravityEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    event: Window;
    window: Window;
    x: s32;
    y: s32;
}
XResizeRequestEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    window: Window;
    width: s32;
    height: s32;
}
XConfigureRequestEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    parent: Window;
    window: Window;
    x: s32;
    y: s32;
    width: s32;
    height: s32;
    border_width: s32;
    above: Window;
    detail: s32;
    value_mask: u64;
}
XCirculateEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    event: Window;
    window: Window;
    place: s32;
}
XCirculateRequestEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    parent: Window;
    window: Window;
    place: s32;
}
XPropertyEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    window: Window;
    atom: Atom;
    time: Time;
    state: s32;
}
XSelectionClearEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    window: Window;
    selection: Atom;
    time: Time;
}
XSelectionRequestEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    owner: Window;
    requestor: Window;
    selection: Atom;
    target: Atom;
    property: Atom;
    time: Time;
}
XSelectionEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    requestor: Window;
    selection: Atom;
    target: Atom;
    property: Atom;
    time: Time;
}
XColormapEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    window: Window;
    colormap: Colormap;
    new: s32;
    state: s32;
}
XClientMessageEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    window: Window;
    message_type: Atom;
    format: s32;
    data: union {
        b: [20] u8;
        s: [10] s16;
        l: [5] s64;
    }
    ;
}
XMappingEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    window: Window;
    request: s32;
    first_keycode: s32;
    count: s32;
}
XErrorEvent :: struct {
    type: s32;
    display: *Display;
    resourceid: XID;
    serial: u64;
    error_code: u8;
    request_code: u8;
    minor_code: u8;
}
XAnyEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    window: Window;
}
XGenericEvent :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    extension: s32;
    evtype: s32;
}
XGenericEventCookie :: struct {
    type: s32;
    serial: u64;
    send_event: s32;
    display: *Display;
    extension: s32;
    evtype: s32;
    cookie: u32;
    data: *void;
}
_XEvent :: union {
    type: s32;
    xany: XAnyEvent;
    xkey: XKeyEvent;
    xbutton: XButtonEvent;
    xmotion: XMotionEvent;
    xcrossing: XCrossingEvent;
    xfocus: XFocusChangeEvent;
    xexpose: XExposeEvent;
    xgraphicsexpose: XGraphicsExposeEvent;
    xnoexpose: XNoExposeEvent;
    xvisibility: XVisibilityEvent;
    xcreatewindow: XCreateWindowEvent;
    xdestroywindow: XDestroyWindowEvent;
    xunmap: XUnmapEvent;
    xmap: XMapEvent;
    xmaprequest: XMapRequestEvent;
    xreparent: XReparentEvent;
    xconfigure: XConfigureEvent;
    xgravity: XGravityEvent;
    xresizerequest: XResizeRequestEvent;
    xconfigurerequest: XConfigureRequestEvent;
    xcirculate: XCirculateEvent;
    xcirculaterequest: XCirculateRequestEvent;
    xproperty: XPropertyEvent;
    xselectionclear: XSelectionClearEvent;
    xselectionrequest: XSelectionRequestEvent;
    xselection: XSelectionEvent;
    xcolormap: XColormapEvent;
    xclient: XClientMessageEvent;
    xmapping: XMappingEvent;
    xerror: XErrorEvent;
    xkeymap: XKeymapEvent;
    xgeneric: XGenericEvent;
    xcookie: XGenericEventCookie;
    pad: [24] s64;
}
XEvent :: _XEvent;
XCharStruct :: struct {
    lbearing: s16;
    rbearing: s16;
    width: s16;
    ascent: s16;
    descent: s16;
    attributes: u16;
}
XFontProp :: struct {
    name: Atom;
    card32: u64;
}
XFontStruct :: struct {
    ext_data: *XExtData;
    fid: Font;
    direction: u32;
    min_char_or_byte2: u32;
    max_char_or_byte2: u32;
    min_byte1: u32;
    max_byte1: u32;
    all_chars_exist: s32;
    default_char: u32;
    n_properties: s32;
    properties: *XFontProp;
    min_bounds: XCharStruct;
    max_bounds: XCharStruct;
    per_char: *XCharStruct;
    ascent: s32;
    descent: s32;
}
XTextItem :: struct {
    chars: *u8;
    nchars: s32;
    delta: s32;
    font: Font;
}
XChar2b :: struct {
    byte1: u8;
    byte2: u8;
}
XTextItem16 :: struct {
    chars: *XChar2b;
    nchars: s32;
    delta: s32;
    font: Font;
}
XEDataObject :: union {
    display: *Display;
    gc: GC;
    visual: *Visual;
    screen: *Screen;
    pixmap_format: *ScreenFormat;
    font: *XFontStruct;
}
XFontSetExtents :: struct {
    max_ink_extent: XRectangle;
    max_logical_extent: XRectangle;
}
_XOM :: struct {}
XOM :: *_XOM;
_XOC :: struct {}
XOC :: *_XOC;
XFontSet :: *_XOC;
XmbTextItem :: struct {
    chars: *u8;
    nchars: s32;
    delta: s32;
    font_set: XFontSet;
}
XwcTextItem :: struct {
    chars: *wchar_t;
    nchars: s32;
    delta: s32;
    font_set: XFontSet;
}
XOMCharSetList :: struct {
    charset_count: s32;
    charset_list: **u8;
}
using XOrientation :: enum u32 {
    XOMOrientation_LTR_TTB :: 0;
    XOMOrientation_RTL_TTB :: 1;
    XOMOrientation_TTB_LTR :: 2;
    XOMOrientation_TTB_RTL :: 3;
    XOMOrientation_Context :: 4;
}
XOMOrientation :: struct {
    num_orientation: s32;
    orientation: *XOrientation;
}
XOMFontInfo :: struct {
    num_font: s32;
    font_struct_list: **XFontStruct;
    font_name_list: **u8;
}
_XIM :: struct {}
XIM :: *_XIM;
_XIC :: struct {}
XIC :: *_XIC;
XIMProc :: #type (a0: XIM, a1: XPointer, a2: XPointer) -> void #c_call;
XICProc :: #type (a0: XIC, a1: XPointer, a2: XPointer) -> s32 #c_call;
XIDProc :: #type (a0: *Display, a1: XPointer, a2: XPointer) -> void #c_call;
XIMStyle :: u64;
XIMStyles :: struct {
    count_styles: u16;
    supported_styles: *XIMStyle;
}
XVaNestedList :: *void;
XIMCallback :: struct {
    client_data: XPointer;
    callback: XIMProc;
}
XICCallback :: struct {
    client_data: XPointer;
    callback: XICProc;
}
XIMFeedback :: u64;
_XIMText :: struct {
    length: u16;
    feedback: *XIMFeedback;
    encoding_is_wchar: s32;
    _string: union {
        multi_byte: *u8;
        wide_char: *wchar_t;
    }
    ;
}
XIMText :: _XIMText;
XIMPreeditState :: u64;
_XIMPreeditStateNotifyCallbackStruct :: struct {
    state: XIMPreeditState;
}
XIMPreeditStateNotifyCallbackStruct :: _XIMPreeditStateNotifyCallbackStruct;
XIMResetState :: u64;
XIMStringConversionFeedback :: u64;
_XIMStringConversionText :: struct {
    length: u16;
    feedback: *XIMStringConversionFeedback;
    encoding_is_wchar: s32;
    _string: union {
        mbs: *u8;
        wcs: *wchar_t;
    }
    ;
}
XIMStringConversionText :: _XIMStringConversionText;
XIMStringConversionPosition :: u16;
XIMStringConversionType :: u16;
XIMStringConversionOperation :: u16;
using XIMCaretDirection :: enum u32 {
    XIMForwardChar :: 0;
    XIMBackwardChar :: 1;
    XIMForwardWord :: 2;
    XIMBackwardWord :: 3;
    XIMCaretUp :: 4;
    XIMCaretDown :: 5;
    XIMNextLine :: 6;
    XIMPreviousLine :: 7;
    XIMLineStart :: 8;
    XIMLineEnd :: 9;
    XIMAbsolutePosition :: 10;
    XIMDontChange :: 11;
}
_XIMStringConversionCallbackStruct :: struct {
    position: XIMStringConversionPosition;
    direction: XIMCaretDirection;
    operation: XIMStringConversionOperation;
    factor: u16;
    text: *XIMStringConversionText;
}
XIMStringConversionCallbackStruct :: _XIMStringConversionCallbackStruct;
_XIMPreeditDrawCallbackStruct :: struct {
    caret: s32;
    chg_first: s32;
    chg_length: s32;
    text: *XIMText;
}
XIMPreeditDrawCallbackStruct :: _XIMPreeditDrawCallbackStruct;
using XIMCaretStyle :: enum u32 {
    XIMIsInvisible :: 0;
    XIMIsPrimary :: 1;
    XIMIsSecondary :: 2;
}
_XIMPreeditCaretCallbackStruct :: struct {
    position: s32;
    direction: XIMCaretDirection;
    style: XIMCaretStyle;
}
XIMPreeditCaretCallbackStruct :: _XIMPreeditCaretCallbackStruct;
using XIMStatusDataType :: enum u32 {
    XIMTextType :: 0;
    XIMBitmapType :: 1;
}
_XIMStatusDrawCallbackStruct :: struct {
    type: XIMStatusDataType;
    data: union {
        text: *XIMText;
        bitmap: Pixmap;
    }
    ;
}
XIMStatusDrawCallbackStruct :: _XIMStatusDrawCallbackStruct;
_XIMHotKeyTrigger :: struct {
    keysym: KeySym;
    modifier: s32;
    modifier_mask: s32;
}
XIMHotKeyTrigger :: _XIMHotKeyTrigger;
_XIMHotKeyTriggers :: struct {
    num_hot_key: s32;
    key: *XIMHotKeyTrigger;
}
XIMHotKeyTriggers :: _XIMHotKeyTriggers;
XIMHotKeyState :: u64;
XIMValuesList :: struct {
    count_values: u16;
    supported_values: **u8;
}
_Xdebug: s32;
XLoadQueryFont :: (unk0: *Display, unk1: *u8) -> *XFontStruct #foreign libX11;
XQueryFont :: (unk0: *Display, unk1: XID) -> *XFontStruct #foreign libX11;
XGetMotionEvents :: (unk0: *Display, unk1: Window, unk2: Time, unk3: Time, unk4: *s32) -> *XTimeCoord #foreign libX11;
XDeleteModifiermapEntry :: (unk0: *XModifierKeymap, unk1: KeyCode, unk2: s32) -> *XModifierKeymap #foreign libX11;
XGetModifierMapping :: (unk0: *Display) -> *XModifierKeymap #foreign libX11;
XInsertModifiermapEntry :: (unk0: *XModifierKeymap, unk1: KeyCode, unk2: s32) -> *XModifierKeymap #foreign libX11;
XNewModifiermap :: (unk0: s32) -> *XModifierKeymap #foreign libX11;
XCreateImage :: (unk0: *Display, unk1: *Visual, unk2: u32, unk3: s32, unk4: s32, unk5: *u8, unk6: u32, unk7: u32, unk8: s32, unk9: s32) -> *XImage #foreign libX11;
XDestroyImage :: (img: *XImage) #foreign libX11;
XInitImage :: (unk0: *XImage) -> s32 #foreign libX11;
XGetImage :: (unk0: *Display, unk1: Drawable, unk2: s32, unk3: s32, unk4: u32, unk5: u32, unk6: u64, unk7: s32) -> *XImage #foreign libX11;
XGetSubImage :: (unk0: *Display, unk1: Drawable, unk2: s32, unk3: s32, unk4: u32, unk5: u32, unk6: u64, unk7: s32, unk8: *XImage, unk9: s32, unk10: s32) -> *XImage #foreign libX11;
XOpenDisplay :: (unk0: *u8) -> *Display #foreign libX11;
XrmInitialize :: () -> void #foreign libX11;
XFetchBytes :: (unk0: *Display, unk1: *s32) -> *u8 #foreign libX11;
XFetchBuffer :: (unk0: *Display, unk1: *s32, unk2: s32) -> *u8 #foreign libX11;
XGetAtomName :: (unk0: *Display, unk1: Atom) -> *u8 #foreign libX11;
XGetAtomNames :: (unk0: *Display, unk1: *Atom, unk2: s32, unk3: **u8) -> s32 #foreign libX11;
XGetDefault :: (unk0: *Display, unk1: *u8, unk2: *u8) -> *u8 #foreign libX11;
XDisplayName :: (unk0: *u8) -> *u8 #foreign libX11;
XKeysymToString :: (unk0: KeySym) -> *u8 #foreign libX11;
XSynchronize :: (unk0: *Display, unk1: *Display, unk2: s32) -> ((a0: *Display) -> s32 #c_call) #foreign libX11;
XSetAfterFunction :: (unk0: *Display, unk1: *Display, unk2: #type (a0: *Display) -> s32 #c_call) -> ((a0: *Display) -> s32 #c_call) #foreign libX11;
XInternAtom :: (unk0: *Display, unk1: *u8, unk2: s32) -> Atom #foreign libX11;
XInternAtoms :: (unk0: *Display, unk1: **u8, unk2: s32, unk3: s32, unk4: *Atom) -> s32 #foreign libX11;
XCopyColormapAndFree :: (unk0: *Display, unk1: Colormap) -> Colormap #foreign libX11;
XCreateColormap :: (unk0: *Display, unk1: Window, unk2: *Visual, unk3: s32) -> Colormap #foreign libX11;
XCreatePixmapCursor :: (unk0: *Display, unk1: Pixmap, unk2: Pixmap, unk3: *XColor, unk4: *XColor, unk5: u32, unk6: u32) -> Cursor #foreign libX11;
XCreateGlyphCursor :: (unk0: *Display, unk1: Font, unk2: Font, unk3: u32, unk4: u32, unk5: *XColor, unk6: *XColor) -> Cursor #foreign libX11;
XCreateFontCursor :: (unk0: *Display, unk1: u32) -> Cursor #foreign libX11;
XLoadFont :: (unk0: *Display, unk1: *u8) -> Font #foreign libX11;
XCreateGC :: (unk0: *Display, unk1: Drawable, unk2: u64, unk3: *XGCValues) -> GC #foreign libX11;
XGContextFromGC :: (unk0: GC) -> GContext #foreign libX11;
XFlushGC :: (unk0: *Display, unk1: GC) -> void #foreign libX11;
XCreatePixmap :: (unk0: *Display, unk1: Drawable, unk2: u32, unk3: u32, unk4: u32) -> Pixmap #foreign libX11;
XCreateBitmapFromData :: (unk0: *Display, unk1: Drawable, unk2: *u8, unk3: u32, unk4: u32) -> Pixmap #foreign libX11;
XCreatePixmapFromBitmapData :: (unk0: *Display, unk1: Drawable, unk2: *u8, unk3: u32, unk4: u32, unk5: u64, unk6: u64, unk7: u32) -> Pixmap #foreign libX11;
XCreateSimpleWindow :: (unk0: *Display, unk1: Window, unk2: s32, unk3: s32, unk4: u32, unk5: u32, unk6: u32, unk7: u64, unk8: u64) -> Window #foreign libX11;
XGetSelectionOwner :: (unk0: *Display, unk1: Atom) -> Window #foreign libX11;
XCreateWindow :: (unk0: *Display, unk1: Window, unk2: s32, unk3: s32, unk4: u32, unk5: u32, unk6: u32, unk7: s32, unk8: u32, unk9: *Visual, unk10: u64, unk11: *XSetWindowAttributes) -> Window #foreign libX11;
XListInstalledColormaps :: (unk0: *Display, unk1: Window, unk2: *s32) -> *Colormap #foreign libX11;
XListFonts :: (unk0: *Display, unk1: *u8, unk2: s32, unk3: *s32) -> **u8 #foreign libX11;
XListFontsWithInfo :: (unk0: *Display, unk1: *u8, unk2: s32, unk3: *s32, unk4: **XFontStruct) -> **u8 #foreign libX11;
XGetFontPath :: (unk0: *Display, unk1: *s32) -> **u8 #foreign libX11;
XListExtensions :: (unk0: *Display, unk1: *s32) -> **u8 #foreign libX11;
XListProperties :: (unk0: *Display, unk1: Window, unk2: *s32) -> *Atom #foreign libX11;
XListHosts :: (unk0: *Display, unk1: *s32, unk2: *s32) -> *XHostAddress #foreign libX11;
XKeycodeToKeysym :: (unk0: *Display, unk1: KeyCode, unk2: s32) -> KeySym #foreign libX11;
XLookupKeysym :: (unk0: *XKeyEvent, unk1: s32) -> KeySym #foreign libX11;
XGetKeyboardMapping :: (unk0: *Display, unk1: KeyCode, unk2: s32, unk3: *s32) -> *KeySym #foreign libX11;
XStringToKeysym :: (unk0: *u8) -> KeySym #foreign libX11;
XMaxRequestSize :: (unk0: *Display) -> s64 #foreign libX11;
XExtendedMaxRequestSize :: (unk0: *Display) -> s64 #foreign libX11;
XResourceManagerString :: (unk0: *Display) -> *u8 #foreign libX11;
XScreenResourceString :: (unk0: *Screen) -> *u8 #foreign libX11;
XDisplayMotionBufferSize :: (unk0: *Display) -> u64 #foreign libX11;
XVisualIDFromVisual :: (unk0: *Visual) -> VisualID #foreign libX11;
XInitThreads :: () -> s32 #foreign libX11;
XLockDisplay :: (unk0: *Display) -> void #foreign libX11;
XUnlockDisplay :: (unk0: *Display) -> void #foreign libX11;
XInitExtension :: (unk0: *Display, unk1: *u8) -> *XExtCodes #foreign libX11;
XAddExtension :: (unk0: *Display) -> *XExtCodes #foreign libX11;
XFindOnExtensionList :: (unk0: **XExtData, unk1: s32) -> *XExtData #foreign libX11;
XEHeadOfExtensionList :: (unk0: XEDataObject) -> **XExtData #foreign libX11;
XRootWindow :: (unk0: *Display, unk1: s32) -> Window #foreign libX11;
XDefaultRootWindow :: (unk0: *Display) -> Window #foreign libX11;
XRootWindowOfScreen :: (unk0: *Screen) -> Window #foreign libX11;
XDefaultVisual :: (unk0: *Display, unk1: s32) -> *Visual #foreign libX11;
XDefaultVisualOfScreen :: (unk0: *Screen) -> *Visual #foreign libX11;
XDefaultGC :: (unk0: *Display, unk1: s32) -> GC #foreign libX11;
XDefaultGCOfScreen :: (unk0: *Screen) -> GC #foreign libX11;
XBlackPixel :: (unk0: *Display, unk1: s32) -> u64 #foreign libX11;
XWhitePixel :: (unk0: *Display, unk1: s32) -> u64 #foreign libX11;
XAllPlanes :: () -> u64 #foreign libX11;
XBlackPixelOfScreen :: (unk0: *Screen) -> u64 #foreign libX11;
XWhitePixelOfScreen :: (unk0: *Screen) -> u64 #foreign libX11;
XNextRequest :: (unk0: *Display) -> u64 #foreign libX11;
XLastKnownRequestProcessed :: (unk0: *Display) -> u64 #foreign libX11;
XServerVendor :: (unk0: *Display) -> *u8 #foreign libX11;
XDisplayString :: (unk0: *Display) -> *u8 #foreign libX11;
XDefaultColormap :: (unk0: *Display, unk1: s32) -> Colormap #foreign libX11;
XDefaultColormapOfScreen :: (unk0: *Screen) -> Colormap #foreign libX11;
XDisplayOfScreen :: (unk0: *Screen) -> *Display #foreign libX11;
XScreenOfDisplay :: (unk0: *Display, unk1: s32) -> *Screen #foreign libX11;
XDefaultScreenOfDisplay :: (unk0: *Display) -> *Screen #foreign libX11;
XEventMaskOfScreen :: (unk0: *Screen) -> s64 #foreign libX11;
XScreenNumberOfScreen :: (unk0: *Screen) -> s32 #foreign libX11;
XErrorHandler :: #type (a0: *Display, a1: *XErrorEvent) -> s32 #c_call;
XSetErrorHandler :: (unk0: XErrorHandler) -> XErrorHandler #foreign libX11;
XIOErrorHandler :: #type (a0: *Display) -> s32 #c_call;
XSetIOErrorHandler :: (unk0: XIOErrorHandler) -> XIOErrorHandler #foreign libX11;
XListPixmapFormats :: (unk0: *Display, unk1: *s32) -> *XPixmapFormatValues #foreign libX11;
XListDepths :: (unk0: *Display, unk1: s32, unk2: *s32) -> *s32 #foreign libX11;
XReconfigureWMWindow :: (unk0: *Display, unk1: Window, unk2: s32, unk3: u32, unk4: *XWindowChanges) -> s32 #foreign libX11;
XGetWMProtocols :: (unk0: *Display, unk1: Window, unk2: **Atom, unk3: *s32) -> s32 #foreign libX11;
XSetWMProtocols :: (unk0: *Display, unk1: Window, unk2: *Atom, unk3: s32) -> s32 #foreign libX11;
XIconifyWindow :: (unk0: *Display, unk1: Window, unk2: s32) -> s32 #foreign libX11;
XWithdrawWindow :: (unk0: *Display, unk1: Window, unk2: s32) -> s32 #foreign libX11;
XGetCommand :: (unk0: *Display, unk1: Window, unk2: ***u8, unk3: *s32) -> s32 #foreign libX11;
XGetWMColormapWindows :: (unk0: *Display, unk1: Window, unk2: **Window, unk3: *s32) -> s32 #foreign libX11;
XSetWMColormapWindows :: (unk0: *Display, unk1: Window, unk2: *Window, unk3: s32) -> s32 #foreign libX11;
XFreeStringList :: (unk0: **u8) -> void #foreign libX11;
XSetTransientForHint :: (unk0: *Display, unk1: Window, unk2: Window) -> s32 #foreign libX11;
XActivateScreenSaver :: (unk0: *Display) -> s32 #foreign libX11;
XAddHost :: (unk0: *Display, unk1: *XHostAddress) -> s32 #foreign libX11;
XAddHosts :: (unk0: *Display, unk1: *XHostAddress, unk2: s32) -> s32 #foreign libX11;
XAddToExtensionList :: (unk0: **_XExtData, unk1: *XExtData) -> s32 #foreign libX11;
XAddToSaveSet :: (unk0: *Display, unk1: Window) -> s32 #foreign libX11;
XAllocColor :: (unk0: *Display, unk1: Colormap, unk2: *XColor) -> s32 #foreign libX11;
XAllocColorCells :: (unk0: *Display, unk1: Colormap, unk2: s32, unk3: *u64, unk4: u32, unk5: *u64, unk6: u32) -> s32 #foreign libX11;
XAllocColorPlanes :: (unk0: *Display, unk1: Colormap, unk2: s32, unk3: *u64, unk4: s32, unk5: s32, unk6: s32, unk7: s32, unk8: *u64, unk9: *u64, unk10: *u64) -> s32 #foreign libX11;
XAllocNamedColor :: (unk0: *Display, unk1: Colormap, unk2: *u8, unk3: *XColor, unk4: *XColor) -> s32 #foreign libX11;
XAllowEvents :: (unk0: *Display, unk1: s32, unk2: Time) -> s32 #foreign libX11;
XAutoRepeatOff :: (unk0: *Display) -> s32 #foreign libX11;
XAutoRepeatOn :: (unk0: *Display) -> s32 #foreign libX11;
XBell :: (unk0: *Display, unk1: s32) -> s32 #foreign libX11;
XBitmapBitOrder :: (unk0: *Display) -> s32 #foreign libX11;
XBitmapPad :: (unk0: *Display) -> s32 #foreign libX11;
XBitmapUnit :: (unk0: *Display) -> s32 #foreign libX11;
XCellsOfScreen :: (unk0: *Screen) -> s32 #foreign libX11;
XChangeActivePointerGrab :: (unk0: *Display, unk1: u32, unk2: Cursor, unk3: Time) -> s32 #foreign libX11;
XChangeGC :: (unk0: *Display, unk1: GC, unk2: u64, unk3: *XGCValues) -> s32 #foreign libX11;
XChangeKeyboardControl :: (unk0: *Display, unk1: u64, unk2: *XKeyboardControl) -> s32 #foreign libX11;
XChangeKeyboardMapping :: (unk0: *Display, unk1: s32, unk2: s32, unk3: *KeySym, unk4: s32) -> s32 #foreign libX11;
XChangePointerControl :: (unk0: *Display, unk1: s32, unk2: s32, unk3: s32, unk4: s32, unk5: s32) -> s32 #foreign libX11;
XChangeProperty :: (unk0: *Display, unk1: Window, unk2: Atom, unk3: Atom, unk4: s32, unk5: s32, unk6: *u8, unk7: s32) -> s32 #foreign libX11;
XChangeSaveSet :: (unk0: *Display, unk1: Window, unk2: s32) -> s32 #foreign libX11;
XChangeWindowAttributes :: (unk0: *Display, unk1: Window, unk2: u64, unk3: *XSetWindowAttributes) -> s32 #foreign libX11;
XCheckIfEvent :: (unk0: *Display, unk1: *XEvent, unk2: #type (a0: *Display, a1: *XEvent, a2: XPointer) -> s32 #c_call , unk3: XPointer) -> s32 #foreign libX11;
XCheckMaskEvent :: (unk0: *Display, unk1: s64, unk2: *XEvent) -> s32 #foreign libX11;
XCheckTypedEvent :: (unk0: *Display, unk1: s32, unk2: *XEvent) -> s32 #foreign libX11;
XCheckTypedWindowEvent :: (unk0: *Display, unk1: Window, unk2: s32, unk3: *XEvent) -> s32 #foreign libX11;
XCheckWindowEvent :: (unk0: *Display, unk1: Window, unk2: s64, unk3: *XEvent) -> s32 #foreign libX11;
XCirculateSubwindows :: (unk0: *Display, unk1: Window, unk2: s32) -> s32 #foreign libX11;
XCirculateSubwindowsDown :: (unk0: *Display, unk1: Window) -> s32 #foreign libX11;
XCirculateSubwindowsUp :: (unk0: *Display, unk1: Window) -> s32 #foreign libX11;
XClearArea :: (unk0: *Display, unk1: Window, unk2: s32, unk3: s32, unk4: u32, unk5: u32, unk6: s32) -> s32 #foreign libX11;
XClearWindow :: (unk0: *Display, unk1: Window) -> s32 #foreign libX11;
XCloseDisplay :: (unk0: *Display) -> s32 #foreign libX11;
XConfigureWindow :: (unk0: *Display, unk1: Window, unk2: u32, unk3: *XWindowChanges) -> s32 #foreign libX11;
XConnectionNumber :: (unk0: *Display) -> s32 #foreign libX11;
XConvertSelection :: (unk0: *Display, unk1: Atom, unk2: Atom, unk3: Atom, unk4: Window, unk5: Time) -> s32 #foreign libX11;
XCopyArea :: (unk0: *Display, unk1: Drawable, unk2: Drawable, unk3: GC, unk4: s32, unk5: s32, unk6: u32, unk7: u32, unk8: s32, unk9: s32) -> s32 #foreign libX11;
XCopyGC :: (unk0: *Display, unk1: GC, unk2: u64, unk3: GC) -> s32 #foreign libX11;
XCopyPlane :: (unk0: *Display, unk1: Drawable, unk2: Drawable, unk3: GC, unk4: s32, unk5: s32, unk6: u32, unk7: u32, unk8: s32, unk9: s32, unk10: u64) -> s32 #foreign libX11;
XDefaultDepth :: (unk0: *Display, unk1: s32) -> s32 #foreign libX11;
XDefaultDepthOfScreen :: (unk0: *Screen) -> s32 #foreign libX11;
XDefaultScreen :: (unk0: *Display) -> s32 #foreign libX11;
XDefineCursor :: (unk0: *Display, unk1: Window, unk2: Cursor) -> s32 #foreign libX11;
XDeleteProperty :: (unk0: *Display, unk1: Window, unk2: Atom) -> s32 #foreign libX11;
XDestroyWindow :: (unk0: *Display, unk1: Window) -> s32 #foreign libX11;
XDestroySubwindows :: (unk0: *Display, unk1: Window) -> s32 #foreign libX11;
XDoesBackingStore :: (unk0: *Screen) -> s32 #foreign libX11;
XDoesSaveUnders :: (unk0: *Screen) -> s32 #foreign libX11;
XDisableAccessControl :: (unk0: *Display) -> s32 #foreign libX11;
XDisplayCells :: (unk0: *Display, unk1: s32) -> s32 #foreign libX11;
XDisplayHeight :: (unk0: *Display, unk1: s32) -> s32 #foreign libX11;
XDisplayHeightMM :: (unk0: *Display, unk1: s32) -> s32 #foreign libX11;
XDisplayKeycodes :: (unk0: *Display, unk1: *s32, unk2: *s32) -> s32 #foreign libX11;
XDisplayPlanes :: (unk0: *Display, unk1: s32) -> s32 #foreign libX11;
XDisplayWidth :: (unk0: *Display, unk1: s32) -> s32 #foreign libX11;
XDisplayWidthMM :: (unk0: *Display, unk1: s32) -> s32 #foreign libX11;
XDrawArc :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: s32, unk4: s32, unk5: u32, unk6: u32, unk7: s32, unk8: s32) -> s32 #foreign libX11;
XDrawArcs :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: *XArc, unk4: s32) -> s32 #foreign libX11;
XDrawImageString :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: s32, unk4: s32, unk5: *u8, unk6: s32) -> s32 #foreign libX11;
XDrawImageString16 :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: s32, unk4: s32, unk5: *XChar2b, unk6: s32) -> s32 #foreign libX11;
XDrawLine :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: s32, unk4: s32, unk5: s32, unk6: s32) -> s32 #foreign libX11;
XDrawLines :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: *XPoint, unk4: s32, unk5: s32) -> s32 #foreign libX11;
XDrawPoint :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: s32, unk4: s32) -> s32 #foreign libX11;
XDrawPoints :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: *XPoint, unk4: s32, unk5: s32) -> s32 #foreign libX11;
XDrawRectangle :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: s32, unk4: s32, unk5: u32, unk6: u32) -> s32 #foreign libX11;
XDrawRectangles :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: *XRectangle, unk4: s32) -> s32 #foreign libX11;
XDrawSegments :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: *XSegment, unk4: s32) -> s32 #foreign libX11;
XDrawString :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: s32, unk4: s32, unk5: *u8, unk6: s32) -> s32 #foreign libX11;
XDrawString16 :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: s32, unk4: s32, unk5: *XChar2b, unk6: s32) -> s32 #foreign libX11;
XDrawText :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: s32, unk4: s32, unk5: *XTextItem, unk6: s32) -> s32 #foreign libX11;
XDrawText16 :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: s32, unk4: s32, unk5: *XTextItem16, unk6: s32) -> s32 #foreign libX11;
XEnableAccessControl :: (unk0: *Display) -> s32 #foreign libX11;
XEventsQueued :: (unk0: *Display, unk1: s32) -> s32 #foreign libX11;
XFetchName :: (unk0: *Display, unk1: Window, unk2: **u8) -> s32 #foreign libX11;
XFillArc :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: s32, unk4: s32, unk5: u32, unk6: u32, unk7: s32, unk8: s32) -> s32 #foreign libX11;
XFillArcs :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: *XArc, unk4: s32) -> s32 #foreign libX11;
XFillPolygon :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: *XPoint, unk4: s32, unk5: s32, unk6: s32) -> s32 #foreign libX11;
XFillRectangle :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: s32, unk4: s32, unk5: u32, unk6: u32) -> s32 #foreign libX11;
XFillRectangles :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: *XRectangle, unk4: s32) -> s32 #foreign libX11;
XFlush :: (unk0: *Display) -> s32 #foreign libX11;
XForceScreenSaver :: (unk0: *Display, unk1: s32) -> s32 #foreign libX11;
XFree :: (unk0: *void) -> s32 #foreign libX11;
XFreeColormap :: (unk0: *Display, unk1: Colormap) -> s32 #foreign libX11;
XFreeColors :: (unk0: *Display, unk1: Colormap, unk2: *u64, unk3: s32, unk4: u64) -> s32 #foreign libX11;
XFreeCursor :: (unk0: *Display, unk1: Cursor) -> s32 #foreign libX11;
XFreeExtensionList :: (unk0: **u8) -> s32 #foreign libX11;
XFreeFont :: (unk0: *Display, unk1: *XFontStruct) -> s32 #foreign libX11;
XFreeFontInfo :: (unk0: **u8, unk1: *XFontStruct, unk2: s32) -> s32 #foreign libX11;
XFreeFontNames :: (unk0: **u8) -> s32 #foreign libX11;
XFreeFontPath :: (unk0: **u8) -> s32 #foreign libX11;
XFreeGC :: (unk0: *Display, gc: GC) -> s32 #foreign libX11;
XFreeModifiermap :: (unk0: *XModifierKeymap) -> s32 #foreign libX11;
XFreePixmap :: (unk0: *Display, unk1: Pixmap) -> s32 #foreign libX11;
XGeometry :: (unk0: *Display, unk1: s32, unk2: *u8, unk3: *u8, unk4: u32, unk5: u32, unk6: u32, unk7: s32, unk8: s32, unk9: *s32, unk10: *s32, unk11: *s32, unk12: *s32) -> s32 #foreign libX11;
XGetErrorDatabaseText :: (unk0: *Display, unk1: *u8, unk2: *u8, unk3: *u8, unk4: *u8, unk5: s32) -> s32 #foreign libX11;
XGetErrorText :: (unk0: *Display, unk1: s32, unk2: *u8, unk3: s32) -> s32 #foreign libX11;
XGetFontProperty :: (unk0: *XFontStruct, unk1: Atom, unk2: *u64) -> s32 #foreign libX11;
XGetGCValues :: (unk0: *Display, unk1: GC, unk2: u64, unk3: *XGCValues) -> s32 #foreign libX11;
XGetGeometry :: (unk0: *Display, unk1: Drawable, unk2: *Window, unk3: *s32, unk4: *s32, unk5: *u32, unk6: *u32, unk7: *u32, unk8: *u32) -> s32 #foreign libX11;
XGetIconName :: (unk0: *Display, unk1: Window, unk2: **u8) -> s32 #foreign libX11;
XGetInputFocus :: (unk0: *Display, unk1: *Window, unk2: *s32) -> s32 #foreign libX11;
XGetKeyboardControl :: (unk0: *Display, unk1: *XKeyboardState) -> s32 #foreign libX11;
XGetPointerControl :: (unk0: *Display, unk1: *s32, unk2: *s32, unk3: *s32) -> s32 #foreign libX11;
XGetPointerMapping :: (unk0: *Display, unk1: *u8, unk2: s32) -> s32 #foreign libX11;
XGetScreenSaver :: (unk0: *Display, unk1: *s32, unk2: *s32, unk3: *s32, unk4: *s32) -> s32 #foreign libX11;
XGetTransientForHint :: (unk0: *Display, unk1: Window, unk2: *Window) -> s32 #foreign libX11;
XGetWindowProperty :: (unk0: *Display, unk1: Window, unk2: Atom, unk3: s64, unk4: s64, unk5: s32, unk6: Atom, unk7: *Atom, unk8: *s32, unk9: *u64, unk10: *u64, unk11: **u8) -> s32 #foreign libX11;
XGetWindowAttributes :: (unk0: *Display, unk1: Window, unk2: *XWindowAttributes) -> s32 #foreign libX11;
XGrabButton :: (unk0: *Display, unk1: u32, unk2: u32, unk3: Window, unk4: s32, unk5: u32, unk6: s32, unk7: s32, unk8: Window, unk9: Cursor) -> s32 #foreign libX11;
XGrabKey :: (unk0: *Display, unk1: s32, unk2: u32, unk3: Window, unk4: s32, unk5: s32, unk6: s32) -> s32 #foreign libX11;
XGrabKeyboard :: (unk0: *Display, unk1: Window, unk2: s32, unk3: s32, unk4: s32, unk5: Time) -> s32 #foreign libX11;
XGrabPointer :: (unk0: *Display, unk1: Window, unk2: s32, unk3: u32, unk4: s32, unk5: s32, unk6: Window, unk7: Cursor, unk8: Time) -> s32 #foreign libX11;
XGrabServer :: (unk0: *Display) -> s32 #foreign libX11;
XHeightMMOfScreen :: (unk0: *Screen) -> s32 #foreign libX11;
XHeightOfScreen :: (unk0: *Screen) -> s32 #foreign libX11;
XIfEvent :: (unk0: *Display, unk1: *XEvent, unk2: #type (a0: *Display, a1: *XEvent, a2: XPointer) -> s32 #c_call , unk3: XPointer) -> s32 #foreign libX11;
XImageByteOrder :: (unk0: *Display) -> s32 #foreign libX11;
XInstallColormap :: (unk0: *Display, unk1: Colormap) -> s32 #foreign libX11;
XKeysymToKeycode :: (unk0: *Display, unk1: KeySym) -> KeyCode #foreign libX11;
XKillClient :: (unk0: *Display, unk1: XID) -> s32 #foreign libX11;
XLookupColor :: (unk0: *Display, unk1: Colormap, unk2: *u8, unk3: *XColor, unk4: *XColor) -> s32 #foreign libX11;
XLowerWindow :: (unk0: *Display, unk1: Window) -> s32 #foreign libX11;
XMapRaised :: (unk0: *Display, unk1: Window) -> s32 #foreign libX11;
XMapSubwindows :: (unk0: *Display, unk1: Window) -> s32 #foreign libX11;
XMapWindow :: (unk0: *Display, unk1: Window) -> s32 #foreign libX11;
XMaskEvent :: (unk0: *Display, unk1: s64, unk2: *XEvent) -> s32 #foreign libX11;
XMaxCmapsOfScreen :: (unk0: *Screen) -> s32 #foreign libX11;
XMinCmapsOfScreen :: (unk0: *Screen) -> s32 #foreign libX11;
XMoveResizeWindow :: (unk0: *Display, unk1: Window, unk2: s32, unk3: s32, unk4: u32, unk5: u32) -> s32 #foreign libX11;
XMoveWindow :: (unk0: *Display, unk1: Window, unk2: s32, unk3: s32) -> s32 #foreign libX11;
XNextEvent :: (unk0: *Display, unk1: *XEvent) -> s32 #foreign libX11;
XNoOp :: (unk0: *Display) -> s32 #foreign libX11;
XParseColor :: (unk0: *Display, unk1: Colormap, unk2: *u8, unk3: *XColor) -> s32 #foreign libX11;
XParseGeometry :: (unk0: *u8, unk1: *s32, unk2: *s32, unk3: *u32, unk4: *u32) -> s32 #foreign libX11;
XPeekEvent :: (unk0: *Display, unk1: *XEvent) -> s32 #foreign libX11;
XPeekIfEvent :: (unk0: *Display, unk1: *XEvent, unk2: #type (a0: *Display, a1: *XEvent, a2: XPointer) -> s32 #c_call , unk3: XPointer) -> s32 #foreign libX11;
XPending :: (unk0: *Display) -> s32 #foreign libX11;
XPlanesOfScreen :: (unk0: *Screen) -> s32 #foreign libX11;
XProtocolRevision :: (unk0: *Display) -> s32 #foreign libX11;
XProtocolVersion :: (unk0: *Display) -> s32 #foreign libX11;
XPutBackEvent :: (unk0: *Display, unk1: *XEvent) -> s32 #foreign libX11;
XPutImage :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: *XImage, unk4: s32, unk5: s32, unk6: s32, unk7: s32, unk8: u32, unk9: u32) -> s32 #foreign libX11;
XQLength :: (unk0: *Display) -> s32 #foreign libX11;
XQueryBestCursor :: (unk0: *Display, unk1: Drawable, unk2: u32, unk3: u32, unk4: *u32, unk5: *u32) -> s32 #foreign libX11;
XQueryBestSize :: (unk0: *Display, unk1: s32, unk2: Drawable, unk3: u32, unk4: u32, unk5: *u32, unk6: *u32) -> s32 #foreign libX11;
XQueryBestStipple :: (unk0: *Display, unk1: Drawable, unk2: u32, unk3: u32, unk4: *u32, unk5: *u32) -> s32 #foreign libX11;
XQueryBestTile :: (unk0: *Display, unk1: Drawable, unk2: u32, unk3: u32, unk4: *u32, unk5: *u32) -> s32 #foreign libX11;
XQueryColor :: (unk0: *Display, unk1: Colormap, unk2: *XColor) -> s32 #foreign libX11;
XQueryColors :: (unk0: *Display, unk1: Colormap, unk2: *XColor, unk3: s32) -> s32 #foreign libX11;
XQueryExtension :: (unk0: *Display, unk1: *u8, unk2: *s32, unk3: *s32, unk4: *s32) -> s32 #foreign libX11;
XQueryKeymap :: (unk0: *Display, unk1: *[32] u8) -> s32 #foreign libX11;
XQueryPointer :: (unk0: *Display, unk1: Window, unk2: *Window, unk3: *Window, unk4: *s32, unk5: *s32, unk6: *s32, unk7: *s32, unk8: *u32) -> s32 #foreign libX11;
XQueryTextExtents :: (unk0: *Display, unk1: XID, unk2: *u8, unk3: s32, unk4: *s32, unk5: *s32, unk6: *s32, unk7: *XCharStruct) -> s32 #foreign libX11;
XQueryTextExtents16 :: (unk0: *Display, unk1: XID, unk2: *XChar2b, unk3: s32, unk4: *s32, unk5: *s32, unk6: *s32, unk7: *XCharStruct) -> s32 #foreign libX11;
XQueryTree :: (unk0: *Display, unk1: Window, unk2: *Window, unk3: *Window, unk4: **Window, unk5: *u32) -> s32 #foreign libX11;
XRaiseWindow :: (unk0: *Display, unk1: Window) -> s32 #foreign libX11;
XReadBitmapFile :: (unk0: *Display, unk1: Drawable, unk2: *u8, unk3: *u32, unk4: *u32, unk5: *Pixmap, unk6: *s32, unk7: *s32) -> s32 #foreign libX11;
XReadBitmapFileData :: (unk0: *u8, unk1: *u32, unk2: *u32, unk3: **u8, unk4: *s32, unk5: *s32) -> s32 #foreign libX11;
XRebindKeysym :: (unk0: *Display, unk1: KeySym, unk2: *KeySym, unk3: s32, unk4: *u8, unk5: s32) -> s32 #foreign libX11;
XRecolorCursor :: (unk0: *Display, unk1: Cursor, unk2: *XColor, unk3: *XColor) -> s32 #foreign libX11;
XRefreshKeyboardMapping :: (unk0: *XMappingEvent) -> s32 #foreign libX11;
XRemoveFromSaveSet :: (unk0: *Display, unk1: Window) -> s32 #foreign libX11;
XRemoveHost :: (unk0: *Display, unk1: *XHostAddress) -> s32 #foreign libX11;
XRemoveHosts :: (unk0: *Display, unk1: *XHostAddress, unk2: s32) -> s32 #foreign libX11;
XReparentWindow :: (unk0: *Display, unk1: Window, unk2: Window, unk3: s32, unk4: s32) -> s32 #foreign libX11;
XResetScreenSaver :: (unk0: *Display) -> s32 #foreign libX11;
XResizeWindow :: (unk0: *Display, unk1: Window, unk2: u32, unk3: u32) -> s32 #foreign libX11;
XRestackWindows :: (unk0: *Display, unk1: *Window, unk2: s32) -> s32 #foreign libX11;
XRotateBuffers :: (unk0: *Display, unk1: s32) -> s32 #foreign libX11;
XRotateWindowProperties :: (unk0: *Display, unk1: Window, unk2: *Atom, unk3: s32, unk4: s32) -> s32 #foreign libX11;
XScreenCount :: (unk0: *Display) -> s32 #foreign libX11;
XSelectInput :: (unk0: *Display, unk1: Window, unk2: s64) -> s32 #foreign libX11;
XSendEvent :: (unk0: *Display, unk1: Window, unk2: s32, unk3: s64, unk4: *XEvent) -> s32 #foreign libX11;
XSetAccessControl :: (unk0: *Display, unk1: s32) -> s32 #foreign libX11;
XSetArcMode :: (unk0: *Display, unk1: GC, unk2: s32) -> s32 #foreign libX11;
XSetBackground :: (unk0: *Display, unk1: GC, unk2: u64) -> s32 #foreign libX11;
XSetClipMask :: (unk0: *Display, unk1: GC, unk2: Pixmap) -> s32 #foreign libX11;
XSetClipOrigin :: (unk0: *Display, unk1: GC, unk2: s32, unk3: s32) -> s32 #foreign libX11;
XSetClipRectangles :: (unk0: *Display, unk1: GC, unk2: s32, unk3: s32, unk4: *XRectangle, unk5: s32, unk6: s32) -> s32 #foreign libX11;
XSetCloseDownMode :: (unk0: *Display, unk1: s32) -> s32 #foreign libX11;
XSetCommand :: (unk0: *Display, unk1: Window, unk2: **u8, unk3: s32) -> s32 #foreign libX11;
XSetDashes :: (unk0: *Display, unk1: GC, unk2: s32, unk3: *u8, unk4: s32) -> s32 #foreign libX11;
XSetFillRule :: (unk0: *Display, unk1: GC, unk2: s32) -> s32 #foreign libX11;
XSetFillStyle :: (unk0: *Display, unk1: GC, unk2: s32) -> s32 #foreign libX11;
XSetFont :: (unk0: *Display, unk1: GC, unk2: Font) -> s32 #foreign libX11;
XSetFontPath :: (unk0: *Display, unk1: **u8, unk2: s32) -> s32 #foreign libX11;
XSetForeground :: (unk0: *Display, unk1: GC, unk2: u64) -> s32 #foreign libX11;
XSetFunction :: (unk0: *Display, unk1: GC, unk2: s32) -> s32 #foreign libX11;
XSetGraphicsExposures :: (unk0: *Display, unk1: GC, unk2: s32) -> s32 #foreign libX11;
XSetIconName :: (unk0: *Display, unk1: Window, unk2: *u8) -> s32 #foreign libX11;
XSetInputFocus :: (unk0: *Display, unk1: Window, unk2: s32, unk3: Time) -> s32 #foreign libX11;
XSetLineAttributes :: (unk0: *Display, unk1: GC, unk2: u32, unk3: s32, unk4: s32, unk5: s32) -> s32 #foreign libX11;
XSetModifierMapping :: (unk0: *Display, unk1: *XModifierKeymap) -> s32 #foreign libX11;
XSetPlaneMask :: (unk0: *Display, unk1: GC, unk2: u64) -> s32 #foreign libX11;
XSetPointerMapping :: (unk0: *Display, unk1: *u8, unk2: s32) -> s32 #foreign libX11;
XSetScreenSaver :: (unk0: *Display, unk1: s32, unk2: s32, unk3: s32, unk4: s32) -> s32 #foreign libX11;
XSetSelectionOwner :: (unk0: *Display, unk1: Atom, unk2: Window, unk3: Time) -> s32 #foreign libX11;
XSetState :: (unk0: *Display, unk1: GC, unk2: u64, unk3: u64, unk4: s32, unk5: u64) -> s32 #foreign libX11;
XSetStipple :: (unk0: *Display, unk1: GC, unk2: Pixmap) -> s32 #foreign libX11;
XSetSubwindowMode :: (unk0: *Display, unk1: GC, unk2: s32) -> s32 #foreign libX11;
XSetTSOrigin :: (unk0: *Display, unk1: GC, unk2: s32, unk3: s32) -> s32 #foreign libX11;
XSetTile :: (unk0: *Display, unk1: GC, unk2: Pixmap) -> s32 #foreign libX11;
XSetWindowBackground :: (unk0: *Display, unk1: Window, unk2: u64) -> s32 #foreign libX11;
XSetWindowBackgroundPixmap :: (unk0: *Display, unk1: Window, unk2: Pixmap) -> s32 #foreign libX11;
XSetWindowBorder :: (unk0: *Display, unk1: Window, unk2: u64) -> s32 #foreign libX11;
XSetWindowBorderPixmap :: (unk0: *Display, unk1: Window, unk2: Pixmap) -> s32 #foreign libX11;
XSetWindowBorderWidth :: (unk0: *Display, unk1: Window, unk2: u32) -> s32 #foreign libX11;
XSetWindowColormap :: (unk0: *Display, unk1: Window, unk2: Colormap) -> s32 #foreign libX11;
XStoreBuffer :: (unk0: *Display, unk1: *u8, unk2: s32, unk3: s32) -> s32 #foreign libX11;
XStoreBytes :: (unk0: *Display, unk1: *u8, unk2: s32) -> s32 #foreign libX11;
XStoreColor :: (unk0: *Display, unk1: Colormap, unk2: *XColor) -> s32 #foreign libX11;
XStoreColors :: (unk0: *Display, unk1: Colormap, unk2: *XColor, unk3: s32) -> s32 #foreign libX11;
XStoreName :: (unk0: *Display, unk1: Window, unk2: *u8) -> s32 #foreign libX11;
XStoreNamedColor :: (unk0: *Display, unk1: Colormap, unk2: *u8, unk3: u64, unk4: s32) -> s32 #foreign libX11;
XSync :: (unk0: *Display, unk1: s32) -> s32 #foreign libX11;
XTextExtents :: (unk0: *XFontStruct, unk1: *u8, unk2: s32, unk3: *s32, unk4: *s32, unk5: *s32, unk6: *XCharStruct) -> s32 #foreign libX11;
XTextExtents16 :: (unk0: *XFontStruct, unk1: *XChar2b, unk2: s32, unk3: *s32, unk4: *s32, unk5: *s32, unk6: *XCharStruct) -> s32 #foreign libX11;
XTextWidth :: (unk0: *XFontStruct, unk1: *u8, unk2: s32) -> s32 #foreign libX11;
XTextWidth16 :: (unk0: *XFontStruct, unk1: *XChar2b, unk2: s32) -> s32 #foreign libX11;
XTranslateCoordinates :: (unk0: *Display, unk1: Window, unk2: Window, unk3: s32, unk4: s32, unk5: *s32, unk6: *s32, unk7: *Window) -> s32 #foreign libX11;
XUndefineCursor :: (unk0: *Display, unk1: Window) -> s32 #foreign libX11;
XUngrabButton :: (unk0: *Display, unk1: u32, unk2: u32, unk3: Window) -> s32 #foreign libX11;
XUngrabKey :: (unk0: *Display, unk1: s32, unk2: u32, unk3: Window) -> s32 #foreign libX11;
XUngrabKeyboard :: (unk0: *Display, unk1: Time) -> s32 #foreign libX11;
XUngrabPointer :: (unk0: *Display, unk1: Time) -> s32 #foreign libX11;
XUngrabServer :: (unk0: *Display) -> s32 #foreign libX11;
XUninstallColormap :: (unk0: *Display, unk1: Colormap) -> s32 #foreign libX11;
XUnloadFont :: (unk0: *Display, unk1: Font) -> s32 #foreign libX11;
XUnmapSubwindows :: (unk0: *Display, unk1: Window) -> s32 #foreign libX11;
XUnmapWindow :: (unk0: *Display, unk1: Window) -> s32 #foreign libX11;
XVendorRelease :: (unk0: *Display) -> s32 #foreign libX11;
XWarpPointer :: (unk0: *Display, unk1: Window, unk2: Window, unk3: s32, unk4: s32, unk5: u32, unk6: u32, unk7: s32, unk8: s32) -> s32 #foreign libX11;
XWidthMMOfScreen :: (unk0: *Screen) -> s32 #foreign libX11;
XWidthOfScreen :: (unk0: *Screen) -> s32 #foreign libX11;
XWindowEvent :: (unk0: *Display, unk1: Window, unk2: s64, unk3: *XEvent) -> s32 #foreign libX11;
XWriteBitmapFile :: (unk0: *Display, unk1: *u8, unk2: Pixmap, unk3: u32, unk4: u32, unk5: s32, unk6: s32) -> s32 #foreign libX11;
XSupportsLocale :: () -> s32 #foreign libX11;
XSetLocaleModifiers :: (unk0: *u8) -> *u8 #foreign libX11;
XOpenOM :: (unk0: *Display, unk1: *_XrmHashBucketRec, unk2: *u8, unk3: *u8) -> XOM #foreign libX11;
XCloseOM :: (unk0: XOM) -> s32 #foreign libX11;
XSetOMValues :: (unk0: XOM, __args: ..Any) -> *u8 #foreign libX11;
XGetOMValues :: (unk0: XOM, __args: ..Any) -> *u8 #foreign libX11;
XDisplayOfOM :: (unk0: XOM) -> *Display #foreign libX11;
XLocaleOfOM :: (unk0: XOM) -> *u8 #foreign libX11;
XCreateOC :: (unk0: XOM, __args: ..Any) -> XOC #foreign libX11;
XDestroyOC :: (unk0: XOC) -> void #foreign libX11;
XOMOfOC :: (unk0: XOC) -> XOM #foreign libX11;
XSetOCValues :: (unk0: XOC, __args: ..Any) -> *u8 #foreign libX11;
XGetOCValues :: (unk0: XOC, __args: ..Any) -> *u8 #foreign libX11;
XCreateFontSet :: (unk0: *Display, unk1: *u8, unk2: ***u8, unk3: *s32, unk4: **u8) -> XFontSet #foreign libX11;
XFreeFontSet :: (unk0: *Display, unk1: XFontSet) -> void #foreign libX11;
XFontsOfFontSet :: (unk0: XFontSet, unk1: ***XFontStruct, unk2: ***u8) -> s32 #foreign libX11;
XBaseFontNameListOfFontSet :: (unk0: XFontSet) -> *u8 #foreign libX11;
XLocaleOfFontSet :: (unk0: XFontSet) -> *u8 #foreign libX11;
XContextDependentDrawing :: (unk0: XFontSet) -> s32 #foreign libX11;
XDirectionalDependentDrawing :: (unk0: XFontSet) -> s32 #foreign libX11;
XContextualDrawing :: (unk0: XFontSet) -> s32 #foreign libX11;
XExtentsOfFontSet :: (unk0: XFontSet) -> *XFontSetExtents #foreign libX11;
XmbTextEscapement :: (unk0: XFontSet, unk1: *u8, unk2: s32) -> s32 #foreign libX11;
XwcTextEscapement :: (unk0: XFontSet, unk1: *wchar_t, unk2: s32) -> s32 #foreign libX11;
Xutf8TextEscapement :: (unk0: XFontSet, unk1: *u8, unk2: s32) -> s32 #foreign libX11;
XmbTextExtents :: (unk0: XFontSet, unk1: *u8, unk2: s32, unk3: *XRectangle, unk4: *XRectangle) -> s32 #foreign libX11;
XwcTextExtents :: (unk0: XFontSet, unk1: *wchar_t, unk2: s32, unk3: *XRectangle, unk4: *XRectangle) -> s32 #foreign libX11;
Xutf8TextExtents :: (unk0: XFontSet, unk1: *u8, unk2: s32, unk3: *XRectangle, unk4: *XRectangle) -> s32 #foreign libX11;
XmbTextPerCharExtents :: (unk0: XFontSet, unk1: *u8, unk2: s32, unk3: *XRectangle, unk4: *XRectangle, unk5: s32, unk6: *s32, unk7: *XRectangle, unk8: *XRectangle) -> s32 #foreign libX11;
XwcTextPerCharExtents :: (unk0: XFontSet, unk1: *wchar_t, unk2: s32, unk3: *XRectangle, unk4: *XRectangle, unk5: s32, unk6: *s32, unk7: *XRectangle, unk8: *XRectangle) -> s32 #foreign libX11;
Xutf8TextPerCharExtents :: (unk0: XFontSet, unk1: *u8, unk2: s32, unk3: *XRectangle, unk4: *XRectangle, unk5: s32, unk6: *s32, unk7: *XRectangle, unk8: *XRectangle) -> s32 #foreign libX11;
XmbDrawText :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: s32, unk4: s32, unk5: *XmbTextItem, unk6: s32) -> void #foreign libX11;
XwcDrawText :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: s32, unk4: s32, unk5: *XwcTextItem, unk6: s32) -> void #foreign libX11;
Xutf8DrawText :: (unk0: *Display, unk1: Drawable, unk2: GC, unk3: s32, unk4: s32, unk5: *XmbTextItem, unk6: s32) -> void #foreign libX11;
XmbDrawString :: (unk0: *Display, unk1: Drawable, unk2: XFontSet, unk3: GC, unk4: s32, unk5: s32, unk6: *u8, unk7: s32) -> void #foreign libX11;
XwcDrawString :: (unk0: *Display, unk1: Drawable, unk2: XFontSet, unk3: GC, unk4: s32, unk5: s32, unk6: *wchar_t, unk7: s32) -> void #foreign libX11;
Xutf8DrawString :: (unk0: *Display, unk1: Drawable, unk2: XFontSet, unk3: GC, unk4: s32, unk5: s32, unk6: *u8, unk7: s32) -> void #foreign libX11;
XmbDrawImageString :: (unk0: *Display, unk1: Drawable, unk2: XFontSet, unk3: GC, unk4: s32, unk5: s32, unk6: *u8, unk7: s32) -> void #foreign libX11;
XwcDrawImageString :: (unk0: *Display, unk1: Drawable, unk2: XFontSet, unk3: GC, unk4: s32, unk5: s32, unk6: *wchar_t, unk7: s32) -> void #foreign libX11;
Xutf8DrawImageString :: (unk0: *Display, unk1: Drawable, unk2: XFontSet, unk3: GC, unk4: s32, unk5: s32, unk6: *u8, unk7: s32) -> void #foreign libX11;
XOpenIM :: (unk0: *Display, unk1: *_XrmHashBucketRec, unk2: *u8, unk3: *u8) -> XIM #foreign libX11;
XCloseIM :: (unk0: XIM) -> s32 #foreign libX11;
XGetIMValues :: (unk0: XIM, __args: ..Any) -> *u8 #foreign libX11;
XSetIMValues :: (unk0: XIM, __args: ..Any) -> *u8 #foreign libX11;
XDisplayOfIM :: (unk0: XIM) -> *Display #foreign libX11;
XLocaleOfIM :: (unk0: XIM) -> *u8 #foreign libX11;
XCreateIC :: (unk0: XIM, __args: ..Any) -> XIC #foreign libX11;
XDestroyIC :: (unk0: XIC) -> void #foreign libX11;
XSetICFocus :: (unk0: XIC) -> void #foreign libX11;
XUnsetICFocus :: (unk0: XIC) -> void #foreign libX11;
XwcResetIC :: (unk0: XIC) -> *wchar_t #foreign libX11;
XmbResetIC :: (unk0: XIC) -> *u8 #foreign libX11;
Xutf8ResetIC :: (unk0: XIC) -> *u8 #foreign libX11;
XSetICValues :: (unk0: XIC, __args: ..Any) -> *u8 #foreign libX11;
XGetICValues :: (unk0: XIC, __args: ..Any) -> *u8 #foreign libX11;
XIMOfIC :: (unk0: XIC) -> XIM #foreign libX11;
XFilterEvent :: (unk0: *XEvent, unk1: Window) -> s32 #foreign libX11;
XmbLookupString :: (unk0: XIC, unk1: *XKeyPressedEvent, unk2: *u8, unk3: s32, unk4: *KeySym, unk5: *s32) -> s32 #foreign libX11;
XwcLookupString :: (unk0: XIC, unk1: *XKeyPressedEvent, unk2: *wchar_t, unk3: s32, unk4: *KeySym, unk5: *s32) -> s32 #foreign libX11;
Xutf8LookupString :: (unk0: XIC, unk1: *XKeyPressedEvent, unk2: *u8, unk3: s32, unk4: *KeySym, unk5: *s32) -> s32 #foreign libX11;
XVaCreateNestedList :: (unk0: s32, __args: ..Any) -> XVaNestedList #foreign libX11;
XRegisterIMInstantiateCallback :: (unk0: *Display, unk1: *_XrmHashBucketRec, unk2: *u8, unk3: *u8, unk4: XIDProc, unk5: XPointer) -> s32 #foreign libX11;
XUnregisterIMInstantiateCallback :: (unk0: *Display, unk1: *_XrmHashBucketRec, unk2: *u8, unk3: *u8, unk4: XIDProc, unk5: XPointer) -> s32 #foreign libX11;
XConnectionWatchProc :: #type (a0: *Display, a1: XPointer, a2: s32, a3: s32, a4: *XPointer) -> void #c_call;
XInternalConnectionNumbers :: (unk0: *Display, unk1: **s32, unk2: *s32) -> s32 #foreign libX11;
XProcessInternalConnection :: (unk0: *Display, unk1: s32) -> void #foreign libX11;
XAddConnectionWatch :: (unk0: *Display, unk1: XConnectionWatchProc, unk2: XPointer) -> s32 #foreign libX11;
XRemoveConnectionWatch :: (unk0: *Display, unk1: XConnectionWatchProc, unk2: XPointer) -> void #foreign libX11;
XSetAuthorization :: (unk0: *u8, unk1: s32, unk2: *u8, unk3: s32) -> void #foreign libX11;
_Xmbtowc :: (unk0: *wchar_t, unk1: *u8, unk2: s32) -> s32 #foreign libX11;
_Xwctomb :: (unk0: *u8, unk1: wchar_t) -> s32 #foreign libX11;
XGetEventData :: (unk0: *Display, unk1: *XGenericEventCookie) -> s32 #foreign libX11;
XFreeEventData :: (unk0: *Display, unk1: *XGenericEventCookie) -> void #foreign libX11;
XSizeHints :: struct {
    flags: s64;
    x: s32;
    y: s32;
    width: s32;
    height: s32;
    min_width: s32;
    min_height: s32;
    max_width: s32;
    max_height: s32;
    width_inc: s32;
    height_inc: s32;
    min_aspect, max_aspect: struct {
        x: s32;
        y: s32;
    }
    ;
    base_width: s32;
    base_height: s32;
    win_gravity: s32;
}
XWMHints :: struct {
    flags: s64;
    input: s32;
    initial_state: s32;
    icon_pixmap: Pixmap;
    icon_window: Window;
    icon_x: s32;
    icon_y: s32;
    icon_mask: Pixmap;
    window_group: XID;
}
XTextProperty :: struct {
    value: *u8;
    encoding: Atom;
    format: s32;
    nitems: u64;
}
using XICCEncodingStyle :: enum u32 {
    XStringStyle :: 0;
    XCompoundTextStyle :: 1;
    XTextStyle :: 2;
    XStdICCTextStyle :: 3;
    XUTF8StringStyle :: 4;
}
XIconSize :: struct {
    min_width: s32;
    min_height: s32;
    max_width: s32;
    max_height: s32;
    width_inc: s32;
    height_inc: s32;
}
anon_struct_6 :: struct {
    res_name: *u8;
    res_class: *u8;
}
XClassHint :: anon_struct_6;
_XComposeStatus :: struct {
    compose_ptr: XPointer;
    chars_matched: s32;
}
XComposeStatus :: _XComposeStatus;
_XRegion :: struct {}
Region :: *_XRegion;
XVisualInfo :: struct {
    visual: *Visual;
    visualid: VisualID;
    screen: s32;
    depth: s32;
    class: s32;
    red_mask: u64;
    green_mask: u64;
    blue_mask: u64;
    colormap_size: s32;
    bits_per_rgb: s32;
}
XStandardColormap :: struct {
    colormap: Colormap;
    red_max: u64;
    red_mult: u64;
    green_max: u64;
    green_mult: u64;
    blue_max: u64;
    blue_mult: u64;
    base_pixel: u64;
    visualid: VisualID;
    killid: XID;
}
XContext :: s32;
XAllocClassHint :: () -> *XClassHint #foreign libX11;
XAllocIconSize :: () -> *XIconSize #foreign libX11;
XAllocSizeHints :: () -> *XSizeHints #foreign libX11;
XAllocStandardColormap :: () -> *XStandardColormap #foreign libX11;
XAllocWMHints :: () -> *XWMHints #foreign libX11;
XClipBox :: (unk0: Region, unk1: *XRectangle) -> s32 #foreign libX11;
XCreateRegion :: () -> Region #foreign libX11;
XDefaultString :: () -> *u8 #foreign libX11;
XDeleteContext :: (unk0: *Display, unk1: XID, unk2: XContext) -> s32 #foreign libX11;
XDestroyRegion :: (unk0: Region) -> s32 #foreign libX11;
XEmptyRegion :: (unk0: Region) -> s32 #foreign libX11;
XEqualRegion :: (unk0: Region, unk1: Region) -> s32 #foreign libX11;
XFindContext :: (unk0: *Display, unk1: XID, unk2: XContext, unk3: *XPointer) -> s32 #foreign libX11;
XGetClassHint :: (unk0: *Display, unk1: Window, unk2: *XClassHint) -> s32 #foreign libX11;
XGetIconSizes :: (unk0: *Display, unk1: Window, unk2: **XIconSize, unk3: *s32) -> s32 #foreign libX11;
XGetNormalHints :: (unk0: *Display, unk1: Window, unk2: *XSizeHints) -> s32 #foreign libX11;
XGetRGBColormaps :: (unk0: *Display, unk1: Window, unk2: **XStandardColormap, unk3: *s32, unk4: Atom) -> s32 #foreign libX11;
XGetSizeHints :: (unk0: *Display, unk1: Window, unk2: *XSizeHints, unk3: Atom) -> s32 #foreign libX11;
XGetStandardColormap :: (unk0: *Display, unk1: Window, unk2: *XStandardColormap, unk3: Atom) -> s32 #foreign libX11;
XGetTextProperty :: (unk0: *Display, unk1: Window, unk2: *XTextProperty, unk3: Atom) -> s32 #foreign libX11;
XGetVisualInfo :: (unk0: *Display, unk1: s64, unk2: *XVisualInfo, unk3: *s32) -> *XVisualInfo #foreign libX11;
XGetWMClientMachine :: (unk0: *Display, unk1: Window, unk2: *XTextProperty) -> s32 #foreign libX11;
XGetWMHints :: (unk0: *Display, unk1: Window) -> *XWMHints #foreign libX11;
XGetWMIconName :: (unk0: *Display, unk1: Window, unk2: *XTextProperty) -> s32 #foreign libX11;
XGetWMName :: (unk0: *Display, unk1: Window, unk2: *XTextProperty) -> s32 #foreign libX11;
XGetWMNormalHints :: (unk0: *Display, unk1: Window, unk2: *XSizeHints, unk3: *s64) -> s32 #foreign libX11;
XGetWMSizeHints :: (unk0: *Display, unk1: Window, unk2: *XSizeHints, unk3: *s64, unk4: Atom) -> s32 #foreign libX11;
XGetZoomHints :: (unk0: *Display, unk1: Window, unk2: *XSizeHints) -> s32 #foreign libX11;
XIntersectRegion :: (unk0: Region, unk1: Region, unk2: Region) -> s32 #foreign libX11;
XConvertCase :: (unk0: KeySym, unk1: *KeySym, unk2: *KeySym) -> void #foreign libX11;
XLookupString :: (unk0: *XKeyEvent, unk1: *u8, unk2: s32, unk3: *KeySym, unk4: *XComposeStatus) -> s32 #foreign libX11;
XMatchVisualInfo :: (unk0: *Display, unk1: s32, unk2: s32, unk3: s32, unk4: *XVisualInfo) -> s32 #foreign libX11;
XOffsetRegion :: (unk0: Region, unk1: s32, unk2: s32) -> s32 #foreign libX11;
XPointInRegion :: (unk0: Region, unk1: s32, unk2: s32) -> s32 #foreign libX11;
XPolygonRegion :: (unk0: *XPoint, unk1: s32, unk2: s32) -> Region #foreign libX11;
XRectInRegion :: (unk0: Region, unk1: s32, unk2: s32, unk3: u32, unk4: u32) -> s32 #foreign libX11;
XSaveContext :: (unk0: *Display, unk1: XID, unk2: XContext, unk3: *u8) -> s32 #foreign libX11;
XSetClassHint :: (unk0: *Display, unk1: Window, unk2: *XClassHint) -> s32 #foreign libX11;
XSetIconSizes :: (unk0: *Display, unk1: Window, unk2: *XIconSize, unk3: s32) -> s32 #foreign libX11;
XSetNormalHints :: (unk0: *Display, unk1: Window, unk2: *XSizeHints) -> s32 #foreign libX11;
XSetRGBColormaps :: (unk0: *Display, unk1: Window, unk2: *XStandardColormap, unk3: s32, unk4: Atom) -> void #foreign libX11;
XSetSizeHints :: (unk0: *Display, unk1: Window, unk2: *XSizeHints, unk3: Atom) -> s32 #foreign libX11;
XSetStandardProperties :: (unk0: *Display, unk1: Window, unk2: *u8, unk3: *u8, unk4: Pixmap, unk5: **u8, unk6: s32, unk7: *XSizeHints) -> s32 #foreign libX11;
XSetTextProperty :: (unk0: *Display, unk1: Window, unk2: *XTextProperty, unk3: Atom) -> void #foreign libX11;
XSetWMClientMachine :: (unk0: *Display, unk1: Window, unk2: *XTextProperty) -> void #foreign libX11;
XSetWMHints :: (unk0: *Display, unk1: Window, unk2: *XWMHints) -> s32 #foreign libX11;
XSetWMIconName :: (unk0: *Display, unk1: Window, unk2: *XTextProperty) -> void #foreign libX11;
XSetWMName :: (unk0: *Display, unk1: Window, unk2: *XTextProperty) -> void #foreign libX11;
XSetWMNormalHints :: (unk0: *Display, unk1: Window, unk2: *XSizeHints) -> void #foreign libX11;
XSetWMProperties :: (unk0: *Display, unk1: Window, unk2: *XTextProperty, unk3: *XTextProperty, unk4: **u8, unk5: s32, unk6: *XSizeHints, unk7: *XWMHints, unk8: *XClassHint) -> void #foreign libX11;
XmbSetWMProperties :: (unk0: *Display, unk1: Window, unk2: *u8, unk3: *u8, unk4: **u8, unk5: s32, unk6: *XSizeHints, unk7: *XWMHints, unk8: *XClassHint) -> void #foreign libX11;
Xutf8SetWMProperties :: (unk0: *Display, unk1: Window, unk2: *u8, unk3: *u8, unk4: **u8, unk5: s32, unk6: *XSizeHints, unk7: *XWMHints, unk8: *XClassHint) -> void #foreign libX11;
XSetWMSizeHints :: (unk0: *Display, unk1: Window, unk2: *XSizeHints, unk3: Atom) -> void #foreign libX11;
XSetRegion :: (unk0: *Display, unk1: GC, unk2: Region) -> s32 #foreign libX11;
XSetStandardColormap :: (unk0: *Display, unk1: Window, unk2: *XStandardColormap, unk3: Atom) -> void #foreign libX11;
XSetZoomHints :: (unk0: *Display, unk1: Window, unk2: *XSizeHints) -> s32 #foreign libX11;
XShrinkRegion :: (unk0: Region, unk1: s32, unk2: s32) -> s32 #foreign libX11;
XStringListToTextProperty :: (unk0: **u8, unk1: s32, unk2: *XTextProperty) -> s32 #foreign libX11;
XSubtractRegion :: (unk0: Region, unk1: Region, unk2: Region) -> s32 #foreign libX11;
XmbTextListToTextProperty :: (display: *Display, list: **u8, count: s32, style: XICCEncodingStyle, text_prop_return: *XTextProperty) -> s32 #foreign libX11;
XwcTextListToTextProperty :: (display: *Display, list: **wchar_t, count: s32, style: XICCEncodingStyle, text_prop_return: *XTextProperty) -> s32 #foreign libX11;
Xutf8TextListToTextProperty :: (display: *Display, list: **u8, count: s32, style: XICCEncodingStyle, text_prop_return: *XTextProperty) -> s32 #foreign libX11;
XwcFreeStringList :: (list: **wchar_t) -> void #foreign libX11;
XTextPropertyToStringList :: (unk0: *XTextProperty, unk1: ***u8, unk2: *s32) -> s32 #foreign libX11;
XmbTextPropertyToTextList :: (display: *Display, text_prop: *XTextProperty, list_return: ***u8, count_return: *s32) -> s32 #foreign libX11;
XwcTextPropertyToTextList :: (display: *Display, text_prop: *XTextProperty, list_return: ***wchar_t, count_return: *s32) -> s32 #foreign libX11;
Xutf8TextPropertyToTextList :: (display: *Display, text_prop: *XTextProperty, list_return: ***u8, count_return: *s32) -> s32 #foreign libX11;
XUnionRectWithRegion :: (unk0: *XRectangle, unk1: Region, unk2: Region) -> s32 #foreign libX11;
XUnionRegion :: (unk0: Region, unk1: Region, unk2: Region) -> s32 #foreign libX11;
XWMGeometry :: (unk0: *Display, unk1: s32, unk2: *u8, unk3: *u8, unk4: u32, unk5: *XSizeHints, unk6: *s32, unk7: *s32, unk8: *s32, unk9: *s32, unk10: *s32) -> s32 #foreign libX11;
XXorRegion :: (unk0: Region, unk1: Region, unk2: Region) -> s32 #foreign libX11;
XrmValue :: struct {
    size: u32;
    addr: XPointer;
}
XrmValuePtr :: *XrmValue;
XrmDatabase :: *_XrmHashBucketRec;
XrmGetStringDatabase :: (data: *u8) -> XrmDatabase #foreign libX11;
XrmGetResource :: (db: XrmDatabase, str_name: *u8, str_class: *u8, str_return_type: **u8, value: *XrmValue) -> Bool #foreign libX11;
XrmDestroyDatabase :: (db: XrmDatabase) #foreign libX11;
DefaultRootWindow :: (display: *Display) -> Window {
    return XDefaultRootWindow(display);
}
DefaultScreen :: (display: *Display) -> s32 {
    return XDefaultScreen(display);
}
ScreenOfDisplay :: (display: *Display, scr: s32) -> *Screen {
    return XScreenOfDisplay(display, scr);
}
DefaultScreenOfDisplay :: (display: *Display) -> *Screen {
    return XDefaultScreenOfDisplay(display);
}
DefaultGC :: (display: *Display, scr: s32) -> GC {
    return XDefaultGC(display, scr);
}
XkbKeycodeToKeysym :: (dpy: *Display, kc: KeyCode, group: u32, level: u32) -> KeySym #foreign libX11;
GLX_RGBA :: 4;
GLX_DOUBLEBUFFER :: 5;
GLX_RED_SIZE :: 8;
GLX_GREEN_SIZE :: 9;
GLX_BLUE_SIZE :: 10;
GLX_ALPHA_SIZE :: 11;
GLX_DEPTH_SIZE :: 12;
GLX_STENCIL_SIZE :: 13;
GLX_X_VISUAL_TYPE :: 0x0022;
GLX_CONTEXT_MAJOR_VERSION_ARB :: 0x2091;
GLX_CONTEXT_MINOR_VERSION_ARB :: 0x2092;
GLX_CONTEXT_FLAGS_ARB :: 0x2094;
GLX_TRUE_COLOR :: 0x8002;
GLX_DRAWABLE_TYPE :: 0x8010;
GLX_RENDER_TYPE :: 0x8011;
GLX_X_RENDERABLE :: 0x8012;
GLX_CONTEXT_PROFILE_MASK_ARB :: 0x9126;
GLX_SAMPLE_BUFFERS :: 0x186a0;
GLX_SAMPLES :: 0x186a1;
GLX_WINDOW_BIT :: 0x01;
GLX_RGBA_BIT :: 0x01;
GLX_CONTEXT_CORE_PROFILE_BIT_ARB :: 0x01;
GLX_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB :: 0x02;
GLX_CONTEXT_DEBUG_BIT_ARB :: 0x01;
GLX_CONTEXT_FORWARD_COMPATIBLE_BIT_ARB :: 0x02;
GLXContext :: *void;
GLXDrawable :: u64;
GLXFBConfig :: *void;
GLXWindow :: XID;
glXChooseVisual :: (dpy: *Display, screen: s32, attrib_list: *s32) -> *XVisualInfo #foreign glx;
glXCreateContext :: (dpy: *Display, visual: *XVisualInfo, share_list: GLXContext, direct: s32) -> GLXContext #foreign glx;
glXMakeCurrent :: (dpy: *Display, drawable: GLXDrawable, ctx: GLXContext) -> s32 #foreign glx;
glXGetCurrentContext :: () -> GLXContext #foreign glx;
glXSwapBuffers :: (dpy: *Display, drawable: GLXDrawable) -> void #foreign glx;
glXDestroyContext :: (dpy: *Display, ctx: GLXContext) #foreign glx;
glXGetProcAddress :: (procName: *u8) -> *void #foreign glx;
glXChooseFBConfig :: (disp: *Display, screen: s32, attrib_list: *s32, nelements: *s32) -> *GLXFBConfig #foreign glx;
glXGetFBConfigAttrib :: (disp: *Display, config: GLXFBConfig, attribute: s32, value: *s32) -> s32 #foreign glx;
glXGetConfig :: (disp: *Display, vis: *XVisualInfo, attrib: s32, value: *s32) -> s32 #foreign glx;
glXCreateWindow :: (display: *Display, config: GLXFBConfig, window: Window, attrib_list: *s32 = null) -> GLXWindow #foreign glx;
#scope_file
String :: #import "String";
trim :: String.trim;
POSIX :: #import "POSIX";
getenv :: POSIX.getenv;
LC_ALL: s32 : 6;
setlocale :: (what: s32, loc: *u8) -> *u8 #foreign libc;
wchar_t :: u64;
libX11 :: #system_library "X11";
libc :: #system_library "c";
glx :: #system_library "GL";
