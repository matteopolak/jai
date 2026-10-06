#load "windows-encoding.jai";
Windows :: #import "Windows";
Windows_Utf8 :: #import "Windows_Utf8";
HANDLE :: Windows.HANDLE;
INVALID_HANDLE_VALUE :: cast(HANDLE) -1;
File :: struct {
    handle: s64;
}

file_open :: (name: string, for_writing := false, keep_existing_content := false, log_errors := false) -> File, bool {
    access: u32 = 0x80000000;
    creation: u32 = 3;
    if for_writing {
        // Writing handles read as well, as the POSIX side's "ab+" does (Zip_File_Directory
        // reads through one).
        access |= 0x40000000;
        creation = 2;
    }
    if for_writing && keep_existing_content creation = 4;
    wide := os_utf8_to_wide(name);
    handle := Windows.CreateFileW(wide, access, 3, null, creation, 0x80, null);
    result: File = .{ cast(s64) handle };
    success := is_valid(result);
    if success && for_writing && keep_existing_content {
        success = file_seek(result, 0, .END);
        if !success file_close(*result);
    }
    if !success && log_errors log_error("Unable to open '%'", name);
    return result, success;
}
file_close :: (file: *File) -> bool {
    if !is_valid(file.*) return true;
    success := Windows.CloseHandle(native_handle(file.*)) != 0;
    file.handle = 0;
    return success;
}
is_valid :: (file: File) -> bool {
    return file.handle != 0 && file.handle != -1;
}

file_read_checked :: (f: File, vdata: *void, bytes_to_read: s64) -> (success: bool, total_read: s64) {
    if !is_valid(f) || bytes_to_read < 0 || (!vdata && bytes_to_read > 0) return false, 0;
    done: s64;
    while done < bytes_to_read {
        remaining := bytes_to_read - done;
        request: u32 = xx min(remaining, 0x7fff_ffff);
        received: u32;
        if !Windows.ReadFile(native_handle(f), cast(*u8) vdata + done, request, *received, null) return false, done;
        if received == 0 return true, done;
        done += received;
    }
    return true, done;
}
file_write :: (file: *File, data: *void, length: s64) -> bool {
    if !is_valid(file.*) || length < 0 || (!data && length > 0) return false;
    done: s64;
    while done < length {
        request: u32 = xx min(length - done, 0x7fff_ffff);
        written: u32;
        if !Windows.WriteFile(native_handle(file.*), cast(*u8) data + done, request, *written, null) || written == 0 return false;
        done += written;
    }
    return true;
}
file_seek :: (file: File, pos: s64, type: Seek_Type) -> (success: bool) {
    displacement := cast(Windows.LARGE_INTEGER_S64) pos;
    return is_valid(file) && Windows.SetFilePointerEx(native_handle(file), displacement, null, cast(Windows.SetFilePointer_MoveMethod) type) != 0;
}
file_tell :: (file: File) -> (success: bool, position: s64) {
    zero: Windows.LARGE_INTEGER_S64;
    result: Windows.LARGE_INTEGER_S64;
    success := is_valid(file) && Windows.SetFilePointerEx(native_handle(file), zero, *result, .FILE_CURRENT) != 0;
    return success, cast(s64) result;
}
file_current_position :: (f: File) -> s64, bool {
    success, value := file_tell(f);
    return value, success;
}
file_set_position :: (f: File, pos: s64) -> bool {
    return file_seek(f, pos, .START);
}
file_length_checked :: (file: File) -> s64, bool {
    result: Windows.LARGE_INTEGER;
    success := is_valid(file) && Windows.GetFileSizeEx(native_handle(file), *result) != 0;
    return result.QuadPart, success;
}
file_move :: (name_old: string, name_new: string) -> bool {
    return Windows.MoveFileExW(os_utf8_to_wide(name_old), os_utf8_to_wide(name_new), 1) != 0;
}
file_delete :: (filename: string) -> bool {
    return Windows.DeleteFileW(os_utf8_to_wide(filename)) != 0;
}
file_exists :: (path: string) -> bool {
    return Windows.GetFileAttributesW(os_utf8_to_wide(path)) != 0xffff_ffff;
}
file_link :: (link: string, filepath: string) -> bool {
    return Windows.CreateHardLinkW(os_utf8_to_wide(link), os_utf8_to_wide(filepath), null) != 0;
}
delete_directory :: (dirname: string) -> bool {
    entry: Windows.WIN32_FIND_DATAW;
    search := Windows.FindFirstFileW(os_utf8_to_wide(Strings.join(dirname, "/*")), *entry);
    if search == cast(HANDLE) -1 return Windows.RemoveDirectoryW(os_utf8_to_wide(dirname)) != 0;
    success := true;
    while true {
        name := os_wide_to_utf8(entry.cFileName.data);
        if name != "." && name != ".." {
            path := Strings.join(dirname, "/", name);
            directory := (entry.dwFileAttributes & 0x10) != 0;
            symlink := (entry.dwFileAttributes & 0x400) != 0;
            if directory && !symlink success = delete_directory(path);
            else if directory success = Windows.RemoveDirectoryW(os_utf8_to_wide(path)) != 0;
            else success = file_delete(path);
            if !success break;
        }
        if !Windows.FindNextFileW(search, *entry) {
            success = cast(u32) Windows.GetLastError() == 18;
            break;
        }
    }
    Windows.FindClose(search);
    return success && Windows.RemoveDirectoryW(os_utf8_to_wide(dirname)) != 0;
}
os_make_directory_if_it_does_not_exist :: (name: string) -> directory_now_exists: bool {
    return make_directory_helper(name, null);
}
make_directory_helper :: (dir_name: string, attribs: *Windows.SECURITY_ATTRIBUTES) -> directory_now_exists: bool {
    name := os_utf8_to_wide(dir_name);
    if Windows.CreateDirectoryW(name, attribs) return true;
    attributes := Windows.GetFileAttributesW(name);
    return attributes != 0xffff_ffff && (attributes & 0x10) != 0;
}
get_absolute_path_windows :: (relative_path: string) -> string, success: bool {
    name := os_utf8_to_wide(relative_path);
    length := Windows.GetFullPathNameW(name, 0, null, null);
    if length == 0 return "", false;
    buffer := cast(*u16) alloc((length + 1) * 2, temp);
    actual := Windows.GetFullPathNameW(name, length + 1, buffer, null);
    if actual == 0 || actual > length return "", false;
    return os_wide_to_utf8(buffer, xx actual), true;
}

File_Map_Info :: struct {
    file: File = .{ -1 };
    mapping: HANDLE;
    data: string;
}
map_file :: (name: string, log_errors := true) -> File_Map_Info, bool {
    result: File_Map_Info;
    stream, opened := file_open(name, log_errors = log_errors);
    if !opened return result, false;
    size, measured := file_length_checked(stream);
    if !measured || size < 0 {
        file_close(*stream);
        return result, false;
    }
    if size == 0 {
        result.file = stream;
        return result, true;
    }
    mapping := Windows.CreateFileMappingW(native_handle(stream), null, 2, 0, 0, null);
    if !mapping {
        file_close(*stream);
        return result, false;
    }
    bytes := cast(*u8) Windows.MapViewOfFile(mapping, 4, 0, 0, 0);
    if !bytes {
        Windows.CloseHandle(mapping);
        file_close(*stream);
        return result, false;
    }
    result.file = stream;
    result.mapping = mapping;
    result.data = .{ size, bytes };
    return result, true;
}
munmap_file :: (file_map: *File_Map_Info) -> bool {
    success := true;
    if file_map.data.data success = Windows.UnmapViewOfFile(file_map.data.data) != 0;
    if file_map.mapping success = Windows.CloseHandle(file_map.mapping) != 0 && success;
    file_close(*file_map.file);
    file_map.* = .{};
    return success;
}
get_path_os_program_data :: () -> string {
    identifier: File_GUID = .{ 0x62ab5d82, 0xfdc1, 0x4dc3, .{ 0xa9, 0xdd, 0x07, 0x0d, 0x1d, 0x49, 0x5d, 0x97 } };
    return native_known_directory(identifier);
}
get_path_os_saved_games :: () -> string {
    identifier: File_GUID = .{ 0x4c5c32ff, 0xbb9d, 0x43b0, .{ 0xb5, 0xb4, 0x2d, 0x72, 0xe5, 0x4e, 0xaa, 0xa4 } };
    return native_known_directory(identifier);
}
#scope_file
native_handle :: (file: File) -> HANDLE {
    return cast(HANDLE) file.handle;
}
File_GUID :: struct {
    data1: u32;
    data2: u16;
    data3: u16;
    data4: [8] u8;
}
file_shell :: #system_library "shell32";
file_ole :: #system_library "ole32";
native_known_folder :: (identifier: *File_GUID, flags: u32, token: HANDLE, path: **u16) -> s32 #foreign file_shell "SHGetKnownFolderPath";
native_task_free :: (memory: *void) #foreign file_ole "CoTaskMemFree";
native_known_directory :: (identifier: File_GUID) -> string {
    value: *u16;
    if native_known_folder(*identifier, 0, null, *value) < 0 return "";
    defer native_task_free(value);
    return os_wide_to_utf8(value, temporary = false);
}
