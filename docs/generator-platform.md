# Generator platform helpers

All ten assigned public names are implemented, including both overloads of
ensure_local_libclang_exists. Public signatures and canonical records come from
the reviewed bindings-generator spec; the 2026-10-15 behavior batch supersedes
the first checkpoint's independent discovery/link policy.

## Reviewed behavior

find_lib_for_foreign_name reads the active context.generator, scans its canonical
Generator.libraries in order and returns the first symbol match, including
LINK_ALWAYS libraries. init/run activation and primitive initialization belong
to their owner. Deinit must not clear/restore the pointer; callers manage context
and record lifetime. No private generator stack or lifecycle registry is added.

os_get_symbol_names_from_file_fixed_and_cached uses exact (OS, CPU, full_path)
keys, caches only success and has no automatic invalidation. Apple-target symbol
names lose one leading underscore. A miss returns caller-owned strings/array and
stores independent copies; a hit returns borrowed cache storage, whose mutation
affects subsequent hits. The single public library_symbol_cache stores canonical
Library_Symbols records. Private allocator metadata retains the first default
allocator for persistent cache storage, so temporary caller allocation does not
invalidate cache entries.

get_libc_paths returns include roots: Linux generic and architecture-specific
roots, Android unified NDK and architecture-specific roots, or the Apple SDK
usr/include root in both outputs. Unsupported OS/CPU values return empty/false.
Returned path strings are independently owned, including the identical Apple
paths. Missing configured directories diagnose and fail.

ensure_local_libclang_exists(source_path) asserts a present source file, compares
mtime and size with its basename in the current directory, and copies when absent,
older or differently sized. It neither validates library exports nor returns a
status. Copy failures diagnose. The no-argument overload selects the corresponding
Windows/macOS/Linux bundled file and asserts otherwise. In this clean build, the
bundle convention is the installed official SDK file configured under the existing
private clang-bindings directory; source-build setup creates that SDK link.
No original/reference binary is used. The earlier validated-link behavior was
replaced, not retained as an undocumented alternate overload.

fix_macos_foreign_name removes one underscore for macOS/iOS TARGET_OS and returns
a borrowed suffix view; retain an owned input's original pointer when freeing it.
The missing-library predicate tests the canonical Function.library pointer; null
input is missing. No extra virtual/inline/bridge exception is claimed reviewed.

## Independent implementation policies

Uncached object symbol strings and arrays are caller owned. Official llvm-nm
handles object formats; exported names are unique, sorted and retain object
spelling. File-content enumeration uses an exclusively created temporary file
and removes it on every normal exit. Its full_path is diagnostic only and never
overwritten. Malformed input/tool failures diagnose; no empty result is fabricated.
The tool text protocol supports ordinary linker identifiers, not embedded-newline
names. Thin archives with external member paths may fail after content staging.

Library loading searches exact spelling then suffix candidates, the supplied
library path then search paths in order. Shared libraries use the native loader.
Static archives use LLVM symbols normalized to foreign spelling on Apple targets.
Library_Info, its strings and static symbol arrays are owned independently;
native handles stay live until callers close them through the OS API.

Apple include discovery uses xcrun --sdk macosx/iphoneos --show-sdk-path, or the
explicit DEVELOPER_TOOLS_APPLE_SDK_ROOT. Linux uses /usr/include and the GNU
x86_64/aarch64 include subdirectory, optionally under DEVELOPER_TOOLS_LINUX_SYSROOT.
Android uses ANDROID_NDK_HOME/ANDROID_NDK_ROOT and its unified prebuilt sysroot.
These are documented installed-SDK selection policies, not claims of exact
historical installation paths.

The model owner's Generator/Token_Info/Library_Symbols source is integrated
verbatim from authorized clean commit 4675c90a. One parameterless private context
module owns the opaque context.generator slot across TARGET_OS imports; a consumer
casts the active pointer to its own canonical Generator. Callers activate the
matching module instance. This private storage choice does not claim a reviewed
reflected Context field type. The owner-coordination record is worker-inbox.md.
The test-only nested-session probe is feasibility evidence and is not production
activation.

## Evidence and integration

Run python3 tools/build_generator_platform.py, then
python3 tools/check_generator_platform.py. Actual interpreter/Mac O0/O2 checks cover
all assigned names, live library calls, original Mach-O/ELF/COFF/archive symbols,
malformed bounds, cache key/ownership/mutation/no-invalidation, temporary-allocation
survival, real Mac SDK roots, configured Linux/Android/Apple directory selection,
and libclang basename/mtime/size copying including real official SDK bytes.
All six desktop OS/CPU combinations receive source checks; Windows native shim
cross-compilation is separate evidence, not Windows execution. Formatting and full
warnings-denied module/fixture lint pass with the compiler-owned general ordering
repair from e9affab7 (locally integrated as 3cecb481), not the overlapping model fix.

The combined suite still stops at bindings-macros.jai:43: the callback model loses
the specific rejection reason for a null native evaluation result. The
[original SDK/FFI reduction](generator-platform-macro-cause.md) reports the exact
cause to stdlib-tools without changing the gate. No combined-green claim is made.

Official delegation documentation:
[llvm-nm](https://llvm.org/docs/CommandGuide/llvm-nm.html),
[libclang](https://clang.llvm.org/docs/LibClang.html). SDK execution does not certify
equivalence to the public LIBCLANG_VERSION21 constant.
