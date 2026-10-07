// Mach kernel interfaces (tasks, ports, timebase).
mach_task_self :: () -> mach_port_t #foreign libc;
kern_return_t :: KERN;
NDR_PROTOCOL_2_0 :: 0;
NDR_INT_BIG_ENDIAN :: 0;
NDR_INT_LITTLE_ENDIAN :: 1;
NDR_FLOAT_IEEE :: 0;
NDR_FLOAT_VAX :: 1;
NDR_FLOAT_CRAY :: 2;
NDR_FLOAT_IBM :: 3;
NDR_CHAR_ASCII :: 0;
NDR_CHAR_EBCDIC :: 1;
__NDR_convert__ :: 0;
__NDR_convert__int_rep__ :: __NDR_convert__;
__NDR_convert__char_rep__ :: 0;
__NDR_convert__float_rep__ :: 0;

KERN :: enum {
    SUCCESS :: 0;
    INVALID_ADDRESS :: 1;
    PROTECTION_FAILURE :: 2;
    NO_SPACE :: 3;
    INVALID_ARGUMENT :: 4;
    FAILURE :: 5;
    RESOURCE_SHORTAGE :: 6;
    NOT_RECEIVER :: 7;
    NO_ACCESS :: 8;
    MEMORY_FAILURE :: 9;
    MEMORY_ERROR :: 10;
    ALREADY_IN_SET :: 11;
    NOT_IN_SET :: 12;
    NAME_EXISTS :: 13;
    ABORTED :: 14;
    INVALID_NAME :: 15;
    INVALID_TASK :: 16;
    INVALID_RIGHT :: 17;
    INVALID_VALUE :: 18;
    UREFS_OVERFLOW :: 19;
    INVALID_CAPABILITY :: 20;
    RIGHT_EXISTS :: 21;
    INVALID_HOST :: 22;
    MEMORY_PRESENT :: 23;
    MEMORY_DATA_MOVED :: 24;
    MEMORY_RESTART_COPY :: 25;
    INVALID_PROCESSOR_SET :: 26;
    POLICY_LIMIT :: 27;
    INVALID_POLICY :: 28;
    INVALID_OBJECT :: 29;
    ALREADY_WAITING :: 30;
    DEFAULT_SET :: 31;
    EXCEPTION_PROTECTED :: 32;
    INVALID_LEDGER :: 33;
    INVALID_MEMORY_CONTROL :: 34;
    INVALID_SECURITY :: 35;
    NOT_DEPRESSED :: 36;
    TERMINATED :: 37;
    LOCK_SET_DESTROYED :: 38;
    LOCK_UNSTABLE :: 39;
    LOCK_OWNED :: 40;
    LOCK_OWNED_SELF :: 41;
    SEMAPHORE_DESTROYED :: 42;
    RPC_SERVER_TERMINATED :: 43;
    RPC_TERMINATE_ORPHAN :: 44;
    RPC_CONTINUE_ORPHAN :: 45;
    NOT_SUPPORTED :: 46;
    NODE_DOWN :: 47;
    NOT_WAITING :: 48;
    OPERATION_TIMED_OUT :: 49;
    CODESIGN_ERROR :: 50;
    POLICY_STATIC :: 51;
    INSUFFICIENT_BUFFER_SIZE :: 52;
    RETURN_MAX :: 0x100;
    CODE_SELECTOR :: 0x0008;
    DATA_SELECTOR :: 0x0010;
    KERN_SUCCESS :: SUCCESS;
    KERN_INVALID_ADDRESS :: INVALID_ADDRESS;
    KERN_PROTECTION_FAILURE :: PROTECTION_FAILURE;
    KERN_NO_SPACE :: NO_SPACE;
    KERN_INVALID_ARGUMENT :: INVALID_ARGUMENT;
    KERN_FAILURE :: FAILURE;
    KERN_RESOURCE_SHORTAGE :: RESOURCE_SHORTAGE;
    KERN_NOT_RECEIVER :: NOT_RECEIVER;
    KERN_NO_ACCESS :: NO_ACCESS;
    KERN_MEMORY_FAILURE :: MEMORY_FAILURE;
    KERN_MEMORY_ERROR :: MEMORY_ERROR;
    KERN_ALREADY_IN_SET :: ALREADY_IN_SET;
    KERN_NOT_IN_SET :: NOT_IN_SET;
    KERN_NAME_EXISTS :: NAME_EXISTS;
    KERN_ABORTED :: ABORTED;
    KERN_INVALID_NAME :: INVALID_NAME;
    KERN_INVALID_TASK :: INVALID_TASK;
    KERN_INVALID_RIGHT :: INVALID_RIGHT;
    KERN_INVALID_VALUE :: INVALID_VALUE;
    KERN_UREFS_OVERFLOW :: UREFS_OVERFLOW;
    KERN_INVALID_CAPABILITY :: INVALID_CAPABILITY;
    KERN_RIGHT_EXISTS :: RIGHT_EXISTS;
    KERN_INVALID_HOST :: INVALID_HOST;
    KERN_MEMORY_PRESENT :: MEMORY_PRESENT;
    KERN_MEMORY_DATA_MOVED :: MEMORY_DATA_MOVED;
    KERN_MEMORY_RESTART_COPY :: MEMORY_RESTART_COPY;
    KERN_INVALID_PROCESSOR_SET :: INVALID_PROCESSOR_SET;
    KERN_POLICY_LIMIT :: POLICY_LIMIT;
    KERN_INVALID_POLICY :: INVALID_POLICY;
    KERN_INVALID_OBJECT :: INVALID_OBJECT;
    KERN_ALREADY_WAITING :: ALREADY_WAITING;
    KERN_DEFAULT_SET :: DEFAULT_SET;
    KERN_EXCEPTION_PROTECTED :: EXCEPTION_PROTECTED;
    KERN_INVALID_LEDGER :: INVALID_LEDGER;
    KERN_INVALID_MEMORY_CONTROL :: INVALID_MEMORY_CONTROL;
    KERN_INVALID_SECURITY :: INVALID_SECURITY;
    KERN_NOT_DEPRESSED :: NOT_DEPRESSED;
    KERN_TERMINATED :: TERMINATED;
    KERN_LOCK_SET_DESTROYED :: LOCK_SET_DESTROYED;
    KERN_LOCK_UNSTABLE :: LOCK_UNSTABLE;
    KERN_LOCK_OWNED :: LOCK_OWNED;
    KERN_LOCK_OWNED_SELF :: LOCK_OWNED_SELF;
    KERN_SEMAPHORE_DESTROYED :: SEMAPHORE_DESTROYED;
    KERN_RPC_SERVER_TERMINATED :: RPC_SERVER_TERMINATED;
    KERN_RPC_TERMINATE_ORPHAN :: RPC_TERMINATE_ORPHAN;
    KERN_RPC_CONTINUE_ORPHAN :: RPC_CONTINUE_ORPHAN;
    KERN_NOT_SUPPORTED :: NOT_SUPPORTED;
    KERN_NODE_DOWN :: NODE_DOWN;
    KERN_NOT_WAITING :: NOT_WAITING;
    KERN_OPERATION_TIMED_OUT :: OPERATION_TIMED_OUT;
    KERN_CODESIGN_ERROR :: CODESIGN_ERROR;
    KERN_POLICY_STATIC :: POLICY_STATIC;
    KERN_INSUFFICIENT_BUFFER_SIZE :: INSUFFICIENT_BUFFER_SIZE;
    KERN_RETURN_MAX :: RETURN_MAX;
    KERN_CODE_SELECTOR :: CODE_SELECTOR;
    KERN_DATA_SELECTOR :: DATA_SELECTOR;
}

MACH_PORT_NULL :: 0;
MACH_PORT_DEAD :: cast,trunc(mach_port_name_t) ~0;
MACH_PORT_RIGHT_SEND :: cast(mach_port_right_t) 0;
MACH_PORT_RIGHT_RECEIVE :: cast(mach_port_right_t) 1;
MACH_PORT_RIGHT_SEND_ONCE :: cast(mach_port_right_t) 2;
MACH_PORT_RIGHT_PORT_SET :: cast(mach_port_right_t) 3;
MACH_PORT_RIGHT_DEAD_NAME :: cast(mach_port_right_t) 4;
MACH_PORT_RIGHT_LABELH :: cast(mach_port_right_t) 5;
MACH_PORT_RIGHT_NUMBER :: cast(mach_port_right_t) 6;
MACH_PORT_TYPE_NONE :: cast(mach_port_type_t) 0;
MACH_PORT_TYPE_DNREQUEST :: 0x80000000;
MACH_PORT_TYPE_SPREQUEST :: 0x40000000;
MACH_PORT_TYPE_SPREQUEST_DELAYED :: 0x20000000;
MACH_PORT_SRIGHTS_NONE :: 0;
MACH_PORT_SRIGHTS_PRESENT :: 1;
MACH_PORT_QLIMIT_ZERO :: 0;
MACH_PORT_QLIMIT_BASIC :: 5;
MACH_PORT_QLIMIT_SMALL :: 16;
MACH_PORT_QLIMIT_LARGE :: 1024;
MACH_PORT_QLIMIT_KERNEL :: 65534;
MACH_PORT_QLIMIT_MIN :: MACH_PORT_QLIMIT_ZERO;
MACH_PORT_QLIMIT_DEFAULT :: MACH_PORT_QLIMIT_BASIC;
MACH_PORT_QLIMIT_MAX :: MACH_PORT_QLIMIT_LARGE;
MACH_PORT_STATUS_FLAG_TEMPOWNER :: 0x01;
MACH_PORT_STATUS_FLAG_GUARDED :: 0x02;
MACH_PORT_STATUS_FLAG_STRICT_GUARD :: 0x04;
MACH_PORT_STATUS_FLAG_IMP_DONATION :: 0x08;
MACH_PORT_STATUS_FLAG_REVIVE :: 0x10;
MACH_PORT_STATUS_FLAG_TASKPTR :: 0x20;
MACH_PORT_LIMITS_INFO :: 1;
MACH_PORT_RECEIVE_STATUS :: 2;
MACH_PORT_DNREQUESTS_SIZE :: 3;
MACH_PORT_TEMPOWNER :: 4;
MACH_PORT_IMPORTANCE_RECEIVER :: 5;
MACH_PORT_DENAP_RECEIVER :: 6;
MACH_PORT_INFO_EXT :: 7;
MACH_PORT_DNREQUESTS_SIZE_COUNT :: 1;
MPO_CONTEXT_AS_GUARD :: 0x01;
MPO_QLIMIT :: 0x02;
MPO_TEMPOWNER :: 0x04;
MPO_IMPORTANCE_RECEIVER :: 0x08;
MPO_INSERT_SEND_RIGHT :: 0x10;
MPO_STRICT :: 0x20;
MPO_DENAP_RECEIVER :: 0x40;
GUARD_TYPE_MACH_PORT :: 0x1;
MACH_MSG_TIMEOUT_NONE :: cast(mach_msg_timeout_t) 0;
MACH_MSGH_BITS_ZERO :: 0x00000000;
MACH_MSGH_BITS_REMOTE_MASK :: 0x0000001f;
MACH_MSGH_BITS_LOCAL_MASK :: 0x00001f00;
MACH_MSGH_BITS_VOUCHER_MASK :: 0x001f0000;
MACH_MSGH_BITS_PORTS_MASK :: MACH_MSGH_BITS_REMOTE_MASK | MACH_MSGH_BITS_LOCAL_MASK | MACH_MSGH_BITS_VOUCHER_MASK;
MACH_MSGH_BITS_COMPLEX :: 0x80000000;
MACH_MSGH_BITS_USER :: 0x801f1f1f;
MACH_MSGH_BITS_RAISEIMP :: 0x20000000;
MACH_MSGH_BITS_DENAP :: MACH_MSGH_BITS_RAISEIMP;
MACH_MSGH_BITS_IMPHOLDASRT :: 0x10000000;
MACH_MSGH_BITS_DENAPHOLDASRT :: MACH_MSGH_BITS_IMPHOLDASRT;
MACH_MSGH_BITS_CIRCULAR :: 0x10000000;
MACH_MSGH_BITS_USED :: 0xb01f1f1f;
MACH_MSG_SIZE_NULL :: cast(*mach_msg_size_t) 0;
MACH_MSG_PRIORITY_UNSPECIFIED :: cast(mach_msg_priority_t) 0;
MACH_MSG_TYPE_MOVE_RECEIVE :: 16;
MACH_MSG_TYPE_MOVE_SEND :: 17;
MACH_MSG_TYPE_MOVE_SEND_ONCE :: 18;
MACH_MSG_TYPE_COPY_SEND :: 19;
MACH_MSG_TYPE_MAKE_SEND :: 20;
MACH_MSG_TYPE_MAKE_SEND_ONCE :: 21;
MACH_MSG_TYPE_COPY_RECEIVE :: 22;
MACH_MSG_TYPE_DISPOSE_RECEIVE :: 24;
MACH_MSG_TYPE_DISPOSE_SEND :: 25;
MACH_MSG_TYPE_DISPOSE_SEND_ONCE :: 26;
MACH_MSG_PHYSICAL_COPY :: 0;
MACH_MSG_VIRTUAL_COPY :: 1;
MACH_MSG_ALLOCATE :: 2;
MACH_MSG_OVERWRITE :: 3;
MACH_MSG_PORT_DESCRIPTOR :: 0;
MACH_MSG_OOL_DESCRIPTOR :: 1;
MACH_MSG_OOL_PORTS_DESCRIPTOR :: 2;
MACH_MSG_OOL_VOLATILE_DESCRIPTOR :: 3;
MACH_MSG_BODY_NULL :: cast(*mach_msg_body_t) 0;
MACH_MSG_DESCRIPTOR_NULL :: cast(*mach_msg_descriptor_t) 0;
MACH_MSG_NULL :: cast(*mach_msg_header_t) 0;
MACH_MSG_TRAILER_FORMAT_0 :: 0;
MACH_MSG_SIZE_MAX :: cast,trunc(mach_msg_size_t) ~0;
MACH_MSG_SIZE_RELIABLE :: cast(mach_msg_size_t) 256 * 1024;
MACH_MSGH_KIND_NORMAL :: 0x00000000;
MACH_MSGH_KIND_NOTIFICATION :: 0x00000001;
mach_msg_kind_t :: mach_port_seqno_t;
MACH_MSG_TYPE_PORT_NONE :: 0;
MACH_MSG_TYPE_PORT_NAME :: 15;
MACH_MSG_TYPE_PORT_RECEIVE :: MACH_MSG_TYPE_MOVE_RECEIVE;
MACH_MSG_TYPE_PORT_SEND :: MACH_MSG_TYPE_MOVE_SEND;
MACH_MSG_TYPE_PORT_SEND_ONCE :: MACH_MSG_TYPE_MOVE_SEND_ONCE;
MACH_MSG_TYPE_LAST :: 22;
MACH_MSG_TYPE_POLYMORPHIC :: cast,trunc(mach_msg_type_name_t) -1;
MACH_MSG_OPTION_NONE :: 0x00000000;
MACH_SEND_MSG :: 0x00000001;
MACH_RCV_MSG :: 0x00000002;
MACH_RCV_LARGE :: 0x00000004;
MACH_RCV_LARGE_IDENTITY :: 0x00000008;
MACH_SEND_TIMEOUT :: 0x00000010;
MACH_SEND_OVERRIDE :: 0x00000020;
MACH_SEND_INTERRUPT :: 0x00000040;
MACH_SEND_NOTIFY :: 0x00000080;
MACH_SEND_ALWAYS :: 0x00010000;
MACH_SEND_TRAILER :: 0x00020000;
MACH_SEND_NOIMPORTANCE :: 0x00040000;
MACH_SEND_NODENAP :: MACH_SEND_NOIMPORTANCE;
MACH_SEND_IMPORTANCE :: 0x00080000;
MACH_SEND_SYNC_OVERRIDE :: 0x00100000;
MACH_RCV_TIMEOUT :: 0x00000100;
MACH_RCV_NOTIFY :: 0x00000200;
MACH_RCV_INTERRUPT :: 0x00000400;
MACH_RCV_VOUCHER :: 0x00000800;
MACH_RCV_OVERWRITE :: 0x00001000;
MACH_RCV_SYNC_WAIT :: 0x00004000;
MACH_RCV_TRAILER_NULL :: 0;
MACH_RCV_TRAILER_SEQNO :: 1;
MACH_RCV_TRAILER_SENDER :: 2;
MACH_RCV_TRAILER_AUDIT :: 3;
MACH_RCV_TRAILER_CTX :: 4;
MACH_RCV_TRAILER_AV :: 7;
MACH_RCV_TRAILER_LABELS :: 8;
MACH_RCV_TRAILER_MASK :: (0xf << 24);
MACH_MSG_SUCCESS :: 0x00000000;
MACH_MSG_MASK :: 0x00003e00;
MACH_MSG_IPC_SPACE :: 0x00002000;
MACH_MSG_VM_SPACE :: 0x00001000;
MACH_MSG_IPC_KERNEL :: 0x00000800;
MACH_MSG_VM_KERNEL :: 0x00000400;
MACH_SEND_IN_PROGRESS :: 0x10000001;
MACH_SEND_INVALID_DATA :: 0x10000002;
MACH_SEND_INVALID_DEST :: 0x10000003;
MACH_SEND_TIMED_OUT :: 0x10000004;
MACH_SEND_INVALID_VOUCHER :: 0x10000005;
MACH_SEND_INTERRUPTED :: 0x10000007;
MACH_SEND_MSG_TOO_SMALL :: 0x10000008;
MACH_SEND_INVALID_REPLY :: 0x10000009;
MACH_SEND_INVALID_RIGHT :: 0x1000000a;
MACH_SEND_INVALID_NOTIFY :: 0x1000000b;
MACH_SEND_INVALID_MEMORY :: 0x1000000c;
MACH_SEND_NO_BUFFER :: 0x1000000d;
MACH_SEND_TOO_LARGE :: 0x1000000e;
MACH_SEND_INVALID_TYPE :: 0x1000000f;
MACH_SEND_INVALID_HEADER :: 0x10000010;
MACH_SEND_INVALID_TRAILER :: 0x10000011;
MACH_SEND_INVALID_RT_OOL_SIZE :: 0x10000015;
MACH_RCV_IN_PROGRESS :: 0x10004001;
MACH_RCV_INVALID_NAME :: 0x10004002;
MACH_RCV_TIMED_OUT :: 0x10004003;
MACH_RCV_TOO_LARGE :: 0x10004004;
MACH_RCV_INTERRUPTED :: 0x10004005;
MACH_RCV_PORT_CHANGED :: 0x10004006;
MACH_RCV_INVALID_NOTIFY :: 0x10004007;
MACH_RCV_INVALID_DATA :: 0x10004008;
MACH_RCV_PORT_DIED :: 0x10004009;
MACH_RCV_IN_SET :: 0x1000400a;
MACH_RCV_HEADER_ERROR :: 0x1000400b;
MACH_RCV_BODY_ERROR :: 0x1000400c;
MACH_RCV_INVALID_TYPE :: 0x1000400d;
MACH_RCV_SCATTER_SMALL :: 0x1000400e;
MACH_RCV_INVALID_TRAILER :: 0x1000400f;
MACH_RCV_IN_PROGRESS_TIMED :: 0x10004011;
VM_PAGE_QUERY_PAGE_PRESENT :: 0x1;
VM_PAGE_QUERY_PAGE_FICTITIOUS :: 0x2;
VM_PAGE_QUERY_PAGE_REF :: 0x4;
VM_PAGE_QUERY_PAGE_DIRTY :: 0x8;
VM_PAGE_QUERY_PAGE_PAGED_OUT :: 0x10;
VM_PAGE_QUERY_PAGE_COPIED :: 0x20;
VM_PAGE_QUERY_PAGE_SPECULATIVE :: 0x40;
VM_PAGE_QUERY_PAGE_EXTERNAL :: 0x80;
VM_PAGE_QUERY_PAGE_CS_VALIDATED :: 0x100;
VM_PAGE_QUERY_PAGE_CS_TAINTED :: 0x200;
VM_PAGE_QUERY_PAGE_CS_NX :: 0x400;
VM_FLAGS_FIXED :: 0x0000;
VM_FLAGS_ANYWHERE :: 0x0001;
VM_FLAGS_PURGABLE :: 0x0002;
VM_FLAGS_4GB_CHUNK :: 0x0004;
VM_FLAGS_RANDOM_ADDR :: 0x0008;
VM_FLAGS_NO_CACHE :: 0x0010;
VM_FLAGS_RESILIENT_CODESIGN :: 0x0020;
VM_FLAGS_RESILIENT_MEDIA :: 0x0040;
VM_FLAGS_OVERWRITE :: 0x4000;
VM_FLAGS_SUPERPAGE_MASK :: 0x70000;
VM_FLAGS_RETURN_DATA_ADDR :: 0x100000;
VM_FLAGS_RETURN_4K_DATA_ADDR :: 0x800000;
VM_FLAGS_ALIAS_MASK :: 0xFF000000;
VM_FLAGS_USER_ALLOCATE :: VM_FLAGS_FIXED | VM_FLAGS_ANYWHERE | VM_FLAGS_PURGABLE | VM_FLAGS_4GB_CHUNK | VM_FLAGS_RANDOM_ADDR | VM_FLAGS_NO_CACHE | VM_FLAGS_OVERWRITE | VM_FLAGS_SUPERPAGE_MASK | VM_FLAGS_ALIAS_MASK;
VM_FLAGS_USER_MAP :: VM_FLAGS_USER_ALLOCATE | VM_FLAGS_RETURN_4K_DATA_ADDR | VM_FLAGS_RETURN_DATA_ADDR;
VM_FLAGS_USER_REMAP :: VM_FLAGS_FIXED | VM_FLAGS_ANYWHERE | VM_FLAGS_RANDOM_ADDR | VM_FLAGS_OVERWRITE | VM_FLAGS_RETURN_DATA_ADDR | VM_FLAGS_RESILIENT_CODESIGN;
VM_FLAGS_SUPERPAGE_SHIFT :: 16;
SUPERPAGE_NONE :: 0;
SUPERPAGE_SIZE_ANY :: 1;
VM_FLAGS_SUPERPAGE_NONE :: SUPERPAGE_NONE << VM_FLAGS_SUPERPAGE_SHIFT;
VM_FLAGS_SUPERPAGE_SIZE_ANY :: SUPERPAGE_SIZE_ANY << VM_FLAGS_SUPERPAGE_SHIFT;
SUPERPAGE_SIZE_2MB :: 2;
VM_FLAGS_SUPERPAGE_SIZE_2MB :: SUPERPAGE_SIZE_2MB << VM_FLAGS_SUPERPAGE_SHIFT;
VM_MEMORY_MALLOC :: 1;
VM_MEMORY_MALLOC_SMALL :: 2;
VM_MEMORY_MALLOC_LARGE :: 3;
VM_MEMORY_MALLOC_HUGE :: 4;
VM_MEMORY_SBRK :: 5;
VM_MEMORY_REALLOC :: 6;
VM_MEMORY_MALLOC_TINY :: 7;
VM_MEMORY_MALLOC_LARGE_REUSABLE :: 8;
VM_MEMORY_MALLOC_LARGE_REUSED :: 9;
VM_MEMORY_ANALYSIS_TOOL :: 10;
VM_MEMORY_MALLOC_NANO :: 11;
VM_MEMORY_MACH_MSG :: 20;
VM_MEMORY_IOKIT :: 21;
VM_MEMORY_STACK :: 30;
VM_MEMORY_GUARD :: 31;
VM_MEMORY_SHARED_PMAP :: 32;
VM_MEMORY_DYLIB :: 33;
VM_MEMORY_OBJC_DISPATCHERS :: 34;
VM_MEMORY_UNSHARED_PMAP :: 35;
VM_MEMORY_APPKIT :: 40;
VM_MEMORY_FOUNDATION :: 41;
VM_MEMORY_COREGRAPHICS :: 42;
VM_MEMORY_CORESERVICES :: 43;
VM_MEMORY_CARBON :: VM_MEMORY_CORESERVICES;
VM_MEMORY_JAVA :: 44;
VM_MEMORY_COREDATA :: 45;
VM_MEMORY_COREDATA_OBJECTIDS :: 46;
VM_MEMORY_ATS :: 50;
VM_MEMORY_LAYERKIT :: 51;
VM_MEMORY_CGIMAGE :: 52;
VM_MEMORY_TCMALLOC :: 53;
VM_MEMORY_COREGRAPHICS_DATA :: 54;
VM_MEMORY_COREGRAPHICS_SHARED :: 55;
VM_MEMORY_COREGRAPHICS_FRAMEBUFFERS :: 56;
VM_MEMORY_COREGRAPHICS_BACKINGSTORES :: 57;
VM_MEMORY_COREGRAPHICS_XALLOC :: 58;
VM_MEMORY_COREGRAPHICS_MISC :: VM_MEMORY_COREGRAPHICS;
VM_MEMORY_DYLD :: 60;
VM_MEMORY_DYLD_MALLOC :: 61;
VM_MEMORY_SQLITE :: 62;
VM_MEMORY_JAVASCRIPT_CORE :: 63;
VM_MEMORY_WEBASSEMBLY :: VM_MEMORY_JAVASCRIPT_CORE;
VM_MEMORY_JAVASCRIPT_JIT_EXECUTABLE_ALLOCATOR :: 64;
VM_MEMORY_JAVASCRIPT_JIT_REGISTER_FILE :: 65;
VM_MEMORY_GLSL :: 66;
VM_MEMORY_OPENCL :: 67;
VM_MEMORY_COREIMAGE :: 68;
VM_MEMORY_WEBCORE_PURGEABLE_BUFFERS :: 69;
VM_MEMORY_IMAGEIO :: 70;
VM_MEMORY_COREPROFILE :: 71;
VM_MEMORY_ASSETSD :: 72;
VM_MEMORY_OS_ALLOC_ONCE :: 73;
VM_MEMORY_LIBDISPATCH :: 74;
VM_MEMORY_ACCELERATE :: 75;
VM_MEMORY_COREUI :: 76;
VM_MEMORY_COREUIFILE :: 77;
VM_MEMORY_GENEALOGY :: 78;
VM_MEMORY_RAWCAMERA :: 79;
VM_MEMORY_CORPSEINFO :: 80;
VM_MEMORY_ASL :: 81;
VM_MEMORY_SWIFT_RUNTIME :: 82;
VM_MEMORY_SWIFT_METADATA :: 83;
VM_MEMORY_DHMM :: 84;
VM_MEMORY_SCENEKIT :: 86;
VM_MEMORY_SKYWALK :: 87;
VM_MEMORY_IOSURFACE :: 88;
VM_MEMORY_LIBNETWORK :: 89;
VM_MEMORY_AUDIO :: 90;
VM_MEMORY_VIDEOBITSTREAM :: 91;
VM_MEMORY_APPLICATION_SPECIFIC_1 :: 240;
VM_MEMORY_APPLICATION_SPECIFIC_16 :: 255;
CPU_STATE_MAX :: 4;
CPU_STATE_USER :: 0;
CPU_STATE_SYSTEM :: 1;
CPU_STATE_IDLE :: 2;
CPU_STATE_NICE :: 3;
CPU_ARCH_MASK :: 0xff000000;
CPU_ARCH_ABI64 :: 0x01000000;
CPU_TYPE_ANY :: cast,trunc(cpu_type_t) -1;
CPU_TYPE_VAX :: cast(cpu_type_t) 1;
CPU_TYPE_MC680x0 :: cast(cpu_type_t) 6;
CPU_TYPE_X86 :: cast(cpu_type_t) 7;
CPU_TYPE_I386 :: CPU_TYPE_X86;
CPU_TYPE_X86_64 :: CPU_TYPE_X86 | CPU_ARCH_ABI64;
CPU_TYPE_MC98000 :: cast(cpu_type_t) 10;
CPU_TYPE_HPPA :: cast(cpu_type_t) 11;
CPU_TYPE_ARM :: cast(cpu_type_t) 12;
CPU_TYPE_ARM64 :: CPU_TYPE_ARM | CPU_ARCH_ABI64;
CPU_TYPE_MC88000 :: cast(cpu_type_t) 13;
CPU_TYPE_SPARC :: cast(cpu_type_t) 14;
CPU_TYPE_I860 :: cast(cpu_type_t) 15;
CPU_TYPE_POWERPC :: cast(cpu_type_t) 18;
CPU_TYPE_POWERPC64 :: CPU_TYPE_POWERPC | CPU_ARCH_ABI64;
CPU_SUBTYPE_MASK :: 0xff000000;
CPU_SUBTYPE_LIB64 :: 0x80000000;
CPU_SUBTYPE_MULTIPLE :: cast,trunc(cpu_subtype_t) -1;
CPU_SUBTYPE_LITTLE_ENDIAN :: cast(cpu_subtype_t) 0;
CPU_SUBTYPE_BIG_ENDIAN :: cast(cpu_subtype_t) 1;
CPU_THREADTYPE_NONE :: cast(cpu_threadtype_t) 0;
CPU_SUBTYPE_VAX_ALL :: cast(cpu_subtype_t) 0;
CPU_SUBTYPE_VAX780 :: cast(cpu_subtype_t) 1;
CPU_SUBTYPE_VAX785 :: cast(cpu_subtype_t) 2;
CPU_SUBTYPE_VAX750 :: cast(cpu_subtype_t) 3;
CPU_SUBTYPE_VAX730 :: cast(cpu_subtype_t) 4;
CPU_SUBTYPE_UVAXI :: cast(cpu_subtype_t) 5;
CPU_SUBTYPE_UVAXII :: cast(cpu_subtype_t) 6;
CPU_SUBTYPE_VAX8200 :: cast(cpu_subtype_t) 7;
CPU_SUBTYPE_VAX8500 :: cast(cpu_subtype_t) 8;
CPU_SUBTYPE_VAX8600 :: cast(cpu_subtype_t) 9;
CPU_SUBTYPE_VAX8650 :: cast(cpu_subtype_t) 10;
CPU_SUBTYPE_VAX8800 :: cast(cpu_subtype_t) 11;
CPU_SUBTYPE_UVAXIII :: cast(cpu_subtype_t) 12;
CPU_SUBTYPE_MC680x0_ALL :: cast(cpu_subtype_t) 1;
CPU_SUBTYPE_MC68030 :: cast(cpu_subtype_t) 1;
CPU_SUBTYPE_MC68040 :: cast(cpu_subtype_t) 2;
CPU_SUBTYPE_MC68030_ONLY :: cast(cpu_subtype_t) 3;
CPU_SUBTYPE_INTEL_FAMILY_MAX :: 15;
CPU_SUBTYPE_INTEL_MODEL_ALL :: 0;
CPU_SUBTYPE_X86_ALL :: cast(cpu_subtype_t) 3;
CPU_SUBTYPE_X86_64_ALL :: cast(cpu_subtype_t) 3;
CPU_SUBTYPE_X86_ARCH1 :: cast(cpu_subtype_t) 4;
CPU_SUBTYPE_X86_64_H :: cast(cpu_subtype_t) 8;
CPU_THREADTYPE_INTEL_HTT :: cast(cpu_threadtype_t) 1;
CPU_SUBTYPE_MIPS_ALL :: cast(cpu_subtype_t) 0;
CPU_SUBTYPE_MIPS_R2300 :: cast(cpu_subtype_t) 1;
CPU_SUBTYPE_MIPS_R2600 :: cast(cpu_subtype_t) 2;
CPU_SUBTYPE_MIPS_R2800 :: cast(cpu_subtype_t) 3;
CPU_SUBTYPE_MIPS_R2000a :: cast(cpu_subtype_t) 4;
CPU_SUBTYPE_MIPS_R2000 :: cast(cpu_subtype_t) 5;
CPU_SUBTYPE_MIPS_R3000a :: cast(cpu_subtype_t) 6;
CPU_SUBTYPE_MIPS_R3000 :: cast(cpu_subtype_t) 7;
CPU_SUBTYPE_MC98000_ALL :: cast(cpu_subtype_t) 0;
CPU_SUBTYPE_MC98601 :: cast(cpu_subtype_t) 1;
CPU_SUBTYPE_HPPA_ALL :: cast(cpu_subtype_t) 0;
CPU_SUBTYPE_HPPA_7100 :: cast(cpu_subtype_t) 0;
CPU_SUBTYPE_HPPA_7100LC :: cast(cpu_subtype_t) 1;
CPU_SUBTYPE_MC88000_ALL :: cast(cpu_subtype_t) 0;
CPU_SUBTYPE_MC88100 :: cast(cpu_subtype_t) 1;
CPU_SUBTYPE_MC88110 :: cast(cpu_subtype_t) 2;
CPU_SUBTYPE_SPARC_ALL :: cast(cpu_subtype_t) 0;
CPU_SUBTYPE_I860_ALL :: cast(cpu_subtype_t) 0;
CPU_SUBTYPE_I860_860 :: cast(cpu_subtype_t) 1;
CPU_SUBTYPE_POWERPC_ALL :: cast(cpu_subtype_t) 0;
CPU_SUBTYPE_POWERPC_601 :: cast(cpu_subtype_t) 1;
CPU_SUBTYPE_POWERPC_602 :: cast(cpu_subtype_t) 2;
CPU_SUBTYPE_POWERPC_603 :: cast(cpu_subtype_t) 3;
CPU_SUBTYPE_POWERPC_603e :: cast(cpu_subtype_t) 4;
CPU_SUBTYPE_POWERPC_603ev :: cast(cpu_subtype_t) 5;
CPU_SUBTYPE_POWERPC_604 :: cast(cpu_subtype_t) 6;
CPU_SUBTYPE_POWERPC_604e :: cast(cpu_subtype_t) 7;
CPU_SUBTYPE_POWERPC_620 :: cast(cpu_subtype_t) 8;
CPU_SUBTYPE_POWERPC_750 :: cast(cpu_subtype_t) 9;
CPU_SUBTYPE_POWERPC_7400 :: cast(cpu_subtype_t) 10;
CPU_SUBTYPE_POWERPC_7450 :: cast(cpu_subtype_t) 11;
CPU_SUBTYPE_POWERPC_970 :: cast(cpu_subtype_t) 100;
CPU_SUBTYPE_ARM_ALL :: cast(cpu_subtype_t) 0;
CPU_SUBTYPE_ARM_V4T :: cast(cpu_subtype_t) 5;
CPU_SUBTYPE_ARM_V6 :: cast(cpu_subtype_t) 6;
CPU_SUBTYPE_ARM_V5TEJ :: cast(cpu_subtype_t) 7;
CPU_SUBTYPE_ARM_XSCALE :: cast(cpu_subtype_t) 8;
CPU_SUBTYPE_ARM_V7 :: cast(cpu_subtype_t) 9;
CPU_SUBTYPE_ARM_V7F :: cast(cpu_subtype_t) 10;
CPU_SUBTYPE_ARM_V7S :: cast(cpu_subtype_t) 11;
CPU_SUBTYPE_ARM_V7K :: cast(cpu_subtype_t) 12;
CPU_SUBTYPE_ARM_V6M :: cast(cpu_subtype_t) 14;
CPU_SUBTYPE_ARM_V7M :: cast(cpu_subtype_t) 15;
CPU_SUBTYPE_ARM_V7EM :: cast(cpu_subtype_t) 16;
CPU_SUBTYPE_ARM_V8 :: cast(cpu_subtype_t) 13;
CPU_SUBTYPE_ARM64_ALL :: cast(cpu_subtype_t) 0;
CPU_SUBTYPE_ARM64_V8 :: cast(cpu_subtype_t) 1;
CPUFAMILY_UNKNOWN :: 0;
CPUFAMILY_POWERPC_G3 :: 0xcee41549;
CPUFAMILY_POWERPC_G4 :: 0x77c184ae;
CPUFAMILY_POWERPC_G5 :: 0xed76d8aa;
CPUFAMILY_INTEL_6_13 :: 0xaa33392b;
CPUFAMILY_INTEL_PENRYN :: 0x78ea4fbc;
CPUFAMILY_INTEL_NEHALEM :: 0x6b5a4cd2;
CPUFAMILY_INTEL_WESTMERE :: 0x573b5eec;
CPUFAMILY_INTEL_SANDYBRIDGE :: 0x5490b78c;
CPUFAMILY_INTEL_IVYBRIDGE :: 0x1f65e835;
CPUFAMILY_INTEL_HASWELL :: 0x10b282dc;
CPUFAMILY_INTEL_BROADWELL :: 0x582ed09c;
CPUFAMILY_INTEL_SKYLAKE :: 0x37fc219f;
CPUFAMILY_INTEL_KABYLAKE :: 0x0f817246;
CPUFAMILY_ARM_9 :: 0xe73283ae;
CPUFAMILY_ARM_11 :: 0x8ff620d8;
CPUFAMILY_ARM_XSCALE :: 0x53b005f5;
CPUFAMILY_ARM_12 :: 0xbd1b0ae9;
CPUFAMILY_ARM_13 :: 0x0cc90e64;
CPUFAMILY_ARM_14 :: 0x96077ef1;
CPUFAMILY_ARM_15 :: 0xa8511bca;
CPUFAMILY_ARM_SWIFT :: 0x1e2d6381;
CPUFAMILY_ARM_CYCLONE :: 0x37a09642;
CPUFAMILY_ARM_TYPHOON :: 0x2c91a47e;
CPUFAMILY_ARM_TWISTER :: 0x92fb37c8;
CPUFAMILY_ARM_HURRICANE :: 0x67ceee93;
CPUFAMILY_ARM_MONSOON_MISTRAL :: 0xe81e7ef6;
CPUFAMILY_INTEL_6_23 :: CPUFAMILY_INTEL_PENRYN;
CPUFAMILY_INTEL_6_26 :: CPUFAMILY_INTEL_NEHALEM;
TIME_MICROS_MAX :: 1000000;
VM_MAP_NULL :: cast(vm_map_t) 0;
UPL_NULL :: cast(upl_t) 0;
VM_NAMED_ENTRY_NULL :: cast(vm_named_entry_t) 0;
EXC_BAD_ACCESS :: 1;
EXC_BAD_INSTRUCTION :: 2;
EXC_ARITHMETIC :: 3;
EXC_EMULATION :: 4;
EXC_SOFTWARE :: 5;
EXC_BREAKPOINT :: 6;
EXC_SYSCALL :: 7;
EXC_MACH_SYSCALL :: 8;
EXC_RPC_ALERT :: 9;
EXC_CRASH :: 10;
EXC_RESOURCE :: 11;
EXC_GUARD :: 12;
EXC_CORPSE_NOTIFY :: 13;
EXC_CORPSE_VARIANT_BIT :: 0x100;
EXCEPTION_DEFAULT :: 1;
EXCEPTION_STATE :: 2;
EXCEPTION_STATE_IDENTITY :: 3;
MACH_EXCEPTION_CODES :: 0x80000000;
EXC_MASK_BAD_ACCESS :: 1 << EXC_BAD_ACCESS;
EXC_MASK_BAD_INSTRUCTION :: 1 << EXC_BAD_INSTRUCTION;
EXC_MASK_ARITHMETIC :: 1 << EXC_ARITHMETIC;
EXC_MASK_EMULATION :: 1 << EXC_EMULATION;
EXC_MASK_SOFTWARE :: 1 << EXC_SOFTWARE;
EXC_MASK_BREAKPOINT :: 1 << EXC_BREAKPOINT;
EXC_MASK_SYSCALL :: 1 << EXC_SYSCALL;
EXC_MASK_MACH_SYSCALL :: 1 << EXC_MACH_SYSCALL;
EXC_MASK_RPC_ALERT :: 1 << EXC_RPC_ALERT;
EXC_MASK_CRASH :: 1 << EXC_CRASH;
EXC_MASK_RESOURCE :: 1 << EXC_RESOURCE;
EXC_MASK_GUARD :: 1 << EXC_GUARD;
EXC_MASK_CORPSE_NOTIFY :: 1 << EXC_CORPSE_NOTIFY;
FIRST_EXCEPTION :: 1;
EXC_SOFT_SIGNAL :: 0x10003;
EXC_MACF_MIN :: 0x20000;
EXC_MACF_MAX :: 0x2FFFF;
x86_THREAD_STATE :: 7;
THREAD_STATE_NONE :: 13;
USER_CODE_SELECTOR :: 0x0017;
USER_DATA_SELECTOR :: 0x001f;
MACHINE_THREAD_STATE :: x86_THREAD_STATE;
THREAD_STATE_FLAVOR_LIST :: 0;
THREAD_STATE_FLAVOR_LIST_NEW :: 128;
THREAD_STATE_FLAVOR_LIST_10_9 :: 129;
THREAD_STATE_FLAVOR_LIST_10_13 :: 130;
MACH_VOUCHER_NULL :: cast(mach_voucher_t) 0;
MACH_VOUCHER_NAME_NULL :: cast(mach_voucher_name_t) 0;
MACH_VOUCHER_NAME_ARRAY_NULL :: cast(mach_voucher_name_array_t) 0;
IPC_VOUCHER_NULL :: cast(ipc_voucher_t) 0;
MACH_VOUCHER_SELECTOR_CURRENT :: cast(mach_voucher_selector_t) 0;
MACH_VOUCHER_SELECTOR_EFFECTIVE :: cast(mach_voucher_selector_t) 1;
MACH_VOUCHER_ATTR_KEY_ALL :: cast,trunc(mach_voucher_attr_key_t) ~0;
MACH_VOUCHER_ATTR_KEY_NONE :: cast(mach_voucher_attr_key_t) 0;
MACH_VOUCHER_ATTR_KEY_ATM :: cast(mach_voucher_attr_key_t) 1;
MACH_VOUCHER_ATTR_KEY_IMPORTANCE :: cast(mach_voucher_attr_key_t) 2;
MACH_VOUCHER_ATTR_KEY_BANK :: cast(mach_voucher_attr_key_t) 3;
MACH_VOUCHER_ATTR_KEY_PTHPRIORITY :: cast(mach_voucher_attr_key_t) 4;
MACH_VOUCHER_ATTR_KEY_USER_DATA :: cast(mach_voucher_attr_key_t) 7;
MACH_VOUCHER_ATTR_KEY_BITS :: MACH_VOUCHER_ATTR_KEY_USER_DATA;
MACH_VOUCHER_ATTR_KEY_TEST :: cast(mach_voucher_attr_key_t) 8;
MACH_VOUCHER_ATTR_KEY_NUM_WELL_KNOWN :: MACH_VOUCHER_ATTR_KEY_TEST;
MACH_VOUCHER_ATTR_NOOP :: cast(mach_voucher_attr_recipe_command_t) 0;
MACH_VOUCHER_ATTR_COPY :: cast(mach_voucher_attr_recipe_command_t) 1;
MACH_VOUCHER_ATTR_REMOVE :: cast(mach_voucher_attr_recipe_command_t) 2;
MACH_VOUCHER_ATTR_SET_VALUE_HANDLE :: cast(mach_voucher_attr_recipe_command_t) 3;
MACH_VOUCHER_ATTR_AUTO_REDEEM :: cast(mach_voucher_attr_recipe_command_t) 4;
MACH_VOUCHER_ATTR_SEND_PREPROCESS :: cast(mach_voucher_attr_recipe_command_t) 5;
MACH_VOUCHER_ATTR_REDEEM :: cast(mach_voucher_attr_recipe_command_t) 10;
MACH_VOUCHER_ATTR_IMPORTANCE_SELF :: cast(mach_voucher_attr_recipe_command_t) 200;
MACH_VOUCHER_ATTR_USER_DATA_STORE :: cast(mach_voucher_attr_recipe_command_t) 211;
MACH_VOUCHER_ATTR_BITS_STORE :: MACH_VOUCHER_ATTR_USER_DATA_STORE;
MACH_VOUCHER_ATTR_TEST_STORE :: MACH_VOUCHER_ATTR_USER_DATA_STORE;
MACH_VOUCHER_ATTR_MAX_RAW_RECIPE_ARRAY_SIZE :: 5120;
MACH_VOUCHER_TRAP_STACK_LIMIT :: 256;
MACH_VOUCHER_ATTR_MANAGER_NULL :: cast(mach_voucher_attr_manager_t) 0;
MACH_VOUCHER_ATTR_CONTROL_NULL :: cast(mach_voucher_attr_control_t) 0;
IPC_VOUCHER_ATTR_MANAGER_NULL :: cast(ipc_voucher_attr_manager_t) 0;
IPC_VOUCHER_ATTR_CONTROL_NULL :: cast(ipc_voucher_attr_control_t) 0;
MACH_VOUCHER_ATTR_VALUE_MAX_NESTED :: cast(mach_voucher_attr_value_handle_array_size_t) 4;
MACH_VOUCHER_ATTR_VALUE_FLAGS_NONE :: cast(mach_voucher_attr_value_flags_t) 0;
MACH_VOUCHER_ATTR_VALUE_FLAGS_PERSIST :: cast(mach_voucher_attr_value_flags_t) 1;
MACH_VOUCHER_ATTR_CONTROL_FLAGS_NONE :: cast(mach_voucher_attr_control_flags_t) 0;
MACH_VOUCHER_IMPORTANCE_ATTR_ADD_EXTERNAL :: 1;
MACH_VOUCHER_IMPORTANCE_ATTR_DROP_EXTERNAL :: 2;
MACH_ACTIVITY_ID_COUNT_MAX :: 16;
POLICY_NULL :: 0;
POLICY_TIMESHARE :: 1;
POLICY_RR :: 2;
POLICY_FIFO :: 4;
POLICYCLASS_FIXEDPRI :: POLICY_RR | POLICY_FIFO;
TASK_INFO_MAX :: 1024;
TASK_BASIC_INFO_32 :: 4;
TASK_BASIC2_INFO_32 :: 6;
TASK_BASIC_INFO_64 :: 5;
TASK_BASIC_INFO :: TASK_BASIC_INFO_64;
TASK_EVENTS_INFO :: 2;
TASK_THREAD_TIMES_INFO :: 3;
TASK_ABSOLUTETIME_INFO :: 1;
TASK_KERNELMEMORY_INFO :: 7;
TASK_SECURITY_TOKEN :: 13;
TASK_AUDIT_TOKEN :: 15;
TASK_AFFINITY_TAG_INFO :: 16;
TASK_DYLD_INFO :: 17;
TASK_DYLD_ALL_IMAGE_INFO_32 :: 0;
TASK_DYLD_ALL_IMAGE_INFO_64 :: 1;
TASK_EXTMOD_INFO :: 19;
MACH_TASK_BASIC_INFO :: 20;
TASK_POWER_INFO :: 21;
TASK_VM_INFO :: 22;
TASK_VM_INFO_PURGEABLE :: 23;
TASK_TRACE_MEMORY_INFO :: 24;
TASK_WAIT_STATE_INFO :: 25;
TASK_POWER_INFO_V2 :: 26;
TASK_VM_INFO_PURGEABLE_ACCOUNT :: 27;
TASK_FLAGS_INFO :: 28;
TF_LP64 :: 0x00000001;
TASK_DEBUG_INFO_INTERNAL :: 29;
TASK_SCHED_TIMESHARE_INFO :: 10;
TASK_SCHED_RR_INFO :: 11;
TASK_SCHED_FIFO_INFO :: 12;
TASK_SCHED_INFO :: 14;
TASK_CATEGORY_POLICY :: 1;
TASK_SUPPRESSION_POLICY :: 3;
TASK_POLICY_STATE :: 4;
TASK_BASE_QOS_POLICY :: 8;
TASK_OVERRIDE_QOS_POLICY :: 9;
TASK_BASE_LATENCY_QOS_POLICY :: 10;
TASK_BASE_THROUGHPUT_QOS_POLICY :: 11;
PROC_FLAG_DARWINBG :: 0x8000;
PROC_FLAG_EXT_DARWINBG :: 0x10000;
PROC_FLAG_IOS_APPLEDAEMON :: 0x20000;
PROC_FLAG_IOS_IMPPROMOTION :: 0x80000;
PROC_FLAG_ADAPTIVE :: 0x100000;
PROC_FLAG_ADAPTIVE_IMPORTANT :: 0x200000;
PROC_FLAG_IMPORTANCE_DONOR :: 0x400000;
PROC_FLAG_SUPPRESSED :: 0x800000;
PROC_FLAG_APPLICATION :: 0x1000000;
PROC_FLAG_IOS_APPLICATION :: PROC_FLAG_APPLICATION;
THREAD_STANDARD_POLICY :: 1;
THREAD_STANDARD_POLICY_COUNT :: 0;
THREAD_EXTENDED_POLICY :: 1;
THREAD_TIME_CONSTRAINT_POLICY :: 2;
THREAD_PRECEDENCE_POLICY :: 3;
THREAD_AFFINITY_POLICY :: 4;
THREAD_AFFINITY_TAG_NULL :: 0;
THREAD_BACKGROUND_POLICY :: 5;
THREAD_BACKGROUND_POLICY_DARWIN_BG :: 0x1000;
THREAD_LATENCY_QOS_POLICY :: 7;
THREAD_THROUGHPUT_QOS_POLICY :: 8;
SYSTEM_CLOCK :: 0;
CALENDAR_CLOCK :: 1;
REALTIME_CLOCK :: 0;
CLOCK_GET_TIME_RES :: 1;
CLOCK_ALARM_CURRES :: 3;
CLOCK_ALARM_MINRES :: 4;
CLOCK_ALARM_MAXRES :: 5;
NSEC_PER_USEC :: 1000;
USEC_PER_SEC :: 1000000;
NSEC_PER_SEC :: 1000000000;
NSEC_PER_MSEC :: 1000000;
ALRMTYPE :: 0xff;
TIME_ABSOLUTE :: 0x00;
TIME_RELATIVE :: 0x01;
TASK_NULL :: cast(task_t) 0;
TASK_NAME_NULL :: cast(task_name_t) 0;
TASK_INSPECT_NULL :: cast(task_inspect_t) 0;
THREAD_NULL :: cast(thread_t) 0;
THREAD_INSPECT_NULL :: cast(thread_inspect_t) 0;
TID_NULL :: cast(u64) 0;
THR_ACT_NULL :: cast(thread_act_t) 0;
IPC_SPACE_NULL :: cast(ipc_space_t) 0;
IPC_SPACE_INSPECT_NULL :: cast(ipc_space_inspect_t) 0;
COALITION_NULL :: cast(coalition_t) 0;
HOST_NULL :: cast(host_t) 0;
HOST_PRIV_NULL :: cast(host_priv_t) 0;
HOST_SECURITY_NULL :: cast(host_security_t) 0;
PROCESSOR_SET_NULL :: cast(processor_set_t) 0;
PROCESSOR_NULL :: cast(processor_t) 0;
SEMAPHORE_NULL :: cast(semaphore_t) 0;
LOCK_SET_NULL :: cast(lock_set_t) 0;
LEDGER_NULL :: cast(ledger_t) 0;
ALARM_NULL :: cast(alarm_t) 0;
UND_SERVER_NULL :: cast(UNDServerRef) 0;
LEDGER_ITEM_INFINITY :: cast,trunc(ledger_item_t) (~0);
LEDGER_LIMIT_INFINITY :: cast(ledger_amount_t) ((1 << 63) - 1);
ZONE_NAME_MAX_LEN :: 80;
MACH_ZONE_NAME_MAX_LEN :: 80;
MACH_MEMORY_INFO_NAME_MAX_LEN :: 80;
SYNC_POLICY_FIFO :: 0x0;
SYNC_POLICY_FIXED_PRIORITY :: 0x1;
SYNC_POLICY_REVERSED :: 0x2;
SYNC_POLICY_ORDER_MASK :: 0x3;
SYNC_POLICY_LIFO :: SYNC_POLICY_FIFO | SYNC_POLICY_REVERSED;
SYNC_POLICY_MAX :: 0x7;
task_MSG_COUNT :: 52;

NDR_record_t :: struct {
    mig_vers: u8;
    if_vers: u8;
    reserved1: u8;
    mig_encoding: u8;
    int_rep: u8;
    char_rep: u8;
    float_rep: u8;
    reserved2: u8;
}

NDR_record: NDR_record_t #elsewhere libc;
vm_offset_t :: u64;
vm_size_t :: u64;
mach_vm_address_t :: u64;
mach_vm_offset_t :: u64;
mach_vm_size_t :: u64;
vm_map_offset_t :: u64;
vm_map_address_t :: u64;
vm_map_size_t :: u64;
mach_port_context_t :: mach_vm_address_t;
mach_port_name_t :: u32;
mach_port_name_array_t :: *mach_port_name_t;
mach_port_array_t :: *mach_port_t;
mach_port_right_t :: u32;
mach_port_type_t :: u32;
mach_port_type_array_t :: *mach_port_type_t;
mach_port_urefs_t :: u32;
mach_port_delta_t :: s32;
mach_port_seqno_t :: u32;
mach_port_mscount_t :: u32;
mach_port_msgcount_t :: u32;
mach_port_rights_t :: u32;
mach_port_srights_t :: u32;

mach_port_status :: struct {
    mps_pset: mach_port_rights_t;
    mps_seqno: mach_port_seqno_t;
    mps_mscount: mach_port_mscount_t;
    mps_qlimit: mach_port_msgcount_t;
    mps_msgcount: mach_port_msgcount_t;
    mps_sorights: mach_port_rights_t;
    mps_srights: u32;
    mps_pdrequest: u32;
    mps_nsrequest: u32;
    mps_flags: u32;
}

mach_port_status_t :: mach_port_status;

mach_port_limits :: struct {
    mpl_qlimit: mach_port_msgcount_t;
}

mach_port_limits_t :: mach_port_limits;

mach_port_info_ext :: struct {
    mpie_status: mach_port_status_t;
    mpie_boost_cnt: mach_port_msgcount_t;
    reserved: [6] u32;
}

mach_port_info_ext_t :: mach_port_info_ext;
mach_port_info_t :: *s32;
mach_port_flavor_t :: s32;

mach_port_qos :: struct {
    __bitfield: u32;
    len: u32;
}

mach_port_qos_t :: mach_port_qos;

mach_port_options :: struct {
    flags: u32;
    mpl: mach_port_limits_t;
    reserved: [2] u64;
}

mach_port_options_t :: mach_port_options;
mach_port_options_ptr_t :: *mach_port_options_t;

mach_port_guard_exception_codes :: enum_flags u32 {
    DESTROY :: 0x1;
    MOD_REFS :: 0x2;
    SET_CONTEXT :: 0x4;
    UNGUARDED :: 0x8;
    INCORRECT_GUARD :: 0x10;
    kGUARD_EXC_DESTROY :: DESTROY;
    kGUARD_EXC_MOD_REFS :: MOD_REFS;
    kGUARD_EXC_SET_CONTEXT :: SET_CONTEXT;
    kGUARD_EXC_UNGUARDED :: UNGUARDED;
    kGUARD_EXC_INCORRECT_GUARD :: INCORRECT_GUARD;
}

mach_msg_timeout_t :: u32;
mach_msg_bits_t :: u32;
mach_msg_size_t :: u32;
mach_msg_id_t :: s32;
mach_msg_priority_t :: u32;
mach_msg_type_name_t :: u32;
mach_msg_copy_options_t :: u32;
mach_msg_descriptor_type_t :: u32;

mach_msg_type_descriptor_t :: struct {
    pad1: u32;
    pad2: mach_msg_size_t;
    __bitfield: u32;
}

mach_msg_port_descriptor_t :: struct {
    name: mach_port_t;
    pad1: mach_msg_size_t;
    __bitfield: u32;
}

mach_msg_ool_descriptor32_t :: struct {
    address: u32;
    size: mach_msg_size_t;
    __bitfield: u32;
}

mach_msg_ool_descriptor64_t :: struct {
    address: u64;
    __bitfield: u32;
    size: mach_msg_size_t;
}

mach_msg_ool_descriptor_t :: struct {
    address: *void;
    __bitfield: u32;
    size: mach_msg_size_t;
}

mach_msg_ool_ports_descriptor32_t :: struct {
    address: u32;
    count: mach_msg_size_t;
    __bitfield: u32;
}

mach_msg_ool_ports_descriptor64_t :: struct {
    address: u64;
    __bitfield: u32;
    count: mach_msg_size_t;
}

mach_msg_ool_ports_descriptor_t :: struct {
    address: *void;
    __bitfield: u32;
    count: mach_msg_size_t;
}

mach_msg_descriptor_t :: union {
    port: mach_msg_port_descriptor_t;
    out_of_line: mach_msg_ool_descriptor_t;
    ool_ports: mach_msg_ool_ports_descriptor_t;
    type: mach_msg_type_descriptor_t;
}

mach_msg_body_t :: struct {
    msgh_descriptor_count: mach_msg_size_t;
}

mach_msg_header_t :: struct {
    msgh_bits: mach_msg_bits_t;
    msgh_size: mach_msg_size_t;
    msgh_remote_port: mach_port_t;
    msgh_local_port: mach_port_t;
    msgh_voucher_port: mach_port_name_t;
    msgh_id: mach_msg_id_t;
}

mach_msg_base_t :: struct {
    header: mach_msg_header_t;
    body: mach_msg_body_t;
}

mach_msg_trailer_type_t :: u32;
mach_msg_trailer_size_t :: u32;
mach_msg_trailer_info_t :: *u8;

mach_msg_trailer_t :: struct {
    msgh_trailer_type: mach_msg_trailer_type_t;
    msgh_trailer_size: mach_msg_trailer_size_t;
}

mach_msg_seqno_trailer_t :: struct {
    msgh_trailer_type: mach_msg_trailer_type_t;
    msgh_trailer_size: mach_msg_trailer_size_t;
    msgh_seqno: mach_port_seqno_t;
}

security_token_t :: struct {
    val: [2] u32;
}

mach_msg_security_trailer_t :: struct {
    msgh_trailer_type: mach_msg_trailer_type_t;
    msgh_trailer_size: mach_msg_trailer_size_t;
    msgh_seqno: mach_port_seqno_t;
    msgh_sender: security_token_t;
}

audit_token_t :: struct {
    val: [8] u32;
}

mach_msg_audit_trailer_t :: struct {
    msgh_trailer_type: mach_msg_trailer_type_t;
    msgh_trailer_size: mach_msg_trailer_size_t;
    msgh_seqno: mach_port_seqno_t;
    msgh_sender: security_token_t;
    msgh_audit: audit_token_t;
}

mach_msg_context_trailer_t :: struct {
    msgh_trailer_type: mach_msg_trailer_type_t;
    msgh_trailer_size: mach_msg_trailer_size_t;
    msgh_seqno: mach_port_seqno_t;
    msgh_sender: security_token_t;
    msgh_audit: audit_token_t;
    msgh_context: mach_port_context_t #align 4;
}

msg_labels_t :: struct {
    sender: mach_port_name_t;
}

mach_msg_mac_trailer_t :: struct {
    msgh_trailer_type: mach_msg_trailer_type_t;
    msgh_trailer_size: mach_msg_trailer_size_t;
    msgh_seqno: mach_port_seqno_t;
    msgh_sender: security_token_t;
    msgh_audit: audit_token_t;
    msgh_context: mach_port_context_t #align 4;
    msgh_ad: s32;
    msgh_labels: msg_labels_t;
}

mach_msg_max_trailer_t :: mach_msg_mac_trailer_t;
mach_msg_format_0_trailer_t :: mach_msg_security_trailer_t;
mach_msg_options_t :: s32;

mach_msg_empty_send_t :: struct {
    header: mach_msg_header_t;
}

mach_msg_empty_rcv_t :: struct {
    header: mach_msg_header_t;
    trailer: mach_msg_trailer_t;
}

mach_msg_empty_t :: union {
    send: mach_msg_empty_send_t;
    rcv: mach_msg_empty_rcv_t;
}

mach_msg_type_size_t :: u32;
mach_msg_type_number_t :: u32;
mach_msg_option_t :: s32;
mach_msg_return_t :: kern_return_t;
mach_msg_overwrite :: (msg: *mach_msg_header_t, option: mach_msg_option_t, send_size: mach_msg_size_t, rcv_size: mach_msg_size_t, rcv_name: mach_port_name_t, timeout: mach_msg_timeout_t, notify: mach_port_name_t, rcv_msg: *mach_msg_header_t, rcv_limit: mach_msg_size_t) -> mach_msg_return_t #foreign libc;
mach_msg :: (msg: *mach_msg_header_t, option: mach_msg_option_t, send_size: mach_msg_size_t, rcv_size: mach_msg_size_t, rcv_name: mach_port_name_t, timeout: mach_msg_timeout_t, notify: mach_port_name_t) -> mach_msg_return_t #foreign libc;
mach_voucher_deallocate :: (voucher: mach_port_name_t) -> kern_return_t #foreign libc;

vm_statistics :: struct {
    free_count: u32;
    active_count: u32;
    inactive_count: u32;
    wire_count: u32;
    zero_fill_count: u32;
    reactivations: u32;
    pageins: u32;
    pageouts: u32;
    faults: u32;
    cow_faults: u32;
    lookups: u32;
    hits: u32;
    purgeable_count: u32;
    purges: u32;
    speculative_count: u32;
}

vm_statistics_t :: *vm_statistics;
vm_statistics_data_t :: vm_statistics;

vm_statistics64 :: struct {
    free_count: u32;
    active_count: u32;
    inactive_count: u32;
    wire_count: u32;
    zero_fill_count: u64;
    reactivations: u64;
    pageins: u64;
    pageouts: u64;
    faults: u64;
    cow_faults: u64;
    lookups: u64;
    hits: u64;
    purges: u64;
    purgeable_count: u32;
    speculative_count: u32;
    decompressions: u64;
    compressions: u64;
    swapins: u64;
    swapouts: u64;
    compressor_page_count: u32;
    throttled_count: u32;
    external_page_count: u32;
    internal_page_count: u32;
    total_uncompressed_pages_in_compressor: u64;
}

vm_statistics64_t :: *vm_statistics64;
vm_statistics64_data_t :: vm_statistics64;

vm_extmod_statistics :: struct {
    task_for_pid_count: s64;
    task_for_pid_caller_count: s64;
    thread_creation_count: s64;
    thread_creation_caller_count: s64;
    thread_set_state_count: s64;
    thread_set_state_caller_count: s64;
}

vm_extmod_statistics_t :: *vm_extmod_statistics;
vm_extmod_statistics_data_t :: vm_extmod_statistics;

vm_purgeable_stat :: struct {
    count: u64;
    size: u64;
}

vm_purgeable_stat_t :: vm_purgeable_stat;

vm_purgeable_info :: struct {
    fifo_data: [8] vm_purgeable_stat_t;
    obsolete_data: vm_purgeable_stat_t;
    lifo_data: [8] vm_purgeable_stat_t;
}

vm_purgeable_info_t :: *vm_purgeable_info;
cpu_type_t :: s32;
cpu_subtype_t :: s32;
cpu_threadtype_t :: s32;

time_value :: struct {
    seconds: s32;
    microseconds: s32;
}

time_value_t :: time_value;
pointer_t :: vm_offset_t;
vm_address_t :: vm_offset_t;
addr64_t :: u64;
reg64_t :: u32;
ppnum_t :: u32;
vm_map_t :: mach_port_t;
vm_object_offset_t :: u64;
vm_object_size_t :: u64;
upl_t :: mach_port_t;
vm_named_entry_t :: mach_port_t;
thread_state_t :: *u32;
thread_state_data_t :: [614] u32;
thread_state_flavor_t :: s32;
thread_state_flavor_array_t :: *thread_state_flavor_t;
exception_type_t :: s32;
exception_data_type_t :: s32;
mach_exception_data_type_t :: s64;
exception_behavior_t :: s32;
exception_data_t :: *exception_data_type_t;
mach_exception_data_t :: *mach_exception_data_type_t;
exception_mask_t :: u32;
exception_mask_array_t :: *exception_mask_t;
exception_behavior_array_t :: *exception_behavior_t;
exception_flavor_array_t :: *thread_state_flavor_t;
exception_port_array_t :: *mach_port_t;
mach_exception_code_t :: mach_exception_data_type_t;
mach_exception_subcode_t :: mach_exception_data_type_t;
mach_voucher_t :: mach_port_t;
mach_voucher_name_t :: mach_port_name_t;
mach_voucher_name_array_t :: *mach_voucher_name_t;
ipc_voucher_t :: mach_voucher_t;
mach_voucher_selector_t :: u32;
mach_voucher_attr_key_t :: u32;
mach_voucher_attr_key_array_t :: *mach_voucher_attr_key_t;
mach_voucher_attr_content_t :: *u8;
mach_voucher_attr_content_size_t :: u32;
mach_voucher_attr_command_t :: u32;
mach_voucher_attr_recipe_command_t :: u32;
mach_voucher_attr_recipe_command_array_t :: *mach_voucher_attr_recipe_command_t;

mach_voucher_attr_recipe_data :: struct {
    key: mach_voucher_attr_key_t;
    command: mach_voucher_attr_recipe_command_t;
    previous_voucher: mach_voucher_name_t;
    content_size: mach_voucher_attr_content_size_t;
}

mach_voucher_attr_recipe_data_t :: mach_voucher_attr_recipe_data;
mach_voucher_attr_recipe_t :: *mach_voucher_attr_recipe_data_t;
mach_voucher_attr_recipe_size_t :: mach_msg_type_number_t;
mach_voucher_attr_raw_recipe_t :: *u8;
mach_voucher_attr_raw_recipe_array_t :: mach_voucher_attr_raw_recipe_t;
mach_voucher_attr_raw_recipe_size_t :: mach_msg_type_number_t;
mach_voucher_attr_raw_recipe_array_size_t :: mach_msg_type_number_t;
mach_voucher_attr_manager_t :: mach_port_t;
mach_voucher_attr_control_t :: mach_port_t;
ipc_voucher_attr_manager_t :: mach_port_t;
ipc_voucher_attr_control_t :: mach_port_t;
mach_voucher_attr_value_handle_t :: u64;
mach_voucher_attr_value_handle_array_t :: *mach_voucher_attr_value_handle_t;
mach_voucher_attr_value_handle_array_size_t :: mach_msg_type_number_t;
mach_voucher_attr_value_reference_t :: u32;
mach_voucher_attr_value_flags_t :: u32;
mach_voucher_attr_control_flags_t :: u32;
mach_voucher_attr_importance_refs :: u32;
policy_t :: s32;
policy_info_t :: *s32;
policy_base_t :: *s32;
policy_limit_t :: *s32;

policy_timeshare_base :: struct {
    base_priority: s32;
}

policy_timeshare_limit :: struct {
    max_priority: s32;
}

policy_timeshare_info :: struct {
    max_priority: s32;
    base_priority: s32;
    cur_priority: s32;
    depressed: u32;
    depress_priority: s32;
}

policy_timeshare_base_t :: *policy_timeshare_base;
policy_timeshare_limit_t :: *policy_timeshare_limit;
policy_timeshare_info_t :: *policy_timeshare_info;
policy_timeshare_base_data_t :: policy_timeshare_base;
policy_timeshare_limit_data_t :: policy_timeshare_limit;
policy_timeshare_info_data_t :: policy_timeshare_info;

policy_rr_base :: struct {
    base_priority: s32;
    quantum: s32;
}

policy_rr_limit :: struct {
    max_priority: s32;
}

policy_rr_info :: struct {
    max_priority: s32;
    base_priority: s32;
    quantum: s32;
    depressed: u32;
    depress_priority: s32;
}

policy_rr_base_t :: *policy_rr_base;
policy_rr_limit_t :: *policy_rr_limit;
policy_rr_info_t :: *policy_rr_info;
policy_rr_base_data_t :: policy_rr_base;
policy_rr_limit_data_t :: policy_rr_limit;
policy_rr_info_data_t :: policy_rr_info;

policy_fifo_base :: struct {
    base_priority: s32;
}

policy_fifo_limit :: struct {
    max_priority: s32;
}

policy_fifo_info :: struct {
    max_priority: s32;
    base_priority: s32;
    depressed: u32;
    depress_priority: s32;
}

policy_fifo_base_t :: *policy_fifo_base;
policy_fifo_limit_t :: *policy_fifo_limit;
policy_fifo_info_t :: *policy_fifo_info;
policy_fifo_base_data_t :: policy_fifo_base;
policy_fifo_limit_data_t :: policy_fifo_limit;
policy_fifo_info_data_t :: policy_fifo_info;

policy_bases :: struct {
    ts: policy_timeshare_base_data_t;
    rr: policy_rr_base_data_t;
    fifo: policy_fifo_base_data_t;
}

policy_limits :: struct {
    ts: policy_timeshare_limit_data_t;
    rr: policy_rr_limit_data_t;
    fifo: policy_fifo_limit_data_t;
}

policy_infos :: struct {
    ts: policy_timeshare_info_data_t;
    rr: policy_rr_info_data_t;
    fifo: policy_fifo_info_data_t;
}

policy_base_data_t :: policy_bases;
policy_limit_data_t :: policy_limits;
policy_info_data_t :: policy_infos;
task_flavor_t :: u32;
task_info_t :: *s32;
task_info_data_t :: [1024] s32;

task_basic_info_32 :: struct {
    suspend_count: s32;
    virtual_size: u32;
    resident_size: u32;
    user_time: time_value_t;
    system_time: time_value_t;
    policy: policy_t;
}

task_basic_info_32_data_t :: task_basic_info_32;
task_basic_info_32_t :: *task_basic_info_32;

task_basic_info_64 :: struct {
    suspend_count: s32;
    virtual_size: mach_vm_size_t #align 4;
    resident_size: mach_vm_size_t #align 4;
    user_time: time_value_t;
    system_time: time_value_t;
    policy: policy_t;
}

task_basic_info_64_data_t :: task_basic_info_64;
task_basic_info_64_t :: *task_basic_info_64;

task_basic_info :: struct {
    suspend_count: s32;
    virtual_size: vm_size_t #align 4;
    resident_size: vm_size_t #align 4;
    user_time: time_value_t;
    system_time: time_value_t;
    policy: policy_t;
}

task_basic_info_data_t :: task_basic_info;
task_basic_info_t :: *task_basic_info;

task_events_info :: struct {
    faults: s32;
    pageins: s32;
    cow_faults: s32;
    messages_sent: s32;
    messages_received: s32;
    syscalls_mach: s32;
    syscalls_unix: s32;
    csw: s32;
}

task_events_info_data_t :: task_events_info;
task_events_info_t :: *task_events_info;

task_thread_times_info :: struct {
    user_time: time_value_t;
    system_time: time_value_t;
}

task_thread_times_info_data_t :: task_thread_times_info;
task_thread_times_info_t :: *task_thread_times_info;

task_absolutetime_info :: struct {
    total_user: u64;
    total_system: u64;
    threads_user: u64;
    threads_system: u64;
}

task_absolutetime_info_data_t :: task_absolutetime_info;
task_absolutetime_info_t :: *task_absolutetime_info;

task_kernelmemory_info :: struct {
    total_palloc: u64;
    total_pfree: u64;
    total_salloc: u64;
    total_sfree: u64;
}

task_kernelmemory_info_data_t :: task_kernelmemory_info;
task_kernelmemory_info_t :: *task_kernelmemory_info;

task_affinity_tag_info :: struct {
    set_count: s32;
    min: s32;
    max: s32;
    task_count: s32;
}

task_affinity_tag_info_data_t :: task_affinity_tag_info;
task_affinity_tag_info_t :: *task_affinity_tag_info;

task_dyld_info :: struct {
    all_image_info_addr: mach_vm_address_t;
    all_image_info_size: mach_vm_size_t;
    all_image_info_format: s32;
}

task_dyld_info_data_t :: task_dyld_info;
task_dyld_info_t :: *task_dyld_info;

task_extmod_info :: struct {
    task_uuid: [16] u8;
    extmod_statistics: vm_extmod_statistics_data_t;
}

task_extmod_info_data_t :: task_extmod_info;
task_extmod_info_t :: *task_extmod_info;

mach_task_basic_info :: struct {
    virtual_size: mach_vm_size_t;
    resident_size: mach_vm_size_t;
    resident_size_max: mach_vm_size_t;
    user_time: time_value_t;
    system_time: time_value_t;
    policy: policy_t;
    suspend_count: s32;
}

mach_task_basic_info_data_t :: mach_task_basic_info;
mach_task_basic_info_t :: *mach_task_basic_info;

task_power_info :: struct {
    total_user: u64;
    total_system: u64;
    task_interrupt_wakeups: u64;
    task_platform_idle_wakeups: u64;
    task_timer_wakeups_bin_1: u64;
    task_timer_wakeups_bin_2: u64;
}

task_power_info_data_t :: task_power_info;
task_power_info_t :: *task_power_info;

task_vm_info :: struct {
    virtual_size: mach_vm_size_t;
    region_count: s32;
    page_size: s32;
    resident_size: mach_vm_size_t;
    resident_size_peak: mach_vm_size_t;
    device: mach_vm_size_t;
    device_peak: mach_vm_size_t;
    internal: mach_vm_size_t;
    internal_peak: mach_vm_size_t;
    external: mach_vm_size_t;
    external_peak: mach_vm_size_t;
    reusable: mach_vm_size_t;
    reusable_peak: mach_vm_size_t;
    purgeable_volatile_pmap: mach_vm_size_t;
    purgeable_volatile_resident: mach_vm_size_t;
    purgeable_volatile_virtual: mach_vm_size_t;
    compressed: mach_vm_size_t;
    compressed_peak: mach_vm_size_t;
    compressed_lifetime: mach_vm_size_t;
    phys_footprint: mach_vm_size_t;
    min_address: mach_vm_address_t;
    max_address: mach_vm_address_t;
}

task_vm_info_data_t :: task_vm_info;
task_vm_info_t :: *task_vm_info;
task_purgable_info_t :: vm_purgeable_info;

task_trace_memory_info :: struct {
    user_memory_address: u64;
    buffer_size: u64;
    mailbox_array_size: u64;
}

task_trace_memory_info_data_t :: task_trace_memory_info;
task_trace_memory_info_t :: *task_trace_memory_info;

task_wait_state_info :: struct {
    total_wait_state_time: u64;
    total_wait_sfi_state_time: u64;
    _reserved: [4] u32;
}

task_wait_state_info_data_t :: task_wait_state_info;
task_wait_state_info_t :: *task_wait_state_info;

gpu_energy_data :: struct {
    task_gpu_utilisation: u64;
    task_gpu_stat_reserved0: u64;
    task_gpu_stat_reserved1: u64;
    task_gpu_stat_reserved2: u64;
}

gpu_energy_data_t :: *gpu_energy_data;

task_power_info_v2 :: struct {
    cpu_energy: task_power_info_data_t;
    gpu_energy: gpu_energy_data;
    task_ptime: u64;
    task_pset_switches: u64;
}

task_power_info_v2_data_t :: task_power_info_v2;
task_power_info_v2_t :: *task_power_info_v2;

task_flags_info :: struct {
    flags: u32;
}

task_flags_info_data_t :: task_flags_info;
task_flags_info_t :: *task_flags_info;
task_inspect_flavor_t :: u32;

task_inspect_flavor :: enum u32 {
    TASK_INSPECT_BASIC_COUNTS :: 1;
}

task_inspect_basic_counts :: struct {
    instructions: u64;
    cycles: u64;
}

task_inspect_basic_counts_data_t :: task_inspect_basic_counts;
task_inspect_basic_counts_t :: *task_inspect_basic_counts;
task_inspect_info_t :: *s32;
task_policy_flavor_t :: u32;
task_policy_t :: *s32;

task_role :: enum s32 {
    RENICED :: -1;
    UNSPECIFIED :: 0;
    FOREGROUND_APPLICATION :: 1;
    BACKGROUND_APPLICATION :: 2;
    CONTROL_APPLICATION :: 3;
    GRAPHICS_SERVER :: 4;
    THROTTLE_APPLICATION :: 5;
    NONUI_APPLICATION :: 6;
    DEFAULT_APPLICATION :: 7;
    TASK_RENICED :: RENICED;
    TASK_UNSPECIFIED :: UNSPECIFIED;
    TASK_FOREGROUND_APPLICATION :: FOREGROUND_APPLICATION;
    TASK_BACKGROUND_APPLICATION :: BACKGROUND_APPLICATION;
    TASK_CONTROL_APPLICATION :: CONTROL_APPLICATION;
    TASK_GRAPHICS_SERVER :: GRAPHICS_SERVER;
    TASK_THROTTLE_APPLICATION :: THROTTLE_APPLICATION;
    TASK_NONUI_APPLICATION :: NONUI_APPLICATION;
    TASK_DEFAULT_APPLICATION :: DEFAULT_APPLICATION;
}

task_role_t :: s32;

task_category_policy :: struct {
    role: task_role_t;
}

task_category_policy_data_t :: task_category_policy;
task_category_policy_t :: *task_category_policy;

task_latency_qos :: enum u32 {
    UNSPECIFIED :: 0;
    _0 :: 16711681;
    _1 :: 16711682;
    _2 :: 16711683;
    _3 :: 16711684;
    _4 :: 16711685;
    _5 :: 16711686;
    LATENCY_QOS_TIER_UNSPECIFIED :: UNSPECIFIED;
    LATENCY_QOS_TIER_0 :: _0;
    LATENCY_QOS_TIER_1 :: _1;
    LATENCY_QOS_TIER_2 :: _2;
    LATENCY_QOS_TIER_3 :: _3;
    LATENCY_QOS_TIER_4 :: _4;
    LATENCY_QOS_TIER_5 :: _5;
}

task_latency_qos_t :: s32;

task_throughput_qos :: enum u32 {
    UNSPECIFIED :: 0;
    _0 :: 16646145;
    _1 :: 16646146;
    _2 :: 16646147;
    _3 :: 16646148;
    _4 :: 16646149;
    _5 :: 16646150;
    THROUGHPUT_QOS_TIER_UNSPECIFIED :: UNSPECIFIED;
    THROUGHPUT_QOS_TIER_0 :: _0;
    THROUGHPUT_QOS_TIER_1 :: _1;
    THROUGHPUT_QOS_TIER_2 :: _2;
    THROUGHPUT_QOS_TIER_3 :: _3;
    THROUGHPUT_QOS_TIER_4 :: _4;
    THROUGHPUT_QOS_TIER_5 :: _5;
}

task_throughput_qos_t :: s32;

task_qos_policy :: struct {
    task_latency_qos_tier: task_latency_qos_t;
    task_throughput_qos_tier: task_throughput_qos_t;
}

task_qos_policy_t :: *task_qos_policy;
thread_policy_flavor_t :: u32;
thread_policy_t :: *s32;

thread_standard_policy :: struct {
    no_data: u32;
}

thread_standard_policy_data_t :: thread_standard_policy;
thread_standard_policy_t :: *thread_standard_policy;

thread_extended_policy :: struct {
    timeshare: u32;
}

thread_extended_policy_data_t :: thread_extended_policy;
thread_extended_policy_t :: *thread_extended_policy;

thread_time_constraint_policy :: struct {
    period: u32;
    computation: u32;
    constraint: u32;
    preemptible: u32;
}

thread_time_constraint_policy_data_t :: thread_time_constraint_policy;
thread_time_constraint_policy_t :: *thread_time_constraint_policy;

thread_precedence_policy :: struct {
    importance: s32;
}

thread_precedence_policy_data_t :: thread_precedence_policy;
thread_precedence_policy_t :: *thread_precedence_policy;

thread_affinity_policy :: struct {
    affinity_tag: s32;
}

thread_affinity_policy_data_t :: thread_affinity_policy;
thread_affinity_policy_t :: *thread_affinity_policy;

thread_background_policy :: struct {
    priority: s32;
}

thread_background_policy_data_t :: thread_background_policy;
thread_background_policy_t :: *thread_background_policy;
thread_latency_qos_t :: s32;

thread_latency_qos_policy :: struct {
    thread_latency_qos_tier: thread_latency_qos_t;
}

thread_latency_qos_policy_data_t :: thread_latency_qos_policy;
thread_latency_qos_policy_t :: *thread_latency_qos_policy;
thread_throughput_qos_t :: s32;

thread_throughput_qos_policy :: struct {
    thread_throughput_qos_tier: thread_throughput_qos_t;
}

thread_throughput_qos_policy_data_t :: thread_throughput_qos_policy;
thread_throughput_qos_policy_t :: *thread_throughput_qos_policy;
alarm_type_t :: s32;
sleep_type_t :: s32;
clock_id_t :: s32;
clock_flavor_t :: s32;
clock_attr_t :: *s32;
clock_res_t :: s32;

mach_timespec :: struct {
    tv_sec: u32;
    tv_nsec: clock_res_t;
}

mach_timespec_t :: mach_timespec;

fsid :: struct {
    val: [2] s32;
}

fsid_t :: fsid;

fsobj_id :: struct {
    fid_objno: u32;
    fid_generation: u32;
}

fsobj_id_t :: fsobj_id;

dyld_kernel_image_info :: struct {
    uuid: uuid_t;
    fsobjid: fsobj_id_t;
    fsid: fsid_t;
    load_addr: u64;
}

dyld_kernel_process_info :: struct {
    cache_image_info: dyld_kernel_image_info;
    timestamp: u64;
    imageCount: u32;
    initialImageCount: u32;
    dyldState: u8;
    no_cache: u32;
    private_cache: u32;
}

dyld_kernel_image_info_t :: dyld_kernel_image_info;
dyld_kernel_process_info_t :: dyld_kernel_process_info;
dyld_kernel_image_info_array_t :: *dyld_kernel_image_info_t;
task_t :: mach_port_t;
task_name_t :: mach_port_t;
task_inspect_t :: mach_port_t;
task_suspension_token_t :: mach_port_t;
thread_t :: mach_port_t;
thread_act_t :: mach_port_t;
thread_inspect_t :: mach_port_t;
ipc_space_t :: mach_port_t;
ipc_space_inspect_t :: mach_port_t;
coalition_t :: mach_port_t;
host_t :: mach_port_t;
host_priv_t :: mach_port_t;
host_security_t :: mach_port_t;
processor_t :: mach_port_t;
processor_set_t :: mach_port_t;
processor_set_control_t :: mach_port_t;
semaphore_t :: mach_port_t;
lock_set_t :: mach_port_t;
ledger_t :: mach_port_t;
alarm_t :: mach_port_t;
clock_serv_t :: mach_port_t;
clock_ctrl_t :: mach_port_t;
processor_set_name_t :: processor_set_t;
clock_reply_t :: mach_port_t;
bootstrap_t :: mach_port_t;
mem_entry_name_port_t :: mach_port_t;
exception_handler_t :: mach_port_t;
exception_handler_array_t :: *exception_handler_t;
vm_task_entry_t :: mach_port_t;
io_master_t :: mach_port_t;
UNDServerRef :: mach_port_t;
task_array_t :: *task_t;
thread_array_t :: *thread_t;
processor_set_array_t :: *processor_set_t;
processor_set_name_array_t :: *processor_set_t;
processor_array_t :: *processor_t;
thread_act_array_t :: *thread_act_t;
ledger_array_t :: *ledger_t;
task_port_t :: task_t;
task_port_array_t :: task_array_t;
thread_port_t :: thread_t;
thread_port_array_t :: thread_array_t;
ipc_space_port_t :: ipc_space_t;
host_name_t :: host_t;
host_name_port_t :: host_t;
processor_set_port_t :: processor_set_t;
processor_set_name_port_t :: processor_set_t;
processor_set_name_port_array_t :: processor_set_array_t;
processor_set_control_port_t :: processor_set_t;
processor_port_t :: processor_t;
processor_port_array_t :: processor_array_t;
thread_act_port_t :: thread_act_t;
thread_act_port_array_t :: thread_act_array_t;
semaphore_port_t :: semaphore_t;
lock_set_port_t :: lock_set_t;
ledger_port_t :: ledger_t;
ledger_port_array_t :: ledger_array_t;
alarm_port_t :: alarm_t;
clock_serv_port_t :: clock_serv_t;
clock_ctrl_port_t :: clock_ctrl_t;
exception_port_t :: exception_handler_t;
exception_port_arrary_t :: exception_handler_array_t;
ledger_item_t :: u32;
ledger_amount_t :: s64;
emulation_vector_t :: *mach_vm_offset_t;
user_subsystem_t :: *u8;
labelstr_t :: *u8;

ipc_info_space :: struct {
    iis_genno_mask: u32;
    iis_table_size: u32;
    iis_table_next: u32;
    iis_tree_size: u32;
    iis_tree_small: u32;
    iis_tree_hash: u32;
}

ipc_info_space_t :: ipc_info_space;

ipc_info_space_basic :: struct {
    iisb_genno_mask: u32;
    iisb_table_size: u32;
    iisb_table_next: u32;
    iisb_table_inuse: u32;
    iisb_reserved: [2] u32;
}

ipc_info_space_basic_t :: ipc_info_space_basic;

ipc_info_name :: struct {
    iin_name: mach_port_name_t;
    iin_collision: s32;
    iin_type: mach_port_type_t;
    iin_urefs: mach_port_urefs_t;
    iin_object: u32;
    iin_next: u32;
    iin_hash: u32;
}

ipc_info_name_t :: ipc_info_name;
ipc_info_name_array_t :: *ipc_info_name_t;

ipc_info_tree_name :: struct {
    iitn_name: ipc_info_name_t;
    iitn_lchild: mach_port_name_t;
    iitn_rchild: mach_port_name_t;
}

ipc_info_tree_name_t :: ipc_info_tree_name;
ipc_info_tree_name_array_t :: *ipc_info_tree_name_t;

zone_name :: struct {
    zn_name: [80] u8;
}

zone_name_t :: zone_name;
zone_name_array_t :: *zone_name_t;

zone_info :: struct {
    zi_count: s32;
    zi_cur_size: vm_size_t;
    zi_max_size: vm_size_t;
    zi_elem_size: vm_size_t;
    zi_alloc_size: vm_size_t;
    zi_pageable: s32;
    zi_sleepable: s32;
    zi_exhaustible: s32;
    zi_collectable: s32;
}

zone_info_t :: zone_info;
zone_info_array_t :: *zone_info_t;

mach_zone_name :: struct {
    mzn_name: [80] u8;
}

mach_zone_name_t :: mach_zone_name;
mach_zone_name_array_t :: *mach_zone_name_t;

mach_zone_info_data :: struct {
    mzi_count: u64;
    mzi_cur_size: u64;
    mzi_max_size: u64;
    mzi_elem_size: u64;
    mzi_alloc_size: u64;
    mzi_sum_size: u64;
    mzi_exhaustible: u64;
    mzi_collectable: u64;
}

mach_zone_info_t :: mach_zone_info_data;
mach_zone_info_array_t :: *mach_zone_info_t;

task_zone_info_data :: struct {
    tzi_count: u64;
    tzi_cur_size: u64;
    tzi_max_size: u64;
    tzi_elem_size: u64;
    tzi_alloc_size: u64;
    tzi_sum_size: u64;
    tzi_exhaustible: u64;
    tzi_collectable: u64;
    tzi_caller_acct: u64;
    tzi_task_alloc: u64;
    tzi_task_free: u64;
}

task_zone_info_t :: task_zone_info_data;
task_zone_info_array_t :: *task_zone_info_t;

mach_memory_info :: struct {
    flags: u64;
    site: u64;
    size: u64;
    free: u64;
    largest: u64;
    collectable_bytes: u64;
    mapped: u64;
    peak: u64;
    tag: u16;
    zone: u16;
    _resvA: [2] u16;
    _resv: [3] u64;
    name: [80] u8;
}

mach_memory_info_t :: mach_memory_info;
mach_memory_info_array_t :: *mach_memory_info_t;
sync_policy_t :: s32;
semaphore_signal :: (semaphore: semaphore_t) -> kern_return_t #foreign libc;
semaphore_signal_all :: (semaphore: semaphore_t) -> kern_return_t #foreign libc;
semaphore_wait :: (semaphore: semaphore_t) -> kern_return_t #foreign libc;
semaphore_timedwait :: (semaphore: semaphore_t, wait_time: mach_timespec_t) -> kern_return_t #foreign libc;
semaphore_timedwait_signal :: (wait_semaphore: semaphore_t, signal_semaphore: semaphore_t, wait_time: mach_timespec_t) -> kern_return_t #foreign libc;
semaphore_wait_signal :: (wait_semaphore: semaphore_t, signal_semaphore: semaphore_t) -> kern_return_t #foreign libc;
semaphore_signal_thread :: (semaphore: semaphore_t, thread: thread_t) -> kern_return_t #foreign libc;
task_create :: (target_task: task_t, ledgers: ledger_array_t, ledgersCnt: mach_msg_type_number_t, inherit_memory: u32, child_task: *task_t) -> kern_return_t #foreign libc;
task_terminate :: (target_task: task_t) -> kern_return_t #foreign libc;
task_threads :: (target_task: task_inspect_t, act_list: *thread_act_array_t, act_listCnt: *mach_msg_type_number_t) -> kern_return_t #foreign libc;
mach_ports_register :: (target_task: task_t, init_port_set: mach_port_array_t, init_port_setCnt: mach_msg_type_number_t) -> kern_return_t #foreign libc;
mach_ports_lookup :: (target_task: task_t, init_port_set: *mach_port_array_t, init_port_setCnt: *mach_msg_type_number_t) -> kern_return_t #foreign libc;
task_info :: (target_task: task_name_t, flavor: task_flavor_t, task_info_out: task_info_t, task_info_outCnt: *mach_msg_type_number_t) -> kern_return_t #foreign libc;
task_set_info :: (target_task: task_t, flavor: task_flavor_t, task_info_in: task_info_t, task_info_inCnt: mach_msg_type_number_t) -> kern_return_t #foreign libc;
task_suspend :: (target_task: task_t) -> kern_return_t #foreign libc;
task_resume :: (target_task: task_t) -> kern_return_t #foreign libc;
task_get_special_port :: (task: task_inspect_t, which_port: s32, special_port: *mach_port_t) -> kern_return_t #foreign libc;
task_set_special_port :: (task: task_t, which_port: s32, special_port: mach_port_t) -> kern_return_t #foreign libc;
thread_create :: (parent_task: task_t, child_act: *thread_act_t) -> kern_return_t #foreign libc;
thread_create_running :: (parent_task: task_t, flavor: thread_state_flavor_t, new_state: thread_state_t, new_stateCnt: mach_msg_type_number_t, child_act: *thread_act_t) -> kern_return_t #foreign libc;
task_set_exception_ports :: (task: task_t, exception_mask: exception_mask_t, new_port: mach_port_t, behavior: exception_behavior_t, new_flavor: thread_state_flavor_t) -> kern_return_t #foreign libc;
task_get_exception_ports :: (task: task_inspect_t, exception_mask: exception_mask_t, masks: exception_mask_array_t, masksCnt: *mach_msg_type_number_t, old_handlers: exception_handler_array_t, old_behaviors: exception_behavior_array_t, old_flavors: exception_flavor_array_t) -> kern_return_t #foreign libc;
task_swap_exception_ports :: (task: task_t, exception_mask: exception_mask_t, new_port: mach_port_t, behavior: exception_behavior_t, new_flavor: thread_state_flavor_t, masks: exception_mask_array_t, masksCnt: *mach_msg_type_number_t, old_handlerss: exception_handler_array_t, old_behaviors: exception_behavior_array_t, old_flavors: exception_flavor_array_t) -> kern_return_t #foreign libc;
lock_set_create :: (task: task_t, new_lock_set: *lock_set_t, n_ulocks: s32, policy: s32) -> kern_return_t #foreign libc;
lock_set_destroy :: (task: task_t, lock_set: lock_set_t) -> kern_return_t #foreign libc;
semaphore_create :: (task: task_t, semaphore: *semaphore_t, policy: s32, value: s32) -> kern_return_t #foreign libc;
semaphore_destroy :: (task: task_t, semaphore: semaphore_t) -> kern_return_t #foreign libc;
task_policy_set :: (task: task_t, flavor: task_policy_flavor_t, policy_info: task_policy_t, policy_infoCnt: mach_msg_type_number_t) -> kern_return_t #foreign libc;
task_policy_get :: (task: task_t, flavor: task_policy_flavor_t, policy_info: task_policy_t, policy_infoCnt: *mach_msg_type_number_t, get_default: *u32) -> kern_return_t #foreign libc;
task_sample :: (task: task_t, reply: mach_port_t) -> kern_return_t #foreign libc;
task_policy :: (task: task_t, policy: policy_t, base: policy_base_t, baseCnt: mach_msg_type_number_t, set_limit: u32, change: u32) -> kern_return_t #foreign libc;
task_set_emulation :: (target_port: task_t, routine_entry_pt: vm_address_t, routine_number: s32) -> kern_return_t #foreign libc;
task_get_emulation_vector :: (task: task_t, vector_start: *s32, emulation_vector: *emulation_vector_t, emulation_vectorCnt: *mach_msg_type_number_t) -> kern_return_t #foreign libc;
task_set_emulation_vector :: (task: task_t, vector_start: s32, emulation_vector: emulation_vector_t, emulation_vectorCnt: mach_msg_type_number_t) -> kern_return_t #foreign libc;
task_set_ras_pc :: (target_task: task_t, basepc: vm_address_t, boundspc: vm_address_t) -> kern_return_t #foreign libc;
task_zone_info :: (target_task: task_t, names: *mach_zone_name_array_t, namesCnt: *mach_msg_type_number_t, info: *task_zone_info_array_t, infoCnt: *mach_msg_type_number_t) -> kern_return_t #foreign libc;
task_assign :: (task: task_t, new_set: processor_set_t, assign_threads: u32) -> kern_return_t #foreign libc;
task_assign_default :: (task: task_t, assign_threads: u32) -> kern_return_t #foreign libc;
task_get_assignment :: (task: task_t, assigned_set: *processor_set_name_t) -> kern_return_t #foreign libc;
task_set_policy :: (task: task_t, pset: processor_set_t, policy: policy_t, base: policy_base_t, baseCnt: mach_msg_type_number_t, limit: policy_limit_t, limitCnt: mach_msg_type_number_t, change: u32) -> kern_return_t #foreign libc;
task_get_state :: (task: task_t, flavor: thread_state_flavor_t, old_state: thread_state_t, old_stateCnt: *mach_msg_type_number_t) -> kern_return_t #foreign libc;
task_set_state :: (task: task_t, flavor: thread_state_flavor_t, new_state: thread_state_t, new_stateCnt: mach_msg_type_number_t) -> kern_return_t #foreign libc;
task_set_phys_footprint_limit :: (task: task_t, new_limit: s32, old_limit: *s32) -> kern_return_t #foreign libc;
task_suspend2 :: (target_task: task_t, suspend_token: *task_suspension_token_t) -> kern_return_t #foreign libc;
task_resume2 :: (suspend_token: task_suspension_token_t) -> kern_return_t #foreign libc;
task_purgable_info :: (task: task_t, stats: *task_purgable_info_t) -> kern_return_t #foreign libc;
task_get_mach_voucher :: (task: task_t, which: mach_voucher_selector_t, voucher: *ipc_voucher_t) -> kern_return_t #foreign libc;
task_set_mach_voucher :: (task: task_t, voucher: ipc_voucher_t) -> kern_return_t #foreign libc;
task_swap_mach_voucher :: (task: task_t, new_voucher: ipc_voucher_t, old_voucher: *ipc_voucher_t) -> kern_return_t #foreign libc;
task_generate_corpse :: (task: task_t, corpse_task_port: *mach_port_t) -> kern_return_t #foreign libc;
task_map_corpse_info :: (task: task_t, corspe_task: task_t, kcd_addr_begin: *vm_address_t, kcd_size: *u32) -> kern_return_t #foreign libc;
task_register_dyld_image_infos :: (task: task_t, dyld_images: dyld_kernel_image_info_array_t, dyld_imagesCnt: mach_msg_type_number_t) -> kern_return_t #foreign libc;
task_unregister_dyld_image_infos :: (task: task_t, dyld_images: dyld_kernel_image_info_array_t, dyld_imagesCnt: mach_msg_type_number_t) -> kern_return_t #foreign libc;
task_get_dyld_image_infos :: (task: task_inspect_t, dyld_images: *dyld_kernel_image_info_array_t, dyld_imagesCnt: *mach_msg_type_number_t) -> kern_return_t #foreign libc;
task_register_dyld_shared_cache_image_info :: (task: task_t, dyld_cache_image: dyld_kernel_image_info_t, no_cache: u32, private_cache: u32) -> kern_return_t #foreign libc;
task_register_dyld_set_dyld_state :: (task: task_t, dyld_state: u8) -> kern_return_t #foreign libc;
task_register_dyld_get_process_state :: (task: task_t, dyld_process_state: *dyld_kernel_process_info_t) -> kern_return_t #foreign libc;
task_map_corpse_info_64 :: (task: task_t, corspe_task: task_t, kcd_addr_begin: *mach_vm_address_t, kcd_size: *mach_vm_size_t) -> kern_return_t #foreign libc;
task_inspect :: (task: task_inspect_t, flavor: task_inspect_flavor_t, info_out: task_inspect_info_t, info_outCnt: *mach_msg_type_number_t) -> kern_return_t #foreign libc;

__Request__task_create_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    ledgers: mach_msg_ool_ports_descriptor_t #align 4;
    NDR: NDR_record_t;
    ledgersCnt: mach_msg_type_number_t;
    inherit_memory: u32;
}

__Request__task_terminate_t :: struct {
    Head: mach_msg_header_t;
}

__Request__task_threads_t :: struct {
    Head: mach_msg_header_t;
}

__Request__mach_ports_register_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    init_port_set: mach_msg_ool_ports_descriptor_t #align 4;
    NDR: NDR_record_t;
    init_port_setCnt: mach_msg_type_number_t;
}

__Request__mach_ports_lookup_t :: struct {
    Head: mach_msg_header_t;
}

__Request__task_info_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    flavor: task_flavor_t;
    task_info_outCnt: mach_msg_type_number_t;
}

__Request__task_set_info_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    flavor: task_flavor_t;
    task_info_inCnt: mach_msg_type_number_t;
    task_info_in: [52] s32;
}

__Request__task_suspend_t :: struct {
    Head: mach_msg_header_t;
}

__Request__task_resume_t :: struct {
    Head: mach_msg_header_t;
}

__Request__task_get_special_port_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    which_port: s32;
}

__Request__task_set_special_port_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    special_port: mach_msg_port_descriptor_t;
    NDR: NDR_record_t;
    which_port: s32;
}

__Request__thread_create_t :: struct {
    Head: mach_msg_header_t;
}

__Request__thread_create_running_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    flavor: thread_state_flavor_t;
    new_stateCnt: mach_msg_type_number_t;
    new_state: [614] u32;
}

__Request__task_set_exception_ports_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    new_port: mach_msg_port_descriptor_t;
    NDR: NDR_record_t;
    exception_mask: exception_mask_t;
    behavior: exception_behavior_t;
    new_flavor: thread_state_flavor_t;
}

__Request__task_get_exception_ports_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    exception_mask: exception_mask_t;
}

__Request__task_swap_exception_ports_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    new_port: mach_msg_port_descriptor_t;
    NDR: NDR_record_t;
    exception_mask: exception_mask_t;
    behavior: exception_behavior_t;
    new_flavor: thread_state_flavor_t;
}

__Request__lock_set_create_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    n_ulocks: s32;
    policy: s32;
}

__Request__lock_set_destroy_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    lock_set: mach_msg_port_descriptor_t;
}

__Request__semaphore_create_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    policy: s32;
    value: s32;
}

__Request__semaphore_destroy_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    semaphore: mach_msg_port_descriptor_t;
}

__Request__task_policy_set_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    flavor: task_policy_flavor_t;
    policy_infoCnt: mach_msg_type_number_t;
    policy_info: [16] s32;
}

__Request__task_policy_get_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    flavor: task_policy_flavor_t;
    policy_infoCnt: mach_msg_type_number_t;
    get_default: u32;
}

__Request__task_sample_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    reply: mach_msg_port_descriptor_t;
}

__Request__task_policy_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    policy: policy_t;
    baseCnt: mach_msg_type_number_t;
    base: [5] s32;
    set_limit: u32;
    change: u32;
}

__Request__task_set_emulation_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    routine_entry_pt: vm_address_t;
    routine_number: s32;
}

__Request__task_get_emulation_vector_t :: struct {
    Head: mach_msg_header_t;
}

__Request__task_set_emulation_vector_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    emulation_vector: mach_msg_ool_descriptor_t #align 4;
    NDR: NDR_record_t;
    vector_start: s32;
    emulation_vectorCnt: mach_msg_type_number_t;
}

__Request__task_set_ras_pc_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    basepc: vm_address_t;
    boundspc: vm_address_t;
}

__Request__task_zone_info_t :: struct {
    Head: mach_msg_header_t;
}

__Request__task_assign_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    new_set: mach_msg_port_descriptor_t;
    NDR: NDR_record_t;
    assign_threads: u32;
}

__Request__task_assign_default_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    assign_threads: u32;
}

__Request__task_get_assignment_t :: struct {
    Head: mach_msg_header_t;
}

__Request__task_set_policy_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    pset: mach_msg_port_descriptor_t;
    NDR: NDR_record_t;
    policy: policy_t;
    baseCnt: mach_msg_type_number_t;
    base: [5] s32;
    limitCnt: mach_msg_type_number_t;
    limit: [1] s32;
    change: u32;
}

__Request__task_get_state_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    flavor: thread_state_flavor_t;
    old_stateCnt: mach_msg_type_number_t;
}

__Request__task_set_state_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    flavor: thread_state_flavor_t;
    new_stateCnt: mach_msg_type_number_t;
    new_state: [614] u32;
}

__Request__task_set_phys_footprint_limit_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    new_limit: s32;
}

__Request__task_suspend2_t :: struct {
    Head: mach_msg_header_t;
}

__Request__task_resume2_t :: struct {
    Head: mach_msg_header_t;
}

__Request__task_purgable_info_t :: struct {
    Head: mach_msg_header_t;
}

__Request__task_get_mach_voucher_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    which: mach_voucher_selector_t;
}

__Request__task_set_mach_voucher_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    voucher: mach_msg_port_descriptor_t;
}

__Request__task_swap_mach_voucher_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    new_voucher: mach_msg_port_descriptor_t;
    old_voucher: mach_msg_port_descriptor_t;
}

__Request__task_generate_corpse_t :: struct {
    Head: mach_msg_header_t;
}

__Request__task_map_corpse_info_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    corspe_task: mach_msg_port_descriptor_t;
}

__Request__task_register_dyld_image_infos_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    dyld_images: mach_msg_ool_descriptor_t #align 4;
    NDR: NDR_record_t;
    dyld_imagesCnt: mach_msg_type_number_t;
}

__Request__task_unregister_dyld_image_infos_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    dyld_images: mach_msg_ool_descriptor_t #align 4;
    NDR: NDR_record_t;
    dyld_imagesCnt: mach_msg_type_number_t;
}

__Request__task_get_dyld_image_infos_t :: struct {
    Head: mach_msg_header_t;
}

__Request__task_register_dyld_shared_cache_image_info_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    dyld_cache_image: dyld_kernel_image_info_t;
    no_cache: u32;
    private_cache: u32;
}

__Request__task_register_dyld_set_dyld_state_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    dyld_state: u8;
    dyld_statePad: [3] u8;
}

__Request__task_register_dyld_get_process_state_t :: struct {
    Head: mach_msg_header_t;
}

__Request__task_map_corpse_info_64_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    corspe_task: mach_msg_port_descriptor_t;
}

__Request__task_inspect_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    flavor: task_inspect_flavor_t;
    info_outCnt: mach_msg_type_number_t;
}

__RequestUnion__task_subsystem :: union {
    Request_task_create: __Request__task_create_t;
    Request_task_terminate: __Request__task_terminate_t;
    Request_task_threads: __Request__task_threads_t;
    Request_mach_ports_register: __Request__mach_ports_register_t;
    Request_mach_ports_lookup: __Request__mach_ports_lookup_t;
    Request_task_info: __Request__task_info_t;
    Request_task_set_info: __Request__task_set_info_t;
    Request_task_suspend: __Request__task_suspend_t;
    Request_task_resume: __Request__task_resume_t;
    Request_task_get_special_port: __Request__task_get_special_port_t;
    Request_task_set_special_port: __Request__task_set_special_port_t;
    Request_thread_create: __Request__thread_create_t;
    Request_thread_create_running: __Request__thread_create_running_t;
    Request_task_set_exception_ports: __Request__task_set_exception_ports_t;
    Request_task_get_exception_ports: __Request__task_get_exception_ports_t;
    Request_task_swap_exception_ports: __Request__task_swap_exception_ports_t;
    Request_lock_set_create: __Request__lock_set_create_t;
    Request_lock_set_destroy: __Request__lock_set_destroy_t;
    Request_semaphore_create: __Request__semaphore_create_t;
    Request_semaphore_destroy: __Request__semaphore_destroy_t;
    Request_task_policy_set: __Request__task_policy_set_t;
    Request_task_policy_get: __Request__task_policy_get_t;
    Request_task_sample: __Request__task_sample_t;
    Request_task_policy: __Request__task_policy_t;
    Request_task_set_emulation: __Request__task_set_emulation_t;
    Request_task_get_emulation_vector: __Request__task_get_emulation_vector_t;
    Request_task_set_emulation_vector: __Request__task_set_emulation_vector_t;
    Request_task_set_ras_pc: __Request__task_set_ras_pc_t;
    Request_task_zone_info: __Request__task_zone_info_t;
    Request_task_assign: __Request__task_assign_t;
    Request_task_assign_default: __Request__task_assign_default_t;
    Request_task_get_assignment: __Request__task_get_assignment_t;
    Request_task_set_policy: __Request__task_set_policy_t;
    Request_task_get_state: __Request__task_get_state_t;
    Request_task_set_state: __Request__task_set_state_t;
    Request_task_set_phys_footprint_limit: __Request__task_set_phys_footprint_limit_t;
    Request_task_suspend2: __Request__task_suspend2_t;
    Request_task_resume2: __Request__task_resume2_t;
    Request_task_purgable_info: __Request__task_purgable_info_t;
    Request_task_get_mach_voucher: __Request__task_get_mach_voucher_t;
    Request_task_set_mach_voucher: __Request__task_set_mach_voucher_t;
    Request_task_swap_mach_voucher: __Request__task_swap_mach_voucher_t;
    Request_task_generate_corpse: __Request__task_generate_corpse_t;
    Request_task_map_corpse_info: __Request__task_map_corpse_info_t;
    Request_task_register_dyld_image_infos: __Request__task_register_dyld_image_infos_t;
    Request_task_unregister_dyld_image_infos: __Request__task_unregister_dyld_image_infos_t;
    Request_task_get_dyld_image_infos: __Request__task_get_dyld_image_infos_t;
    Request_task_register_dyld_shared_cache_image_info: __Request__task_register_dyld_shared_cache_image_info_t;
    Request_task_register_dyld_set_dyld_state: __Request__task_register_dyld_set_dyld_state_t;
    Request_task_register_dyld_get_process_state: __Request__task_register_dyld_get_process_state_t;
    Request_task_map_corpse_info_64: __Request__task_map_corpse_info_64_t;
    Request_task_inspect: __Request__task_inspect_t;
}

__Reply__task_create_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    child_task: mach_msg_port_descriptor_t;
}

__Reply__task_terminate_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_threads_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    act_list: mach_msg_ool_ports_descriptor_t #align 4;
    NDR: NDR_record_t;
    act_listCnt: mach_msg_type_number_t;
}

__Reply__mach_ports_register_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__mach_ports_lookup_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    init_port_set: mach_msg_ool_ports_descriptor_t #align 4;
    NDR: NDR_record_t;
    init_port_setCnt: mach_msg_type_number_t;
}

__Reply__task_info_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
    task_info_outCnt: mach_msg_type_number_t;
    task_info_out: [52] s32;
}

__Reply__task_set_info_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_suspend_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_resume_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_get_special_port_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    special_port: mach_msg_port_descriptor_t;
}

__Reply__task_set_special_port_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__thread_create_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    child_act: mach_msg_port_descriptor_t;
}

__Reply__thread_create_running_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    child_act: mach_msg_port_descriptor_t;
}

__Reply__task_set_exception_ports_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_get_exception_ports_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    old_handlers: [32] mach_msg_port_descriptor_t;
    NDR: NDR_record_t;
    masksCnt: mach_msg_type_number_t;
    masks: [32] exception_mask_t;
    old_behaviors: [32] exception_behavior_t;
    old_flavors: [32] thread_state_flavor_t;
}

__Reply__task_swap_exception_ports_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    old_handlerss: [32] mach_msg_port_descriptor_t;
    NDR: NDR_record_t;
    masksCnt: mach_msg_type_number_t;
    masks: [32] exception_mask_t;
    old_behaviors: [32] exception_behavior_t;
    old_flavors: [32] thread_state_flavor_t;
}

__Reply__lock_set_create_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    new_lock_set: mach_msg_port_descriptor_t;
}

__Reply__lock_set_destroy_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__semaphore_create_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    semaphore: mach_msg_port_descriptor_t;
}

__Reply__semaphore_destroy_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_policy_set_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_policy_get_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
    policy_infoCnt: mach_msg_type_number_t;
    policy_info: [16] s32;
    get_default: u32;
}

__Reply__task_sample_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_policy_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_set_emulation_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_get_emulation_vector_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    emulation_vector: mach_msg_ool_descriptor_t #align 4;
    NDR: NDR_record_t;
    vector_start: s32;
    emulation_vectorCnt: mach_msg_type_number_t;
}

__Reply__task_set_emulation_vector_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_set_ras_pc_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_zone_info_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    names: mach_msg_ool_descriptor_t #align 4;
    info: mach_msg_ool_descriptor_t #align 4;
    NDR: NDR_record_t;
    namesCnt: mach_msg_type_number_t;
    infoCnt: mach_msg_type_number_t;
}

__Reply__task_assign_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_assign_default_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_get_assignment_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    assigned_set: mach_msg_port_descriptor_t;
}

__Reply__task_set_policy_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_get_state_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
    old_stateCnt: mach_msg_type_number_t;
    old_state: [614] u32;
}

__Reply__task_set_state_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_set_phys_footprint_limit_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
    old_limit: s32;
}

__Reply__task_suspend2_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    suspend_token: mach_msg_port_descriptor_t;
}

__Reply__task_resume2_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_purgable_info_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
    stats: task_purgable_info_t #align 4;
}

__Reply__task_get_mach_voucher_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    voucher: mach_msg_port_descriptor_t;
}

__Reply__task_set_mach_voucher_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_swap_mach_voucher_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    old_voucher: mach_msg_port_descriptor_t;
}

__Reply__task_generate_corpse_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    corpse_task_port: mach_msg_port_descriptor_t;
}

__Reply__task_map_corpse_info_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
    kcd_addr_begin: vm_address_t #align 4;
    kcd_size: u32;
}

__Reply__task_register_dyld_image_infos_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_unregister_dyld_image_infos_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_get_dyld_image_infos_t :: struct {
    Head: mach_msg_header_t;
    msgh_body: mach_msg_body_t;
    dyld_images: mach_msg_ool_descriptor_t #align 4;
    NDR: NDR_record_t;
    dyld_imagesCnt: mach_msg_type_number_t;
}

__Reply__task_register_dyld_shared_cache_image_info_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_register_dyld_set_dyld_state_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
}

__Reply__task_register_dyld_get_process_state_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
    dyld_process_state: dyld_kernel_process_info_t #align 4;
}

__Reply__task_map_corpse_info_64_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
    kcd_addr_begin: mach_vm_address_t #align 4;
    kcd_size: mach_vm_size_t #align 4;
}

__Reply__task_inspect_t :: struct {
    Head: mach_msg_header_t;
    NDR: NDR_record_t;
    RetCode: kern_return_t;
    info_outCnt: mach_msg_type_number_t;
    info_out: [4] s32;
}

__ReplyUnion__task_subsystem :: union {
    Reply_task_create: __Reply__task_create_t;
    Reply_task_terminate: __Reply__task_terminate_t;
    Reply_task_threads: __Reply__task_threads_t;
    Reply_mach_ports_register: __Reply__mach_ports_register_t;
    Reply_mach_ports_lookup: __Reply__mach_ports_lookup_t;
    Reply_task_info: __Reply__task_info_t;
    Reply_task_set_info: __Reply__task_set_info_t;
    Reply_task_suspend: __Reply__task_suspend_t;
    Reply_task_resume: __Reply__task_resume_t;
    Reply_task_get_special_port: __Reply__task_get_special_port_t;
    Reply_task_set_special_port: __Reply__task_set_special_port_t;
    Reply_thread_create: __Reply__thread_create_t;
    Reply_thread_create_running: __Reply__thread_create_running_t;
    Reply_task_set_exception_ports: __Reply__task_set_exception_ports_t;
    Reply_task_get_exception_ports: __Reply__task_get_exception_ports_t;
    Reply_task_swap_exception_ports: __Reply__task_swap_exception_ports_t;
    Reply_lock_set_create: __Reply__lock_set_create_t;
    Reply_lock_set_destroy: __Reply__lock_set_destroy_t;
    Reply_semaphore_create: __Reply__semaphore_create_t;
    Reply_semaphore_destroy: __Reply__semaphore_destroy_t;
    Reply_task_policy_set: __Reply__task_policy_set_t;
    Reply_task_policy_get: __Reply__task_policy_get_t;
    Reply_task_sample: __Reply__task_sample_t;
    Reply_task_policy: __Reply__task_policy_t;
    Reply_task_set_emulation: __Reply__task_set_emulation_t;
    Reply_task_get_emulation_vector: __Reply__task_get_emulation_vector_t;
    Reply_task_set_emulation_vector: __Reply__task_set_emulation_vector_t;
    Reply_task_set_ras_pc: __Reply__task_set_ras_pc_t;
    Reply_task_zone_info: __Reply__task_zone_info_t;
    Reply_task_assign: __Reply__task_assign_t;
    Reply_task_assign_default: __Reply__task_assign_default_t;
    Reply_task_get_assignment: __Reply__task_get_assignment_t;
    Reply_task_set_policy: __Reply__task_set_policy_t;
    Reply_task_get_state: __Reply__task_get_state_t;
    Reply_task_set_state: __Reply__task_set_state_t;
    Reply_task_set_phys_footprint_limit: __Reply__task_set_phys_footprint_limit_t;
    Reply_task_suspend2: __Reply__task_suspend2_t;
    Reply_task_resume2: __Reply__task_resume2_t;
    Reply_task_purgable_info: __Reply__task_purgable_info_t;
    Reply_task_get_mach_voucher: __Reply__task_get_mach_voucher_t;
    Reply_task_set_mach_voucher: __Reply__task_set_mach_voucher_t;
    Reply_task_swap_mach_voucher: __Reply__task_swap_mach_voucher_t;
    Reply_task_generate_corpse: __Reply__task_generate_corpse_t;
    Reply_task_map_corpse_info: __Reply__task_map_corpse_info_t;
    Reply_task_register_dyld_image_infos: __Reply__task_register_dyld_image_infos_t;
    Reply_task_unregister_dyld_image_infos: __Reply__task_unregister_dyld_image_infos_t;
    Reply_task_get_dyld_image_infos: __Reply__task_get_dyld_image_infos_t;
    Reply_task_register_dyld_shared_cache_image_info: __Reply__task_register_dyld_shared_cache_image_info_t;
    Reply_task_register_dyld_set_dyld_state: __Reply__task_register_dyld_set_dyld_state_t;
    Reply_task_register_dyld_get_process_state: __Reply__task_register_dyld_get_process_state_t;
    Reply_task_map_corpse_info_64: __Reply__task_map_corpse_info_64_t;
    Reply_task_inspect: __Reply__task_inspect_t;
}

#scope_file
libc :: #system_library "libc";
