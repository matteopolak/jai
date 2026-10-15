# SDL3 installed SDK packaging and relocation

Coordinator-reported ordinary native CI candidate `a6371ec` passes Linux x64/arm64 and macOS x64/arm64. Both Windows jobs fail the native build/smoke step with `FileNotFoundError` while copying `install/windows-<cpu>/lib/cmake/SDL3`. This is a genuine packaging defect. The reported exception is in the post-install packaging path; it does not establish a successfully completed Windows package or installed-SDK consumer check. No Windows install tree or standalone Windows execution logs were available in this macOS worktree. Windows layout tests below are explicitly simulated; corrected native execution belongs to the next coordinator CI run.

## Pinned install rules and the correction

The verified SDL 3.4.18 source's `CMakeLists.txt:4115–4164` sets `SDL_INSTALL_CMAKEDIR_ROOT_DEFAULT` to `cmake` for Windows without MinGW, and `${CMAKE_INSTALL_LIBDIR}/cmake/SDL3` otherwise. The actual configured root is a cache option, so even an OS-specific hardcoded replacement would not handle every valid install. The export targets refer to their installation prefix and to sibling headers/libraries; moving only the `.cmake` files to another directory also breaks those paths.

`installed_cmake_dir` now reads the real `install_manifest.txt` produced by `cmake --install`. It requires exactly one `SDL3Config.cmake` inside the installed prefix, then verifies the config/version, headers target, static/shared targets and both Release export files actually exist there. Missing, ambiguous or external exports are errors. The actual installed relative CMake path is printed and recorded in `sdl3/build.json`; it is not guessed from the OS.

`package_installed_sdk` copies the actual complete installed prefix to `<native>/sdl3/sdk`, preserving the original directory depth, metadata contents, headers, library filenames, runtime aliases, pkg-config files and installed licenses. Unix alias symlinks are materialized as byte-identical files so ordinary release ZIP extraction preserves their paths. Export files are not fabricated or rewritten. The previous incomplete `sdl3/cmake` and misplaced audit-only `.pc` copies are removed; official CMake/pkg-config consumer files now live at their correct locations inside the SDK prefix.

The compiler-facing artifacts at `<native>` retain their existing identities:

| Platform | Compiler-facing files | Official SDK identities |
|---|---|---|
| Windows | `SDL3.lib` static, `SDL3-import.lib` import, `SDL3.dll` runtime | `sdl3/sdk/lib/SDL3-static.lib` static, `sdl3/sdk/lib/SDL3.lib` import, `sdl3/sdk/bin/SDL3.dll` runtime |
| macOS/Linux | `libSDL3.a` plus runtime/SONAME names | The same archive/runtime names under `sdl3/sdk/lib` |

SDK file hashes are recorded individually in `build.json`. The runtime/package audit requires the exact SDK inventory, validates every file's SHA256, checks headers/config presence and compares each compiler-facing artifact with its official SDK counterpart. Existing root license/notices and all runtime/GPU symbol checks remain. Installed public headers still pass the pinned-header hash/inventory audit; no API or GPU declaration changes.

Retaining both official SDK filenames/layout and compiler-facing aliases requires duplicate physical library bytes in portable ZIP packages. Actual local macOS arm64 sizes were 14,120,346 bytes for the complete installed SDK and 10,532,256 bytes for compiler-facing archives/runtimes. This is an explicit size tradeoff for valid unmodified exported targets and existing compiler lookup names. Future archive deduplication may reduce it if it preserves both identities and ordinary extraction; dropping headers or rewriting incomplete export files is not an acceptable substitute.

## Real installed-target consumers

Every native build, including offline rebuild, now copies the packaged SDK to a separate durable `relocated SDK` directory and configures `tools/native/sdl3/consumer` against that prefix and its recorded actual config directory. `find_package(SDL3 3.4.18 EXACT CONFIG REQUIRED)` requires headers plus static/shared targets, with no default/system package search. Before compiling, CMake checks that every imported library/header path resolves inside the relocated SDK, static/shared target types are correct, and Windows static/import/runtime paths are distinct. Any absolute staging-tree reference fails.

Four real programs are compiled and run with CTest: C/static, C/shared, C++/static and C++/shared. They include actual installed SDL3 headers, check target CPU/pointer width, compare header/runtime version 3004018, call the packaged overflow wrapper on success/overflow and initialize/quit headless SDL events. C++ declarations retain the wrapper's C linkage. Each shared Windows consumer receives the actual imported DLL beside its own executable; output directories are separate to avoid concurrent DLL copy races. Unix consumers use CMake's imported-library build runtime paths. No manually installed SDL or device/display is needed.

The consumer build requires CMake 3.24 or newer (including the framework-link expressions in macOS exports) and propagates discovered native VS/host/target selection, static CRT choice, or explicit macOS CPU/deployment flags. VS 2026 discovery still requires CMake 4.2 or newer. Native CTest runs only when target equals host; compilation is recorded separately for an explicitly requested macOS cross build. Ordinary release/native CI uses native matching runners on all six targets. `build.json` records successful consumer compilation and whether native execution actually occurred, only after the checks pass.

For a native C/C++ application, use:

```sh
cmake -S your-app -B build -DCMAKE_PREFIX_PATH=/absolute/native/sdl3/sdk
cmake --build build --config Release
```

Link `SDL3::SDL3-static` or `SDL3::SDL3-shared`. Headers and transitive platform dependencies come from the official exported targets. The Jai module continues using `<native>` via `JAIC_NATIVE_LIBS`; it does not change to SDK filenames. The SDK also retains official `lib/pkgconfig/sdl3.pc` where SDL installed it.

## Actual verification

Durable logs are under `artifacts/sdl3/ci-a6371ec/`:

- `python3 -m unittest discover -s tools -p 'test_sdl3*.py'`: 38 pass (`unit-final.log`). New fixtures test Windows `cmake`, Unix `lib/cmake/SDL3`, custom export directories, missing/ambiguous/external configs, and relocation with byte/role preservation. Fixture files are marked as layout/copy data, never native libraries or functional CMake packages. Existing LF/autocrlf, exact generated bytes, all canonical hashes and 95-GPU-API checks remain.
- `python3 tools/sdl3_native.py --offline --jobs 2`: passes locally on macOS arm64 (`native-host.log`), including original producer static/shared SDK-layout smoke and four actual installed-target consumers.
- `python3 tools/build_native_libs.py SDL3 --platform macos-arm64`: integrated builder passes (`pipeline-host.log`), logs actual `lib/cmake/SDL3` discovery, and all four relocated C/C++ executables pass after final separate-output changes.
- `python3 tools/test_sdl3.py --jaic ../compiler/target/debug/jaic --stdlib artifacts/sdl3/test-stdlib --native artifacts/native-libs/macos-arm64`: passes (`audit-and-jai.log`): 87 actual installed SDK files, all metadata/header/artifact identities and hashes, 1,329 runtime exports including 95 GPU symbols, licenses/notices, and all four linked Jai fixtures using authorized new staged dependencies.
- All-six-target byte-exact generator check and modified Python compilation pass. No generated Jai, contract ledger, enum/layout, callback or core/GPU export changes in this repair.

Corrected Windows SDK packaging and these new C/C++ consumers remain native CI pending. The four Linux/macOS passing jobs reported by the coordinator concern the preceding candidate, not execution of these new consumer checks. No GPU hardware, device or oldest-OS test is claimed. No workflow dispatch, issue comment, tag, publishing or release action was performed. Coordinator should integrate this own-branch checkpoint and rerun ordinary six-runner SDL3 native CI; release/publication remains held.
