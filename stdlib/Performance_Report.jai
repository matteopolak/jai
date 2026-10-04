// Metaprogram plugin: asks the compiler for performance data and prints a text report
// (time, #run, polymorph and bytecode statistics) once compilation completes.
get_plugin :: () -> *Plugin {
    p := New(My);
    p.before_intercept = before_intercept;
    p.message          = message;
    return p;
}

#scope_module

before_intercept :: (p: *Plugin, flags: *Intercept_Flags) {
    flags.* |= .DO_PERFORMANCE_REPORT_POLYMORPHS | .DO_PERFORMANCE_REPORT_RUNS;
}

plural :: (x: s64) -> string {
    if x != 1 return "s";
    return "";
}

// The report arrives before COMPLETE; we hold on to it and print at the very end so the
// output is not interleaved with link lines or other plugins.
message :: (p: *Plugin, message: *Message) {
    my := cast(*My) p;
    if message.kind == {
        case .PERFORMANCE_REPORT; my.report = cast(*Message_Performance_Report) message;
        case .COMPLETE;           print_performance_report(my);
    }
}

print_performance_report :: (my: *My) {
    if !my.report {
        write_string("Performance_Report did not receive a PERFORMANCE_REPORT message from the compiler, so no report can be generated. The plugin may not be initialized, or another plugin disabled the intercept flags.\n");
        return;
    }

    builder: String_Builder;

    print_time_report(my, *builder);

    append(*builder, "\n");
    if my.report.run_directive_report.reported  print_run_directive_report(my, *builder);
    else append(*builder, "--- (#run Report was not selected, so this report is empty.) ---\n");

    append(*builder, "\n");
    if my.report.polymorph_report.reported  print_polymorph_report(my, *builder);

    append(*builder, "\n");
    print_bytecode_report(my, *builder);

    result := builder_to_string(*builder);
    write_string(result);
    free(result);
}

print_time_report :: (my: *My, builder: *String_Builder) {
    append(builder, "----- Time Report: -----\n");
    time := *my.report.time_report;
    print_to_builder(builder, "#runs:               %\n", time.run_directives);
    print_to_builder(builder, "bytecode inlining:   %\n", time.bytecode_inlining);
    print_to_builder(builder, "bytecode generating: %\n", time.bytecode_generating);
}

print_bytecode_report :: (my: *My, builder: *String_Builder) {
    append(builder, "----- Bytecode Report: -----\n");
    r := *my.report.bytecode_report;
    print_to_builder(builder, "calls inlined:        %\n", r.num_calls_inlined);
    print_to_builder(builder, "calls total:          %\n", r.num_calls_total);
    print_to_builder(builder, "instructions inlined: %\n", r.num_instructions_inlined);
    print_to_builder(builder, "instructions total:   %\n", r.num_instructions_total);
}

print_run_directive_report :: (my: *My, builder: *String_Builder) {
    append(builder, "----- #run Report: -----\n");
    runs := *my.report.run_directive_report;

    // Sort a copy of pointers, never the compiler-owned records.
    sorted: [..] *runs.Record;
    array_reserve(*sorted, runs.records.count);
    for * r: runs.records  array_add(*sorted, r);
    quick_sort(sorted, x => -x.elapsed_time);

    for r: sorted {
        callee := r.callee;
        print_to_builder(builder, "[%:%,%] stalls: % elapsed: %\n", callee.enclosing_load.fully_pathed_filename, callee.l0, callee.c0, r.num_stalls, r.elapsed_time);
    }
}

print_polymorph_report :: (my: *My, builder: *String_Builder) {
    append(builder, "----- Polymorph Report: -----\n");
    poly := *my.report.polymorph_report;
    print_to_builder(builder, "Solves invoked: %\n", poly.num_solves_invoked);
    print_to_builder(builder, "Solves used:    %\n", poly.num_solves_used);
    append(builder, "\n");

    if !poly.reported {
        append(builder, "--- (Polymorph Report was not selected, so the rest of this report is empty.) ---\n");
        return;
    }

    old := Program_Print.print_procedure_bodies;
    Program_Print.print_procedure_bodies = false;
    defer Program_Print.print_procedure_bodies = old;

    sorted: [..] *poly.Record;
    array_reserve(*sorted, poly.records.count);
    for * r: poly.records  array_add(*sorted, r);
    quick_sort(sorted, x => -x.num_call_sites);

    total_constants_dedup := 0;
    total_bytecode_dedup  := 0;
    total_polymorphs      := 0;

    for r: sorted {
        source := r.source;
        print_to_builder(builder, "% [%:%,%]\n", source.name, source.enclosing_load.fully_pathed_filename, source.l0, source.c0);
        print_to_builder(builder, "  % call site%, % constants_dedup, % bytecode_dedup\n", r.num_call_sites, plural(r.num_call_sites), r.num_deduplications_by_constants, r.num_deduplications_by_bytecode);

        total_constants_dedup += r.num_deduplications_by_constants;
        total_bytecode_dedup  += r.num_deduplications_by_bytecode;

        count := r.distinct_polymorphs.count;
        print_to_builder(builder, "  % polymorph%:\n", count, plural(count));
        total_polymorphs += count;

        for * distinct: r.distinct_polymorphs {
            params := get_constants_block_string(distinct.polymorphed);
            loc := distinct.location;
            print_to_builder(builder, "    (%) [%:%,%]\n", params, loc.fully_pathed_filename, loc.line_number, loc.character_number);
        }
        append(builder, "\n");
    }

    print_to_builder(builder, "\nTotal constants dedup: %\nTotal bytecode dedup: %\nTotal polymorphs: %\n", total_constants_dedup, total_bytecode_dedup, total_polymorphs);
    append(builder, "\n");
}

// Program_Print cannot yet reconstruct arbitrary expressions, so print the common
// shapes of polymorph arguments (identifiers and literals) and elide the rest.
print_simple_expression :: (builder: *String_Builder, node: *Code_Node) {
    if !node { append(builder, "?"); return; }
    if node.kind == {
        case .IDENT;
            append(builder, (cast(*Code_Ident) node).name);
        case .LITERAL;
            literal := cast(*Code_Literal) node;
            if literal.value_type == {
                case .NUMBER;  print_to_builder(builder, "%", literal._s64);
                case .STRING;  print_to_builder(builder, "\"%\"", literal._string);
                case .BOOLEAN; print_to_builder(builder, "%", literal._s64 != 0);
                case;          append(builder, "...");
            }
        case;
            append(builder, "...");
    }
}

get_constants_block_string :: (header: *Code_Procedure_Header) -> string {
    block := header.constants_block;
    if !block.members return "";

    builder: String_Builder;
    for block.members {
        decl := cast(*Code_Declaration) it;
        assert(decl.kind == .DECLARATION);
        if it_index > 0  append(*builder, ", ");
        print_to_builder(*builder, "%=", decl.name);
        print_simple_expression(*builder, decl.expression);
    }
    return builder_to_string(*builder);
}

#import "Basic";
#import "Compiler";
#import "Sort";

Program_Print :: #import "Program_Print";

Plugin :: Metaprogram_Plugin;

My :: struct {
    #as using base: Plugin;
    report: *Message_Performance_Report;
}
