// Reports: a table of rows built from the smoothed (or historical) zone values, the cursor and
// selection that an interactive viewer drives, and the plain-text and CSV writers.

Report_Mode :: enum u8 {
    SELF_TIME; // One row per zone, by time spent in the zone itself.
    HIERARCHICAL_TIME; // One row per zone, by time including everything it called.
    CALL_COUNT; // One row per zone, by calls per frame.
    CALL_GRAPH; // The selected zone with its callers above and its callees below.
}

NUM_HEADER :: 4; // Columns: name, self, hierarchical, calls.

// Bits of Report_Row.value_flag: which numeric columns hold a value.
VALUE_SELF :: 1;
VALUE_HIER :: 2;
VALUE_CALLS :: 4;

Report_Row :: struct {
    indent: s64; // Nesting level for display (call graph only).
    name: string;
    number: s64; // Index of the zone in `zones`.
    prefix: u8; // Marker shown before the name: '<' caller, '*' selected zone, '>' callee, or ' '.
    value_flag: s64; // VALUE_* bits.

    self_time: float64; // Milliseconds per frame.
    hier_time: float64; // Milliseconds per frame.
    calls: float64; // Calls per frame.

    heat: float64; // 0..1; how unsteady this zone is right now.
    zone: *Zone;
}

Report :: struct {
    title: string;
    title_right: string;
    header: [NUM_HEADER] string;
    hilit_header: s32; // Column the rows are sorted by.

    records: [..] Report_Row;
    hilight: s64; // Row under the cursor.
}

displayed_quantity := Report_Mode.SELF_TIME;

set_report_mode :: (mode: Report_Mode) {
    if mode == displayed_quantity return;
    displayed_quantity = mode;
    cursor_row = 0;
}

// Builds the report for the current mode, smoothing level and display frame. The result is owned
// by Iprof and rebuilt in place by the next call.
create_report :: () -> *Report {
    r := *current_report;
    array_reset_keeping_memory(*r.records);
    if !live return r;

    was_busy := busy;
    busy = true;
    defer busy = was_busy;

    pick_zone_values();

    if displayed_quantity == .CALL_GRAPH fill_call_graph(r);
    else fill_flat(r);

    if jump_to_focus_row {
        cursor_row = focus_row;
        jump_to_focus_row = false;
    }
    cursor_row = clamp(cursor_row, 0, max(r.records.count - 1, 0));
    r.hilight = cursor_row;

    last_rows.count = 0;
    for r.records array_add(*last_rows, it.zone);
    return r;
}

move_cursor :: (delta: s64) {
    cursor_row += delta;
}
set_cursor :: (row: s64) {
    cursor_row = row;
}

// Focus the call graph on the zone of the row under the cursor.
select :: () {
    if !last_rows.count return;
    focus_zone(last_rows[clamp(cursor_row, 0, last_rows.count - 1)]);
}

// Move the call-graph focus to the most expensive caller of the focused zone; from the root, or
// outside call-graph mode, go back to the self-time list.
select_parent :: () {
    if displayed_quantity != .CALL_GRAPH || !graph_focus || graph_focus == *zones[0] {
        set_report_mode(.SELF_TIME);
        return;
    }
    best: *Zone;
    best_ms: float64 = -1;
    for every_node {
        if it.zone != graph_focus || !it.parent continue;
        ms := it.smooth[smoothing_level].hier_ms;
        if ms > best_ms {
            best_ms = ms;
            best = it.parent.zone;
        }
    }
    if best focus_zone(best);
}

// Logs the report as a fixed-width table.
log_text_report :: (report: *Report) {
    text := text_report(report);
    log("%", text);
    free(text);
}

// The report as text (what log_text_report prints). Allocated with the context allocator.
text_report :: (report: *Report) -> string {
    b: String_Builder;
    print_to_builder(*b, "%", report.title);
    if report.title_right print_to_builder(*b, "    [%]", report.title_right);
    append(*b, "\n");

    for col: 1..NUM_HEADER - 1 pad_left(*b, report.header[col], COLUMN_WIDTH);
    append(*b, "  ");
    append(*b, report.header[0]);
    append(*b, "\n");

    for report.records {
        cell(*b, it.value_flag & VALUE_SELF != 0, it.self_time, 3);
        cell(*b, it.value_flag & VALUE_HIER != 0, it.hier_time, 3);
        cell(*b, it.value_flag & VALUE_CALLS != 0, it.calls, -1);
        append(*b, "  ");
        for 1..it.indent append(*b, "  ");
        if it.prefix != #char " " && it.prefix != 0 {
            append(*b, it.prefix);
            append(*b, " ");
        }
        append(*b, it.name);
        append(*b, "\n");
    }
    return builder_to_string(*b);
}

// Writes the rows as CSV (zone,self_ms,hier_ms,calls,indent,file,line). Returns false if the file
// could not be written.
save_csv_report :: (report: *Report, filename: string) -> bool {
    b: String_Builder;
    append(*b, "zone,self_ms,hier_ms,calls,indent,file,line\n");
    for report.records {
        csv_quoted(*b, it.name);
        print_to_builder(*b, ",%,%,%,%,", it.self_time, it.hier_time, it.calls, it.indent);
        if it.zone {
            csv_quoted(*b, it.zone.full_path);
            print_to_builder(*b, ",%", it.zone.line);
        } else {
            append(*b, ",");
        }
        append(*b, "\n");
    }
    return write_entire_file(filename, *b);
}

get_reportmode_str :: (mode: Report_Mode) -> string {
    if mode == {
        case .SELF_TIME; return "self time";
        case .HIERARCHICAL_TIME; return "hierarchical time";
        case .CALL_COUNT; return "call count";
        case .CALL_GRAPH; return "call graph";
    }
    return "?";
}

#scope_module

COLUMN_WIDTH :: 12;

current_report: Report;
cursor_row: s64;
last_rows: [..] *Zone; // Zone of each row of the last report, for select().
graph_focus: *Zone;
focus_row: s64; // Row of graph_focus in the last call-graph report.
jump_to_focus_row := false;

// End of an auto-instrumented run. The run is treated as a single frame, which is closed
// here so its totals are in the summary that gets logged (and optionally saved as CSV).
write_exit_report :: (csv_filename: string) {
    update(record_data = true);
    summary := create_report();
    log_text_report(summary);
    if csv_filename.count == 0 return;
    saved := save_csv_report(summary, csv_filename);
    if saved log("Iprof: wrote the report to '%'.\n", csv_filename);
    else log_error("Iprof: could not write '%'.\n", csv_filename);
}

focus_zone :: (zone: *Zone) {
    if !zone return;
    graph_focus = zone;
    displayed_quantity = .CALL_GRAPH;
    jump_to_focus_row = true;
}

// Sets Zone.shown (and heat) for every entered zone from either the live averages or history.
pick_zone_values :: () {
    #if DO_HISTORY {
        if display_frame > 0 && frames_recorded > 0 {
            slot := history_slot(display_frame);
            for *zones {
                if !it.entered continue;
                h := *it.history[slot];
                it.shown = .{ h.self_ms, h.hier_ms, h.calls };
                it.heat = 0;
            }
            return;
        }
    }

    // Heat compares the latest frame with the slow average, so it needs both sums.
    column := sort_column();
    sum_zone_nodes(0);
    for *zones if it.entered it.heat = column_value(it.shown, column);
    sum_zone_nodes(SMOOTHING_LEVELS - 1);
    for *zones {
        if !it.entered continue;
        slow := column_value(it.shown, column);
        it.heat = min(abs(it.heat - slow) / max(slow, 0.001), 1.0);
    }
    sum_zone_nodes(smoothing_level);
}

sort_column :: () -> s64 {
    if displayed_quantity == .SELF_TIME return 1;
    if displayed_quantity == .CALL_COUNT return 3;
    return 2;
}

column_value :: (s: Sample64, column: s64) -> float64 {
    if column == 1 return s.self_ms;
    if column == 3 return s.calls;
    return s.hier_ms;
}

row_for :: (zone: *Zone, values: Sample64) -> Report_Row {
    row: Report_Row;
    row.name = zone.name;
    row.number = zone - zones.data;
    row.prefix = #char " ";
    row.value_flag = VALUE_SELF | VALUE_HIER | VALUE_CALLS;
    row.self_time = values.self_ms;
    row.hier_time = values.hier_ms;
    row.calls = values.calls;
    row.heat = zone.heat;
    row.zone = zone;
    return row;
}

set_titles :: (r: *Report, subject: string) {
    free(r.title);
    free(r.title_right);
    r.title = sprint("Iprof: %", subject);
    if display_frame > 0 r.title_right = sprint("frame -%", display_frame);
    else if frames_recorded == 1 r.title_right = copy_string("1 frame");
    else if smoothing_level == 0 r.title_right = copy_string("latest frame");
    else if smoothing_level == 1 r.title_right = copy_string("fast average");
    else r.title_right = copy_string("slow average");

    r.header[0] = "zone";
    r.header[1] = "self ms";
    r.header[2] = "hier ms";
    r.header[3] = "calls";
    r.hilit_header = cast(s32) sort_column();
}

fill_flat :: (r: *Report) {
    set_titles(r, get_reportmode_str(displayed_quantity));
    for *zones {
        if !it.entered continue;
        array_add(*r.records, row_for(it, it.shown));
    }
    order_rows(r.records, sort_column());
}

// Rows sorted by `column`, largest first; equal values keep zone order.
order_rows :: (rows: [] Report_Row, column: s64) {
    // Insertion sort: reports have tens of rows, and it is stable.
    for i: 1..rows.count - 1 {
        row := rows[i];
        key := row_column(row, column);
        j := i - 1;
        while j >= 0 && row_column(rows[j], column) < key {
            rows[j + 1] = rows[j];
            j -= 1;
        }
        rows[j + 1] = row;
    }
}

row_column :: (row: Report_Row, column: s64) -> float64 {
    if column == 1 return row.self_time;
    if column == 3 return row.calls;
    return row.hier_time;
}

// Per-zone sums for the callers or callees of the focused zone.
Edge :: struct {
    zone: *Zone;
    values: Sample64;
}

add_to_edge :: (edges: *[..] Edge, zone: *Zone, node: *Call_Node) {
    v := node.smooth[smoothing_level];
    if !node.outermost v.hier_ms = 0;
    for *edges.* {
        if it.zone != zone continue;
        it.values.self_ms += v.self_ms;
        it.values.hier_ms += v.hier_ms;
        it.values.calls += v.calls;
        return;
    }
    array_add(edges, .{ zone, v });
}

fill_call_graph :: (r: *Report) {
    if !graph_focus graph_focus = *zones[0];
    focus := graph_focus;
    set_titles(r, tprint("call graph of %", focus.name));

    callers: [..] Edge;
    callees: [..] Edge;
    callers.allocator = temp;
    callees.allocator = temp;
    for every_node {
        if it.zone != focus continue;
        if it.parent && it.parent.zone != focus add_to_edge(*callers, it.parent.zone, it);
        child := it.first_child;
        while child {
            if child.zone != focus add_to_edge(*callees, child.zone, child);
            child = child.next_sibling;
        }
    }

    first := r.records.count;
    for callers {
        row := row_for(it.zone, it.values);
        row.prefix = #char "<";
        array_add(*r.records, row);
    }
    order_rows(array_view(r.records, first, r.records.count - first), 2);

    focus_row = r.records.count;
    centre := row_for(focus, focus.shown);
    centre.prefix = #char "*";
    centre.indent = 1;
    array_add(*r.records, centre);

    first = r.records.count;
    for callees {
        row := row_for(it.zone, it.values);
        row.prefix = #char ">";
        row.indent = 2;
        array_add(*r.records, row);
    }
    order_rows(array_view(r.records, first, r.records.count - first), 2);
}

pad_left :: (b: *String_Builder, s: string, width: s64) {
    for s.count..width - 1 append(b, " ");
    append(b, s);
}

// One numeric column; "-" when the row has no value there.
cell :: (b: *String_Builder, present: bool, value: float64, decimals: s64) {
    pad_left(b, ifx present then number_text(value, decimals) else "-", COLUMN_WIDTH);
}

// decimals < 0: whole numbers print without a fraction, others with one digit. Temporary storage.
number_text :: (value: float64, decimals: s64) -> string {
    digits := decimals;
    if digits < 0 digits = ifx value == cast(float64) cast(s64) value then 0 else 1;
    return tprint("%", formatFloat(value, trailing_width = digits, zero_removal = .NO));
}

csv_quoted :: (b: *String_Builder, s: string) {
    append(b, "\"");
    for 0..s.count - 1 {
        if s[it] == #char "\"" append(b, "\"");
        append(b, s[it]);
    }
    append(b, "\"");
}

#import "Basic";
#import "Math";
#import "File";
