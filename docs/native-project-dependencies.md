# Native project dependencies

## What it is

`corpus/native-dependencies.json` records native library declarations from the seven pinned upstream projects, including revision, source SHA-256, directive options and line number. `tools/native_dependencies.py` verifies that evidence, inventories conventional host SDK paths without loading libraries, and builds one pinned official VMA source dependency with installed tools.

Dependency readiness is separate from language support. A successful parser, semantic check, handwritten FFI contract or source dependency rebuild does not establish that an upstream application links or runs.

## How it works

The declaration scanner masks strings and nested comments before identifying `#library` and `#system_library`. It verifies every pinned Jai source before scanning and records 120 declarations: Focus 35, The Way to Jai 21, Jails 1, jaison 0, OpenJai 24, Vk-Engine 21 and sgpu 18. These are declarations across all source files and target branches, not the libraries required by one resolved entrypoint. Runtime `dlopen` names and dependencies imported through standard modules need additional review.

| Project | Source-backed native/platform requirements | Acceptance boundary |
| --- | --- | --- |
| Focus | macOS Objective-C/AppKit/Foundation/Carbon/QuartzCore and libc/pthreads; Windows user32/kernel32/shell32/ole32/Dwmapi; Linux X11/XCB/Wayland/xkbcommon/fontconfig/OpenGL. Optional Tracy and a local LightweightRenderingView helper occur in modules. | Select the actual imported module graph and optional features first. Platform headers, callbacks, GUI/event lifetime and helper source rebuilds remain distinct gates. |
| The Way to Jai | Individual examples use libc/Win32, GLFW, raylib, C++ libraries and authored C/dynamic libraries. | This is a collection of examples, not one application dependency set. C/C++ implementation source is outside the current Jai-only corpus fetch; inspect and rebuild it before linking any example's local artifact. |
| Jails | `server/main.jai:622` selects Windows kernel32 for its watchdog; File/Process/Thread and compiler workspaces add OS effects through imports. | Native process/thread behavior and metaprogram scheduling are independent of resolving kernel32. No full language-server acceptance yet. |
| jaison | No direct native library declaration in the six pinned Jai files. | Imported Basic/reflection/module behavior still needs genuine source implementations. Zero direct declarations does not mean the complete module graph has no native effects. |
| OpenJai | libc in its build script, plus C/C++/raylib/dynamic-library example and foreign compile-time tests. | Alternate compiler implementation files are corpus input only. Do not execute its build script or compiler to establish this rewrite's acceptance. Example dependencies require independent source builds. |
| Vk-Engine | Vulkan loader/VMA, SDL2, ImGui, Windows C++ runtime or Linux libstdc++.so.6/libunwind. | Vulkan and ImGui modules select Windows/Linux only; the SDL module's macOS branch does not establish engine macOS support. ImGui bindings name mangled C++ exports (`imgui_linux.jai:484`), so a generic C wrapper is insufficient. |
| sgpu | Vulkan/VMA/C++ runtime plus optional Slang; Windows, Linux and macOS source branches. | `modules/Vulkan_With_VMA/module.jai:91-139` selects platform paths and linkage modes. Local paths require reviewed source rebuilds, matching symbols/layout/version and target libraries before any project link. |

sgpu's Windows branch selects local Vulkan and VMA libraries plus `libcpmt`; Linux selects local VMA, system Vulkan and both C++ runtime names; macOS selects local VMA/Vulkan plus `c++` and `c++abi`. Debug VMA and local Vulkan parameters alter the chosen artifact. Slang's platform library names are selected in `modules/slang/module.jai:35-41`; `SLANG_COMPILER` defaults to true in the root module. Preserve these choices as semantic metadata, then independently resolve approved native dependencies; never search supplied object/library directories.

Focus's asynchronous file implementation selects IO completion ports, io_uring or its pthread pool at `modules/File_Async/module.jai:126-134`. The macOS pool calls `pthread_create` at `thread_pool.jai:105`; Linux imports Linux/POSIX and calls `io_uring_setup`, rather than declaring a separate liburing dependency. Completion ordering, partial reads, cancellation, synchronization, error propagation and teardown need target behavior tests. [Windows IOCP documentation](https://learn.microsoft.com/en-us/windows/win32/fileio/i-o-completion-ports) and the [Linux io_uring manual](https://man7.org/linux/man-pages/man7/io_uring.7.html) describe different platform interfaces. The narrow [OS library acceptance](os-library-acceptance.md) exercises file/process/pthread operations; it does not validate Focus's queue lifecycle.

The read-only 2026-10-02 host inventory found macOS 27 SDK framework directories, Vulkan headers/loader 1.4.357.0, SDL2 compatibility headers/library 2.32.70 and SDL3 headers. Conventional GLFW, Slang, VMA and MoltenVK ICD paths were absent. This only reports searched paths; it verifies no installed native library ABI, loadability, driver or GPU capability. The [Vulkan loader](https://github.com/KhronosGroup/Vulkan-Loader/blob/main/BUILD.md) has its own source/header dependency requirements; on macOS, [Vulkan's development guide](https://docs.vulkan.org/tutorial/latest/02_Development_environment.html) describes MoltenVK's translation through Metal. A loader file alone does not complete that stack.

The VMA recipe pins official v3.3.0 commit `1d8f600fd424278486eade7ed3e877c99f0846b1` and the header SHA-256 in the manifest. It generates a two-line `VMA_IMPLEMENTATION` wrapper, invokes installed `clang++` and `llvm-ar` with explicit paths, and writes a new archive under ignored artifacts. [VMA's setup guide](https://gpuopen-librariesandsdks.github.io/VulkanMemoryAllocator/html/quick_start.html) requires compiling the implementation as C++, with Vulkan headers available. The recipe fixes Vulkan 1.3 and both static/dynamic function-import macros; it does not claim these settings match every corpus consumer.

The successful arm64 macOS build produced `artifacts/native-dependencies/vma-3.3.0-arm64-logged/libVkMemAlloc.a`. Its receipt fingerprints compiler, archiver, 717 included headers, wrapper, flags, target and archive. That archive remains build evidence and is not linked by the driver. Receipts always have `link_authority: false`.

The [reviewed native linking](reviewed-native-linking.md) path replays the source build, runs an independent C++ ABI/runtime oracle, validates resolved Jai signatures/target layouts, and snapshots the new archive for one linker invocation. Its six-symbol VMA virtual-allocation contract needs no Vulkan loader or GPU. GPU VMA APIs and full corpus project execution remain unverified.

Vk-Engine's SDL rebuild source requests `SDL2-2.30.2` in `Modules/SDL/generate.jai:9`, while its deliberately retained handcrafted `SDL_version.jai` constants still say 2.0.1. Treat the selected function/record ABI as the contract rather than inferring compatibility from those stale constants. Its macOS recipe builds shared arm64/x86_64 variants with deployment targets 11.0/10.13, combines them with `lipo`, and sets `@rpath/libSDL2.dylib`; a fresh static host-only archive would not reproduce that linkage/lifetime contract. The installed SDL2 compatibility 2.32.70 library was inventoried only, never used as a source-built replacement.

The [fresh SDL2 CPU witness](native-sdl-witness.md) now rebuilds exact official 2.30.2 source with a disabled-device static configuration, and executes authored version/layout/geometry/error/event-queue checks. It verifies the selected `SDL_Rect`, `SDL_UserEvent` and `SDL_Event` C layouts and event pointer/code round trip. Its source/tool/transitive/header/archive/executable receipt remains `link_authority: false`; it proves neither complete Jai SDL binding acceptance nor the application's shared/universal/graphics configuration. The same inspection pins sgpu's Slang source header to official 2025.22.1 after CRLF normalization and records conflicting 2025.24.x packaged native filenames; no Slang library has been loaded or accepted.

The pinned bindings have different generated versions: sgpu's macOS/Linux files declare `VK_HEADER_VERSION = 335` and `VMA_VULKAN_VERSION = 1004000`; its Windows file and Vk-Engine's Windows/Linux files declare 250 and 1003000. The installed 357 headers and this independently authored virtual-allocation fixture do not establish compatibility with those full generated bindings. Compare selected source signatures, layout and conditional symbols against the exact rebuilt SDK before extending link authority.

The [SDK source witnesses](native-sdk-proofs.md) now rebuild ImGui 1.90.4 docking and Focus's exact LightweightRenderingView implementation. ImGui's selected C++ symbols/types, CPU drawing and bounded layouts passed; a self-written Jai fixture returned 42 at O0/O2 against the fresh archive. Focus's class/property/NSRect oracle passed without initializing a window or graphics context. Neither receipt grants driver linking authority or full project acceptance. GLFW, Slang, raylib and Tracy still need selected source recipes and ABI/runtime contracts. Use official [SDL2 installation/build instructions](https://wiki.libsdl.org/SDL2/Installation), [GLFW build instructions](https://www.glfw.org/docs/latest/compile.html), [Dear ImGui sources and backends](https://github.com/ocornut/imgui/blob/master/docs/BACKENDS.md), [raylib sources](https://github.com/raysan5/raylib), [Tracy sources](https://github.com/wolfpld/tracy), and [Slang's source build documentation](https://github.com/shader-slang/slang/blob/master/docs/building.md). Pin and inspect each implementation, build configuration and transitive source dependency before creating a recipe. Slang's documented default LLVM support may fetch a prebuilt library; use an inspected source-only configuration such as `SLANG_SLANG_LLVM_FLAVOR=DISABLE` where appropriate, and inspect DXC/submodule handling as well. A current upstream release is not automatically ABI compatible with the pinned Jai bindings.

## How to change it

Update `RebuildRecipe` and reviewed SHA-256 only after inspecting an immutable official source revision. Adding a recipe requires explicit compiler flags, target support, transitive input fingerprints and an independently reviewed native binding contract. Do not turn a caller-supplied JSON receipt into an automatic linker allowlist.

Regenerate the `projects` evidence field deliberately from `corpus_evidence()` after a reviewed corpus pin update, preserving the manifest's metadata. `verify-manifest` rejects source drift and declaration/option/line changes. Keep scanner output separate from a resolved target dependency set; conditional branches and runtime loaders cannot be inferred correctly from spelling alone.

The provenance tests use inert, self-written fixture bytes and mocked source recipes. They verify source drift, escaping symlinks, protected roots, target mismatches, tool/header/archive changes, unreviewed source rejection before subprocess execution and environment scrubbing. No original or fixture native library executes in these tests.

## Configuration

```sh
python3 tools/native_dependencies.py verify-manifest
python3 tools/native_dependencies.py inventory --report artifacts/native-sdk-inventory.json
python3 tools/native_dependencies.py inventory --sdk vulkan=/absolute/vulkan-sdk --sdk sdl2=/absolute/sdl2-prefix --report artifacts/configured-native-sdk-inventory.json
python3 -m unittest discover -s tools -p test_native_dependencies.py
```

For the inspected source-only VMA recipe, download **only** the pinned header from its [immutable official source URL](https://raw.githubusercontent.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator/1d8f600fd424278486eade7ed3e877c99f0846b1/include/vk_mem_alloc.h) into `artifacts/native-dependencies/source/vma/vk_mem_alloc.h`, then run:

```sh
python3 tools/native_dependencies.py build-vma \
  --header "$PWD/artifacts/native-dependencies/source/vma/vk_mem_alloc.h" \
  --includes /opt/homebrew/include \
  --compiler /usr/bin/clang++ \
  --archiver /opt/homebrew/opt/llvm/bin/llvm-ar \
  --target arm64-apple-darwin \
  --output "$PWD/artifacts/native-dependencies/vma-review-build"
python3 tools/native_dependencies.py verify-receipt \
  artifacts/native-dependencies/vma-review-build/receipt.json \
  --target arm64-apple-darwin
```

Output directories must be fresh and remain beneath `artifacts/native-dependencies`; existing directories are never replaced. Compiler/archiver must resolve into conventional installed tool roots. This bounded recipe supports explicit macOS/Linux triples; supplying a triple does not install a cross SDK. `reference`, `vendor` and `corpus/upstream` are protected, including symlink aliases. Inherited compiler include/search paths, SDK overrides and loader injection variables are removed. Build commands use argument lists, never a shell; the script runs no downloaded build scripts or installers.

SDK inventory accepts `vulkan`, `sdl2`, `sdl3`, `glfw`, `slang` and `macos-sdk` as repeatable `--sdk name=absolute-root` overrides. It reads ICD configuration from conventional `share/vulkan/icd.d` and `etc/vulkan/icd.d` paths without opening libraries or querying a GPU. Configured paths do not authorize linking. Vk-Engine's Vulkan/ImGui branches require Windows/Linux; sgpu's default Slang mode still requires a reviewed source build and binding contract.

## Dependencies

Python standard library, `tools/check_corpus.py` for the repository root, and corpus masking/decoding helpers in `tools/inventory_corpus_features.py`. Inventory and receipt verification require no compiler, library load or network. VMA rebuilding requires the exact reviewed official header, Vulkan and C++ SDK headers, an installed C++ compiler and an installed archiver; it records the actual headers rather than treating their directory names as provenance.
