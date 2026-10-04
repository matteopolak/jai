// Independently normalized ABI contract. No reference procedure bodies or binaries.
#if OS == . WINDOWS {
    #scope_module
    ;
    Windows :: #import "Windows" ;
    #scope_export
    ;
    Window_Type :: Windows . HWND ;
    INVALID_WINDOW : Window_Type : null ;
}
else #if OS == . LINUX {
    #scope_module
    ;
    X11 :: #import "X11" ;
    #scope_export
    ;
    Window_Type :: X11 . Window ;
    INVALID_WINDOW : Window_Type : 0 ;
}
else #if OS == . MACOS {
    #scope_module
    ;
    ObjC :: #import "Objective_C/AppKit" ;
    #scope_export
    ;
    Window_Type :: * ObjC . NSWindow ;
    INVALID_WINDOW : Window_Type : null ;
}
else #if OS == . PS5 {
    #scope_export
    ;
    Window_Type :: * void ;
    INVALID_WINDOW : Window_Type : null ;
}
else #if OS == . WASM {
    // The browser has no native windows; programs that draw use a canvas the page owns.
    #scope_export
    ;
    Window_Type :: * void ;
    INVALID_WINDOW : Window_Type : null ;
}
else #if OS == . ANDROID {
    #scope_module
    ;
    Android :: #import "Android" ;
    #scope_export
    ;
    Window_Type :: * Android . ANativeWindow ;
    INVALID_WINDOW : Window_Type : null ;
}
