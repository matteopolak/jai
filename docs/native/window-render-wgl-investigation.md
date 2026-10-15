# WGL failure investigation and native CI handoff

## 2fa2bc2: transient pinned-source download failure

Authorized filtered candidate 2fa2bc2 feedback reports source_tree urllib
URLError/WinError10054 before ARM64 Mesa compilation. Classification:
infrastructure transport failure. The subsequent missing driver directory is a
consequence, not independent evidence of a rendering defect. No raw CI logs or
vendor Jai bodies were read.

The source downloader now permits four total attempts, with 2/4/8-second bounded
backoff and an explicit 120-second timeout for each blocking network operation.
This is a socket-operation timeout, not a total archive-transfer deadline. Only
connection reset/abort/refusal, network/host unavailability, timeouts, temporary
DNS failure, premature HTTP disconnect/incomplete response, and HTTP
408/425/429/500/502/503/504 qualify. Unknown errors, permanent DNS/HTTP failures,
TLS certificate/protocol failures, local filesystem errors and hash mismatches
remain fatal. Retried HTTP error responses are closed. Exhaustion rethrows the
last original failure; retries emit the archive name, exception class and delay.
Persistent service failures still fail CI rather than producing a driver claim.

Each attempt creates a unique empty sibling temporary file; failure removes it
before backoff. No append/resume or partial-file reuse is allowed. The complete
closed file must match the unchanged exact pinned SHA-256 before atomic promotion
to the durable archive name and before filtered extraction. An existing archive
is rehashed and reused without network access only when valid; a corrupt durable
archive remains an explicit integrity error, preserved for diagnosis rather than
silently replaced. Default urllib HTTPS/TLS verification remains enabled.
Verified LLVM receipt/cache policy, Windows WGL platform/target/install hash
checks, PE/export/dependency checks and actual loaded-driver identity are unchanged.

Original deterministic tests in tests/window-render/test_mesa_download.py script
only urllib transport boundaries, never a real server or driver. Nine tests cover
partial-transfer reset then success with unique empty files, WinError10054,
timeouts/DNS/disconnect/truncation and retryable HTTP statuses, bounded exhaustion,
permanent/TLS errors, fatal local promotion timeout, corrupt bytes, valid/corrupt
durable archives, and real filtered extraction following a verified retry. The
existing ten source/cache, eight installer and one prepared-child-Python tests
remain required (28 total). These are helper tests, not native SDK/GL execution.
Next normal coordinator CI must still build/install/load the real ARM64 driver
and pass fresh GL probe/readback and all public event/render/lifecycle gates.
No Mesa rebuild, network fetch, native Windows proof or publication was attempted
for this local checkpoint.

## a6371ec: optional VS2026 search entry is not a required SDK input

Authorized filtered CIa6371ec fails in cache configuration before LLVM build on
`C:\Program Files\Microsoft Visual Studio\18\Enterprise\VC\Auxiliary\VS\include`.
The configured entry does not exist. Both Windows CPUs now pass headless/windowed
WebGPU; this does not establish WGL support. No raw CI/vendor Jai logs were read.

Classification: genuine infrastructure preflight defect. MSVC searches INCLUDE
and LIB in order; an absent optional search directory supplies no header/library
files. The helper had conflated every configured entry with a required existing
selected SDK directory. The fix records each configured path, its resolved path
and explicit state. Missing entries are retained deterministically, not dropped.
Every present directory is still fully content-fingerprinted; creating a missing
directory (even empty), adding inputs, or changing their content changes the key.
Inputs are re-fingerprinted before publishing a new LLVM completion receipt, so
creating a search directory or changing SDK/tools during the build cannot stamp
the completed installation with the earlier input identity.
Search order is preserved. Existing non-directory entries are recorded as
not-directory; replacing them with a searchable directory changes the key too.
Non-absence search-entry stat errors propagate rather than being marked missing.

Real auxiliary native inputs may live under explicitly selected VSINSTALLDIR or
VCINSTALLDIR, in addition to VCToolsInstallDir/WindowsSdkDir, UniversalCRTSdkDir
and NETFXSDKDir. These roots come from the native vcvars environment, not guessed
alternate SDK installations. Present unselected directories remain rejected;
absent unselected entries are recorded without traversing their contents. If
created later they must pass native-root authorization before any cache reuse.

Separate minimum-input checks require the selected ARM64 toolchain/SDK, reachable
MSVC vcruntime.h/vector, selected Windows/UCRT Windows.h/SDKDDKVer.h/stdio.h, static
/MT libcmt/libcpmt/libvcruntime/libucrt, and ARM64 kernel32/user32/gdi32/ws2_32
import libraries. WindowsSDKVersion and UCRTVersion select the actual versions;
UniversalCRTSdkDir is honored when provided. Each required file must exist and
be the first matching file in the real configured search list, preventing an
unreachable or wrong-SDK/architecture shadow from being accepted. Missing compiler
and SDK tools remain errors. These metadata checks are a necessary minimum, not
proof that a complete native compiler/driver build will succeed.

Cache configuration is now schema2 to describe absence states and required-input
identity explicitly. Full completed LLVM receipt/file verification is unchanged;
old keys are retained, but there is no unverifiable automatic migration to the new
configuration key. Currenta6371ec never reached a valid key/LLVM build. Once a
schema2 cache is populated it is reusable across fresh Mesa retries; Mesa-only
options still do not invalidate LLVM. No integrity check or WGL assertion is removed.

Local regressions reproduce the VS18 auxiliary paths in an independently authored
SDK-layout fixture. Coverage includes optional missing INCLUDE and LIB entries,
stable repeated absence, later empty-directory creation, later content creation,
header/library/tool changes, missing required headers/libraries/ARM64 SDK tree,
wrong target architecture, missing compiler, required library shadowing, and
unselected real directories. Fixtures are metadata-only, never runnable SDKs or
native graphics evidence. Ten source/cache tests, eight installer/identity tests
and one real Meson prepared-Python test pass (19 total). Native VS2026/MSVC build,
cache reuse and WGL probe/draw/readback/lifecycle/Windows lint remain pending CI.
The normal commands below remain applicable with the selected vcvars environment.
Release publication remains held.

Native oracles: [MSVC environment/search variables](https://learn.microsoft.com/en-us/cpp/build/reference/cl-environment-variables?view=msvc-170),
[include search ordering](https://learn.microsoft.com/en-us/cpp/build/reference/i-additional-include-directories?view=msvc-170),
[Microsoft static CRT/STL libraries](https://learn.microsoft.com/en-us/cpp/c-runtime-library/crt-library-features?view=msvc-170).

## e223538 install failure: validated expectation and configuration fix

Authorized filtered evidence: native ARM64 LLVM/Mesa compilation reached install,
then candidatee223538 (using helpera68544c) failed the required WGL pair check.
No ARM64 GL execution was established. Compiler linking/headless WARP and ARM64
signed-wheel checks pass; those are distinct from OpenGL driver support. No raw CI
logs, vendor Jai or coordinator implementation bodies were inspected.

Failure triage: the DLL expectation is correct. Official pinned Mesa25.2.5
`meson.build:401-424` sets `with_platform_windows` from the **platforms option**,
and `src/gallium/meson.build:233-244` includes both WGL targets only when that
flag and OpenGL are enabled. Our `-Dplatforms=[]` disabled those targets even on
Windows. This is a helper configuration defect, not an installer-name oracle
correction or unavailable-platform classification. The proper fix is explicit
`-Dplatforms=windows`; no assertion is dropped and no unrelated DLL is renamed.

The pinned target definitions create `opengl32.dll` in targets/libgl-gdi and
`libgallium_wgl.dll` in targets/wgl, both installed shared libraries. The supported
`gallium-wgl-dll-name` option is explicitly pinned to its canonical default
`libgallium_wgl`. `shared-glapi` is deprecated/no-op in this source version; it
is not used as an invented enabling switch. The source archive/digest remain
unchanged. No LLVM option, source pin or cache receipt format changes: completed
verified LLVM entries from1f66dc1 remain reusable on the same toolchain/config.
An original regression confirms Mesa-only option changes do not alter that key.

Before compilation the helper saves real Meson --buildoptions/--machines/--targets/
--installed/--install-plan JSON and requires Windows/aarch64, llvmpipe, OpenGL,
static LLVM/CRT and both expected installed shared-library targets defined in the
verified native source paths. Installation saves `install-files.json` (relative
paths, sizes and hashes) even on failure. Discovery follows Meson's actual install
mapping, including custom directories/case, and requires exact build/install file
hash equality. It cannot substitute a similarly named target or a guessed path.
External DESTDIR is rejected to keep all outputs in the fresh owned prefix.

`window_render_mesa_install.py` validates ARM64 PE identity for installed DLLs,
then uses official MSVC dumpbin /dependents /exports to check real WGL/ICD symbols
and opengl32's import of the actual ICD. Only the reachable app-local dependency
closure is copied, preserving original names. SDK-native metadata is retained in
`native-sdk/*.sdk.txt` and progressive `native-sdk/validation.json`; successful
closure is recorded in `driver-dependencies.json`. Missing external dependencies
are checked with the actual OS LoadLibraryExW SYSTEM32 search, including API-set
resolution, and resolved module paths/machines are reported. The OS loader handles
compatible system ARM64X libraries; all deployed driver images must be ARM64.
These are loader/metadata checks, not a renderer execution pass.

Native vcvars must expose its official dumpbin.exe under VCToolsInstallDir. Use
the already documented prepared venv/package/SDK configuration and restore the
coordinator's1f66dc1 LLVM cache/full receipts. Build with a **fresh** output:

```sh
python tools/window_render_mesa_windows.py \
  --out target/window-mesa-arm64-wgl --cache-dir target/window-mesa-cache --jobs 4
python tools/window_render_wgl_ci.py \
  --jaic target/aarch64-pc-windows-msvc/debug/jaic.exe \
  --jailint target/aarch64-pc-windows-msvc/debug/jailint.exe \
  --stdlib stdlib --native-libs target/native-libs \
  --driver-dir target/window-mesa-arm64-wgl/driver
```

The native runner still requires fresh actual GL3.3 creation, llvmpipe identity,
draw/readback, events, lifecycle and strict lint in interpreter/O0/O2. It now also
requires the probe's actual loaded opengl32 file identity to match the supplied
fresh driver file or its app-local deployed copy; a renderer label alone cannot
establish the candidate driver was loaded. The interpreter explicitly honors the
JAIC_NATIVE_LIBS source directory, so requiring only the app-local copy would be
an incorrect new test expectation. The identity regression covers both legitimate
paths and rejects an unlisted same-content file; no existing assertion is removed.
No GL/GLSL overrides or skip-as-pass paths are introduced. Native ARM64 build,
dependency checks and GL execution remain **pending the next native run**.

Local evidence: eight new installer/configuration/SDK-metadata/file-identity tests,
seven source/cache tests and one real Meson child-Python regression pass (16 total).
The new x64 COFF-header negative test proves rejection before any SDK execution;
it is deliberately non-executable metadata, not a usable driver fixture.
Installer fixtures are metadata/copy-integrity inputs only, never executed or
counted as native drivers. Public stdlib APIs and Jai sources are unchanged.
The full public application/corpus gate remains the coordinator's responsibility.

Native oracles: pinned Mesa archive and its target/DEF files; [Mesa WGL deployment](https://docs.mesa3d.org/drivers/llvmpipe.html#windows),
[Meson introspection](https://mesonbuild.com/IDE-integration.html),
[MSVC DLL dependencies](https://learn.microsoft.com/en-us/cpp/build/reference/dependents?view=msvc-170),
[Microsoft native loader](https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-loadlibraryexw).

## Prepared Python discovery correction

Authorized candidatea78721d feedback: native ARM64 LLVM source build completed;
Mesa setup failed at meson.build:933 because its `find_program('python3', 'python')`
selected hosted global python3.EXE, which lacks Mako. This is infrastructure failure,
not driver execution evidence. No raw CI log was read.

The helper now writes `native-arm64.ini` with both `[binaries] python3` and `python`
bound to the invoking venv's exact `sys.executable`, and supplies `--native-file`
to Meson setup. The venv path is preserved without symlink resolution; resolving
it on Unix would lose the venv prefix. Native execution requires a venv and
removes PYTHONHOME/PYTHONPATH inheritance; user-site packages are disabled. LLVM's
CMake Python3_EXECUTABLE is also explicit. Source-build evidence records the
actual child interpreter/prefix and Mako/PyYAML versions plus the machine-file text.
Mesa25.2.5 also requires PyYAML directly after its Mako check, so PyYAML6.0.3 is now
pinned/preflighted. No package is installed into or borrowed from global Python.

Original regression `tests/window-render/test_mesa_python.py` runs real Meson1.8.3
from a prepared venv while a real empty venv's python3 wins PATH discovery. The
unconfigured control fails; the generated machine configuration succeeds and the
child reports the exact prepared interpreter/prefix and pinned Mako/PyYAML. The
project/config paths contain spaces and an apostrophe. Local result: one test
passes on macOS; no MSVC build or Windows graphics execution is implied.

Run that test using the prepared interpreter before the native build:

```sh
python tests/window-render/test_mesa_python.py
```

The SDK/toolchain requirements below remain enforced; no SDK ABI or GL capability
override is introduced. Meson's documented [native binary configuration](https://mesonbuild.com/Machine-files.html#binaries)
applies to find_program independently of the interpreter running Meson itself.

## Verified LLVM reuse

The helper now defaults to a persistent `target/window-mesa-cache` independent
of each fresh `--out` directory. Only the installed LLVM tree is reused; parser
generators, Mesa sources/build/install and deployed driver DLLs are produced anew.
CI may persist/restore that dedicated cache directory from its own source-built
outputs. It must retain the completed receipt and every recorded file; a directory
or an older successful-status report alone is not a cache completion certificate.
Candidatea78721d predates this receipt format, so its LLVM directory is not
automatically adopted. The first build with the new helper must populate the cache.

The key covers the pinned LLVM source, exact CMake options, prepared Python/version
and package pins, toolchain versions/flags, selected compiler/linker/lib/rc/mt/
CMake/Ninja hashes (including installed package binaries/data behind launchers),
MSVC frontend directory hashes, and content hashes of selected
SDK INCLUDE/LIB trees. Windows environment names are handled case-insensitively.
SDK fingerprinting is restricted to explicit VCToolsInstallDir/WindowsSdkDir (and
NETFXSDKDir when selected), never arbitrary source or authentication directories.
Initialize the full native ARM64 vcvars environment so these SDK directories and
INCLUDE/LIB exist. External CMake toolchain-file overrides are rejected by this
native MSVC configuration; the actual cl.exe path is explicit for both languages.

After installation, actual ARM64 PE identity, LLVM20.1.8, AArch64 host/backend and
relocated installation directories are checked. Every installed file is hashed
and an atomic `complete.json` is written before Mesa setup. On reuse, configuration,
the entire file manifest and native identity/prefix are rechecked. Missing,
modified, unexpected or symbolic-link artifacts fail verification. No completed
receipt means no reuse of partial libraries. Writer locks reject concurrent or
abandoned in-progress writers; an abandoned lock needs coordinator cleanup after
confirming the original job has stopped. Corrupt completed entries fail explicitly;
remove only that dedicated cache entry before rebuilding. Cache hashes detect
stale/corrupt content; they are not authentication against a malicious cache writer.

Use a fresh output for each retry and retain the same trusted cache:

```sh
python tools/window_render_mesa_windows.py \
  --out target/window-mesa-arm64-retry \
  --cache-dir target/window-mesa-cache --jobs 4
```

Then pass **that retry's** driver directory to the native WGL runner. Nonempty
output directories are rejected, so prior DLLs/evidence cannot be mistaken for
new build output. `source-build.json` records the key, hit/miss, complete key
configuration, actual LLVM identity and each command. Hashing SDK/installed LLVM
files has a disk-I/O cost; it deliberately trades some retry time for verified
reuse instead of rebuilding LLVM. Actual Windows cache reuse remains pending;
local tests exercise content/configuration integrity, not native library execution.
Seven integrity regressions plus the real Meson child-discovery test pass locally.

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
MarkupSafe3.0.3, packaging25.0, PyYAML6.0.3. CMake/Ninja/MarkupSafe/PyYAML native ARM64 wheel availability
was checked against the public package index. For example, in the activated venv:

```sh
python -m pip install cmake==3.31.6 ninja==1.13.2 meson==1.8.3 Mako==1.3.10 MarkupSafe==3.0.3 packaging==25.0 PyYAML==6.0.3
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
