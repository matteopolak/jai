// The supplied plugin ABI is explicitly scoped to the original compiler protocol.
init_plugins :: (names: [] string, results: *[..] *Metaprogram_Plugin, w: Workspace) {
    if already_initted_plugins {
        Compiler.compiler_report("Plugin initialization was requested more than once.");
        return;
    }
    already_initted_plugins = true;
    builder: String_Builder;
    append(*builder, "PLUGIN_INIT_STRING :: #string AUTHORED_PLUGIN_LOAD\n");
    for name, index: names {
        module_name, parameters := my_split_from_left(name, #char "(");
        if module_name.count == 0 { Compiler.compiler_report("An empty plugin module name is invalid."); return; }
        print_to_builder(*builder, "Module_% :: #import ", index);
        append_source_quote(*builder, module_name);
        append(*builder, parameters);
        append(*builder, ";\n");
        print_to_builder(*builder, "plugin_%: *Metaprogram_Plugin = Module_%.get_plugin();\n", index, index);
        print_to_builder(*builder, "assert(plugin_%);\nplugin_%.workspace = w;\narray_add(results, plugin_%);\n", index, index, index);
    }
    append(*builder, "AUTHORED_PLUGIN_LOAD\n");
    generated := builder_to_string(*builder);
    Compiler.add_build_string(generated, cast(Workspace) -1, code=MY_MODULE_SCOPE);
    init_plugins_part_2(results, w);
}
#scope_module
Compiler :: #import,file "legacy/Compiler/module.jai";
Metaprogram_Plugin :: Compiler.Metaprogram_Plugin;
#import "Basic";
#placeholder PLUGIN_INIT_STRING;
MY_MODULE_SCOPE :: #code {};
already_initted_plugins := false;
init_plugins_part_2 :: (results: *[..] *Metaprogram_Plugin, w: Workspace) {
    #insert PLUGIN_INIT_STRING;
}
slice :: inline (s: string, index: s64, count: s64) -> string {
    if index < 0 index = 0;
    if index > s.count index = s.count;
    if count < 0 count = 0;
    if count > s.count - index count = s.count - index;
    return .{count, s.data + index};
}
my_split_from_left :: (s: string, byte: u8) -> (left: string, right: string) {
    for current, index: s if current == byte return slice(s, 0, index), slice(s, index, s.count - index);
    return s, "";
}
append_source_quote :: (builder: *String_Builder, text: string) {
    append(builder, "\"");
    for byte: text {
        if byte == #char "\"" || byte == #char "\\" append(builder, "\\");
        append(builder, string.{1, *byte});
    }
    append(builder, "\"");
}
