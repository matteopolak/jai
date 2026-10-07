// Classic SDL2 mapping surface. No copied controller database.
#import "Basic";

SDL_Input_Target :: enum {
    UNINITIALIZED;
    LEFTX;
    RIGHTX;
    LEFTY;
    RIGHTY;
    LEFT_TRIGGER;
    RIGHT_TRIGGER;
    DPAD_LEFT;
    DPAD_RIGHT;
    DPAD_UP;
    DPAD_DOWN;
    BACK;
    GUIDE;
    START;
    LEFT_SHOULDER;
    RIGHT_SHOULDER;
    LEFT_STICK;
    RIGHT_STICK;
    A;
    B;
    X;
    Y;
}

SDL_Input_Type :: enum {
    UNINITIALIZED;
    BUTTON;
    AXIS;
    HAT;
}

SDL_Input_Map :: struct {
    target: SDL_Input_Target;
    type: SDL_Input_Type;
    index: s32 = -1;
    subindex: s32 = -1;
}

SDL_Gamepad_Mapping :: struct {
    guid: string;
    name: string;
    platform: string;
    mappings: [..] SDL_Input_Map;
}

SDL_HAT_UP_BIT :: 0x01;
SDL_HAT_RIGHT_BIT :: 0x02;
SDL_HAT_DOWN_BIT :: 0x04;
SDL_HAT_LEFT_BIT :: 0x08;

input_name_to_input_target :: (name: string) -> SDL_Input_Target {
    names: [21] string = .["leftx", "rightx", "lefty", "righty", "lefttrigger", "righttrigger", "dpleft", "dpright", "dpup", "dpdown", "back", "guide", "start", "leftshoulder", "rightshoulder", "leftstick", "rightstick", "a", "b", "x", "y"];
    for candidate, index: names if name == candidate return cast(SDL_Input_Target) (index + 1);
    return .UNINITIALIZED;
}

parse_gamepad_mapping_string :: (input: string) -> map: SDL_Gamepad_Mapping, success: bool {
    cursor: s64 = 0;
    guid := mapping_token(input, *cursor, 44);
    name := mapping_token(input, *cursor, 44);
    if guid.count != 32 && guid != "xinput" return map, false;
    if guid.count == 32 for byte: guid if !((byte >= 48 && byte <= 57) || (byte >= 65 && byte <= 70) || (byte >= 97 && byte <= 102)) return map, false;
    if name.count == 0 return map, false;
    map.guid = copy_string(guid);
    map.name = copy_string(name);
    while cursor < input.count {
        field := mapping_token(input, *cursor, 44);
        if field.count == 0 continue;
        split: s64 = 0;
        while split < field.count && field[split] != 58 split += 1;
        if split == 0 || split >= field.count {
            deinit(map);
            return .{}, false;
        }
        target_name: string = .{ field.data, split };
        value: string = .{ field.data + split + 1, field.count - split - 1 };
        if target_name == "platform" {
            free(map.platform);
            map.platform = copy_string(value);
            continue;
        }
        // SDL metadata does not alter the classic hardware mapping record.
        if target_name == "crc" || target_name == "hint" || target_name == "sdk" continue;
        target := input_name_to_input_target(target_name);
        if target == .UNINITIALIZED || value.count < 2 {
            deinit(map);
            return .{}, false;
        }
        entry: SDL_Input_Map;
        entry.target = target;
        if value[0] == 98 entry.type = .BUTTON;
        else if value[0] == 97 entry.type = .AXIS;
        else if value[0] == 104 entry.type = .HAT;
        else {
            deinit(map);
            return .{}, false;
        }
        position: s64 = 1;
        parsed_index, ok := mapping_integer(value, *position);
        entry.index = parsed_index;
        if !ok {
            deinit(map);
            return .{}, false;
        }
        if entry.type == .HAT {
            if position >= value.count || value[position] != 46 {
                deinit(map);
                return .{}, false;
            }
            position += 1;
            parsed_hat, hat_ok := mapping_integer(value, *position);
            entry.subindex = parsed_hat;
            if !hat_ok || entry.subindex < 1 || entry.subindex > 15 {
                deinit(map);
                return .{}, false;
            }
        }
        if position != value.count {
            deinit(map);
            return .{}, false;
        }
        array_add(*map.mappings, entry);
    }
    return map, true;
}

deinit :: (map: SDL_Gamepad_Mapping) {
    free(map.guid);
    free(map.name);
    free(map.platform);
    array_free(map.mappings);
}

get_guid_string :: (bustype: s16, vendor: s16, product: s16, version: s16) -> temp_string: string {
    bytes: [16] u8;
    words: [4] u16 = .[cast(u16) bustype, cast(u16) vendor, cast(u16) product, cast(u16) version];
    for word, index: words {
        bytes[index * 4] = cast(u8) word;
        bytes[index * 4 + 1] = cast(u8) (word >> 8);
    }
    out := cast(*u8) talloc(32);
    if !out return "";
    digits :: "0123456789abcdef";
    for byte, index: bytes {
        out[index * 2] = digits[byte >> 4];
        out[index * 2 + 1] = digits[byte & 15];
    }
    return .{ out, 32 };
}

#scope_file
mapping_token :: (input: string, cursor: *s64, separator: u8) -> string {
    start := cursor.*;
    while cursor.* < input.count && input[cursor.*] != separator cursor.* += 1;
    token: string = .{ input.data + start, cursor.* - start };
    if cursor.* < input.count cursor.* += 1;
    return token;
}

mapping_integer :: (input: string, cursor: *s64) -> s32, bool {
    start := cursor.*;
    number: s64 = 0;
    while cursor.* < input.count && input[cursor.*] >= 48 && input[cursor.*] <= 57 {
        number = number * 10 + input[cursor.*] - 48;
        cursor.* += 1;
        if number > 0x7fffffff return 0, false;
    }
    return cast(s32) number, cursor.* > start;
}
