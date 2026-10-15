# Data/resource testing and native dependencies

All commands run from the portable-data worktree. Build source tools here:

    cargo build --offline -p jaic-cli -p jailint
    target/debug/jaic jaifmt/main.jai -O2 -exe target/jaifmt

On macOS/Linux, build official hash-pinned native C dependencies through the NEW producer tool:

    python3 tools/native_bindings/build_dependencies.py --output target/portable-data/native --library stb_image --library stb_image_resize

On Windows, the producer helper currently emits Unix library names; use the
scoped real SDK build recipe from a Visual Studio developer command prompt with
clang-cl on PATH:

    python tests/portable-data/build_windows_images.py --cpu x64

Use --cpu arm64 for an ARM64 compiler/Python host. It reuses the producer's pinned
official stb fetch/validation, writes actual DLLs/import libraries under this
worktree's target, and changes no shared manifest. This recipe is prepared and
syntax-checked, not native-executed here. The runner supplies its native DLL path.
Both direct ICO and filename loading now require native resize linkage.
No global dependency manifest changes are required. Set JAIC_NATIVE_LIBS to that
absolute directory for filename decoder builds/interpreter execution. The scoped
runner does this automatically, generates original BMP fixtures, and requires
existing native tools/dependencies rather than substituting a decoder:

    python3 tests/portable-data/run.py

The runner verifies real jaifmt check idempotence, strict lint, interpreter,
native O0/O2, compiled WASI for portable non-stb cases, and unused-code target
checks. Desktop source checks cover x64 and ARM64 separately. Windows-only sources have a separate explicit Windows lint manifest and
x64/ARM64 checks; the runner does not pretend they execute on other targets.
Host native evidence is macOS ARM64. SDK tools llvm-rc and lld-link are required
for resource interoperability. Independent Python consumers inspect public
package/CSV wire formats and SDK .res output. No assertions are disabled.

Artifacts/logs/manifests live under target/portable-data. Successful current
runner output ends with scoped success and the explicit unverified native
Windows limitation. Narrow resize/manifest/grouping/path literal
questions remain in the questions document; passing these original tests does
not settle missing reviewed contracts.

Coordinator integration plan: transfer only scoped stable commits; provide native
stb libraries via existing JAIC_NATIVE_LIBS packaging, run the same portable suite
and native Windows resource readback on Windows, and run native Windows discovery/positive Icon attachment before treating native
platform verification as complete. Full corpus,
ordinary CI and release publication remain coordinator owned.

Unsupported image-target probe: python3 tests/portable-data/run.py --probe-unsupported-wasi-images
This intentionally reports actual missing stb imports and returns nonzero; it is
not part of reviewed supported-target completion. No fallback imports are used.

On Windows the scoped runner also executes resource/public-discovery tests at
O0/O2 and invokes the unchanged real +Icon compiler CLI, followed by independent
Win32 SDK resource readback. These conditional Windows commands are prepared but
not executed on this macOS host. They must pass on Windows before native support
is considered verified.
