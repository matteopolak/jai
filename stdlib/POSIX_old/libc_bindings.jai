// libc functions shared by every Unix target of POSIX_old.
sysconf :: (name: _SC_definitions) -> s64 #foreign libc;
strsignal :: (sig: s32) -> *u8 #foreign libc;
#if OS == .LINUX {
    syscall :: (number: s64, args: ..Any) -> s64 #foreign libc;
} else #if OS == .MACOS {
    syscall :: (number: s32, args: ..Any) -> s32 #foreign libc;
    __syscall :: (number: quad_t, args: ..Any) -> s32 #foreign libc;
}
getpwent :: () -> *passwd #foreign libc;
setpwent :: () #foreign libc;
endpwent :: () #foreign libc;
#if OS == .LINUX {
    timerfd_create :: (clockid: s32, flags: s32) -> s32 #foreign libc;
    timerfd_settime :: (fd: s32, flags: s32, new_value: *itimerspec, old_value: *itimerspec) -> s32 #foreign libc;
}
#scope_module
#if OS == .LINUX {
    __errno_location :: () -> *OS_Error_Code #foreign libc;
} else #if OS == .MACOS {
    __errno_location :: () -> *OS_Error_Code #foreign libc "__error";
}
#scope_export
#if OS == .MACOS {
    htonl :: (hostlong: u32) -> u32 #foreign libc;
    htons :: (hostshort: u16) -> u16 #foreign libc;
    ntohl :: (netlong: u32) -> u32 #foreign libc;
    ntohs :: (netshort: u16) -> u16 #foreign libc;
}
write :: (fd: s32, buf: *void, count: size_t) -> ssize_t #foreign libc;
pwrite :: (fd: s32, buf: *void, count: size_t, offset: off_t) -> ssize_t #foreign libc;
getenv :: (name: *u8) -> *u8 #foreign libc;
setenv :: (name: *u8, value: *u8, overwrite: s32) -> s32 #foreign libc;
perror :: (s: *u8) #foreign libc;
chmod :: (path: *u8, mode: mode_t) -> s32 #foreign libc;
ioctl :: (fd: s32, request: u64, args: ..Any) -> s32 #foreign libc;
getuid :: () -> uid_t #foreign libc;
geteuid :: () -> uid_t #foreign libc;
getpwnam :: (name: *u8) -> *passwd #foreign libc;
getpwuid :: (uid: uid_t) -> *passwd #foreign libc;
getpwnam_r :: (name: *u8, pwd: *passwd, buffer: *u8, bufsize: size_t, result: **passwd) -> s32 #foreign libc;
getpwuid_r :: (uid: uid_t, pwd: *passwd, buffer: *u8, bufsize: size_t, result: **passwd) -> s32 #foreign libc;
wait :: (stat_loc: *s32) -> pid_t #foreign libc;
waitpid :: (pid: pid_t, stat_loc: *s32, options: s32) -> pid_t #foreign libc;
kill :: (pid: pid_t, sig: s32) -> s32 #foreign libc;
fork :: () -> pid_t #foreign libc;
dupfd :: (oldfd: s32) -> s32 #foreign libc "dup";
dup2 :: (oldfd: s32, newfd: s32) -> s32 #foreign libc;
pipe :: (pipefd: *[2] s32) -> s32 #foreign libc;
#if OS == .LINUX {
    pipe2 :: (pipefd: *[2] s32, flags: s32) -> s32 #foreign libc;
}
shmget :: (key: key_t, size: size_t, shmflg: s32) -> s32 #foreign libc;
shm_open :: (name: *u8, oflag: s32, mode: mode_t) -> s32 #foreign librt;
shm_unlink :: (name: *u8) -> s32 #foreign librt;
getlogin_r :: (buf: *u8, bufsize: size_t) -> s32 #foreign libc;
getlogin :: (buf: *u8) -> *u8 #foreign libc;
fnmatch :: (pattern: *u8, name: *u8, flags: s32) -> s32 #foreign libc;
time :: (calptr: *time_t) -> time_t #foreign libc;
gmtime :: (calptr: *time_t) -> *tm #foreign libc;
localtime :: (calptr: *time_t) -> *tm #foreign libc;
gmtime_r :: (calptr: *time_t, result: *tm) -> *tm #foreign libc;
localtime_r :: (calptr: *time_t, result: *tm) -> *tm #foreign libc;
gettimeofday :: (tv: *timeval, tzp: *void) -> s32 #foreign libc;
fopen :: (pathname: *u8, mode: *u8) -> *FILE #foreign libc;
fclose :: (stream: *FILE) -> s32 #foreign libc;
ftell :: (stream: *FILE) -> s64 #foreign libc;
ftello :: (stream: *FILE) -> s64 #foreign libc;
#if OS == .LINUX {
    ftello64 :: (stream: *FILE) -> s64 #foreign libc;
} else {
    ftello64 :: ftello;
}
fread :: (ptr: *void, size: size_t, count: size_t, stream: *FILE) -> size_t #foreign libc;
fwrite :: (ptr: *void, size: size_t, count: size_t, stream: *FILE) -> size_t #foreign libc;
fseek :: (stream: *FILE, offset: s64, whence: s32) -> s32 #foreign libc;
popen :: (command: *u8, type: *u8) -> *FILE #foreign libc;
pclose :: (stream: *FILE) -> s32 #foreign libc;
mkdir :: (filename: *u8, mode: mode_t) -> s32 #foreign libc;
rename :: (oldpath: *u8, newpath: *u8) -> s32 #foreign libc;
_remove :: (path: *u8) -> s32 #foreign libc "remove";
unlink :: (pathname: *u8) -> s32 #foreign libc;
link :: (oldpath: *u8, newpath: *u8) -> s32 #foreign libc;
uname :: (name: *utsname) -> s32 #foreign libc;
gethostname :: (name: *s8, namelen: size_t) -> s32 #foreign libc;
closedir :: (dirp: *DIR) -> s32 #foreign libc;
#if OS == .MACOS {
    opendir :: (dirname: *u8) -> *DIR #foreign libc "opendir$INODE64";
    readdir :: (dirp: *DIR) -> *dirent #foreign libc "readdir$INODE64";
    readdir_r :: (dirp: *DIR, entry: *dirent, result: **dirent) -> s32 #foreign libc "readdir_r$INODE64";
    rewinddir :: (dirp: *DIR) #foreign libc "rewinddir$INODE64";
    seekdir :: (dirp: *DIR, loc: s64) #foreign libc "seekdir$INODE64";
    telldir :: (dirp: *DIR) -> s64 #foreign libc "telldir$INODE64";
} else {
    opendir :: (dirname: *u8) -> *DIR #foreign libc;
    readdir :: (dirp: *DIR) -> *dirent #foreign libc;
    readdir_r :: (dirp: *DIR, entry: *dirent, result: **dirent) -> s32 #foreign libc;
    rewinddir :: (dirp: *DIR) #foreign libc;
    seekdir :: (dirp: *DIR, loc: s64) #foreign libc;
    telldir :: (dirp: *DIR) -> s64 #foreign libc;
}
access :: (pathname: *u8, mode: s32) -> s32 #foreign libc;
readlink :: (path: *u8, buf: *u8, bufsize: size_t) -> ssize_t #foreign libc;
realpath :: (filename: *u8, symlink: *u8) -> *u8 #foreign libc;
getcwd :: (buf: *u8, size: size_t) -> *u8 #foreign libc;
mprotect :: (addr: *void, len: size_t, prot: s32) -> s32 #foreign libc;
mmap :: (addr: *void, len: size_t, prot: s32, flags: s32, fildes: s32, offset: off_t) -> *void #foreign libc;
munmap :: (addr: *void, len: size_t) -> s32 #foreign libc;
madvise :: (addr: *void, length: size_t, advice: s32) -> s32 #foreign libc;
poll :: (fds: *pollfd, nfds: nfds_t, timeout: s32) -> s32 #foreign libc;
system :: (command: *u8) -> s32 #foreign libc;
execvp :: (file: *u8, argv: **u8) -> s32 #foreign libc;
raise :: (signum: s32) -> s32 #foreign libc;
sigaction :: (signum: s32, act: *sigaction_t, oldact: *sigaction_t) -> s32 #foreign libc;
sigemptyset :: (set: *sigset_t) -> s32 #foreign libc;
sigaddset :: (set: *sigset_t, signum: s32) -> s32 #foreign libc;
sigprocmask :: (how: s32, set: *sigset_t, oldset: *sigset_t) -> s32 #foreign libc;
#if OS == .LINUX {
    signalfd :: (fd: s32, mask: *sigset_t, flags: s32) -> s32 #foreign libc;
    signalfd_siginfo :: struct {
        ssi_signo: u32;
        ssi_errno: s32;
        ssi_code: s32;
        ssi_pid: u32;
        ssi_uid: u32;
        ssi_fd: s32;
        ssi_tid: u32;
        ssi_band: u32;
        ssi_overrun: u32;
        ssi_trapno: u32;
        ssi_status: s32;
        ssi_int: s32;
        ssi_ptr: u64;
        ssi_utime: u64;
        ssi_stime: u64;
        ssi_addr: u64;
        ssi_addr_lsb: u16;
        __pad2: u16;
        ssi_syscall: s32;
        ssi_call_addr: u64;
        ssi_arch: u32;
        pad: [28] u8;
    };
    #assert(size_of(signalfd_siginfo) == 128);
    eventfd :: (initval: s32, flags: s32) -> s32 #foreign libc;
}
backtrace :: (array: **void, size: s32) -> s32 #foreign libexecinfo;
backtrace_symbols :: (array: **void, size: s32) -> **u8 #foreign libexecinfo;
backtrace_symbols_fd :: (array: **void, size: s32, fd: s32) #foreign libexecinfo;
getpid :: () -> pid_t #foreign libc;
getsid :: (pid: pid_t) -> pid_t #foreign libc;
getppid :: () -> pid_t #foreign libc;
#if OS == .LINUX {
    sem_init :: (sem: *sem_t, pshared: s32, value: u32) -> s32 #foreign pthreads;
    sem_destroy :: (sem: *sem_t) -> s32 #foreign pthreads;
    sem_post :: (sem: *sem_t) -> s32 #foreign pthreads;
    sem_wait :: (sem: *sem_t) -> s32 #foreign pthreads;
    sem_timedwait :: (sem: *sem_t, abs_timeout: *timespec) -> s32 #foreign pthreads;
}
clock_gettime :: (clk: clockid_t, tp: *timespec) -> int #foreign librt;
clock_getres :: (clk: clockid_t, tp: *timespec) -> int #foreign librt;
clock_settime :: (clk: clockid_t, tp: *timespec) -> int #foreign librt;
open :: (pathname: *u8, flags: s32) -> s32 #foreign libc;
open :: (pathname: *u8, flags: s32, mode: mode_t) -> s32 #foreign libc;
openat :: (directory: s32, pathname: *u8, flags: s32) -> s32 #foreign libc;
openat :: (directory: s32, pathname: *u8, flags: s32, mode: mode_t) -> s32 #foreign libc;
fcntl :: (fd: s32, cmd: s32, optional: ..Any) -> s32 #foreign libc;
read :: (fd: s32, buf: *void, count: size_t) -> ssize_t #foreign libc;
pread :: (fd: s32, buf: *void, count: size_t, offset: off_t) -> ssize_t #foreign libc;
close :: (fd: s32) -> s32 #foreign libc;
ftruncate :: (fd: s32, length: off_t) -> s32 #foreign libc;
#if OS == .LINUX {} else #if OS == .MACOS {
    stat :: (path: *u8, buf: *stat_t) -> s32 #foreign libc "stat$INODE64";
    fstat :: (fd: s32, buf: *stat_t) -> s32 #foreign libc "fstat$INODE64";
    lstat :: (path: *u8, buf: *stat_t) -> s32 #foreign libc "lstat$INODE64";
}
aio_cancel :: (fd: s32, aiocbp: *aiocb_t) -> s32 #foreign librt;
aio_error :: (aiocbp: *aiocb_t) -> s32 #foreign librt;
aio_fsync :: (op: s32, aiocbp: *aiocb_t) -> s32 #foreign librt;
aio_read :: (aiocbp: *aiocb_t) -> s32 #foreign librt;
aio_return :: (aiocbp: *aiocb_t) -> ssize_t #foreign librt;
aio_suspend :: (aiocblist: **aiocb_t, nent: s32, timeout: *timespec) -> s32 #foreign librt;
aio_write :: (aiocbp: *aiocb_t) -> s32 #foreign librt;
lio_listio :: (mode: s32, aiocblist: **aiocb_t, nent: s32, sigp: *sigevent_t) -> s32 #foreign librt;
#if OS == .MACOS {
    getattrlistbulk :: (dirfd: s32, attrList: *attrlist_t, attrBuf: *void, attrBufSize: size_t, options: u64) -> s32 #foreign libc;
}
dynamic_linker :: #system_library "libdl";
dlopen :: (filename: *u8, flag: s32) -> *void #foreign dynamic_linker;
dlerror :: () -> *u8 #foreign dynamic_linker;
dlsym :: (handle: *void, symbol: *u8) -> *void #foreign dynamic_linker;
#if OS == .LINUX && GNU_ENV {
    dlvsym :: (handle: *void, symbol: *u8, version: *u8) -> *void #foreign dynamic_linker;
}
dlclose :: (handle: *void) -> s32 #foreign dynamic_linker;
#scope_file
libc :: #system_library "libc";
libm :: #system_library "libm";
#if OS == .LINUX librt :: #system_library "librt";
else #if OS == .MACOS librt :: libc;
#if OS == .LINUX && !GNU_ENV {
    libexecinfo :: #system_library "libexecinfo";
} else {
    libexecinfo :: libc;
}
pthreads :: #system_library "libpthread";

#scope_export
#load "../POSIX/linux-stat.jai";
