// Independent real initializer candidate. Requires general compiler #run call
// suspension; do not count as active support until the positive test executes.
init_plugins :: (to_create: [] Plugin_To_Create, results: *[..] *C.Metaprogram_Plugin, w: Workspace) -> (success: bool) {
    if !import_source_requested {
        generated := generate_initializers(to_create);
        defer free(generated);
        import_source_requested = true;
        C.add_build_string(generated, -1, IMPORT_SCOPE);
    }

    return initialize_imported_plugins(to_create, results, w);
}

#scope_file
using #import "Basic";
C :: #import "Compiler";
S :: #import "String";

import_source_requested: bool;
IMPORT_SCOPE :: #code {};

generate_initializers :: (requests: [] Plugin_To_Create) -> string {
    builder: String_Builder;

    defer free_buffers(*builder);

    for request, i: requests {
        name := request.name;
        suffix: string;
        at := S.find_index_from_left(name, cast(u8) 40);

        if at >= 0 {
            suffix = S.slice(name, at, name.count);
            name = S.slice(name, 0, at);
        }

        quoted := quote_module_string(name);

        defer free(quoted);
        print_to_builder(*builder, "Imported_Plugin_% :: #import %%;\n", i, quoted, suffix);
    }

    append(*builder, "initialize_imported_plugins :: (requests: [] Plugin_To_Create, results: *[..] *C.Metaprogram_Plugin, w: Workspace) -> bool {\n");
    print_to_builder(*builder, "if requests.count != % return false;\n", requests.count);

    for request, i: requests {
        quoted := quote_module_string(request.name);
        defer free(quoted);
        print_to_builder(*builder, "if requests[%].name != % return false;\n", i, quoted);
    }

    append(*builder, "success := true;\n");

    for request, i: requests {
        print_to_builder(*builder, "{ p := Imported_Plugin_%.get_plugin();\n", i);
        append(*builder, "if !p { success = false; } else { p.workspace = w; array_add(results, p);\n");
        print_to_builder(*builder, "if p.init { if !p.init(p, requests[%].options) success = false; }\n", i);
        print_to_builder(*builder, "else if requests[%].options.count != 0 success = false; }}\n", i);
    }

    append(*builder, "return success; }\n");

    return builder_to_string(*builder);
}

quote_module_string :: (value: string) -> string {
    builder: String_Builder;

    defer free_buffers(*builder);
    append(*builder, "\"");

    for byte: value {
        if byte == 34 || byte == 92 append(*builder, "\\");
        if byte == 10 append(*builder, "\\n");
        else if byte == 13 append(*builder, "\\r");
        else append(*builder, byte);
    }

    append(*builder, "\"");

    return builder_to_string(*builder);
}
