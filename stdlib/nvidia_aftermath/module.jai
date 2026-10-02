// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
#load "nvidia_aftermath_bindings.jai";

#import "d3d12";
#import "Windows";

#assert size_of(*void) == 8 "This pinned native ABI contract supports 64-bit targets only.";
