#import "Basic";
B :: #import "Bindings_Generator";

inspect :: (cur: B.CXCursor, _parent: B.CXCursor, data: *void) -> B.CXChildVisitResult #c_call {
    if cur.kind != .VarDecl return .Continue;

    count := cast(*int) data;
    count.* += 1;

    push_context {
        first := B.get_name_for_cursor(cur);
        second := B.get_name_for_cursor(cur);

        assert(first == second && first.count > 0 && first.data != second.data);
        first.data[0] = #char "X";
        assert(first != second);
        free(first);
        free(second);
        B.debug_print_cursor(cur);
    }

    return .Continue;
}

main :: () {
    filename := to_c_string(tprint("%generator-emission.h", #filepath));

    defer free(filename);
    index := B.clang_createIndex(0, 0);

    assert(index != null);
    defer B.clang_disposeIndex(index);
    unit: B.CXTranslationUnit;

    assert(B.clang_parseTranslationUnit2(index, filename, null, 0, null, 0, 0, *unit) == .Success);
    defer B.clang_disposeTranslationUnit(unit);
    assert(B.clang_getNumDiagnostics(unit) == 0);
    count := 0;

    B.clang_visitChildren(B.clang_getTranslationUnitCursor(unit), inspect, *count);
    assert(count == 3);
}
