// Helpers for building a handful of C/C++ files into an executable, static library,
// dynamic library or object file from a metaprogram. Compile-time only (errors go through compiler_report).
// For anything complicated, use a real build system.

#module_parameters () (PS5_SUPPORT := false);

Build_Type :: enum {
    STATIC_LIBRARY;
    DYNAMIC_LIBRARY;
    EXECUTABLE;
    OBJ_FILE;
}

build_cpp_static_lib  :: #bake_arguments build_cpp(type = .STATIC_LIBRARY);
build_cpp_dynamic_lib :: #bake_arguments build_cpp(type = .DYNAMIC_LIBRARY);
build_cpp_executable  :: #bake_arguments build_cpp(type = .EXECUTABLE);

// compiler_executable_path and ar_executable_path are used for non-Windows targets only.
// When empty, the compiler comes from $CC / $CXX (clang / clang++ if unset) and the archiver is "ar".
build_cpp :: (output_basename: string, files: ..string, type: Build_Type, debug := false, extra: [] string = .[], library_files: [] string = .[], target := OS, compiler_executable_path := "", ar_executable_path := "", working_directory := "", loc := #caller_location) -> bool {
    auto_release_temp();
    push_allocator(temp);

    arguments: [..] string;
    objs: [..] string;

    if target == .WINDOWS
        return build_with_msvc(output_basename, files, type, debug, extra, library_files, working_directory, loc, *arguments, *objs);
    else
        return build_with_unix_tools(output_basename, files, type, debug, extra, library_files, target, compiler_executable_path, ar_executable_path, working_directory, loc, *arguments, *objs);
}

// Collects every .c / .cpp file below `path`. Free the result with free_cpp_files.
enum_cpp_files :: (path: string, recursive := false) -> [..] string {
    files: [..] string;

    visitor :: (info: *File_Visit_Info, files: *[..] string) {
        extension := path_extension(info.full_name);
        if extension == "cpp" || extension == "c" {
            array_add(files, copy_string(info.full_name));
        }
    }

    visit_files(path, recursive = recursive, *files, visitor);
    return files;
}

free_cpp_files :: (files: [] string) {
    for files free(it);
    array_free(files);
}

#scope_file

NINTENDO_SDK_BIN_PATH :: "Compilers\\NX\\nx\\aarch64\\bin\\";

run_logged :: (arguments: [] string, working_directory: string) -> exit_code: s32 {
    log("%", get_quoted_command_string(arguments));
    result := run_command(..arguments, capture_and_return_output = true, print_captured_output = true, working_directory = working_directory);
    return result.exit_code;
}

build_with_msvc :: (output_basename: string, files: [] string, type: Build_Type, debug: bool, extra: [] string, library_files: [] string, working_directory: string, loc: Source_Code_Location, arguments: *[..] string, objs: *[..] string) -> bool {
    #if OS != .WINDOWS {
        compiler_report("Unable to find Visual Studio; can't compile.\n", loc);
        return false;
    } else {
        output_filename: string;
        if #complete type == {
            case .STATIC_LIBRARY;  output_filename = tprint("%.lib", output_basename);
            case .DYNAMIC_LIBRARY; output_filename = tprint("%.dll", output_basename);
            case .EXECUTABLE;      output_filename = tprint("%.exe", output_basename);
            case .OBJ_FILE;        output_filename = tprint("%.obj", output_basename);
        }
        path_overwrite_separators(output_filename, #char "\\");

        vc_path, linker_path := find_visual_studio_in_a_ridiculous_garbage_way();
        kit_root := find_windows_kit_root();
        if !kit_root {
            compiler_report("Unable to find Windows Kit root; can't compile.\n", loc);
            return false;
        }

        array_add(arguments, join(linker_path, "\\", "cl.exe"), "/nologo");

        kit_include := replace(kit_root, "Lib", "Include");
        array_add(arguments,
            tprint("/I%\\..\\..\\include", vc_path),
            tprint("/I%\\um", kit_include),
            tprint("/I%\\ucrt", kit_include),
            tprint("/I%\\shared", kit_include));

        array_add(arguments, "/DWIN32");
        if debug {
            array_add(arguments, "/DDEBUG", "/Od", "/DEBUG", "/Zi", tprint("/Fd%.pdb", output_basename));
        } else {
            array_add(arguments, "/O2", "/Oi");
        }
        array_add(arguments, "/W3", "-diagnostics:caret", "-diagnostics:column");
        array_add(arguments, ..extra);

        for files {
            src := copy_temporary_string(it);
            path_overwrite_separators(src);
            array_add(arguments, src);
            array_add(objs, tprint("%.obj", path_strip_extension(path_filename(it))));
        }

        defer {
            if type != .OBJ_FILE for objs.* file_delete(it);
            if type == .DYNAMIC_LIBRARY file_delete(tprint("%.exp", output_basename));
        }

        if type == .STATIC_LIBRARY || type == .OBJ_FILE {
            array_add(arguments, "/c");
        } else {
            array_add(arguments, "/link");
            if type == .DYNAMIC_LIBRARY array_add(arguments, "/DLL");
            array_add(arguments,
                "/MACHINE:AMD64",
                tprint("/OUT:%", output_filename),
                tprint("/libpath:%", vc_path),
                tprint("/libpath:%\\um\\x64", kit_root),
                tprint("/libpath:%\\ucrt\\x64", kit_root));
        }
        array_add(arguments, ..library_files);

        exit_code := run_logged(arguments.*, working_directory);
        if exit_code {
            compiler_report(tprint("Compiler failed with exit code '%'.\n", exit_code), loc);
            return false;
        }

        if type == .STATIC_LIBRARY {
            arguments.count = 0;
            array_add(arguments, join(linker_path, "\\lib.exe"), "/nologo");
            array_add(arguments, ..objs.*);
            array_add(arguments, tprint("/OUT:%", output_filename));

            exit_code = run_logged(arguments.*, working_directory);
            if exit_code {
                compiler_report(tprint("Librarian failed with exit code '%'.\n", exit_code), loc);
                return false;
            }
        }
        return true;
    }
}

// Directory holding the Android NDK's clang/ar (mirrors Toolchains/Android's lookup via NDK_HOME / ANDROID_NDK_HOME).
android_toolchain_directory :: () -> string {
    root := to_string(getenv("NDK_HOME"));
    if !root root = to_string(getenv("ANDROID_NDK_HOME"));
    assert(root.count > 0, "Set the 'NDK_HOME' or 'ANDROID_NDK_HOME' environment variable to an ndk directory");

    #if OS == .WINDOWS      host_tag := "windows-x86_64";
    else #if OS == .MACOS   host_tag := "darwin-x86_64";
    else                    host_tag := "linux-x86_64";
    return tprint("%/toolchains/llvm/prebuilt/%", root, host_tag);
}

build_with_unix_tools :: (output_basename: string, files: [] string, type: Build_Type, debug: bool, extra: [] string, library_files: [] string, target: Operating_System_Tag, compiler_executable_path: string, ar_executable_path: string, working_directory: string, loc: Source_Code_Location, arguments: *[..] string, objs: *[..] string) -> bool {
    output_filename: string;
    if #complete type == {
        case .STATIC_LIBRARY;  output_filename = tprint("%.a", output_basename);
        case .OBJ_FILE;        output_filename = tprint("%.o", output_basename);
        case .DYNAMIC_LIBRARY;
            if target == {
                case .MACOS;   output_filename = tprint("%.dylib", output_basename);
                case .LINUX;   #through;
                case .ANDROID; output_filename = tprint("%.so", output_basename);
                case;          assert(false);
            }
        case .EXECUTABLE;      output_filename = copy_temporary_string(output_basename);
    }
    #if OS == .WINDOWS path_overwrite_separators(output_filename, #char "\\");

    compiler := compiler_executable_path;
    ar       := ar_executable_path;
    if !compiler || (type == .STATIC_LIBRARY && !ar) {
        is_cpp_project := false;
        for files if ends_with(it, ".cpp") { is_cpp_project = true; break; }  // C++ driver links the C++ runtime.
        clang_name := ifx is_cpp_project then "clang++" else "clang";

        if target == {
            case .NN_SWITCH;
                sdk_root := to_string(getenv("NINTENDO_SDK_ROOT"));
                if !sdk_root.count {
                    compiler_report("Could not find Nintendo SDK root. Please set the NINTENDO_SDK_ROOT environment variable.");
                    return false;
                }
                if !compiler compiler = join(sdk_root, NINTENDO_SDK_BIN_PATH, clang_name);
                if !ar       ar       = join(sdk_root, NINTENDO_SDK_BIN_PATH, "llvm-ar.exe");

            case .PS5;
                // The PS5 toolchain finder lives in a proprietary module; supply the paths explicitly.
                #if PS5_SUPPORT {
                    compiler_report("PS5 toolchain lookup is unavailable; pass compiler_executable_path and ar_executable_path.\n", loc);
                    return false;
                }

            case .ANDROID;
                toolchain := android_toolchain_directory();
                if !compiler compiler = tprint("%/bin/%", toolchain, clang_name);
                if !ar       ar       = tprint("%/bin/llvm-ar", toolchain);

            case;
                if !compiler {
                    compiler = to_string(getenv(temp_c_string(ifx is_cpp_project then "CXX" else "CC")));
                    if !compiler.count compiler = clang_name;
                }
                if !ar ar = "ar";
        }
    }

    array_add(arguments, compiler);
    if debug array_add(arguments, "-g", "-Og");
    else     array_add(arguments, "-O3");
    array_add(arguments, ..extra);

    if type == .STATIC_LIBRARY || type == .OBJ_FILE {
        array_add(arguments, "-c");
    } else {
        if type == .DYNAMIC_LIBRARY array_add(arguments, "-shared", "-fpic");
        if target == .MACOS {
            if type == .DYNAMIC_LIBRARY array_add(arguments, "-install_name", tprint("@rpath/%", output_filename));
            if type == .EXECUTABLE      array_add(arguments, "-rpath", "@loader_path");
        }
        array_add(arguments, "-o", output_filename);
    }

    for files {
        src := copy_temporary_string(it);
        path_overwrite_separators(src);
        array_add(arguments, src);
        array_add(objs, tprint("%.o", path_basename(it)));
    }

    defer if type != .OBJ_FILE for objs.* file_delete(it);

    array_add(arguments, ..library_files);

    exit_code := run_logged(arguments.*, working_directory);
    if exit_code {
        compiler_report(tprint("Compiler failed with exit code '%'.\n", exit_code), loc);
        return false;
    }

    if type == .STATIC_LIBRARY {
        file_delete(output_filename);  // ar only adds to an archive; start from a fresh one.

        arguments.count = 0;
        array_add(arguments, ar, ifx target == .WASM then "-rcs" else "-rc", output_filename);
        array_add(arguments, ..objs.*);

        exit_code = run_logged(arguments.*, working_directory);
        if exit_code {
            compiler_report(tprint("Archive command failed with exit code '%'.\n", exit_code), loc);
            return false;
        }
    }
    return true;
}

#import "Basic";
#import "File";
#import "String";
#import "Process";
#import "Compiler";
#import "File_Utilities";

#if OS == .WINDOWS {
    #import "Windows_Resources";
    #import "Windows";
} else {
    #import "POSIX";
}
