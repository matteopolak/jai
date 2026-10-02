#scope_file
Basic :: #import "Basic";
String :: #import "String";
File :: #import "File";
Hash_Table :: #import "Hash_Table";
#scope_export
Text_File_Handler :: struct {
    short_name: string;
    full_path: string;
    comment_character: u8 = #char "#";
    do_version_number := true;
    strip_comments_from_ends_of_lines := true;
    auto_skip_blank_lines := true;
    file_data_to_free: string;
    file_data: string;
    failed := false;
    version := -1;
    line_number := 0;
}
deinit :: (using x: *Text_File_Handler) {
    Basic.free(file_data_to_free);
    file_data_to_free = ""; file_data = "";
}
start_file :: (handler: *Text_File_Handler, short_name: string, full_path: string, optional := false, loc := #caller_location) {
    data, ok := File.read_entire_file(full_path, log_errors=!optional);
    if !ok {
        deinit(handler);
        handler.short_name = short_name; handler.full_path = full_path;
        handler.version = -1; handler.line_number = 0;
        if !optional handler.failed = true;
        handler.file_data = "";
        return;
    }
    start_from_memory(handler, short_name, full_path, data, loc);
    handler.file_data_to_free = data;
}
start_from_memory :: (using handler: *Text_File_Handler, _short_name: string, _full_path: string, _file_data: string, loc := #caller_location) {
    if file_data_to_free.data Basic.free(file_data_to_free);
    file_data_to_free = "";
    short_name = _short_name; full_path = _full_path; file_data = _file_data;
    version = -1; line_number = 0;
    // Failure is sticky across starts so a caller can inspect the whole batch.
    if do_version_number {
        line, found := consume_next_line(handler);
        if !found || line.count < 3 || line[0] != 91 || line[line.count-1] != 93 {
            failed = true; return;
        }
        value, ok := String.string_to_int(String.slice(line, 1, line.count-2));
        if !ok { failed = true; return; }
        version = value;
    }
}
consume_next_line :: (sp: *string) -> string, bool {
    if sp.count == 0 return "", false;
    n := 0;
    while n < sp.count && sp.data[n] != 10 && sp.data[n] != 13 n += 1;
    line := String.slice(sp.*, 0, n);
    consumed := n;
    if consumed < sp.count {
        first := sp.data[consumed]; consumed += 1;
        if first == 13 && consumed < sp.count && sp.data[consumed] == 10 consumed += 1;
    }
    sp.data += consumed; sp.count -= consumed;
    return line, true;
}
consume_next_line :: (handler: *Text_File_Handler) -> line: string, found: bool {
    while true {
        line, found := consume_next_line(*handler.file_data);
        if !found return "", false;
        handler.line_number += 1;
        line = String.trim(line);
        if handler.strip_comments_from_ends_of_lines {
            index := String.find_index_from_left(line, handler.comment_character);
            if index >= 0 line = String.trim_right(String.slice(line, 0, index));
        } else if line.count > 0 && line[0] == handler.comment_character continue;
        if handler.auto_skip_blank_lines && line.count == 0 continue;
        return line, true;
    }
}
break_by_spaces :: (line: string) -> left: string, right: string {
    line = String.trim_left(line);
    index := String.find_index_of_any_from_left(line, String.DEFAULT_SPACES);
    if index < 0 return line, "";
    return String.slice(line, 0, index), String.trim_left(String.slice(line, index, line.count-index));
}
error :: (handler: Text_File_Handler, format: string, args: .. Any, flags := Log_Flags.NONE, loc := #caller_location) {
    message := Basic.sprint(format, ..args);
    Basic.log_error("Line % of '%': %", handler.line_number, handler.full_path, message, flags=flags, loc=loc);
    Basic.free(message);
}
warn :: (handler: Text_File_Handler, format: string, args: .. Any, flags := Log_Flags.NONE, loc := #caller_location) {
    message := Basic.sprint(format, ..args);
    Basic.log_warning("Line % of '%': %", handler.line_number, handler.full_path, message, flags=flags, loc=loc);
    Basic.free(message);
}
file_to_array :: (filename: string, do_trim := true, skip_blank_lines := true, do_version_number := false, use_data_from_memory := false, data_from_memory := "", loc := #caller_location) -> success: bool, array: [..] string {
    handler: Text_File_Handler;
    handler.do_version_number = do_version_number; handler.auto_skip_blank_lines = skip_blank_lines;
    if use_data_from_memory start_from_memory(*handler, filename, filename, data_from_memory, loc);
    else start_file(*handler, filename, filename, loc=loc);
    array: [..] string;
    while true {
        line, found := consume_next_line(*handler.file_data);
        if !found break;
        handler.line_number += 1;
        comment := String.find_index_from_left(line, handler.comment_character);
        if comment >= 0 line = String.slice(line, 0, comment);
        if do_trim line = String.trim(line);
        if skip_blank_lines && String.trim(line).count == 0 continue;
        Basic.array_add(*array, Basic.copy_string(line));
    }
    deinit(*handler);
    return !handler.failed, array;
}
file_to_table :: (filename: string, do_trim := true, skip_blank_lines := true, do_version_number := false, use_data_from_memory := false, data_from_memory := "", loc := #caller_location) -> success: bool, table: Hash_Table.Table(string, void) {
    success, lines := file_to_array(filename, do_trim, skip_blank_lines, do_version_number, use_data_from_memory, data_from_memory, loc);
    table: Hash_Table.Table(string, void);
    for line: lines {
        if Hash_Table.table_contains(*table, line) { Basic.free(line); continue; }
        empty: void; Hash_Table.table_set(*table, line, empty);
    }
    Basic.array_free(*lines);
    return success, table;
}
