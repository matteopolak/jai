// Original-format and C-porting checks require original, checked AST projections.
#module_parameters(CHECK_BINDINGS := true);

do_error_checking :: (p: *Metaprogram_Plugin, message: *Message) {
    if !message || message.kind != .TYPECHECKED return;
    typed := cast(*Message_Typechecked) message;
    for item: typed.procedure_bodies check_print_calls(item);
}

finish_error_checking :: () {
    if fatal_error compiler_set_workspace_status(.FAILED);
}

C_Porting_Check_Settings :: struct {
    skip_modules := false;
    check_treatment_of_arrays_as_pointers_in_procedure_calls := true;
    check_treatment_of_arrays_as_pointers_in_assignments := true;
    check_intermediate_cast_to_int_when_adding_small_integers := true;
}

check_c_porting :: (message: *Message, settings: C_Porting_Check_Settings) {
    if !message || message.kind != .TYPECHECKED return;
    typed := cast(*Message_Typechecked) message;
    for item: typed.procedure_bodies check_c_porting(item, settings);
}

check_c_porting :: (tc: Typechecked(Code_Procedure_Body), settings: C_Porting_Check_Settings) {
    for node: tc.subexpressions {
        if !node || should_skip(node, settings) continue;
        if node.kind == .PROCEDURE_CALL && settings.check_treatment_of_arrays_as_pointers_in_procedure_calls {
            call := cast(*Code_Procedure_Call) node;
            for argument: call.arguments_sorted if is_of_fixed_array_type(argument) compiler_report("A fixed array parameter is a value copy; pass a pointer to preserve C alias semantics.", make_location(argument), .WARNING);
        }
        if node.kind == .DECLARATION && settings.check_treatment_of_arrays_as_pointers_in_assignments {
            declaration := cast(*Code_Declaration) node;
            if is_of_fixed_array_type(declaration.expression) compiler_report("An inferred fixed-array declaration copies its array value.", make_location(node), .WARNING);
        }
        if node.kind == .BINARY_OPERATOR && settings.check_treatment_of_arrays_as_pointers_in_assignments {
            binary := cast(*Code_Binary_Operator) node;
            if binary.operator_type == #char "=" && is_of_fixed_array_type(binary.left) && is_of_fixed_array_type(binary.right) compiler_report("A fixed-array assignment copies array storage.", make_location(node), .WARNING);
        }
        if node.kind == .CAST && settings.check_intermediate_cast_to_int_when_adding_small_integers {
            conversion := cast(*Code_Cast) node;
            inner := conversion.expression;
            if !inner || !inner.type || !conversion.type continue;
            if inner.kind == .BINARY_OPERATOR && inner.type.type == .INTEGER && conversion.type.type == .INTEGER && inner.type.runtime_size < 4 && conversion.type.runtime_size > inner.type.runtime_size compiler_report("Small-integer arithmetic occurs before the widening conversion; C promotes operands first.", make_location(node), .WARNING);
        }
    }
}

#scope_module
#import,file "../Compiler/module.jai";
#import "Basic";

fatal_error := false;
my_plugin: Metaprogram_Plugin;

get_plugin :: () -> *Metaprogram_Plugin {
    my_plugin.message = do_error_checking;
    my_plugin.finish = plugin_finish;
    return *my_plugin;
}

plugin_finish :: (p: *Metaprogram_Plugin) {
    finish_error_checking();
}

check_print_calls :: (tc: Typechecked) {
    for node: tc.subexpressions {
        if !node || node.kind != .PROCEDURE_CALL continue;
        call := cast(*Code_Procedure_Call) node;
        callee := call.resolved_procedure_expression;
        if !callee || callee.kind != .PROCEDURE_HEADER continue;
        header := cast(*Code_Procedure_Header) callee;
        if !is_printlike_or_scanlike(header) || !validate_printlike(header) continue;
        format_index, varargs_index := get_argument_indices_of_format_string_and_varargs(header);
        if format_index < 0 || format_index >= call.arguments_sorted.count continue;
        argument := call.arguments_sorted[format_index];
        if !argument || argument.kind != .LITERAL continue;
        literal := cast(*Code_Literal) argument;
        if literal.value_type != .STRING continue;
        required := count_percents(literal._string, literal);
        supplied := call.arguments_sorted.count - varargs_index;
        if required != supplied {
            compiler_report("Literal format argument count differs from the supplied varargs.", make_location(literal), .ERROR_CONTINUABLE);
            fatal_error = true;
        }
    }
}

is_printlike_or_scanlike :: (header: *Code_Procedure_Header) -> bool {
    for note: header.notes if note.text == "PrintLike" || note.text == "ScanLike" return true;
    return false;
}

is_printlike :: (header: *Code_Procedure_Header) -> bool {
    for note: header.notes if note.text == "PrintLike" return true;
    return false;
}

validate_printlike :: (header: *Code_Procedure_Header) -> bool {
    format, varargs := get_argument_indices_of_format_string_and_varargs(header);
    if format < 0 || varargs < 0 {
        compiler_report("A format-marked procedure needs a format string immediately before a varargs parameter.", make_location(header), .ERROR_CONTINUABLE);
        fatal_error = true;
        return false;
    }
    argument := header.arguments[format];
    if !argument.type || argument.type.type != .STRING {
        compiler_report("The format argument must have string type.", make_location(argument), .ERROR_CONTINUABLE);
        fatal_error = true;
        return false;
    }
    return true;
}

get_argument_indices_of_format_string_and_varargs :: (proc: *Code_Procedure_Header) -> (format_string_index: int, varargs_index: int) {
    for argument, index: proc.arguments if argument.type_inst && argument.type_inst.inst_flags & .VARARGS return index - 1, index;
    return -1, -1;
}

count_percents :: (s: string, site: *Code_Literal) -> int {
    cursor: s64;
    argument: s64;
    maximum: s64;
    while cursor < s.count {
        byte := s[cursor];
        cursor += 1;
        if byte == #char "\\" && cursor < s.count {
            cursor += 1;
            continue;
        }
        if byte != #char "%" continue;
        if cursor < s.count && s[cursor] == #char "%" {
            cursor += 1;
            continue;
        }
        if cursor + 1 < s.count && s[cursor] == #char "0" && s[cursor + 1] == #char "0" {
            cursor += 2;
            continue;
        }
        numeric: s64;
        digits: s64;
        while cursor < s.count && s[cursor] >= #char "0" && s[cursor] <= #char "9" {
            numeric = numeric * 10 + s[cursor] - #char "0";
            cursor += 1;
            digits += 1;
        }
        if digits > 0 && numeric > 0 argument = numeric;
        else argument += 1;
        if argument > maximum maximum = argument;
    }
    return maximum;
}

should_skip :: (node: *Code_Node, settings: C_Porting_Check_Settings) -> bool {
    if !settings.skip_modules || !node.enclosing_load || !node.enclosing_load.enclosing_import return false;
    return node.enclosing_load.enclosing_import.module_type == .FILE;
}

is_of_fixed_array_type :: (node: *Code_Node) -> bool {
    if !node || !node.type || node.type.type != .ARRAY return false;
    return (cast(*Type_Info_Array) node.type).array_type == .FIXED;
}
