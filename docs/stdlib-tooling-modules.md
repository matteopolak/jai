# Tooling modules: Debug, MacOS_Bundler, BuildCpp, Autorun, Performance_Report

## What it is

Small build-and-debug modules that metaprograms and programs import: `Debug` (backtraces, breakpoints, assert and signal handlers), `MacOS_Bundler` (`.app` bundles), `BuildCpp` (compile C/C++ from a metaprogram), and the metaprogram plugins `Autorun` and `Performance_Report`. Profiling is in [iprof.md](iprof.md).

## How it works

- `Debug` (`stdlib/Debug/module.jai`) is the full API: `init`, `backtrace`/`free_backtrace`, `breakpoint`, `is_debugger_present`, `attach_to_debugger`, `abort`, `enable_signal_handler`, `set_report_mode`, and the assert handlers `no_assert`/`print_assert`/`trace_assert`/`break_assert`/`interactive_assert`. It is the same code as `stdlib/legacy/Debug`. `init()` also installs `break_assert`/`interactive_assert` as `context.assertion_failed` when it is still the default. The assert handlers return `bool` (always `false` except the breaking ones) so they can be assigned to `context.assertion_failed`.
- `MacOS_Bundler`: `create_app_bundle(app_name, exe, icon, resources_dir, only_copy_subdirectories_and_files, write_plist)` lays out `Name.app/Contents/{MacOS,Resources}`, copies the executable (chmod 0x1FF), converts the icon through `sips` (`convert_image_to_icns`) and optionally writes `Info.plist` with the `plist_*` helpers.
- `BuildCpp`: `build_cpp(output_basename, files, type, ...)` runs `$CC`/`$CXX` (clang by default), `ar`, or `cl.exe` on Windows. `build_cpp_static_lib`/`_dynamic_lib`/`_executable` are `#bake_arguments` shortcuts. Errors go through `compiler_report`. Android uses the NDK from `NDK_HOME`/`ANDROID_NDK_HOME` (looked up locally: `Toolchains/Android` does not exist in `stdlib/`).
- `Autorun` runs the produced executable at plugin `shutdown` if compilation had no errors (`LAUNCHER_COMMAND` prefixes the command). `Performance_Report` asks for the polymorph and `#run` reports and prints them at the `COMPLETE` message. Both are `Metaprogram_Plugin`s; `jaic` cannot load plugins yet (`Metaprogram_Plugins.jai`), so they typecheck and their callbacks can be driven by hand, as the tests do.

## How to change it

- Add a Debug platform: extend the `#if OS == ...` branches in `backtrace` / `is_debugger_present` / `enable_signal_handler`.
- `Performance_Report` prints polymorph arguments with a local `print_simple_expression` because `Program_Print.print_expression` did not exist then; it can now be replaced with that.
- Gotchas found while writing these: `return ifx cond then "s";` without `else` does not typecheck in `jaic` (use an explicit `if`); `Basic.getenv` takes a C string (`temp_c_string`); a literal array module argument such as `Autorun(LAUNCHER_COMMAND=.["x"])` arrives as `void`.

## Configuration

`Debug`: `USE_GRAPHICS`. `BuildCpp`: `PS5_SUPPORT`. `Autorun`: `OUTPUT_EXECUTABLE_EXTENSION`, `LAUNCHER_COMMAND`. Environment: `CC`, `CXX`, `NDK_HOME`, `ANDROID_NDK_HOME`, `NINTENDO_SDK_ROOT`.

## Dependencies

`Process` (`run_command`), `File`, `File_Utilities`, `POSIX`, `Compiler`, `Sort`, `Program_Print`.

## Related compatibility additions

- `Simp`: `Simp_Coordinate_System` and the `coords` argument of `set_render_target` (recorded in `context.simp.coordinate_system`; projection and text stay right-handed), `immediate_begin`, `immediate_vertex`, `Loaded_Font`, `find_loaded_font`, `make_loaded_font`, `load_font(path, basename, height)`, `get_character_width_in_pixels`, `get_glyph_width_in_pixels`, `accumulate_glyphs_from_font`, `get_baseline_height`, `release_font`, OpenType feature structs, `isdigit`, `isLegalUTF8`, `glyph_id_to_hash_key`. The original `get_font_at_size(path, name, height)` is not added: it has the same parameter types as the existing `get_font_at_size(name, font_data, height)`.
- `Input`: `add_resize_record`, `window_minimized`, `WHEEL_DELTA`. Also fixed: `update_window_events` used `swap(*a, *b)`, which resolves to the by-value `swap` and so never delivered resize/move records; it now uses `Swap`.
- `Socket`: the Winsock `WSA*` error constants (Windows only).
- `File`: `write_entire_file(name, *builder)` no longer resets the builder before writing.
