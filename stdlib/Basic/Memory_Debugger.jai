// Independently authored allocation history, reachability, and leak reporting.
#scope_file
MD_Tables :: #import "legacy/Hash_Table";
MD_Pool :: #import "legacy/Pool";
MD_Compiler :: #import "Compiler";
#scope_export
#add_context inside_memory_debugger := false;
#add_context __basic_memory_debugger_lock_owned := false;
#load "Memory_Debugger_Core.jai";
#scope_export

Procedure_To_Elide :: struct { procedure_name: string; module_name: string; }
Leak_Report_Options :: struct {
    known_allocation_leaves: []Procedure_To_Elide;
    roots_to_skip: []Procedure_To_Elide;
    group_by_these_calls: []Procedure_To_Elide;
    scan_global_memory_to_remove_leaks := true;
    scan_leaks_to_combine := true;
}
Leak_Combiner_Record :: struct {
    child_count: s64;
    child_bytes: s64;
    my_bytes_were_combined_into_this_parent: *void;
}
Leak_Report :: struct {
    marked_as_non_leak_allocations: s64;
    marked_as_non_leak_bytes: s64;
    sorted_summaries: []*Leak_Summary;
    leak_combiner_table: MD_Tables.Table(*void, Leak_Combiner_Record);
    pool: MD_Pool.Pool;
}
Leak_Summary :: struct {
    count: s64;
    bytes: s64;
    allocations_since_last_visualizer_update: s64;
    bytes_allocated_since_last_visualizer_update: s64;
    alloc_site_trace: *Packed_Stack_Trace;
    allocator_proc: Allocator_Proc;
    group_info: *Group_Info;
    child_count: s64;
    child_bytes: s64;
}
Group_Info :: struct {
    procedure: Procedure_To_Elide;
    sub_summaries: []*Leak_Summary;
    root_nodes_in_common: s64;
    leaf_nodes_in_common: s64;
}

Preamble :: () #expand {
    if context.inside_memory_debugger `return;
    if _md_ignore_allocator(`allocator) `return;
    context.inside_memory_debugger = true;
    `defer context.inside_memory_debugger = false;
}
add_allocation_to_table :: (memory: *void, size: s64, allocator: Allocator, trace: *Stack_Trace_Node) {
    mode := _md_compat_begin(allocator);
    if mode == 0 return;
    defer _md_compat_end(mode);
    _md_diagnose(md_alloc(*md_state, allocator, memory, size, trace, context.thread_index), "add_allocation_to_table", memory);
}
add_allocation_this_frame :: (a: *Allocation, size: s64) {
    mode := _md_compat_begin(a.allocator);
    if mode == 0 return;
    defer _md_compat_end(mode);
    record := md_find(*md_state, a.pointer);
    if !record { _md_diagnose(.UNKNOWN_MEMORY, "add_allocation_this_frame", a.pointer); return; }
    md_note_frame(*md_state, record, size);
    a.visualization_update_cycle = md_state.frame_cycle;
}
add_free_this_frame :: (a: *Allocation, size: s64) {
    mode := _md_compat_begin(a.allocator);
    if mode == 0 return;
    defer _md_compat_end(mode);
    record := md_find(*md_state, a.pointer);
    if !record { _md_diagnose(.UNKNOWN_MEMORY, "add_free_this_frame", a.pointer); return; }
    md_note_free_frame(*md_state, record, size);
    a.visualization_update_cycle = md_state.frame_cycle;
}

_check_alloc :: inline (allocator: Allocator, memory: *void, size: s64) {
    if !memory || !_md_begin(allocator) return;
    #if VISUALIZE_MEMORY_DEBUGGER defer vis_update_if_it_has_been_long_enough();
    defer _md_end();
    _md_diagnose(md_alloc(*md_state, allocator, memory, size, context.stack_trace, context.thread_index), "alloc", memory);
}
_check_free :: inline (allocator: Allocator, memory: *void) {
    if !memory || !_md_begin(allocator) return;
    #if VISUALIZE_MEMORY_DEBUGGER defer vis_update_if_it_has_been_long_enough();
    defer _md_end();
    _md_diagnose(md_free(*md_state, allocator, memory, context.stack_trace), "free", memory);
}
_check_realloc :: inline (allocator: Allocator, old_memory: *void, old_size: s64, new_memory: *void, new_size: s64) {
    if !_md_begin(allocator) return;
    #if VISUALIZE_MEMORY_DEBUGGER defer vis_update_if_it_has_been_long_enough();
    defer _md_end();
    status := md_realloc(*md_state, allocator, old_memory, old_size, new_memory, new_size, context.stack_trace, context.thread_index);
    if status != .FAILED_REALLOC _md_diagnose(status, "realloc", old_memory);
}
_check_create_heap :: (a: Allocator) {
    if !_md_begin(a) return;
    defer _md_end();
    heap := md_raw_new(*md_state, MD_Heap);
    assert(heap != null, "memory debugger heap registry allocation failed");
    if !heap return;
    heap.allocator = a;
    heap.next = md_heaps;
    md_heaps = heap;
}
_check_destroy_heap :: (a: Allocator) {
    if !_md_begin(a) return;
    defer _md_end();
    _md_diagnose(md_destroy_heap(*md_state, a, context.stack_trace), "destroy_heap", a.data);
    cursor := md_heaps;
    while cursor {
        if md_same_allocator(cursor.allocator, a) cursor.destroyed = true;
        cursor = cursor.next;
    }
}
allocations_before_this_call_will_not_be_considered_leaks :: () {
    if !_md_begin(.{}) return;
    defer _md_end();
    md_state.first_report_index = md_state.next_index;
}
this_allocation_is_not_a_leak :: (memory: *void) {
    if !_md_begin(.{}) return;
    defer _md_end();
    record := md_find(*md_state, memory);
    assert(record != null && record.allocation.is_live, "leak annotation requires a live tracked allocation");
    if record && record.allocation.is_live record.ignored = true;
}
this_allocation_leaks_todo :: (memory: *void) { this_allocation_is_not_a_leak(memory); }
this_allocation_does_not_propagate_leak_ownership :: (memory: *void) {
    if !_md_begin(.{}) return;
    defer _md_end();
    record := md_find(*md_state, memory);
    assert(record != null && record.allocation.is_live, "ownership annotation requires a live tracked allocation");
    if record && record.allocation.is_live record.allocation.propagates_leak_ownership = false;
}
report_memory_leaks :: (options: Leak_Report_Options = .{}) {
    report := make_leak_report(options);
    defer deinit(*report);
    log_leak_report(report, options);
}
make_leak_report :: (options: Leak_Report_Options = .{}, for_visualizer := false) -> Leak_Report {
    report: Leak_Report;
    if !_md_begin(.{}) return report;
    defer _md_end();
    MD_Pool.set_allocators(*report.pool, md_state.storage_allocator);
    report.leak_combiner_table.allocator = md_state.storage_allocator;
    live_count: s64;
    cursor := md_state.records;
    while cursor {
        if cursor.allocation.is_live live_count += 1;
        cursor = cursor.next;
    }
    rows := cast(*MD_Report_Row)MD_Pool.get(*report.pool, live_count * size_of(MD_Report_Row));
    count: s64;
    cursor = md_state.records;
    while cursor {
        if cursor.allocation.is_live {
            rows[count] = .{};
            rows[count].record = cursor;
            rows[count].marked = !for_visualizer && !md_is_leak(*md_state, cursor);
            count += 1;
        }
        cursor = cursor.next;
    }
    if !for_visualizer && options.scan_global_memory_to_remove_leaks {
        runtime := MD_Compiler.get_runtime_info();
        if !runtime.global_data_info {
            log_error("memory debugger requires compiler runtime global-data metadata\n");
            Runtime_Support.debug_break();
            return report;
        }
        for *segment: runtime.global_data_info.segment_info _md_mark_referenced(rows, count, segment.data.data, segment.data.count);
    }
    // Propagate reachability from explicitly ignored allocations and globals.
    changed := true;
    while changed {
        changed = false;
        for i: 0..count-1 {
            if !rows[i].marked || !rows[i].record.allocation.propagates_leak_ownership continue;
            allocation := *rows[i].record.allocation;
            if _md_mark_referenced(rows, count, allocation.pointer, allocation.size) changed = true;
        }
    }
    for i: 0..count-1 {
        if rows[i].marked {
            report.marked_as_non_leak_allocations += 1;
            report.marked_as_non_leak_bytes += rows[i].record.allocation.size;
        }
    }
    if options.scan_leaks_to_combine {
        // Prefer true graph roots, then retain one root per remaining cycle.
        for parent: 0..count-1 {
            if rows[parent].marked || !rows[parent].record.allocation.propagates_leak_ownership continue;
            allocation := *rows[parent].record.allocation;
            for child: 0..count-1 {
                if child == parent || rows[child].marked continue;
                if _md_points_at(allocation.pointer, allocation.size, rows[child].record.allocation.pointer) rows[child].incoming += 1;
            }
        }
        for i: 0..count-1 {
            if rows[i].marked || rows[i].incoming != 0 continue;
            rows[i].visited = true;
            _md_combine(*report, rows, count, i);
        }
        for i: 0..count-1 {
            if rows[i].marked || rows[i].visited continue;
            rows[i].visited = true;
            _md_combine(*report, rows, count, i);
        }
    }
    pointers := cast(**Leak_Summary)MD_Pool.get(*report.pool, count * size_of(*Leak_Summary));
    summary_count: s64;
    for i: 0..count-1 {
        if rows[i].marked || rows[i].parent >= 0 continue;
        allocation := *rows[i].record.allocation;
        trace := _md_copy_trace(*report.pool, allocation.alloc_site_trace);
        summary: *Leak_Summary;
        for j: 0..summary_count-1 {
            if md_trace_matches(pointers[j].alloc_site_trace, trace) { summary = pointers[j]; break; }
        }
        if !summary {
            summary = cast(*Leak_Summary)MD_Pool.get(*report.pool, size_of(Leak_Summary));
            summary.* = .{};
            summary.alloc_site_trace = trace;
            summary.allocator_proc = allocation.allocator.proc;
            pointers[summary_count] = summary;
            summary_count += 1;
        } else if summary.allocator_proc != allocation.allocator.proc summary.allocator_proc = null;
        summary.count += 1;
        summary.bytes += allocation.size;
        summary.child_count += rows[i].child_count;
        summary.child_bytes += rows[i].child_bytes;
        if rows[i].record.frame_cycle == md_state.frame_cycle {
            summary.allocations_since_last_visualizer_update += rows[i].record.frame_allocations;
            summary.bytes_allocated_since_last_visualizer_update += rows[i].record.frame_bytes;
        }
    }
    report.sorted_summaries = .{summary_count, pointers};
    for procedure: options.group_by_these_calls _md_group(*report, procedure);
    _md_sort_summaries(report.sorted_summaries);
    return report;
}
log_leak_report :: (report: Leak_Report, options: Leak_Report_Options = .{}) {
    bytes_total: s64;
    leaks_total: s64;
    for summary: report.sorted_summaries {
        from_root := -1;
        from_leaf := -1;
        grouped := "";
        if summary.group_info {
            info := summary.group_info;
            grouped = tprint(", grouped from % stack traces for \"%\" in \"%\"", _md_commas(info.sub_summaries.count), info.procedure.procedure_name, info.procedure.module_name);
            from_root = info.root_nodes_in_common;
            from_leaf = info.leaf_nodes_in_common;
        }
        if summary.child_count {
            bytes := summary.bytes + summary.child_bytes;
            count := summary.count + summary.child_count;
            log("\n----- % byte% in % allocation%% [including aggregated children pointed at by the original memory, which % % byte% in % allocation%] -----\n",
                _md_commas(bytes), _md_plural(bytes), _md_commas(count), _md_plural(count), grouped,
                ifx summary.count > 1 then "were" else "was", _md_commas(summary.bytes), _md_plural(summary.bytes), _md_commas(summary.count), _md_plural(summary.count));
        } else {
            log("\n----- % byte% in % allocation%% -----\n", _md_commas(summary.bytes), _md_plural(summary.bytes), _md_commas(summary.count), _md_plural(summary.count), grouped);
        }
        bytes_total += summary.bytes + summary.child_bytes;
        leaks_total += summary.count + summary.child_count;

        trace := summary.alloc_site_trace;
        if !trace {
            log("(stack trace unavailable)\n");
            continue;
        }
        first := 0;
        last := trace.nodes.count - 1;
        if options.known_allocation_leaves || options.roots_to_skip || options.group_by_these_calls {
            first, last = _md_trim_trace(options, trace);
        }
        _md_log_trace(trace, first, last, from_root, from_leaf, summary.group_info);
    }
    log("\nTotal: % byte% in % allocation%.\n", _md_commas(bytes_total), _md_plural(bytes_total), _md_commas(leaks_total), _md_plural(leaks_total));
    log("\nMarked as non-leaks: % byte% in % allocation%.\n", _md_commas(report.marked_as_non_leak_bytes), _md_plural(report.marked_as_non_leak_bytes), _md_commas(report.marked_as_non_leak_allocations), _md_plural(report.marked_as_non_leak_allocations));
}
deinit :: (report: *Leak_Report) {
    previous := context.inside_memory_debugger;
    context.inside_memory_debugger = true;
    defer context.inside_memory_debugger = previous;
    MD_Tables.deinit(*report.leak_combiner_table);
    MD_Pool.release(*report.pool);
    report.* = .{};
}
init :: () {
    if !_md_begin(.{}) return;
    _md_end();
}
// Release retained history at an explicit process/debugger lifecycle boundary.
deinit_memory_debugger :: () {
    if !_md_begin(.{}) return;
    defer _md_end();
    heap := md_heaps;
    while heap {
        next := heap.next;
        md_state.storage_allocator.proc(.FREE, 0, size_of(MD_Heap), heap, md_state.storage_allocator.data);
        heap = next;
    }
    md_heaps = null;
    md_deinit(*md_state);
}

#scope_module
MD_Heap :: struct { allocator: Allocator; destroyed: bool; next: *MD_Heap; }
MD_Report_Row :: struct {
    record: *MD_Record;
    marked: bool;
    visited: bool;
    parent: s64 = -1;
    child_count: s64;
    child_bytes: s64;
    incoming: s64;
}
md_state: MD_State;
md_heaps: *MD_Heap;
md_owner_context: *void;
md_owner_thread_index: u32;

_md_begin :: (allocator: Allocator) -> bool {
    if context.inside_memory_debugger return false;
    context.inside_memory_debugger = true;
    if _md_ignore_allocator(allocator) { context.inside_memory_debugger = false; return false; }
    _md_acquire();
    _md_prepare_state();
    return true;
}
_md_acquire :: () {
    while true {
        acquired, previous := compare_and_swap(*md_owner_context, cast(*void)null, cast(*void)*context);
        if acquired break;
    }
    indexed, previous := compare_and_swap(*md_owner_thread_index, cast(u32)0, context.thread_index);
    context.__basic_memory_debugger_lock_owned = true;
}
_md_prepare_state :: () {
    if !md_state.storage_allocator.proc md_state.storage_allocator = Runtime_Support.Context_Base.default_allocator;
}
_md_end :: () {
    _md_release();
    context.inside_memory_debugger = false;
}
_md_release :: () {
    unindexed, previous := compare_and_swap(*md_owner_thread_index, context.thread_index, cast(u32)0);
    released, previous_context := compare_and_swap(*md_owner_context, cast(*void)*context, cast(*void)null);
    context.__basic_memory_debugger_lock_owned = false;
}
_md_ignore_allocator :: (allocator: Allocator) -> bool {
    if allocator.proc == temporary_allocator_proc return true;
    if allocator.proc {
        caps, name := get_capabilities_info(allocator);
        if caps & .HINT_I_AM_A_FAST_BUMP_ALLOCATOR return true;
    }
    return false;
}
_md_compat_begin :: (allocator: Allocator) -> u8 {
    if !context.inside_memory_debugger {
        if !_md_begin(allocator) return 0;
        return 1;
    }
    // A copied Context flag can outlive the original critical section. Reuse
    // only the active gate owned by this real context and thread index.
    if context.__basic_memory_debugger_lock_owned {
        active, previous := compare_and_swap(*md_owner_context, cast(*void)*context, cast(*void)*context);
        if active {
            same_thread, previous := compare_and_swap(*md_owner_thread_index, context.thread_index, context.thread_index);
            if same_thread return 2;
        }
    }
    context.__basic_memory_debugger_lock_owned = false;
    if _md_ignore_allocator(allocator) return 0;
    _md_acquire();
    _md_prepare_state();
    return 3;
}
_md_compat_end :: (mode: u8) {
    if mode == 1 _md_end();
    else if mode == 3 _md_release();
}
#scope_file
_md_diagnose :: (status: MD_Status, operation: string, memory: *void) {
    if status == .OK return;
    log_error("Memory debugger %: % at %\n", operation, status, memory);
    record := md_find(*md_state, memory);
    if record && record.allocation.alloc_site_trace {
        for node: record.allocation.alloc_site_trace.nodes {
            if node.info log_error("  allocated by % at %:%\n", node.info.name, node.info.location.fully_pathed_filename, node.line_number);
        }
    }
    log_stack_trace(context.stack_trace);
    Runtime_Support.debug_break();
}
_md_points_at :: (memory: *void, bytes: s64, target: *void) -> bool {
    offset: s64;
    while offset <= bytes - size_of(*void) {
        candidate: *void;
        memcpy(*candidate, cast(*u8)memory + offset, size_of(*void));
        if candidate == target return true;
        offset += size_of(*void);
    }
    return false;
}
_md_mark_referenced :: (rows: *MD_Report_Row, count: s64, memory: *void, bytes: s64) -> bool {
    changed := false;
    for i: 0..count-1 {
        if !rows[i].marked && _md_points_at(memory, bytes, rows[i].record.allocation.pointer) {
            rows[i].marked = true;
            changed = true;
        }
    }
    return changed;
}
_md_combine :: (report: *Leak_Report, rows: *MD_Report_Row, count: s64, parent: s64) {
    allocation := *rows[parent].record.allocation;
    if !allocation.propagates_leak_ownership return;
    for child: 0..count-1 {
        if rows[child].marked || rows[child].visited || rows[child].parent >= 0 continue;
        if !_md_points_at(allocation.pointer, allocation.size, rows[child].record.allocation.pointer) continue;
        rows[child].parent = parent;
        rows[child].visited = true;
        _md_combine(report, rows, count, child);
        rows[parent].child_count += 1 + rows[child].child_count;
        rows[parent].child_bytes += rows[child].record.allocation.size + rows[child].child_bytes;
    }
    value: Leak_Combiner_Record;
    value.child_count = rows[parent].child_count;
    value.child_bytes = rows[parent].child_bytes;
    if rows[parent].parent >= 0 value.my_bytes_were_combined_into_this_parent = rows[rows[parent].parent].record.allocation.pointer;
    MD_Tables.table_set(*report.leak_combiner_table, rows[parent].record.allocation.pointer, value);
}
_md_copy_trace :: (pool: *MD_Pool.Pool, source: *Packed_Stack_Trace) -> *Packed_Stack_Trace {
    if !source return null;
    result := cast(*Packed_Stack_Trace)MD_Pool.get(pool, size_of(Packed_Stack_Trace));
    result.* = source.*;
    result.nodes.data = cast(*Stack_Trace_Node)MD_Pool.get(pool, source.nodes.count * size_of(Stack_Trace_Node));
    for i: 0..source.nodes.count-1 result.nodes[i] = source.nodes[i];
    return result;
}
_md_procedure_matches :: (target: Procedure_To_Elide, node: Stack_Trace_Node) -> bool {
    if !node.info || node.info.name != target.procedure_name return false;
    if target.module_name.count == 0 return true;
    path := node.info.location.fully_pathed_filename;
    start: s64;
    while start < path.count {
        end := start;
        while end < path.count && path[end] != #char "/" && path[end] != cast(u8)0x5c end += 1;
        width := end - start;
        if width == target.module_name.count || (width == target.module_name.count+4 && path[end-4] == #char "." && path[end-3] == #char "j" && path[end-2] == #char "a" && path[end-1] == #char "i") {
            match := true;
            for i: 0..target.module_name.count-1 if path[start+i] != target.module_name[i] { match = false; break; }
            if match return true;
        }
        start = end + 1;
    }
    return false;
}
_md_has_call :: (summary: *Leak_Summary, target: Procedure_To_Elide) -> bool {
    if !summary.alloc_site_trace return false;
    for node: summary.alloc_site_trace.nodes if _md_procedure_matches(target, node) return true;
    return false;
}
_md_group :: (report: *Leak_Report, target: Procedure_To_Elide) {
    matches: s64;
    for summary: report.sorted_summaries if _md_has_call(summary, target) matches += 1;
    if matches < 2 return;
    group := cast(*Leak_Summary)MD_Pool.get(*report.pool, size_of(Leak_Summary));
    group.* = .{};
    info := cast(*Group_Info)MD_Pool.get(*report.pool, size_of(Group_Info));
    info.* = .{};
    info.procedure = target;
    info.sub_summaries = .{matches, cast(**Leak_Summary)MD_Pool.get(*report.pool, matches*size_of(*Leak_Summary))};
    group.group_info = info;
    retained: s64;
    grouped: s64;
    for summary: report.sorted_summaries {
        if _md_has_call(summary, target) {
            info.sub_summaries[grouped] = summary;
            grouped += 1;
            group.count += summary.count;
            group.bytes += summary.bytes;
            group.child_count += summary.child_count;
            group.child_bytes += summary.child_bytes;
            group.allocations_since_last_visualizer_update += summary.allocations_since_last_visualizer_update;
            group.bytes_allocated_since_last_visualizer_update += summary.bytes_allocated_since_last_visualizer_update;
        } else {
            report.sorted_summaries[retained] = summary;
            retained += 1;
        }
    }
    report.sorted_summaries[retained] = group;
    report.sorted_summaries.count = retained + 1;
    // Common physical trace prefixes/suffixes are computed from real nodes.
    first := info.sub_summaries[0].alloc_site_trace;
    if first {
        info.root_nodes_in_common = first.nodes.count;
        info.leaf_nodes_in_common = first.nodes.count;
        for i: 1..info.sub_summaries.count-1 {
            other := info.sub_summaries[i].alloc_site_trace;
            if !other { info.root_nodes_in_common = 0; info.leaf_nodes_in_common = 0; break; }
            same_leaf: s64;
            while same_leaf < info.leaf_nodes_in_common && same_leaf < other.nodes.count && first.nodes[same_leaf].info == other.nodes[same_leaf].info same_leaf += 1;
            info.leaf_nodes_in_common = same_leaf;
            same_root: s64;
            while same_root < info.root_nodes_in_common && same_root < other.nodes.count && first.nodes[first.nodes.count-1-same_root].info == other.nodes[other.nodes.count-1-same_root].info same_root += 1;
            info.root_nodes_in_common = same_root;
        }
    }
}
_md_sort_summaries :: (summaries: []*Leak_Summary) {
    for i: 1..summaries.count-1 {
        saved := summaries[i];
        position := i;
        while position > 0 && summaries[position-1].bytes + summaries[position-1].child_bytes < saved.bytes + saved.child_bytes {
            summaries[position] = summaries[position-1];
            position -= 1;
        }
        summaries[position] = saved;
    }
}
_md_commas :: (n: Any) -> FormatInt {
    result: FormatInt;
    result.digits_per_comma = 3;
    result.comma_string = ",";
    result.value = n;
    return result;
}
_md_plural :: (n: s64) -> string { return ifx n == 1 then "" else "s"; }
// Returns the displayed [first, last] node range: roots in roots_to_skip are trimmed
// from the end, and the leaf side starts after the rootmost known allocation leaf.
_md_trim_trace :: (options: Leak_Report_Options, trace: *Packed_Stack_Trace) -> (first: s64, last: s64) {
    last := trace.nodes.count - 1;
    while last >= 0 {
        node := trace.nodes[last];
        if !node.info { last -= 1; continue; }
        skip := false;
        for options.roots_to_skip if _md_procedure_matches(it, node) { skip = true; break; }
        if !skip break;
        last -= 1;
    }
    i := last;
    while i >= 0 {
        for leaf: options.known_allocation_leaves if _md_procedure_matches(leaf, trace.nodes[i]) return i, last;
        i -= 1;
    }
    return 0, last;
}
_md_log_trace :: (trace: *Packed_Stack_Trace, first_in: s64, last_in: s64, from_root: s64, from_leaf: s64, group_info: *Group_Info) {
    first := first_in;
    last := last_in;
    ellipses_start := from_leaf;
    if ellipses_start <= first && ellipses_start > 0 first = ellipses_start - 1;

    longest := 0;
    for i: first..last {
        node := trace.nodes[i];
        if node.info longest = max(longest, node.info.name.count);
    }
    longest = min(longest + 1, 44);

    ellipses_end := -1;
    if from_root >= 0 {
        ellipses_end = trace.nodes.count - 1 - from_root;
        if first >= ellipses_start first = max(0, ellipses_start - 1);
        if last <= ellipses_end last = min(trace.nodes.count - 1, ellipses_end + 1);
    }

    SPACES :: "                                            ";
    for i: first..last {
        node := trace.nodes[i];
        if !node.info continue;
        if i >= ellipses_start && i <= ellipses_end {
            if i == ellipses_start log("...\n");
            continue;
        }
        padding := SPACES;
        padding.count = max(0, longest - node.info.name.count);

        // A grouped trace can reach one frame from several line numbers; list them all.
        lines: [..] s64;
        lines.allocator = __temporary_allocator;
        if group_info {
            initial := node.line_number;
            for sub: group_info.sub_summaries {
                other_trace := sub.alloc_site_trace;
                j := i;
                if i > ellipses_end {
                    below := trace.nodes.count - 1 - i;
                    j = other_trace.nodes.count - 1 - below;
                    if j <= ellipses_start continue;
                }
                other := other_trace.nodes[j];
                if other.line_number != initial {
                    if !lines array_add(*lines, initial);
                    array_add_if_unique(*lines, other.line_number);
                }
            }
            // Insertion sort; the list is tiny.
            for a: 1..lines.count-1 {
                v := lines[a];
                b := a;
                while b > 0 && lines[b-1] > v { lines[b] = lines[b-1]; b -= 1; }
                lines[b] = v;
            }
        }
        if lines {
            builder: String_Builder;
            builder.allocator = __temporary_allocator;
            for lines {
                if it_index != 0 append(*builder, ", ");
                print_to_builder(*builder, "%", it);
            }
            log("%1% %:(%)\n", node.info.name, padding, node.info.location.fully_pathed_filename, builder_to_string(*builder));
        } else {
            log("%1% %:%\n", node.info.name, padding, node.info.location.fully_pathed_filename, node.line_number);
        }
    }
}
_md_log_summary :: (summary: *Leak_Summary, options: Leak_Report_Options, prefix: string) {
    log_warning("%% allocations, % bytes (% child allocations, % child bytes)\n", prefix, summary.count, summary.bytes, summary.child_count, summary.child_bytes);
    if summary.group_info {
        log_warning("%grouped by %\n", prefix, summary.group_info.procedure.procedure_name);
        for child: summary.group_info.sub_summaries _md_log_summary(child, options, prefix);
        return;
    }
    if !summary.alloc_site_trace return;
    first: s64;
    last := summary.alloc_site_trace.nodes.count;
    for target: options.known_allocation_leaves {
        for node, index: summary.alloc_site_trace.nodes if _md_procedure_matches(target, node) { first = max(first, index+1); break; }
    }
    while last > first {
        skip := false;
        for target: options.roots_to_skip if _md_procedure_matches(target, summary.alloc_site_trace.nodes[last-1]) { skip = true; break; }
        if !skip break;
        last -= 1;
    }
    for i: first..last-1 {
        node := summary.alloc_site_trace.nodes[i];
        if node.info log_warning("%  % at %:%\n", prefix, node.info.name, node.info.location.fully_pathed_filename, node.line_number);
    }
}
_md_append_summary :: (builder: *String_Builder, summary: *Leak_Summary) {
    print_to_builder(builder, "  % allocations, % bytes (% child allocations, % child bytes)\n", summary.count, summary.bytes, summary.child_count, summary.child_bytes);
    if summary.group_info {
        print_to_builder(builder, "  grouped by %\n", summary.group_info.procedure.procedure_name);
        for child: summary.group_info.sub_summaries _md_append_summary(builder, child);
    } else if summary.alloc_site_trace {
        for node: summary.alloc_site_trace.nodes {
            if node.info print_to_builder(builder, "    % at %:%\n", node.info.name, node.info.location.fully_pathed_filename, node.line_number);
        }
    }
}
#scope_export
