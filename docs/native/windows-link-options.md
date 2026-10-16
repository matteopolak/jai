# Windows build-option forwarding

`Compiler.Build_Options.additional_linker_arguments` supplies argument tokens.
The compiler does not shell-split them, remove quoting characters, or combine
multiple input files. The backend now routes Windows LINK switches through the
selected compiler driver and translates supported PE options for GNU linkers.

| Selected tool/target | Argument boundary |
| --- | --- |
| `link.exe` / `lld-link` | Existing LINK arguments remain unchanged. |
| GNU-style Clang, MSVC target | Recognized LINK switches use separate `-Xlinker` tokens. |
| MinGW GCC/Clang | Supported LINK switches become GNU PE options, passed with `-Xlinker`. |
| `clang-cl`, MSVC target | Compiler inputs/options precede `/link`; native linker arguments follow it. |

Explicit Clang `--driver-mode=cl`, `gcc` and `g++` overrides select the same
boundary as the actual driver. Already explicit `-Xlinker`/`-Wl,` forwarding and
compiler-option operands keep their intended boundaries. Relative order within
each tool's arguments is preserved. In particular, library paths containing
spaces or commas are a single argument; implicit forwarding uses `-Xlinker`
rather than introducing comma splitting through `-Wl,`.

For MinGW, raw `/SUBSYSTEM`, `/ENTRY`, `/STACK`, `/HEAP`, `/BASE`, `/INCLUDE`,
`/LIBPATH`, `/OUT` and `/DLL` have GNU equivalents. Subsystem version syntax
`windows,6.2` becomes `windows:6.2`; entry-symbol case and path bytes are retained.
Other recognized LINK switches without an implemented GNU equivalent produce an
explicit unsupported-translation diagnostic. They are not silently ignored or
accepted as filenames. Callers may supply explicit target-native GNU options.
Unknown inputs retain the tool's own diagnostics. Native MSVC switches are not
translated when the actual linker consumes LINK syntax.

The driver boundaries follow the official [Clang argument reference](https://clang.llvm.org/docs/ClangCommandLineReference.html)
and [clang-cl manual](https://clang.llvm.org/docs/UsersManual.html#clang-cl).
PE equivalents follow the [GNU linker option documentation](https://sourceware.org/binutils/docs/ld/Options.html).

An explicit Clang `JAIC_LINKER` override now receives the selected MinGW target,
as it already did for an MSVC target. Cross GCC drivers retain their own built-in
target. MSVC SDK discovery, CRT defaults, physical DLL/import-archive providers,
library selection, and linker option precedence are otherwise retained.

## Independent evidence

The baseline source-built compiler rejects the new public build-options fixture
with `/SUBSYSTEM:windows` and `/ENTRY:mainCRTStartup` treated as input filenames.
The repaired compiler cross-links that fixture using both the installed x64
MinGW GCC CRT toolchain and Clang with the matching SDK/sysroot. The resulting
real PE files have `IMAGE_SUBSYSTEM_WINDOWS_GUI` and a nonzero entry address.
Output paths contain spaces. No Windows program was executed on the Mac host.

The independent C controls in
`tests/cleanroom-language/windows-link-options/{entry,helper}.c` require both
object inputs and no CRT. Actual LLVM tools cross-linked six PEs: x64 and ARM64
through GNU Clang, MSVC-target Clang and clang-cl. Their real PE headers confirm
target architecture, GUI subsystem and entry address. These controls establish
driver/linker syntax and COFF linkage, **not MSVC SDK/CRT or Windows runtime
execution**. Use `-fuse-ld=lld` for these installed LLVM drivers; the initial
absolute `-fuse-ld` attempt failed and is retained in the captures.

Eight original argument-rendering regressions cover driver modes, direct LINK,
GNU translations, unsupported switches, compiler-only options/operands, slash
paths, commas, spaces, multiple inputs and stable argument order. The whole
backend library suite has 25 passing tests. Run:

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= \
  cargo test --locked -p jaic-llvm --lib
JAIC_LINKER=x86_64-w64-mingw32-gcc jaic \
  tests/cleanroom-language/windows-link-options/main.jai -os windows -cpu x64
```

Use an isolated T7 Cargo target and TMPDIR for local verification. Captures and
exact source/build identity are linked by
[the status receipt](../status/windows-link-options.json).

## Remaining qualifications

Windows x64/ARM64 CI must rerun the unchanged `portable-data-console-windows`
program and native MSVC/MinGW link/runtime gates. ARM64 CRT/SDK execution was not
available here. No Console functionality, assertions or target guards changed.
The separately reported generated Windows path-string hex-escape failure still
needs a minimal independent input, generating API/source kind and first diagnostic
from root. No printer change is inferred from that report.

Initial source-only clippy/format checks accidentally omitted the accepted root
toolchain/format configuration and compile-time fixture inputs from the
isolated build copy. Their failures are preserved. The final checks use the
exact accepted configuration and inputs; no production lint suppression or
unrelated formatting changes were introduced.
