# SDL2 runtime-oracle Unix header preparation — 940fc8cf

Root reports Linux ARM job 117173008021 and Linux x64 job 117173008054 fail with missing `SDL_config_unix.h` during native binding preparation. This is a genuine incomplete SDK input, not an obsolete fixture expectation. The canonical SDL layout/RWops/SysWM assertions remain unchanged. It is separate from comprehensive Extension SDL3 and its 95 GPU APIs.

## Verified input and include chain

Current accepted source was read only from the authorized `stdlib-shared` producer. The captured builder bytes remain identical at producer object `7e549d17811a4be3d28ed65c61efa017c6c0c069`. No history, quarantined sources, reference bodies or raw CI logs were accessed.

`tools/native_bindings/dependencies.json` pins two different oracles:

- `sdl_abi_probe`: official SDL **2.0.1**, archive SHA256 `0ae7e902a26777614a011fe7053ca7e8b14843db3c42ca117564d208cf6732f0`, source `SDL2-2.0.1/include`. Its layout measurements are untouched.
- `sdl_runtime_abi_probe`: official **sdl2-compat 2.32.70**, [exact archive](https://codeload.github.com/libsdl-org/sdl2-compat/tar.gz/refs/tags/release-2.32.70), SHA256 `e4a8bd5a7052418b8f9cb031e31927389051c22b81d9069806d70b047d856d12`. Downloaded bytes were validated before reading public C headers/CMake files. Upstream `project(sdl2_compat VERSION 2.32.70 LANGUAGES C)` confirms the version.

The source-derived runtime chain is `sdl_runtime_abi_probe.c` → `SDL.h:31` → `SDL_main.h:25` → `SDL_stdinc.h:33` → `SDL_config.h:51` → `SDL_config_unix.h` on Unix (also `SDL.h:32` directly includes `SDL_stdinc.h`). The archive contains `SDL_config_unix.h.cmake`, not the generated `.h`. Its CMake file calls `configure_file(include/SDL2/SDL_config_unix.h.cmake include/SDL2/SDL_config_unix.h)` and exports the generated build include root before the source root. The current probe builder supplies only `.work/vendor/sdl2-compat-release-2.32.70/include/SDL2`; it never configures that header. This independently explains the Linux-only missing file. macOS selects the supplied `SDL_config_macosx.h` earlier in the platform chain.

Exact CI compiler command/include trace, installed runtime package version and package-config roots were requested from root and remain pending. They have not been inferred from the historical Homebrew receipt in `docs/native/sdl-sdk-inputs.json`. This source repair does not use installed system headers, so it cannot silently mix a distro SDL2 config with pinned compat declarations. Actual runtime/header agreement still requires native replay.

## Narrow repair

Only `build_dependencies.py::main` changes in the accepted builder: when the runtime probe is selected, prepare its generated headers once and supply generated-first/source-second include roots. The new `sdl_sdk_headers.py::prepare_runtime_headers` runs **CMake script mode** against the verified upstream template. It retains upstream's `SDL2COMPAT_X11=ON` default, hence `SDL2COMPAT_DISABLE_X11=OFF`. The sole directive becomes CMake's `/* #undef ... */`; every other byte and notice in the upstream template is retained. X11, Wayland, OpenGL and all other upstream definitions remain intact. No constants/structures, minimal SDK config, SDL3 header substitutions, driver disabling or compiler/runtime changes are introduced.

This is deliberately header-only configuration for C ABI probes, not a build/install of the compat runtime. Full upstream project configuration requires unrelated SDL3 implementation headers; the probe itself consumes only SDL2 public headers. The helper validates the sole template substitution and enabled upstream X11 default before invoking `configure_file`; a new unknown substitution/default causes an explicit review error. Missing templates, missing CMake output and CMake failure are fatal; stale generated output is removed before CMake. All normal native measurements/assertions continue to run in the existing probes. CMake is a required preparation tool, with no substitute generator/fallback.

Integration owns adoption, `verify.py`, workflow and dependency provisioning. No shared tree was written. No Jai or native C body changed, so no new Jai formatting/lint execution is claimed for this patch. Prior fixture-path, WGL lint and upstream provider exports are unchanged.

## Evidence and reproduction

Actual here: six Python tests on `/usr/bin/python3` 3.9, including real CMake script-mode generation, byte-exact comparison with the pinned template, repeat generation, generated-first include inventory, runtime-selection gating, unknown-input rejection, failed-CMake/stale-output handling, and missing-output/template errors. Before the change the preparation regression fails with `0 != 1: runtime probe must configure the pinned SDK headers`. No native compiler, SDK probe, GUI/fault program or benchmark was executed. Linux/native CI and runtime/header agreement remain pending; even a Mac compile would not prove Linux execution.

All temporary files and the two verified official C source archives are in the assigned T7 namespace `.../sdl3/target/sdl-sdk-940`. Test source staging needs only the verified archive's real `CMakeLists.txt` and `include/SDL2/SDL_config_unix.h.cmake`. The helper receives the full verified extracted source in production. Run tests against the patched builder (do not run its main):

```sh
TMPDIR="$T7/sdl-sdk-940/tmp" PYTHONDONTWRITEBYTECODE=1 \
SDL_SDK_TEST_BUILDER="$T7/sdl-sdk-940/verified/tools/native_bindings/build_dependencies.py" \
SDL_SDK_TEST_HELPER="$T7/sdl-sdk-940/verified/tools/native_bindings/sdl_sdk_headers.py" \
SDL_SDK_TEST_SOURCE="$T7/sdl-sdk-940/official" \
/usr/bin/python3 -m unittest discover -s "$T7/sdl-sdk-940/verified/tools" -p test_sdl_sdk_headers.py -v
```

`T7` above is `/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/sdl3/target`, never an internal fallback. After root grants an SDK slot, or in normal Linux CI with existing SDK dependencies, compile both real probes using the current accepted builder with `--library sdl_abi_probe --library sdl_runtime_abi_probe --output <owned-output>`. Then run the canonical layout/RWops/SysWM gates through integration's verifier/runtime runner. Do not substitute the six configuration tests for these ABI/runtime gates.

The exact new three-source-file patch is [sdl-sdk-config-940.patch](../../patches/sdl-sdk-config-940.patch). [Machine-readable receipt](sdl-sdk-config-940-receipt.json) includes patch/base/output hashes and unchanged fixture/oracle/manifest hashes. It does not transport an old whole-file builder or modify integration's index. Release hold remains; no workflow dispatch, release/tag/publication or issue comment.
