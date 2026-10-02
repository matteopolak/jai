// Independently normalized ABI contract. No reference procedure bodies or binaries.
SDL_RELEASED :: 0 ;
SDL_PRESSED :: 1 ;
using SDL_EventType :: enum u32 {
    SDL_FIRSTEVENT :: 0 ;
    SDL_QUIT :: 0x100 ;
    SDL_APP_TERMINATING ;
    SDL_APP_LOWMEMORY ;
    SDL_APP_WILLENTERBACKGROUND ;
    SDL_APP_DIDENTERBACKGROUND ;
    SDL_APP_WILLENTERFOREGROUND ;
    SDL_APP_DIDENTERFOREGROUND ;
    SDL_WINDOWEVENT :: 0x200 ;
    SDL_SYSWMEVENT ;
    SDL_KEYDOWN :: 0x300 ;
    SDL_KEYUP ;
    SDL_TEXTEDITING ;
    SDL_TEXTINPUT ;
    SDL_KEYMAPCHANGED ;
    SDL_MOUSEMOTION :: 0x400 ;
    SDL_MOUSEBUTTONDOWN ;
    SDL_MOUSEBUTTONUP ;
    SDL_MOUSEWHEEL ;
    SDL_JOYAXISMOTION :: 0x600 ;
    SDL_JOYBALLMOTION ;
    SDL_JOYHATMOTION ;
    SDL_JOYBUTTONDOWN ;
    SDL_JOYBUTTONUP ;
    SDL_JOYDEVICEADDED ;
    SDL_JOYDEVICEREMOVED ;
    SDL_CONTROLLERAXISMOTION :: 0x650 ;
    SDL_CONTROLLERBUTTONDOWN ;
    SDL_CONTROLLERBUTTONUP ;
    SDL_CONTROLLERDEVICEADDED ;
    SDL_CONTROLLERDEVICEREMOVED ;
    SDL_CONTROLLERDEVICEREMAPPED ;
    SDL_FINGERDOWN :: 0x700 ;
    SDL_FINGERUP ;
    SDL_FINGERMOTION ;
    SDL_DOLLARGESTURE :: 0x800 ;
    SDL_DOLLARRECORD ;
    SDL_MULTIGESTURE ;
    SDL_CLIPBOARDUPDATE :: 0x900 ;
    SDL_DROPFILE :: 0x1000 ;
    SDL_DROPTEXT ;
    SDL_DROPBEGIN ;
    SDL_DROPCOMPLETE ;
    SDL_AUDIODEVICEADDED :: 0x1100 ;
    SDL_AUDIODEVICEREMOVED ;
    SDL_RENDER_TARGETS_RESET :: 0x2000 ;
    SDL_RENDER_DEVICE_RESET ;
    SDL_USEREVENT :: 0x8000 ;
    SDL_LASTEVENT :: 0xFFFF ;
}
SDL_CommonEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
}
SDL_WindowEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    windowID : u32 ;
    event : SDL_WindowEventID ;
    padding1 : u8 ;
    padding2 : u8 ;
    padding3 : u8 ;
    data1 : s32 ;
    data2 : s32 ;
}
SDL_KeyboardEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    windowID : u32 ;
    state : u8 ;
    repeat : u8 ;
    padding2 : u8 ;
    padding3 : u8 ;
    keysym : SDL_Keysym ;
}
SDL_TEXTEDITINGEVENT_TEXT_SIZE :: 32 ;
SDL_TextEditingEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    windowID : u32 ;
    text : [ SDL_TEXTEDITINGEVENT_TEXT_SIZE ] u8 ;
    start : s32 ;
    length : s32 ;
}
SDL_TEXTINPUTEVENT_TEXT_SIZE :: 32 ;
SDL_TextInputEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    windowID : u32 ;
    text : [ SDL_TEXTINPUTEVENT_TEXT_SIZE ] s8 ;
}
SDL_MouseMotionEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    windowID : u32 ;
    which : u32 ;
    state : u32 ;
    x : s32 ;
    y : s32 ;
    xrel : s32 ;
    yrel : s32 ;
}
SDL_MouseButtonEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    windowID : u32 ;
    which : u32 ;
    button : u8 ;
    state : u8 ;
    clicks : u8 ;
    padding1 : u8 ;
    x : s32 ;
    y : s32 ;
}
SDL_MouseWheelEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    windowID : u32 ;
    which : u32 ;
    x : s32 ;
    y : s32 ;
    direction : u32 ;
}
SDL_JoyAxisEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    which : SDL_JoystickID ;
    axis : u8 ;
    padding1 : u8 ;
    padding2 : u8 ;
    padding3 : u8 ;
    value : s16 ;
    padding4 : u16 ;
}
SDL_JoyBallEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    which : SDL_JoystickID ;
    ball : u8 ;
    padding1 : u8 ;
    padding2 : u8 ;
    padding3 : u8 ;
    xrel : s16 ;
    yrel : s16 ;
}
SDL_JoyHatEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    which : SDL_JoystickID ;
    hat : u8 ;
    value : u8 ;
    padding1 : u8 ;
    padding2 : u8 ;
}
SDL_JoyButtonEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    which : SDL_JoystickID ;
    button : u8 ;
    state : u8 ;
    padding1 : u8 ;
    padding2 : u8 ;
}
SDL_JoyDeviceEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    which : s32 ;
}
SDL_ControllerAxisEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    which : SDL_JoystickID ;
    axis : u8 ;
    padding1 : u8 ;
    padding2 : u8 ;
    padding3 : u8 ;
    value : s16 ;
    padding4 : u16 ;
}
SDL_ControllerButtonEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    which : SDL_JoystickID ;
    button : u8 ;
    state : u8 ;
    padding1 : u8 ;
    padding2 : u8 ;
}
SDL_ControllerDeviceEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    which : s32 ;
}
SDL_AudioDeviceEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
}
SDL_QuitEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
}
SDL_UserEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
}
SDL_SysWMEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
}
SDL_TouchFingerEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
}
SDL_MultiGestureEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
}
SDL_DollarGestureEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
}
SDL_DropEvent :: struct {
    type : SDL_EventType ;
    timestamp : u32 ;
    file : * u8 ;
    windowID : u32 ;
}
SDL_Event :: union {
    type : SDL_EventType ;
    common : SDL_CommonEvent ;
    window : SDL_WindowEvent ;
    key : SDL_KeyboardEvent ;
    edit : SDL_TextEditingEvent ;
    text : SDL_TextInputEvent ;
    motion : SDL_MouseMotionEvent ;
    button : SDL_MouseButtonEvent ;
    wheel : SDL_MouseWheelEvent ;
    jaxis : SDL_JoyAxisEvent ;
    jball : SDL_JoyBallEvent ;
    jhat : SDL_JoyHatEvent ;
    jbutton : SDL_JoyButtonEvent ;
    jdevice : SDL_JoyDeviceEvent ;
    caxis : SDL_ControllerAxisEvent ;
    cbutton : SDL_ControllerButtonEvent ;
    cdevice : SDL_ControllerDeviceEvent ;
    adevice : SDL_AudioDeviceEvent ;
    quit : SDL_QuitEvent ;
    user : SDL_UserEvent ;
    syswm : SDL_SysWMEvent ;
    tfinger : SDL_TouchFingerEvent ;
    mgesture : SDL_MultiGestureEvent ;
    dgesture : SDL_DollarGestureEvent ;
    drop : SDL_DropEvent ;
    padding : [ 56 ] u8 ;
}
#assert ( size_of ( SDL_Event ) == 56 ) ;
using SDL_eventaction :: enum u32 {
    SDL_ADDEVENT ;
    SDL_PEEKEVENT ;
    SDL_GETEVENT ;
}
SDL_PumpEvents :: ( ) #foreign SDL2 ;
SDL_PeepEvents :: ( events : * SDL_Event , numevents : s32 , action : SDL_eventaction , minType : u32 , maxType : u32 ) -> s32 #foreign SDL2 ;
SDL_HasEvent :: ( type : u32 ) -> SDL_bool #foreign SDL2 ;
SDL_HasEvents :: ( minType : u32 , maxType : u32 ) -> SDL_bool #foreign SDL2 ;
SDL_FlushEvent :: ( type : u32 ) #foreign SDL2 ;
SDL_FlushEvents :: ( minType : u32 , maxType : u32 ) #foreign SDL2 ;
SDL_PollEvent :: ( event : * SDL_Event ) -> s32 #foreign SDL2 ;
SDL_WaitEvent :: ( event : * SDL_Event ) -> s32 #foreign SDL2 ;
SDL_WaitEventTimeout :: ( event : * SDL_Event , timeout : s32 ) -> s32 #foreign SDL2 ;
SDL_PushEvent :: ( event : * SDL_Event ) -> s32 #foreign SDL2 ;
