# Window and audio bindings

## What it is

These independently authored Jai modules preserve the included SDL2, X11, window, icon, and sound API surfaces. Native operations call trusted system SDKs. SDL's native runtime remains an external dependency.

## How it works

`stdlib/SDL/` keeps the supplied SDL2 names, defaults, constants, and layouts, and binds `#system_library "SDL2"`. Rectangle tests, version packing, position encoding, scan-code mapping, mouse-button and audio-format masks, and BMP opening have independent bodies. The included `2.0.1` header constants and `src/SDL2-2.30.2` historical build path are compatibility metadata; the installed SDK version was not probed. Maintained upstream contracts are in the [SDL2 API documentation](https://wiki.libsdl.org/SDL2/CategoryAPI) and [SDL_CreateWindow](https://wiki.libsdl.org/SDL2/SDL_CreateWindow).

`SDL/generate.jai` independently implements a manually invoked CMake workflow, including command failure handling and release/debug configurations. `--source <directory>` selects independently obtained upstream SDL2 source; further arguments are forwarded to CMake. The script writes under `build/SDL2-<platform>-<variant>`, performs no `#run` build, and does not search distribution binaries. No build command was executed in this rewrite. See the maintained [SDL2 CMake documentation](https://wiki.libsdl.org/SDL2/README-cmake).

`stdlib/X11/` preserves Xlib/GLX contracts against `X11`, `GL`, and `c`. Independent conveniences initialize the display and protocol atoms, advertise drag-and-drop types, release clipboard storage, manage simple buttons/events/dialogs, query ownership and selection events, draw text, and set size/attention hints. Modal message boxes use a separate display connection so they do not consume the application's pending events. These helpers are not a replacement for the native X server or window manager. The [Xlib manual](https://www.x.org/releases/current/doc/libX11/libX11/libX11.html) is the authoritative API reference.

`Window_Creation` retains the platform signatures and `Window_Type` handles. Windows registers a class, converts UTF-8 titles, creates a native window, and saves/restores fullscreen styles and geometry. Linux chooses a GLX visual and creates/maps an X11 window; fullscreen sends an EWMH request. macOS initializes `NSApplication`, discovers optional context delegate factories, and builds a native `NSWindow` with an AppKit `NSOpenGLView` compatibility view. Its fullscreen wrapper saves/restores the window style and frame. Android returns the existing NativeActivity window and changes native fullscreen flags. The custom shipped rendering-view binary is not loaded.

`Icon.jai` allocates the compiler plugin, handles options/help/cleanup, and processes the executable post-write event. Windows delegates icon modification to the independent `Windows_Resources` implementation. Other platforms report unavailable executable-icon updates.

`Sound_Player` now has independent bodies for PCM WAV/IMA ADPCM/Vorbis loading, cached decode pages, the decode worker and completed queues, stream lifecycle, listener/rate/volume updates, panning, resampling, accumulation, PCM clipping, output history, and async filling. WAV/ADPCM storage is copied into the returned `Sound_Data`; Vorbis borrows its owned compressed buffer while its decoder is alive. Page coordinates and playback positions count frames; PCM buffers interleave signed 16-bit channel samples.

Completed pages enter the mixer only while `sound_mutex` is held. Stopping a stream with pending decode work retains both the stream and its asset until those pages finish; the decoder and `release_asset` callback are then retired. Shutdown joins workers before releasing page memory. `release_asset` runs under the sound lock and must not re-enter sound-player APIs that acquire that lock.

Platform output delegates to real SDK APIs: ALSA PCM writes/recovery, AudioUnit initialization and a render callback, DirectSound buffer positions/locks, or AAudio builder/write operations. AudioUnit rendering uses atomic cursors in a single-producer/single-consumer ring and does not acquire the writer mutex or allocate in the render callback. The writer mutex is initialized after the ring reaches its final storage address. Output-device enumeration uses ALSA hints, CoreAudio AudioObject properties, DirectSound enumeration, or Android `AudioManager.getDevices(GET_DEVICES_OUTPUTS)` through JNI. JNI names are converted through Java's UTF-8 byte encoding, and thread attachment/local references are cleaned up.

The playback implementations currently negotiate stereo signed-16 output. Panning supports the preserved channel structures, but negotiated surround layouts, alternate device selection, application-focus muting, reconnect handling, and historical sound-engine timing/quality parity are incomplete or unverified. Source bodies establish actual algorithms and SDK calls; they do not establish working playback on a device.

## Verification and remaining gaps

The detailed inventory is `stdlib/.coverage/window-audio-bindings.json`: 38 source files, 223 independent bodies, 883 retained or added foreign declarations, and zero remaining `Native_Adapters` procedures. Fifteen of those foreign declarations belong to the optional unavailable `jai-stdlib-unavailable-sofd` file-dialog library; they are explicitly not implementations. The other 868 declarations are SDK bindings, not runtime passes.

The frozen `jai-rs parse FILE` check accepts 37 of 38 files. `Sound_Player/os/win32.jai` retains the supplied `CreateSoundBuffer` callback-field default `outer: **void = null`, which the frozen parser rejects. A separate diagnostic copy elides only that unsupported default to check the remaining file syntax; this does not turn the original file into a parse pass. The PS5 load targets were absent from the supplied contract tree and remain missing.

Verification consists of textual inventory, preserved signatures, source hashes, SDK contract review, and parsing. Type checking, exhaustive ABI validation, GUI interaction, device playback, native builds, and behavior tests were not run. No reference source, shipped native artifact, plugin, or generated SDK program was executed, loaded, or linked. Optional `sofd` still needs an independent implementation. Vorbis requires `jai_stb_vorbis_adapter`, which remains an external contract: no native adapter implementation was authored or executed. A trusted upstream adapter build is a required runtime prerequisite recorded by the codec module.

## How to change it

Extend SDL2 declarations in their corresponding `SDL_*.jai` file and preserve the caller's major ABI. Check current official signatures before changing types or layouts. Keep manual SDK builds separate from normal module imports and point `--source` at independently reviewed upstream source.

Window helpers belong in the platform file selected by `OS`. Preserve defaults, result names, coordinate handedness, native calling conventions, and field order. X11 fullscreen success means the request was delivered; the compositor may apply it asynchronously. AppKit creation must run on the application thread.

Mixer changes require a review of frame/sample/byte units and queue ownership. Never free pending decoder pages or their compressed assets. Keep the AudioUnit callback allocation-free and nonblocking, and publish ring cursors only after writes or reads finish. Cached device results are borrowed module-owned snapshots and should be enumerated from the application's control thread.

Record source implementation, parsing, ABI validation, and behavior execution separately in coverage. Do not count a foreign declaration or a syntax pass as a device-behavior result.

## Configuration

`Window_Creation` preserves `DEFAULT_MSAA: s32 = 4` and background `[0.15, 0.15, 0.2]`. Windows MSAA remains a later rendering-context concern; Linux and macOS request it when choosing the visual/pixel format. `Sound_Player` keeps `MAX_SOUND_CATEGORIES = 64`, `VERBOSE = false`, existing sampling/buffer/channel constants, and `Sound_Player_Config`. Its async flag chooses thread or caller-driven filling, and `seconds_to_fill_ahead` controls the requested fill horizon. The focus-audibility field is honored by DirectSound's focus flag; cross-platform focus muting remains a gap.

Native link names are system names (`SDL2`, `X11`, `GL`, `c`, `asound`, `dsound`, Apple audio frameworks, and Android SDK libraries). No locator points into `reference/modules`. CMake and the platform C/C++ toolchain are needed only when a developer explicitly runs the optional manual SDK workflow. There are no new environment variables.

## Dependencies

Higher-level modules use the independent Jai `Basic`, `Math`, `Thread`, `File`, `Process`, `Compiler`, `Windows`, `Windows_Utf8`, `Windows_Resources`, `POSIX`, `Objective_C`, `Android`, `Wav_File`, `Adpcm`, and `stb_vorbis` modules. Their native prerequisites and target ABI checks remain separate.

SDK behavior was reviewed against the [ALSA PCM reference](https://www.alsa-project.org/alsa-doc/alsa-lib/pcm.html), [Windows window creation](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-createwindowexw), [DirectSound compatibility reference](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee416762(v=vs.85)), [AudioUnit render callback](https://developer.apple.com/documentation/audiotoolbox/aurendercallback), [CoreAudio device property](https://developer.apple.com/documentation/coreaudio/kaudiohardwarepropertydevices), [AAudio guide](https://developer.android.com/ndk/guides/audio/aaudio/aaudio), and [Android device enumeration](https://developer.android.com/reference/android/media/AudioManager#getDevices(int)). The trusted installed Apple SDK headers additionally supplied the CoreAudio property-address layout and query signatures.
