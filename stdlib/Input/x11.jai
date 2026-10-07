#scope_module
X :: #import "X11";

X11_Input_Window :: struct {
    window: X.Window;
    input_context: X.XIC;
    x: s32;
    y: s32;
    pointer_valid := false;
}

x11_input_windows: [..] X11_Input_Window;
x11_focus: X.Window;
// An application can preserve clipboard, expose and extension events here.
#scope_export
x11_unhandled_event_source: (event: *X.XEvent) = null;

#scope_module
x11_key_code :: (symbol: X.KeySym) -> Key_Code {
    if symbol >= 0x61 && symbol <= 0x7a return cast(Key_Code) (symbol - 32);
    if symbol >= 0x20 && symbol < 0x7f return cast(Key_Code) symbol;
    if symbol >= 0xffbe && symbol <= 0xffd5 return cast(Key_Code) (cast(u64) Key_Code.F1 + symbol - 0xffbe);
    if symbol == 0xff1b return .ESCAPE;
    if symbol == 0xff08 return .BACKSPACE;
    if symbol == 0xff09 return .TAB;
    if symbol == 0xff0d || symbol == 0xff8d return .ENTER;
    if symbol == 0xffff return .DELETE;
    if symbol == 0xff51 return .ARROW_LEFT;
    if symbol == 0xff52 return .ARROW_UP;
    if symbol == 0xff53 return .ARROW_RIGHT;
    if symbol == 0xff54 return .ARROW_DOWN;
    if symbol == 0xff55 return .PAGE_UP;
    if symbol == 0xff56 return .PAGE_DOWN;
    if symbol == 0xff50 return .HOME;
    if symbol == 0xff57 return .END;
    if symbol == 0xff63 return .INSERT;
    if symbol == 0xffe1 || symbol == 0xffe2 return .SHIFT;
    if symbol == 0xffe3 || symbol == 0xffe4 return .CTRL;
    if symbol == 0xffe9 || symbol == 0xffea return .ALT;
    if symbol == 0xffe7 || symbol == 0xffe8 || symbol == 0xffeb || symbol == 0xffec return .CMD;
    if symbol == 0xff13 return .PAUSE;
    if symbol == 0xff14 return .SCROLL_LOCK;
    if symbol == 0xff61 return .PRINT_SCREEN;
    return .UNKNOWN;
}

x11_modifiers :: (event: *Event, mask: u32) {
    event.shift_pressed = (mask & X.ShiftMask) != 0;
    event.ctrl_pressed = (mask & X.ControlMask) != 0;
    event.alt_pressed = (mask & X.Mod1Mask) != 0;
    event.cmd_meta_pressed = (mask & X.Mod4Mask) != 0;
}

x11_register_window :: (window: X.Window) -> *X11_Input_Window {
    for *entry: x11_input_windows if entry.window == window return entry;
    entry: X11_Input_Window;
    entry.window = window;
    if X.x_global_input_method {
        entry.input_context = X.XCreateIC(X.x_global_input_method, X.XNInputStyle,
            cast(u64) (X.XIMPreeditNothing | X.XIMStatusNothing), X.XNClientWindow, window, X.XNFocusWindow, window, cast(*u8) null);
    }
    return array_add(*x11_input_windows, entry);
}

x11_poll_input :: () {
    display := X.x_global_display;
    if !display return;
    while X.XPending(display) > 0 {
        native: X.XEvent;
        X.XNextEvent(display, *native);
        window := native.xany.window;
        owned := false;
        for candidate: X.x_global_windows if candidate == window {
            owned = true;
            break;
        }
        if !owned for candidate: x11_input_windows if candidate.window == window {
            owned = true;
            break;
        }
        if !owned {
            if x11_unhandled_event_source != null x11_unhandled_event_source(*native);
            continue;
        }
        entry := x11_register_window(window);
        routed_window := cast(Window_Type) window;
        if X.XFilterEvent(*native, window) != 0 continue;
        repeated := false;
        if native.type == X.KeyRelease && X.XPending(display) > 0 {
            next: X.XEvent;
            X.XPeekEvent(display, *next);
            if next.type == X.KeyPress && next.xkey.window == window && next.xkey.keycode == native.xkey.keycode && next.xkey.time == native.xkey.time {
                X.XNextEvent(display, *native);
                repeated = true;
            }
        }
        event: Event;
        if native.type == X.KeyPress || native.type == X.KeyRelease {
            event.type = .KEYBOARD;
            event.key_pressed = xx (native.type == X.KeyPress);
            event.key_code = x11_key_code(X.XLookupKeysym(*native.xkey, 0));
            event.repeat = repeated;
            x11_modifiers(*event, native.xkey.state);
            queue_input_event(routed_window, event);
            if native.type == X.KeyPress {
                symbol: X.KeySym;
                buffer: [256] u8;
                count: s32;
                if entry.input_context {
                    status: s32;
                    count = X.Xutf8LookupString(entry.input_context, *native.xkey, buffer.data, cast(s32) buffer.count, *symbol, *status);
                    if status == X.XBufferOverflow {
                        text := alloc(count);
                        if text {
                            count = X.Xutf8LookupString(entry.input_context, *native.xkey, cast(*u8) text, count, *symbol, *status);
                            if count > 0 queue_utf8_text(routed_window, .{ count, cast(*u8) text }, repeated);
                            free(text);
                        }
                    } else if count > 0 queue_utf8_text(routed_window, .{ count, buffer.data }, repeated);
                } else {
                    count = X.XLookupString(*native.xkey, buffer.data, cast(s32) buffer.count, *symbol, null);
                    for i: 0..count - 1 {
                        text_event: Event;
                        text_event.type = .TEXT_INPUT;
                        text_event.utf32 = buffer[i];
                        text_event.text_input_count = 1;
                        text_event.repeat = repeated;
                        queue_input_event(routed_window, text_event);
                    }
                }
            }
        } else if native.type == X.ButtonPress || native.type == X.ButtonRelease {
            number := native.xbutton.button;
            if number == 4 || number == 5 {
                if native.type == X.ButtonPress {
                    event.type = .MOUSE_WHEEL;
                    event.typical_wheel_delta = 1;
                    event.wheel_delta = 1;
                    if number == 5 event.wheel_delta = -1;
                    x11_modifiers(*event, native.xbutton.state);
                    queue_input_event(routed_window, event);
                }
            } else if number >= 1 && number <= 3 {
                event.type = .KEYBOARD;
                event.key_pressed = xx (native.type == X.ButtonPress);
                event.key_code = .MOUSE_BUTTON_LEFT;
                if number == 2 event.key_code = .MOUSE_BUTTON_MIDDLE;
                if number == 3 event.key_code = .MOUSE_BUTTON_RIGHT;
                x11_modifiers(*event, native.xbutton.state);
                queue_input_event(routed_window, event);
            }
        } else if native.type == X.MotionNotify {
            if entry.pointer_valid queue_mouse_delta(native.xmotion.x - entry.x, native.xmotion.y - entry.y);
            entry.x = native.xmotion.x;
            entry.y = native.xmotion.y;
            entry.pointer_valid = true;
        } else if native.type == X.ConfigureNotify {
            queue_window_resize(routed_window, native.xconfigure.width, native.xconfigure.height);
            queue_window_move(routed_window, native.xconfigure.x, native.xconfigure.y);
        } else if native.type == X.FocusIn {
            x11_focus = window;
            set_input_focus(routed_window, true);
            if entry.input_context X.XSetICFocus(entry.input_context);
        } else if native.type == X.FocusOut {
            set_input_focus(routed_window, false);
            entry.pointer_valid = false;
            if entry.input_context X.XUnsetICFocus(entry.input_context);
            if x11_focus == window x11_focus = 0;
        } else if native.type == X.ClientMessage && native.xclient.message_type == X.x_global_wm_protocols && native.xclient.format == 32 && cast(X.Atom) native.xclient.data.l[0] == X.x_global_wm_delete_window {
            event.type = .QUIT;
            queue_input_event(routed_window, event);
        } else if native.type == X.DestroyNotify {
            set_input_focus(routed_window, false);
            if entry.input_context {
                X.XDestroyIC(entry.input_context);
                entry.input_context = null;
            }
            for record, index: x11_input_windows if record.window == window {
                array_ordered_remove_by_index(*x11_input_windows, index);
                break;
            }
        } else if x11_unhandled_event_source != null x11_unhandled_event_source(*native);
    }
}

x11_pointer_query :: (window: Window_Type, client_area: bool) -> float, float, bool {
    if !X.x_global_display return 0, 0, false;
    target := cast(X.Window) window;
    if !target {
        if client_area {
            mode: s32;
            X.XGetInputFocus(X.x_global_display, *target, *mode);
            if target <= 1 return 0, 0, false;
        } else target = X.XDefaultRootWindow(X.x_global_display);
    }
    root: X.Window;
    child: X.Window;
    screen_x: s32;
    screen_y: s32;
    local_x: s32;
    local_y: s32;
    state: u32;
    if X.XQueryPointer(X.x_global_display, target, *root, *child, *screen_x, *screen_y, *local_x, *local_y, *state) == 0 return 0, 0, false;
    if client_area return cast(float) local_x, cast(float) local_y, true;
    return cast(float) screen_x, cast(float) screen_y, true;
}
