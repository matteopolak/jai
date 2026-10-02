// Maintained Check API: validates the actual TYPECHECKED node projection.
do_error_checking :: (context, message) {
    if !message || message.kind != "TYPECHECKED" return;
    typed := cast(*Compiler.Message_Typechecked) message;
    for node: typed.all {
        if !node {
            Compiler.compiler_report("A TYPECHECKED message contains a null node.");
            continue;
        }
        if node.kind == "UNINITIALIZED" || node.kind == "" {
            Compiler.compiler_report("A TYPECHECKED message contains an uninitialized node.");
        }
        for child: node.subexpressions {
            if !child Compiler.compiler_report("A checked node contains a null subexpression.");
        }
    }
}
#scope_module
Compiler :: #import "Compiler";
