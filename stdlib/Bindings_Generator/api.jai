// Public helpers for generator scripts and visitors, with the reference module's names and
// signatures: retyping declarations to enums, type queries, and the default header paths.

LIBCLANG_VERSION :: 19;   // The libclang API level the declarations follow (any newer libclang works).

// C often types a value as an integer although an enum lists its values. These replace the
// type of `decl` (a variable, field or argument) or the return type of a function with the
// enum, looked up by name in the enclosing structs and namespaces and then globally.
change_type_to_enum :: (decl: *Declaration, enum_name: string) -> bool {
    e := find_parent_enum(decl, enum_name);
    if !e {
        log_error("Could not find enum with name \"%\" to replace type of \"%\"", enum_name, decl.output_name);
        return false;
    }
    change_type_to_enum(decl, e);
    return true;
}

change_type_to_enum :: (decl: *Declaration, e: *Enum) {
    if !e.type {
        log("Warning: Replacing type of % with enum %, whose type is not set (enums made from macros have none; set it in the visitor).", decl.output_name, e.output_name);
    } else if decl.type && decl.type.size != e.type.size {
        log("Warning: Replacing type of % (size %) with enum % of different size %", decl.output_name, decl.type.size, e.output_name, e.type.size);
    }
    decl.type = make_enum_type(e);
    // Default values must then be cast: `= cast(Enum) 5`.
    decl.decl_flags |= .NEEDS_DEFAULT_ARGUMENT_CAST;
}

change_return_type_to_enum :: (decl: *Declaration, enum_name: string) -> bool {
    e := find_parent_enum(decl, enum_name);
    if !e {
        log_error("Could not find enum with name \"%\" to replace return type of \"%\"", enum_name, decl.output_name);
        return false;
    }
    change_return_type_to_enum(decl, e);
    return true;
}

change_return_type_to_enum :: (decl: *Declaration, e: *Enum) {
    assert(decl.kind == .FUNCTION && decl.type && decl.type.type_of_function != null);
    change_return_type_to_enum(decl.output_name, decl.type.type_of_function, e);
}

change_return_type_to_enum :: (name: string, function_type: *Function_Type, enum_name: string) -> bool {
    e := find_parent_enum(null, enum_name);
    if !e {
        log_error("Could not find enum with name \"%\" to replace return type of \"%\"", enum_name, name);
        return false;
    }
    change_return_type_to_enum(name, function_type, e);
    return true;
}

change_return_type_to_enum :: (name: string, function_type: *Function_Type, e: *Enum) {
    if !e.type {
        log("Warning: Replacing return type of % with enum %, whose type is not set.", name, e.output_name);
    }
    change_return_type(name, function_type, make_enum_type(e));
}

change_return_type :: (decl: *Declaration, new_return_type: *CType) {
    assert(decl.kind == .FUNCTION && decl.type && decl.type.type_of_function != null);
    change_return_type(decl.output_name, decl.type.type_of_function, new_return_type);
}

change_return_type :: (name: string, function_type: *Function_Type, new_return_type: *CType) {
    old := function_type.return_type;
    if old && old.size != new_return_type.size {
        log("Warning: Replacing return type of % (size %) with a type of different size %", name, old.size, new_return_type.size);
    }
    function_type.return_type = new_return_type;
}

// The enum named `enum_name` (C or output name) visible from `decl`: its enclosing structs and
// namespaces first, then the global scope. `decl` may be null.
find_parent_enum :: (decl: *Declaration, enum_name: string) -> *Enum {
    find_in :: (declarations: [] *Declaration, enum_name: string) -> *Enum {
        for declarations {
            if it.kind == .ENUM && (it.name == enum_name || it.output_name == enum_name) return cast(*Enum) it;
        }
        return null;
    }

    scope := ifx decl then decl.parent else null;
    while scope {
        found: *Enum;
        if scope.kind == .STRUCT         found = find_in((cast(*Struct) scope).declarations, enum_name);
        else if scope.kind == .NAMESPACE found = find_in((cast(*Namespace) scope).declarations, enum_name);
        if found return found;
        scope = scope.parent;
    }
    found := find_in(context.generator.global_scope.members, enum_name);
    if found return found;
    for context.generator.enum_macros {
        if it.name == enum_name || it.output_name == enum_name return it;
    }
    return null;
}

// The declared name (or, with `output_name`, the Jai name) of an enum, struct or typedef type.
get_type_name :: (type: *CType, output_name := true, strip_pointers := false) -> string {
    t := type;
    while strip_pointers && t && t.pointer_to  t = t.pointer_to;
    if !t return "";
    decl: *Declaration;
    if t.type_of_enum         decl = t.type_of_enum;
    else if t.type_of_struct  decl = t.type_of_struct;
    else if t.type_of_typedef decl = t.type_of_typedef;
    if !decl return "";
    return ifx output_name then decl.output_name else decl.name;
}

is_pointer_type :: (type: *CType) -> bool {
    t := strip_type(type, typedefs = true);
    return t && t.pointer_to != null;
}

is_function_type :: (type: *CType) -> bool {
    t := strip_type(type, typedefs = true);
    return t && t.type_of_function != null;
}

find_underlying_type :: (type: *CType) -> *CType {
    return strip_type(type, typedefs = true);
}

is_zero_int_expression :: (expression: *Expression) -> bool {
    if !expression || expression.kind != .LITERAL return false;
    lit := cast(*Literal) expression;
    return lit.literal_kind == .INTEGER && lit.int_value == 0;
}

// The struct a type names, directly or through pointers and arrays.
try_find_struct_in_type :: (type: *CType) -> *Struct {
    if !type return null;
    if type.type_of_struct     return type.type_of_struct;
    if type.array_element_type return try_find_struct_in_type(type.array_element_type);
    if type.pointer_to         return try_find_struct_in_type(type.pointer_to);
    return null;
}

is_operator_name :: (name: string) -> bool {
    return begins_with(name, "operator");
}

// `operator+=`, `operator=` (but not `operator==` and friends).
is_assignment_operator :: (name: string) -> bool {
    if !is_operator_name(name) return false;
    op := trim(advance(name, "operator".count));
    if !op || op[op.count - 1] != #char "=" return false;
    return op != "==" && op != "!=" && op != "<=" && op != ">=";
}

// An identifier for a C++ operator (`operator!=` -> `operator_not_equals`). With
// `keep_operators_allowed_in_jai`, the operators Jai can overload keep their symbol.
replace_operator_name :: (name: string, keep_operators_allowed_in_jai := false) -> string {
    if keep_operators_allowed_in_jai {
        op := replace_all(advance(name, "operator".count), " ", "");
        for JAI_OPERATORS  if it == op return tprint("operator%", op);
    }
    result, overloadable := operator_names(name, 0);
    return result;
}

// `A.B.` for a declaration nested in A.B, relative to `current_scope`.
append_parent_path :: (builder: *String_Builder, decl: *Declaration, current_scope: *Declaration) {
    if !decl || decl == current_scope return;
    scope := current_scope;
    while scope {
        if scope == decl return;
        scope = scope.parent;
    }
    if decl.parent append_parent_path(builder, decl.parent, current_scope);
    if decl.kind == .NAMESPACE && (cast(*Namespace) decl).should_flatten return;
    if !decl.output_name return;
    append(builder, decl.output_name);
    append(builder, ".");
}

// The header directories the reference passes as `-isystem` when `system_include_paths` is
// empty. libclang adds its own builtin headers, so only the C library directories are listed
// (the SDK's on macOS, the NDK's for Android, /usr/include on Linux; none for Windows).
get_default_system_include_paths :: (os := OS, cpu := CPU) -> [] string {
    paths: [..] string;
    if os == .WINDOWS return paths;
    libc_path, libc_platform_path, ok := get_libc_paths(os, cpu);
    if !ok return paths;
    array_add(*paths, libc_path);
    if libc_platform_path != libc_path  array_add(*paths, libc_platform_path);
    return paths;
}

get_libc_paths :: (os := OS, cpu := CPU) -> libc_path: string, libc_platform_path: string, success: bool {
    if os == {
        case .LINUX;
            platform := ifx cpu == .ARM64 then "/usr/include/aarch64-linux-gnu" else "/usr/include/x86_64-linux-gnu";
            return "/usr/include", platform, true;
        case .ANDROID;
            libc_path, libc_platform_path := get_ndk_libc_paths(cpu);
            return libc_path, libc_platform_path, true;
        case .MACOS;
            sdk, ok := get_macos_sdk_path();
            if !ok return "", "", false;
            path := sprint("%/usr/include", sdk);
            return path, path, true;
    }
    return "", "", false;
}

#scope_module

make_enum_type :: (e: *Enum) -> *CType {
    t := New(CType);
    t.type_of_enum = e;
    t.size = ifx e.type then e.type.size else 4;
    return t;
}
