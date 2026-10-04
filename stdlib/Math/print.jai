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
math_struct_printer :: (builder: *Basic.String_Builder, any: Any, user_data: *void) -> bool {
    if any.type==type_info(Vector2) {
        v:=cast(*Vector2) any.value_pointer;
        print_numeric_row(builder,v.component);
        return true;
    }
    if any.type==type_info(Vector3) {
        v:=cast(*Vector3) any.value_pointer;
        print_numeric_row(builder,v.component);
        return true;
    }
    if any.type==type_info(Vector4) {
        v:=cast(*Vector4) any.value_pointer;
        print_numeric_row(builder,v.component);
        return true;
    }
    return print_matrix(builder,any,user_data);
}
