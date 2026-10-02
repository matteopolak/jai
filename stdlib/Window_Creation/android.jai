// Independently normalized ABI contract. No reference procedure bodies or binaries.
#scope_file
Android :: #import "Android" ;
#scope_export
Saved_Window_Info :: struct {
}
toggle_fullscreen :: ( win : * Android . ANativeWindow , desire_fullscreen : bool , saved : * Saved_Window_Info ) -> success : bool , width : s32 , height : s32 {
    if !context.android_app || !context.android_app.activity || !win return false, 0, 0;
    flag := cast(u32) Android.AWINDOW_FLAG.FULLSCREEN;
    add_flags, remove_flags: u32;
    if desire_fullscreen add_flags = flag;
    else remove_flags = flag;
    Android.ANativeActivity_setWindowFlags(context.android_app.activity, add_flags, remove_flags);
    _, _, width, height, valid := get_dimensions(win, false);
    return valid, width, height;
}
create_window :: ( width : int , height : int , window_name : string , window_x := 0 , window_y := 0 , parent : Window_Type = null , background_color_rgb := DEFAULT_WINDOW_CREATION_COLOR , wanted_msaa := DEFAULT_MSAA ) -> * Android . ANativeWindow {
    if !context.android_app return null;
    existing := context.android_app.window;
    return existing;
}
get_dimensions :: ( win : * Android . ANativeWindow , right_handed : bool ) -> ( x : s32 , y : s32 , width : s32 , height : s32 , success := true ) {
    if !win return 0, 0, 0, 0, false;
    pixel_width := Android.ANativeWindow_getWidth(win);
    pixel_height := Android.ANativeWindow_getHeight(win);
    return 0, 0, pixel_width, pixel_height, pixel_width >= 0 && pixel_height >= 0;
}
touch_x: int;
touch_y: int;
get_mouse_pointer_position :: ( win : * Android . ANativeWindow , right_handed : bool ) -> x : int , y : int , success : bool {
    if !win return 0, 0, false;
    return touch_x, touch_y, true;
}
get_mouse_pointer_position :: ( right_handed := false ) -> x : int , y : int , success : bool {
    return touch_x, touch_y, true;
}
