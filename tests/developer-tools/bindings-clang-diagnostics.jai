#import "Basic";
#import "String";
B :: #import "Bindings_Generator";

main :: () {
    index := B.clang_createIndex(0, 0);

    assert(index != null);
    defer B.clang_disposeIndex(index);
    filename := to_c_string("original-unsaved-header.h");

    defer free(filename);
    contents := to_c_string("struct Broken { unknown_type field; };\n");

    defer free(contents);
    unsaved: B.CXUnsavedFile;
    unsaved.Filename = filename;
    unsaved.Contents = contents;
    unsaved.Length = cast(type_of(unsaved.Length)) to_string(contents).count;
    unit: B.CXTranslationUnit;
    status := B.clang_parseTranslationUnit2(index, filename, null, 0, *unsaved, 1, 0, *unit);

    assert(status == .Success && unit != null);
    defer B.clang_disposeTranslationUnit(unit);
    assert(B.clang_getNumDiagnostics(unit) == 1);
    diagnostic := B.clang_getDiagnostic(unit, 0);

    assert(diagnostic != null && B.clang_getDiagnosticSeverity(diagnostic) == .Error);
    defer B.clang_disposeDiagnostic(diagnostic);
    spelling := B.clang_getDiagnosticSpelling(diagnostic);

    defer B.clang_disposeString(spelling);
    assert(contains(to_string(B.clang_getCString(spelling)), "unknown_type"));
    formatted := B.clang_formatDiagnostic(diagnostic, B.clang_defaultDiagnosticDisplayOptions());

    defer B.clang_disposeString(formatted);
    assert(contains(to_string(B.clang_getCString(formatted)), "original-unsaved-header.h:1:17: error:"));
    location := B.clang_getDiagnosticLocation(diagnostic);

    assert(B.clang_Location_isFromMainFile(location) != 0);
    file: B.CXFile;
    line, column, offset: u32;

    B.clang_getSpellingLocation(location, *file, *line, *column, *offset);
    assert(file != null && line == 1 && column == 17 && offset == 16);
    name := B.clang_getFileName(file);

    defer B.clang_disposeString(name);
    assert(to_string(B.clang_getCString(name)) == "original-unsaved-header.h");
    print("ok\n");
}
