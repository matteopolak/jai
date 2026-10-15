// STAGED SOURCE: actual single-module draft; general parameter/context producer
// mechanism and canonical primitive/registry integration still need completion.
#add_context generator: *Generator;
#add_context binding_generator_options: Generate_Bindings_Options;

init_generator :: (using generator: *Generator, options: Generate_Bindings_Options) {
    assert(generator != null, "generator record is required");
    context.generator = generator;
    pointer_size = size_of(*void);
    type_def_void = New(CType);
    type_def_void.flags = .VOID | .SHARED;
    type_def_bool = New(CType);
    type_def_bool.flags = .BOOL | .SHARED;
    type_def_bool.size = 1;
    type_def_bool.alignment = 1;
    type_def_u8 = lifecycle_integer(1, false);
    type_def_u16 = lifecycle_integer(2, false);
    type_def_u32 = lifecycle_integer(4, false);
    type_def_u64 = lifecycle_integer(8, false);
    type_def_s8 = lifecycle_integer(1, true);
    type_def_s16 = lifecycle_integer(2, true);
    type_def_s32 = lifecycle_integer(4, true);
    type_def_s64 = lifecycle_integer(8, true);
    type_def_char = lifecycle_integer(1, !(options.cpu == .ARM64 && (options.os == .LINUX || options.os == .ANDROID)));
    type_def_char.number_flags |= .CHAR;
    type_def_float32 = lifecycle_float(4);
    type_def_float64 = lifecycle_float(8);
    type_def_pointer_to_void = create_pointer_to(type_def_void);
    type_def_pointer_to_void.flags |= .SHARED;
    type_def_jai_string = New(CType);
    type_def_jai_string.hardcoded_jai_string = "string";
    type_def_jai_string.size = size_of(string);
    type_def_jai_string.alignment = align_of(string);
    type_def_jai_string.flags = .SHARED;
    type_def_type = New(CType);
    type_def_type.hardcoded_jai_string = "Type";
    type_def_type.size = size_of(Type);
    type_def_type.alignment = align_of(Type);
    type_def_type.flags = .SHARED;
}

deinit_generator :: (generator: *Generator) {
    assert(generator != null, "generator record is required");

    for tokens: generator.tokens_to_free {
        if tokens.token_pointer && generator.translation_unit
            clang_disposeTokens(generator.translation_unit, tokens.token_pointer, tokens.num_tokens);
    }

    array_free(generator.tokens_to_free);

    if generator.translation_unit {
        clang_disposeTranslationUnit(generator.translation_unit);
        generator.translation_unit = null;
    }

    if generator.clang_index {
        clang_disposeIndex(generator.clang_index);
        generator.clang_index = null;
    }
    // The reviewed active slot is deliberately left untouched.
}

run_generator :: (generator: *Generator, options: Generate_Bindings_Options) -> bool {
    assert(generator != null, "generator record is required");
    context.generator = generator;
    context.binding_generator_options = options;
    normalized, valid := normalize_options(options);
    if !valid return false;

    model := New(Native_Model);
    model.index = clang_createIndex(0, 0);
    if !model.index {
        log_error("Bindings_Generator: could not create native parser index\n");
        free(model);
        return false;
    }

    adopted := false;
    arguments: [..] *u8;

    defer {
        if !adopted {
            if model.unit clang_disposeTranslationUnit(model.unit);
            clang_disposeIndex(model.index);
            for allocation: model.allocations free(allocation);
        }

        for argument: arguments free(argument);

        array_free(arguments);
        free(model.filename);
        array_free(model.allocations);
        array_free(model.cursors);
        array_free(model.declaration_cursors);
        array_free(model.cpp_functions);
        array_free(model.cpp_cursors);
        if !adopted free(model);
    }

    array_add(*arguments, to_c_string("-x"));
    array_add(*arguments, to_c_string("c"));
    array_add(*arguments, to_c_string("-std=c11"));
    triple := binding_target_triple(normalized.os, normalized.cpu);
    if !triple {
        log_error("Bindings_Generator: unsupported parser target\n");
        return false;
    }

    array_add(*arguments, to_c_string(tprint("--target=%", triple)));
    for path: normalized.include_paths array_add(*arguments, to_c_string(tprint("-I%", path)));

    for path: normalized.system_include_paths {
        array_add(*arguments, to_c_string("-isystem"));
        array_add(*arguments, to_c_string(path));
    }

    defaults: [] string;
    if normalized.system_include_paths.count == 0 defaults = get_default_system_include_paths(normalized.os, normalized.cpu);

    defer {
        for path: defaults free(path);
        array_free(defaults);
    }

    if normalized.system_include_paths.count == 0 && defaults.count == 0 {
        log_error("Bindings_Generator: parser include discovery failed\n");
        return false;
    }

    for path: defaults {
        array_add(*arguments, to_c_string("-isystem"));
        array_add(*arguments, to_c_string(path));
    }

    for argument: normalized.extra_clang_arguments array_add(*arguments, to_c_string(argument));

    model.args = arguments;
    model.filename = to_c_string(normalized.source_files[0]);
    status := clang_parseTranslationUnit2(model.index, model.filename, arguments.data, cast(s32) arguments.count, null, 0, 1, *model.unit);
    if status != .Success || !model.unit {
        log_error("Bindings_Generator: native parser failed (%)\n", status);
        return false;
    }

    diagnostic_count := cast(s64) clang_getNumDiagnostics(model.unit);
    for index: 0..diagnostic_count - 1 {
        diagnostic := clang_getDiagnostic(model.unit, cast(u32) index);

        defer clang_disposeDiagnostic(diagnostic);

        if clang_getDiagnosticSeverity(diagnostic) >= .Warning {
            text := clang_formatDiagnostic(diagnostic, clang_defaultDiagnosticDisplayOptions());
            defer clang_disposeString(text);
            log_error("Bindings_Generator: %\n", to_string(clang_getCString(text)));
            return false;
        }
    }

    populate_model(model, model.unit);

    if model.failed || !group_numeric_macros(model, normalized) {
        log_error("Bindings_Generator: unsupported persistent declaration model\n");
        return false;
    }

    registry: type_of(generator.declarations_by_cursor);

    for declaration, index: model.root.declarations {
        if index >= model.declaration_cursors.count break;
        cursor := model.declaration_cursors[index];
        table_set(*registry, clang_getCanonicalCursor(cursor), declaration);
    }

    for declaration: model.root.declarations {
        if normalized.visitor visit_declarations(normalized.visitor, declaration, cast(*Declaration) *model.root);
        if normalized.visitor_with_data visit_declarations(normalized.visitor_with_data, normalized.visitor_data, declaration, cast(*Declaration) *model.root);
    }

    native_target := clang_getTranslationUnitTargetInfo(model.unit);
    if !native_target {
        table_reset(*registry);
        log_error("Bindings_Generator: parser target metadata is unavailable\n");
        return false;
    }

    bits := clang_TargetInfo_getPointerWidth(native_target);

    clang_TargetInfo_dispose(native_target);

    if bits <= 0 || bits % 8 != 0 {
        table_reset(*registry);
        log_error("Bindings_Generator: invalid native pointer width\n");
        return false;
    }

    deinit_generator(generator);
    generator.clang_index = model.index;
    generator.translation_unit = model.unit;
    generator.pointer_size = bits / 8;
    generator.global_scope.members = model.root.declarations;
    generator.declarations_by_cursor = registry;
    generator.counts = .{};
    for declaration: generator.global_scope.members {
        if declaration.kind == .FUNCTION generator.counts.functions += 1;
        if declaration.kind == .STRUCT generator.counts.structs += 1;
        if declaration.kind == .ENUM generator.counts.enums += 1;
    }

    adopted = true;

    return true;
}

#scope_module
#import "Basic";
#import "Hash_Table";

lifecycle_integer :: (bytes: int, signed: bool) -> *CType {
    type := get_int_type(bytes, signed);
    type.flags |= .SHARED;
    return type;
}

lifecycle_float :: (bytes: int) -> *CType {
    type := New(CType);
    type.size = bytes;
    type.alignment = bytes;
    type.number_flags = .FLOAT | (ifx bytes == 4 then Number_Flags._32BIT else ._64BIT);
    type.flags = .SHARED;

    return type;
}
