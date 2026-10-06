// Win32 queue pump. Call on the thread owning the native windows.
#scope_module
Win :: #import "Windows";
windows_focus: Win.HWND;
Windows_Mouse_Position :: struct {
    window: Win.HWND;
    x: s32;
    y: s32;
    valid := false;
}
windows_mouse_positions: [..] Windows_Mouse_Position;
windows_high_surrogate: u16;
windows_surrogate_window: Window_Type;
windows_key_code :: (virtual_key: u32) -> Key_Code {
    if virtual_key >= 0x30 && virtual_key <= 0x5a return cast(Key_Code) virtual_key;
    if virtual_key >= 0x70 && virtual_key <= 0x87 return cast(Key_Code) (cast(u32) Key_Code.F1 + virtual_key - 0x70);
    if virtual_key == 0x1b return .ESCAPE;
    if virtual_key == 0x25 return .ARROW_LEFT;
    if virtual_key == 0x26 return .ARROW_UP;
    if virtual_key == 0x27 return .ARROW_RIGHT;
    if virtual_key == 0x28 return .ARROW_DOWN;
    if virtual_key == 0x10 || virtual_key == 0xa0 || virtual_key == 0xa1 return .SHIFT;
    if virtual_key == 0x11 || virtual_key == 0xa2 || virtual_key == 0xa3 return .CTRL;
    if virtual_key == 0x12 || virtual_key == 0xa4 || virtual_key == 0xa5 return .ALT;
    if virtual_key == 0x5b || virtual_key == 0x5c return .CMD;
    if virtual_key == 0x21 return .PAGE_UP;
    if virtual_key == 0x22 return .PAGE_DOWN;
    if virtual_key == 0x23 return .END;
    if virtual_key == 0x24 return .HOME;
    if virtual_key == 0x2d return .INSERT;
    if virtual_key == 0x2e return .DELETE;
    if virtual_key == 0x13 return .PAUSE;
    if virtual_key == 0x91 return .SCROLL_LOCK;
    if virtual_key == 0x2c return .PRINT_SCREEN;
    if virtual_key == 8 || virtual_key == 9 || virtual_key == 13 || virtual_key == 32 return cast(Key_Code) virtual_key;
    mapped := Input_MapVirtualKeyW(virtual_key, 2) & 0x7fffffff;
    if mapped > 0 && mapped < 128 return cast(Key_Code) mapped;
    return .UNKNOWN;
}
windows_modifiers :: (event: *Event) {
    event.shift_pressed = Win.GetKeyState(0x10) < 0;
    event.ctrl_pressed = Win.GetKeyState(0x11) < 0;
    event.alt_pressed = Win.GetKeyState(0x12) < 0;
    event.cmd_meta_pressed = Win.GetKeyState(0x5b) < 0 || Win.GetKeyState(0x5c) < 0;
}
windows_emit_utf16 :: (window: Window_Type, unit: u16, repeated: bool) {
    if unit >= 0xd800 && unit <= 0xdbff {
        windows_high_surrogate = unit;
        windows_surrogate_window = window;
        return;
    }
    scalar := cast(u32) unit;
    if unit >= 0xdc00 && unit <= 0xdfff {
        if windows_high_surrogate == 0 || windows_surrogate_window != window return;
        scalar = 0x10000 + ((cast(u32) windows_high_surrogate - 0xd800) << 10) + unit - 0xdc00;
    }
    windows_high_surrogate = 0;
    event: Event;
    event.type = .TEXT_INPUT;
    event.utf32 = scalar;
    event.repeat = repeated;
    event.text_input_count = 1;
    windows_modifiers(*event);
    queue_input_event(window, event);
}
// Window_Creation registers the procedure in `context._windows_windowproc` as its window class
// procedure. Windows calls it directly for sent messages (WM_SIZE while a window is created or
// resized, WM_CLOSE from the close button), which never pass through the queue, so it notes
// every message here and the pump turns them into events. It runs without a Jai context, so it
// only copies the message into a fixed buffer.
#add_context _windows_windowproc := input_window_procedure;

Noted_Message :: struct {
    hwnd: Win.HWND;
    kind: u32;
    wparam: Win.WPARAM;
    lparam: Win.LPARAM;
}
noted_messages: [256] Noted_Message;
noted_count := 0;

input_window_procedure :: (hwnd: Win.HWND, kind: u32, wparam: Win.WPARAM, lparam: Win.LPARAM) -> Win.LRESULT #c_call {
    windows_windowproc_handles_input = true;
    if noted_count < noted_messages.count {
        noted_messages[noted_count] = .{ hwnd, kind, wparam, lparam };
        noted_count += 1;
    }
    // Closing is the program's decision: report QUIT and keep the window.
    if kind == Win.WM_CLOSE return 0;
    return Win.DefWindowProcW(hwnd, kind, wparam, lparam);
}

process_noted_messages :: () {
    for index: 0..noted_count - 1 {
        noted := noted_messages[index];
        windows_process_input_message(noted.hwnd, noted.kind, noted.wparam, noted.lparam);
    }
    noted_count = 0;
}

windows_poll_input :: () {
    process_noted_messages();
    message: Win.MSG;
    while Win.PeekMessageW(*message, null, 0, 0, Win.PM_REMOVE) != 0 {
        if message.message == Win.WM_QUIT {
            event: Event;
            event.type = .QUIT;
            queue_input_event(event);
            continue;
        }
        if !windows_windowproc_handles_input windows_process_input_message(message.hwnd, message.message, message.wParam, message.lParam);
        Win.TranslateMessage(*message);
        Win.DispatchMessageW(*message);
        process_noted_messages();
    }
    focused := Win.GetFocus();
    if focused != windows_focus {
        if windows_focus set_input_focus(cast(Window_Type) cast(u64) windows_focus, false);
        if focused set_input_focus(cast(Window_Type) cast(u64) focused, true);
        windows_focus = focused;
        for *position: windows_mouse_positions position.valid = false;
    }
}
windows_pointer_query :: (window: Window_Type, client_area: bool) -> float, float, bool {
    point: Win.POINT;
    if Win.GetCursorPos(*point) == 0 return 0, 0, false;
    if client_area {
        hwnd := cast(Win.HWND) cast(u64) window;
        if !hwnd hwnd = Win.GetFocus();
        if !hwnd || Win.ScreenToClient(hwnd, *point) == 0 return 0, 0, false;
    }
    return cast(float) point.x, cast(float) point.y, true;
}

input_user32 :: #system_library "user32";
Input_MapVirtualKeyW :: (code: u32, map_type: u32) -> u32 #foreign input_user32 "MapVirtualKeyW";

#scope_export
// True once a window procedure feeds windows_process_input_message (Input's own does), so the
// pump does not also process the queued messages it dispatches to that procedure.
windows_windowproc_handles_input := false;
windows_process_input_message :: (hwnd: Win.HWND, kind: u32, wparam: Win.WPARAM, lparam: Win.LPARAM) {
    message: Win.MSG;
    message.hwnd = hwnd;
    message.message = kind;
    message.wParam = wparam;
    message.lParam = lparam;
    window := cast(Window_Type) cast(u64) message.hwnd;
    event: Event;
    if message.message == Win.WM_QUIT {
        event.type = .QUIT;
        queue_input_event(event);
        return;
    }
    if message.message == Win.WM_SETFOCUS set_input_focus(window, true);
    if message.message == Win.WM_KILLFOCUS set_input_focus(window, false);
    if message.message == Win.WM_DESTROY {
        set_input_focus(window, false);
        for position, index: windows_mouse_positions if position.window == message.hwnd {
            array_ordered_remove_by_index(*windows_mouse_positions, index);
            break;
        }
    }
    if message.message == Win.WM_CLOSE {
        event.type = .QUIT;
        queue_input_event(window, event);
    }
    if message.message == Win.WM_KEYDOWN || message.message == Win.WM_KEYUP || message.message == Win.WM_SYSKEYDOWN || message.message == Win.WM_SYSKEYUP {
        event.type = .KEYBOARD;
        event.key_code = windows_key_code(cast(u32) message.wParam);
        event.key_pressed = xx (message.message == Win.WM_KEYDOWN || message.message == Win.WM_SYSKEYDOWN);
        event.repeat = event.key_pressed && ((cast(u64) message.lParam) & ((cast(u64) 1) << 30)) != 0;
        windows_modifiers(*event);
        queue_input_event(window, event);
    } else if message.message == Win.WM_CHAR {
        windows_emit_utf16(window, cast(u16) message.wParam, ((cast(u64) message.lParam) & ((cast(u64) 1) << 30)) != 0);
    } else if message.message == Win.WM_UNICHAR && message.wParam != 0xffff {
        scalar := cast(u32) message.wParam;
        if scalar <= 0x10ffff && !(scalar >= 0xd800 && scalar <= 0xdfff) {
            event.type = .TEXT_INPUT;
            event.utf32 = scalar;
            event.text_input_count = 1;
            windows_modifiers(*event);
            queue_input_event(window, event);
        }
    } else if message.message == Win.WM_LBUTTONDOWN || message.message == Win.WM_LBUTTONUP || message.message == Win.WM_RBUTTONDOWN || message.message == Win.WM_RBUTTONUP || message.message == Win.WM_MBUTTONDOWN || message.message == Win.WM_MBUTTONUP {
        event.type = .KEYBOARD;
        event.key_pressed = xx (message.message == Win.WM_LBUTTONDOWN || message.message == Win.WM_RBUTTONDOWN || message.message == Win.WM_MBUTTONDOWN);
        event.key_code = .MOUSE_BUTTON_LEFT;
        if message.message == Win.WM_RBUTTONDOWN || message.message == Win.WM_RBUTTONUP event.key_code = .MOUSE_BUTTON_RIGHT;
        if message.message == Win.WM_MBUTTONDOWN || message.message == Win.WM_MBUTTONUP event.key_code = .MOUSE_BUTTON_MIDDLE;
        windows_modifiers(*event);
        queue_input_event(window, event);
    } else if message.message == Win.WM_MOUSEWHEEL {
        event.type = .MOUSE_WHEEL;
        event.wheel_delta = cast(s16) ((message.wParam >> 16) & 0xffff);
        event.typical_wheel_delta = 120;
        windows_modifiers(*event);
        queue_input_event(window, event);
    } else if message.message == Win.WM_MOUSEMOVE {
        x := cast(s16) ((cast(u64) message.lParam) & 0xffff);
        y := cast(s16) (((cast(u64) message.lParam) >> 16) & 0xffff);
        found := false;
        for *position: windows_mouse_positions {
            if position.window != message.hwnd continue;
            if position.valid queue_mouse_delta(x - position.x, y - position.y);
            position.x = x;
            position.y = y;
            position.valid = true;
            found = true;
            break;
        }
        if !found array_add(*windows_mouse_positions, .{ message.hwnd, x, y, true });
    } else if message.message == Win.WM_SIZE {
        queue_window_resize(window, cast(u16) ((cast(u64) message.lParam) & 0xffff), cast(u16) (((cast(u64) message.lParam) >> 16) & 0xffff));
    } else if message.message == Win.WM_MOVE {
        queue_window_move(window, cast(s16) ((cast(u64) message.lParam) & 0xffff), cast(s16) (((cast(u64) message.lParam) >> 16) & 0xffff));
    }

}
