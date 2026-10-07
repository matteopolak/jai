// Linux declarations: <sys/resource.h>.
RLIM_INFINITY :: cast,trunc(__rlim_t) -1;
RLIM_SAVED_MAX :: RLIM_INFINITY;
RLIM_SAVED_CUR :: RLIM_INFINITY;
__rusage_defined :: 1;
PRIO_MIN :: -20;
PRIO_MAX :: 20;
__u_char :: u8;
__u_short :: u16;
__u_int :: u32;
__u_long :: u64;
__quad_t :: s64;
__u_quad_t :: u64;
__intmax_t :: s64;
__uintmax_t :: u64;
__dev_t :: u64;
__uid_t :: u32;
__gid_t :: u32;
__ino_t :: u64;
__ino64_t :: u64;
__mode_t :: u32;
__nlink_t :: u64;
__off_t :: s64;
__off64_t :: s64;

__fsid_t :: struct {
    __val: [2] s32;
}

__clock_t :: s64;
__rlim_t :: u64;
__rlim64_t :: u64;
__id_t :: u32;
__time_t :: s64;
__useconds_t :: u32;
__suseconds_t :: s64;
__daddr_t :: s32;
__key_t :: s32;
__clockid_t :: s32;
__timer_t :: *void;
__blksize_t :: s64;
__blkcnt_t :: s64;
__blkcnt64_t :: s64;
__fsblkcnt_t :: u64;
__fsblkcnt64_t :: u64;
__fsfilcnt_t :: u64;
__fsfilcnt64_t :: u64;
__fsword_t :: s64;
__ssize_t :: s64;
__syscall_slong_t :: s64;
__syscall_ulong_t :: u64;
__loff_t :: __off64_t;
__caddr_t :: *u8;
__intptr_t :: s64;
__socklen_t :: u32;
__sig_atomic_t :: s32;

__rlimit_resource :: enum u32 {
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
    __RLIMIT_RSS :: RLIMIT_RSS;
    __RLIMIT_OFILE :: RLIMIT_OFILE;
    __RLIMIT_NPROC :: RLIMIT_NPROC;
    __RLIMIT_MEMLOCK :: RLIMIT_MEMLOCK;
    __RLIMIT_LOCKS :: RLIMIT_LOCKS;
    __RLIMIT_SIGPENDING :: RLIMIT_SIGPENDING;
    __RLIMIT_MSGQUEUE :: RLIMIT_MSGQUEUE;
    __RLIMIT_NICE :: RLIMIT_NICE;
    __RLIMIT_RTPRIO :: RLIMIT_RTPRIO;
    __RLIMIT_RTTIME :: RLIMIT_RTTIME;
    __RLIMIT_NLIMITS :: RLIMIT_NLIMITS;
    __RLIM_NLIMITS :: RLIM_NLIMITS;
}

rlim_t :: __rlim_t;

rlimit :: struct {
    rlim_cur: rlim_t;
    rlim_max: rlim_t;
}

RUSAGE :: enum s32 {
    SELF :: 0;
    CHILDREN :: -1;
    RUSAGE_SELF :: SELF;
    RUSAGE_CHILDREN :: CHILDREN;
}

rusage :: struct {
    ru_utime: timeval;
    ru_stime: timeval;
    union {
        ru_maxrss: s64;
        __ru_maxrss_word: __syscall_slong_t;
    }
    union {
        ru_ixrss: s64;
        __ru_ixrss_word: __syscall_slong_t;
    }
    union {
        ru_idrss: s64;
        __ru_idrss_word: __syscall_slong_t;
    }
    union {
        ru_isrss: s64;
        __ru_isrss_word: __syscall_slong_t;
    }
    union {
        ru_minflt: s64;
        __ru_minflt_word: __syscall_slong_t;
    }
    union {
        ru_majflt: s64;
        __ru_majflt_word: __syscall_slong_t;
    }
    union {
        ru_nswap: s64;
        __ru_nswap_word: __syscall_slong_t;
    }
    union {
        ru_inblock: s64;
        __ru_inblock_word: __syscall_slong_t;
    }
    union {
        ru_oublock: s64;
        __ru_oublock_word: __syscall_slong_t;
    }
    union {
        ru_msgsnd: s64;
        __ru_msgsnd_word: __syscall_slong_t;
    }
    union {
        ru_msgrcv: s64;
        __ru_msgrcv_word: __syscall_slong_t;
    }
    union {
        ru_nsignals: s64;
        __ru_nsignals_word: __syscall_slong_t;
    }
    union {
        ru_nvcsw: s64;
        __ru_nvcsw_word: __syscall_slong_t;
    }
    union {
        ru_nivcsw: s64;
        __ru_nivcsw_word: __syscall_slong_t;
    }
}

__priority_which :: enum u32 {
    PROCESS :: 0;
    PGRP :: 1;
    USER :: 2;
    PRIO_PROCESS :: PROCESS;
    PRIO_PGRP :: PGRP;
    PRIO_USER :: USER;
}

id_t :: __id_t;
__rlimit_resource_t :: s32;
__rusage_who_t :: s32;
__priority_which_t :: s32;
getrlimit :: (__resource: __rlimit_resource_t, __rlimits: *rlimit) -> s32 #foreign libc;
setrlimit :: (__resource: __rlimit_resource_t, __rlimits: *rlimit) -> s32 #foreign libc;
getrusage :: (__who: __rusage_who_t, __usage: *rusage) -> s32 #foreign libc;
getpriority :: (__which: __priority_which_t, __who: id_t) -> s32 #foreign libc;
setpriority :: (__which: __priority_which_t, __who: id_t, __prio: s32) -> s32 #foreign libc;
#scope_file
libc :: #system_library "libc";
