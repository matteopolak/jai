// macOS arm64 declarations: <sys/sysctl.h>.
ucred :: struct {}
P_TRACED :: 0x00000800;
CTL_MAXNAME :: 12;
CTLTYPE :: 0xf;
CTLTYPE_NODE :: 1;
CTLTYPE_INT :: 2;
CTLTYPE_STRING :: 3;
CTLTYPE_QUAD :: 4;
CTLTYPE_OPAQUE :: 5;
CTLTYPE_STRUCT :: CTLTYPE_OPAQUE;
CTLFLAG_RD :: 0x80000000;
CTLFLAG_WR :: 0x40000000;
CTLFLAG_RW :: CTLFLAG_RD | CTLFLAG_WR;
CTLFLAG_NOLOCK :: 0x20000000;
CTLFLAG_ANYBODY :: 0x10000000;
CTLFLAG_SECURE :: 0x08000000;
CTLFLAG_MASKED :: 0x04000000;
CTLFLAG_NOAUTO :: 0x02000000;
CTLFLAG_KERN :: 0x01000000;
CTLFLAG_LOCKED :: 0x00800000;
CTLFLAG_OID2 :: 0x00400000;
OID_AUTO :: -1;
OID_AUTO_START :: 100;
CTL_UNSPEC :: 0;
CTL_KERN :: 1;
CTL_VM :: 2;
CTL_VFS :: 3;
CTL_NET :: 4;
CTL_DEBUG :: 5;
CTL_HW :: 6;
CTL_MACHDEP :: 7;
CTL_USER :: 8;
CTL_MAXID :: 9;
KERN_OSTYPE :: 1;
KERN_OSRELEASE :: 2;
KERN_OSREV :: 3;
KERN_VERSION :: 4;
KERN_MAXVNODES :: 5;
KERN_MAXPROC :: 6;
KERN_MAXFILES :: 7;
KERN_ARGMAX :: 8;
KERN_SECURELVL :: 9;
KERN_HOSTNAME :: 10;
KERN_HOSTID :: 11;
KERN_CLOCKRATE :: 12;
KERN_VNODE :: 13;
KERN_PROC :: 14;
KERN_FILE :: 15;
KERN_PROF :: 16;
KERN_POSIX1 :: 17;
KERN_NGROUPS :: 18;
KERN_JOB_CONTROL :: 19;
KERN_SAVED_IDS :: 20;
KERN_BOOTTIME :: 21;
KERN_NISDOMAINNAME :: 22;
KERN_DOMAINNAME :: KERN_NISDOMAINNAME;
KERN_MAXPARTITIONS :: 23;
KERN_KDEBUG :: 24;
KERN_UPDATEINTERVAL :: 25;
KERN_OSRELDATE :: 26;
KERN_NTP_PLL :: 27;
KERN_BOOTFILE :: 28;
KERN_MAXFILESPERPROC :: 29;
KERN_MAXPROCPERUID :: 30;
KERN_DUMPDEV :: 31;
KERN_IPC :: 32;
KERN_DUMMY :: 33;
KERN_PS_STRINGS :: 34;
KERN_USRSTACK32 :: 35;
KERN_LOGSIGEXIT :: 36;
KERN_SYMFILE :: 37;
KERN_PROCARGS :: 38;
KERN_NETBOOT :: 40;
KERN_SYSV :: 42;
KERN_AFFINITY :: 43;
KERN_TRANSLATE :: 44;
KERN_CLASSIC :: KERN_TRANSLATE;
KERN_EXEC :: 45;
KERN_CLASSICHANDLER :: KERN_EXEC;
KERN_AIOMAX :: 46;
KERN_AIOPROCMAX :: 47;
KERN_AIOTHREADS :: 48;
KERN_PROCARGS2 :: 49;
KERN_COREFILE :: 50;
KERN_COREDUMP :: 51;
KERN_SUGID_COREDUMP :: 52;
KERN_PROCDELAYTERM :: 53;
KERN_SHREG_PRIVATIZABLE :: 54;
KERN_LOW_PRI_WINDOW :: 56;
KERN_LOW_PRI_DELAY :: 57;
KERN_POSIX :: 58;
KERN_USRSTACK64 :: 59;
KERN_NX_PROTECTION :: 60;
KERN_TFP :: 61;
KERN_PROCNAME :: 62;
KERN_THALTSTACK :: 63;
KERN_SPECULATIVE_READS :: 64;
KERN_OSVERSION :: 65;
KERN_SAFEBOOT :: 66;
KERN_RAGEVNODE :: 68;
KERN_TTY :: 69;
KERN_CHECKOPENEVT :: 70;
KERN_THREADNAME :: 71;
KERN_MAXID :: 72;
KERN_USRSTACK :: KERN_USRSTACK64;
KERN_RAGE_PROC :: 1;
KERN_RAGE_THREAD :: 2;
KERN_UNRAGE_PROC :: 3;
KERN_UNRAGE_THREAD :: 4;
KERN_OPENEVT_PROC :: 1;
KERN_UNOPENEVT_PROC :: 2;
KERN_TFP_POLICY :: 1;
KERN_TFP_POLICY_DENY :: 0;
KERN_TFP_POLICY_DEFAULT :: 2;
KERN_KDEFLAGS :: 1;
KERN_KDDFLAGS :: 2;
KERN_KDENABLE :: 3;
KERN_KDSETBUF :: 4;
KERN_KDGETBUF :: 5;
KERN_KDSETUP :: 6;
KERN_KDREMOVE :: 7;
KERN_KDSETREG :: 8;
KERN_KDGETREG :: 9;
KERN_KDREADTR :: 10;
KERN_KDPIDTR :: 11;
KERN_KDTHRMAP :: 12;
KERN_KDPIDEX :: 14;
KERN_KDSETRTCDEC :: 15;
KERN_KDGETENTROPY :: 16;
KERN_KDWRITETR :: 17;
KERN_KDWRITEMAP :: 18;
KERN_KDTEST :: 19;
KERN_KDREADCURTHRMAP :: 21;
KERN_KDSET_TYPEFILTER :: 22;
KERN_KDBUFWAIT :: 23;
KERN_KDCPUMAP :: 24;
KERN_KDWRITEMAP_V3 :: 27;
KERN_KDWRITETR_V3 :: 28;
KERN_PROC_ALL :: 0;
KERN_PROC_PID :: 1;
KERN_PROC_PGRP :: 2;
KERN_PROC_SESSION :: 3;
KERN_PROC_TTY :: 4;
KERN_PROC_UID :: 5;
KERN_PROC_RUID :: 6;
KERN_PROC_LCID :: 7;
KERN_VFSNSPACE_HANDLE_PROC :: 1;
KERN_VFSNSPACE_UNHANDLE_PROC :: 2;
WMESGLEN :: 7;
EPROC_CTTY :: 0x01;
EPROC_SLEADER :: 0x02;
COMAPT_MAXLOGNAME :: 12;
KIPC_MAXSOCKBUF :: 1;
KIPC_SOCKBUF_WASTE :: 2;
KIPC_SOMAXCONN :: 3;
KIPC_MAX_LINKHDR :: 4;
KIPC_MAX_PROTOHDR :: 5;
KIPC_MAX_HDR :: 6;
KIPC_MAX_DATALEN :: 7;
KIPC_MBSTAT :: 8;
KIPC_NMBCLUSTERS :: 9;
KIPC_SOQLIMITCOMPAT :: 10;
VM_METER :: 1;
VM_LOADAVG :: 2;
VM_MACHFACTOR :: 4;
VM_SWAPUSAGE :: 5;
VM_MAXID :: 6;
LSCALE :: 1000;
HW_MACHINE :: 1;
HW_MODEL :: 2;
HW_NCPU :: 3;
HW_BYTEORDER :: 4;
HW_PHYSMEM :: 5;
HW_USERMEM :: 6;
HW_PAGESIZE :: 7;
HW_DISKNAMES :: 8;
HW_DISKSTATS :: 9;
HW_EPOCH :: 10;
HW_FLOATINGPT :: 11;
HW_MACHINE_ARCH :: 12;
HW_VECTORUNIT :: 13;
HW_BUS_FREQ :: 14;
HW_CPU_FREQ :: 15;
HW_CACHELINE :: 16;
HW_L1ICACHESIZE :: 17;
HW_L1DCACHESIZE :: 18;
HW_L2SETTINGS :: 19;
HW_L2CACHESIZE :: 20;
HW_L3SETTINGS :: 21;
HW_L3CACHESIZE :: 22;
HW_TB_FREQ :: 23;
HW_MEMSIZE :: 24;
HW_AVAILCPU :: 25;
HW_TARGET :: 26;
HW_PRODUCT :: 27;
HW_MAXID :: 28;
USER_CS_PATH :: 1;
USER_BC_BASE_MAX :: 2;
USER_BC_DIM_MAX :: 3;
USER_BC_SCALE_MAX :: 4;
USER_BC_STRING_MAX :: 5;
USER_COLL_WEIGHTS_MAX :: 6;
USER_EXPR_NEST_MAX :: 7;
USER_LINE_MAX :: 8;
USER_RE_DUP_MAX :: 9;
USER_POSIX2_VERSION :: 10;
USER_POSIX2_C_BIND :: 11;
USER_POSIX2_C_DEV :: 12;
USER_POSIX2_CHAR_TERM :: 13;
USER_POSIX2_FORT_DEV :: 14;
USER_POSIX2_FORT_RUN :: 15;
USER_POSIX2_LOCALEDEF :: 16;
USER_POSIX2_SW_DEV :: 17;
USER_POSIX2_UPE :: 18;
USER_STREAM_MAX :: 19;
USER_TZNAME_MAX :: 20;
USER_MAXID :: 21;
CTL_DEBUG_NAME :: 0;
CTL_DEBUG_VALUE :: 1;
CTL_DEBUG_MAXID :: 20;
session :: struct {}
pgrp :: struct {}
proc :: struct {}

extern_proc :: struct {
    p_un: union {
        p_st1: struct {
            __p_forw: *proc;
            __p_back: *proc;
        };
        __p_starttime: timeval;
    };
    p_vmspace: *vmspace;
    sigacts :: struct {}
    p_sigacts: *sigacts;
    p_flag: s32;
    p_stat: u8;
    p_pid: pid_t;
    p_oppid: pid_t;
    p_dupfd: s32;
    user_stack: *u8;
    exit_thread: *void;
    p_debugger: s32;
    sigwait: s32;
    p_estcpu: u32;
    p_cpticks: s32;
    p_pctcpu: fixpt_t;
    p_wchan: *void;
    p_wmesg: *u8;
    p_swtime: u32;
    p_slptime: u32;
    p_realtimer: itimerval;
    p_rtime: timeval;
    p_uticks: u64;
    p_sticks: u64;
    p_iticks: u64;
    p_traceflag: s32;
    vnode :: struct {}
    p_tracep: *vnode;
    p_siglist: s32;
    p_textvp: *vnode;
    p_holdcnt: s32;
    p_sigmask: sigset_t;
    p_sigignore: sigset_t;
    p_sigcatch: sigset_t;
    p_priority: u8;
    p_usrpri: u8;
    p_nice: u8;
    p_comm: [17] u8;
    p_pgrp: *pgrp;
    user :: struct {}
    p_addr: *user;
    p_xstat: u16;
    p_acflag: u16;
    rusage :: struct {}
    p_ru: *rusage;
}

vmspace :: struct {
    dummy: s32;
    dummy2: *u8;
    dummy3: [5] s32;
    dummy4: [3] *u8;
}

ctlname :: struct {
    ctl_name: *u8;
    ctl_type: s32;
}

_pcred :: struct {
    pc_lock: [72] u8;
    pc_ucred: *ucred;
    p_ruid: uid_t;
    p_svuid: uid_t;
    p_rgid: gid_t;
    p_svgid: gid_t;
    p_refcnt: s32;
}

_ucred :: struct {
    cr_ref: s32;
    cr_uid: uid_t;
    cr_ngroups: s16;
    cr_groups: [16] gid_t;
}

kinfo_proc :: struct {
    kp_proc: extern_proc;
    eproc :: struct {
        e_paddr: *proc;
        e_sess: *session;
        e_pcred: _pcred;
        e_ucred: _ucred;
        e_vm: vmspace;
        e_ppid: pid_t;
        e_pgid: pid_t;
        e_jobc: s16;
        e_tdev: dev_t;
        e_tpgid: pid_t;
        e_tsess: *session;
        e_wmesg: [8] u8;
        e_xsize: segsz_t;
        e_xrssize: s16;
        e_xccount: s16;
        e_xswrss: s16;
        e_flag: s32;
        e_login: [12] u8;
        e_spare: [4] s32;
    }
    kp_eproc: eproc;
}

xsw_usage :: struct {
    xsu_total: u64;
    xsu_avail: u64;
    xsu_used: u64;
    xsu_pagesize: u32;
    xsu_encrypted: s32;
}

loadavg :: struct {
    ldavg: [3] fixpt_t;
    fscale: s64;
}

sysctl :: (unknown0: *s32, unknown1: u32, unknown2: *void, unknown3: *u64, unknown4: *void, unknown5: u64) -> s32 #foreign libc;
sysctlbyname :: (unknown0: *u8, unknown1: *void, unknown2: *u64, unknown3: *void, unknown4: u64) -> s32 #foreign libc;
sysctlnametomib :: (unknown0: *u8, unknown1: *s32, unknown2: *u64) -> s32 #foreign libc;
#scope_file
libc :: #system_library "libc";
