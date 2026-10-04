// Bindings_Generator on a small C++ header: flattened namespaces, mangled
// names, reference defaults wrapped as values, visitor and printing hooks.
#import "Basic";
#import "String";
#import "File";
#import "Bindings_Generator";

HEADER :: #string END
struct Vec2 { float x, y; };
namespace Gui {
    bool Button(const char* label, const Vec2& size);
    bool Begin(const char* name, bool* p_open = nullptr, int flags = 0);
    float Scale(float s = 1.5f, int n = 3);
}
END;

visited: int;

visitor :: (decl: *Declaration, parent: *Declaration) -> Declaration_Visit_Result {
    if decl.kind == .FUNCTION && decl.name == "Scale" {
        decl.decl_flags |= .OMIT_FROM_OUTPUT;
        return .STOP;
    }
    visited += 1;
    return .RECURSE;
}

main :: () {
    header_path := "/tmp/jai_bindgen_cpp_test.h";
    output_path := "/tmp/jai_bindgen_cpp_test.jai";
    assert(write_entire_file(header_path, HEADER));

    opts: Generate_Bindings_Options;
    array_add(*opts.source_files, header_path);
    array_add(*opts.extra_clang_arguments, "-x", "c++");
    array_add(*opts.flatten_namespaces, "Gui");
    opts.generate_library_declarations = false;
    opts.generate_compile_time_struct_checks = false;
    opts.visitor = visitor;
    assert(generate_bindings(opts, output_path));

    text, ok := read_entire_file(output_path);
    assert(ok);
    assert(visited > 0);
    assert(contains(text, "Button :: (label: *u8, size: *Vec2) -> bool #foreign \"_ZN3Gui6ButtonEPKcRK4Vec2\";"));
    assert(contains(text, "Begin :: (name: *u8, p_open: *bool = null, flags: s32 = 0) -> bool #foreign"));
    assert(!contains(text, "Scale"));
    print("ok\n");
}
