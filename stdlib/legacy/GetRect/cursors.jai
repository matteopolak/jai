// Borrowed stock system cursors; no custom cursor assets or private native APIs.
#scope_module
NUM_POINTERS :: #run enum_highest_value(Pointer_Image)+1;
left_pointers_initialized:bool;
left_pointer_requested:bool;
left_request_cursor :: (image:Pointer_Image,widget:*Active_Widget) { left_pointer_requested=true; if draw_procs.set_pointer_image draw_procs.set_pointer_image(image,widget); }
#if OS==.MACOS {
    Cursor_ObjC :: #import "Objective_C";
    using Cursor_ObjC;
}
#scope_export
#if OS==.WINDOWS {
    Windows :: #import "Windows";
    pointers:[NUM_POINTERS]Windows.HCURSOR;
    init_pointers :: () {
        names:=*void.[Windows.IDC_ARROW,Windows.IDC_HAND,Windows.IDC_NO,Windows.IDC_SIZEWE,Windows.IDC_SIZENS,Windows.IDC_SIZEALL,Windows.IDC_SIZENWSE,Windows.IDC_SIZENESW];
        for name,index:names { pointers[index]=Windows.LoadCursorW(null,cast(*s16)name); assert(pointers[index]!=null,"System cursor could not be loaded"); }
        left_pointers_initialized=true;
    }
    getrect_set_pointer_image :: (image:Pointer_Image,widget:*Active_Widget) {
        if events_occluded(widget) return;
        left_pointer_requested=true;
        if pointer_image_sink { pointer_image_sink(image,widget); return; }
        if !left_pointers_initialized init_pointers(); index:=cast(int)image;
        assert(index>=0&&index<NUM_POINTERS,"Invalid cursor image");
        if index>=0&&index<NUM_POINTERS&&pointers[index] Windows.SetCursor(pointers[index]);
    }
} else #if OS==.MACOS {
    pointers:[NUM_POINTERS]*NSCursor;
    init_pointers :: () {
        pointers[0]=NSCursor.arrowCursor(); pointers[1]=NSCursor.pointingHandCursor(); pointers[2]=NSCursor.operationNotAllowedCursor();
        pointers[3]=NSCursor.resizeLeftRightCursor(); pointers[4]=NSCursor.resizeUpDownCursor(); pointers[5]=NSCursor.closedHandCursor();
        // Earlier AppKit targets lack a public diagonal stock cursor accessor.
        pointers[6]=pointers[5]; pointers[7]=pointers[5];
        for cursor:pointers assert(cursor!=null,"AppKit cursor class method returned nil");
        left_pointers_initialized=true;
    }
    getrect_set_pointer_image :: (image:Pointer_Image,widget:*Active_Widget) {
        if events_occluded(widget) return;
        left_pointer_requested=true;
        if pointer_image_sink { pointer_image_sink(image,widget); return; }
        if !left_pointers_initialized init_pointers(); index:=cast(int)image;
        assert(index>=0&&index<NUM_POINTERS,"Invalid cursor image");
        if index>=0&&index<NUM_POINTERS&&pointers[index] NSCursor.set(pointers[index]);
    }
} else {
    init_pointers :: () { assert(pointer_image_sink!=null,"This target needs a cursor provider"); left_pointers_initialized=pointer_image_sink!=null; }
    getrect_set_pointer_image :: (image:Pointer_Image,widget:*Active_Widget) {
        if events_occluded(widget) return;
        left_pointer_requested=true;
        if !left_pointers_initialized init_pointers();
        if pointer_image_sink pointer_image_sink(image,widget);
    }
}
