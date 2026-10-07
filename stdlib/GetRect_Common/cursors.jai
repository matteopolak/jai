// Borrowed stock system cursors; no custom cursor assets or private native APIs.
#scope_module
NUM_POINTERS :: #run enum_highest_value(Pointer_Image) + 1;
left_pointers_initialized: bool;
left_pointer_requested: bool;

left_request_cursor :: (image: Pointer_Image, widget: *Active_Widget) {
    left_pointer_requested = true;
    if draw_procs.set_pointer_image draw_procs.set_pointer_image(image, widget);
}

#if OS == .MACOS {
    Cursor_ObjC :: #import "Objective_C/AppKit";

    using Cursor_ObjC;
}

#scope_export
#if OS == .WINDOWS {
    Windows :: #import "Windows";

    pointers: [NUM_POINTERS] Windows.HCURSOR;

    init_pointers :: () {
        names: [NUM_POINTERS] *void = .[Windows.IDC_ARROW, Windows.IDC_HAND, Windows.IDC_NO, Windows.IDC_SIZEWE, Windows.IDC_SIZENS, Windows.IDC_SIZEALL, Windows.IDC_SIZENWSE, Windows.IDC_SIZENESW];
        for name, index: names {
            pointers[index] = Windows.LoadCursorW(null, cast(*s16) name);
            assert(pointers[index] != null, "System cursor could not be loaded");
        }
        left_pointers_initialized = true;
    }

    getrect_set_pointer_image :: (image: Pointer_Image, widget: *Active_Widget) {
        if events_occluded(widget) return;
        left_pointer_requested = true;
        if pointer_image_sink {
            pointer_image_sink(image, widget);
            return;
        }
        if !left_pointers_initialized init_pointers();
        index := cast(int) image;
        assert(index >= 0 && index < NUM_POINTERS, "Invalid cursor image");
        if index >= 0 && index < NUM_POINTERS && pointers[index] Windows.SetCursor(pointers[index]);
    }
} else #if OS == .MACOS {
    pointers: [NUM_POINTERS] *NSCursor;

    init_pointers :: () {
        pointers[0] = NSCursor.arrowCursor();
        pointers[1] = NSCursor.pointingHandCursor();
        pointers[2] = NSCursor.operationNotAllowedCursor();
        pointers[3] = NSCursor.resizeLeftRightCursor();
        pointers[4] = NSCursor.resizeUpDownCursor();
        pointers[5] = NSCursor.closedHandCursor();
        // Earlier AppKit targets lack a public diagonal stock cursor accessor.
        pointers[6] = pointers[5];
        pointers[7] = pointers[5];
        for cursor: pointers assert(cursor != null, "AppKit cursor class method returned nil");
        left_pointers_initialized = true;
    }

    getrect_set_pointer_image :: (image: Pointer_Image, widget: *Active_Widget) {
        if events_occluded(widget) return;
        left_pointer_requested = true;
        if pointer_image_sink {
            pointer_image_sink(image, widget);
            return;
        }
        if !left_pointers_initialized init_pointers();
        index := cast(int) image;
        assert(index >= 0 && index < NUM_POINTERS, "Invalid cursor image");
        if index >= 0 && index < NUM_POINTERS && pointers[index] NSCursor.set(pointers[index]);
    }
} else #if OS == .LINUX {
    Cursor_X11 :: #import "X11";

    pointers: [NUM_POINTERS] Cursor_X11.Cursor;

    init_pointers :: () {
        display := Cursor_X11.x_global_display;
        if !display return;
        // Shapes of the X cursor font, in Pointer_Image order: left_ptr, hand2, X_cursor,
        // sb_h_double_arrow, sb_v_double_arrow, fleur, bottom_right_corner, bottom_left_corner.
        shapes: [NUM_POINTERS] u32 = .[68, 60, 0, 108, 116, 52, 14, 12];
        for shape, index: shapes pointers[index] = Cursor_X11.XCreateFontCursor(display, shape);
        left_pointers_initialized = true;
    }

    getrect_set_pointer_image :: (image: Pointer_Image, widget: *Active_Widget) {
        if events_occluded(widget) return;
        left_pointer_requested = true;
        if pointer_image_sink {
            pointer_image_sink(image, widget);
            return;
        }
        // No display yet (no window was opened): there is no cursor to change.
        if !left_pointers_initialized init_pointers();
        if !left_pointers_initialized return;
        index := cast(int) image;
        assert(index >= 0 && index < NUM_POINTERS, "Invalid cursor image");
        if index < 0 || index >= NUM_POINTERS || !pointers[index] return;
        // The cursor belongs to the window with the keyboard focus (0 and 1 are None and
        // PointerRoot, not windows).
        display := Cursor_X11.x_global_display;
        focus: Cursor_X11.Window;
        revert: s32;
        Cursor_X11.XGetInputFocus(display, *focus, *revert);
        if focus > 1 Cursor_X11.XDefineCursor(display, focus, pointers[index]);
    }
} else {
    // Other targets have no stock cursors here; a program can still install pointer_image_sink.
    init_pointers :: () {
        left_pointers_initialized = true;
    }

    getrect_set_pointer_image :: (image: Pointer_Image, widget: *Active_Widget) {
        if events_occluded(widget) return;
        left_pointer_requested = true;
        if pointer_image_sink pointer_image_sink(image, widget);
    }
}
