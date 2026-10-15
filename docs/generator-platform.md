# Generator platform implementation plan and policy

Implement the assigned facade over independent private internals; retain canonical
Library_Info and native declarations. Delegate object formats to installed official
LLVM tools and live symbol lookup to the native loader.

Batches: original C/object fixtures and failing public tests; file/content symbols
and native loading; installed-libclang discovery and foreign-name predicates;
interpreter/native O0/O2, formatting, strict lint and local checkpoint commit.

[Contract dependencies](specs/questions/generator-platform.md) track missing
canonical generator/cache state and unresolved libc-path meanings.

Uncached symbol strings and arrays are caller owned. Enumerate defined external
symbols in exact object spelling, unique and sorted by LLVM's export-symbol mode. Malformed objects,
tool failures and nonempty diagnostics fail visibly. Content is staged in an
exclusively created temporary file removed on exit; full_path is diagnostic only.

Loading searches exact spelling before suffix candidates, library_path then paths
in order. Shared libraries use the native loader; static archives use LLVM symbols.
Returned Library_Info, strings and array are caller owned. Native handles remain
live until callers close them through the OS API. No extra registry is introduced.

`fix_macos_foreign_name` changes the supplied string to a borrowed suffix view;
retain the original allocation when freeing an owned input. The missing-library
predicate tests the Function's canonical library pointer without resolving it.

Libclang discovery validates createIndex, parseTranslationUnit2 and getClangVersion
exports. A usable existing configuration is retained, including when an explicit
source is supplied. Otherwise no-argument discovery tries the configured SDK
prefix and the native loader name, then creates a non-overwriting symbolic link.
Explicit source names a library file; failures diagnose. Windows symlink creation
requires OS support/privilege and fails visibly when unavailable.

Run `python3 tools/build_generator_platform.py` before using the helpers, then
`python3 tools/check_generator_platform.py` for original object/library effects,
actual interpreter/Mac O0/O2, integrated warnings-denied lint and formatting.
Six desktop OS/CPU combinations receive source checks; Windows/Linux are not
executed. Object enumeration requires the configured official llvm-nm executable.
The text export protocol cannot represent embedded newlines in symbol names;
this implementation supports ordinary linker identifiers. Thin-archive content
that refers to external member paths may fail after temporary staging and is not
claimed self-contained. No malformed-object success or placeholder list is supplied.

Official documentation: [llvm-nm](https://llvm.org/docs/CommandGuide/llvm-nm.html),
[libclang](https://clang.llvm.org/docs/LibClang.html). SDK execution does not certify
equivalence to the public LIBCLANG_VERSION21 constant.

## Verified checkpoint and remaining scope

Implemented seven of ten assigned names (eight reviewed overloads):
ensure_local_libclang_exists (both), os_get_symbol_names_from_file,
os_get_symbol_names_from_file_content, os_load_library,
os_symbol_exists_in_library, fix_macos_foreign_name,
function_is_missing_foreign_library. All execute in the dedicated Mac suite.
The C host shim also compiles against the official MinGW x64 SDK with warnings
denied; Windows execution is not claimed.

Remaining: find_lib_for_foreign_name requires canonical Generator context;
os_get_symbol_names_from_file_fixed_and_cached requires canonical public cache
state and its lifetime/normalization policy; get_libc_paths needs the meaning of
its two path results. Exact questions and notification are in the linked question
file and worker-inbox.md. No stubs or alternative canonical state were added.

Combined tools/check_developer_tools.py reaches an existing string-macro callback
diagnostic mismatch at bindings-macros.jai:43. It reproduces with this facade
unloaded. Thus the dedicated scope passes, while the full combined suite is not
green; the reduced public-API probe and owner notification are retained locally.

## Canonical model integration

The single Generator, Token_Info and Library_Symbols declarations are integrated
verbatim from model owner's explicitly authorized clean commit 4675c90a, file
generator-state.jai. The obsolete Windows-only Library_Symbols declaration is
removed. module.jai loads generator-state directly until the model owner's facade
is combined; then retain its load and remove this direct load.

Original canonical tests execute pointer identity through Generator.libraries,
Token_Info storage, zero defaults, and real native-cursor Hash_Table callbacks in
the interpreter and Mac O0/O2. All six desktop branches are source checked. This
supplies the shared model dependency without introducing a second cache/registry.
Context activation and the single cache lifetime are still with stdlib-tools/model
owner; a save/restore nested-session proposal is recorded in worker-inbox.md.
