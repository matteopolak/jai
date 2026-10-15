# Audio desktop native integration

The audio-owned builder and verifier are self-contained within this worktree.
They do not invoke the shared-root native builder, edit a shared manifest, use
peer artifacts or publish anything. All compiler commands below refer to the
NEW source-built jaic. Android is excluded until the compiler has an Android OS
target; Linux checks are never Android evidence.

## Artifact layout and linkage

`Sound_Player` requests bare `jai_audio_output` through the normal native library
search path. Each target directory contains a static archive for native linking
and a shared library for interpreter calls, together with the existing pinned
opaque stb_vorbis archive/shared library and its verified license.
`audio-build.json` records target, SHA256s, SDK link dependencies and the compiler
invocation. Object headers are checked against the requested OS and CPU; passing
a host compiler as a cross compiler cannot create a mislabeled successful build.
Build records do not imply execution. A separate audio-runtime.json records the
exact-host SDK harness outcome, including real device availability and unsupported
manual pause. Physical focus/hotplug/sleep remain untested in that record.

Native executables embed the owned adapter and decoder. macOS links only public
system frameworks; Linux still requires the system ALSA runtime and its selected
PCM plugins; Windows links system WinMM/User32. These are external OS dependencies,
not embedded device services. Shared libraries are for interpreting Jai source,
not required beside an already linked native executable.

The relocatability verifier copies artifacts to a new install path, compiles
against that path, moves the install tree, removes its audio/decoder shared files,
clears loader override variables, inspects executable imports/rpaths, and runs
O0/O2 entity-phase and compressed-decoder tests from the moved tree. Windows
runtime PATH contains only the moved package and OS directories, so SDK/compiler
directories cannot mask missing package/runtime DLL dependencies. A successful
native device marker is required with `--require-device`. An unavailable device
is explicitly labeled and is never treated as playback evidence.

## Six release targets

| Target | Build host/SDK | Actual evidence in this worker |
| --- | --- | --- |
| macos-arm64 | Apple ARM64 host, public macOS SDK | Owned C/ObjC and opaque decoder built; real silent SDK harness and relocated O0/O2 Jai tests run |
| macos-x64 | Apple SDK with `-arch x86_64` | C/ObjC/decoder/harness and Jai O0/O2 cross-linked; translated Rosetta execution on ARM64, not physical x64 |
| windows-x64 | Windows SDK + clang/LLVM, or MinGW-w64 | C/decoder/harness and Jai O0/O2 cross-linked as PE x64; not executed |
| windows-arm64 | Windows ARM64 SDK + clang/LLVM | Owned/decoder/harness ARM64 objects compiled with common public MinGW headers; CRT/library link and runtime unavailable |
| linux-x64 | Linux x64 libc + ALSA development SDK | Build recipe and Jai source checks only; runtime delegated to normal coordinator CI |
| linux-arm64 | Linux ARM64 libc + ALSA development SDK | Build recipe and Jai source checks only; runtime delegated to normal coordinator CI |

All six have explicit source checks in `audio_verify_release.py --check-targets`.
They are not cross-link or native runtime evidence. Cross builds require an
explicit compiler/SDK; execution is allowed only for the exact host target.

On each matching desktop host, install public LLVM/Clang, Python, Rust and the
platform development SDK, build jaic/jailint/jaifmt from this repository, then run:

```sh
python3 tools/audio_build_native.py --test-runtime --require-device
python3 tools/audio_verify_release.py --require-device --check-targets
python3 tools/audio_verify.py --require-device --require-multichannel
```

The last verifier currently expects host artifacts in target/audio-native and
source-built tools in target/compiler/debug and target/jaifmt. For Linux headless
CI, install the ALSA development package and set `JAI_AUDIO_ALSA_DEVICE=null`.
ALSA's real null PCM opens, accepts samples and exercises device lifecycle without
speaker output. Windows CI without an audio endpoint should omit
`--require-device` and retain explicit unavailable markers; actual device evidence
requires a real/virtual OS endpoint. No fake output handle is supplied.

Additional cross build examples:

```sh
python3 tools/audio_build_native.py --platform macos-x64
python3 tools/audio_build_native.py --check-windows
python3 tools/audio_build_native.py --platform linux-arm64 --cc "aarch64-linux-gnu-gcc --sysroot=/path/to/public/sdk" --ar aarch64-linux-gnu-ar
python3 tools/audio_build_native.py --platform windows-arm64 --cc "clang --target=aarch64-pc-windows-msvc" --ar llvm-ar
python3 tools/audio_build_native.py --platform windows-x64 --cc "clang --target=x86_64-pc-windows-msvc" --ar llvm-ar
```

Windows MSVC-style commands run in a matching SDK developer environment with
INCLUDE/LIB and linker paths configured for that target. LLVM ar writes COFF
.lib archives. MinGW uses `--mingw` and GNU archives. A Linux cross sysroot must
include libc and ALSA headers/libraries for that CPU. The recipes fail on missing
SDKs, unexpected warnings in owned code, object-target mismatch or link errors;
the unexecuted recipes are not claimed as tested toolchains.

## Minimal shared integration plan

The coordinator can add the following library entry through its native builder's
local-source facility, without fetching another implementation:

```json
{
  "jai_audio_output": {
    "local": "stdlib/internal/audio/native",
    "local_units": ["output.c"],
    "platforms": ["macos", "linux", "windows"]
  }
}
```

This is a minimal proposed manifest fragment, not an applied shared edit. The
coordinator builder also needs a macOS-only Objective-C unit `focus.m`, static
and interpreter-shared outputs, and per-target system link dependencies from
`tools/audio_native_plan.json`. If its current local-source builder assumes an
external `source`, add general source-less local-unit support rather than
inventing a vendor dependency. Retain the existing pinned stb_vorbis recipe.
Install both libraries and the verified stb license in each normal
native-libs/<os>-<cpu> directory. No compiler module-name rule is needed.

Run this owned verifier against the final staged native directory on all six
normal CI hosts using `--artifacts PATH`; artifact output/build staging must stay
inside the worker checkout when this worker invokes the builder. Coordinator CI
may stage its own copy of the NEW source. Retain per-target metadata for actual
native execution, source checks and cross-builds separately.

## Focus and device recovery

macOS uses NSRunningApplication's active state only after identifying an owned
window using public CoreGraphics window metadata. Windows uses foreground process
identity when this process owns a visible top-level window. CLI/headless hosts
continue playing. These queries do not activate another app, record screens or
request window-focus changes. ALSA has no portable window-focus query; Linux
does not infer X11/Wayland focus from the audio API.

The producer polls lifecycle state at 250 ms intervals. Focus loss pauses the
native queue when the configuration disallows background audio; focus gain
resumes it. macOS checks default output identity and running queues; Linux handles
suspend/XRUN/disconnection state through ALSA's documented resume/prepare APIs.
WinMM provides system default-device stream routing on supported Windows; errors
still enter the owned retry path. Backend count/submission failures dispose the
lost device, report an error outside the player lock and retry opening every
250 ms. Stream cursors stop advancing during unavailable/paused producer updates.
Already queued audio is discarded on reopen and is not replayed. The logical
rate/channel format is retained; an incompatible new device can stay unavailable
until a compatible endpoint returns. Failed disposal is fatal rather than freeing
possibly live callback state.

Device enumeration queries the OS afresh on every call. Unchanged lists reuse
their snapshot; changed snapshots and interned device names remain valid for the
process lifetime so existing returned slices do not dangle. This trades memory
proportional to unique observed topology/name changes for safe borrowed results.

Physical hotplug, GUI focus transitions and OS sleep/wake are not automated in
this worker. The native harness proves real SDK pause/resume and controlled
close/reopen with silence, not physical events. Normal CI/manual follow-up should
disconnect/reconnect a virtual/physical endpoint, change the default output,
background/foreground a windowed app and suspend/resume the OS, checking that
errors are reported, retries are bounded and shutdown completes.

Official SDK inputs: [Apple running-application state](https://developer.apple.com/documentation/appkit/nsrunningapplication),
[Apple window metadata](https://developer.apple.com/documentation/coregraphics/cgwindowlistcopywindowinfo%28_%3A_%3A%29),
[AudioQueue running state](https://developer.apple.com/documentation/audiotoolbox/kaudioqueueproperty_isrunning),
[Windows foreground process](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getforegroundwindow),
[Windows high-level default-device routing](https://learn.microsoft.com/en-us/windows/win32/coreaudio/getting-the-default-device-endpoint-for-stream-routing),
[WinMM pause/restart](https://learn.microsoft.com/en-us/windows/win32/multimedia/stopping-pausing-and-restarting-playback)
and [ALSA PCM recovery](https://www.alsa-project.org/alsa-doc/alsa-lib/group___p_c_m.html).


## Cross-linked packages and translated evidence

The durable cross linker builds five NEW fixtures in O0/O2, verifies executable
OS/CPU headers, records hashes and stages a self-contained runtime package:

```sh
python3 tools/audio_cross_link.py --platform macos-x64 --artifacts target/audio-native/macos-x64
python3 tools/audio_cross_link.py --platform windows-x64 --artifacts target/audio-native/windows-x64-mingw
```

For macOS cross-CPU codegen, the compiler requires an explicit target triple;
the tool supplies x86_64-apple-macosx11.0. MinGW uses JAIC_CROSS_LIBS for target
archives, separating them from host JAIC_NATIVE_LIBS. Initial attempts with
cross -os macos/-cpu or host archive variables failed; these were invocation
errors, not production defects. No compiler special case or linker workaround
was introduced.

Each target/audio-cross-link/<platform> folder contains executables, fixture data,
license and run.py. Copy that NEW package to a matching normal CI host and run:

```sh
python3 run.py --require-device
```

Add --require-multichannel only when logical 6/8 formats are expected to be
available. The standalone runner needs Python and OS dependencies, no compiler or
stdlib source. It checks hashes/architecture and records runtime-result.json.
Native and translated execution remain separate; a mismatched CPU/OS is rejected.

On this ARM64 Mac, the installed Rosetta runner can additionally execute the x64
fixtures and logical 6/8 paths:

```sh
python3 tools/audio_run_translated.py --require-device --require-multichannel
```

Its translated-runtime.json explicitly disclaims physical x64 hardware. The
cross-link result stays link-only; the separate runtime record carries execution.
No translator is installed by these tools.

A separate object-only check uses Clang's real Windows ARM64 target and common
public MinGW-w64 headers. Example for the installed public SDK (adjust its path):

```sh
python3 tools/audio_compile_objects.py --platform windows-arm64 --cc "clang --target=aarch64-w64-windows-gnu -isystem /path/to/mingw-w64/include"
```

It compiles/validates owned adapter, SDK harness and opaque decoder object headers,
without claiming ARM64 CRT libraries, a linked DLL/executable or runtime. This
check exposed inconsistent DLL-export attributes between declarations/definitions;
the header now consistently marks producer exports and leaves static consumers
unmarked. Clang warnings remain denied; no suppression was added.
