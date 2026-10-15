# WGL failure investigation and native CI handoff

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
