// Metaprogram plugins (`jai first.jai -plug Name`), newer-Jai API shape.
//
// jaic parses plugin arguments, but cannot instantiate plugins yet: the
// reference implementation splices `#import "Name"` into this module while a
// metaprogram's `#run` is executing, which needs suspendable typechecking.
// Metaprograms that ask for no plugins (the common case) work unchanged.

Plugin_To_Create :: struct {
    name: string;
    options: [..] string;  // Arguments given to the plugin, e.g. `-plug Check -- -no_unused`.
}

// Split `-plug Name` arguments (and their trailing options) from the rest.
parse_plugin_arguments :: (args: [] string) -> (success: bool, plugins_to_create: [..] Plugin_To_Create, remaining_args: [..] string) {
    plugins: [..] Plugin_To_Create;
    remaining: [..] string;
    i := 0;
    while i < args.count {
        arg := args[i];
        i += 1;
        if arg != "-plug" && arg != "+plug" {
            array_add(*remaining, arg);
            continue;
        }
        if i >= args.count {
            Compiler.compiler_report("-plug needs a plugin name.\n", mode = .ERROR_CONTINUABLE);
            return false, plugins, remaining;
        }
        plugin: Plugin_To_Create;
        plugin.name = args[i];
        i += 1;
        array_add(*plugins, plugin);
    }
    return true, plugins, remaining;
}

init_plugins :: (plugins: [] Plugin_To_Create, results: *[..] *Metaprogram_Plugin, w: Workspace) -> bool {
    if !plugins.count  return true;
    for plugins {
        Compiler.compiler_report(tprint("Metaprogram plugin '%' cannot be loaded: jaic does not support metaprogram plugins yet.\n", it.name), mode = .ERROR_CONTINUABLE);
    }
    return false;
}

init_plugins :: (names: [] string, results: *[..] *Metaprogram_Plugin, w: Workspace) -> bool {
    plugins: [..] Plugin_To_Create;
    defer array_free(plugins);
    for names {
        plugin: Plugin_To_Create;
        plugin.name = it;
        array_add(*plugins, plugin);
    }
    return init_plugins(plugins, results, w);
}

#scope_module
Compiler :: #import "Compiler";
Metaprogram_Plugin :: Compiler.Metaprogram_Plugin;
#import "Basic";
