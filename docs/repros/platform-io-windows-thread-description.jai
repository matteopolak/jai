// Original compiler interoperability reproducer; run on Windows, not merely -check.
#assert OS == .WINDOWS;

#import "Basic";
T :: #import "Thread";

worker :: (thread: *T.Thread) -> s64 {
    assert(context.thread_index == thread.index);
    return 0;
}

main :: () {
    thread: T.Thread;

    assert(T.thread_init(*thread, worker, name = "I/O worker 雪"));
    description: *u16;
    result := get_description(thread.windows_thread, *description);

    assert(result >= 0 && description != null, "native thread description failed: %", result);
    expected: [13] u16 = .[73, 47, 79, 32, 119, 111, 114, 107, 101, 114, 32, 0x96ea, 0];
    for expected assert(description[it_index] == it);

    assert(local_free(description) == null);
    T.thread_start(*thread);
    assert(T.thread_is_done(*thread, 5000));
    T.thread_deinit(*thread);
    print("ok\n");
}

#scope_file
kernel32 :: #system_library "kernel32";
get_description :: (handle: *void, output: **u16) -> s32 #foreign kernel32 "GetThreadDescription";
local_free :: (memory: *void) -> *void #foreign kernel32 "LocalFree";
