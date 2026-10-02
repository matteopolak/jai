// Traversal of the maintained Compiler node projection, without synthetic AST nodes.
maybe_array_add :: inline (array: *[..] $T, item: T) #no_abc {
    if item Basic.array_add(array, item);
}
get_subexpressions :: (node: *Code_Node, pointers: *[..] *Code_Node) {
    if !node return;
    for child: node.subexpressions if child Basic.array_add(pointers, child);
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
    for child: node.subexpressions get_recursive_nodes_depth_first(child, pointers);
}
Dumb_Value :: struct {
    node: *Code_Node;
    preorder := false;
}
get_values :: (node: *Code_Node, values: *[..] Dumb_Value) {
    if !node return;
    Basic.array_add(values, Dumb_Value.{node, true});
    for child: node.subexpressions get_values(child, values);
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
