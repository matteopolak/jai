// The maintained compiler contract governs workspace and option defaults.
is_absolute_path :: (path: string) -> bool {
    if path.count == 0 return false;
    if path[0] == #char "/" || path[0] == #char "\\" return true;
    return path.count >= 3 && path[1] == #char ":" && (path[2] == #char "/" || path[2] == #char "\\");
}

build :: () {
    parent := get_build_options();
    args := parent.compile_time_command_line;
    workspace := compiler_create_workspace("Target Program");
    options := get_build_options(workspace);
    files: [..] string;
    added: [..] string;
    import_paths: [..] string;
    program_arguments: [..] string;
    cursor: s64;
    while cursor < args.count {
        argument := args[cursor];
        cursor += 1;
        if argument == "--" || argument == "-" {
            while cursor < args.count {
                Basic.array_add(*program_arguments, args[cursor]);
                cursor += 1;
            }
            break;
        }
        if argument == "-help" || argument == "--help" {
            Basic.write_string(HELP_STRING);
            return;
        }
        if argument == "-release" {
            set_optimization(*options, .OPTIMIZED);
            continue;
        }
        if argument == "-debug" {
            set_optimization(*options, .DEBUG, true);
            continue;
        }
        if argument == "-x64" {
            options.backend = .X64;
            continue;
        }
        if argument == "-llvm" {
            options.backend = .LLVM;
            continue;
        }
        if argument == "-no_output" {
            options.output_type = .NO_OUTPUT;
            continue;
        }
        if argument == "-verbose" {
            verbose = true;
            continue;
        }
        if argument == "-no_cwd" continue;
        if argument == "-output" || argument == "-output_path" || argument == "-import_dir" || argument == "-add" {
            if cursor == args.count {
                compiler_report("Metaprogram option needs a value.");
                return;
            }
            value := args[cursor];
            cursor += 1;
            if argument == "-output" options.output_executable_name = value;
            else if argument == "-output_path" options.output_path = value;
            else if argument == "-import_dir" Basic.array_add(*import_paths, value);
            else Basic.array_add(*added, value);
            continue;
        }
        if argument.count > 0 && argument[0] == #char "-" {
            compiler_report("This metaprogram option is not implemented by the maintained Compiler protocol.");
            return;
        }
        Basic.array_add(*files, argument);
    }
    if files.count == 0 && added.count == 0 {
        compiler_report("No input source was supplied.");
        return;
    }
    if options.output_executable_name.count == 0 && files.count > 0 options.output_executable_name = filename_stem(files[0]);
    options.compile_time_command_line = program_arguments;
    if import_paths.count > 0 options.import_path = import_paths;
    set_build_options(options, workspace);
    compiler_begin_intercept(workspace);
    for source: files add_build_file(source, workspace);
    for source: added add_build_string(source, workspace);
    message_loop(workspace);
    compiler_end_intercept(workspace);
}

message_loop :: (w: Workspace) {
    while true {
        message := compiler_wait_for_message();
        if !message {
            compiler_report("The compiler message stream ended without a completion message.");
            return;
        }
        if message.workspace != w continue;
        if message.kind == .DEBUG_DUMP {
            dump := cast(*Message_Debug_Dump) message;
            Basic.write_string(dump.dump_text);
        }
        if message.kind == .COMPLETE {
            complete := cast(*Message_Complete) message;
            if complete.error_code != .NONE compiler_set_workspace_status(.FAILED, w);
            return;
        }
    }
}

#run,stallable build();

#scope_module
#import "Compiler";
Basic :: #import "Basic";

verbose := false;

HELP_STRING :: #string COMPILER_REFLECTION_HELP
Usage: jai file.jai [-release|-debug] [-x64|-llvm] [-output name] [-output_path path] [-import_dir path] [-add source] [-no_output] [-- program arguments]
COMPILER_REFLECTION_HELP
filename_stem :: (path: string) -> string {
    begin: s64;
    end := path.count;
    for byte, index: path {
        if byte == #char "/" || byte == #char "\\" {
            begin = index + 1;
            end = path.count;
        } else if byte == #char "." end = index;
    }
    return .{ end - begin, path.data + begin };
}
