// The first event uses the default Basic instance, before debugger API calls.
Default_Basic :: #import "Basic";
Debugger :: #import "Basic"(MEMORY_DEBUGGER=true, VISUALIZE_MEMORY_DEBUGGER=false);

main :: () -> s64 {
    memory := Default_Basic.alloc(37);
    if !memory return 1;
    options: Debugger.Leak_Report_Options;
    options.scan_global_memory_to_remove_leaks = false;
    options.scan_leaks_to_combine = false;
    report := Debugger.make_leak_report(options);
    count: s64;
    bytes: s64;
    for summary: report.sorted_summaries { count += summary.count; bytes += summary.bytes; }
    Debugger.deinit(*report);
    if count != 1 || bytes != 37 return 2;
    replacement := Default_Basic.realloc(memory, 61, 37);
    if !replacement return 3;
    memory = replacement;
    report = Debugger.make_leak_report(options);
    count = 0; bytes = 0;
    for summary: report.sorted_summaries { count += summary.count; bytes += summary.bytes; }
    Debugger.deinit(*report);
    if count != 1 || bytes != 61 return 4;
    Default_Basic.free(memory);
    report = Debugger.make_leak_report(options);
    count = 0;
    for summary: report.sorted_summaries count += summary.count;
    Debugger.deinit(*report);
    if count != 0 return 5;
    Debugger.deinit_memory_debugger();
    return 0;
}
