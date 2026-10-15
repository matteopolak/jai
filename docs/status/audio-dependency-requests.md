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
  Superseded source-relative limitation: bare native-library search and static
  archives are now implemented and host relocation tests pass. The concrete
  source-less local manifest fragment, conditional focus.m unit, six target SDK
  recipes and validation plan are in ../features/audio-native-integration.md.
- Compiler owner: nested COM overlay names are rejected at the field parser.
  Audio uses the identical zero-offset IUnknown prefix overlay and retains all
  reviewed fields/types. A general nested-overlay improvement needs owner review.
- Reviewed-spec coordinator: resolve remaining helper contracts and Android
  conditional public signatures in sound-player questions; no absent-user prompt
  is needed. The refreshed history and phase synchronization contracts are resolved.
- Compiler owner: add Android to the target OS model and CLI. An actual `-os
  android` check currently exits 2 (unknown OS); Linux is not counted as Android.
  Native Android/Windows ARM64 SDKs and native Linux/Windows execution remain
  coordinator validation dependencies; no peer toolchain changes are made here.
