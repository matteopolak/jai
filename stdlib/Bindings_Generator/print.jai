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
    depth := context.generator.tab_depth;
    while depth > 0 {
        append(builder, TAB_STRING);
        depth -= 1;
    }
}

// Reproduces the blank lines of the header: a declaration that does not sit on the line after
// the previous one (or comes from another file) gets an empty line before it.
// `last_location` carries the previous declaration's position from call to call.
maybe_add_spacing :: (builder: *String_Builder, last_location: *Location, location: Location, decl_flags: Declaration_Flags, mimic: bool) {
    previous := last_location.*;
    last_location.* = location;
    if !mimic || !previous.file || (decl_flags & .NO_SPACING) != 0 return;
    same_file := location.file == previous.file;
    if same_file && (location.line == previous.line || location.line == previous.line + 1) return;
    append(builder, "\n");
}

// As above, enabled by the `mimic_spacing_flags` bit for this kind of scope.
maybe_add_spacing :: (builder: *String_Builder, last_location: *Location, location: Location, decl_flags: Declaration_Flags, mimic_type: Mimic_Spacing_Flags) {
    enabled := (context.generator_options.mimic_spacing_flags & mimic_type) != 0;
    maybe_add_spacing(builder, last_location, location, decl_flags, enabled);
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
        if p.output_name path = join(p.output_name, ".", path);
        p = p.parent;
    }
    return path;
}

type_to_string :: (ty: *CType, current_scope: *Declaration = null, flags: Print_Decl_Flags = 0) -> string {
    text: String_Builder;
    print_type_to_builder(*text, ty, current_scope, flags);
    return builder_to_string(*text);
}

print_type_to_builder :: (builder: *String_Builder, ty: *CType, current_scope: *Declaration, flags: Print_Decl_Flags = 0) {
    // Pointers and arrays are prefixes of the type they lead to.
    t := ty;
    while t && !t.hardcoded_jai_string && !t.type_of_function {
        if t.pointer_to {
            append(builder, "*");
            t = t.pointer_to;
        } else if t.array_element_type {
            // An array of unknown size (`int x[]`) is printed as an empty one.
            print_to_builder(builder, "[%] ", max(t.array_element_count, 0));
            t = t.array_element_type;
        } else {
            break;
        }
    }

    if !t {
        append(builder, "void");
    } else if t.hardcoded_jai_string {
        g := context.generator;
        if t == g.type_def_u128 || t == g.type_def_s128 g.int128_was_referenced = true;
        if t.flags & .WIDE_LONG_DOUBLE g.long_double_was_referenced = true;
        append(builder, t.hardcoded_jai_string);
    } else if t.type_of_function {
        append(builder, "#type ");
        print_function_type_to_builder(builder, t.type_of_function, current_scope, null, true);
    } else if t.type_of_struct {
        print_struct_type_name(builder, t, current_scope, flags);
    } else if t.type_of_enum || t.type_of_typedef {
        named := naming_declaration(t);
        append(builder, parent_path(named));
        append(builder, named.output_name);
    } else if t.number_flags {
        append(builder, number_type_name(t));
    } else {
        append(builder, "void");
    }
}

// A struct is printed by its qualified name with its template arguments, except an anonymous
// one, which can only be spelled out in place.
print_struct_type_name :: (builder: *String_Builder, t: *CType, current_scope: *Declaration, flags: Print_Decl_Flags) {
    s := t.type_of_struct;
    if !s.name && (s.flags & .IS_ANON) {
        print_struct_body(builder, s, true);
        return;
    }
    append(builder, parent_path(s));
    append(builder, s.output_name);
    if t.template_instantiation_params.count {
        append(builder, "(");
        for t.template_instantiation_params {
            if it_index append(builder, ", ");
            print_type_to_builder(builder, it, current_scope, flags);
        }
        append(builder, ")");
    } else if s.template_type_params.count && (s.flags & Struct.Flags.OBJC_INTERFACE) {
        // An Objective-C generic named without arguments (`NSArray *`) is `NSArray(id)`.
        ids: [..] string;
        ids.allocator = temp;
        for s.template_type_params array_add(*ids, "id");
        print_to_builder(builder, "(%)", join(..ids, separator = ", "));
    }
    if t.comment print_to_builder(builder, " %", t.comment);
}

print_function_type_to_builder :: (builder: *String_Builder, type: *Function_Type, current_scope: *Declaration, func: *Function, add_directives := false) {
    args: [] *Declaration = type.arguments;
    if func args = context.generator_options.get_func_args_for_printing(func, type, .FOREIGN_FUNC_DECLARATION);
    append(builder, "(");
    for args {
        if it_index > 0 append(builder, ", ");
        arg_flags := Print_Decl_Flags.NO_SEMICOLON | .NO_INDENT | .IN_FUNCTION_ARGS | .KEEP_POINTER_TO_VALUE;
        if !func arg_flags |= .NO_ARGUMENT_DEFAULTS;
        if type.flags & .ADD_C_TYPE_DETAILS arg_flags |= .C_TYPE_DETAILS;
        print_declaration_to_builder(builder, it, current_scope, arg_flags);
    }
    if type.flags & .VARIADIC {
        if args.count > 0 append(builder, ", ");
        append(builder, "__args: ..Any");
    }
    append(builder, ")");
    append(builder, " -> ");
    print_type_to_builder(builder, type.return_type, current_scope, .IN_FUNCTION_RETURN);
    append_calling_convention_directives(builder, type, func != null);
}

// `#cpp_method` passes the object as the first argument. Procedure types that are not
// foreign declarations (pointers, members) need `#c_call` spelled out.
append_calling_convention_directives :: (builder: *String_Builder, type: *Function_Type, assume_foreign: bool) {
    if type.flags & .CPP_METHOD append(builder, " #cpp_method");
    else if !assume_foreign append(builder, " #c_call");
    if returned_through_hidden_pointer(type.return_type) append(builder, " #cpp_return_type_is_non_pod");
}

// A C++ class that is returned through a hidden result pointer rather than in registers:
// for MSVC one with a user-declared constructor, for the Itanium ABI one with a copy or move
// constructor or a destructor.
returned_through_hidden_pointer :: (result: *CType) -> bool {
    if !result || !result.type_of_struct || result == context.generator.type_def_void return false;
    class_flags := result.type_of_struct.flags;
    if context.generator_options.os == .WINDOWS return (class_flags & .HAS_CONSTRUCTOR) != 0;
    return (class_flags & (.HAS_COPY_CONSTRUCTOR | .HAS_MOVE_CONSTRUCTOR | .HAS_DESTRUCTOR)) != 0;
}

// ----------------------------------------------------------------------------
// Expressions.

escape_string_literal :: (s: string) -> string {
    builder: String_Builder;
    append(*builder, "\"");
    for 0..s.count - 1 {
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
    for 0..text.count - 1 {
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
    if begins_with(raw, ".") return raw; // An enum value the generator wrote itself (`.NONE`).
    if raw == "nullptr" || raw == "NULL" || raw == "0" return ifx raw == "0" then "0" else "null";
    body := raw;
    negative := false;
    if begins_with(body, "-") {
        negative = true;
        body = advance(body, 1);
    }
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
            stripped_target := strip_type(target_type, typedefs = true);
            if stripped_target && stripped_target.pointer_to && lit.int_value == 0 {
                append(builder, "null");
            } else if stripped_target && stripped_target == context.generator.type_def_bool {
                append(builder, ifx lit.int_value == 0 then "false" else "true");
            } else {
                print_to_builder(builder, "%", lit.int_value);
            }
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
        name := unwrap_single_bitfield(it).output_name;
        if name.count > longest longest = name.count;
    }
    return longest;
}

print_comment_prefix :: (builder: *String_Builder, comment: Comment, no_indent: bool) {
    remainder := comment.text;
    while remainder {
        _, line, rest := split_from_left(remainder, #char "\n");
        remainder = rest;
        line = trim(line, " \t\r");
        append(builder, line);
        append(builder, "\n");
        if !no_indent append_indentation(builder);
    }
}

// A bit field run with a single member is printed as that member, typed as the storage. The
// member is copied: its own type is still needed for the accessors.
unwrap_single_bitfield :: (decl: *Declaration) -> *Declaration {
    if decl.kind == .BITFIELD {
        run := cast(*Bitfield) decl;
        if run.members.count == 1 {
            member := New(Declaration);
            member.* = run.members[0].*;
            member.type = run.type;
            return member;
        }
    }
    return decl;
}

// One declaration of any kind. `align_declarations` is the name width fields are padded to;
// `explicit_alignment` adds `#align` to a field.
print_declaration_to_builder :: (builder: *String_Builder, _decl: *Declaration, current_scope: *Declaration, flags: Print_Decl_Flags = 0, align_declarations := 0, explicit_alignment := 0) {
    decl := unwrap_single_bitfield(_decl);
    no_indent := (flags & .NO_INDENT) != 0;
    if !no_indent append_indentation(builder);

    // A comment from the lines above goes first; one from the same line goes last.
    comment_text := ifx context.generator_options.try_to_preserve_comments then decl.comment.text else "";
    comment_above := comment_text.count > 0 && is_prefix_comment(decl.comment);
    if comment_above print_comment_prefix(builder, decl.comment, no_indent);

    if decl.decl_flags & .QUALIFIER_AS append(builder, "#as ");
    if decl.decl_flags & .QUALIFIER_USING append(builder, "using ");

    kind := decl.kind;
    if kind == .DECLARATION print_data_declaration(builder, decl, current_scope, flags, align_declarations, explicit_alignment);
    else if kind == .FUNCTION print_function(builder, cast(*Function) decl, current_scope);
    else if kind == .STRUCT print_struct_and_followers(builder, cast(*Struct) decl, current_scope);
    else if kind == .BITFIELD print_bitfield_run(builder, cast(*Bitfield) decl, current_scope, flags, align_declarations);
    else if kind == .ENUM print_enum(builder, cast(*Enum) decl);
    else if kind == .TYPEDEF print_typedef(builder, cast(*Typedef) decl);
    else if kind == .NAMESPACE print_namespace(builder, cast(*Namespace) decl);
    else if kind == .MACRO_DEFINITION print_constant(builder, decl.output_name, decl.expression, null, null);
    else log("Bindings_Generator: cannot print a declaration of kind %\n", kind);

    if comment_text.count > 0 && !comment_above print_to_builder(builder, " %", normalize_line_endings(comment_text));
}

// `NAME :: value;`
print_constant :: (builder: *String_Builder, name: string, value: *Expression, type: *CType, current_scope: *Declaration) {
    print_to_builder(builder, "% :: ", name);
    print_expression_to_builder(builder, value, type, current_scope);
    append(builder, ";");
}

// `name: ` followed by the spaces that line the types of a struct up.
print_padded_name :: (builder: *String_Builder, name: string, width: int) {
    print_to_builder(builder, "%: ", name);
    for 1..width - name.count append(builder, #char " ");
}

// A struct and what has to come right after it: the block helper of an Objective-C block
// type, and the size checks, which a nested struct defers to the end of the file.
print_struct_and_followers :: (builder: *String_Builder, s: *Struct, current_scope: *Declaration) {
    print_struct(builder, s);
    context.generator.counts.structs += 1;
    if s.flags & .OBJC_BLOCK print_block_literal_helper(builder, s);

    if current_scope && current_scope.kind != .NAMESPACE return; // In a struct: its checks cover this one.
    flattened := !current_scope || (cast(*Namespace) current_scope).should_flatten;
    if flattened print_struct_checks(builder, s);
    else array_add(*context.generator.deferred_struct_checks, s);
}

// The storage member of a bit field run, then the members it holds, commented out below it.
print_bitfield_run :: (builder: *String_Builder, run: *Bitfield, current_scope: *Declaration, flags: Print_Decl_Flags, name_width: int) {
    print_padded_name(builder, run.output_name, name_width);
    print_type_to_builder(builder, run.type, current_scope, flags);
    append(builder, ";\n");
    append_indentation(builder);
    append(builder, "/* ");
    context.generator.tab_depth += 1;
    for run.members {
        append(builder, "\n");
        print_declaration_to_builder(builder, it, current_scope, flags);
    }
    context.generator.tab_depth -= 1;
    append(builder, "\n");
    append_indentation(builder);
    append(builder, "*/");
}

// A variable, field or argument; a constant with a value prints as a constant instead.
print_data_declaration :: (builder: *String_Builder, decl: *Declaration, current_scope: *Declaration, flags: Print_Decl_Flags, name_width: int, explicit_alignment: int) {
    if (decl.decl_flags & .IS_CONST) && decl.expression && !(flags & .IN_FUNCTION_ARGS) {
        print_constant(builder, decl.output_name, decl.expression, decl.type, current_scope);
        return;
    }

    // A `const T&` parameter is declared as a pointer, but its wrapper takes the value.
    by_value := (decl.decl_flags & .POINTER_TO_VALUE) != 0;
    keep_pointer := (flags & .KEEP_POINTER_TO_VALUE) != 0;
    shown := decl.type;
    if by_value && !keep_pointer && shown.pointer_to shown = shown.pointer_to;

    print_padded_name(builder, decl.output_name, name_width);
    if (flags & .C_TYPE_DETAILS) && context.generator_options.add_overloaded_const_and_ref_comments {
        print_c_type_details(builder, decl, decl.type);
    }
    if decl.decl_flags & .PRINT_AS_RAW {
        raw := strip_type(shown, typedefs = true).type_of_struct;
        append(builder, parent_path(raw));
        append(builder, raw.output_name);
        append(builder, "__RAW");
    } else {
        print_type_to_builder(builder, shown, current_scope, flags);
    }

    defaults_allowed := !(flags & .NO_ARGUMENT_DEFAULTS) && !(by_value && keep_pointer);
    if defaults_allowed && can_print_expression(decl.expression) print_default_value(builder, decl, current_scope);
    if decl.storage_class == .Extern && decl.foreign_name append_elsewhere(builder, decl, decl.foreign_name);
    if explicit_alignment > 0 print_to_builder(builder, " #align %", explicit_alignment);
    if !(flags & .NO_SEMICOLON) append(builder, ";");
    if decl.bitfield_width > 0 print_to_builder(builder, " /* % bits */", decl.bitfield_width);
}

// ` = value`. When an enum replaced an integer type (change_type_to_enum), a value that is
// not an enum member is cast: `= cast(Mode)2`.
print_default_value :: (builder: *String_Builder, decl: *Declaration, current_scope: *Declaration) {
    value: String_Builder;
    was_enum_member := print_expression_to_builder(*value, decl.expression, decl.type, current_scope);
    append(builder, " = ");
    if !was_enum_member && (decl.decl_flags & .NEEDS_DEFAULT_ARGUMENT_CAST) {
        append(builder, "cast(");
        print_type_to_builder(builder, decl.type, current_scope);
        append(builder, ")");
    }
    append(builder, builder_to_string(*value));
}

// A declaration printed on its own, for lists put together by the caller.
declaration_text :: (decl: *Declaration, current_scope: *Declaration, flags: Print_Decl_Flags) -> string {
    text: String_Builder;
    print_declaration_to_builder(*text, decl, current_scope, flags);
    return builder_to_string(*text);
}

// `/*const*/`, `/*reference*/` or `/*const reference*/` before an argument type, for C++
// overloads whose Jai signatures would otherwise be indistinguishable.
print_c_type_details :: (builder: *String_Builder, decl: *Declaration, type: *CType) {
    if !type return;
    is_const := (decl.decl_flags & .IS_CONST) != 0 || (type.flags & .CONST) != 0;
    if type.pointer_to && (type.flags & .REFERENCE) && (type.pointer_to.flags & .CONST) is_const = true;
    is_reference := (type.flags & .REFERENCE) != 0;
    if !is_const && !is_reference return;
    append(builder, "/*");
    if is_const append(builder, "const");
    if is_const && is_reference append(builder, " ");
    if is_reference append(builder, "reference");
    append(builder, "*/ ");
}

// `Block_X_literal(invoke, user_data)`: a block Objective-C can call, made from a Jai
// `#c_call` procedure. It is a global block (never copied or freed) built by the Objective_C
// module; `objc_block_user_data(block)` returns `user_data` inside `invoke`.
print_block_literal_helper :: (builder: *String_Builder, s: *Struct) {
    invoke: *Declaration;
    for s.declarations if it.name == "invoke" invoke = it;
    if !invoke return;
    append(builder, "\n");
    append_indentation(builder);
    print_to_builder(builder, "%_literal :: (invoke: ", s.output_name);
    print_type_to_builder(builder, invoke.type, null, .IN_FUNCTION_ARGS);
    print_to_builder(builder, ", user_data: *void = null) -> *% {\n", s.output_name);
    append_indentation(builder);
    print_to_builder(builder, "    return cast(*%) objc_make_block(cast(*void) invoke, user_data);\n", s.output_name);
    append_indentation(builder);
    append(builder, "}\n");
}

// Binds a declaration to its symbol: functions with `#foreign`, variables with `#elsewhere`.
// The symbol is only spelled out when it is not the name the declaration is printed with
// (`declared_name`, by default the output name).
append_elsewhere :: (builder: *String_Builder, decl: *Declaration, foreign_name: string, declared_name := "") {
    directive := "#elsewhere";
    if decl.kind == .FUNCTION directive = "#foreign";
    print_to_builder(builder, " %", directive);
    if decl.library print_to_builder(builder, " %", library_identifier(decl.library));
    printed_as := ifx declared_name then declared_name else decl.output_name;
    renamed := foreign_name.count > 0 && foreign_name != printed_as;
    if renamed print_to_builder(builder, " \"%\"", foreign_name);
}

// An Objective-C method is a message send through `objc_msgSend`, cast to the method's
// signature. Selectors are registered once in `__selectors` (see print_objc_selector_table).
// Methods returning `instancetype` are polymorphic in the receiver's class.
print_objc_method :: (builder: *String_Builder, func: *Function, current_scope: *Declaration) {
    type := func.type.type_of_function;
    is_class_method := (type.flags & .OBJC_CLASS_METHOD) != 0;
    returns_instancetype := (type.flags & .RETURNS_INSTANCETYPE) != 0;
    owner := cast(*Struct) func.parent;
    owner_name := join(parent_path(owner), owner.output_name);
    if owner.template_type_params.count > 0 {
        names: String_Builder;
        for owner.template_type_params {
            if it_index > 0 append(*names, ", ");
            append(*names, it.output_name);
        }
        owner_name = tprint("%(%)", owner_name, builder_to_string(*names));
    }

    print_to_builder(builder, "% :: inline (", func.output_name);
    for type.arguments {
        if it_index > 0 append(builder, ", ");
        if it_index == 0 && !is_class_method && returns_instancetype {
            print_to_builder(builder, "self: *$instancetype/%", owner_name);
        } else {
            print_declaration_to_builder(builder, it, current_scope, Print_Decl_Flags.NO_SEMICOLON | .NO_INDENT | .IN_FUNCTION_ARGS);
        }
    }
    return_text: string;
    if returns_instancetype {
        return_text = ifx is_class_method then join("*", owner_name) else "*instancetype";
    } else {
        return_text = type_to_string(type.return_type, current_scope, .IN_FUNCTION_RETURN);
    }
    returns_value := return_text != "void";
    append(builder, ")");
    if returns_value print_to_builder(builder, " -> %", return_text);
    append(builder, " {\n");

    context.generator.tab_depth += 1;
    append_indentation(builder);
    append(builder, "__selectors_init();\n");
    append_indentation(builder);
    append(builder, "_func: (obj: *void, selector: Selector");
    for type.arguments {
        if it_index == 0 continue;
        print_to_builder(builder, ", %: %", it.output_name, type_to_string(it.type, current_scope, .IN_FUNCTION_ARGS));
    }
    print_to_builder(builder, ") -> % #c_call;\n", return_text);
    append_indentation(builder);
    print_to_builder(builder, "_func = xx %;\n", ifx objc_returns_in_memory(type.return_type) then "objc_msgSend_stret" else "objc_msgSend");
    append_indentation(builder);
    if returns_value append(builder, "return ");
    print_to_builder(builder, "_func(%, __selectors.%", type.arguments[0].output_name, objc_selector_field(func.foreign_name));
    for type.arguments {
        if it_index == 0 continue;
        print_to_builder(builder, ", %", it.output_name);
    }
    append(builder, ");\n");
    context.generator.tab_depth -= 1;
    append_indentation(builder);
    append(builder, "}");
}

// x86-64 returns aggregates over 16 bytes through a hidden result pointer, and the Objective-C
// runtime then wants the message sent with `objc_msgSend_stret`. arm64 sends everything through
// `objc_msgSend`. (The decision follows `Generate_Bindings_Options.cpu`, not the host.)
objc_returns_in_memory :: (type: *CType) -> bool {
    if context.generator_options.cpu != .X64 return false;
    t := strip_type(type, typedefs = true);
    if !t || !t.type_of_struct return false;
    return t.size > 16 || (t.type_of_struct.type && t.type_of_struct.type.size > 16);
}

// `setX:y:` -> `setX_y_`
objc_selector_field :: (selector: string) -> string {
    builder: String_Builder;
    for 0..selector.count - 1 {
        c := selector[it];
        append(*builder, ifx c == #char ":" then cast(u8) #char "_" else c);
    }
    return avoid_reserved_names(builder_to_string(*builder));
}

// The selectors of all message sends, registered with the runtime on first use.
print_objc_selector_table :: (builder: *String_Builder, g: *Generator_State) {
    if !g.unique_objc_selectors.count return;
    append(builder, "\n\n#scope_file\n\n#import \"Objective_C\"; // For objc_msgSend and sel_registerName\n\n");
    append(builder, "_Generated_Selectors :: struct {\n    initialized: bool;\n");
    for g.unique_objc_selectors print_to_builder(builder, "    %: Selector;\n", objc_selector_field(it));
    append(builder, "}\n__selectors: _Generated_Selectors;\n\n");
    append(builder, "__selectors_init :: () {\n    if __selectors.initialized return;\n    __selectors.initialized = true;\n");
    for g.unique_objc_selectors print_to_builder(builder, "    __selectors.% = sel_registerName(\"%\");\n", objc_selector_field(it), it);
    append(builder, "}\n");
}

// A function: a foreign declaration (`virtual_` for a class's own implementation of a virtual
// function), plus a Jai-side wrapper when one was asked for. In a vtable it is a member of
// procedure type instead.
print_function :: (builder: *String_Builder, func: *Function, current_scope: *Declaration, in_vtable := false) {
    context.generator.counts.functions += 1;
    type := func.type.type_of_function;
    if type.flags & .OBJC_METHOD {
        print_objc_method(builder, func, current_scope);
        return;
    }

    // A printf-like function binds as `name_CFormat`; `name` is the wrapper that formats.
    printf_like := (func.decl_flags & .NEEDS_PRINTF_WRAPPER) != 0;
    bound_name := func.output_name;
    if printf_like {
        bound_name = sprint("%_CFormat", func.output_name);
        context.generator.generated_printf_wrapper = true;
    }

    if in_vtable {
        print_to_builder(builder, "%: ", bound_name);
        print_function_type_to_builder(builder, type, current_scope, func, false);
        append(builder, ";");
        return;
    }

    declared_name := ifx func.is_virtual then join("virtual_", bound_name) else bound_name;
    print_to_builder(builder, "% :: ", declared_name);
    print_function_type_to_builder(builder, type, current_scope, func, false);
    // C symbols have no foreign_name; the Jai name differs from them for `name_CFormat`, after
    // `strip_prefixes` and for names Jai reserves.
    symbol := ifx func.foreign_name then func.foreign_name else func.name;
    append_elsewhere(builder, func, symbol, declared_name);
    append(builder, ";");

    if printf_like {
        print_function_wrapper(builder, func, bound_name, true, current_scope);
    } else if func.decl_flags & .NEEDS_ARGUMENT_WRAPPER {
        // A wrapper cannot pass C varargs on.
        if type.flags & .VARIADIC log("Bindings_Generator: % is variadic, so it gets no wrapper taking its `const &` arguments by value.\n", func.name);
        else print_function_wrapper(builder, func, bound_name, false, current_scope);
    }
}

// The Jai procedure in front of a foreign one (named `bound_name`). For a printf-like
// function it takes a Jai format string and `..Any` arguments and passes the formatted text
// as a `"%s"` argument; otherwise it takes `const T&` arguments by value and passes pointers.
print_function_wrapper :: (builder: *String_Builder, func: *Function, bound_name: string, printf_like: bool, current_scope: *Declaration) {
    options := *context.generator_options;
    type := func.type.type_of_function;
    params := options.get_func_args_for_printing(func, type, .OUTER_WRAPPER);
    call_args := options.get_func_args_for_printing(func, type, .INNER_WRAPPER_CALL);

    declared: [..] string;
    passed: [..] string;
    declared.allocator = temp;
    passed.allocator = temp;
    format: *Declaration;
    if printf_like {
        // The last C argument, the format, is replaced.
        format = params[params.count - 1];
        params.count -= 1;
        call_args.count -= 1;
    }
    for params array_add(*declared, declaration_text(it, current_scope, Print_Decl_Flags.NO_SEMICOLON | .NO_INDENT | .IN_FUNCTION_ARGS));
    for call_args array_add(*passed, ifx it.decl_flags & .POINTER_TO_VALUE then tprint("*%", it.output_name) else it.output_name);
    if format {
        array_add(*declared, tprint("%: string, __args: ..Any", format.output_name));
        array_add(*passed, join("\"%s\", temp_c_string(tprint(", format.output_name, ", ..__args))"));
    }

    returns_value := type.return_type != context.generator.type_def_void;
    append(builder, "\n");
    append_indentation(builder);
    print_to_builder(builder, "% :: (%)", func.output_name, join(..declared, separator = ", "));
    if returns_value {
        append(builder, " -> ");
        print_type_to_builder(builder, type.return_type, current_scope);
    }
    // The formatting wrapper needs the context (temporary storage); the other does not.
    append(builder, ifx printf_like then " {\n" else " #no_context {\n");

    context.generator.tab_depth += 1;
    append_indentation(builder);
    if returns_value append(builder, "return ");
    print_to_builder(builder, "%(%);\n", bound_name, join(..passed, separator = ", "));
    context.generator.tab_depth -= 1;
    append_indentation(builder);
    append(builder, ifx printf_like then "} @PrintLike" else "}");
}

// ----------------------------------------------------------------------------
// Enums, typedefs, structs, namespaces.

// Hex is only used for values that are not negative; a negative one stays decimal.
append_integer :: (builder: *String_Builder, value: $T, as_hex: bool) {
    if as_hex && value >= 0 print_to_builder(builder, "0x%", formatInt(value, base = 16));
    else print_to_builder(builder, "%", value);
}

print_enum :: (builder: *String_Builder, e: *Enum) {
    // With `c_enum_emulation` the values are also reachable without the enum's name, as in C.
    lead := ifx context.generator_options.c_enum_emulation then "using " else "";
    print_to_builder(builder, "%% :: ", lead, e.output_name);
    print_enum_body(builder, e);
}

// `enum u32 { ... }`: the values, then (with ALIAS_ORIGINAL_NAMES) the C names of the values
// that were renamed, as constants naming the new ones.
print_enum_body :: (builder: *String_Builder, e: *Enum) {
    context.generator.counts.enums += 1;
    append(builder, ifx (e.flags & .IS_ENUM_FLAGS) != 0 then "enum_flags" else "enum");
    if e.type {
        append(builder, " ");
        print_type_to_builder(builder, e.type, e.parent);
    }
    if e.decl_flags & .TYPE_INFO_NONE append(builder, " #type_info_none");
    append(builder, " {\n");

    context.generator.tab_depth += 1;
    printed_values := print_enum_values(builder, e);
    if e.flags & .ALIAS_ORIGINAL_NAMES print_enum_aliases(builder, e, printed_values);
    context.generator.tab_depth -= 1;

    append_indentation(builder);
    append(builder, "}");
}

// One `NAME :: value;` line per value that has a name, the names padded to a common width.
// Returns whether there was any.
print_enum_values :: (builder: *String_Builder, e: *Enum) -> bool {
    width := 0;
    for e.enumerates {
        if !(it.decl_flags & .OMIT_FROM_OUTPUT) width = max(width, it.output_name.count);
    }
    signed := is_signed_storage(e.type);
    hex := (e.flags & .VALUES_IN_HEX) != 0;
    keep_blank_lines := (e.flags & .MIMIC_SPACING) != 0;

    previous: Location;
    count := 0;
    for e.enumerates {
        if !it.output_name || (it.decl_flags & .OMIT_FROM_OUTPUT) continue;
        maybe_add_spacing(builder, *previous, it.location, 0, keep_blank_lines);
        append_indentation(builder);
        has_comment := it.comment.text.count > 0;
        comment_above := has_comment && is_prefix_comment(it.comment);
        if comment_above print_comment_prefix(builder, it.comment, false);

        append_padded(builder, it.output_name, width);
        append(builder, " :: ");
        // A value from a macro keeps its expression text.
        value := cast(*Literal) it.expression;
        if !value || value.kind != .LITERAL append(builder, "0");
        else if value.literal_kind == .MACRO append(builder, value.raw_value);
        else if signed append_integer(builder, value.int_value, hex);
        else append_integer(builder, cast,no_check(u64) value.int_value, hex);
        append(builder, ";");
        if has_comment && !comment_above print_to_builder(builder, " %", it.comment.text);
        append(builder, "\n");
        count += 1;
    }
    return count > 0;
}

// `C_NAME :: NAME;` for each renamed value, after a blank line when values precede them.
print_enum_aliases :: (builder: *String_Builder, e: *Enum, after_values: bool) {
    width := 0;
    for e.enumerates {
        if it.name != it.output_name && !(it.decl_flags & .OMIT_FROM_OUTPUT) width = max(width, it.name.count);
    }
    need_gap := after_values;
    for e.enumerates {
        if !it.output_name || it.name == it.output_name || (it.decl_flags & .OMIT_FROM_OUTPUT) continue;
        if need_gap {
            append(builder, "\n");
            need_gap = false;
        }
        append_indentation(builder);
        append_padded(builder, it.name, width);
        print_to_builder(builder, " :: %;\n", it.output_name);
    }
}

// `text` followed by spaces up to `width` characters.
append_padded :: (builder: *String_Builder, text: string, width: int) {
    append(builder, text);
    for 1..width - text.count append(builder, #char " ");
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
    if s.flags & .NEEDS_RAW {
        // A derived class puts its fields into the tail padding of this one (Itanium C++ ABI).
        // Jai structs are padded to their alignment, so the data lives in `X__RAW`, printed
        // without trailing padding, and `X` wraps it.
        print_struct_body(builder, s, false, .WRAPPER);
        append(builder, "\n");
        append_indentation(builder);
        print_to_builder(builder, "// % without padding. Needed to generate a C++-equivalent struct layout when \"inheriting\" from %\n", s.output_name, s.output_name);
        append_indentation(builder);
        print_to_builder(builder, "%__RAW :: ", s.output_name);
        print_struct_body(builder, s, false, .RAW_DATA);
        append(builder, " #no_padding");
    } else {
        print_struct_body(builder, s, false);
    }

    // The vtable of a C++ class follows the class.
    if s.name && !(s.flags & .IS_ANON) && s.type {
        info := find_or_create_extra_info(s.type, s);
        if info && info.vtable.count > 0 {
            append(builder, "\n");
            append_indentation(builder);
            print_struct_vtable(builder, s, info);
        }
    }

    if context.generator_options.generate_bitfield_accessors print_bitfield_accessors(builder, s);

    // Operators are overloads at the scope of the struct, not members.
    last_location: Location;
    for s.declarations {
        if it.decl_flags & .OMIT_FROM_OUTPUT continue;
        if !is_operator(it) continue;
        append(builder, "\n");
        maybe_add_spacing(builder, *last_location, it.location, it.decl_flags, .STRUCT);
        print_declaration_to_builder(builder, it, null, 0);
    }
}

// C++ operators are printed after their struct, as overloads at the struct's scope.
is_operator :: (decl: *Declaration) -> bool {
    if decl.kind != .FUNCTION return false;
    return (cast(*Function) decl).is_operator;
}

Struct_Part :: enum {
    FULL;
    WRAPPER; // `X :: struct { using x__raw: X__RAW; <everything but the data> }`
    RAW_DATA; // The data members only.
}

// `union { ... }` / `struct { ... }` with the members, shared by named and inline structs.
print_struct_body :: (builder: *String_Builder, s: *Struct, as_type: bool, part := Struct_Part.FULL) {
    if s.flags & .IS_UNION append(builder, "union");
    else append(builder, "struct");

    if s.template_type_params.count > 0 {
        append(builder, "(");
        for s.template_type_params {
            if it_index > 0 append(builder, ", ");
            print_declaration_to_builder(builder, it, s.parent, Print_Decl_Flags.NO_SEMICOLON | .NO_INDENT);
        }
        append(builder, ")");
    }

    if s.decl_flags & .TYPE_INFO_NONE append(builder, " #type_info_none");
    else if s.decl_flags & .TYPE_INFO_PROCEDURES_ARE_VOID_POINTERS append(builder, " #type_info_procedures_are_void_pointers");
    append(builder, " {");

    context.generator.tab_depth += 1;
    mimic := (s.flags & .MIMIC_SPACING) != 0 || (context.generator_options.mimic_spacing_flags & .STRUCT) != 0;
    last_location: Location;
    max_len := get_name_alignment(s.declarations);
    printed := false;
    has_fields := false;

    local_names: [..] *Declaration;
    for s.template_type_params array_add(*local_names, it);
    for s.declarations {
        if it.decl_flags & .OMIT_FROM_OUTPUT continue;
        avoid_name_clash(*local_names, it);
    }

    info: *Struct_Extra_Info;
    has_vtable := false;
    if !as_type && s.type {
        info = find_or_create_extra_info(s.type, s);
        has_vtable = info != null && info.vtable.count > 0;
    }

    // Base classes: `#as using base: Base;`. Only one base with a vtable can be
    // `using`-ed (their vtable members would clash), and none that would shadow members.
    if part == .WRAPPER {
        append(builder, "\n");
        append_indentation(builder);
        print_to_builder(builder, "using %__raw: %__RAW;", to_lower_copy(s.output_name), s.output_name);
        printed = true;
        has_fields = true;
    }

    // In the RAW variant a struct has no implicit padding: spell out the gaps clang laid out.
    raw_next := 0;
    raw_padding_count := 0;
    if part == .RAW_DATA && has_vtable && !info.vtable_parent raw_next = context.generator.pointer_size;

    // A class with virtual bases is dynamic even without virtual functions: unless a
    // non-virtual base at offset 0 brings one, it starts with its own vtable pointer.
    if part != .WRAPPER && !as_type && !has_vtable && s.virtual_bases.count > 0 && !first_parent_is_dynamic(s) {
        append(builder, "\n");
        append_indentation(builder);
        append(builder, "__vptr: *void; // C++ virtual bases make the class dynamic");
        if part == .RAW_DATA raw_next = context.generator.pointer_size;
        printed = true;
        has_fields = true;
    }

    seen_dynamic_base := false;
    for parent: s.parents {
        if part == .WRAPPER continue;
        parent_info, parent_struct := find_or_create_extra_info(parent.type, s);
        // Only one base with a vtable pointer can be `using`-ed: the pointers' names collide.
        dynamic_base := parent_info != null && (parent_info.vtable.count > 0 || parent_info.vtable_parent != null);
        disable_using := dynamic_base && seen_dynamic_base;
        if dynamic_base seen_dynamic_base = true;
        if !disable_using && parent_struct disable_using = base_shadows_names(parent_struct, local_names);
        if disable_using {
            parent.decl_flags &= ~ .QUALIFIER_USING;
            prepend_comment(*parent.comment, "// jai: not `using`, its names would collide with others in this struct");
        }
        append(builder, "\n");
        maybe_add_spacing(builder, *last_location, parent.location, parent.decl_flags, mimic);
        if (s.flags & (Struct.Flags.OBJC_INTERFACE | .OBJC_PROTOCOL)) && it_index > 0 {
            // Every superclass and protocol of an Objective_C object is the object itself.
            append_indentation(builder);
            print_to_builder(builder, "#place %;\n", s.parents[0].output_name);
        }
        if part == .RAW_DATA && !(s.flags & .IS_UNION) {
            // No implicit padding between the bases either.
            alignment := max(get_type_alignment(parent.type), 1);
            offset := (raw_next + alignment - 1) / alignment * alignment;
            if offset > raw_next {
                append_indentation(builder);
                print_to_builder(builder, "__padding%: [%] u8;\n", raw_padding_count, offset - raw_next);
                raw_padding_count += 1;
            }
            raw_next = offset + get_base_data_size(parent);
        }
        print_declaration_to_builder(builder, parent, s, 0);
        printed = true;
        if parent.type.size > 0 has_fields = true;
    }

    // A non-virtual base that has virtual bases of its own embeds them here, but C++ shares
    // them at the end of the most derived object: the Jai layout cannot match.
    inherits_virtual_bases := false;
    for s.parents {
        base := get_base_struct(it);
        if base && struct_has_virtual_bases(base) inherits_virtual_bases = true;
    }
    if part == .FULL && inherits_virtual_bases {
        s.flags |= .NO_STRUCT_CHECKS;
        append(builder, "\n");
        append_indentation(builder);
        append(builder, "// jai: a base class has C++ virtual bases, which this class shares; its layout differs from C++, do not use these fields.");
    } else if part == .FULL && s.parents.count > 0 && !(s.flags & .IS_UNION) && s.type {
        _, end := get_printed_base_layout(s);
        first_own := get_first_own_offset(s);
        if first_own >= 0 && first_own < end {
            s.flags |= .NO_STRUCT_CHECKS;
            append(builder, "\n");
            append_indentation(builder);
            append(builder, "// jai: the C++ layout of this class differs (its fields reuse tail padding of a base class); do not use these fields.");
        }
    }

    // libclang does not report the vtable pointer as a field.
    if has_vtable && !info.vtable_parent && part != .WRAPPER {
        append(builder, "\n");
        append_indentation(builder);
        print_to_builder(builder, "%: *%_VTable;", info.vtable_name, s.output_name);
        printed = true;
        has_fields = true;
    }

    // Where the next field lands with Jai's natural alignment, to spot fields that C packs
    // tighter (`#pragma pack`) or aligns further (`alignas`): those get an explicit `#align`.
    check_alignment := part == .FULL && !(s.flags & .IS_UNION) && !(s.decl_flags & .TEMPLATE) && !as_type && s.parents.count == 0 && !has_vtable;
    next_field_offset := 0;
    for s.declarations {
        if it.decl_flags & .OMIT_FROM_OUTPUT continue;
        if is_operator(it) continue;
        is_data := is_struct_field(it);
        if part == .WRAPPER && is_data continue;
        if part == .RAW_DATA && !is_data continue;
        explicit_alignment := 0;
        if check_alignment && is_data {
            if it.kind == .DECLARATION && it.bitfield_width <= 0 {
                offset, size, alignment := get_field_layout(it);
                if offset >= 0 && size >= 0 && alignment > 0 && next_field_offset >= 0 {
                    padded := (next_field_offset + alignment - 1) / alignment * alignment;
                    if padded != offset explicit_alignment = alignment_reaching(next_field_offset, offset, alignment);
                }
                next_field_offset = ifx offset >= 0 && size >= 0 then offset + size else -1;
            } else {
                // Anonymous members and bit fields: libclang's offsets are not reliable here.
                offset, size := get_field_layout(it);
                next_field_offset = ifx offset >= 0 && size >= 0 then offset + size else -1;
            }
        }
        if part == .RAW_DATA && !(s.flags & .IS_UNION) {
            offset, size, alignment := get_field_layout(it);
            if offset < 0 && alignment > 0 offset = (raw_next + alignment - 1) / alignment * alignment;
            if offset > raw_next {
                append(builder, "\n");
                append_indentation(builder);
                print_to_builder(builder, "__padding%: [%] u8;", raw_padding_count, offset - raw_next);
                raw_padding_count += 1;
            }
            if offset >= 0 && size >= 0 raw_next = offset + size;
        }
        append(builder, "\n");
        maybe_add_spacing(builder, *last_location, it.location, it.decl_flags, mimic);
        flags: Print_Decl_Flags;
        print_declaration_to_builder(builder, it, s, flags, max_len, explicit_alignment);
        printed = true;
        if is_struct_field(it) has_fields = true;
    }

    if part != .WRAPPER print_bitfield_alignment_helper(builder, s);

    // Virtual bases come after everything else, where clang puts them in a complete object.
    if part != .WRAPPER && !as_type && s.virtual_bases.count > 0 {
        end := nonvirtual_data_end(s, has_vtable || !first_parent_is_dynamic(s));
        for vbase: s.virtual_bases {
            append(builder, "\n");
            append_indentation(builder);
            if part == .RAW_DATA {
                offset := vbase.bit_offset_in_parent / 8;
                if vbase.bit_offset_in_parent >= 0 && offset > raw_next {
                    print_to_builder(builder, "__padding%: [%] u8;\n", raw_padding_count, offset - raw_next);
                    append_indentation(builder);
                    raw_padding_count += 1;
                }
                if vbase.bit_offset_in_parent >= 0 raw_next = offset + max(vbase.type.size, 0);
            }
            explicit_alignment := 0;
            natural := get_type_alignment(vbase.type);
            if end >= 0 && vbase.bit_offset_in_parent >= 0 && natural > 0 && part != .RAW_DATA {
                offset := vbase.bit_offset_in_parent / 8;
                if (end + natural - 1) / natural * natural != offset explicit_alignment = alignment_reaching(end, offset, natural);
                end = offset + max(vbase.type.size, 0);
            } else {
                end = -1;
            }
            print_declaration_to_builder(builder, vbase, s, .NO_INDENT, 0, explicit_alignment);
            append(builder, " // C++ virtual base");
            // libclang before 20 cannot report the offset: no placement and no struct check.
            if vbase.bit_offset_in_parent < 0 append(builder, " (offset unknown to this libclang)");
            printed = true;
            if vbase.type.size > 0 has_fields = true;
        }
    }

    // A derived class's own vtable pointer overlays the one of its first base.
    if has_vtable && info.vtable_parent && part != .WRAPPER {
        append(builder, "\n");
        append_indentation(builder);
        print_to_builder(builder, "#place %; %: *%_VTable;", info.vtable_parent_declaration.output_name, info.vtable_name, s.output_name);
        printed = true;
        has_fields = true;
    }

    if !as_type && part != .WRAPPER && !has_fields && s.type && s.type.size == 1 {
        append(builder, "\n");
        append_indentation(builder);
        append(builder, "__empty_struct_padding: u8; // An empty C++ class still takes up one byte");
        printed = true;
    }

    // Virtual functions are normally called through the vtable; these bindings call a
    // specific implementation (e.g. a base class's from an override).
    first_virtual := true;
    for s.virtual_functions {
        if part == .RAW_DATA break;
        if it.decl_flags & .OMIT_FROM_OUTPUT continue;
        if !it.library && (context.generator_options.strip_flags & .SYMBOLS_WITH_UNKNOWN_FOREIGN_LIBS) continue;
        if first_virtual {
            first_virtual = false;
            append(builder, "\n");
            for line: string.[
                "// This class's own implementations of its virtual functions. Calls normally go",
                "// through the vtable; bind these to reach a base class's version from an override,",
                "// or to fill in a vtable by hand.",
            ] {
                append(builder, "\n");
                append_indentation(builder);
                append(builder, line);
            }
        }
        append(builder, "\n");
        maybe_add_spacing(builder, *last_location, it.location, it.decl_flags, mimic);
        print_declaration_to_builder(builder, it, s);
        printed = true;
    }

    append(builder, "\n");
    context.generator.tab_depth -= 1;
    append_indentation(builder);
    append(builder, "}");
}

// Would `using` a base bring in a data member or type parameter named like a member of the
// derived struct? (Functions may overload.)
base_shadows_names :: (base: *Struct, local_names: [..] *Declaration) -> bool {
    for member: base.declarations {
        if member.kind == .FUNCTION || (member.decl_flags & .OMIT_FROM_OUTPUT) continue;
        for local_names {
            if it.kind != .FUNCTION && it.output_name == member.output_name return true;
        }
    }
    for param: base.template_type_params {
        for local_names {
            if it.output_name == param.output_name return true;
        }
    }
    return false;
}

// ----------------------------------------------------------------------------
// Bit fields.

// Alignment in bytes of a type as C lays it out; 0 when it cannot be told (templates).
get_type_alignment :: (type: *CType) -> s64 {
    if !type return 0;
    if type.alignment > 0 return type.alignment;
    if type.template_instantiation_params.count > 0 return 0;
    if type.pointer_to || type.type_of_function return context.generator.pointer_size;
    if type.type_of_typedef return get_type_alignment(type.type_of_typedef.type);
    if type.array_element_type return get_type_alignment(type.array_element_type);
    if type.type_of_struct {
        s := type.type_of_struct;
        if s.decl_flags & .TEMPLATE return 0;
        return get_struct_alignment(s, true);
    }
    if type.type_of_enum && type.type_of_enum.type return type.type_of_enum.type.size;
    return max(type.size, 1);
}

// With `include_bitfield_alignment` false the widest declared type of the bit fields does not count.
get_struct_alignment :: (s: *Struct, include_bitfield_alignment: bool) -> s64 {
    best := 1;
    for s.parents {
        a := get_type_alignment(it.type);
        if a == 0 return 0;
        if a > best best = a;
    }
    for s.declarations {
        if it.decl_flags & .OMIT_FROM_OUTPUT continue;
        a := 1;
        if it.kind == .BITFIELD {
            bf := cast(*Bitfield) it;
            if !bf.type.array_element_type a = bf.type.size;
            if include_bitfield_alignment && bf.alignment_type a = max(a, bf.alignment_type.size);
        } else {
            is_field := is_struct_field(it);
            if !is_field continue;
            if it.kind == .STRUCT {
                a = get_struct_alignment(cast(*Struct) it, include_bitfield_alignment);
            } else {
                a = get_type_alignment(it.type);
            }
            if a == 0 return 0;
        }
        if a > best best = a;
    }
    return best;
}

// C aligns a struct for the widest declared type of its bit fields even when the storage
// member is narrower. A `#place` member of that type recreates the alignment.
print_bitfield_alignment_helper :: (builder: *String_Builder, s: *Struct) {
    if s.decl_flags & .TEMPLATE return;
    needed: *Bitfield;
    for s.declarations {
        if it.kind != .BITFIELD || (it.decl_flags & .OMIT_FROM_OUTPUT) continue;
        bf := cast(*Bitfield) it;
        if bf.alignment_type && (!needed || needed.alignment_type.size < bf.alignment_type.size) needed = bf;
    }
    if !needed return;
    natural := get_struct_alignment(s, false);
    if natural == 0 || natural >= needed.alignment_type.size return;

    anchor: *Declaration;
    for s.declarations {
        if it.decl_flags & .OMIT_FROM_OUTPUT continue;
        is_field, is_anon := is_struct_field(it);
        if is_field && !is_anon {
            anchor = unwrap_single_bitfield(it);
            break;
        }
    }
    if !anchor return;

    aligned_name := unwrap_single_bitfield(needed).output_name;
    append(builder, "\n");
    append_indentation(builder);
    print_to_builder(builder, "#place %; %_alignment: ", anchor.output_name, aligned_name);
    print_type_to_builder(builder, needed.alignment_type, null);
    append(builder, ";");
}

// Offset (bytes, -1 if unknown), size and alignment (0 if unknown) of a data member as clang laid it out.
struct_has_virtual_bases :: (s: *Struct) -> bool {
    if s.virtual_bases.count > 0 return true;
    for s.parents {
        base := get_base_struct(it);
        if base && struct_has_virtual_bases(base) return true;
    }
    return false;
}

// Whether `s` has a vtable pointer: virtual functions, virtual bases or a dynamic base.
struct_is_dynamic :: (s: *Struct) -> bool {
    if s.virtual_bases.count > 0 || s.virtual_functions.count > 0 return true;
    for s.parents {
        base := get_base_struct(it);
        if base && struct_is_dynamic(base) return true;
    }
    return false;
}

// Itanium puts the first dynamic non-virtual base at offset 0, where its vptr serves the class.
first_parent_is_dynamic :: (s: *Struct) -> bool {
    for s.parents {
        base := get_base_struct(it);
        if base && struct_is_dynamic(base) return true;
    }
    return false;
}

// Where the non-virtual part of `s` ends, from libclang's offsets (-1 when unknown).
nonvirtual_data_end :: (s: *Struct, own_vptr: bool) -> s64 {
    end := ifx own_vptr then context.generator.pointer_size else 0;
    for s.parents {
        if it.bit_offset_in_parent < 0 || it.type.size < 0 return -1;
        end = max(end, it.bit_offset_in_parent / 8 + it.type.size);
    }
    for s.declarations {
        if it.decl_flags & .OMIT_FROM_OUTPUT continue;
        is_data := is_struct_field(it);
        if !is_data || it.storage_class == .Static continue;
        offset, size := get_field_layout(it);
        if offset < 0 || size < 0 return -1;
        end = max(end, offset + size);
    }
    return end;
}

// The power-of-two alignment that moves a field from `next` (the end of the previous field)
// to `offset`, or 0 when there is none (then the layout cannot be expressed this way).
// A packed field gets the largest alignment below its natural one that works, so the
// struct keeps as much of its alignment as the C one (`#pragma pack(4)` -> `#align 4`).
alignment_reaching :: (next: s64, offset: s64, natural: s64) -> s64 {
    if offset < (next + natural - 1) / natural * natural {
        a := natural;
        while a >= 1 {
            if (next + a - 1) / a * a == offset return a;
            a /= 2;
        }
        return 0;
    }
    a := natural;
    while a <= 4096 {
        if (next + a - 1) / a * a == offset return a;
        a *= 2;
    }
    return 0;
}

get_field_layout :: (decl: *Declaration) -> offset: s64, size: s64, alignment: s64 {
    if decl.kind == .BITFIELD {
        bf := cast(*Bitfield) decl;
        return bf.start_byte, bf.byte_count, ifx bf.type.array_element_type then 1 else bf.type.size;
    }
    if decl.kind == .STRUCT {
        st := cast(*Struct) decl;
        return -1, ifx st.type then st.type.size else -1, get_struct_alignment(st, true);
    }
    offset := -1;
    if decl.bit_offset_in_parent >= 0 offset = decl.bit_offset_in_parent / 8;
    if !decl.type return offset, -1, 0;
    return offset, decl.type.size, get_type_alignment(decl.type);
}

// The struct a base-class declaration names (null for template instantiations and unknown types).
get_base_struct :: (parent: *Declaration) -> *Struct {
    base_type := strip_type(parent.type, typedefs = true);
    if !base_type || !base_type.type_of_struct || base_type.template_instantiation_params.count > 0 return null;
    return base_type.type_of_struct;
}

// The bytes of a base class that fields of the derived class may not reuse.
get_base_data_size :: (parent: *Declaration) -> s64 {
    if parent.decl_flags & .PRINT_AS_RAW {
        return get_data_size(get_base_struct(parent));
    }
    return max(parent.type.size, 0);
}

// Where the Itanium ABI puts each non-virtual base of `s` and where the bases' data ends.
// A base is followed by whatever fits after its data size (`reuse[i]`: the data size of a
// non-POD base, else its full size), aligned for the next base.
get_base_layout :: (s: *Struct, reuse: [] bool) -> offsets: [] s64, end: s64 {
    offsets: [..] s64;
    end := 0;
    info := find_or_create_extra_info(s.type, s);
    if info && info.vtable.count > 0 && !info.vtable_parent end = context.generator.pointer_size;
    for parent: s.parents {
        alignment := max(get_type_alignment(parent.type), 1);
        end = (end + alignment - 1) / alignment * alignment;
        array_add(*offsets, end);
        size := max(parent.type.size, 0);
        base := get_base_struct(parent);
        if reuse[it_index] && base size = get_data_size(base);
        end += size;
    }
    return offsets, end;
}

// `get_base_layout` for the bases as they are printed.
get_printed_base_layout :: (s: *Struct) -> offsets: [] s64, end: s64 {
    reuse: [..] bool;
    for s.parents array_add(*reuse, (it.decl_flags & .PRINT_AS_RAW) != 0);
    return get_base_layout(s, reuse);
}

// Size of the data of a class without its tail padding (what a derived class starts after).
get_data_size :: (s: *Struct) -> s64 {
    _, end := get_printed_base_layout(s);
    for s.declarations {
        if it.decl_flags & .OMIT_FROM_OUTPUT continue;
        is_data := is_struct_field(it);
        if !is_data continue;
        offset, size, alignment := get_field_layout(it);
        if offset < 0 {
            offset = ifx alignment > 0 then (end + alignment - 1) / alignment * alignment else end;
        }
        if size >= 0 end = max(end, offset + size);
    }
    return end;
}

// Offset of the first data member of a class itself (-1 if it has none).
get_first_own_offset :: (s: *Struct) -> s64 {
    first_own := -1;
    for s.declarations {
        if it.decl_flags & .OMIT_FROM_OUTPUT continue;
        is_data := is_struct_field(it);
        if !is_data continue;
        offset := get_field_layout(it);
        if offset >= 0 && (first_own < 0 || offset < first_own) first_own = offset;
    }
    return first_own;
}

// Does laying the bases out with `reuse` agree with where clang put the class's own members?
base_layout_matches :: (s: *Struct, end: s64) -> bool {
    first_own := get_first_own_offset(s);
    if first_own >= 0 return first_own >= end;
    if s.type.size < 0 return true;
    alignment := max(get_struct_alignment(s, true), 1);
    return (end + alignment - 1) / alignment * alignment == s.type.size;
}

// Does the class have what makes the Itanium ABI let derived classes use its tail padding
// (a user-declared constructor or destructor, virtual functions, or such a base)?
is_probably_non_pod :: (s: *Struct) -> bool {
    if s.flags & (Struct.Flags.HAS_CONSTRUCTOR | .HAS_COPY_CONSTRUCTOR | .HAS_MOVE_CONSTRUCTOR | .HAS_DESTRUCTOR) return true;
    info := find_or_create_extra_info(s.type, s);
    if info && (info.vtable.count > 0 || info.vtable_parent) return true;
    for s.parents {
        base := get_base_struct(it);
        if base && is_probably_non_pod(base) return true;
    }
    return false;
}

// Classes whose fields live in the tail padding of their base classes: each such base is
// printed with a padding-free `__RAW` variant for the derived class to embed. The bases of
// a class are laid out in order, each after the data of the previous one, so with several
// bases any of them may be the one whose padding gets reused. Which ones is found by trying
// the possibilities against the offsets clang reports; if none agrees, the class is left
// alone (print_struct_body comments it and skips the struct checks).
mark_tail_padding_bases :: (g: *Generator_State) {
    done: Table(*Struct, bool);
    for s: g.structs_to_check mark_tail_padding_struct(s, *done);
}

mark_tail_padding_struct :: (s: *Struct, done: *Table(*Struct, bool)) {
    if table_contains(done, s) return;
    table_add(done, s, true);
    if (s.decl_flags & (Declaration_Flags.OMIT_FROM_OUTPUT | .TEMPLATE)) || (s.flags & .IS_UNION) || !s.type return;
    if s.parents.count == 0 || s.parents.count > 6 return;
    // Shared virtual bases make the layout inexpressible anyway (see print_struct_body).
    if struct_has_virtual_bases(s) return;

    // The data size of a base depends on how its own bases were marked.
    for s.parents {
        base := get_base_struct(it);
        if base mark_tail_padding_struct(base, done);
    }

    candidates: [..] bool; // May the padding after this base be reused?
    for s.parents {
        base := get_base_struct(it);
        ok := base != null && !(base.decl_flags & (Declaration_Flags.OMIT_FROM_OUTPUT | .TEMPLATE)) && !(base.flags & (Struct.Flags.IS_UNION | .IS_INCOMPLETE)) && base.name != "";
        array_add(*candidates, ok && get_data_size(base) < it.type.size);
    }

    // The Itanium ABI reuses the tail padding of every non-POD base. Whether a base is POD is not
    // always visible (a class with no own members fits both layouts), so the candidates that look
    // non-POD are tried first, then the remaining combinations.
    preferred := 0;
    for s.parents {
        if candidates[it_index] && is_probably_non_pod(get_base_struct(it)) preferred |= 1 << it_index;
    }

    reuse: [..] bool;
    for 0..s.parents.count - 1 array_add(*reuse, false);
    found := false;
    for attempt: 0..(1 << s.parents.count) {
        mask := ifx attempt == 0 then preferred else attempt - 1;
        valid := true;
        for 0..s.parents.count - 1 {
            reuse[it] = (mask & (1 << it)) != 0;
            if reuse[it] && !candidates[it] valid = false;
        }
        if !valid continue;
        _, end := get_base_layout(s, reuse);
        if base_layout_matches(s, end) {
            found = true;
            break;
        }
    }
    if !found return;

    for parent: s.parents {
        if !reuse[it_index] continue;
        base := get_base_struct(parent);
        base.flags |= .NEEDS_RAW;
        if !(parent.decl_flags & .PRINT_AS_RAW) {
            parent.decl_flags |= .PRINT_AS_RAW;
            parent.output_name = sprint("%__raw", parent.output_name);
        }
    }
}

hex :: (value: u64) -> string {
    return tprint("0x%", formatInt(value, base = 16));
}

// Extension: `S_get_x` / `S_set_x` procedures that read and write a bit field member by its
// bit offset.
print_bitfield_accessors :: (builder: *String_Builder, s: *Struct) {
    if s.decl_flags & .TEMPLATE return;
    if !s.name || (s.flags & .IS_ANON) || !s.output_name return;
    if s.parent && s.parent.kind == .STRUCT return;
    printed := false;
    for s.declarations {
        if it.kind != .BITFIELD || (it.decl_flags & .OMIT_FROM_OUTPUT) continue;
        bf := cast(*Bitfield) it;
        for m: bf.members {
            if m.decl_flags & .OMIT_FROM_OUTPUT continue;
            if begins_with(m.name, "_anon") || !m.type continue;
            width := m.bitfield_width;
            offset := m.bit_offset_in_parent;
            if width <= 0 || width > 64 || offset < 0 continue;
            first_byte := offset / 8;
            shift := offset % 8;
            nbytes := (shift + width + 7) / 8;
            if nbytes > 8 continue;
            real := m.type;
            while real.type_of_typedef real = real.type_of_typedef.type;
            is_bool := real.hardcoded_jai_string == "bool";
            is_signed := (real.number_flags & .SIGNED) != 0;
            if real.type_of_enum && real.type_of_enum.type is_signed = (real.type_of_enum.type.number_flags & .SIGNED) != 0;
            mask: u64 = 0xffff_ffff_ffff_ffff;
            if width < 64 mask = ((cast(u64) 1) << width) - 1;

            append(builder, "\n\n");
            print_to_builder(builder, "%_get_% :: (s: *%) -> ", s.output_name, m.output_name, s.output_name);
            print_type_to_builder(builder, m.type, null);
            append(builder, " {\n    bits: u64;\n    base := cast(*u8) s;\n");
            print_to_builder(builder, "    for 0..% bits |= (cast(u64) base[%+it]) << (cast(u64) (8 * it));\n", nbytes - 1, first_byte);
            print_to_builder(builder, "    bits = (bits >> %) & %;\n", shift, hex(mask));
            if is_signed && width < 64 {
                print_to_builder(builder, "    if bits & % bits |= %;\n", hex((cast(u64) 1) << (width - 1)), hex(~mask));
            }
            if is_bool {
                append(builder, "    return bits != 0;\n}");
            } else {
                append(builder, "    return cast,trunc(");
                print_type_to_builder(builder, m.type, null);
                append(builder, ") bits;\n}");
            }

            append(builder, "\n\n");
            print_to_builder(builder, "%_set_% :: (s: *%, value: ", s.output_name, m.output_name, s.output_name);
            print_type_to_builder(builder, m.type, null);
            append(builder, ") {\n    base := cast(*u8) s;\n    bits: u64;\n");
            print_to_builder(builder, "    for 0..% bits |= (cast(u64) base[%+it]) << (cast(u64) (8 * it));\n", nbytes - 1, first_byte);
            if is_bool {
                append(builder, "    new_value: u64 = ifx value then 1 else 0;\n");
            } else {
                append(builder, "    new_value := cast,trunc(u64) value;\n");
            }
            print_to_builder(builder, "    bits = (bits & ~(% << %)) | ((new_value & %) << %);\n", hex(mask), shift, hex(mask), shift);
            print_to_builder(builder, "    for 0..% base[%+it] = cast(u8) ((bits >> (cast(u64) (8 * it))) & 0xff);\n}", nbytes - 1, first_byte);
            printed = true;
        }
    }
    if printed append(builder, "\n");
}

// ----------------------------------------------------------------------------
// C++ vtables.

// The vtable layout of the struct a type names (null for other types), computed once per
// struct: the entries the class adds to the table of the base it extends.
find_or_create_extra_info :: (type: *CType, base_struct: *Struct) -> *Struct_Extra_Info, *Struct {
    stripped := strip_type(type, typedefs = true);
    if !stripped || !stripped.type_of_struct return null, null;
    s := stripped.type_of_struct;

    g := context.generator;
    known, cached := table_find(*g.extra_infos, s);
    if known return cached, s;
    info := New(Struct_Extra_Info);
    table_add(*g.extra_infos, s, info); // Before visiting the bases, so a cycle ends here.

    link_vtable_base(s, info, base_struct);
    for s.virtual_functions {
        if !is_inherited_vtable_entry(info, it) add_vtable_entry(info, it);
    }
    // The base's table pointer is `vtable`; a derived class's own pointer needs its own name.
    info.vtable_name = ifx info.vtable_parent then to_lower_copy(tprint("%_vtable", s.output_name)) else "vtable";
    return info, s;
}

// The class's table extends that of its base with a vtable: the base's own table if it adds
// entries, else the one the base itself extends. Two such bases cannot be expressed.
link_vtable_base :: (s: *Struct, info: *Struct_Extra_Info, base_struct: *Struct) {
    for parent: s.parents {
        parent_info, parent_struct := find_or_create_extra_info(parent.type, base_struct);
        if !parent_info continue;
        has_entries := parent_info.vtable.count > 0;
        if !has_entries && !parent_info.vtable_parent continue;
        if info.vtable_parent {
            log("Bindings_Generator: % has several base classes with virtual functions; only the first one's vtable is described.\n", s.name);
            return;
        }
        info.vtable_parent_declaration = parent;
        if has_entries {
            info.vtable_parent = parent_struct;
            info.vtable_parent_info = parent_info;
        } else {
            info.vtable_parent = parent_info.vtable_parent;
            info.vtable_parent_info = parent_info.vtable_parent_info;
        }
    }
}

// An override has a slot already, in the table of some base.
is_inherited_vtable_entry :: (info: *Struct_Extra_Info, func: *Function) -> bool {
    ancestor := info.vtable_parent_info;
    while ancestor {
        for ancestor.vtable {
            if functions_are_equivalent(it, func, ignore_first_argument = true) return true;
        }
        ancestor = ancestor.vtable_parent_info;
    }
    return false;
}

// Overloads share neighbouring slots: a later overload goes in front of its first namesake.
add_vtable_entry :: (info: *Struct_Extra_Info, func: *Function) {
    slot := info.vtable.count;
    for info.vtable {
        if it.name != func.name continue;
        slot = it_index;
        break;
    }
    array_insert_at(*info.vtable, func, slot);
}

// What follows a C++ class with virtual functions: its `X_VTable` struct, then optionally a
// procedure per entry that calls through the vtable (`X_area(this)`), and `vtable(obj)`.
print_struct_vtable :: (builder: *String_Builder, s: *Struct, info: *Struct_Extra_Info) {
    // Blank lines are reproduced across the table and the call helpers alike.
    previous: Location;
    print_vtable_table(builder, s, info, *previous);

    options := *context.generator_options;
    if options.generate_c_style_api_for_vtable {
        for info.vtable print_vtable_call(builder, s, info, it, *previous);
        append(builder, "\n");
    }
    if options.generate_vtable_helpers {
        append(builder, "\n");
        append_indentation(builder);
        print_to_builder(builder, "vtable :: (obj: *%) -> *%_VTable { return obj.%; }", s.output_name, s.output_name, info.vtable_name);
    }
    append(builder, "\n");
}

// `X_VTable :: struct`: the table of the base with a vtable (`using`), then the entries this
// class adds, in slot order. An entry that is left out keeps its slot as a `*void`.
print_vtable_table :: (builder: *String_Builder, s: *Struct, info: *Struct_Extra_Info, previous: *Location) {
    // An entry named like one of a base table is renamed: overloads cannot share the name of
    // a member.
    inherited: [..] *Declaration;
    inherited.allocator = temp;
    ancestor := info.vtable_parent_info;
    while ancestor {
        for ancestor.vtable array_add(*inherited, it);
        ancestor = ancestor.vtable_parent_info;
    }

    print_to_builder(builder, "%_VTable :: struct #type_info_none {", s.output_name);
    context.generator.tab_depth += 1;
    if info.vtable_parent {
        base_name := info.vtable_parent.output_name;
        append(builder, "\n");
        append_indentation(builder);
        print_to_builder(builder, "using %: %_VTable;", to_lower_copy(base_name), base_name);
    }
    for entry: info.vtable {
        append(builder, "\n");
        maybe_add_spacing(builder, previous, entry.location, entry.decl_flags, .VTABLE);
        append_indentation(builder);
        avoid_name_clash(*inherited, entry, allow_overloads = false);
        if entry.decl_flags & .OMIT_FROM_OUTPUT print_to_builder(builder, "%: *void;", entry.output_name);
        else print_function(builder, entry, s.parent, in_vtable = true);
    }
    context.generator.tab_depth -= 1;
    append(builder, "\n");
    append_indentation(builder);
    append(builder, "}");
}

// `X_f :: inline (this: *X, a: s32) -> R { return this.vtable.f(this, a); }`. Needs the object
// argument; variadic entries get none (the arguments could not be passed on).
print_vtable_call :: (builder: *String_Builder, s: *Struct, info: *Struct_Extra_Info, entry: *Function, previous: *Location) {
    if entry.decl_flags & .OMIT_FROM_OUTPUT return;
    type := entry.type.type_of_function;
    if type.flags & .VARIADIC {
        log("Bindings_Generator: %.% is variadic, so it gets no procedure calling it through the vtable.\n", s.name, entry.name);
        return;
    }
    params := context.generator_options.get_func_args_for_printing(entry, type, .FOREIGN_FUNC_DECLARATION);
    if !params.count return;

    declared: [..] string;
    passed: [..] string;
    declared.allocator = temp;
    passed.allocator = temp;
    for params {
        // Arguments are passed on exactly as the entry takes them: a `const T&` stays a pointer.
        param_flags := Print_Decl_Flags.NO_SEMICOLON | .NO_INDENT | .IN_FUNCTION_ARGS;
        if it.decl_flags & .POINTER_TO_VALUE param_flags |= .NO_ARGUMENT_DEFAULTS | .KEEP_POINTER_TO_VALUE;
        array_add(*declared, declaration_text(it, s.parent, param_flags));
        array_add(*passed, it.output_name);
    }
    call := tprint("%.%.%(%);", params[0].output_name, info.vtable_name, entry.output_name, join(..passed, separator = ", "));

    append(builder, "\n");
    maybe_add_spacing(builder, previous, entry.location, entry.decl_flags, .VTABLE);
    append_indentation(builder);
    print_to_builder(builder, "%_% :: inline (%) ", s.output_name, entry.output_name, join(..declared, separator = ", "));
    if type.return_type == context.generator.type_def_void {
        print_to_builder(builder, "{ % }", call);
    } else {
        append(builder, "-> ");
        print_type_to_builder(builder, type.return_type, s.parent, .IN_FUNCTION_RETURN);
        print_to_builder(builder, " { return % }", call);
    }
}
