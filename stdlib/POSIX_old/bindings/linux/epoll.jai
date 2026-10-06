// Linux declarations: <sys/epoll.h>.
Epoll_Ctl :: enum s32 {
    ADD :: 1;
    DEL :: 2;
    MOD :: 3;
}
EPOLL_CTL_ADD :: cast(s32) Epoll_Ctl.ADD;
EPOLL_CTL_DEL :: cast(s32) Epoll_Ctl.DEL;
EPOLL_CTL_MOD :: cast(s32) Epoll_Ctl.MOD;
EPOLLIN: u32 : 0x0001;
EPOLLPRI: u32 : 0x0002;
EPOLLOUT: u32 : 0x0004;
EPOLLERR: u32 : 0x0008;
EPOLLHUP: u32 : 0x0010;
EPOLLNVAL: u32 : 0x0020;
EPOLLRDNORM: u32 : 0x0040;
EPOLLRDBAND: u32 : 0x0080;
EPOLLWRNORM: u32 : 0x0100;
EPOLLWRBAND: u32 : 0x0200;
EPOLLMSG: u32 : 0x0400;
EPOLLRDHUP: u32 : 0x2000;
EPOLL_URING_WAKE: u32 : 1 << 27;
EPOLLEXCLUSIVE: u32 : 1 << 28;
EPOLLWAKEUP: u32 : 1 << 29;
EPOLLONESHOT: u32 : 1 << 30;
EPOLLET: u32 : 1 << 31;
EPOLL_CLOEXEC: s32 : 0x80000;
epoll_data :: union {
    ptr: *void;
    fd: s32;
    _u32: u32;
    _u64: u64;
}
epoll_event :: struct {
    events: u32;
    data: epoll_data #align 4;
}
epoll_create :: (size: s32) -> s32 #foreign libc;
epoll_create1 :: (flags: s32) -> s32 #foreign libc;
epoll_ctl :: (epfd: s32, op: Epoll_Ctl, fd: s32, event: *epoll_event) -> s32 #foreign libc;
epoll_ctl :: (epfd: s32, op: s32, fd: s32, event: *epoll_event) -> s32 #foreign libc #deprecated "Use the variant that takes Epoll_Ctl";
epoll_wait :: (epfd: s32, events: *epoll_event, maxevents: s32, timeout: s32) -> s32 #foreign libc;
epoll_pwait :: (epfd: s32, events: *epoll_event, maxevents: s32, timeout: s32, sigmask: *sigset_t) -> s32 #foreign libc;
#scope_file
libc :: #system_library "libc";
