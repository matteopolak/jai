S :: #import "SDL";
#load "../../stdlib/internal/bindings/sdl-native/module.jai";

probe :: #library "../../.work/native/sdl_abi_probe";
libc :: #library,system "c";
abort :: () #foreign libc;

check :: (value: bool) {
    if !value abort();
}

size_matches :: (which: u32, actual: u64) -> s32 #foreign probe "binding_sdl_check_size";
native_offset :: (which: u32) -> u64 #foreign probe "binding_sdl_offset";

// Exact reviewed public prefixes, independently of full native record sizes.
#assert size_of(S.SDL_RWops) == 48;
#assert offset_of(S.SDL_RWops, "size") == 0;
#assert offset_of(S.SDL_RWops, "seek") == 8;
#assert offset_of(S.SDL_RWops, "read") == 16;
#assert offset_of(S.SDL_RWops, "write") == 24;
#assert offset_of(S.SDL_RWops, "close") == 32;
#assert offset_of(S.SDL_RWops, "type") == 40;
#assert size_of(S.SDL_UserEvent) == 8;
#assert offset_of(S.SDL_UserEvent, "type") == 0;
#assert offset_of(S.SDL_UserEvent, "timestamp") == 4;

main :: () {
    valid := size_matches(0, size_of(S.SDL_version)) != 0;
    if size_matches(1, size_of(S.SDL_Rect)) == 0 valid = false;
    if size_matches(2, size_of(S.SDL_PixelFormat)) == 0 valid = false;
    if size_matches(3, size_of(S.SDL_Surface)) == 0 valid = false;
    if size_matches(4, size_of(S.SDL_Event)) == 0 valid = false;

    format: S.SDL_PixelFormat;
    surface: S.SDL_Surface;
    rw: S.SDL_RWops;

    check((cast(u64) *format.palette) - (cast(u64) *format) == native_offset(0));
    check((cast(u64) *format.refcount) - (cast(u64) *format) == native_offset(1));
    check((cast(u64) *surface.pixels) - (cast(u64) *surface) == native_offset(2));
    check((cast(u64) *surface.clip_rect) - (cast(u64) *surface) == native_offset(3));
    check((cast(u64) *rw.type) - (cast(u64) *rw) == native_offset(4));
    check(offset_of(S.SDL_RWops, "size") == native_offset(5));
    check(offset_of(S.SDL_RWops, "seek") == native_offset(6));
    check(offset_of(S.SDL_RWops, "read") == native_offset(7));
    check(offset_of(S.SDL_RWops, "write") == native_offset(8));
    check(offset_of(S.SDL_RWops, "close") == native_offset(9));
    check(offset_of(S.SDL_UserEvent, "type") == native_offset(11));
    check(offset_of(S.SDL_UserEvent, "timestamp") == native_offset(12));

    // Complete private native storage must match the full pinned C records.
    if size_matches(5, size_of(RWops)) == 0 valid = false;
    if size_matches(6, size_of(User_Event)) == 0 valid = false;

    check(offset_of(RWops, "size") == native_offset(5));
    check(offset_of(RWops, "seek") == native_offset(6));
    check(offset_of(RWops, "read") == native_offset(7));
    check(offset_of(RWops, "write") == native_offset(8));
    check(offset_of(RWops, "close") == native_offset(9));
    check(offset_of(RWops, "type") == native_offset(4));
    check(offset_of(RWops, "hidden") == native_offset(10));
    check(offset_of(User_Event, "type") == native_offset(11));
    check(offset_of(User_Event, "timestamp") == native_offset(12));
    check(offset_of(User_Event, "windowID") == native_offset(13));
    check(offset_of(User_Event, "code") == native_offset(14));
    check(offset_of(User_Event, "data1") == native_offset(15));
    check(offset_of(User_Event, "data2") == native_offset(16));

    check(valid);
}
