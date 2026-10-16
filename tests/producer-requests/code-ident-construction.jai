C :: #import "Compiler";

construct :: (explicit_kind: bool) -> Code {
    identifier: C.Code_Ident;
    identifier.name = "result";
    if explicit_kind identifier.kind = .IDENT;

    assignment: C.Code_Binary_Operator;
    assignment.kind = .BINARY_OPERATOR;
    assignment.operator_type = #char "=";
    assignment.left = *identifier;
    assignment.right = C.compiler_get_nodes(#code 19);

    return C.compiler_get_code(*assignment);
}

// Change only this argument to distinguish implicit versus explicit node tags.
rebuilt :: #run construct(false);
main :: () {}
