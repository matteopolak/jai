// Metaprogram plugin that gives the built program an application icon.
//
//   Windows  the icon is written into the executable's resources.
//   macOS    an executable has no icon of its own, so the plugin lays out `<name>.app` beside it
//            with MacOS_Bundler (the icon converted by `sips`, so any image sips reads works).
//   Linux    desktop environments take icons from a .desktop entry, so the plugin writes
//            `<name>.desktop` beside the executable that names the icon file.
//
// The two helpers below are public so a build script can call them without the plugin.
get_plugin :: () -> *Metaprogram_Plugin {
    state := New(Icon_Plugin);
    state.plugin.log_help = log_help;
    state.plugin.handle_one_option = handle_one_option;
    state.plugin.shutdown = shutdown;
    state.plugin.message = message;
    return *state.plugin;
}

message :: (p: *Metaprogram_Plugin, message: *Message) {
    state := cast(*Icon_Plugin) p;
    if !state || !message || state.icon_filename.count == 0 return;
    // The icon is patched into the file the linker has just written, so only that phase matters.
    if message.kind == .PHASE {
        written := cast(*Message_Phase) message;
        if written.phase == .POST_WRITE_EXECUTABLE stamp_icon(state.icon_filename, message.workspace, written.executable_name);
    }
}

shutdown :: (p: *Metaprogram_Plugin) {
    state := cast(*Icon_Plugin) p;
    free(state);
}

handle_one_option :: (p: *Metaprogram_Plugin, options: [] string, cursor: int) -> new_cursor: int {
    if cursor < 0 || cursor >= options.count return cursor;
    if options[cursor] != "-icon" return cursor;
    next := cursor + 1;
    if next == options.count {
        log_error("Missing filename after -icon.\n");
        return next;
    }
    state := cast(*Icon_Plugin) p;
    state.icon_filename = options[next];
    return next + 1;
}

log_help :: (p: *Metaprogram_Plugin) {
    log(HELP_STRING);
}

HELP_STRING :: "-icon filename  Set the program's icon (an ICO file on Windows; an image sips reads for a macOS .app bundle; any image a desktop entry can name on Linux).\n";

// The text of a freedesktop.org desktop entry that launches `executable_path` with the icon.
desktop_entry_text :: (name: string, executable_path: string, icon_path: string) -> string {
    entry: String_Builder;
    append(*entry, "[Desktop Entry]\nType=Application\n");
    print_to_builder(*entry, "Name=%\n", name);
    print_to_builder(*entry, "Exec=%\n", executable_path);
    print_to_builder(*entry, "Icon=%\n", icon_path);
    append(*entry, "Terminal=false\n");
    return builder_to_string(*entry);
}

// Writes `<executable_path>.desktop` next to the executable and returns its path ("" on failure).
write_desktop_entry :: (executable_path: string, icon_path: string) -> string {
    name := executable_path;
    for index: 0..executable_path.count - 1 {
        if executable_path[index] == #char "/" || executable_path[index] == #char "\\" name = slice(executable_path, index + 1, executable_path.count - index - 1);
    }
    path := tprint("%.desktop", executable_path);
    if !write_entire_file(path, desktop_entry_text(name, executable_path, icon_path)) return "";
    return path;
}

#scope_module
stamp_icon :: (icon_filename: string, workspace: Workspace, executable_name: string) {
    #if OS == .WINDOWS {
        #import "Windows_Resources";
        options := get_build_options(workspace);
        target := tprint("%/%", options.output_path, executable_name);
        if !set_icon_by_filename(target, icon_filename) log_error("Could not set the icon of %.\n", target);
    } else #if OS == .MACOS {
        options := get_build_options(workspace);
        directory := options.output_path;
        if !directory directory = ".";
        executable := tprint("%/%", directory, executable_name);
        absolute, found := get_absolute_path(executable);
        icon_absolute, icon_found := get_absolute_path(icon_filename);
        previous := get_working_directory();
        if !found || !set_working_directory(directory) {
            log_error("Could not enter % to bundle %.\n", directory, executable_name);
            return;
        }
        bundle := MacOS_Bundler.create_app_bundle(executable_name, absolute, ifx icon_found then icon_absolute else icon_filename, "", true, true);
        set_working_directory(previous);
        log("Bundled % with its icon.\n", bundle);
    } else #if OS == .LINUX {
        options := get_build_options(workspace);
        directory := options.output_path;
        if !directory directory = ".";
        if !write_desktop_entry(tprint("%/%", directory, executable_name), icon_filename) log_error("Could not write the desktop entry for %.\n", executable_name);
    } else {
        log_error("Setting an executable's icon is not supported on %.\n", OS);
    }
}

Icon_Plugin :: struct {
    #as using plugin: Metaprogram_Plugin;
    icon_filename: string;
}

#import "Compiler";
#import "Basic";
#import "File";
#import "String";
#if OS == .MACOS MacOS_Bundler :: #import "MacOS_Bundler";
