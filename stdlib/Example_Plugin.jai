// Independently authored example of the canonical metaprogram callback protocol.
#import "Basic";
#import "Compiler";

get_plugin :: () -> *Metaprogram_Plugin {
    plugin := New(Metaprogram_Plugin);
    plugin.before_intercept = before_intercept;
    plugin.add_source = add_source;
    plugin.message = message;
    plugin.finish = finish;
    plugin.shutdown = shutdown;
    plugin.handle_one_option = handle_one_option;
    plugin.log_help = log_help;
    return plugin;
}

before_intercept :: (p: *Metaprogram_Plugin, flags: *Intercept_Flags) {
    print("Example_Plugin: compilation starting.\n");
}

add_source :: (p: *Metaprogram_Plugin) {
    print("Example_Plugin: build options are finalized.\n");
}

message :: (p: *Metaprogram_Plugin, message: *Message) {
    num_messages += 1;
    if message.kind == .PHASE {
        phase := cast(*Message_Phase) message;
        print("Example_Plugin: phase %.\n", phase.phase);
        if phase.phase == .PRE_WRITE_EXECUTABLE {
            print("Example_Plugin: executable %.\n", phase.executable_name);
        }
    } else if message.kind == .TYPECHECKED {
        checked := cast(*Message_Typechecked) message;
        print("Example_Plugin: % declarations, % headers, % bodies, % structs, % other nodes.\n",
              checked.declarations.count, checked.procedure_headers.count,
              checked.procedure_bodies.count, checked.structs.count, checked.others.count);
    } else if message.kind == .COMPLETE {
        print("Example_Plugin: compilation complete.\n");
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
