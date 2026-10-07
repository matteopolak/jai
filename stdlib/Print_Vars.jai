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
    Indentation :: enum u8 {
        NONE;
        LEFT_JUSTIFIED;
        RIGHT_JUSTIFIED;
    }
    name_indentation := Indentation.LEFT_JUSTIFIED;
    value_indentation := Indentation.LEFT_JUSTIFIED;
}

// One output line: each enabled column is prefix + text padded to the column width + suffix.
print_helper :: (builder: *Basic.String_Builder, config: Print_Vars_Config, name_width: s64, value_width: s64, name: string, value: string, type: Type) {
    flags := config.control_flags;
    if flags & .PRINT_NAME emit_column(builder, config.before_name, name, name_width, config.name_indentation, config.after_name);
    if flags & .PRINT_VALUE emit_column(builder, config.before_value, value, value_width, config.value_indentation, config.after_value);
    if flags & .PRINT_TYPE emit_column(builder, config.before_type, Basic.tprint("%", type), 0, .NONE, config.after_type);
    Basic.append(builder, config.line_separator);
}

emit_column :: (builder: *Basic.String_Builder, prefix: string, text: string, width: s64, side: Print_Vars_Config.Indentation, suffix: string) {
    Basic.append(builder, prefix);
    fill := width - text.count;
    if side == .RIGHT_JUSTIFIED pad_spaces(builder, fill);
    Basic.append(builder, text);
    if side == .LEFT_JUSTIFIED pad_spaces(builder, fill);
    Basic.append(builder, suffix);
}

pad_spaces :: (builder: *Basic.String_Builder, n: s64) {
    for 1..n Basic.append(builder, " ");
}

get_code_name :: (code: Code) -> string #compile_time {
    root := Compiler.compiler_get_nodes(code);
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
        for index: 0..N - 1 {
            Basic.print_to_builder(*generated, "names[%] = #run get_code_name(args[%]);\n", index, index);
            Basic.print_to_builder(*generated, "__printed_value% := #insert args[%];\n", index, index);
            Basic.print_to_builder(*generated, "types[%] = type_of(__printed_value%);\n", index, index);
            Basic.print_to_builder(*generated, "values[%] = Basic.sprint(\"\%\", __printed_value%);\n", index, index);
        }
        return Basic.builder_to_string(*generated);
    };
    name_width := 0;
    value_width := 0;
    for i: 0..N - 1 {
        name_width = Basic.max(name_width, names[i].count);
        value_width = Basic.max(value_width, values[i].count);
    }
    for i: 0..N - 1 {
        print_helper(builder, config, name_width, value_width, names[i], values[i], types[i]);
        Basic.free(names[i]);
        Basic.free(values[i]);
    }
}

print_vars_to :: (builder: *Basic.String_Builder, $args: ..Code) #expand {
    print_vars_helper(builder, .{}, args);
}

print_vars :: ($args: ..Code) #expand {
    builder: Basic.String_Builder;
    print_vars_helper(*builder, .{}, args);
    Basic.write_builder(*builder);
}

log_vars :: ($args: ..Code) #expand {
    builder: Basic.String_Builder;
    print_vars_helper(*builder, .{}, args);
    text := Basic.builder_to_string(*builder);
    Basic.log("%", text);
    Basic.free(text);
}
