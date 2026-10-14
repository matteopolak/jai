// Real native BMP decoding and file I/O through unchanged public Jai callbacks.
S :: #import "SDL";
#load "../../stdlib/internal/bindings/sdl-native/module.jai";

probe :: #library "../../.work/native/sdl_runtime_abi_probe";
native_size :: () -> u64 #foreign probe "binding_runtime_rw_size";
native_hidden :: () -> u64 #foreign probe "binding_runtime_rw_hidden_offset";
libc :: #library,system "c";
abort :: () #foreign libc;
#add_context rw_test_marker: s64 = 17;

check :: (value: bool) {
    if !value abort();
}

Stream :: struct {
    before: u64 = 0x1234_5678_abcd_ef01;
    operations: S.SDL_RWops;
    after: u64 = 0xfedc_ba98_7654_3210;
    cursor: s64;
    closes: s32;
    bytes: [58] u8;
}

owner :: (source: *S.SDL_RWops) -> *Stream {
    check(context.rw_test_marker == 17);
    return cast(*Stream) (cast(*u8) source - offset_of(Stream, "operations"));
}

stream_size :: (source: *S.SDL_RWops) -> s64 {
    return owner(source).bytes.count;
}

stream_seek :: (source: *S.SDL_RWops, offset: s64, whence: int) -> s64 {
    stream := owner(source);
    target := offset;

    if whence == 1 target += stream.cursor;
    else if whence == 2 target += stream.bytes.count;
    else if whence != 0 return -1;
    if target < 0 || target > stream.bytes.count return -1;

    stream.cursor = target;

    return target;
}

stream_read :: (source: *S.SDL_RWops, destination: *void, size: int, count: int) -> int {
    stream := owner(source);

    if size <= 0 || count < 0 return 0;

    actual := (stream.bytes.count - stream.cursor) / size;
    if actual > count actual = count;

    bytes := actual * size;
    for i: 0..bytes - 1 {
        (cast(*u8) destination)[i] = stream.bytes[stream.cursor + i];
    }

    stream.cursor += bytes;

    return actual;
}

stream_close :: (source: *S.SDL_RWops) -> int {
    owner(source).closes += 1;
    return 0;
}

main :: () {
    check(size_of(S.SDL_RWops) == 48);
    check(size_of(RWops) == native_size());
    check(offset_of(RWops, "hidden") == native_hidden());
    stream: Stream;
    stream.operations.size = stream_size;
    stream.operations.seek = stream_seek;
    stream.operations.read = stream_read;
    stream.operations.close = stream_close;
    stream.operations.type = 4; // Public tag does not provide native MEMORY storage.
    // 1x1 bottom-up BGR24 BMP, with native row padding.
    stream.bytes[0] = 0x42;
    stream.bytes[1] = 0x4d;
    stream.bytes[2] = 58;
    stream.bytes[10] = 54;
    stream.bytes[14] = 40;
    stream.bytes[18] = 1;
    stream.bytes[22] = 1;
    stream.bytes[26] = 1;
    stream.bytes[28] = 24;
    stream.bytes[34] = 4;
    stream.bytes[54] = 0x19;
    stream.bytes[55] = 0x37;
    stream.bytes[56] = 0x59;
    selected := context;
    selected.rw_test_marker = 99;
    surface: *S.SDL_Surface;

    push_context selected {
        surface = S.SDL_LoadBMP_RW(*stream.operations, 0);
    }

    check(surface != null && surface.w == 1 && surface.h == 1);
    S.SDL_FreeSurface(surface);
    check(stream.closes == 0);
    check(stream.operations.type == 4);
    check(stream.before == 0x1234_5678_abcd_ef01 && stream.after == 0xfedc_ba98_7654_3210);
    stream.cursor = 0;
    surface = S.SDL_LoadBMP_RW(*stream.operations, 1);
    check(surface != null && stream.closes == 1);
    S.SDL_FreeSurface(surface);
    check(stream.before == 0x1234_5678_abcd_ef01 && stream.after == 0xfedc_ba98_7654_3210);

    file := S.SDL_RWFromFile(".work/native-rwops-test.bmp", "w+b");

    check(file != null);
    check(file.write(file, stream.bytes.data, 1, stream.bytes.count) == stream.bytes.count);
    check(file.size(file) == stream.bytes.count);
    check(file.seek(file, 0, 0) == 0);
    surface = S.SDL_LoadBMP_RW(file, 1);
    check(surface != null && surface.w == 1 && surface.h == 1);
    S.SDL_FreeSurface(surface);
    file = S.SDL_RWFromFile(".work/native-rwops-test.bmp", "rb");
    check(file != null);
    copied_operations := <<file;

    check(copied_operations.size(*copied_operations) == -1);
    check(copied_operations.close(*copied_operations) == -1);
    check(file.size(file) == stream.bytes.count);
    copied: [2] u8;

    check(file.read(file, copied.data, 1, 2) == 2);
    check(copied[0] == 0x42 && copied[1] == 0x4d);
    check(file.close(file) == 0);
    invalid: S.SDL_RWops;

    check(S.SDL_LoadBMP_RW(*invalid, 1) == null);
    check(S.SDL_GetError() != null && S.SDL_GetError()[0] != 0);
}
