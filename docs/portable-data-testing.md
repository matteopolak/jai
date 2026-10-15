# Data/resource testing and native dependencies

All commands run from the portable-data worktree. Build source tools here:

    cargo build --offline -p jaic-cli -p jailint
    target/debug/jaic jaifmt/main.jai -O2 -exe target/jaifmt

Build official hash-pinned native C dependencies through the NEW producer tool:

    python3 tools/native_bindings/build_dependencies.py --output target/portable-data/native --library stb_image --library stb_image_resize

No global dependency manifest changes are required. Set JAIC_NATIVE_LIBS to that
absolute directory for filename decoder builds/interpreter execution. The scoped
runner does this automatically, generates original BMP fixtures, and requires
existing native tools/dependencies rather than substituting a decoder:

    python3 tests/portable-data/run.py

The runner verifies real jaifmt check idempotence, strict lint, interpreter,
native O0/O2, compiled WASI for portable non-stb cases, and unused-code target
checks. Windows-only sources have a separate explicit Windows lint manifest and
x64/ARM64 checks; the runner does not pretend they execute on other targets.
Host native evidence is macOS ARM64. SDK tools llvm-rc and lld-link are required
for resource interoperability. Independent Python consumers inspect public
package/CSV wire formats and SDK .res output. No assertions are disabled.

Artifacts/logs/manifests live under target/portable-data. Successful current
runner output ends with scoped success and the explicit unverified native
Windows limitation. ICO fixed-frame compatibility and narrow subtitle/package
boundaries remain in the questions document; passing these original tests does
not settle missing reviewed contracts.

Coordinator integration plan: transfer only scoped stable commits; provide native
stb libraries via existing JAIC_NATIVE_LIBS packaging, run the same portable suite
and native Windows resource readback on Windows, and resolve public ID/plugin/
frame policies before treating five-module completion as achieved. Full corpus,
ordinary CI and release publication remain coordinator owned.
