# Bindings_Generator

## What it is

`stdlib/Bindings_Generator` turns C, C++ and Objective-C headers into Jai declarations: constants from `#define`s, enums, structs (with bit fields), unions, typedefs, function-pointer types, `#foreign` procedures, C++ classes, and Objective-C classes/protocols as message-send wrappers. The public API matches the official module: fill in a `Generate_Bindings_Options`, optionally set a `visitor`, call `generate_bindings(opts, "out.jai")`. Existing generators such as Vk-Engine's `Modules/{Vulkan,ImGui}/generate.jai` and sgpu's `Vulkan_With_VMA/generate.jai` run unchanged.

## How it works

Write a small program (usually the project's `generate.jai`) that fills in the options and calls `generate_bindings`, and run it with `jaic run`. It needs libclang (see Configuration).

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

`tests/stdlib/bindings-generator-c.jai` is a complete example, including a `visitor` and output assertions; it writes into `/tmp`.

### Pipeline

1. `generate_bindings` (`generate.jai`) builds a `Generator_State` (stored in `context.generator`, options in `context.generator_options`), resolves the requested libraries, and asks libclang to parse a synthetic `generate_temp.h` that `#include`s each entry of `source_files`.
2. `convert.jai` walks the translation unit and builds the declaration model of `types.jai` (`Declaration`, `Function`, `Struct`, `Enum`, `Typedef`, `Namespace`, `Bitfield`, `CType`, `Literal`...). Declarations from system headers are skipped unless `path_fragments_to_treat_as_non_system_paths` or `system_types_to_include` whitelist them; types declared in system headers are referred to by name (see "System types" below), except the builtin integer typedefs (`uint32_t`, `size_t`...), which become primitives. Macros are kept only when their body is a constant expression over literals and already-known constants.
3. `post_process` converts macros to enums (`generate_enums_from_macros_with_prefixes`), assigns functions to libraries, then the user `visitor` runs over every declaration (it may set `decl_flags`, rename `output_name`, swap types, add default values), followed by `omit_unnecessary_typedefs_and_macros`.
4. `print.jai` prints the model. Enum values are prefix-stripped (`auto_detect_enum_prefixes`), original names stay as aliases, unions print as `union`, bit fields as a `__bitfield` storage member plus `S_get_x`/`S_set_x` accessors (see "Bit fields"), C++ reference parameters become pointers with a value-taking `#no_context` wrapper when they have defaults, and printf-like variadics get a `_CFormat` foreign declaration plus a Jai `string` wrapper.

Library assignment: each `libraries` / `libnames` entry is located (search paths, then `lib` prefix and `.dylib/.so/.dll/.lib/.a` suffixes) and its exported symbols read with `nm -g`. A function binds to the first library exporting its symbol. A library file that can't be found is "unknown": unresolved functions go to the first unknown library with a logged note. With `SYMBOLS_WITH_UNKNOWN_FOREIGN_LIBS` in `strip_flags`, a function found in no library is stripped instead.

### Why libclang goes through a Rust bridge

libclang passes `CXCursor`/`CXType` structs by value and drives traversal with a native callback (`clang_visitChildren`), which interpreted `#foreign` calls can't do well. So `crates/jaic/src/clang.rs` loads libclang itself and exposes it through the `__jaic_clang(op, a, b, text)` and `__jaic_clang_text()` primitives. Cursors and types live in arenas and reach Jai as integer handles; equal cursors get equal handles, so handles work as hash keys. `stdlib/Bindings_Generator/clang.jai` wraps this (`clang("kind", cursor)`). All AST logic is Jai; Rust only forwards calls and collects children.

### C++ support

- **Methods**: members are printed inside the struct as `name :: (this: *T, ...) -> R #cpp_method #foreign lib "mangled";`. `const T&` parameters become `*T` plus a `#no_context` value wrapper (defaults live on the wrapper). Static methods have no `this`; static `const` data members with a value become struct constants.
- **Constructors / destructors**: `Constructor`, `CopyConstructor`, `MoveConstructor`, `Destructor` (D1), `Destructor_Base` (D2). Manglings come from `clang("manglings", cursor)` so the C1/C2 and D0/D1/D2 variants are real symbols. `#cpp_return_type_is_non_pod` is printed for functions returning a type with a constructor, copy/move constructor or destructor.
- **Virtuals**: virtual methods print as `virtual_<name>` in a comment-headed section (usable to call a parent implementation). `X_VTable :: struct #type_info_none` lists the entries in vtable order (D1 then D0 for the destructor), followed by C-style `X_name :: inline (this: *X, ...)` wrappers and `vtable :: (obj: *X) -> *X_VTable` when `generate_vtable_helpers` is on. A derived class overlays the vptr with `#place base; x_vtable: *X_VTable;`.
- **Inheritance**: `#as using base: Base;` for the first base; later bases are plain members. Derived vtables embed the parent vtable with `using`.
- **Templates**: class templates print as `struct(T: Type)` (non-type parameters keep their C type), instantiations as `Box(s32)`. libclang reports dependent types as "Unexposed", so they are recovered from placeholder structs, `TypeRef`/`TemplateRef` children and (for non-type arguments) the type spelling (`create_unexposed_type`, `fill_template_arguments` in `convert.jai`). Explicit specializations are skipped.
- **Operators**: binary operators Jai can overload print as `operator+ :: ...` after the struct; others get names like `operator_not_equals`.
- **Default arguments**: temporaries (`T(a, b)`, `T()`, `{}`) print as `T.{...}`, null casts and `NULL`/`nullptr` as `null`, bool literals as `true`/`false`.
- **Macros**: macro bodies are parsed with C's precedence and printed with the parentheses Jai's different table needs to keep that grouping (`1<<24|1<<16` -> `1 << 24 | (1 << 16)`, `A % 3 * 2` -> `(A % 3) * 2`, `(unsigned)A | 1` -> `(cast(u32) A) | 1`; `jai_binding` in `convert.jai`). Copying the tokens verbatim would silently change their meaning in Jai. Surrounding parentheses are stripped (`(4)` -> `4`); macros naming a type or `int`/`void` (`#define X ImWchar`) and casts to a named type (`((ImGuiID)0)` -> `cast(ID) 0`, `cast,trunc(ID) -1` before `-`/`~`) are resolved after all declarations exist (`NEEDS_CHECKING` in `post_process`).
- **Gaps**: inline functions are bound only when the library exports their symbol (a header-only inline method has none), so bind against the built library. Tail padding is handled for classes with any number of non-template bases (see "Tail padding and `__RAW` structs"); virtual bases are handled (see "Virtual bases"); a class whose layout cannot be reproduced (template bases, empty-base optimization) still gets a comment and `NO_STRUCT_CHECKS`.

Compiler support the generated code relies on:

- `#cpp_method` implies the C calling convention and no context, for procedure literals and procedure types (so vtable entries are called correctly). `#cpp_return_type_is_non_pod` sets `ProcType.non_pod_return`; the IR sets `CAbi.ret_indirect`, and `interp/native.rs::call` and the LLVM backend (`lower_sig`) then return the aggregate through the hidden result pointer even when it would fit in registers. By-value struct arguments and results otherwise use the shared classifier (`crates/jaic/src/abi.rs`).
- Bridge ops used for C++: `is_virtual`, `is_pure_virtual`, `is_const_method`, `is_copy_ctor`, `is_move_ctor`, `is_inlined`, `access`, `manglings`, `specialized_template`, `t_template_arg`, `is_virtual_base`, `base_offset` (bits; `-1` when the libclang is too old for `clang_getOffsetOfBase`), `comment_line`.

Real-world check: scratch copies of the Vk-Engine generators (`jaic check generate.jai -os linux`) bind Vulkan-Headers with VMA and Dear ImGui (docking branch). The ImGui output type-checks and drives a real frame (`CreateContext`, `Style.Constructor`, `NewFrame`, `Begin`, `Render`) against a dylib built from the same sources.

### Struct checks, inline stripping and the `#library` declaration

- **Struct checks** (`generate_compile_time_struct_checks`, default true; `print_struct_checks` in `generate.jai`): right after each struct, `print_declaration_to_builder` prints `#run { assert(...); }` with the size of every base-class member (`size_of(type_of(S.base))`), the offset (through an `instance: S;`) and size of every plain data member, and `size_of(S)`. Nested structs follow their outer struct; structs inside non-flattened namespaces are collected in `deferred_struct_checks` and checked at the end of the file. Bit fields, anonymous members, statics, `__RAW` wrappers (members only) and structs flagged `NO_STRUCT_CHECKS` are skipped. The messages use a literal `%` so the generated `assert` fills in the value.
- **Inline functions**: `strip_flags = .INLINED_FUNCTIONS` marks functions that libclang reports as inlined (`is_inlined`: defined in the class body or declared `inline`) `OMIT_FROM_OUTPUT` in `create_function` (`convert.jai`). A constructor defined out of line in the header (`S::S() {}` without `inline`) is kept, because the library exports it.
- **Library declarations** (`generate_library_declarations`): printed last, after the checks, in a `#scope_file` block (`#import "Basic"; // The generated code uses assert.` (the comment lists `assert`, `S128/U128` and `tprint` as they are needed), then `name :: #library "<generated_library_path_prefix><full_path>";`). `full_path` is the path the library was found at (`<libpath>/<name>`, without the extension), e.g. `./cpp_library` for `libpaths = .`; an unfound library keeps its plain name. The declarations are file-scope, so code outside the generated file refers to the library by its `#foreign` use only.

### Bit fields

- `fill_struct_members` / `finish_bitfield` (`convert.jai`) merge adjacent bit fields into one `Bitfield` (a zero-width field ends the run; in a union each field is its own run). The storage is an unsigned integer of exactly the bytes clang laid out, or `[N] u8` when the run is not naturally aligned for that size. `Bitfield.start_byte`/`byte_count` record the span, and padding before the run is absorbed.
- The widest declared type among the members is the C alignment of the run. When the other members do not already give the struct that alignment, `print_bitfield_alignment_helper` prints `#place first_member; name_alignment: <type>;`. A run with a single member prints as that member (`flag: u8; /* 1 bits */`).
- Accessors (`generate_bitfield_accessors`, default on): `S_get_x :: (s: *S) -> T` and `S_set_x :: (s: *S, value: T)` read/write by absolute bit offset (little endian), sign-extending signed fields; setters truncate to the field width. Unnamed fields, fields over 64 bits and fields of nested anonymous structs get none.
- Itanium/AAPCS64 (the default) lets a field start anywhere as long as it does not straddle its declared type's unit, and packs adjacent fields regardless of their type.
- **MSVC layout** (`os = .WINDOWS`): `is_msvc_layout` / `fits_msvc_unit` / `finish_msvc_bitfield` (`convert.jai`). MSVC allocates a whole unit of the declared type's size; a field joins the open unit only when its type has the same size and it lies inside that unit, otherwise (other size, would cross the unit end, after a `: 0` field) a new unit starts. Each run is stored as an unsigned integer of exactly the unit size at the unit's start (so `char a:3; int b:5; char c:2` is three storages of 1, 4 and 1 bytes at offsets 0, 4 and 8). The bit offsets always come from libclang, so the parse itself has to use the MS rules: when `os == .WINDOWS` and the extra arguments contain no `-target`/`--target`/`-mms-bitfields`/`-fms-*`, `generate_bindings` adds `-mms-bitfields` (MS bit field rules on the host's target and headers). Pass `-target x86_64-pc-windows-msvc` yourself to also get Windows type sizes (`long` is 4 bytes) and a Windows-flavoured parse.

Test: `tests/stdlib/bindings-generator-bitfields.jai` (C reads and writes the same structs; includes a Vulkan-style 24/8/24/8 instance).

### Tail padding and `__RAW` structs

Under the Itanium C++ ABI a derived class can put its fields (or its next base class) into the tail padding of a non-POD base, but a Jai struct member always keeps its padding. `mark_tail_padding_bases` (`print.jai`, run before printing) decides per class which of its bases get `NEEDS_RAW`: bases are laid out in order, each at its alignment after the data size of the previous one (`get_base_layout`), and the combinations of "reuse this base's padding" are tried against where libclang puts the class's first own field (or `sizeof` when it has none; `base_layout_matches`). Bases are marked before the classes derived from them, because a base's data size depends on how its own bases were marked. When the combinations are indistinguishable (a class with no members of its own), bases that look non-POD (`is_probably_non_pod`: user constructors/destructor, virtuals, or such a base) are preferred, as the ABI reuses exactly those. A marked base is printed as a wrapper embedding its data, plus the data struct:

```
Viewport :: struct {
    using viewport__raw: Viewport__RAW;
    <methods, constants, nested types>
}
Viewport__RAW :: struct {
    <vptr, bases, data members, explicit __paddingN: [k] u8 gaps>
} #no_padding
```

The derived class embeds the RAW variant. With several bases the later ones then land where C++ puts them (natural alignment after the unpadded earlier base). `#no_padding` removes all padding between members, so `print_struct_body` spells out every gap as `__paddingN`, including the alignment gaps between the bases of a RAW struct; `get_data_size` computes the unpadded size and chains through bases that are RAW themselves.

- Consequence: a pointer to the derived class no longer converts implicitly to a pointer to the base wrapper; cast it (`cast(*Base) ptr`).
- A POD base keeps its padding in C++ and gets no RAW variant.

Tests: `tests/stdlib/bindings-generator-cpp-raw.jai` (single bases, chains), `tests/stdlib/bindings-generator-cpp-raw-multi.jai` (`C : A, B`, `G : A, F` where the second base sits inside the first one's padding, and a two-base class that is itself a base).

### Objective-C

Parse with `extra_clang_arguments` containing `-x objective-c`. Generated code uses the stdlib `Objective_C` module (`id`, `Class`, `Selector`, `NSObject`, `objc_msgSend`, `sel_registerName`).

- `@interface` and `@protocol` become structs (`create_objc_interface`). libclang does not report an `@interface` as a definition, so a declaration is skipped only when its definition cursor is elsewhere. Superclass and adopted protocols become `#as using x: X;` members; all but the first are `#place`d at offset 0 so pointer conversions are the identity. Categories add their methods to the extended class.
- Types: `id`/`Class`/`SEL` print as `id`/`Class`/`Selector`; `Foo *` is `*Foo`; `id<P>` is `*P`; protocol qualifiers on `Class` are dropped; nullability attributes are looked through.
- Methods print as `name :: inline (self: *Foo, args) -> R`, with `class: Class` first for class methods, named by the selector up to the first colon. The body casts `objc_msgSend` to the method's typed `#c_call` signature and sends `__selectors.<sel>`. The selector table, a lazy `__selectors_init` and `#import "Objective_C"` are printed in a `#scope_file` block (`print_objc_selector_table`). `instancetype` instance methods are polymorphic (`self: *$instancetype/Foo` returning `*instancetype`); class methods return `*Foo`.
- Struct returns: with `cpu = .X64`, a method returning a struct or union larger than 16 bytes (the SysV MEMORY class; `objc_returns_in_memory`) is sent through `objc_msgSend_stret`; arm64 never uses it (the stdlib `Objective_C` module aliases the `_stret` names there). The choice follows `Generate_Bindings_Options.cpu`, not the host. Structs of 16 bytes or less, even floating point ones, go through `objc_msgSend`.
- Not handled: variadic methods (skipped with a log line) and structs under 16 bytes that SysV still passes in memory (unaligned or x87 members). Methods passing or returning a 16-byte `long double` (the x86-64 `objc_msgSend_fpret` case) are always stripped with a log line; see "`long double`".
- **Generics** (`create_objc_interface`, `create_objc_object_type`, `objc_superclass_type` in `convert.jai`): `@interface Box<T : id>` becomes `Box :: struct(T: Type)` (the C++ template machinery: `template_type_params`, `template_instantiation_params`). Methods take `self: *Box(T)`; `T` in a signature or ivar prints as `T`; `NSArray<NSString *> *` is `*NSArray(*NSString)`; a generic class used without arguments (`NSArray *`) takes `id` for each parameter (done at print time in `print_type_to_builder`, so it works even when the definition is in a skipped system header: the parameters are read as soon as the type is first seen). A superclass specialisation (`Sub : Box<Item *>`) prints `#as using box: Box(*Item);`; libclang reports its arguments only as class references after the superclass reference, so nested generics, `id<P>` arguments and `id` collapse to `id`. Call a method of a specialisation as `Box(*Item).item(b)`; `class(Box(*Item))` finds the runtime class. Bounds (`T : NSObject *`) are not enforced, and a category on a generic class reuses the class's parameter names.
- **Instance variables** (`add_objc_ivar`): the `@interface { ... }` ivars become data members after the superclass member, in declaration order, so `p._x = 3` works on a `*Point`. Jai lays them out with natural alignment, which equals clang's layout for ordinary types. Limits: ivars only declared in an `@implementation` or class extension are invisible; a subclass's first ivar is assumed to start at the Jai size of its superclass (a superclass ending in a small ivar that the runtime lets the subclass pack behind is not modeled); bit field ivars are skipped; `@private`/`@protected` are not distinguished. Struct size checks skip Objective-C structs (their size is runtime-owned).
- **Blocks** (`create_block_type`): `void (^)(int)` prints as a pointer to a struct named after the signature, `Block_<result>_<args>` (`*` becomes `P`, e.g. `Block_void_s32_PNSString`, `Block_s32_s32`). The struct is the block header (`isa`, `flags`, `reserved`, `invoke`, `descriptor`) with `invoke: #type (block: *Block_X, args...) -> R #c_call`, so a block received from Objective-C is called as `b.invoke(b, 3)`. One struct per signature is added to the global scope on first use and shared by typedefs (`Handler :: *Block_void_s32;`), parameters, results and properties. Generic parameters inside a block signature are erased to `id` (the struct lives outside the class). Every block struct is followed by a constructor, `Block_X_literal :: (invoke: <invoke type>, user_data: *void = null) -> *Block_X`, which wraps a Jai `#c_call` procedure in a global block (`objc_make_block` in the `Objective_C` module: `_NSConcreteGlobalBlock` isa, the `BLOCK_IS_GLOBAL` flag, a static descriptor and one extra `user_data` slot). Inside `invoke`, `objc_block_user_data(block)` returns that pointer, which replaces captured variables. Global blocks are never copied or freed by the runtime, so the result can be stored by Objective-C (`setOnDone:`) and stays valid; it is allocated with `New` and lives for the program. In the interpreter the procedure is turned into a native thunk by passing it through a foreign call inside `objc_make_block`.
- Libraries: OBJC methods are not assigned to a library by symbol; the classes must be loaded by linking or loading the library in the program (`dlopen` or a call to a function in it).
- Bridge ops used for Objective-C: `cursor_result_type`, `t_objc_base`, `t_objc_num_protocols`, `t_objc_protocol`, `t_objc_num_type_args`, `t_objc_type_arg`, `t_modified`.

Tests: `tests/stdlib/bindings-generator-objc-stret.jai` (text of the x64 and arm64 bindings; the x64 ones are also type checked), `bindings-generator-objc.jai` (builds a dylib with clang, then drives classes, a protocol, a category, properties, class methods, `instancetype`, `double` and `BOOL`), `bindings-generator-objc-generics.jai` (generic classes, specialised uses, unspecialised `id` defaults, a specialised subclass, generic `instancetype`), `bindings-generator-objc-ivars.jai` (reading and writing ivars across Jai and Objective-C, subclass ivars) and `bindings-generator-objc-blocks.jai` (block typedefs, parameters, results and properties; calling returned blocks through `invoke`; passing Jai procedures as blocks with `Block_X_literal`, with and without `user_data`, including one Objective-C stores and calls later).

### System types

A type declared in a system header (`FILE`, `struct stat`, `pthread_mutex_t`, `__darwin_size_t`...) is not printed; the bindings use its name and expect the program to import the module that defines it (usually `POSIX`, `Socket` or `Windows`). The typedef keeps the clang alignment (`CType.alignment`) so packed checks stay right. Two exceptions: the fixed-size integer typedefs in `TYPEDEFS_TO_UNWRAP` (`types.jai`: `uint8_t` ... `uint64_t`, `size_t`, `intptr_t`, `ptrdiff_t`, `off_t`, the BSD `u_int32_t` family, CoreFoundation's `UInt32`...) become primitives (casts in macros use `builtin_integer_typedef`), and anything listed in `system_types_to_include` or under a `path_fragments_to_treat_as_non_system_paths` path is printed normally. System structs get `Struct.Flags.IS_SYSTEM` and are never checked.

### Virtual bases

C++ classes with `virtual` bases (`struct Left : virtual Base`) are laid out by the Itanium ABI as: own vtable pointer, non-virtual bases, own members, then each virtual base at an offset clang computes. `convert.jai` asks the bridge for `is_virtual_base` and `base_offset` (bits) on every base specifier and moves virtual ones to `Struct.virtual_bases`. `print.jai` then prints:

```
Left :: struct {
    __vptr: *void; // C++ virtual bases make the class dynamic
    l: s32;
    using base: Base #align 8; // C++ virtual base
}
```

The `__vptr` is added only when no other vtable pointer is present (no virtual methods and no dynamic first base). `#align N` is added when natural alignment would not land the base at clang's offset (`alignment_reaching`). Struct checks assert the virtual base's offset through an instance (`vbase_instance`). `clang_getOffsetOfBase` only exists in libclang 20+ (Xcode 16's libclang lacks it); with an older libclang `base_offset` is `-1`, the virtual base is printed without `#align`, its comment reads `// C++ virtual base (offset unknown to this libclang)` and it gets no offset check. The bridge therefore prefers a libclang that has it (see the search order below), so a machine with both Xcode 16 and a Homebrew LLVM produces the checked output. A class that inherits from a class with virtual bases (a diamond) is printed with its non-virtual parts, a `// jai: a base class has C++ virtual bases` comment and `NO_STRUCT_CHECKS`, because the shared virtual base sits at a different offset in every most-derived class. Classes with virtual bases are never given `__RAW` variants.

### Overloads that look the same in Jai

`void take(int &)` and `void take(const int &)` both become `(v: *s32)`, which Jai would treat as a redefinition. `rename_equivalent_overload` (`convert.jai`) gives later ones a `_1`, `_2`... suffix (`foreign_name` keeps the real symbol) and flags both with `ADD_C_TYPE_DETAILS`, so with `add_overloaded_const_and_ref_comments` (default on) the parameters print as `/*reference*/ *s32` and `/*const reference*/ *s32`. Global functions are tracked in `function_names_seen`; methods use the struct's declarations.

### `long double`

`T_LONGDOUBLE` maps by size: 8 bytes (arm64 Apple, Windows) is `float64`, 4 is `float32`. A 16-byte one (x87 on x86-64, binary128 on Linux arm64) is flagged `CType.Flags.WIDE_LONG_DOUBLE` (with clang's alignment) and printed according to `Generate_Bindings_Options.use_jaic_long_double`:

- `true` (default): `Long_Double`, jaic's non-standard extension type ([jaic extensions](../language/jaic-extensions.md)). Functions and methods that pass or return one are bound, and the file-scope part of the output gets `#import "Jaic_Extensions";` (`Generator_State.long_double_was_referenced`, set when the type is printed). The output then only compiles with jaic, for the target it was generated for.
- `false`: the portable output other Jai compilers accept. Struct members keep their layout as `[16] u8`, and functions and methods that pass or return one are stripped with a log line (`uses_wide_long_double`).

Objective-C methods using a 16-byte `long double` are stripped either way: on x86-64 they would need `objc_msgSend_fpret`, which the generator does not emit. Test: `tests/stdlib/bindings-generator-long-double.jai` binds `tests/native/c-long-double/longdouble.h` for the compile target and calls every function (also built for x86-64 and run under Rosetta by the `c_long_double` native test); `bindings-generator-parity.jai` checks both settings.

### Packed members and `#align`

When clang puts a member at an offset its natural alignment would not give (`#pragma pack`, `__attribute__((packed))`, or a virtual base), `print_struct_body` adds `#align N` to the member, choosing the largest power of two that reaches the offset (`check_alignment`, `next_field_offset`, `alignment_reaching` in `print.jai`). This needs the compiler rule that a member's `#align` replaces its natural alignment rather than only raising it (`crates/jaic/src/sema/structs.rs`).

### Other output rules

- A function whose printed name is not its C symbol (`name_CFormat`, a name shortened by `strip_prefixes`, or a Jai keyword escaped with `_`) names the symbol in its `#foreign` directive; C++ functions always do, with the mangled name (`append_elsewhere` in `print.jai`).
- Unnamed parameters print as `unknown0`, `unknown1`... (the `Declaration.name` stays empty; only `output_name` is set).
- A comment starting on an earlier line than the declaration, or spanning several lines, is printed before it; a one-line comment on the same line goes after it (`is_prefix_comment`). The bridge op `comment_line` gives the comment's first line.
- Character macros (`#define SEP '%'`) become `#char "%"`.
- Macros whose value names an enum constant are dropped (C enum constants are not top-level names in Jai). Inside `generate_enums_from_macros_with_prefixes` enums, references to other enums' values are rewritten (`V`, `Enum.V` or `xx Enum.V`; `rewrite_enum_macro_references`).
- `(T)(-1)` style casts print as `cast,trunc(T) -1`; `extern const` variables print as `#elsewhere`; `extern "C" { ... }` blocks are walked (`LINKAGE_SPEC`).
- A pointer to a function typedef refers to the typedef by name instead of expanding it.
- Printf wrappers (`generate_printf_wrappers`) are made for every variadic function whose last named argument is a `char *`. The C function is declared as `name_CFormat` (bound to its C symbol, `#foreign lib "name"`); the wrapper `name :: (..., fmt: string, __args: ..Any)` formats with Jai's `tprint` and passes the text on as `"%s", temp_c_string(...)`, so it needs a context with temporary storage (no `#no_context`). Code generated in `print_function_wrapper` (`print.jai`).
- Every generated file starts with a `// Generated by Bindings_Generator. ...` comment; with `add_generator_command` (default on) it also shows the command line (`generator_command` in `generate.jai`). A class with virtual functions has its `virtual_*` bindings under a short comment explaining when to use them, and an empty C++ class gets `__empty_struct_padding: u8;` because C++ gives it size 1.
- macOS `.tbd` stubs that only list `arm64e` count for `arm64`.

### Coverage of the public API

"Partial" entries are explained in the notes.

| Area | Status | Notes |
| --- | --- | --- |
| `Generate_Bindings_Options`: every public field | Supported | Plus `libclang_path`, `generate_bitfield_accessors`, `libraries`/`library_search_paths` |
| `generate_bindings(opts, path)` / `(opts) -> String_Builder, bool` | Supported | |
| `visitor`, `get_func_args_for_printing`, `will_print_bindings`, `convert_macro_value_to_enum_callback` | Supported | |
| Enum values as `*Declaration` (`Enum.enumerates`, `Literal.enum_value`), `Library_Info.identifier` | Supported | The API Vk-Engine's and sgpu's Vulkan generators use; see "Enum values and libraries" |
| Helper procedures (`change_type_to_enum`, `get_type_name`, `find_underlying_type`, `get_default_system_include_paths`...) | Supported | `api.jai` |
| `strip_flags` (constructors, destructors, va_list, unknown libraries, inlined) | Supported | |
| `strip_prefixes`, enum prefix detection and stripping, `alias_original_enum_names`, `c_enum_emulation` | Supported | |
| `generate_enums_from_macros_with_prefixes`, `macro_prefixes_to_unwrap`, `typedef_prefixes_to_unwrap` | Supported | |
| `mimic_spacing_flags`, `try_to_preserve_comments` | Partial | Blank lines and comment placement follow the same rules; a few blank lines differ (e.g. around forward-declared unions) |
| Library lookup, `#foreign` names, `generate_library_declarations`, `system_library_*`, `.tbd` stubs | Supported | Symbols read with `nm` |
| Extern variables (`#elsewhere`) and `omit_global_declarations` | Supported | |
| Structs, unions, anonymous members, nested types | Supported | |
| Bit fields (Itanium and MSVC) | Supported | Accessors are an extension (`generate_bitfield_accessors`) |
| Packed structs (`#align` on members) | Supported | |
| Compile-time struct checks | Supported | |
| Macros (integer, float, string, char, casts, references to constants) | Supported | Spacing of operators differs (`1 << 0` vs `1<<0`) |
| C++ methods, constructors, destructors, operators, default arguments | Supported | |
| C++ virtual functions, vtables, `generate_vtable_helpers`, `generate_c_style_api_for_vtable` | Supported | |
| C++ templates and instantiations | Supported | Explicit specializations skipped |
| C++ tail padding (`__RAW`) | Supported | |
| C++ virtual bases | Supported | Diamonds (a base that has virtual bases) are printed without checks |
| Overloads equal in Jai, `add_overloaded_const_and_ref_comments` | Supported | |
| `flatten_namespaces` | Supported | |
| Objective-C classes, protocols, categories, properties, `instancetype`, generics, ivars | Supported | Limits under "Objective-C" |
| `objc_msgSend_stret` | Supported | |
| `objc_msgSend_fpret` | Partial | Methods returning a 16-byte `long double` are stripped; every other return uses `objc_msgSend` |
| Objective-C blocks: receiving and calling | Supported | |
| Objective-C blocks: literals from Jai procedures | Supported | `Block_X_literal`, global blocks only (no captured-variable copying) |
| `long double` | Extension | 8-byte is `float64`; 16-byte is jaic's `Long_Double` (or, with `use_jaic_long_double = false`, `[16] u8` members and stripped functions, the portable form) |
| Windows/MSVC headers (`os = .WINDOWS`) | Partial | MSVC bit fields and type sizes through `-target`; COM interface `uuid` attributes are not printed |
| Include guards and `TOKENS_TO_REPLACE`-style preprocessing tweaks | Missing | Not needed by any generator in the corpus |
| 128-bit integers | Partial | `__int128` prints as Basic's `S128`/`U128` |

### Enum values and libraries

`Enum.enumerates` is a `[..] *Declaration`. Each value is a constant declaration (`decl_flags` has `IS_CONST`) whose `parent` is the enum and whose `expression` is a `Literal`:

- `.INTEGER`: `int_value` holds the value's bits (read as unsigned when the enum's type is unsigned; `new_enumerator` and `is_signed_storage` in `convert.jai`);
- `.MACRO`: a value made from a `#define` (`generate_enums_from_macros_with_prefixes`); `raw_value` is its Jai text.

The visitor sees the values after their enum (`visit_declarations`, `case .ENUM`), so it can rename one (`output_name`) or drop one (`OMIT_FROM_OUTPUT`; `print_enum_values` and `print_enum_aliases` skip it). A `Literal` of kind `.ENUM` names a value through `enum_value: *Declaration`, as Vulkan generators do for `sType` defaults:

```jai
for struct_type_decl.enumerates if it.output_name == "BUFFER_MEMORY_BARRIER" {
    literal := New(Literal);
    literal.literal_kind = .ENUM;
    literal.enum_type = struct_type_decl;
    literal.enum_value = it;
    decl.expression = literal;
}
```

Generators written for the older value-type API (`*Enum.Enumerate`, `for * enumerates`, such as `UnNabbo--no_api`'s) do not type-check.

`Library_Info.identifier` is the name the bindings give a library (`libvulkan :: #library ...`, `#foreign libvulkan`); `name` is its file name without directory or extension. `will_print_bindings` may rename one: `context.generator.libraries[0].identifier = "libvulkan";` (sgpu).

Tests: `tests/stdlib/bindings-generator-declaration-api.jai`.

`tests/stdlib/bindings-generator-parity.jai` pins the output rules above (system types, `unknownN`, comments, char macros, enum macro rewriting, casts, packed `#align`, `long double`) for C and C++.

`GENERATOR_DEFAULT_SYSTEM_INCLUDE_PATH` may be listed in `system_include_paths`. It stands for clang's builtin headers, which libclang adds itself, so the generator skips it.

A program importing `Bindings_Generator` also builds natively: `lower_intrinsic_wrapper` (`sema/procs.rs`) emits a trap for `#compiler` hook procedures that have no intrinsic op. The stub first writes `runtime error: '<name>' is a compiler primitive; it runs only at compile time` to stderr. A native program that calls `generate_bindings` from `main` works under `jaic run`, where the interpreter calls the hook; built natively, it now says why it stops.

## How to change it

- New libclang query: add a function pointer to `Api` and a match arm in `clang::call` (`crates/jaic/src/clang.rs`), then call `clang("op", ...)` from Jai.
- New C construct: handle its cursor kind in `handle_toplevel_cursor` / `fill_struct_members` / `create_type` (`convert.jai`) and print it in `print.jai`.
- Output format lives entirely in `print.jai`; `maybe_add_spacing` reproduces the blank lines of the source.
- Gotchas: every `create_type` call returns a fresh `CType` (visitors mutate them) except the primitive singletons (`type_def_*`); a struct is registered in `declarations_by_cursor` before its members are converted so recursive types terminate; the `#add_context` fields mean generator code must run inside `generate_bindings`.
- Limits are listed per area above: "C++ support", "Objective-C", "`long double`", and the coverage table.

## Configuration

`Generate_Bindings_Options` has the official fields (`include_paths`, `source_files`, `extra_clang_arguments`, `flatten_namespaces`, `strip_prefixes`, `strip_flags`, `visitor`, `get_func_args_for_printing`, `header`/`footer`, `generate_library_declarations`, ...). Both library spellings work: `libnames`/`libpaths` and the older `libraries` (`.{filename=..., identifier=...}`) with `library_search_paths`. Extra fields: `libclang_path`, `generate_bitfield_accessors` (default true). `os` selects the MSVC bit field rules (`.WINDOWS`) and `cpu` selects the `objc_msgSend_stret` use (`.X64`); both default to the compile target.

libclang search order (`candidates`/`open_api` in `crates/jaic/src/clang.rs`): `Generate_Bindings_Options.libclang_path` and the `JAI_LIBCLANG` environment variable are used as given. Otherwise the candidates are `/Library/Developer/CommandLineTools/usr/lib`, the Xcode toolchain, `/opt/homebrew/opt/llvm/lib`, `/usr/local/opt/llvm/lib`, keg-only Homebrew versions (`/opt/homebrew/opt/llvm@N/lib`, `/usr/local/opt/llvm@N/lib`, newest first), `/usr/lib*`, `/usr/lib/llvm-N` (newest first), then the system loader; the first candidate that exports `clang_getOffsetOfBase` (libclang 20+) wins, and only when none does is the first loadable one used. This keeps the output the same across machines whose first toolchain differs (GitHub's macos-15 images have Xcode 16's libclang first, a linked `llvm@18`, and the `llvm@23` CI installs keg-only). Rejected candidates stay loaded in the process (never `dlclose`d). On macOS the SDK is passed as `-isysroot $(xcrun --show-sdk-path)` unless the options already contain `-isysroot`; the SDK is also used when the program targets another OS on a Mac (falling back to the Command Line Tools SDK path when `run_command` is unavailable), so cross-target generators still find the C headers. A libclang bundled with an official Jai distribution is never used.

## Dependencies

libclang (any recent LLVM; 20+ for virtual base offsets), `nm` for library symbols, `xcrun` on macOS, and the stdlib modules `Basic`, `String`, `File`, `Hash_Table`, `Process`, plus `Objective_C` for generated Objective-C code.

Tests in `tests/stdlib/`:

- C: `bindings-generator-c.jai`, `-bitfields.jai`, `-bitfields-msvc.jai` (clang's `x86_64-pc-windows-msvc` layout and a native `-mms-bitfields` library), `-parity.jai`, `-checks.jai` (fixture `tests/native/bindgen-checks/`), `-long-double.jai`.
- C++: `bindings-generator-cpp.jai`, `-cpp-classes.jai` (builds a library with `clang++` and calls it), `-cpp-raw.jai`, `-cpp-raw-multi.jai`, `-cpp-virtual-bases.jai`.
- Objective-C (macOS only): `bindings-generator-objc.jai`, `-objc-generics.jai`, `-objc-ivars.jai`, `-objc-blocks.jai`, `-objc-stret.jai`.
- `using-member-default-override.jai` covers struct-body `member = value;` overrides the declaration model needs.

`-cpp-raw`, `-checks`, `-parity`, `-cpp-virtual-bases` and the four Objective-C tests also run natively from `crates/jaic-cli/tests/native.rs`.
