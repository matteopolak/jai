// Metaprogram plugin that embeds an application icon into Windows executables.
get_plugin :: ( ) -> * Metaprogram_Plugin {
    state := New(My_Plugin);
    state.plugin.log_help = log_help;
    state.plugin.handle_one_option = handle_one_option;
    state.plugin.shutdown = shutdown;
    state.plugin.message = message;
    return *state.plugin;
}
message :: ( p : * Metaprogram_Plugin , message : * Message ) {
    if !p || !message return;
    if message.kind != .PHASE return;
    phase := cast(*Message_Phase) message;
    if phase.phase != .POST_WRITE_EXECUTABLE return;
    state := cast(*My_Plugin) p;
    if state.icon_filename.count == 0 return;
    #if OS == .WINDOWS {
        #import "Windows_Resources";
        options := get_build_options(message.workspace);
        executable := tprint("%/%", options.output_path, phase.executable_name);
        if !set_icon_by_filename(executable, state.icon_filename) {
            log_error("Failed to update icon in %.\n", executable);
        }
    } else {
        log_error("Executable icon updates are unavailable on %.\n", OS);
    }
}
shutdown :: ( p : * Metaprogram_Plugin ) {
    state := cast(*My_Plugin) p;
    free(state);
}
handle_one_option :: ( p : * Metaprogram_Plugin , options : [ ] string , cursor : int ) -> new_cursor : int {
    if cursor < 0 || cursor >= options.count return cursor;
    if options[cursor] != "-icon" return cursor;
    next := cursor + 1;
    if next == options.count {
        log_error("Missing filename after -icon.\n");
        return next;
    }
    state := cast(*My_Plugin) p;
    state.icon_filename = options[next];
    return next + 1;
}
log_help :: ( p : * Metaprogram_Plugin ) {
    log(HELP_STRING);
}
HELP_STRING :: "-icon filename  Set the executable icon from an ICO file.\n";
#scope_module
My_Plugin :: struct {
    #as using plugin : Metaprogram_Plugin ;
    icon_filename : string ;
}
#import "Compiler" ;
#import "Basic" ;
