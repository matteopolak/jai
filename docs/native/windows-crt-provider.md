# Windows CRT provider identity

The admitted completed Windows job 117243082265 reports `Crt.dll` missing
while interpreting args-process, generator platform operations, and Linux-link
tooling. These are real required failures, not unsupported-platform cases.

The reviewed Windows page specifies four procedures with `#foreign Crt`:
`_beginthreadex`, `_endthreadex`, `getenv`, and `_wgetenv`. It does not specify
a physical `Crt.dll` or a library declaration. The independently authored
generator previously fell back from the identifier `Crt` to the same literal
native basename. That produced a nonexistent provider request.

The private generator mapping now selects `ucrt`, the actual Windows SDK
dynamic import-library basename. The private `Crt` declaration, public procedure
names/signatures, and the entire declaration body remain otherwise unchanged.
This is a documented implementation choice from SDK evidence, not a claim about
an unspecified original implementation's CRT selection.

[Microsoft's CRT library table](https://learn.microsoft.com/en-us/cpp/c-runtime-library/crt-library-features?view=msvc-170)
identifies `ucrt.lib` as the dynamic UCRT import library. `libucrt.lib` is static;
the MSVC `msvcrt.lib` is a startup archive, not a substitute DLL import library.
Do not rename one of those files to `Crt.lib`, produce a replacement DLL, or add
a global interpreter fallback. The current compiler already searches real SDK
LIB directories and resolves the import archive's per-symbol provider metadata.

## SDK evidence

Official NuGet packages `Microsoft.Windows.SDK.CPP.{x64,arm64}` version
`10.0.26100.6584` supply the inspected `c/ucrt/<cpu>/ucrt.lib` archives.

| CPU | Package SHA-256 | Archive SHA-256 |
| --- | --- | --- |
| x64 | `c29ce7a4641cb37ee32ebb8078cc65cfbabc7025076bcfba869039204b1e960d` | `7ef4eac926bf597d2f243f16cdfed7e0db22cb3ca34a1d7e088a84c994a03d66` |
| ARM64 | `ac06922186fdd75e4ff1033a304ea629d7917bd0ca85e483762f8109584ccfc4` | `c2c1328647f4454f71a68e8e194f89eef7d3fdf2661192ab8d87fba395ee13fa` |

Both actual archives contain native-target short import records for all four
procedures. `_beginthreadex` and `_endthreadex` select
`api-ms-win-crt-runtime-l1-1-0.dll`; the two environment procedures select
`api-ms-win-crt-environment-l1-1-0.dll`. ARM64EC records also occur in the ARM64
archive; the proof separately requires all four ordinary ARM64 records. Static
LLVM metadata inspection does not execute these SDK libraries.

Own evidence directory:
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/bindings/windows-crt-provider`.
`verification.json` pins commands, logs, compiler/linter identities, source
guards, and the archive-derived records. Seven command invocations passed:
one invocation containing three source contract tests, Ruff check/format, and
source-check/strict-lint pairs on both Windows CPUs.

## Required native replay and remaining closure

`tests/native-bindings/windows-crt-provider.jai` calls the public environment
APIs against the real Windows process's `SystemRoot`. It preserves CRT ownership
of returned strings. It starts a real CRT thread, checks its shared write, waits,
requires the exit code set by `_endthreadex`, and closes its handle. Its local
SDK declaration of `GetExitCodeThread` adds no public library export.

Run this fixture with the matching producer's interpreter and native O0/O2 on
actual Windows x64/ARM64, with the selected SDK UCRT LIB directory available.
The source-only checks here cannot prove loading, callback execution, cleanup,
or interpreter/native resource identity. Original failed job records remain
failed until actual replay. Jai formatter execution is queued behind the held
integration native lease; no formatter pass is claimed. No SDK or target-program
execution, GUI, or fault test was performed in this batch.

Two separate required providers remain open:

| Request | Current causal boundary | Handoff owner/action |
| --- | --- | --- |
| `ffi` | The varargs module requires `ffi` with `link_always`; the general native package manifest has no ffi entry. The existing bindings helper builder links `binding_ffi` with `-lffi` using a Unix-only build path. | Integration/native provider owner must provision actual target libffi plus the real bridge, retain genuine import archives and stage their dependent DLLs. Do not remove the required library directive to conceal the gap. |
| `../internal/developer-tools/clang-bindings/clang` | Generated canonical declarations use this library path, but `build_developer_bindings.py` explicitly supports only macOS/Linux. The native tools manifest says the same. | Generator owner must supply a Windows-capable SDK/libclang build/package and matching dependency/import-library manifest at the canonical private directory. Retaining import archives alone cannot create absent providers. |

The shared inbox requests the exact clean producer paths and hashes from the
generator owner. No ready Windows ffi/libclang closure has been received or
claimed by this batch. Integration owns the common builder, package catalogue,
runtime search/deployment wrapper, and workflow wiring; these were not edited.
README owner: please index this report under native bindings.
