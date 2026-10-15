#import "Basic";
P :: #import "Simple_Package";
F :: #import "File";
H :: #import "Hash_Table";

errors: int;

capture :: (message: string, data: *void, info: Log_Info) {
    assert(message.count > 0 && data == null && (info.common_flags & .ERROR) != 0);
    errors += 1;
}

release_metadata :: (package: *P.Load_Package) {
    H.deinit(*package.lookup);
    array_free(package.entries);
    package.* = .{};
}

main :: () {
    args := get_command_line_arguments();

    assert(args.count == 2);
    path := sprint("%/package.simp", args[1]);

    defer free(path);
    creator: P.Create_Package;

    P.init(*creator);
    defer P.deinit(*creator);
    name := copy_string("zeta");
    payload: [3] u8 = .[1, 2, 3];

    P.add(*creator, name, payload);
    assert(creator.entries[0].name.data != name.data && creator.entries[0].data.data == payload.data);
    name.data[0] = 88;
    free(name);
    payload[1] = 99;
    P.add(*creator, "alpha", .{});
    assert(P.write(*creator, path));
    bytes, read_ok := F.read_entire_file(path);

    assert(read_ok && bytes.count == 182);
    defer free(bytes);
    loaded: P.Load_Package;

    assert(P.init_from_memory(*loaded, .{ bytes.count, bytes.data }, "memory"));
    assert(loaded.header.magic == 0x706d6973 && loaded.header.version == 1);
    assert(loaded.header.table_of_contents_offset == 67 && loaded.table_of_contents.number_of_entries == 2);
    assert(loaded.entries[0].name == "alpha" && loaded.entries[1].name == "zeta");
    assert(loaded.entries[1].data.data == bytes.data + 64 && loaded.entries[1].data[1] == 99);
    found, entry := H.table_find(*loaded.lookup, "zeta");

    assert(found && entry == *loaded.entries[1]);
    release_metadata(*loaded);
    assert(P.load_table_of_contents(*loaded, .{ bytes.count - 67, bytes.data + 67 }, bytes.data, "direct", 67));
    assert(loaded.entries[1].data.data == bytes.data + 64 && loaded.entries[1].data[1] == 99);
    release_metadata(*loaded);
    assert(P.init_from_file(*loaded, path));
    owned := loaded.data.data;

    assert(loaded.entries[1].data[1] == 99);
    release_metadata(*loaded);
    free(owned);
    toc_ok, toc := P.load_table_of_contents_only(path);

    assert(toc_ok && toc.entries.count == 2 && toc.entries[1].name == "zeta");
    assert(toc.entries[1].data.count == 0 && toc.entries[1].data.data == null);
    owned = toc.data.data;
    release_metadata(*toc);
    free(owned);
    assert(P.write(*creator, path, sort_contents = false));
    assert(P.init_from_file(*loaded, path));
    assert(loaded.entries[0].name == "zeta" && loaded.entries[1].name == "alpha");
    owned = loaded.data.data;
    release_metadata(*loaded);
    free(owned);

    push_context {
        context.logger = capture;
        context.logger_data = null;
        assert(!P.init_from_memory(*loaded, .{ 63, bytes.data }));
        bytes.data[4] = 2;
        assert(!P.init_from_memory(*loaded, .{ bytes.count, bytes.data }));
        bytes.data[4] = 1;
        bytes.data[67 + 64 + 4 + 5] = 1;
        assert(!P.init_from_memory(*loaded, .{ bytes.count, bytes.data }));
        assert(loaded.entries.count == 0 && loaded.lookup.count == 0 && loaded.data.count == 0);
    }

    assert(errors == 3);
    assert(size_of(P.Package_Header) == 64 && size_of(P.Table_Of_Contents) == 64);
    assert(type_info(P.Entry_Info).name == "Entry_Info");
    print("ok\n");
}
