# Tooling modules: Debug, MacOS_Bundler, BuildCpp, Autorun, Performance_Report

## What it is

Small build-and-debug modules that metaprograms and programs import: `Debug` (backtraces, breakpoints, assert and signal handlers), `MacOS_Bundler` (`.app` bundles), `BuildCpp` (compile C/C++ from a metaprogram) and the plugins `Autorun` and `Performance_Report`. The profiler has its own page: [iprof](iprof.md).

## How it works

- `Debug` (`stdlib/Debug/module.jai`): `init`, `backtrace`/`free_backtrace`, `breakpoint`, `is_debugger_present`, `attach_to_debugger`, `abort`, `enable_signal_handler`, `set_report_mode`, and the assert handlers `no_assert`, `print_assert`, `trace_assert`, `break_assert`, `interactive_assert`. They return `bool` so they can be assigned to `context.assertion_failed`. `init()` installs `break_assert`/`interactive_assert` when the context still has the default handler.
- `MacOS_Bundler`: `create_app_bundle(app_name, exe, icon, resources_dir, ...)` lays out `Name.app/Contents/{MacOS,Resources}`, copies the executable, converts the icon with `sips` (`convert_image_to_icns`) and can write `Info.plist`.
- `BuildCpp`: `build_cpp(output_basename, files, type, ...)` runs `$CC`/`$CXX` (clang by default), `ar`, or `cl.exe` on Windows; `build_cpp_static_lib`, `build_cpp_dynamic_lib` and `build_cpp_executable` are shortcuts. Errors go through `compiler_report`. Android builds find the NDK through `NDK_HOME` or `ANDROID_NDK_HOME`.
- `Autorun` runs the produced executable at plugin shutdown if the build had no errors (`LAUNCHER_COMMAND` prefixes the command line). `Performance_Report` asks for polymorph and `#run` reports and prints them on the `COMPLETE` message. Both are `Metaprogram_Plugin`s; `jaic` cannot load plugins yet (see [compiler-and-metaprogramming](compiler-and-metaprogramming.md)), so tests drive their callbacks by hand.

## How to change it

- New Debug platform: extend the `#if OS == ...` branches in `backtrace`, `is_debugger_present` and `enable_signal_handler`.
- `Performance_Report` prints polymorph arguments with a local `print_simple_expression`; it could use `Program_Print.print_expression` instead.
- Gotchas: `return ifx cond then "s";` without `else` does not type-check in `jaic` (use an explicit `if`); `Basic.getenv` takes a C string (`temp_c_string`); a literal array module argument such as `Autorun(LAUNCHER_COMMAND=.["x"])` arrives as `void`.
- Tests: `tests/stdlib/buildcpp-api.jai`, `autorun-plugin.jai`, `performance-report-plugin.jai`, `iprof-plugin.jai`.

## Configuration

`Debug(USE_GRAPHICS)`, `BuildCpp(PS5_SUPPORT)`, `Autorun(OUTPUT_EXECUTABLE_EXTENSION, LAUNCHER_COMMAND)`. Environment variables read by `BuildCpp`: `CC`, `CXX`, `NDK_HOME`, `ANDROID_NDK_HOME`, `NINTENDO_SDK_ROOT`.

## Dependencies

`Process` (`run_command`), `File`, `File_Utilities`, `POSIX`, `Compiler`, `Sort`, `Program_Print`.
