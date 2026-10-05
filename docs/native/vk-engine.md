# Vk-Engine (corpus project)

## What it is

[Vk-Engine](https://github.com/ostef/Vk-Engine) (with its `Linalg` and `Jolt-Jai` submodules) is the largest Jai game-engine project in the corpus: a metaprogram (`Build.jai`) that builds four modules (`Core`, `Renderer`, `Game`, `Editor`), regenerates the Vulkan / Dear ImGui / Jolt bindings, and uses compile-time code generation heavily. It is the main stress test for workspaces, compiler messages, `#insert`/`#run` and the Bindings_Generator.

## How it works

Status on macOS arm64 (2026-10-04):

| Step | State |
| --- | --- |
| `jaic check Build.jai -I Modules -I Source -os linux - Core\|Renderer\|Game\|Editor` | all four modules compile (about 3 s for Core, release build); the ImGui and Vulkan generators run against the real headers |
| `jaic build Build.jai -I Modules -I Source - Core` (native macOS) | fails in about 3 s: `unknown identifier 'VkBuffer'` |
| Native C++ libraries | `tools/build_vk_engine_libs.py` builds `libImGui.dylib`, `libVkMemAlloc.a` and `libJoltC.dylib` |

Why native macOS stops: the upstream modules have no macOS branch, so they would have to be edited (out of scope, the corpus is read-only input):

- `Modules/Vulkan/module.jai` loads bindings and libraries only for `.WINDOWS` and `.LINUX`, so no `Vk*` name exists on macOS, and `Source/Core/Graphics/Vulkan` (part of `Core`) fails.
- `Modules/ImGui/module.jai` has `#assert false "Unsupported OS"`; `Modules/JoltPhysics/module.jai` declares `JoltC` only for Windows and Linux.
- The three `generate.jai` files `#assert false` for macOS in their library-building functions (`ImGui/generate.jai`, `Vulkan/generate.jai`, `Jolt-Jai/generate.jai`), so `Build.jai` cannot regenerate bindings natively either.

`Build.jai` looks for `Modules/<M>/Libs/<MacOS|Linux|Windows>/...` and runs the module's `generate.jai` with `build` when a library is missing. `tools/build_vk_engine_libs.py` fills the macOS slots (so a future macOS port of the modules finds them), and `tools/fetch_upstreams.py` provides the sources: Vk-Engine's vendored ImGui and Vulkan/VMA headers, Linalg, Jolt-Jai and its `JoltC` submodule (`ostef/JoltC`, a `DEPENDENCIES` entry pinned to the submodule commit, linked into `ostef--Jolt-Jai/Source/JoltC`). Jolt Physics v5.6.0 is cloned by the build tool into `artifacts/thirdparty/JoltPhysics` and handed to JoltC's CMake with `FETCHCONTENT_SOURCE_DIR_JOLTPHYSICS`.

Running the checks with `-os linux` on a Mac: the bindings generators use the host's SDK (`generate.jai` falls back to `/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk` because `run_command` is unavailable when the target is another OS). They overwrite `Modules/ImGui/imgui_linux.jai` and `Modules/Vulkan/vulkan_linux.jai` in the corpus with freshly generated bindings; rerun `python3 tools/fetch_upstreams.py` to restore the pinned originals. The Jolt generator cannot run in this mode (it starts `cmake`), and the final `Could not copy file '.../Libs/Linux/libImGui.so'` lines are expected: no Linux libraries exist on a Mac.

Compiler issues this project exposed:

- A polymorphic parameter default that mentions earlier bindings (`$compare: (T, T) -> bool = (a, b) => a == b`) was evaluated in a new scope on every call, so its lambda was a new procedure, and the instantiation of the callee was never found again. Defaults now use one scope per (definition scope, bindings) (`default_scopes`, `calls.rs`).
- `drain_bodies_lenient` (run before every compile-time call) retried every body that had failed, including their `#insert`/`#run`, so a few bodies with an error compounded into hours of work (a missing module on macOS). A failed body is now retried only after code was added, a file or module loaded or a top-level `#run` finished (`lower_epoch`, `procs.rs`); failures waiting for a `#placeholder` are never memoized, since the metaprogram may define it at any time.

## How to change it

- New library or option: edit `tools/build_vk_engine_libs.py`. The CMake options mirror `JoltCompileOptions.Default | CombinedSharedLibs` of `Jolt-Jai/generate.jai` and the defines in `Modules/JoltPhysics/module.jai` (`DOUBLE_PRECISION`, `OBJECT_LAYER_BITS`, ...); they must match, `CheckVersionID` compares them at run time. `JPH_USE_VK=OFF` and `ENABLE_ALL_WARNINGS=OFF` keep Jolt from needing `dxc` and from failing on newer clang warnings.
- A macOS port of the engine modules would add the missing `#if OS == .MACOS` branches in the three `module.jai` files and generate `*_macos.jai` bindings (`ImGui/generate.jai` already names `imgui_macos.jai`); load `libvulkan` from `/opt/homebrew/lib` (MoltenVK, see [native libs](../tools/native-libs.md)).
- Tests for the compiler fixes: `tests/stdlib/poly-default-lambda-instance.jai`, `tests/stdlib/compile-time-failing-bodies.jai`.

## Configuration

`python3 tools/build_vk_engine_libs.py [imgui] [vma] [joltc] [--release] [--force] [--jobs N]`; default builds are debug like upstream's (`--release` for optimized). Outputs: `corpus/upstream/ostef--Vk-Engine/Modules/ImGui/Libs/MacOS/libImGui.dylib`, `.../Modules/Vulkan/Libs/MacOS/libVkMemAlloc.a`, `corpus/upstream/ostef--Jolt-Jai/Libs/MacOS/libJoltC.dylib` (also reachable as `Modules/JoltPhysics/Libs/MacOS`). `JAI_LIBCLANG` selects libclang for the generators ([bindings generator](../stdlib/bindings-generator.md)). Use a `--release` jaic build for the project.

## Dependencies

`cmake`, `ninja` (optional), a C++20 compiler and git; network access for `tools/fetch_upstreams.py` and the Jolt clone. For running the engine eventually: MoltenVK and the Vulkan loader from Homebrew (`brew install molten-vk vulkan-loader`).
