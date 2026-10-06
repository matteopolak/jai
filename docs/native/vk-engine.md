# Vk-Engine (corpus project)

## What it is

[Vk-Engine](https://github.com/ostef/Vk-Engine), with its `Linalg` and `Jolt-Jai` submodules, is the largest game-engine project in the corpus. Its metaprogram (`Build.jai`) builds four modules (`Core`, `Renderer`, `Game`, `Editor`), regenerates the Vulkan, Dear ImGui and Jolt bindings, and leans heavily on compile-time code generation. It is the main stress test for workspaces, compiler messages, `#insert`/`#run` and `Bindings_Generator`.

## How it works

What works:

- `jaic check Build.jai -I Modules -I Source -os linux - <Module>` compiles each of the four modules when `Libs/Linux` holds the libraries; empty placeholder files are enough. The sweep cases `vk-engine-*-check` in `tools/upstream-cases.json` do exactly this in a scratch copy. Use a release `jaic`.
- `tools/build_vk_engine_libs.py` builds the native C++ libraries for macOS: `libImGui.dylib`, `libVkMemAlloc.a`, `libJoltC.dylib`.

What doesn't:

- A native macOS `jaic build` fails with `unknown identifier 'VkBuffer'`. The upstream modules have no macOS branch, and the corpus is read-only input, so this is out of scope:
  - `Modules/Vulkan/module.jai` loads bindings and libraries only for `.WINDOWS` and `.LINUX`, so no `Vk*` name exists on macOS and `Source/Core/Graphics/Vulkan` fails.
  - `Modules/ImGui/module.jai` has `#assert false "Unsupported OS"`; `Modules/JoltPhysics/module.jai` declares `JoltC` only for Windows and Linux.
  - The three `generate.jai` files `#assert false` for macOS in their library-building code, so bindings can't be regenerated natively either.
- Without placeholders, `Build.jai` runs the generators first, and the Vulkan one fails: `Modules/Vulkan/generate.jai` assigns an element of `Enum.enumerates` to a `*Declaration`. That is an older Bindings_Generator API; the current one stores `Enum.Enumerate` values, so the official compiler rejects the file too ("expected *Declaration, found Enumerate"). Not a jaic bug.

`Build.jai` looks for `Modules/<M>/Libs/<MacOS|Linux|Windows>/...` and runs the module's `generate.jai` when a library is missing. `build_vk_engine_libs.py` fills the macOS slots, for a future macOS port. `tools/fetch_upstreams.py` provides the sources: Vk-Engine's vendored ImGui and Vulkan/VMA headers, Linalg, Jolt-Jai, and its `JoltC` submodule (`ostef/JoltC`, pinned in `DEPENDENCIES` to the submodule commit and linked into `ostef--Jolt-Jai/Source/JoltC`). The build tool clones Jolt Physics v5.6.0 into `artifacts/thirdparty/JoltPhysics` and hands it to JoltC's CMake via `FETCHCONTENT_SOURCE_DIR_JOLTPHYSICS`.

Gotcha: running the checks with `-os linux` on a Mac without placeholders makes the generators use the host SDK (`generate.jai` falls back to `/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk`, since `run_command` is unavailable when targeting another OS). They overwrite `Modules/ImGui/imgui_linux.jai` and `Modules/Vulkan/vulkan_linux.jai` in the corpus; run `tools/fetch_upstreams.py` to restore them. The Jolt generator can't run in this mode (it starts `cmake`), and the closing `Could not copy file '.../Libs/Linux/libImGui.so'` lines are expected on a Mac.

### Compiler behaviour this project relies on

- Uncalled noted procedures are lowered for metaprograms only in the program's own files, not imported modules (`lower_reachable_inner`). `Common` ships an uncalled `@PrintLike FormatToCString` whose body calls a nonexistent `CSprint`.
- A polymorphic default that mentions earlier bindings (`$compare: (T, T) -> bool = (a, b) => a == b`) is evaluated in one scope per (definition scope, bindings) (`default_scopes` in `calls.rs`). A fresh scope per call would make the lambda a new procedure each time, and the callee's instantiation would never be found again.
- A failed body is retried only after something changed: code added, a file or module loaded, or a top-level `#run` finished (`lower_epoch` in `procs.rs`). Retrying every failed body before each compile-time call, with their `#insert`s and `#run`s, turned a few errors into hours of work. Failures waiting on a `#placeholder` are never memoised, since the metaprogram may define it at any time.

## How to change it

- New library or option: `tools/build_vk_engine_libs.py`. Its CMake options mirror `JoltCompileOptions.Default | CombinedSharedLibs` in `Jolt-Jai/generate.jai` and the defines in `Modules/JoltPhysics/module.jai` (`DOUBLE_PRECISION`, `OBJECT_LAYER_BITS`, ...). They must match: `CheckVersionID` compares them at run time. `JPH_USE_VK=OFF` and `ENABLE_ALL_WARNINGS=OFF` keep Jolt from needing `dxc` or failing on newer clang warnings.
- A macOS port of the engine modules would add `#if OS == .MACOS` branches to the three `module.jai` files, generate `*_macos.jai` bindings (`ImGui/generate.jai` already names `imgui_macos.jai`), and load `libvulkan` from `/opt/homebrew/lib` (MoltenVK; see [native libs](../tools/native-libs.md)).

Tests for the compiler behaviour above: `tests/stdlib/poly-default-lambda-instance.jai`, `compile-time-failing-bodies.jai`, `compiler-noted-module-procs.jai`.

## Configuration

```sh
python3 tools/build_vk_engine_libs.py [imgui] [vma] [joltc] [--release] [--force] [--jobs N]
```

Builds are debug by default, like upstream's. Outputs go to `corpus/upstream/ostef--Vk-Engine/Modules/ImGui/Libs/MacOS/libImGui.dylib`, `.../Modules/Vulkan/Libs/MacOS/libVkMemAlloc.a` and `corpus/upstream/ostef--Jolt-Jai/Libs/MacOS/libJoltC.dylib` (also reachable as `Modules/JoltPhysics/Libs/MacOS`). `JAI_LIBCLANG` selects libclang for the generators ([Bindings_Generator](../stdlib/bindings-generator.md)).

## Dependencies

`cmake`, optionally `ninja`, a C++20 compiler and git; network access for `fetch_upstreams.py` and the Jolt clone. Running the engine would also need MoltenVK and the Vulkan loader (`brew install molten-vk vulkan-loader`).
