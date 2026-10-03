# Native platform and graphics bindings

## What it is

This part of `stdlib` replaces the bundled Jai native-facing modules with independently authored declarations and Jai wrappers. It retains the public module names, record fields, constants, signatures and defaults needed by the supplied API contracts, while keeping external native runtimes outside the rewrite.

An API declaration, a successful source parse and an authored wrapper body are separate evidence categories. The retained graphics Jai wrapper contracts now have independently authored bodies; matching external native runtimes and compiler support for retained ABI annotations remain prerequisites. No foreign symbol resolution, native linking, native execution, GPU behavior or target ABI acceptance has been verified by this work.

The aggregate report is `stdlib/.coverage/native-platform-bindings.json`. Exact graphics source hashes, remaining adapter signatures and diagnostics are in `stdlib/.coverage/graphics-source-parse.json`. Related families have their own documentation:

- [Platform SDK bindings](platform-sdk-bindings.md): POSIX, Windows, Android and Objective-C declarations and wrappers.
- [Window and audio bindings](window-audio-bindings.md): SDL2, X11, window creation, icons and sound helpers.
- [Codec and native bindings](codec-native-bindings.md): FreeType, compression, image/video codecs, allocators and optional instrumentation.

The aggregate report records the current public source inventory. Named procedure-body occurrences and intentionally disabled telemetry hooks are not runtime pass counts. Component reports retain exact source hashes, parser diagnostics and external SDK prerequisites. The graphics completion packet separately records 29 privately checked files, 24 whole-file syntax passes, five passing body witnesses, zero adapter declarations and zero empty bodies; those figures describe source syntax, not ABI or live behavior.

## How it works

The contract normalizer tokenizes read-only API source, preserves declaration data and discards procedure bodies before authoring begins. It removes executable `#run` blocks rather than importing their effects. Existing native prototypes remain declarations. Each missing Jai wrapper initially becomes an explicitly unavailable adapter contract; independent source subsequently replaces those contracts where the behavior can be implemented.

Native library locators use target system dependencies, such as `opengl32`, `OpenGL`, `GL`, `EGL`, `Metal`, `vulkan`, `vulkan-1`, `curl`, `d3d11`, `d3d12`, `dxgi`, `d3dcompiler_47` and `dxcompiler`. No supplied binary, object, static archive or DLL is included. These locators do not establish that a dependency is installed or that all declared symbols are exported.

### OpenGL

`GL/loader.jai` parses the current context version and checks complete extension names. `load-core.jai` and `load-all.jai` explicitly resolve retained procedure fields whose names match the [canonical Khronos OpenGL registry](https://registry.khronos.org/OpenGL/). Name matching is recorded in `gl-current-registry.json`; it is not a complete signature or ABI proof. Desktop baseline procedures retain their system foreign declarations. Procedure lookup uses WGL with a system-library fallback on Windows, GLX on Linux, `dlsym` on macOS and EGL on Android.

The core loader also resolves its three retained GLX swap-interval fields against the [official GLX extension header](https://github.com/KhronosGroup/OpenGL-Registry/blob/main/api/GL/glxext.h). Two legacy field signatures need source bridges: EXT's retained integer result wraps an actual void SDK call and returns compatibility zero, which is not native error status; MESA's signed input is converted to the SDK's unsigned input. The public field contracts remain intact.

`GL/utilities.jai` supplies counted-string shader input, temporary C-string names, native info-log queries, object labels and a synchronous debug callback. The callback captures the importing context's logger and data; those values must remain valid while that callback is registered. Debug state is per imported module instance, so changing it affects contexts using that instance. `DumpGLErrors` deliberately returns false when the declared `DUMP_GL_ERRORS` configuration is disabled; its enabled branch queries and logs native errors.

`GL/mac-context.jai` independently creates an AppKit pixel format and context, reduces the requested sample count when pixel-format creation fails, reads the selected sample count and attaches a window view. It checks for the view's context setter before calling it. The installed AppKit SDK provides legacy, 3.2 core and 4.1 core profiles. An unspecified modern profile selects 4.1; incompatible requested profiles return null. The caller owns a returned context. AppKit thread/autorelease requirements remain the caller's responsibility. The debug option requests available debug output after loading procedures; it does not manufacture a native debug-context flag. `windows-context.jai` creates a temporary hidden system window/context to resolve WGL extension procedures, selects the target window's pixel format once, creates the requested target context and queries the selected sample count. A failed later operation cannot undo a Win32 window's pixel-format assignment; callers must recreate that window before selecting a different format. Successful contexts/DCs belong to the caller.

`linux-context.jai` chooses GLX framebuffer configurations matching the existing X11 window visual, creates and makes current a context, queries samples and releases temporary Xlib arrays. The visual fixed at X11 window creation constrains available MSAA configurations. It requires GLX 1.3+, the shared X11 display and external coordination with users that change the process-wide X error handler. `context.jai` dispatches the retained generic helper to a supported target and loads GL procedures after successful creation; unsupported targets assert unavailable.

The counted-string `_glGetActiveAttrib` and `_glGetActiveUniform` overloads forward the real GL output writes into caller-owned mutable storage. `name.count` must cover `bufSize`; string literals are unsuitable output storage. The helpers preserve the string view and report the native written length through the existing `length` pointer.

### Direct3D, DXGI and shader compilers

Authored interface wrappers call their declared vtable fields with the receiver and native arguments. By-value IID overloads pass the address of the local IID to the native pointer overload. This follows the documented [COM interface/vtable model](https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nn-unknwn-iunknown), while retaining the declared interface layout and calling-convention metadata. Reflection interfaces with a plain `vtable` field follow the same rule as interfaces with named vtable fields.

The eleven D3D12 component/filter helpers encode and extract documented bit fields in Jai. Their data contract is checked against [Microsoft's DirectX-Headers declarations](https://github.com/microsoft/DirectX-Headers/blob/main/include/directx/d3d12.idl). `d3d_compiler/compile-helpers.jai` now converts counted names, builds a null-terminated native macro array, calls the real [D3DCompile entry point](https://learn.microsoft.com/en-us/windows/win32/api/d3dcompiler/nf-d3dcompiler-d3dcompile), copies bytecode/diagnostic blobs and releases those COM references. Definition strings use `NAME=VALUE`; a bare name means value `1`. Copied nonempty strings belong to the caller's context allocator. The file helper converts its path to UTF-16 and returns the actual native blob references; callers release them. Native HRESULT failures remain failures.

`dxc_compiler/compile-helpers.jai` creates SDK utilities/compiler/include objects, builds owned UTF-16 arguments, compiles UTF-8 HLSL, converts diagnostics to UTF-8, checks compiler status and copies the resulting binary into a caller-owned dynamic byte array. Options map to shader profile, entry point, defines, debug data, warnings, optimization and SPIR-V flags; extra arguments follow those generated options. Temporary COM references and argument allocations are released on every exit. Reflection uses [IDxcUtils::CreateReflection from the official header](https://github.com/microsoft/DirectXShaderCompiler/blob/main/include/dxc/dxcapi.h) and returns a caller-owned reflection interface. These retained DXC declarations use the Windows UTF-16 ABI; the helper rejects other targets rather than invoking the upstream UTF-32 ABI with the wrong arguments.

### Metal

The retained Metal method wrappers use typed Objective-C message calls and explicit class-factory receivers. `init_metal` registers the selector table, and the seven record constructors assign their fields directly. The installed `objc/message.h` requires correctly typed function pointers. Reviewed plain LP64 record returns of more than sixteen bytes use output-first `objc_msgSend_stret` on X64; ARM64 uses typed `objc_msgSend`. Smaller reviewed records use typed direct returns. [Clang's current X64 ABI classifier](https://github.com/llvm/llvm-project/blob/main/clang/lib/CodeGen/Targets/X86.cpp) supports that size boundary for these ordinary multi-field records. The Jai native lowering and target runtime still require ABI acceptance tests.

All retained former Metal procedure-body contracts now have authored bodies. This does not prove every selector spelling, SDK availability annotation, imported record layout or method call works against a particular installed OS version. The whole-file parser still stops at a retained namespace-promotion declaration before reaching later declarations; the independently extracted body witness parses.

### Vulkan

`Vulkan/version.jai` implements the retained integer version macros. The retained enumeration helpers perform the native count query, allocate with the context allocator, initialize required `sType`/`pNext` fields, fill the array and propagate native status. Failed fills free the allocation; successful arrays belong to the caller and must be freed with the same allocator. A positive `VK_INCOMPLETE` result is retained with its partial array.

The [canonical Vulkan registry](https://registry.khronos.org/vulkan/) verifies needed structure identifiers. Its URL, hash and reviewed header version are recorded in `vulkan-upstream-provenance.json`. The public binding remains the supplied retained API; no speculative `Vulkan/current` namespace is included. Six Linux extension enumeration helpers now resolve genuine SDK procedures through the registered owning instance/device and execute the native count/fill protocol. Returned arrays use the caller's context allocator; failed fills free them and `VK_INCOMPLETE` preserves partial output. No extension alias is guessed to be a loader export.

`dispatch-registry.jai` wraps real instance/device creation, physical-device/group enumeration, queue retrieval and destruction. Typed records distinguish instances, physical devices, devices and queues; monotonically increasing lifetime generations associate children with exact parents. Destruction unregisters descendants before native destruction, and newly created native handles start new registrations. The [official instance lookup contract](https://docs.vulkan.org/refpages/latest/refpages/source/vkGetInstanceProcAddr.html) and [device lookup contract](https://docs.vulkan.org/refpages/latest/refpages/source/vkGetDeviceProcAddr.html) require this owner relationship. Registry lookups hold a CAS lock only while copying provenance. Allocation, deallocation, SDK calls and user callbacks run outside the lock. Registry nodes use the system C allocator, independently of enumeration arrays.

Clients that bypass these creation/enumeration wrappers must call `vk_register_instance`, `vk_register_physical_device`, `vk_register_device` and `vk_register_queue` in parent order. They must explicitly unregister before bypassing destruction or replacing a native lifetime. Duplicate registration is valid only for the same current parent; unregistering a parent removes its descendants. Opaque native handle memory is never inspected. Caller synchronization still prevents destruction while a native call is in flight; the registry does not replace [Vulkan's required external lifetime synchronization](https://docs.vulkan.org/refpages/latest/refpages/source/vkDestroyInstance.html).

Unknown registered provenance returns `ERROR_INITIALIZATION_FAILED` for result-bearing helpers. An unavailable resolved procedure returns `ERROR_EXTENSION_NOT_PRESENT`. The retained void/array-only helpers assert on missing provenance, unavailable procedures or host-memory exhaustion because their signatures have no error return. Queue checkpoint queries retain the SDK's device-lost precondition. Loader availability and enabled extensions are external runtime prerequisites.

### Curl and ImGui

Curl's five formatting wrappers convert counted format strings to temporary C strings and forward arguments to the native format entry points. The ABI policy comes from [libcurl's compatibility documentation](https://curl.se/libcurl/abi.html): a stable ABI does not make a newer symbol available in an older installed library.

ImGui's authored helpers forward to declared native overloads, handling counted text ranges, C strings, pointer arguments and format arguments. Text-range helpers preserve caller-owned pointers when native methods return positions into the input. The native locator is the actual `imgui` SDK library. The retained records and constants require the standard, non-docking [official 1.89.6 API](https://github.com/ocornut/imgui/blob/v1.89.6/imgui.h), default 16-bit `ImWchar`/draw indices, pointer texture IDs and matching configuration. A source-only Clang declaration audit matches all 502 Unix symbol contracts to real non-inline header declarations, including equivalent Itanium base/complete destructor variants. This proves declaration correspondence, not exported-symbol resolution or target ABI acceptance. The Windows decorated names and C++ return metadata remain retained and require separate MSVC ABI validation.

The normal `CreateContext` wrapper invokes upstream `DebugCheckVersionAndDataLayout` with the retained version and record sizes before creating the context. Direct calls/externally created contexts still require the same matching SDK. The independently reviewed engine SDK at 1.90.4 docking is a different external dependency and cannot satisfy these 1.89.6 record layouts. No native ImGui runtime implementation or substitute library is authored here.

## How to change it

Author behavior in the owning Jai file or a clearly loaded helper file. Keep module parameters in the module entry file. A `#load` creates a separate file scope, so helpers used by other loaded files need module visibility; file-private imports and variables remain local to their defining file.

`tools/rewrite_native_api_contracts.py` is a destructive authoring aid for a new output path: it deliberately discards all procedure bodies, including independently authored ones if rerun on finished source. Do not run it over the finished tree as a verification command. `author_graphics_dispatch.py`, `author_metal_dispatch.py`, `author_vulkan_enumeration.py` and `author_imgui_forwarding.py` operate on authored declarations; inspect their reports and resulting source whenever extending their rules. The Vulkan authoring command requires an explicitly reviewed `--registry` path. These tools never build or run a native runtime.

Run the source-only checker with a frozen compiler built from this project's own source:

```sh
python3 tools/check_native_binding_sources.py \
  --parser target/standard-library-snapshots/9508def6f527169083405db10c93d9d377289fecdca749a546eb849ca39d501d/jai-rs
```

The checker records compiler hashes before/after, authored source hashes before/after, full-file syntax results and ten procedure-body witnesses. The latest report records each current file and witness result; independently authored SDK helpers contain no empty bodies or unavailable adapter declarations. The private completion packet passes 24/29 full-file parses and 5/5 extracted body witnesses; its remaining full-file failures are retained ABI syntax. Compiler build-input verification is false for that frozen snapshot; the report does not infer a current Rust build from a binary hash.

After refreshing all component reports, run `tools/summarize_native_binding_coverage.py --parser PATH` with the same frozen own compiler. It reads the four component manifests, checks every listed authored file in parse mode and rewrites the aggregate report with current source hashes. Its `--output` option selects the aggregate destination. Component adapter/compatibility inventories retain their distinct meanings rather than being folded into a fabricated native pass percentage.

Whole-file limitations are exact retained syntax: GL procedure-pointer reflection attributes, Metal's bare namespace `using`, Windows ImGui's non-POD C++ return annotation and COM `#place` layout directives. Removing those contracts merely to obtain a parser pass would erase ABI information. A body witness establishes syntax only and cannot replace full-file semantic resolution.

New wrapper contracts must be implemented as actual Jai behavior or reviewed genuine native declarations. Do not introduce an invented compatibility library, successful no-op body or placeholder result to make a dependency appear complete. Native integration should separately test layouts, calling conventions, exported symbols, lifetime/ownership and live behavior on each target.

## Configuration

GL retains `DUMP_GL_ERRORS=false`, `ENABLE_ALL_EXTENSIONS=false` and `DEFAULT_MSAA:s32=4`; its module entry owns these defaults. `Vulkan` retains `USE_VULKAN_1_1=true`. Direct3D debug bindings retain `INCLUDE_DEBUG_BINDINGS=false`. Existing target `OS`/`CPU` conditions and remaining family-specific module parameters are preserved and recorded in their coverage reports.

No new environment variable installs native dependencies. Native library discovery follows the compiler's reviewed system-linking configuration. The source checker takes explicit `--parser`, optional `--output` and optional `--witness-dir` paths. Work keeps at least 2 GiB free and performs no native SDK build, dependency installation or supplied-artifact execution.

## Dependencies

Jai helpers rely on the authored `Basic`, `String`, `Compiler`, `Window_Type`, `Windows` and `Objective_C` modules as required by their contracts. Foreign calls require separately installed system SDK libraries or independently obtained matching upstream native libraries. In particular, retained ImGui requires its independently built 1.89.6 SDK; D3DCompiler requires `d3dcompiler_47`; DXC requires compatible `dxcompiler` interfaces; Vulkan requires a real loader/driver and enabled extensions. Graphics calls require a live context/device and their documented target/thread rules. SDK declarations and compatibility libraries remain external prerequisites; their runtime implementations are not reimplemented by this standard-library rewrite.
