#import "Basic";
W :: #import "Windows";
I :: #import "Input";

user32 :: #library,system "user32";
post_message :: (window: W.HWND, message: u32, wparam: W.WPARAM, lparam: W.LPARAM) -> s32 #foreign user32 "PostMessageW";

main :: () {
    class_name := u16.[#char "W", #char "R", #char "T", 0];
    wc: W.WNDCLASSEXW;
    wc.cbSize = size_of(W.WNDCLASSEXW);
    wc.lpfnWndProc = I.MyWindowProc;
    wc.lpszClassName = class_name.data;
    assert(W.RegisterClassExW(*wc) != 0);
    win := W.CreateWindowExW(0, class_name.data, class_name.data, 0, 0, 0, 100, 100, null, null, null, null);

    assert(win != null);
    defer assert(W.DestroyWindow(win) != 0);

    deltas := s32.[-32768, -120, -1, 0, 1, 120, 32767];

    for message: u32.[W.WM_MOUSEWHEEL, W.WM_MOUSEHWHEEL] {
        for delta: deltas {
            encoded := delta;
            if encoded < 0 encoded += 65536;

            // Nonzero upper pointer-width bits and every native mouse-key bit.
            packed := 0x123456780000007f | (cast(u64) encoded << 16);

            assert(post_message(win, message, packed, 0x8000ffff) != 0);
            I.update_window_events();
            assert(I.events_this_frame.count == 1);
            e := I.events_this_frame[0];

            assert(e.type == .MOUSE_WHEEL && e.window == win);
            assert(e.wheel_delta == delta && e.typical_wheel_delta == 120);
            assert(e.shift_pressed && e.ctrl_pressed);
            expected_z := 0;
            if message == W.WM_MOUSEWHEEL expected_z = delta;

            assert(I.mouse_delta_z == expected_z);
            assert((I.input_button_states[cast(int) I.Key_Code.SHIFT] & .DOWN) != .NONE);
            assert((I.input_button_states[cast(int) I.Key_Code.CTRL] & .DOWN) != .NONE);
        }
    }

    // The original scroll-down encoding must survive repeated frame pumps.
    for 0..255 {
        assert(post_message(win, W.WM_MOUSEWHEEL, 0xff880000, 0) != 0);
        I.update_window_events();
        assert(I.events_this_frame.count == 1);
        assert(I.events_this_frame[0].wheel_delta == -120);
        assert(I.mouse_delta_z == -120);
    }

    print("ok\n");
}
