// Autorun: a metaprogram plugin that starts the freshly built program once compilation
// has finished cleanly. LAUNCHER_COMMAND is put in front of the executable path, for a
// wrapper such as a debugger or an emulator; OUTPUT_EXECUTABLE_EXTENSION is appended to
// the executable name (".exe" when cross-building for Windows, for instance).
#module_parameters (OUTPUT_EXECUTABLE_EXTENSION := "", LAUNCHER_COMMAND: [] string = .[]) ();

get_plugin :: () -> *Plugin {
    runner := New(Runner);
    runner.shutdown = shutdown;
    runner.message  = message;
    return runner;
}

message :: (_p: *Plugin, message: *Compiler.Message) {
    if message.kind != .COMPLETE return;
    outcome := cast(*Compiler.Message_Complete) message;
    (cast(*Runner) _p).build_failed = outcome.error_code != .NONE;
}

// Runs at the very end, after the executable has been written.
shutdown :: (_p: *Plugin) {
    runner := cast(*Runner) _p;
    defer free(runner);

    executable, why_not := executable_to_run(runner);
    if !executable {
        log("[Autorun] %\n", why_not);
        return;
    }

    command: [..] string;
    defer array_free(command);
    for LAUNCHER_COMMAND  array_add(*command, it);
    array_add(*command, executable);

    log("[Autorun] Starting %\n", executable);
    complain_if_unsuccessful(Process.run_command(..command));
}

#scope_module

#import "Basic";
Compiler :: #import "Compiler";
Process  :: #import "Process";

Plugin :: Compiler.Metaprogram_Plugin;

Runner :: struct {
    #as using plugin: Plugin;
    build_failed: bool;
}

// The path of the program to start, or "" and the reason nothing should run.
executable_to_run :: (runner: *Runner) -> path: string, reason: string {
    if runner.build_failed  return "", "The build had errors; not starting the program.";

    options := Compiler.get_build_options(runner.workspace);
    if options.output_type != .EXECUTABLE {
        return "", tprint("Nothing to start: workspace % builds %, not an executable.", runner.workspace, options.output_type);
    }

    name := tprint("%1%2", options.output_executable_name, OUTPUT_EXECUTABLE_EXTENSION);
    directory := options.output_path;
    if !directory  return tprint("./%", name), "";

    // A directory from the command line has no trailing separator; one the compiler
    // picked does.
    last := directory[directory.count - 1];
    if last == #char "/" || last == #char "\\"  return tprint("%1%2", directory, name), "";
    return tprint("%1/%2", directory, name), "";
}

complain_if_unsuccessful :: (result: Process.Process_Result) {
    text: string;
    if result.type == {
        case .EXITED;
            if result.exit_code == 0  return;
            text = tprint("[Autorun] The program finished with exit code %.", result.exit_code);
        case .SIGNALED;
            text = tprint("[Autorun] The program was killed by signal %.", result.signal);
        case .FAILED_TO_LAUNCH;
            text = "[Autorun] The program could not be started.";
        case;
            text = tprint("[Autorun] Unexpected process state: %", result);
    }
    Compiler.compiler_report(text);
}
