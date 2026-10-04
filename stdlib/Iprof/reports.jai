// Batch reporting for Iprof: a text table logged through the context logger, and a CSV file.

log_text_report :: (report: *Report) {
    // Pass 1: format the numbers so we know the column widths.
    self_time_strings: [..] string;
    hier_time_strings: [..] string;
    self_time_strings.allocator = temp;
    hier_time_strings.allocator = temp;
    array_resize(*self_time_strings, report.records.count);
    array_resize(*hier_time_strings, report.records.count);

    self_max_digits := 2;
    hier_max_digits := 2;

    PRECISION :: 3;

    for row, index: report.records {
        s := tprint("%", formatFloat(row.self_time, trailing_width=PRECISION, zero_removal=.NO));
        found, before, after := split_from_left(s, #char ".");
        self_time_strings[index] = s;
        self_max_digits = max(self_max_digits, before.count);

        s = tprint("%", formatFloat(row.hier_time, trailing_width=PRECISION, zero_removal=.NO));
        found, before, after = split_from_left(s, #char ".");
        hier_time_strings[index] = s;
        hier_max_digits = max(hier_max_digits, before.count);
    }

    // Pass 2: lay out the table.
    NAME_FIELD_WIDTH :: 28;
    MARGIN_A :: 6;
    MARGIN_B :: 6;

    SELF_LABEL  :: "self (ms)";
    HIER_LABEL  :: "hier (ms)";
    CALLS_LABEL :: "calls";

    builder: String_Builder;

    append_spaces(*builder, NAME_FIELD_WIDTH + self_max_digits + 1 + PRECISION - SELF_LABEL.count);
    append(*builder, SELF_LABEL);
    append_spaces(*builder, MARGIN_A + hier_max_digits + 1 + PRECISION - HIER_LABEL.count);
    append(*builder, HIER_LABEL);
    append_spaces(*builder, MARGIN_B + 1 - CALLS_LABEL.count);
    append(*builder, CALLS_LABEL);
    append(*builder, "\n");

    for row, index: report.records {
        if row.calls == 0  continue;  // The text report skips zones that never ran.

        append(*builder, row.name);
        append_spaces(*builder, NAME_FIELD_WIDTH - row.name.count);

        s := self_time_strings[index];
        found, before, after := split_from_left(s, #char ".");
        append_spaces(*builder, self_max_digits - before.count);
        print_to_builder(*builder, "%", s);

        append_spaces(*builder, MARGIN_A);

        s = hier_time_strings[index];
        found, before, after = split_from_left(s, #char ".");
        append_spaces(*builder, hier_max_digits - before.count);
        print_to_builder(*builder, "%", s);

        append_spaces(*builder, MARGIN_B);
        print_to_builder(*builder, "%", row.calls);
        append(*builder, "\n");
    }

    s := builder_to_string(*builder);
    defer free(s);

    log("%", s);
}

save_csv_report :: (report: *Report, filename: string) {
    PRECISION :: 5;

    NAME_LABEL  :: "name";
    SELF_LABEL  :: "self (ms)";
    HIER_LABEL  :: "hier (ms)";
    CALLS_LABEL :: "calls";

    builder: String_Builder;

    print_to_builder(*builder, "! Instrumented by: %\n", get_toplevel_command_line_text());
    print_to_builder(*builder, "%,%,%,%\n", NAME_LABEL, SELF_LABEL, HIER_LABEL, CALLS_LABEL);

    for row: report.records {
        print_to_builder(*builder, "%,%,%,%\n",
                         row.name,
                         formatFloat(row.self_time, trailing_width=PRECISION, zero_removal=.NO),
                         formatFloat(row.hier_time, trailing_width=PRECISION, zero_removal=.NO),
                         row.calls);
    }

    success := write_entire_file(filename, *builder);
    if !success  log_error("[Iprof] Unable to write a CSV report to file '%'!\n", filename);
}

#scope_file

#import "File";
#import "Basic";
#import "Math";
#import "String";

// The command line the program was *compiled* with; only meaningful in a client built by a metaprogram.
get_toplevel_command_line_text :: () -> string {
    return #run join_command_line();
}

join_command_line :: () -> string {
    builder: String_Builder;
    for Compiler.get_toplevel_command_line() {
        if it_index  append(*builder, " ");
        append(*builder, it);
    }
    return builder_to_string(*builder);
}

Compiler :: #import "Compiler";

append_spaces :: (builder: *String_Builder, spaces: int) {
    for 1..spaces  append(builder, " ");
}
