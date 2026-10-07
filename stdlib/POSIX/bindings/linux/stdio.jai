// Linux declarations: <stdio.h>.
_GNU_SOURCE :: 1;
_IOFBF :: 0;
_IOLBF :: 1;
_IONBF :: 2;
SEEK_SET :: 0;
SEEK_CUR :: 1;
SEEK_END :: 2;
SEEK_DATA :: 3;
SEEK_HOLE :: 4;
P_tmpdir :: "/tmp";
__O_LARGEFILE :: 0;
F_GETLK64 :: 5;
F_SETLK64 :: 6;
F_SETLKW64 :: 7;
O_ACCMODE :: 0x3;
O_RDONLY :: 0x0;
O_WRONLY :: 0x1;
O_RDWR :: 0x2;
O_CREAT :: 0x40;
O_EXCL :: 0x80;
O_NOCTTY :: 0x100;
O_TRUNC :: 0x200;
O_APPEND :: 0x400;
O_NONBLOCK :: 0x800;
O_NDELAY :: O_NONBLOCK;
O_SYNC :: 0x101000;
O_FSYNC :: O_SYNC;
O_ASYNC :: 0x2000;

// AArch64 places these three bits differently from x86-64 (its <bits/fcntl.h>). Every
// CPU-dependent declaration in these bindings names each supported CPU; the browser target
// (OS == .WASM, whatever CPU it reports) shares the x86-64 layouts with the interpreter's sandbox.
#if CPU == .ARM64 && OS != .WASM {
    __O_DIRECTORY :: 0x4000;
    __O_NOFOLLOW :: 0x8000;
    __O_DIRECT :: 0x10000;
} else #if CPU == .X64 || OS == .WASM {
    __O_DIRECTORY :: 0x10000;
    __O_NOFOLLOW :: 0x20000;
    __O_DIRECT :: 0x4000;
} else {
    #assert false "POSIX: no Linux <fcntl.h> flags for this CPU";
}

__O_CLOEXEC :: 0x80000;
__O_NOATIME :: 0x40000;
__O_PATH :: 0x200000;
__O_DSYNC :: 0x1000;
__O_TMPFILE :: 0x400000 | __O_DIRECTORY;
F_GETLK :: 5;
F_SETLK :: 6;
F_SETLKW :: 7;
F_OFD_GETLK :: 36;
F_OFD_SETLK :: 37;
F_OFD_SETLKW :: 38;
O_LARGEFILE :: __O_LARGEFILE;
O_DIRECTORY :: __O_DIRECTORY;
O_NOFOLLOW :: __O_NOFOLLOW;
O_CLOEXEC :: __O_CLOEXEC;
O_DIRECT :: __O_DIRECT;
O_NOATIME :: __O_NOATIME;
O_PATH :: __O_PATH;
O_TMPFILE :: __O_TMPFILE;
O_DSYNC :: __O_DSYNC;
O_RSYNC :: O_SYNC;
F_DUPFD :: 0;
F_GETFD :: 1;
F_SETFD :: 2;
F_GETFL :: 3;
F_SETFL :: 4;
__F_SETOWN :: 8;
__F_GETOWN :: 9;
F_SETOWN :: __F_SETOWN;
F_GETOWN :: __F_GETOWN;
__F_SETSIG :: 10;
__F_GETSIG :: 11;
__F_SETOWN_EX :: 15;
__F_GETOWN_EX :: 16;
F_SETSIG :: __F_SETSIG;
F_GETSIG :: __F_GETSIG;
F_SETOWN_EX :: __F_SETOWN_EX;
F_GETOWN_EX :: __F_GETOWN_EX;
F_SETLEASE :: 1024;
F_GETLEASE :: 1025;
F_NOTIFY :: 1026;
F_SETPIPE_SZ :: 1031;
F_GETPIPE_SZ :: 1032;
F_ADD_SEALS :: 1033;
F_GET_SEALS :: 1034;
F_GET_RW_HINT :: 1035;
F_SET_RW_HINT :: 1036;
F_GET_FILE_RW_HINT :: 1037;
F_SET_FILE_RW_HINT :: 1038;
F_DUPFD_CLOEXEC :: 1030;
FD_CLOEXEC :: 1;
F_RDLCK :: 0;
F_WRLCK :: 1;
F_UNLCK :: 2;
F_EXLCK :: 4;
F_SHLCK :: 8;
LOCK_SH :: 1;
LOCK_EX :: 2;
LOCK_NB :: 4;
LOCK_UN :: 8;
LOCK_MAND :: 32;
LOCK_READ :: 64;
LOCK_WRITE :: 128;
LOCK_RW :: 192;
DN_ACCESS :: 0x00000001;
DN_MODIFY :: 0x00000002;
DN_CREATE :: 0x00000004;
DN_DELETE :: 0x00000008;
DN_RENAME :: 0x00000010;
DN_ATTRIB :: 0x00000020;
DN_MULTISHOT :: 0x80000000;
F_SEAL_SEAL :: 0x0001;
F_SEAL_SHRINK :: 0x0002;
F_SEAL_GROW :: 0x0004;
F_SEAL_WRITE :: 0x0008;
RWF_WRITE_LIFE_NOT_SET :: 0;
RWH_WRITE_LIFE_NONE :: 1;
RWH_WRITE_LIFE_SHORT :: 2;
RWH_WRITE_LIFE_MEDIUM :: 3;
RWH_WRITE_LIFE_LONG :: 4;
RWH_WRITE_LIFE_EXTREME :: 5;
FAPPEND :: O_APPEND;
FFSYNC :: O_FSYNC;
FASYNC :: O_ASYNC;
FNONBLOCK :: O_NONBLOCK;
FNDELAY :: O_NDELAY;
__POSIX_FADV_DONTNEED :: 4;
__POSIX_FADV_NOREUSE :: 5;
POSIX_FADV_NORMAL :: 0;
POSIX_FADV_RANDOM :: 1;
POSIX_FADV_SEQUENTIAL :: 2;
POSIX_FADV_WILLNEED :: 3;
POSIX_FADV_DONTNEED :: __POSIX_FADV_DONTNEED;
POSIX_FADV_NOREUSE :: __POSIX_FADV_NOREUSE;
SYNC_FILE_RANGE_WAIT_BEFORE :: 1;
SYNC_FILE_RANGE_WRITE :: 2;
SYNC_FILE_RANGE_WAIT_AFTER :: 4;
SPLICE_F_MOVE :: 1;
SPLICE_F_NONBLOCK :: 2;
SPLICE_F_MORE :: 4;
SPLICE_F_GIFT :: 8;
MAX_HANDLE_SZ :: 128;
AT_FDCWD :: -100;
AT_SYMLINK_NOFOLLOW :: 0x100;
AT_REMOVEDIR :: 0x200;
AT_SYMLINK_FOLLOW :: 0x400;
AT_NO_AUTOMOUNT :: 0x800;
AT_EMPTY_PATH :: 0x1000;
AT_EACCESS :: 0x200;
_STAT_VER_KERNEL :: 0;
_STAT_VER_LINUX :: 1;
_MKNOD_VER_LINUX :: 0;
_STAT_VER :: _STAT_VER_LINUX;
__S_IFMT :: 0xf000;
__S_IFDIR :: 0x4000;
__S_IFCHR :: 0x2000;
__S_IFBLK :: 0x6000;
__S_IFREG :: 0x8000;
__S_IFIFO :: 0x1000;
__S_IFLNK :: 0xa000;
__S_IFSOCK :: 0xc000;
__S_ISUID :: 0x800;
__S_ISGID :: 0x400;
__S_ISVTX :: 0x200;
__S_IREAD :: 0x100;
__S_IWRITE :: 0x80;
__S_IEXEC :: 0x40;
UTIME_NOW :: (1 << 30) - 1;
UTIME_OMIT :: (1 << 30) - 2;
S_IFMT :: __S_IFMT;
S_IFDIR :: __S_IFDIR;
S_IFCHR :: __S_IFCHR;
S_IFBLK :: __S_IFBLK;
S_IFREG :: __S_IFREG;
S_IFIFO :: __S_IFIFO;
S_IFLNK :: __S_IFLNK;
S_IFSOCK :: __S_IFSOCK;
S_ISUID :: __S_ISUID;
S_ISGID :: __S_ISGID;
S_ISVTX :: __S_ISVTX;
S_IRUSR :: __S_IREAD;
S_IWUSR :: __S_IWRITE;
S_IXUSR :: __S_IEXEC;
S_IRWXU :: __S_IREAD | __S_IWRITE | __S_IEXEC;
S_IRGRP :: S_IRUSR >> 3;
S_IWGRP :: S_IWUSR >> 3;
S_IXGRP :: S_IXUSR >> 3;
S_IRWXG :: S_IRWXU >> 3;
S_IROTH :: S_IRGRP >> 3;
S_IWOTH :: S_IWGRP >> 3;
S_IXOTH :: S_IXGRP >> 3;
S_IRWXO :: S_IRWXG >> 3;
R_OK :: 4;
W_OK :: 2;
X_OK :: 1;
F_OK :: 0;
F_ULOCK :: 0;
F_LOCK :: 1;
F_TLOCK :: 2;
F_TEST :: 3;
S_IREAD :: S_IRUSR;
S_IWRITE :: S_IWUSR;
S_IEXEC :: S_IXUSR;
ACCESSPERMS :: S_IRWXU | S_IRWXG | S_IRWXO;
ALLPERMS :: S_ISUID | S_ISGID | S_ISVTX | S_IRWXU | S_IRWXG | S_IRWXO;
DEFFILEMODE :: S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH;
S_BLKSIZE :: 512;
_MKNOD_VER :: 0;
TCGETS :: 0x5401;
TCSETS :: 0x5402;
TCSETSW :: 0x5403;
TCSETSF :: 0x5404;
TCGETA :: 0x5405;
TCSETA :: 0x5406;
TCSETAW :: 0x5407;
TCSETAF :: 0x5408;
TCSBRK :: 0x5409;
TCXONC :: 0x540A;
TCFLSH :: 0x540B;
TIOCEXCL :: 0x540C;
TIOCNXCL :: 0x540D;
TIOCSCTTY :: 0x540E;
TIOCGPGRP :: 0x540F;
TIOCSPGRP :: 0x5410;
TIOCOUTQ :: 0x5411;
TIOCSTI :: 0x5412;
TIOCGWINSZ :: 0x5413;
TIOCSWINSZ :: 0x5414;
TIOCMGET :: 0x5415;
TIOCMBIS :: 0x5416;
TIOCMBIC :: 0x5417;
TIOCMSET :: 0x5418;
TIOCGSOFTCAR :: 0x5419;
TIOCSSOFTCAR :: 0x541A;
FIONREAD :: 0x541B;
TIOCINQ :: FIONREAD;
TIOCLINUX :: 0x541C;
TIOCCONS :: 0x541D;
TIOCGSERIAL :: 0x541E;
TIOCSSERIAL :: 0x541F;
TIOCPKT :: 0x5420;
FIONBIO :: 0x5421;
TIOCNOTTY :: 0x5422;
TIOCSETD :: 0x5423;
TIOCGETD :: 0x5424;
TCSBRKP :: 0x5425;
TIOCSBRK :: 0x5427;
TIOCCBRK :: 0x5428;
TIOCGSID :: 0x5429;
TIOCGRS485 :: 0x542E;
TIOCSRS485 :: 0x542F;
TCGETX :: 0x5432;
TCSETX :: 0x5433;
TCSETXF :: 0x5434;
TCSETXW :: 0x5435;
TIOCVHANGUP :: 0x5437;
FIONCLEX :: 0x5450;
FIOCLEX :: 0x5451;
FIOASYNC :: 0x5452;
TIOCSERCONFIG :: 0x5453;
TIOCSERGWILD :: 0x5454;
TIOCSERSWILD :: 0x5455;
TIOCGLCKTRMIOS :: 0x5456;
TIOCSLCKTRMIOS :: 0x5457;
TIOCSERGSTRUCT :: 0x5458;
TIOCSERGETLSR :: 0x5459;
TIOCSERGETMULTI :: 0x545A;
TIOCSERSETMULTI :: 0x545B;
TIOCMIWAIT :: 0x545C;
TIOCGICOUNT :: 0x545D;
FIOQSIZE :: 0x5460;
TIOCPKT_DATA :: 0;
TIOCPKT_FLUSHREAD :: 1;
TIOCPKT_FLUSHWRITE :: 2;
TIOCPKT_STOP :: 4;
TIOCPKT_START :: 8;
TIOCPKT_NOSTOP :: 16;
TIOCPKT_DOSTOP :: 32;
TIOCPKT_IOCTL :: 64;
TIOCSER_TEMT :: 0x01;
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
SIOGIFINDEX :: SIOCGIFINDEX;
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

__mbstate_t :: struct {
    __count: s32;
    __value: union {
        __wch: u32;
        __wchb: [4] u8;
    };
}

_G_fpos_t :: struct {
    __pos: s64;
    __state: __mbstate_t;
}

_G_fpos64_t :: struct {
    __pos: s64;
    __state: __mbstate_t;
}

__io_read_fn :: #type (__cookie: *void, __buf: *u8, __nbytes: u64) -> s64 #c_call;
__io_write_fn :: #type (__cookie: *void, __buf: *u8, __n: u64) -> s64 #c_call;
__io_seek_fn :: #type (__cookie: *void, __pos: *s64, __w: s32) -> s32 #c_call;
__io_close_fn :: #type (__cookie: *void) -> s32 #c_call;

_IO_cookie_io_functions_t :: struct {
    read: __io_read_fn;
    write: __io_write_fn;
    seek: __io_seek_fn;
    close: __io_close_fn;
}

fpos_t :: _G_fpos_t;
fpos64_t :: _G_fpos64_t;
stdin: *_IO_FILE #elsewhere libc;
stdout: *_IO_FILE #elsewhere libc;
stderr: *_IO_FILE #elsewhere libc;
_remove :: (__filename: *u8) -> s32 #foreign libc "remove";
rename :: (__old: *u8, __new: *u8) -> s32 #foreign libc;
renameat :: (__oldfd: s32, __old: *u8, __newfd: s32, __new: *u8) -> s32 #foreign libc;
tmpfile :: () -> *FILE #foreign libc;
tmpfile64 :: () -> *FILE #foreign libc;
tmpnam :: (__s: *u8) -> *u8 #foreign libc;
tmpnam_r :: (__s: *u8) -> *u8 #foreign libc;
tempnam :: (__dir: *u8, __pfx: *u8) -> *u8 #foreign libc;
fclose :: (__stream: *FILE) -> s32 #foreign libc;
fflush :: (__stream: *FILE) -> s32 #foreign libc;
fflush_unlocked :: (__stream: *FILE) -> s32 #foreign libc;
fcloseall :: () -> s32 #foreign libc;
fopen :: (__filename: *u8, __modes: *u8) -> *FILE #foreign libc;
freopen :: (__filename: *u8, __modes: *u8, __stream: *FILE) -> *FILE #foreign libc;
fopen64 :: (__filename: *u8, __modes: *u8) -> *FILE #foreign libc;
freopen64 :: (__filename: *u8, __modes: *u8, __stream: *FILE) -> *FILE #foreign libc;
fdopen :: (__fd: s32, __modes: *u8) -> *FILE #foreign libc;
fopencookie :: (__magic_cookie: *void, __modes: *u8, __io_funcs: _IO_cookie_io_functions_t) -> *FILE #foreign libc;
fmemopen :: (__s: *void, __len: u64, __modes: *u8) -> *FILE #foreign libc;
open_memstream :: (__bufloc: **u8, __sizeloc: *u64) -> *FILE #foreign libc;
setbuf :: (__stream: *FILE, __buf: *u8) -> void #foreign libc;
setvbuf :: (__stream: *FILE, __buf: *u8, __modes: s32, __n: u64) -> s32 #foreign libc;
setbuffer :: (__stream: *FILE, __buf: *u8, __size: u64) -> void #foreign libc;
setlinebuf :: (__stream: *FILE) -> void #foreign libc;
fprintf :: (__stream: *FILE, __format: *u8, __args: ..Any) -> s32 #foreign libc;
printf :: (__format: *u8, __args: ..Any) -> s32 #foreign libc;
sprintf :: (__s: *u8, __format: *u8, __args: ..Any) -> s32 #foreign libc;
snprintf :: (__s: *u8, __maxlen: u64, __format: *u8, __args: ..Any) -> s32 #foreign libc;
__asprintf :: (__ptr: **u8, __fmt: *u8, __args: ..Any) -> s32 #foreign libc;
asprintf :: (__ptr: **u8, __fmt: *u8, __args: ..Any) -> s32 #foreign libc;
dprintf :: (__fd: s32, __fmt: *u8, __args: ..Any) -> s32 #foreign libc;
fscanf :: (__stream: *FILE, __format: *u8, __args: ..Any) -> s32 #foreign libc;
scanf :: (__format: *u8, __args: ..Any) -> s32 #foreign libc;
sscanf :: (__s: *u8, __format: *u8, __args: ..Any) -> s32 #foreign libc;
fgetc :: (__stream: *FILE) -> s32 #foreign libc;
getc :: (__stream: *FILE) -> s32 #foreign libc;
getchar :: () -> s32 #foreign libc;
getc_unlocked :: (__stream: *FILE) -> s32 #foreign libc;
getchar_unlocked :: () -> s32 #foreign libc;
fgetc_unlocked :: (__stream: *FILE) -> s32 #foreign libc;
fputc :: (__c: s32, __stream: *FILE) -> s32 #foreign libc;
putc :: (__c: s32, __stream: *FILE) -> s32 #foreign libc;
putchar :: (__c: s32) -> s32 #foreign libc;
fputc_unlocked :: (__c: s32, __stream: *FILE) -> s32 #foreign libc;
putc_unlocked :: (__c: s32, __stream: *FILE) -> s32 #foreign libc;
putchar_unlocked :: (__c: s32) -> s32 #foreign libc;
getw :: (__stream: *FILE) -> s32 #foreign libc;
putw :: (__w: s32, __stream: *FILE) -> s32 #foreign libc;
fgets :: (__s: *u8, __n: s32, __stream: *FILE) -> *u8 #foreign libc;
fgets_unlocked :: (__s: *u8, __n: s32, __stream: *FILE) -> *u8 #foreign libc;
__getdelim :: (__lineptr: **u8, __n: *u64, __delimiter: s32, __stream: *FILE) -> s64 #foreign libc;
getdelim :: (__lineptr: **u8, __n: *u64, __delimiter: s32, __stream: *FILE) -> s64 #foreign libc;
getline :: (__lineptr: **u8, __n: *u64, __stream: *FILE) -> s64 #foreign libc;
fputs :: (__s: *u8, __stream: *FILE) -> s32 #foreign libc;
puts :: (__s: *u8) -> s32 #foreign libc;
ungetc :: (__c: s32, __stream: *FILE) -> s32 #foreign libc;
fread :: (__ptr: *void, __size: u64, __n: u64, __stream: *FILE) -> u64 #foreign libc;
fwrite :: (__ptr: *void, __size: u64, __n: u64, __s: *FILE) -> u64 #foreign libc;
fputs_unlocked :: (__s: *u8, __stream: *FILE) -> s32 #foreign libc;
fread_unlocked :: (__ptr: *void, __size: u64, __n: u64, __stream: *FILE) -> u64 #foreign libc;
fwrite_unlocked :: (__ptr: *void, __size: u64, __n: u64, __stream: *FILE) -> u64 #foreign libc;
fseek :: (__stream: *FILE, __off: s64, __whence: s32) -> s32 #foreign libc;
ftell :: (__stream: *FILE) -> s64 #foreign libc;
rewind :: (__stream: *FILE) -> void #foreign libc;
fseeko :: (__stream: *FILE, __off: s64, __whence: s32) -> s32 #foreign libc;
ftello :: (__stream: *FILE) -> s64 #foreign libc;
fgetpos :: (__stream: *FILE, __pos: *fpos_t) -> s32 #foreign libc;
fsetpos :: (__stream: *FILE, __pos: *fpos_t) -> s32 #foreign libc;
fseeko64 :: (__stream: *FILE, __off: s64, __whence: s32) -> s32 #foreign libc;
ftello64 :: (__stream: *FILE) -> s64 #foreign libc;
fgetpos64 :: (__stream: *FILE, __pos: *fpos64_t) -> s32 #foreign libc;
fsetpos64 :: (__stream: *FILE, __pos: *fpos64_t) -> s32 #foreign libc;
clearerr :: (__stream: *FILE) -> void #foreign libc;
feof :: (__stream: *FILE) -> s32 #foreign libc;
ferror :: (__stream: *FILE) -> s32 #foreign libc;
clearerr_unlocked :: (__stream: *FILE) -> void #foreign libc;
feof_unlocked :: (__stream: *FILE) -> s32 #foreign libc;
ferror_unlocked :: (__stream: *FILE) -> s32 #foreign libc;
perror :: (__s: *u8) -> void #foreign libc;
fileno :: (__stream: *FILE) -> s32 #foreign libc;
fileno_unlocked :: (__stream: *FILE) -> s32 #foreign libc;
popen :: (__command: *u8, __modes: *u8) -> *FILE #foreign libc;
pclose :: (__stream: *FILE) -> s32 #foreign libc;
ctermid :: (__s: *u8) -> *u8 #foreign libc;
cuserid :: (__s: *u8) -> *u8 #foreign libc;
obstack :: struct {}
obstack_printf :: (__obstack: *obstack, __format: *u8, __args: ..Any) -> s32 #foreign libc;
flockfile :: (__stream: *FILE) -> void #foreign libc;
ftrylockfile :: (__stream: *FILE) -> s32 #foreign libc;
funlockfile :: (__stream: *FILE) -> void #foreign libc;

flock :: struct {
    l_type: s16;
    l_whence: s16;
    l_start: s64;
    l_len: s64;
    l_pid: s32;
}

flock64 :: struct {
    l_type: s16;
    l_whence: s16;
    l_start: s64;
    l_len: s64;
    l_pid: s32;
}

__pid_type :: enum u32 {
    TID :: 0;
    PID :: 1;
    PGRP :: 2;
    GID :: 2;
    F_OWNER_TID :: TID;
    F_OWNER_PID :: PID;
    F_OWNER_PGRP :: PGRP;
    F_OWNER_GID :: GID;
}

f_owner_ex :: struct {
    type: __pid_type;
    pid: s32;
}

file_handle :: struct {
    handle_bytes: u32;
    handle_type: s32;
    f_handle: [0] u8;
}

readahead :: (__fd: s32, __offset: s64, __count: u64) -> s64 #foreign libc;
sync_file_range :: (__fd: s32, __offset: s64, __count: s64, __flags: u32) -> s32 #foreign libc;
vmsplice :: (__fdout: s32, __iov: *iovec, __count: u64, __flags: u32) -> s64 #foreign libc;
splice :: (__fdin: s32, __offin: *s64, __fdout: s32, __offout: *s64, __len: u64, __flags: u32) -> s64 #foreign libc;
tee :: (__fdin: s32, __fdout: s32, __len: u64, __flags: u32) -> s64 #foreign libc;
fallocate :: (__fd: s32, __mode: s32, __offset: s64, __len: s64) -> s32 #foreign libc;
fallocate64 :: (__fd: s32, __mode: s32, __offset: s64, __len: s64) -> s32 #foreign libc;
name_to_handle_at :: (__dfd: s32, __name: *u8, __handle: *file_handle, __mnt_id: *s32, __flags: s32) -> s32 #foreign libc;
open_by_handle_at :: (__mountdirfd: s32, __handle: *file_handle, __flags: s32) -> s32 #foreign libc;
mode_t :: u32;
pid_t :: s32;

// The kernel's struct stat differs per architecture: AArch64 uses the generic 128-byte layout
// (32-bit st_nlink after st_mode), x86-64 its own 144-byte one. The browser target uses x86-64.
#if CPU == .ARM64 && OS != .WASM {
    nlink_t :: u32;
    blksize_t :: s32;

    stat_t :: struct {
        st_dev: u64;
        st_ino: u64;
        st_mode: u32;
        st_nlink: u32;
        st_uid: u32;
        st_gid: u32;
        st_rdev: u64;
        __pad1: u64;
        st_size: s64;
        st_blksize: s32;
        __pad2: s32;
        st_blocks: s64;
        st_atime: timespec;
        st_mtime: timespec;
        st_ctime: timespec;
        __glibc_reserved: [2] s32;
    }

    stat64_t :: struct {
        st_dev: u64;
        st_ino: u64;
        st_mode: u32;
        st_nlink: u32;
        st_uid: u32;
        st_gid: u32;
        st_rdev: u64;
        __pad1: u64;
        st_size: s64;
        st_blksize: s32;
        __pad2: s32;
        st_blocks: s64;
        st_atime: timespec;
        st_mtime: timespec;
        st_ctime: timespec;
        __glibc_reserved: [2] s32;
    }
} else #if CPU == .X64 || OS == .WASM {
    nlink_t :: u64;
    blksize_t :: s64;

    stat_t :: struct {
        st_dev: u64;
        st_ino: u64;
        st_nlink: u64;
        st_mode: u32;
        st_uid: u32;
        st_gid: u32;
        __pad0: s32;
        st_rdev: u64;
        st_size: s64;
        st_blksize: s64;
        st_blocks: s64;
        st_atime: timespec;
        st_mtime: timespec;
        st_ctime: timespec;
        __glibc_reserved: [3] s64;
    }

    stat64_t :: struct {
        st_dev: u64;
        st_ino: u64;
        st_nlink: u64;
        st_mode: u32;
        st_uid: u32;
        st_gid: u32;
        __pad0: s32;
        st_rdev: u64;
        st_size: s64;
        st_blksize: s64;
        st_blocks: s64;
        st_atime: timespec;
        st_mtime: timespec;
        st_ctime: timespec;
        __glibc_reserved: [3] s64;
    }
} else {
    #assert false "POSIX: no Linux struct stat layout for this CPU";
}

fcntl :: (__fd: s32, __cmd: s32, __args: ..Any) -> s32 #foreign libc;
open :: (__file: *u8, __oflag: s32, __args: ..Any) -> s32 #foreign libc;
open64 :: (__file: *u8, __oflag: s32, __args: ..Any) -> s32 #foreign libc;
openat :: (__fd: s32, __file: *u8, __oflag: s32, __args: ..Any) -> s32 #foreign libc;
openat64 :: (__fd: s32, __file: *u8, __oflag: s32, __args: ..Any) -> s32 #foreign libc;
creat :: (__file: *u8, __mode: mode_t) -> s32 #foreign libc;
creat64 :: (__file: *u8, __mode: mode_t) -> s32 #foreign libc;
lockf :: (__fd: s32, __cmd: s32, __len: s64) -> s32 #foreign libc;
lockf64 :: (__fd: s32, __cmd: s32, __len: s64) -> s32 #foreign libc;
posix_fadvise :: (__fd: s32, __offset: s64, __len: s64, __advise: s32) -> s32 #foreign libc;
posix_fadvise64 :: (__fd: s32, __offset: s64, __len: s64, __advise: s32) -> s32 #foreign libc;
posix_fallocate :: (__fd: s32, __offset: s64, __len: s64) -> s32 #foreign libc;
posix_fallocate64 :: (__fd: s32, __offset: s64, __len: s64) -> s32 #foreign libc;
dev_t :: u64;
gid_t :: u32;
ino_t :: u64;
uid_t :: u32;
blkcnt_t :: s64;
chmod :: (__file: *u8, __mode: u32) -> s32 #foreign libc;
lchmod :: (__file: *u8, __mode: u32) -> s32 #foreign libc;
fchmod :: (__fd: s32, __mode: u32) -> s32 #foreign libc;
fchmodat :: (__fd: s32, __file: *u8, __mode: u32, __flag: s32) -> s32 #foreign libc;
umask :: (__mask: u32) -> u32 #foreign libc;
mkdir :: (__path: *u8, __mode: u32) -> s32 #foreign libc;
mkdirat :: (__fd: s32, __path: *u8, __mode: u32) -> s32 #foreign libc;
mkfifo :: (__path: *u8, __mode: u32) -> s32 #foreign libc;
mkfifoat :: (__fd: s32, __path: *u8, __mode: u32) -> s32 #foreign libc;
utimensat :: (__fd: s32, __path: *u8, __times: *[2] timespec, __flags: s32) -> s32 #foreign libc;
futimens :: (__fd: s32, __times: *[2] timespec) -> s32 #foreign libc;
__fxstat :: (__ver: s32, __fildes: s32, __stat_buf: *stat_t) -> s32 #foreign libc;
__xstat :: (__ver: s32, __filename: *u8, __stat_buf: *stat_t) -> s32 #foreign libc;
__lxstat :: (__ver: s32, __filename: *u8, __stat_buf: *stat_t) -> s32 #foreign libc;
__fxstatat :: (__ver: s32, __fildes: s32, __filename: *u8, __stat_buf: *stat_t, __flag: s32) -> s32 #foreign libc;
__fxstat64 :: (__ver: s32, __fildes: s32, __stat_buf: *stat64_t) -> s32 #foreign libc;
__xstat64 :: (__ver: s32, __filename: *u8, __stat_buf: *stat64_t) -> s32 #foreign libc;
__lxstat64 :: (__ver: s32, __filename: *u8, __stat_buf: *stat64_t) -> s32 #foreign libc;
__fxstatat64 :: (__ver: s32, __fildes: s32, __filename: *u8, __stat_buf: *stat64_t, __flag: s32) -> s32 #foreign libc;
__xmknod :: (__ver: s32, __path: *u8, __mode: u32, __dev: *u64) -> s32 #foreign libc;
__xmknodat :: (__ver: s32, __fd: s32, __path: *u8, __mode: u32, __dev: *u64) -> s32 #foreign libc;
ioctl :: (__fd: s32, __request: u64, __args: ..Any) -> s32 #foreign libc;

aiocb :: struct {
    aio_fildes: s32;
    aio_lio_opcode: s32;
    aio_reqprio: s32;
    aio_buf: *void;
    aio_nbytes: u64;
    aio_sigevent: sigevent;
    __next_prio: *aiocb;
    __abs_prio: s32;
    __policy: s32;
    __error_code: s32;
    __return_value: s64;
    aio_offset: s64;
    __pad: [0] u8;
    __glibc_reserved: [32] u8;
}

aiocb64 :: struct {
    aio_fildes: s32;
    aio_lio_opcode: s32;
    aio_reqprio: s32;
    aio_buf: *void;
    aio_nbytes: u64;
    aio_sigevent: sigevent;
    __next_prio: *aiocb;
    __abs_prio: s32;
    __policy: s32;
    __error_code: s32;
    __return_value: s64;
    aio_offset: s64;
    __glibc_reserved: [32] u8;
}

aioinit :: struct {
    aio_threads: s32;
    aio_num: s32;
    aio_locks: s32;
    aio_usedba: s32;
    aio_debug: s32;
    aio_numusers: s32;
    aio_idle_time: s32;
    aio_reserved: s32;
}

AIO :: enum u32 {
    CANCELED :: 0;
    NOTCANCELED :: 1;
    ALLDONE :: 2;
    AIO_CANCELED :: CANCELED;
    AIO_NOTCANCELED :: NOTCANCELED;
    AIO_ALLDONE :: ALLDONE;
}

LIO :: enum u32 {
    READ :: 0;
    WRITE :: 1;
    NOP :: 2;
    LIO_READ :: READ;
    LIO_WRITE :: WRITE;
    LIO_NOP :: NOP;
}

LIO_1 :: enum u32 {
    WAIT :: 0;
    NOWAIT :: 1;
    LIO_WAIT :: WAIT;
    LIO_NOWAIT :: NOWAIT;
}

aio_init :: (__init: *aioinit) -> void #foreign librt;
aio_read :: (__aiocbp: *aiocb) -> s32 #foreign librt;
aio_write :: (__aiocbp: *aiocb) -> s32 #foreign librt;
lio_listio :: (__mode: s32, __list: **aiocb, __nent: s32, __sig: *sigevent) -> s32 #foreign librt;
aio_error :: (__aiocbp: *aiocb) -> s32 #foreign librt;
aio_return :: (__aiocbp: *aiocb) -> s64 #foreign librt;
aio_cancel :: (__fildes: s32, __aiocbp: *aiocb) -> s32 #foreign librt;
aio_suspend :: (__list: **aiocb, __nent: s32, __timeout: *timespec) -> s32 #foreign librt;
aio_fsync :: (__operation: s32, __aiocbp: *aiocb) -> s32 #foreign librt;
aio_read64 :: (__aiocbp: *aiocb64) -> s32 #foreign librt;
aio_write64 :: (__aiocbp: *aiocb64) -> s32 #foreign librt;
lio_listio64 :: (__mode: s32, __list: **aiocb64, __nent: s32, __sig: *sigevent) -> s32 #foreign librt;
aio_error64 :: (__aiocbp: *aiocb64) -> s32 #foreign librt;
aio_return64 :: (__aiocbp: *aiocb64) -> s64 #foreign librt;
aio_cancel64 :: (__fildes: s32, __aiocbp: *aiocb64) -> s32 #foreign librt;
aio_suspend64 :: (__list: **aiocb64, __nent: s32, __timeout: *timespec) -> s32 #foreign librt;
aio_fsync64 :: (__operation: s32, __aiocbp: *aiocb64) -> s32 #foreign librt;

EFD :: enum u32 {
    SEMAPHORE :: 1;
    CLOEXEC :: 524288;
    NONBLOCK :: 2048;
    EFD_SEMAPHORE :: SEMAPHORE;
    EFD_CLOEXEC :: CLOEXEC;
    EFD_NONBLOCK :: NONBLOCK;
}

eventfd_t :: u64;
eventfd :: (__count: u32, __flags: s32) -> s32 #foreign libc;
eventfd_read :: (__fd: s32, __value: *eventfd_t) -> s32 #foreign libc;
eventfd_write :: (__fd: s32, __value: eventfd_t) -> s32 #foreign libc;

TFD :: enum u32 {
    CLOEXEC :: 524288;
    NONBLOCK :: 2048;
    TFD_CLOEXEC :: CLOEXEC;
    TFD_NONBLOCK :: NONBLOCK;
}

TFD_TIMER :: enum u32 {
    ABSTIME :: 1;
    CANCEL_ON_SET :: 2;
    TFD_TIMER_ABSTIME :: ABSTIME;
    TFD_TIMER_CANCEL_ON_SET :: CANCEL_ON_SET;
}

timerfd_create :: (__clock_id: s32, __flags: s32) -> s32 #foreign libc;
timerfd_settime :: (__ufd: s32, __flags: s32, __utmr: *itimerspec, __otmr: *itimerspec) -> s32 #foreign libc;
timerfd_gettime :: (__ufd: s32, __otmr: *itimerspec) -> s32 #foreign libc;

SFD :: enum u32 {
    CLOEXEC :: 524288;
    NONBLOCK :: 2048;
    SFD_CLOEXEC :: CLOEXEC;
    SFD_NONBLOCK :: NONBLOCK;
}

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
    __pad: [48] u8;
}

signalfd :: (__fd: s32, __mask: *sigset_t, __flags: s32) -> s32 #foreign libc;
#scope_file
libc :: #system_library "libc";
librt :: #system_library "librt";
USE_GNU :: true;
#scope_export
FILE :: _IO_FILE;
_IO_FILE :: struct {};

#if !USE_GNU {
    ftello64 :: ftello;
}

#scope_export
#load "../../linux-stat.jai";
