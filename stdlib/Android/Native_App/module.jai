// Native activity glue: the app state, event loop and lifecycle callbacks.
#assert OS == .ANDROID "This module is only supported on Android";
#add_context android_app: *Android_App;
#load "bindings.jai";
#import "Android";
#import "Android/Jni";
#import "POSIX";
