# Fresh SDL2 source witness

## What it is

`tools/native_sdl_witness.py` rebuilds official SDL2 2.30.2 source and runs a bounded, authored C witness against the freshly emitted archive. It checks the selected SDK version, rectangle/event layouts, geometry, genuine error handling and an event code/pointer round trip on macOS arm64.

This proves a small native SDK contract. It does not prove Jai compilation of the complete SDL module, the application's shared-library configuration, a window, rendering or Vk-Engine execution.

## How it works

Vk-Engine's pinned `Modules/SDL/generate.jai:9` requests `src/SDL2-2.30.2` and explicitly retains handcrafted bindings. The `SDL_version.jai` constants say 2.0.1, despite declarations for APIs added later. The generator's concrete source request therefore selects this source rebuild; the stale constants are not used to authorize an older or installed replacement.

The recipe pins official [release-2.30.2 source](https://github.com/libsdl-org/SDL/tree/f461d91cd265d7b9a44b4d472b1df0c0ad2855a0), its archive SHA-256 and 1,231 text source hashes in `corpus/native-sdl-sources.json`. Preparation extracts only regular C/Objective-C/header/CMake/template files and license notices; it ignores archive links and native artifacts. Before building, the verifier rejects changed or unlisted source, escaping paths and symlinks.

The installed CMake/clang/make/archiver build a static host archive from unchanged official source. The configuration disables video, audio, rendering, joystick, HID, sensors, haptics, power, dynamic object loading, filesystem, CPU feature detection and assembly. Source-defined unavailable-feature behavior stays outside the witness. It does not replace the selected geometry/error/event functions with mocks. Git and pkg-config discovery are disabled; source revision evidence comes from the immutable manifest. The executable uses a scrubbed environment, including removal of the `SDL_DYNAMIC_API` override and loader/include injection variables.

The C witness checks the layouts mirrored by the pinned Jai declarations:

| Type | Size | Alignment | Checked offsets |
| --- | ---: | ---: | --- |
| `SDL_Rect` | 16 | 4 | `x=0`, `y=4`, `w=8`, `h=12` |
| `SDL_UserEvent` | 32 | 8 | `code=12`, `data1=16`, `data2=24` |
| `SDL_Event` | 56 | 8 | Union storage size/alignment |

It intersects two rectangles, computes their union, rejects a null rectangle through SDL's genuine error code/path, initializes only the event subsystem, registers one user event, pushes its code and pointer, reads it back, observes an empty queue and calls `SDL_Quit`. No window, display, GPU or audio device is initialized. Pointer equality is checked only within the authored process.

The completed 2026-10-02 witness emitted:

```text
SDL_version 2 30 2
SDL_Rect 16 4 0 4 8 12
SDL_UserEvent 32 8 12 16 24
SDL_Event 56 8
cpu_geometry_error_event_queue 1
```

The receipt at `artifacts/native-dependencies/sdl2-2.30.2-cpu-witness-3/receipt.json` verifies 1,231 official source files, 1,646 actual transitive source/header inputs, tool fingerprints, flags, unchanged CMake definition, witness source, archive and executable. The archive SHA-256 is `cf2e67e01187185aa35d2519c15411c22ec881f7c8dd5a4beb52bf7347cae89c`. Receipt verification never executes its saved executable or grants linking authority.

The application's macOS recipe instead builds shared arm64/x86_64 variants, combines a universal library and changes its ID to `@rpath/libSDL2.dylib`. This static CPU-only witness has different feature/linkage settings. Complete version-dependent records, generated Jai ABI validation, shared library lifetime/search policy and graphics behavior need their own contracts.

Slang inspection has a separate evidence boundary. `corpus/native-slang-headers.json` records immutable source-header hashes: sgpu's packaged `slang.h` matches official [v2025.22.1 source](https://github.com/shader-slang/slang/tree/01fdbb8a1a9b4a948731b580a6a5b618e8e116ff) exactly after CRLF normalization, and its version header states 2025.22.1. Native filename metadata advertises 2025.24.2 on macOS and 2025.24 on Linux. Those native artifacts were not fetched or loaded; their actual version and ABI remain unverified. A future Slang build must start from the matching source/interface contract and review its transitive source build, C++ vtables, `SessionDesc`/`TargetDesc` records and SPIR-V compilation path. The [official build instructions](https://github.com/shader-slang/slang/blob/master/docs/building.md) describe optional prebuilt LLVM/DXC paths; do not silently use them for a source-only acceptance claim.

## How to change it

Change source revisions only after reviewing immutable official source and regenerating the archive/file manifest. Keep the manifest digest, archive digest and source revision constants synchronized. The current source pin follows the upstream generator's explicit 2.30.2 request, rather than whatever a package manager currently provides.

Extend `WITNESS` and its exact expected output together. Each added API needs a source-backed signature/layout review and a bounded observable behavior. Enabling a device or GUI feature changes the accepted configuration; it requires separate target/runtime evidence and should not silently broaden this CPU witness.

Keep persisted receipts as evidence only. The compiler's private fresh-dependency authority is a separate mechanism; no SDL authority is created by this script or its JSON. The hermetic tests exercise exact output, incorrect version/layout, source drift, extra files, symlink escapes and disabled-feature configuration without executing an SDK.

## Configuration

Download the [immutable official source archive](https://codeload.github.com/libsdl-org/SDL/tar.gz/f461d91cd265d7b9a44b4d472b1df0c0ad2855a0) to an ignored artifact path, then prepare a fresh source directory and build:

```sh
python3 tools/native_sdl_witness.py \
  --prepare-source-archive artifacts/native-dependencies/source/sdl-2.30.2.tar.gz \
  --output "$PWD/artifacts/native-dependencies/source/sdl2-2.30.2"
python3 tools/native_sdl_witness.py \
  --output "$PWD/artifacts/native-dependencies/sdl2-2.30.2-cpu-review"
python3 tools/native_sdl_witness.py \
  --verify-receipt artifacts/native-dependencies/sdl2-2.30.2-cpu-review/receipt.json
python3 -m unittest discover -s tools -p test_native_sdl_witness.py
```

Preparation and builds require fresh managed directories and never replace existing artifacts. `--source` overrides the default prepared source path; it must still match the reviewed manifest. The current execution contract requires macOS arm64 and installed tools at `/opt/homebrew/bin/cmake`, `/usr/bin/clang`, `/usr/bin/clang++`, `/usr/bin/make` and `/usr/bin/ar`. Build work uses one job. `build.log` and `witness-build.log` retain diagnostics; the CPU witness has a ten-second timeout.

## Dependencies

Python standard library, shared typed fingerprints/protected-root checks in `tools/native_dependencies.py`, the exact reviewed official SDL source, installed CMake and native host tools, and the host Apple SDK. The narrow C witness links its freshly emitted SDL archive and standard Apple system libraries/frameworks; it never selects installed SDL2 compatibility libraries or supplied upstream binaries. No system-wide package installation, source upload, Jai metaprogram execution or application build is needed.
