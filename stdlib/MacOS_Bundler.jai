// MacOS_Bundler: lays out a macOS application bundle in the working directory:
//
//     <app_name>.app/Contents/MacOS/<app_name>      the executable (made runnable)
//     <app_name>.app/Contents/Resources/...         copied resources and the icon
//     <app_name>.app/Contents/Info.plist            when write_plist is set
//
// Icons are converted to .icns with the system's `sips` tool. The plist_* helpers are
// public so callers can write a richer Info.plist of their own.

// With only_copy_subdirectories_and_files, the contents of resource_directory_to_copy land
// directly in Resources; otherwise they keep a folder named after the source directory.
create_app_bundle :: (app_name: string, app_exe_path: string, icon_file_path: string, resource_directory_to_copy: string, only_copy_subdirectories_and_files: bool, write_plist: bool) -> app_bundle_dir: string, resources_path: string {
    bundle := tprint("%.app", app_name);
    binaries, resources := make_app_bundle_subdirectories(bundle);

    install_executable(app_exe_path, tprint("%/%", binaries, app_name));

    if resource_directory_to_copy {
        target := resources;
        if !only_copy_subdirectories_and_files target = tprint("%/%", resources, last_path_component(resource_directory_to_copy));
        copy_directory(resource_directory_to_copy, target);
    }

    // Only name the icon in Info.plist if the conversion actually produced it.
    icon := "";
    if icon_file_path && convert_image_to_icns(icon_file_path, tprint("%/%", resources, BUNDLE_ICON_NAME)) icon = BUNDLE_ICON_NAME;

    if write_plist write_info_plist(tprint("%/Contents/Info.plist", bundle), icon);
    return bundle, resources;
}

make_app_bundle_subdirectories :: (app_bundle_name: string) -> macos_folder_path: string, resources_path: string {
    contents := tprint("%/Contents", app_bundle_name);
    binaries := tprint("%/MacOS", contents);
    resources := tprint("%/Resources", contents);
    // Recursive creation makes the bundle root and Contents on the way down.
    make_directory_if_it_does_not_exist(binaries, recursive = true);
    make_directory_if_it_does_not_exist(resources, recursive = true);
    return binaries, resources;
}

convert_image_to_icns :: (input_path: string, output_path: string) -> bool {
    result := run_command("sips", "-s", "format", "icns", input_path, "--out", output_path);
    return result.type == .EXITED && result.exit_code == 0;
}

plist_start :: (builder: *String_Builder) {
    append(builder, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
    append(builder, "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n");
    append(builder, "<plist version=\"1.0\">\n<dict>\n");
}

plist_end :: (builder: *String_Builder) {
    append(builder, "</dict>\n</plist>\n");
}

plist_write_key_value :: (builder: *String_Builder, key: string, value: Any) -> success: bool {
    kind := value.type.type;
    if kind != .BOOL && kind != .STRING return false;
    plist_write_key(builder, key);
    if kind == .STRING plist_write_string(builder, (cast(*string) value.value_pointer).*);
    else plist_write_bool(builder, (cast(*bool) value.value_pointer).*);
    return true;
}

plist_write_key :: (builder: *String_Builder, key: string) {
    xml_element(builder, "key", key);
}

plist_write_string :: (builder: *String_Builder, str: string) {
    xml_element(builder, "string", str);
}

plist_write_bool :: (builder: *String_Builder, value: bool) {
    append(builder, ifx value then "<true/>\n" else "<false/>\n");
}

#scope_file
#import "Basic";
#import "Process";
#import "File";
#import "File_Utilities";
#import "String";
#import "POSIX";

BUNDLE_ICON_NAME :: "icon_data.icns";

install_executable :: (source: string, destination: string) {
    copy_file(source, destination);
    chmod(temp_c_string(destination), 0x1ED); // rwxr-xr-x
}

write_info_plist :: (path: string, icon: string) {
    plist: String_Builder;
    plist_start(*plist);
    if icon plist_write_key_value(*plist, "CFBundleIconFile", icon);
    plist_end(*plist);
    text := builder_to_string(*plist);
    defer free(text);
    write_entire_file(path, text);
}

// "assets/sounds/" -> "sounds"
last_path_component :: (path: string) -> string {
    trimmed := path;
    while trimmed.count > 1 && (trimmed[trimmed.count - 1] == #char "/" || trimmed[trimmed.count - 1] == #char "\\") trimmed.count -= 1;
    return path_filename(trimmed);
}

// <tag>text</tag> on its own line, with the text escaped.
xml_element :: (builder: *String_Builder, tag: string, text: string) {
    print_to_builder(builder, "<%>", tag);
    for byte: text {
        if byte == {
            case #char "&"; append(builder, "&amp;");
            case #char "<"; append(builder, "&lt;");
            case #char ">"; append(builder, "&gt;");
            case; append(builder, *byte, 1);
        }
    }
    print_to_builder(builder, "</%>\n", tag);
}
