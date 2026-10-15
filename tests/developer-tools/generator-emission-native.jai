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
        // Native ABI groundwork for the pending comment-fill contract. This
        // probes official raw-comment/range APIs, not an invented fill policy.
        raw := B.clang_Cursor_getRawCommentText(cur);

        defer B.clang_disposeString(raw);
        pointer := B.clang_getCString(raw);
        comment := ifx pointer then to_string(pointer) else "";
        range := B.clang_Cursor_getCommentRange(cur);
        line, column: u32;

        B.clang_getSpellingLocation(B.clang_getRangeStart(range), null, *line, *column, null);
        if count.* == 1 assert(comment == "/// Alpha documentation." && line == 1 && column == 1);
        if count.* == 2 assert(comment == "///< Beta documentation." && line == 3 && column == 11);
        if count.* == 3 assert(comment == "" && B.clang_Range_isNull(range) != 0);

        print("comment [%] %:%\n", comment, line, column);
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
