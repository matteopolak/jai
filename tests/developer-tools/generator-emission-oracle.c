/* Original SDK oracle: no generated or reference implementation input. */
#include <clang-c/Index.h>
#include <stdio.h>

static enum CXChildVisitResult inspect(CXCursor cursor, CXCursor parent,
                                      CXClientData opaque) {
    (void)parent;
    if (clang_getCursorKind(cursor) != CXCursor_VarDecl)
        return CXChildVisit_Continue;
    unsigned *count = opaque;
    ++*count;
    CXString kind = clang_getCursorKindSpelling(clang_getCursorKind(cursor));
    CXString name = clang_getCursorSpelling(cursor);
    unsigned line = 0, column = 0;
    clang_getSpellingLocation(clang_getCursorLocation(cursor), NULL, &line,
                             &column, NULL);
    printf("%s %s %u:%u\n", clang_getCString(kind), clang_getCString(name), line,
           column);
    clang_disposeString(name);
    clang_disposeString(kind);
    return CXChildVisit_Continue;
}

int main(int argc, char **argv) {
    if (argc != 2) return 2;
    CXIndex index = clang_createIndex(0, 0);
    if (!index) return 3;
    CXTranslationUnit unit = NULL;
    if (clang_parseTranslationUnit2(index, argv[1], NULL, 0, NULL, 0, 0,
                                   &unit) != CXError_Success) {
        clang_disposeIndex(index);
        return 4;
    }
    unsigned count = 0;
    unsigned diagnostics = clang_getNumDiagnostics(unit);
    clang_visitChildren(clang_getTranslationUnitCursor(unit), inspect, &count);
    clang_disposeTranslationUnit(unit);
    clang_disposeIndex(index);
    return diagnostics || count != 3;
}
