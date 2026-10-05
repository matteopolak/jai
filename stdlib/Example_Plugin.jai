// Example_Plugin: a metaprogram plugin that fills in every callback and prints a line
// from each one, to show when the compiler calls them. Copy it as a starting point.
#import "Basic";
#import "Compiler";

get_plugin :: () -> *Metaprogram_Plugin {
    plugin := New(Metaprogram_Plugin);
    plugin.handle_one_option = handle_one_option;
    plugin.log_help          = log_help;
    plugin.before_intercept  = before_intercept;
    plugin.add_source        = add_source;
    plugin.message           = message;
    plugin.finish            = finish;
    plugin.shutdown          = shutdown;
    return plugin;
}

// Called before the compiler starts intercepting the workspace; `flags` may be adjusted here.
before_intercept :: (p: *Metaprogram_Plugin, flags: *Intercept_Flags) {
    print("Example_Plugin: before_intercept, nothing compiled yet.\n");
}

// Build options can no longer change; a plugin could add its own source files now.
add_source :: (p: *Metaprogram_Plugin) {
    print("Example_Plugin: add_source.\n");
}

message :: (p: *Metaprogram_Plugin, message: *Message) {
    num_messages += 1;
    if message.kind == {
        case .TYPECHECKED;
            batch := cast(*Message_Typechecked) message;
            print("Example_Plugin: typechecked a batch of % (% declarations, % procedure bodies).\n",
                  batch.all.count, batch.declarations.count, batch.procedure_bodies.count);

        case .PHASE;
            update := cast(*Message_Phase) message;
            if update.phase == .PRE_WRITE_EXECUTABLE  print("Example_Plugin: about to write %.\n", update.executable_name);
            else print("Example_Plugin: now in phase %.\n", update.phase);

        case .COMPLETE;
            print("Example_Plugin: the build is done.\n");
    }
}

finish :: (p: *Metaprogram_Plugin) {
    print("Example_Plugin: received % messages.\n", num_messages);
}

shutdown :: (p: *Metaprogram_Plugin) {
    print("Example_Plugin: shutting down.\n");
    free(p);
}

handle_one_option :: (p: *Metaprogram_Plugin, options: [] string, cursor: int) -> new_cursor: int {
    if cursor < 0 || cursor >= options.count return cursor;
    if options[cursor] != "-option" return cursor;
    if cursor + 1 == options.count {
        log_error("Example_Plugin: -option requires an argument.\n");
        return cursor + 1;
    }
    log("Example_Plugin: -option %.\n", options[cursor + 1]);
    return cursor + 2;
}

log_help :: (p: *Metaprogram_Plugin) {
    log(HELP_STRING);
}

HELP_STRING :: "-option arg        Print the supplied example argument.\n";

#scope_module
num_messages := 0;
