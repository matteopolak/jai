// Independent declaration normalization; see docs/stdlib/native-bindings.md.
#load "bindings.jai";

#if OS == .WINDOWS || OS == .PS5 {
    #scope_module
    FILE :: void;
} else #if OS_IS_UNIX {
    #import "POSIX";
    // The codec calls libm (sin, pow, exp...); nothing in Jai does, so link it explicitly.
    codec_math :: #system_library,link_always "m";
} else {
    #assert false;
}

#assert size_of(*void) == 8 "This pinned native ABI contract supports 64-bit targets only.";
