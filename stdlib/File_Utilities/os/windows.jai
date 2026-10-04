#load "../../File/windows-encoding.jai";
Windows :: #import "Windows";
Utf8 :: #import "Windows_Utf8";

file_exists :: (file_path: string) -> bool {
    return Windows.GetFileAttributesW(os_utf8_to_wide(file_path)) != 0xffff_ffff;
}
file_modtime_and_size :: (file_path: string) -> (modtime: Apollo_Time, size: s64, success: bool) {
    info: File_Attribute_Data;
    if !native_file_attributes(os_utf8_to_wide(file_path), 0, *info) return .{}, 0, false;
    size := (cast(s64) info.nFileSizeHigh << 32) | info.nFileSizeLow;
    return filetime_to_apollo(info.ftLastWriteTime), size, true;
}
atomic_file_replace_or_just_rename_if_destination_file_does_not_exist :: (old_filename: string, new_filename: string) -> bool {
    return Windows.MoveFileExW(os_utf8_to_wide(old_filename), os_utf8_to_wide(new_filename), 1 | 8) != 0;
}

is_directory :: (path: string) -> bool, success: bool {
    attrib := Windows.GetFileAttributesW(os_utf8_to_wide(path));
    if attrib == 0xffff_ffff return false, false;
    return (attrib & Windows.FILE_ATTRIBUTE_DIRECTORY) != 0, true;
}

#scope_module
same_file :: (source: string, destination: string) -> bool {
    a := Windows.CreateFileW(os_utf8_to_wide(source), 0, 7, null, 3, 0x02000000, null);
    if a == cast(Windows.HANDLE) -1 return false;
    defer Windows.CloseHandle(a);
    b := Windows.CreateFileW(os_utf8_to_wide(destination), 0, 7, null, 3, 0x02000000, null);
    if b == cast(Windows.HANDLE) -1 return false;
    defer Windows.CloseHandle(b);
    a_id: File_Identity;
    b_id: File_Identity;
    if !Windows.GetFileInformationByHandleEx(a, cast(Windows.FILE_INFO_BY_HANDLE_CLASS) 18, *a_id, size_of(File_Identity)) || !Windows.GetFileInformationByHandleEx(b, cast(Windows.FILE_INFO_BY_HANDLE_CLASS) 18, *b_id, size_of(File_Identity)) return false;
    return a_id.volume == b_id.volume && memcmp(a_id.identifier.data, b_id.identifier.data, 16) == 0;
}
File_Identity :: struct { volume: u64; identifier: [16] u8; }
File_Attribute_Data :: struct {
    dwFileAttributes: u32;
    ftCreationTime: Windows.FILETIME;
    ftLastAccessTime: Windows.FILETIME;
    ftLastWriteTime: Windows.FILETIME;
    nFileSizeHigh: u32;
    nFileSizeLow: u32;
}
utility_kernel :: #system_library "kernel32";
native_file_attributes :: (name: *u16, level: s32, attributes: *File_Attribute_Data) -> s32 #foreign utility_kernel "GetFileAttributesExW";
directory_entries :: (path: string) -> [] File_Visit_Info, bool {
    result: [..] File_Visit_Info;
    result.allocator = temp;
    native: Windows.WIN32_FIND_DATAW;
    pattern := Strings.join(path, "/*");
    search := Windows.FindFirstFileW(os_utf8_to_wide(pattern), *native);
    if search == cast(Windows.HANDLE) -1 return result, false;
    defer Windows.FindClose(search);
    while true {
        name := os_wide_to_utf8(native.cFileName.data);
        if name != "." && name != ".." {
            info: File_Visit_Info;
            info.short_name = name;
            info.full_name = Strings.join(path, "/", name);
            info.is_directory = (native.dwFileAttributes & 0x10) != 0;
            info.is_symlink = (native.dwFileAttributes & 0x400) != 0;
            info.modification_time = filetime_to_apollo(native.ftLastWriteTime);
            array_add(*result, info);
        }
        if !Windows.FindNextFileW(search, *native) {
            if cast(u32) Windows.GetLastError() != 18 return result, false;
            break;
        }
    }
    return result, true;
}
