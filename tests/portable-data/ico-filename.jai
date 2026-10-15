#import "Basic";
I :: #import "Ico_File";
F :: #import "File";

errors: int;

capture :: (message: string, data: *void, info: Log_Info) {
    assert(message.count > 0 && data == null && (info.common_flags & .ERROR) != 0);
    errors += 1;
}

main :: () {
    args := get_command_line_arguments();

    assert(args.count == 2);
    bitmap := sprint("%/bitmap-ü.bmp", args[1]);

    defer free(bitmap);
    encoded := I.create_ico_file_from_bitmap_filename(bitmap);

    defer free(encoded);
    assert(encoded.count == 22 + 40 + 16 * 16 * 4 + 16 * 4);
    assert(encoded[62] == 30 && encoded[63] == 20 && encoded[64] == 10 && encoded[65] == 255);
    path := sprint("%/filename.ico", args[1]);

    defer free(path);
    assert(F.write_entire_file(path, encoded));
    missing := sprint("%/absent-ü.bmp", args[1]);
    malformed := sprint("%/invalid.bmp", args[1]);

    defer free(missing);
    defer free(malformed);
    assert(F.write_entire_file(malformed, "not a bitmap"));

    push_context {
        context.logger = capture;
        context.logger_data = null;
        assert(I.create_ico_file_from_bitmap_filename(missing).count == 0);
        assert(I.create_ico_file_from_bitmap_filename(malformed).count == 0);
    }

    assert(errors == 2);
    print("ok\n");
}
