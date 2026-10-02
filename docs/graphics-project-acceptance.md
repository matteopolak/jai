# Graphics project acceptance

## What it is

This lane checks the pinned `ostef/Vk-Engine` and `roeyb1/sgpu` source with this repository's compiler. Source checking, compiler workspace builds, reviewed SDK linking and actual GPU execution are separate acceptance gates.

## How it works

Vk-Engine's authoritative root is `Build.jai`. It imports compiler workspace services, generates source with `#insert`, and compiles project modules. Its Vulkan and ImGui modules select Windows/Linux, so SDL's macOS branch alone does not establish a macOS engine build.

sgpu's authoritative workspace recipe is `examples/build.jai`; `examples/01_memory.jai` is a genuine application root. The recipe builds eight examples and copies native libraries. sgpu selects Windows/Linux/macOS Vulkan/VMA dependencies, with Slang enabled by default and RenderDoc optional. Its Slang interfaces and shader filesystem use `#cpp_method` callbacks and procedure fields.

The current read-only SDK inventory is `artifacts/native-sdk-configuration-current.json`. It observes an ARM64 macOS host and installed Vulkan headers/loader and SDL paths. Path existence does not authorize replacing the project's native artifacts or establish matching symbols, layouts, a GPU driver, or a successful link. sgpu's default Slang branch imports `shader_vfs.jai`; disabling it would change project configuration and is not part of the default acceptance profile. The memory example explicitly enables `VALIDATION`, so validation-layer availability is another runtime requirement.

The pinned generated bindings identify Vulkan header revision 335 and VMA Vulkan configuration 1.4 for sgpu macOS, versus header revision 250 and VMA configuration 1.3 for Vk-Engine Windows/Linux. SDK receipts must preserve those source requirements when establishing compatibility with a rebuilt dependency; an installed newer header version alone is insufficient evidence.

The independently rebuilt VMA proof currently covers six virtual-allocation APIs with Vulkan loader imports disabled and a separately checked Jai ABI. It does not authorize the projects' GPU allocation bindings or the sgpu Vulkan 1.4 configuration.

The authored `tests/sdk/imgui-method.jai` fixture calls the exact Vk-Engine `AddRectFilled` symbol through `#cpp_method`, including pointer receivers, C++ reference parameters and default rounding/flags. Its C++ host uses the independently rebuilt ImGui 1.90.4 docking archive at revision `c6aa051629753f0ef0d26bf775a8b6a92aa213b2`. The matched-target report `artifacts/imgui-jai-method-8a52b33b-matched-target.json` records successful linking and execution with 12 CPU vertices, 18 indices and exit 42. Source/archive fingerprints and the authored host's transitive headers were verified before execution. This proves that selected method boundary, without Vulkan, a window backend or an engine build.

The immutable snapshot report `artifacts/graphics-project-8a52b33b.json` records compiler SHA-256 `8a52b33b52753562e987b37ec8274548e019aa62b7b611d5c432c0f5c3e00489`, real Preload search and Runtime_Support disabled. All three roots pass lexing. Both sgpu roots now pass parsing: application checking reaches the enum cast suffix in `module.jai:626`, while workspace checking reaches the `$$ s: string` parameter in `String/module.jai:783`. Vk-Engine still fails parsing its filtered `using` declaration on line 7. Code generation and builds were requested but were not reached; project builds, links and executions remain zero.

The earlier `graphics-project-baseline.json` and `graphics-project-737a864b.json` preserve the previous failures before mixed result assignment and compile-time case parsing advanced the sgpu roots. New feature fixtures such as C++ method vtable calls prove their actual contract independently; they do not change the observed upstream acceptance stage until the pinned roots are rerun.

The later source-only checkpoint `artifacts/os-graphics-project-b1b82044.json` records immutable CLI SHA-256 `b1b820444e2a6585cda11d8efc2bf2186c5a6623cf54312552ba403d4e64fd13`. All three authoritative graphics roots pass direct parsing. Their genuine application/workspace checks first fail in dependency syntax: Vk-Engine reaches `Modules/Common/module.jai:316:17` (`push_context,defer_pop`); sgpu's build recipe reaches `String/module.jai:894:9` (`for #v2`); the memory application reaches `module.jai:661:10` (caller-exported return). Every recorded failure location carries the pinned dependency source hash. Full graph parsing/checking, project builds, links and execution remain incomplete; root parsing alone proves none of those stages.

## How to change it

Rerun the exact pinned roots against an immutable compiler snapshot after language changes land. Preserve both original workspace recipes and actual application roots; checking a module or an authored ABI fixture does not substitute for the project build. Coordinate source-rebuilt Vulkan, VMA, Slang and engine-specific dependencies through the native dependency manifest and target proof boundary.

`tools/check_os_graphics.py` reruns this fixed root set together with the OS modules, using only `parse` and `check`/`check-library`. Its exact command and frozen-binary selection rules are documented in [OS library acceptance](os-library-acceptance.md). Keep source-only failures separate from the reviewed SDK witnesses above.

## Configuration

The corpus harness uses actual project `Modules/` or `modules/` search directories and the reference module directory. `--bootstrap search` enables real Preload resolution; Runtime_Support remains off in that profile. Reports record the exact binary, source hashes, environments, commands and observed stages.

The SDK fixture uses `--target arm64-apple-macosx27.0.0` for both emitted Jai objects and trusted Clang++ linking, matching the rebuilt archive's receipt. Reproduce it only with a reviewed source-rebuilt archive and verified receipt; the compiler's default deployment target may differ from the SDK witness target.

## Dependencies

`tools/check_corpus.py`, pinned upstream manifests, this repository's compiler and reference source modules. Native builds additionally require reviewed source-rebuilt SDKs matching the selected target, symbols, layout and versions. Original corpus native artifacts are never loaded or executed.
