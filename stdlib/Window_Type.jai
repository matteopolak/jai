// Window_Type: the native window handle type of each platform.
#if OS == .WINDOWS {
    #scope_module
    ;

    Windows :: #import "Windows";

    #scope_export
    ;
    Window_Type :: Windows.HWND;
    INVALID_WINDOW: Window_Type : null;
} else #if OS == .LINUX {
    #scope_module
    ;

    X11 :: #import "X11";

    #scope_export
    ;
    Window_Type :: X11.Window;
    INVALID_WINDOW: Window_Type : 0;
} else #if OS == .MACOS {
    #scope_module
    ;

    ObjC :: #import "Objective_C/AppKit";

    #scope_export
    ;
    Window_Type :: *ObjC.NSWindow;
    INVALID_WINDOW: Window_Type : null;
    // The windows Window_Creation made. Input follows only these: AppKit makes and drops windows
    // of its own (text input, tooltips, menus) that are not the program's.
    macos_program_windows: [..] Window_Type;
} else #if OS == .PS5 {
    #scope_export
    ;
    Window_Type :: *void;
    INVALID_WINDOW: Window_Type : null;
} else #if OS == .WASM {
    // The browser has no native windows; programs that draw use a canvas the page owns.
    #scope_export
    ;
    Window_Type :: *void;
    INVALID_WINDOW: Window_Type : null;
} else #if OS == .ANDROID {
    #scope_module
    ;

    Android :: #import "Android";

    #scope_export
    ;
    Window_Type :: *Android.ANativeWindow;
    INVALID_WINDOW: Window_Type : null;
}
