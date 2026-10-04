// Independent declaration normalization; see docs/stdlib/native-bindings.md.
#if OS == .WINDOWS {
    #load "windows.jai";
} else {
    #load "unix.jai";
}

#scope_module

#import "Math";

#assert size_of(*void) == 8 "This pinned native ABI contract supports 64-bit targets only.";

#scope_module
Basic :: #import "Basic";
#load "native.jai";
#assert size_of(Vector3) == 12 && size_of(Vector2) == 8 "Atlas native vertex ABI requires packed float3 and float2 records.";
