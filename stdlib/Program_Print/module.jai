// Prints Code_Node syntax trees (as returned by compiler_get_nodes) back to Jai
// source text. Independently authored; see docs/stdlib/program-print.md.
//
// Nodes that jaic's exporter does not produce print as "<unsupported node>".

#import "Basic";
#import "Compiler";

// When false, procedure literals print their header followed by "{ ... }".
print_procedure_bodies := true;

#scope_export

// Append the contents of a literal; the caller supplies surrounding quotes.
print_string_literal :: (builder: *String_Builder, s: string) {
    for byte: s {
        if byte == 0 append(builder, "\\0");
        else if byte == 0x1b append(builder, "\\e");
        else if byte == 0x0a append(builder, "\\n");
        else if byte == 0x0d append(builder, "\\r");
        else if byte == 0x09 append(builder, "\\t");
        else if byte == 0x1f append(builder, "\\%");
        else if byte == #char "\"" append(builder, "\\\"");
        else if byte == #char "\\" append(builder, "\\\\");
        else append(builder, *byte, 1);
    }
}

// Prints `expression` as source. Returns false when the node (or something below it)
// has no printable form. `skip_parens` omits the parentheses a lower-precedence
// operand would otherwise get.
print_expression :: (builder: *String_Builder, expression: *Code_Node, skip_parens := false) -> printed: bool {
    if expression == null {
        return false;
    }
    return pp_expression(builder, expression, 0, 0);
}

// Prints a declaration such as `x : int = 3` or `f :: (a: int) -> int { ... }`.
print_declaration :: (builder: *String_Builder, decl: *Code_Declaration, print_using := true, compound: *Code_Compound_Declaration = null, print_type := true) -> bool {
    if decl == null return false;
    if print_using && (decl.flags & .IS_MARKED_AS_AS) append(builder, "#as ");
    return pp_declaration(builder, decl, 0, print_type);
}

#scope_module

// ---------------------------------------------------------------------------
// Operators
// ---------------------------------------------------------------------------

// Binding strength of a binary operator; 0 means "not a plain binary operator".
// Jai groups the bitwise and shift operators on one level above `*`, and puts `%`
// between `*`/`/` and `+`/`-`. A prefix cast sits at PP_CAST_LEVEL, just below the
// bitwise level, because its value takes a following bitwise chain.
pp_precedence :: (op: s32) -> s32 {
    if op == {
        case #char "&"; #through;
        case #char "^"; #through;
        case #char "|"; #through;
        case xx Operator_Type.SHIFT_LEFT; #through;
        case xx Operator_Type.SHIFT_RIGHT; #through;
        case xx Operator_Type.ROTATE_LEFT; #through;
        case xx Operator_Type.ROTATE_RIGHT; return PP_CAST_LEVEL + 1;
        case #char "*"; #through;
        case #char "/"; return 7;
        case #char "%"; return 6;
        case #char "+"; #through;
        case #char "-"; return 5;
        case #char "<"; #through;
        case #char ">"; #through;
        case xx Operator_Type.LESS_OR_EQUAL; #through;
        case xx Operator_Type.GREATER_OR_EQUAL; return 4;
        case xx Operator_Type.IS_EQUAL; #through;
        case xx Operator_Type.IS_NOT_EQUAL; return 3;
        case xx Operator_Type.LOGICAL_AND; return 2;
        case xx Operator_Type.LOGICAL_OR; return 1;
    }
    return 0;
}

PP_CAST_LEVEL :: 8;

pp_operator_text :: (op: s32) -> string {
    text := operator_to_string(cast(Operator_Type) op);
    if text.count return text;
    if op > 0 && op < 128 {
        s := alloc_string(1);
        s.data[0] = cast(u8) op;
        return s;
    }
    return "?";
}

// Precedence of the node when printed as an operand (binary operators only).
pp_node_precedence :: (node: *Code_Node) -> s32 {
    if node == null return 100;
    if node.kind == .BINARY_OPERATOR {
        bin := cast(*Code_Binary_Operator) node;
        op := cast(s32) bin.operator_type;
        if op == #char "." || op == xx Operator_Type.ARRAY_SUBSCRIPT return 100;
        p := pp_precedence(op);
        if p return p;
        return 0; // assignments
    }
    if node.kind == .IF {
        if (cast(*Code_If) node).if_flags & .IS_IFX return 0;
    }
    if node.kind == .CAST {
        return PP_CAST_LEVEL;
    }
    return 100;
}

pp_indent :: (builder: *String_Builder, depth: s64) {
    for 0..depth - 1 append(builder, "    ");
}

pp_unsupported :: (builder: *String_Builder) -> bool {
    append(builder, "<unsupported node>");
    return false;
}

// ---------------------------------------------------------------------------
// Literals and types
// ---------------------------------------------------------------------------

pp_literal :: (builder: *String_Builder, lit: *Code_Literal, depth: s64) -> bool {
    ok := true;
    if lit.value_type == {
        case .NUMBER;
            if lit.value_flags & .FLOAT {
                print_to_builder(builder, "%", lit._float64);
            } else if lit.value_flags & .HEX {
                print_to_builder(builder, "0x%", FormatInt.{ value = lit._u64, base = 16 });
            } else if lit.value_flags & .BINARY {
                print_to_builder(builder, "0b%", FormatInt.{ value = lit._u64, base = 2 });
            } else {
                print_to_builder(builder, "%", lit._s64);
            }
        case .STRING;
            append(builder, "\"");
            print_string_literal(builder, lit._string);
            append(builder, "\"");
        case .BOOLEAN;
            if lit._s64 append(builder, "true");
            else append(builder, "false");
        case .POINTER;
            append(builder, "null");
        case .STRUCT;
            info := lit.struct_literal_info;
            if info.type_expression ok = pp_type(builder, info.type_expression, depth);
            append(builder, ".{");
            for arg, i: info.arguments {
                if i > 0 append(builder, ", ");
                if !pp_expression(builder, arg, depth, 0) ok = false;
            }
            append(builder, "}");
        case .ARRAY;
            info := lit.array_literal_info;
            if info.element_type ok = pp_type(builder, info.element_type, depth);
            append(builder, ".[");
            for member, i: info.array_members {
                if i > 0 append(builder, ", ");
                if !pp_expression(builder, member, depth, 0) ok = false;
            }
            append(builder, "]");
        case .TYPE_INFO;
            append(builder, "<type>");
            ok = false;
        case;
            append(builder, "---");
    }
    return ok;
}

pp_type :: (builder: *String_Builder, inst: *Code_Type_Instantiation, depth: s64) -> bool {
    if inst == null return false;
    if inst.type_valued_expression {
        if inst.type_valued_expression.kind != .PLACEHOLDER {
            return pp_expression(builder, inst.type_valued_expression, depth, 0);
        }
    }
    if inst.result {
        print_type_to_builder(builder, inst.result);
        return true;
    }
    append(builder, "<type>");
    return false;
}

// ---------------------------------------------------------------------------
// Declarations, arguments, blocks
// ---------------------------------------------------------------------------

pp_arguments :: (builder: *String_Builder, args: [] Code_Argument, depth: s64) -> bool {
    ok := true;
    for arg, i: args {
        if i > 0 append(builder, ", ");
        if arg.name {
            append(builder, arg.name.name);
            append(builder, " = ");
        }
        if !pp_expression(builder, arg.expression, depth, 0) ok = false;
    }
    return ok;
}

// Names of a compound declaration; `x=` marks one that is assigned rather than declared
// when the list mixes both.
pp_compound_names :: (builder: *String_Builder, names: *Code_Comma_Separated_Arguments, depth: s64) -> bool {
    if !names return false;
    declares := false;
    for names.arguments if it.modifier != .ASSIGN declares = true;
    for names.arguments {
        if it_index append(builder, ", ");
        if !it.node return false;
        if it.node.kind == .DECLARATION append(builder, (cast(*Code_Declaration) it.node).name);
        else if !pp_expression(builder, it.node, depth, 0) return false;
        if it.modifier == .ASSIGN && declares append(builder, "=");
    }
    return true;
}

pp_declaration :: (builder: *String_Builder, decl: *Code_Declaration, depth: s64, print_type := true, parameter := false) -> bool {
    ok := true;
    if decl.flags & .HAS_SCOPE_MODIFIER append(builder, "`");
    append(builder, decl.name); // Empty for the properties of a compound declaration.
    constant := (decl.flags & .IS_CONSTANT) != 0;
    has_type := print_type && decl.type_inst != null;
    if has_type {
        if parameter append(builder, ": ");
        else append(builder, " : ");
        ok = pp_type(builder, decl.type_inst, depth);
        if decl.expression {
            if constant append(builder, " : ");
            else append(builder, " = ");
        }
    } else {
        if constant append(builder, " :: ");
        else if decl.expression append(builder, " := ");
        else append(builder, " : ");
    }
    if decl.expression {
        if !pp_expression(builder, decl.expression, depth, 0) ok = false;
    }
    return ok;
}

// A braced block: statements on their own lines, indented one level deeper.
pp_block :: (builder: *String_Builder, block: *Code_Block, depth: s64) -> bool {
    if block == null {
        append(builder, "{}");
        return true;
    }
    if block.statements.count == 0 {
        append(builder, "{}");
        return true;
    }
    ok := true;
    append(builder, "{\n");
    for stmt: block.statements {
        if !pp_statement(builder, stmt, depth + 1) ok = false;
    }
    pp_indent(builder, depth);
    append(builder, "}");
    return ok;
}

// A block following `if`, `while`, ...: the block itself is always braced.
pp_body :: (builder: *String_Builder, block: *Code_Block, depth: s64) -> bool {
    return pp_block(builder, block, depth);
}

pp_ends_with_brace :: (node: *Code_Node) -> bool {
    if node == null return false;
    if node.kind == {
        case .BLOCK; #through;
        case .WHILE; #through;
        case .FOR; #through;
        case .PUSH_CONTEXT; #through;
        case .PROCEDURE_HEADER; #through;
        case .STRUCT; #through;
        case .ENUM;
            if node.kind == .PROCEDURE_HEADER return (cast(*Code_Procedure_Header) node).body_or_null != null && print_procedure_bodies;
            return true;
        case .IF;
            return (cast(*Code_If) node).if_flags & .IS_IFX == 0;
        case .DECLARATION;
            decl := cast(*Code_Declaration) node;
            if decl.expression == null return false;
            return pp_ends_with_brace(decl.expression);
        case .COMPOUND_DECLARATION;
            return pp_ends_with_brace((cast(*Code_Compound_Declaration) node).declaration_properties);
        case .DEFER;
            return false;
    }
    return false;
}

// One statement on its own line(s), with `;` where Jai needs it.
pp_statement :: (builder: *String_Builder, node: *Code_Node, depth: s64) -> bool {
    pp_indent(builder, depth);
    ok := pp_expression(builder, node, depth, 0);
    if !pp_ends_with_brace(node) append(builder, ";");
    append(builder, "\n");
    return ok;
}

pp_case :: (builder: *String_Builder, node: *Code_Node, depth: s64) -> bool {
    if node.kind != .CASE return pp_statement(builder, node, depth);
    c := cast(*Code_Case) node;
    ok := true;
    pp_indent(builder, depth);
    if c.condition {
        append(builder, "case ");
        ok = pp_expression(builder, c.condition, depth, 0);
        append(builder, ";\n");
    } else {
        append(builder, "case;\n");
    }
    if c.then_block {
        for stmt: c.then_block.statements {
            if !pp_statement(builder, stmt, depth + 1) ok = false;
        }
    }
    if c.marked_as_fallthrough {
        pp_indent(builder, depth + 1);
        append(builder, "#through;\n");
    }
    return ok;
}

pp_if :: (builder: *String_Builder, node: *Code_If, depth: s64) -> bool {
    ok := true;
    if node.if_flags & .IS_IFX {
        append(builder, "ifx ");
        if !pp_expression(builder, node.condition, depth, 0) ok = false;
        append(builder, " then ");
        if node.then_block && node.then_block.statements.count {
            if !pp_expression(builder, node.then_block.statements[0], depth, 0) ok = false;
        }
        if node.else_block && node.else_block.statements.count {
            append(builder, " else ");
            if !pp_expression(builder, node.else_block.statements[0], depth, 0) ok = false;
        }
        return ok;
    }
    if node.if_flags & .IS_SWITCH_STATEMENT {
        if node.if_flags & .IS_STATIC append(builder, "#if ");
        else append(builder, "if ");
        if !pp_expression(builder, node.condition, depth, 0) ok = false;
        append(builder, " == {\n");
        if node.then_block {
            for stmt: node.then_block.statements {
                if !pp_case(builder, stmt, depth + 1) ok = false;
            }
        }
        pp_indent(builder, depth);
        append(builder, "}");
        return ok;
    }
    if node.if_flags & .IS_STATIC append(builder, "#if ");
    else append(builder, "if ");
    if !pp_expression(builder, node.condition, depth, 0) ok = false;
    append(builder, " ");
    if !pp_body(builder, node.then_block, depth) ok = false;
    if node.else_block {
        append(builder, " else ");
        // `else if` chains stay flat.
        else_block := node.else_block;
        if else_block.statements.count == 1 && else_block.statements[0].kind == .IF && ((cast(*Code_If) else_block.statements[0]).if_flags & .IS_IFX) == 0 {
            if !pp_if(builder, cast(*Code_If) else_block.statements[0], depth) ok = false;
        } else {
            if !pp_body(builder, else_block, depth) ok = false;
        }
    }
    return ok;
}

pp_for :: (builder: *String_Builder, node: *Code_For, depth: s64) -> bool {
    ok := true;
    append(builder, "for ");
    flags := cast(u32) node.for_flags;
    if flags & 0x2 append(builder, "<");
    if flags & 0x1 append(builder, "*");
    if node.ident_it {
        append(builder, node.ident_it.name);
        if node.ident_it_index {
            append(builder, ", ");
            append(builder, node.ident_it_index.name);
        }
        append(builder, ": ");
    }
    if !pp_expression(builder, node.iteration_expression, depth, 0) ok = false;
    if node.iteration_expression_right {
        append(builder, "..");
        if !pp_expression(builder, node.iteration_expression_right, depth, 0) ok = false;
    }
    append(builder, " ");
    if !pp_body(builder, node.block, depth) ok = false;
    return ok;
}

pp_procedure :: (builder: *String_Builder, header: *Code_Procedure_Header, depth: s64) -> bool {
    ok := true;
    append(builder, "(");
    for arg, i: header.arguments {
        if i > 0 append(builder, ", ");
        if !pp_declaration(builder, arg, depth, true, true) ok = false;
    }
    append(builder, ")");
    if header.returns.count {
        append(builder, " -> ");
        for ret, i: header.returns {
            if i > 0 append(builder, ", ");
            if ret.name.count {
                if !pp_declaration(builder, ret, depth) ok = false;
            } else if ret.type_inst {
                if !pp_type(builder, ret.type_inst, depth) ok = false;
            }
        }
    }
    flags := header.procedure_flags;
    if flags & .C_CALL append(builder, " #c_call");
    if flags & .MACRO append(builder, " #expand");
    if flags & .ELSEWHERE {
        append(builder, " #foreign");
        return ok;
    }
    if header.body_or_null {
        append(builder, " ");
        if print_procedure_bodies {
            if !pp_block(builder, header.body_or_null.block, depth) ok = false;
        } else {
            append(builder, "{ ... }");
        }
    }
    return ok;
}

pp_struct :: (builder: *String_Builder, node: *Code_Struct, depth: s64) -> bool {
    ok := true;
    if node.textual_flags & 0x2 append(builder, "union");
    else append(builder, "struct");
    append(builder, " ");
    if node.block == null || node.block.statements.count == 0 {
        append(builder, "{}");
        return true;
    }
    return pp_block(builder, node.block, depth);
}

// ---------------------------------------------------------------------------
// Expressions
// ---------------------------------------------------------------------------

// `parent_prec` is the precedence of the enclosing binary operator, and `side` is
// 1 for a right operand, so that left-associative chains need no parentheses.
pp_expression :: (builder: *String_Builder, node: *Code_Node, depth: s64, parent_prec: s32, side := 0) -> bool {
    if node == null {
        append(builder, "<null>");
        return false;
    }
    ok := true;
    my_prec := pp_node_precedence(node);
    parens := parent_prec > 0 && node.kind == .BINARY_OPERATOR && my_prec < parent_prec + side && my_prec != 0;
    if parent_prec > 0 && my_prec == 0 parens = true;
    // A prefix cast would swallow a bitwise operator after it, or a postfix one.
    if node.kind == .CAST && parent_prec > PP_CAST_LEVEL parens = true;
    if node.node_flags & .IS_PARENTHESIZED parens = true;
    if parens append(builder, "(");

    if node.kind == {
        case .LITERAL;
            ok = pp_literal(builder, cast(*Code_Literal) node, depth);
        case .IDENT;
            ident := cast(*Code_Ident) node;
            if ident.flags & .HAS_SCOPE_MODIFIER append(builder, "`");
            append(builder, ident.name);
        case .CONTEXT;
            append(builder, "context");
        case .PLACEHOLDER;
            ok = pp_unsupported(builder);
        case .UNARY_OPERATOR;
            un := cast(*Code_Unary_Operator) node;
            op := cast(s32) un.operator_type;
            if op == xx Operator_Type.POSTFIX_DEREFERENCE {
                ok = pp_expression(builder, un.subexpression, depth, 100);
                append(builder, ".*");
            } else {
                if op == xx Operator_Type.POINTER_DEREFERENCE append(builder, "<<");
                else append(builder, pp_operator_text(op));
                ok = pp_expression(builder, un.subexpression, depth, 100);
            }
        case .BINARY_OPERATOR;
            ok = pp_binary(builder, cast(*Code_Binary_Operator) node, depth);
        case .PROCEDURE_CALL;
            call := cast(*Code_Procedure_Call) node;
            ok = pp_expression(builder, call.procedure_expression, depth, 100);
            append(builder, "(");
            if !pp_arguments(builder, call.arguments_unsorted, depth) ok = false;
            append(builder, ")");
        case .CAST;
            cast_node := cast(*Code_Cast) node;
            if cast_node.target_type == null {
                append(builder, "xx");
                if cast_node.cast_flags & .TRUNCATE append(builder, ",trunc");
                if cast_node.cast_flags & .NO_BOUNDS_CHECK append(builder, ",no_check");
                append(builder, " ");
            } else {
                append(builder, "cast");
                if cast_node.cast_flags & .TRUNCATE append(builder, ",trunc");
                if cast_node.cast_flags & .NO_BOUNDS_CHECK append(builder, ",no_check");
                if cast_node.cast_flags & .FORCE append(builder, ",force");
                append(builder, "(");
                ok = pp_type(builder, cast_node.target_type, depth);
                append(builder, ") ");
            }
            if !pp_expression(builder, cast_node.expression, depth, 100) ok = false;
        case .TYPE_INSTANTIATION;
            ok = pp_type(builder, cast(*Code_Type_Instantiation) node, depth);
        case .DECLARATION;
            ok = pp_declaration(builder, cast(*Code_Declaration) node, depth);
        case .COMPOUND_DECLARATION;
            // `a, b := f()`: the names, then the nameless declaration with the type and values.
            compound := cast(*Code_Compound_Declaration) node;
            ok = pp_compound_names(builder, compound.comma_separated_assignment, depth);
            if compound.declaration_properties && !pp_declaration(builder, compound.declaration_properties, depth) ok = false;
        case .COMMA_SEPARATED_ARGUMENTS;
            list := cast(*Code_Comma_Separated_Arguments) node;
            for list.arguments {
                if it_index append(builder, ", ");
                if !pp_expression(builder, it.node, depth, 0) ok = false;
            }
        case .BLOCK;
            ok = pp_block(builder, cast(*Code_Block) node, depth);
        case .IF;
            ok = pp_if(builder, cast(*Code_If) node, depth);
        case .WHILE;
            w := cast(*Code_While) node;
            append(builder, "while ");
            ok = pp_expression(builder, w.condition, depth, 0);
            append(builder, " ");
            if !pp_body(builder, w.block, depth) ok = false;
        case .FOR;
            ok = pp_for(builder, cast(*Code_For) node, depth);
        case .LOOP_CONTROL;
            lc := cast(*Code_Loop_Control) node;
            if lc.control_type == .BREAK append(builder, "break");
            else if lc.control_type == .CONTINUE append(builder, "continue");
            else append(builder, "remove");
            if lc.target_ident {
                append(builder, " ");
                append(builder, lc.target_ident.name);
            }
        case .RETURN;
            ret := cast(*Code_Return) node;
            if ret.return_flags & .IS_BACKTICKED append(builder, "`return");
            else append(builder, "return");
            if ret.arguments_unsorted.count {
                append(builder, " ");
                ok = pp_arguments(builder, ret.arguments_unsorted, depth);
            }
        case .DEFER;
            d := cast(*Code_Defer) node;
            if d.is_backticked append(builder, "`defer ");
            else append(builder, "defer ");
            if d.block && d.block.statements.count == 1 {
                ok = pp_expression(builder, d.block.statements[0], depth, 0);
            } else {
                ok = pp_block(builder, d.block, depth);
            }
        case .USING;
            append(builder, "using ");
            ok = pp_expression(builder, (cast(*Code_Using) node).expression, depth, 0);
        case .PUSH_CONTEXT;
            pc := cast(*Code_Push_Context) node;
            append(builder, "push_context ");
            ok = pp_expression(builder, pc.to_push, depth, 0);
            append(builder, " ");
            if !pp_body(builder, pc.block, depth) ok = false;
        case .PROCEDURE_HEADER;
            ok = pp_procedure(builder, cast(*Code_Procedure_Header) node, depth);
        case .STRUCT;
            ok = pp_struct(builder, cast(*Code_Struct) node, depth);
        case .ENUM;
            e := cast(*Code_Enum) node;
            if e.is_flags append(builder, "enum_flags {}");
            else append(builder, "enum {}");
            ok = false;
        case .DIRECTIVE_CODE;
            append(builder, "#code ");
            ok = pp_expression(builder, (cast(*Code_Directive_Code) node).expression, depth, 0);
        case .DIRECTIVE_INSERT;
            append(builder, "#insert ");
            ok = pp_expression(builder, (cast(*Code_Directive_Insert) node).expression, depth, 0);
        case .DIRECTIVE_RUN;
            run := cast(*Code_Directive_Run) node;
            if run.flags & .ASSERTION {
                append(builder, "#assert(");
                if run.expression && !pp_expression(builder, run.expression, depth, 0) ok = false;
                if run.message {
                    append(builder, ", ");
                    if !pp_expression(builder, run.message, depth, 0) ok = false;
                }
                append(builder, ")");
            } else {
                append(builder, "#run");
                if run.expression {
                    append(builder, " ");
                    if !pp_expression(builder, run.expression, depth, 0) ok = false;
                }
            }
        case .DIRECTIVE_EXISTS;
            append(builder, "#exists(");
            if !pp_expression(builder, (cast(*Code_Directive_Exists) node).query_expression, depth, 0) ok = false;
            append(builder, ")");
        case .DIRECTIVE_LOCATION;
            loc := cast(*Code_Directive_Location) node;
            if loc.is_caller_location {
                append(builder, "#caller_location");
            } else {
                append(builder, "#location");
                if loc.expression {
                    append(builder, "(");
                    ok = pp_expression(builder, loc.expression, depth, 0);
                    append(builder, ")");
                }
            }
        case .DIRECTIVE_IMPORT;
            imp := cast(*Code_Directive_Import) node;
            print_to_builder(builder, "#import \"%\"", imp.name);
        case;
            ok = pp_unsupported(builder);
    }

    if parens append(builder, ")");
    return ok;
}

pp_binary :: (builder: *String_Builder, bin: *Code_Binary_Operator, depth: s64) -> bool {
    ok := true;
    op := cast(s32) bin.operator_type;
    if op == #char "." {
        if bin.left {
            if !pp_expression(builder, bin.left, depth, 100) ok = false;
        }
        append(builder, ".");
        if !pp_expression(builder, bin.right, depth, 100) ok = false;
        return ok;
    }
    if op == xx Operator_Type.ARRAY_SUBSCRIPT {
        if !pp_expression(builder, bin.left, depth, 100) ok = false;
        append(builder, "[");
        if !pp_expression(builder, bin.right, depth, 0) ok = false;
        append(builder, "]");
        return ok;
    }
    prec := pp_precedence(op);
    if prec {
        if !pp_expression(builder, bin.left, depth, prec, 0) ok = false;
        append(builder, " ");
        append(builder, pp_operator_text(op));
        append(builder, " ");
        if !pp_expression(builder, bin.right, depth, prec, 1) ok = false;
        return ok;
    }
    // Assignment forms.
    if !pp_expression(builder, bin.left, depth, 0) ok = false;
    append(builder, " ");
    append(builder, pp_operator_text(op));
    append(builder, " ");
    if !pp_expression(builder, bin.right, depth, 0) ok = false;
    return ok;
}
