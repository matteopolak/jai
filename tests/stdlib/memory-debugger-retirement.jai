Debugger :: #import "Basic"(MEMORY_DEBUGGER=true, VISUALIZE_MEMORY_DEBUGGER=false);
Default_Basic :: #import "Basic";
Runtime :: #import "Runtime_Support"(DEFINE_SYSTEM_ENTRY_POINT=false, DEFINE_INITIALIZATION=false, ENABLE_BACKTRACE_ON_CRASH=false);

main :: () -> s64 {
    defer Debugger.deinit_memory_debugger();
    allocator := context.allocator;
    // Actual raw backing acquired before/suppressed from observation.
    unobserved := allocator.proc(.ALLOCATE, 19, 0, null, allocator.data);
    if !unobserved return 1;
    Runtime.notify_allocator_event(.FREE, allocator, unobserved, 0, null, 0, is_retirement=true);
    allocator.proc(.FREE, 0, 19, unobserved, allocator.data);
    // Observed backing must be retired before the same underlying free.
    observed := Default_Basic.alloc(31, allocator);
    if !observed return 2;
    Runtime.notify_allocator_event(.FREE, allocator, observed, 0, null, 0, is_retirement=true);
    allocator.proc(.FREE, 0, 31, observed, allocator.data);
    options: Debugger.Leak_Report_Options;
    options.scan_global_memory_to_remove_leaks = false;
    options.scan_leaks_to_combine = false;
    report := Debugger.make_leak_report(options);
    defer Debugger.deinit(*report);
    for summary: report.sorted_summaries if summary.count > 0 return 3;
    return 0;
}
