// Independent declaration normalization; see docs/stdlib/native-bindings.md.
#load "bindings.jai";

#assert size_of(*void) == 8 "This pinned native ABI contract supports 64-bit targets only.";
