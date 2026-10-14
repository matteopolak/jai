#import "Basic";
C :: #import "Clipboard";

main :: () {
    C.os_clipboard_set_text("clean-room clipboard π 🪟");
    value := C.os_clipboard_get_text();

    assert(value == "clean-room clipboard π 🪟");
    free(value);
    pixels := u8.[255, 0, 0, 255, 0, 255, 0, 255, 0, 0, 255, 255, 255, 255, 255, 255];

    C.os_clipboard_set_bitmap(2, 2, pixels.data, 4, true);

    #if OS == .MACOS {
        inspection := inspect_bitmap();
        if inspection != 0 print("native PNG inspection failed at check %\n", inspection);
        assert(inspection == 0, "native clipboard PNG pixels or orientation differ");
    }

    C.os_clipboard_empty();
    print("ok\n");
}

#scope_file
#if OS == .MACOS {
    probe :: #library,system "window_clipboard_probe";
    inspect_bitmap :: () -> s32 #foreign probe "window_clipboard_probe";
}
