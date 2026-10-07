// Metal: bindings to Apple's GPU API through the Objective-C runtime.
#assert(OS == .MACOS || OS == .IOS, "Metal is only supported on Apple platforms");

#load "Metal.jai";
#scope_module
#import "macos";
