// Independently authored classic ZIP central-directory reader.
Zip_Entry :: struct {
    filename: string;
    position_in_file: s64;
    version_made_by: u16;
    version_needed_to_extract: u16;
    bit_flag: u16;
    crc: u32;
    compressed_len: u32;
    chunk_len: u32;
    name_len: u16;
    extra_field_len: u16;
    file_comment_len: u16;
    internal_attributes: u16;
    external_attributes: u32;
    chunk_offset: u32;
}

Zip_Directory :: struct {
    name := "";
    entries: [..] Zip_Entry;
    memory_block: string;
    file: File;
}

// The open file belongs to the caller; this releases only directory storage.
deinit :: (dir: *Zip_Directory) {
    if !dir return;
    free(dir.name);
    free(dir.entries.data);
    free(dir.memory_block);
    dir.name = "";
    dir.entries.data = null;
    dir.entries.count = 0;
    dir.entries.allocated = 0;
    dir.memory_block = "";
}

load_zip_directory :: (zip_filename: string, close_file := true) -> (success: bool, dir: Zip_Directory) {
    empty: Zip_Directory;
    opened, ok := file_open(zip_filename, true, true);
    if !ok return false, empty;
    success, dir := zip_read_directory(zip_filename, opened);
    if !success {
        deinit(*dir);
        file_close(*dir.file);
        return false, empty;
    }
    if close_file file_close(*dir.file);
    return true, dir;
}

#scope_file
zip_read_directory :: (zip_filename: string, opened: File) -> bool, Zip_Directory {
    dir: Zip_Directory;
    dir.file = opened;
    length, measured := file_length(dir.file);
    if !measured || length < 22 return false, dir;
    window := length;
    if window > 65557 window = 65557;
    tail := alloc_string(window);
    if !tail.data return false, dir;
    defer free(tail);
    if !file_set_position(dir.file, length - window) return false, dir;
    read_ok, received := file_read(dir.file, tail.data, tail.count);
    if !read_ok || received != tail.count return false, dir;

    end: s64 = -1;
    scan := window - 22;
    while scan >= 0 {
        if zip_u32(tail.data + scan) == 0x06054b50 {
            comment_length := cast(s64) zip_u16(tail.data + scan + 20);
            if scan + 22 + comment_length == window {
                end = scan;
                break;
            }
        }
        scan -= 1;
    }
    if end < 0 return false, dir;
    p := tail.data + end;
    if zip_u16(p + 4) != 0 || zip_u16(p + 6) != 0 return false, dir;
    count := zip_u16(p + 10);
    if zip_u16(p + 8) != count || count == 0xffff return false, dir;
    directory_size := cast(s64) zip_u32(p + 12);
    directory_start := cast(s64) zip_u32(p + 16);
    if directory_size == 0xffff_ffff || directory_start == 0xffff_ffff return false, dir;
    end_position := length - window + end;
    if directory_start > end_position || directory_size > end_position - directory_start return false, dir;
    if cast(s64) count * 46 > directory_size return false, dir;
    if directory_size > 0 {
        dir.memory_block = alloc_string(directory_size);
        if !dir.memory_block.data return false, dir;
        if !file_set_position(dir.file, directory_start) return false, dir;
        read_ok, received = file_read(dir.file, dir.memory_block.data, directory_size);
        if !read_ok || received != directory_size return false, dir;
    }
    if count > 0 {
        bytes := cast(s64) count * size_of(Zip_Entry);
        dir.entries.data = cast(*Zip_Entry) alloc(bytes);
        if !dir.entries.data return false, dir;
        dir.entries.allocated = count;
        storage := cast(*Resizable_Array) *dir.entries;
        storage.allocator = context.allocator;
        memset(dir.entries.data, 0, bytes);
    }

    offset: s64 = 0;
    for i: 0..cast(s64) count-1 {
        if offset > directory_size - 46 return false, dir;
        p = dir.memory_block.data + offset;
        if zip_u32(p) != 0x02014b50 || zip_u16(p + 34) != 0 return false, dir;
        entry: Zip_Entry;
        entry.position_in_file = directory_start + offset;
        entry.version_made_by = zip_u16(p + 4);
        entry.version_needed_to_extract = zip_u16(p + 6);
        entry.bit_flag = zip_u16(p + 8);
        entry.crc = zip_u32(p + 16);
        entry.compressed_len = zip_u32(p + 20);
        entry.chunk_len = zip_u32(p + 24);
        entry.name_len = zip_u16(p + 28);
        entry.extra_field_len = zip_u16(p + 30);
        entry.file_comment_len = zip_u16(p + 32);
        entry.internal_attributes = zip_u16(p + 36);
        entry.external_attributes = zip_u32(p + 38);
        local_start := cast(s64) zip_u32(p + 42);
        if entry.compressed_len == 0xffff_ffff || entry.chunk_len == 0xffff_ffff || local_start == 0xffff_ffff return false, dir;
        span := cast(s64) 46 + entry.name_len + entry.extra_field_len + entry.file_comment_len;
        if span > directory_size - offset return false, dir;
        entry.filename.data = p + 46;
        entry.filename.count = entry.name_len;
        // Use the local header's extra-field length, which can differ from the directory.
        if local_start > directory_start - 30 return false, dir;
        header: [30] u8;
        if !file_set_position(dir.file, local_start) return false, dir;
        read_ok, received = file_read(dir.file, header.data, 30);
        if !read_ok || received != 30 || zip_u32(header.data) != 0x04034b50 return false, dir;
        payload := local_start + 30 + zip_u16(header.data + 26) + zip_u16(header.data + 28);
        if payload > directory_start || entry.compressed_len > directory_start - payload || payload > 0xffff_ffff return false, dir;
        entry.chunk_offset = cast(u32) payload;
        dir.entries.data[i] = entry;
        dir.entries.count += 1;
        offset += span;
    }
    dir.name = alloc_string(zip_filename.count);
    if zip_filename.count > 0 {
        if !dir.name.data return false, dir;
        memcpy(dir.name.data, zip_filename.data, zip_filename.count);
    }
    return true, dir;
}

#import "Basic";
#import "File";
zip_u16 :: (p: *u8) -> u16 { return (cast(u16) p[0]) | ((cast(u16) p[1]) << 8); }
zip_u32 :: (p: *u8) -> u32 {
    return (cast(u32) p[0]) | ((cast(u32) p[1]) << 8) | ((cast(u32) p[2]) << 16) | ((cast(u32) p[3]) << 24);
}
