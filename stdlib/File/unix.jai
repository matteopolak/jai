#import "POSIX";

File :: struct { handle: s64; }

file_open :: (name: string, for_writing := false, keep_existing_content := false, log_errors := true) -> File, bool {
    mode := "rb";
    if for_writing {
        mode = "wb";
        if keep_existing_content mode = "ab+";
    }
    stream := fopen(temp_c_string(name), temp_c_string(mode));
    if !stream && log_errors log_error("Unable to open '%'", name);
    return .{cast(s64) stream}, stream != null;
}

file_close :: (file: *File) -> bool {
    if !is_valid(file.*) return true;
    result := fclose(native_handle(file.*)) == 0;
    file.handle = 0;
    return result;
}
is_valid :: (file: File) -> bool { return file.handle != 0; }

file_read_checked :: (f: File, vdata: *void, bytes_to_read: s64) -> (success: bool, total_read: s64) {
    if !is_valid(f) || bytes_to_read < 0 || (!vdata && bytes_to_read > 0) return false, 0;
    cursor: s64;
    while cursor < bytes_to_read {
        amount := fread(cast(*u8) vdata + cursor, 1, cast(u64) (bytes_to_read - cursor), native_handle(f));
        if amount <= 0 return feof(native_handle(f)) != 0, cursor;
        cursor += cast(s64) amount;
    }
    return true, cursor;
}

file_write :: (file: *File, data: *void, length: s64) -> bool {
    if !is_valid(file.*) || length < 0 || (!data && length > 0) return false;
    offset: s64;
    while offset < length {
        amount := fwrite(cast(*u8) data + offset, 1, cast(u64) (length - offset), native_handle(file.*));
        if amount <= 0 return false;
        offset += cast(s64) amount;
    }
    return true;
}

file_seek :: (file: File, pos: s64, type: Seek_Type) -> (success: bool) {
    if !is_valid(file) return false;
    return fseek(native_handle(file), pos, cast(s32) type) == 0;
}
file_tell :: (file: File) -> (success: bool, position: s64) {
    if !is_valid(file) return false, -1;
    value := ftello(native_handle(file));
    return value >= 0, value;
}
file_current_position :: (f: File) -> s64, bool {
    success, value := file_tell(f);
    return value, success;
}
file_set_position :: (f: File, pos: s64) -> bool { return file_seek(f, pos, .START); }
file_length_checked :: (file: File) -> (length: s64, success: bool) {
    old, valid := file_current_position(file);
    if !valid || !file_seek(file, 0, .END) return 0, false;
    size, measured := file_current_position(file);
    restored := file_set_position(file, old);
    return size, measured && restored;
}

file_move :: (name_old: string, name_new: string) -> bool {
    return rename(temp_c_string(name_old), temp_c_string(name_new)) == 0;
}
file_delete :: (filename: string) -> bool { return unlink(temp_c_string(filename)) == 0; }
file_exists :: (path: string) -> bool { return access(temp_c_string(path), 0) == 0; }
file_link :: (linkpath: string, filepath: string) -> bool {
    return link(temp_c_string(filepath), temp_c_string(linkpath)) == 0;
}
delete_directory :: (dirname: string) -> bool {
    stream := opendir(temp_c_string(dirname));
    if !stream return false;
    success := true;
    while true {
        set_errno(cast(OS_Error_Code) 0);
        entry := readdir(stream);
        if !entry { if errno() != 0 success = false; break; }
        name := to_string(entry.d_name.data);
        if name == "." || name == ".." continue;
        path := Strings.join(dirname, "/", name);
        state: stat_t;
        if lstat(temp_c_string(path), *state) != 0 { success = false; break; }
        if S_ISDIR(state.st_mode) {
            if !delete_directory(path) { success = false; break; }
        } else if !file_delete(path) { success = false; break; }
    }
    if closedir(stream) != 0 success = false;
    if !success return false;
    return rmdir(temp_c_string(dirname)) == 0;
}
os_make_directory_if_it_does_not_exist :: (name: string) -> directory_now_exists: bool {
    return make_directory_helper(name, 511);
}
make_directory_helper :: (dir_name: string, attribs: mode_t) -> directory_now_exists: bool {
    c_name := temp_c_string(dir_name);
    if mkdir(c_name, attribs) == 0 return true;
    state: stat_t;
    return stat(c_name, *state) == 0 && S_ISDIR(state.st_mode);
}
get_absolute_path_unix :: (relative_path: string) -> string, success: bool {
    resolved := realpath(temp_c_string(relative_path), null);
    if !resolved return "", false;
    result := copy_temporary_string(to_string(resolved));
    c_free(resolved);
    return result, true;
}

#scope_file
native_handle :: (file: File) -> *FILE { return cast(*FILE) file.handle; }
native_libc :: #system_library "c";
c_free :: (memory: *void) #foreign native_libc "free";
