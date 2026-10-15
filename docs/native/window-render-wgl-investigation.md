# WGL failure investigation and native CI handoff

## Latest lifecycle evidence and correction (2026-10-14)

Authorized filtered run38662728329 supersedes the historical creation-only
diagnosis below. x64 actually loads Mesa llvmpipe/OpenGL4.6; probe, public events
and public shader/texture draw/readback pass interpreter/O0/O2. Lifecycle fails
context selection (native exits3221226505). ARM64 actually loads GDI Generic1.1,
and still needs a matching real driver. Signed wheels pass both CPUs. No raw
logs or forbidden implementation sources were consulted.

Official Mesa25.2.5 `src/gallium/frontends/wgl/stw_framebuffer.c` installs a
CALLWNDPROC hook and releases the window framebuffer on WM_DESTROY, before our
window procedure executes. Our retirement callback selected that dying window's
DC. This is a concrete source-level lifetime hazard consistent with the native
failure; a new native run must still establish that it explains this CI failure.

Each Windows context now owns a real hidden native STATIC window/common DC at
the original display position, with the visible window's exact installed pixel
format. During destruction only that retirement drawable is selected for GL
cleanup. Non-root contexts delete their context, release this common DC and
destroy its native window. The first share-owner context and its retirement
drawable remain process-lived, so pending PBOs/textures survive closing all public
windows and reopening. This is an actual SDK-backed resource, not a fake public
window or simulated GL support. Retaining one native surface/context is a real
resource/performance cost; see the deviations report. Different multisample
formats receive distinct compatible retirement DCs.

The original lifecycle regression now checks current-context/DC preservation when
closing a noncurrent window, explicitly unbinds/rebinds the retained live owner
after all public windows close, preserves real texture/readback assertions, and
repeats multisample-window teardown. A current dying drawable is replaced before
renderer retirement flushes pending immediate writes to surviving texture storage;
the regression checks those pixels after reopen. Every failed native selection
records stage, immediate GetLastError, requested handles and prior handles before
asserting. Native CI filtered summaries include those records and lint diagnostic
headers/locations without source excerpts. The previous filtered report gives no
lint rule/location; native Windows strict lint is still unresolved until its
actual findings are supplied. Native-host strict lint is a separate local check.

## Pinned native ARM64 source route

`tools/window_render_mesa_windows.py` builds the actual WGL pair from official
Mesa25.2.5, LLVM20.1.8 and upstream WinFlexBison2.5.25 sources. URLs and SHA256s
are immutable in the helper; the LLVM digest comes from its official release API,
Mesa/WinFlexBison hashes were measured on downloaded upstream source archives.
No Jai implementation is involved. Build inputs, exact commands, MSVC/SDK versions
and output DLL hashes are recorded in target/window-mesa-arm64/source-build.json.

Use native Windows ARM64 Python3.12+ and VS2022 ARM64 C/C++ tools (VS17.9+,
Windows SDK20348+ per Mesa's installation documentation). Initialize vcvarsall
for ARM64, then install build tools with these exact versions in an isolated
environment: cmake3.31.6, ninja1.13.2, meson1.8.3, Mako1.3.10,
MarkupSafe3.0.3, packaging25.0. CMake/Ninja/MarkupSafe native ARM64 wheel availability
was checked against the public package index. For example, in the activated venv:

```sh
python -m pip install cmake==3.31.6 ninja==1.13.2 meson==1.8.3 Mako==1.3.10 MarkupSafe==3.0.3 packaging==25.0
```

Tool wheels may execute as host build tools; generator executables, LLVM tools
and driver DLLs are verified as ARM64 PE images. No x64 driver is accepted.

```sh
python tools/window_render_mesa_windows.py --plan
python tools/window_render_mesa_windows.py --jobs 4
python tools/window_render_wgl_ci.py \
  --jaic target/aarch64-pc-windows-msvc/debug/jaic.exe \
  --jailint target/aarch64-pc-windows-msvc/debug/jailint.exe \
  --stdlib stdlib --native-libs target/native-libs \
  --driver-dir target/window-mesa-arm64/driver
```

LLVM is built with the AArch64 backend and static /MT CRT, matching Mesa;
llvmpipe/draw LLVM are enabled, shared LLVM disabled. Unused Vulkan/EGL/GLES/GLX
and optional compression/XML libraries are disabled to keep this WGL driver build
self-contained; production OpenGL shaders/render/readback tests remain required.
Upstream Mesa CTS is not claimed. WinFlexBison is itself built from source and
installed with its parser data. Meson fallback downloads are disabled. A stale
extracted source tree is rejected rather than silently trusted. No GL/GLSL version
override is permitted. App-local deployment and actual llvmpipe identity/readback
are required by the native runner; a successful DLL build alone is insufficient.

Local evidence: pinned Mesa and WinFlexBison archives downloaded and inspected,
LLVM official release digest and its AArch64 COFF runtime-linker support checked,
plan and three source-cache safety regressions pass. This macOS host cannot build
MSVC ARM64 DLLs or execute Windows graphics. ARM64 driver build/deployment/runtime
remain **pending native CI**, with potentially substantial LLVM build time/memory
and runner desktop/session constraints. No unavailable driver is counted as pass.

Official native sources: [Mesa source archive](https://archive.mesa3d.org/mesa-25.2.5.tar.xz),
[LLVM20.1.8](https://github.com/llvm/llvm-project/releases/tag/llvmorg-20.1.8),
[WinFlexBison2.5.25](https://github.com/lexxmark/winflexbison/tree/1176da2adaf972b2216b1ac8dd611e128fe80bc5),
[Mesa installation](https://docs.mesa3d.org/install.html),
[Mesa llvmpipe](https://docs.mesa3d.org/drivers/llvmpipe.html),
[Microsoft wglMakeCurrent](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-wglmakecurrent).

## Evidence boundary

Authorized filtered feedback in `docs/ci-feedback-latest.md` reports candidate
`0100a1f`, Windows run38658753246: signed-wheel issue #1 passes on x64 and arm64.
Graphics programs link, but public renderer execution fails in canonical WGL
creation in interpreter, native O0 and native O2 on both CPUs. This establishes
neither the failing native call nor the available driver. No raw CI logs, vendor
corpus bodies, quarantined integration or implementation transcripts were read.

This macOS worker cannot measure a Windows runner's actual driver. Windows native
success remains unclaimed until a new filtered report supplies the probe results.

## Reviewed independent binding path

The NEW bindings producer's `internal/bindings/wgl/module.jai` uses a temporary
standard window on the target display, retains its DC, sets a legacy pixel format
before creating/making current the bootstrap context, resolves WGL extensions,
then selects or reuses the target's immutable pixel format. It requests version3.3
and the core-profile bit for Simp and restores both prior current handles on exit.
No proved defect in this sequence was found by source review. PFD fields have the
native 40-byte layout; the probe checks that size on each CPU.

Simp's GLSL330 shaders require the requested context. Changing the request to1.1,
dropping the core requirement, bypassing failed assertions or skipping rendering
would conceal a real unsupported environment. None is done.

Production failure diagnostics now capture requested version/profile/MSAA, share
handle, prior/current context and DC, and any actually installed target PFD. The
error is explicitly **post-cleanup**: the binding currently returns null without
retaining the error at the failing call, and deferred native cleanup can replace
it. Unavailable descriptors are reported as unavailable, not as zero-bit formats.
Successful construction additionally checks the binding's current-context/DC
restoration contract before selecting the new context.

## Bindings-owner integration request

Please instrument failure branches in the canonical private WGL adapter, preserving
its exact public signature. Capture `GetLastError` immediately after a failed SDK
call, before cleanup; include the stage in a native diagnostic. Distinguish missing
advertised extensions/capabilities from SDK-call failures with numeric error codes.
Relevant boundaries are bootstrap window/DC acquisition, Choose/SetPixelFormat,
legacy context creation/current selection, extension retrieval/resolution,
ARB pixel-format selection/query, target format installation, context-attrib
creation, context sharing, and prior-context restoration. Preserve all cleanup and
the irreversible target pixel-format rule. No binding-owner checkout is modified
by this worker and no staged replacement binding module is installed.

One concrete cleanup ownership issue needs owner review: the adapter's failed
target-creation defer unconditionally requires ReleaseDC to succeed. Public
Window_Creation windows have CS_OWNDC, whose private DC remains OS-owned until
window destruction. ReleaseDC does not release private/class DCs. Apply the native
class/DC ownership distinction to this failure cleanup, as the owned renderer
lifecycle already does; retain checked release for common DCs. This issue is not
proved to be the initial CI creation failure. The probe's unsupported-version
case exercises the failure path on a genuine private-DC public window.

The original `windows-wgl-driver.jai` probe independently calls native SDK pixel
format and legacy-context operations through canonical Windows bindings. It prints
actual PFD data, GL vendor/renderer/version, WGL extensions and loaded opengl32 DLL
path, then tests the canonical constructor on the installed target format. It
requires actual3.3 core support, renders/reads an exact magenta pixel, and verifies
unsupported-version failure preserves the current context/DC and pixel format.
This separates bootstrap/PFD failures, absent modern-driver capabilities, and
canonical constructor behavior without creating another production GL backend.

`windows-render-public.jai` also requires actual public Simp shader compilation,
immediate color drawing, an RGBA render-target texture, sampled image drawing,
pixel comparisons and native swap. Existing wheel and close/reopen/shared-readback
tests remain intact and required.

## Next native run

Run on each native Windows CPU with the NEW source-built compiler and native C
dependencies, from the integrated clean producer tree:

```sh
python tools/window_render_wgl_ci.py \
  --jaic target/CPU-pc-windows-msvc/debug/jaic.exe \
  --jailint target/CPU-pc-windows-msvc/debug/jailint.exe \
  --stdlib stdlib --native-libs target/native-libs
```

The tool attempts interpreter/O0/O2 for the driver probe and all three production
renderer regressions. A failed build is recorded and its nonexistent/stale binary
is not executed. Failures/timeouts remain failures; no automatic success retry is
used. Root retains full own-test diagnostics in results.json; transfer only
summary.json's filtered SDK metadata/statuses into authorized feedback for this
worker. Include GL_VENDOR/GL_RENDERER/GL_VERSION, WGL extensions, loaded DLL path,
PFD values and any failing SDK stage/error for each mode and CPU.
Build both tools from the NEW compiler source (`cargo build --locked -p jaic-cli
-p jailint`, retaining the native CI target/CRT configuration). Native warnings-
denied lint also runs on the actual integrated library roots and the new tests;
incomplete compilation is a failure. Local facade roots must not accidentally
prepend their inherited dependency directory ahead of the integrated library.

If identity confirms insufficient system GL capability, configure a real software
driver explicitly. Mesa documents an application-local opengl32.dll plus its WGL
driver dependencies. Build from a pinned official Mesa source with matching native
CPU, LLVM/JIT target, SDK and CRT; retain source/version/digest/configuration evidence.
Do not reuse x64 DLLs as arm64 evidence or assume an unexecuted arm64 build works.
Source build and driver installation have **not** been executed by this worker.

Deploy the resulting directory explicitly:

```sh
python tools/window_render_wgl_ci.py \
  --jaic target/CPU-pc-windows-msvc/debug/jaic.exe \
  --jailint target/CPU-pc-windows-msvc/debug/jailint.exe \
  --stdlib stdlib --native-libs target/native-libs \
  --driver-dir target/mesa-CPU-driver
```

This validates PE CPU identities, records DLL SHA256 values, and copies actual
driver DLLs beside both the source-built compiler and native programs, all under
the local target directory. Interpreter library search includes that explicit
directory. It selects llvmpipe and requires the reported renderer to identify
llvmpipe as well as pass actual context/draw/readback tests. Version/GLSL overrides
are rejected. It does not alter system drivers/registry, download opaque drivers,
access credentials, dispatch CI or publish anything. Normal native CI coverage
must still run after this targeted diagnostic, without test exclusions.

## Official native sources

- [ChoosePixelFormat](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-choosepixelformat): closest match requires checking actual capabilities.
- [wglCreateContext](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-wglcreatecontext): set a pixel format first and select a context before GL calls.
- [ReleaseDC](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-releasedc) and [private DC ownership](https://learn.microsoft.com/en-us/windows/win32/gdi/private-display-device-contexts): only common DCs need release; class/private DCs remain OS-owned.
- [WGL context/profile attributes](https://registry.khronos.org/OpenGL/extensions/ARB/WGL_ARB_create_context.txt): version/profile requests and failure conditions.
- [Mesa build prerequisites](https://docs.mesa3d.org/install.html), [Windows Meson configuration](https://docs.mesa3d.org/meson.html), [LLVMpipe application-local Windows deployment](https://docs.mesa3d.org/drivers/llvmpipe.html).
