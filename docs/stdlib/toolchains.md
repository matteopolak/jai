# Toolchains

## What it is

`stdlib/Toolchains` holds small helpers that metaprograms (build scripts and `Bindings_Generator` generators) use to find platform SDKs: `Toolchains/macOS.jai` for the macOS SDK and `Toolchains/Android` for the Android NDK. The reference modules' `generate.jai` scripts import them to pick include paths and target triples.

## How it works

- `#load "Toolchains/macOS.jai"` (or import it through a module) gives `get_macos_sdk_path() -> string, bool`. It returns `$MACOS_SDK_PATH` when set, otherwise the output of `xcrun --show-sdk-path`, and caches the result.
- `#import "Toolchains/Android"(SDK_LEVEL = 34)` gives:
  - `get_android_target_triple(cpu)` returns e.g. `"aarch64-linux-android"` and `"aarch64-linux-android34"`. Only `.X64` and `.ARM64` are valid.
  - `get_ndk_paths()` returns the NDK `root`, the prebuilt LLVM `toolchain` for the host and its `sysroot`. It asserts when no NDK is configured.
  - `get_ndk_libc_paths(cpu)` returns the shared C include directory and the per-triple one, ready for `Generate_Bindings_Options.system_include_paths`.
- `Compiler`'s build options default `minimum_os_version` for macOS targets to 11.0 on arm64 and 10.13 on x86-64 when it was left at zero. Metaprograms that build `-target` triples from it (for example the macOS generators) otherwise produce `macosx0.0`.

## How to change it

- New platforms get their own file or module under `stdlib/Toolchains/`, with no top-level side effects, because generators import them unconditionally.
- Keep the procedures lazy. Nothing should run (no `xcrun`, no NDK lookup) until a caller asks for it, since the modules are imported on every OS.

## Configuration

| Variable | Used by | Meaning |
| --- | --- | --- |
| `MACOS_SDK_PATH` | `get_macos_sdk_path` | Overrides the `xcrun` lookup |
| `NDK_HOME`, then `ANDROID_NDK_HOME` | `get_ndk_paths` | Root of an Android NDK |
| `SDK_LEVEL` module parameter (default 34) | `Toolchains/Android` | Android API level appended to the triple |
| `ENABLE_ARM_LSE` module parameter | `Toolchains/Android` | Accepted for API compatibility |

## Dependencies

`xcrun` (Xcode or the Command Line Tools) on macOS; an Android NDK for the Android helpers; stdlib `Basic`, `File`, `String`, `Process`, `POSIX`/`Windows`.
