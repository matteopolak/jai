// Metaprogram plugin: when the build succeeds and produces an executable, run it.
// LAUNCHER_COMMAND is prepended to the command line (e.g. a wrapper or emulator).
#module_parameters (OUTPUT_EXECUTABLE_EXTENSION := "", LAUNCHER_COMMAND: [] string = .[]) ();

get_plugin :: () -> *Plugin {
    p := New(My);
    p.message  = message;
    p.shutdown = shutdown;
    return p;
}

message :: (_p: *Plugin, message: *Compiler.Message) {
    p := cast(*My) _p;
    if message.kind == .COMPLETE {
        complete := cast(*Compiler.Message_Complete) message;
        if complete.error_code != .NONE  p.should_run = false;
    }
}

shutdown :: (_p: *Plugin) {
    p := cast(*My) _p;

    if !p.should_run {
        log("[Autorun] There were errors, so we are not running.\n");
        free(p);
        return;
    }

    options := Compiler.get_build_options(p.workspace);
    if options.output_type != .EXECUTABLE {
        log("[Autorun] Not running anything, because the Build_Options.output_type of Workspace % is %.\n", p.workspace, options.output_type);
        free(p);
        return;
    }

    // Paths given on the command line have no trailing separator; compiler-chosen ones do.
    separator := "/";
    path := options.output_path;
    if path.count {
        last := path[path.count - 1];
        if last == #char "/" || last == #char "\\" separator = "";
    }

    executable_name := tprint("%1%2%3%4", path, separator, options.output_executable_name, OUTPUT_EXECUTABLE_EXTENSION);
    log("[Autorun] Running: %\n", executable_name);

    command: [..] string;
    array_add(*command, ..LAUNCHER_COMMAND);
    array_add(*command, executable_name);
    result := Process.run_command(..command);

    if result.exit_code != 0 {
        if result.type == {
            case .FAILED_TO_LAUNCH; Compiler.compiler_report("[Autorun] Program failed to launch.");
            case .EXITED;           Compiler.compiler_report(tprint("[Autorun] Program exited with code %.", result.exit_code));
            case .SIGNALED;         Compiler.compiler_report(tprint("[Autorun] Program quit due to signal %.", result.signal));
            case;                   Compiler.compiler_report(tprint("[Autorun] Unexpected result from running the program: %", result));
        }
    }

    free(p);
}

#scope_module

#import "Basic";
Compiler :: #import "Compiler";
Process  :: #import "Process";

Plugin :: Compiler.Metaprogram_Plugin;

My :: struct {
    #as using base: Plugin;
    should_run := true;
}
