main :: () {
    args := get_command_line_arguments();

    defer free(args.data);
    assert(args.count == 2, "provide a caller-owned native font path");
    S.init_fonts();
    S.ensure_fonts_are_initted();
    bytes, ok := File.read_entire_file(args[1], log_errors = false);

    assert(ok);
    defer free(bytes);
    font := S.make_loaded_font("caller-font", .{ bytes.count, bytes.data });

    assert(font != null && font.face != null);
    assert(font.face.num_glyphs > 0 && font.face.units_per_EM > 0);
    assert(font.data.count == bytes.count && font.data.data != bytes.data);
    original := font.data[0];

    bytes[0] ^= 1;
    assert(font.data[0] == original);
    assert(S.find_loaded_font("caller-font") == font);
    S.destroy(font);
    assert(S.find_loaded_font("caller-font") == null);
    invalid := u8.[0, 1, 2, 3];

    assert(S.make_loaded_font("invalid", invalid) == null);
    assert(S.find_loaded_font("invalid") == null);
    file_font := S.make_loaded_font(args[1]);

    assert(file_font != null && file_font.face.num_glyphs > 0);
    S.destroy(file_font);
    print("ok\n");
}
