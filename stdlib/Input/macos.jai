#scope_module
Mac :: #import "Objective_C/AppKit";
ObjC :: #import "Objective_C";
Foundation :: #import "Objective_C"; // Foundation.jai is part of Objective_C, not a module of its own.
Mac_Input_Window :: struct {
    window: *Mac.NSWindow;
    x: s32;
    y: s32;
    width: s32;
    height: s32;
}
mac_input_windows: [..] Mac_Input_Window = .{ allocator = INPUT_HEAP };
mac_input_focus: *Mac.NSWindow;
mac_modifier_mask: u64;
mac_event_window :: (event: *Mac.NSEvent) -> *Mac.NSWindow {
    call: (receiver: *void, selector: ObjC.SEL) -> *Mac.NSWindow #c_call;
    call = cast(type_of(call)) ObjC.objc_msgSend;
    return call(event, ObjC.sel_registerName("window\0"));
}
mac_key_code :: (event: *Mac.NSEvent) -> Key_Code {
    code := Mac.NSEvent.keyCode(event);
    // Hardware codes are only used for non-text keys; layout-aware characters below.
    if code == 53 return .ESCAPE;
    if code == 36 || code == 76 return .ENTER;
    if code == 48 return .TAB;
    if code == 51 return .BACKSPACE;
    if code == 117 return .DELETE;
    if code == 123 return .ARROW_LEFT;
    if code == 124 return .ARROW_RIGHT;
    if code == 125 return .ARROW_DOWN;
    if code == 126 return .ARROW_UP;
    if code == 115 return .HOME;
    if code == 119 return .END;
    if code == 116 return .PAGE_UP;
    if code == 121 return .PAGE_DOWN;
    function_codes: [20] u16 = .[122, 120, 99, 118, 96, 97, 98, 100, 101, 109, 103, 111, 105, 107, 113, 106, 64, 79, 80, 90];
    for native, index: function_codes if native == code return cast(Key_Code) (cast(s64) Key_Code.F1 + index);
    text := Mac.NSEvent.charactersIgnoringModifiers(event);
    if !text return .UNKNOWN;
    bytes := Foundation.NSString.UTF8String(text);
    if !bytes return .UNKNOWN;
    if bytes[0] >= 97 && bytes[0] <= 122 return cast(Key_Code) (bytes[0] - 32);
    if bytes[0] >= 32 && bytes[0] < 127 return cast(Key_Code) bytes[0];
    return .UNKNOWN;
}
mac_modifiers :: (event: *Event, mask: u64) {
    event.shift_pressed = (mask & (1 << 17)) != 0;
    event.ctrl_pressed = (mask & (1 << 18)) != 0;
    event.alt_pressed = (mask & (1 << 19)) != 0;
    event.cmd_meta_pressed = (mask & (1 << 20)) != 0;
}
mac_poll_geometry :: () {
    // Only the windows the program made (Window_Creation registers them): AppKit makes and drops
    // windows of its own as the user types and clicks, and those are not the program's to report.
    index: s64 = 0;
    while index < macos_program_windows.count {
        window := macos_program_windows[index];
        // A window the user closed is ordered out but not released (setReleasedWhenClosed NO), so
        // it stays in NSApp.windows: closing shows as no longer visible without being minimized.
        if !mac_window_flag(window, "isVisible\0") && !mac_window_flag(window, "isMiniaturized\0") {
            event: Event;
            event.type = .QUIT;
            queue_input_event(cast(Window_Type) cast(u64) window, event);
            array_ordered_remove_by_index(*macos_program_windows, index);
            for mac_input_windows if it.window == window {
                array_ordered_remove_by_index(*mac_input_windows, it_index);
                break;
            }
            continue;
        }
        index += 1;
        view := Mac.NSWindow.contentView(window);
        if !view continue;
        frame := Mac.NSWindow.frame(window);
        area := Mac.NSView.convertRectToBacking(view, Mac.NSView.bounds(view));
        x := cast(s32) frame.origin.x;
        y := cast(s32) frame.origin.y;
        width := cast(s32) area.size.width;
        height := cast(s32) area.size.height;
        routed := cast(Window_Type) cast(u64) window;
        found := false;
        for *entry: mac_input_windows {
            if entry.window != window continue;
            if width != entry.width || height != entry.height queue_window_resize(routed, width, height);
            if x != entry.x || y != entry.y queue_window_move(routed, x, y);
            entry.x = x;
            entry.y = y;
            entry.width = width;
            entry.height = height;
            found = true;
            break;
        }
        if !found {
            array_add(*mac_input_windows, .{ window, x, y, width, height });
            queue_window_resize(routed, width, height);
        }
    }
}
mac_window_flag :: (window: *Mac.NSWindow, selector: *u8) -> bool {
    call: (receiver: *void, selector: ObjC.SEL) -> ObjC.BOOL #c_call;
    call = cast(type_of(call)) ObjC.objc_msgSend;
    return call(window, ObjC.sel_registerName(selector)) != 0;
}
macos_poll_input :: () {
    application := Mac.NSApplication.sharedApplication();
    if !application return;
    pool := ObjC.objc_init(ObjC.objc_alloc(Foundation.NSAutoreleasePool));
    defer Foundation.NSAutoreleasePool.drain(pool);
    while true {
        native := Mac.NSApplication.nextEventMatchingMask(application, .NSEventMaskAny,
            Foundation.NSDate.distantPast(), Mac.NSDefaultRunLoopMode, ObjC.YES);
        if !native break;
        window := mac_event_window(native);
        kind := Mac.NSEvent.type(native);
        flags := cast(u64) Mac.NSEvent.modifierFlags(native);
        event: Event;
        mac_modifiers(*event, flags);
        if window {
            routed := cast(Window_Type) cast(u64) window;
            if kind == .NSEventTypeKeyDown || kind == .NSEventTypeKeyUp {
                event.type = .KEYBOARD;
                event.key_code = mac_key_code(native);
                event.key_pressed = xx (kind == .NSEventTypeKeyDown);
                event.repeat = event.key_pressed && Mac.NSEvent.isARepeat(native) != 0;
                queue_input_event(routed, event);
                if event.key_pressed && !event.ctrl_pressed && !event.cmd_meta_pressed {
                    text := Mac.NSEvent.characters(native);
                    if text {
                        bytes := Foundation.NSString.UTF8String(text);
                        if bytes {
                            count: s64 = 0;
                            while bytes[count] != 0 count += 1;
                            queue_utf8_text(routed, .{ count, bytes }, event.repeat);
                        }
                    }
                }
            } else if kind == .NSEventTypeFlagsChanged {
                masks: [4] u64 = .[1 << 17, 1 << 18, 1 << 19, 1 << 20];
                codes: [4] Key_Code = .[.SHIFT, .CTRL, .ALT, .CMD];
                for mask, index: masks {
                    if ((flags ^ mac_modifier_mask) & mask) == 0 continue;
                    modifier_event := event;
                    modifier_event.type = .KEYBOARD;
                    modifier_event.key_code = codes[index];
                    modifier_event.key_pressed = xx ((flags & mask) != 0);
                    queue_input_event(routed, modifier_event);
                }
            } else if kind == .NSEventTypeLeftMouseDown || kind == .NSEventTypeLeftMouseUp || kind == .NSEventTypeRightMouseDown || kind == .NSEventTypeRightMouseUp || kind == .NSEventTypeOtherMouseDown || kind == .NSEventTypeOtherMouseUp {
                event.type = .KEYBOARD;
                event.key_pressed = xx (kind == .NSEventTypeLeftMouseDown || kind == .NSEventTypeRightMouseDown || kind == .NSEventTypeOtherMouseDown);
                event.key_code = .MOUSE_BUTTON_LEFT;
                if kind == .NSEventTypeRightMouseDown || kind == .NSEventTypeRightMouseUp event.key_code = .MOUSE_BUTTON_RIGHT;
                if kind == .NSEventTypeOtherMouseDown || kind == .NSEventTypeOtherMouseUp event.key_code = .MOUSE_BUTTON_MIDDLE;
                queue_input_event(routed, event);
            } else if kind == .NSEventTypeScrollWheel {
                event.type = .MOUSE_WHEEL;
                event.typical_wheel_delta = 120;
                event.wheel_delta = cast(s32) (Mac.NSEvent.deltaY(native) * 120);
                queue_input_event(routed, event);
            } else if kind == .NSEventTypeMouseMoved || kind == .NSEventTypeLeftMouseDragged || kind == .NSEventTypeRightMouseDragged || kind == .NSEventTypeOtherMouseDragged {
                queue_mouse_delta(cast(int) Mac.NSEvent.deltaX(native), cast(int) Mac.NSEvent.deltaY(native));
            }
        }
        mac_modifier_mask = flags;
        Mac.NSApplication.sendEvent(application, native);
        // AppKit keeps whatever cursor was set last; put the arrow back unless the program
        // handles the cursor itself.
        is_move := kind == .NSEventTypeMouseMoved || kind == .NSEventTypeMouseEntered;
        if window && is_move && !custom_cursor_handling Mac.NSCursor.set(Mac.NSCursor.arrowCursor());
    }
    focused := Mac.NSApplication.keyWindow(application);
    if !mac_application_active(application) focused = null;
    if focused != mac_input_focus {
        if mac_input_focus set_input_focus(cast(Window_Type) cast(u64) mac_input_focus, false);
        if focused set_input_focus(cast(Window_Type) cast(u64) focused, true);
        mac_input_focus = focused;
    }
    mac_poll_geometry();
}
macos_pointer_query :: (window: Window_Type, client_area: bool) -> float, float, bool {
    native := cast(*Mac.NSWindow) cast(u64) window;
    application := Mac.NSApplication.sharedApplication();
    if !native && application native = Mac.NSApplication.keyWindow(application);
    if !native return 0, 0, false;
    point := Mac.NSWindow.mouseLocationOutsideOfEventStream(native);
    if client_area {
        view := Mac.NSWindow.contentView(native);
        if !view return 0, 0, false;
        point = Mac.NSView.convertPoint(view, point, null);
        point = Mac.NSView.convertPointToBacking(view, point);
        area := Mac.NSView.convertRectToBacking(view, Mac.NSView.bounds(view));
        point.y = area.size.height - point.y;
    } else {
        point = mac_point_to_screen(native, point);
    }
    return cast(float) point.x, cast(float) point.y, true;
}

mac_point_to_screen :: (window: *Mac.NSWindow, point: Foundation.NSPoint) -> Foundation.NSPoint {
    call: (receiver: *void, selector: ObjC.SEL, point: Foundation.NSPoint) -> Foundation.NSPoint #c_call;
    call = cast(type_of(call)) ObjC.objc_msgSend;
    return call(window, ObjC.sel_registerName("convertPointToScreen:\0"), point);
}

mac_application_active :: (application: *Mac.NSApplication) -> bool {
    call: (receiver: *void, selector: ObjC.SEL) -> ObjC.BOOL #c_call;
    call = cast(type_of(call)) ObjC.objc_msgSend;
    return call(application, ObjC.sel_registerName("isActive\0")) != 0;
}
