// Printers recognize declared numeric layouts before reading their storage.
print_numeric_row :: (builder: *Basic.String_Builder, values: [] float) {
    Basic.append(builder,"(");
    for i: 0..values.count-1 {
        if i!=0 Basic.append(builder,", ");
        Basic.print_to_builder(builder,"%",values[i]);
    }
    Basic.append(builder,")");
}
print_known_matrix :: (builder: *Basic.String_Builder, m: $T/interface AnyMatrix) -> bool {
    for i: 0..m.v.count-1 {
        if i!=0 Basic.append(builder,", ");
        print_numeric_row(builder,m.v[i].component);
    }
    return true;
}
print_matrix :: (builder: *Basic.String_Builder, any: Any, user_data: *void) -> bool {
    if any.type==type_info(Matrix2) return print_known_matrix(builder,(cast(*Matrix2) any.value_pointer).*);
    if any.type==type_info(Matrix3) return print_known_matrix(builder,(cast(*Matrix3) any.value_pointer).*);
    if any.type==type_info(Matrix4) return print_known_matrix(builder,(cast(*Matrix4) any.value_pointer).*);
    if any.type==type_info(Matrix4x3) return print_known_matrix(builder,(cast(*Matrix4x3) any.value_pointer).*);
    return false;
}
// Struct printer hook: vectors render as "(x, y, ...)", matrices as a list of such rows.
math_struct_printer :: (builder: *Basic.String_Builder, any: Any, user_data: *void) -> bool {
    lanes := 0;
    if      any.type == type_info(Vector2)  lanes = 2;
    else if any.type == type_info(Vector3)  lanes = 3;
    else if any.type == type_info(Vector4)  lanes = 4;
    if lanes == 0  return print_matrix(builder, any, user_data);

    // Every vector type is a run of floats starting at offset 0.
    view: [] float;
    view.data  = cast(*float) any.value_pointer;
    view.count = lanes;
    print_numeric_row(builder, view);
    return true;
}
