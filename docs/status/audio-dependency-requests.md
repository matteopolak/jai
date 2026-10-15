# Audio dependency requests

No peer sources or shared manifest files were changed.

- Bindings/coordinator: package the existing pinned stb_vorbis static/shared native
  library for all supported targets. Audio builds a local copy solely for tests.
  No public codec type changes or pl_mpeg dependency are needed.
- Coordinator/native packaging: integrate stdlib/internal/audio/native/output.c
  as an owned native library. macOS needs AudioToolbox/CoreAudio/CoreFoundation;
  Linux needs ALSA; Windows source uses WinMM. Source-relative local dylib loading
  is tested, but relocated/release installations are not verified. Coordinate
  tools/native-libs.json and shared build changes outside this worker's checkout.
- Compiler owner: nested COM overlay names are rejected at the field parser.
  Audio uses the identical zero-offset IUnknown prefix overlay and retains all
  reviewed fields/types. A general nested-overlay improvement needs owner review.
- Reviewed-spec coordinator: resolve remaining helper contracts and Android
  conditional public signatures in sound-player questions; no absent-user prompt
  is needed. advance_history_cursor has no implementable behavior specification.
