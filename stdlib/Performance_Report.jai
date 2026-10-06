// Performance_Report: a metaprogram plugin that switches on the compiler's performance
// statistics and prints them as plain text when the build is done. Sections: timings,
// bytecode inlining, #run directives (slowest first) and polymorph instantiations
// (most call sites first).
get_plugin :: () -> *Metaprogram_Plugin {
    state := New(Report_Plugin);
    state.before_intercept = request_statistics;
    state.message = on_compiler_message;
    return state;
}

#scope_module

#import "Basic";
#import "Compiler";
#import "Sort";
Program_Print :: #import "Program_Print";

Report_Plugin :: struct {
    #as using plugin: Metaprogram_Plugin;
    statistics: *Message_Performance_Report;
}

// Width of the label column in "label   value" rows.
LABEL_COLUMN :: 26;

request_statistics :: (plugin: *Metaprogram_Plugin, flags: *Intercept_Flags) {
    flags.* |= .DO_PERFORMANCE_REPORT_RUNS;
    flags.* |= .DO_PERFORMANCE_REPORT_POLYMORPHS;
}

on_compiler_message :: (plugin: *Metaprogram_Plugin, message: *Message) {
    state := cast(*Report_Plugin) plugin;

    // The statistics arrive before COMPLETE. Holding them until then keeps the report
    // after everything else the build prints.
    if message.kind == .PERFORMANCE_REPORT {
        state.statistics = cast(*Message_Performance_Report) message;
        return;
    }
    if message.kind != .COMPLETE return;

    if state.statistics == null {
        write_string("Performance_Report: no performance statistics arrived from the compiler; nothing to report. (Was the plugin's before_intercept skipped, or the flags cleared by another plugin?)\n");
        return;
    }

    out: String_Builder;
    write_timings(*out, state.statistics);
    write_bytecode(*out, state.statistics);
    write_runs(*out, state.statistics);
    write_polymorphs(*out, state.statistics);
    text := builder_to_string(*out);
    write_string(text);
    free(text);
}

heading :: (out: *String_Builder, title: string) {
    print_to_builder(out, "\n== % ==\n", title);
}

row :: (out: *String_Builder, label: string, value: Any) {
    append(out, "  ");
    append(out, label);
    padding := LABEL_COLUMN - label.count;
    while padding > 0 {
        append(out, " ");
        padding -= 1;
    }
    print_to_builder(out, "%\n", value);
}

write_timings :: (out: *String_Builder, stats: *Message_Performance_Report) {
    heading(out, "Time");
    row(out, "#run directives", stats.time_report.run_directives);
    row(out, "bytecode generation", stats.time_report.bytecode_generating);
    row(out, "bytecode inlining", stats.time_report.bytecode_inlining);
}

write_bytecode :: (out: *String_Builder, stats: *Message_Performance_Report) {
    counts := stats.bytecode_report;
    heading(out, "Bytecode");
    row(out, "calls", counts.num_calls_total);
    row(out, "calls inlined", counts.num_calls_inlined);
    row(out, "instructions", counts.num_instructions_total);
    row(out, "instructions inlined", counts.num_instructions_inlined);
}

Run_Record :: Run_Directive_Report.Record;
Polymorph_Record :: Polymorph_Report.Record;

slowest_first :: (a: Run_Record, b: Run_Record) -> s64 {
    if a.elapsed_time > b.elapsed_time return -1;
    if a.elapsed_time < b.elapsed_time return 1;
    return 0;
}

busiest_first :: (a: Polymorph_Record, b: Polymorph_Record) -> s64 {
    return b.num_call_sites - a.num_call_sites;
}

write_runs :: (out: *String_Builder, stats: *Message_Performance_Report) {
    heading(out, "#run directives");
    if !stats.run_directive_report.reported {
        append(out, "  (not collected)\n");
        return;
    }

    // Sort copies: the records belong to the compiler.
    ordered: [..] Run_Record;
    defer array_free(ordered);
    array_add(*ordered, ..stats.run_directive_report.records);
    quick_sort(ordered, slowest_first);

    for ordered {
        print_to_builder(out, "  %  %  (stalls: %)\n", it.elapsed_time, source_position(it.callee), it.num_stalls);
    }
}

write_polymorphs :: (out: *String_Builder, stats: *Message_Performance_Report) {
    report := *stats.polymorph_report;
    heading(out, "Polymorphs");
    row(out, "solves invoked", report.num_solves_invoked);
    row(out, "solves used", report.num_solves_used);
    if !report.reported {
        append(out, "  (per-procedure detail not collected)\n");
        return;
    }

    ordered: [..] Polymorph_Record;
    defer array_free(ordered);
    array_add(*ordered, ..report.records);
    quick_sort(ordered, busiest_first);

    instantiations, by_constants, by_bytecode: s64;
    for record: ordered {
        name := ifx record.source then record.source.name else "?";
        print_to_builder(out, "\n  % at %\n", name, source_position(record.source));
        print_to_builder(out, "    call sites: %; deduplicated: % by constants, % by bytecode\n",
                         record.num_call_sites, record.num_deduplications_by_constants, record.num_deduplications_by_bytecode);
        print_to_builder(out, "    distinct instantiations: %\n", record.distinct_polymorphs.count);
        for record.distinct_polymorphs {
            append(out, "      (");
            write_constants(out, it.polymorphed);
            print_to_builder(out, ") from %:%\n", it.location.fully_pathed_filename, it.location.line_number);
        }
        instantiations += record.distinct_polymorphs.count;
        by_constants += record.num_deduplications_by_constants;
        by_bytecode += record.num_deduplications_by_bytecode;
    }

    append(out, "\n");
    row(out, "distinct instantiations", instantiations);
    row(out, "deduplicated (constants)", by_constants);
    row(out, "deduplicated (bytecode)", by_bytecode);
}

source_position :: (node: *Code_Node) -> string {
    if !node return "<unknown>";
    loc := make_location(node);
    return tprint("%:%:%", loc.fully_pathed_filename, loc.line_number, loc.character_number);
}

// The baked constants of one instantiation, e.g. "T=float, N=3".
write_constants :: (out: *String_Builder, header: *Code_Procedure_Header) {
    if !header || !header.constants_block return;
    separator := "";
    for entry: header.constants_block.members {
        if entry.kind != .DECLARATION continue;
        declaration := cast(*Code_Declaration) entry;
        print_to_builder(out, "%1%2=", separator, declaration.name);
        separator = ", ";
        if !Program_Print.print_expression(out, declaration.expression) append(out, "?");
    }
}
