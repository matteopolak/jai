// Linux declarations: <pthread.h>.
SCHED_OTHER :: 0;
SCHED_FIFO :: 1;
SCHED_RR :: 2;
__PTHREAD_MUTEX_HAVE_PREV :: 1;
__have_pthread_attr_t :: 1;
PTHREAD_ONCE_INIT :: 0;
PTHREAD_BARRIER_SERIAL_THREAD :: -1;
sched_param :: struct {
    sched_priority: s32;
}
sched_setparam :: (__pid: pid_t, __param: *sched_param) -> s32 #foreign libpthread;
sched_getparam :: (__pid: pid_t, __param: *sched_param) -> s32 #foreign libpthread;
sched_setscheduler :: (__pid: pid_t, __policy: s32, __param: *sched_param) -> s32 #foreign libpthread;
sched_getscheduler :: (__pid: pid_t) -> s32 #foreign libpthread;
sched_yield :: () -> s32 #foreign libpthread;
sched_get_priority_max :: (__algorithm: s32) -> s32 #foreign libpthread;
sched_get_priority_min :: (__algorithm: s32) -> s32 #foreign libpthread;
sched_rr_get_interval :: (__pid: pid_t, __t: *timespec) -> s32 #foreign libpthread;
__pthread_rwlock_arch_t :: struct {
    __readers: u32;
    __writers: u32;
    __wrphase_futex: u32;
    __writers_futex: u32;
    __pad3: u32;
    __pad4: u32;
    __cur_writer: s32;
    __shared: s32;
    __rwelision: s8;
    __pad1: [7] u8;
    __pad2: u64;
    __flags: u32;
}
__pthread_internal_list :: struct {
    __prev: *__pthread_internal_list;
    __next: *__pthread_internal_list;
}
__pthread_list_t :: __pthread_internal_list;
__pthread_mutex_s :: struct {
    __lock: s32;
    __count: u32;
    __owner: s32;
    __nusers: u32;
    __kind: s32;
    __spins: s16;
    __elision: s16;
    __list: __pthread_list_t;
}
__pthread_cond_s :: struct {
    union {
        __wseq: u64;
        __wseq32: struct {
            __low: u32;
            __high: u32;
        };
    }
    union {
        __g1_start: u64;
        __g1_start32: struct {
            __low: u32;
            __high: u32;
        };
    }
    __g_refs: [2] u32;
    __g_size: [2] u32;
    __g1_orig_size: u32;
    __wrefs: u32;
    __g_signals: [2] u32;
}
pthread_t :: u64;
pthread_mutexattr_t :: union {
    __size: [4] u8;
    __align: s32;
}
pthread_condattr_t :: union {
    __size: [4] u8;
    __align: s32;
}
pthread_key_t :: u32;
pthread_once_t :: s32;
pthread_attr_t :: union {
    __size: [56] u8;
    __align: s64;
}
pthread_mutex_t :: union {
    __data: __pthread_mutex_s;
    __size: [40] u8;
    __align: s64;
}
pthread_cond_t :: union {
    __data: __pthread_cond_s;
    __size: [48] u8;
    __align: s64;
}
pthread_rwlock_t :: union {
    __data: __pthread_rwlock_arch_t;
    __size: [56] u8;
    __align: s64;
}
pthread_rwlockattr_t :: union {
    __size: [8] u8;
    __align: s64;
}
pthread_spinlock_t :: s32;
pthread_barrier_t :: union {
    __size: [32] u8;
    __align: s64;
}
pthread_barrierattr_t :: union {
    __size: [4] u8;
    __align: s32;
}
__jmp_buf :: [8] s64;
PTHREAD_CREATE :: enum u32 {
    JOINABLE :: 0;
    DETACHED :: 1;
    PTHREAD_CREATE_JOINABLE :: JOINABLE;
    PTHREAD_CREATE_DETACHED :: DETACHED;
}
PTHREAD_MUTEX :: enum u32 {
    TIMED_NP :: 0;
    RECURSIVE_NP :: 1;
    ERRORCHECK_NP :: 2;
    ADAPTIVE_NP :: 3;
    NORMAL :: 0;
    RECURSIVE :: 1;
    ERRORCHECK :: 2;
    DEFAULT :: 0;
    PTHREAD_MUTEX_TIMED_NP :: TIMED_NP;
    PTHREAD_MUTEX_RECURSIVE_NP :: RECURSIVE_NP;
    PTHREAD_MUTEX_ERRORCHECK_NP :: ERRORCHECK_NP;
    PTHREAD_MUTEX_ADAPTIVE_NP :: ADAPTIVE_NP;
    PTHREAD_MUTEX_NORMAL :: NORMAL;
    PTHREAD_MUTEX_RECURSIVE :: RECURSIVE;
    PTHREAD_MUTEX_ERRORCHECK :: ERRORCHECK;
    PTHREAD_MUTEX_DEFAULT :: DEFAULT;
}
PTHREAD_MUTEX_1 :: enum u32 {
    STALLED :: 0;
    STALLED_NP :: 0;
    ROBUST :: 1;
    ROBUST_NP :: 1;
    PTHREAD_MUTEX_STALLED :: STALLED;
    PTHREAD_MUTEX_STALLED_NP :: STALLED_NP;
    PTHREAD_MUTEX_ROBUST :: ROBUST;
    PTHREAD_MUTEX_ROBUST_NP :: ROBUST_NP;
}
PTHREAD_PRIO :: enum u32 {
    NONE :: 0;
    INHERIT :: 1;
    PROTECT :: 2;
    PTHREAD_PRIO_NONE :: NONE;
    PTHREAD_PRIO_INHERIT :: INHERIT;
    PTHREAD_PRIO_PROTECT :: PROTECT;
}
PTHREAD_RWLOCK :: enum u32 {
    PREFER_READER_NP :: 0;
    PREFER_WRITER_NP :: 1;
    PREFER_WRITER_NONRECURSIVE_NP :: 2;
    DEFAULT_NP :: 0;
    PTHREAD_RWLOCK_PREFER_READER_NP :: PREFER_READER_NP;
    PTHREAD_RWLOCK_PREFER_WRITER_NP :: PREFER_WRITER_NP;
    PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP :: PREFER_WRITER_NONRECURSIVE_NP;
    PTHREAD_RWLOCK_DEFAULT_NP :: DEFAULT_NP;
}
PTHREAD :: enum u32 {
    INHERIT_SCHED :: 0;
    EXPLICIT_SCHED :: 1;
    PTHREAD_INHERIT_SCHED :: INHERIT_SCHED;
    PTHREAD_EXPLICIT_SCHED :: EXPLICIT_SCHED;
}
PTHREAD_SCOPE :: enum u32 {
    SYSTEM :: 0;
    PROCESS :: 1;
    PTHREAD_SCOPE_SYSTEM :: SYSTEM;
    PTHREAD_SCOPE_PROCESS :: PROCESS;
}
PTHREAD_PROCESS :: enum u32 {
    PRIVATE :: 0;
    SHARED :: 1;
    PTHREAD_PROCESS_PRIVATE :: PRIVATE;
    PTHREAD_PROCESS_SHARED :: SHARED;
}
_pthread_cleanup_buffer :: struct {
    __routine: #type (unknown0: *void) -> void #c_call;
    __arg: *void;
    __canceltype: s32;
    __prev: *_pthread_cleanup_buffer;
}
PTHREAD_CANCEL :: enum u32 {
    ENABLE :: 0;
    DISABLE :: 1;
    PTHREAD_CANCEL_ENABLE :: ENABLE;
    PTHREAD_CANCEL_DISABLE :: DISABLE;
}
PTHREAD_CANCEL_1 :: enum u32 {
    DEFERRED :: 0;
    ASYNCHRONOUS :: 1;
    PTHREAD_CANCEL_DEFERRED :: DEFERRED;
    PTHREAD_CANCEL_ASYNCHRONOUS :: ASYNCHRONOUS;
}
pthread_create :: (__newthread: *pthread_t, __attr: *pthread_attr_t, __start_routine: #type (unknown0: *void) -> *void #c_call, __arg: *void) -> s32 #foreign libpthread;
pthread_exit :: (__retval: *void) -> void #foreign libpthread;
pthread_join :: (__th: pthread_t, __thread_return: **void) -> s32 #foreign libpthread;
pthread_detach :: (__th: pthread_t) -> s32 #foreign libpthread;
pthread_self :: () -> pthread_t #foreign libpthread;
pthread_equal :: (__thread1: pthread_t, __thread2: pthread_t) -> s32 #foreign libpthread;
pthread_attr_init :: (__attr: *pthread_attr_t) -> s32 #foreign libpthread;
pthread_attr_destroy :: (__attr: *pthread_attr_t) -> s32 #foreign libpthread;
pthread_attr_getdetachstate :: (__attr: *pthread_attr_t, __detachstate: *s32) -> s32 #foreign libpthread;
pthread_attr_setdetachstate :: (__attr: *pthread_attr_t, __detachstate: s32) -> s32 #foreign libpthread;
pthread_attr_getguardsize :: (__attr: *pthread_attr_t, __guardsize: *u64) -> s32 #foreign libpthread;
pthread_attr_setguardsize :: (__attr: *pthread_attr_t, __guardsize: u64) -> s32 #foreign libpthread;
pthread_attr_getschedparam :: (__attr: *pthread_attr_t, __param: *sched_param) -> s32 #foreign libpthread;
pthread_attr_setschedparam :: (__attr: *pthread_attr_t, __param: *sched_param) -> s32 #foreign libpthread;
pthread_attr_getschedpolicy :: (__attr: *pthread_attr_t, __policy: *s32) -> s32 #foreign libpthread;
pthread_attr_setschedpolicy :: (__attr: *pthread_attr_t, __policy: s32) -> s32 #foreign libpthread;
pthread_attr_getinheritsched :: (__attr: *pthread_attr_t, __inherit: *s32) -> s32 #foreign libpthread;
pthread_attr_setinheritsched :: (__attr: *pthread_attr_t, __inherit: s32) -> s32 #foreign libpthread;
pthread_attr_getscope :: (__attr: *pthread_attr_t, __scope: *s32) -> s32 #foreign libpthread;
pthread_attr_setscope :: (__attr: *pthread_attr_t, __scope: s32) -> s32 #foreign libpthread;
pthread_attr_getstackaddr :: (__attr: *pthread_attr_t, __stackaddr: **void) -> s32 #foreign libpthread;
pthread_attr_setstackaddr :: (__attr: *pthread_attr_t, __stackaddr: *void) -> s32 #foreign libpthread;
pthread_attr_getstacksize :: (__attr: *pthread_attr_t, __stacksize: *u64) -> s32 #foreign libpthread;
pthread_attr_setstacksize :: (__attr: *pthread_attr_t, __stacksize: u64) -> s32 #foreign libpthread;
pthread_attr_getstack :: (__attr: *pthread_attr_t, __stackaddr: **void, __stacksize: *u64) -> s32 #foreign libpthread;
pthread_attr_setstack :: (__attr: *pthread_attr_t, __stackaddr: *void, __stacksize: u64) -> s32 #foreign libpthread;
pthread_setschedparam :: (__target_thread: pthread_t, __policy: s32, __param: *sched_param) -> s32 #foreign libpthread;
pthread_getschedparam :: (__target_thread: pthread_t, __policy: *s32, __param: *sched_param) -> s32 #foreign libpthread;
pthread_setschedprio :: (__target_thread: pthread_t, __prio: s32) -> s32 #foreign libpthread;
pthread_once :: (__once_control: *pthread_once_t, __init_routine: #type () -> void #c_call) -> s32 #foreign libpthread;
pthread_setcancelstate :: (__state: s32, __oldstate: *s32) -> s32 #foreign libpthread;
pthread_setcanceltype :: (__type: s32, __oldtype: *s32) -> s32 #foreign libpthread;
pthread_cancel :: (__th: pthread_t) -> s32 #foreign libpthread;
pthread_testcancel :: () -> void #foreign libpthread;
__pthread_unwind_buf_t :: struct {
    __cancel_jmp_buf: [1] struct {
        __cancel_jmp_buf: __jmp_buf;
        __mask_was_saved: s32;
    };
    __pad: [4] *void;
}
__pthread_cleanup_frame :: struct {
    __cancel_routine: #type (unknown0: *void) -> void #c_call;
    __cancel_arg: *void;
    __do_it: s32;
    __cancel_type: s32;
}
__pthread_register_cancel :: (__buf: *__pthread_unwind_buf_t) -> void #foreign libpthread;
__pthread_unregister_cancel :: (__buf: *__pthread_unwind_buf_t) -> void #foreign libpthread;
__pthread_unwind_next :: (__buf: *__pthread_unwind_buf_t) -> void #foreign libpthread;
__sigsetjmp :: (__env: *__jmp_buf_tag, __savemask: s32) -> s32 #foreign libpthread;
pthread_mutex_init :: (__mutex: *pthread_mutex_t, __mutexattr: *pthread_mutexattr_t) -> s32 #foreign libpthread;
pthread_mutex_destroy :: (__mutex: *pthread_mutex_t) -> s32 #foreign libpthread;
pthread_mutex_trylock :: (__mutex: *pthread_mutex_t) -> s32 #foreign libpthread;
pthread_mutex_lock :: (__mutex: *pthread_mutex_t) -> s32 #foreign libpthread;
pthread_mutex_timedlock :: (__mutex: *pthread_mutex_t, __abstime: *timespec) -> s32 #foreign libpthread;
pthread_mutex_unlock :: (__mutex: *pthread_mutex_t) -> s32 #foreign libpthread;
pthread_mutex_getprioceiling :: (__mutex: *pthread_mutex_t, __prioceiling: *s32) -> s32 #foreign libpthread;
pthread_mutex_setprioceiling :: (__mutex: *pthread_mutex_t, __prioceiling: s32, __old_ceiling: *s32) -> s32 #foreign libpthread;
pthread_mutex_consistent :: (__mutex: *pthread_mutex_t) -> s32 #foreign libpthread;
pthread_mutexattr_init :: (__attr: *pthread_mutexattr_t) -> s32 #foreign libpthread;
pthread_mutexattr_destroy :: (__attr: *pthread_mutexattr_t) -> s32 #foreign libpthread;
pthread_mutexattr_getpshared :: (__attr: *pthread_mutexattr_t, __pshared: *s32) -> s32 #foreign libpthread;
pthread_mutexattr_setpshared :: (__attr: *pthread_mutexattr_t, __pshared: s32) -> s32 #foreign libpthread;
pthread_mutexattr_gettype :: (__attr: *pthread_mutexattr_t, __kind: *s32) -> s32 #foreign libpthread;
pthread_mutexattr_settype :: (__attr: *pthread_mutexattr_t, __kind: s32) -> s32 #foreign libpthread;
pthread_mutexattr_getprotocol :: (__attr: *pthread_mutexattr_t, __protocol: *s32) -> s32 #foreign libpthread;
pthread_mutexattr_setprotocol :: (__attr: *pthread_mutexattr_t, __protocol: s32) -> s32 #foreign libpthread;
pthread_mutexattr_getprioceiling :: (__attr: *pthread_mutexattr_t, __prioceiling: *s32) -> s32 #foreign libpthread;
pthread_mutexattr_setprioceiling :: (__attr: *pthread_mutexattr_t, __prioceiling: s32) -> s32 #foreign libpthread;
pthread_mutexattr_getrobust :: (__attr: *pthread_mutexattr_t, __robustness: *s32) -> s32 #foreign libpthread;
pthread_mutexattr_setrobust :: (__attr: *pthread_mutexattr_t, __robustness: s32) -> s32 #foreign libpthread;
pthread_rwlock_init :: (__rwlock: *pthread_rwlock_t, __attr: *pthread_rwlockattr_t) -> s32 #foreign libpthread;
pthread_rwlock_destroy :: (__rwlock: *pthread_rwlock_t) -> s32 #foreign libpthread;
pthread_rwlock_rdlock :: (__rwlock: *pthread_rwlock_t) -> s32 #foreign libpthread;
pthread_rwlock_tryrdlock :: (__rwlock: *pthread_rwlock_t) -> s32 #foreign libpthread;
pthread_rwlock_timedrdlock :: (__rwlock: *pthread_rwlock_t, __abstime: *timespec) -> s32 #foreign libpthread;
pthread_rwlock_wrlock :: (__rwlock: *pthread_rwlock_t) -> s32 #foreign libpthread;
pthread_rwlock_trywrlock :: (__rwlock: *pthread_rwlock_t) -> s32 #foreign libpthread;
pthread_rwlock_timedwrlock :: (__rwlock: *pthread_rwlock_t, __abstime: *timespec) -> s32 #foreign libpthread;
pthread_rwlock_unlock :: (__rwlock: *pthread_rwlock_t) -> s32 #foreign libpthread;
pthread_rwlockattr_init :: (__attr: *pthread_rwlockattr_t) -> s32 #foreign libpthread;
pthread_rwlockattr_destroy :: (__attr: *pthread_rwlockattr_t) -> s32 #foreign libpthread;
pthread_rwlockattr_getpshared :: (__attr: *pthread_rwlockattr_t, __pshared: *s32) -> s32 #foreign libpthread;
pthread_rwlockattr_setpshared :: (__attr: *pthread_rwlockattr_t, __pshared: s32) -> s32 #foreign libpthread;
pthread_rwlockattr_getkind_np :: (__attr: *pthread_rwlockattr_t, __pref: *s32) -> s32 #foreign libpthread;
pthread_rwlockattr_setkind_np :: (__attr: *pthread_rwlockattr_t, __pref: s32) -> s32 #foreign libpthread;
pthread_cond_init :: (__cond: *pthread_cond_t, __cond_attr: *pthread_condattr_t) -> s32 #foreign libpthread;
pthread_cond_destroy :: (__cond: *pthread_cond_t) -> s32 #foreign libpthread;
pthread_cond_signal :: (__cond: *pthread_cond_t) -> s32 #foreign libpthread;
pthread_cond_broadcast :: (__cond: *pthread_cond_t) -> s32 #foreign libpthread;
pthread_cond_wait :: (__cond: *pthread_cond_t, __mutex: *pthread_mutex_t) -> s32 #foreign libpthread;
pthread_cond_timedwait :: (__cond: *pthread_cond_t, __mutex: *pthread_mutex_t, __abstime: *timespec) -> s32 #foreign libpthread;
pthread_condattr_init :: (__attr: *pthread_condattr_t) -> s32 #foreign libpthread;
pthread_condattr_destroy :: (__attr: *pthread_condattr_t) -> s32 #foreign libpthread;
pthread_condattr_getpshared :: (__attr: *pthread_condattr_t, __pshared: *s32) -> s32 #foreign libpthread;
pthread_condattr_setpshared :: (__attr: *pthread_condattr_t, __pshared: s32) -> s32 #foreign libpthread;
pthread_condattr_getclock :: (__attr: *pthread_condattr_t, __clock_id: *__clockid_t) -> s32 #foreign libpthread;
pthread_condattr_setclock :: (__attr: *pthread_condattr_t, __clock_id: __clockid_t) -> s32 #foreign libpthread;
pthread_spin_init :: (__lock: *pthread_spinlock_t, __pshared: s32) -> s32 #foreign libpthread;
pthread_spin_destroy :: (__lock: *pthread_spinlock_t) -> s32 #foreign libpthread;
pthread_spin_lock :: (__lock: *pthread_spinlock_t) -> s32 #foreign libpthread;
pthread_spin_trylock :: (__lock: *pthread_spinlock_t) -> s32 #foreign libpthread;
pthread_spin_unlock :: (__lock: *pthread_spinlock_t) -> s32 #foreign libpthread;
pthread_barrier_init :: (__barrier: *pthread_barrier_t, __attr: *pthread_barrierattr_t, __count: u32) -> s32 #foreign libpthread;
pthread_barrier_destroy :: (__barrier: *pthread_barrier_t) -> s32 #foreign libpthread;
pthread_barrier_wait :: (__barrier: *pthread_barrier_t) -> s32 #foreign libpthread;
pthread_barrierattr_init :: (__attr: *pthread_barrierattr_t) -> s32 #foreign libpthread;
pthread_barrierattr_destroy :: (__attr: *pthread_barrierattr_t) -> s32 #foreign libpthread;
pthread_barrierattr_getpshared :: (__attr: *pthread_barrierattr_t, __pshared: *s32) -> s32 #foreign libpthread;
pthread_barrierattr_setpshared :: (__attr: *pthread_barrierattr_t, __pshared: s32) -> s32 #foreign libpthread;
pthread_key_create :: (__key: *pthread_key_t, __destr_function: #type (unknown0: *void) -> void #c_call) -> s32 #foreign libpthread;
pthread_key_delete :: (__key: pthread_key_t) -> s32 #foreign libpthread;
pthread_getspecific :: (__key: pthread_key_t) -> *void #foreign libpthread;
pthread_setspecific :: (__key: pthread_key_t, __pointer: *void) -> s32 #foreign libpthread;
pthread_getcpuclockid :: (__thread_id: pthread_t, __clock_id: *__clockid_t) -> s32 #foreign libpthread;
__sigset_t :: struct {
    __val: [16] u64;
}
__jmp_buf_tag :: struct {
    __jmpbuf: __jmp_buf;
    __mask_was_saved: s32;
    __saved_mask: __sigset_t;
}
jmp_buf :: [1] __jmp_buf_tag;
setjmp :: (__env: *jmp_buf) -> s32 #foreign libpthread;
_setjmp :: (__env: *[1] __jmp_buf_tag) -> s32 #foreign libpthread;
longjmp :: (__env: *[1] __jmp_buf_tag, __val: s32) -> void #foreign libpthread;
_longjmp :: (__env: *[1] __jmp_buf_tag, __val: s32) -> void #foreign libpthread;
sigjmp_buf :: [1] __jmp_buf_tag;
siglongjmp :: (__env: *sigjmp_buf, __val: s32) -> void #foreign libpthread;
#scope_file
libpthread :: #system_library "libpthread";
libc :: #system_library "libc";
