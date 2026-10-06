// Independently authored manual SDL2 SDK build workflow. No compile-time build action.
// Supply trusted upstream source with --source; this script never locates distribution binaries.
AT_COMPILE_TIME :: true;
NUM_PARALLEL_CMAKE_JOBS :: 8;
SOURCE_PATH :: "src/SDL2-2.30.2";
#if OS == .WINDOWS {
    PLATFORM_NAME :: "windows";
} else #if OS == .LINUX {
    PLATFORM_NAME :: "linux";
} else #if OS == .MACOS {
    PLATFORM_NAME :: "macos";
}
build_sdl :: (args: [] string) -> bool {
    no_extra_flags: [] string;
    if !build_sdl_variant(args, "release", no_extra_flags) return false;
    return build_sdl_variant(args, "debug", no_extra_flags);
}
build_sdl_variant :: (args: [] string, suffix: string, extra_config_args: [] string) -> bool {
    source := SOURCE_PATH;
    build_path := sprint("build/SDL2-%-%", PLATFORM_NAME, suffix);
    defer free(build_path);
    forwarded: [..] string;
    defer array_free(forwarded);
    index: s64 = 0;
    while index < args.count {
        argument := args[index];
        if argument == "--source" {
            if index + 1 >= args.count {
                print("--source needs an independently obtained SDL2 source directory\n");
                return false;
            }
            source = args[index + 1];
            index += 2;
            continue;
        }
        array_add(*forwarded, argument);
        index += 1;
    }
    // This is a manually invoked workflow for trusted upstream SDK source, never a #run action.
    configure: [..] string;
    defer array_free(configure);
    array_add(*configure, "cmake", "-S", source, "-B", build_path,
        "-DSDL_SHARED=ON", "-DSDL_STATIC=OFF", "-DSDL_TEST=OFF", "-DSDL_TESTS=OFF");
    mode := "Release";
    if suffix == "debug" mode = "Debug";
    mode_flag := sprint("-DCMAKE_BUILD_TYPE=%", mode);
    defer free(mode_flag);
    array_add(*configure, mode_flag);
    for flag: forwarded array_add(*configure, flag);
    for flag: extra_config_args array_add(*configure, flag);
    if !SDL_Build_Run(configure) return false;
    parallelism := sprint("%", NUM_PARALLEL_CMAKE_JOBS);
    defer free(parallelism);
    command: [] string = .["cmake", "--build", build_path, "--config", mode, "--parallel", parallelism];
    return SDL_Build_Run(command);
}
run_or_exit :: (command: ..string, working_directory := "") -> string {
    status, output, error, timed_out := Process_SDL_Build.run_command(..command,
        working_directory = working_directory, capture_and_return_output = true);
    if timed_out || status.type != .EXITED || status.exit_code != 0 {
        print("SDL SDK build command failed: %\n%\n", command, error);
        free(output);
        free(error);
        exit(1);
    }
    free(error);
    return output;
}
main :: () {
    arguments := get_command_line_arguments();
    options: [] string;
    if arguments.count > 1 options = .{ data = arguments.data + 1, count = arguments.count - 1 };
    if !build_sdl(options) exit(1);
}


#scope_module
#import "Basic";
Process_SDL_Build :: #import "Process";
#scope_file
SDL_Build_Run :: (command: [] string) -> bool {
    status, output, error, timed_out := Process_SDL_Build.run_command(..command,
        capture_and_return_output = true, print_captured_output = true);
    defer free(output);
    defer free(error);
    return !timed_out && status.type == .EXITED && status.exit_code == 0;
}
