#import "Basic";
B :: #import "Bindings_Generator";

S :: type_of(context._bindings_generator_session.*);

Capture :: struct {
    saved: #Context;
    children: [..] B.CXCursor;
}

visit :: (cur: B.CXCursor, _parent: B.CXCursor, data: B.CXClientData) -> B.CXChildVisitResult #c_call {
    capture := cast(*Capture) data;

    push_context {
        context = capture.saved;
        array_add(*capture.children, cur);
    }

    return .Continue;
}

errors: int;

log :: (_text: string, _data: *void, info: Log_Info) {
    if (info.common_flags & .ERROR) != 0 errors += 1;
}

main :: () {
    index := B.clang_createIndex(0, 0);

    defer B.clang_disposeIndex(index);
    filename := to_c_string(tprint("%generator-model-templates.hpp", #filepath));

    defer free(filename);
    unit: B.CXTranslationUnit;

    assert(B.clang_parseTranslationUnit2(index, filename, null, 0, null, 0, 0, *unit) == .Success);
    defer B.clang_disposeTranslationUnit(unit);
    assert(B.clang_getNumDiagnostics(unit) == 0);
    capture: Capture;
    capture.saved = context;
    root := B.clang_getTranslationUnitCursor(unit);

    B.clang_visitChildren(root, visit, *capture);
    defer array_free(capture.children);
    assert(capture.children.count == 3);
    generator: B.Generator;
    generator.translation_unit = unit;
    session := S.open(*generator, B.TARGET_OS);

    defer S.close(*session);
    defer H.table_reset(*generator.declarations_by_cursor);

    push_context {
        S.activate(*generator, null, *session);
        record := B.create_struct(capture.children[0]);

        assert(record != null && record.template_type_params.count == 2 && record.declarations.count == 3);
        parameter := record.template_type_params[0];

        assert(parameter.name == "T" && parameter.type == generator.type_def_type);
        assert(parameter.parent == cast(*B.Declaration) record);
        assert(record.declarations[0].type.type_of_declaration == parameter);
        assert(record.declarations[1].type.pointer_to.type_of_declaration == parameter);
        second_parameter := record.template_type_params[1];

        assert(record.declarations[2].type.pointer_to.type_of_declaration == second_parameter);
        assert((record.declarations[2].type.pointer_to.flags & .CONST) != 0);
        fields: Capture;
        fields.saved = context;
        B.clang_visitChildren(capture.children[0], visit, *fields);
        defer array_free(fields.children);
        assert(fields.children.count == 6);
        // Dependent methods without a mangling retain a usable standalone signature.
        method_cur := fields.children[5];
        ft := B.create_function_type(method_cur, B.clang_getCursorType(method_cur));

        assert(ft.return_type.type_of_declaration == second_parameter && ft.arguments.count == 2);
        assert(ft.arguments[0].type.pointer_to.type_of_struct == record);
        assert(ft.arguments[1].type.type_of_declaration == parameter);
        assert(B.create_function(method_cur, capture.children[0]) == null);
        field := fields.children[2];
        refs: Capture;
        refs.saved = context;
        B.clang_visitChildren(field, visit, *refs);
        defer array_free(refs.children);
        assert(refs.children.count == 1);
        type, consumed := B.create_elaborated_type(B.clang_getCursorType(field), refs.children, field);

        assert(type.type_of_declaration == parameter && consumed == 1);
        substituted := B.create_type_inner(B.clang_getCursorType(field), field, false, substitute_children = refs.children);

        assert(substituted.type_of_declaration == parameter);
        info, generated := B.find_or_create_extra_info(record.type, cast(*B.Declaration) record);

        assert(info == *B.struct_extra_info_unknown && generated == null);

        push_context {
            context.logger = log;

            for i: 1..2 {
                assert(B.create_struct(capture.children[i]) == null);
                found, _declaration := H.table_find(*generator.declarations_by_cursor, B.clang_getCanonicalCursor(capture.children[i]));
                assert(!found);
            }
        }

        assert(errors == 2 && !session.failed);
    }

    print("ok\n");
}

#scope_file
H :: #import "Hash_Table";
