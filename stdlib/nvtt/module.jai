// Independent declaration normalization; see docs/stdlib/native-bindings.md.
#if OS == .WINDOWS {
    #load "windows.jai";

    #scope_module
    #import "Windows";

} else #if OS == .LINUX {
    #load "linux.jai";
} else #if OS == .MACOS {
    #load "macos.jai";
} else #if OS == .PS5 {
    #assert false "Pinned NVTT PS5 ABI is unavailable.";
} else {
    #assert(false);
}

#assert size_of(*void) == 8 "This pinned native ABI contract supports 64-bit targets only.";

#assert CPU == .X64 "The legacy NVTT C++ return bridge requires the reviewed x86-64 calling convention.";
