// Android x64 declarations: <sys/resource.h>.
RUSAGE :: enum s32 {
    SELF :: 0;
    CHILDREN :: -1;
    BOTH :: -2;
    THREAD :: 1;
}
RLIM64_INFINITY :: ~0;
PRIO_MIN :: -20;
PRIO_MAX :: 20;
PRIO :: enum s32 {
    PROCESS :: 0;
    PGRP :: 1;
    USER :: 2;
}
_STK_LIM :: 8 * 1024 * 1024;
MLOCK_LIMIT :: 8 * 1024 * 1024;
RLIMIT_RESOURCE :: enum s32 {
    CPU :: 0;
    FSIZE :: 1;
    DATA :: 2;
    STACK :: 3;
    CORE :: 4;
    RSS :: 5;
    NPROC :: 6;
    NOFILE :: 7;
    MEMLOCK :: 8;
    AS :: 9;
    LOCKS :: 10;
    SIGPENDING :: 11;
    MSGQUEUE :: 12;
    NICE :: 13;
    RTPRIO :: 14;
    RTTIME :: 15;
}
RLIM_NLIMITS :: 16;
RLIM_INFINITY :: ~0;
RLIM_SAVED_CUR :: RLIM_INFINITY;
RLIM_SAVED_MAX :: RLIM_INFINITY;
id_t :: u32;
rusage :: struct {
    ru_utime: timeval;
    ru_stime: timeval;
    ru_maxrss: s64;
    ru_ixrss: s64;
    ru_idrss: s64;
    ru_isrss: s64;
    ru_minflt: s64;
    ru_majflt: s64;
    ru_nswap: s64;
    ru_inblock: s64;
    ru_oublock: s64;
    ru_msgsnd: s64;
    ru_msgrcv: s64;
    ru_nsignals: s64;
    ru_nvcsw: s64;
    ru_nivcsw: s64;
}
rlimit :: struct {
    rlim_cur: u64;
    rlim_max: u64;
}
rlimit64 :: struct {
    rlim_cur: u64;
    rlim_max: u64;
}
rlim_t :: u64;
rlim64_t :: u64;
getrlimit :: (__resource: RLIMIT_RESOURCE, __limit: *rlimit) -> s32 #foreign libc;
setrlimit :: (__resource: RLIMIT_RESOURCE, __limit: *rlimit) -> s32 #foreign libc;
getrlimit64 :: (__resource: RLIMIT_RESOURCE, __limit: *rlimit64) -> s32 #foreign libc;
setrlimit64 :: (__resource: RLIMIT_RESOURCE, __limit: *rlimit64) -> s32 #foreign libc;
getpriority :: (__which: PRIO, __who: id_t) -> s32 #foreign libc;
setpriority :: (__which: PRIO, __who: id_t, __priority: s32) -> s32 #foreign libc;
getrusage :: (__who: RUSAGE, __usage: *rusage) -> s32 #foreign libc;
prlimit :: (__pid: pid_t, __resource: RLIMIT_RESOURCE, __new_limit: *rlimit, __old_limit: *rlimit) -> s32 #foreign libc;
prlimit64 :: (__pid: pid_t, __resource: RLIMIT_RESOURCE, __new_limit: *rlimit64, __old_limit: *rlimit64) -> s32 #foreign libc;
#scope_file
libc :: #system_library "libc";
