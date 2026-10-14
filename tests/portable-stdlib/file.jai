#import "Basic";
F :: #import "File";

main :: () {
    name := "portable-file-test.bin";

    assert(F.write_entire_file(name, "abcdef"));
    file, ok := F.file_open(name);

    assert(ok);
    assert(F.file_set_position(file, 2));
    tail, read_ok := F.read_entire_file(file, true);

    assert(read_ok && tail == "cdef" && tail.data[tail.count] == 0);
    free(tail);
    byte: u8;
    success, count := F.file_read(file, *byte, 1);

    assert(success && count == 0);
    success, count = F.file_read(file, null, 0);
    assert(!success && count == 0);
    F.file_close(*file);
    assert(!F.is_valid(file));
    file, ok = F.file_open(name, true, true);
    assert(ok && F.file_write(*file, "Z"));
    F.file_close(*file);
    data, valid := F.read_entire_file(name);

    assert(valid && data == "Zbcdef");
    free(data);
    assert(F.file_delete(name));
    print("ok\n");
}
