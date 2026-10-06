#scope_file
SDL_Gamepad :: #import "SDL";
sdl_controller:*SDL_Gamepad.SDL_GameController;
sdl_gamepad_initialized:=false;
#scope_export
// Explicit optional SDL2 provider uses the installed SDL mapping database.
use_sdl_gamepad :: () -> bool {
    if !sdl_gamepad_initialized {
        if SDL_Gamepad.SDL_InitSubSystem(.SDL_INIT_GAMECONTROLLER)!=0 return false;
        sdl_gamepad_initialized=true;
    }
    gamepad_sample_source=sample_sdl_gamepad;
    return true;
}
close_sdl_gamepad :: () {
    if sdl_controller { SDL_Gamepad.SDL_GameControllerClose(sdl_controller); sdl_controller=null; }
    if sdl_gamepad_initialized { SDL_Gamepad.SDL_QuitSubSystem(.SDL_INIT_GAMECONTROLLER); sdl_gamepad_initialized=false; }
}
sample_sdl_gamepad :: (sample:*Gamepad_Sample) -> bool {
    sample.*=.{};
    if !sdl_gamepad_initialized return false;
    SDL_Gamepad.SDL_GameControllerUpdate();
    if sdl_controller && SDL_Gamepad.SDL_GameControllerGetAttached(sdl_controller)==.SDL_FALSE {
        SDL_Gamepad.SDL_GameControllerClose(sdl_controller); sdl_controller=null;
    }
    if !sdl_controller {
        count:=SDL_Gamepad.SDL_NumJoysticks();
        for index:0..count-1 {
            if SDL_Gamepad.SDL_IsGameController(cast(s32)index)==.SDL_FALSE continue;
            sdl_controller=SDL_Gamepad.SDL_GameControllerOpen(cast(s32)index);
            if sdl_controller break;
        }
    }
    if !sdl_controller return false;
    SDL_Gamepad.SDL_GameControllerUpdate();
    sample.left_stick=.{sdl_axis(.SDL_CONTROLLER_AXIS_LEFTX),-sdl_axis(.SDL_CONTROLLER_AXIS_LEFTY)};
    sample.right_stick=.{sdl_axis(.SDL_CONTROLLER_AXIS_RIGHTX),-sdl_axis(.SDL_CONTROLLER_AXIS_RIGHTY)};
    sample.left_trigger=clamp(sdl_axis(.SDL_CONTROLLER_AXIS_TRIGGERLEFT),0.0,1.0);
    sample.right_trigger=clamp(sdl_axis(.SDL_CONTROLLER_AXIS_TRIGGERRIGHT),0.0,1.0);
    codes:[14]Gamepad_Code=.[.A,.B,.X,.Y,.BACK,.START,.LEFT_STICK_CLICK,.RIGHT_STICK_CLICK,.LEFT_SHOULDER,.RIGHT_SHOULDER,.DPAD_UP,.DPAD_DOWN,.DPAD_LEFT,.DPAD_RIGHT];
    buttons:[14]SDL_Gamepad.SDL_GameControllerButton=.[.SDL_CONTROLLER_BUTTON_A,.SDL_CONTROLLER_BUTTON_B,.SDL_CONTROLLER_BUTTON_X,.SDL_CONTROLLER_BUTTON_Y,.SDL_CONTROLLER_BUTTON_BACK,.SDL_CONTROLLER_BUTTON_START,.SDL_CONTROLLER_BUTTON_LEFTSTICK,.SDL_CONTROLLER_BUTTON_RIGHTSTICK,.SDL_CONTROLLER_BUTTON_LEFTSHOULDER,.SDL_CONTROLLER_BUTTON_RIGHTSHOULDER,.SDL_CONTROLLER_BUTTON_DPAD_UP,.SDL_CONTROLLER_BUTTON_DPAD_DOWN,.SDL_CONTROLLER_BUTTON_DPAD_LEFT,.SDL_CONTROLLER_BUTTON_DPAD_RIGHT];
    for button,index:buttons if SDL_Gamepad.SDL_GameControllerGetButton(sdl_controller,button)!=0 sample.buttons |= (cast(u32)1)<<cast(s64)codes[index];
    return true;
}
#scope_file
sdl_axis :: (axis:SDL_Gamepad.SDL_GameControllerAxis) -> float {
    raw:=SDL_Gamepad.SDL_GameControllerGetAxis(sdl_controller,axis);
    if raw<0 return cast(float)raw/32768;
    return cast(float)raw/32767;
}
