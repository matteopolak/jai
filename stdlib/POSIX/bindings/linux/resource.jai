// Linux declarations: <sys/resource.h>.
RLIM_INFINITY :: cast,trunc(u64) -1;
RLIM64_INFINITY :: 0xffffffffffffffff;
RLIM_SAVED_MAX :: RLIM_INFINITY;
RLIM_SAVED_CUR :: RLIM_INFINITY;
__rusage_defined :: 1;
PRIO_MIN :: -20;
PRIO_MAX :: 20;

RLIMIT_RESOURCE :: enum u32 {
    RLIMIT_CPU :: 0;
    RLIMIT_FSIZE :: 1;
    RLIMIT_DATA :: 2;
    RLIMIT_STACK :: 3;
    RLIMIT_CORE :: 4;
    RLIMIT_RSS :: 5;
    RLIMIT_NOFILE :: 7;
    RLIMIT_OFILE :: 7;
    RLIMIT_AS :: 9;
    RLIMIT_NPROC :: 6;
    RLIMIT_MEMLOCK :: 8;
    RLIMIT_LOCKS :: 10;
    RLIMIT_SIGPENDING :: 11;
    RLIMIT_MSGQUEUE :: 12;
    RLIMIT_NICE :: 13;
    RLIMIT_RTPRIO :: 14;
    RLIMIT_RTTIME :: 15;
    RLIMIT_NLIMITS :: 16;
    RLIM_NLIMITS :: 16;
}

rlim_t :: u64;
rlim64_t :: u64;

rlimit :: struct {
    rlim_cur: rlim_t;
    rlim_max: rlim_t;
}

rlimit64 :: struct {
    rlim_cur: rlim64_t;
    rlim_max: rlim64_t;
}

RUSAGE :: enum s32 {
    SELF :: 0;
    CHILDREN :: -1;
    THREAD :: 1;
}

rusage :: struct {
    ru_utime: timeval;
    ru_stime: timeval;
    union {
        ru_maxrss: s64;
        __ru_maxrss_word: s64;
    }
    union {
        ru_ixrss: s64;
        __ru_ixrss_word: s64;
    }
    union {
        ru_idrss: s64;
        __ru_idrss_word: s64;
    }
    union {
        ru_isrss: s64;
        __ru_isrss_word: s64;
    }
    union {
        ru_minflt: s64;
        __ru_minflt_word: s64;
    }
    union {
        ru_majflt: s64;
        __ru_majflt_word: s64;
    }
    union {
        ru_nswap: s64;
        __ru_nswap_word: s64;
    }
    union {
        ru_inblock: s64;
        __ru_inblock_word: s64;
    }
    union {
        ru_oublock: s64;
        __ru_oublock_word: s64;
    }
    union {
        ru_msgsnd: s64;
        __ru_msgsnd_word: s64;
    }
    union {
        ru_msgrcv: s64;
        __ru_msgrcv_word: s64;
    }
    union {
        ru_nsignals: s64;
        __ru_nsignals_word: s64;
    }
    union {
        ru_nvcsw: s64;
        __ru_nvcsw_word: s64;
    }
    union {
        ru_nivcsw: s64;
        __ru_nivcsw_word: s64;
    }
}

PRIO :: enum u32 {
    PROCESS :: 0;
    PGRP :: 1;
    USER :: 2;
}

prlimit :: (__pid: s32, __resource: RLIMIT_RESOURCE, __new_limit: *rlimit, __old_limit: *rlimit) -> s32 #foreign libc;
prlimit64 :: (__pid: s32, __resource: RLIMIT_RESOURCE, __new_limit: *rlimit64, __old_limit: *rlimit64) -> s32 #foreign libc;
id_t :: u32;
getrlimit :: (__resource: RLIMIT_RESOURCE, __rlimits: *rlimit) -> s32 #foreign libc;
getrlimit64 :: (__resource: RLIMIT_RESOURCE, __rlimits: *rlimit64) -> s32 #foreign libc;
setrlimit :: (__resource: RLIMIT_RESOURCE, __rlimits: *rlimit) -> s32 #foreign libc;
setrlimit64 :: (__resource: RLIMIT_RESOURCE, __rlimits: *rlimit64) -> s32 #foreign libc;
getrusage :: (__who: RUSAGE, __usage: *rusage) -> s32 #foreign libc;
getpriority :: (__which: PRIO, __who: id_t) -> s32 #foreign libc;
setpriority :: (__which: PRIO, __who: id_t, __prio: s32) -> s32 #foreign libc;
#scope_file
libc :: #system_library "libc";
