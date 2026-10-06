// Windows windows through Win32.
create_window :: (width: int, height: int, window_name: string, window_x := -1, window_y := -1, parent: Window_Type = null, background_color_rgb := DEFAULT_WINDOW_CREATION_COLOR, wanted_msaa := DEFAULT_MSAA) -> HWND {
    if width <= 0 || height <= 0 || width > 0x7fffffff || height > 0x7fffffff return null;
    init_window_class(background_color_rgb);
    if !window_class_initted return null;
    class_name, ok_class, _ := utf8_to_wide(WINDOW_CLASS_NAME);
    title, ok_title, _ := utf8_to_wide(window_name);
    defer free(class_name);
    defer free(title);
    if !ok_class || !ok_title return null;
    style := WINDOWED_STYLE;
    if parent style = SECONDARY_WINDOW_STYLE;
    dimensions: RECT;
    dimensions.right = cast(s32) width;
    dimensions.bottom = cast(s32) height;
    if AdjustWindowRect(*dimensions, style, 0) == 0 return null;
    x := cast(s32) window_x;
    y := cast(s32) window_y;
    if window_x == -1 x = cast(s32) CW_USEDEFAULT;
    if window_y == -1 y = cast(s32) CW_USEDEFAULT;
    handle := CreateWindowExW(0, class_name, title, style, x, y, dimensions.right - dimensions.left,
        dimensions.bottom - dimensions.top, parent, null, GetModuleHandleW(null), null);
    if handle ShowWindow(handle, SW_SHOW);
    return handle;
}

Saved_Window_Info :: struct {
    rect: RECT;
    style: s32;
    ex_style: s32;
}

toggle_fullscreen :: (hwnd: HWND, desire_fullscreen: bool, saved: *Saved_Window_Info) -> (succcess: bool, width: s32, height: s32) {
    if !hwnd || !saved return false, 0, 0;
    target: RECT;
    if desire_fullscreen {
        if GetWindowRect(hwnd, *saved.rect) == 0 return false, 0, 0;
        saved.style = GetWindowLongW(hwnd, GWL_STYLE);
        saved.ex_style = GetWindowLongW(hwnd, GWL_EXSTYLE);
        monitor: MONITORINFO;
        monitor.cbSize = size_of(MONITORINFO);
        if GetMonitorInfoW(MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST), *monitor) == 0 return false, 0, 0;
        target = monitor.rcMonitor;
        SetWindowLongW(hwnd, GWL_STYLE, cast(s32) FULLSCREEN_STYLE);
        SetWindowLongW(hwnd, GWL_EXSTYLE, saved.ex_style & ~cast(s32) WS_EX_WINDOWEDGE);
    } else {
        target = saved.rect;
        SetWindowLongW(hwnd, GWL_STYLE, saved.style);
        SetWindowLongW(hwnd, GWL_EXSTYLE, saved.ex_style);
    }
    moved := SetWindowPos(hwnd, null, target.left, target.top, target.right - target.left,
        target.bottom - target.top, SWP_FRAMECHANGED | SWP_NOZORDER | SWP_NOOWNERZORDER);
    if moved == 0 return false, 0, 0;
    client: RECT;
    if GetClientRect(hwnd, *client) == 0 return false, 0, 0;
    return true, client.right - client.left, client.bottom - client.top;
}

WINDOWED_STYLE: u32 : WS_OVERLAPPEDWINDOW;
FULLSCREEN_STYLE: u32 : WS_VISIBLE | WS_POPUP;
SECONDARY_WINDOW_STYLE: u32 : WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME;
#scope_file
window_class_initted := false;
WINDOW_CLASS_NAME :: "Default Window Class";

MAKEINTRESOURCEA :: (i: u32) -> *u8 {
    encoded := cast(u64) i;
    return cast(*u8) encoded;
}

MAKEINTRESOURCEW :: (i: u32) -> *u16 {
    encoded := cast(u64) i;
    return cast(*u16) encoded;
}

init_window_class :: (background_color_rgb: [3] float) {
    if window_class_initted return;
    class_name, converted, _ := utf8_to_wide(WINDOW_CLASS_NAME);
    if !converted return;
    defer free(class_name);
    descriptor: WNDCLASSEXW;
    descriptor.cbSize = size_of(WNDCLASSEXW);
    descriptor.style = CS_OWNDC | CS_HREDRAW | CS_VREDRAW;
    descriptor.hInstance = GetModuleHandleW(null);
    descriptor.lpszClassName = class_name;
    procedure := windows_windowproc_exists();
    if procedure descriptor.lpfnWndProc = procedure;
    if !descriptor.lpfnWndProc descriptor.lpfnWndProc = cast(*void) DefWindowProcW;
    descriptor.hCursor = LoadCursorW(null, cast(*s16) IDC_ARROW);
    descriptor.hIcon = LoadIconW(descriptor.hInstance, MAKEINTRESOURCEW(2));
    if !descriptor.hIcon descriptor.hIcon = LoadIconW(null, MAKEINTRESOURCEW(32512));
    color: u32 = 0;
    for channel: 0..2 color |= (cast(u32) (clamp(background_color_rgb[channel], 0.0, 1.0) * 255.0 + 0.5)) << (channel * 8);
    descriptor.hbrBackground = CreateSolidBrush(color);
    atom := RegisterClassExW(*descriptor);
    if atom == 0 {
        already_registered := cast(u32) GetLastError() == 1410;
        if descriptor.hbrBackground DeleteObject(descriptor.hbrBackground);
        window_class_initted = already_registered;
        return;
    }
    window_class_initted = true;
}

windows_windowproc_exists :: () -> *void {
    fields := cast(*Type_Info_Struct) type_info(#Context);
    member, offset := get_field_with_offset(fields, "_windows_windowproc");
    if !member || offset < 0 return null;
    slot := cast(**void) (cast(*u8) *context + offset);
    return slot.*;
}

#scope_export
get_dimensions :: (hwnd: HWND, right_handed: bool) -> (x: s32, y: s32, width: s32, height: s32, success := true) {
    client: RECT;
    origin: POINT;
    if GetClientRect(hwnd, *client) == 0 return 0, 0, 0, 0, false;
    if ClientToScreen(hwnd, *origin) == 0 return 0, 0, 0, 0, false;
    client_width := client.right - client.left;
    client_height := client.bottom - client.top;
    if right_handed origin.y += client_height;
    return origin.x, origin.y, client_width, client_height, true;
}

get_mouse_pointer_position :: (hwnd: HWND, right_handed: bool) -> (x: int, y: int, success: bool) {
    point: POINT;
    if GetCursorPos(*point) == 0 return 0, 0, false;
    if ScreenToClient(hwnd, *point) == 0 return point.x, point.y, false;
    if right_handed {
        client: RECT;
        if GetClientRect(hwnd, *client) == 0 return point.x, point.y, false;
        point.y = client.bottom - client.top - point.y;
    }
    return point.x, point.y, true;
}

get_mouse_pointer_position :: (right_handed := false) -> x: int, y: int, success: bool {
    active := Native_GetActiveWindow();
    if !active return 0, 0, false;
    return get_mouse_pointer_position(active, right_handed);
}

#scope_module
#import "Basic";
#import "Windows";
#import "Windows_Utf8";

#scope_file
user32 :: #system_library "user32";


#scope_file
Native_GetActiveWindow :: () -> HWND #foreign user32 "GetActiveWindow";
