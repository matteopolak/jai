// Android arm64 declarations: <pthread.h>.
CSIGNAL :: 0x000000ff;
CLONE_VM :: 0x00000100;
CLONE_FS :: 0x00000200;
CLONE_FILES :: 0x00000400;
CLONE_SIGHAND :: 0x00000800;
CLONE_PIDFD :: 0x00001000;
CLONE_PTRACE :: 0x00002000;
CLONE_VFORK :: 0x00004000;
CLONE_PARENT :: 0x00008000;
CLONE_THREAD :: 0x00010000;
CLONE_NEWNS :: 0x00020000;
CLONE_SYSVSEM :: 0x00040000;
CLONE_SETTLS :: 0x00080000;
CLONE_PARENT_SETTID :: 0x00100000;
CLONE_CHILD_CLEARTID :: 0x00200000;
CLONE_DETACHED :: 0x00400000;
CLONE_UNTRACED :: 0x00800000;
CLONE_CHILD_SETTID :: 0x01000000;
CLONE_NEWCGROUP :: 0x02000000;
CLONE_NEWUTS :: 0x04000000;
CLONE_NEWIPC :: 0x08000000;
CLONE_NEWUSER :: 0x10000000;
CLONE_NEWPID :: 0x20000000;
CLONE_NEWNET :: 0x40000000;
CLONE_IO :: 0x80000000;
CLONE_CLEAR_SIGHAND :: 0x100000000;
CLONE_INTO_CGROUP :: 0x200000000;
CLONE_NEWTIME :: 0x00000080;
CLONE_ARGS_SIZE_VER0 :: 64;
CLONE_ARGS_SIZE_VER1 :: 80;
CLONE_ARGS_SIZE_VER2 :: 88;
SCHED_NORMAL :: 0;
SCHED_FIFO :: 1;
SCHED_RR :: 2;
SCHED_BATCH :: 3;
SCHED_IDLE :: 5;
SCHED_DEADLINE :: 6;
SCHED_RESET_ON_FORK :: 0x40000000;
SCHED_FLAG_RESET_ON_FORK :: 0x01;
SCHED_FLAG_RECLAIM :: 0x02;
SCHED_FLAG_DL_OVERRUN :: 0x04;
SCHED_FLAG_KEEP_POLICY :: 0x08;
SCHED_FLAG_KEEP_PARAMS :: 0x10;
SCHED_FLAG_UTIL_CLAMP_MIN :: 0x20;
SCHED_FLAG_UTIL_CLAMP_MAX :: 0x40;
SCHED_FLAG_KEEP_ALL :: SCHED_FLAG_KEEP_POLICY | SCHED_FLAG_KEEP_PARAMS;
SCHED_FLAG_UTIL_CLAMP :: SCHED_FLAG_UTIL_CLAMP_MIN | SCHED_FLAG_UTIL_CLAMP_MAX;
SCHED_FLAG_ALL :: SCHED_FLAG_RESET_ON_FORK | SCHED_FLAG_RECLAIM | SCHED_FLAG_DL_OVERRUN | SCHED_FLAG_KEEP_ALL | SCHED_FLAG_UTIL_CLAMP;
SCHED_OTHER :: SCHED_NORMAL;
CPU_SETSIZE :: 1024;
PTHREAD_ONCE_INIT :: 0;
PTHREAD_BARRIER_SERIAL_THREAD :: -1;
PTHREAD_CREATE_DETACHED :: 1;
PTHREAD_CREATE_JOINABLE :: 0;
PTHREAD_EXPLICIT_SCHED :: 0;
PTHREAD_INHERIT_SCHED :: 1;
PTHREAD_PRIO_NONE :: 0;
PTHREAD_PRIO_INHERIT :: 1;
PTHREAD_PROCESS_PRIVATE :: 0;
PTHREAD_PROCESS_SHARED :: 1;
PTHREAD_SCOPE_SYSTEM :: 0;
PTHREAD_SCOPE_PROCESS :: 1;
_JBLEN :: 32;
pthread_attr_t :: struct {
    flags: u32;
    stack_base: *void;
    stack_size: u64;
    guard_size: u64;
    sched_policy: s32;
    sched_priority: s32;
    __reserved: [16] u8;
}
pthread_barrier_t :: struct {
    __private: [4] s64;
}
pthread_barrierattr_t :: s32;
pthread_cond_t :: struct {
    __private: [12] s32;
}
pthread_condattr_t :: s64;
pthread_key_t :: s32;
pthread_mutex_t :: struct {
    __private: [10] s32;
}
pthread_mutexattr_t :: s64;
pthread_once_t :: s32;
pthread_rwlock_t :: struct {
    __private: [14] s32;
}
pthread_rwlockattr_t :: s64;
pthread_spinlock_t :: struct {
    __private: s64;
}
pthread_t :: s64;
clone_args :: struct {
    flags: u64;
    pidfd: u64;
    child_tid: u64;
    parent_tid: u64;
    exit_signal: u64;
    stack: u64;
    stack_size: u64;
    tls: u64;
    set_tid: u64;
    set_tid_size: u64;
    cgroup: u64;
}
sched_param :: struct {
    sched_priority: s32;
}
sched_setscheduler :: (__pid: pid_t, __policy: s32, __param: *sched_param) -> s32 #foreign libc;
sched_getscheduler :: (__pid: pid_t) -> s32 #foreign libc;
sched_yield :: () -> s32 #foreign libc;
sched_get_priority_max :: (__policy: s32) -> s32 #foreign libc;
sched_get_priority_min :: (__policy: s32) -> s32 #foreign libc;
sched_setparam :: (__pid: pid_t, __param: *sched_param) -> s32 #foreign libc;
sched_getparam :: (__pid: pid_t, __param: *sched_param) -> s32 #foreign libc;
sched_rr_get_interval :: (__pid: pid_t, __quantum: *timespec) -> s32 #foreign libc;
clone :: (__fn: #type (unknown0: *void) -> s32 #c_call, __child_stack: *void, __flags: s32, __arg: *void, __args: ..Any) -> s32 #foreign libc;
unshare :: (__flags: s32) -> s32 #foreign libc;
setns :: (__fd: s32, __ns_type: s32) -> s32 #foreign libc;
sched_getcpu :: () -> s32 #foreign libc;
cpu_set_t :: struct {
    __bits: [16] u64;
}
sched_setaffinity :: (__pid: pid_t, __set_size: u64, __set: *cpu_set_t) -> s32 #foreign libc;
sched_getaffinity :: (__pid: pid_t, __set_size: u64, __set: *cpu_set_t) -> s32 #foreign libc;
__sched_cpucount :: (__set_size: u64, __set: *cpu_set_t) -> s32 #foreign libc;
__sched_cpualloc :: (__count: u64) -> *cpu_set_t #foreign libc;
__sched_cpufree :: (__set: *cpu_set_t) -> void #foreign libc;
PTHREAD_MUTEX :: enum u32 {
    NORMAL :: 0;
    RECURSIVE :: 1;
    ERRORCHECK :: 2;
    ERRORCHECK_NP :: 2;
    RECURSIVE_NP :: 1;
    DEFAULT :: 0;
    PTHREAD_MUTEX_NORMAL :: NORMAL;
    PTHREAD_MUTEX_RECURSIVE :: RECURSIVE;
    PTHREAD_MUTEX_ERRORCHECK :: ERRORCHECK;
    PTHREAD_MUTEX_ERRORCHECK_NP :: ERRORCHECK_NP;
    PTHREAD_MUTEX_RECURSIVE_NP :: RECURSIVE_NP;
    PTHREAD_MUTEX_DEFAULT :: DEFAULT;
}
PTHREAD_RWLOCK_PREFER :: enum u32 {
    READER_NP :: 0;
    WRITER_NONRECURSIVE_NP :: 1;
    PTHREAD_RWLOCK_PREFER_READER_NP :: READER_NP;
    PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP :: WRITER_NONRECURSIVE_NP;
}
pthread_atfork :: (__prepare: #type () -> void #c_call, __parent: #type () -> void #c_call, __child: #type () -> void #c_call) -> s32 #foreign libc;
pthread_attr_destroy :: (__attr: *pthread_attr_t) -> s32 #foreign libc;
pthread_attr_getdetachstate :: (__attr: *pthread_attr_t, __state: *s32) -> s32 #foreign libc;
pthread_attr_getguardsize :: (__attr: *pthread_attr_t, __size: *u64) -> s32 #foreign libc;
pthread_attr_getinheritsched :: (__attr: *pthread_attr_t, __flag: *s32) -> s32 #foreign libc;
pthread_attr_getschedparam :: (__attr: *pthread_attr_t, __param: *sched_param) -> s32 #foreign libc;
pthread_attr_getschedpolicy :: (__attr: *pthread_attr_t, __policy: *s32) -> s32 #foreign libc;
pthread_attr_getscope :: (__attr: *pthread_attr_t, __scope: *s32) -> s32 #foreign libc;
pthread_attr_getstack :: (__attr: *pthread_attr_t, __addr: **void, __size: *u64) -> s32 #foreign libc;
pthread_attr_getstacksize :: (__attr: *pthread_attr_t, __size: *u64) -> s32 #foreign libc;
pthread_attr_init :: (__attr: *pthread_attr_t) -> s32 #foreign libc;
pthread_attr_setdetachstate :: (__attr: *pthread_attr_t, __state: s32) -> s32 #foreign libc;
pthread_attr_setguardsize :: (__attr: *pthread_attr_t, __size: u64) -> s32 #foreign libc;
pthread_attr_setinheritsched :: (__attr: *pthread_attr_t, __flag: s32) -> s32 #foreign libc;
pthread_attr_setschedparam :: (__attr: *pthread_attr_t, __param: *sched_param) -> s32 #foreign libc;
pthread_attr_setschedpolicy :: (__attr: *pthread_attr_t, __policy: s32) -> s32 #foreign libc;
pthread_attr_setscope :: (__attr: *pthread_attr_t, __scope: s32) -> s32 #foreign libc;
pthread_attr_setstack :: (__attr: *pthread_attr_t, __addr: *void, __size: u64) -> s32 #foreign libc;
pthread_attr_setstacksize :: (__addr: *pthread_attr_t, __size: u64) -> s32 #foreign libc;
pthread_condattr_destroy :: (__attr: *pthread_condattr_t) -> s32 #foreign libc;
pthread_condattr_getclock :: (__attr: *pthread_condattr_t, __clock: *clockid_t) -> s32 #foreign libc;
pthread_condattr_getpshared :: (__attr: *pthread_condattr_t, __shared: *s32) -> s32 #foreign libc;
pthread_condattr_init :: (__attr: *pthread_condattr_t) -> s32 #foreign libc;
pthread_condattr_setclock :: (__attr: *pthread_condattr_t, __clock: clockid_t) -> s32 #foreign libc;
pthread_condattr_setpshared :: (__attr: *pthread_condattr_t, __shared: s32) -> s32 #foreign libc;
pthread_cond_broadcast :: (__cond: *pthread_cond_t) -> s32 #foreign libc;
pthread_cond_clockwait :: (__cond: *pthread_cond_t, __mutex: *pthread_mutex_t, __clock: clockid_t, __timeout: *timespec) -> s32 #foreign libc;
pthread_cond_destroy :: (__cond: *pthread_cond_t) -> s32 #foreign libc;
pthread_cond_init :: (__cond: *pthread_cond_t, __attr: *pthread_condattr_t) -> s32 #foreign libc;
pthread_cond_signal :: (__cond: *pthread_cond_t) -> s32 #foreign libc;
pthread_cond_timedwait :: (__cond: *pthread_cond_t, __mutex: *pthread_mutex_t, __timeout: *timespec) -> s32 #foreign libc;
pthread_cond_timedwait_monotonic_np :: (__cond: *pthread_cond_t, __mutex: *pthread_mutex_t, __timeout: *timespec) -> s32 #foreign libc;
pthread_cond_wait :: (__cond: *pthread_cond_t, __mutex: *pthread_mutex_t) -> s32 #foreign libc;
pthread_create :: (__pthread_ptr: *pthread_t, __attr: *pthread_attr_t, __start_routine: #type (unknown0: *void) -> *void #c_call, unknown0: *void) -> s32 #foreign libc;
pthread_detach :: (__pthread: pthread_t) -> s32 #foreign libc;
pthread_exit :: (__return_value: *void) -> void #foreign libc;
pthread_equal :: (__lhs: pthread_t, __rhs: pthread_t) -> s32 #foreign libc;
pthread_getattr_np :: (__pthread: pthread_t, __attr: *pthread_attr_t) -> s32 #foreign libc;
pthread_getcpuclockid :: (__pthread: pthread_t, __clock: *clockid_t) -> s32 #foreign libc;
pthread_getspecific :: (__key: pthread_key_t) -> *void #foreign libc;
pthread_gettid_np :: (__pthread: pthread_t) -> pid_t #foreign libc;
pthread_join :: (__pthread: pthread_t, __return_value_ptr: **void) -> s32 #foreign libc;
pthread_key_create :: (__key_ptr: *pthread_key_t, __key_destructor: #type (unknown0: *void) -> void #c_call) -> s32 #foreign libc;
pthread_key_delete :: (__key: pthread_key_t) -> s32 #foreign libc;
pthread_mutexattr_destroy :: (__attr: *pthread_mutexattr_t) -> s32 #foreign libc;
pthread_mutexattr_getpshared :: (__attr: *pthread_mutexattr_t, __shared: *s32) -> s32 #foreign libc;
pthread_mutexattr_gettype :: (__attr: *pthread_mutexattr_t, __type: *s32) -> s32 #foreign libc;
pthread_mutexattr_getprotocol :: (__attr: *pthread_mutexattr_t, __protocol: *s32) -> s32 #foreign libc;
pthread_mutexattr_init :: (__attr: *pthread_mutexattr_t) -> s32 #foreign libc;
pthread_mutexattr_setpshared :: (__attr: *pthread_mutexattr_t, __shared: s32) -> s32 #foreign libc;
pthread_mutexattr_settype :: (__attr: *pthread_mutexattr_t, __type: s32) -> s32 #foreign libc;
pthread_mutexattr_setprotocol :: (__attr: *pthread_mutexattr_t, __protocol: s32) -> s32 #foreign libc;
pthread_mutex_clocklock :: (__mutex: *pthread_mutex_t, __clock: clockid_t, __abstime: *timespec) -> s32 #foreign libc;
pthread_mutex_destroy :: (__mutex: *pthread_mutex_t) -> s32 #foreign libc;
pthread_mutex_init :: (__mutex: *pthread_mutex_t, __attr: *pthread_mutexattr_t) -> s32 #foreign libc;
pthread_mutex_lock :: (__mutex: *pthread_mutex_t) -> s32 #foreign libc;
pthread_mutex_timedlock :: (__mutex: *pthread_mutex_t, __timeout: *timespec) -> s32 #foreign libc;
pthread_mutex_timedlock_monotonic_np :: (__mutex: *pthread_mutex_t, __timeout: *timespec) -> s32 #foreign libc;
pthread_mutex_trylock :: (__mutex: *pthread_mutex_t) -> s32 #foreign libc;
pthread_mutex_unlock :: (__mutex: *pthread_mutex_t) -> s32 #foreign libc;
pthread_once :: (__once: *pthread_once_t, __init_routine: #type () -> void #c_call) -> s32 #foreign libc;
pthread_rwlockattr_init :: (__attr: *pthread_rwlockattr_t) -> s32 #foreign libc;
pthread_rwlockattr_destroy :: (__attr: *pthread_rwlockattr_t) -> s32 #foreign libc;
pthread_rwlockattr_getpshared :: (__attr: *pthread_rwlockattr_t, __shared: *s32) -> s32 #foreign libc;
pthread_rwlockattr_setpshared :: (__attr: *pthread_rwlockattr_t, __shared: s32) -> s32 #foreign libc;
pthread_rwlockattr_getkind_np :: (__attr: *pthread_rwlockattr_t, __kind: *s32) -> s32 #foreign libc;
pthread_rwlockattr_setkind_np :: (__attr: *pthread_rwlockattr_t, __kind: s32) -> s32 #foreign libc;
pthread_rwlock_clockrdlock :: (__rwlock: *pthread_rwlock_t, __clock: clockid_t, __timeout: *timespec) -> s32 #foreign libc;
pthread_rwlock_clockwrlock :: (__rwlock: *pthread_rwlock_t, __clock: clockid_t, __timeout: *timespec) -> s32 #foreign libc;
pthread_rwlock_destroy :: (__rwlock: *pthread_rwlock_t) -> s32 #foreign libc;
pthread_rwlock_init :: (__rwlock: *pthread_rwlock_t, __attr: *pthread_rwlockattr_t) -> s32 #foreign libc;
pthread_rwlock_rdlock :: (__rwlock: *pthread_rwlock_t) -> s32 #foreign libc;
pthread_rwlock_timedrdlock :: (__rwlock: *pthread_rwlock_t, __timeout: *timespec) -> s32 #foreign libc;
pthread_rwlock_timedrdlock_monotonic_np :: (__rwlock: *pthread_rwlock_t, __timeout: *timespec) -> s32 #foreign libc;
pthread_rwlock_timedwrlock :: (__rwlock: *pthread_rwlock_t, __timeout: *timespec) -> s32 #foreign libc;
pthread_rwlock_timedwrlock_monotonic_np :: (__rwlock: *pthread_rwlock_t, __timeout: *timespec) -> s32 #foreign libc;
pthread_rwlock_tryrdlock :: (__rwlock: *pthread_rwlock_t) -> s32 #foreign libc;
pthread_rwlock_trywrlock :: (__rwlock: *pthread_rwlock_t) -> s32 #foreign libc;
pthread_rwlock_unlock :: (__rwlock: *pthread_rwlock_t) -> s32 #foreign libc;
pthread_rwlock_wrlock :: (__rwlock: *pthread_rwlock_t) -> s32 #foreign libc;
pthread_barrierattr_init :: (__attr: *pthread_barrierattr_t) -> s32 #foreign libc;
pthread_barrierattr_destroy :: (__attr: *pthread_barrierattr_t) -> s32 #foreign libc;
pthread_barrierattr_getpshared :: (__attr: *pthread_barrierattr_t, __shared: *s32) -> s32 #foreign libc;
pthread_barrierattr_setpshared :: (__attr: *pthread_barrierattr_t, __shared: s32) -> s32 #foreign libc;
pthread_barrier_init :: (__barrier: *pthread_barrier_t, __attr: *pthread_barrierattr_t, __count: u32) -> s32 #foreign libc;
pthread_barrier_destroy :: (__barrier: *pthread_barrier_t) -> s32 #foreign libc;
pthread_barrier_wait :: (__barrier: *pthread_barrier_t) -> s32 #foreign libc;
pthread_spin_destroy :: (__spinlock: *pthread_spinlock_t) -> s32 #foreign libc;
pthread_spin_init :: (__spinlock: *pthread_spinlock_t, __shared: s32) -> s32 #foreign libc;
pthread_spin_lock :: (__spinlock: *pthread_spinlock_t) -> s32 #foreign libc;
pthread_spin_trylock :: (__spinlock: *pthread_spinlock_t) -> s32 #foreign libc;
pthread_spin_unlock :: (__spinlock: *pthread_spinlock_t) -> s32 #foreign libc;
pthread_self :: () -> pthread_t #foreign libc;
pthread_getname_np :: (__pthread: pthread_t, __buf: *u8, __n: u64) -> s32 #foreign libc;
pthread_setname_np :: (__pthread: pthread_t, __name: *u8) -> s32 #foreign libc;
pthread_setschedparam :: (__pthread: pthread_t, __policy: s32, __param: *sched_param) -> s32 #foreign libc;
pthread_getschedparam :: (__pthread: pthread_t, __policy: *s32, __param: *sched_param) -> s32 #foreign libc;
pthread_setschedprio :: (__pthread: pthread_t, __priority: s32) -> s32 #foreign libc;
pthread_setspecific :: (__key: pthread_key_t, __value: *void) -> s32 #foreign libc;
__pthread_cleanup_t :: struct {
    __cleanup_prev: *__pthread_cleanup_t;
    __cleanup_routine: #type () -> void #c_call;
    __cleanup_arg: *void;
}
__pthread_cleanup_push :: (c: *__pthread_cleanup_t, unknown0: #type () -> void #c_call, unknown1: *void) -> void #foreign libc;
__pthread_cleanup_pop :: (unknown0: *__pthread_cleanup_t, unknown1: s32) -> void #foreign libc;
sem_t :: struct {
    count: u32;
    __reserved: [3] s32;
}
sem_clockwait :: (__sem: *sem_t, __clock: clockid_t, __ts: *timespec) -> s32 #foreign libc;
sem_destroy :: (__sem: *sem_t) -> s32 #foreign libc;
sem_getvalue :: (__sem: *sem_t, __value: *s32) -> s32 #foreign libc;
sem_init :: (__sem: *sem_t, __shared: s32, __value: u32) -> s32 #foreign libc;
sem_post :: (__sem: *sem_t) -> s32 #foreign libc;
sem_timedwait :: (__sem: *sem_t, __ts: *timespec) -> s32 #foreign libc;
sem_timedwait_monotonic_np :: (__sem: *sem_t, __ts: *timespec) -> s32 #foreign libc;
sem_trywait :: (__sem: *sem_t) -> s32 #foreign libc;
sem_wait :: (__sem: *sem_t) -> s32 #foreign libc;
sem_open :: (__name: *u8, _flags: s32, __args: ..Any) -> *sem_t #foreign libc;
sem_close :: (__sem: *sem_t) -> s32 #foreign libc;
sem_unlink :: (__name: *u8) -> s32 #foreign libc;
sigjmp_buf :: [33] s64;
jmp_buf :: [32] s64;
_setjmp :: (__env: *jmp_buf) -> s32 #foreign libc;
_longjmp :: (__env: *jmp_buf, __value: s32) -> void #foreign libc;
setjmp :: (__env: *jmp_buf) -> s32 #foreign libc;
longjmp :: (__env: *jmp_buf, __value: s32) -> void #foreign libc;
sigsetjmp :: (__env: *sigjmp_buf, __save_signal_mask: s32) -> s32 #foreign libc;
siglongjmp :: (__env: *sigjmp_buf, __value: s32) -> void #foreign libc;
#scope_file
libc :: #system_library "libc";
