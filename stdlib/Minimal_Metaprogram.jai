// Workspace construction against the maintained Compiler options API.
is_absolute_path :: (path: string) -> bool {
    if path.count == 0 return false;
    if path[0] == #char "/" || path[0] == #char "\\" return true;
    return path.count >= 3 && path[1] == #char ":" && (path[2] == #char "/" || path[2] == #char "\\");
}
build :: () {
    input := get_build_options();
    workspace := compiler_create_workspace("Target Program");
    options := get_build_options(workspace);
    sources: [..] string;
    for option: input.compile_time_command_line {
        if option == "-release" set_optimization(*options, .OPTIMIZED);
        else if option == "-debug" set_optimization(*options, .DEBUG);
        else if option == "-x64" options.backend = .X64;
        else if option == "-llvm" options.backend = .LLVM;
        else if option == "-no_cwd" continue;
        else if option.count > 0 && option[0] == #char "-" compiler_report("Unknown minimal metaprogram option.");
        else Basic.array_add(*sources, option);
    }
    if sources.count == 0 {
        compiler_report("No input source was supplied.");
        return;
    }
    options.output_executable_name = filename_stem(sources[0]);
    set_build_options(options, workspace);
    for source: sources add_build_file(source, workspace);
}
#run build();
#scope_module
#import "Compiler";
Basic :: #import "Basic";
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
