// Independently authored source-text utility. AST reconstruction is pending.
#import "Basic";

print_procedure_bodies := true;

// Append the contents of a literal; the caller supplies surrounding quotes.
print_string_literal :: (builder: *String_Builder, s: string) {
    for byte: s {
        if byte == 0 append(builder, "\\0");
        else if byte == 0x1b append(builder, "\\e");
        else if byte == 0x0a append(builder, "\\n");
        else if byte == 0x0d append(builder, "\\r");
        else if byte == 0x09 append(builder, "\\t");
        else if byte == 0x1f append(builder, "\\%");
        else if byte == #char "\"" append(builder, "\\\"");
        else if byte == #char "\\" append(builder, "\\\\");
        else append(builder, *byte, 1);
    }
}
