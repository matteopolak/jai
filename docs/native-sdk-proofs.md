# Reviewed SDK source ABI witnesses

## What it is

`tools/native_sdk_proofs.py` rebuilds two inspected source dependencies and checks selected native contracts: Dear ImGui 1.90.4 docking and Focus's macOS LightweightRenderingView helper. Persisted receipts describe evidence and always set `link_authority: false` and `full_project_acceptance: false`; they cannot authorize the compiler driver to load a caller-provided archive.

## How it works

`corpus/native-sdk-sources.json` pins repository, immutable commit, exact implementation/header/license files and SHA-256. The tool also pins the manifest's own bytes. It compiles explicit translation units with installed tools, inspects symbols only in its freshly created archive, checks actual transitive inputs against reviewed source or installed SDK roots, and executes an independently authored oracle. It runs no downloaded build scripts, installers or original project native artifacts.

Each receipt records the target, compiler/archiver/symbol-tool fingerprints, archive and oracle executable fingerprints, included headers, flags, selected symbols, oracle source hash and typed measured ABI. The decoder rejects missing/duplicate rows, changed layouts, invalid Objective-C storage bounds and mismatched selector types. Receipts cannot replace the private process-local authority used by [reviewed native linking](reviewed-native-linking.md).

The ImGui recipe pins `ocornut/imgui` commit `c6aa051629753f0ef0d26bf775a8b6a92aa213b2`, the **docking** variant of 1.90.4. Vk-Engine's generated Linux bindings reference docking functions and mangled C++ exports; the non-docking 1.90.4 tag is insufficient. Eight selected exports and exact function types are checked. The native oracle creates/destroys a context, builds CPU font data, starts a docking frame, draws a rectangle and checks its draw data. Typed layout checks cover `ImVec2`, `ImDrawVert` and `ImVector<void*>`; `ImGuiIO` and `ImGuiStyle` checks cover size/alignment only, not every generated binding field.

The Focus recipe uses corpus-pinned commit `c6b3ead7d4174527d0138e8a31f7c3c5663badec`. The oracle verifies class inheritance, object getter/setter signatures, retained object identity, class storage/ivar bounds and `NSRect` layout. It uses raw Objective-C runtime storage and a null OpenGL context; it does not initialize an NSView window, run an event loop or render through OpenGL/Metal. The downloaded source retains its GPL-3.0 license; ImGui retains its MIT license.

Fresh arm64 macOS 27 probes passed: ImGui emitted 12 vertices/18 indices; Focus measured base/derived storage 536/544 bytes with the context ivar at 536. An independently authored [Jai ImGui fixture](../tests/fixtures/imgui-source-abi.jai) called the rebuilt mangled exports and returned 42 at O0/O2 through this rewrite's previously built compiler and installed Clang++. That manual native linkage is distinct from the new driver receipt gate. No full Focus, Vk-Engine or sgpu application ran. Vk-Engine's Vulkan/ImGui modules select Windows/Linux, so these macOS CPU checks do not establish an engine macOS port.

## How to change it

Inspect an immutable source revision, configuration macros, licensing and all required implementation inputs before modifying `REVISIONS`, `FILES`, the source manifest and its code-pinned SHA-256. Extend `native_sdk_oracles.py` with actual type/layout/runtime checks and update `measured_abi` with a complete protocol. Keep known layout validation separate from size-only evidence. Add tests for source drift, protected-root aliases, malformed protocols and rejection before any subprocess.

Extending driver link authority requires a separate typed source-signature/target-layout validator and a fresh-build constructor with a protected snapshot retained through linking. An archive path, matching version string, persisted receipt or installed header directory is insufficient.

## Configuration

Fetch only the manifest-listed source files from their exact repository commits into ignored `artifacts/native-dependencies/source/<recipe>`. All output directories must be fresh beneath `artifacts/native-dependencies`; protected source roots and symlink aliases are rejected.

```sh
python3 tools/native_sdk_proofs.py imgui-1.90.4-docking \
  --source artifacts/native-dependencies/source/imgui-1.90.4-docking \
  --target arm64-apple-macosx27.0.0 \
  --output artifacts/native-dependencies/imgui-reviewed-new
python3 tools/native_sdk_proofs.py focus-lightweight-view \
  --source artifacts/native-dependencies/source/focus-lightweight-view \
  --target arm64-apple-macosx27.0.0 \
  --output artifacts/native-dependencies/focus-reviewed-new
python3 -m unittest discover -s tools -p 'test_native*.py'
```

Flags fix C++17, O2 and PIC. `--compiler`, `--archiver` and `--nm` accept installed tool paths; inherited search paths and injection variables are cleared. Native execution requires the actual host architecture/OS, not an arbitrary cross-target triple. Focus additionally requires macOS AppKit/QuartzCore. No recipe discovers or loads corpus native assets.

## Dependencies

Python standard library, `native_dependencies.py`, `native_sdk_oracles.py`, installed Clang++/LLVM archive and symbol tools, C++/platform SDK headers and exact reviewed source files. Focus uses the installed Objective-C runtime/AppKit/QuartzCore. ImGui's CPU oracle uses no SDL/Vulkan backend or GPU. Vulkan loader/ICD/GPU operation, complete VMA APIs, SDL2, Slang, GUI lifetime and full project module graphs remain separate [dependency gates](native-project-dependencies.md).
