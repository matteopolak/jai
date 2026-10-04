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
    return char == #char "_" || ((char & 0xDF) >= #char "A" && (char & 0xDF) <= #char "Z");
}

stripped_name :: (name: string) -> string {
    options := *context.generator_options;
    if options.strip_prefixes.count == 0 || name.count == 0 return name;

    stripped := name;
    for options.strip_prefixes {
        if begins_with(name, it) {
            stripped = advance(stripped, it.count);
            while stripped.count > 1 && stripped[0] == #char "_" && is_valid_identifier_start(stripped[1]) {
                stripped = advance(stripped, 1);
            }
            break;
        }
    }
    return stripped;
}

make_valid_identifier :: (name: string) -> string {
    result := copy_string(name);
    for 0..result.count-1 {
        c := result[it];
        ok := (c >= #char "a" && c <= #char "z") || (c >= #char "A" && c <= #char "Z") || (c >= #char "0" && c <= #char "9") || c == #char "_";
        if !ok result[it] = #char "_";
    }
    return result;
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
        // Overloads are fine unless they would look identical in Jai.
        original := decl.output_name;
        count := 0;
        while true {
            clash := false;
            for existing.* {
                if it.kind == .FUNCTION && it != decl && functions_are_equivalent(cast(*Function) it, cast(*Function) decl) { clash = true; break; }
                if it.kind != .FUNCTION && it.output_name == decl.output_name { clash = true; break; }
            }
            if !clash break;
            count += 1;
            decl.output_name = tprint("%_%", original, count);
        }
        array_add(existing, decl);
        return;
    }
    while name_clashes(existing, decl.output_name) {
        decl.output_name = join(decl.output_name, "_");
    }
    array_add(existing, decl);
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
    g.type_def_u128.hardcoded_jai_string = "u128";
    g.type_def_u128.size = 16;
    g.type_def_s8  = make_number_type(.SIGNED | ._8BIT, 1);
    g.type_def_s16 = make_number_type(.SIGNED | ._16BIT, 2);
    g.type_def_s32 = make_number_type(.SIGNED | ._32BIT, 4);
    g.type_def_s64 = make_number_type(.SIGNED | ._64BIT, 8);
    g.type_def_s128 = New(CType);
    g.type_def_s128.hardcoded_jai_string = "s128";
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
    t := New(CType);
    t.pointer_to = pointee;
    t.size = context.generator.pointer_size;
    return t;
}

strip_type :: (type: *CType, typedefs := false, enums := false) -> *CType {
    while type {
        if typedefs && type.type_of_typedef && type.type_of_typedef.type {
            type = type.type_of_typedef.type;
        } else if enums && type.type_of_enum && type.type_of_enum.type {
            type = type.type_of_enum.type;
        } else {
            break;
        }
    }
    return type;
}

// ----------------------------------------------------------------------------
// Typedef unwrapping.

should_unwrap_typedef :: (name: string) -> bool {
    for TYPEDEFS_TO_UNWRAP  if it == name return true;
    for TYPEDEF_PREFIXES_TO_UNWRAP  if begins_with(name, it) return true;
    for context.generator_options.typedef_prefixes_to_unwrap  if begins_with(name, it) return true;
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
    comment.location = location;
}

is_prefix_comment :: (comment: Comment) -> bool {
    t := comment.text;
    if begins_with(t, "///<") || begins_with(t, "//<") || begins_with(t, "/**<") || begins_with(t, "/*<") return false;
    return true;
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
        case T_LONGDOUBLE; return g.type_def_float64;
        case T_NULLPTR;    return g.type_def_ptr_void;

        case T_POINTER;
            pointee := clang("t_pointee", ty);
            pk := type_kind(pointee);
            if pk == T_ELABORATED || pk == T_TYPEDEF {
                // A pointer to a typedef of a function type is still a function pointer.
                canonical := clang("t_canonical", pointee);
                if type_kind(canonical) == T_FUNCTIONPROTO || type_kind(canonical) == T_FUNCTIONNOPROTO {
                    pk = type_kind(canonical);
                    if type_kind(pointee) == T_ELABORATED  pointee = canonical;
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
            return g.type_def_ptr_void;

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
            if !is_user_declaration(decl, name) || should_unwrap_typedef(name) {
                return create_type(clang("typedef_underlying", decl), ctx);
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
    st := New(Struct);
    st.kind = .STRUCT;
    st.name = name;
    st.output_name = avoid_reserved_names(stripped_name(name), true);
    t := New(CType);
    t.type_of_struct = st;
    t.size = 0;
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
            return make_placeholder_struct(cursor_name(decl), "");
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
    return type && type.pointer_to && type.pointer_to.number_flags & ._8BIT && !(type.pointer_to.number_flags & .FLOAT);
}

function_has_a_valist_arg :: (func: *Function) -> bool {
    for func.type.type_of_function.arguments {
        if is_va_list(it.type) return true;
    }
    return false;
}

is_va_list :: (type: *CType) -> bool {
    if !type return false;
    if type.type_of_typedef && contains(type.type_of_typedef.name, "va_list") return true;
    if type.type_of_struct && contains(type.type_of_struct.name, "va_list") return true;
    if type.hardcoded_jai_string == "__va_list_tag" return true;
    return false;
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

    count := clang("t_num_args", ty);
    if count < 0 count = 0;
    cursor_args := 0;
    if cur cursor_args = clang("num_args", cur);

    i := 0;
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
        if !arg.name arg.name = tprint("arg%", i);
        arg.output_name = avoid_reserved_names(arg.name);
        // Arrays decay to pointers in argument position.
        if arg.type.array_element_type {
            arg.type = create_pointer_to(arg.type.array_element_type);
        }
        array_add(*ft.arguments, arg);
        i += 1;
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

// `operator+` stays an operator name; unsupported operators get an identifier
// (`operator!=` -> `operator_not_equals`).
operator_names :: (name: string, argument_count: s64) -> output_name: string, overloadable: bool {
    symbol := replace_all(name, " ", "");
    symbol = advance(symbol, "operator".count);
    for JAI_OPERATORS {
        if it == symbol && argument_count == 2 return tprint("operator%", symbol), true;
    }
    n := symbol;
    n = replace_all(n, "<=>", "_spaceship");
    n = replace_all(n, "->*", "_arrow_star");
    n = replace_all(n, "->", "_arrow");
    n = replace_all(n, "++", "_plus_plus");
    n = replace_all(n, "--", "_minus_minus");
    n = replace_all(n, "==", "_equals");
    n = replace_all(n, "!=", "_not_equals");
    n = replace_all(n, ">=", "_greater_equals");
    n = replace_all(n, "<=", "_less_equals");
    n = replace_all(n, "<<", "_lshift");
    n = replace_all(n, ">>", "_rshift");
    n = replace_all(n, "&&", "_and_and");
    n = replace_all(n, "||", "_or_or");
    n = replace_all(n, "+", "_plus");
    n = replace_all(n, "-", "_minus");
    n = replace_all(n, "*", "_times");
    n = replace_all(n, "/", "_divide");
    n = replace_all(n, "%", "_modulo");
    n = replace_all(n, "^", "_xor");
    n = replace_all(n, "&", "_and");
    n = replace_all(n, "|", "_or");
    n = replace_all(n, "~", "_tilde");
    n = replace_all(n, "<", "_less");
    n = replace_all(n, ">", "_greater");
    n = replace_all(n, "[]", "_brackets");
    n = replace_all(n, "!", "_not");
    n = replace_all(n, "=", "_assign");
    n = replace_all(n, ",", "_comma");
    n = replace_all(n, "()", "_parens");
    if !n || is_digit(n[0]) || !is_valid_identifier_start(n[0]) && n[0] != #char "_" {
        n = tprint("_%", n);
    }
    if !begins_with(n, "_") n = tprint("_%", n);
    return tprint("operator%", n), false;
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
    func.output_name = avoid_reserved_names(stripped_name(func.name));
    if begins_with(name, "operator") && !(ft.flags & (.CONSTRUCTOR | .DESTRUCTOR)) {
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

    // printf-like functions: the last named argument is a format string.
    if (ft.flags & .VARIADIC) && options.generate_printf_wrappers && ft.arguments.count > 0 && !func.is_virtual {
        last := ft.arguments[ft.arguments.count - 1];
        if is_char_pointer_type(last.type) && (last.name == "fmt" || last.name == "format" || last.name == "fmt_") {
            func.decl_flags |= .NEEDS_PRINTF_WRAPPER;
        }
    }
    return func;
}

// ----------------------------------------------------------------------------
// Expressions (default arguments, initializers).

create_null_literal :: () -> *Literal {
    lit := New(Literal);
    lit.literal_kind = .NULL;
    return lit;
}

create_int_literal :: (value: s64) -> *Literal {
    lit := New(Literal);
    lit.literal_kind = .INTEGER;
    lit.int_value = value;
    return lit;
}

create_expression_from_cursor :: (c: Cursor, target_type: *CType) -> *Expression {
    kind := cursor_kind(c);

    if kind == .CXX_NULLPTR_LITERAL return create_null_literal();
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
                for enum_decl.enumerates {
                    if it.name == name {
                        lit.enum_value = it;
                        break;
                    }
                }
                if lit.enum_value return lit;
            }
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
        values: [..] *Expression;
        type_name := "";
        ok := true;
        for children {
            k := cursor_kind(it);
            if k == .TYPE_REF {
                type_name = cursor_name(it);
                continue;
            }
            if k == .UNEXPOSED_EXPR && children.count == 1 {
                return create_expression_from_cursor(it, target_type);
            }
            if is_expression_kind(xx k) {
                e := create_expression_from_cursor(it, null);
                if !e { ok = false; break; }
                array_add(*values, e);
            }
        }
        if ok && type_name && kind == .CALL_EXPR {
            lit := New(Struct_Literal);
            lit.type_name = stripped_name(type_name);
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

    if is_template g.template_depth += 1;
    fill_struct_members(s, key);
    if is_template g.template_depth -= 1;
    if s.name {
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
                array_add(*s.parents, parent_decl);

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
                    if !bitfield {
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
                    finish_bitfield(bitfield);
                } else {
                    bitfield = null;
                    array_add(*s.declarations, field);
                }

            case .STRUCT_DECL; #through;
            case .UNION_DECL;
                if clang("is_anonymous_record", it) {
                    bitfield = null;
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

// Size the storage of a run of bit fields.
finish_bitfield :: (bitfield: *Bitfield) {
    first := bitfield.members[0];
    last := bitfield.members[bitfield.members.count - 1];
    start := first.bit_offset_in_parent;
    end := last.bit_offset_in_parent + last.bitfield_width;
    bytes := (end - start + 7) / 8;
    t := New(CType);
    base_size := ifx first.type then first.type.size else 0;
    if bytes == base_size && (bytes == 1 || bytes == 2 || bytes == 4 || bytes == 8) {
        t = get_int_type(bytes, false);
    } else {
        t.array_element_type = context.generator.type_def_u8;
        t.array_element_count = bytes;
        t.size = bytes;
    }
    bitfield.type = t;
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

    children := get_children(key);
    for children {
        if cursor_kind(it) != .ENUM_CONSTANT_DECL continue;
        en := New(Enum.Enumerate);
        en.kind = .DECLARATION;
        en.name = cursor_name(it);
        en.signed_value = clang("enum_value", it);
        en.unsigned_value = cast(u64) clang("enum_uvalue", it);
        en.location = cursor_location(it);
        fill_comment(*en.comment, it, en.location);
        en.output_name = stripped_name(get_enum_value_name(e, en));
        array_add(*e.enumerates, en);
        table_add(*g.known_constants, en.name, true);
    }
    if e.name  compute_enum_names(e, false);
    return e;
}

get_enum_value_name :: (e: *Enum, en: *Enum.Enumerate) -> string {
    options := *context.generator_options;
    name := en.name;

    if options.strip_enum_values_with_suffix.count > 0 {
        if ends_with(name, options.strip_enum_values_with_suffix) return "";
    }

    for options.strip_enum_value_prefixes {
        if it[0] == e.name && begins_with(name, it[1]) {
            name = advance(name, it[1].count);
        }
    }

    if options.strip_enum_prefixes && e.name && begins_with(name, e.name) {
        name = advance(name, e.name.count);
        if begins_with(name, "_")  name = advance(name, 1);
    }

    return name;
}

compute_enum_names :: (e: *Enum, already_stripped := false) {
    options := *context.generator_options;
    prefix_initialized := false;
    common_prefix := "";
    if options.auto_detect_enum_prefixes && e.enumerates.count > 1 && !already_stripped {
        for e.enumerates {
            if options.strip_enum_prefixes && e.name && begins_with(it.name, e.name) {
                prefix_initialized = true;
                common_prefix = "";
                break;
            }

            if !prefix_initialized {
                common_prefix = it.output_name;
                common_prefix.count -= 1;
                prefix_initialized = true;
            } else {
                if it.output_name.count <= common_prefix.count {
                    common_prefix.count = it.output_name.count - 1;
                }
                i := 0;
                while i < common_prefix.count {
                    if common_prefix[i] != it.output_name[i] {
                        common_prefix.count = i;
                        break;
                    }
                    i += 1;
                }
            }
        }

        underscore_index := find_index_from_right(common_prefix, #char "_");
        if underscore_index != -1 {
            common_prefix.count = underscore_index + 1;
        } else {
            common_prefix.count = 0;
        }

        for e.enumerates {
            it.output_name = advance(it.output_name, common_prefix.count);
            it.output_name = avoid_reserved_names(trim_left(it.output_name, "_"));
        }
    }

    for e.enumerates {
        if !it.output_name || is_digit(it.output_name[0]) {
            it.output_name = sprint("_%", it.output_name);
        }
    }

    if !e.name {
        if common_prefix {
            e.output_name = trim_right(common_prefix, "_");
        } else if !e.output_name {
            e.output_name = "anon_enum";
        }
        if !e.output_name e.output_name = "anon_enum";
        avoid_name_clash(*context.generator.anon_declarations, e);
    }
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
}

CAST_TYPE_WORDS :: string.["int", "unsigned", "long", "short", "char", "signed", "float", "double", "void", "const",
    "uint8_t", "uint16_t", "uint32_t", "uint64_t", "int8_t", "int16_t", "int32_t", "int64_t", "size_t", "ssize_t", "intptr_t", "uintptr_t"];

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
            if s.count == 3 return tprint("#char %", slice(s, 0, s.count));
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
        if !found { p.ok = false; return ""; }
        return s;
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

macro_binary :: (p: *Macro_Parser, min_precedence: s64) -> string {
    lhs := macro_unary(p);
    while p.ok {
        op := peek_token(p);
        prec := binary_precedence(op);
        if prec == 0 || prec < min_precedence break;
        p.index += 1;
        rhs := macro_binary(p, prec + 1);
        lhs = tprint("% % %", lhs, op, rhs);
    }
    return lhs;
}

macro_expression :: (p: *Macro_Parser) -> string {
    return macro_binary(p, 1);
}

// The Jai text of a macro body, or ok = false when it is not a constant expression.
convert_macro_body :: (tokens: [] Macro_Token) -> string, bool {
    if tokens.count == 0 return "", false;
    p: Macro_Parser;
    p.tokens = tokens;
    // Adjacent string literals concatenate.
    if tokens.count > 1 && tokens[0].kind == 3 && begins_with(tokens[0].spelling, "\"") {
        builder: String_Builder;
        for tokens {
            if it.kind != 3 || !begins_with(it.spelling, "\"") return "", false;
            body := slice(it.spelling, 1, it.spelling.count - 2);
            append(*builder, body);
        }
        return tprint("\"%\"", builder_to_string(*builder)), true;
    }
    result := macro_expression(*p);
    if !p.ok || p.index != tokens.count return "", false;
    return result, true;
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

    converted, ok := convert_macro_body(body);
    if !ok {
        decl.macro_value_result = .DISCARD;
        return decl;
    }
    lit := New(Literal);
    lit.literal_kind = .MACRO;
    lit.macro_value.tokens = body;
    lit.raw_value = converted;
    decl.expression = lit;
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
            for ns.declarations { it.parent = ns.parent; array_add(scope, it); }
        } else if ns.declarations.count {
            add_to_scope(scope, ns);
        }
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

        case .ENUM_DECL;
            e := create_enum(c);
            e.parent = parent;
            if e.name then add_to_scope(scope, e); else array_add(*g.pending_anon_enums, e);

        case .TYPEDEF_DECL; #through;
        case .TYPE_ALIAS_DECL;
            if should_unwrap_typedef(name) return;
            td := create_typedef(c);
            td.parent = parent;
            add_to_scope(scope, td);

        case .VAR_DECL;
            // Constants initialised by a literal become constants.
            ty := clang("type", c);
            if clang("t_const", ty) {
                decl := create_constant_declaration(c);
                if decl add_to_scope(scope, decl);
            } else if clang("storage_class", c) == xx Storage_Class.Extern {
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
