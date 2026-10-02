// Normalized API contracts; reference procedure bodies were discarded.
kqueue :: () -> s32 #foreign libc;
kevent64 :: (kq: s32, changelist: *Kevent64, nchanges: s32, eventlist: *Kevent64, nevents: s32, flags: Kevent_Call_Flags, timeout: *timespec) -> s32 #foreign libc;
Kevent_Call_Flags :: enum_flags u32 {
    KEVENT_FLAG_NONE :: 0x000000;
    KEVENT_FLAG_IMMEDIATE :: 0x000001;
    KEVENT_FLAG_ERROR_EVENTS :: 0x000002;
}
Kevent64 :: struct {
    ident: u64;
    filter: Kevent_Filter;
    flags: Kevent_Flags;
    fflags: Kevent_Fflags;
    data: s64;
    udata: *void;
    ext: [2] u64;
}
Kevent_Filter :: enum s16 {
    READ :: -1;
    WRITE :: -2;
    AIO :: -3;
    VNODE :: -4;
    PROC :: -5;
    SIGNAL :: -6;
    TIMER :: -7;
    MACHPORT :: -8;
    FS :: -9;
    USER :: -10;
    VM :: -12;
    EXCEPT :: -15;
}
Kevent_Flags :: enum_flags u16 {
    ADD :: 0x0001;
    DELETE :: 0x0002;
    ENABLE :: 0x0004;
    DISABLE :: 0x0008;
    ONESHOT :: 0x0010;
    CLEAR :: 0x0020;
    RECEIPT :: 0x0040;
    DISPATCH :: 0x0080;
    UDATA_SPECIFIC :: 0x0100;
    DISPATCH2 :: (DISPATCH | UDATA_SPECIFIC);
    VANISHED :: 0x0200;
    SYSFLAGS :: 0xF000;
    FLAG0 :: 0x1000;
    FLAG1 :: 0x2000;
    ERROR :: 0x4000;
    EOF :: 0x8000;
    POLL :: FLAG0;
    OOBAND :: FLAG1;
}
Kevent_Fflags :: enum_flags u32 {
    LOWAT :: 0x00000001;
    EXIT :: 0x80000000;
    FORK :: 0x40000000;
    EXEC :: 0x20000000;
    SIGNAL :: 0x08000000;
    EXITSTATUS :: 0x04000000;
    EXIT_DETAIL :: 0x02000000;
    PDATAMASK :: 0x000fffff;
    PCTRLMASK :: (~PDATAMASK);
    EXIT_DETAIL_MASK :: 0x00070000;
    EXIT_DECRYPTFAIL :: 0x00010000;
    EXIT_MEMORY :: 0x00020000;
    EXIT_CSERROR :: 0x00040000;
    VM_PRESSURE :: 0x80000000;
    VM_PRESSURE_TERMINATE :: 0x40000000;
    VM_PRESSURE_SUDDEN_TERMINATE :: 0x20000000;
    VM_ERROR :: 0x10000000;
    SECONDS :: 0x00000001;
    USECONDS :: 0x00000002;
    NSECONDS :: 0x00000004;
    ABSOLUTE :: 0x00000008;
    LEEWAY :: 0x00000010;
    CRITICAL :: 0x00000020;
    BACKGROUND :: 0x00000040;
    MACH_CONTINUOUS_TIME :: 0x00000080;
    MACHTIME :: 0x00000100;
    TRIGGER :: 0x01000000;
    FFNOP :: 0x00000000;
    FFAND :: 0x40000000;
    FFOR :: 0x80000000;
    FFCOPY :: 0xc0000000;
    FFCTRLMASK :: 0xc0000000;
    FFLAGSMASK :: 0x00ffffff;
}
#scope_file
libc :: #system_library "libc";
