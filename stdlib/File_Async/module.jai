#import "Basic";
Sync :: #import "File";
Threads :: #import "Thread";

Error :: struct {
    code: enum {
        Success :: 0;
        DidNotWait;
        FullQueue;
        FileAccessFailed;
        Incomplete;
        Catastrophic;
    };
    platform_code: s64;
}

Queue :: struct(User_Data: Type) {
    mutex: Threads.Mutex;
    submitted: Threads.Condition_Variable;
    completed: Threads.Condition_Variable;
    worker: Threads.Thread;
    allocator: Allocator;
    requests: [..] Request(User_Data);
    completions: [..] Completion(User_Data);
    open_files: [..] *File_State;
    request_cursor: int;
    completion_cursor: int;
    outstanding: int;
    stopping: bool;
    capacity: int = 64;
}

File :: struct(User_Data: Type) {
    #if OS == .WINDOWS {
        handle: *void;
        unfinished_operations: *u64;
    } else {
        descriptor: s32 = -1;
        unfinished_operations: *s64;
    }
    state: *File_State;
}

initialize_queue :: ($User_Data: Type) -> *Queue(User_Data), result := Error.{} {
    queue := New(Queue(User_Data));
    if !queue return null, error(.Catastrophic);
    queue.allocator = context.allocator;
    queue.requests.allocator = queue.allocator;
    queue.completions.allocator = queue.allocator;
    queue.open_files.allocator = queue.allocator;
    Threads.init(*queue.mutex);
    // Condition variables cannot fail to initialize: `init` asserts instead of returning a status.
    Threads.init(*queue.submitted);
    Threads.init(*queue.completed);
    worker :: (thread: *Threads.Thread) -> s64 {
        owner := cast(*Queue(User_Data)) thread.data;
        while true {
            Threads.lock(*owner.mutex);
            while owner.request_cursor == owner.requests.count && !owner.stopping Threads.wait(*owner.submitted, *owner.mutex);
            if owner.request_cursor == owner.requests.count && owner.stopping {
                Threads.unlock(*owner.mutex);
                return 0;
            }
            request := owner.requests[owner.request_cursor];
            owner.request_cursor += 1;
            if owner.request_cursor == owner.requests.count {
                owner.request_cursor = 0;
                owner.requests.count = 0;
            }
            Threads.unlock(*owner.mutex);
            completion := perform(request, owner.allocator);
            if request.path free(request.path, owner.allocator);
            Threads.lock(*owner.mutex);
            if request.file request.file.pending -= 1;
            array_add(*owner.completions, completion);
            Threads.wake_all(*owner.completed);
            Threads.unlock(*owner.mutex);
        }
    }
    if !Threads.thread_init(*queue.worker, worker) || !start_worker(queue) {
        Threads.thread_deinit(*queue.worker);
        Threads.destroy(*queue.completed);
        Threads.destroy(*queue.submitted);
        Threads.destroy(*queue.mutex);
        free(queue);
        return null, error(.Catastrophic);
    }
    return queue, .{};
}

destroy_queue :: (queue: *Queue) {
    if !queue return;
    Threads.lock(*queue.mutex);
    queue.stopping = true;
    Threads.wake_all(*queue.submitted);
    Threads.unlock(*queue.mutex);
    Threads.thread_deinit(*queue.worker);
    for i: queue.completion_cursor..queue.completions.count - 1 {
        if queue.completions[i].owns_data free(queue.completions[i].data.data, queue.allocator);
    }
    for state: queue.open_files {
        if !state.closed Sync.file_close(*state.stream);
        free(state, queue.allocator);
    }
    array_free(queue.requests);
    array_free(queue.completions);
    array_free(queue.open_files);
    Threads.destroy(*queue.completed);
    Threads.destroy(*queue.submitted);
    Threads.destroy(*queue.mutex);
    free(queue, queue.allocator);
}

open_file :: (queue: *Queue($T), file_path: string, keep_existing_content := true) -> File(T), result := Error.{} {
    file_result: File(T);
    if !queue return file_result, error(.Catastrophic);
    stream, opened := open_random_access(file_path, keep_existing_content);
    if !opened return file_result, platform_error(.FileAccessFailed);
    state := New(File_State, allocator = queue.allocator);
    if !state {
        Sync.file_close(*stream);
        return file_result, error(.Catastrophic);
    }
    state.stream = stream;
    state.owner = queue;
    Threads.lock(*queue.mutex);
    if queue.stopping {
        Threads.unlock(*queue.mutex);
        Sync.file_close(*stream);
        free(state, queue.allocator);
        return file_result, error(.Catastrophic);
    }
    array_add(*queue.open_files, state);
    Threads.unlock(*queue.mutex);
    file_result.state = state;
    #if OS == .WINDOWS {
        file_result.handle = cast(*void) stream.handle;
        file_result.unfinished_operations = cast(*u64) *state.pending;
    } else {
        file_result.descriptor = Async_Posix.fileno(cast(*Async_Posix.FILE) stream.handle);
        file_result.unfinished_operations = *state.pending;
    }
    return file_result, .{};
}

close_file :: (queue: *Queue, file: File) {
    if !queue || !file.state || file.state.owner != queue return;
    Threads.lock(*queue.mutex);
    while file.state.pending > 0 Threads.wait(*queue.completed, *queue.mutex);
    if !file.state.closed {
        Sync.file_close(*file.state.stream);
        file.state.closed = true;
    }
    Threads.unlock(*queue.mutex);
}

read_entire_file :: (queue: *Queue($T), file_path: string, user_data: T) -> result := Error.{} {
    if !queue return error(.Catastrophic);
    request: Request(T);
    request.kind = .READ_ALL;
    request.path = owned_name(file_path, queue.allocator);
    request.user_data = user_data;
    return submit(queue, request);
}

write_entire_file :: (queue: *Queue($T), file_path: string, data: [] u8, user_data: T) -> result := Error.{} {
    if !queue return error(.Catastrophic);
    request: Request(T);
    request.kind = .WRITE_ALL;
    request.path = owned_name(file_path, queue.allocator);
    request.data = data;
    request.user_data = user_data;
    return submit(queue, request);
}

read_file :: (queue: *Queue($T), file: File, position: s64, data: [] u8, user_data: T) -> result := Error.{} {
    request: Request(T);
    request.kind = .READ;
    request.file = file.state;
    request.position = position;
    request.data = data;
    request.user_data = user_data;
    return submit(queue, request);
}

write_file :: (queue: *Queue($T), file: File, position: s64, data: [] u8, user_data: T) -> result := Error.{} {
    request: Request(T);
    request.kind = .WRITE;
    request.file = file.state;
    request.position = position;
    request.data = data;
    request.user_data = user_data;
    return submit(queue, request);
}

wait_for_completion :: (queue: *Queue($T), check_only := false) -> T, data: [] u8, result := Error.{} {
    if !queue {
        empty: T;
        return empty, .[], error(.Catastrophic);
    }
    Threads.lock(*queue.mutex);
    defer Threads.unlock(*queue.mutex);
    while queue.completion_cursor == queue.completions.count {
        if check_only || queue.stopping {
            empty: T;
            return empty, .[], error(.DidNotWait);
        }
        Threads.wait(*queue.completed, *queue.mutex);
    }
    value := queue.completions[queue.completion_cursor];
    queue.completion_cursor += 1;
    queue.outstanding -= 1;
    if queue.completion_cursor == queue.completions.count {
        queue.completion_cursor = 0;
        queue.completions.count = 0;
    }
    return value.user_data, value.data, value.result;
}

#scope_module
File_State :: struct {
    stream: Sync.File;
    pending: s64;
    closed: bool;
    owner: *void;
}

Request_Kind :: enum {
    READ;
    WRITE;
    READ_ALL;
    WRITE_ALL;
}

Request :: struct(T: Type) {
    kind: Request_Kind;
    file: *File_State;
    path: string;
    position: s64;
    data: [] u8;
    user_data: T;
}

Completion :: struct(T: Type) {
    user_data: T;
    data: [] u8;
    result: Error;
    owns_data: bool;
}

error :: (code: type_of(Error.code), platform_code: $T = 0) -> Error {
    return .{ code, cast(s64) platform_code };
}

platform_error :: (code: type_of(Error.code)) -> Error {
    System :: #import "System";
    return error(code, System.get_error_value());
}

owned_name :: (name: string, allocator: Allocator) -> string {
    memory := cast(*u8) alloc(name.count, allocator);
    if name.count > 0 && memory memcpy(memory, name.data, name.count);
    return .{ name.count, memory };
}

start_worker :: (queue: *Queue) -> bool {
    queue.worker.data = queue;
    return Threads.thread_start(*queue.worker);
}

submit :: (queue: *Queue($T), request: Request(T)) -> Error {
    if !queue return error(.Catastrophic);
    Threads.lock(*queue.mutex);
    defer Threads.unlock(*queue.mutex);
    if queue.stopping || request.position < 0 || request.data.count < 0 || request.path.count > 0 && !request.path.data {
        if request.path free(request.path, queue.allocator);
        return error(.Catastrophic);
    }
    if queue.outstanding >= queue.capacity {
        if request.path free(request.path, queue.allocator);
        return error(.FullQueue);
    }
    if request.kind == .READ || request.kind == .WRITE {
        if !request.file || request.file.closed || request.file.owner != queue return error(.FileAccessFailed);
        request.file.pending += 1;
    }
    array_add(*queue.requests, request);
    queue.outstanding += 1;
    Threads.wake(*queue.submitted);
    return .{};
}

perform :: (request: Request($T), allocator: Allocator) -> Completion(T) {
    result: Completion(T);
    result.user_data = request.user_data;
    result.data = request.data;
    stream: Sync.File;
    close_when_done := request.kind == .READ_ALL || request.kind == .WRITE_ALL;
    if close_when_done {
        opened: bool;
        stream, opened = Sync.file_open(request.path, for_writing = request.kind == .WRITE_ALL);
        if !opened {
            result.result = platform_error(.FileAccessFailed);
            return result;
        }
    } else {
        stream = request.file.stream;
    }
    defer if close_when_done Sync.file_close(*stream);
    if !Sync.file_set_position(stream, request.position) {
        result.result = platform_error(.Incomplete);
        return result;
    }
    if request.kind == .READ_ALL {
        size := Sync.file_length(stream);
        if size < 0 {
            result.result = platform_error(.Incomplete);
            return result;
        }
        bytes := cast(*u8) alloc(size, allocator);
        if size > 0 && !bytes {
            result.result = error(.Catastrophic);
            return result;
        }
        result.data = .{ size, bytes };
        result.owns_data = true;
    }
    if request.kind == .READ || request.kind == .READ_ALL {
        ok, count := Sync.file_read_checked(stream, result.data.data, result.data.count);
        if !ok || count != result.data.count result.result = platform_error(.Incomplete);
    } else {
        if !Sync.file_write(*stream, request.data.data, request.data.count) result.result = platform_error(.Incomplete);
    }
    if close_when_done {
        if !Sync.file_close(*stream) && result.result.code == .Success result.result = platform_error(.Incomplete);
        close_when_done = false;
    }
    return result;
}

#if OS == .WINDOWS {
    Async_Windows :: #import "Windows";
    #load "../File/windows-encoding.jai";

    open_random_access :: (name: string, keep: bool) -> Sync.File, bool {
        disposition: u32 = 2;
        if keep disposition = 4;
        handle := Async_Windows.CreateFileW(os_utf8_to_wide(name), 0x80000000 | 0x40000000, 3, null, disposition, 0x80, null);
        return .{ cast(s64) handle }, handle != cast(Async_Windows.HANDLE) -1;
    }
} else {
    Async_Posix :: #import "POSIX";

    open_random_access :: (name: string, keep: bool) -> Sync.File, bool {
        mode := "w+b";
        if keep mode = "r+b";
        stream := Async_Posix.fopen(temp_c_string(name), temp_c_string(mode));
        if !stream && keep && Async_Posix.errno() == Async_Posix.ENOENT stream = Async_Posix.fopen(temp_c_string(name), temp_c_string("w+b"));
        return .{ cast(s64) stream }, stream != null;
    }
}
