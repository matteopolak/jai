// Run only with a disposable, absent path provided as the sole argument.
// The witness exercises the maintained integer File handle through real APIs.
Basic :: #import "Basic";
Files :: #import "File";

main :: () {
    arguments := Basic.get_command_line_arguments();
    Basic.assert(arguments.count == 2, "expected a disposable file path");
    if arguments.count != 2 return;
    path := arguments[1];
    Basic.assert(!Files.file_exists(path), "witness refuses to replace an existing file");
    if Files.file_exists(path) return;
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
