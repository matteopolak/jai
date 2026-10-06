// Test-only in-memory seekable file, exercising parser source without native I/O.
File :: struct {
    handle: *Stream;
}
Stream :: struct {
    position: s64;
    closed: bool;
}
archive: string;
stream: Stream;
file_open :: (name: string, for_writing := false, keep_existing_content := false, log_errors := true) -> File, bool {
    stream.position = 0;
    stream.closed = false;
    result: File;
    result.handle = *stream;
    return result, true;
}
file_close :: (file: *File) {
    if file.handle file.handle.closed = true;
    file.handle = null;
}
file_length :: (file: File) -> s64, bool {
    return archive.count, file.handle != null;
}
file_set_position :: (file: File, pos: s64) -> bool {
    if !file.handle || file.handle.closed || pos < 0 || pos > archive.count return false;
    file.handle.position = pos;
    return true;
}
file_read :: (file: File, output: *void, count: s64) -> bool, s64 {
    if !file.handle || file.handle.closed || count < 0 || count > archive.count - file.handle.position return false, 0;
    memcpy(output, archive.data + file.handle.position, count);
    file.handle.position += count;
    return true, count;
}
read_entire_file :: (name: string, zero_terminated := false, log_errors := true) -> string, bool {
    return archive, true;
}
