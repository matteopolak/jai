// Independently authored reflected command-line parser.
// The supplied standard-library interface is documented in docs/stdlib/command-line.md.

Is_Set :: struct(T: Type) {
    #insert -> string {
        descriptor := type_info(T);
        assert(descriptor.type == .STRUCT, "Command_Line requires a struct type");
        fields := cast(*Type_Info_Struct)descriptor;
        generated: String_Builder;
        for field: fields.members {
            if cli_skip_member(*field) continue;
            append(*generated, field.name);
            append(*generated, ": bool = false;\n");
        }
        text := builder_to_string(*generated);
        free_buffers(*generated);
        return text;
    };
}

Argument_Flags :: enum_flags u64 {
    FREE_ARGUMENTS_ALLOWED :: 0x1;
    DOUBLE_DASH_REQUIRED :: 0x2;
    SHOW_HELP_ON_ERROR :: 0x4;
    SORT_HELP :: 0x8;
    ALIGN_HELP :: 0x10;
}

Default_Argument_Flags :: Argument_Flags.FREE_ARGUMENTS_ALLOWED | .SORT_HELP | .ALIGN_HELP;

parse_arguments :: ($T: Type, flags := Default_Argument_Flags, help_triggers: []string = .["help", "HELP", "?"]) -> (success: bool, result: T, is_set: Is_Set(T), free_arguments: [..]string) {
    argv := get_command_line_arguments();
    defer {
        for text: argv free(text.data);
        array_free(argv);
    }
    return parse_arguments_from(argv, T, flags, help_triggers);
}

// Additive entry for callers with an explicit argv. Element zero is the program name.
parse_arguments_from :: (argv: []string, $T: Type, flags := Default_Argument_Flags, help_triggers: []string = .["help", "HELP", "?"]) -> (success: bool, result: T, is_set: Is_Set(T), free_arguments: [..]string) {
    result: T;
    specified: Is_Set(T);
    positional: [..]string;
    descriptor := type_info(T);
    assert(descriptor.type == .STRUCT, "Command_Line requires a struct type");
    fields := cast(*Type_Info_Struct)descriptor;
    marker_fields := cast(*Type_Info_Struct)type_info(Is_Set(T));
    cursor: s64 = 1;
    positional_only := false;
    accepted := true;
    requested_help := false;
    while cursor < argv.count {
        word := argv[cursor];
        if !positional_only && word == "--" && (flags & .FREE_ARGUMENTS_ALLOWED) {
            positional_only = true;
            cursor += 1;
            continue;
        }
        prefix_size: s64 = 1;
        if flags & .DOUBLE_DASH_REQUIRED prefix_size = 2;
        option := !positional_only && word.count >= prefix_size;
        if option {
            for i: 0..prefix_size-1 if word[i] != #char "-" option = false;
        }
        if !option {
            if !(flags & .FREE_ARGUMENTS_ALLOWED) {
                log_error("Unexpected positional argument: %", word);
                accepted = false;
                break;
            }
            array_add(*positional, copy_string(word));
            cursor += 1;
            continue;
        }
        name := string.{word.count-prefix_size, word.data+prefix_size};
        member: *Type_Info_Struct_Member;
        for *field: fields.members {
            if !cli_skip_member(field) && field.name == name { member = field; break; }
        }
        if member == null {
            for trigger: help_triggers if name == trigger requested_help = true;
            if requested_help show_help(T, flags, help_triggers);
            else log_error("Unknown command-line option: %", name);
            accepted = false;
            break;
        }
        marker: *bool;
        for field: marker_fields.members {
            if field.name == name {
                marker = cast(*bool)((cast(*u8)*specified)+field.offset_in_bytes);
                break;
            }
        }
        assert(marker != null, "Missing generated command-line marker");
        if marker.* {
            log_error("Command-line option was repeated: %", name);
            accepted = false;
            break;
        }
        cursor += 1;
        destination := (cast(*u8)*result)+member.offset_in_bytes;
        if !cli_read_value(destination, member.type, argv, *cursor) {
            log_error("Invalid or missing value for command-line option: %", name);
            accepted = false;
            break;
        }
        marker.* = true;
    }
    if !accepted && !requested_help {
        if flags & .SHOW_HELP_ON_ERROR show_help(T, flags, help_triggers);
        else if help_triggers.count {
            if flags & .DOUBLE_DASH_REQUIRED log_error("Use --% for help.", help_triggers[0]);
            else log_error("Use -% for help.", help_triggers[0]);
        }
    }
    return accepted, result, specified, positional;
}

show_help :: ($T: Type, flags: Argument_Flags, help_triggers: []string) {
    descriptor := type_info(T);
    assert(descriptor.type == .STRUCT, "Command_Line requires a struct type");
    fields := cast(*Type_Info_Struct)descriptor;
    entries: [..]*Type_Info_Struct_Member;
    defer array_free(entries);
    longest: s64;
    for *field: fields.members {
        if cli_skip_member(field) continue;
        array_add(*entries, field);
        if field.name.count > longest longest = field.name.count;
    }
    if flags & .SORT_HELP {
        i: s64 = 1;
        while i < entries.count {
            selected := entries[i];
            j := i;
            while j > 0 && cli_name_before(selected.name, entries[j-1].name) {
                entries[j] = entries[j-1];
                j -= 1;
            }
            entries[j] = selected;
            i += 1;
        }
    }
    prefix := "-";
    if flags & .DOUBLE_DASH_REQUIRED prefix = "--";
    if !entries.count && !help_triggers.count {
        if flags & .FREE_ARGUMENTS_ALLOWED print("There are no named options; positional arguments are allowed.\n");
        else print("There are no valid command-line options.\n");
        return;
    }
    print("Command-line options:\n");
    for field: entries {
        print("    %%", prefix, field.name);
        description: string;
        for note: field.notes {
            if note.count && note[0] == #char "?" description = .{note.count-1, note.data+1};
        }
        if description.count {
            print(": ");
            if flags & .ALIGN_HELP {
                remaining := longest-field.name.count;
                while remaining > 0 { print(" "); remaining -= 1; }
            }
            print("%", description);
        }
        print("\n");
    }
    if help_triggers.count {
        print("\n    ");
        for trigger: help_triggers {
            if it_index print(", ");
            print("%%", prefix, trigger);
        }
        print(": Show the list of commands.\n");
    }
}

#scope_file
#import "Basic";
Reflection :: #import "Reflection";

cli_skip_member :: (member: *Type_Info_Struct_Member) -> bool {
    return (member.flags & (.CONSTANT | .IMPORTED)) != 0;
}

cli_name_before :: (left: string, right: string) -> bool {
    count := left.count;
    if right.count < count count = right.count;
    for i: 0..count-1 {
        if left[i] < right[i] return true;
        if left[i] > right[i] return false;
    }
    return left.count < right.count;
}

cli_read_value :: (slot: *u8, descriptor: *Type_Info, argv: []string, cursor: *s64) -> bool {
    if descriptor.type == .BOOL {
        (cast(*bool)slot).* = true;
        return true;
    }
    if descriptor.type == .ARRAY {
        array := cast(*Type_Info_Array)descriptor;
        if array.array_type != .FIXED || array.array_count < 0 return false;
        for i: 0..array.array_count-1 {
            if !cli_read_value(slot+i*array.element_type.runtime_size, array.element_type, argv, cursor) return false;
        }
        return true;
    }
    if cursor.* >= argv.count return false;
    text := argv[cursor.*];
    if descriptor.type == .STRING {
        (cast(*string)slot).* = copy_string(text);
        cursor.* += 1;
        return true;
    }
    if descriptor.type == .ENUM {
        enumeration := cast(*Type_Info_Enum)descriptor;
        if enumeration.enum_type_flags & .FLAGS return false;
        for entry: enumeration.names {
            if entry == text {
                Reflection.set_enum_value(slot, enumeration, enumeration.values[it_index]);
                cursor.* += 1;
                return true;
            }
        }
        return false;
    }
    if descriptor.type != .INTEGER && descriptor.type != .FLOAT return false;
    // Work in temporary storage so a failed full-token conversion cannot mutate the result.
    storage: u64;
    if descriptor.runtime_size != 1 && descriptor.runtime_size != 2 && descriptor.runtime_size != 4 && descriptor.runtime_size != 8 return false;
    value: Any;
    value.type = descriptor;
    value.value_pointer = *storage;
    remaining := text;
    if !Reflection.set_value_from_string(value, *remaining) || remaining.count return false;
    bytes := cast(*u8)*storage;
    for i: 0..descriptor.runtime_size-1 slot[i] = bytes[i];
    cursor.* += 1;
    return true;
}
