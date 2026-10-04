// Authored complete snapshots over the existing local visualization wire API.
#scope_file
MD_Wire :: #import "Protocol_For_Memory_Visualization";
MD_Channel :: #import "Shared_Memory_Channel";
MD_Strings :: #import "Hash_Table";

MILLISECONDS_PER_VIS_UPDATE :: 250;
MILLISECONDS_PER_VIS_INIT :: 500;
vis_channel: MD_Channel.Write_Channel;
vis_initted: bool;
vis_enabled: bool;
did_user_level_per_frame_update: bool;
last_update_time := APOLLO_TIME_INVALID;
last_vis_init_time := APOLLO_TIME_INVALID;

vis_init :: () {
    if vis_enabled return;
    now := current_time_monotonic();
    if last_vis_init_time != APOLLO_TIME_INVALID && to_milliseconds(now-last_vis_init_time) < MILLISECONDS_PER_VIS_INIT return;
    last_vis_init_time = now;
    success, channel := MD_Channel.writer_connect(MD_Wire.MEMORY_VISUALIZATION_CHANNEL_NAME, name_not_found_is_quiet=true);
    vis_initted = true;
    if !success return;
    vis_channel = channel;
    vis_enabled = true;
}
vis_fini :: () {
    if vis_enabled MD_Channel.writer_disconnect(*vis_channel);
    vis_enabled = false;
    vis_initted = false;
    last_vis_init_time = APOLLO_TIME_INVALID;
}
vis_update_if_it_has_been_long_enough :: () {
    if context.inside_memory_debugger || did_user_level_per_frame_update return;
    now := current_time_monotonic();
    if last_update_time != APOLLO_TIME_INVALID && to_milliseconds(now-last_update_time) < MILLISECONDS_PER_VIS_UPDATE return;
    vis_update();
    last_update_time = now;
}
vis_update :: () {
    if context.inside_memory_debugger return;
    // Acquire a report first: its pool owns all trace data used on the wire.
    options: Leak_Report_Options;
    options.scan_global_memory_to_remove_leaks = false;
    options.scan_leaks_to_combine = false;
    report := make_leak_report(options, for_visualizer=true);
    defer deinit(*report);
    if !_md_begin(.{}) return;
    defer _md_end();
    vis_init();
    if !vis_enabled return;
    version: MD_Wire.Memory_Debugger_Version_Info;
    version.tag = .RESET_AND_TELL_VERSION;
    version.version = MD_Wire.VIS_PROTOCOL_VERSION;
    version.default_allocator_proc = md_state.storage_allocator.proc;
    if !_vis_send(*version, size_of(version)) return;
    strings: MD_Strings.Table(string, s32);
    strings.keys.allocator = md_state.storage_allocator;
    strings.values.allocator = md_state.storage_allocator;
    defer MD_Strings.deinit(*strings);
    for summary: report.sorted_summaries {
        if !_vis_trace(summary.alloc_site_trace, *strings) return;
    }
    // Historical event records hold actual source trace pointers until shutdown.
    allocation_count: s64;
    free_count: s64;
    record := md_state.records;
    while record {
        if record.frame_cycle == md_state.frame_cycle && record.frame_allocations > 0 {
            if !_vis_trace(record.allocation.alloc_site_trace, *strings) return;
            allocation_count += 1;
        }
        if record.free_cycle == md_state.frame_cycle && record.frame_frees > 0 && record.allocation.free_site_trace {
            if !_vis_trace(record.allocation.free_site_trace, *strings) return;
            if !_vis_trace(record.allocation.alloc_site_trace, *strings) return;
            free_count += 1;
        }
        record = record.next;
    }
    bytes := size_of(MD_Wire.Summary_Info) + report.sorted_summaries.count*size_of(MD_Wire.Packed_Summary) + allocation_count*size_of(MD_Wire.Allocs_This_Frame) + free_count*size_of(MD_Wire.Frees_This_Frame);
    success, message := MD_Channel.writer_reserve_message(*vis_channel, bytes);
    if !success return;
    cursor := message.user_write_pointer;
    header := cast(*MD_Wire.Summary_Info)cursor;
    header.* = .{};
    header.tag = .UPDATE_USAGE;
    header.num_live = cast(s32)report.sorted_summaries.count;
    header.num_allocs_this_frame = cast(s32)allocation_count;
    header.num_frees_this_frame = cast(s32)free_count;
    cursor += size_of(MD_Wire.Summary_Info);
    for summary: report.sorted_summaries {
        packed := cast(*MD_Wire.Packed_Summary)cursor;
        packed.* = .{};
        packed.count = summary.count;
        packed.bytes = summary.bytes;
        packed.alloc_site_trace = summary.alloc_site_trace;
        packed.allocator_proc = summary.allocator_proc;
        packed.allocations_since_last_visualizer_update = summary.allocations_since_last_visualizer_update;
        packed.bytes_allocated_since_last_visualizer_update = summary.bytes_allocated_since_last_visualizer_update;
        if summary.group_info {
            packed.grouped_from_this_many_stack_traces = cast(s32)summary.group_info.sub_summaries.count;
            packed.root_nodes_in_common = cast(s32)summary.group_info.root_nodes_in_common;
            packed.leaf_nodes_in_common = cast(s32)summary.group_info.leaf_nodes_in_common;
        }
        cursor += size_of(MD_Wire.Packed_Summary);
    }
    record = md_state.records;
    while record {
        if record.frame_cycle == md_state.frame_cycle && record.frame_allocations > 0 {
            event := cast(*MD_Wire.Allocs_This_Frame)cursor;
            event.* = .{};
            event.count = record.frame_allocations;
            event.bytes = record.frame_bytes;
            event.alloc_site_trace = record.allocation.alloc_site_trace;
            event.allocator_proc = record.allocation.allocator.proc;
            cursor += size_of(MD_Wire.Allocs_This_Frame);
        }
        if record.free_cycle == md_state.frame_cycle && record.frame_frees > 0 && record.allocation.free_site_trace {
            event := cast(*MD_Wire.Frees_This_Frame)cursor;
            event.* = .{};
            event.count = record.frame_frees;
            event.bytes = record.frame_freed_bytes;
            event.alloc_site_trace = record.allocation.alloc_site_trace;
            event.free_site_trace = record.allocation.free_site_trace;
            event.allocator_proc = record.allocation.allocator.proc;
            cursor += size_of(MD_Wire.Frees_This_Frame);
        }
        record = record.next;
    }
    assert(cursor == message.user_write_pointer+bytes);
    if !MD_Channel.writer_commit_message(*vis_channel, message) { vis_fini(); return; }
    if md_state.frame_cycle == 0xffff_ffff {
        record = md_state.records;
        while record { record.frame_cycle = 0; record.free_cycle = 0; record = record.next; }
        md_state.frame_cycle = 1;
    } else md_state.frame_cycle += 1;
}

_vis_send :: (data: *void, bytes: s64) -> bool {
    success, message := MD_Channel.writer_reserve_message(*vis_channel, bytes);
    if !success return false;
    memcpy(message.user_write_pointer, data, bytes);
    if !MD_Channel.writer_commit_message(*vis_channel, message) { vis_fini(); return false; }
    return true;
}
_vis_string :: (table: *MD_Strings.Table(string, s32), value: string) -> (index: s32, success: bool) {
    existing, found := MD_Strings.table_find(table, value);
    if found return existing, true;
    index := cast(s32)table.count;
    count := min(value.count, cast(s64)0x7fff_ffff);
    success, message := MD_Channel.writer_reserve_message(*vis_channel, size_of(MD_Wire.String_Info)+count);
    if !success return -1, false;
    info := cast(*MD_Wire.String_Info)message.user_write_pointer;
    info.* = .{};
    info.tag = .ADD_STRING;
    info.index = cast(MD_Wire.String_Index)index;
    info.count = cast(s32)count;
    memcpy(message.user_write_pointer+size_of(MD_Wire.String_Info), value.data, count);
    if !MD_Channel.writer_commit_message(*vis_channel, message) { vis_fini(); return -1, false; }
    MD_Strings.table_set(table, value, index);
    return index, true;
}
_vis_trace :: (trace: *Packed_Stack_Trace, strings: *MD_Strings.Table(string, s32)) -> bool {
    if !trace return true;
    for node: trace.nodes {
        if !node.info continue;
        name, ok_name := _vis_string(strings, node.info.name);
        if !ok_name return false;
        filename, ok_filename := _vis_string(strings, node.info.location.fully_pathed_filename);
        if !ok_filename return false;
        procedure: MD_Wire.Packed_Stack_Trace_Procedure_Info;
        procedure.tag = .ADD_PROCEDURE_INFO;
        procedure.name = cast(MD_Wire.String_Index)name;
        procedure.filename = cast(MD_Wire.String_Index)filename;
        procedure.line_number = cast(s32)node.info.location.line_number;
        procedure.character_number = cast(s32)node.info.location.character_number;
        procedure.remote_address = node.info;
        if !_vis_send(*procedure, size_of(procedure)) return false;
    }
    bytes := size_of(MD_Wire.Single_Stack_Trace_Info)+trace.nodes.count*size_of(Stack_Trace_Node);
    success, message := MD_Channel.writer_reserve_message(*vis_channel, bytes);
    if !success return false;
    info := cast(*MD_Wire.Single_Stack_Trace_Info)message.user_write_pointer;
    info.* = .{};
    info.tag = .ADD_STACK_TRACE;
    info.hash = trace.hash;
    info.address = trace;
    info.num_nodes = cast(s32)trace.nodes.count;
    memcpy(message.user_write_pointer+size_of(MD_Wire.Single_Stack_Trace_Info), trace.nodes.data, trace.nodes.count*size_of(Stack_Trace_Node));
    if !MD_Channel.writer_commit_message(*vis_channel, message) { vis_fini(); return false; }
    return true;
}
#scope_export
memory_visualizer_per_frame_update :: () {
    did_user_level_per_frame_update = true;
    vis_update();
    last_update_time = current_time_monotonic();
}
