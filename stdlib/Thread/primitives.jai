// Maintained Thread state is backed by real system synchronization.
#scope_export
Thread_Index :: s64;
Thread_Proc :: #type *void;
Native_Thread_Proc :: #type (*Thread) -> s64;
POSIX_THREADS :: OS == .LINUX || OS == .MACOS || OS == .ANDROID;
#if POSIX_THREADS {
    #load "native_posix.jai";
} else #if OS == .WINDOWS {
    #load "native_windows.jai";
} else {
    #assert(false, "Thread requires an authored POSIX or Windows SDK provider");
}
Thread_Os_Specific :: struct {
    thread_handle: Native_Thread_Handle;
    is_alive_semaphore: Semaphore;
    suspended_semaphore: Semaphore;
    is_done := true;
}
Thread :: struct {
    index: Thread_Index;
    started: bool;
    done := true;
    proc: Native_Thread_Proc;
    data: *void;
    workspace: Workspace;
    starting_context: #Context;
    starting_temporary_storage: Temporary_Storage;
    allocator_used_for_temporary_storage: Allocator;
    #if LOAD_THREAD_GROUP worker_info: *Thread_Group.Worker_Info;
    using specific: Thread_Os_Specific;
    owns_temporary_storage: bool;
    initialized: bool;
}
// With DEBUG off (as in `jai`), a mutex or condition variable is exactly the OS object, so printing
// one shows the same fields `jai` shows.
Mutex :: struct {
    csection: Per_OS_Critical_Section_Type;
}
Condition_Variable :: struct {
    condition_variable: Per_OS_Condition_Variable_Type;
}
Semaphore :: struct {
    owner: u32;
    event: u32 = 0;
    semaphore: Native_Semaphore_Handle;
    mutex: Per_OS_Critical_Section_Type;
    condition: Per_OS_Condition_Variable_Type;
    count: s64;
    initialized: bool;
}
Wait_For_Result :: enum { SUCCESS; TIMEOUT; ERROR; }

thread_init :: (thread: *Thread, proc: Thread_Proc) -> bool {
    return thread_init(thread, cast(Native_Thread_Proc) proc);
}
thread_init :: (thread: *Thread, proc: Native_Thread_Proc,
    temporary_storage_size: s32 = 16384, starting_storage: *Temporary_Storage = null) -> bool {
    if thread == null || proc == null || temporary_storage_size < 0 return false;
    if thread.initialized return false;
    thread.index = atomic_add(*next_thread_index, 1);
    thread.proc = proc;
    thread.starting_context = context;
    thread.workspace = get_current_workspace();
    thread.allocator_used_for_temporary_storage = context.allocator;
    thread.owns_temporary_storage = starting_storage == null;
    if starting_storage != null thread.starting_temporary_storage = starting_storage.*;
    else if !init_temporary_storage(*thread.starting_temporary_storage, temporary_storage_size,
        allocator = thread.allocator_used_for_temporary_storage) return false;
    if !init(*thread.is_alive_semaphore) {
        if thread.owns_temporary_storage deinit_temporary_storage(*thread.starting_temporary_storage,
            thread.allocator_used_for_temporary_storage, true);
        return false;
    }
    thread.started = false; thread.done = true; thread.is_done = true;
    thread.initialized = true;
    return true;
}
thread_start :: (thread: *Thread) -> bool {
    if thread == null || !thread.initialized || thread.started return false;
    thread.started = true; thread.done = false; thread.is_done = false;
    #if POSIX_THREADS {
        result := pthread_create(*thread.thread_handle, null, native_thread_entry, thread);
        if result == 0 return true;
    } else {
        thread.thread_handle = CreateThread(null, 0, cast(*void) native_windows_thread_entry, thread, .{}, null);
        if thread.thread_handle != null return true;
    }
    thread.started = false; thread.done = true; thread.is_done = true;
    return false;
}
thread_is_done :: (thread: *Thread, milliseconds: s32 = 0) -> bool {
    if thread == null || !thread.initialized return true;
    if atomic_read(*thread.done) return true;
    if milliseconds == 0 return false;
    result := wait_for(*thread.is_alive_semaphore, milliseconds);
    if result != .SUCCESS return false;
    signal(*thread.is_alive_semaphore);
    return atomic_read(*thread.done);
}
thread_deinit :: (thread: *Thread) {
    if thread == null || !thread.initialized return;
    if thread.started {
        #if POSIX_THREADS assert(pthread_join(thread.thread_handle, null) == 0);
        else {
            WaitForSingleObject(thread.thread_handle, 0xffffffff);
            CloseHandle(thread.thread_handle);
        }
    }
    destroy(*thread.is_alive_semaphore);
    if thread.owns_temporary_storage deinit_temporary_storage(*thread.starting_temporary_storage,
        thread.allocator_used_for_temporary_storage, true);
    thread.initialized = false; thread.started = false; thread.done = true; thread.is_done = true;
}
thread_destroy :: (thread: *Thread) { thread_deinit(thread); }

init :: (mutex: *Mutex, name: string = "", order: Mutex_Order = -1) {
    ok := initialize_mutex(*mutex.csection);
    assert(ok, "could not initialize mutex");
}
destroy :: (mutex: *Mutex) { destroy_mutex(*mutex.csection); }
lock :: (mutex: *Mutex) { csection_lock(*mutex.csection); }
unlock :: (mutex: *Mutex) { csection_unlock(*mutex.csection); }
init :: (cv: *Condition_Variable, desired_name := "") {
    ok := initialize_condition(*cv.condition_variable);
    assert(ok, "could not initialize condition variable");
}
destroy :: (cv: *Condition_Variable) { destroy_condition(*cv.condition_variable); }
wait :: (c: *Condition_Variable, m: *Mutex) { cvariable_wait(*c.condition_variable, *m.csection); }
wake :: (c: *Condition_Variable) { cvariable_wake(*c.condition_variable); }
wake_all :: (c: *Condition_Variable) { cvariable_wake_all(*c.condition_variable); }
csection_lock :: (csection: *Per_OS_Critical_Section_Type) #expand {
    #if POSIX_THREADS assert(pthread_mutex_lock(csection) == 0);
    else EnterCriticalSection(csection);
}
csection_unlock :: (csection: *Per_OS_Critical_Section_Type) #expand {
    #if POSIX_THREADS assert(pthread_mutex_unlock(csection) == 0);
    else LeaveCriticalSection(csection);
}
cvariable_wait :: (condition_variable: *Per_OS_Condition_Variable_Type,
    csection: *Per_OS_Critical_Section_Type, wait_time_ms: s32 = -1) {
    result := wait_condition(condition_variable, csection, wait_time_ms);
    assert(result != .ERROR);
}
cvariable_wake :: (condition_variable: *Per_OS_Condition_Variable_Type) {
    #if POSIX_THREADS assert(pthread_cond_signal(condition_variable) == 0);
    else WakeConditionVariable(condition_variable);
}
cvariable_wake_all :: (condition_variable: *Per_OS_Condition_Variable_Type) {
    #if POSIX_THREADS assert(pthread_cond_broadcast(condition_variable) == 0);
    else WakeAllConditionVariable(condition_variable);
}
init :: (s: *Semaphore, initial_value: s32 = 0) -> bool {
    if s == null || s.initialized || initial_value < 0 return false;
    if !initialize_mutex(*s.mutex) return false;
    if !initialize_condition(*s.condition) { destroy_mutex(*s.mutex); return false; }
    s.count = initial_value; s.initialized = true;
    return true;
}
destroy :: (s: *Semaphore) {
    if s == null || !s.initialized return;
    destroy_condition(*s.condition); destroy_mutex(*s.mutex);
    s.initialized = false;
}
signal :: (s: *Semaphore) {
    assert(s.initialized);
    csection_lock(*s.mutex); s.count += 1;
    cvariable_wake(*s.condition); csection_unlock(*s.mutex);
}
wait_for :: (s: *Semaphore, milliseconds: s32 = -1) -> Wait_For_Result {
    if s == null || !s.initialized return .ERROR;
    csection_lock(*s.mutex);
    defer csection_unlock(*s.mutex);
    #if POSIX_THREADS {
        deadline: timespec;
        if milliseconds > 0 deadline = deadline_after(milliseconds);
        while s.count == 0 {
            if milliseconds == 0 return .TIMEOUT;
            result: s32;
            if milliseconds < 0 result = pthread_cond_wait(*s.condition, *s.mutex);
            else result = pthread_cond_timedwait(*s.condition, *s.mutex, *deadline);
            if result == ETIMEDOUT return .TIMEOUT;
            if result != 0 return .ERROR;
        }
    } else {
        started := native_tick_count();
        while s.count == 0 {
            remaining: u32 = 0xffffffff;
            if milliseconds >= 0 {
                elapsed := native_tick_count() - started;
                if elapsed >= cast(u64) milliseconds return .TIMEOUT;
                remaining = cast(u32) (cast(u64) milliseconds - elapsed);
            }
            if SleepConditionVariableCS(*s.condition, *s.mutex, remaining) == 0 {
                if GetLastError() == 1460 return .TIMEOUT;
                return .ERROR;
            }
        }
    }
    s.count -= 1; return .SUCCESS;
}

#scope_module
initialize_mutex :: (mutex: *Per_OS_Critical_Section_Type) -> bool {
    #if POSIX_THREADS {
        attributes: pthread_mutexattr_t;
        if pthread_mutexattr_init(*attributes) != 0 return false;
        defer pthread_mutexattr_destroy(*attributes);
        #if OS == .MACOS kind :: PTHREAD_MUTEX_RECURSIVE;
        else kind :: cast(s32) PTHREAD_MUTEX.RECURSIVE;
        if pthread_mutexattr_settype(*attributes, kind) != 0 return false;
        return pthread_mutex_init(mutex, *attributes) == 0;
    }
    else { InitializeCriticalSection(mutex); return true; }
}
destroy_mutex :: (mutex: *Per_OS_Critical_Section_Type) {
    #if POSIX_THREADS assert(pthread_mutex_destroy(mutex) == 0);
    else DeleteCriticalSection(mutex);
}
initialize_condition :: (condition: *Per_OS_Condition_Variable_Type) -> bool {
    #if POSIX_THREADS return pthread_cond_init(condition, null) == 0;
    else { InitializeConditionVariable(condition); return true; }
}
destroy_condition :: (condition: *Per_OS_Condition_Variable_Type) {
    #if POSIX_THREADS assert(pthread_cond_destroy(condition) == 0);
    else memset(condition, 0, size_of(Per_OS_Condition_Variable_Type));
}
wait_condition :: (condition: *Per_OS_Condition_Variable_Type, mutex: *Per_OS_Critical_Section_Type,
    milliseconds: s32) -> Wait_For_Result {
    #if POSIX_THREADS {
        result: s32;
        if milliseconds < 0 result = pthread_cond_wait(condition, mutex);
        else {
            deadline := deadline_after(milliseconds);
            result = pthread_cond_timedwait(condition, mutex, *deadline);
        }
        if result == 0 return .SUCCESS;
        if result == ETIMEDOUT return .TIMEOUT;
        return .ERROR;
    } else {
        timeout := cast(u32) milliseconds;
        if SleepConditionVariableCS(condition, mutex, timeout) != 0 return .SUCCESS;
        if GetLastError() == 1460 return .TIMEOUT;
        return .ERROR;
    }
}
#if POSIX_THREADS {
    deadline_after :: (milliseconds: s32) -> timespec {
        now: timeval;
        assert(gettimeofday(*now, null) == 0);
        result: timespec;
        result.tv_sec = now.tv_sec + milliseconds / 1000;
        result.tv_nsec = cast(s64) now.tv_usec * 1000 + (milliseconds % 1000) * 1000000;
        if result.tv_nsec >= 1000000000 { result.tv_nsec -= 1000000000; result.tv_sec += 1; }
        return result;
    }
    native_thread_entry :: (opaque: *void) -> *void #c_call {
        thread := cast(*Thread) opaque;
        push_context thread.starting_context {
            context.thread_index = cast(u32) thread.index;
            context.stack_trace = null;
            context.temporary_storage = *thread.starting_temporary_storage;
            thread.proc(thread);
            atomic_write(*thread.is_done, true);
            atomic_write(*thread.done, true);
            signal(*thread.is_alive_semaphore);
        }
        return null;
    }
} else {
    native_windows_library :: #system_library "kernel32";
    native_tick_count :: () -> u64 #foreign native_windows_library "GetTickCount64";
    native_windows_thread_entry :: (opaque: *void) -> u32 #c_call {
        thread := cast(*Thread) opaque;
        push_context thread.starting_context {
            context.thread_index = cast(u32) thread.index;
            context.stack_trace = null;
            context.temporary_storage = *thread.starting_temporary_storage;
            thread.proc(thread);
            atomic_write(*thread.is_done, true);
            atomic_write(*thread.done, true);
            signal(*thread.is_alive_semaphore);
        }
        return 0;
    }
}
