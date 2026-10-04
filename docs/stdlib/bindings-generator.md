# Bindings_Generator

## What it is

`stdlib/Bindings_Generator` turns C, C++ and Objective-C headers into Jai declarations: constants from `#define`s, enums, structs (with bit fields), unions, typedefs, function-pointer types, `#foreign` procedures, C++ classes, and Objective-C classes/protocols as message-send wrappers. The public API follows the reference module: fill in a `Generate_Bindings_Options`, optionally set a `visitor`, call `generate_bindings(opts, "out.jai")`. Metaprograms such as `Vk-Engine/Modules/{Vulkan,ImGui}/generate.jai` run unchanged.

## How it works

Running it: write a small program (usually the project's `generate.jai`) that fills in the options and calls `generate_bindings`, then run it with `jaic run`. It needs libclang on the machine (see Configuration).

```jai
#import "Basic";
#import "Bindings_Generator";

main :: () {
    opts: Generate_Bindings_Options;
    array_add(*opts.source_files, "mylib.h");
    array_add(*opts.include_paths, ".");
    array_add(*opts.libnames, "mylib");
    assert(generate_bindings(opts, "mylib.jai"));
}
```

```sh
jaic run generate.jai            # writes mylib.jai
jaic check generate.jai -os linux   # generators for another OS's headers
```

A complete worked example, including `visitor` use and output assertions, is `tests/stdlib/bindings-generator-c.jai` (`jaic run tests/stdlib/bindings-generator-c.jai`; it writes into `/tmp`).

The pipeline:

1. `generate_bindings` (`generate.jai`) builds a `Generator_State` (stored in `context.generator`, options in `context.generator_options`), resolves the requested libraries, and asks libclang to parse a synthetic `generate_temp.h` that `#include`s each entry of `source_files`.
2. `convert.jai` walks the translation unit and builds the declaration model of `types.jai` (`Declaration`, `Function`, `Struct`, `Enum`, `Typedef`, `Namespace`, `Bitfield`, `CType`, `Literal`...). Declarations from system headers are skipped unless `path_fragments_to_treat_as_non_system_paths` or `system_types_to_include` whitelist them; system typedefs (`uint32_t`, `size_t`...) are unwrapped to primitives. Macros are kept only when their body is a constant expression over literals and already-known constants.
3. `post_process` converts macros to enums (`generate_enums_from_macros_with_prefixes`), assigns functions to libraries, then the user `visitor` runs over every declaration (it may set `decl_flags`, rename `output_name`, swap types, add default values), followed by `omit_unnecessary_typedefs_and_macros`.
4. `print.jai` prints the model. Enum values are prefix-stripped (`auto_detect_enum_prefixes`), original names stay as aliases, unions print as `union`, bit fields as a `__bitfield` storage member plus `S_get_x`/`S_set_x` accessors (see "Bit fields"), C++ reference parameters become pointers with a value-taking `#no_context` wrapper when they have defaults, and printf-like variadics get a `_CFormat` foreign declaration plus a Jai `string` wrapper.

Library assignment: each `libraries` / `libnames` entry is located (search paths, then `lib` prefix and `.dylib/.so/.dll/.lib/.a` suffixes) and its exported symbols read with `nm -g` (output captured directly with `run_command(..., capture_and_return_output = true)`). A function binds to the first library exporting its symbol. If a library file cannot be found it is treated as "unknown": unresolved functions are assigned to the first unknown library and a note is logged; otherwise, with `SYMBOLS_WITH_UNKNOWN_FOREIGN_LIBS` set, a function found in no library is stripped.

### Why libclang goes through a Rust bridge

The interpreter's `#foreign` calls pass scalars only. libclang passes and returns `CXCursor`/`CXType` structs by value and drives traversal with a native callback (`clang_visitChildren`). So `crates/jaic/src/clang.rs` loads libclang itself and exposes it as the `__jaic_clang(op, a, b, text)` / `__jaic_clang_text()` primitives. Cursors and types are stored in arenas and handed to Jai as integer handles; equal cursors get equal handles (usable as hash keys). `stdlib/Bindings_Generator/clang.jai` wraps this (`clang("kind", cursor)`...). All AST logic is Jai; Rust only forwards calls and collects children.

### C++ support

Everything below is learned from the behaviour of the reference generator, not copied from it.

- **Methods**: members are printed inside the struct as `name :: (this: *T, ...) -> R #cpp_method #foreign lib "mangled";`. `const T&` parameters become `*T` plus a `#no_context` value wrapper (defaults live on the wrapper). Static methods have no `this`; static `const` data members with a value become struct constants.
- **Constructors / destructors**: `Constructor`, `CopyConstructor`, `MoveConstructor`, `Destructor` (D1), `Destructor_Base` (D2). Manglings come from `clang("manglings", cursor)` so the C1/C2 and D0/D1/D2 variants are real symbols. `#cpp_return_type_is_non_pod` is printed for functions returning a type with a constructor, copy/move constructor or destructor.
- **Virtuals**: virtual methods print as `virtual_<name>` in a comment-headed section (usable to call a parent implementation). `X_VTable :: struct #type_info_none` lists the entries in vtable order (D1 then D0 for the destructor), followed by C-style `X_name :: inline (this: *X, ...)` wrappers and `vtable :: (obj: *X) -> *X_VTable` when `generate_vtable_helpers` is on. A derived class overlays the vptr with `#place base; x_vtable: *X_VTable;`.
- **Inheritance**: `#as using base: Base;` for the first base; later bases are plain members. Derived vtables embed the parent vtable with `using`.
- **Templates**: class templates print as `struct(T: Type)` (non-type parameters keep their C type), instantiations as `Box(s32)`. libclang reports dependent types as "Unexposed", so they are recovered from placeholder structs, `TypeRef`/`TemplateRef` children and (for non-type arguments) the type spelling (`create_unexposed_type`, `fill_template_arguments` in `convert.jai`). Explicit specializations are skipped.
- **Operators**: binary operators Jai can overload print as `operator+ :: ...` after the struct; others get names like `operator_not_equals`.
- **Default arguments**: temporaries (`T(a, b)`, `T()`, `{}`) print as `T.{...}`, null casts and `NULL`/`nullptr` as `null`, bool literals as `true`/`false`.
- **Macros**: surrounding parentheses are stripped (`(4)` -> `4`); macros naming a type or `int`/`void` (`#define X ImWchar`) and casts to a named type (`((ImGuiID)0)` -> `cast(ID) 0`, `cast,trunc(ID) -1` before `-`/`~`) are resolved after all declarations exist (`NEEDS_CHECKING` in `post_process`).
- **Known gaps**: inline functions are bound only when the library exports their symbol (a header-only inline method has none), so bind against the built library. Tail padding is handled for classes with a single base (see "Tail padding and `__RAW` structs"); with several bases or a template base the generator still adds a comment and sets `NO_STRUCT_CHECKS`.

Compiler support the generated code relies on:

- `#cpp_method` implies the C calling convention and no context, for procedure literals and procedure types (so vtable entries are called correctly). `#cpp_return_type_is_non_pod` sets `ProcType.non_pod_return`; the IR sets `CAbi.ret_indirect`, and `interp/native.rs::call` then returns the aggregate through the hidden result pointer even when it would fit in registers. By-value struct arguments and results otherwise use the shared classifier (`crates/jaic/src/abi.rs`).
- libclang bridge ops added for this: `is_virtual`, `is_pure_virtual`, `is_const_method`, `is_copy_ctor`, `is_move_ctor`, `is_inlined`, `access`, `manglings`, `specialized_template`, `t_template_arg`.

Verification against real headers (scratch copies of the Vk-Engine generators run with `jaic check generate.jai -os linux`): Vulkan-Headers 1.3.250 + VMA produced 651 functions / 902 structs / 250 enums; Dear ImGui 1.90.4-docking produced 1143 functions / 121 structs / 78 enums, and the output type-checks and drives a real frame (`CreateContext`, `Style.Constructor`, `NewFrame`, `Begin`, `Render`) against a dylib built from the same sources.

### Bit fields

- `fill_struct_members` / `finish_bitfield` (`convert.jai`) merge adjacent bit fields into one `Bitfield` (a zero-width field ends the run; in a union each field is its own run). The storage is an unsigned integer of exactly the bytes clang laid out, or `[N] u8` when the run is not naturally aligned for that size. `Bitfield.start_byte`/`byte_count` record the span, and padding before the run is absorbed.
- The widest declared type among the members is the C alignment of the run. When the other members do not already give the struct that alignment, `print_bitfield_alignment_helper` prints `#place first_member; name_alignment: <type>;`. A run with a single member prints as that member (`flag: u8; /* 1 bits */`).
- Accessors (`generate_bitfield_accessors`, default on): `S_get_x :: (s: *S) -> T` and `S_set_x :: (s: *S, value: T)` read/write by absolute bit offset (little endian), sign-extending signed fields; setters truncate to the field width. Unnamed fields, fields over 64 bits and fields of nested anonymous structs get none.
- Gotcha: the layout follows the Itanium/AAPCS64 rule that a field does not straddle its declared type's unit; MSVC layout is not modeled.

Test: `tests/stdlib/bindings-generator-bitfields.jai` (C reads and writes the same structs; includes a Vulkan-style 24/8/24/8 instance).

### Tail padding and `__RAW` structs

Under the Itanium C++ ABI a derived class can put its fields into the tail padding of a non-POD base, but a Jai struct member always keeps its padding. `mark_tail_padding_bases` (`print.jai`, run before printing) finds a class with one base whose first own field starts before the base's `sizeof`, and marks that base `NEEDS_RAW`. The base is printed as a wrapper embedding its data, plus the data struct:

```
Viewport :: struct {
    using viewport__raw: Viewport__RAW;
    <methods, constants, nested types>
}
Viewport__RAW :: struct {
    <vptr, bases, data members, explicit __paddingN: [k] u8 gaps>
} #no_padding
```

The derived class embeds the RAW variant. `#no_padding` removes all padding between members, so `print_struct_body` spells out every gap as `__paddingN`; `get_data_size` computes the unpadded size and chains through bases that are RAW themselves.

- Consequence: a pointer to the derived class no longer converts implicitly to a pointer to the base wrapper; cast it (`cast(*Base) ptr`).
- A POD base keeps its padding in C++ and gets no RAW variant.

Test: `tests/stdlib/bindings-generator-cpp-raw.jai`.

### Objective-C

Parse with `extra_clang_arguments` containing `-x objective-c`. Generated code uses the stdlib `Objective_C` module (`id`, `Class`, `Selector`, `NSObject`, `objc_msgSend`, `sel_registerName`).

- `@interface` and `@protocol` become structs (`create_objc_interface`). libclang does not report an `@interface` as a definition, so a declaration is skipped only when its definition cursor is elsewhere. Superclass and adopted protocols become `#as using x: X;` members; all but the first are `#place`d at offset 0 so pointer conversions are the identity. Categories add their methods to the extended class.
- Types: `id`/`Class`/`SEL` print as `id`/`Class`/`Selector`; `Foo *` is `*Foo`; `id<P>` is `*P`; generics and protocol qualifiers on `Class` are dropped; nullability attributes are looked through.
- Methods print as `name :: inline (self: *Foo, args) -> R`, with `class: Class` first for class methods, named by the selector up to the first colon. The body casts `objc_msgSend` to the method's typed `#c_call` signature and sends `__selectors.<sel>`. The selector table, a lazy `__selectors_init` and `#import "Objective_C"` are printed in a `#scope_file` block (`print_objc_selector_table`). `instancetype` instance methods are polymorphic (`self: *$instancetype/Foo` returning `*instancetype`); class methods return `*Foo`.
- Not handled: ivars, variadic methods (skipped with a log line), generics as parameters, block signatures, and x86-64 `objc_msgSend_stret`/`_fpret` (arm64 sends everything through `objc_msgSend`).
- Libraries: OBJC methods are not assigned to a library by symbol; the classes must be loaded by linking or loading the library in the program (`dlopen` or a call to a function in it).
- Bridge ops added: `cursor_result_type`, `t_objc_base`, `t_objc_num_protocols`, `t_objc_protocol`, `t_objc_num_type_args`, `t_objc_type_arg`, `t_modified`.

Test: `tests/stdlib/bindings-generator-objc.jai` (builds a dylib with clang, then drives classes, a protocol, a category, properties, class methods, `instancetype`, `double` and `BOOL`).

Native builds: a program importing `Bindings_Generator` builds with `jaic build`; `lower_intrinsic_wrapper` (`sema/procs.rs`) now emits a trap for `#compiler` hook procedures that have no intrinsic op, instead of returning undefined values (it caused "use of undefined value" on build).

- `GENERATOR_DEFAULT_SYSTEM_INCLUDE_PATH` (newer jai API) may be listed in `system_include_paths`; it stands for clang's
  builtin headers, which libclang adds itself, so the generator skips it.

## How to change it

- New libclang query: add a function pointer to `Api` and a match arm in `clang::call` (`crates/jaic/src/clang.rs`), then call `clang("op", ...)` from Jai.
- New C construct: handle its cursor kind in `handle_toplevel_cursor` / `fill_struct_members` / `create_type` (`convert.jai`) and print it in `print.jai`.
- Output format lives entirely in `print.jai`; `maybe_add_spacing` reproduces the blank lines of the source.
- Gotchas: every `create_type` call returns a fresh `CType` (visitors mutate them) except the primitive singletons (`type_def_*`); a struct is registered in `declarations_by_cursor` before its members are converted so recursive types terminate; the `#add_context` fields mean generator code must run inside `generate_bindings`.
- Limitations: Objective-C generics are dropped (see "Objective-C"); extern variables are printed `#elsewhere <lib>`; `long double` and 128-bit integers are approximated; C++ gaps are listed under "C++ support".

## Configuration

`Generate_Bindings_Options` mirrors the reference fields (`include_paths`, `source_files`, `extra_clang_arguments`, `flatten_namespaces`, `strip_prefixes`, `strip_flags`, `visitor`, `get_func_args_for_printing`, `header`/`footer`, `generate_library_declarations`, ...). Both library spellings work: `libnames`/`libpaths` and the older `libraries` (`.{filename=..., identifier=...}`) with `library_search_paths`. Extra fields: `libclang_path`, `generate_bitfield_accessors` (default true).

libclang search order: `Generate_Bindings_Options.libclang_path`, the `JAI_LIBCLANG` environment variable, `/Library/Developer/CommandLineTools/usr/lib`, the Xcode toolchain, `/opt/homebrew/opt/llvm/lib`, `/usr/local/opt/llvm/lib`, `/usr/lib*` (including `llvm-*`), then the system loader. A Homebrew LLVM can be used without linking it: `JAI_LIBCLANG=/opt/homebrew/opt/llvm/lib/libclang.dylib`. On macOS the SDK is passed as `-isysroot $(xcrun --show-sdk-path)` unless the options already contain `-isysroot`; the SDK is also used when the program targets another OS on a Mac (falling back to the Command Line Tools SDK path when `run_command` is unavailable), so cross-target generators still find the C headers. Libraries shipped under `reference/` are never used.

## Dependencies

libclang (any recent LLVM; tested with the Xcode Command Line Tools copy), `nm` for library symbol tables, `xcrun` on macOS, and the stdlib modules `Basic`, `String`, `File`, `Hash_Table`, `Process`, plus `Objective_C` for generated Objective-C code. Tests: `tests/stdlib/bindings-generator-c.jai`, `bindings-generator-cpp.jai`, `bindings-generator-cpp-classes.jai` (builds a C++ library with `clang++` and calls it), `bindings-generator-bitfields.jai`, `bindings-generator-cpp-raw.jai`, `bindings-generator-objc.jai` (macOS only; the last three also run natively from `crates/jaic-cli/tests/native.rs`), `using-member-default-override.jai` (struct-body `member = value;` overrides, needed by the declaration model).
