#import "Basic";
#import "Compiler";
B :: #import "Bindings_Generator";

// Staged official SDK dependency, not a distributed-library search default.
#run compiler_add_library_search_directory("/opt/homebrew/opt/llvm/lib");

State :: struct {
    records: s64;
    functions: s64;
    record_size: s64;
}

visit :: (cursor: B.CXCursor, _parent: B.CXCursor, data: B.CXClientData) -> B.CXChildVisitResult #c_call {
    state := cast(*State) data;

    if cursor.kind == .StructDecl {
        spelling := B.clang_getCursorSpelling(cursor);

        defer B.clang_disposeString(spelling);
        name := to_string(B.clang_getCString(spelling));
        if name == "Sample" {
            type := B.clang_getCursorType(cursor);
            state.record_size = B.clang_Type_getSizeOf(type);
            state.records += 1;
        }
    }

    if cursor.kind == .FunctionDecl state.functions += 1;

    return .Continue;
}

main :: () {
    assert(size_of(B.CXCursor) == 32 && size_of(B.CXType) == 24 && size_of(B.CXString) == 16);
    index := B.clang_createIndex(0, 0);

    assert(index != null);
    defer B.clang_disposeIndex(index);
    filename := to_c_string(tprint("%bindings-input.h", #filepath));

    defer free(filename);
    args: [2] *u8;
    args[0] = to_c_string("-x");
    args[1] = to_c_string("c");
    defer free(args[0]);
    defer free(args[1]);
    unit: B.CXTranslationUnit;
    status := B.clang_parseTranslationUnit2(index, filename, args.data, 2, null, 0, 0, *unit);

    assert(status == .Success && unit != null);
    defer B.clang_disposeTranslationUnit(unit);
    state: State;
    root := B.clang_getTranslationUnitCursor(unit);

    assert(B.clang_visitChildren(root, visit, *state) == 0);
    assert(state.records == 1 && state.functions == 2 && state.record_size == 32);
    print("ok\n");
}
