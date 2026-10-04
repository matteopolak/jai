# Native and platform bindings

## What it is

Declaration-only modules that let Jai code call operating-system APIs and C libraries through `#foreign`, `#system_library` and `#library`: the platform layers (`POSIX`, `macos`, `Windows`, `Linux`, `Android`, `Objective_C`, `Metal`, `X11`, `d3d11`, `d3d12`, `dxgi`, `d3d_compiler`, `dxc_compiler`, `Vulkan`, `GL`) and third-party libraries (`SDL`, `ImGui`, `Curl`, `stb_image`, `stb_image_write`, `stb_image_resize`, `stb_vorbis`, `freetype-2.12.1`, `freetype255`, `lz4`, `meshoptimizer`, `MojoShader`, `nvtt`, `pl_mpeg`, `rpmalloc`, `telemetry3`, `Thekla_Atlas`, `Thekla_Baker`, `nvidia_aftermath`). They contain types, constants and prototypes, and little logic.

## How it works

- Platform layers branch on `OS`: `POSIX/module.jai` pulls in `POSIX/bindings/{linux,macos,android}`, `errno.jai`, `file-mode-wait.jai` and `linux-stat.jai`; `macos/` has `core_foundation.jai`, `kernel.jai`, `mach.jai` and `kevent.jai`; `Objective_C/` holds Foundation, AppKit, CoreGraphics and GameController declarations (with `arm64`/`x64` ABI variants) and `bindings/{arm64,x64}/{message,runtime}.jai` for the Objective-C runtime and `objc_msgSend`; `Windows/` has `support.jai` and `resources.jai`; `Linux/` has `epoll.jai` and `io_uring*.jai`.
- Libraries are named with `#system_library "name"` (resolved by the OS loader) or `#library` (a path). `stb_image`, `stb_image_write`, `stb_image_resize` and `stb_vorbis` are not shipped by any OS, so they are built from pinned sources by `python3 tools/build_native_libs.py` into `artifacts/native-libs/<os>-<arch>/`, where `jaic` looks before the system search (details in `../tools/native-libs.md`). Other libraries (`SDL2`, `libcurl`, `freetype`, Vulkan) must be installed on the host.
- Some modules pick their foreign library per OS (`SDL/module.jai` selects SDL2 by `OS`; `Curl/{unix,windows}.jai`; `freetype-2.12.1/{unix,windows}.jai`). `Vulkan` has generated per-OS files plus a dispatch layer (`dispatch-native.jai`, `dispatch-registry.jai`) that loads entry points at run time. `GL` bundles a glad-style loader (`glad_core.jai`, `load-all.jai`) and per-OS context creation (`mac-context.jai`, `linux-context.jai`, `windows-context.jai`).
- Cross-checking another OS needs no SDK: `jaic check file.jai -os windows` selects the `#if OS == .WINDOWS` branches. Calling them requires running on that OS.
- Many binding files are produced with [bindings-generator](bindings-generator.md) from the C headers; the generated files are checked in.

## How to change it

- Add a function by declaring it with the exact C signature and calling convention; struct layouts must match the C ABI (the compiler classifies by-value structs, see the ABI notes in [bindings-generator](bindings-generator.md)).
- A new third-party library that no OS ships: add a source pin and a one-line translation unit to `tools/native-libs.json`, then rebuild with `build_native_libs.py`.
- Keep OS-specific declarations in their own file and select them with `#if OS == ...` in `module.jai`, so other targets still type-check.
- Regression programs that touch bindings: `tests/stdlib/c-variadic-foreign-calls.jai`, `cpp-method-and-array-decay.jai`, `buildcpp-api.jai`, `const-integer-pointer.jai`. Real library calls (SDL windows, GL contexts, Vulkan devices) are exercised only by the corpus projects, not by `tests/stdlib`.

## Configuration

`-os linux|windows|macos` on the `jaic` command line selects the OS branches. `Window_Creation`, `Simp`, `Input` and others take their own module parameters (see their pages). Library search: `artifacts/native-libs/<os>-<arch>/` first, then the system loader.

## Dependencies

System SDK headers/libraries at generation time only; at run time the named shared libraries must be present. The checked-in binding sources depend on `Basic`, `POSIX` and, for Apple frameworks, `Objective_C`.
