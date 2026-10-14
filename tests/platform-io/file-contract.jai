#import "Basic";
F :: #import "File";

main :: () {
    root := "platform-io-雪-😀";
    name := "platform-io-雪-😀/binary.bin";
    alias := "platform-io-雪-😀/link.bin";
    moved := "platform-io-雪-😀/moved.bin";

    assert(F.make_directory_if_it_does_not_exist(root));
    assert(F.make_directory_if_it_does_not_exist(root));
    assert(F.write_entire_file(name, "a\0b\r\nc"));
    assert(!F.make_directory_if_it_does_not_exist(name));
    file, opened := F.file_open(name, for_writing = true, keep_existing_content = true);

    assert(opened);
    bytes: [16] u8;
    ok, count := F.file_read(file, bytes.data, bytes.count);

    assert(ok && count == 6 && bytes[1] == 0 && bytes[3] == 13 && bytes[4] == 10);
    length, sized := F.file_length(file);

    assert(sized && length == 6);
    tell_ok, position := F.file_tell(file);

    assert(tell_ok && position == 6);
    assert(F.file_seek(file, -3, .END));
    assert(F.file_seek(file, -1, .CURRENT));
    assert(F.file_write(*file, "Z"));
    assert(F.file_flush(file));
    assert(F.file_seek(file, 0, .START));
    data, read_ok := F.read_entire_file(file, true);

    assert(read_ok && data == "a\0Z\r\nc" && data.data[data.count] == 0);
    free(data);
    assert(!F.file_seek(file, -1, .START));
    F.file_close(*file);
    assert(!F.is_valid(file));
    F.file_close(*file);
    assert(!F.file_write(*file, "bad"));
    assert(F.file_link(alias, name));
    assert(F.file_move(alias, moved));
    assert(F.file_delete(name));
    data, read_ok = F.read_entire_file(moved);
    assert(read_ok && data == "a\0Z\r\nc");
    free(data);
    assert(!F.delete_directory(root));

    #if OS == .WINDOWS {
        canonical := F.file_get_canonical_path(moved);

        assert(canonical.count > moved.count);
        free(canonical);
        mapping, mapped := F.map_file(moved);

        assert(mapped && mapping.data == "a\0Z\r\nc");
        assert(F.munmap_file(*mapping));
        assert(!F.is_valid(mapping.file) && mapping.mapping == null && mapping.data.count == 0);
    }

    info, map_ok := F.map_entire_file_start(moved);

    assert(map_ok && info.data == "a\0Z\r\nc");
    F.map_entire_file_end(*info);

    #if OS == .WINDOWS {
        borrowed := F.string_to_map_file_info("borrowed");
        F.map_entire_file_end(*borrowed);
    }

    assert(F.write_entire_file(moved, ""));
    data, read_ok = F.read_entire_file(moved, true);
    assert(read_ok && data.count == 0 && data.data[0] == 0);
    free(data);
    assert(F.file_delete(moved));
    assert(F.delete_directory(root));
    _, opened = F.file_open(name, log_errors = false);
    assert(!opened);
    print("ok\n");
}
