// Writes, reads and deletes a scratch file next to this program through the File module.
Basic :: #import "Basic";
Files :: #import "File";

main :: () {
    path := "file-roundtrip.tmp";
    Files.file_delete(path);
    payload := "A\0B\r\n";
    Basic.assert(Files.write_entire_file(path, payload));
    defer Files.file_delete(path);
    stream, opened := Files.file_open(path);
    Basic.assert(opened && Files.is_valid(stream));
    Basic.assert(Files.file_length(stream) == payload.count);
    buffer: [5] u8;
    chunk_ok, read_count := Files.file_read(stream, buffer.data, buffer.count);
    Basic.assert(chunk_ok && read_count == buffer.count);
    Basic.assert(memcmp(buffer.data, payload.data, payload.count) == 0);
    Basic.assert(Files.file_set_position(stream, 1));
    byte: u8;
    Basic.assert(Files.file_read(stream, *byte, 1) && byte == 0);
    Basic.assert(Files.file_close(*stream) && !Files.is_valid(stream));
    text, read_ok := Files.read_entire_file(path);
    Basic.assert(read_ok && text == payload);
    Basic.free(text);
}
