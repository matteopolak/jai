#import "Basic";
using B :: #import "Bindings_Generator";

// The façade load is coordinator-owned; exercise the exact public helper file.
#load "../../stdlib/Bindings_Generator/modifiers.jai";

Capture :: struct {
    saved_context: #Context;
    fields: int;
    public_fields: int;
    protected_fields: int;
    private_fields: int;
}

visit :: (cur: CXCursor, _parent: CXCursor, data: CXClientData) -> CXChildVisitResult #c_call {
    if cur.kind != .FieldDecl return .Recurse;

    state := cast(*Capture) data;

    push_context {
        context = state.saved_context;
        decl: Declaration;
        decl.decl_flags = .DEPRECATED;
        add_access_flags(*decl, cur);
        access := clang_getCXXAccessSpecifier(cur);

        assert((decl.decl_flags & .DEPRECATED) != 0);

        if access == .CXXPublic {
            assert(!(decl.decl_flags & (.PRIVATE | .PROTECTED)));
            state.public_fields += 1;
        } else if access == .CXXProtected {
            assert((decl.decl_flags & .PROTECTED) != 0);
            assert(!(decl.decl_flags & .PRIVATE));
            state.protected_fields += 1;
        } else if access == .CXXPrivate {
            assert((decl.decl_flags & .PRIVATE) != 0);
            assert(!(decl.decl_flags & .PROTECTED));
            state.private_fields += 1;
        } else assert(false);

        old := decl.decl_flags;

        add_access_flags(*decl, cur);
        assert(decl.decl_flags == old);
        state.fields += 1;
    }

    return .Continue;
}

main :: () {
    signature: Function_Type;
    type: CType;
    type.type_of_function = *signature;
    function: Function;
    function.type = *type;
    assert(!function_has_a_valist_arg(*function));
    integer: CType;
    integer.number_flags = .SIGNED | ._32BIT;
    integer.size = 4;
    ordinary: Declaration;
    ordinary.type = *integer;
    array_add(*signature.arguments, *ordinary);
    defer array_free(signature.arguments);
    assert(!function_has_a_valist_arg(*function));
    va_alias: Typedef;
    va_alias.name = "va_list";
    va_type: CType;
    va_type.type_of_typedef = *va_alias;
    argument: Declaration;
    argument.type = *va_type;
    array_add(*signature.arguments, *argument);
    assert(function_has_a_valist_arg(*function));
    assert(signature.arguments.count == 2 && argument.type == *va_type);
    va_alias.name = "__builtin_va_list";
    assert(function_has_a_valist_arg(*function));
    va_alias.name = "__gnuc_va_list";
    assert(function_has_a_valist_arg(*function));
    va_alias.name = "other_list";
    assert(!function_has_a_valist_arg(*function));
    signature.flags = .VARIADIC;
    assert(!function_has_a_valist_arg(*function));
    va_alias.name = "va_list";
    signature.return_type = *va_type;
    signature.arguments.count = 1;
    assert(!function_has_a_valist_arg(*function));
    // Matching parameters at every position, including more than one match.
    signature.arguments[0] = *argument;
    assert(function_has_a_valist_arg(*function));
    array_add(*signature.arguments, *ordinary);
    array_add(*signature.arguments, *argument);
    assert(function_has_a_valist_arg(*function));
    signature.arguments[0] = *ordinary;
    signature.arguments[1] = *argument;
    signature.arguments[2] = *ordinary;
    assert(function_has_a_valist_arg(*function));
    assert(signature.arguments.count == 3);
    assert(signature.arguments[0] == *ordinary && signature.arguments[1] == *argument && signature.arguments[2] == *ordinary);
    assert(argument.type == *va_type && ordinary.type == *integer);

    index := clang_createIndex(0, 0);

    assert(index != null);
    defer clang_disposeIndex(index);
    filename := to_c_string("modifiers-original.cpp");

    defer free(filename);
    source := "class Sample { int implicit_private; public: int exposed; protected: int guarded; private: int hidden; }; struct Other { int implicit_public; }; int global;";
    unsaved: CXUnsavedFile;
    unsaved.Filename = filename;
    unsaved.Contents = source.data;
    unsaved.Length = cast(type_of(unsaved.Length)) source.count;
    unit: CXTranslationUnit;
    status := clang_parseTranslationUnit2(index, filename, null, 0, *unsaved, 1, 0, *unit);

    assert(status == .Success && unit != null);
    defer clang_disposeTranslationUnit(unit);
    assert(clang_getNumDiagnostics(unit) == 0);
    state: Capture;
    state.saved_context = context;
    clang_visitChildren(clang_getTranslationUnitCursor(unit), visit, *state);
    assert(state.fields == 5 && state.public_fields == 2 && state.protected_fields == 1 && state.private_fields == 2);
    decl: Declaration;
    decl.decl_flags = .IS_CONST;
    add_access_flags(*decl, clang_getNullCursor());
    assert(decl.decl_flags == .IS_CONST);
    print("ok\n");
}
