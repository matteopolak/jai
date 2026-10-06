# Tooling modules: Debug, MacOS_Bundler, BuildCpp, Autorun, Performance_Report

## What it is

Small build-and-debug modules that metaprograms and programs import: `Debug` (backtraces, breakpoints, assert and signal handlers), `MacOS_Bundler` (`.app` bundles), `BuildCpp` (compile C/C++ from a metaprogram) and the plugins `Autorun` and `Performance_Report`. The profiler has its own page: [iprof](iprof.md). `Jai_Format` (the source formatter behind `jaifmt` and the playground's Format button) is documented with the tool: [jaifmt](../tools/jaifmt.md#module-api).

## How it works

- `Debug` (`stdlib/Debug/module.jai`): `init`, `backtrace`/`free_backtrace`, `breakpoint`, `is_debugger_present`, `attach_to_debugger`, `abort`, `enable_signal_handler`, `set_report_mode`, and the assert handlers `no_assert`, `print_assert`, `trace_assert`, `break_assert`, `interactive_assert`. They return `bool` so they can be assigned to `context.assertion_failed`. `init()` installs `break_assert`/`interactive_assert` when the context still has the default handler.
- `MacOS_Bundler`: `create_app_bundle(app_name, exe, icon, resources_dir, ...)` lays out `Name.app/Contents/{MacOS,Resources}` in the working directory, copies the executable (mode `0755`), copies the resource directory with `File_Utilities.copy_directory` (straight into `Resources/`, or into `Resources/<dir name>/`), converts the icon with `sips` (`convert_image_to_icns`) and can write `Info.plist`. `CFBundleIconFile` is only written when the icon conversion succeeded. The `plist_*` helpers write one escaped element per line (`<string>value</string>`).
- `BuildCpp`: `build_cpp(output_basename, files, type, ...)` runs `$CC`/`$CXX` (clang by default), `ar`, or `cl.exe` on Windows; `build_cpp_static_lib`, `build_cpp_dynamic_lib` and `build_cpp_executable` are shortcuts. The arguments are gathered into a file-scope `Job`; `output_suffix` picks the extension, `pick_unix_tools` the per-target default tools (only consulted when an override path is missing), and `execute` logs, runs and reports one command. Objects are compiled into `working_directory` and deleted from there afterwards (kept for `OBJ_FILE`). macOS dylibs get `-install_name @rpath/<file name>`. Errors go through `compiler_report`, which is fatal when called at run time. Android builds find the NDK through `NDK_HOME` or `ANDROID_NDK_HOME`; PS5 builds need explicit tool paths. `enum_cpp_files` filters `File_Utilities.file_list` to `.c`/`.cpp`.
- `Autorun` runs the produced executable at plugin shutdown if the build had no errors (`LAUNCHER_COMMAND` prefixes the command line; an empty `output_path` runs `./<name>`). A non-zero exit, a signal or a launch failure is reported with `compiler_report`. `Performance_Report` asks for polymorph and `#run` reports, keeps the `PERFORMANCE_REPORT` message, and prints it on `COMPLETE` as `== Section ==` blocks: time, bytecode, `#run` directives (slowest first), polymorphs (most call sites first). It sorts copies of the records and prints baked constants with `Program_Print.print_expression`. The text is for people; nothing parses it. Both are `Metaprogram_Plugin`s, loaded with `-plug` ([metaprogram plugins](../metaprogramming/metaprogram-plugins.md)); the tests drive their callbacks by hand.

## How to change it

- New Debug platform: extend the `#if OS == ...` branches in `backtrace`, `is_debugger_present` and `enable_signal_handler`.
- Gotcha: `getenv` is libc's and takes a C string (`temp_c_string`).
- These modules are independent rewrites; run `tools/check_reference_resemblance.py` after changing them ([reference resemblance check](../tools/reference-resemblance.md)).
- Tests: `tests/stdlib/buildcpp-api.jai` (executable, static and dynamic library, object files, `enum_cpp_files`), `macos-bundler.jai`, `autorun-plugin.jai`, `performance-report-plugin.jai` (synthetic report records), `example-plugin.jai`, `iprof-plugin.jai`.

## Configuration

`Debug(USE_GRAPHICS)`, `BuildCpp(PS5_SUPPORT)`, `Autorun(OUTPUT_EXECUTABLE_EXTENSION, LAUNCHER_COMMAND)`. Environment variables read by `BuildCpp`: `CC`, `CXX`, `NDK_HOME`, `ANDROID_NDK_HOME`, `NINTENDO_SDK_ROOT`.

## Dependencies

`Process` (`run_command`), `File`, `File_Utilities`, `POSIX`, `Compiler`, `Sort`, `Program_Print`.
