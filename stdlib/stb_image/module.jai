// Independent declaration normalization; see docs/stdlib/native-bindings.md.
#load "bindings.jai";

#if OS == .WINDOWS || OS == .PS5 {
    #scope_module
    FILE :: void;
} else #if OS_IS_UNIX {
    #import "POSIX";
    codec_math :: #system_library "m";
} else {
    #assert false;
}

#assert size_of(*void) == 8 "This pinned native ABI contract supports 64-bit targets only.";
