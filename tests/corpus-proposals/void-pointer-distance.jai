main :: () -> int {
    data: [4]u8;
    begin := cast(*void) data.data;
    end := begin + 3;
    return cast(int) (end - begin);
}
