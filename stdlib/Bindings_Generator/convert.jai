// libclang AST -> Declaration model.

// ----------------------------------------------------------------------------
// Small helpers over the clang bridge.

cursor_kind :: (c: Cursor) -> Cursor_Kind { return cast(Cursor_Kind) clang("kind", c); }
cursor_name :: (c: Cursor) -> string { return clang_string("spelling", c); }
type_name_of :: (t: Clang_Type) -> string { return clang_string("t_spelling", t); }
type_kind :: (t: Clang_Type) -> s64 { return clang("t_kind", t); }

get_children :: (c: Cursor) -> [..] Cursor {
    result: [..] Cursor;
    list := clang("children", c);
    count := clang("last_count");
    i := 0;
    while i < count {
        array_add(*result, clang("list_item", list, i));
        i += 1;
    }
    return result;
}

file_id_for :: (name: string) -> s64 {
    if !name return 0;
    g := context.generator;
    found, id := table_find(*g.file_ids, name);
    if found return id;
    array_add(*g.filenames, name);
    new_id := g.filenames.count;
    table_add(*g.file_ids, name, new_id);
    return new_id;
}

file_name_of :: (id: s64) -> string {
    g := context.generator;
    if id <= 0 || id > g.filenames.count return "";
    return g.filenames[id - 1];
}

cursor_location :: (c: Cursor) -> Location, string {
    loc: Location;
    line := clang("location", c);
    file := clang_text();
    column := clang("last_count");
    loc.file = file_id_for(file);
    loc.line = cast(u32) line;
    loc.column = cast(u32) column;
    return loc, file;
}

is_expression_kind :: (kind: s64) -> bool { return kind >= 100 && kind < 200; }

// ----------------------------------------------------------------------------
// Names.

avoid_reserved_names :: (name: string, avoid_type_names := false) -> string {
    for RESERVED_NAMES {
        if it == name return join("_", name);
    }
    if avoid_type_names {
        for RESERVED_TYPE_NAMES {
            if it == name return join("_", name);
        }
    }
    return name;
}

is_valid_identifier_start :: (char: u8) -> bool {
    if char == #char "_" return true;
    return (char >= #char "a" && char <= #char "z") || (char >= #char "A" && char <= #char "Z");
}

is_identifier_byte :: (char: u8) -> bool {
    return is_valid_identifier_start(char) || (char >= #char "0" && char <= #char "9");
}

// `name` without the first of `strip_prefixes` it starts with. Underscores left at the front
// go as well, except one that keeps the name from starting with a digit (`_2D`).
stripped_name :: (name: string) -> string {
    for prefix: context.generator_options.strip_prefixes {
        if !begins_with(name, prefix) continue;
        rest := advance(name, prefix.count);
        while rest.count > 1 && rest[0] == #char "_" && is_valid_identifier_start(rest[1])  rest = advance(rest, 1);
        return rest;
    }
    return name;
}

// A copy of `name` with every byte an identifier cannot hold turned into `_`.
make_valid_identifier :: (name: string) -> string {
    builder: String_Builder;
    for i: 0..name.count-1 {
        byte := name[i];
        append(*builder, ifx is_identifier_byte(byte) then byte else cast(u8) #char "_");
    }
    return builder_to_string(*builder);
}

anonymous_spelling :: (name: string) -> bool {
    return !name || begins_with(name, "(anonymous") || begins_with(name, "(unnamed") || contains(name, "(unnamed ") || contains(name, "(anonymous ");
}

name_clashes :: (existing: *[..] *Declaration, name: string) -> bool {
    for existing.* {
        if it.output_name == name return true;
    }
    return false;
}

// Same name and the same argument types (the object argument is ignored on request).
functions_are_equivalent :: (a: *Function, b: *Function, ignore_first_argument := false) -> bool {
    if a.output_name != b.output_name return false;
    at := a.type.type_of_function;
    bt := b.type.type_of_function;
    first := 0;
    if ignore_first_argument {
        first = 1;
        if at.arguments.count > 0 && bt.arguments.count > 0 {
            a_const := (at.arguments[0].type.flags & .CONST) != 0;
            b_const := (bt.arguments[0].type.flags & .CONST) != 0;
            if a_const != b_const return false;
        }
    }
    if at.arguments.count != bt.arguments.count return false;
    i := first;
    while i < at.arguments.count {
        if !is_same_type(at.arguments[i].type.*, bt.arguments[i].type.*) return false;
        i += 1;
    }
    return true;
}

avoid_name_clash :: (existing: *[..] *Declaration, decl: *Declaration, allow_overloads := true) {
    if !existing return;
    if decl.kind == .FUNCTION && allow_overloads {
        rename_equivalent_overload(existing, decl);
        array_add(existing, decl);
        return;
    }
    while name_clashes(existing, decl.output_name) {
        decl.output_name = join(decl.output_name, "_");
    }
    array_add(existing, decl);
}

// Overloads are fine unless they would look identical in Jai (`f(int&)` and `f(const int&)`
// are both `f :: (v: *s32)`): the later one becomes `f_1`, and both get comments saying
// which C++ types they take.
rename_equivalent_overload :: (existing: *[..] *Declaration, decl: *Declaration) {
        original := decl.output_name;
        count := 0;
        while true {
            clash := false;
            for existing.* {
                if it.kind == .FUNCTION && it != decl && functions_are_equivalent(cast(*Function) it, cast(*Function) decl) {
                    // Both get `/*const reference*/` comments to tell the overloads apart.
                    other := cast(*Function) it;
                    if other.type && other.type.type_of_function  other.type.type_of_function.flags |= .ADD_C_TYPE_DETAILS;
                    self_func := cast(*Function) decl;
                    if self_func.type && self_func.type.type_of_function  self_func.type.type_of_function.flags |= .ADD_C_TYPE_DETAILS;
                    clash = true;
                    break;
                }
                if it.kind != .FUNCTION && it.output_name == decl.output_name { clash = true; break; }
            }
            if !clash break;
            count += 1;
            decl.output_name = tprint("%_%", original, count);
        }
}

// ----------------------------------------------------------------------------
// Primitive types.

make_number_type :: (flags: Number_Flags, size: s64) -> *CType {
    t := New(CType);
    t.number_flags = flags;
    t.size = size;
    return t;
}

init_generator :: (g: *Generator_State) {
    g.type_def_void = New(CType);
    g.type_def_void.hardcoded_jai_string = "void";
    g.type_def_void.size = 0;

    g.type_def_bool = New(CType);
    g.type_def_bool.hardcoded_jai_string = "bool";
    g.type_def_bool.size = 1;

    g.type_def_u8  = make_number_type(.None | ._8BIT, 1);
    g.type_def_u16 = make_number_type(.None | ._16BIT, 2);
    g.type_def_u32 = make_number_type(.None | ._32BIT, 4);
    g.type_def_u64 = make_number_type(.None | ._64BIT, 8);
    g.type_def_u128 = New(CType);
    g.type_def_u128.hardcoded_jai_string = "U128";   // Basic's 128-bit integers
    g.type_def_u128.size = 16;
    g.type_def_s8  = make_number_type(.SIGNED | ._8BIT, 1);
    g.type_def_s16 = make_number_type(.SIGNED | ._16BIT, 2);
    g.type_def_s32 = make_number_type(.SIGNED | ._32BIT, 4);
    g.type_def_s64 = make_number_type(.SIGNED | ._64BIT, 8);
    g.type_def_s128 = New(CType);
    g.type_def_s128.hardcoded_jai_string = "S128";
    g.type_def_s128.size = 16;
    g.type_def_float32 = make_number_type(.FLOAT | .SIGNED | ._32BIT, 4);
    g.type_def_float64 = make_number_type(.FLOAT | .SIGNED | ._64BIT, 8);

    g.type_def_ptr_void = New(CType);
    g.type_def_ptr_void.pointer_to = g.type_def_void;
    g.type_def_ptr_void.size = 8;

    g.type_def_jai_string = New(CType);
    g.type_def_jai_string.hardcoded_jai_string = "string";
    g.type_def_jai_string.size = 16;

    g.type_def_type = New(CType);
    g.type_def_type.hardcoded_jai_string = "Type";
    g.type_def_type.size = 8;

    g.type_def_objc_class = create_empty_struct_type("Class");
    g.type_def_objc_selector = create_empty_struct_type("Selector");
    g.type_def_objc_block_pointer = create_empty_struct_type("Block");
    g.type_def_objc_id = create_empty_struct_type("id");

    // Windows module type of the hidden argument of MSVC virtual destructors.
    g.type_def_msvc_destructor_flags = New(CType);
    g.type_def_msvc_destructor_flags.hardcoded_jai_string = "Msvc_Destructor_Flags";
    g.type_def_msvc_destructor_flags.size = 4;
}

// A named type the Objective_C module defines (`id`, `Class`...); only its name is printed.
create_empty_struct_type :: (name: string) -> *CType {
    t, holder := struct_type_named(name, name, 8);
    holder.type = t;
    return t;
}

// A struct type that only exists to be printed by name; the struct has no members.
struct_type_named :: (name: string, output_name: string, size: s64) -> *CType, *Struct {
    t := New(CType);
    t.size = size;
    t.type_of_struct = New(Struct);
    t.type_of_struct.name = name;
    t.type_of_struct.output_name = output_name;
    return t, t.type_of_struct;
}

get_int_type :: (size: s64, signed: bool) -> *CType {
    g := context.generator;
    if size == {
        case 1; return ifx signed then g.type_def_s8 else g.type_def_u8;
        case 2; return ifx signed then g.type_def_s16 else g.type_def_u16;
        case 4; return ifx signed then g.type_def_s32 else g.type_def_u32;
        case 8; return ifx signed then g.type_def_s64 else g.type_def_u64;
        case 16; return ifx signed then g.type_def_s128 else g.type_def_u128;
    }
    return ifx signed then g.type_def_s32 else g.type_def_u32;
}

create_pointer_to :: (pointee: *CType) -> *CType {
    pointer := New(CType);
    pointer.size = context.generator.pointer_size;
    pointer.pointer_to = pointee;
    return pointer;
}

// Looks through typedefs and/or enums down to the type they stand for.
strip_type :: (type: *CType, typedefs := false, enums := false) -> *CType {
    t := type;
    while t {
        under: *CType;
        if typedefs && t.type_of_typedef     under = t.type_of_typedef.type;
        else if enums && t.type_of_enum      under = t.type_of_enum.type;
        if !under break;
        t = under;
    }
    return t;
}

// ----------------------------------------------------------------------------
// Typedef unwrapping.

// Fixed-width and size typedefs print as the Jai integer they name.
should_unwrap_typedef :: (name: string) -> bool {
    if array_find(TYPEDEFS_TO_UNWRAP, name) return true;
    return starts_with_any(name, TYPEDEF_PREFIXES_TO_UNWRAP) || starts_with_any(name, context.generator_options.typedef_prefixes_to_unwrap);
}

starts_with_any :: (text: string, prefixes: [] string) -> bool {
    for prefixes {
        if begins_with(text, it) return true;
    }
    return false;
}

// Whether a declaration that lives in `file` is generated at all.
is_user_declaration :: (c: Cursor, name: string) -> bool {
    line := clang("location", c);
    file := clang_text();
    if !file return false;
    if !clang("system_header", c) return true;
    options := *context.generator_options;
    lower := to_lower_copy(file);
    for options.path_fragments_to_treat_as_non_system_paths {
        if contains(lower, it) return true;
    }
    for options.system_types_to_include {
        if it == name return true;
    }
    return false;
}

// ----------------------------------------------------------------------------
// Comments.

fill_comment :: (comment: *Comment, c: Cursor, location: Location) {
    if !context.generator_options.try_to_preserve_comments return;
    text := clang_string("comment", c);
    if !text return;
    comment.text = text;
    // The location is only kept for a comment that starts on an earlier line than the
    // declaration: that makes it a prefix comment. A same-line comment follows the declaration.
    comment_line := clang("comment_line", c);
    if comment_line > 0 && comment_line < location.line {
        comment.location = location;
        comment.location.line = xx comment_line;
    }
}

is_prefix_comment :: (comment: Comment) -> bool {
    t := comment.text;
    if !t return false;
    if begins_with(t, "///<") || begins_with(t, "//<") || begins_with(t, "/**<") || begins_with(t, "/*<") return false;
    return comment.location.line > 0 || find_index_from_left(t, #char "\n") != -1;
}

// ----------------------------------------------------------------------------
// Types.

create_type :: (ty: Clang_Type, ctx: Cursor = 0) -> *CType {
    g := context.generator;
    kind := type_kind(ty);

    if kind == T_ELABORATED {
        named := clang("t_named", ty);
        return create_type(named, ctx);
    }
    if kind == T_UNEXPOSED || kind == T_AUTO {
        canonical := clang("t_canonical", ty);
        if canonical != ty && type_kind(canonical) != T_UNEXPOSED  return create_type(canonical, ctx);
        if kind == T_UNEXPOSED {
            unexposed := create_unexposed_type(ty, ctx);
            if unexposed return unexposed;
        }
    }

    size := clang("t_sizeof", ty);
    result: *CType;

    if kind == {
        case T_VOID;       return g.type_def_void;
        case T_BOOL;       return g.type_def_bool;
        case T_CHAR_U;     return g.type_def_u8;
        case T_UCHAR;      return g.type_def_u8;
        case T_CHAR_S;     return g.type_def_u8;
        case T_SCHAR;      return g.type_def_s8;
        case T_USHORT;     return g.type_def_u16;
        case T_UINT;       return g.type_def_u32;
        case T_ULONG;      return get_int_type(size, false);
        case T_ULONGLONG;  return g.type_def_u64;
        case T_UINT128;    return g.type_def_u128;
        case T_SHORT;      return g.type_def_s16;
        case T_INT;        return g.type_def_s32;
        case T_LONG;       return get_int_type(size, true);
        case T_LONGLONG;   return g.type_def_s64;
        case T_INT128;     return g.type_def_s128;
        case T_CHAR16;     return g.type_def_u16;
        case T_CHAR32;     return g.type_def_u32;
        case T_WCHAR;      return get_int_type(size, true);
        case T_FLOAT;      return g.type_def_float32;
        case T_DOUBLE;     return g.type_def_float64;
        case T_LONGDOUBLE;
            // arm64 Apple and Windows: a double. x86-64 and Linux arm64: 16 bytes, which only
            // jaic's Long_Double extension can pass. Without it they stay bytes so structs keep
            // their layout, and functions that pass one are stripped (see uses_wide_long_double).
            if size == 8 return g.type_def_float64;
            if size == 4 return g.type_def_float32;
            result = New(CType);
            if context.generator_options.use_jaic_long_double {
                result.hardcoded_jai_string = "Long_Double";
            } else {
                result.array_element_type = g.type_def_u8;
                result.array_element_count = size;
            }
            result.size = size;
            result.alignment = clang("t_alignof", ty);
            result.flags |= .WIDE_LONG_DOUBLE;
            return result;
        case T_NULLPTR;    return g.type_def_ptr_void;

        case T_POINTER;
            pointee := clang("t_pointee", ty);
            pk := type_kind(pointee);
            if pk == T_ELABORATED {
                named := clang("t_named", pointee);
                if type_kind(named) == T_TYPEDEF {
                    pointee = named;
                    pk = T_TYPEDEF;
                }
            }
            if pk == T_ELABORATED || pk == T_TYPEDEF {
                // A pointer to a typedef of a function type is still a function pointer.
                canonical := clang("t_canonical", pointee);
                if type_kind(canonical) == T_FUNCTIONPROTO || type_kind(canonical) == T_FUNCTIONNOPROTO {
                    if pk == T_TYPEDEF {
                        // `stbi_write_func *f`: a Jai procedure type is already a pointer, so the
                        // typedef name stands for the pointer.
                        named := create_type(pointee, ctx);
                        if named && named.type_of_typedef {
                            result = New(CType);
                            result.* = named.*;
                            result.size = size;
                            return result;
                        }
                    }
                    pk = type_kind(canonical);
                    pointee = canonical;
                }
            }
            if pk == T_FUNCTIONPROTO || pk == T_FUNCTIONNOPROTO {
                result = New(CType);
                result.type_of_function = create_function_type(pointee, 0, null);
                result.size = size;
                return result;
            }
            result = create_pointer_to(create_type(pointee, ctx));
            result.size = size;
            if clang("t_const", pointee) result.pointer_to = copy_ctype_const(result.pointer_to);
            return result;

        case T_BLOCKPOINTER;
            return create_block_type(ty, ctx);

        case T_OBJCTYPEPARAM;
            // A generic parameter of an Objective-C class (`T` in `@interface Box<T>`).
            param_decl := clang("t_decl", ty);
            return make_type_param_placeholder(ifx param_decl then cursor_name(param_decl) else type_name_of(ty));

        case T_ATTRIBUTED;
            return create_type(clang("t_modified", ty), ctx);

        case T_OBJCID;     return g.type_def_objc_id;
        case T_OBJCCLASS;  return g.type_def_objc_class;
        case T_OBJCSEL;    return g.type_def_objc_selector;

        case T_OBJCINTERFACE;
            result = New(CType);
            result.type_of_struct = create_objc_interface(clang("t_decl", ty), true);
            result.size = 0;
            return result;

        case T_OBJCOBJECT;
            return create_objc_object_type(ty);

        case T_OBJCOBJECTPOINTER;
            pointee := clang("t_pointee", ty);
            inner := create_type(pointee, ctx);
            // `id` and `Class` are pointers already.
            if inner == g.type_def_objc_id || inner == g.type_def_objc_class return inner;
            result = create_pointer_to(inner);
            return result;

        case T_LVALUEREF; #through;
        case T_RVALUEREF;
            pointee := clang("t_pointee", ty);
            result = create_pointer_to(create_type(pointee, ctx));
            result.flags |= .REFERENCE;
            if clang("t_const", pointee) result.flags |= .CONST;
            result.size = g.pointer_size;
            return result;

        case T_RECORD;
            decl := clang("t_decl", ty);
            return create_record_type(ty, decl, ctx, size);

        case T_ENUM;
            decl := clang("t_decl", ty);
            e := create_enum(decl);
            result = New(CType);
            result.type_of_enum = e;
            result.size = size;
            return result;

        case T_TYPEDEF;
            decl := clang("t_decl", ty);
            name := cursor_name(decl);
            if cursor_kind(decl) == .TEMPLATE_TYPE_PARAMETER  return make_type_param_placeholder(name);   // `T` of `Box<T>`.
            if should_unwrap_typedef(name) {
                return create_type(clang("typedef_underlying", decl), ctx);
            }
            if !is_user_declaration(decl, name) {
                // A typedef from a system header is used by name and not generated: `time_t`,
                // `FILE` or `socklen_t` are expected to come from POSIX, Windows and the like.
                result = New(CType);
                result.hardcoded_jai_string = name;
                result.size = size;
                result.alignment = clang("t_alignof", ty);
                return result;
            }
            td := create_typedef(decl);
            if !td || td.should_unwrap {
                return create_type(clang("typedef_underlying", decl), ctx);
            }
            result = New(CType);
            result.type_of_typedef = td;
            result.size = size;
            return result;

        case T_FUNCTIONPROTO; #through;
        case T_FUNCTIONNOPROTO;
            result = New(CType);
            result.type_of_function = create_function_type(ty, 0, null);
            result.size = size;
            return result;

        case T_CONSTANTARRAY;
            result = New(CType);
            result.array_element_type = create_type(clang("t_element", ty), ctx);
            result.array_element_count = clang("t_array_size", ty);
            result.size = size;
            return result;

        case T_INCOMPLETEARRAY;
            result = New(CType);
            result.array_element_type = create_type(clang("t_element", ty), ctx);
            result.array_element_count = -1;
            result.size = -1;
            return result;

        case T_VARIABLEARRAY; #through;
        case T_DEPENDENTSIZEDARRAY;
            result = create_pointer_to(create_type(clang("t_element", ty), ctx));
            return result;
    }

    // Anything else (vectors, complex numbers, templates...) becomes opaque bytes.
    result = New(CType);
    if size > 0 {
        result.array_element_type = g.type_def_u8;
        result.array_element_count = size;
        result.size = size;
    } else {
        result.hardcoded_jai_string = "void";
    }
    if context.generator_options.log_unsupported {
        log("Bindings_Generator: unsupported type '%' (kind %)\n", type_name_of(ty), kind);
    }
    return result;
}

// A block pointer (`void (^)(int)`) points to a block literal: the Objective-C block header
// with the `invoke` function first receiving the block itself. One struct per signature,
// named `Block_<result>_<args>` (`*` becomes `P`), is added to the global scope.
create_block_type :: (ty: Clang_Type, ctx: Cursor) -> *CType {
    g := context.generator;
    pointee := clang("t_pointee", ty);
    pk := type_kind(pointee);
    if pk != T_FUNCTIONPROTO && pk != T_FUNCTIONNOPROTO return g.type_def_ptr_void;
    ft := create_function_type(pointee, 0, null);
    if !ft.return_type return g.type_def_ptr_void;
    ft.return_type = erase_objc_type_params(ft.return_type);
    for ft.arguments  it.type = erase_objc_type_params(it.type);

    builder: String_Builder;
    append(*builder, "Block_");
    append(*builder, sanitize_for_identifier(type_to_string(ft.return_type)));
    for ft.arguments {
        append(*builder, "_");
        append(*builder, sanitize_for_identifier(type_to_string(it.type)));
    }
    name := builder_to_string(*builder);

    found, existing := table_find(*g.objc_blocks, name);
    if found return create_pointer_to(existing);

    s := New(Struct);
    s.kind = .STRUCT;
    s.name = name;
    s.output_name = name;
    if ctx s.location = cursor_location(ctx);
    s.flags |= .NO_STRUCT_CHECKS | .OBJC_BLOCK;
    s.type = New(CType);
    s.type.type_of_struct = s;
    s.type.size = 32;
    table_add(*g.objc_blocks, name, s.type);

    add_plain_member(s, "isa", g.type_def_ptr_void);
    add_plain_member(s, "flags", g.type_def_s32);
    add_plain_member(s, "reserved", g.type_def_s32);

    block_arg := New(Declaration);
    block_arg.kind = .DECLARATION;
    block_arg.name = "block";
    block_arg.output_name = "block";
    block_arg.type = create_pointer_to(s.type);
    arguments: [..] *Declaration;
    array_add(*arguments, block_arg);
    for ft.arguments  array_add(*arguments, it);
    ft.arguments = arguments;
    invoke_type := New(CType);
    invoke_type.type_of_function = ft;
    invoke_type.size = 8;
    add_plain_member(s, "invoke", invoke_type);
    add_plain_member(s, "descriptor", g.type_def_ptr_void);

    array_add(*g.global_scope.members, s);
    table_add(*g.added_to_scope, s, true);
    return create_pointer_to(s.type);
}

add_plain_member :: (s: *Struct, name: string, type: *CType) {
    member := New(Declaration);
    member.kind = .DECLARATION;
    member.name = name;
    member.output_name = name;
    member.parent = s;
    member.location = s.location;
    member.type = type;
    array_add(*s.declarations, member);
}

sanitize_for_identifier :: (text: string) -> string {
    builder: String_Builder;
    for 0..text.count-1 {
        c := text[it];
        if c == #char "*" append(*builder, "P");
        else if is_identifier_byte(c) append(*builder, c);
    }
    return builder_to_string(*builder);
}

// A record type; instantiations of class templates refer to the template itself
// and carry their arguments in `template_instantiation_params`.
create_record_type :: (ty: Clang_Type, decl: Cursor, ctx: Cursor, size: s64) -> *CType {
    base := clang("specialized_template", decl);
    if base decl = base;
    s := create_struct(decl);
    result := New(CType);
    result.type_of_struct = s;
    result.size = size;
    if base  fill_template_arguments(ty, result, ctx);
    return result;
}

// A template parameter used as a type (`T value;`) is a stand-in struct named like the parameter.
make_placeholder_struct :: (name: string, comment: string) -> *CType {
    t := struct_type_named(name, avoid_reserved_names(stripped_name(name), true), 0);
    t.comment = comment;
    return t;
}

looks_like_valid_identifier :: (name: string) -> bool {
    if !name return false;
    for 0..name.count-1 {
        c := name[it];
        if c == #char ":" || c == #char "<" || c == #char " " return false;
    }
    return true;
}

// libclang reports dependent types (`T`, `Foo<T>`) as unexposed. Their declaration
// (or, failing that, the first references under the cursor that uses the type)
// still names the template involved.
create_unexposed_type :: (ty: Clang_Type, ctx: Cursor) -> *CType {
    g := context.generator;
    decl := clang("t_decl", ty);
    if decl {
        dk := cursor_kind(decl);
        if dk == .TEMPLATE_TYPE_PARAMETER || dk == .NON_TYPE_TEMPLATE_PARAMETER || dk == .TEMPLATE_TEMPLATE_PARAMETER {
            return make_type_param_placeholder(cursor_name(decl));
        }
        return create_record_type(ty, decl, ctx, clang("t_sizeof", ty));
    }
    if !ctx return null;

    // Collect the references below `ctx`: a name, then (for a template) its arguments.
    refs: [..] Cursor;
    collect_references(ctx, *refs, 0);
    if refs.count == 0 return null;
    name := cursor_name(refs[0]);
    is_template_ref := cursor_kind(refs[0]) == .TEMPLATE_REF;
    if !looks_like_valid_identifier(name) {
        if !context.generator_options.add_placeholders_for_unresolved_types return null;
        return make_placeholder_struct("UnknownTypePlaceholder", tprint("/* % */", type_name_of(ty)));
    }
    result := make_placeholder_struct(name, "");
    if is_template_ref {
        i := 1;
        while i < refs.count {
            if cursor_kind(refs[i]) != .TYPE_REF return null;
            arg := create_type(clang("type", refs[i]), refs[i]);
            if !arg return null;
            array_add(*result.template_instantiation_params, arg);
            i += 1;
        }
    }
    return result;
}

// Pre-order list of the cursors below `c`.
collect_references :: (c: Cursor, refs: *[..] Cursor, depth: s64) {
    children := get_children(c);
    for children {
        array_add(refs, it);
        if depth < 4  collect_references(it, refs, depth + 1);
    }
}

// The arguments of a template instantiation, by position.
fill_template_arguments :: (ty: Clang_Type, result: *CType, ctx: Cursor) -> bool {
    count := clang("t_num_template_args", ty);
    spelling := type_name_of(ty);
    i := 0;
    while i < count {
        arg_ty := clang("t_template_arg", ty, i);
        ak := type_kind(arg_ty);
        arg: *CType;
        if ak == T_INVALID {
            // Non-type arguments (`Foo<3>`) have no type; take the literal from the spelling.
            text := template_argument_text(spelling, i);
            if text && (is_digit(text[0]) || text == "true" || text == "false" || text[0] == #char "-") {
                arg = New(CType);
                arg.hardcoded_jai_string = text;
                arg.size = 0;
            } else if context.generator_options.add_placeholders_for_unresolved_types {
                arg = make_placeholder_struct("UnknownTemplateArgumentPlaceholder", ifx text then tprint("/* % */", text) else "");
            } else return false;
        } else if ak == T_UNEXPOSED && clang("t_num_template_args", arg_ty) <= 0 {
            name := type_name_of(arg_ty);
            if looks_like_valid_identifier(name) {
                arg = make_placeholder_struct(name, "");
            } else if context.generator_options.add_placeholders_for_unresolved_types {
                arg = make_placeholder_struct("UnknownTemplateArgumentPlaceholder", tprint("/* % */", name));
            } else return false;
        } else {
            arg = create_type(arg_ty, ctx);
        }
        if !arg return false;
        array_add(*result.template_instantiation_params, arg);
        i += 1;
    }
    return true;
}

// The text of the `index`th top-level argument in `Name<a, b<c>, d>`.
template_argument_text :: (spelling: string, index: s64) -> string {
    start := -1;
    for 0..spelling.count-1 {
        if spelling[it] == #char "<" { start = it + 1; break; }
    }
    if start < 0 return "";
    depth := 0;
    current := 0;
    arg_start := start;
    i := start;
    while i < spelling.count {
        c := spelling[i];
        if c == #char "<" || c == #char "(" depth += 1;
        else if (c == #char ">" || c == #char ")") && depth > 0 depth -= 1;
        else if (c == #char "," && depth == 0) || (c == #char ">" && depth == 0) {
            if current == index return trim(slice(spelling, arg_start, i - arg_start));
            current += 1;
            arg_start = i + 1;
            if c == #char ">" break;
        }
        i += 1;
    }
    return "";
}

copy_ctype_const :: (t: *CType) -> *CType {
    // Pointee constness is only recorded on the pointer type.
    return t;
}

is_char_pointer_type :: (type: *CType) -> bool {
    if !type || !type.pointer_to return false;
    pointee := type.pointer_to.number_flags;
    return (pointee & ._8BIT) != 0 && (pointee & .FLOAT) == 0;
}

// x87 `long double` (and Linux arm64's binary128) arguments or results: only jaic's Long_Double
// can pass them, and on x86-64 a method returning one would also need objc_msgSend_fpret.
uses_wide_long_double :: (ft: *Function_Type) -> bool {
    if !ft return false;
    if ft.return_type && (ft.return_type.flags & .WIDE_LONG_DOUBLE) return true;
    for ft.arguments  if it.type && (it.type.flags & .WIDE_LONG_DOUBLE) return true;
    return false;
}

// A `va_list` parameter cannot be passed from Jai (`vprintf` and friends).
function_has_a_valist_arg :: (func: *Function) -> bool {
    arguments := func.type.type_of_function.arguments;
    for arguments {
        if !is_va_list(it.type) continue;
        return true;
    }
    return false;
}

// Recognized by name: platforms spell it as a typedef, a builtin struct or `__va_list_tag`.
is_va_list :: (type: *CType) -> bool {
    if !type return false;
    if contains(type.hardcoded_jai_string, "va_list") return true;
    if type.type_of_typedef return contains(type.type_of_typedef.name, "va_list");
    return type.type_of_struct != null && contains(type.type_of_struct.name, "va_list");
}

// ----------------------------------------------------------------------------
// Function types and functions.

create_function_type :: (ty: Clang_Type, cur: Cursor, func: *Function) -> *Function_Type {
    ft := New(Function_Type);
    kind: Cursor_Kind;
    if cur kind = cursor_kind(cur);

    if kind == .CONSTRUCTOR {
        ft.flags |= .CONSTRUCTOR;
        if clang("is_copy_ctor", cur) ft.flags |= .COPY_CONSTRUCTOR;
        else if clang("is_move_ctor", cur) ft.flags |= .MOVE_CONSTRUCTOR;
    } else if kind == .DESTRUCTOR {
        ft.flags |= .DESTRUCTOR;
    }
    if cur && clang("is_inlined", cur) ft.flags |= .INLINE;

    // Non-static member functions take the object as a hidden first argument.
    is_cpp_method := (kind == .CONSTRUCTOR || kind == .DESTRUCTOR) || (kind == .CXX_METHOD && !clang("is_static_method", cur));
    if is_cpp_method {
        ft.flags |= .CPP_METHOD;
        parent := clang("semantic_parent", cur);
        this_arg := New(Declaration);
        this_arg.kind = .DECLARATION;
        this_arg.name = "this";
        this_arg.output_name = "this";
        parent_type := New(CType);
        parent_type.type_of_struct = create_struct(parent);
        parent_type.size = clang("t_sizeof", clang("type", parent));
        this_arg.type = create_pointer_to(parent_type);
        if clang("is_const_method", cur) this_arg.type.flags |= .CONST;
        array_add(*ft.arguments, this_arg);
    }

    ft.return_type = create_type(clang("t_result", ty), cur);
    if clang("t_variadic", ty) ft.flags |= .VARIADIC;
    // MSVC virtual destructors take a hidden flags argument (bit 0: free the memory, bit 1: delete[]).
    windows_virtual_destructor := kind == .DESTRUCTOR && context.generator_options.os == .WINDOWS && clang("is_virtual", cur);

    count := clang("t_num_args", ty);
    if count < 0 count = 0;
    cursor_args := 0;
    if cur cursor_args = clang("num_args", cur);

    i := 0;
    unknown_count := 0;
    while i < count {
        arg := New(Declaration);
        arg.kind = .DECLARATION;
        arg_cursor: Cursor;
        if i < cursor_args  arg_cursor = clang("arg", cur, i);
        arg_type := clang("t_arg", ty, i);
        if arg_cursor {
            arg.name = cursor_name(arg_cursor);
            arg.type = create_type(clang("type", arg_cursor), arg_cursor);
            arg.location = cursor_location(arg_cursor);
            fill_default_argument(arg, arg_cursor);
        } else {
            arg.type = create_type(arg_type, cur);
        }
        // `const T&` arguments get a wrapper taking the value (see print_function).
        if (arg.type.flags & .REFERENCE) && (arg.type.flags & .CONST) {
            arg.decl_flags |= .POINTER_TO_VALUE;
        }
        if clang("t_const", arg_type) arg.decl_flags |= .IS_CONST;
        // Unnamed parameters keep an empty name and print as unknown0, unknown1, ... (existing
        // visitors match on these output names).
        if arg.name {
            arg.output_name = avoid_reserved_names(arg.name);
        } else {
            arg.output_name = tprint("unknown%", unknown_count);
            unknown_count += 1;
        }
        // Arrays decay to pointers in argument position.
        if arg.type.array_element_type {
            arg.type = create_pointer_to(arg.type.array_element_type);
        }
        array_add(*ft.arguments, arg);
        i += 1;
    }
    if windows_virtual_destructor {
        flags_arg := New(Declaration);
        flags_arg.kind = .DECLARATION;
        flags_arg.name = "flags";
        flags_arg.output_name = "flags";
        flags_arg.type = context.generator.type_def_msvc_destructor_flags;
        lit := New(Literal);
        lit.literal_kind = .RAW_CPP_TOKENS;
        lit.raw_value = ".NONE";
        flags_arg.expression = lit;
        array_add(*ft.arguments, flags_arg);
    }
    return ft;
}

// Parameter names of a function pointer type come from the PARM_DECL children
// of the typedef or field that declares it.
name_function_arguments :: (ty: *CType, c: Cursor) {
    while ty && ty.pointer_to  ty = ty.pointer_to;
    if !ty || !ty.type_of_function return;
    ft := ty.type_of_function;
    children := get_children(c);
    index := 0;
    for children {
        if cursor_kind(it) != .PARM_DECL continue;
        if index >= ft.arguments.count break;
        name := cursor_name(it);
        if name {
            ft.arguments[index].name = name;
            ft.arguments[index].output_name = avoid_reserved_names(name);
        }
        index += 1;
    }
}

// A default argument is the expression child of a parameter declaration.
fill_default_argument :: (arg: *Declaration, cursor: Cursor) {
    children := get_children(cursor);
    for children {
        k := clang("kind", it);
        if is_expression_kind(k) {
            arg.expression = create_expression_from_cursor(it, arg.type);
            return;
        }
    }
}

// Itanium manglings carry an extra leading underscore on Mach-O.
normalize_mangled_name :: (name: string) -> string {
    if begins_with(name, "__Z") return advance(name, 1);
    return name;
}

// Operators Jai can overload (binary form only); everything else becomes a plain function.
JAI_OPERATORS :: string.["+", "-", "*", "/", "%", "==", "<", ">", "<=", ">=", "&", "|", "^", "<<", ">>", "[]"];

replace_all :: (text: string, from: string, to: string) -> string {
    result, count := replace(text, from, to);
    return result;
}

// Symbol -> word for operators Jai cannot overload, longest symbols first so that `<=` is not
// read as `<` followed by `=`.
OPERATOR_SPELLINGS :: string.[
    "<=>", "_spaceship",    "->*", "_arrow_star",  "->", "_arrow",
    "++",  "_plus_plus",    "--",  "_minus_minus", "==", "_equals",
    "!=",  "_not_equals",   ">=",  "_greater_equals", "<=", "_less_equals",
    "<<",  "_lshift",       ">>",  "_rshift",      "&&", "_and_and",
    "||",  "_or_or",        "+",   "_plus",        "-",  "_minus",
    "*",   "_times",        "/",   "_divide",      "%",  "_modulo",
    "^",   "_xor",          "&",   "_and",         "|",  "_or",
    "~",   "_tilde",        "<",   "_less",        ">",  "_greater",
    "[]",  "_brackets",     "!",   "_not",         "=",  "_assign",
    ",",   "_comma",        "()",  "_parens",
];

// A binary operator Jai can overload keeps its symbol (`operator+`); any other operator gets
// an identifier (`operator!=` -> `operator_not_equals`, `operator new` -> `operator_new`).
operator_names :: (name: string, argument_count: s64) -> output_name: string, overloadable: bool {
    symbol := advance(replace_all(name, " ", ""), "operator".count);
    if argument_count == 2 && array_find(JAI_OPERATORS, symbol)  return tprint("operator%", symbol), true;

    spelled := symbol;
    pair := 0;
    while pair < OPERATOR_SPELLINGS.count {
        spelled = replace_all(spelled, OPERATOR_SPELLINGS[pair], OPERATOR_SPELLINGS[pair + 1]);
        pair += 2;
    }
    // Every spelled symbol starts with `_`; conversion operators (`operator int`) do not.
    if !begins_with(spelled, "_")  spelled = tprint("_%", spelled);
    return tprint("operator%", spelled), false;
}

create_function :: (c: Cursor, parent: *Declaration) -> *Function {
    options := *context.generator_options;
    kind := cursor_kind(c);
    name := cursor_name(c);
    func := New(Function);
    func.kind = .FUNCTION;
    func.name = name;
    func.parent = parent;
    func.location = cursor_location(c);
    fill_comment(*func.comment, c, func.location);
    if kind == .CXX_METHOD || kind == .CONSTRUCTOR || kind == .DESTRUCTOR {
        func.is_virtual = clang("is_virtual", c) != 0;
    }

    func_type := clang("type", c);
    func.type = New(CType);
    func.type.type_of_function = create_function_type(func_type, c, func);
    func.type.size = 8;
    // Parameters of a call take their types from the declaration cursors.
    ft := func.type.type_of_function;

    if ft.flags & .CONSTRUCTOR {
        if ft.flags & .COPY_CONSTRUCTOR func.name = "CopyConstructor";
        else if ft.flags & .MOVE_CONSTRUCTOR func.name = "MoveConstructor";
        else func.name = "Constructor";
        if options.strip_flags & .CONSTRUCTORS func.decl_flags |= .OMIT_FROM_OUTPUT;
    } else if ft.flags & .DESTRUCTOR {
        func.name = "Destructor";
        if options.strip_flags & .DESTRUCTORS func.decl_flags |= .OMIT_FROM_OUTPUT;
    }
    // Inline functions defined in a header have no symbol in the library.
    if (options.strip_flags & .INLINED_FUNCTIONS) && (ft.flags & .INLINE) {
        func.decl_flags |= .OMIT_FROM_OUTPUT;
    }
    func.output_name = avoid_reserved_names(stripped_name(func.name));
    if begins_with(name, "operator") &&!(ft.flags & (.CONSTRUCTOR | .DESTRUCTOR)) {
        func.output_name, func.is_operator = operator_names(name, ft.arguments.count);
    }

    // C++ functions bind to their mangled names; C symbols keep the plain name.
    if ft.flags & (.CONSTRUCTOR | .DESTRUCTOR) {
        // Itanium emits several variants: C1 complete / C2 base constructor,
        // D1 complete / D0 deleting / D2 base destructor.
        manglings := clang("manglings", c);
        constructor_name := "";
        if ft.flags & .CONSTRUCTOR constructor_name = tprint("%C1E", name);
        i := 0;
        while i < manglings {
            mangled := normalize_mangled_name(clang_string("mangling_item", i));
            if ft.flags & .CONSTRUCTOR {
                if contains(mangled, constructor_name) func.foreign_name = mangled;
            } else {
                if ends_with(mangled, "D0Ev") func.deleting_foreign_name = mangled;
                else if ends_with(mangled, "D1Ev") func.foreign_name = mangled;
                else if ends_with(mangled, "D2Ev") func.base_foreign_name = mangled;
            }
            i += 1;
        }
        if !func.foreign_name && manglings > 0  func.foreign_name = normalize_mangled_name(clang_string("mangling_item", 0));
        if !func.foreign_name return null;
    } else {
        mangled := normalize_mangled_name(clang_string("mangling", c));
        if begins_with(mangled, "_Z") func.foreign_name = mangled;
    }
    if clang("storage_class", c) == xx Storage_Class.Static {
        func.storage_class = .Static;
    }

    // `const T&` arguments get a wrapper taking the value; virtual functions
    // are called through the vtable and cannot be wrapped.
    for ft.arguments {
        if (it.decl_flags & .POINTER_TO_VALUE) && !func.is_virtual  func.decl_flags |= .NEEDS_ARGUMENT_WRAPPER;
    }

    // Operators are called with values: the wrapper takes the object by value.
    if func.is_operator && (ft.flags & .CPP_METHOD) {
        this_arg := ft.arguments[0];
        if this_arg.type.flags & .CONST {
            this_arg.decl_flags |= .POINTER_TO_VALUE;
            func.decl_flags |= .NEEDS_ARGUMENT_WRAPPER;
        }
    }

    // printf-like functions: variadic, and the last named argument is a char pointer.
    if (ft.flags & .VARIADIC) && options.generate_printf_wrappers && ft.arguments.count > 0 && !func.is_virtual {
        last := ft.arguments[ft.arguments.count - 1];
        if is_char_pointer_type(last.type) {
            func.decl_flags |= .NEEDS_PRINTF_WRAPPER;
        }
    }
    return func;
}

// ----------------------------------------------------------------------------
// Expressions (default arguments, initializers).

new_literal :: (kind: Literal_Kind) -> *Literal {
    result := New(Literal);
    result.literal_kind = kind;
    return result;
}

create_null_literal :: () -> *Literal { return new_literal(.NULL); }

create_int_literal :: (value: s64) -> *Literal {
    result := new_literal(.INTEGER);
    result.int_value = value;
    return result;
}

create_expression_from_cursor :: (c: Cursor, target_type: *CType) -> *Expression {
    kind := cursor_kind(c);

    if kind == .CXX_NULLPTR_LITERAL || kind == .GNU_NULL_EXPR return create_null_literal();
    if kind == .CXX_BOOL_LITERAL {
        tokens := tokens_of(c);
        lit := New(Literal);
        lit.literal_kind = .RAW_CPP_TOKENS;
        lit.raw_value = ifx tokens.count > 0 then tokens[0].spelling else "false";
        return lit;
    }

    // Enumerators referenced by name.
    if kind == .DECL_REF_EXPR {
        ref := clang("referenced", c);
        if ref && cursor_kind(ref) == .ENUM_CONSTANT_DECL {
            parent := clang("semantic_parent", ref);
            enum_decl := create_enum(parent);
            if enum_decl {
                lit := New(Literal);
                lit.literal_kind = .ENUM;
                lit.enum_type = enum_decl;
                name := cursor_name(ref);
                for * enum_decl.enumerates {
                    if it.name == name {
                        lit.enum_value = it;
                        break;
                    }
                }
                if lit.enum_value return lit;
            }
        }
    }

    // `(const T*)0` and friends.
    if kind == .CSTYLE_CAST_EXPR || kind == .CXX_FUNCTIONAL_CAST {
        cast_children := get_children(c);
        for cast_children {
            if !is_expression_kind(xx cursor_kind(it)) continue;
            inner := create_expression_from_cursor(it, null);
            if inner && inner.kind == .LITERAL {
                inner_lit := cast(*Literal) inner;
                if inner_lit.literal_kind == .NULL || (inner_lit.literal_kind == .INTEGER && inner_lit.int_value == 0 && target_type && target_type.pointer_to) return create_null_literal();
            }
            break;
        }
    }

    result := clang("evaluate", c);
    // CXEval_Int = 1, Float = 2, StrLiteral = 4
    if result == 1 {
        return create_int_literal(clang("eval_int"));
    } else if result == 2 {
        lit := New(Literal);
        lit.literal_kind = .FLOAT;
        bits := clang("eval_double");
        lit.float_value = << cast(*float64) *bits;
        return lit;
    } else if result == 4 {
        lit := New(Literal);
        lit.literal_kind = .STRING;
        clang("eval_string");
        lit.string_value = clang_text();
        return lit;
    }

    // Constructor calls with literal arguments: T(a, b) -> T.{a, b}
    if kind == .CALL_EXPR || kind == .UNEXPOSED_EXPR {
        children := get_children(c);
        // Implicit wrappers (casts, temporaries, cleanups) show up as one-child unexposed expressions.
        if kind == .UNEXPOSED_EXPR && children.count == 1 && is_expression_kind(xx cursor_kind(children[0])) {
            return create_expression_from_cursor(children[0], target_type);
        }
        values: [..] *Expression;
        type_name := "";
        ok := true;
        for children {
            k := cursor_kind(it);
            if k == .TYPE_REF {
                type_name = cursor_name(it);
                continue;
            }
            if is_expression_kind(xx k) {
                e := create_expression_from_cursor(it, null);
                if !e { ok = false; break; }
                array_add(*values, e);
            }
        }
        // `T()` and `{}` have no type reference child; ask the expression's own type.
        if ok && !type_name && kind == .CALL_EXPR {
            type_name = type_name_of(clang("type", c));
            if begins_with(type_name, "const ") type_name = advance(type_name, 6);
        }
        // A copy or move of a temporary: `T(T(a, b))` is just `T(a, b)`.
        if ok && kind == .CALL_EXPR && values.count == 1 && values[0].kind == .STRUCT_LITERAL {
            inner_literal := cast(*Struct_Literal) values[0];
            if inner_literal.type_name == stripped_name(strip_elaborated_keyword(type_name)) || !type_name return inner_literal;
        }
        if ok && type_name && kind == .CALL_EXPR {
            lit := New(Struct_Literal);
            lit.type_name = stripped_name(strip_elaborated_keyword(type_name));
            lit.values = values;
            return lit;
        }
    }

    if kind == .PAREN_EXPR {
        children := get_children(c);
        if children.count == 1 {
            inner := create_expression_from_cursor(children[0], target_type);
            if inner {
                p := New(Paren_Expression);
                p.child = inner;
                return p;
            }
        }
    }

    // Anything else: keep the tokens and print them as written.
    tokens := tokens_of(c);
    if tokens.count == 0 return null;
    lit := New(Literal);
    lit.literal_kind = .RAW_CPP_TOKENS;
    builder: String_Builder;
    for tokens  append(*builder, it.spelling);
    lit.raw_value = builder_to_string(*builder);
    return lit;
}

strip_elaborated_keyword :: (name: string) -> string {
    for string.["struct ", "class ", "union ", "enum "] {
        if begins_with(name, it) return advance(name, it.count);
    }
    return name;
}

// Tokens covering the extent of a cursor.
tokens_of :: (c: Cursor) -> [] Macro_Token {
    count := clang("tokenize", c);
    result: [..] Macro_Token;
    i := 0;
    while i < count {
        t: Macro_Token;
        t.kind = cast(s32) clang("token_kind", i);
        clang("token", i);
        t.spelling = clang_text();
        array_add(*result, t);
        i += 1;
    }
    return result;
}

// ----------------------------------------------------------------------------
// Typedefs.

create_typedef :: (c: Cursor) -> *Typedef {
    g := context.generator;
    found, existing := table_find(*g.declarations_by_cursor, c);
    if found return cast(*Typedef) existing;

    name := cursor_name(c);
    td := New(Typedef);
    td.kind = .TYPEDEF;
    td.name = name;
    td.output_name = avoid_reserved_names(stripped_name(name), true);
    td.location = cursor_location(c);
    fill_comment(*td.comment, c, td.location);
    table_add(*g.declarations_by_cursor, c, td);

    underlying_cursor_type := clang("typedef_underlying", c);
    td.type = create_type(underlying_cursor_type, c);
    name_function_arguments(td.type, c);

    // typedef struct { ... } Name;  gives the anonymous record its name.
    if td.type.type_of_struct && !td.type.type_of_struct.name {
        s := td.type.type_of_struct;
        s.name = name;
        s.output_name = td.output_name;
        s.flags &= ~.IS_ANON;
        td.decl_flags |= .OMIT_FROM_OUTPUT;
        array_add(*context.generator.global_scope.members, s);
        table_add(*g.added_to_scope, s, true);
        s.location = td.location;
    } else if td.type.type_of_enum && !td.type.type_of_enum.name {
        e := td.type.type_of_enum;
        e.name = name;
        e.output_name = td.output_name;
        td.decl_flags |= .OMIT_FROM_OUTPUT;
        compute_enum_names(e, false);
        array_add(*context.generator.global_scope.members, e);
        table_add(*g.added_to_scope, e, true);
        e.location = td.location;
    } else if td.type.type_of_struct && td.type.type_of_struct.name == name {
        td.decl_flags |= .OMIT_FROM_OUTPUT;
    } else if td.type.type_of_enum && td.type.type_of_enum.name == name {
        td.decl_flags |= .OMIT_FROM_OUTPUT;
    }
    return td;
}

// ----------------------------------------------------------------------------
// Structs and unions.

create_struct :: (c: Cursor) -> *Struct {
    g := context.generator;
    ck := cursor_kind(c);
    if ck == .TEMPLATE_TYPE_PARAMETER || ck == .NON_TYPE_TEMPLATE_PARAMETER || ck == .TEMPLATE_TEMPLATE_PARAMETER {
        return make_placeholder_struct(cursor_name(c), "").type_of_struct;
    }
    key := clang("definition", c);
    if !key key = clang("canonical", c);
    found, existing := table_find(*g.declarations_by_cursor, key);
    if found return cast(*Struct) existing;

    spelling := cursor_name(key);
    kind := cursor_kind(key);
    is_template := kind == .CLASS_TEMPLATE;
    s := New(Struct);
    s.kind = .STRUCT;
    if !anonymous_spelling(spelling) && !clang("is_anonymous", key) {
        s.name = spelling;
    }
    s.location = cursor_location(key);
    fill_comment(*s.comment, key, s.location);
    if kind == .UNION_DECL  s.flags |= .IS_UNION;
    if !s.name {
        s.flags |= .IS_ANON;
    } else {
        s.output_name = avoid_reserved_names(stripped_name(s.name), true);
    }
    table_add(*g.declarations_by_cursor, key, s);
    s.type = New(CType);
    s.type.type_of_struct = s;
    s.type.size = clang("t_sizeof", clang("type", key));
    if is_template {
        s.type.size = 0;
        s.decl_flags |= .TEMPLATE;
    } else if g.template_depth > 0 {
        s.decl_flags |= .TEMPLATE;
    }

    if !clang("is_definition", key) {
        s.flags |= .IS_INCOMPLETE;
        return s;
    }

    // A named struct from a system header is referred to by name only, like a system typedef.
    if s.name && !is_user_declaration(key, s.name) {
        s.flags |= .IS_SYSTEM;
        s.decl_flags |= .OMIT_FROM_OUTPUT;
    }

    if is_template g.template_depth += 1;
    fill_struct_members(s, key);
    if is_template g.template_depth -= 1;
    if s.name && !(s.flags & .IS_SYSTEM) {
        array_add(*g.structs_to_check, s);
    }
    return s;
}

// The declaration of a constant (`static const int N = 3;`, `const float PI = ...`), or null.
create_constant_declaration :: (c: Cursor) -> *Declaration {
    g := context.generator;
    ty := clang("type", c);
    if !clang("t_const", ty) return null;
    result := clang("evaluate", c);
    if result != 1 && result != 2 return null;
    name := cursor_name(c);
    decl := New(Declaration);
    decl.kind = .DECLARATION;
    decl.name = name;
    decl.output_name = avoid_reserved_names(stripped_name(name));
    decl.location = cursor_location(c);
    decl.decl_flags |= .IS_CONST;
    decl.type = create_type(ty, c);
    if result == 1 {
        decl.expression = create_int_literal(clang("eval_int"));
    } else {
        lit := New(Literal);
        lit.literal_kind = .FLOAT;
        bits := clang("eval_double");
        lit.float_value = << cast(*float64) *bits;
        decl.expression = lit;
    }
    table_set(*g.known_constants, name, true);
    return decl;
}

// A member function, constructor or destructor of `s`.
add_method :: (s: *Struct, c: Cursor) {
    g := context.generator;
    key := clang("canonical", c);
    if table_contains(*g.declarations_by_cursor, key) return;
    func := create_function(c, s);
    if !func return;
    table_add(*g.declarations_by_cursor, key, func);
    ft := func.type.type_of_function;
    if !context.generator_options.use_jaic_long_double && uses_wide_long_double(ft) {
        log_stripped(func.name, "passes a long double wider than 64 bits, which Jai has no type for");
        return;
    }

    if ft.flags & .CONSTRUCTOR {
        s.flags |= .HAS_CONSTRUCTOR;
        if ft.flags & .COPY_CONSTRUCTOR s.flags |= .HAS_COPY_CONSTRUCTOR;
        else if ft.flags & .MOVE_CONSTRUCTOR s.flags |= .HAS_MOVE_CONSTRUCTOR;
    } else if ft.flags & .DESTRUCTOR {
        s.flags |= .HAS_DESTRUCTOR;
    }

    // The base-object destructor is not virtual even when the complete one is.
    if func.base_foreign_name {
        base_copy := New(Function);
        base_copy.* = func.*;
        base_copy.name = tprint("%_Base", func.name);
        base_copy.output_name = tprint("%_Base", func.output_name);
        base_copy.foreign_name = func.base_foreign_name;
        base_copy.is_virtual = false;
        array_add(*s.declarations, base_copy);
    }

    if func.is_virtual {
        array_add(*s.virtual_functions, func);
        if func.deleting_foreign_name {
            deleting := New(Function);
            deleting.* = func.*;
            deleting.name = tprint("%_Deleting", func.name);
            deleting.output_name = tprint("%_Deleting", func.output_name);
            deleting.foreign_name = func.deleting_foreign_name;
            array_add(*s.virtual_functions, deleting);
        }
    } else {
        array_add(*s.declarations, func);
    }
}

fill_struct_members :: (s: *Struct, key: Cursor) {
    g := context.generator;
    children := get_children(key);
    bitfield: *Bitfield;
    // Byte where the previous member ended (-1: unknown), to detect padding before a bit field run.
    prev_end := ifx s.parents.count > 0 then -1 else 0;
    run_prev_end := 0;
    is_union := (s.flags & .IS_UNION) != 0;
    for children {
        kind := cursor_kind(it);
        if kind == {
            case .TEMPLATE_TYPE_PARAMETER; #through;
            case .NON_TYPE_TEMPLATE_PARAMETER; #through;
            case .TEMPLATE_TEMPLATE_PARAMETER;
                is_type := kind != .NON_TYPE_TEMPLATE_PARAMETER;
                param := New(Declaration);
                param.kind = .DECLARATION;
                param.name = cursor_name(it);
                param.output_name = avoid_reserved_names(param.name, is_type);
                param.location = cursor_location(it);
                if is_type {
                    param.type = g.type_def_type;
                } else {
                    param.type = create_type(clang("type", it), it);
                }
                array_add(*s.template_type_params, param);

            case .CXX_BASE_SPECIFIER;
                // struct B : public A  becomes  B :: struct { #as using a: A; }
                parent_type := create_type(clang("type", it), it);
                if !parent_type continue;
                base_name: string;
                if parent_type.type_of_struct base_name = parent_type.type_of_struct.name;
                else if parent_type.type_of_typedef base_name = parent_type.type_of_typedef.name;
                else continue;
                parent_decl := New(Declaration);
                parent_decl.kind = .DECLARATION;
                parent_decl.name = to_lower_copy(base_name);
                parent_decl.output_name = avoid_reserved_names(parent_decl.name);
                parent_decl.type = parent_type;
                parent_decl.parent = s;
                parent_decl.location = cursor_location(it);
                parent_decl.decl_flags |= .QUALIFIER_USING | .QUALIFIER_AS;
                parent_decl.bit_offset_in_parent = clang("base_offset", key, it);
                if clang("is_virtual_base", it) {
                    parent_decl.decl_flags &= ~.QUALIFIER_AS;
                    array_add(*s.virtual_bases, parent_decl);
                } else {
                    array_add(*s.parents, parent_decl);
                }

            case .CXX_METHOD; #through;
            case .CONSTRUCTOR; #through;
            case .DESTRUCTOR;
                // Template members have no symbols of their own to bind to.
                if g.template_depth == 0  add_method(s, it);

            case .FIELD_DECL;
                field := New(Declaration);
                field.kind = .DECLARATION;
                field.name = cursor_name(it);
                field.parent = s;
                field.location = cursor_location(it);
                fill_comment(*field.comment, it, field.location);
                field.type = create_type(clang("type", it), it);
                name_function_arguments(field.type, it);
                field.output_name = avoid_reserved_names(field.name);
                if !field.name {
                    field.name = tprint("_anon%", s.declarations.count);
                    field.output_name = field.name;
                }
                offset := clang("field_offset", it);
                if offset >= 0 field.bit_offset_in_parent = offset;
                if clang("is_bitfield", it) {
                    field.bitfield_width = clang("bit_width", it);
                    // `int : 0;` only moves the next bit field to a new storage unit;
                    // the run's storage covers the gap.
                    if field.bitfield_width == 0 continue;
                    if is_union  bitfield = null;
                    if bitfield && is_msvc_layout() && !fits_msvc_unit(bitfield, field) bitfield = null;
                    if !bitfield {
                        run_prev_end = prev_end;
                        bitfield = New(Bitfield);
                        bitfield.kind = .BITFIELD;
                        bitfield.parent = s;
                        bitfield.location = field.location;
                        bitfield.output_name = "__bitfield";
                        bitfield.name = "__bitfield";
                        bitfield.bit_offset_in_parent = field.bit_offset_in_parent;
                        array_add(*s.declarations, bitfield);
                    }
                    array_add(*bitfield.members, field);
                    finish_bitfield(bitfield, run_prev_end);
                    prev_end = ifx is_union then -1 else bitfield.start_byte + bitfield.byte_count;
                } else {
                    bitfield = null;
                    array_add(*s.declarations, field);
                    if is_union || offset < 0 || !field.type || field.type.size < 0 {
                        prev_end = -1;
                    } else {
                        prev_end = offset / 8 + field.type.size;
                    }
                }

            case .STRUCT_DECL; #through;
            case .UNION_DECL;
                if clang("is_anonymous_record", it) {
                    bitfield = null;
                    prev_end = -1;
                    nested := create_struct(it);
                    nested.parent = s;
                    nested.flags |= .IS_ANON;
                    array_add(*s.declarations, nested);
                }

            case .VAR_DECL;
                // Static data members have no place in a Jai struct; constants do.
                decl := create_constant_declaration(it);
                if decl {
                    decl.parent = s;
                    array_add(*s.declarations, decl);
                }

            case;
                // Nested enums and typedefs are not part of the layout.
        }
    }
}

// MSVC allocates bit fields in units of their declared type: a field joins the open unit only
// when its type has the same size and it still lies inside that unit; anything else (another
// size, a field that would cross the unit's end, the unit a `: 0` field skips to) starts a new
// unit. Itanium/AAPCS64 instead pack adjacent fields regardless of type.
is_msvc_layout :: () -> bool {
    return context.generator_options.os == .WINDOWS;
}

fits_msvc_unit :: (bitfield: *Bitfield, field: *Declaration) -> bool {
    first := bitfield.members[0];
    if !first.type || !field.type || first.type.size != field.type.size return false;
    unit_bits := first.type.size * 8;
    if unit_bits <= 0 return false;
    return field.bit_offset_in_parent / unit_bits == first.bit_offset_in_parent / unit_bits;
}

// The storage of an MSVC run is its whole unit: an integer of the declared type's size at the
// unit's (naturally aligned) start, which is also what C aligns the struct for.
finish_msvc_bitfield :: (bitfield: *Bitfield) {
    first := bitfield.members[0];
    unit := first.type.size;
    bitfield.alignment_type = null;
    bitfield.start_byte = first.bit_offset_in_parent / 8 / unit * unit;
    bitfield.byte_count = unit;
    if unit == 1 || unit == 2 || unit == 4 || unit == 8 {
        bitfield.type = first.type;
        if first.type.type_of_enum || first.type.type_of_typedef || first.type.pointer_to bitfield.type = get_int_type(unit, false);
    } else {
        t := New(CType);
        t.array_element_type = context.generator.type_def_u8;
        t.array_element_count = unit;
        t.size = unit;
        bitfield.type = t;
        bitfield.alignment_type = first.type;
    }
}

// Size the storage of a run of bit fields (adjacent bit fields share one `__bitfield` member).
// The storage covers exactly the bytes clang laid the run out in; it is an integer when the
// run starts at a multiple of its size (so Jai places it where C does), a byte array otherwise.
// `alignment_type` remembers the widest declared type: C aligns the struct for it even when
// the storage is narrower, which print_struct_body restores with a `#place` member.
finish_bitfield :: (bitfield: *Bitfield, prev_end: s64) {
    first := bitfield.members[0];
    last := bitfield.members[bitfield.members.count - 1];
    if is_msvc_layout() && first.type && first.type.size > 0 {
        finish_msvc_bitfield(bitfield);
        return;
    }
    start_byte := first.bit_offset_in_parent / 8;
    end_byte := (last.bit_offset_in_parent + last.bitfield_width + 7) / 8;
    bytes := end_byte - start_byte;

    widest: *CType;
    for bitfield.members {
        if it.type && (!widest || widest.size < it.type.size) widest = it.type;
    }
    bitfield.alignment_type = null;
    bitfield.type = null;

    // Integer storage must land where Jai's natural alignment puts it.
    is_int_size := bytes == 1 || bytes == 2 || bytes == 4 || bytes == 8;
    if is_int_size && start_byte % bytes == 0 && (prev_end < 0 || (prev_end + bytes - 1) / bytes * bytes == start_byte) {
        if widest && widest.size == bytes {
            bitfield.type = widest;
        } else {
            bitfield.type = get_int_type(bytes, false);
            if widest && widest.size > bytes bitfield.alignment_type = widest;
        }
    } else {
        // A byte array is aligned to 1: start it where the previous member ended.
        if prev_end >= 0 && prev_end < start_byte {
            start_byte = prev_end;
            bytes = end_byte - start_byte;
        }
        t := New(CType);
        t.array_element_type = context.generator.type_def_u8;
        t.array_element_count = bytes;
        t.size = bytes;
        bitfield.type = t;
        if widest && widest.size > 1 bitfield.alignment_type = widest;
    }
    bitfield.start_byte = start_byte;
    bitfield.byte_count = bytes;
}


// ----------------------------------------------------------------------------
// Objective-C.

// `id<P>`, `Class<P>` and `Base<Arg>`: protocols are dropped except a single protocol on `id`,
// which names the type. Type arguments of a generic class (`NSArray<NSString *>`) become the
// instantiation parameters (`NSArray(*NSString)`).
create_objc_object_type :: (ty: Clang_Type) -> *CType {
    g := context.generator;
    base := clang("t_objc_base", ty);
    base_kind := type_kind(base);
    protocols := clang("t_objc_num_protocols", ty);
    decl: Cursor;
    if base_kind == T_OBJCID {
        if protocols != 1 return g.type_def_objc_id;
        decl = clang("t_objc_protocol", ty, 0);
    } else if base_kind == T_OBJCCLASS {
        return g.type_def_objc_class;
    } else {
        decl = clang("t_decl", base);
    }
    if !decl return g.type_def_objc_id;
    result := New(CType);
    result.type_of_struct = create_objc_interface(decl, true);
    result.size = 0;
    if base_kind != T_OBJCID {
        count := clang("t_objc_num_type_args", ty);
        for 0..count-1 {
            arg := create_type(clang("t_objc_type_arg", ty, it), 0);
            if !arg arg = g.type_def_objc_id;
            array_add(*result.template_instantiation_params, arg);
        }
    }
    return result;
}

// The type of an Objective-C object inside its own (generic) declaration: `Box(T)`.
objc_self_type :: (s: *Struct) -> *CType {
    result := New(CType);
    result.type_of_struct = s;
    result.size = 0;
    for s.template_type_params  array_add(*result.template_instantiation_params, make_type_param_placeholder(it.name));
    return result;
}

make_type_param_placeholder :: (name: string) -> *CType {
    result := make_placeholder_struct(name, "");
    result.type_of_struct.flags |= .IS_TYPE_PARAM;
    return result;
}

// Block structs live outside the generic class they were seen in, so its parameters
// (`T`) are replaced by `id` (template parameters in C++ blocks too).
erase_objc_type_params :: (t: *CType) -> *CType {
    if !t return t;
    if t.pointer_to {
        t.pointer_to = erase_objc_type_params(t.pointer_to);
    } else if t.type_of_struct {
        if t.type_of_struct.flags & .IS_TYPE_PARAM return context.generator.type_def_objc_id;
        for t.template_instantiation_params  t.template_instantiation_params[it_index] = erase_objc_type_params(it);
    }
    return t;
}

// The superclass of `Sub : Box<NSString *>`. libclang reports the arguments as class
// references after the superclass reference; anything it cannot account for becomes `id`.
objc_superclass_type :: (parent: *Struct, children: [] Cursor, index: s64) -> *CType {
    g := context.generator;
    result := objc_self_type(parent);
    result.template_instantiation_params.count = 0;
    count := parent.template_type_params.count;
    args: [..] *CType;
    j := index + 2;   // Past the reference to the superclass itself.
    while j < children.count && cursor_kind(children[j]) == .OBJC_CLASS_REF {
        arg := create_type(clang("type", children[j]), 0);
        if arg array_add(*args, create_pointer_to(arg));
        j += 1;
    }
    for 0..count-1 {
        array_add(*result.template_instantiation_params, ifx args.count == count then args[it] else g.type_def_objc_id);
    }
    return result;
}

// An `@interface` or `@protocol`. With `resolving_type_only` only the (empty) struct that names
// the type is created; the members are converted when the declaration itself is visited.
create_objc_interface :: (c: Cursor, resolving_type_only := false) -> *Struct {
    g := context.generator;
    kind := cursor_kind(c);
    key := clang("canonical", c);
    found, existing := table_find(*g.declarations_by_cursor, key);
    s: *Struct;
    if found {
        s = cast(*Struct) existing;
    } else {
        s = New(Struct);
        s.kind = .STRUCT;
        s.name = cursor_name(c);
        s.output_name = avoid_reserved_names(stripped_name(s.name), true);
        s.location = cursor_location(c);
        fill_comment(*s.comment, c, s.location);
        s.flags |= ifx kind == .OBJC_PROTOCOL_DECL then Struct.Flags.OBJC_PROTOCOL else .OBJC_INTERFACE;
        s.type = New(CType);
        s.type.type_of_struct = s;
        s.type.size = 0;
        table_add(*g.declarations_by_cursor, key, s);
    }
    // Generic parameters (`@interface Box<T : id>`) become `struct(T: Type)` parameters. They are
    // read as soon as the type is seen, so a use before (or without) the definition can name them.
    if kind == .OBJC_INTERFACE_DECL && s.template_type_params.count == 0 {
        for get_children(c) {
            if cursor_kind(it) != .TEMPLATE_TYPE_PARAMETER continue;
            param := New(Declaration);
            param.kind = .DECLARATION;
            param.name = cursor_name(it);
            param.output_name = avoid_reserved_names(param.name, true);
            param.location = cursor_location(it);
            param.type = g.type_def_type;
            array_add(*s.template_type_params, param);
        }
    }
    if resolving_type_only || s.objc_filled return s;

    // libclang does not treat an `@interface` as a definition (that is its `@implementation`);
    // only a declaration whose definition was seen elsewhere is skipped.
    definition := clang("definition", c);
    if !clang("is_definition", c) && definition  return s;
    s.objc_filled = true;
    s.flags &= ~Struct.Flags.IS_INCOMPLETE;
    s.location = cursor_location(c);
    fill_comment(*s.comment, c, s.location);

    children := get_children(c);
    for children {
        child_kind := cursor_kind(it);
        if child_kind == {
            case .OBJC_ROOT_CLASS;
                // A root class is usable wherever an `id` is.
                add_objc_parent(s, "ID", g.type_def_objc_id, it);

            case .OBJC_SUPER_CLASS_REF; #through;
            case .OBJC_PROTOCOL_REF;
                ref := clang("referenced", it);
                if !ref continue;
                parent := create_objc_interface(ref, true);
                parent_type := parent.type;
                if child_kind == .OBJC_SUPER_CLASS_REF && parent.template_type_params.count > 0  parent_type = objc_superclass_type(parent, children, it_index);
                add_objc_parent(s, to_lower_copy(parent.name), parent_type, it);

            case .OBJC_IVAR_DECL;
                add_objc_ivar(s, it);

            case .OBJC_INSTANCE_METHOD_DECL; #through;
            case .OBJC_CLASS_METHOD_DECL;
                add_objc_method(s, it);
        }
    }
    return s;
}

// An instance variable is a data member of the object struct (the clang layout follows the
// superclass, which is the first member).
add_objc_ivar :: (s: *Struct, c: Cursor) {
    if clang("is_bitfield", c) {
        log_stripped(cursor_name(c), "is a bit field instance variable");
        return;
    }
    field := New(Declaration);
    field.kind = .DECLARATION;
    field.name = cursor_name(c);
    field.parent = s;
    field.location = cursor_location(c);
    fill_comment(*field.comment, c, field.location);
    field.type = create_type(clang("type", c), c);
    if !field.type {
        log_stripped(field.name, "has an unsupported type");
        return;
    }
    name_function_arguments(field.type, c);
    field.output_name = avoid_reserved_names(field.name);
    offset := clang("field_offset", c);
    if offset >= 0 field.bit_offset_in_parent = offset;
    avoid_name_clash(*s.declarations, field);   // Adds it.
}

add_objc_parent :: (s: *Struct, name: string, type: *CType, c: Cursor) {
    decl := New(Declaration);
    decl.kind = .DECLARATION;
    decl.name = name;
    decl.output_name = avoid_reserved_names(name);
    decl.type = type;
    decl.parent = s;
    decl.location = cursor_location(c);
    decl.decl_flags |= .QUALIFIER_USING | .QUALIFIER_AS;
    array_add(*s.parents, decl);
}

// Categories add their methods to the class they extend.
create_objc_category :: (c: Cursor) {
    children := get_children(c);
    target: *Struct;
    for children {
        if cursor_kind(it) != .OBJC_CLASS_REF continue;
        ref := clang("referenced", it);
        if ref target = create_objc_interface(ref, true);
        break;
    }
    if !target return;
    for children {
        child_kind := cursor_kind(it);
        if child_kind == .OBJC_INSTANCE_METHOD_DECL || child_kind == .OBJC_CLASS_METHOD_DECL  add_objc_method(target, it);
    }
}

add_objc_method :: (s: *Struct, c: Cursor) {
    g := context.generator;
    is_class_method := cursor_kind(c) == .OBJC_CLASS_METHOD_DECL;
    selector := cursor_name(c);
    for s.declarations {
        if it.kind != .FUNCTION || it.foreign_name != selector continue;
        existing_is_class := ((cast(*Function) it).type.type_of_function.flags & Function_Type.Flags.OBJC_CLASS_METHOD) != 0;
        if existing_is_class == is_class_method return;
    }

    func := New(Function);
    func.kind = .FUNCTION;
    func.name = selector;
    func.foreign_name = selector;
    func.parent = s;
    func.location = cursor_location(c);
    fill_comment(*func.comment, c, func.location);
    colon := find_index_from_left(selector, #char ":");
    func.output_name = avoid_reserved_names(stripped_name(ifx colon >= 0 then slice(selector, 0, colon) else selector));

    ft := New(Function_Type);
    ft.flags |= .OBJC_METHOD;
    if is_class_method ft.flags |= .OBJC_CLASS_METHOD;
    if clang("is_variadic", c) {
        log_stripped(selector, "is a variadic Objective-C method");
        return;
    }

    // The receiver comes first: `self` for instance methods, the `Class` for class methods.
    receiver := New(Declaration);
    receiver.kind = .DECLARATION;
    if is_class_method {
        receiver.name = "class";
        receiver.output_name = "class";
        receiver.type = g.type_def_objc_class;
    } else {
        receiver.name = "self";
        receiver.output_name = "self";
        receiver.type = create_pointer_to(objc_self_type(s));
    }
    array_add(*ft.arguments, receiver);

    result := clang("cursor_result_type", c);
    ft.return_type = create_type(result, c);
    if type_name_of(result) == "instancetype" ft.flags |= .RETURNS_INSTANCETYPE;

    count := clang("num_args", c);
    unknown_count := 0;
    for 0..count-1 {
        arg_cursor := clang("arg", c, it);
        arg := New(Declaration);
        arg.kind = .DECLARATION;
        arg.name = cursor_name(arg_cursor);
        if arg.name {
            arg.output_name = avoid_reserved_names(arg.name);
        } else {
            arg.output_name = tprint("unknown%", unknown_count);
            unknown_count += 1;
        }
        arg.location = cursor_location(arg_cursor);
        arg.type = create_type(clang("type", arg_cursor), arg_cursor);
        array_add(*ft.arguments, arg);
    }

    func.type = New(CType);
    func.type.type_of_function = ft;
    func.type.size = 8;

    if !table_contains(*g.objc_selector_set, selector) {
        table_add(*g.objc_selector_set, selector, true);
        array_add(*g.unique_objc_selectors, selector);
    }
    if uses_wide_long_double(ft) {
        log_stripped(selector, "passes a long double wider than 64 bits (on x86-64 it would also need objc_msgSend_fpret)");
        return;
    }
    avoid_name_clash(*s.declarations, func);   // Adds it.
}

// ----------------------------------------------------------------------------
// Enums.

create_enum :: (c: Cursor) -> *Enum {
    g := context.generator;
    key := clang("definition", c);
    if !key key = clang("canonical", c);
    found, existing := table_find(*g.declarations_by_cursor, key);
    if found return cast(*Enum) existing;

    spelling := cursor_name(key);
    e := New(Enum);
    e.kind = .ENUM;
    if !anonymous_spelling(spelling) && !clang("is_anonymous", key)  e.name = spelling;
    e.location = cursor_location(key);
    fill_comment(*e.comment, key, e.location);
    if e.name  e.output_name = avoid_reserved_names(stripped_name(e.name), true);
    table_add(*g.declarations_by_cursor, key, e);

    int_type := clang("enum_int_type", key);
    e.type = create_type(int_type, key);
    if context.generator_options.alias_original_enum_names  e.flags |= .ALIAS_ORIGINAL_NAMES;
    if options_mimic_enums()  e.flags |= .MIMIC_SPACING;

    children := get_children(key);
    for children {
        if cursor_kind(it) != .ENUM_CONSTANT_DECL continue;
        en: Enum.Enumerate;
        en.name = cursor_name(it);
        en.signed_value = clang("enum_value", it);
        en.unsigned_value = cast(u64) clang("enum_uvalue", it);
        en.location = cursor_location(it);
        fill_comment(*en.comment, it, en.location);
        en.output_name = stripped_name(get_enum_value_name(e, en));
        // Not a known constant: the value only exists as `Enum.value` in the output, so a macro
        // that names it (`#define OLD_NAME NEW_NAME`) has nothing to refer to and is dropped.
        array_add(*e.enumerates, en);
    }
    if e.name  compute_enum_names(e, false);
    return e;
}

// The Jai name of a value before prefix detection: empty for a value dropped by
// `strip_enum_values_with_suffix`, else the C name without the prefixes configured for this
// enum and (with `strip_enum_prefixes`) without the enum's own name.
get_enum_value_name :: (e: *Enum, en: Enum.Enumerate) -> string {
    options := *context.generator_options;
    suffix := options.strip_enum_values_with_suffix;
    if suffix && ends_with(en.name, suffix) return "";

    result := en.name;
    for rule: options.strip_enum_value_prefixes {
        if rule[0] != e.name || !begins_with(result, rule[1]) continue;
        result = advance(result, rule[1].count);
    }
    if options.strip_enum_prefixes && e.name && begins_with(result, e.name) {
        result = advance(result, e.name.count);
        if result && result[0] == #char "_"  result = advance(result, 1);
    }
    return result;
}

// Final value names (and the name of an anonymous enum). With `auto_detect_enum_prefixes`,
// a prefix all values share up to an underscore is dropped (`KEY_UP`, `KEY_DOWN` -> `UP`,
// `DOWN`); an anonymous enum is then named after it (`KEY`).
compute_enum_names :: (e: *Enum, already_stripped := false) {
    detected := "";
    if context.generator_options.auto_detect_enum_prefixes && !already_stripped && e.enumerates.count > 1 {
        detected = detect_value_prefix(e);
        for * e.enumerates {
            it.output_name = avoid_reserved_names(trim_left(advance(it.output_name, detected.count), "_"));
        }
    }

    // A value has to start like an identifier: `1080P` becomes `_1080P`.
    for * e.enumerates {
        if it.output_name && !is_digit(it.output_name[0]) continue;
        it.output_name = sprint("_%", it.output_name);
    }

    if e.name return;
    if detected  e.output_name = trim_right(detected, "_");
    if !e.output_name  e.output_name = "anon_enum";
    avoid_name_clash(*context.generator.anon_declarations, e);
}

// The longest start up to and including an `_` that every value name has, leaving each name
// at least one character. Nothing when a value began with the enum's name: then
// `strip_enum_prefixes` has already removed the prefix that matters.
detect_value_prefix :: (e: *Enum) -> string {
    if context.generator_options.strip_enum_prefixes && e.name {
        for e.enumerates {
            if begins_with(it.name, e.name) return "";
        }
    }

    shared := e.enumerates[0].output_name;
    shared.count = max(shared.count - 1, 0);
    for e.enumerates {
        if it_index == 0 continue;
        limit := min(shared.count, it.output_name.count - 1);
        same := 0;
        while same < limit && shared[same] == it.output_name[same]  same += 1;
        shared.count = same;
    }
    // Only whole words: cut back to the last underscore.
    shared.count = find_index_from_right(shared, #char "_") + 1;
    return shared;
}

// ----------------------------------------------------------------------------
// Macros.

macro_literal_suffix_ok :: (suffix: string) -> bool {
    s := to_lower_copy(suffix);
    return s == "" || s == "u" || s == "l" || s == "ul" || s == "lu" || s == "ll" || s == "ull" || s == "llu";
}

// Converts a C numeric literal to Jai, or returns ok = false.
convert_number_literal :: (text: string) -> string, bool {
    if !text return "", false;
    is_hex := begins_with(text, "0x") || begins_with(text, "0X");
    is_float := false;
    end := text.count;
    if is_hex {
        i := 2;
        while i < text.count && ((text[i] >= #char "0" && text[i] <= #char "9") || (text[i] >= #char "a" && text[i] <= #char "f") || (text[i] >= #char "A" && text[i] <= #char "F")) i += 1;
        if i == 2 return "", false;
        if !macro_literal_suffix_ok(slice(text, i, text.count - i)) return "", false;
        return slice(text, 0, i), true;
    }

    i := 0;
    while i < text.count && (text[i] >= #char "0" && text[i] <= #char "9") i += 1;
    digits_end := i;
    if i < text.count && text[i] == #char "." {
        is_float = true;
        i += 1;
        while i < text.count && (text[i] >= #char "0" && text[i] <= #char "9") i += 1;
    }
    if i < text.count && (text[i] == #char "e" || text[i] == #char "E") {
        is_float = true;
        i += 1;
        if i < text.count && (text[i] == #char "+" || text[i] == #char "-") i += 1;
        while i < text.count && (text[i] >= #char "0" && text[i] <= #char "9") i += 1;
    }
    if i == 0 return "", false;
    body := slice(text, 0, i);
    suffix := slice(text, i, text.count - i);
    if is_float {
        s := to_lower_copy(suffix);
        if s != "" && s != "f" && s != "l" return "", false;
        if ends_with(body, ".") body = join(body, "0");
        if begins_with(body, ".") body = join("0", body);
        return body, true;
    }
    if !macro_literal_suffix_ok(suffix) return "", false;
    // Octal literals: a leading 0 followed by digits.
    if body.count > 1 && body[0] == #char "0" {
        value: s64;
        for 0..body.count-1  value = value * 8 + (body[it] - #char "0");
        return tprint("%", value), true;
    }
    return body, true;
}

Macro_Parser :: struct {
    tokens: [] Macro_Token;
    index: s64;
    ok := true;
    // An identifier that is not (yet) known; the macro is rechecked once all declarations exist.
    unresolved := false;
}

CAST_TYPE_WORDS :: string.["int", "unsigned", "long", "short", "char", "signed", "float", "double", "void", "const",
    "uint8_t", "uint16_t", "uint32_t", "uint64_t", "int8_t", "int16_t", "int32_t", "int64_t", "size_t", "ssize_t", "intptr_t", "uintptr_t"];

// The Jai type of a fixed-size integer typedef from libc headers, or "".
builtin_integer_typedef :: (name: string) -> string {
    n := name;
    while begins_with(n, "_") n = advance(n, 1);
    if begins_with(n, "u_int") n = advance(n, 2);   // u_int32_t -> int32_t (unsigned below)
    unsigned := begins_with(name, "u_") || begins_with(n, "u");
    if begins_with(n, "u") n = advance(n, 1);
    if n == "int8_t"  return ifx unsigned then "u8"  else "s8";
    if n == "int16_t" return ifx unsigned then "u16" else "s16";
    if n == "int32_t" return ifx unsigned then "u32" else "s32";
    if n == "int64_t" return ifx unsigned then "u64" else "s64";
    if name == "size_t" || name == "__size_t" || name == "uintptr_t" return "u64";
    if name == "ssize_t" || name == "__ssize_t" || name == "intptr_t" return "s64";
    return "";
}

macro_type_name :: (words: [] string) -> string {
    unsigned := false;
    longs := 0;
    base := "";
    for words {
        if it == "unsigned" unsigned = true;
        else if it == "long" longs += 1;
        else if it == "short" base = "short";
        else if it == "char" base = "char";
        else if it == "int" { if !base base = "int"; }
        else if it == "float" base = "float";
        else if it == "double" base = "double";
        else if it == "uint8_t" return "u8";
        else if it == "uint16_t" return "u16";
        else if it == "uint32_t" return "u32";
        else if it == "uint64_t" return "u64";
        else if it == "int8_t" return "s8";
        else if it == "int16_t" return "s16";
        else if it == "int32_t" return "s32";
        else if it == "int64_t" return "s64";
        else if it == "size_t" return "u64";
        else if it == "ssize_t" return "s64";
        else if it == "intptr_t" return "s64";
        else if it == "uintptr_t" return "u64";
    }
    if base == "float" return "float32";
    if base == "double" return "float64";
    if base == "char" return ifx unsigned then "u8" else "s8";
    if base == "short" return ifx unsigned then "u16" else "s16";
    if longs > 0 return ifx unsigned then "u64" else "s64";
    return ifx unsigned then "u32" else "s32";
}

peek_token :: (p: *Macro_Parser) -> string {
    if p.index >= p.tokens.count return "";
    return p.tokens[p.index].spelling;
}

macro_primary :: (p: *Macro_Parser) -> string {
    if p.index >= p.tokens.count { p.ok = false; return ""; }
    t := p.tokens[p.index];
    s := t.spelling;

    if s == "(" {
        // Cast to a named type: `(ImGuiID)0`.
        if p.index + 2 < p.tokens.count && p.tokens[p.index + 1].kind == 2 {
            name := p.tokens[p.index + 1].spelling;
            k := p.index + 2;
            stars := 0;
            while k < p.tokens.count && p.tokens[k].spelling == "*" { stars += 1; k += 1; }
            if k < p.tokens.count && p.tokens[k].spelling == ")" && !table_contains(*context.generator.known_constants, name) {
                is_type, type_name := table_find(*context.generator.known_types, name);
                if !is_type {
                    // Fixed-size integer typedefs (`u_int32_t`, `__uint8_t`, ...) are unwrapped.
                    type_name = builtin_integer_typedef(name);
                    is_type = type_name.count > 0;
                }
                if !is_type {
                    p.ok = false;
                    p.unresolved = true;
                    return "";
                }
                p.index = k + 1;
                operand := macro_unary(p);
                stars_text := "";
                for 1..stars stars_text = join(stars_text, "*");
                // A negative or complemented value does not fit an unsigned type without `,trunc`.
                trunc := ifx begins_with(operand, "-") || begins_with(operand, "(-") || begins_with(operand, "~") || begins_with(operand, "(~") then ",trunc" else "";
                return tprint("cast%(%%) %", trunc, stars_text, type_name, operand);
            }
        }
        // Cast or parenthesized expression.
        j := p.index + 1;
        words: [..] string;
        is_cast := true;
        star_count := 0;
        while j < p.tokens.count && p.tokens[j].spelling != ")" {
            w := p.tokens[j].spelling;
            if w == "*" {
                star_count += 1;
            } else {
                known := false;
                for CAST_TYPE_WORDS if it == w known = true;
                if !known { is_cast = false; break; }
                array_add(*words, w);
            }
            j += 1;
        }
        if is_cast && words.count > 0 && j < p.tokens.count {
            p.index = j + 1;
            operand := macro_unary(p);
            if star_count > 0 {
                if operand == "0" return "null";
                p.ok = false;
                return "";
            }
            return tprint("cast(%) %", macro_type_name(words), operand);
        }
        p.index += 1;
        inner := macro_expression(p);
        if peek_token(p) != ")" { p.ok = false; return ""; }
        p.index += 1;
        return tprint("(%)", inner);
    }

    p.index += 1;
    if t.kind == 3 {
        // Literal
        if begins_with(s, "\"") return s;
        if begins_with(s, "'") {
            // C 'x' becomes Jai #char "x"; only escapes Jai shares with C are passed through.
            if s.count == 3 {
                c := s[1];
                if c == #char "\"" return "#char \"\\\"\"";
                if c == #char "\\" { p.ok = false; return ""; }
                return tprint("#char \"%\"", slice(s, 1, 1));
            }
            if s.count == 4 && s[1] == #char "\\" {
                e := s[2];
                if e == #char "n" || e == #char "t" || e == #char "r" || e == #char "0" || e == #char "\\" || e == #char "\"" {
                    return tprint("#char \"%\"", slice(s, 1, 2));
                }
                if e == #char "'" return "#char \"'\"";
            }
            p.ok = false;
            return "";
        }
        converted, ok := convert_number_literal(s);
        if !ok { p.ok = false; return ""; }
        return converted;
    }
    if t.kind == 2 {
        // Identifier: only names that will exist in the output.
        found := table_contains(*context.generator.known_constants, s);
        if found return s;
        is_type, type_name := table_find(*context.generator.known_types, s);
        if is_type return type_name;
        p.ok = false;
        p.unresolved = true;
        return "";
    }
    if t.kind == 1 {
        if s == "int" return "s32";
        if s == "void" return "void";
    }
    p.ok = false;
    return "";
}

macro_unary :: (p: *Macro_Parser) -> string {
    s := peek_token(p);
    if s == "~" || s == "-" || s == "+" || s == "!" {
        p.index += 1;
        operand := macro_unary(p);
        if s == "+" return operand;
        return tprint("%1%2", s, operand);
    }
    return macro_primary(p);
}

binary_precedence :: (op: string) -> s64 {
    if op == "*" || op == "/" || op == "%" return 10;
    if op == "+" || op == "-" return 9;
    if op == "<<" || op == ">>" return 8;
    if op == "&" return 6;
    if op == "^" return 5;
    if op == "|" return 4;
    return 0;
}

// How tightly Jai binds a binary operator. Its table differs from C's (the bitwise and
// shift operators share one level above `*`, and `%` sits below `*` and `/`), so the
// text of a C expression is parenthesized wherever Jai would group it differently.
jai_binding :: (op: string) -> s64 {
    if op == "+" || op == "-" return 1;
    if op == "%" return 2;
    if op == "*" || op == "/" return 3;
    return 4;
}

// A prefix cast in Jai takes a following bitwise operator into its value.
starts_with_cast :: (text: string) -> bool {
    rest := text;
    while rest.count && (rest[0] == #char "-" || rest[0] == #char "~" || rest[0] == #char "!") advance(*rest);
    return begins_with(rest, "cast");
}

macro_binary :: (p: *Macro_Parser, min_precedence: s64) -> string, binding: s64 {
    lhs := macro_unary(p);
    lhs_binding := 0; // 0 while lhs is not a binary expression
    while p.ok {
        op := peek_token(p);
        prec := binary_precedence(op);
        if prec == 0 || prec < min_precedence break;
        p.index += 1;
        rhs, rhs_binding := macro_binary(p, prec + 1);
        binding := jai_binding(op);
        bitwise := binding == 4;
        if lhs_binding {
            if lhs_binding < binding lhs = tprint("(%)", lhs);
        } else if bitwise && starts_with_cast(lhs) {
            lhs = tprint("(%)", lhs);
        }
        if rhs_binding {
            if rhs_binding <= binding rhs = tprint("(%)", rhs);
        } else if bitwise && starts_with_cast(rhs) {
            rhs = tprint("(%)", rhs);
        }
        lhs = tprint("% % %", lhs, op, rhs);
        lhs_binding = binding;
    }
    return lhs, lhs_binding;
}

macro_expression :: (p: *Macro_Parser) -> string {
    text := macro_binary(p, 1);
    return text;
}

// The Jai text of a macro body, or ok = false when it is not a constant expression.
// True when the first token's parenthesis closes at the last token.
is_wrapped_in_parens :: (tokens: [] Macro_Token) -> bool {
    if tokens.count < 3 || tokens[0].spelling != "(" || tokens[tokens.count - 1].spelling != ")" return false;
    depth := 0;
    for tokens {
        if it.spelling == "(" depth += 1;
        else if it.spelling == ")" {
            depth -= 1;
            if depth == 0 return it_index == tokens.count - 1;
        }
    }
    return false;
}

convert_macro_body :: (tokens_in: [] Macro_Token) -> string, bool, bool {
    tokens := tokens_in;
    // `(X)` is the value X; a cast like `(int)(X)` closes its first paren earlier.
    while is_wrapped_in_parens(tokens) tokens = array_view(tokens, 1, tokens.count - 2);
    if tokens.count == 0 return "", false, false;
    p: Macro_Parser;
    p.tokens = tokens;
    // Adjacent string literals concatenate.
    if tokens.count > 1 && tokens[0].kind == 3 && begins_with(tokens[0].spelling, "\"") {
        builder: String_Builder;
        for tokens {
            if it.kind != 3 || !begins_with(it.spelling, "\"") return "", false, false;
            body := slice(it.spelling, 1, it.spelling.count - 2);
            append(*builder, body);
        }
        return tprint("\"%\"", builder_to_string(*builder)), true, false;
    }
    result := macro_expression(*p);
    if !p.ok || p.index != tokens.count return "", false, p.unresolved;
    return result, true, false;
}

create_macro_definition :: (c: Cursor) -> *Declaration {
    name := cursor_name(c);
    if !name return null;
    for MACROS_TO_IGNORE  if it == name return null;
    if clang("macro_function_like", c) return null;
    if clang("macro_builtin", c) return null;

    tokens := tokens_of(c);
    // The first token is the macro name.
    if tokens.count < 2 return null;
    body := array_view(tokens, 1, tokens.count - 1);
    // Drop trailing comments.
    while body.count > 0 && body[body.count - 1].kind == 4  body.count -= 1;

    decl := New(Declaration);
    decl.kind = .MACRO_DEFINITION;
    decl.name = name;
    decl.output_name = avoid_reserved_names(stripped_name(name));
    decl.location = cursor_location(c);
    fill_comment(*decl.comment, c, decl.location);

    converted, ok, unresolved := convert_macro_body(body);
    lit := New(Literal);
    lit.literal_kind = .MACRO;
    lit.macro_value.tokens = body;
    lit.raw_value = converted;
    decl.expression = lit;
    if !ok {
        // Identifiers naming types are resolved once every declaration exists (post_process).
        if unresolved {
            decl.macro_value_result = .NEEDS_CHECKING;
        } else {
            decl.macro_value_result = .DISCARD;
            decl.expression = null;
        }
        return decl;
    }
    decl.macro_value_result = .KEEP;
    table_set(*context.generator.known_constants, name, true);
    return decl;
}

// ----------------------------------------------------------------------------
// Top level.

add_to_scope :: (scope: *[..] *Declaration, decl: *Declaration) {
    g := context.generator;
    if !decl return;
    already := table_contains(*g.added_to_scope, decl);
    if already return;
    table_set(*g.added_to_scope, decl, true);
    array_add(scope, decl);
}

create_namespace :: (c: Cursor, parent: *Declaration) -> *Namespace {
    ns := New(Namespace);
    ns.kind = .NAMESPACE;
    ns.name = cursor_name(c);
    ns.output_name = avoid_reserved_names(stripped_name(ns.name));
    ns.parent = parent;
    ns.location = cursor_location(c);
    for context.generator_options.flatten_namespaces {
        if it == ns.name ns.should_flatten = true;
    }
    return ns;
}

handle_toplevel_cursor :: (c: Cursor, scope: *[..] *Declaration, parent: *Declaration) {
    g := context.generator;
    options := *context.generator_options;
    kind := cursor_kind(c);
    name := cursor_name(c);

    if kind == .NAMESPACE {
        ns := create_namespace(c, parent);
        children := get_children(c);
        for children  handle_toplevel_cursor(it, *ns.declarations, ns);
        if ns.should_flatten {
            for * g.pending_anon_enums {
                if it.scope == *ns.declarations {
                    it.scope = scope;
                    it.index += scope.count;
                }
            }
            for ns.declarations { it.parent = ns.parent; array_add(scope, it); }
        } else if ns.declarations.count {
            add_to_scope(scope, ns);
        }
        return;
    }

    // `extern "C" { ... }` (and `__BEGIN_DECLS` in C++ mode): its declarations belong to the
    // enclosing scope. Older libclangs report the block as an unexposed declaration.
    if kind == .LINKAGE_SPEC || kind == .UNEXPOSED_DECL {
        for get_children(c)  handle_toplevel_cursor(it, scope, parent);
        return;
    }

    if !is_user_declaration(c, name) {
        g.counts.ignored_system_declarations += 1;
        return;
    }

    if kind == {
        case .MACRO_DEFINITION;
            decl := create_macro_definition(c);
            if decl add_to_scope(scope, decl);

        case .FUNCTION_DECL;
            if !name return;
            func := create_function(c, parent);
            ft := func.type.type_of_function;
            if function_has_a_valist_arg(func) && (options.strip_flags & .FUNCTIONS_WITH_VALIST) {
                log_stripped(name, "takes a va_list");
                return;
            }
            if !options.use_jaic_long_double && uses_wide_long_double(ft) {
                log_stripped(name, "passes a long double wider than 64 bits, which Jai has no type for");
                return;
            }
            // Functions with internal linkage have no symbol to bind to.
            if clang("linkage", c) == 2 && !(options.strip_flags & .INLINED_FUNCTIONS) {
                log_stripped(name, "has internal linkage");
                return;
            }
            // Only the first declaration of a function is bound.
            key := clang("canonical", c);
            found := table_contains(*g.declarations_by_cursor, key);
            if found return;
            table_add(*g.declarations_by_cursor, key, func);
            // C++ overloads: only names seen before can clash.
            if table_contains(*g.function_names_seen, func.output_name) {
                rename_equivalent_overload(scope, func);
            } else {
                table_add(*g.function_names_seen, func.output_name, true);
            }
            add_to_scope(scope, func);

        case .STRUCT_DECL; #through;
        case .UNION_DECL; #through;
        case .CLASS_DECL; #through;
        case .CLASS_TEMPLATE;
            // Explicit specializations are not generated.
            if clang("specialized_template", c) return;
            s := create_struct(c);
            if s.name {
                s.parent = parent;
                add_to_scope(scope, s);
            }

        case .OBJC_INTERFACE_DECL; #through;
        case .OBJC_PROTOCOL_DECL;
            s := create_objc_interface(c);
            if !(s.flags & .IS_INCOMPLETE) && !table_contains(*g.added_to_scope, s) {
                s.parent = parent;
                add_to_scope(scope, s);
            }

        case .OBJC_CATEGORY_DECL;
            create_objc_category(c);

        case .ENUM_DECL;
            e := create_enum(c);
            e.parent = parent;
            if e.name {
                add_to_scope(scope, e);
            } else {
                // Named later by a typedef, or placed here once the whole file is converted.
                array_add(*g.pending_anon_enums, .{e, scope, scope.count});
            }

        case .TYPEDEF_DECL; #through;
        case .TYPE_ALIAS_DECL;
            if should_unwrap_typedef(name) return;
            td := create_typedef(c);
            td.parent = parent;
            add_to_scope(scope, td);

        case .VAR_DECL;
            // Constants initialised by a literal become constants.
            ty := clang("type", c);
            constant: *Declaration;
            if clang("t_const", ty)  constant = create_constant_declaration(c);
            if constant {
                add_to_scope(scope, constant);
            } else if clang("storage_class", c) == xx Storage_Class.Extern && !options.omit_global_declarations {
                // Includes `extern const T name;`: a constant whose value lives in the library.
                decl := New(Declaration);
                decl.kind = .DECLARATION;
                decl.name = name;
                decl.output_name = avoid_reserved_names(stripped_name(name));
                decl.location = cursor_location(c);
                decl.type = create_type(ty, c);
                decl.foreign_name = name;
                decl.storage_class = .Extern;
                add_to_scope(scope, decl);
            }
    }
}

log_stripped :: (name: string, reason: string) {
    context.generator.counts.stripped += 1;
    if context.generator_options.log_stripped_declarations {
        log("Stripped '%': %\n", name, reason);
    }
}
