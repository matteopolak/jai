#scope_file
Math :: #import "Math";
Vector2 :: Math.Vector2;
Input :: #import "Input";
Key_Current_State :: Input.Key_Current_State;
#scope_export

Gamepad :: struct {
    connected: bool;
    buttons: [] Key_Current_State;
    left_stick: Vector2;
    right_stick: Vector2;
    left_trigger: float;
    right_trigger: float;
    generate_events: bool;
    generate_left_stick_events: bool;
    left_stick_rotation_angle: float;
    right_stick_rotation_angle: float;
    left_stick_deadzone: float;
    right_stick_deadzone: float;
    left_trigger_deadzone: float;
    right_trigger_deadzone: float;
    left_stick_threshold: float;
    right_stick_threshold: float;
    left_trigger_threshold: float;
    right_trigger_threshold: float;
}
gamepad: Gamepad;
Gamepad_Code :: enum {
    DPAD_UP;
    DPAD_DOWN;
    DPAD_LEFT;
    DPAD_RIGHT;
    START;
    BACK;
    LEFT_SHOULDER;
    RIGHT_SHOULDER;
    LEFT_TRIGGER;
    RIGHT_TRIGGER;
    A;
    B;
    X;
    Y;
    LEFT_STICK_UP;
    LEFT_STICK_DOWN;
    LEFT_STICK_LEFT;
    LEFT_STICK_RIGHT;
    RIGHT_STICK_UP;
    RIGHT_STICK_DOWN;
    RIGHT_STICK_LEFT;
    RIGHT_STICK_RIGHT;
    LEFT_STICK_CLICK;
    RIGHT_STICK_CLICK;
}

// A provider supplies normalized physical state; derived events are owned here.
Gamepad_Sample :: struct {
    buttons: u32;
    left_stick: Vector2;
    right_stick: Vector2;
    left_trigger: float;
    right_trigger: float;
}
gamepad_sample_source: (sample: *Gamepad_Sample) -> bool = null;

init_gamepad :: () {
    gamepad.buttons.data = *Input.input_button_states[cast(s64) Input.Key_Code.GAMEPAD_0_BEGIN];
    gamepad.buttons.count = Input.GAMEPAD_BUTTON_COUNT;
    gamepad.connected = false;
    gamepad.left_stick = .{};
    gamepad.right_stick = .{};
    gamepad.left_trigger = 0;
    gamepad.right_trigger = 0;
    for *button: gamepad.buttons button.* = .NONE;
    #if OS == .WINDOWS {
        if gamepad_sample_source == null gamepad_sample_source = sample_xinput;
    } else #if OS == .LINUX {
        if gamepad_sample_source == null gamepad_sample_source = sample_evdev;
    } else #if OS == .MACOS {
        if gamepad_sample_source == null gamepad_sample_source = sample_gamecontroller;
    }
}

update_gamepad :: () {
    if gamepad.buttons.data == null init_gamepad();
    sample: Gamepad_Sample;
    connected := false;
    if gamepad_sample_source != null connected = gamepad_sample_source(*sample);
    gamepad.connected = connected;
    if !connected sample = .{};
    gamepad.left_stick = filter_stick(sample.left_stick, gamepad.left_stick_deadzone, gamepad.left_stick_rotation_angle);
    gamepad.right_stick = filter_stick(sample.right_stick, gamepad.right_stick_deadzone, gamepad.right_stick_rotation_angle);
    gamepad.left_trigger = filter_trigger(sample.left_trigger, gamepad.left_trigger_deadzone);
    gamepad.right_trigger = filter_trigger(sample.right_trigger, gamepad.right_trigger_deadzone);
    for i: 0..Input.GAMEPAD_BUTTON_COUNT - 1 {
        pressed := (sample.buttons & ((cast(u32) 1) << i)) != 0;
        code := cast(Gamepad_Code) i;
        if code == .LEFT_TRIGGER pressed = gamepad.left_trigger > gamepad.left_trigger_threshold;
        if code == .RIGHT_TRIGGER pressed = gamepad.right_trigger > gamepad.right_trigger_threshold;
        if code == .LEFT_STICK_UP pressed = gamepad.left_stick.y > gamepad.left_stick_threshold;
        if code == .LEFT_STICK_DOWN pressed = gamepad.left_stick.y < -gamepad.left_stick_threshold;
        if code == .LEFT_STICK_LEFT pressed = gamepad.left_stick.x < -gamepad.left_stick_threshold;
        if code == .LEFT_STICK_RIGHT pressed = gamepad.left_stick.x > gamepad.left_stick_threshold;
        if code == .RIGHT_STICK_UP pressed = gamepad.right_stick.y > gamepad.right_stick_threshold;
        if code == .RIGHT_STICK_DOWN pressed = gamepad.right_stick.y < -gamepad.right_stick_threshold;
        if code == .RIGHT_STICK_LEFT pressed = gamepad.right_stick.x < -gamepad.right_stick_threshold;
        if code == .RIGHT_STICK_RIGHT pressed = gamepad.right_stick.x > gamepad.right_stick_threshold;
        update_button_state(pressed, code);
    }
}

#scope_file
#import "Basic";
filter_stick :: (stick: Vector2, deadzone: float, angle: float) -> Vector2 {
    length := Math.sqrt(stick.x * stick.x + stick.y * stick.y);
    zone := clamp(deadzone, 0.0, 0.9999);
    if length <= zone return .{};
    scale := clamp((length - zone) / (1 - zone), 0.0, 1.0) / length;
    x := stick.x * scale;
    y := stick.y * scale;
    return .{ x * Math.cos(angle) - y * Math.sin(angle), x * Math.sin(angle) + y * Math.cos(angle) };
}
filter_trigger :: (value: float, deadzone: float) -> float {
    zone := clamp(deadzone, 0.0, 0.9999);
    return clamp((value - zone) / (1 - zone), 0.0, 1.0);
}
update_button_state :: (pressed: bool, code: Gamepad_Code) {
    index := cast(s64) code;
    button := *gamepad.buttons[index];
    was_down := (button.* & .DOWN) != 0;
    if pressed == was_down return;
    if pressed button.* |= .DOWN | .START;
    else button.* = (button.* & ~Key_Current_State.DOWN) | .END;
    left_stick := index >= cast(s64) Gamepad_Code.LEFT_STICK_UP && index <= cast(s64) Gamepad_Code.LEFT_STICK_RIGHT;
    if !gamepad.generate_events && !(left_stick && gamepad.generate_left_stick_events) return;
    event: Input.Event;
    event.type = .KEYBOARD;
    event.key_pressed = xx (pressed);
    event.key_code = cast(Input.Key_Code) (cast(s64) Input.Key_Code.GAMEPAD_0_BEGIN + index);
    Input.publish_input_event(event);
}

#if OS == .WINDOWS {
    #load "Xinput.jai";
    sample_xinput :: (sample: *Gamepad_Sample) -> bool {
        sample.* = .{};
        state: XINPUT_STATE;
        if XInputGetState(0, *state) != 0 return false;
        sample.left_stick = .{ cast(float) state.Gamepad.sThumbLX / 32768, cast(float) state.Gamepad.sThumbLY / 32768 };
        sample.right_stick = .{ cast(float) state.Gamepad.sThumbRX / 32768, cast(float) state.Gamepad.sThumbRY / 32768 };
        sample.left_trigger = cast(float) state.Gamepad.bLeftTrigger / 255;
        sample.right_trigger = cast(float) state.Gamepad.bRightTrigger / 255;
        masks: [14] u16 = .[1, 2, 4, 8, 16, 32, 256, 512, 4096, 8192, 16384, 32768, 64, 128];
        codes: [14] Gamepad_Code = .[.DPAD_UP, .DPAD_DOWN, .DPAD_LEFT, .DPAD_RIGHT, .START, .BACK, .LEFT_SHOULDER, .RIGHT_SHOULDER, .A, .B, .X, .Y, .LEFT_STICK_CLICK, .RIGHT_STICK_CLICK];
        for mask, i: masks {
            if (state.Gamepad.wButtons & mask) != 0 sample.buttons |= (cast(u32) 1) << cast(s64) codes[i];
        }
        return true;
    }
}

#if OS == .LINUX {
    #load "linux.jai";
} else #if OS == .MACOS {
    #load "macos.jai";
    #load "iohid-provider.jai";
}

#load "sdl.jai";
