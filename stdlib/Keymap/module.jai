#import "Basic";
#import "Input";
#import "Gamepad";
#import "Text_File_Handler";
#import "Bucket_Array";
File :: #import "File";
#load "save.jai";

Keymap_Set :: struct {
    keymaps: Bucket_Array(Keymap, 16, true);
    default_keymap: *Keymap;
}
Key_Press_Proc :: #type ();
Key_Hold_Proc :: #type (bool);
Keymap :: struct {
    procs: [..] Proc_Info;
    mappings: [..] Single_Key_Mapping;
    command_string_proc: (command: string);
    ignore_modifier_keys := false;
    Proc_Info :: struct {
        name: string;
        press_\proc: Key_Press_Proc;
        toggle_proc: Key_Hold_Proc;
    }
    section_name: string;
    enabled := true;
}
Single_Key_Mapping :: struct {
    utf32: u32;
    respect_ignore_modifier_keys := true;
    toggled_on := false;
    modifier_flags: Event.Modifier_Flags;
    command_string: string;
    proc_index: s32 = -1;
}
Modifier_Flags :: Event.Modifier_Flags;
Add_Mapping_Error_Type :: enum u8 {
    NO_INFORMATION_ABOUT_THE_ERROR :: 0;
    NONSENSICAL_MODIFIERS :: 1;
    UNKNOWN_COMMAND :: 2;
    NO_ERROR :: 3;
}

add_keymap :: (set: *Keymap_Set, section_name: string) -> *Keymap {
    existing := find_section(set, section_name);
    if existing != null return existing;
    keymap, _ := find_and_occupy_empty_slot(*set.keymaps);
    keymap.section_name = copy_string(section_name);
    return keymap;
}
reset_keymaps :: (set: *Keymap_Set) {
    for bucket: set.keymaps.all_buckets {
        for occupied, i: bucket.occupied {
            if occupied reset_keymap(*bucket.data[i]);
        }
    }
}
enable :: (set: *Keymap_Set, keymap: *Keymap, value: bool) {
    if !value release_holds(keymap);
    keymap.enabled = value;
}
handle_event :: (set: *Keymap_Set, event: Event) -> bool {
    bucket_index := set.keymaps.all_buckets.count;
    while bucket_index > 0 {
        bucket_index -= 1;
        bucket := set.keymaps.all_buckets[bucket_index];
        slot: s64 = 16;
        while slot > 0 {
            slot -= 1;
            if !bucket.occupied[slot] continue;
            keymap := *bucket.data[slot];
            if keymap.enabled && keymap_handle_event(keymap.*, event) return true;
        }
    }
    return false;
}
load_from_memory :: (set: *Keymap_Set, memory: string, short_name := "unnamed", full_path := "(no path)") -> bool {
    handler: Text_File_Handler;
    start_from_memory(*handler, short_name, full_path, memory);
    return load_from_handler(set, set.default_keymap, *handler);
}
load_from_file :: (set: *Keymap_Set, short_name: string, filename: string, optional := false) -> bool {
    contents, success := File.read_entire_file(filename, log_errors = !optional);
    if !success return optional;
    defer free(contents);
    return load_from_memory(set, contents, short_name, filename);
}
reset_keymap :: (keymap: *Keymap) {
    release_holds(keymap);
    for mapping: keymap.mappings free(mapping.command_string);
    keymap.mappings.count = 0;
}
reload_keymap :: (using keymap: *Keymap, short_name: string, filename: string, optional := false) -> bool
    #deprecated "Use load_from_file or load_from_memory instead." {
    return load_from_file(keymap, short_name, filename, optional);
}
load_from_file :: (using keymap: *Keymap, short_name: string, full_path: string, optional := false) -> bool {
    contents, success := File.read_entire_file(full_path, log_errors = !optional);
    if !success return optional;
    defer free(contents);
    return load_from_memory(keymap, contents, short_name, full_path, optional);
}
load_from_memory :: (using keymap: *Keymap, memory: string, short_name: string, full_path: string, optional := false) -> bool {
    handler: Text_File_Handler;
    start_from_memory(*handler, short_name, full_path, memory);
    return load_from_handler(null, keymap, *handler);
}
load_from_handler :: (set: *Keymap_Set, keymap: *Keymap, handler: *Text_File_Handler) -> bool {
    pending: [..] Pending_Mapping;
    defer array_free(pending);
    current := keymap;
    while true {
        line, found := consume_next_line(handler);
        if !found break;
        line = trim_keymap_text(line);
        if line.count == 0 continue;
        if line.data[0] == 91 {
            if line.count < 2 || line.data[line.count - 1] != 93 {
                handler.failed = true;
                break;
            }
            section := text_range(line, 1, line.count - 2);
            if section == "1" continue;
            if set == null {
                handler.failed = true;
                break;
            }
            current = find_section(set, section);
            if current == null {
                handler.failed = true;
                break;
            }
            continue;
        }
        if current == null {
            handler.failed = true;
            break;
        }
        split: s64 = 0;
        while split < line.count && line.data[split] != 32 && line.data[split] != 9 split += 1;
        if split == line.count {
            handler.failed = true;
            break;
        }
        token := text_range(line, 0, split);
        command := trim_keymap_text(text_range(line, split, line.count - split));
        flags: Modifier_Flags;
        while token.count >= 2 && token.data[1] == 45 {
            modifier := upper_ascii(token.data[0]);
            if modifier == 83 flags.shift_pressed = true;
            else if modifier == 67 flags.ctrl_pressed = true;
            else if modifier == 65 flags.alt_pressed = true;
            else if modifier == 77 flags.cmd_meta_pressed = true;
            else {
                handler.failed = true;
                break;
            }
            token = text_range(token, 2, token.count - 2);
        }
        if handler.failed break;
        recognized, code := map_string_to_key(token);
        if !recognized || command.count == 0 {
            handler.failed = true;
            break;
        }
        is_proc := command.data[0] != 58;
        if !is_proc command = trim_keymap_text(text_range(command, 1, command.count - 1));
        mapping, error_type := make_mapping(current, code, flags, true, command, is_proc);
        if error_type != .NO_ERROR {
            handler.failed = true;
            break;
        }
        array_add(*pending, .{ current, mapping });
    }
    if handler.failed {
        for entry: pending free(entry.mapping.command_string);
        return false;
    }
    for entry: pending install_mapping(entry.keymap, entry.mapping);
    return true;
}
add_proc :: (keymap: *Keymap, name: string, proc: Key_Press_Proc) {
    for *info: keymap.procs {
        if info.name != name continue;
        info.press_\proc = proc;
        info.toggle_proc = null;
        return;
    }
    info: Keymap.Proc_Info;
    info.name = copy_string(name);
    info.press_\proc = proc;
    array_add(*keymap.procs, info);
}
add_proc :: (keymap: *Keymap, name: string, proc: Key_Hold_Proc) {
    for *info: keymap.procs {
        if info.name != name continue;
        info.toggle_proc = proc;
        info.press_\proc = null;
        return;
    }
    info: Keymap.Proc_Info;
    info.name = copy_string(name);
    info.toggle_proc = proc;
    array_add(*keymap.procs, info);
}
add_mapping :: (keymap: *Keymap, key: Key_Code, modifier_flags: Event.Modifier_Flags,
    respect_ignore_modifier_keys: bool, command: string, is_proc: bool)
    -> (success: bool, error_type: Add_Mapping_Error_Type) {
    mapping, error_type := make_mapping(keymap, key, modifier_flags, respect_ignore_modifier_keys, command, is_proc);
    if error_type != .NO_ERROR return false, error_type;
    install_mapping(keymap, mapping);
    return true, .NO_ERROR;
}
keymap_handle_event :: (keymap: Keymap, e: Event) -> bool {
    if !keymap.enabled || (e.type != .KEYBOARD && e.type != .TEXT_INPUT) return false;
    key := cast(u32) e.key_code;
    pressed := e.key_pressed != 0;
    if e.type == .TEXT_INPUT {
        key = e.utf32;
        pressed = true;
        if key < 128 return false;
    }
    if key >= 97 && key <= 122 key -= 32;
    index := keymap.mappings.count;
    while index > 0 {
        index -= 1;
        mapping := *keymap.mappings[index];
        if mapping.utf32 != key continue;
        ignore_modifiers := keymap.ignore_modifier_keys;
        if !mapping.respect_ignore_modifier_keys ignore_modifiers = !ignore_modifiers;
        if pressed && !ignore_modifiers && mapping.modifier_flags.packed != e.modifier_flags.packed continue;
        if mapping.proc_index >= 0 {
            info := keymap.procs[mapping.proc_index];
            if info.toggle_proc != null {
                if mapping.toggled_on != pressed {
                    mapping.toggled_on = pressed;
                    info.toggle_proc(pressed);
                }
                return true;
            }
            if !pressed return false;
            if info.press_\proc != null info.press_\proc();
            return true;
        }
        if !pressed return false;
        if keymap.command_string_proc == null return false;
        keymap.command_string_proc(mapping.command_string);
        return true;
    }
    return false;
}
map_string_to_key :: (s: string) -> bool, Key_Code {
    for named: named_keys {
        if key_name_equal(s, named.name) return true, named.key;
    }
    if s.count >= 2 && upper_ascii(s.data[0]) == 70 {
        number, success, remainder := string_to_int(text_range(s, 1, s.count - 1));
        if success && remainder.count == 0 && number >= 1 && number <= 24 return true, cast(Key_Code) (cast(s64) Key_Code.F1 + number - 1);
    }
    value, valid := single_codepoint(s);
    if !valid return false, .UNKNOWN;
    if value >= 97 && value <= 122 value -= 32;
    return true, cast(Key_Code) value;
}
map_key_to_string :: (k: Key_Code) -> string {
    for named: named_keys if named.key == k return named.name;
    value := cast(u32) k;
    if value > 0x10ffff || (value >= 0xd800 && value <= 0xdfff) return "Unknown";
    if value >= cast(u32) Key_Code.F1 && value <= cast(u32) Key_Code.F24 return tprint("F%", value - cast(u32) Key_Code.F1 + 1);
    bytes: [4] u8;
    count: s64;
    if value < 0x80 {
        bytes[0] = cast(u8) value;
        count = 1;
    } else if value < 0x800 {
        bytes[0] = cast(u8) (0xc0 | (value >> 6));
        bytes[1] = cast(u8) (0x80 | (value & 0x3f));
        count = 2;
    } else if value < 0x10000 && !(value >= 0xd800 && value <= 0xdfff) {
        bytes[0] = cast(u8) (0xe0 | (value >> 12));
        bytes[1] = cast(u8) (0x80 | ((value >> 6) & 0x3f));
        bytes[2] = cast(u8) (0x80 | (value & 0x3f));
        count = 3;
    } else if value <= 0x10ffff {
        bytes[0] = cast(u8) (0xf0 | (value >> 18));
        bytes[1] = cast(u8) (0x80 | ((value >> 12) & 0x3f));
        bytes[2] = cast(u8) (0x80 | ((value >> 6) & 0x3f));
        bytes[3] = cast(u8) (0x80 | (value & 0x3f));
        count = 4;
    } else return "Unknown";
    result: string = .{ count, cast(*u8) alloc(count, temp) };
    memcpy(result.data, *bytes[0], count);
    return result;
}
keymap_copy :: (source: *Keymap, dest: *Keymap) {
    if source == dest return;
    reset_keymap(dest);
    keymap_copy_procs(source, dest);
    dest.command_string_proc = source.command_string_proc;
    dest.ignore_modifier_keys = source.ignore_modifier_keys;
    dest.enabled = source.enabled;
    for item: source.mappings {
        copied := item;
        copied.toggled_on = false;
        if item.command_string.count != 0 copied.command_string = copy_string(item.command_string);
        array_add(*dest.mappings, copied);
    }
}
keymap_copy_procs :: (source: *Keymap, dest: *Keymap) {
    if source == dest return;
    release_holds(dest);
    for info: dest.procs free(info.name);
    dest.procs.count = 0;
    for info: source.procs {
        copied := info;
        copied.name = copy_string(info.name);
        array_add(*dest.procs, copied);
    }
}

#scope_file
Pending_Mapping :: struct {
    keymap: *Keymap;
    mapping: Single_Key_Mapping;
}
release_holds :: (keymap: *Keymap) {
    for *mapping: keymap.mappings {
        if !mapping.toggled_on continue;
        mapping.toggled_on = false;
        if mapping.proc_index < 0 || mapping.proc_index >= keymap.procs.count continue;
        proc := keymap.procs[mapping.proc_index].toggle_proc;
        if proc != null proc(false);
    }
}
make_mapping :: (keymap: *Keymap, key: Key_Code, flags: Modifier_Flags,
    respect: bool, command: string, is_proc: bool) -> Single_Key_Mapping, Add_Mapping_Error_Type {
    result: Single_Key_Mapping;
    result.utf32 = cast(u32) key;
    result.modifier_flags = flags;
    result.respect_ignore_modifier_keys = respect;
    if (key == .SHIFT && flags.shift_pressed) || (key == .CTRL && flags.ctrl_pressed) ||
       (key == .ALT && flags.alt_pressed) || (key == .CMD && flags.cmd_meta_pressed) return result, .NONSENSICAL_MODIFIERS;
    if is_proc {
        for info, i: keymap.procs {
            if info.name == command {
                result.proc_index = cast(s32) i;
                return result, .NO_ERROR;
            }
        }
        return result, .UNKNOWN_COMMAND;
    }
    if keymap.command_string_proc == null return result, .UNKNOWN_COMMAND;
    result.command_string = copy_string(command);
    return result, .NO_ERROR;
}
install_mapping :: (keymap: *Keymap, mapping: Single_Key_Mapping) {
    for *old: keymap.mappings {
        if old.utf32 != mapping.utf32 || old.modifier_flags.packed != mapping.modifier_flags.packed ||
            old.respect_ignore_modifier_keys != mapping.respect_ignore_modifier_keys continue;
        if old.toggled_on && old.proc_index >= 0 {
            proc := keymap.procs[old.proc_index].toggle_proc;
            if proc != null proc(false);
        }
        free(old.command_string);
        old.* = mapping;
        return;
    }
    array_add(*keymap.mappings, mapping);
}
find_section :: (set: *Keymap_Set, section: string) -> *Keymap {
    if set == null return null;
    for bucket: set.keymaps.all_buckets {
        for occupied, i: bucket.occupied {
            if occupied && bucket.data[i].section_name == section return *bucket.data[i];
        }
    }
    return null;
}
text_range :: (s: string, start: s64, count: s64) -> string {
    return .{ count, s.data + start };
}
trim_keymap_text :: (s: string) -> string {
    result := s;
    for byte, i: result {
        if byte == 35 {
            result.count = i;
            break;
        }
    }
    while result.count > 0 && (result.data[0] == 32 || result.data[0] == 9 || result.data[0] == 13) {
        result.data += 1;
        result.count -= 1;
    }
    while result.count > 0 {
        byte := result.data[result.count - 1];
        if byte != 32 && byte != 9 && byte != 13 break;
        result.count -= 1;
    }
    return result;
}
upper_ascii :: (byte: u8) -> u8 {
    if byte >= 97 && byte <= 122 return byte - 32;
    return byte;
}
key_name_equal :: (a: string, b: string) -> bool {
    if a.count != b.count return false;
    for byte, i: a if upper_ascii(byte) != upper_ascii(b.data[i]) return false;
    return true;
}
single_codepoint :: (s: string) -> u32, bool {
    if s.count < 1 || s.count > 4 return 0, false;
    first := s.data[0];
    count: s64;
    value: u32;
    minimum: u32;
    if first < 0x80 {
        count = 1;
        value = first;
    } else if (first & 0xe0) == 0xc0 {
        count = 2;
        value = first & 0x1f;
        minimum = 0x80;
    } else if (first & 0xf0) == 0xe0 {
        count = 3;
        value = first & 0xf;
        minimum = 0x800;
    } else if (first & 0xf8) == 0xf0 {
        count = 4;
        value = first & 7;
        minimum = 0x10000;
    } else return 0, false;
    if count != s.count return 0, false;
    for i: 1..count - 1 {
        byte := s.data[i];
        if (byte & 0xc0) != 0x80 return 0, false;
        value = value << 6 | (byte & 0x3f);
    }
    return value, value >= minimum && value <= 0x10ffff && !(value >= 0xd800 && value <= 0xdfff);
}
named_keys: [] struct {
    name: string;
    key: Key_Code;
} = .[
.{ "ESC", .ESCAPE }, .{ "Enter", .ENTER }, .{ "Return", .ENTER }, .{ "Tab", .TAB },
.{ "ArrowUp", .ARROW_UP }, .{ "ArrowDown", .ARROW_DOWN }, .{ "ArrowLeft", .ARROW_LEFT }, .{ "ArrowRight", .ARROW_RIGHT },
.{ "MouseLeft", .MOUSE_BUTTON_LEFT }, .{ "MouseRight", .MOUSE_BUTTON_RIGHT }, .{ "MouseMiddle", .MOUSE_BUTTON_MIDDLE },
.{ "MouseWheelUp", .MOUSE_WHEEL_UP }, .{ "MouseWheelDown", .MOUSE_WHEEL_DOWN },
.{ "Delete", .DELETE }, .{ "Insert", .INSERT }, .{ "End", .END }, .{ "Home", .HOME }, .{ "Backspace", .BACKSPACE },
.{ "PrintScreen", .PRINT_SCREEN }, .{ "Pause", .PAUSE }, .{ "PageUp", .PAGE_UP }, .{ "PageDown", .PAGE_DOWN },
.{ "ScrollLock", .SCROLL_LOCK }, .{ "Shift", .SHIFT }, .{ "Alt", .ALT }, .{ "Control", .CTRL }, .{ "Space", .SPACEBAR },
.{ "Gamepad_ArrowUp", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.DPAD_UP) },
.{ "Gamepad_ArrowDown", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.DPAD_DOWN) },
.{ "Gamepad_ArrowLeft", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.DPAD_LEFT) },
.{ "Gamepad_ArrowRight", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.DPAD_RIGHT) },
.{ "Gamepad_Start", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.START) }, .{ "Gamepad_Back", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.BACK) },
.{ "Gamepad_LShoulder", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.LEFT_SHOULDER) }, .{ "Gamepad_RShoulder", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.RIGHT_SHOULDER) },
.{ "Gamepad_LTrigger", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.LEFT_TRIGGER) }, .{ "Gamepad_RTrigger", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.RIGHT_TRIGGER) },
.{ "Gamepad_A", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.A) }, .{ "Gamepad_B", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.B) },
.{ "Gamepad_X", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.X) }, .{ "Gamepad_Y", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.Y) },
.{ "Gamepad_LStickUp", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.LEFT_STICK_UP) }, .{ "Gamepad_LStickDown", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.LEFT_STICK_DOWN) },
.{ "Gamepad_LStickLeft", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.LEFT_STICK_LEFT) }, .{ "Gamepad_LStickRight", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.LEFT_STICK_RIGHT) },
.{ "Gamepad_RStickUp", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.RIGHT_STICK_UP) }, .{ "Gamepad_RStickDown", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.RIGHT_STICK_DOWN) },
.{ "Gamepad_RStickLeft", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.RIGHT_STICK_LEFT) }, .{ "Gamepad_RStickRight", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.RIGHT_STICK_RIGHT) },
.{ "Gamepad_LStickClick", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.LEFT_STICK_CLICK) }, .{ "Gamepad_RStickClick", xx (Key_Code.GAMEPAD_0_BEGIN) + xx (Gamepad_Code.RIGHT_STICK_CLICK) }
];
