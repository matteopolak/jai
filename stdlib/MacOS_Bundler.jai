// Builds a macOS .app bundle directory layout (and optionally Info.plist / icns icon).

// only_copy_subdirectories_and_files == false puts the files of resource_directory_to_copy under
// "Contents/Resources/<directory name>/", otherwise they go straight into "Contents/Resources".
create_app_bundle :: (app_name: string, app_exe_path: string, icon_file_path: string, resource_directory_to_copy: string, only_copy_subdirectories_and_files: bool, write_plist: bool) -> app_bundle_dir: string, resources_path: string {
    app_bundle_name := tprint("%.app", app_name);
    macos_path, resources_path := make_app_bundle_subdirectories(app_bundle_name);

    if resource_directory_to_copy.count {
        if only_copy_subdirectories_and_files {
            copy_files_recursively(resource_directory_to_copy, resources_path);
        } else {
            out_dir := tprint("%/%", resources_path, basename(resource_directory_to_copy));
            make_directory_if_it_does_not_exist(out_dir);
            copy_files_recursively(resource_directory_to_copy, out_dir);
        }
    }

    bundle_exe_path := tprint("%/%", macos_path, app_name);
    copy_file(app_exe_path, bundle_exe_path);
    chmod(temp_c_string(bundle_exe_path), 0x1FF);

    icon_data_file_name: string;
    if icon_file_path.count {
        icon_data_file_name = "icon_data.icns";
        convert_image_to_icns(icon_file_path, tprint("%/%", resources_path, icon_data_file_name));
    }

    if write_plist {
        builder: String_Builder;
        plist_start(*builder);
        if icon_data_file_name.count {
            success := plist_write_key_value(*builder, "CFBundleIconFile", icon_data_file_name);
            assert(success);
        }
        plist_end(*builder);
        output := builder_to_string(*builder);
        write_entire_file(tprint("%/Contents/Info.plist", app_bundle_name), output);
        free(output);
    }

    return app_bundle_name, resources_path;
}

make_app_bundle_subdirectories :: (app_bundle_name: string) -> macos_folder_path: string, resources_path: string {
    resources_path := tprint("%/Contents/Resources", app_bundle_name);
    macos_path     := tprint("%/Contents/MacOS", app_bundle_name);

    make_directory_if_it_does_not_exist(app_bundle_name);
    make_directory_if_it_does_not_exist(tprint("%/Contents", app_bundle_name));
    make_directory_if_it_does_not_exist(macos_path);
    make_directory_if_it_does_not_exist(resources_path);

    return macos_path, resources_path;
}

convert_image_to_icns :: (input_path: string, output_path: string) -> bool {
    process_result, output, error := run_command("sips", "-s", "format", "icns", input_path, "--out", output_path);
    return process_result.exit_code == 0;
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
    if value.type.type != .BOOL && value.type.type != .STRING return false;
    plist_write_key(builder, key);
    if value.type.type == .BOOL plist_write_bool(builder, (cast(*bool) value.value_pointer).*);
    else plist_write_string(builder, (cast(*string) value.value_pointer).*);
    return true;
}

plist_write_key :: (builder: *String_Builder, key: string) {
    append(builder, "<key>");
    append_xml_text(builder, key);
    append(builder, "</key>");
}

plist_write_string :: (builder: *String_Builder, str: string) {
    append(builder, "<string>\n");
    append_xml_text(builder, str);
    append(builder, "</string>\n");
}

plist_write_bool :: (builder: *String_Builder, value: bool) {
    if value append(builder, "<true/>");
    else append(builder, "<false/>");
}

#scope_file
#import "Basic";
#import "Process";
#import "File";
#import "File_Utilities";
#import "String";
#import "POSIX";

copy_files_recursively :: (source: string, dest: string) {
    paths: [2] string;
    paths[0] = source;
    paths[1] = dest;

    visitor :: (info: *File_Visit_Info, paths: [2] string) {
        relative_path := info.full_name;
        advance(*relative_path, paths[0].count);
        out_path := join(paths[1], "/", relative_path);
        make_directory_if_it_does_not_exist(path_strip_filename(out_path), recursive = true);
        copy_file(info.full_name, out_path);
    }

    res := visit_files(paths[0], true, paths, visitor);
    assert(res);
}

append_xml_text :: (builder: *String_Builder, text: string) {
    for byte: text {
        if byte == #char "&" append(builder, "&amp;");
        else if byte == #char "<" append(builder, "&lt;");
        else if byte == #char ">" append(builder, "&gt;");
        else append(builder, *byte, 1);
    }
}
