#scope_export
Thread_Continue_Status :: enum { CONTINUE; STOP; }
Thread_Group_Proc :: #type *void;
Native_Thread_Group_Proc :: #type (group: *Thread_Group, thread: *Thread, work: *void) -> Thread_Continue_Status;
Thread_Group :: struct {
    threads: [..] Thread;
    completed_work: [..] *void;
    logging := true;
    started: bool;
    shutdown_requested: bool;
    data: *void;
    proc: Native_Thread_Group_Proc;
    name: string;
    time_proc: () -> float64;
    allocator: Allocator;
    worker_info: [] Worker_Info;
    worker_info_data_to_free: *void;
    next_worker_index: s32;
    Worker_Info :: struct {
        using info: Unpadded_Worker_Info;
        DESIRED_SIZE :: #run align_forward(size_of(type_of(info)), CACHE_LINE_SIZE);
        padding: [DESIRED_SIZE] u8 = ---;
        work_steal_indices: [] s32;
    }
    Unpadded_Worker_Info :: struct {
        thread: Thread;
        available: Work_List;
        completed: Work_List;
        group: *Thread_Group;
        worker_index: s32;
    }
    Work_List :: struct {
        semaphore: Semaphore;
        mutex: Mutex;
        first: *Work_Entry;
        last: *Work_Entry;
        count: s32;
    }
    Work_Entry :: struct {
        next: *Work_Entry;
        work: *void;
        thread_index: Thread_Index;
        logging_name: string;
        issue_time: float64;
        work_list_index: s32;
    }
    initted := false;
    should_exit := false;
    enable_work_stealing: bool;
}
Work_List :: Thread_Group.Work_List;
Work_Entry :: Thread_Group.Work_Entry;

init :: (group: *Thread_Group, num_threads: int, group_proc: Thread_Group_Proc,
    enable_work_stealing: bool) -> bool {
    return init(group, cast(s32) num_threads, cast(Native_Thread_Group_Proc) group_proc,
        enable_work_stealing, 16384);
}
init :: (using group: *Thread_Group, num_threads: s32, group_proc: Native_Thread_Group_Proc,
    enable_work_stealing := false, temporary_storage_size: s32 = 16384) -> bool {
    if group == null || initted || num_threads <= 0 || group_proc == null return false;
    allocator = context.allocator;
    proc = group_proc;
    group.enable_work_stealing = enable_work_stealing;
    threads.allocator = allocator; completed_work.allocator = allocator;
    array_resize(*threads, num_threads);
    worker_info, worker_info_data_to_free = NewArray(num_threads, Thread_Group.Worker_Info, true);
    if worker_info.data == null { array_reset(*threads); return false; }
    initialized: s32 = 0;
    while initialized < num_threads {
        worker := *worker_info[initialized];
        worker.group = group; worker.worker_index = initialized;
        if !init_work_list(*worker.available) break;
        if !init_work_list(*worker.completed) { deinit_work_list(*worker.available, allocator); break; }
        thread := *threads[initialized];
        thread.data = worker; thread.worker_info = worker;
        if !thread_init(thread, thread_group_run, temporary_storage_size) {
            deinit_work_list(*worker.completed, allocator); deinit_work_list(*worker.available, allocator); break;
        }
        worker.thread = thread.*;
        worker.work_steal_indices = NewArray(num_threads - 1, s32);
        cursor: s32 = 0;
        for other: 0..num_threads-1 {
            if other == initialized continue;
            worker.work_steal_indices[cursor] = cast(s32) other; cursor += 1;
        }
        initialized += 1;
    }
    if initialized != num_threads {
        for i: 0..initialized-1 {
            thread_deinit(*threads[i]);
            free(worker_info[i].work_steal_indices.data, allocator);
            deinit_work_list(*worker_info[i].completed, allocator);
            deinit_work_list(*worker_info[i].available, allocator);
        }
        free(worker_info_data_to_free, allocator);
        worker_info = .{}; worker_info_data_to_free = null;
        array_reset(*threads); return false;
    }
    next_worker_index = 0; initted = true; started = false;
    should_exit = false; shutdown_requested = false;
    return true;
}
start :: (group: *Thread_Group) -> bool {
    if group == null || !group.initted || group.started || group.shutdown_requested return false;
    for *thread: group.threads {
        if !thread_start(thread) {
            shutdown(group);
            return false;
        }
        thread.worker_info.thread = thread.*;
    }
    group.started = true;
    return true;
}
add_work :: (group: *Thread_Group, work: *void, logging_name := "") -> bool {
    if group == null || !group.initted || group.shutdown_requested return false;
    entry := cast(*Work_Entry) alloc(size_of(Work_Entry), group.allocator);
    if entry == null return false;
    entry.* = .{};
    entry.work = work; entry.logging_name = logging_name;
    entry.issue_time = get_time(group);
    index := group.next_worker_index;
    group.next_worker_index = (index + 1) % cast(s32) group.worker_info.count;
    entry.work_list_index = index;
    append_work(*group.worker_info[index].available, entry);
    if group.enable_work_stealing {
        for *worker: group.worker_info {
            if worker.worker_index != index signal(*worker.available.semaphore);
        }
    }
    return true;
}
get_completed_work :: (group: *Thread_Group) -> [..] *void {
    if group == null { empty: [..] *void; return empty; }
    group.completed_work.count = 0;
    for *worker: group.worker_info {
        while true {
            entry := pop_work(*worker.completed);
            if entry == null break;
            array_add(*group.completed_work, entry.work);
            free(entry, group.allocator);
        }
    }
    return group.completed_work;
}
shutdown :: (using group: *Thread_Group, timeout_milliseconds: s32 = -1) -> bool {
    if group == null || !initted return true;
    shutdown_requested = true; atomic_write(*should_exit, true);
    for *worker: worker_info signal(*worker.available.semaphore);
    deadline := get_time(group) + cast(float64) timeout_milliseconds / 1000;
    for *thread: threads {
        wait_ms := timeout_milliseconds;
        if timeout_milliseconds >= 0 {
            remaining := (deadline - get_time(group)) * 1000;
            if remaining < 0 remaining = 0;
            wait_ms = cast(s32) remaining;
        }
        if !thread_is_done(thread, wait_ms) return false;
    }
    processed_all := true;
    for *worker: worker_info {
        if worker.available.count != 0 processed_all = false;
        thread_deinit(*threads[worker.worker_index]);
        free(worker.work_steal_indices.data, allocator);
        deinit_work_list(*worker.available, allocator);
        deinit_work_list(*worker.completed, allocator);
    }
    free(worker_info_data_to_free, allocator);
    worker_info_data_to_free = null; worker_info = .{};
    array_reset(*threads);
    array_reset(*completed_work);
    started = false; initted = false;
    return processed_all;
}

#scope_file
init_work_list :: (list: *Work_List) -> bool {
    init(*list.mutex);
    if !init(*list.semaphore) { destroy(*list.mutex); return false; }
    list.first = null; list.last = null; list.count = 0;
    return true;
}
deinit_work_list :: (list: *Work_List, allocator: Allocator) {
    entry := list.first;
    while entry != null { next := entry.next; free(entry, allocator); entry = next; }
    destroy(*list.semaphore); destroy(*list.mutex);
    list.first = null; list.last = null; list.count = 0;
}
append_work :: (list: *Work_List, entry: *Work_Entry) {
    entry.next = null;
    lock(*list.mutex);
    if list.last == null list.first = entry;
    else list.last.next = entry;
    list.last = entry; list.count += 1;
    unlock(*list.mutex);
    signal(*list.semaphore);
}
pop_work :: (list: *Work_List) -> *Work_Entry {
    lock(*list.mutex);
    defer unlock(*list.mutex);
    entry := list.first;
    if entry == null return null;
    list.first = entry.next;
    if list.first == null list.last = null;
    list.count -= 1; entry.next = null;
    return entry;
}
thread_group_run :: (thread: *Thread) -> s64 {
    worker := thread.worker_info;
    group := worker.group;
    while true {
        entry := pop_work(*worker.available);
        if entry == null && group.enable_work_stealing {
            for index: worker.work_steal_indices {
                entry = pop_work(*group.worker_info[index].available);
                if entry != null break;
            }
        }
        if entry == null {
            if atomic_read(*group.should_exit) break;
            if wait_for(*worker.available.semaphore) == .ERROR return -1;
            continue;
        }
        status := group.proc(group, thread, entry.work);
        entry.thread_index = thread.index;
        append_work(*worker.completed, entry);
        if status == .STOP break;
    }
    return 0;
}
get_time :: (group: *Thread_Group) -> float64 {
    if group.time_proc != null return group.time_proc();
    #if POSIX_THREADS {
        now: timeval;
        assert(gettimeofday(*now, null) == 0);
        return cast(float64) now.tv_sec + cast(float64) now.tv_usec / 1000000;
    } else return cast(float64) native_tick_count() / 1000;
}
