// Traversal of the maintained Compiler node projection, without synthetic AST nodes.
maybe_array_add :: inline (array: *[..] $T, item: T) #no_abc {
    if item Basic.array_add(array, item);
}
// The direct syntactic children of `node`, in source order. Resolved links (declarations an
// identifier names, parent blocks, owning statements) are not followed, so walks terminate.
get_subexpressions :: (node: *Code_Node, pointers: *[..] *Code_Node) {
    if !node return;
    add :: (child: *Code_Node) #expand { maybe_array_add(pointers, child); }
    if node.kind == {
      case .BLOCK;
        block := cast(*Code_Block) node;
        for block.statements add(it);
      case .LITERAL;
        literal := cast(*Code_Literal) node;
        if literal.value_type == .STRUCT && literal.struct_literal_info {
            info := literal.struct_literal_info;
            add(info.type_expression);
            for info.arguments add(it);
        } else if literal.value_type == .ARRAY && literal.array_literal_info {
            info := literal.array_literal_info;
            add(info.element_type);
            for info.array_members add(it);
        }
      case .UNARY_OPERATOR;
        add((cast(*Code_Unary_Operator) node).subexpression);
      case .BINARY_OPERATOR;
        binary := cast(*Code_Binary_Operator) node;
        add(binary.left);
        add(binary.right);
      case .PROCEDURE_BODY;
        add((cast(*Code_Procedure_Body) node).block);
      case .PROCEDURE_CALL;
        call := cast(*Code_Procedure_Call) node;
        add(call.procedure_expression);
        for call.arguments_unsorted add(it.expression);
      case .WHILE;
        loop := cast(*Code_While) node;
        add(loop.condition);
        add(loop.block);
      case .IF;
        branch := cast(*Code_If) node;
        add(branch.condition);
        add(branch.then_block);
        add(branch.else_block);
      case .CASE;
        arm := cast(*Code_Case) node;
        add(arm.condition);
        add(arm.then_block);
      case .RETURN;
        ret := cast(*Code_Return) node;
        for ret.arguments_unsorted add(it.expression);
      case .FOR;
        loop := cast(*Code_For) node;
        add(loop.iteration_expression);
        add(loop.iteration_expression_right);
        add(loop.block);
      case .TYPE_INSTANTIATION;
        inst := cast(*Code_Type_Instantiation) node;
        add(inst.type_valued_expression);
        add(inst.pointer_to);
        add(inst.array_element_type);
        add(inst.array_dimension);
      case .ENUM;
        e := cast(*Code_Enum) node;
        add(e.internal_type_inst);
        add(e.block);
      case .PROCEDURE_HEADER;
        header := cast(*Code_Procedure_Header) node;
        for header.arguments add(it);
        for header.returns add(it);
      case .STRUCT;
        add((cast(*Code_Struct) node).block);
      case .COMMA_SEPARATED_ARGUMENTS;
        list := cast(*Code_Comma_Separated_Arguments) node;
        for list.arguments add(it.node);
      case .EXTRACT;
        add((cast(*Code_Extract) node).from);
      case .MAKE_VARARGS;
        for (cast(*Code_Make_Varargs) node).expressions add(it);
      case .DECLARATION;
        decl := cast(*Code_Declaration) node;
        add(decl.type_inst);
        add(decl.expression);
      case .COMPOUND_DECLARATION;
        add((cast(*Code_Compound_Declaration) node).comma_separated_assignment);
      case .CAST;
        c := cast(*Code_Cast) node;
        add(c.target_type);
        add(c.expression);
      case .DIRECTIVE_RUN;
        add((cast(*Code_Directive_Run) node).procedure);
      case .DIRECTIVE_CODE;
        add((cast(*Code_Directive_Code) node).expression);
      case .DIRECTIVE_BYTES;
        add((cast(*Code_Directive_Bytes) node).expression);
      case .DIRECTIVE_BAKE;
        add((cast(*Code_Directive_Bake) node).procedure_call);
      case .PUSH_CONTEXT;
        push := cast(*Code_Push_Context) node;
        add(push.to_push);
        add(push.block);
      case .EXPRESSION_QUERY;
        add((cast(*Code_Expression_Query) node).expression_to_query);
      case .TYPE_QUERY;
        add((cast(*Code_Type_Query) node).type_to_query);
      case .DIRECTIVE_LOCATION;
        add((cast(*Code_Directive_Location) node).expression);
      case .DIRECTIVE_ADD_CONTEXT;
        add((cast(*Code_Directive_Add_Context) node).expression);
      case .DIRECTIVE_INSERT;
        insert := cast(*Code_Directive_Insert) node;
        add(insert.expression);
        add(insert.expansion);
      case .USING;
        add((cast(*Code_Using) node).expression);
      case .DEFER;
        add((cast(*Code_Defer) node).block);
      case .DIRECTIVE_MODIFY;
        add((cast(*Code_Directive_Modify) node).block);
    }
}
get_recursive_nodes_breadth_first :: (node: *Code_Node, pointers: *[..] *Code_Node) {
    if !node return;
    cursor := pointers.count;
    Basic.array_add(pointers, node);
    while cursor < pointers.count {
        current := pointers.*[cursor];
        get_subexpressions(current, pointers);
        cursor += 1;
    }
}
get_recursive_nodes_depth_first :: (node: *Code_Node, pointers: *[..] *Code_Node) {
    if !node return;
    Basic.array_add(pointers, node);
    children: [..] *Code_Node;
    defer Basic.array_free(children);
    get_subexpressions(node, *children);
    for children get_recursive_nodes_depth_first(it, pointers);
}
Dumb_Value :: struct {
    node: *Code_Node;
    preorder := false;
}
get_values :: (node: *Code_Node, values: *[..] Dumb_Value) {
    if !node return;
    Basic.array_add(values, Dumb_Value.{node, true});
    children: [..] *Code_Node;
    defer Basic.array_free(children);
    get_subexpressions(node, *children);
    for children get_values(it, values);
    Basic.array_add(values, Dumb_Value.{node, false});
}
visit_pre_and_postorder :: (node: *Code_Node, code: Code) #expand {
    order: [..] Dumb_Value;
    defer Basic.array_free(*order);
    get_values(node, *order);
    for value: order {
        `it := value.node;
        `preorder := value.preorder;
        #insert code;
    }
}
#scope_module
#import "Compiler";
Basic :: #import "Basic";
