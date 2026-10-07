// Metaprogram plugin that embeds an application icon into Windows executables.
get_plugin :: () -> *Metaprogram_Plugin {
    state := New(Icon_Plugin);
    state.plugin.log_help = log_help;
    state.plugin.handle_one_option = handle_one_option;
    state.plugin.shutdown = shutdown;
    state.plugin.message = message;
    return *state.plugin;
}

message :: (p: *Metaprogram_Plugin, message: *Message) {
    state := cast(*Icon_Plugin) p;
    if !state || !message || state.icon_filename.count == 0 return;
    // The icon is patched into the file the linker has just written, so only that phase matters.
    if message.kind == .PHASE {
        written := cast(*Message_Phase) message;
        if written.phase == .POST_WRITE_EXECUTABLE stamp_icon(state.icon_filename, message.workspace, written.executable_name);
    }
}

shutdown :: (p: *Metaprogram_Plugin) {
    state := cast(*Icon_Plugin) p;
    free(state);
}

handle_one_option :: (p: *Metaprogram_Plugin, options: [] string, cursor: int) -> new_cursor: int {
    if cursor < 0 || cursor >= options.count return cursor;
    if options[cursor] != "-icon" return cursor;
    next := cursor + 1;
    if next == options.count {
        log_error("Missing filename after -icon.\n");
        return next;
    }
    state := cast(*Icon_Plugin) p;
    state.icon_filename = options[next];
    return next + 1;
}

log_help :: (p: *Metaprogram_Plugin) {
    log(HELP_STRING);
}

HELP_STRING :: "-icon filename  Set the executable icon from an ICO file.\n";

#scope_module
stamp_icon :: (icon_filename: string, workspace: Workspace, executable_name: string) {
    #if OS == .WINDOWS {
        #import "Windows_Resources";
        options := get_build_options(workspace);
        target := tprint("%/%", options.output_path, executable_name);
        if !set_icon_by_filename(target, icon_filename) log_error("Could not set the icon of %.\n", target);
    } else {
        log_error("Setting an executable's icon is not supported on %.\n", OS);
    }
}

Icon_Plugin :: struct {
    #as using plugin: Metaprogram_Plugin;
    icon_filename: string;
}

#import "Compiler";
#import "Basic";
