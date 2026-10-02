# Native platform and graphics bindings

## What it is

This part of `stdlib` replaces the bundled Jai native-facing modules with independently authored declarations and Jai wrappers. It retains the public module names, record fields, constants, signatures and defaults needed by the supplied API contracts, while keeping external native runtimes outside the rewrite.

The implementation remains incomplete. An API declaration, a successful source parse and an authored wrapper body are separate evidence categories. No foreign symbol resolution, native linking, native execution, GPU behavior or target ABI acceptance has been verified by this work.

The aggregate report is `stdlib/.coverage/native-platform-bindings.json`. Exact graphics source hashes, remaining adapter signatures and diagnostics are in `stdlib/.coverage/graphics-source-parse.json`. Related families have their own documentation:

- [Platform SDK bindings](platform-sdk-bindings.md): POSIX, Windows, Android and Objective-C declarations and wrappers.
- [Window and audio bindings](window-audio-bindings.md): SDL2, X11, window creation, icons and sound helpers.
- [Codec and native bindings](codec-native-bindings.md): FreeType, compression, image/video codecs, allocators and optional instrumentation.

The final source snapshot lists 203 public Jai files, with 191 whole-file syntax passes and twelve exact syntax gaps. Its 2,988 named procedure-body occurrences include thirteen intentionally disabled telemetry hooks; they are not runtime pass counts. All checked sources and the frozen compiler hash remained stable during this parse-only audit.

## How it works

The contract normalizer tokenizes read-only API source, preserves declaration data and discards procedure bodies before authoring begins. It removes executable `#run` blocks rather than importing their effects. Existing native prototypes remain declarations. Each missing Jai wrapper initially becomes an explicitly unavailable adapter contract; independent source subsequently replaces those contracts where the behavior can be implemented.

Native library locators use target system dependencies, such as `opengl32`, `OpenGL`, `GL`, `EGL`, `Metal`, `vulkan`, `vulkan-1`, `curl`, `d3d11`, `d3d12`, `dxgi`, `d3dcompiler_47` and `dxcompiler`. No supplied binary, object, static archive or DLL is included. These locators do not establish that a dependency is installed or that all declared symbols are exported.

### OpenGL

`GL/loader.jai` parses the current context version and checks complete extension names. `load-core.jai` and `load-all.jai` explicitly resolve retained procedure fields whose names match the [canonical Khronos OpenGL registry](https://registry.khronos.org/OpenGL/). Name matching is recorded in `gl-current-registry.json`; it is not a complete signature or ABI proof. Desktop baseline procedures retain their system foreign declarations. Procedure lookup uses WGL with a system-library fallback on Windows, GLX on Linux, `dlsym` on macOS and EGL on Android.

The core loader also resolves its three retained GLX swap-interval fields against the [official GLX extension header](https://github.com/KhronosGroup/OpenGL-Registry/blob/main/api/GL/glxext.h). Two legacy field signatures need source bridges: EXT's retained integer result wraps an actual void SDK call and returns compatibility zero, which is not native error status; MESA's signed input is converted to the SDK's unsigned input. The public field contracts remain intact.

`GL/utilities.jai` supplies counted-string shader input, temporary C-string names, native info-log queries, object labels and a synchronous debug callback. The callback captures the importing context's logger and data; those values must remain valid while that callback is registered. Debug state is per imported module instance, so changing it affects contexts using that instance. `DumpGLErrors` deliberately returns false when the declared `DUMP_GL_ERRORS` configuration is disabled; its enabled branch queries and logs native errors.

`GL/mac-context.jai` independently creates an AppKit pixel format and context, reduces the requested sample count when pixel-format creation fails, reads the selected sample count and attaches a window view. It checks for the view's context setter before calling it. The installed AppKit SDK provides legacy, 3.2 core and 4.1 core profiles. An unspecified modern profile selects 4.1; incompatible requested profiles return null. The caller owns a returned context. AppKit thread/autorelease requirements remain the caller's responsibility. The debug option requests available debug output after loading procedures; it does not manufacture a native debug-context flag. Windows/GLX context creation and the generic context helper remain explicit gaps.

The retained counted-string overloads of `_glGetActiveAttrib` and `_glGetActiveUniform` also remain gaps: a verified mutable output-buffer contract is required before implementing their native writes.

### Direct3D, DXGI and shader compilers

Authored interface wrappers call their declared vtable fields with the receiver and native arguments. By-value IID overloads pass the address of the local IID to the native pointer overload. This follows the documented [COM interface/vtable model](https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nn-unknwn-iunknown), while retaining the declared interface layout and calling-convention metadata. Reflection interfaces with a plain `vtable` field follow the same rule as interfaces with named vtable fields.

The eleven D3D12 component/filter helpers encode and extract documented bit fields in Jai. Their data contract is checked against [Microsoft's DirectX-Headers declarations](https://github.com/microsoft/DirectX-Headers/blob/main/include/directx/d3d12.idl). The high-level `D3DCompile`, `D3DCompileFromFile`, `DXC_Compile` and `DXC_Reflect` helpers remain unavailable adapters. Native compiler entry-point declarations are present, but they do not replace those Jai behaviors.

### Metal

The retained Metal method wrappers use typed Objective-C message calls and explicit class-factory receivers. `init_metal` registers the selector table, and the seven record constructors assign their fields directly. The installed `objc/message.h` requires correctly typed function pointers. Reviewed plain LP64 record returns of more than sixteen bytes use output-first `objc_msgSend_stret` on X64; ARM64 uses typed `objc_msgSend`. Smaller reviewed records use typed direct returns. [Clang's current X64 ABI classifier](https://github.com/llvm/llvm-project/blob/main/clang/lib/CodeGen/Targets/X86.cpp) supports that size boundary for these ordinary multi-field records. The Jai native lowering and target runtime still require ABI acceptance tests.

All retained former Metal procedure-body contracts now have authored bodies. This does not prove every selector spelling, SDK availability annotation, imported record layout or method call works against a particular installed OS version. The whole-file parser still stops at a retained namespace-promotion declaration before reaching later declarations; the independently extracted body witness parses.

### Vulkan

`Vulkan/version.jai` implements the retained integer version macros. Forty-six enumeration helpers perform the native count query, allocate with the context allocator, initialize required `sType`/`pNext` fields, fill the array and propagate native status. Failed fills free the allocation; successful arrays belong to the caller and must be freed with the same allocator. A positive `VK_INCOMPLETE` result is retained with its partial array.

The [canonical Vulkan registry](https://registry.khronos.org/vulkan/) verifies needed structure identifiers. Its URL, hash and reviewed header version are recorded in `vulkan-upstream-provenance.json`. The public binding remains the supplied retained API; no speculative `Vulkan/current` namespace is included. Six Linux extension enumeration helpers remain unavailable because their retained contracts lack a verified native dispatch path. Loader/library availability and device/instance extension enablement remain separate prerequisites.

### Curl and ImGui

Curl's five formatting wrappers convert counted format strings to temporary C strings and forward arguments to the native format entry points. The ABI policy comes from [libcurl's compatibility documentation](https://curl.se/libcurl/abi.html): a stable ABI does not make a newer symbol available in an older installed library.

ImGui's authored helpers forward to declared native overloads, handling counted text ranges, C strings, pointer arguments and format arguments. Text-range helpers preserve caller-owned pointers when native methods return positions into the input. The retained C++ symbol contracts still require the matching compatibility library; `jai-independent-imgui-compat` is deliberately unavailable here. A reviewed upstream header snapshot is declaration provenance, not a built replacement C++ library or evidence that a newer ImGui ABI is interchangeable.

## How to change it

Author behavior in the owning Jai file or a clearly loaded helper file. Keep module parameters in the module entry file. A `#load` creates a separate file scope, so helpers used by other loaded files need module visibility; file-private imports and variables remain local to their defining file.

`tools/rewrite_native_api_contracts.py` is a destructive authoring aid for a new output path: it deliberately discards all procedure bodies, including independently authored ones if rerun on finished source. Do not run it over the finished tree as a verification command. `author_graphics_dispatch.py`, `author_metal_dispatch.py`, `author_vulkan_enumeration.py` and `author_imgui_forwarding.py` operate on authored declarations; inspect their reports and resulting source whenever extending their rules. The Vulkan authoring command requires an explicitly reviewed `--registry` path. These tools never build or run a native runtime.

Run the source-only checker with a frozen compiler built from this project's own source:

```sh
python3 tools/check_native_binding_sources.py \
  --parser target/standard-library-snapshots/9508def6f527169083405db10c93d9d377289fecdca749a546eb849ca39d501d/jai-rs
```

The checker records compiler hashes before/after, authored source hashes before/after, full-file syntax results and ten procedure-body witnesses. At this checkpoint, 24 of 35 graphics files parse and all ten witnesses parse, covering 2,220 authored procedure bodies with zero empty bodies. Fifteen unavailable adapter declarations remain. Compiler build-input verification is false for that frozen snapshot; the report does not infer a current Rust build from a binary hash.

After refreshing all component reports, run `tools/summarize_native_binding_coverage.py --parser PATH` with the same frozen own compiler. It reads the four component manifests, checks every listed authored file in parse mode and rewrites the aggregate report with current source hashes. Its `--output` option selects the aggregate destination. Component adapter/compatibility inventories retain their distinct meanings rather than being folded into a fabricated native pass percentage.

Whole-file limitations are exact retained syntax: GL procedure-pointer reflection attributes, Metal's bare namespace `using`, Windows ImGui's non-POD C++ return annotation and COM `#place` layout directives. Removing those contracts merely to obtain a parser pass would erase ABI information. A body witness establishes syntax only and cannot replace full-file semantic resolution.

An unresolved `Native_Adapters` declaration intentionally names `jai-stdlib-native-adapters`, for which no implementation is provided. It is recorded as a gap and must never be counted as an SDK behavior or supplied as an empty procedure. Replace it only with real source or a reviewed actual native declaration. Native integration should separately test layouts, calling conventions, exported symbols, lifetime/ownership and live behavior on each target.

## Configuration

GL retains `DUMP_GL_ERRORS=false`, `ENABLE_ALL_EXTENSIONS=false` and `DEFAULT_MSAA:s32=4`; its module entry owns these defaults. `Vulkan` retains `USE_VULKAN_1_1=true`. Direct3D debug bindings retain `INCLUDE_DEBUG_BINDINGS=false`. Existing target `OS`/`CPU` conditions and remaining family-specific module parameters are preserved and recorded in their coverage reports.

No new environment variable installs native dependencies. Native library discovery follows the compiler's reviewed system-linking configuration. The source checker takes explicit `--parser`, optional `--output` and optional `--witness-dir` paths. Work keeps at least 2 GiB free and performs no native SDK build, dependency installation or supplied-artifact execution.

## Dependencies

Jai helpers rely on the authored `Basic`, `String`, `Compiler`, `Window_Type`, `Windows` and `Objective_C` modules as required by their contracts. Foreign calls require separately installed system SDK libraries or independently obtained matching upstream native libraries. Graphics calls require a live context/device and their documented target/thread rules. SDK declarations and compatibility libraries remain external prerequisites; their runtime implementations are not reimplemented by this standard-library rewrite.
