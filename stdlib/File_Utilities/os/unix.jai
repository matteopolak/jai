#import "POSIX";

file_exists :: (file_path: string) -> bool {
    return access(temp_c_string(file_path), 0) == 0;
}

file_modtime_and_size :: (file_path: string) -> (modtime: Apollo_Time, size: s64, success: bool) {
    value: stat_t;
    if stat(temp_c_string(file_path), *value) != 0 return .{}, 0, false;
    return timespec_to_apollo(value.st_mtime), value.st_size, true;
}

atomic_file_replace_or_just_rename_if_destination_file_does_not_exist :: (old_filename: string, new_filename: string) -> bool {
    return file_move(old_filename, new_filename);
}

is_directory :: (path: string) -> bool, success: bool {
    stats: stat_t;
    if stat(temp_c_string(path), *stats) != 0 return false, false;
    return S_ISDIR(stats.st_mode), true;
}

#scope_module
same_file :: (source: string, destination: string) -> bool {
    a: stat_t;
    b: stat_t;
    if stat(temp_c_string(source), *a) != 0 || stat(temp_c_string(destination), *b) != 0 return false;
    return a.st_dev == b.st_dev && a.st_ino == b.st_ino;
}

directory_entries :: (path: string) -> [] File_Visit_Info, bool {
    result: [..] File_Visit_Info;
    result.allocator = temp;
    stream := opendir(temp_c_string(path));
    if !stream return result, false;
    defer closedir(stream);
    while true {
        set_errno(cast(OS_Error_Code) 0);
        native_entry := readdir(stream);
        if !native_entry {
            if errno() != 0 return result, false;
            break;
        }
        short_name := to_string(native_entry.d_name.data);
        if short_name == "." || short_name == ".." continue;
        info: File_Visit_Info;
        info.short_name = copy_temporary_string(short_name);
        info.full_name = Strings.join(path, "/", short_name);
        value: stat_t;
        filename := temp_c_string(info.full_name);
        if lstat(filename, *value) != 0 {
            info.had_error = true;
        } else {
            info.is_symlink = (value.st_mode & 0xf000) == 0xa000;
            if info.is_symlink && stat(filename, *value) != 0 info.had_error = true;
            info.is_directory = S_ISDIR(value.st_mode);
            info.modification_time = timespec_to_apollo(value.st_mtime);
        }
        array_add(*result, info);
    }
    return result, true;
}
