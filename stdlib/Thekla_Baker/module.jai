// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
#if OS == .WINDOWS {
    #load "windows.jai";
} else #if OS == .LINUX || OS == .MACOS {
    #load "unix.jai";
} else {
    #assert(false);
}

#scope_module

#import "Math";

#assert size_of(*void) == 8 "This pinned native ABI contract supports 64-bit targets only.";
