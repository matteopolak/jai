// Helpers for generator scripts and visitors: retyping declarations as enums, small type
// queries, and the C library header directories of each target.

LIBCLANG_VERSION :: 19; // The libclang API level the declarations follow (any newer libclang works).

// C headers often declare a value as a plain integer although it holds the values of an enum.
// These retype a variable, field or argument (or a function's result) as that enum. Lookups by
// name search outwards from the declaration, as find_parent_enum describes.
change_type_to_enum :: (decl: *Declaration, enum_name: string) -> bool {
    target := enum_for_retyping(decl, enum_name, "type", decl.output_name);
    if target change_type_to_enum(decl, target);
    return target != null;
}

change_type_to_enum :: (decl: *Declaration, e: *Enum) {
    old_size := ifx decl.type then decl.type.size else -1;
    note_enum_retyping("type", decl.output_name, old_size, e);
    decl.type = make_enum_type(e);
    // A default argument written for the integer type now needs `cast(Enum)`.
    decl.decl_flags |= .NEEDS_DEFAULT_ARGUMENT_CAST;
}

change_return_type_to_enum :: (decl: *Declaration, enum_name: string) -> bool {
    target := enum_for_retyping(decl, enum_name, "return type", decl.output_name);
    if target change_return_type_to_enum(decl, target);
    return target != null;
}

change_return_type_to_enum :: (decl: *Declaration, e: *Enum) {
    change_return_type_to_enum(decl.output_name, function_type_of(decl), e);
}

// For function types that are not declarations (function pointers): the lookup is global.
change_return_type_to_enum :: (name: string, function_type: *Function_Type, enum_name: string) -> bool {
    target := enum_for_retyping(null, enum_name, "return type", name);
    if target change_return_type_to_enum(name, function_type, target);
    return target != null;
}

change_return_type_to_enum :: (name: string, function_type: *Function_Type, e: *Enum) {
    // A size mismatch is reported by change_return_type.
    if !e.type note_enum_retyping("return type", name, -1, e);
    change_return_type(name, function_type, make_enum_type(e));
}

change_return_type :: (decl: *Declaration, new_return_type: *CType) {
    change_return_type(decl.output_name, function_type_of(decl), new_return_type);
}

change_return_type :: (name: string, function_type: *Function_Type, new_return_type: *CType) {
    previous := function_type.return_type;
    function_type.return_type = new_return_type;
    if !previous || previous.size == new_return_type.size return;
    log("Bindings_Generator: the return type of % changes size, from % to % bytes.", name, previous.size, new_return_type.size);
}

// The enum called `enum_name` (its C or its Jai name) as seen from `decl`: the structs and
// namespaces around `decl` from the innermost out, then the global scope, then the enums made
// from macros. `decl` may be null to search globally.
find_parent_enum :: (decl: *Declaration, enum_name: string) -> *Enum {
    scope := ifx decl then decl.parent else null;
    while true {
        // A null scope stands for the global one, which ends the walk.
        members: [] *Declaration;
        if !scope members = context.generator.global_scope.members;
        else if scope.kind == .STRUCT members = (cast(*Struct) scope).declarations;
        else if scope.kind == .NAMESPACE members = (cast(*Namespace) scope).declarations;
        for members {
            if it.kind == .ENUM && answers_to(it, enum_name) return cast(*Enum) it;
        }
        if !scope break;
        scope = scope.parent;
    }
    for context.generator.enum_macros {
        if answers_to(it, enum_name) return it;
    }
    return null;
}

// The name of the enum, struct or typedef a type refers to: its Jai name, or with
// `output_name = false` its C name. Empty for any other type.
get_type_name :: (type: *CType, output_name := true, strip_pointers := false) -> string {
    t := type;
    if strip_pointers {
        while t && t.pointer_to t = t.pointer_to;
    }
    named := naming_declaration(t);
    if !named return "";
    if output_name return named.output_name;
    return named.name;
}

find_underlying_type :: (type: *CType) -> *CType {
    return strip_type(type, typedefs = true);
}

is_pointer_type :: (type: *CType) -> bool {
    underlying := find_underlying_type(type);
    return underlying != null && underlying.pointer_to != null;
}

is_function_type :: (type: *CType) -> bool {
    underlying := find_underlying_type(type);
    return underlying != null && underlying.type_of_function != null;
}

is_zero_int_expression :: (expression: *Expression) -> bool {
    if expression && expression.kind == .LITERAL {
        literal := cast(*Literal) expression;
        if literal.literal_kind == .INTEGER return literal.int_value == 0;
    }
    return false;
}

// The struct at the bottom of a chain of pointers and arrays (null if there is none).
try_find_struct_in_type :: (type: *CType) -> *Struct {
    t := type;
    while t && !t.type_of_struct {
        if t.array_element_type t = t.array_element_type;
        else t = t.pointer_to;
    }
    return ifx t then t.type_of_struct else null;
}

is_operator_name :: (name: string) -> bool {
    return begins_with(name, "operator");
}

// Compound and plain assignment (`operator-=`, `operator=`); comparisons ending in `=` are not.
is_assignment_operator :: (name: string) -> bool {
    if !is_operator_name(name) return false;
    symbol := replace_all(advance(name, "operator".count), " ", "");
    if !ends_with(symbol, "=") return false;
    for string.["==", "!=", "<=", ">="] {
        if symbol == it return false;
    }
    return true;
}

// A name usable as an identifier for a C++ operator (`operator!=` -> `operator_not_equals`).
// With `keep_operators_allowed_in_jai`, an operator Jai can overload keeps its symbol.
replace_operator_name :: (name: string, keep_operators_allowed_in_jai := false) -> string {
    if keep_operators_allowed_in_jai {
        symbol := replace_all(advance(name, "operator".count), " ", "");
        if array_find(JAI_OPERATORS, symbol) return tprint("operator%", symbol);
    }
    identifier := operator_names(name, 0);
    return identifier;
}

// Appends the qualification `decl` needs when named from inside `current_scope`: `A.B.` for
// a declaration nested in A.B, minus whatever scopes the two share.
append_parent_path :: (builder: *String_Builder, decl: *Declaration, current_scope: *Declaration) {
    outside: [..] *Declaration;
    outside.allocator = temp;
    d := decl;
    while d && !scope_contains(d, current_scope) {
        array_add(*outside, d);
        d = d.parent;
    }
    for < outside {
        if it.kind == .NAMESPACE && (cast(*Namespace) it).should_flatten continue;
        if it.output_name print_to_builder(builder, "%.", it.output_name);
    }
}

// The `-isystem` directories used when `system_include_paths` is empty. libclang knows its
// own builtin headers, so only the C library's are listed: the SDK's on macOS, the NDK's for
// Android, /usr/include and its per-CPU directory on Linux, and none for Windows.
get_default_system_include_paths :: (os := OS, cpu := CPU) -> [] string {
    result: [..] string;
    common, per_cpu, found := get_libc_paths(os, cpu);
    if found {
        array_add(*result, common);
        if per_cpu != common array_add(*result, per_cpu);
    }
    return result;
}

get_libc_paths :: (os := OS, cpu := CPU) -> libc_path: string, libc_platform_path: string, success: bool {
    if os == .LINUX {
        triple := ifx cpu == .ARM64 then "aarch64-linux-gnu" else "x86_64-linux-gnu";
        return "/usr/include", sprint("/usr/include/%", triple), true;
    }
    if os == .ANDROID {
        common, per_cpu := get_ndk_libc_paths(cpu);
        return common, per_cpu, true;
    }
    if os == .MACOS {
        sdk, have_sdk := get_macos_sdk_path();
        if have_sdk {
            include := sprint("%/usr/include", sdk);
            return include, include, true;
        }
    }
    return "", "", false; // Windows: the C library headers come with the toolchain.
}

#scope_module

make_enum_type :: (e: *Enum) -> *CType {
    t := New(CType);
    t.type_of_enum = e;
    t.size = ifx e.type then e.type.size else 4;
    return t;
}

function_type_of :: (decl: *Declaration) -> *Function_Type {
    assert(decl.kind == .FUNCTION && decl.type && decl.type.type_of_function != null, "% is not a function", decl.output_name);
    return decl.type.type_of_function;
}

enum_for_retyping :: (from: *Declaration, enum_name: string, what: string, subject: string) -> *Enum {
    found := find_parent_enum(from, enum_name);
    if !found log_error("Bindings_Generator: cannot change the % of \"%\": no enum \"%\" is visible from it.", what, subject, enum_name);
    return found;
}

// Retyping is allowed either way; these only point out what may make the bindings wrong.
note_enum_retyping :: (what: string, subject: string, old_size: s64, e: *Enum) {
    if !e.type {
        log("Bindings_Generator: the % of % becomes enum %, which has no underlying type yet (an enum made from macros gets one in the visitor).", what, subject, e.output_name);
    } else if old_size >= 0 && old_size != e.type.size {
        log("Bindings_Generator: the % of % becomes enum %, which changes its size from % to % bytes.", what, subject, e.output_name, old_size, e.type.size);
    }
}

answers_to :: (d: *Declaration, wanted: string) -> bool {
    return d.name == wanted || d.output_name == wanted;
}

naming_declaration :: (t: *CType) -> *Declaration {
    if !t return null;
    if t.type_of_struct return t.type_of_struct;
    if t.type_of_enum return t.type_of_enum;
    return t.type_of_typedef;
}

// Is `inner` (or one of its enclosing scopes) `outer`?
scope_contains :: (outer: *Declaration, inner: *Declaration) -> bool {
    s := inner;
    while s {
        if s == outer return true;
        s = s.parent;
    }
    return false;
}
