save_to_file :: (set: *Keymap_Set, filename: string) {
    builder: String_Builder;
    defer free(*builder);
    print_to_builder(*builder, set);
    contents := builder_to_string(*builder);
    defer free(contents);
    assert(File.write_entire_file(filename, contents), "keymap save failed");
}

print_to_builder :: (builder: *String_Builder, set: *Keymap_Set) {
    append(builder, "[1]\n\n");
    for bucket: set.keymaps.all_buckets {
        for occupied, i: bucket.occupied {
            if !occupied continue;
            keymap := *bucket.data[i];
            append(builder, "[");
            append(builder, keymap.section_name);
            append(builder, "]\n");
            print_keymap_mappings_to_builder(builder, keymap);
            append(builder, "\n");
        }
    }
}

save_to_file :: (keymap: *Keymap, filename: string) {
    builder: String_Builder;
    defer free(*builder);
    print_to_builder(*builder, keymap);
    contents := builder_to_string(*builder);
    defer free(contents);
    assert(File.write_entire_file(filename, contents), "keymap save failed");
}

print_to_builder :: (builder: *String_Builder, keymap: *Keymap) {
    append(builder, "[1]\n\n");
    print_keymap_mappings_to_builder(builder, keymap);
}

print_keymap_mappings_to_builder :: (builder: *String_Builder, keymap: *Keymap) {
    for mapping: keymap.mappings {
        if mapping.modifier_flags.shift_pressed append(builder, "S-");
        if mapping.modifier_flags.ctrl_pressed append(builder, "C-");
        if mapping.modifier_flags.alt_pressed append(builder, "A-");
        if mapping.modifier_flags.cmd_meta_pressed append(builder, "M-");
        append(builder, map_key_to_string(cast(Key_Code) mapping.utf32));
        append(builder, " ");
        if mapping.proc_index >= 0 append(builder, keymap.procs[mapping.proc_index].name);
        else {
            append(builder, ":");
            append(builder, mapping.command_string);
        }
        append(builder, "\n");
    }
}
