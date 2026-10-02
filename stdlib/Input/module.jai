// Platform adapters enqueue events; this module owns frame lifetime and state.
#import "Basic";
Window_Type :: s64;

Input_Event_Type :: enum {
    QUIT :: 0; KEYBOARD :: 1; TEXT_INPUT :: 2; WINDOW :: 3;
    MOUSE_WHEEL :: 4; DRAG_AND_DROP_FILES :: 6; TOUCH :: 7; UNINITIALIZED :: 8;
}
Event_Type :: Input_Event_Type;
Key_Current_State :: enum_flags u32 {
    NONE :: 0; DOWN :: 1; START :: 4; END :: 8;
}
GAMEPAD_BUTTON_COUNT :: 32;
Key_Code :: enum {
    ESCAPE :: 0; MOUSE_BUTTON_LEFT :: 1;
    ARROW_UP :: 2; ARROW_DOWN :: 3; ARROW_LEFT :: 4; ARROW_RIGHT :: 5;
    BACKSPACE :: 8; TAB :: 9; LINEFEED :: 10; ENTER :: 13;
    SPACEBAR :: 32; DELETE :: 127;
    PAGE_UP :: 132; PAGE_DOWN :: 133; HOME :: 134; END :: 135; INSERT :: 136;
    PAUSE :: 137; SCROLL_LOCK :: 138; ALT; CTRL; SHIFT; CMD; META :: CMD;
    F1; F2; F3; F4; F5; F6; F7; F8; F9; F10; F11; F12;
    F13; F14; F15; F16; F17; F18; F19; F20; F21; F22; F23; F24;
    PRINT_SCREEN; MOUSE_BUTTON_MIDDLE :: 169; MOUSE_BUTTON_RIGHT;
    MOUSE_WHEEL_UP; MOUSE_WHEEL_DOWN;
    GAMEPAD_0_BEGIN :: 173; GAMEPAD_0_END :: 205;
    GAMEPAD_1_BEGIN :: 206; GAMEPAD_1_END :: 238;
    GAMEPAD_2_BEGIN :: 239; GAMEPAD_2_END :: 271;
    GAMEPAD_3_BEGIN :: 272; GAMEPAD_3_END :: 304;
    TOUCH; UNKNOWN :: 306;
}
Window_Event :: struct {
    Modifier_Flags :: union {
        struct {
            shift_pressed := false; ctrl_pressed := false;
            alt_pressed := false; cmd_meta_pressed := false;
        }
        packed: u32 = 0;
    }
    type: Input_Event_Type;
    key_pressed: bool;
    key_code: Key_Code;
    using modifier_flags: Modifier_Flags;
    utf32: u32;
    repeat := false;
    text_input_count: u16;
    typical_wheel_delta: s32;
    wheel_delta: s32;
    files: [..] string;
    touch_type: enum u8 { MOVED :: 0; PRESSED :: 1; RELEASED :: 2; }
    touch_index: s32;
}
Event :: Window_Event;
NUM_BUTTON_STATES :: 307;
mouse_delta_x: int;
mouse_delta_y: int;
mouse_delta_z: int;
events_this_frame: [..] Event;
input_button_states: [NUM_BUTTON_STATES] Key_Current_State;
input_application_has_focus := false;
Window_Resize :: struct { window: Window_Type; width: int; height: int; }
Window_Resize_Record :: Window_Resize;
window_resizes_this_frame: [..] Window_Resize;
Window_Move_Record :: struct { window: Window_Type; x: s32; y: s32; }

// Adapters run on the owner thread; drag-and-drop buffers transfer ownership.
queue_input_event :: (event: Event) {
    array_add(*pending_events, event);
}
queue_mouse_delta :: (x: int, y: int, z: int = 0) {
    pending_mouse_x += x; pending_mouse_y += y; pending_mouse_z += z;
}
queue_window_resize :: (window: Window_Type, width: s32, height: s32) {
    for *record: pending_resizes {
        if record.window == window { record.width = width; record.height = height; return; }
    }
    array_add(*pending_resizes, .{window, width, height});
}
queue_window_move :: (window: Window_Type, x: s32, y: s32) {
    for *record: pending_moves {
        if record.window == window { record.x = x; record.y = y; return; }
    }
    array_add(*pending_moves, .{window, x, y});
}
set_input_focus :: (focused: bool) {
    input_application_has_focus = focused;
    if focused return;
    for *state, index: input_button_states {
        if (state.* & .DOWN) == 0 continue;
        state.* = .END;
        release: Event;
        release.type = .KEYBOARD;
        release.key_code = cast(Key_Code) index;
        release.key_pressed = false;
        queue_input_event(release);
    }
}

get_window_resizes :: () -> [..] Window_Resize {
    return window_resizes_this_frame;
}
get_window_moves :: () -> [] Window_Move_Record {
    moves_to_free.count = 0;
    swap(*pending_moves, *moves_to_free);
    return moves_to_free;
}
input_per_frame_event_and_flag_update :: () {
    for event: events_this_frame {
        for file: event.files free(file);
        array_free(event.files);
    }
    events_this_frame.count = 0;
    for *state: input_button_states state.* &= .DOWN;
    mouse_delta_x = 0; mouse_delta_y = 0; mouse_delta_z = 0;
}

update_window_events :: () {
    input_per_frame_event_and_flag_update();
    if input_event_source != null input_event_source();
    window_resizes_this_frame.count = 0;
    swap(*pending_resizes, *window_resizes_this_frame);
    mouse_delta_x = pending_mouse_x; mouse_delta_y = pending_mouse_y; mouse_delta_z = pending_mouse_z;
    pending_mouse_x = 0; pending_mouse_y = 0; pending_mouse_z = 0;
    for event: pending_events {
        if event.type == .KEYBOARD && cast(u32) event.key_code < NUM_BUTTON_STATES {
            state := *input_button_states[cast(u32) event.key_code];
            if event.key_pressed {
                if (state.* & .DOWN) == 0 state.* |= .START;
                state.* |= .DOWN;
            } else {
                state.* |= .END;
                state.* &= ~Key_Current_State.DOWN;
            }
        }
        if event.type == .MOUSE_WHEEL mouse_delta_z += event.wheel_delta;
        array_add(*events_this_frame, event);
    }
    pending_events.count = 0;
}
set_custom_cursor_handling :: (is_custom: bool) {
    custom_cursor_handling = is_custom;
}
init_input_system :: () {
    input_application_has_focus = true;
    for *state: input_button_states state.* = .NONE;
    if input_initialize_source != null input_initialize_source();
}

// These explicit adapters are additional authored integration points.
input_event_source: () = null;
input_initialize_source: () = null;
input_pointer_source: (window: Window_Type, client_area: bool) -> float, float = null;
get_mouse_pointer_position :: () -> float, float, bool {
    if input_pointer_source == null return 0, 0, false;
    x, y := input_pointer_source(cast(Window_Type) 0, false);
    return x, y, true;
}
get_mouse_pointer_position :: (window: Window_Type, client_area := false) -> float, float {
    assert(input_pointer_source != null, "Input pointer adapter is not installed");
    return input_pointer_source(window, client_area);
}

#scope_module
pending_events: [..] Event;
pending_moves: [..] Window_Move_Record;
moves_to_free: [..] Window_Move_Record;
pending_resizes: [..] Window_Resize_Record;
pending_mouse_x: int; pending_mouse_y: int; pending_mouse_z: int;
custom_cursor_handling := false;
