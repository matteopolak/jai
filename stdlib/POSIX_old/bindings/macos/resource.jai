// macOS declarations: <sys/resource.h>.
PRIO_PROCESS :: 0;
PRIO_PGRP :: 1;
PRIO_USER :: 2;
PRIO_DARWIN_THREAD :: 3;
PRIO_DARWIN_PROCESS :: 4;
PRIO_MIN :: -20;
PRIO_MAX :: 20;
PRIO_DARWIN_BG :: 0x1000;
PRIO_DARWIN_NONUI :: 0x1001;
RUSAGE :: enum {
    SELF :: 0;
    CHILDREN :: -1;
    RUSAGE_SELF :: SELF;
    RUSAGE_CHILDREN :: CHILDREN;
}
RUSAGE_INFO :: enum {
    V0 :: 0;
    V1 :: 1;
    V2 :: 2;
    V3 :: 3;
    V4 :: 4;
    CURRENT :: V4;
    RUSAGE_INFO_V0 :: V0;
    RUSAGE_INFO_V1 :: V1;
    RUSAGE_INFO_V2 :: V2;
    RUSAGE_INFO_V3 :: V3;
    RUSAGE_INFO_V4 :: V4;
    RUSAGE_INFO_CURRENT :: CURRENT;
}
RLIM_INFINITY :: ((cast(u64)1) << 63) - 1;
RLIM_SAVED_MAX :: RLIM_INFINITY;
RLIM_SAVED_CUR :: RLIM_INFINITY;
RLIMIT_CPU :: 0;
RLIMIT_FSIZE :: 1;
RLIMIT_DATA :: 2;
RLIMIT_STACK :: 3;
RLIMIT_CORE :: 4;
RLIMIT_AS :: 5;
RLIMIT_RSS :: RLIMIT_AS;
RLIMIT_MEMLOCK :: 6;
RLIMIT_NPROC :: 7;
RLIMIT_NOFILE :: 8;
RLIM_NLIMITS :: 9;
_RLIMIT_POSIX_FLAG :: 0x1000;
RLIMIT_WAKEUPS_MONITOR :: 0x1;
RLIMIT_CPU_USAGE_MONITOR :: 0x2;
RLIMIT_THREAD_CPULIMITS :: 0x3;
WAKEMON_ENABLE :: 0x01;
WAKEMON_DISABLE :: 0x02;
WAKEMON_GET_PARAMS :: 0x04;
WAKEMON_SET_DEFAULTS :: 0x08;
WAKEMON_MAKE_FATAL :: 0x10;
CPUMON_MAKE_FATAL :: 0x1000;
IOPOL_TYPE_DISK :: 0;
IOPOL_SCOPE_PROCESS :: 0;
IOPOL_SCOPE_THREAD :: 1;
IOPOL_SCOPE_DARWIN_BG :: 2;
IOPOL_DEFAULT :: 0;
IOPOL_IMPORTANT :: 1;
IOPOL_PASSIVE :: 2;
IOPOL_THROTTLE :: 3;
IOPOL_UTILITY :: 4;
IOPOL_STANDARD :: 5;
IOPOL_APPLICATION :: IOPOL_STANDARD;
IOPOL_NORMAL :: IOPOL_IMPORTANT;
id_t :: u32;
rlim_t :: u64;
rusage :: struct {
    ru_utime: timeval;
    ru_stime: timeval;
    ru_maxrss: s64;
    ru_ixrss: s64;
    ru_idrss: s64;
    ru_isrss: s64;
    ru_minflt: s64;
    ru_majflt: s64;
    ru_nswap: s64;
    ru_inblock: s64;
    ru_oublock: s64;
    ru_msgsnd: s64;
    ru_msgrcv: s64;
    ru_nsignals: s64;
    ru_nvcsw: s64;
    ru_nivcsw: s64;
}
rusage_info_t :: *void;
rusage_info_v0 :: struct {
    ri_uuid: [16] u8;
    ri_user_time: u64;
    ri_system_time: u64;
    ri_pkg_idle_wkups: u64;
    ri_interrupt_wkups: u64;
    ri_pageins: u64;
    ri_wired_size: u64;
    ri_resident_size: u64;
    ri_phys_footprint: u64;
    ri_proc_start_abstime: u64;
    ri_proc_exit_abstime: u64;
}
rusage_info_v1 :: struct {
    ri_uuid: [16] u8;
    ri_user_time: u64;
    ri_system_time: u64;
    ri_pkg_idle_wkups: u64;
    ri_interrupt_wkups: u64;
    ri_pageins: u64;
    ri_wired_size: u64;
    ri_resident_size: u64;
    ri_phys_footprint: u64;
    ri_proc_start_abstime: u64;
    ri_proc_exit_abstime: u64;
    ri_child_user_time: u64;
    ri_child_system_time: u64;
    ri_child_pkg_idle_wkups: u64;
    ri_child_interrupt_wkups: u64;
    ri_child_pageins: u64;
    ri_child_elapsed_abstime: u64;
}
rusage_info_v2 :: struct {
    ri_uuid: [16] u8;
    ri_user_time: u64;
    ri_system_time: u64;
    ri_pkg_idle_wkups: u64;
    ri_interrupt_wkups: u64;
    ri_pageins: u64;
    ri_wired_size: u64;
    ri_resident_size: u64;
    ri_phys_footprint: u64;
    ri_proc_start_abstime: u64;
    ri_proc_exit_abstime: u64;
    ri_child_user_time: u64;
    ri_child_system_time: u64;
    ri_child_pkg_idle_wkups: u64;
    ri_child_interrupt_wkups: u64;
    ri_child_pageins: u64;
    ri_child_elapsed_abstime: u64;
    ri_diskio_bytesread: u64;
    ri_diskio_byteswritten: u64;
}
rusage_info_v3 :: struct {
    ri_uuid: [16] u8;
    ri_user_time: u64;
    ri_system_time: u64;
    ri_pkg_idle_wkups: u64;
    ri_interrupt_wkups: u64;
    ri_pageins: u64;
    ri_wired_size: u64;
    ri_resident_size: u64;
    ri_phys_footprint: u64;
    ri_proc_start_abstime: u64;
    ri_proc_exit_abstime: u64;
    ri_child_user_time: u64;
    ri_child_system_time: u64;
    ri_child_pkg_idle_wkups: u64;
    ri_child_interrupt_wkups: u64;
    ri_child_pageins: u64;
    ri_child_elapsed_abstime: u64;
    ri_diskio_bytesread: u64;
    ri_diskio_byteswritten: u64;
    ri_cpu_time_qos_default: u64;
    ri_cpu_time_qos_maintenance: u64;
    ri_cpu_time_qos_background: u64;
    ri_cpu_time_qos_utility: u64;
    ri_cpu_time_qos_legacy: u64;
    ri_cpu_time_qos_user_initiated: u64;
    ri_cpu_time_qos_user_interactive: u64;
    ri_billed_system_time: u64;
    ri_serviced_system_time: u64;
}
rusage_info_v4 :: struct {
    ri_uuid: [16] u8;
    ri_user_time: u64;
    ri_system_time: u64;
    ri_pkg_idle_wkups: u64;
    ri_interrupt_wkups: u64;
    ri_pageins: u64;
    ri_wired_size: u64;
    ri_resident_size: u64;
    ri_phys_footprint: u64;
    ri_proc_start_abstime: u64;
    ri_proc_exit_abstime: u64;
    ri_child_user_time: u64;
    ri_child_system_time: u64;
    ri_child_pkg_idle_wkups: u64;
    ri_child_interrupt_wkups: u64;
    ri_child_pageins: u64;
    ri_child_elapsed_abstime: u64;
    ri_diskio_bytesread: u64;
    ri_diskio_byteswritten: u64;
    ri_cpu_time_qos_default: u64;
    ri_cpu_time_qos_maintenance: u64;
    ri_cpu_time_qos_background: u64;
    ri_cpu_time_qos_utility: u64;
    ri_cpu_time_qos_legacy: u64;
    ri_cpu_time_qos_user_initiated: u64;
    ri_cpu_time_qos_user_interactive: u64;
    ri_billed_system_time: u64;
    ri_serviced_system_time: u64;
    ri_logical_writes: u64;
    ri_lifetime_max_phys_footprint: u64;
    ri_instructions: u64;
    ri_cycles: u64;
    ri_billed_energy: u64;
    ri_serviced_energy: u64;
    ri_unused: [2] u64;
}
rusage_info_current :: rusage_info_v4;
rlimit :: struct {
    rlim_cur: rlim_t;
    rlim_max: rlim_t;
}
proc_rlimit_control_wakeupmon :: struct {
    wm_flags: u32;
    wm_rate: s32;
}
getpriority :: (unknown0: s32, unknown1: id_t) -> s32 #foreign libc;
getiopolicy_np :: (unknown0: s32, unknown1: s32) -> s32 #foreign libc;
getrlimit :: (unknown0: s32, unknown1: *rlimit) -> s32 #foreign libc;
getrusage :: (unknown0: s32, unknown1: *rusage) -> s32 #foreign libc;
setpriority :: (unknown0: s32, unknown1: id_t, unknown2: s32) -> s32 #foreign libc;
setiopolicy_np :: (unknown0: s32, unknown1: s32, unknown2: s32) -> s32 #foreign libc;
setrlimit :: (unknown0: s32, unknown1: *rlimit) -> s32 #foreign libc;
#scope_file
libc :: #system_library "libc";
