// Plist text generation is independent. Bundle filesystem workflows are pending.
#import "Basic";

plist_start :: (builder: *String_Builder) {
    append(builder, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
    append(builder, "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n");
    append(builder, "<plist version=\"1.0\">\n<dict>\n");
}

plist_end :: (builder: *String_Builder) {
    append(builder, "</dict>\n</plist>\n");
}

plist_write_key_value :: (builder: *String_Builder, key: string, value: Any) -> success: bool {
    if value.type.type != .BOOL && value.type.type != .STRING return false;
    plist_write_key(builder, key);
    if value.type.type == .BOOL plist_write_bool(builder, (cast(*bool) value.value_pointer).*);
    else plist_write_string(builder, (cast(*string) value.value_pointer).*);
    return true;
}

plist_write_key :: (builder: *String_Builder, key: string) {
    append(builder, "<key>");
    append_xml_text(builder, key);
    append(builder, "</key>");
}

plist_write_string :: (builder: *String_Builder, str: string) {
    append(builder, "<string>\n");
    append_xml_text(builder, str);
    append(builder, "</string>\n");
}

plist_write_bool :: (builder: *String_Builder, value: bool) {
    if value append(builder, "<true/>");
    else append(builder, "<false/>");
}

#scope_file
append_xml_text :: (builder: *String_Builder, text: string) {
    for byte: text {
        if byte == #char "&" append(builder, "&amp;");
        else if byte == #char "<" append(builder, "&lt;");
        else if byte == #char ">" append(builder, "&gt;");
        else append(builder, *byte, 1);
    }
}
