#import "Basic";
Icons :: #import "Ico_File";
Files :: #import "File";

u32_at :: (data: string, offset: int) -> u32 {
    return (cast(u32) data[offset]) | ((cast(u32) data[offset + 1]) << 8) | ((cast(u32) data[offset + 2]) << 16) | ((cast(u32) data[offset + 3]) << 24);
}

main :: () {
    image_bytes, mask_bytes, total_bytes := Icons.get_bytes_for_image(4, 16);

    assert(image_bytes == 2088 && mask_bytes == 64 && total_bytes == 2216);
    assert(Icons.get_total_bytes_for_size(4, 16) == total_bytes);
    arguments := get_command_line_arguments();

    assert(arguments.count == 2);
    rgba_path := sprint("%/icon-rgba.ico", arguments[1]);
    rgb_path := sprint("%/icon-rgb.ico", arguments[1]);
    normal_path := sprint("%/icon-normal.ico", arguments[1]);

    defer free(rgba_path);
    defer free(rgb_path);
    defer free(normal_path);
    pixels: [16] u8 = .[255, 0, 0, 255, 0, 255, 0, 255, 0, 0, 255, 255, 255, 255, 255, 0];
    encoded := Icons.create_ico_file(2, 2, 4, pixels.data);

    defer free(encoded);
    assert(encoded.count == 86 && encoded.data != pixels.data);
    assert(encoded[0] == 0 && encoded[2] == 1 && encoded[4] == 1);
    assert(encoded[6] == 2 && encoded[7] == 2 && encoded[10] == 1 && encoded[12] == 32);
    assert(u32_at(encoded, 14) == 64 && u32_at(encoded, 18) == 22);
    assert(u32_at(encoded, 22) == 40 && u32_at(encoded, 26) == 2 && u32_at(encoded, 30) == 4);
    assert(encoded[62] == 255 && encoded[63] == 0 && encoded[64] == 0 && encoded[65] == 255);
    assert(encoded[70] == 0 && encoded[71] == 0 && encoded[72] == 255 && encoded[73] == 255);
    assert(encoded[78] == 64 && encoded[82] == 0);
    assert(Files.write_entire_file(rgba_path, encoded));
    rgb: [3] u8 = .[10, 20, 30];
    small := Icons.create_ico_file(1, 1, 3, rgb.data);

    defer free(small);
    assert(small.count == 70 && small[12] == 24);
    assert(small[62] == 30 && small[63] == 20 && small[64] == 10 && small[65] == 0);
    assert(Files.write_entire_file(rgb_path, small));
    normal: [1024] u8;

    for index: 0..255 {
        normal[index * 4] = 100;
        normal[index * 4 + 3] = 255;
    }

    sixteen := Icons.create_ico_file(16, 16, 4, normal.data);

    defer free(sixteen);
    assert(sixteen.count == 1150);
    assert(Files.write_entire_file(normal_path, sixteen));
    print("ok\n");
}
