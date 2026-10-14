#import "Basic";
C :: #import "Clipboard";

main :: () {
    C.os_clipboard_set_text("clean-room clipboard π 🪟");
    value := C.os_clipboard_get_text();

    assert(value == "clean-room clipboard π 🪟");
    free(value);
    pixels := u8.[255, 0, 0, 255, 0, 255, 0, 255, 0, 0, 255, 255, 255, 255, 255, 255];

    C.os_clipboard_set_bitmap(2, 2, pixels.data, 4, true);
    C.os_clipboard_empty();
    print("ok\n");
}
