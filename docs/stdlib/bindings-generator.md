# Bindings_Generator

## What it is

`stdlib/Bindings_Generator` turns C (and a little C++) headers into Jai declarations: constants from `#define`s, enums, structs, unions, typedefs, function-pointer types and `#foreign` procedures. The public API follows the reference module: fill in a `Generate_Bindings_Options`, optionally set a `visitor`, call `generate_bindings(opts, "out.jai")`. Metaprograms such as `Vk-Engine/Modules/{Vulkan,ImGui}/generate.jai` run unchanged.

## How it works

1. `generate_bindings` (`generate.jai`) builds a `Generator_State` (stored in `context.generator`, options in `context.generator_options`), resolves the requested libraries, and asks libclang to parse a synthetic `generate_temp.h` that `#include`s each entry of `source_files`.
2. `convert.jai` walks the translation unit and builds the declaration model of `types.jai` (`Declaration`, `Function`, `Struct`, `Enum`, `Typedef`, `Namespace`, `Bitfield`, `CType`, `Literal`...). Declarations from system headers are skipped unless `path_fragments_to_treat_as_non_system_paths` or `system_types_to_include` whitelist them; system typedefs (`uint32_t`, `size_t`...) are unwrapped to primitives. Macros are kept only when their body is a constant expression over literals and already-known constants.
3. `post_process` converts macros to enums (`generate_enums_from_macros_with_prefixes`), assigns functions to libraries, then the user `visitor` runs over every declaration (it may set `decl_flags`, rename `output_name`, swap types, add default values), followed by `omit_unnecessary_typedefs_and_macros`.
4. `print.jai` prints the model. Enum values are prefix-stripped (`auto_detect_enum_prefixes`), original names stay as aliases, unions print as `union`, bit fields as a `__bitfield` storage member with a comment, C++ reference parameters become pointers with a value-taking `#no_context` wrapper when they have defaults, and printf-like variadics get a `_CFormat` foreign declaration plus a Jai `string` wrapper.

Library assignment: each `libraries` / `libnames` entry is located (search paths, then `lib` prefix and `.dylib/.so/.dll/.lib/.a` suffixes) and its exported symbols read with `nm -g`. A function binds to the first library exporting its symbol. If a library file cannot be found it is treated as "unknown": unresolved functions are assigned to the first unknown library and a note is logged; otherwise, with `SYMBOLS_WITH_UNKNOWN_FOREIGN_LIBS` set, a function found in no library is stripped.

### Why libclang goes through a Rust bridge

The interpreter's `#foreign` calls pass scalars only. libclang passes and returns `CXCursor`/`CXType` structs by value and drives traversal with a native callback (`clang_visitChildren`). So `crates/jaic/src/clang.rs` loads libclang itself and exposes it as the `__jaic_clang(op, a, b, text)` / `__jaic_clang_text()` primitives. Cursors and types are stored in arenas and handed to Jai as integer handles; equal cursors get equal handles (usable as hash keys). `stdlib/Bindings_Generator/clang.jai` wraps this (`clang("kind", cursor)`...). All AST logic is Jai; Rust only forwards calls and collects children.

## How to change it

- New libclang query: add a function pointer to `Api` and a match arm in `clang::call` (`crates/jaic/src/clang.rs`), then call `clang("op", ...)` from Jai.
- New C construct: handle its cursor kind in `handle_toplevel_cursor` / `fill_struct_members` / `create_type` (`convert.jai`) and print it in `print.jai`.
- Output format lives entirely in `print.jai`; `maybe_add_spacing` reproduces the blank lines of the source.
- Gotchas: every `create_type` call returns a fresh `CType` (visitors mutate them) except the primitive singletons (`type_def_*`); a struct is registered in `declarations_by_cursor` before its members are converted so recursive types terminate; the `#add_context` fields mean generator code must run inside `generate_bindings`.
- Limitations: C++ support is minimal (namespaces, plain structs, free functions with defaults; no methods, templates, inheritance, vtables); no Objective-C; bit fields are opaque storage; extern variables are bound with `#foreign` only when a library is known; `long double` and 128-bit integers are approximated.

## Configuration

`Generate_Bindings_Options` mirrors the reference fields (`include_paths`, `source_files`, `extra_clang_arguments`, `flatten_namespaces`, `strip_prefixes`, `strip_flags`, `visitor`, `get_func_args_for_printing`, `header`/`footer`, `generate_library_declarations`, ...). Both library spellings work: `libnames`/`libpaths` and the older `libraries` (`.{filename=..., identifier=...}`) with `library_search_paths`. Extra field: `libclang_path`.

libclang search order: `Generate_Bindings_Options.libclang_path`, the `JAI_LIBCLANG` environment variable, `/Library/Developer/CommandLineTools/usr/lib`, the Xcode toolchain, `/opt/homebrew/opt/llvm/lib`, `/usr/local/opt/llvm/lib`, `/usr/lib*` (including `llvm-*`), then the system loader. A Homebrew LLVM can be used without linking it: `JAI_LIBCLANG=/opt/homebrew/opt/llvm/lib/libclang.dylib`. On macOS the SDK is passed as `-isysroot $(xcrun --show-sdk-path)` unless the options already contain `-isysroot`. Libraries shipped under `reference/` are never used.

## Dependencies

libclang (any recent LLVM; tested with the Xcode Command Line Tools copy), `nm` for library symbol tables, `xcrun` on macOS, and the stdlib modules `Basic`, `String`, `File`, `Hash_Table`, `Process`. Tests: `tests/stdlib/bindings-generator-c.jai`, `bindings-generator-cpp.jai`, `using-member-default-override.jai` (struct-body `member = value;` overrides, needed by the declaration model).
