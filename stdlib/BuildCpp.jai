// BuildCpp: turn a few C or C++ source files into an executable, a library or object
// files by invoking the platform toolchain, typically from a metaprogram. Problems are
// reported with compiler_report at the caller's location. This is meant for small
// vendored libraries; anything bigger deserves a proper build system.

#module_parameters ()(PS5_SUPPORT := false);

Build_Type :: enum {
    STATIC_LIBRARY;
    DYNAMIC_LIBRARY;
    EXECUTABLE;
    OBJ_FILE;
}

build_cpp_static_lib :: #bake_arguments build_cpp(type = .STATIC_LIBRARY);
build_cpp_dynamic_lib :: #bake_arguments build_cpp(type = .DYNAMIC_LIBRARY);
build_cpp_executable :: #bake_arguments build_cpp(type = .EXECUTABLE);

// Windows targets use MSVC (cl.exe, lib.exe), located automatically. Other targets use a
// clang-style driver: compiler_executable_path, else $CC or $CXX, else clang or clang++
// (the SDK's own copy for Android and Switch). Static libraries are packed with
// ar_executable_path, else "ar" (llvm-ar from the SDK for Android and Switch).
// OBJ_FILE leaves one object per source next to the working directory and ignores
// output_basename.
build_cpp :: (output_basename: string, files: ..string, type: Build_Type, debug := false, extra: [] string = .[], library_files: [] string = .[], target := OS, compiler_executable_path := "", ar_executable_path := "", working_directory := "", loc := #caller_location) -> bool {
    auto_release_temp();
    push_allocator(temp);

    job: Job;
    job.sources = files;
    job.type = type;
    job.debug = debug;
    job.extra = extra;
    job.libraries = library_files;
    job.target = target;
    job.directory = working_directory;
    job.loc = loc;
    job.output = tprint("%1%2", output_basename, output_suffix(type, target));
    #if OS == .WINDOWS path_overwrite_separators(job.output, #char "\\");

    if target == .WINDOWS return build_with_msvc(*job, output_basename);
    return build_with_clang(*job, compiler_executable_path, ar_executable_path);
}

// The .c and .cpp files in `path` (and below it, if recursive). Release with free_cpp_files.
enum_cpp_files :: (path: string, recursive := false) -> [..] string {
    sources: [..] string;
    candidates := file_list(path, recursive);
    for candidates {
        extension := path_extension(it);
        if extension == "c" || extension == "cpp" array_add(*sources, it);
        else free(it);
    }
    array_free(candidates);
    return sources;
}

free_cpp_files :: (files: [] string) {
    for files free(it);
    array_free(files);
}

#scope_file

Job :: struct {
    sources: [] string;
    type: Build_Type;
    debug: bool;
    extra: [] string;
    libraries: [] string;
    target: Operating_System_Tag;
    directory: string;
    loc: Source_Code_Location;

    output: string; // final artifact, extension included
    objects: [..] string; // intermediate objects, deleted afterwards unless they are the product
}

output_suffix :: (type: Build_Type, target: Operating_System_Tag) -> string {
    windows := target == .WINDOWS;
    if type == .EXECUTABLE return ifx windows then ".exe" else "";
    if type == .OBJ_FILE return ifx windows then ".obj" else ".o";
    if type == .STATIC_LIBRARY return ifx windows then ".lib" else ".a";
    if windows return ".dll";
    if target == .MACOS return ".dylib";
    return ".so";
}

// Logs the command line, runs it with output echoed, and reports a non-zero exit.
execute :: (job: *Job, tool: string, command: [] string) -> bool {
    log("%", get_quoted_command_string(command));
    result := run_command(..command, capture_and_return_output = true, print_captured_output = true, working_directory = job.directory);
    if result.type == .EXITED && result.exit_code == 0 return true;
    if result.type == .FAILED_TO_LAUNCH report(job, tprint("BuildCpp: could not start the % (%).\n", tool, command[0]));
    else report(job, tprint("BuildCpp: the % exited with code %.\n", tool, result.exit_code));
    return false;
}

// Objects are named relative to the directory the tools ran in, not to ours.
remove_intermediates :: (job: *Job) {
    if job.type == .OBJ_FILE return;
    for job.objects {
        if job.directory file_delete(tprint("%/%", job.directory, it));
        else file_delete(it);
    }
}

add_sources :: (job: *Job, command: *[..] string, object_extension: string) {
    for job.sources {
        native := copy_temporary_string(it);
        path_overwrite_separators(native);
        array_add(command, native);
        array_add(*job.objects, tprint("%1%2", path_strip_extension(path_filename(it)), object_extension));
    }
}

uses_cpp :: (sources: [] string) -> bool {
    for sources if path_extension(it) == "cpp" return true;
    return false;
}

build_with_msvc :: (job: *Job, output_basename: string) -> bool {
    #if OS != .WINDOWS {
        report(job, "BuildCpp: Windows targets need MSVC, which is only available when building on Windows.\n");
        return false;
    } else {
        #if CPU == .ARM64 {
            arch :: "arm64";
            machine :: "/MACHINE:ARM64";
        } else {
            arch :: "x64";
            machine :: "/MACHINE:X64";
        }
        // The library folder of the newest MSVC toolset and its linker; cl.exe and lib.exe sit
        // next to the linker, the headers two levels above the libraries.
        vc_lib, linker := find_visual_studio_in_a_ridiculous_garbage_way();
        if !vc_lib || !linker {
            report(job, "BuildCpp: no Visual Studio C++ toolset found.\n");
            return false;
        }
        vc_bin := path_strip_filename(linker);
        sdk_lib, sdk_include := find_sdk_folders(arch);
        if !sdk_lib {
            report(job, "BuildCpp: no Windows SDK found.\n");
            return false;
        }
        packs := job.type == .STATIC_LIBRARY || job.type == .OBJ_FILE;

        command: [..] string;
        array_add(*command, tprint("%cl.exe", vc_bin), "/nologo", "/W3", "/DWIN32", "-diagnostics:column", "-diagnostics:caret");
        for string.[tprint("%\\..\\..\\include", vc_lib), tprint("%\\ucrt", sdk_include), tprint("%\\um", sdk_include), tprint("%\\shared", sdk_include)] {
            array_add(*command, tprint("/I%", it));
        }
        if job.debug array_add(*command, "/Od", "/Zi", "/DEBUG", "/DDEBUG", tprint("/Fd%.pdb", output_basename));
        else array_add(*command, "/O2", "/Oi");
        array_add(*command, ..job.extra);
        add_sources(job, *command, ".obj");
        defer remove_intermediates(job);

        if packs {
            array_add(*command, "/c");
        } else {
            array_add(*command, "/link", tprint("/OUT:%", job.output), machine);
            if job.type == .DYNAMIC_LIBRARY array_add(*command, "/DLL");
            for string.[vc_lib, tprint("%\\ucrt\\%", sdk_lib, arch), tprint("%\\um\\%", sdk_lib, arch)] array_add(*command, tprint("/libpath:%", it));
        }
        array_add(*command, ..job.libraries);
        // The linker leaves an export file next to a DLL; nobody asked for it.
        defer if job.type == .DYNAMIC_LIBRARY file_delete(tprint("%.exp", output_basename));

        if !execute(job, "compiler", command) return false;
        if job.type != .STATIC_LIBRARY return true;

        archive: [..] string;
        array_add(*archive, tprint("%lib.exe", vc_bin), "/nologo", tprint("/OUT:%", job.output));
        array_add(*archive, ..job.objects);
        return execute(job, "librarian", archive);
    }
}

#if OS == .WINDOWS {
    // `Lib\<version>` and `Include\<version>` of the newest Windows 10+ SDK that has libraries
    // for `arch`. The registry names only the kit's root.
    find_sdk_folders :: (arch: string) -> lib: string, include: string {
        root := find_windows_kit_root();
        if !root return "", "";
        root = trim_right(root, "\\/");
        Search :: struct {
            arch: string;
            best: string;
        }
        search := Search.{ arch = arch };
        consider :: (info: *File_Visit_Info, search: *Search) {
            if !begins_with(info.short_name, "10.") return;
            if !file_exists(tprint("%\\um\\%\\kernel32.lib", info.full_name, search.arch)) return;
            if !search.best || version_less(search.best, info.short_name) search.best = copy_temporary_string(info.short_name);
        }
        visit_files(tprint("%\\Lib", root), false, *search, consider, visit_files = false, visit_directories = true);
        if !search.best return "", "";
        return tprint("%\\Lib\\%", root, search.best), tprint("%\\Include\\%", root, search.best);
    }

    // Dotted versions compared part by part as numbers: 10.0.9 is older than 10.0.10.
    version_less :: (a: string, b: string) -> bool {
        left, right := split(a, "."), split(b, ".");
        for 0..min(left.count, right.count) - 1 {
            x, y := string_to_int(left[it]), string_to_int(right[it]);
            if x != y return x < y;
        }
        return left.count < right.count;
    }
}

// An error for whoever is listening: the compiler while a metaprogram builds, the log otherwise.
report :: (job: *Job, message: string) {
    if #compile_time compiler_report(message, job.loc);
    else log_error("%", message);
}

build_with_clang :: (job: *Job, compiler_override: string, archiver_override: string) -> bool {
    cpp := uses_cpp(job.sources);
    compiler, archiver := compiler_override, archiver_override;
    if !compiler || (!archiver && job.type == .STATIC_LIBRARY) {
        default_compiler, default_archiver, found := pick_unix_tools(job, cpp);
        if !found return false;
        if !compiler compiler = default_compiler;
        if !archiver archiver = default_archiver;
    }

    command: [..] string;
    array_add(*command, compiler);
    if job.debug array_add(*command, "-Og", "-g");
    else array_add(*command, "-O3");
    if job.type == {
        case .STATIC_LIBRARY; #through;
        case .OBJ_FILE;
            array_add(*command, "-c");
        case .DYNAMIC_LIBRARY;
            array_add(*command, "-o", job.output, "-shared", "-fpic");
            // Let executables find the library through their rpath.
            if job.target == .MACOS array_add(*command, "-install_name", tprint("@rpath/%", path_filename(job.output)));
        case .EXECUTABLE;
            array_add(*command, "-o", job.output);
            if job.target == .MACOS array_add(*command, "-rpath", "@loader_path");
    }
    array_add(*command, ..job.extra);
    add_sources(job, *command, ".o");
    array_add(*command, ..job.libraries);
    defer remove_intermediates(job);

    if !execute(job, "compiler", command) return false;
    if job.type != .STATIC_LIBRARY return true;

    // `ar r` updates an existing archive in place, so stale members would survive.
    file_delete(job.output);
    archive: [..] string;
    array_add(*archive, archiver, ifx job.target == .WASM then "-rcs" else "-rc", job.output);
    array_add(*archive, ..job.objects);
    return execute(job, "archiver", archive);
}

// Default compiler and archiver for a target, used where the caller gave no override.
pick_unix_tools :: (job: *Job, cpp: bool) -> compiler: string, archiver: string, found: bool {
    driver := ifx cpp then "clang++" else "clang";

    if job.target == .ANDROID {
        ndk := from_environment("NDK_HOME");
        if !ndk ndk = from_environment("ANDROID_NDK_HOME");
        if !ndk {
            report(job, "BuildCpp: set NDK_HOME or ANDROID_NDK_HOME to an Android NDK to build for Android.\n");
            return "", "", false;
        }
        #if OS == .WINDOWS host := "windows-x86_64";
        else #if OS == .MACOS host := "darwin-x86_64";
        else host := "linux-x86_64";
        bin := tprint("%/toolchains/llvm/prebuilt/%/bin", ndk, host);
        return tprint("%/%", bin, driver), tprint("%/llvm-ar", bin), true;
    }

    if job.target == .NN_SWITCH {
        sdk := from_environment("NINTENDO_SDK_ROOT");
        if !sdk {
            report(job, "BuildCpp: set NINTENDO_SDK_ROOT to build for Switch.\n");
            return "", "", false;
        }
        bin := tprint("%\\Compilers\\NX\\nx\\aarch64\\bin", sdk);
        return tprint("%\\%", bin, driver), tprint("%\\llvm-ar.exe", bin), true;
    }

    if job.target == .PS5 {
        // The PS5 SDK lookup is not part of this module; callers pass the tool paths.
        report(job, "BuildCpp: pass compiler_executable_path and ar_executable_path for PS5 builds.\n");
        return "", "", false;
    }

    compiler := from_environment(ifx cpp then "CXX" else "CC");
    if !compiler compiler = driver;
    return compiler, "ar", true;
}

from_environment :: (name: string) -> string {
    return to_string(getenv(temp_c_string(name)));
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
