// Normalized API contracts; reference procedure bodies were discarded.
#assert OS == .ANDROID "This module is only supported on Android";
#add_context android_app: *Android_App;
#load "bindings.jai";
#import "Android";
#import "Android/Jni";
#import "POSIX";
