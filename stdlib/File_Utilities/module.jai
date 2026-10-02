#import "Basic";
Strings :: #import "String";
#import "File";
#load "path.jai";

File_Visit_Details :: struct {
    short_name: string;
    full_name: string;
    modification_time: Apollo_Time;
    had_error: bool;
    is_symlink: bool;
    is_directory: bool;
    descend_into_directory: bool;
}

#if OS == .WINDOWS { #load "os/windows.jai"; }
else { #load "os/unix.jai"; }

copy_file :: (source: string, dest: string) -> bool {
    if source == dest || same_file(source, dest) return false;
    input, opened := file_open(source);
    if !opened return false;
    defer file_close(*input);
    output, created := file_open(dest, for_writing = true);
    if !created return false;
    defer file_close(*output);
    buffer: [65536] u8;
    while true {
        read_ok, received := file_read_checked(input, buffer.data, buffer.count);
        if !read_ok return false;
        if received > 0 && !file_write(*output, buffer.data, received) return false;
        if received < buffer.count return true;
    }
}

visit_files_detailed :: (dir_name: string, recursive: bool, user_data: $T, proc: (info: *File_Visit_Details, user_data: T), visit_files := true, visit_directories := false, visit_symlinks := true, follow_directory_symlinks := true) -> bool {
    if !proc return true;
    pending: [..] string;
    pending.allocator = temp;
    visited: [..] string;
    visited.allocator = temp;
    array_add(*pending, dir_name);
    cursor: int;
    while cursor < pending.count {
        directory := pending[cursor];
        cursor += 1;
        canonical, resolved := get_absolute_path(directory);
        if !resolved return false;
        already_seen := false;
        for seen: visited if seen == canonical { already_seen = true; break; }
        if already_seen continue;
        array_add(*visited, canonical);
        entries, scanned := directory_entries(directory);
        if !scanned return false;
        for entry: entries {
            info := entry;
            info.descend_into_directory = recursive && info.is_directory && (!info.is_symlink || follow_directory_symlinks) && !info.had_error;
            selected := visit_files && !info.is_directory || visit_directories && info.is_directory;
            if selected && (visit_symlinks || !info.is_symlink) proc(*info, user_data);
            if info.descend_into_directory array_add(*pending, info.full_name);
        }
    }
    return true;
}

copy_directory :: (source: string, dest: string) {
    if !make_directory_if_it_does_not_exist(dest, true) return;
    Copy_State :: struct { source: string; destination: string; }
    state: Copy_State = .{source, dest};
    visitor :: (info: *File_Visit_Details, state: Copy_State) {
        suffix := Strings.slice(info.full_name, state.source.count, info.full_name.count - state.source.count);
        output := Strings.join(state.destination, suffix);
        if info.is_directory make_directory_if_it_does_not_exist(output, true);
        else copy_file(info.full_name, output);
    }
    visit_files_detailed(source, true, state, visitor, visit_directories = true);
}

file_list :: (path: string, recursive := false, follow_directory_symlinks := true) -> [] string #must {
    result: [..] string;
    visitor :: (info: *File_Visit_Details, output: *[..] string) {
        array_add(output, copy_string(info.full_name));
    }
    visit_files_detailed(path, recursive, *result, visitor, follow_directory_symlinks = follow_directory_symlinks);
    return result;
}

visit_files :: (start_path: string, recursive: bool, user_data: $User_Data, visitor: $Visitor, visit_files := true, visit_directories := false) -> bool {
    Adapter :: struct { user_data: User_Data; visitor: Visitor; }
    adapter: Adapter = .{user_data, visitor};
    forward :: (details: *File_Visit_Details, adapter: Adapter) {
        info: File_Visit_Info;
        info.short_name = details.short_name;
        info.full_name = details.full_name;
        info.descend_into_directory = details.descend_into_directory;
        adapter.visitor(*info, adapter.user_data);
        details.descend_into_directory = info.descend_into_directory;
    }
    return visit_files_detailed(start_path, recursive, adapter, forward, visit_files, visit_directories, true, true);
}
