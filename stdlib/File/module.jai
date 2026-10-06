// Repository-authored synchronous stream algorithms; native calls are SDK boundaries.
#import "Basic";
Strings :: #import "String";

Seek_Type :: enum {
    START :: 0;
    CURRENT :: 1;
    END :: 2;
}

#if OS == .WINDOWS {
    #load "windows.jai";
} else {
    #load "unix.jai";
}

file_write :: inline (file: *File, data: string) -> bool {
    return file_write(file, data.data, data.count);
}

file_write :: (file: *File, builder: *String_Builder, do_reset := true) -> bool {
    defer if do_reset reset(builder);
    part := get_base_buffer(builder);
    while part {
        if !file_write(file, get_buffer_data(part), part.count) return false;
        part = part.next;
    }
    return true;
}

write_entire_file :: inline (name: string, data: string) -> bool {
    return write_entire_file(name, data.data, data.count);
}

write_entire_file :: (name: string, data: *void, count: int) -> bool {
    if count < 0 return false;
    output, opened := file_open(name, for_writing = true);
    if !opened return false;
    written := file_write(*output, data, count);
    closed := file_close(*output);
    return written && closed;
}

write_entire_file :: (name: string, builder: *String_Builder, do_reset := true) -> bool {
    defer if do_reset reset(builder);
    output, opened := file_open(name, for_writing = true);
    if !opened return false;
    written := file_write(*output, builder, false);
    closed := file_close(*output);
    return written && closed;
}

read_entire_file :: (path: string, zero_terminated := false, log_errors := true) -> (contents: string, success: bool) {
    return read_entire_file_terminated(path, zero_terminated, log_errors);
}

read_entire_file_terminated :: (name: string, zero_terminated := false, log_errors := true) -> string, bool {
    input, opened := file_open(name, log_errors = log_errors);
    if !opened return "", false;
    defer file_close(*input);
    return read_entire_file(input, zero_terminated);
}

read_entire_file :: (f: File, zero_terminated := false) -> string, bool {
    length, measured := file_length_checked(f);
    if !measured || length < 0 || length == 0x7fff_ffff_ffff_ffff return "", false;
    if !file_set_position(f, 0) return "", false;
    allocation_size := length;
    if zero_terminated allocation_size += 1;
    if allocation_size == 0 return "", true;
    bytes := cast(*u8) alloc(allocation_size);
    if !bytes return "", false;
    success, received := file_read_checked(f, bytes, length);
    if !success || received != length {
        free(bytes);
        return "", false;
    }
    if zero_terminated bytes[length] = 0;
    return .{ length, bytes }, true;
}

USE_MAP_FILE :: (OS == .WINDOWS);
STORE_MAPPED_FILENAMES :: false;
Map_File_Info :: struct {
    data: string;
    #if STORE_MAPPED_FILENAMES {
        filename: string;
    }
    #if USE_MAP_FILE {
        map_info: File_Map_Info;
    }
}

string_to_map_file_info :: (data: string) -> Map_File_Info {
    result: Map_File_Info;
    result.data = data;
    return result;
}

map_entire_file_start :: (name: string, log_errors := true) -> Map_File_Info, bool {
    result: Map_File_Info;
    #if USE_MAP_FILE {
        mapping, success := map_file(name, log_errors);
        if !success return result, false;
        result.map_info = mapping;
        result.data = mapping.data;
    } else {
        bytes, success := read_entire_file_terminated(name, false, log_errors);
        if !success return result, false;
        result.data = bytes;
    }
    #if STORE_MAPPED_FILENAMES {
        result.filename = copy_string(name);
    }
    return result, true;
}

map_entire_file_end :: (file_info: *Map_File_Info) {
    #if USE_MAP_FILE {
        munmap_file(*file_info.map_info);
    } else {
        free(file_info.data);
    }
    #if STORE_MAPPED_FILENAMES {
        free(file_info.filename);
    }
    file_info.* = .{};
}

make_directory_if_it_does_not_exist :: (name: string, recursive := false) -> directory_now_exists: bool {
    if !name return false;
    if recursive {
        for i: 0..name.count - 1 {
            separator := name[i] == #char "/";
            #if OS == .WINDOWS {
                separator = separator || name[i] == #char "\\";
            }
            if separator && i > 0 {
                #if OS == .WINDOWS {
                    if i == 2 && name[1] == #char ":" continue;
                }
                if !os_make_directory_if_it_does_not_exist(Strings.slice(name, 0, i)) return false;
            }
        }
    }
    return os_make_directory_if_it_does_not_exist(name);
}

get_absolute_path :: inline (relative_path: string) -> string, success: bool {
    #if OS == .WINDOWS {
        return get_absolute_path_windows(relative_path);
    } else {
        return get_absolute_path_unix(relative_path);
    }
}

file_length :: (file: File) -> (length: s64, success: bool) {
    return file_length_checked(file);
}

// Reads up to `bytes_to_read`; reaching the end of the file early still succeeds, with
// the shorter `total_read`.
file_read :: (f: File, vdata: *void, bytes_to_read: s64) -> (success: bool, total_read: s64) {
    if bytes_to_read <= 0 || !vdata return false, 0;
    return file_read_checked(f, vdata, bytes_to_read);
}
