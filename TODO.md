# TODO

Work we know about but haven't done yet. Remove an item when it lands (or move it to an issue).

## Releases and distribution

- **Sign and notarize macOS binaries.** Developer ID Application certificate + hardened runtime + `notarytool` in `release.yml`. `jaic` probably needs `com.apple.security.cs.disable-library-validation` (it loads user dylibs in `jaic run`/`#run`) and `allow-unsigned-executable-memory` or `allow-jit` (libffi closures); verify with the native-library and WebGPU tests. Only browser-downloaded archives are affected today (Homebrew, `install.sh` and the VS Code download aren't quarantined).
- **Sign Windows binaries** (e.g. Azure Trusted Signing). Unsigned, new-every-release exes fail winget's Defender reputation check (`Validation-Defender-Error`); a local Defender scan of 0.4.0/0.4.1 finds nothing.
- **winget:** get the first package accepted ([microsoft/winget-pkgs#448536](https://github.com/microsoft/winget-pkgs/pull/448536) for 0.4.2, waiver requested). Until signing exists, each release's PR may need a waiver or Defender submission.
- **Open VSX:** deprecation of `matteopolak.jai` in favour of `matteopolak.jai-toolchain` is pending review ([EclipseFdn/publish-extensions#1188](https://github.com/EclipseFdn/publish-extensions/pull/1188)).

## Language and compiler

From the conformance run (details in the uncommitted `conformance-local/NOTES.md`):

- `type_of` of a polymorphic struct template should be `Type`, and printing an uninstantiated polymorphic struct should print its name (jaic has no type for the template).
- `type_of` of a polymorphic procedure loses its parameters and returns (`poly_proc_type`).
- Warning for "not all control paths return a value".
- Error for clashing names brought in by two `using` members; error for identical overloads.
- Possible version drift, left alone on purpose until confirmed against a current beta: `Formatter` printing as a struct, one-character strings as `u8` (`x += "s"`, `ifx 1 else "a"`), slice `==`, constant float division by zero, and leniencies such as `u32 & ~0x7`.

Other:

- Native builds don't null-check plain loads (`v := p.*` segfaults at `-O0`, is undefined at `-O2`); only the interpreter and `print` report it.
- `Code_Node` kinds jaic doesn't model (`#asm`, `#bake`, `#bytes`, `#this`, `#load`, `#place`, …) arrive as `.PLACEHOLDER` in metaprograms.
- Messages jaic doesn't send: `FAILED_IMPORT`, `ERROR`, `PERFORMANCE_REPORT`, `DEBUG_DUMP` ([build options](docs/metaprogramming/build-options.md)).

## WebAssembly and the browser

- WASI threads are cooperative: a busy wait that never blocks keeps the turn (`threads-switch-while-locked` stays skipped for wasm-native).
- WASM builds are wasm64 only, with no processes or sockets, and only the common part of libm.
- WebGPU in the playground needs Chromium (WebGPU in workers plus JSPI); Firefox and Safari get the "no WebGPU" state.

## WebGPU

- The X11 and HWND surfaces are tested in CI under Xvfb/WARP only, not on real desktops.
- `wgpuDevicePushErrorScope(.Internal)` aborts inside wgpu-native; avoid it until upstream fixes it.

## Editor

- Toggling a comment inside an embedded-language here-string (`#string SQL`, …) may do nothing until VS Code has loaded that language once.
- GLSL and Metal here-strings need a third-party grammar extension; consider bundling small grammars like the WGSL one.

## CI

- Flaky: `window-input-native-events` (custom cursor) in the macOS interpreter run; `c_thread_callbacks_block_on_jai_threads` on Windows arm64.
- `macos-15-intel` runners are slow and often queued; merges don't wait for them.
