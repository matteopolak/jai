// Independently authored before the refreshed ownership split.
// SOURCE-ONLY handoff candidate; not loaded by production or counted complete.
#import "Bindings_Generator";
#import "Basic";

is_target_type_signed :: (target_type: *CType = null) -> bool {
    type := strip_type(target_type, typedefs = true, enums = true);
    return type != null && type.number_flags != 0 && !(type.number_flags & .FLOAT) && (type.number_flags & .SIGNED) != 0;
}

is_target_type_unsigned :: (target_type: *CType = null) -> bool {
    type := strip_type(target_type, typedefs = true, enums = true);
    return type != null && type.number_flags != 0 && !(type.number_flags & .FLOAT) && !(type.number_flags & .SIGNED);
}

is_zero_int_expression :: (expression: *Expression) -> bool {
    if !expression || expression.kind != .LITERAL return false;

    literal := cast(*Literal) expression;
    if literal.literal_kind == .INTEGER return literal.int_value == 0;
    if literal.literal_kind == .UNSIGNED_INTEGER return literal.uint_value == 0;

    return false;
}
