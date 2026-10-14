# Unix BuildCpp helper

The public facade defines canonical Build_Type and exact baked aliases. Public
build entrypoints are compile-time-only. Private code separates artifact building,
temporary-file ownership, tool execution and compiler reporting.

Each source is compiled to a uniquely reserved directory alongside its intended
output. C++ suffixes select CXX and other inputs select CC; explicit compiler paths
override those choices. Only the named CC, CXX and AR environment settings are
read. Empty settings fall back to `cc`, `c++` and `ar`. Values denote executable
names/paths, not shell programs. Arguments are passed individually through the
supported Process backend; no shell command is composed. Embedded NUL is rejected
in public path/argument inputs.

Object outputs are validated against the requested ELF/Mach-O target family.
Static archives and linked artifacts are written to fresh intermediate outputs
and renamed into place only after tool success. This avoids stale archive members
and preserves existing outputs on compilation/link failure. Dynamic-library
objects use PIC. Debug selects O0 plus debug information; release selects O2.
Caller flags reach compilation and non-archive linking, and library files follow
compiled objects. A C++ input selects the C++ driver for final linking.

All created intermediate files/directories are checked during cleanup. Native
tools can fail ordinarily, so private operations collect failure diagnostics and
return through cleanup before the public boundary reports a compiler ERROR.
The source compiler aborts #run immediately on that report; relying on later
defer cleanup was an implementation bug found and removed by negative tests.
No errors are downgraded or suppressed.

macOS universal builds separately compile arm64 and x86_64 in a unique directory,
combine them with lipo into a staged output, and clean the architecture artifacts.
The returned boolean includes cleanup failure. A multi-architecture `lipo
-verify_arch` invocation was rejected by the local native tool; verification now
uses one invocation per architecture and retains both checks. Archive member
tests permit the native symbol-index pseudo-member while requiring the original
second object to disappear after a smaller rebuild.

Verified artifacts include a static C archive linked into a C++ executable that
prints the expected answer, a dlopen/dlsym-loaded dynamic library returning 42,
a standalone object produced using relative paths/working_directory, extra flags
required by source #error guards, and a macOS universal dynamic library with both
architectures verified. Missing compiler, invalid C and wrong-target object tests
require real compiler diagnostics, preserved previous output and zero leftover
intermediate directories. The focused runner copies only new compiler/POSIX
dependencies into its integration tree.

Remaining limitations/contracts:

- Windows Visual Studio/SDK discovery and invocation are unimplemented; the module
  rejects unsupported hosts. Linux native execution remains unverified here.
- Cross-OS toolchains are explicitly unsupported. A native-host tool metaprogram
  is excluded from cross-target test execution; object format validation prevents
  an explicitly mismatched compiler output from being accepted as the native target.
- Output suffix policy is currently `.a`, `.o`, `.dylib`/`.so`, or none for Unix
  executables, without adding `lib`. The reviewed page does not define exact naming.
- OBJ_FILE accepts exactly one source. Static archives with library_files are
  rejected rather than embedding nested archive files. These cases need review.
- CC/CXX/AR containing wrapper commands or embedded options are unsupported.
  The exact environment parsing/tool selection policy is not established.
- Source enumeration recognizes `.c`, `.C`, `.cc`, `.cpp`, `.cxx`, `.c++`, returning
  owned strings. Native filesystem failures retain the underlying API's diagnostics;
  complete extension and partial-enumeration policies need review.
- Universal lib_path is the complete final filename. Default architecture/flag
  behavior outside the tested two architectures and lipo/tool discovery need review.
- Successful tool stdout/stderr, including warning text, are forwarded to their
  original streams. Failed output is included in the compiler ERROR after cleanup.
  Exact reference warning presentation remains unspecified.

The two early, preverification lazy typechecking failures left generated objects
under target before the reporting refactor. Their observed paths and failure are
recorded in the development deviation report; they were explicitly removed from
our own target tree. Current tests enforce clean intermediate ownership after
both success and expected tool failures.
