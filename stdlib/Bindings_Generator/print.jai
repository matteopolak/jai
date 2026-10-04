// Declaration model -> Jai source text.

Print_Decl_Flags :: enum_flags {
    NO_SEMICOLON;
    NO_INDENT;
    IN_FUNCTION_ARGS;
    IN_FUNCTION_RETURN;
    NO_ARGUMENT_DEFAULTS;
    C_TYPE_DETAILS;
    KEEP_POINTER_TO_VALUE;
    IS_GLOBAL;
}

append_indentation :: (builder: *String_Builder) {
    for 1..context.generator.tab_depth  append(builder, TAB_STRING);
}

maybe_add_spacing :: (builder: *String_Builder, last_location: *Location, location: Location, decl_flags: Declaration_Flags, mimic: bool) {
    skip := (decl_flags & .NO_SPACING) != 0;
    extra := false;
    if last_location.file {
        if location.file != last_location.file || (location.line != last_location.line && location.line != last_location.line + 1) {
            extra = true;
        }
    }
    last_location.* = location;
    if mimic && extra && !skip  append(builder, "\n");
}

maybe_add_spacing :: (builder: *String_Builder, last_location: *Location, location: Location, decl_flags: Declaration_Flags, mimic_type: Mimic_Spacing_Flags) {
    maybe_add_spacing(builder, last_location, location, decl_flags, (context.generator_options.mimic_spacing_flags & mimic_type) != 0);
}

// ----------------------------------------------------------------------------
// Types.

number_type_name :: (t: *CType) -> string {
    flags := t.number_flags;
    if flags & .FLOAT {
        if t.size == 4 return "float";
        return "float64";
    }
    signed := (flags & .SIGNED) != 0;
    if flags & ._8BIT return ifx signed then "s8" else "u8";
    if flags & ._16BIT return ifx signed then "s16" else "u16";
    if flags & ._32BIT return ifx signed then "s32" else "u32";
    return ifx signed then "s64" else "u64";
}

parent_path :: (decl: *Declaration) -> string {
    path := "";
    p := decl.parent;
    while p {
        if p.kind == .NAMESPACE && (cast(*Namespace) p).should_flatten {
            p = p.parent;
            continue;
        }
        if p.output_name  path = join(p.output_name, ".", path);
        p = p.parent;
    }
    return path;
}

type_to_string :: (ty: *CType, current_scope: *Declaration = null, flags: Print_Decl_Flags = 0) -> string {
    builder: String_Builder;
    print_type_to_builder(*builder, ty, current_scope, flags);
    return builder_to_string(*builder);
}

print_type_to_builder :: (builder: *String_Builder, ty: *CType, current_scope: *Declaration, flags: Print_Decl_Flags = 0) {
    if !ty {
        append(builder, "void");
        return;
    }
    if ty.hardcoded_jai_string {
        append(builder, ty.hardcoded_jai_string);
        return;
    }
    if ty.type_of_function {
        append(builder, "#type ");
        print_function_type_to_builder(builder, ty.type_of_function, current_scope, null, true);
        return;
    }
    if ty.pointer_to {
        append(builder, "*");
        if ty.pointer_to.type_of_function {
            // A pointer to a function type: the function pointer itself.
            print_type_to_builder(builder, ty.pointer_to, current_scope, flags);
        } else {
            print_type_to_builder(builder, ty.pointer_to, current_scope, flags);
        }
        return;
    }
    if ty.array_element_type {
        if ty.array_element_count >= 0 {
            print_to_builder(builder, "[%] ", ty.array_element_count);
        } else {
            append(builder, "[0] ");
        }
        print_type_to_builder(builder, ty.array_element_type, current_scope, flags);
        return;
    }
    if ty.type_of_typedef {
        append(builder, parent_path(ty.type_of_typedef));
        append(builder, ty.type_of_typedef.output_name);
        return;
    }
    if ty.type_of_enum {
        e := ty.type_of_enum;
        append(builder, parent_path(e));
        append(builder, e.output_name);
        return;
    }
    if ty.type_of_struct {
        s := ty.type_of_struct;
        if s.flags & .IS_ANON && !s.name {
            print_struct_body(builder, s, true);
        } else {
            append(builder, parent_path(s));
            append(builder, s.output_name);
        }
        return;
    }
    if ty.number_flags {
        append(builder, number_type_name(ty));
        return;
    }
    append(builder, "void");
}

print_function_type_to_builder :: (builder: *String_Builder, type: *Function_Type, current_scope: *Declaration, func: *Function, add_directives: bool) {
    args: [] *Declaration = type.arguments;
    if func  args = context.generator_options.get_func_args_for_printing(func, type, .FOREIGN_FUNC_DECLARATION);
    append(builder, "(");
    needs_printf := func && (func.decl_flags & .NEEDS_PRINTF_WRAPPER) != 0;
    for args {
        if it_index > 0 append(builder, ", ");
        arg_flags := Print_Decl_Flags.NO_SEMICOLON | .NO_INDENT | .IN_FUNCTION_ARGS | .KEEP_POINTER_TO_VALUE;
        if !func arg_flags |= .NO_ARGUMENT_DEFAULTS;
        print_declaration_to_builder(builder, it, current_scope, arg_flags);
    }
    if type.flags & .VARIADIC {
        if args.count > 0 append(builder, ", ");
        append(builder, "__args: ..Any");
    }
    append(builder, ")");
    append(builder, " -> ");
    print_type_to_builder(builder, type.return_type, current_scope, .IN_FUNCTION_RETURN);
    if add_directives  append(builder, " #c_call");
}

// ----------------------------------------------------------------------------
// Expressions.

escape_string_literal :: (s: string) -> string {
    builder: String_Builder;
    append(*builder, "\"");
    for 0..s.count-1 {
        c := s[it];
        if c == #char "\"" append(*builder, "\\\"");
        else if c == #char "\\" append(*builder, "\\\\");
        else if c == #char "\n" append(*builder, "\\n");
        else if c == #char "\t" append(*builder, "\\t");
        else if c == #char "\r" append(*builder, "\\r");
        else if c == 0 append(*builder, "\\0");
        else append(*builder, c);
    }
    append(*builder, "\"");
    return builder_to_string(*builder);
}

float_to_text :: (value: float64) -> string {
    text := tprint("%", value);
    has_marker := false;
    for 0..text.count-1 {
        c := text[it];
        if c == #char "." || c == #char "e" || c == #char "E" || c == #char "n" || c == #char "i" has_marker = true;
    }
    if !has_marker text = join(text, ".0");
    return text;
}

// Whether an expression can be printed as a Jai constant.
can_print_expression :: (e: *Expression) -> bool {
    if !e return false;
    if e.kind == {
        case .LITERAL;
            lit := cast(*Literal) e;
            if lit.literal_kind == .RAW_CPP_TOKENS return raw_expression_text(lit.raw_value) != "";
            return true;
        case .PAREN_EXPRESSION;
            return can_print_expression((cast(*Paren_Expression) e).child);
        case .STRUCT_LITERAL;
            s := cast(*Struct_Literal) e;
            for s.values if !can_print_expression(it) return false;
            return true;
        case .UNARY_OPERATOR;
            return can_print_expression((cast(*Unary_Operator) e).child);
        case .BINARY_OPERATOR;
            b := cast(*Binary_Operator) e;
            return can_print_expression(b.lhs) && can_print_expression(b.rhs);
    }
    return false;
}

// Token text of a C++ expression, translated when it is simple enough.
raw_expression_text :: (raw: string) -> string {
    if raw == "true" || raw == "false" return raw;
    if raw == "nullptr" || raw == "NULL" || raw == "0" return ifx raw == "0" then "0" else "null";
    body := raw;
    negative := false;
    if begins_with(body, "-") { negative = true; body = advance(body, 1); }
    converted, ok := convert_number_literal(body);
    if ok return ifx negative then join("-", converted) else converted;
    if table_contains(*context.generator.known_constants, raw) return raw;
    return "";
}

print_expression_to_builder :: (builder: *String_Builder, e: *Expression, target_type: *CType = null, current_scope: *Declaration = null) -> did_print_enum: bool {
    if !e return false;
    if e.kind == {
        case .LITERAL;
            return print_literal_to_builder(builder, cast(*Literal) e, target_type, current_scope);
        case .PAREN_EXPRESSION;
            append(builder, "(");
            print_expression_to_builder(builder, (cast(*Paren_Expression) e).child, target_type, current_scope);
            append(builder, ")");
        case .UNARY_OPERATOR;
            u := cast(*Unary_Operator) e;
            append(builder, u.op);
            print_expression_to_builder(builder, u.child, target_type, current_scope);
        case .BINARY_OPERATOR;
            b := cast(*Binary_Operator) e;
            print_expression_to_builder(builder, b.lhs, target_type, current_scope);
            print_to_builder(builder, " % ", b.op);
            print_expression_to_builder(builder, b.rhs, target_type, current_scope);
        case .STRUCT_LITERAL;
            s := cast(*Struct_Literal) e;
            print_to_builder(builder, "%.{", s.type_name);
            for s.values {
                if it_index > 0 append(builder, ", ");
                print_expression_to_builder(builder, it, null, current_scope);
            }
            append(builder, "}");
    }
    return false;
}

print_literal_to_builder :: (builder: *String_Builder, lit: *Literal, target_type: *CType, current_scope: *Declaration) -> did_print_enum: bool {
    if lit.literal_kind == {
        case .NULL;
            append(builder, "null");
        case .INTEGER;
            print_to_builder(builder, "%", lit.int_value);
        case .FLOAT;
            append(builder, float_to_text(lit.float_value));
        case .STRING;
            append(builder, escape_string_literal(lit.string_value));
        case .RAW_CPP_TOKENS;
            append(builder, raw_expression_text(lit.raw_value));
        case .MACRO;
            append(builder, lit.raw_value);
        case .IDENTIFIER;
            if lit.identifier append(builder, lit.identifier.output_name);
        case .ENUM;
            name := lit.enum_value.output_name;
            stripped := strip_type(target_type, typedefs = true);
            if stripped && stripped.type_of_enum == lit.enum_type {
                print_to_builder(builder, ".%", name);
            } else {
                print_to_builder(builder, "%.%", lit.enum_type.output_name, name);
            }
            return true;
    }
    return false;
}

// ----------------------------------------------------------------------------
// Declarations.

get_name_alignment :: (declarations: [] *Declaration) -> int {
    longest := 0;
    for declarations {
        if it.decl_flags & .OMIT_FROM_OUTPUT continue;
        is_field, is_anon := is_struct_field(it);
        if !is_field || is_anon continue;
        if it.output_name.count > longest longest = it.output_name.count;
    }
    return longest;
}

print_comment_prefix :: (builder: *String_Builder, comment: Comment, no_indent: bool) {
    remainder := comment.text;
    while remainder {
        found, line, rest := split_from_left(remainder, #char "\n");
        remainder = rest;
        line = trim(line, " \t\r");
        append(builder, line);
        append(builder, "\n");
        if !no_indent append_indentation(builder);
    }
}

print_declaration_to_builder :: (builder: *String_Builder, decl: *Declaration, current_scope: *Declaration, flags: Print_Decl_Flags = 0, align_declarations := 0) {
    if !(flags & .NO_INDENT) append_indentation(builder);

    comment := decl.comment;
    options := *context.generator_options;
    has_comment := options.try_to_preserve_comments && comment.text.count > 0;
    prefix_comment := has_comment && is_prefix_comment(comment);
    if prefix_comment  print_comment_prefix(builder, comment, (flags & .NO_INDENT) != 0);

    if decl.decl_flags & .QUALIFIER_AS      append(builder, "#as ");
    if decl.decl_flags & .QUALIFIER_USING   append(builder, "using ");

    if decl.kind == {
        case .FUNCTION;
            print_function(builder, cast(*Function) decl, current_scope);
            context.generator.counts.functions += 1;
        case .ENUM;
            print_enum(builder, cast(*Enum) decl);
        case .TYPEDEF;
            print_typedef(builder, cast(*Typedef) decl);
        case .STRUCT;
            print_struct(builder, cast(*Struct) decl);
            context.generator.counts.structs += 1;
        case .BITFIELD;
            bf := cast(*Bitfield) decl;
            append(builder, bf.output_name);
            append(builder, ": ");
            for bf.output_name.count..align_declarations-1  append(builder, #char " ");
            print_type_to_builder(builder, bf.type, current_scope, flags);
            append(builder, ";\n");
            append_indentation(builder);
            append(builder, "/* ");
            context.generator.tab_depth += 1;
            for bf.members {
                append(builder, "\n");
                print_declaration_to_builder(builder, it, current_scope, flags);
            }
            context.generator.tab_depth -= 1;
            append(builder, "\n");
            append_indentation(builder);
            append(builder, "*/");
        case .NAMESPACE;
            print_namespace(builder, cast(*Namespace) decl);
        case .MACRO_DEFINITION;
            print_to_builder(builder, "% :: ", decl.output_name);
            print_expression_to_builder(builder, decl.expression);
            append(builder, ";");
        case .DECLARATION;
            type_to_print := decl.type;
            if (decl.decl_flags & .POINTER_TO_VALUE) && decl.type.pointer_to && !(flags & .KEEP_POINTER_TO_VALUE) {
                type_to_print = decl.type.pointer_to;
            }
            name := decl.output_name;
            is_constant := (decl.decl_flags & .IS_CONST) != 0 && decl.expression != null && !(flags & .IN_FUNCTION_ARGS);

            if is_constant {
                // NAME :: value;
                print_to_builder(builder, "% :: ", name);
                print_expression_to_builder(builder, decl.expression, decl.type, current_scope);
                append(builder, ";");
            } else {
                append(builder, name);
                append(builder, ": ");
                for name.count..align_declarations-1  append(builder, #char " ");
                print_type_to_builder(builder, type_to_print, current_scope, flags);

                if !(flags & .NO_ARGUMENT_DEFAULTS) && decl.expression && can_print_expression(decl.expression) && !((decl.decl_flags & .POINTER_TO_VALUE) && (flags & .KEEP_POINTER_TO_VALUE)) {
                    append(builder, " = ");
                    temp: String_Builder;
                    did_print_enum := print_expression_to_builder(*temp, decl.expression, decl.type, current_scope);
                    if (decl.decl_flags & .NEEDS_DEFAULT_ARGUMENT_CAST) && !did_print_enum {
                        append(builder, "cast(");
                        print_type_to_builder(builder, decl.type, current_scope);
                        append(builder, ")");
                    }
                    append(builder, builder_to_string(*temp));
                }
                if decl.foreign_name && decl.storage_class == .Extern {
                    append_elsewhere(builder, decl, decl.foreign_name);
                }
                if !(flags & .NO_SEMICOLON) append(builder, ";");
                if decl.bitfield_width > 0 {
                    print_to_builder(builder, " /* % bits */", decl.bitfield_width);
                }
            }
        case;
            log("Bindings_Generator: unhandled declaration kind %\n", decl.kind);
    }

    if has_comment && !prefix_comment {
        append(builder, " ");
        append(builder, normalize_line_endings(comment.text));
    }
}

append_elsewhere :: (builder: *String_Builder, decl: *Declaration, foreign_name: string) {
    append(builder, " #foreign");
    if decl.library {
        append(builder, " ");
        append(builder, library_identifier(decl.library));
    }
    if foreign_name && foreign_name != decl.output_name {
        print_to_builder(builder, " \"%\"", foreign_name);
    }
}

print_function :: (builder: *String_Builder, func: *Function, current_scope: *Declaration) {
    options := *context.generator_options;
    name := func.output_name;
    needs_printf_wrapper := (func.decl_flags & .NEEDS_PRINTF_WRAPPER) != 0;
    type := func.type.type_of_function;

    foreign_declaration_name := name;
    if needs_printf_wrapper foreign_declaration_name = sprint("%_CFormat", name);

    // The foreign declaration comes first; a wrapper follows when requested.
    print_to_builder(builder, "% :: ", foreign_declaration_name);
    print_function_type_to_builder(builder, type, current_scope, func, false);
    append_elsewhere(builder, func, func.foreign_name);
    append(builder, ";");

    if (func.decl_flags & .NEEDS_ARGUMENT_WRAPPER) || needs_printf_wrapper {
        if (type.flags & .VARIADIC) && !needs_printf_wrapper {
            log("Function \"%\" needs an argument wrapper, but wrappers cannot be generated for variadic functions.\n", func.name);
            return;
        }
        append(builder, "\n");
        append_indentation(builder);
        print_to_builder(builder, "% :: (", name);

        outer := options.get_func_args_for_printing(func, type, .OUTER_WRAPPER);
        normal_outer := outer;
        if needs_printf_wrapper normal_outer = array_view(outer, 0, outer.count - 1);
        for normal_outer {
            print_declaration_to_builder(builder, it, current_scope, Print_Decl_Flags.NO_SEMICOLON | .NO_INDENT | .IN_FUNCTION_ARGS);
            if (it_index < normal_outer.count - 1) || needs_printf_wrapper  append(builder, ", ");
        }
        if needs_printf_wrapper {
            format_arg := outer[outer.count - 1];
            print_to_builder(builder, "%: string, __args: ..Any", format_arg.output_name);
        }

        if type.return_type == context.generator.type_def_void {
            append(builder, ")");
        } else {
            append(builder, ") -> ");
            print_type_to_builder(builder, type.return_type, current_scope);
        }
        if !needs_printf_wrapper  append(builder, " #no_context");
        append(builder, " {\n");

        context.generator.tab_depth += 1;
        if needs_printf_wrapper {
            format_arg := outer[outer.count - 1];
            append_indentation(builder);
            append(builder, "push_allocator(temp);\n");
            append_indentation(builder);
            append(builder, "formatted_text_builder: String_Builder;\n");
            append_indentation(builder);
            print_to_builder(builder, "print_to_builder(*formatted_text_builder, %, ..__args);\n", format_arg.output_name);
            append_indentation(builder);
            append(builder, "append(*formatted_text_builder, \"\\0\");\n");
            append_indentation(builder);
            append(builder, "formatted_text := builder_to_string(*formatted_text_builder);\n");
        }

        append_indentation(builder);
        if type.return_type != context.generator.type_def_void  append(builder, "return ");
        print_to_builder(builder, "%(", foreign_declaration_name);
        inner := options.get_func_args_for_printing(func, type, .INNER_WRAPPER_CALL);
        normal_inner := inner;
        if needs_printf_wrapper normal_inner = array_view(inner, 0, inner.count - 1);
        for normal_inner {
            if it.decl_flags & .POINTER_TO_VALUE  append(builder, "*");
            append(builder, it.output_name);
            if it_index != normal_inner.count - 1 || needs_printf_wrapper  append(builder, ", ");
        }
        if needs_printf_wrapper  append(builder, "\"%s\", formatted_text.data");
        append(builder, ");\n");
        context.generator.tab_depth -= 1;
        append_indentation(builder);
        append(builder, "}");
        if needs_printf_wrapper  append(builder, " @PrintLike");
    }
}

// ----------------------------------------------------------------------------
// Enums, typedefs, structs, namespaces.

append_integer :: (builder: *String_Builder, value: $T, as_hex: bool) {
    if as_hex {
        if value < 0 {
            print_to_builder(builder, "%", value);
        } else {
            print_to_builder(builder, "0x%", formatInt(value, base = 16));
        }
    } else {
        print_to_builder(builder, "%", value);
    }
}

print_enum :: (builder: *String_Builder, e: *Enum) {
    if context.generator_options.c_enum_emulation  append(builder, "using ");
    print_to_builder(builder, "% :: ", e.output_name);
    print_enum_body(builder, e);
}

print_enum_body :: (builder: *String_Builder, e: *Enum) {
    if e.flags & .IS_ENUM_FLAGS {
        append(builder, "enum_flags");
    } else {
        append(builder, "enum");
    }
    if e.type {
        append(builder, " ");
        print_type_to_builder(builder, e.type, e.parent);
    }
    if e.decl_flags & .TYPE_INFO_NONE  append(builder, " #type_info_none");
    append(builder, " {\n");

    underlying := strip_type(e.type, typedefs = true);
    is_signed := underlying != null && (underlying.number_flags & .SIGNED) != 0;
    as_hex := (e.flags & .VALUES_IN_HEX) != 0;
    mimic := (e.flags & .MIMIC_SPACING) != 0;

    max_name_len := 0;
    for e.enumerates {
        if it.output_name.count > max_name_len max_name_len = it.output_name.count;
    }

    context.generator.tab_depth += 1;
    last_location: Location;
    wrote_any := false;
    for e.enumerates {
        if !it.output_name continue;
        maybe_add_spacing(builder, *last_location, it.location, 0, mimic);
        if it.comment.text && is_prefix_comment(it.comment) {
            append_indentation(builder);
            print_comment_prefix(builder, it.comment, false);
        }
        append_indentation(builder);
        append(builder, it.output_name);
        for it.output_name.count..max_name_len-1  append(builder, #char " ");
        append(builder, " :: ");
        if it.string_value {
            append(builder, it.string_value);
        } else if is_signed {
            append_integer(builder, it.signed_value, as_hex);
        } else {
            append_integer(builder, it.unsigned_value, as_hex);
        }
        append(builder, ";");
        if it.comment.text && !is_prefix_comment(it.comment) {
            append(builder, " ");
            append(builder, it.comment.text);
        }
        append(builder, "\n");
        wrote_any = true;
    }

    if e.flags & .ALIAS_ORIGINAL_NAMES {
        max_original_len := 0;
        for e.enumerates {
            if it.name == it.output_name continue;
            if it.name.count > max_original_len max_original_len = it.name.count;
        }

        first := true;
        for e.enumerates {
            if !it.output_name continue;
            if it.name == it.output_name continue;
            if first && wrote_any append(builder, "\n");
            first = false;
            append_indentation(builder);
            append(builder, it.name);
            for it.name.count..max_original_len-1  append(builder, #char " ");
            print_to_builder(builder, " :: %;\n", it.output_name);
        }
    }

    context.generator.tab_depth -= 1;
    context.generator.counts.enums += 1;
    append_indentation(builder);
    append(builder, "}");
}

print_typedef :: (builder: *String_Builder, def: *Typedef) {
    print_to_builder(builder, "% :: ", def.output_name);
    print_type_to_builder(builder, def.type, def.parent);
    append(builder, ";");
}

print_namespace :: (builder: *String_Builder, ns: *Namespace) {
    print_to_builder(builder, "% :: struct {\n", ns.output_name);
    context.generator.tab_depth += 1;
    last_location: Location;
    for ns.declarations {
        if it.decl_flags & .OMIT_FROM_OUTPUT continue;
        maybe_add_spacing(builder, *last_location, it.location, it.decl_flags, .NAMESPACE);
        print_declaration_to_builder(builder, it, ns);
        append(builder, "\n");
    }
    context.generator.tab_depth -= 1;
    append_indentation(builder);
    append(builder, "}");
}

print_struct :: (builder: *String_Builder, s: *Struct) {
    if s.name && !(s.flags & .IS_ANON) {
        print_to_builder(builder, "% :: ", s.output_name);
    }
    print_struct_body(builder, s, false);
}

// `union { ... }` / `struct { ... }` with the members, shared by named and inline structs.
print_struct_body :: (builder: *String_Builder, s: *Struct, inline: bool) {
    if s.flags & .IS_UNION  append(builder, "union");
    else append(builder, "struct");

    if s.decl_flags & .TYPE_INFO_NONE  append(builder, " #type_info_none");
    else if s.decl_flags & .TYPE_INFO_PROCEDURES_ARE_VOID_POINTERS  append(builder, " #type_info_procedures_are_void_pointers");
    append(builder, " {");

    context.generator.tab_depth += 1;
    mimic := (s.flags & .MIMIC_SPACING) != 0 || (context.generator_options.mimic_spacing_flags & .STRUCT) != 0;
    last_location: Location;
    max_len := get_name_alignment(s.declarations);
    printed := false;

    local_names: [..] *Declaration;
    for s.declarations {
        if it.decl_flags & .OMIT_FROM_OUTPUT continue;
        avoid_name_clash(*local_names, it);
    }

    // The largest member of a union comes first, as the layout of C unions starts at offset 0.
    members: [..] *Declaration;
    for s.declarations  array_add(*members, it);

    for members {
        if it.decl_flags & .OMIT_FROM_OUTPUT continue;
        append(builder, "\n");
        maybe_add_spacing(builder, *last_location, it.location, it.decl_flags, mimic);
        flags: Print_Decl_Flags;
        print_declaration_to_builder(builder, it, s, flags, max_len);
        printed = true;
    }
    append(builder, "\n");
    context.generator.tab_depth -= 1;
    append_indentation(builder);
    append(builder, "}");
}
