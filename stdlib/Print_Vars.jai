#scope_file
Basic :: #import "Basic";
Compiler :: #import "Compiler";
PP :: #import "Program_Print";
#scope_export
Print_Vars_Config :: struct {
    control_flags: enum_flags u32 {
        PRINT_NAME :: 0x1;
        PRINT_VALUE :: 0x2;
        PRINT_TYPE :: 0x4;
    } = xx 0x7;
    before_name := "";
    after_name := " = ";
    before_value := "";
    after_value := " (";
    before_type := "";
    after_type := ")";
    line_separator := "\n";
    Indentation :: enum u8 { NONE; LEFT_JUSTIFIED; RIGHT_JUSTIFIED; }
    name_indentation := Indentation.LEFT_JUSTIFIED;
    value_indentation := Indentation.LEFT_JUSTIFIED;
}
append_indented :: (builder: *Basic.String_Builder, field: string, indentation: Print_Vars_Config.Indentation, gap: s64) {
    if indentation == .RIGHT_JUSTIFIED for i: 0..gap-1 Basic.append(builder, cast(u8) 32);
    Basic.append(builder, field);
    if indentation == .LEFT_JUSTIFIED for i: 0..gap-1 Basic.append(builder, cast(u8) 32);
}
print_helper :: (builder: *Basic.String_Builder, using config: Print_Vars_Config, name_width: s64, value_width: s64, name: string, value: string, type: Type) {
    if control_flags & .PRINT_NAME {
        Basic.append(builder, before_name);
        append_indented(builder, name, name_indentation, Basic.max(0, name_width-name.count));
        Basic.append(builder, after_name);
    }
    if control_flags & .PRINT_VALUE {
        Basic.append(builder, before_value);
        append_indented(builder, value, value_indentation, Basic.max(0, value_width-value.count));
        Basic.append(builder, after_value);
    }
    if control_flags & .PRINT_TYPE {
        Basic.append(builder, before_type);
        Basic.print_to_builder(builder, "%", type);
        Basic.append(builder, after_type);
    }
    Basic.append(builder, line_separator);
}
get_code_name :: (code: Code) -> string #compile_time {
    root, expressions := Compiler.compiler_get_nodes(code);
    if root.kind == .IDENT return Basic.copy_string((cast(*Compiler.Code_Ident) root).name);
    builder: Basic.String_Builder;
    PP.print_expression(*builder, root);
    return Basic.builder_to_string(*builder);
}
print_vars_helper :: (builder: *Basic.String_Builder, config: Print_Vars_Config, $args: [$N] Code) #expand {
    names: [N] string;
    values: [N] string;
    types: [N] Type;
    #insert -> string {
        generated: Basic.String_Builder;
        for index: 0..N-1 {
            Basic.print_to_builder(*generated, "names[%] = #run get_code_name(args[%]);\n", index, index);
            Basic.print_to_builder(*generated, "__printed_value% := #insert args[%];\n", index, index);
            Basic.print_to_builder(*generated, "types[%] = type_of(__printed_value%);\n", index, index);
            Basic.print_to_builder(*generated, "values[%] = Basic.sprint(\"\%\", __printed_value%);\n", index, index);
        }
        return Basic.builder_to_string(*generated);
    };
    name_width := 0; value_width := 0;
    for i: 0..N-1 {
        name_width = Basic.max(name_width, names[i].count);
        value_width = Basic.max(value_width, values[i].count);
    }
    for i: 0..N-1 {
        print_helper(builder, config, name_width, value_width, names[i], values[i], types[i]);
        Basic.free(names[i]); Basic.free(values[i]);
    }
}
print_vars_to :: (builder: *Basic.String_Builder, $args: .. Code) #expand { print_vars_helper(builder, .{}, args); }
print_vars :: ($args: .. Code) #expand {
    builder: Basic.String_Builder;
    print_vars_helper(*builder, .{}, args);
    Basic.write_builder(*builder);
}
log_vars :: ($args: .. Code) #expand {
    builder: Basic.String_Builder;
    print_vars_helper(*builder, .{}, args);
    text := Basic.builder_to_string(*builder);
    Basic.log("%", text); Basic.free(text);
}
