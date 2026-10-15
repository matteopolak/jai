# Audio dependency requests

No peer sources or shared manifest files were changed.

- Bindings/coordinator: package the existing pinned stb_vorbis static/shared native
  library for all supported targets. Audio builds a local copy solely for tests.
  No public codec type changes or pl_mpeg dependency are needed.
- Coordinator/native packaging: integrate stdlib/internal/audio/native/output.c
  as an owned native library, staging `output.h` and `routing.h` too. macOS needs
  AudioToolbox/CoreAudio/CoreFoundation/AppKit/CoreGraphics; Linux needs ALSA;
  Windows source uses WinMM/user32. Coordinate
  tools/native-libs.json and shared build changes outside this worker's checkout.
  Bare native-library search and static archives are implemented, and actual
  ARM64 host relocation tests pass. The concrete
  source-less local manifest fragment, conditional focus.m unit, six target SDK
  recipes and validation plan are in ../features/audio-native-integration.md.
- Compiler owner: nested COM overlay names are rejected at the field parser.
  Audio uses the identical zero-offset IUnknown prefix overlay and retains all
  reviewed fields/types. A general nested-overlay improvement needs owner review.
- Reviewed-spec coordinator: resolve remaining helper contracts and Android
  conditional public signatures in sound-player questions; no absent-user prompt
  is needed. The refreshed history and phase synchronization contracts are resolved.
  Refreshed questions 2/4/6/7/9 are now implemented; remaining numeric clarification
  is narrow and does not justify seeking original private source behavior.
- Compiler owner: add Android to the target OS model and CLI. An actual `-os
  android` check currently exits 2 (unknown OS); Linux is not counted as Android.
  Native Android/Windows ARM64 SDKs and native Linux/Windows execution remain
  coordinator validation dependencies; no peer toolchain changes are made here.

- Thread owner: NEW `internal/thread/synchronization.jai` places essential
  mutex/condition/semaphore SDK operations inside `Basic.assert` arguments;
  `lifecycle.jai` similarly guards Windows ResumeThread/CloseHandle this way.
  Basic(ENABLE_ASSERT=false) discards those arguments. A staged global-default
  experiment failed audio's decode join with `thread completion wait failed`.
  This is a genuine dependency safety defect, not a legacy test expectation.
  Please move essential SDK operations outside optional assertions and provide
  assertion-disabled lifecycle tests. Audio does not edit those peer sources.
  Audio's own disabled-assert regression deliberately leaves Thread's default
  assertion configuration intact to isolate owned evidence.
  Exact minimal reproducer: `tests/audio/dependencies/thread-no-assert.jai`;
  run `python3 tools/audio_reproduce_thread_dependency.py` (currently exits 1).
  Action: `init(Semaphore)`, `signal`, then `wait_for(..., 0)` must yield SUCCESS.
  Native ARM64 macOS interpreter baseline yields SUCCESS; staged default-off
  Thread yields ERROR. Original full configuration was
  `tests/audio/assertion-independent.jai` with a staged NEW Basic facade defaulting
  ENABLE_ASSERT=false globally: exit -6, Thread diagnostic `thread completion wait
  failed`, followed by audio fatal `audio decode worker join failed`. This failure
  is preserved here; the narrower audio-only configuration is not its resolution.
