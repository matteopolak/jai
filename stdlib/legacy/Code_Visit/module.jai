// Original AST visitor. Traversal follows owned syntax edges only.
maybe_array_add :: inline (array: *[..] $T, item: T) #no_abc {
    if item array_add(array, item);
}
get_subexpressions :: (node: *Code_Node, pointers: *[..] *Code_Node) {
    if !node return;
    if node.kind == .UNARY_OPERATOR {
        value := cast(*Code_Unary_Operator) node;
        maybe_array_add(pointers, cast(*Code_Node) value.subexpression);
        return;
    }
    if node.kind == .BINARY_OPERATOR {
        value := cast(*Code_Binary_Operator) node;
        maybe_array_add(pointers, cast(*Code_Node) value.left);
        maybe_array_add(pointers, cast(*Code_Node) value.right);
        return;
    }
    if node.kind == .PROCEDURE_BODY {
        value := cast(*Code_Procedure_Body) node;
        maybe_array_add(pointers, cast(*Code_Node) value.block);
        return;
    }
    if node.kind == .WHILE {
        value := cast(*Code_While) node;
        maybe_array_add(pointers, cast(*Code_Node) value.condition);
        maybe_array_add(pointers, cast(*Code_Node) value.block);
        return;
    }
    if node.kind == .IF {
        value := cast(*Code_If) node;
        maybe_array_add(pointers, cast(*Code_Node) value.condition);
        maybe_array_add(pointers, cast(*Code_Node) value.then_block);
        maybe_array_add(pointers, cast(*Code_Node) value.else_block);
        return;
    }
    if node.kind == .LOOP_CONTROL {
        value := cast(*Code_Loop_Control) node;
        maybe_array_add(pointers, cast(*Code_Node) value.target_ident);
        return;
    }
    if node.kind == .CASE {
        value := cast(*Code_Case) node;
        maybe_array_add(pointers, cast(*Code_Node) value.condition);
        maybe_array_add(pointers, cast(*Code_Node) value.then_block);
        return;
    }
    if node.kind == .FOR {
        value := cast(*Code_For) node;
        maybe_array_add(pointers, cast(*Code_Node) value.iteration_expression);
        maybe_array_add(pointers, cast(*Code_Node) value.iteration_expression_right);
        maybe_array_add(pointers, cast(*Code_Node) value.block);
        maybe_array_add(pointers, cast(*Code_Node) value.want_pointer_expression);
        maybe_array_add(pointers, cast(*Code_Node) value.want_reverse_expression);
        maybe_array_add(pointers, cast(*Code_Node) value.want_replacement_for_expansion);
        return;
    }
    if node.kind == .TYPE_INSTANTIATION {
        value := cast(*Code_Type_Instantiation) node;
        maybe_array_add(pointers, cast(*Code_Node) value.pointer_to);
        maybe_array_add(pointers, cast(*Code_Node) value.type_directive_target);
        maybe_array_add(pointers, cast(*Code_Node) value.array_element_type);
        maybe_array_add(pointers, cast(*Code_Node) value.array_dimension);
        return;
    }
    if node.kind == .ENUM {
        value := cast(*Code_Enum) node;
        maybe_array_add(pointers, cast(*Code_Node) value.block);
        return;
    }
    if node.kind == .DIRECTIVE_BYTES {
        value := cast(*Code_Directive_Bytes) node;
        maybe_array_add(pointers, cast(*Code_Node) value.expression);
        return;
    }
    if node.kind == .DECLARATION {
        value := cast(*Code_Declaration) node;
        maybe_array_add(pointers, cast(*Code_Node) value.type_inst);
        maybe_array_add(pointers, cast(*Code_Node) value.expression);
        maybe_array_add(pointers, cast(*Code_Node) value.alignment_expression);
        for note: value.notes maybe_array_add(pointers, cast(*Code_Node) note);
        return;
    }
    if node.kind == .RESOLVED_OVERLOAD {
        value := cast(*Code_Resolved_Overload) node;
        maybe_array_add(pointers, cast(*Code_Node) value.result);
        maybe_array_add(pointers, cast(*Code_Node) value.source_expression);
        return;
    }
    if node.kind == .CAST {
        value := cast(*Code_Cast) node;
        maybe_array_add(pointers, cast(*Code_Node) value.target_type);
        maybe_array_add(pointers, cast(*Code_Node) value.expression);
        return;
    }
    if node.kind == .DIRECTIVE_IMPORT {
        value := cast(*Code_Directive_Import) node;
        maybe_array_add(pointers, cast(*Code_Node) value.module_parameters_call);
        maybe_array_add(pointers, cast(*Code_Node) value.program_parameters_call);
        return;
    }
    if node.kind == .DIRECTIVE_CODE {
        value := cast(*Code_Directive_Code) node;
        maybe_array_add(pointers, cast(*Code_Node) value.expression);
        return;
    }
    if node.kind == .DIRECTIVE_BAKE {
        value := cast(*Code_Directive_Bake) node;
        maybe_array_add(pointers, cast(*Code_Node) value.procedure_call);
        return;
    }
    if node.kind == .DIRECTIVE_MODIFY {
        value := cast(*Code_Directive_Modify) node;
        maybe_array_add(pointers, cast(*Code_Node) value.block);
        return;
    }
    if node.kind == .TYPE_QUERY {
        value := cast(*Code_Type_Query) node;
        maybe_array_add(pointers, cast(*Code_Node) value.type_to_query);
        return;
    }
    if node.kind == .EXPRESSION_QUERY {
        value := cast(*Code_Expression_Query) node;
        maybe_array_add(pointers, cast(*Code_Node) value.expression_to_query);
        return;
    }
    if node.kind == .PUSH_CONTEXT {
        value := cast(*Code_Push_Context) node;
        maybe_array_add(pointers, cast(*Code_Node) value.to_push);
        maybe_array_add(pointers, cast(*Code_Node) value.block);
        return;
    }
    if node.kind == .DIRECTIVE_LOCATION {
        value := cast(*Code_Directive_Location) node;
        maybe_array_add(pointers, cast(*Code_Node) value.expression);
        return;
    }
    if node.kind == .DIRECTIVE_MODULE_PARAMETERS {
        value := cast(*Code_Directive_Module_Parameters) node;
        maybe_array_add(pointers, cast(*Code_Node) value.module_parameters);
        maybe_array_add(pointers, cast(*Code_Node) value.program_parameters);
        return;
    }
    if node.kind == .COMPOUND_DECLARATION {
        value := cast(*Code_Compound_Declaration) node;
        maybe_array_add(pointers, cast(*Code_Node) value.comma_separated_assignment);
        maybe_array_add(pointers, cast(*Code_Node) value.declaration_properties);
        maybe_array_add(pointers, cast(*Code_Node) value.alignment_expression);
        for note: value.notes maybe_array_add(pointers, cast(*Code_Node) note);
        return;
    }
    if node.kind == .DEFER {
        value := cast(*Code_Defer) node;
        maybe_array_add(pointers, cast(*Code_Node) value.block);
        return;
    }
    if node.kind == .USING {
        value := cast(*Code_Using) node;
        maybe_array_add(pointers, cast(*Code_Node) value.expression);
        return;
    }
    if node.kind == .DIRECTIVE_INSERT {
        value := cast(*Code_Directive_Insert) node;
        maybe_array_add(pointers, cast(*Code_Node) value.expression);
        return;
    }
    if node.kind == .DIRECTIVE_PROCEDURE_NAME {
        value := cast(*Code_Directive_Procedure_Name) node;
        maybe_array_add(pointers, cast(*Code_Node) value.argument);
        return;
    }
    if node.kind == .DIRECTIVE_EXISTS {
        value := cast(*Code_Directive_Exists) node;
        maybe_array_add(pointers, cast(*Code_Node) value.query_expression);
        maybe_array_add(pointers, cast(*Code_Node) value.sync_expression);
        return;
    }
    if node.kind == .STRUCT {
        value := cast(*Code_Struct) node;
        maybe_array_add(pointers, cast(*Code_Node) value.block);
        for note: value.notes maybe_array_add(pointers, cast(*Code_Node) note);
        return;
    }
    if node.kind == .BLOCK {
        value := cast(*Code_Block) node;
        for child: value.statements maybe_array_add(pointers, cast(*Code_Node) child);
        return;
    }
    if node.kind == .PROCEDURE_HEADER {
        value := cast(*Code_Procedure_Header) node;
        for child: value.arguments maybe_array_add(pointers, cast(*Code_Node) child);
        for child: value.returns maybe_array_add(pointers, cast(*Code_Node) child);
        for child: value.notes maybe_array_add(pointers, cast(*Code_Node) child);
        return;
    }
    if node.kind == .MAKE_VARARGS {
        value := cast(*Code_Make_Varargs) node;
        for child: value.expressions maybe_array_add(pointers, cast(*Code_Node) child);
        return;
    }
    if node.kind == .PROCEDURE_CALL {
        value := cast(*Code_Procedure_Call) node;
        maybe_array_add(pointers, value.procedure_expression);
        for argument: value.arguments_unsorted maybe_array_add(pointers, argument.expression);
        maybe_array_add(pointers, cast(*Code_Node) value.macro_expansion_block);
        return;
    }
    if node.kind == .RETURN {
        value := cast(*Code_Return) node;
        for argument: value.arguments_unsorted maybe_array_add(pointers, argument.expression);
        return;
    }
    if node.kind == .COMMA_SEPARATED_ARGUMENTS {
        value := cast(*Code_Comma_Separated_Arguments) node;
        for argument: value.arguments maybe_array_add(pointers, argument.node);
        return;
    }
    if node.kind == .DIRECTIVE_RUN {
        value := cast(*Code_Directive_Run) node;
        maybe_array_add(pointers, cast(*Code_Node) value.procedure);
        if value.procedure maybe_array_add(pointers, cast(*Code_Node) value.procedure.body_or_null);
    }
}
get_recursive_nodes_breadth_first :: (node: *Code_Node, pointers: *[..] *Code_Node) {
    if !node return;
    cursor := pointers.count;
    array_add(pointers, node);
    while cursor < pointers.count {
        current := pointers.*[cursor];
        cursor += 1;
        get_subexpressions(current, pointers);
    }
}
get_recursive_nodes_depth_first :: (node: *Code_Node, pointers: *[..] *Code_Node) {
    if !node return;
    pending: [..] *Code_Node;
    children: [..] *Code_Node;
    defer array_free(*pending);
    defer array_free(*children);
    array_add(*pending, node);
    while pending.count > 0 {
        current := pending[pending.count - 1];
        pending.count -= 1;
        array_add(pointers, current);
        children.count = 0;
        get_subexpressions(current, *children);
        for < child: children array_add(*pending, child);
    }
}
Dumb_Value :: struct {
    node: *Code_Node;
    preorder := false;
}
get_values :: (node: *Code_Node, values: *[..] Dumb_Value) {
    if !node return;
    pending: [..] Dumb_Value;
    children: [..] *Code_Node;
    defer array_free(*pending);
    defer array_free(*children);
    array_add(*pending, Dumb_Value.{node, true});
    while pending.count > 0 {
        event := pending[pending.count - 1];
        pending.count -= 1;
        array_add(values, event);
        if !event.preorder continue;
        array_add(*pending, Dumb_Value.{event.node, false});
        children.count = 0;
        get_subexpressions(event.node, *children);
        for < child: children array_add(*pending, Dumb_Value.{child, true});
    }
}
visit_pre_and_postorder :: (node: *Code_Node, code: Code) #expand {
    events: [..] Dumb_Value;
    defer array_free(*events);
    get_values(node, *events);
    for event: events {
        `it := event.node;
        `preorder := event.preorder;
        #insert code;
    }
}
#scope_module
#import,file "../Compiler/module.jai";
#import "Basic";
