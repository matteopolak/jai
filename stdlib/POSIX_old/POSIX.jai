// Portable POSIX types and helpers for POSIX_old.
GNU_ENV :: true;
OS_Error_Code :: #type,isa s32;
size_t :: u64;
ssize_t :: s64;
off_t :: s64;
ino_t :: u64;
uid_t :: u32;
gid_t :: u32;
blkcnt_t :: s64;
time_t :: s64;
key_t :: s32;
pid_t :: s32;
suseconds_t :: s32;

#if OS == .LINUX {
    dev_t :: u64;
    mode_t :: u32;
    nlink_t :: u64;
    blksize_t :: s64;
    clock_t :: s64;
} else #if OS == .MACOS {
    dev_t :: s32;
    mode_t :: u16;
    nlink_t :: u16;
    blksize_t :: s32;
    clock_t :: u64;
    quad_t :: u64;
    caddr_t :: *s8;
    fixpt_t :: u32;
}

POLLIN :: 0x0001;
POLLPRI :: 0x0002;
POLLOUT :: 0x0004;
POLLERR :: 0x0008;
POLLHUP :: 0x0010;
POLLNVAL :: 0x0020;

pollfd :: struct {
    fd: s32;
    events: s16;
    revents: s16;
}

#if OS == .LINUX {
    POLLRDHUP :: 0x2000;
    nfds_t :: u64;
} else #if OS == .MACOS {
    nfds_t :: u32;
}

WNOHANG :: 1;
WUNTRACED :: 2;

#if OS == .LINUX {
    __WCOREFLAG :: 0x80;
    __W_CONTINUED :: 0xffff;
} else #if OS == .MACOS {
    #scope_file
    WCOREFLAG :: 0x512;
    WSTOPPED :: 0x7F;
    #scope_export
}

IPC_CREAT :: 0x0200;
IPC_EXCL :: 0x0400;
IPC_NOWAIT :: 0x0800;
IPC_PRIVATE: key_t : 0;
IPC_RMID :: 0;
IPC_SET :: 1;
IPC_STAT :: 2;

#if OS == .LINUX {
    IPC_INFO :: 3;
}

O_RDONLY :: 0x0;
O_WRONLY :: 0x1;
O_RDWR :: 0x2;
O_ACCMODE :: 0x3;

#if OS == .LINUX {
    O_CREAT :: 0x040;
    O_EXCL :: 0x080;
    O_NOCTTY :: 0x100;
    O_TRUNC :: 0x200;
    O_APPEND :: 0x000400;
    O_NONBLOCK :: 0x000800;
    O_DSYNC :: 0x001000;
    FASYNC :: 0x002000;
    O_DIRECT :: 0x004000;
    O_LARGEFILE :: 0x008000;
    O_DIRECTORY :: 0x010000;
    O_NOFOLLOW :: 0x020000;
    O_NOATIME :: 0x040000;
    O_CLOEXEC :: 0x080000;
    O_PATH :: 0x200000;
    O_NDELAY :: O_NONBLOCK;
    __O_SYNC :: 0x100000;
    O_SYNC :: __O_SYNC | O_DSYNC;
    __O_TMPFILE :: 0x400000;
    O_TMPFILE :: __O_TMPFILE | O_DIRECTORY;
    O_TMPFILE_MASK :: __O_TMPFILE | O_DIRECTORY | O_CREAT;
} else #if OS == .MACOS {
    O_NONBLOCK :: 0x00000004;
    O_APPEND :: 0x00000008;
    O_SHLOCK :: 0x00000010;
    O_EXLOCK :: 0x00000020;
    O_ASYNC :: 0x00000040;
    O_SYNC :: 0x00000080;
    O_NOFOLLOW :: 0x00000100;
    O_CREAT :: 0x00000200;
    O_TRUNC :: 0x00000400;
    O_EXCL :: 0x00000800;
    O_EVTONLY :: 0x00008000;
    O_NOCTTY :: 0x00020000;
    O_DIRECTORY :: 0x00100000;
    O_SYMLINK :: 0x00200000;
    O_CLOEXEC :: 0x01000000;
    O_NOFOLLOW_ANY :: 0x20000000;
}

#if OS == .LINUX {
    AT_FDCWD :: -100;
    AT_SYMLINK_NOFOLLOW :: 0x100;
    AT_EACCESS :: 0x200;
    AT_REMOVEDIR :: 0x200;
    AT_SYMLINK_FOLLOW :: 0x400;
    AT_NO_AUTOMOUNT :: 0x800;
    AT_EMPTY_PATH :: 0x1000;
    AT_STATX_SYNC_TYPE :: 0x6000;
    AT_STATX_SYNC_AS_STAT :: 0x0000;
    AT_STATX_FORCE_SYNC :: 0x2000;
    AT_STATX_DONT_SYNC :: 0x4000;
    AT_RECURSIVE :: 0x8000;
} else #if OS == .MACOS {
    AT_FDCWD :: -2;
    AT_EACCESS :: 0x0010;
    AT_SYMLINK_NOFOLLOW :: 0x0020;
    AT_SYMLINK_FOLLOW :: 0x0040;
    AT_REMOVEDIR :: 0x0080;
    AT_REALDEV :: 0x0200;
    AT_FDONLY :: 0x0400;
    AT_SYMLINK_NOFOLLOW_ANY :: 0x0800;
}

F_DUPFD :: 0;
F_GETFD :: 1;
F_SETFD :: 2;
F_GETFL :: 3;
F_SETFL :: 4;

#if OS == .LINUX {
    F_GETLK :: 5;
    F_SETLK :: 6;
    F_SETLKW :: 7;
    F_SETOWN :: 8;
    F_GETOWN :: 9;
    FD_CLOEXEC :: 1;
    F_RDLCK :: 0;
    F_WRLCK :: 1;
    F_UNLCK :: 2;
} else #if OS == .MACOS {
    F_GETOWN :: 5;
    F_SETOWN :: 6;
    F_GETLK :: 7;
    F_SETLK :: 8;
    F_SETLKW :: 9;
    F_SETLKWTIMEOUT :: 10;
    FD_CLOEXEC :: 1;
    F_RDLCK :: 1;
    F_UNLCK :: 2;
    F_WRLCK :: 3;
}

S_IRUSR :: 0x100;
S_IWUSR :: 0x080;
S_IXUSR :: 0x040;
S_IRGRP :: 0x20;
S_IWGRP :: 0x10;
S_IXGRP :: 0x08;
S_IROTH :: 0x4;
S_IWOTH :: 0x2;
S_IXOTH :: 0x1;
S_ISUID :: 0x800;
S_ISGID :: 0x400;
S_ISVTX :: 0x200;

#if OS == .LINUX {
    SIOCADDRT :: 0x890B;
    SIOCDELRT :: 0x890C;
    SIOCRTMSG :: 0x890D;
    SIOCGIFNAME :: 0x8910;
    SIOCSIFLINK :: 0x8911;
    SIOCGIFCONF :: 0x8912;
    SIOCGIFFLAGS :: 0x8913;
    SIOCSIFFLAGS :: 0x8914;
    SIOCGIFADDR :: 0x8915;
    SIOCSIFADDR :: 0x8916;
    SIOCGIFDSTADDR :: 0x8917;
    SIOCSIFDSTADDR :: 0x8918;
    SIOCGIFBRDADDR :: 0x8919;
    SIOCSIFBRDADDR :: 0x891a;
    SIOCGIFNETMASK :: 0x891b;
    SIOCSIFNETMASK :: 0x891c;
    SIOCGIFMETRIC :: 0x891d;
    SIOCSIFMETRIC :: 0x891e;
    SIOCGIFMEM :: 0x891f;
    SIOCSIFMEM :: 0x8920;
    SIOCGIFMTU :: 0x8921;
    SIOCSIFMTU :: 0x8922;
    SIOCSIFNAME :: 0x8923;
    SIOCSIFHWADDR :: 0x8924;
    SIOCGIFENCAP :: 0x8925;
    SIOCSIFENCAP :: 0x8926;
    SIOCGIFHWADDR :: 0x8927;
    SIOCGIFSLAVE :: 0x8929;
    SIOCSIFSLAVE :: 0x8930;
    SIOCADDMULTI :: 0x8931;
    SIOCDELMULTI :: 0x8932;
    SIOCGIFINDEX :: 0x8933;
    SIOCSIFPFLAGS :: 0x8934;
    SIOCGIFPFLAGS :: 0x8935;
    SIOCDIFADDR :: 0x8936;
    SIOCSIFHWBROADCAST :: 0x8937;
    SIOCGIFCOUNT :: 0x8938;
    SIOCGIFBR :: 0x8940;
    SIOCSIFBR :: 0x8941;
    SIOCGIFTXQLEN :: 0x8942;
    SIOCSIFTXQLEN :: 0x8943;
    SIOCDARP :: 0x8953;
    SIOCGARP :: 0x8954;
    SIOCSARP :: 0x8955;
    SIOCDRARP :: 0x8960;
    SIOCGRARP :: 0x8961;
    SIOCSRARP :: 0x8962;
    SIOCGIFMAP :: 0x8970;
    SIOCSIFMAP :: 0x8971;
    SIOCADDDLCI :: 0x8980;
    SIOCDELDLCI :: 0x8981;
    SIOCDEVPRIVATE :: 0x89F0;
    SIOCPROTOPRIVATE :: 0x89E0;
} else #if OS == .MACOS {}

timespec :: struct {
    tv_sec: time_t;
    tv_nsec: s64;
}

timeval :: struct {
    tv_sec: time_t;
    tv_usec: suseconds_t;
}

itimerval :: struct {
    it_interval: timeval;
    it_value: timeval;
}

tm :: struct {
    tm_sec: s32;
    tm_min: s32;
    tm_hour: s32;
    tm_mday: s32;
    tm_mon: s32;
    tm_year: s32;
    tm_wday: s32;
    tm_yday: s32;
    tm_isdst: s32;
    tm_gmtoff: s64;
    tm_zone: *u8;
}

#if OS == .LINUX {
    using clockid_t :: enum s32 {
        CLOCK_REALTIME :: 0;
        CLOCK_MONOTONIC :: 1;
        CLOCK_PROCESS_CPUTIME_ID :: 2;
        CLOCK_THREAD_CPUTIME_ID :: 3;
        CLOCK_MONOTONIC_RAW :: 4;
        CLOCK_REALTIME_COARSE :: 5;
        CLOCK_MONOTONIC_COARSE :: 6;
    }
} else #if OS == .MACOS {
    using clockid_t :: enum s32 {
        CLOCK_REALTIME :: 0;
        CLOCK_MONOTONIC :: 6;
        CLOCK_MONOTONIC_RAW :: 4;
        CLOCK_MONOTONIC_RAW_APPROX :: 5;
        CLOCK_UPTIME_RAW :: 8;
        CLOCK_UPTIME_RAW_APPROX :: 9;
        CLOCK_PROCESS_CPUTIME_ID :: 12;
        CLOCK_THREAD_CPUTIME_ID :: 16;
    }
}

#if OS == .LINUX {
    itimerspec :: struct {
        it_interval: timespec;
        it_value: timespec;
    }
}

#if OS == .LINUX {
    FNM_PATHNAME :: 1 << 0;
    FNM_NOESCAPE :: 1 << 1;
    FNM_PERIOD :: 1 << 2;
    FNM_FILE_NAME :: FNM_PATHNAME;
    FNM_LEADING_DIR :: 1 << 3;
    FNM_CASEFOLD :: 1 << 4;
    FNM_EXTMATCH :: 1 << 5;
    FNM_NOMATCH :: 1;
    FNM_NOSYS :: -1;
} else #if OS == .MACOS {
    FNM_NOMATCH :: 1;
    FNM_NOESCAPE :: 0x01;
    FNM_PATHNAME :: 0x02;
    FNM_PERIOD :: 0x04;
    FNM_NOSYS :: -1;
    FNM_LEADING_DIR :: 0x08;
    FNM_CASEFOLD :: 0x10;
    FNM_IGNORECASE :: FNM_CASEFOLD;
    FNM_FILE_NAME :: FNM_PATHNAME;
}

#if OS == .LINUX {
    _UTSNAME_LENGTH :: 65;

    utsname :: struct {
        sysname: [_UTSNAME_LENGTH] u8;
        nodename: [_UTSNAME_LENGTH] u8;
        release: [_UTSNAME_LENGTH] u8;
        version: [_UTSNAME_LENGTH] u8;
        machine: [_UTSNAME_LENGTH] u8;
        domainname: [_UTSNAME_LENGTH] u8;
    }
} else #if OS == .MACOS {
    _SYS_NAMELEN :: 256;

    utsname :: struct {
        sysname: [_SYS_NAMELEN] u8;
        nodename: [_SYS_NAMELEN] u8;
        release: [_SYS_NAMELEN] u8;
        version: [_SYS_NAMELEN] u8;
        machine: [_SYS_NAMELEN] u8;
    }
}

FILE :: struct {}
DIR :: struct {}
SEEK_SET :: 0;
SEEK_CUR :: 1;
SEEK_END :: 2;

#if OS == .LINUX {
    dirent :: struct {
        d_ino: ino_t;
        d_off: off_t;
        d_reclen: u16;
        d_type: u8;
        d_name: [256] u8;
    }
} else #if OS == .MACOS {
    dirent :: struct {
        d_ino: u64;
        d_seekoff: u64;
        d_reclen: u16;
        d_namlen: u16;
        d_type: u8;
        d_name: [255] u8;
    }
}

DT_UNKNOWN :: 0;
DT_FIFO :: 1;
DT_CHR :: 2;
DT_DIR :: 4;
DT_BLK :: 6;
DT_REG :: 8;
DT_LNK :: 10;
DT_SOCK :: 12;
DT_WHT :: 14;
PROT_NONE :: 0x00;
PROT_READ :: 0x01;
PROT_WRITE :: 0x02;
PROT_EXEC :: 0x04;
MAP_FAILED :: cast,no_check(*void) 0xffff_ffff_ffff_ffff;
MAP_SHARED :: 0x0001;
MAP_PRIVATE :: 0x0002;
MAP_FIXED :: 0x0010;
MAP_FILE :: 0x0000;
MAP_ANON :: MAP_ANONYMOUS;

#if OS == .LINUX {
    MAP_ANONYMOUS :: 0x0020;
    MAP_POPULATE :: 0x8000;
} else #if OS == .MACOS {
    MAP_ANONYMOUS :: 0x1000;
}

MADV_NORMAL :: 0;
MADV_RANDOM :: 1;
MADV_SEQUENTIAL :: 2;
MADV_WILLNEED :: 3;
MADV_DONTNEED :: 4;

#if OS == .LINUX {
    MADV_SPACEAVAIL :: 5;
    MADV_REMOVE :: 9;
    MADV_DONTFORK :: 10;
    MADV_DOFORK :: 11;
    MADV_MERGEABLE :: 12;
    MADV_UNMERGEABLE :: 13;
    MADV_HUGEPAGE :: 14;
    MADV_NOHUGEPAGE :: 15;
    MADV_DODUMP :: 17;
}

STDIN_FILENO :: 0;
STDOUT_FILENO :: 1;
STDERR_FILENO :: 2;

#if OS == .LINUX {
    using _SC_definitions :: enum s32 {
        _SC_ARG_MAX;
        _SC_CHILD_MAX;
        _SC_CLK_TCK;
        _SC_NGROUPS_MAX;
        _SC_OPEN_MAX;
        _SC_STREAM_MAX;
        _SC_TZNAME_MAX;
        _SC_JOB_CONTROL;
        _SC_SAVED_IDS;
        _SC_REALTIME_SIGNALS;
        _SC_PRIORITY_SCHEDULING;
        _SC_TIMERS;
        _SC_ASYNCHRONOUS_IO;
        _SC_PRIORITIZED_IO;
        _SC_SYNCHRONIZED_IO;
        _SC_FSYNC;
        _SC_MAPPED_FILES;
        _SC_MEMLOCK;
        _SC_MEMLOCK_RANGE;
        _SC_MEMORY_PROTECTION;
        _SC_MESSAGE_PASSING;
        _SC_SEMAPHORES;
        _SC_SHARED_MEMORY_OBJECTS;
        _SC_AIO_LISTIO_MAX;
        _SC_AIO_MAX;
        _SC_AIO_PRIO_DELTA_MAX;
        _SC_DELAYTIMER_MAX;
        _SC_MQ_OPEN_MAX;
        _SC_MQ_PRIO_MAX;
        _SC_VERSION;
        _SC_PAGESIZE;
        _SC_PAGE_SIZE :: _SC_PAGESIZE;
        _SC_RTSIG_MAX;
        _SC_SEM_NSEMS_MAX;
        _SC_SEM_VALUE_MAX;
        _SC_SIGQUEUE_MAX;
        _SC_TIMER_MAX;
        _SC_BC_BASE_MAX;
        _SC_BC_DIM_MAX;
        _SC_BC_SCALE_MAX;
        _SC_BC_STRING_MAX;
        _SC_COLL_WEIGHTS_MAX;
        _SC_EQUIV_CLASS_MAX;
        _SC_EXPR_NEST_MAX;
        _SC_LINE_MAX;
        _SC_RE_DUP_MAX;
        _SC_CHARCLASS_NAME_MAX;
        _SC_2_VERSION;
        _SC_2_C_BIND;
        _SC_2_C_DEV;
        _SC_2_FORT_DEV;
        _SC_2_FORT_RUN;
        _SC_2_SW_DEV;
        _SC_2_LOCALEDEF;
        _SC_PII;
        _SC_PII_XTI;
        _SC_PII_SOCKET;
        _SC_PII_INTERNET;
        _SC_PII_OSI;
        _SC_POLL;
        _SC_SELECT;
        _SC_UIO_MAXIOV;
        _SC_IOV_MAX :: _SC_UIO_MAXIOV;
        _SC_PII_INTERNET_STREAM;
        _SC_PII_INTERNET_DGRAM;
        _SC_PII_OSI_COTS;
        _SC_PII_OSI_CLTS;
        _SC_PII_OSI_M;
        _SC_T_IOV_MAX;
        _SC_THREADS;
        _SC_THREAD_SAFE_FUNCTIONS;
        _SC_GETGR_R_SIZE_MAX;
        _SC_GETPW_R_SIZE_MAX;
        _SC_LOGIN_NAME_MAX;
        _SC_TTY_NAME_MAX;
        _SC_THREAD_DESTRUCTOR_ITERATIONS;
        _SC_THREAD_KEYS_MAX;
        _SC_THREAD_STACK_MIN;
        _SC_THREAD_THREADS_MAX;
        _SC_THREAD_ATTR_STACKADDR;
        _SC_THREAD_ATTR_STACKSIZE;
        _SC_THREAD_PRIORITY_SCHEDULING;
        _SC_THREAD_PRIO_INHERIT;
        _SC_THREAD_PRIO_PROTECT;
        _SC_THREAD_PROCESS_SHARED;
        _SC_NPROCESSORS_CONF;
        _SC_NPROCESSORS_ONLN;
        _SC_PHYS_PAGES;
        _SC_AVPHYS_PAGES;
        _SC_ATEXIT_MAX;
        _SC_PASS_MAX;
        _SC_XOPEN_VERSION;
        _SC_XOPEN_XCU_VERSION;
        _SC_XOPEN_UNIX;
        _SC_XOPEN_CRYPT;
        _SC_XOPEN_ENH_I18N;
        _SC_XOPEN_SHM;
        _SC_2_CHAR_TERM;
        _SC_2_C_VERSION;
        _SC_2_UPE;
        _SC_XOPEN_XPG2;
        _SC_XOPEN_XPG3;
        _SC_XOPEN_XPG4;
        _SC_CHAR_BIT;
        _SC_CHAR_MAX;
        _SC_CHAR_MIN;
        _SC_INT_MAX;
        _SC_INT_MIN;
        _SC_LONG_BIT;
        _SC_WORD_BIT;
        _SC_MB_LEN_MAX;
        _SC_NZERO;
        _SC_SSIZE_MAX;
        _SC_SCHAR_MAX;
        _SC_SCHAR_MIN;
        _SC_SHRT_MAX;
        _SC_SHRT_MIN;
        _SC_UCHAR_MAX;
        _SC_UINT_MAX;
        _SC_ULONG_MAX;
        _SC_USHRT_MAX;
        _SC_NL_ARGMAX;
        _SC_NL_LANGMAX;
        _SC_NL_MSGMAX;
        _SC_NL_NMAX;
        _SC_NL_SETMAX;
        _SC_NL_TEXTMAX;
        _SC_XBS5_ILP32_OFF32;
        _SC_XBS5_ILP32_OFFBIG;
        _SC_XBS5_LP64_OFF64;
        _SC_XBS5_LPBIG_OFFBIG;
        _SC_XOPEN_LEGACY;
        _SC_XOPEN_REALTIME;
        _SC_XOPEN_REALTIME_THREADS;
        _SC_ADVISORY_INFO;
        _SC_BARRIERS;
        _SC_BASE;
        _SC_C_LANG_SUPPORT;
        _SC_C_LANG_SUPPORT_R;
        _SC_CLOCK_SELECTION;
        _SC_CPUTIME;
        _SC_THREAD_CPUTIME;
        _SC_DEVICE_IO;
        _SC_DEVICE_SPECIFIC;
        _SC_DEVICE_SPECIFIC_R;
        _SC_FD_MGMT;
        _SC_FIFO;
        _SC_PIPE;
        _SC_FILE_ATTRIBUTES;
        _SC_FILE_LOCKING;
        _SC_FILE_SYSTEM;
        _SC_MONOTONIC_CLOCK;
        _SC_MULTI_PROCESS;
        _SC_SINGLE_PROCESS;
        _SC_NETWORKING;
        _SC_READER_WRITER_LOCKS;
        _SC_SPIN_LOCKS;
        _SC_REGEXP;
        _SC_REGEX_VERSION;
        _SC_SHELL;
        _SC_SIGNALS;
        _SC_SPAWN;
        _SC_SPORADIC_SERVER;
        _SC_THREAD_SPORADIC_SERVER;
        _SC_SYSTEM_DATABASE;
        _SC_SYSTEM_DATABASE_R;
        _SC_TIMEOUTS;
        _SC_TYPED_MEMORY_OBJECTS;
        _SC_USER_GROUPS;
        _SC_USER_GROUPS_R;
        _SC_2_PBS;
        _SC_2_PBS_ACCOUNTING;
        _SC_2_PBS_LOCATE;
        _SC_2_PBS_MESSAGE;
        _SC_2_PBS_TRACK;
        _SC_SYMLOOP_MAX;
        _SC_STREAMS;
        _SC_2_PBS_CHECKPOINT;
        _SC_V6_ILP32_OFF32;
        _SC_V6_ILP32_OFFBIG;
        _SC_V6_LP64_OFF64;
        _SC_V6_LPBIG_OFFBIG;
        _SC_HOST_NAME_MAX;
        _SC_TRACE;
        _SC_TRACE_EVENT_FILTER;
        _SC_TRACE_INHERIT;
        _SC_TRACE_LOG;
        _SC_LEVEL1_ICACHE_SIZE;
        _SC_LEVEL1_ICACHE_ASSOC;
        _SC_LEVEL1_ICACHE_LINESIZE;
        _SC_LEVEL1_DCACHE_SIZE;
        _SC_LEVEL1_DCACHE_ASSOC;
        _SC_LEVEL1_DCACHE_LINESIZE;
        _SC_LEVEL2_CACHE_SIZE;
        _SC_LEVEL2_CACHE_ASSOC;
        _SC_LEVEL2_CACHE_LINESIZE;
        _SC_LEVEL3_CACHE_SIZE;
        _SC_LEVEL3_CACHE_ASSOC;
        _SC_LEVEL3_CACHE_LINESIZE;
        _SC_LEVEL4_CACHE_SIZE;
        _SC_LEVEL4_CACHE_ASSOC;
        _SC_LEVEL4_CACHE_LINESIZE;
        _SC_IPV6 :: _SC_LEVEL1_ICACHE_SIZE + cast(_SC_definitions) 50;
        _SC_RAW_SOCKETS;
        _SC_V7_ILP32_OFF32;
        _SC_V7_ILP32_OFFBIG;
        _SC_V7_LP64_OFF64;
        _SC_V7_LPBIG_OFFBIG;
        _SC_SS_REPL_MAX;
        _SC_TRACE_EVENT_NAME_MAX;
        _SC_TRACE_NAME_MAX;
        _SC_TRACE_SYS_MAX;
        _SC_TRACE_USER_EVENT_MAX;
        _SC_XOPEN_STREAMS;
        _SC_THREAD_ROBUST_PRIO_INHERIT;
        _SC_THREAD_ROBUST_PRIO_PROTECT;
    }
} else #if OS == .MACOS {
    using _SC_definitions :: enum s32 {
        _SC_ARG_MAX :: 1;
        _SC_CHILD_MAX :: 2;
        _SC_CLK_TCK :: 3;
        _SC_NGROUPS_MAX :: 4;
        _SC_OPEN_MAX :: 5;
        _SC_JOB_CONTROL :: 6;
        _SC_SAVED_IDS :: 7;
        _SC_VERSION :: 8;
        _SC_BC_BASE_MAX :: 9;
        _SC_BC_DIM_MAX :: 10;
        _SC_BC_SCALE_MAX :: 11;
        _SC_BC_STRING_MAX :: 12;
        _SC_COLL_WEIGHTS_MAX :: 13;
        _SC_EXPR_NEST_MAX :: 14;
        _SC_LINE_MAX :: 15;
        _SC_RE_DUP_MAX :: 16;
        _SC_2_VERSION :: 17;
        _SC_2_C_BIND :: 18;
        _SC_2_C_DEV :: 19;
        _SC_2_CHAR_TERM :: 20;
        _SC_2_FORT_DEV :: 21;
        _SC_2_FORT_RUN :: 22;
        _SC_2_LOCALEDEF :: 23;
        _SC_2_SW_DEV :: 24;
        _SC_2_UPE :: 25;
        _SC_STREAM_MAX :: 26;
        _SC_TZNAME_MAX :: 27;
        _SC_ASYNCHRONOUS_IO :: 28;
        _SC_PAGESIZE :: 29;
        _SC_MEMLOCK :: 30;
        _SC_MEMLOCK_RANGE :: 31;
        _SC_MEMORY_PROTECTION :: 32;
        _SC_MESSAGE_PASSING :: 33;
        _SC_PRIORITIZED_IO :: 34;
        _SC_PRIORITY_SCHEDULING :: 35;
        _SC_REALTIME_SIGNALS :: 36;
        _SC_SEMAPHORES :: 37;
        _SC_FSYNC :: 38;
        _SC_SHARED_MEMORY_OBJECTS :: 39;
        _SC_SYNCHRONIZED_IO :: 40;
        _SC_TIMERS :: 41;
        _SC_AIO_LISTIO_MAX :: 42;
        _SC_AIO_MAX :: 43;
        _SC_AIO_PRIO_DELTA_MAX :: 44;
        _SC_DELAYTIMER_MAX :: 45;
        _SC_MQ_OPEN_MAX :: 46;
        _SC_MAPPED_FILES :: 47;
        _SC_RTSIG_MAX :: 48;
        _SC_SEM_NSEMS_MAX :: 49;
        _SC_SEM_VALUE_MAX :: 50;
        _SC_SIGQUEUE_MAX :: 51;
        _SC_TIMER_MAX :: 52;
        _SC_GETPW_R_SIZE_MAX :: 71;
    }
}

#if OS == .LINUX {
    EPERM :: 1;
    ENOENT :: 2;
    ESRCH :: 3;
    EINTR :: 4;
    EIO :: 5;
    ENXIO :: 6;
    E2BIG :: 7;
    ENOEXEC :: 8;
    EBADF :: 9;
    ECHILD :: 10;
    EAGAIN :: 11;
    EWOULDBLOCK :: 11;
    ENOMEM :: 12;
    EACCES :: 13;
    EFAULT :: 14;
    ENOTBLK :: 15;
    EBUSY :: 16;
    EEXIST :: 17;
    EXDEV :: 18;
    ENODEV :: 19;
    ENOTDIR :: 20;
    EISDIR :: 21;
    EINVAL :: 22;
    ENFILE :: 23;
    EMFILE :: 24;
    ENOTTY :: 25;
    ETXTBSY :: 26;
    EFBIG :: 27;
    ENOSPC :: 28;
    ESPIPE :: 29;
    EROFS :: 30;
    EMLINK :: 31;
    EPIPE :: 32;
    EDOM :: 33;
    ERANGE :: 34;
    EDEADLK :: 35;
    EDEADLOCK :: 35;
    ENAMETOOLONG :: 36;
    ENOLCK :: 37;
    ENOSYS :: 38;
    ENOTEMPTY :: 39;
    ELOOP :: 40;
    ENOMSG :: 42;
    EIDRM :: 43;
    ECHRNG :: 44;
    EL2NSYNC :: 45;
    EL3HLT :: 46;
    EL3RST :: 47;
    ELNRNG :: 48;
    EUNATCH :: 49;
    ENOCSI :: 50;
    EL2HLT :: 51;
    EBADE :: 52;
    EBADR :: 53;
    EXFULL :: 54;
    ENOANO :: 55;
    EBADRQC :: 56;
    EBADSLT :: 57;
    EBFONT :: 59;
    ENOSTR :: 60;
    ENODATA :: 61;
    ETIME :: 62;
    ENOSR :: 63;
    ENONET :: 64;
    ENOPKG :: 65;
    EREMOTE :: 66;
    ENOLINK :: 67;
    EADV :: 68;
    ESRMNT :: 69;
    ECOMM :: 70;
    EPROTO :: 71;
    EMULTIHOP :: 72;
    EDOTDOT :: 73;
    EBADMSG :: 74;
    EOVERFLOW :: 75;
    ENOTUNIQ :: 76;
    EBADFD :: 77;
    EREMCHG :: 78;
    ELIBACC :: 79;
    ELIBBAD :: 80;
    ELIBSCN :: 81;
    ELIBMAX :: 82;
    ELIBEXEC :: 83;
    EILSEQ :: 84;
    ERESTART :: 85;
    ESTRPIPE :: 86;
    EUSERS :: 87;
    ENOTSOCK :: 88;
    EDESTADDRREQ :: 89;
    EMSGSIZE :: 90;
    EPROTOTYPE :: 91;
    ENOPROTOOPT :: 92;
    EPROTONOSUPPORT :: 93;
    ESOCKTNOSUPPORT :: 94;
    EOPNOTSUPP :: 95;
    ENOTSUP :: 95;
    EPFNOSUPPORT :: 96;
    EAFNOSUPPORT :: 97;
    EADDRINUSE :: 98;
    EADDRNOTAVAIL :: 99;
    ENETDOWN :: 100;
    ENETUNREACH :: 101;
    ENETRESET :: 102;
    ECONNABORTED :: 103;
    ECONNRESET :: 104;
    ENOBUFS :: 105;
    EISCONN :: 106;
    ENOTCONN :: 107;
    ESHUTDOWN :: 108;
    ETOOMANYREFS :: 109;
    ETIMEDOUT :: 110;
    ECONNREFUSED :: 111;
    EHOSTDOWN :: 112;
    EHOSTUNREACH :: 113;
    EALREADY :: 114;
    EINPROGRESS :: 115;
    ESTALE :: 116;
    EUCLEAN :: 117;
    ENOTNAM :: 118;
    ENAVAIL :: 119;
    EISNAM :: 120;
    EREMOTEIO :: 121;
    EDQUOT :: 122;
    ENOMEDIUM :: 123;
    EMEDIUMTYPE :: 124;
    ECANCELED :: 125;
    ENOKEY :: 126;
    EKEYEXPIRED :: 127;
    EKEYREVOKED :: 128;
    EKEYREJECTED :: 129;
    EOWNERDEAD :: 130;
    ENOTRECOVERABLE :: 131;
    ERFKILL :: 132;
    EHWPOISON :: 133;
} else #if OS == .MACOS {
    EPERM :: 1;
    ENOENT :: 2;
    ESRCH :: 3;
    EINTR :: 4;
    EIO :: 5;
    ENXIO :: 6;
    E2BIG :: 7;
    ENOEXEC :: 8;
    EBADF :: 9;
    ECHILD :: 10;
    EDEADLK :: 11;
    ENOMEM :: 12;
    EACCES :: 13;
    EFAULT :: 14;
    ENOTBLK :: 15;
    EBUSY :: 16;
    EEXIST :: 17;
    EXDEV :: 18;
    ENODEV :: 19;
    ENOTDIR :: 20;
    EISDIR :: 21;
    EINVAL :: 22;
    ENFILE :: 23;
    EMFILE :: 24;
    ENOTTY :: 25;
    ETXTBSY :: 26;
    EFBIG :: 27;
    ENOSPC :: 28;
    ESPIPE :: 29;
    EROFS :: 30;
    EMLINK :: 31;
    EPIPE :: 32;
    EDOM :: 33;
    ERANGE :: 34;
    EAGAIN :: 35;
    EWOULDBLOCK :: 35;
    EINPROGRESS :: 36;
    EALREADY :: 37;
    ENOTSOCK :: 38;
    EDESTADDRREQ :: 39;
    EMSGSIZE :: 40;
    EPROTOTYPE :: 41;
    ENOPROTOOPT :: 42;
    EPROTONOSUPPORT :: 43;
    ESOCKTNOSUPPORT :: 44;
    ENOTSUP :: 45;
    EPFNOSUPPORT :: 46;
    EAFNOSUPPORT :: 47;
    EADDRINUSE :: 48;
    EADDRNOTAVAIL :: 49;
    ENETDOWN :: 50;
    ENETUNREACH :: 51;
    ENETRESET :: 52;
    ECONNABORTED :: 53;
    ECONNRESET :: 54;
    ENOBUFS :: 55;
    EISCONN :: 56;
    ENOTCONN :: 57;
    ESHUTDOWN :: 58;
    ETOOMANYREFS :: 59;
    ETIMEDOUT :: 60;
    ECONNREFUSED :: 61;
    ELOOP :: 62;
    ENAMETOOLONG :: 63;
    EHOSTDOWN :: 64;
    EHOSTUNREACH :: 65;
    ENOTEMPTY :: 66;
    EPROCLIM :: 67;
    EUSERS :: 68;
    EDQUOT :: 69;
    ESTALE :: 70;
    EREMOTE :: 71;
    EBADRPC :: 72;
    ERPCMISMATCH :: 73;
    EPROGUNAVAIL :: 74;
    EPROGMISMATCH :: 75;
    EPROCUNAVAIL :: 76;
    ENOLCK :: 77;
    ENOSYS :: 78;
    EFTYPE :: 79;
    EAUTH :: 80;
    ENEEDAUTH :: 81;
    EPWROFF :: 82;
    EDEVERR :: 83;
    EOVERFLOW :: 84;
    EBADEXEC :: 85;
    EBADARCH :: 86;
    ESHLIBVERS :: 87;
    EBADMACHO :: 88;
    ECANCELED :: 89;
    EIDRM :: 90;
    ENOMSG :: 91;
    EILSEQ :: 92;
    ENOATTR :: 93;
    EBADMSG :: 94;
    EMULTIHOP :: 95;
    ENODATA :: 96;
    ENOLINK :: 97;
    ENOSR :: 98;
    ENOSTR :: 99;
    EPROTO :: 100;
    ETIME :: 101;
    EOPNOTSUPP :: 102;
    ENOPOLICY :: 103;
    ENOTRECOVERABLE :: 104;
    EOWNERDEAD :: 105;
    EQFULL :: 106;
    ELAST :: 106;
}

SIGHUP :: 1;
SIGINT :: 2;
SIGQUIT :: 3;
SIGILL :: 4;
SIGTRAP :: 5;
SIGABRT :: 6;
SIGFPE :: 8;
SIGKILL :: 9;
SIGSEGV :: 11;
SIGPIPE :: 13;
SIGALRM :: 14;
SIGTERM :: 15;
SIGTTIN :: 21;
SIGTTOU :: 22;
SIGXCPU :: 24;
SIGXFSZ :: 25;
SIGVTALRM :: 26;
SIGPROF :: 27;
SIGWINCH :: 28;

#if OS == .LINUX {
    SIGBUS :: 7;
    SIGCHLD :: 17;
    SIGCONT :: 18;
    SIGPOLL :: 29;
    SIGPWR :: 30;
    SIGSTKFLT :: 16;
    SIGSTOP :: 19;
    SIGSYS :: 31;
    SIGTSTP :: 20;
    SIGURG :: 23;
    SIGUSR1 :: 10;
    SIGUSR2 :: 12;
} else #if OS == .MACOS {
    SIGBUS :: 10;
    SIGCHLD :: 20;
    SIGCONT :: 19;
    SIGINFO :: 29;
    SIGIO :: 23;
    SIGPOLL :: 7;
    SIGSTOP :: 17;
    SIGSYS :: 12;
    SIGTSTP :: 18;
    SIGURG :: 16;
    SIGUSR1 :: 30;
    SIGUSR2 :: 31;
}

RTLD_LAZY :: 0x1;
RTLD_NOW :: 0x2;

#if OS == .LINUX {
    RTLD_LOCAL :: 0;
    RTLD_GLOBAL :: 0x0100;
    RTLD_BINDING_MASK :: 0x0003;
    RTLD_NOLOAD :: 0x0004;
    RTLD_DEEPBIND :: 0x0008;
    RTLD_NODELETE :: 0x1000;
} else #if OS == .MACOS {
    RTLD_LOCAL :: 0x004;
    RTLD_GLOBAL :: 0x008;
    RTLD_NOLOAD :: 0x010;
    RTLD_NODELETE :: 0x080;
    RTLD_FIRST :: 0x100;
}

#if OS == .LINUX {
    passwd :: struct {
        pw_name: *u8;
        pw_passwd: *u8;
        pw_uid: uid_t;
        pw_gid: gid_t;
        pw_gecos: *u8;
        pw_dir: *u8;
        pw_shell: *u8;
    }
} else #if OS == .MACOS {
    passwd :: struct {
        pw_name: *u8;
        pw_passwd: *u8;
        pw_uid: uid_t;
        pw_gid: gid_t;
        pw_change: time_t;
        pw_class: *u8;
        pw_gecos: *u8;
        pw_dir: *u8;
        pw_shell: *u8;
        pw_expire: time_t;
    }
}

#if OS == .LINUX {
    sem_t :: struct {
        dummy: [32] u8;
        __align: s64;
    }
} else #if OS == .MACOS {
    sem_t :: s32;
}

#if OS == .LINUX {
    _SIGSET_NWORDS :: (1024 / (8 * size_of(u64)));

    sigset_t :: struct {
        __val: [_SIGSET_NWORDS] u64;
    }

    stack_t :: struct {
        ss_sp: *void;
        ss_flags: s32;
        ss_size: size_t;
    }
} else #if OS == .MACOS {
    sigset_t :: u32;

    stack_t :: struct {
        ss_sp: *void;
        ss_size: u64;
        ss_flags: s32;
    }
}

sigval_t :: union {
    sival_int: s32;
    sival_ptr: *void;
}

#if OS == .LINUX {
    sigevent_t :: struct {
        sigev_value: sigval_t;
        sigev_signo: s32;
        sigev_notify: s32;
        union {
            _pad: [12] s32;
            sigev_notify_thread_id: pid_t;
            struct {
                sigev_notify_function: (sigval_t) #c_call;
                sigev_notify_attributes: *pthread_attr_t;
            }
        }
    }

    sigevent :: sigevent_t;
    #scope_file
    __SI_MAX_SIZE :: 128;
    __SI_PAD_SIZE :: ((__SI_MAX_SIZE / size_of(s32)) - 4);
    __SI_BAND_TYPE :: s64;

    #scope_export
    siginfo_t :: struct {
        si_signo: s32;
        si_errno: s32;
        si_code: s32;
        __pad0: s32;
        union {
            _pad: [__SI_PAD_SIZE] s32;
            _kill: struct {
                si_pid: pid_t;
                si_uid: uid_t;
            };
            _timer: struct {
                si_tid: s32;
                si_overrun: s32;
                si_sigval: sigval_t;
            };
            _rt: struct {
                si_pid: pid_t;
                si_uid: uid_t;
                si_sigval: sigval_t;
            };
            _sigchld: struct {
                si_pid: pid_t;
                si_uid: uid_t;
                si_status: s32;
                si_utime: clock_t;
                si_stime: clock_t;
            };
            using _sigfault: struct {
                si_addr: *void;
                si_addr_lsb: s16;
                _bounds: union {
                    _addr_bnd: struct {
                        _lower: *void;
                        _upper: *void;
                    };
                    _pkey: u32;
                };
            };
            _sigpoll: struct {
                si_band: s64;
                si_fd: s32;
            };
            _sigsys: struct {
                _call_addr: *void;
                _syscall: s32;
                _arch: u32;
            };
        };
    }
} else #if OS == .MACOS {
    sigevent_t :: struct {
        sigev_notify: s32;
        sigev_signo: s32;
        sigev_value: sigval_t;
        sigev_notify_function: (sigval_t) #c_call;
        sigev_notify_attributes: *pthread_attr_t;
    }

    siginfo_t :: struct {
        si_signo: s32;
        si_errno: s32;
        si_code: s32;
        si_pid: pid_t;
        si_uid: uid_t;
        si_status: s32;
        si_addr: *void;
        si_value: sigval_t;
        si_band: s64;
        __pad: [7] u64;
    }
}

sigaction_t :: struct {
    union {
        sa_handler: (sig: s32) #c_call;
        sa_sigaction: (sig: s32, info: *siginfo_t, p: *void) #c_call;
    }
    sa_mask: sigset_t;
    sa_flags: s32;
    #if OS == .LINUX then sa_restorer: () #c_call;
}

#if OS == .LINUX {
    SA_NOCLDSTOP :: 1;
    SA_NOCLDWAIT :: 2;
    SA_SIGINFO :: 4;
    SA_ONSTACK :: 0x08000000;
    SA_RESTART :: 0x10000000;
    SA_NODEFER :: 0x40000000;
    SA_RESETHAND :: 0x80000000;
    SA_INTERRUPT :: 0x20000000;
    SA_NOMASK :: SA_NODEFER;
    SA_ONESHOT :: SA_RESETHAND;
    SA_STACK :: SA_ONSTACK;
    SIG_BLOCK :: 0;
    SIG_UNBLOCK :: 1;
    SIG_SETMASK :: 2;
} else #if OS == .MACOS {
    SA_NOCLDSTOP :: 0x0008;
    SA_NOCLDWAIT :: 0x0020;
    SA_SIGINFO :: 0x0040;
    SA_ONSTACK :: 0x0001;
    SA_RESTART :: 0x0002;
    SA_NODEFER :: 0x0010;
    SA_RESETHAND :: 0x0004;
    SIG_BLOCK :: 1;
    SIG_UNBLOCK :: 2;
    SIG_SETMASK :: 3;
}

SIG_DFL :: cast(*void) 0;
SIG_IGN :: cast(*void) 1;

#if OS == .LINUX {
    aiocb_t :: struct {
        aio_fildes: s32;
        aio_lio_opcode: s32;
        aio_reqprio: s32;
        aio_buf: *void;
        aio_nbytes: size_t;
        aio_sigevent: sigevent_t;
        __next_prio: *aiocb_t;
        __abs_prio: s32;
        __policy: s32;
        __error_code: s32;
        __return_value: ssize_t;
        aio_offset: off_t;
        __glibc_reserved: [32] u8;
    }

    AIO_CANCELED :: 0;
    AIO_NOTCANCELED :: 1;
    AIO_ALLDONE :: 2;
    LIO_READ :: 0;
    LIO_WRITE :: 1;
    LIO_NOP :: 2;
    LIO_WAIT :: 0;
    LIO_NOWAIT :: 1;
    AIO_LISTIO_MAX :: 256;
} else #if OS == .MACOS {
    aiocb_t :: struct {
        aio_fildes: s32;
        aio_offset: off_t;
        aio_buf: *void;
        aio_nbytes: size_t;
        aio_reqprio: s32;
        aio_sigevent: sigevent_t;
        aio_lio_opcode: s32;
    }

    AIO_ALLDONE :: 0x1;
    AIO_CANCELED :: 0x2;
    AIO_NOTCANCELED :: 0x4;
    LIO_NOP :: 0x0;
    LIO_READ :: 0x1;
    LIO_WRITE :: 0x2;
    LIO_NOWAIT :: 0x1;
    LIO_WAIT :: 0x2;
    AIO_LISTIO_MAX :: 16;
}

#if OS == .LINUX {
    greg_t :: s64;
    __NGREG :: 23;
    gregset_t :: #type [__NGREG] greg_t;

    gregset_registers :: enum {
        REG_R8 :: 0;
        REG_R9;
        REG_R10;
        REG_R11;
        REG_R12;
        REG_R13;
        REG_R14;
        REG_R15;
        REG_RDI;
        REG_RSI;
        REG_RBP;
        REG_RBX;
        REG_RDX;
        REG_RAX;
        REG_RCX;
        REG_RSP;
        REG_RIP;
        REG_EFL;
        REG_CSGSFS;
        REG_ERR;
        REG_TRAPNO;
        REG_OLDMASK;
        REG_CR2;
    }

    _libc_fpxreg :: struct {
        significand: [4] u16;
        exponent: u16;
        __glibc_reserved1: [3] u16;
    }

    _libc_xmmreg :: struct {
        element: [4] u32;
    }

    _libc_fpstate :: struct {
        cwd: u16;
        swd: u16;
        ftw: u16;
        fop: u16;
        rip: u64;
        rdp: u64;
        mxcsr: u32;
        mxcr_mask: u32;
        _st: [8] _libc_fpxreg;
        _xmm: [16] _libc_xmmreg;
        __glibc_reserved1: [24] u32;
    }

    fpregset_t :: *_libc_fpstate;

    mcontext_t :: struct {
        gregs: gregset_t;
        fpregs: fpregset_t;
        __reserved1: [8] u64;
    }

    ucontext_t :: struct {
        uc_flags: u64;
        uc_link: *ucontext_t;
        uc_stack: stack_t;
        uc_mcontext: mcontext_t;
        uc_sigmask: sigset_t;
        __fpregs_mem: _libc_fpstate;
    }
} else #if OS == .MACOS {
    greg_t :: u64;

    mcontext_t :: struct {
        __es: x64_exception_state64_t;
        __ss: x64_thread_state64_t;
        __fs: x64_float_state64_t;
    }

    ucontext_t :: struct {
        uc_onstack: s32;
        uc_sigmask: sigset_t;
        uc_stack: stack_t;
        uc_link: *ucontext_t;
        uc_mcsize: u64;
        uc_mcontext: *mcontext_t;
    }
}

#if OS == .LINUX {
    stat_t :: struct {
        st_dev: dev_t;
        st_ino: ino_t;
        st_nlink: nlink_t;
        st_mode: mode_t;
        st_uid: uid_t;
        st_gid: gid_t;
        pad0: s32;
        st_rdev: dev_t;
        st_size: off_t;
        st_blksize: blksize_t;
        st_blocks: blkcnt_t;
        st_atime: timespec;
        st_mtime: timespec;
        st_ctime: timespec;
        __glibc_reserved: [3] s64;
    }
} else #if OS == .MACOS {
    stat_t :: struct {
        st_dev: dev_t;
        st_mode: mode_t;
        st_nlink: nlink_t;
        st_ino: ino_t;
        st_uid: uid_t;
        st_gid: gid_t;
        st_rdev: dev_t;
        st_atime: timespec;
        st_mtime: timespec;
        st_ctime: timespec;
        st_birthtime: timespec;
        st_size: off_t;
        st_blocks: blkcnt_t;
        st_blksize: blksize_t;
        st_flags: u32;
        st_gen: u32;
        st_lspare: s32;
        st_qspare: [2] s64;
    }
}

S_IFMT :: 0xF000;
S_IFDIR :: 0x4000;
S_IFCHR :: 0x2000;
S_IFBLK :: 0x6000;
S_IFREG :: 0x8000;
S_IFIFO :: 0x1000;
S_IFLNK :: 0xA000;
S_IFSOCK :: 0xC000;

#scope_export
#if OS == .MACOS {
    SYS_invalid :: 63;
    SYS_syscall :: 0;
    SYS_exit :: 1;
    SYS_fork :: 2;
    SYS_read :: 3;
    SYS_write :: 4;
    SYS_open :: 5;
    SYS_close :: 6;
    SYS_wait4 :: 7;
    SYS_link :: 9;
    SYS_unlink :: 10;
    SYS_chdir :: 12;
    SYS_fchdir :: 13;
    SYS_mknod :: 14;
    SYS_chmod :: 15;
    SYS_chown :: 16;
    SYS_getfsstat :: 18;
    SYS_getpid :: 20;
    SYS_setuid :: 23;
    SYS_getuid :: 24;
    SYS_geteuid :: 25;
    SYS_ptrace :: 26;
    SYS_recvmsg :: 27;
    SYS_sendmsg :: 28;
    SYS_recvfrom :: 29;
    SYS_accept :: 30;
    SYS_getpeername :: 31;
    SYS_getsockname :: 32;
    SYS_access :: 33;
    SYS_chflags :: 34;
    SYS_fchflags :: 35;
    SYS_sync :: 36;
    SYS_kill :: 37;
    SYS_getppid :: 39;
    SYS_dup :: 41;
    SYS_pipe :: 42;
    SYS_getegid :: 43;
    SYS_sigaction :: 46;
    SYS_getgid :: 47;
    SYS_sigprocmask :: 48;
    SYS_getlogin :: 49;
    SYS_setlogin :: 50;
    SYS_acct :: 51;
    SYS_sigpending :: 52;
    SYS_sigaltstack :: 53;
    SYS_ioctl :: 54;
    SYS_reboot :: 55;
    SYS_revoke :: 56;
    SYS_symlink :: 57;
    SYS_readlink :: 58;
    SYS_execve :: 59;
    SYS_umask :: 60;
    SYS_chroot :: 61;
    SYS_msync :: 65;
    SYS_vfork :: 66;
    SYS_munmap :: 73;
    SYS_mprotect :: 74;
    SYS_madvise :: 75;
    SYS_mincore :: 78;
    SYS_getgroups :: 79;
    SYS_setgroups :: 80;
    SYS_getpgrp :: 81;
    SYS_setpgid :: 82;
    SYS_setitimer :: 83;
    SYS_swapon :: 85;
    SYS_getitimer :: 86;
    SYS_getdtablesize :: 89;
    SYS_dup2 :: 90;
    SYS_fcntl :: 92;
    SYS_select :: 93;
    SYS_fsync :: 95;
    SYS_setpriority :: 96;
    SYS_socket :: 97;
    SYS_connect :: 98;
    SYS_getpriority :: 100;
    SYS_bind :: 104;
    SYS_setsockopt :: 105;
    SYS_listen :: 106;
    SYS_sigsuspend :: 111;
    SYS_gettimeofday :: 116;
    SYS_getrusage :: 117;
    SYS_getsockopt :: 118;
    SYS_readv :: 120;
    SYS_writev :: 121;
    SYS_settimeofday :: 122;
    SYS_fchown :: 123;
    SYS_fchmod :: 124;
    SYS_setreuid :: 126;
    SYS_setregid :: 127;
    SYS_rename :: 128;
    SYS_flock :: 131;
    SYS_mkfifo :: 132;
    SYS_sendto :: 133;
    SYS_shutdown :: 134;
    SYS_socketpair :: 135;
    SYS_mkdir :: 136;
    SYS_rmdir :: 137;
    SYS_utimes :: 138;
    SYS_futimes :: 139;
    SYS_adjtime :: 140;
    SYS_gethostuuid :: 142;
    SYS_setsid :: 147;
    SYS_getpgid :: 151;
    SYS_setprivexec :: 152;
    SYS_pread :: 153;
    SYS_pwrite :: 154;
    SYS_nfssvc :: 155;
    SYS_statfs :: 157;
    SYS_fstatfs :: 158;
    SYS_unmount :: 159;
    SYS_getfh :: 161;
    SYS_quotactl :: 165;
    SYS_mount :: 167;
    SYS_csops :: 169;
    SYS_csops_audittoken :: 170;
    SYS_waitid :: 173;
    SYS_kdebug_typefilter :: 177;
    SYS_kdebug_trace_string :: 178;
    SYS_kdebug_trace64 :: 179;
    SYS_kdebug_trace :: 180;
    SYS_setgid :: 181;
    SYS_setegid :: 182;
    SYS_seteuid :: 183;
    SYS_sigreturn :: 184;
    SYS_thread_selfcounts :: 186;
    SYS_fdatasync :: 187;
    SYS_stat :: 188;
    SYS_fstat :: 189;
    SYS_lstat :: 190;
    SYS_pathconf :: 191;
    SYS_fpathconf :: 192;
    SYS_getrlimit :: 194;
    SYS_setrlimit :: 195;
    SYS_getdirentries :: 196;
    SYS_mmap :: 197;
    SYS_lseek :: 199;
    SYS_truncate :: 200;
    SYS_ftruncate :: 201;
    SYS_sysctl :: 202;
    SYS_mlock :: 203;
    SYS_munlock :: 204;
    SYS_undelete :: 205;
    SYS_open_dprotected_np :: 216;
    SYS_getattrlist :: 220;
    SYS_setattrlist :: 221;
    SYS_getdirentriesattr :: 222;
    SYS_exchangedata :: 223;
    SYS_searchfs :: 225;
    SYS_delete :: 226;
    SYS_copyfile :: 227;
    SYS_fgetattrlist :: 228;
    SYS_fsetattrlist :: 229;
    SYS_poll :: 230;
    SYS_watchevent :: 231;
    SYS_waitevent :: 232;
    SYS_modwatch :: 233;
    SYS_getxattr :: 234;
    SYS_fgetxattr :: 235;
    SYS_setxattr :: 236;
    SYS_fsetxattr :: 237;
    SYS_removexattr :: 238;
    SYS_fremovexattr :: 239;
    SYS_listxattr :: 240;
    SYS_flistxattr :: 241;
    SYS_fsctl :: 242;
    SYS_initgroups :: 243;
    SYS_posix_spawn :: 244;
    SYS_ffsctl :: 245;
    SYS_nfsclnt :: 247;
    SYS_fhopen :: 248;
    SYS_minherit :: 250;
    SYS_semsys :: 251;
    SYS_msgsys :: 252;
    SYS_shmsys :: 253;
    SYS_semctl :: 254;
    SYS_semget :: 255;
    SYS_semop :: 256;
    SYS_msgctl :: 258;
    SYS_msgget :: 259;
    SYS_msgsnd :: 260;
    SYS_msgrcv :: 261;
    SYS_shmat :: 262;
    SYS_shmctl :: 263;
    SYS_shmdt :: 264;
    SYS_shmget :: 265;
    SYS_shm_open :: 266;
    SYS_shm_unlink :: 267;
    SYS_sem_open :: 268;
    SYS_sem_close :: 269;
    SYS_sem_unlink :: 270;
    SYS_sem_wait :: 271;
    SYS_sem_trywait :: 272;
    SYS_sem_post :: 273;
    SYS_sysctlbyname :: 274;
    SYS_open_extended :: 277;
    SYS_umask_extended :: 278;
    SYS_stat_extended :: 279;
    SYS_lstat_extended :: 280;
    SYS_fstat_extended :: 281;
    SYS_chmod_extended :: 282;
    SYS_fchmod_extended :: 283;
    SYS_access_extended :: 284;
    SYS_settid :: 285;
    SYS_gettid :: 286;
    SYS_setsgroups :: 287;
    SYS_getsgroups :: 288;
    SYS_setwgroups :: 289;
    SYS_getwgroups :: 290;
    SYS_mkfifo_extended :: 291;
    SYS_mkdir_extended :: 292;
    SYS_identitysvc :: 293;
    SYS_shared_region_check_np :: 294;
    SYS_vm_pressure_monitor :: 296;
    SYS_psynch_rw_longrdlock :: 297;
    SYS_psynch_rw_yieldwrlock :: 298;
    SYS_psynch_rw_downgrade :: 299;
    SYS_psynch_rw_upgrade :: 300;
    SYS_psynch_mutexwait :: 301;
    SYS_psynch_mutexdrop :: 302;
    SYS_psynch_cvbroad :: 303;
    SYS_psynch_cvsignal :: 304;
    SYS_psynch_cvwait :: 305;
    SYS_psynch_rw_rdlock :: 306;
    SYS_psynch_rw_wrlock :: 307;
    SYS_psynch_rw_unlock :: 308;
    SYS_psynch_rw_unlock2 :: 309;
    SYS_getsid :: 310;
    SYS_settid_with_pid :: 311;
    SYS_psynch_cvclrprepost :: 312;
    SYS_aio_fsync :: 313;
    SYS_aio_return :: 314;
    SYS_aio_suspend :: 315;
    SYS_aio_cancel :: 316;
    SYS_aio_error :: 317;
    SYS_aio_read :: 318;
    SYS_aio_write :: 319;
    SYS_lio_listio :: 320;
    SYS_iopolicysys :: 322;
    SYS_process_policy :: 323;
    SYS_mlockall :: 324;
    SYS_munlockall :: 325;
    SYS_issetugid :: 327;
    SYS___pthread_kill :: 328;
    SYS___pthread_sigmask :: 329;
    SYS___sigwait :: 330;
    SYS___disable_threadsignal :: 331;
    SYS___pthread_markcancel :: 332;
    SYS___pthread_canceled :: 333;
    SYS___semwait_signal :: 334;
    SYS_proc_info :: 336;
    SYS_sendfile :: 337;
    SYS_stat64 :: 338;
    SYS_fstat64 :: 339;
    SYS_lstat64 :: 340;
    SYS_stat64_extended :: 341;
    SYS_lstat64_extended :: 342;
    SYS_fstat64_extended :: 343;
    SYS_getdirentries64 :: 344;
    SYS_statfs64 :: 345;
    SYS_fstatfs64 :: 346;
    SYS_getfsstat64 :: 347;
    SYS___pthread_chdir :: 348;
    SYS___pthread_fchdir :: 349;
    SYS_audit :: 350;
    SYS_auditon :: 351;
    SYS_getauid :: 353;
    SYS_setauid :: 354;
    SYS_getaudit_addr :: 357;
    SYS_setaudit_addr :: 358;
    SYS_auditctl :: 359;
    SYS_bsdthread_create :: 360;
    SYS_bsdthread_terminate :: 361;
    SYS_kqueue :: 362;
    SYS_kevent :: 363;
    SYS_lchown :: 364;
    SYS_bsdthread_register :: 366;
    SYS_workq_open :: 367;
    SYS_workq_kernreturn :: 368;
    SYS_kevent64 :: 369;
    SYS___old_semwait_signal :: 370;
    SYS___old_semwait_signal_nocancel :: 371;
    SYS_thread_selfid :: 372;
    SYS_ledger :: 373;
    SYS_kevent_qos :: 374;
    SYS_kevent_id :: 375;
    SYS___mac_execve :: 380;
    SYS___mac_syscall :: 381;
    SYS___mac_get_file :: 382;
    SYS___mac_set_file :: 383;
    SYS___mac_get_link :: 384;
    SYS___mac_set_link :: 385;
    SYS___mac_get_proc :: 386;
    SYS___mac_set_proc :: 387;
    SYS___mac_get_fd :: 388;
    SYS___mac_set_fd :: 389;
    SYS___mac_get_pid :: 390;
    SYS_pselect :: 394;
    SYS_pselect_nocancel :: 395;
    SYS_read_nocancel :: 396;
    SYS_write_nocancel :: 397;
    SYS_open_nocancel :: 398;
    SYS_close_nocancel :: 399;
    SYS_wait4_nocancel :: 400;
    SYS_recvmsg_nocancel :: 401;
    SYS_sendmsg_nocancel :: 402;
    SYS_recvfrom_nocancel :: 403;
    SYS_accept_nocancel :: 404;
    SYS_msync_nocancel :: 405;
    SYS_fcntl_nocancel :: 406;
    SYS_select_nocancel :: 407;
    SYS_fsync_nocancel :: 408;
    SYS_connect_nocancel :: 409;
    SYS_sigsuspend_nocancel :: 410;
    SYS_readv_nocancel :: 411;
    SYS_writev_nocancel :: 412;
    SYS_sendto_nocancel :: 413;
    SYS_pread_nocancel :: 414;
    SYS_pwrite_nocancel :: 415;
    SYS_waitid_nocancel :: 416;
    SYS_poll_nocancel :: 417;
    SYS_msgsnd_nocancel :: 418;
    SYS_msgrcv_nocancel :: 419;
    SYS_sem_wait_nocancel :: 420;
    SYS_aio_suspend_nocancel :: 421;
    SYS___sigwait_nocancel :: 422;
    SYS___semwait_signal_nocancel :: 423;
    SYS___mac_mount :: 424;
    SYS___mac_get_mount :: 425;
    SYS___mac_getfsstat :: 426;
    SYS_fsgetpath :: 427;
    SYS_audit_session_self :: 428;
    SYS_audit_session_join :: 429;
    SYS_fileport_makeport :: 430;
    SYS_fileport_makefd :: 431;
    SYS_audit_session_port :: 432;
    SYS_pid_suspend :: 433;
    SYS_pid_resume :: 434;
    SYS_pid_hibernate :: 435;
    SYS_pid_shutdown_sockets :: 436;
    SYS_shared_region_map_and_slide_np :: 438;
    SYS_kas_info :: 439;
    SYS_memorystatus_control :: 440;
    SYS_guarded_open_np :: 441;
    SYS_guarded_close_np :: 442;
    SYS_guarded_kqueue_np :: 443;
    SYS_change_fdguard_np :: 444;
    SYS_usrctl :: 445;
    SYS_proc_rlimit_control :: 446;
    SYS_connectx :: 447;
    SYS_disconnectx :: 448;
    SYS_peeloff :: 449;
    SYS_socket_delegate :: 450;
    SYS_telemetry :: 451;
    SYS_proc_uuid_policy :: 452;
    SYS_memorystatus_get_level :: 453;
    SYS_system_override :: 454;
    SYS_vfs_purge :: 455;
    SYS_sfi_ctl :: 456;
    SYS_sfi_pidctl :: 457;
    SYS_coalition :: 458;
    SYS_coalition_info :: 459;
    SYS_necp_match_policy :: 460;
    SYS_getattrlistbulk :: 461;
    SYS_clonefileat :: 462;
    SYS_openat :: 463;
    SYS_openat_nocancel :: 464;
    SYS_renameat :: 465;
    SYS_faccessat :: 466;
    SYS_fchmodat :: 467;
    SYS_fchownat :: 468;
    SYS_fstatat :: 469;
    SYS_fstatat64 :: 470;
    SYS_linkat :: 471;
    SYS_unlinkat :: 472;
    SYS_readlinkat :: 473;
    SYS_symlinkat :: 474;
    SYS_mkdirat :: 475;
    SYS_getattrlistat :: 476;
    SYS_proc_trace_log :: 477;
    SYS_bsdthread_ctl :: 478;
    SYS_openbyid_np :: 479;
    SYS_recvmsg_x :: 480;
    SYS_sendmsg_x :: 481;
    SYS_thread_selfusage :: 482;
    SYS_csrctl :: 483;
    SYS_guarded_open_dprotected_np :: 484;
    SYS_guarded_write_np :: 485;
    SYS_guarded_pwrite_np :: 486;
    SYS_guarded_writev_np :: 487;
    SYS_renameatx_np :: 488;
    SYS_mremap_encrypted :: 489;
    SYS_netagent_trigger :: 490;
    SYS_stack_snapshot_with_config :: 491;
    SYS_microstackshot :: 492;
    SYS_grab_pgo_data :: 493;
    SYS_persona :: 494;
    SYS_work_interval_ctl :: 499;
    SYS_getentropy :: 500;
    SYS_necp_open :: 501;
    SYS_necp_client_action :: 502;
    SYS___nexus_open :: 503;
    SYS___nexus_register :: 504;
    SYS___nexus_deregister :: 505;
    SYS___nexus_create :: 506;
    SYS___nexus_destroy :: 507;
    SYS___nexus_get_opt :: 508;
    SYS___nexus_set_opt :: 509;
    SYS___channel_open :: 510;
    SYS___channel_get_info :: 511;
    SYS___channel_sync :: 512;
    SYS___channel_get_opt :: 513;
    SYS___channel_set_opt :: 514;
    SYS_ulock_wait :: 515;
    SYS_ulock_wake :: 516;
    SYS_fclonefileat :: 517;
    SYS_fs_snapshot :: 518;
    SYS_terminate_with_payload :: 520;
    SYS_abort_with_payload :: 521;
    SYS_necp_session_open :: 522;
    SYS_necp_session_action :: 523;
    SYS_setattrlistat :: 524;
    SYS_net_qos_guideline :: 525;
    SYS_fmount :: 526;
    SYS_ntp_adjtime :: 527;
    SYS_ntp_gettime :: 528;
    SYS_os_fault_with_payload :: 529;
    SYS_kqueue_workloop_ctl :: 530;
    SYS___mach_bridge_remote_time :: 531;
    SYS_MAXSYSCALL :: 532;
} else #if OS == .LINUX {
    SYS_read :: 0;
    SYS_write :: 1;
    SYS_open :: 2;
    SYS_close :: 3;
    SYS_stat :: 4;
    SYS_fstat :: 5;
    SYS_lstat :: 6;
    SYS_poll :: 7;
    SYS_lseek :: 8;
    SYS_mmap :: 9;
    SYS_mprotect :: 10;
    SYS_munmap :: 11;
    SYS_brk :: 12;
    SYS_rt_sigaction :: 13;
    SYS_rt_sigprocmask :: 14;
    SYS_rt_sigreturn :: 15;
    SYS_ioctl :: 16;
    SYS_pread64 :: 17;
    SYS_pwrite64 :: 18;
    SYS_readv :: 19;
    SYS_writev :: 20;
    SYS_access :: 21;
    SYS_pipe :: 22;
    SYS_select :: 23;
    SYS_sched_yield :: 24;
    SYS_mremap :: 25;
    SYS_msync :: 26;
    SYS_mincore :: 27;
    SYS_madvise :: 28;
    SYS_shmget :: 29;
    SYS_shmat :: 30;
    SYS_shmctl :: 31;
    SYS_dup :: 32;
    SYS_dup2 :: 33;
    SYS_pause :: 34;
    SYS_nanosleep :: 35;
    SYS_getitimer :: 36;
    SYS_alarm :: 37;
    SYS_setitimer :: 38;
    SYS_getpid :: 39;
    SYS_sendfile :: 40;
    SYS_socket :: 41;
    SYS_connect :: 42;
    SYS_accept :: 43;
    SYS_sendto :: 44;
    SYS_recvfrom :: 45;
    SYS_sendmsg :: 46;
    SYS_recvmsg :: 47;
    SYS_shutdown :: 48;
    SYS_bind :: 49;
    SYS_listen :: 50;
    SYS_getsockname :: 51;
    SYS_getpeername :: 52;
    SYS_socketpair :: 53;
    SYS_setsockopt :: 54;
    SYS_getsockopt :: 55;
    SYS_clone :: 56;
    SYS_fork :: 57;
    SYS_vfork :: 58;
    SYS_execve :: 59;
    SYS_exit :: 60;
    SYS_wait4 :: 61;
    SYS_kill :: 62;
    SYS_uname :: 63;
    SYS_semget :: 64;
    SYS_semop :: 65;
    SYS_semctl :: 66;
    SYS_shmdt :: 67;
    SYS_msgget :: 68;
    SYS_msgsnd :: 69;
    SYS_msgrcv :: 70;
    SYS_msgctl :: 71;
    SYS_fcntl :: 72;
    SYS_flock :: 73;
    SYS_fsync :: 74;
    SYS_fdatasync :: 75;
    SYS_truncate :: 76;
    SYS_ftruncate :: 77;
    SYS_getdents :: 78;
    SYS_getcwd :: 79;
    SYS_chdir :: 80;
    SYS_fchdir :: 81;
    SYS_rename :: 82;
    SYS_mkdir :: 83;
    SYS_rmdir :: 84;
    SYS_creat :: 85;
    SYS_link :: 86;
    SYS_unlink :: 87;
    SYS_symlink :: 88;
    SYS_readlink :: 89;
    SYS_chmod :: 90;
    SYS_fchmod :: 91;
    SYS_chown :: 92;
    SYS_fchown :: 93;
    SYS_lchown :: 94;
    SYS_umask :: 95;
    SYS_gettimeofday :: 96;
    SYS_getrlimit :: 97;
    SYS_getrusage :: 98;
    SYS_sysinfo :: 99;
    SYS_times :: 100;
    SYS_ptrace :: 101;
    SYS_getuid :: 102;
    SYS_syslog :: 103;
    SYS_getgid :: 104;
    SYS_setuid :: 105;
    SYS_setgid :: 106;
    SYS_geteuid :: 107;
    SYS_getegid :: 108;
    SYS_setpgid :: 109;
    SYS_getppid :: 110;
    SYS_getpgrp :: 111;
    SYS_setsid :: 112;
    SYS_setreuid :: 113;
    SYS_setregid :: 114;
    SYS_getgroups :: 115;
    SYS_setgroups :: 116;
    SYS_setresuid :: 117;
    SYS_getresuid :: 118;
    SYS_setresgid :: 119;
    SYS_getresgid :: 120;
    SYS_getpgid :: 121;
    SYS_setfsuid :: 122;
    SYS_setfsgid :: 123;
    SYS_getsid :: 124;
    SYS_capget :: 125;
    SYS_capset :: 126;
    SYS_rt_sigpending :: 127;
    SYS_rt_sigtimedwait :: 128;
    SYS_rt_sigqueueinfo :: 129;
    SYS_rt_sigsuspend :: 130;
    SYS_sigaltstack :: 131;
    SYS_utime :: 132;
    SYS_mknod :: 133;
    SYS_uselib :: 134;
    SYS_personality :: 135;
    SYS_ustat :: 136;
    SYS_statfs :: 137;
    SYS_fstatfs :: 138;
    SYS_sysfs :: 139;
    SYS_getpriority :: 140;
    SYS_setpriority :: 141;
    SYS_sched_setparam :: 142;
    SYS_sched_getparam :: 143;
    SYS_sched_setscheduler :: 144;
    SYS_sched_getscheduler :: 145;
    SYS_sched_get_priority_max :: 146;
    SYS_sched_get_priority_min :: 147;
    SYS_sched_rr_get_interval :: 148;
    SYS_mlock :: 149;
    SYS_munlock :: 150;
    SYS_mlockall :: 151;
    SYS_munlockall :: 152;
    SYS_vhangup :: 153;
    SYS_modify_ldt :: 154;
    SYS_pivot_root :: 155;
    SYS__sysctl :: 156;
    SYS_prctl :: 157;
    SYS_arch_prctl :: 158;
    SYS_adjtimex :: 159;
    SYS_setrlimit :: 160;
    SYS_chroot :: 161;
    SYS_sync :: 162;
    SYS_acct :: 163;
    SYS_settimeofday :: 164;
    SYS_mount :: 165;
    SYS_umount2 :: 166;
    SYS_swapon :: 167;
    SYS_swapoff :: 168;
    SYS_reboot :: 169;
    SYS_sethostname :: 170;
    SYS_setdomainname :: 171;
    SYS_iopl :: 172;
    SYS_ioperm :: 173;
    SYS_create_module :: 174;
    SYS_init_module :: 175;
    SYS_delete_module :: 176;
    SYS_get_kernel_syms :: 177;
    SYS_query_module :: 178;
    SYS_quotactl :: 179;
    SYS_nfsservctl :: 180;
    SYS_getpmsg :: 181;
    SYS_putpmsg :: 182;
    SYS_afs_syscall :: 183;
    SYS_tuxcall :: 184;
    SYS_security :: 185;
    SYS_gettid :: 186;
    SYS_readahead :: 187;
    SYS_setxattr :: 188;
    SYS_lsetxattr :: 189;
    SYS_fsetxattr :: 190;
    SYS_getxattr :: 191;
    SYS_lgetxattr :: 192;
    SYS_fgetxattr :: 193;
    SYS_listxattr :: 194;
    SYS_llistxattr :: 195;
    SYS_flistxattr :: 196;
    SYS_removexattr :: 197;
    SYS_lremovexattr :: 198;
    SYS_fremovexattr :: 199;
    SYS_tkill :: 200;
    SYS_time :: 201;
    SYS_futex :: 202;
    SYS_sched_setaffinity :: 203;
    SYS_sched_getaffinity :: 204;
    SYS_set_thread_area :: 205;
    SYS_io_setup :: 206;
    SYS_io_destroy :: 207;
    SYS_io_getevents :: 208;
    SYS_io_submit :: 209;
    SYS_io_cancel :: 210;
    SYS_get_thread_area :: 211;
    SYS_lookup_dcookie :: 212;
    SYS_epoll_create :: 213;
    SYS_epoll_ctl_old :: 214;
    SYS_epoll_wait_old :: 215;
    SYS_remap_file_pages :: 216;
    SYS_getdents64 :: 217;
    SYS_set_tid_address :: 218;
    SYS_restart_syscall :: 219;
    SYS_semtimedop :: 220;
    SYS_fadvise64 :: 221;
    SYS_timer_create :: 222;
    SYS_timer_settime :: 223;
    SYS_timer_gettime :: 224;
    SYS_timer_getoverrun :: 225;
    SYS_timer_delete :: 226;
    SYS_clock_settime :: 227;
    SYS_clock_gettime :: 228;
    SYS_clock_getres :: 229;
    SYS_clock_nanosleep :: 230;
    SYS_exit_group :: 231;
    SYS_epoll_wait :: 232;
    SYS_epoll_ctl :: 233;
    SYS_tgkill :: 234;
    SYS_utimes :: 235;
    SYS_vserver :: 236;
    SYS_mbind :: 237;
    SYS_set_mempolicy :: 238;
    SYS_get_mempolicy :: 239;
    SYS_mq_open :: 240;
    SYS_mq_unlink :: 241;
    SYS_mq_timedsend :: 242;
    SYS_mq_timedreceive :: 243;
    SYS_mq_notify :: 244;
    SYS_mq_getsetattr :: 245;
    SYS_kexec_load :: 246;
    SYS_waitid :: 247;
    SYS_add_key :: 248;
    SYS_request_key :: 249;
    SYS_keyctl :: 250;
    SYS_ioprio_set :: 251;
    SYS_ioprio_get :: 252;
    SYS_inotify_init :: 253;
    SYS_inotify_add_watch :: 254;
    SYS_inotify_rm_watch :: 255;
    SYS_migrate_pages :: 256;
    SYS_openat :: 257;
    SYS_mkdirat :: 258;
    SYS_mknodat :: 259;
    SYS_fchownat :: 260;
    SYS_futimesat :: 261;
    SYS_newfstatat :: 262;
    SYS_unlinkat :: 263;
    SYS_renameat :: 264;
    SYS_linkat :: 265;
    SYS_symlinkat :: 266;
    SYS_readlinkat :: 267;
    SYS_fchmodat :: 268;
    SYS_faccessat :: 269;
    SYS_pselect6 :: 270;
    SYS_ppoll :: 271;
    SYS_unshare :: 272;
    SYS_set_robust_list :: 273;
    SYS_get_robust_list :: 274;
    SYS_splice :: 275;
    SYS_tee :: 276;
    SYS_sync_file_range :: 277;
    SYS_vmsplice :: 278;
    SYS_move_pages :: 279;
    SYS_utimensat :: 280;
    SYS_epoll_pwait :: 281;
    SYS_signalfd :: 282;
    SYS_timerfd_create :: 283;
    SYS_eventfd :: 284;
    SYS_fallocate :: 285;
    SYS_timerfd_settime :: 286;
    SYS_timerfd_gettime :: 287;
    SYS_accept4 :: 288;
    SYS_signalfd4 :: 289;
    SYS_eventfd2 :: 290;
    SYS_epoll_create1 :: 291;
    SYS_dup3 :: 292;
    SYS_pipe2 :: 293;
    SYS_inotify_init1 :: 294;
    SYS_preadv :: 295;
    SYS_pwritev :: 296;
    SYS_rt_tgsigqueueinfo :: 297;
    SYS_perf_event_open :: 298;
    SYS_recvmmsg :: 299;
    SYS_fanotify_init :: 300;
    SYS_fanotify_mark :: 301;
    SYS_prlimit64 :: 302;
    SYS_name_to_handle_at :: 303;
    SYS_open_by_handle_at :: 304;
    SYS_clock_adjtime :: 305;
    SYS_syncfs :: 306;
    SYS_sendmmsg :: 307;
    SYS_setns :: 308;
    SYS_getcpu :: 309;
    SYS_process_vm_readv :: 310;
    SYS_process_vm_writev :: 311;
    SYS_kcmp :: 312;
    SYS_finit_module :: 313;
    SYS_sched_setattr :: 314;
    SYS_sched_getattr :: 315;
    SYS_renameat2 :: 316;
    SYS_seccomp :: 317;
    SYS_getrandom :: 318;
    SYS_memfd_create :: 319;
    SYS_kexec_file_load :: 320;
    SYS_bpf :: 321;
    SYS_execveat :: 322;
    SYS_userfaultfd :: 323;
    SYS_membarrier :: 324;
    SYS_mlock2 :: 325;
    SYS_copy_file_range :: 326;
    SYS_preadv2 :: 327;
    SYS_pwritev2 :: 328;
    SYS_pkey_mprotect :: 329;
    SYS_pkey_alloc :: 330;
    SYS_pkey_free :: 331;
    SYS_statx :: 332;
    SYS_io_pgetevents :: 333;
    SYS_rseq :: 334;
    SYS_pidfd_send_signal :: 424;
    SYS_io_uring_setup :: 425;
    SYS_io_uring_enter :: 426;
    SYS_io_uring_register :: 427;
    SYS_open_tree :: 428;
    SYS_move_mount :: 429;
    SYS_fsopen :: 430;
    SYS_fsconfig :: 431;
    SYS_fsmount :: 432;
    SYS_fspick :: 433;
    SYS_pidfd_open :: 434;
    SYS_clone3 :: 435;
    SYS_epoll_pwait2 :: 441;
}

#if OS == .LINUX {
    TFD_NONBLOCK :: O_NONBLOCK;
    SFD_NONBLOCK :: O_NONBLOCK;
    EFD_NONBLOCK :: 0x0800;

    statx_timestamp_t :: struct {
        tv_sec: s64;
        tv_nsec: u32;
        __reserved: s32;
    }

    statx_t :: struct {
        stx_mask: u32;
        stx_blksize: u32;
        stx_attributes: u64;
        stx_nlink: u32;
        stx_uid: u32;
        stx_gid: u32;
        stx_mode: u16;
        __spare0: [1] u16;
        stx_ino: u64;
        stx_size: u64;
        stx_blocks: u64;
        stx_attributes_mask: u64;
        stx_atime: statx_timestamp_t;
        stx_btime: statx_timestamp_t;
        stx_ctime: statx_timestamp_t;
        stx_mtime: statx_timestamp_t;
        stx_rdev_major: u32;
        stx_rdev_minor: u32;
        stx_dev_major: u32;
        stx_dev_minor: u32;
        stx_mnt_id: u64;
        __spare2: u64;
        __spare3: [12] u64;
    };

    STATX_TYPE: u32 : 0x00000001;
    STATX_MODE: u32 : 0x00000002;
    STATX_NLINK: u32 : 0x00000004;
    STATX_UID: u32 : 0x00000008;
    STATX_GID: u32 : 0x00000010;
    STATX_ATIME: u32 : 0x00000020;
    STATX_MTIME: u32 : 0x00000040;
    STATX_CTIME: u32 : 0x00000080;
    STATX_INO: u32 : 0x00000100;
    STATX_SIZE: u32 : 0x00000200;
    STATX_BLOCKS: u32 : 0x00000400;
    STATX_BASIC_STATS: u32 : 0x000007ff;
    STATX_BTIME: u32 : 0x00000800;
    STATX_MNT_ID: u32 : 0x00001000;
    STATX__RESERVED: u32 : 0x80000000;
    STATX_ATTR_COMPRESSED :: 0x00000004;
    STATX_ATTR_IMMUTABLE :: 0x00000010;
    STATX_ATTR_APPEND :: 0x00000020;
    STATX_ATTR_NODUMP :: 0x00000040;
    STATX_ATTR_ENCRYPTED :: 0x00000800;
    STATX_ATTR_AUTOMOUNT :: 0x00001000;
    STATX_ATTR_MOUNT_ROOT :: 0x00002000;
    STATX_ATTR_VERITY :: 0x00100000;
    STATX_ATTR_DAX :: 0x00200000;
} else #if OS == .MACOS {
    x64_exception_state64_t :: struct {
        __trapno: u16;
        __cpu: u16;
        __err: u32;
        __faultvaddr: u64;
    }

    x64_thread_state64_t :: struct {
        __rax: u64;
        __rbx: u64;
        __rcx: u64;
        __rdx: u64;
        __rdi: u64;
        __rsi: u64;
        __rbp: u64;
        __rsp: u64;
        __r8: u64;
        __r9: u64;
        __r10: u64;
        __r11: u64;
        __r12: u64;
        __r13: u64;
        __r14: u64;
        __r15: u64;
        __rip: u64;
        __rflags: u64;
        __cs: u64;
        __fs: u64;
        __gs: u64;
    }

    darwin_mmst_reg :: struct {
        __mmst_reg: [10] u8;
        __mmst_rsrv: [6] u8;
    }

    xmm_reg :: struct {
        __xmm_reg: [16] u8;
    }

    x64_float_state64_t :: struct {
        __fpu_reserved: [2] s32;
        __fpu_fcw: u16;
        __fpu_fsw: u16;
        __fpu_ftw: u8;
        __fpu_rsrv1: u8;
        __fpu_fop: u16;
        __fpu_ip: u32;
        __fpu_cs: u16;
        __fpu_rsrv2: u16;
        __fpu_dp: u32;
        __fpu_ds: u16;
        __fpu_rsrv3: u16;
        __fpu_mxcsr: u32;
        __fpu_mxcsrmask: u32;
        __fpu_stmm0: darwin_mmst_reg;
        __fpu_stmm1: darwin_mmst_reg;
        __fpu_stmm2: darwin_mmst_reg;
        __fpu_stmm3: darwin_mmst_reg;
        __fpu_stmm4: darwin_mmst_reg;
        __fpu_stmm5: darwin_mmst_reg;
        __fpu_stmm6: darwin_mmst_reg;
        __fpu_stmm7: darwin_mmst_reg;
        __fpu_xmm0: xmm_reg;
        __fpu_xmm1: xmm_reg;
        __fpu_xmm2: xmm_reg;
        __fpu_xmm3: xmm_reg;
        __fpu_xmm4: xmm_reg;
        __fpu_xmm5: xmm_reg;
        __fpu_xmm6: xmm_reg;
        __fpu_xmm7: xmm_reg;
        __fpu_xmm8: xmm_reg;
        __fpu_xmm9: xmm_reg;
        __fpu_xmm10: xmm_reg;
        __fpu_xmm11: xmm_reg;
        __fpu_xmm12: xmm_reg;
        __fpu_xmm13: xmm_reg;
        __fpu_xmm14: xmm_reg;
        __fpu_xmm15: xmm_reg;
        __fpu_rsrv4: [6 * 16] u8;
        __fpu_reserved1: s32;
    }

    mach_port_t :: u32;

    attrlist_t :: struct {
        bitmapcount: u16 = ATTR_BIT_MAP_COUNT;
        reserved: u16;
        using sets: attribute_set_t;
    }

    attribute_set_t :: struct {
        commonattr: ATTR_CMN;
        volattr: u32;
        dirattr: u32;
        fileattr: u32;
        forkattr: u32;
    }

    attrreference_t :: struct {
        attr_dataoffset: s32;
        attr_length: u32;
    }

    ATTR_BIT_MAP_COUNT :: 5;

    ATTR_CMN :: enum_flags u32 {
        RETURNED_ATTRS :: 0x80000000;
        NAME :: 0x00000001;
        OBJTYPE :: 0x00000008;
        USERACCESS :: 0x00200000;
    }

    vtype :: enum u32 #specified {
        VNON :: 0;
        VREG :: 1;
        VDIR :: 2;
        VBLK :: 3;
        VCHR :: 4;
        VLNK :: 5;
        VSOCK :: 6;
        VFIFO :: 7;
        VBAD :: 8;
        VSTR :: 9;
        VCPLX :: 10;
    }
}

iovec :: struct {
    iov_base: *void;
    iov_len: size_t;
}

#scope_export
#load "../POSIX/file-mode-wait.jai";
