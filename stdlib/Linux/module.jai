// Linux-specific system interfaces on top of POSIX.
#scope_file
POSIX :: #import "POSIX";

timeval :: POSIX.timeval;
libc :: #system_library "libc";
#scope_export
KERN_SUCCESS :: 0;

inotify_event :: struct {
    wd: s32;
    mask: u32;
    cookie: u32;
    len: u32;
    name: [0] u8; // C flexible array: `len` bytes follow the 16-byte header.
}

IN_CLOEXEC :: 0x80000;
IN_NONBLOCK :: 0x00800;
IN_ACCESS :: 0x00000001;
IN_MODIFY :: 0x00000002;
IN_ATTRIB :: 0x00000004;
IN_CLOSE_WRITE :: 0x00000008;
IN_CLOSE_NOWRITE :: 0x00000010;
IN_CLOSE :: (IN_CLOSE_WRITE | IN_CLOSE_NOWRITE);
IN_OPEN :: 0x00000020;
IN_MOVED_FROM :: 0x00000040;
IN_MOVED_TO :: 0x00000080;
IN_MOVE :: (IN_MOVED_FROM | IN_MOVED_TO);
IN_CREATE :: 0x00000100;
IN_DELETE :: 0x00000200;
IN_DELETE_SELF :: 0x00000400;
IN_MOVE_SELF :: 0x00000800;
IN_UNMOUNT :: 0x00002000;
IN_Q_OVERFLOW :: 0x00004000;
IN_IGNORED :: 0x00008000;
IN_ONLYDIR :: 0x01000000;
IN_DONT_FOLLOW :: 0x02000000;
IN_EXCL_UNLINK :: 0x04000000;
IN_MASK_ADD :: 0x20000000;
IN_ISDIR :: 0x40000000;
IN_ONESHOT :: 0x80000000;

IN_ALL_EVENTS :: (IN_ACCESS | IN_MODIFY | IN_ATTRIB | IN_CLOSE_WRITE | IN_CLOSE_NOWRITE | IN_OPEN | IN_MOVED_FROM
| IN_MOVED_TO | IN_CREATE | IN_DELETE | IN_DELETE_SELF | IN_MOVE_SELF);

inotify_init :: (flags: s32 = 0) -> s32 #foreign libc "inotify_init1";
inotify_add_watch :: (fd: s32, pathname: *u8, mask: u32) -> s32 #foreign libc;
inotify_rm_watch :: (fd: s32, wd: s32) -> s32 #foreign libc;

sys_info :: struct {
    uptime: s64;
    loads: [3] u64;
    totalram: u64;
    freeram: u64;
    sharedram: u64;
    bufferram: u64;
    totalswap: u64;
    freeswap: u64;
    procs: u16;
    pad: u16;
    totalhigh: u64;
    freehigh: u64;
    mem_unit: u32;
    _f: [20 - 2 * size_of(u64) - size_of(u32)] s8;
}

sysinfo :: (info: *sys_info) -> s32 #foreign libc;

input_absinfo :: struct {
    value: s32;
    minimum: s32;
    maximum: s32;
    fuzz: s32;
    flat: s32;
    resolution: s32;
}

input_event :: struct {
    time: timeval;
    type: u16;
    code: u16;
    value: s32;
}

EV_SYN :: 0x00;
EV_KEY :: 0x01;
EV_REL :: 0x02;
EV_ABS :: 0x03;
EV_MSC :: 0x04;
EV_SW :: 0x05;
EV_LED :: 0x11;
EV_SND :: 0x12;
EV_REP :: 0x14;
EV_FF :: 0x15;
EV_PWR :: 0x16;
EV_FF_STATUS :: 0x17;
EV_MAX :: 0x1f;
EV_CNT :: EV_MAX + 1;
ABS_HAT0X :: 0x10;
ABS_HAT0Y :: 0x11;
ABS_HAT1X :: 0x12;
ABS_HAT1Y :: 0x13;
ABS_HAT2X :: 0x14;
ABS_HAT2Y :: 0x15;
ABS_HAT3X :: 0x16;
ABS_HAT3Y :: 0x17;
BTN_MISC :: 0x100;
BTN_JOYSTICK :: 0x120;
KEY_MAX :: 0x2ff;
ABS_MAX :: 0x3f;

#load "io_uring.jai";
#load "epoll.jai";
#import "POSIX";
