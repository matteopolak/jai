#if OS == .WINDOWS {
    #load "../File/windows-encoding.jai";
    W :: #import "Windows";
    Utf8 :: #import "Windows_Utf8";
    os_clipboard_get_text :: () -> string {
        return os_clipboard_get_text(null);
    }
    os_clipboard_set_text :: (text: string) {
        os_clipboard_set_text(null, text);
    }
    os_clipboard_empty :: () {
        os_clipboard_empty(null);
    }
    os_clipboard_set_bitmap :: (width: s32, height: s32, pixels: *u8, channels: s32, flip := false) {
        os_clipboard_set_bitmap(null, width, height, pixels, channels, flip);
    }

    os_clipboard_get_text :: (hwnd: W.HWND) -> string {
        if !W.OpenClipboard(hwnd) return "";
        defer W.CloseClipboard();
        handle := W.GetClipboardData(13);
        if !handle return "";
        pointer := cast(*u16) W.GlobalLock(handle);
        if !pointer return "";
        defer W.GlobalUnlock(handle);
        maximum := clipboard_global_size(handle) / 2;
        length: u64;
        while length < maximum && pointer[length] != 0 length += 1;
        if length == maximum return "";
        return os_wide_to_utf8(pointer, xx length);
    }
    os_clipboard_set_text :: (hwnd: W.HWND, text: string) {
        wide := os_utf8_to_wide(text);
        count: s64;
        while wide[count] != 0 count += 1;
        memory := W.GlobalAlloc(2, xx ((count + 1) * 2));
        if !memory return;
        pointer := W.GlobalLock(memory);
        if !pointer {
            clipboard_global_free(memory);
            return;
        }
        memcpy(pointer, wide, (count + 1) * 2);
        W.GlobalUnlock(memory);
        if !publish_windows(hwnd, 13, memory) clipboard_global_free(memory);
    }
    os_clipboard_empty :: (hwnd: W.HWND) {
        if !W.OpenClipboard(hwnd) return;
        defer W.CloseClipboard();
        W.EmptyClipboard();
    }
    os_clipboard_set_bitmap :: (hwnd: W.HWND, width: s32, height: s32, pixels: *u8, channels: s32, flip := false) {
        dib, valid := make_dib(width, height, pixels, channels, flip);
        if !valid return;
        defer free(dib);
        memory := W.GlobalAlloc(2, xx dib.count);
        if !memory return;
        pointer := W.GlobalLock(memory);
        if !pointer {
            clipboard_global_free(memory);
            return;
        }
        memcpy(pointer, dib.data, dib.count);
        W.GlobalUnlock(memory);
        if !publish_windows(hwnd, 8, memory) clipboard_global_free(memory);
    }
    #scope_file
    clipboard_kernel :: #system_library "kernel32";
    clipboard_global_free :: (memory: W.HGLOBAL) -> W.HGLOBAL #foreign clipboard_kernel "GlobalFree";
    clipboard_global_size :: (memory: W.HGLOBAL) -> u64 #foreign clipboard_kernel "GlobalSize";
    publish_windows :: (hwnd: W.HWND, format: u32, memory: W.HGLOBAL) -> bool {
        if !W.OpenClipboard(hwnd) return false;
        defer W.CloseClipboard();
        if !W.EmptyClipboard() return false;
        return W.SetClipboardData(format, memory) != null;
    }
    #scope_export
} else #if OS == .MACOS {
    os_clipboard_get_text :: () -> string {
        pool := clipboard_autorelease_pool();
        defer objc_clear(pool, clipboard_selector("drain"));
        board := clipboard_board();
        value := objc_one(board, clipboard_selector("stringForType:"), clipboard_nsstring("public.utf8-plain-text"));
        if !value return "";
        count := objc_encoding_length(value, clipboard_selector("lengthOfBytesUsingEncoding:"), 4);
        bytes := cast(*u8) objc_zero(value, clipboard_selector("UTF8String"));
        if !bytes return "";
        return copy_string(string.{ xx count, bytes });
    }
    os_clipboard_set_text :: (text: string) {
        pool := clipboard_autorelease_pool();
        defer objc_clear(pool, clipboard_selector("drain"));
        board := clipboard_board();
        objc_clear(board, clipboard_selector("clearContents"));
        objc_two_bool(board, clipboard_selector("setString:forType:"), clipboard_nsstring(text), clipboard_nsstring("public.utf8-plain-text"));
    }
    os_clipboard_empty :: () {
        pool := clipboard_autorelease_pool();
        defer objc_clear(pool, clipboard_selector("drain"));
        objc_clear(clipboard_board(), clipboard_selector("clearContents"));
    }
    os_clipboard_set_bitmap :: (width: s32, height: s32, pixels: *u8, channels: s32, flip := false) {
        pool := clipboard_autorelease_pool();
        defer objc_clear(pool, clipboard_selector("drain"));
        bmp, valid := make_bmp(width, height, pixels, channels, flip);
        if !valid return;
        defer free(bmp);
        data := objc_bytes(clipboard_class("NSData"), clipboard_selector("dataWithBytes:length:"), bmp.data, xx bmp.count);
        board := clipboard_board();
        objc_clear(board, clipboard_selector("clearContents"));
        objc_two_bool(board, clipboard_selector("setData:forType:"), data, clipboard_nsstring("com.microsoft.bmp"));
    }
    #scope_file
    clipboard_objc :: #system_library "objc";
    clipboard_appkit :: #system_library "AppKit";
    clipboard_load_appkit :: () -> bool #foreign clipboard_appkit "NSApplicationLoad";
    clipboard_class :: (name: *u8) -> *void #foreign clipboard_objc "objc_getClass";
    clipboard_selector :: (name: *u8) -> *void #foreign clipboard_objc "sel_registerName";
    objc_zero :: (object: *void, selector: *void) -> *void #foreign clipboard_objc "objc_msgSend";
    objc_one :: (object: *void, selector: *void, argument: *void) -> *void #foreign clipboard_objc "objc_msgSend";
    objc_two_bool :: (object: *void, selector: *void, first: *void, second: *void) -> bool #foreign clipboard_objc "objc_msgSend";
    objc_clear :: (object: *void, selector: *void) -> s64 #foreign clipboard_objc "objc_msgSend";
    objc_bytes_encoding :: (object: *void, selector: *void, bytes: *u8, length: u64, encoding: u64) -> *void #foreign clipboard_objc "objc_msgSend";
    objc_encoding_length :: (object: *void, selector: *void, encoding: u64) -> u64 #foreign clipboard_objc "objc_msgSend";
    objc_bytes :: (object: *void, selector: *void, bytes: *u8, length: u64) -> *void #foreign clipboard_objc "objc_msgSend";
    objc_utf8 :: (object: *void, selector: *void, bytes: *u8) -> *void #foreign clipboard_objc "objc_msgSend";
    clipboard_nsstring :: (text: string) -> *void {
        allocated := objc_zero(clipboard_class("NSString"), clipboard_selector("alloc"));
        value := objc_bytes_encoding(allocated, clipboard_selector("initWithBytes:length:encoding:"), text.data, xx text.count, 4);
        return objc_zero(value, clipboard_selector("autorelease"));
    }
    clipboard_board :: () -> *void {
        return objc_zero(clipboard_class("NSPasteboard"), clipboard_selector("generalPasteboard"));
    }
    clipboard_autorelease_pool :: () -> *void {
        clipboard_load_appkit();
        allocated := objc_zero(clipboard_class("NSAutoreleasePool"), clipboard_selector("alloc"));
        return objc_zero(allocated, clipboard_selector("init"));
    }
    #scope_export
} else #if OS == .LINUX {
    Processes :: #import "Process";
    os_clipboard_get_text :: () -> string {
        arguments: [3] string = .[ "wl-paste", "--no-newline", "" ];
        status, out, err, timeout := Processes.run_command(..slice_array(arguments, 0, 2), capture_and_return_output = true);
        if status.type == .EXITED && status.exit_code == 0 return copy_string(out);
        x_arguments: [4] string = .[ "xclip", "-selection", "clipboard", "-o" ];
        status, out, err, timeout = Processes.run_command(..x_arguments, capture_and_return_output = true);
        if status.type == .EXITED && status.exit_code == 0 return copy_string(out);
        return "";
    }
    os_clipboard_set_text :: (text: string) {
        arguments: [1] string = .[ "wl-copy" ];
        if clipboard_send(arguments, text) return;
        fallback: [3] string = .[ "xclip", "-selection", "clipboard" ];
        clipboard_send(fallback, text);
    }
    os_clipboard_empty :: () {
        arguments: [2] string = .[ "wl-copy", "--clear" ];
        status, out, err, timeout := Processes.run_command(..arguments);
        if status.type != .EXITED || status.exit_code != 0 os_clipboard_set_text("");
    }
    os_clipboard_set_bitmap :: (width: s32, height: s32, pixels: *u8, channels: s32, flip := false) {
        bmp, valid := make_bmp(width, height, pixels, channels, flip);
        if !valid return;
        defer free(bmp);
        arguments: [3] string = .[ "wl-copy", "--type", "image/bmp" ];
        if clipboard_send(arguments, bmp) return;
        fallback: [5] string = .[ "xclip", "-selection", "clipboard", "-t", "image/bmp" ];
        clipboard_send(fallback, bmp);
    }
    #scope_file
    clipboard_send :: (arguments: [] string, data: string) -> bool {
        process: Processes.Process;
        if !Processes.create_process(*process, ..arguments, capture_and_return_output = true) return false;
        defer Processes.deinit(*process);
        offset: int;
        while offset < data.count {
            bytes: [] u8 = .{ data.count - offset, data.data + offset };
            success, count := Processes.write_to_process(*process, bytes);
            if !success || count == 0 return false;
            offset += count;
        }
        Processes.deinit(*process.input);
        success, result := Processes.get_process_result(*process, 5000);
        return success && result.type == .EXITED && result.exit_code == 0;
    }
    slice_array :: (array: [] string, index: int, count: int) -> [] string {
        return .{ count, array.data + index };
    }
    #scope_export
} else #if OS == .WASM {
    // The browser build keeps the clipboard in memory: the page owns the real clipboard.
    os_clipboard_get_text :: () -> string {
        return copy_string(wasm_clipboard_text);
    }
    os_clipboard_set_text :: (text: string) {
        free(wasm_clipboard_text);
        wasm_clipboard_text = copy_string(text);
    }
    os_clipboard_empty :: () {
        free(wasm_clipboard_text);
        wasm_clipboard_text = "";
    }
    os_clipboard_set_bitmap :: (width: s32, height: s32, pixels: *u8, channels: s32, flip := false) {}
    #scope_file
    wasm_clipboard_text: string;
    #scope_export
} else {
    #assert(false, "Clipboard requires Windows, macOS AppKit, Linux clipboard helpers, or the in-memory browser clipboard");
}

#scope_file
make_dib :: (width: s32, height: s32, pixels: *u8, channels: s32, flip: bool) -> string, bool {
    if width <= 0 || height <= 0 || !pixels || channels != 3 && channels != 4 return "", false;
    pitch := (cast(s64) width * 3 + 3) & ~3;
    if pitch > (0xffff_ffff - 40) / height return "", false;
    count := pitch * height + 40;
    bytes := cast(*u8) alloc(count);
    if !bytes return "", false;
    memset(bytes, 0, count);
    write_le32(bytes, 40);
    write_le32(bytes + 4, xx width);
    write_le32(bytes + 8, xx height);
    bytes[12] = 1;
    bytes[14] = 24;
    write_le32(bytes + 20, xx (pitch * height));
    for y: 0..height - 1 {
        source_y := height - y - 1;
        if flip source_y = y;
        for x: 0..width - 1 {
            source := pixels + (cast(s64) source_y * width + x) * channels;
            output := bytes + 40 + y * pitch + x * 3;
            output[0] = source[2];
            output[1] = source[1];
            output[2] = source[0];
        }
    }
    return .{ count, bytes }, true;
}
make_bmp :: (width: s32, height: s32, pixels: *u8, channels: s32, flip: bool) -> string, bool {
    dib, valid := make_dib(width, height, pixels, channels, flip);
    if !valid return "", false;
    defer free(dib);
    bytes := cast(*u8) alloc(dib.count + 14);
    if !bytes return "", false;
    memset(bytes, 0, 14);
    bytes[0] = #char "B";
    bytes[1] = #char "M";
    write_le32(bytes + 2, xx (dib.count + 14));
    write_le32(bytes + 10, 54);
    memcpy(bytes + 14, dib.data, dib.count);
    return .{ dib.count + 14, bytes }, true;
}
write_le32 :: (bytes: *u8, value: u32) {
    for i: 0..3 bytes[i] = cast(u8) ((value >> (i * 8)) & 255);
}
