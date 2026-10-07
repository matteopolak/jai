// Platform adapters enqueue events; this module owns frame lifetime and state.
#module_parameters (ENABLE_NATIVE_INPUT_ADAPTERS := true);
#import "Basic";
#import "Window_Type";

Input_Event_Type :: enum {
    QUIT :: 0;
    KEYBOARD :: 1;
    TEXT_INPUT :: 2;
    WINDOW :: 3;
    MOUSE_WHEEL :: 4;
    DRAG_AND_DROP_FILES :: 6;
    TOUCH :: 7;
    UNINITIALIZED :: 8;
}
Event_Type :: Input_Event_Type;
Key_Current_State :: enum_flags u32 {
    NONE :: 0;
    DOWN :: 1;
    START :: 4;
    END :: 8;
}
GAMEPAD_BUTTON_COUNT :: 32;
Key_Code :: enum {
    ESCAPE :: 0;
    MOUSE_BUTTON_LEFT :: 1;
    ARROW_UP :: 2;
    ARROW_DOWN :: 3;
    ARROW_LEFT :: 4;
    ARROW_RIGHT :: 5;
    BACKSPACE :: 8;
    TAB :: 9;
    LINEFEED :: 10;
    ENTER :: 13;
    SPACEBAR :: 32;
    DELETE :: 127;
    PAGE_UP :: 132;
    PAGE_DOWN :: 133;
    HOME :: 134;
    END :: 135;
    INSERT :: 136;
    PAUSE :: 137;
    SCROLL_LOCK :: 138;
    ALT;
    CTRL;
    SHIFT;
    CMD;
    META :: CMD;
    F1;
    F2;
    F3;
    F4;
    F5;
    F6;
    F7;
    F8;
    F9;
    F10;
    F11;
    F12;
    F13;
    F14;
    F15;
    F16;
    F17;
    F18;
    F19;
    F20;
    F21;
    F22;
    F23;
    F24;
    PRINT_SCREEN;
    MOUSE_BUTTON_MIDDLE :: 169;
    MOUSE_BUTTON_RIGHT;
    MOUSE_WHEEL_UP;
    MOUSE_WHEEL_DOWN;
    GAMEPAD_0_BEGIN :: 173;
    GAMEPAD_0_END :: 205;
    GAMEPAD_1_BEGIN :: 206;
    GAMEPAD_1_END :: 238;
    GAMEPAD_2_BEGIN :: 239;
    GAMEPAD_2_END :: 271;
    GAMEPAD_3_BEGIN :: 272;
    GAMEPAD_3_END :: 304;
    TOUCH;
    UNKNOWN :: 306;
}
Window_Event :: struct {
    Modifier_Flags :: union {
        struct {
            shift_pressed := false;
            ctrl_pressed := false;
            alt_pressed := false;
            cmd_meta_pressed := false;
        }
        packed: u32 = 0;
    }
    type: Input_Event_Type;
    key_pressed: u32; // non-zero: pressed (else released)
    key_code: Key_Code;
    using modifier_flags: Modifier_Flags;
    utf32: u32;
    repeat := false;
    text_input_count: u16;
    typical_wheel_delta: s32;
    wheel_delta: s32;
    files: [..] string;
    touch_type: enum u8 {
        MOVED :: 0;
        PRESSED :: 1;
        RELEASED :: 2;
    }
    touch_index: s32;
}
Event :: Window_Event;
NUM_BUTTON_STATES :: 307;
mouse_delta_x: int;
mouse_delta_y: int;
mouse_delta_z: int;
events_this_frame: [..] Event = .{ allocator = INPUT_HEAP };
// Borrowed frame views: payload ownership remains in events_this_frame.
Routed_Input_Event :: struct {
    window: Window_Type;
    event: Event;
}
routed_events_this_frame: [..] Routed_Input_Event = .{ allocator = INPUT_HEAP };
unrouted_events_this_frame: [..] Event = .{ allocator = INPUT_HEAP };
input_button_states: [NUM_BUTTON_STATES] Key_Current_State;
input_application_has_focus := false;
Window_Resize_Record :: struct {
    window: Window_Type;
    width: s32;
    height: s32;
}
window_resizes_this_frame: [..] Window_Resize_Record = .{ allocator = INPUT_HEAP };
Window_Move_Record :: struct {
    window: Window_Type;
    x: s32;
    y: s32;
}

// Adapters run on the owner thread. A queued event's `files` (the array and each name, all from
// the array's allocator) pass to Input, which frees them at the next update.
queue_input_event :: (event: Event) {
    array_add(*pending_events, .{ event = event });
}
queue_input_event :: (window: Window_Type, event: Event) {
    array_add(*pending_events, .{ event = event, window = window, associated = true });
}
// For sources sampled after update_window_events, including Gamepad.
publish_input_event :: (event: Event) {
    publish_pending_event(.{ event = event });
}
publish_input_event :: (window: Window_Type, event: Event) {
    publish_pending_event(.{ event = event, window = window, associated = true });
}
queue_mouse_delta :: (x: int, y: int, z: int = 0) {
    pending_mouse_x += x;
    pending_mouse_y += y;
    pending_mouse_z += z;
}
queue_window_resize :: (window: Window_Type, width: s32, height: s32) {
    for *record: pending_resizes {
        if record.window == window {
            record.width = width;
            record.height = height;
            return;
        }
    }
    array_add(*pending_resizes, .{ window, width, height });
}
// Original-API spelling of queue_window_resize: coalesces per window until the next update.
add_resize_record :: (hwnd: Window_Type, width: s32, height: s32) {
    queue_window_resize(hwnd, width, height);
}
// Set by hosts that learn a window is minimized; kept for source compatibility with the original Input module.
window_minimized := false;
WHEEL_DELTA :: 120; // Wheel units per notch, as in the original Input module.
queue_window_move :: (window: Window_Type, x: s32, y: s32) {
    for *record: pending_moves {
        if record.window == window {
            record.x = x;
            record.y = y;
            return;
        }
    }
    array_add(*pending_moves, .{ window, x, y });
}
set_input_focus :: (focused: bool) {
    unscoped_input_focus = focused;
    if !focused {
        for *record: window_input_states record.focused = false;
        release_focus_buttons(INVALID_WINDOW, false);
    }
    refresh_application_focus();
}
set_input_focus :: (window: Window_Type, focused: bool) {
    index := ensure_input_window(window);
    window_input_states[index].focused = focused;
    if !focused release_focus_buttons(window, true);
    refresh_application_focus();
}
// Unknown windows have no observed focus or held state.
window_has_input_focus :: (window: Window_Type) -> bool {
    index := find_input_window(window);
    if index < 0 return false;
    return window_input_states[index].focused;
}
get_window_key_state :: (window: Window_Type, key: Key_Code) -> Key_Current_State {
    if cast(u32) key >= NUM_BUTTON_STATES return .NONE;
    index := find_input_window(window);
    if index < 0 return .NONE;
    return window_input_states[index].buttons[cast(u32) key];
}
window_key_is_down :: (window: Window_Type, key: Key_Code) -> bool {
    return (get_window_key_state(window, key) & .DOWN) != 0;
}

get_window_resizes :: () -> [] Window_Resize_Record {
    return window_resizes_this_frame;
}
get_window_moves :: () -> [] Window_Move_Record {
    moves_to_free.count = 0;
    Swap(*pending_moves, *moves_to_free);
    return moves_to_free;
}
input_per_frame_event_and_flag_update :: () {
    routed_events_this_frame.count = 0;
    unrouted_events_this_frame.count = 0;
    // A dropped file's names share the allocator of the array that lists them.
    for event: events_this_frame {
        for file: event.files free(file, event.files.allocator);
        array_free(event.files);
    }
    events_this_frame.count = 0;
    // Motion is per frame; of the button flags only "held" carries over.
    mouse_delta_x, mouse_delta_y, mouse_delta_z = 0, 0, 0;
    for *state: input_button_states state.* &= .DOWN;
    for *state: unscoped_button_states state.* &= .DOWN;
    for *record: window_input_states for *state : record.buttons state.* &= .DOWN;
}

input_system_initialized := false;

update_window_events :: () {
    // Programs written for the official Input module never call init_input_system; without the
    // native adapter installed, no window events are pumped (on macOS the window never appears).
    if !input_system_initialized {
        input_system_initialized = true;
        init_input_system();
    }
    input_per_frame_event_and_flag_update();
    if input_event_source != null input_event_source();
    window_resizes_this_frame.count = 0;
    Swap(*pending_resizes, *window_resizes_this_frame);
    mouse_delta_x = pending_mouse_x;
    mouse_delta_y = pending_mouse_y;
    mouse_delta_z = pending_mouse_z;
    pending_mouse_x = 0;
    pending_mouse_y = 0;
    pending_mouse_z = 0;
    for pending: pending_events publish_pending_event(pending);
    pending_events.count = 0;
}
// false (the default): the pointer shows the standard arrow over Input's windows, restored as it
// moves there. true: the program sets the cursor itself and Input leaves it alone.
set_custom_cursor_handling :: (is_custom: bool) {
    custom_cursor_handling = is_custom;
}
init_input_system :: () {
    input_system_initialized = true;
    input_application_has_focus = true;
    for *state: input_button_states state.* = .NONE;
    for *state: unscoped_button_states state.* = .NONE;
    for *record: window_input_states for *state : record.buttons state.* = .NONE;
    unscoped_input_focus = false;
    if window_input_states.count > 0 refresh_application_focus();
    install_native_input_adapter();
    if input_initialize_source != null input_initialize_source();
}

// These explicit adapters are additional authored integration points. The pointer
// getters are named distinctly from Window_Creation's get_mouse_pointer_position, which
// programs commonly import alongside Input.
input_event_source: () = null;
input_initialize_source: () = null;
input_pointer_source: (window: Window_Type, client_area: bool) -> float, float = null;
input_pointer_query_source: (window: Window_Type, client_area: bool) -> float, float, bool = null;
get_input_pointer_position :: () -> float, float, bool {
    if input_pointer_query_source != null return input_pointer_query_source(INVALID_WINDOW, false);
    if input_pointer_source == null return 0, 0, false;
    x, y := input_pointer_source(INVALID_WINDOW, false);
    return x, y, true;
}
get_input_pointer_position :: (window: Window_Type, client_area := false) -> float, float {
    if input_pointer_query_source != null {
        x, y, success := input_pointer_query_source(window, client_area);
        assert(success, "Native pointer query failed");
        return x, y;
    }
    assert(input_pointer_source != null, "Input pointer adapter is not installed");
    return input_pointer_source(window, client_area);
}

#scope_module
// Input's queues live across frames, so they never take the caller's context.allocator: a program
// that runs with `context.allocator = temp` and resets temporary storage every frame would leave
// them pointing at reclaimed memory.
INPUT_HEAP :: Context_Base.default_allocator;
Pending_Input_Event :: struct {
    event: Event;
    window: Window_Type;
    associated := false;
}
pending_events: [..] Pending_Input_Event = .{ allocator = INPUT_HEAP };
Window_Input_State :: struct {
    window: Window_Type;
    focused := false;
    buttons: [NUM_BUTTON_STATES] Key_Current_State;
}
window_input_states: [..] Window_Input_State = .{ allocator = INPUT_HEAP };
unscoped_button_states: [NUM_BUTTON_STATES] Key_Current_State;
unscoped_input_focus := false;
find_input_window :: (window: Window_Type) -> s64 {
    for record, index: window_input_states if record.window == window return index;
    return -1;
}
ensure_input_window :: (window: Window_Type) -> s64 {
    index := find_input_window(window);
    if index >= 0 return index;
    record: Window_Input_State;
    record.window = window;
    array_add(*window_input_states, record);
    return window_input_states.count - 1;
}
refresh_application_focus :: () {
    input_application_has_focus = unscoped_input_focus;
    for record: window_input_states if record.focused {
        input_application_has_focus = true;
        return;
    }
}
key_has_any_owner_down :: (key: u32) -> bool {
    if (unscoped_button_states[key] & .DOWN) != 0 return true;
    for record: window_input_states if (record.buttons[key] & .DOWN) != 0 return true;
    return false;
}
update_owner_key_state :: (state: *Key_Current_State, pressed: bool) {
    if pressed {
        if (state.* & .DOWN) == 0 state.* |= .START;
        state.* |= .DOWN;
    } else state.* = (state.* | .END) & ~Key_Current_State.DOWN;
}
publish_pending_event :: (pending: Pending_Input_Event) {
    event := pending.event;
    if event.type == .KEYBOARD && cast(u32) event.key_code < NUM_BUTTON_STATES {
        key := cast(u32) event.key_code;
        if pending.associated {
            index := ensure_input_window(pending.window);
            update_owner_key_state(*window_input_states[index].buttons[key], event.key_pressed != 0);
        } else update_owner_key_state(*unscoped_button_states[key], event.key_pressed != 0);
        state := *input_button_states[key];
        if event.key_pressed {
            if (state.* & .DOWN) == 0 state.* |= .START;
            state.* |= .DOWN;
        } else if !key_has_any_owner_down(key) {
            state.* = (state.* | .END) & ~Key_Current_State.DOWN;
        }
    }
    if event.type == .MOUSE_WHEEL mouse_delta_z += event.wheel_delta;
    array_add(*events_this_frame, event);
    if pending.associated array_add(*routed_events_this_frame, .{ pending.window, event });
    else array_add(*unrouted_events_this_frame, event);
}
queued_window_key_down :: (window: Window_Type, key: u32) -> bool {
    index := find_input_window(window);
    down := false;
    if index >= 0 down = (window_input_states[index].buttons[key] & .DOWN) != 0;
    for pending: pending_events {
        if !pending.associated || pending.window != window || pending.event.type != .KEYBOARD || cast(u32) pending.event.key_code != key continue;
        down = pending.event.key_pressed != 0;
    }
    return down;
}
key_has_scoped_source :: (key: u32) -> bool {
    for record: window_input_states if (record.buttons[key] & .DOWN) != 0 return true;
    for pending: pending_events if pending.associated && pending.event.type == .KEYBOARD && cast(u32) pending.event.key_code == key return true;
    return false;
}
release_focus_buttons :: (window: Window_Type, scoped: bool) {
    if scoped {
        for key: 0..NUM_BUTTON_STATES - 1 {
            if !queued_window_key_down(window, cast(u32) key) continue;
            event: Event;
            event.type = .KEYBOARD;
            event.key_code = cast(Key_Code) key;
            queue_input_event(window, event);
        }
        return;
    }
    // Every queued scoped press must have a real record before releasing all origins.
    for pending: pending_events if pending.associated && pending.event.type == .KEYBOARD ensure_input_window(pending.window);
    for record: window_input_states release_focus_buttons(record.window, true);
    for key: 0..NUM_BUTTON_STATES - 1 {
        down := (unscoped_button_states[key] & .DOWN) != 0;
        if !down && !key_has_scoped_source(cast(u32) key) down = (input_button_states[key] & .DOWN) != 0;
        for pending: pending_events {
            if pending.associated || pending.event.type != .KEYBOARD || cast(s64) pending.event.key_code != key continue;
            down = pending.event.key_pressed != 0;
        }
        if !down continue;
        event: Event;
        event.type = .KEYBOARD;
        event.key_code = cast(Key_Code) key;
        queue_input_event(event);
    }
}
// Strict decoder shared by XIM and AppKit text streams.
queue_utf8_text :: (window: Window_Type, bytes: [] u8, repeat := false) {
    offset: s64 = 0;
    while offset < bytes.count {
        first := bytes[offset];
        offset += 1;
        scalar := cast(u32) first;
        continuation: s32 = 0;
        minimum: u32 = 0;
        if first > 0xf4 continue;
        if first >= 0xf0 {
            continuation = 3;
            scalar &= 7;
            minimum = 0x10000;
        } else if first >= 0xe0 {
            continuation = 2;
            scalar &= 15;
            minimum = 0x800;
        } else if first >= 0xc2 {
            continuation = 1;
            scalar &= 31;
            minimum = 0x80;
        } else if first >= 0x80 continue;
        if offset + continuation > bytes.count return;
        valid := true;
        for i: 0..continuation - 1 {
            next := bytes[offset + i];
            if (next & 0xc0) != 0x80 {
                valid = false;
                break;
            }
            scalar = (scalar << 6) | (next & 63);
        }
        if !valid continue;
        offset += continuation;
        if scalar < minimum || scalar > 0x10ffff || (scalar >= 0xd800 && scalar <= 0xdfff) continue;
        event: Event;
        event.type = .TEXT_INPUT;
        event.utf32 = scalar;
        event.text_input_count = 1;
        event.repeat = repeat;
        queue_input_event(window, event);
    }
}
install_native_input_adapter :: () {
    #if ENABLE_NATIVE_INPUT_ADAPTERS {
        #if OS == .WINDOWS {
            if input_event_source == null input_event_source = windows_poll_input;
            if input_pointer_source == null && input_pointer_query_source == null input_pointer_query_source = windows_pointer_query;
        } else #if OS == .LINUX {
            if input_event_source == null input_event_source = x11_poll_input;
            if input_pointer_source == null && input_pointer_query_source == null input_pointer_query_source = x11_pointer_query;
        } else #if OS == .MACOS {
            if input_event_source == null input_event_source = macos_poll_input;
            if input_pointer_source == null && input_pointer_query_source == null input_pointer_query_source = macos_pointer_query;
        }
    }
}
#if ENABLE_NATIVE_INPUT_ADAPTERS {
    #if OS == .WINDOWS {
        #load "windows.jai";
    } else #if OS == .LINUX {
        #load "x11.jai";
    } else #if OS == .MACOS {
        #load "macos.jai";
    }
}
pending_moves: [..] Window_Move_Record = .{ allocator = INPUT_HEAP };
moves_to_free: [..] Window_Move_Record = .{ allocator = INPUT_HEAP };
pending_resizes: [..] Window_Resize_Record = .{ allocator = INPUT_HEAP };
pending_mouse_x: int;
pending_mouse_y: int;
pending_mouse_z: int;
custom_cursor_handling := false;
