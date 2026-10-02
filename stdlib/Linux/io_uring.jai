// Normalized API contracts; reference procedure bodies were discarded.
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
STATX_TYPE: u32: 0x00000001;
STATX_MODE: u32: 0x00000002;
STATX_NLINK: u32: 0x00000004;
STATX_UID: u32: 0x00000008;
STATX_GID: u32: 0x00000010;
STATX_ATIME: u32: 0x00000020;
STATX_MTIME: u32: 0x00000040;
STATX_CTIME: u32: 0x00000080;
STATX_INO: u32: 0x00000100;
STATX_SIZE: u32: 0x00000200;
STATX_BLOCKS: u32: 0x00000400;
STATX_BASIC_STATS: u32: 0x000007ff;
STATX_BTIME: u32: 0x00000800;
STATX_MNT_ID: u32: 0x00001000;
STATX__RESERVED: u32: 0x80000000;
STATX_ATTR_COMPRESSED :: 0x00000004;
STATX_ATTR_IMMUTABLE :: 0x00000010;
STATX_ATTR_APPEND :: 0x00000020;
STATX_ATTR_NODUMP :: 0x00000040;
STATX_ATTR_ENCRYPTED :: 0x00000800;
STATX_ATTR_AUTOMOUNT :: 0x00001000;
STATX_ATTR_MOUNT_ROOT :: 0x00002000;
STATX_ATTR_VERITY :: 0x00100000;
STATX_ATTR_DAX :: 0x00200000;
AT_STATX_SYNC_TYPE :: 0x6000;
AT_STATX_SYNC_AS_STAT :: 0x0000;
AT_STATX_FORCE_SYNC :: 0x2000;
AT_STATX_DONT_SYNC :: 0x4000;
SYS_io_uring_setup :: 425;
SYS_io_uring_enter :: 426;
SYS_io_uring_register :: 427;
using __kernel_rwf_t :: enum_flags s32 {
    RWF_HIPRI :: 0x00000001;
    RWF_DSYNC :: 0x00000002;
    RWF_SYNC :: 0x00000004;
    RWF_NOWAIT :: 0x00000008;
    RWF_APPEND :: 0x00000010;
    RWF_SUPPORTED :: RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT | RWF_APPEND;
}
io_uring_params :: struct {
    sq_entries: u32;
    cq_entries: u32;
    flags: IORING_Setup_Flags;
    sq_thread_cpu: u32;
    sq_thread_idle: u32;
    features: IORING_FEAT_Flags;
    wq_fd: s32;
    resv: [3] u32;
    sq_off: io_sqring_offsets;
    cq_off: io_cqring_offsets;
};
using IORING_Setup_Flags :: enum_flags u32 {
    IORING_SETUP_IOPOLL :: 1 << 0;
    IORING_SETUP_SQPOLL :: 1 << 1;
    IORING_SETUP_SQ_AFF :: 1 << 2;
    IORING_SETUP_CQSIZE :: 1 << 3;
    IORING_SETUP_CLAMP :: 1 << 4;
    IORING_SETUP_ATTACH_WQ :: 1 << 5;
    IORING_SETUP_R_DISABLED :: 1 << 6;
    IORING_SETUP_SUBMIT_ALL :: 1 << 7;
    IORING_SETUP_COOP_TASKRUN :: 1 << 8;
    IORING_SETUP_TASKRUN_FLAG :: 1 << 9;
    IORING_SETUP_SQE128 :: 1 << 10;
    IORING_SETUP_CQE32 :: 1 << 11;
}
using IORING_FEAT_Flags :: enum_flags u32 {
    IORING_FEAT_SINGLE_MMAP :: 1 << 0;
    IORING_FEAT_NODROP :: 1 << 1;
    IORING_FEAT_SUBMIT_STABLE :: 1 << 2;
    IORING_FEAT_RW_CUR_POS :: 1 << 3;
    IORING_FEAT_CUR_PERSONALITY :: 1 << 4;
    IORING_FEAT_FAST_POLL :: 1 << 5;
    IORING_FEAT_POLL_32BITS :: 1 << 6;
    IORING_FEAT_SQPOLL_NONFIXED :: 1 << 7;
    IORING_FEAT_EXT_ARG :: 1 << 8;
    IORING_FEAT_NATIVE_WORKERS :: 1 << 9;
    IORING_FEAT_RSRC_TAGS :: 1 << 10;
    IORING_FEAT_CQE_SKIP :: 1 << 11;
    IORING_FEAT_LINKED_FILE :: 1 << 12;
}
io_sqring_offsets :: struct {
    head: u32;
    tail: u32;
    ring_mask: u32;
    ring_entries: u32;
    flags: u32;
    dropped: u32;
    array: u32;
    resv1: u32;
    resv2: u64;
};
using IORING_SQ_Flags :: enum_flags u32 {
    IORING_SQ_NEED_WAKEUP :: 1 << 0;
    IORING_SQ_CQ_OVERFLOW :: 1 << 1;
    IORING_SQ_TASKRUN :: 1 << 2;
}
io_cqring_offsets :: struct {
    head: u32;
    tail: u32;
    ring_mask: u32;
    ring_entries: u32;
    overflow: u32;
    cqes: u32;
    flags: u32;
    resv1: u32;
    resv2: u64;
};
using IORING_CQ_Flags :: enum_flags u32 {
    IORING_CQ_EVENTFD_DISABLED :: 1 << 0;
}
IORING_OFF_SQ_RING: s64: 0;
IORING_OFF_CQ_RING: s64: 0x08000000;
IORING_OFF_SQES: s64: 0x10000000;
io_uring_sqe :: struct {
    opcode: IORING_OP;
    flags: IOSQE_Flags;
    union {
        ioprio: u16;
        accept_flags: IORING_ACCEPT_Flags;
    }
    fd: s32;
    union {
        off: u64;
        addr2: u64;
        recv_send_flags: IORING_RECVSEND_Flags;
    };
    union {
        addr: u64;
        splice_off_in: u64;
    };
    union {
        len: u32;
        poll_flags: IORING_POLL_Flags;
    }
    union {
        rw_flags: __kernel_rwf_t;
        op_flags: IORING_OP_Flags;
        other_flags: u32;
        poll_events: u16;
        fadvise_advice: u32;
    };
    user_data: u64;
    union {
        buf_index: u16 #align 1;
        buf_group: u16 #align 1;
    }
    personality: u16;
    union {
        splice_fd_in: s32;
        file_index: u32;
    };
    addr3: u64;
    __pad2: [1] u64;
};
using IORING_OP :: enum u8 {
    IORING_OP_NOP;
    IORING_OP_READV;
    IORING_OP_WRITEV;
    IORING_OP_FSYNC;
    IORING_OP_READ_FIXED;
    IORING_OP_WRITE_FIXED;
    IORING_OP_POLL_ADD;
    IORING_OP_POLL_REMOVE;
    IORING_OP_SYNC_FILE_RANGE;
    IORING_OP_SENDMSG;
    IORING_OP_RECVMSG;
    IORING_OP_TIMEOUT;
    IORING_OP_TIMEOUT_REMOVE;
    IORING_OP_ACCEPT;
    IORING_OP_ASYNC_CANCEL;
    IORING_OP_LINK_TIMEOUT;
    IORING_OP_CONNECT;
    IORING_OP_FALLOCATE;
    IORING_OP_OPENAT;
    IORING_OP_CLOSE;
    IORING_OP_FILES_UPDATE;
    IORING_OP_STATX;
    IORING_OP_READ;
    IORING_OP_WRITE;
    IORING_OP_FADVISE;
    IORING_OP_MADVISE;
    IORING_OP_SEND;
    IORING_OP_RECV;
    IORING_OP_OPENAT2;
    IORING_OP_EPOLL_CTL;
    IORING_OP_SPLICE;
    IORING_OP_PROVIDE_BUFFERS;
    IORING_OP_REMOVE_BUFFERS;
    IORING_OP_TEE;
    IORING_OP_SHUTDOWN;
    IORING_OP_RENAMEAT;
    IORING_OP_UNLINKAT;
    IORING_OP_MKDIRAT;
    IORING_OP_SYMLINKAT;
    IORING_OP_LINKAT;
    IORING_OP_MSG_RING;
    IORING_OP_FSETXATTR;
    IORING_OP_SETXATTR;
    IORING_OP_FGETXATTR;
    IORING_OP_GETXATTR;
    IORING_OP_SOCKET;
    IORING_OP_URING_CMD;
    IORING_OP_LAST;
}
using IOSQE_Flag_Bits :: enum {
    IOSQE_FIXED_FILE_BIT;
    IOSQE_IO_DRAIN_BIT;
    IOSQE_IO_LINK_BIT;
    IOSQE_IO_HARDLINK_BIT;
    IOSQE_ASYNC_BIT;
    IOSQE_BUFFER_SELECT_BIT;
    IOSQE_CQE_SKIP_SUCCESS_BIT;
};
using IOSQE_Flags :: enum_flags u8 {
    IOSQE_FIXED_FILE :: 1 << IOSQE_FIXED_FILE_BIT;
    IOSQE_IO_DRAIN :: 1 << IOSQE_IO_DRAIN_BIT;
    IOSQE_IO_LINK :: 1 << IOSQE_IO_LINK_BIT;
    IOSQE_IO_HARDLINK :: 1 << IOSQE_IO_HARDLINK_BIT;
    IOSQE_ASYNC :: 1 << IOSQE_ASYNC_BIT;
    IOSQE_BUFFER_SELECT :: 1 << IOSQE_BUFFER_SELECT_BIT;
    IOSQE_CQE_SKIP_SUCCESS :: 1 << IOSQE_CQE_SKIP_SUCCESS_BIT;
}
using IORING_ACCEPT_Flags :: enum_flags u16 {
    IORING_ACCEPT_MULTISHOT :: 1 << 0;
}
IORING_FILE_INDEX_ALLOC: u32: ~cast(u32)0;
using IORING_RECVSEND_Flags :: enum_flags u64 {
    IORING_RECVSEND_POLL_FIRST :: 1 << 0;
}
using IORING_POLL_Flags :: enum_flags u32 {
    IORING_POLL_ADD_MULTI :: 1 << 0;
    IORING_POLL_UPDATE_EVENTS :: 1 << 1;
    IORING_POLL_UPDATE_USER_DATA :: 1 << 2;
}
using IORING_OP_Flags :: enum_flags u32 #specified {
    IORING_CLOSE_FD_AND_FILE_SLOT :: 1 << 0;
    IORING_FSYNC_DATASYNC :: 1 << 0;
    IORING_TIMEOUT_ABS :: 1 << 0;
    IORING_TIMEOUT_UPDATE :: 1 << 1;
    IORING_TIMEOUT_BOOTTIME :: 1 << 2;
    IORING_TIMEOUT_REALTIME :: 1 << 3;
    IORING_LINK_TIMEOUT_UPDATE :: 1 << 4;
    IORING_TIMEOUT_ETIME_SUCCESS :: 1 << 5;
    IORING_TIMEOUT_CLOCK_MASK :: IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME;
    IORING_TIMEOUT_UPDATE_MASK :: IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE;
    SPLICE_F_FD_IN_FIXED :: 1 << 31;
    IORING_ASYNC_CANCEL_ALL :: 1 << 0;
    IORING_ASYNC_CANCEL_FD :: 1 << 1;
    IORING_ASYNC_CANCEL_ANY :: 1 << 2;
}
io_uring_cqe :: struct {
    user_data: u64;
    res: s32;
    flags: IOCQE_Flags;
};
using IOCQE_Flags :: enum_flags u32 {
    IORING_CQE_F_BUFFER :: 1 << 0;
    IORING_CQE_F_MORE :: 1 << 1;
    IORING_CQE_F_SOCK_NONEMPTY :: 1 << 2;
}
using IORING_ENTER :: enum_flags u32 {
    IORING_ENTER_GETEVENTS :: 1 << 0;
    IORING_ENTER_SQ_WAKEUP :: 1 << 1;
    IORING_ENTER_SQ_WAIT :: 1 << 2;
    IORING_ENTER_EXT_ARG :: 1 << 3;
    IORING_ENTER_REGISTERED_RING :: 1 << 4;
}
io_uring_getevents_arg :: struct {
    sigmask: u64;
    sigmask_sz: u32;
    pad: u32;
    ts: u64;
};
using IORING_REGISTER :: enum {
    IORING_REGISTER_BUFFERS :: 0;
    IORING_UNREGISTER_BUFFERS :: 1;
    IORING_REGISTER_FILES :: 2;
    IORING_UNREGISTER_FILES :: 3;
    IORING_REGISTER_EVENTFD :: 4;
    IORING_UNREGISTER_EVENTFD :: 5;
    IORING_REGISTER_FILES_UPDATE :: 6;
    IORING_REGISTER_EVENTFD_ASYNC :: 7;
    IORING_REGISTER_PROBE :: 8;
    IORING_REGISTER_PERSONALITY :: 9;
    IORING_UNREGISTER_PERSONALITY :: 10;
    IORING_REGISTER_RESTRICTIONS :: 11;
    IORING_REGISTER_ENABLE_RINGS :: 12;
    IORING_REGISTER_FILES2 :: 13;
    IORING_REGISTER_FILES_UPDATE2 :: 14;
    IORING_REGISTER_BUFFERS2 :: 15;
    IORING_REGISTER_BUFFERS_UPDATE :: 16;
    IORING_REGISTER_IOWQ_AFF :: 17;
    IORING_UNREGISTER_IOWQ_AFF :: 18;
    IORING_REGISTER_IOWQ_MAX_WORKERS :: 19;
    IORING_REGISTER_RING_FDS :: 20;
    IORING_UNREGISTER_RING_FDS :: 21;
    IORING_REGISTER_PBUF_RING :: 22;
    IORING_UNREGISTER_PBUF_RING :: 23;
    IORING_REGISTER_LAST;
}
using IO_WQ_Categories :: enum {
    IO_WQ_BOUND;
    IO_WQ_UNBOUND;
};
io_uring_files_update :: struct {
    offset: u32;
    resv: u32;
    fds: *s32;
};
io_uring_rsrc_register :: struct {
    nr: u32;
    flags: IORING_RSRC_Flags;
    resv2: u64;
    data: *iovec;
    tags: *u64;
};
using IORING_RSRC_Flags :: enum_flags u32 {
    IORING_RSRC_REGISTER_SPARSE :: 1 << 0;
}
io_uring_rsrc_update :: struct {
    offset: u32;
    resv: u32;
    data: *iovec;
};
io_uring_rsrc_update2 :: struct {
    offset: u32;
    resv: u32;
    data: *iovec;
    tags: *u64;
    nr: u32;
    resv2: u32;
};
IORING_REGISTER_FILES_SKIP: s32: -2;
io_uring_probe :: struct {
    last_op: IORING_OP;
    ops_len: u8;
    resv: u16;
    resv2: [3] u32;
    ops: [0] io_uring_probe_op;
};
io_uring_probe_op :: struct {
    op: IORING_OP;
    resv: u8;
    flags: IO_URING_OP_Flags;
    resv2: u32;
};
using IO_URING_OP_Flags :: enum_flags u16 {
    IO_URING_OP_SUPPORTED :: 1 << 0;
}
io_uring_restriction :: struct {
    opcode: u16;
    union {
        register_op: u8;
        sqe_op: u8;
        sqe_flags: u8;
    };
    resv: u8;
    resv2: [3] u32;
};
using IO_URING_RESTRICTION_OP :: enum {
    IORING_RESTRICTION_REGISTER_OP :: 0;
    IORING_RESTRICTION_SQE_OP :: 1;
    IORING_RESTRICTION_SQE_FLAGS_ALLOWED :: 2;
    IORING_RESTRICTION_SQE_FLAGS_REQUIRED :: 3;
    IORING_RESTRICTION_LAST;
};
io_uring_buf_ring :: struct {
    union {
        struct {
            resv1: u64;
            resv2: u32;
            resv3: u16;
            tail: u16;
        };
        bufs: [0] io_uring_buf;
    };
};
io_uring_buf :: struct {
    addr: u64;
    len: u32;
    bid: u16;
    resv: u16;
};
io_uring_buf_reg :: struct {
    ring_addr: u64;
    ring_entries: u32;
    bgid: u16;
    pad: u16;
    resv: [3] u64;
};

#scope_export
#load "io-uring-syscalls.jai";
