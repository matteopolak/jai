// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
#load "telemetry.jai";

#assert size_of(*void) == 8 "This pinned native ABI contract supports 64-bit targets only.";
