// The browser playground: the page forwards its canvas's keyboard, mouse, focus and size changes
// (crates/jai-wasm/js/webgpu_host.mjs, `input` and `resize`), and this adapter turns them into
// Input events. The page already maps keys to Key_Code values.

#scope_module

Canvas_Event :: struct {
    type: u32;       // 1 key or mouse button, 2 text, 3 pointer moved, 4 wheel, 5 resize, 6 focus, 7 quit
    key: u32;        // Key_Code
    pressed: u32;
    modifiers: u32;  // 1 shift, 2 ctrl, 4 alt, 8 meta
    x: s32;
    y: s32;
    utf32: u32;
    repeat: u32;
}

jai_canvas_poll_event :: (event: *Canvas_Event) -> u32 #foreign;

wasm_pointer_x: s32;
wasm_pointer_y: s32;
wasm_has_pointer := false;

wasm_poll_input :: () {
    native: Canvas_Event;
    while jai_canvas_poll_event(*native) {
        event: Event;
        event.shift_pressed = (native.modifiers & 1) != 0;
        event.ctrl_pressed = (native.modifiers & 2) != 0;
        event.alt_pressed = (native.modifiers & 4) != 0;
        event.cmd_meta_pressed = (native.modifiers & 8) != 0;
        if native.type == {
          case 1;
            event.type = .KEYBOARD;
            event.key_code = cast(Key_Code) native.key;
            event.key_pressed = native.pressed;
            event.repeat = native.repeat != 0;
            queue_input_event(event);
          case 2;
            event.type = .TEXT_INPUT;
            event.utf32 = native.utf32;
            event.text_input_count = 1;
            queue_input_event(event);
          case 3;
            if wasm_has_pointer queue_mouse_delta(native.x - wasm_pointer_x, native.y - wasm_pointer_y);
            wasm_pointer_x, wasm_pointer_y = native.x, native.y;
            wasm_has_pointer = true;
          case 4;
            event.type = .MOUSE_WHEEL;
            event.typical_wheel_delta = WHEEL_DELTA;
            event.wheel_delta = native.y;
            queue_mouse_delta(0, 0, native.y);
            queue_input_event(event);
          case 5;
            queue_window_resize(INVALID_WINDOW, native.x, native.y);
          case 6;
            set_input_focus(native.pressed != 0);
          case 7;
            event.type = .QUIT;
            queue_input_event(event);
        }
    }
}

wasm_pointer_query :: (window: Window_Type, client_area: bool) -> float, float, bool {
    return cast(float) wasm_pointer_x, cast(float) wasm_pointer_y, wasm_has_pointer;
}
