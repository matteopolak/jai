// Metaprogram plugins (`jai first.jai -plug Name`), newer-Jai API shape.
//
// `jaic check|build file.jai -plug Name` works: the command line names the plugin
// modules before compilation starts, so jaic writes a small metaprogram that imports
// them and calls `build_with_plugins` below. What does not work is choosing plugins
// while a metaprogram runs (`init_plugins` with names only known then), which would
// need `#import` of a computed name mid-#run.

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
        Compiler.compiler_report(tprint("Metaprogram plugin '%' cannot be loaded from inside a metaprogram; pass it to jaic as '-plug %' instead.\n", it.name, it.name), mode = .ERROR_CONTINUABLE);
    }
    return false;
}

// Compile `file` in a new workspace with the given plugins hooked in. `options` are the
// command-line arguments jaic did not recognize: plugins with an `init` hook get all of
// them; older plugins take theirs one at a time through `handle_one_option`.
build_with_plugins :: (file: string, plugins: [] *Metaprogram_Plugin, options: [] string, output_name := "", output_path := "") -> bool {
    Compiler.set_build_options_dc(.{do_output = false});
    w := Compiler.compiler_create_workspace("Target Program");
    build_options := Compiler.get_build_options(w);
    if output_name  build_options.output_executable_name = output_name;
    if output_path  build_options.output_path = output_path;
    Compiler.set_build_options(build_options, w);
    for plugins  it.workspace = w;

    if !deliver_plugin_options(plugins, options)  { Compiler.compiler_set_workspace_status(.FAILED, w); return false; }

    flags: Compiler.Intercept_Flags;
    for plugins  if it.before_intercept  it.before_intercept(it, *flags);
    Compiler.compiler_begin_intercept(w, flags);
    for plugins  if it.add_source  it.add_source(it);
    Compiler.add_build_file(file, w);

    failed := false;
    while true {
        message := Compiler.compiler_wait_for_message();
        if !message  break;
        for plugins  if it.message  it.message(it, message);
        if message.kind == .COMPLETE {
            done := cast(*Compiler.Message_Complete) message;
            failed = done.error_code != .NONE;
            break;
        }
    }
    Compiler.compiler_end_intercept(w);
    for plugins  if it.finish  it.finish(it);
    for plugins  if it.shutdown  it.shutdown(it);
    if failed  Compiler.compiler_set_workspace_status(.FAILED, w);
    return !failed;
}

#scope_file
deliver_plugin_options :: (plugins: [] *Metaprogram_Plugin, options: [] string) -> bool {
    stepwise: [..] *Metaprogram_Plugin;
    defer array_free(stepwise);
    for plugins {
        if it.init {
            if !it.init(it, options)  return false;
        } else if it.handle_one_option {
            array_add(*stepwise, it);
        }
    }
    // Only plugins without `init` need each option claimed by someone.
    if !stepwise.count  return true;
    cursor := 0;
    while cursor < options.count {
        claimed := false;
        for stepwise {
            next := it.handle_one_option(it, options, cursor);
            if next > cursor { cursor = next; claimed = true; break; }
        }
        if !claimed {
            Compiler.compiler_report(tprint("No plugin accepts the option '%'.\n", options[cursor]), mode = .ERROR_CONTINUABLE);
            return false;
        }
    }
    return true;
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
