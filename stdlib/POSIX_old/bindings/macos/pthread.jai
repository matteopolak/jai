// macOS declarations: <pthread.h>.
__PTHREAD_SIZE__ :: 8176;
__PTHREAD_ATTR_SIZE__ :: 56;
__PTHREAD_MUTEXATTR_SIZE__ :: 8;
__PTHREAD_MUTEX_SIZE__ :: 56;
__PTHREAD_CONDATTR_SIZE__ :: 8;
__PTHREAD_COND_SIZE__ :: 40;
__PTHREAD_ONCE_SIZE__ :: 8;
__PTHREAD_RWLOCK_SIZE__ :: 192;
__PTHREAD_RWLOCKATTR_SIZE__ :: 16;
QOS_MIN_RELATIVE_PRIORITY :: -15;
PTHREAD_CREATE_JOINABLE :: 1;
PTHREAD_CREATE_DETACHED :: 2;
PTHREAD_INHERIT_SCHED :: 1;
PTHREAD_EXPLICIT_SCHED :: 2;
PTHREAD_CANCEL_ENABLE :: 0x01;
PTHREAD_CANCEL_DISABLE :: 0x00;
PTHREAD_CANCEL_DEFERRED :: 0x02;
PTHREAD_CANCEL_ASYNCHRONOUS :: 0x00;
PTHREAD_SCOPE_SYSTEM :: 1;
PTHREAD_SCOPE_PROCESS :: 2;
PTHREAD_PROCESS_SHARED :: 1;
PTHREAD_PROCESS_PRIVATE :: 2;
PTHREAD_PRIO_NONE :: 0;
PTHREAD_PRIO_INHERIT :: 1;
PTHREAD_PRIO_PROTECT :: 2;
PTHREAD_MUTEX_NORMAL :: 0;
PTHREAD_MUTEX_ERRORCHECK :: 1;
PTHREAD_MUTEX_RECURSIVE :: 2;
PTHREAD_MUTEX_DEFAULT :: PTHREAD_MUTEX_NORMAL;
_JBLEN :: (9 * 2) + 3 + 16;
_PTHREAD_MUTEX_POLICY_NONE :: 0;
_PTHREAD_MUTEX_POLICY_FAIRSHARE :: 1;
_PTHREAD_MUTEX_POLICY_FIRSTFIT :: 2;
__darwin_pthread_handler_rec :: struct {
    __routine: #type (unknown0: *void) -> void #c_call;
    __arg: *void;
    __next: *__darwin_pthread_handler_rec;
}
_opaque_pthread_attr_t :: struct {
    __sig: s64;
    __opaque: [56] u8;
}
_opaque_pthread_cond_t :: struct {
    __sig: s64;
    __opaque: [40] u8;
}
_opaque_pthread_condattr_t :: struct {
    __sig: s64;
    __opaque: [8] u8;
}
_opaque_pthread_mutex_t :: struct {
    __sig: s64;
    __opaque: [56] u8;
}
_opaque_pthread_mutexattr_t :: struct {
    __sig: s64;
    __opaque: [8] u8;
}
_opaque_pthread_once_t :: struct {
    __sig: s64;
    __opaque: [8] u8;
}
_opaque_pthread_rwlock_t :: struct {
    __sig: s64;
    __opaque: [192] u8;
}
_opaque_pthread_rwlockattr_t :: struct {
    __sig: s64;
    __opaque: [16] u8;
}
_opaque_pthread_t :: struct {
    __sig: s64;
    __cleanup_stack: *__darwin_pthread_handler_rec;
    __opaque: [8176] u8;
}
sched_param :: struct {
    sched_priority: s32;
    __opaque: [4] u8;
}
sched_yield :: () -> s32 #foreign libc;
sched_get_priority_min :: (unknown0: s32) -> s32 #foreign libc;
sched_get_priority_max :: (unknown0: s32) -> s32 #foreign libc;
pthread_attr_t :: _opaque_pthread_attr_t;
pthread_cond_t :: _opaque_pthread_cond_t;
pthread_condattr_t :: _opaque_pthread_condattr_t;
pthread_key_t :: u64;
pthread_mutex_t :: _opaque_pthread_mutex_t;
pthread_mutexattr_t :: _opaque_pthread_mutexattr_t;
pthread_once_t :: _opaque_pthread_once_t;
pthread_rwlock_t :: _opaque_pthread_rwlock_t;
pthread_rwlockattr_t :: _opaque_pthread_rwlockattr_t;
pthread_t :: *_opaque_pthread_t;
QOS_CLASS :: enum u32 {
    USER_INTERACTIVE :: 33;
    USER_INITIATED :: 25;
    DEFAULT :: 21;
    UTILITY :: 17;
    BACKGROUND :: 9;
    UNSPECIFIED :: 0;
    QOS_CLASS_USER_INTERACTIVE :: USER_INTERACTIVE;
    QOS_CLASS_USER_INITIATED :: USER_INITIATED;
    QOS_CLASS_DEFAULT :: DEFAULT;
    QOS_CLASS_UTILITY :: UTILITY;
    QOS_CLASS_BACKGROUND :: BACKGROUND;
    QOS_CLASS_UNSPECIFIED :: UNSPECIFIED;
}
qos_class_t :: u32;
qos_class_self :: () -> qos_class_t #foreign libc;
qos_class_main :: () -> qos_class_t #foreign libc;
pthread_attr_set_qos_class_np :: (__attr: *pthread_attr_t, __qos_class: qos_class_t, __relative_priority: s32) -> s32 #foreign libc;
pthread_attr_get_qos_class_np :: (__attr: *pthread_attr_t, __qos_class: *qos_class_t, __relative_priority: *s32) -> s32 #foreign libc;
pthread_set_qos_class_self_np :: (__qos_class: qos_class_t, __relative_priority: s32) -> s32 #foreign libc;
pthread_get_qos_class_np :: (__pthread: pthread_t, __qos_class: *qos_class_t, __relative_priority: *s32) -> s32 #foreign libc;
pthread_override_s :: struct {}
pthread_override_t :: *pthread_override_s;
pthread_override_qos_class_start_np :: (__pthread: pthread_t, __qos_class: qos_class_t, __relative_priority: s32) -> pthread_override_t #foreign libc;
pthread_override_qos_class_end_np :: (__override: pthread_override_t) -> s32 #foreign libc;
pthread_atfork :: (unknown0: #type () -> void #c_call, unknown1: #type () -> void #c_call, unknown2: #type () -> void #c_call) -> s32 #foreign libc;
pthread_attr_destroy :: (unknown0: *pthread_attr_t) -> s32 #foreign libc;
pthread_attr_getdetachstate :: (unknown0: *pthread_attr_t, unknown1: *s32) -> s32 #foreign libc;
pthread_attr_getguardsize :: (unknown0: *pthread_attr_t, unknown1: *u64) -> s32 #foreign libc;
pthread_attr_getinheritsched :: (unknown0: *pthread_attr_t, unknown1: *s32) -> s32 #foreign libc;
pthread_attr_getschedparam :: (unknown0: *pthread_attr_t, unknown1: *sched_param) -> s32 #foreign libc;
pthread_attr_getschedpolicy :: (unknown0: *pthread_attr_t, unknown1: *s32) -> s32 #foreign libc;
pthread_attr_getscope :: (unknown0: *pthread_attr_t, unknown1: *s32) -> s32 #foreign libc;
pthread_attr_getstack :: (unknown0: *pthread_attr_t, unknown1: **void, unknown2: *u64) -> s32 #foreign libc;
pthread_attr_getstackaddr :: (unknown0: *pthread_attr_t, unknown1: **void) -> s32 #foreign libc;
pthread_attr_getstacksize :: (unknown0: *pthread_attr_t, unknown1: *u64) -> s32 #foreign libc;
pthread_attr_init :: (unknown0: *pthread_attr_t) -> s32 #foreign libc;
pthread_attr_setdetachstate :: (unknown0: *pthread_attr_t, unknown1: s32) -> s32 #foreign libc;
pthread_attr_setguardsize :: (unknown0: *pthread_attr_t, unknown1: u64) -> s32 #foreign libc;
pthread_attr_setinheritsched :: (unknown0: *pthread_attr_t, unknown1: s32) -> s32 #foreign libc;
pthread_attr_setschedparam :: (unknown0: *pthread_attr_t, unknown1: *sched_param) -> s32 #foreign libc;
pthread_attr_setschedpolicy :: (unknown0: *pthread_attr_t, unknown1: s32) -> s32 #foreign libc;
pthread_attr_setscope :: (unknown0: *pthread_attr_t, unknown1: s32) -> s32 #foreign libc;
pthread_attr_setstack :: (unknown0: *pthread_attr_t, unknown1: *void, unknown2: u64) -> s32 #foreign libc;
pthread_attr_setstackaddr :: (unknown0: *pthread_attr_t, unknown1: *void) -> s32 #foreign libc;
pthread_attr_setstacksize :: (unknown0: *pthread_attr_t, unknown1: u64) -> s32 #foreign libc;
pthread_cancel :: (unknown0: pthread_t) -> s32 #foreign libc;
pthread_cond_broadcast :: (unknown0: *pthread_cond_t) -> s32 #foreign libc;
pthread_cond_destroy :: (unknown0: *pthread_cond_t) -> s32 #foreign libc;
pthread_cond_init :: (unknown0: *pthread_cond_t, unknown1: *pthread_condattr_t) -> s32 #foreign libc;
pthread_cond_signal :: (unknown0: *pthread_cond_t) -> s32 #foreign libc;
pthread_cond_timedwait :: (unknown0: *pthread_cond_t, unknown1: *pthread_mutex_t, unknown2: *timespec) -> s32 #foreign libc;
pthread_cond_wait :: (unknown0: *pthread_cond_t, unknown1: *pthread_mutex_t) -> s32 #foreign libc;
pthread_condattr_destroy :: (unknown0: *pthread_condattr_t) -> s32 #foreign libc;
pthread_condattr_init :: (unknown0: *pthread_condattr_t) -> s32 #foreign libc;
pthread_condattr_getpshared :: (unknown0: *pthread_condattr_t, unknown1: *s32) -> s32 #foreign libc;
pthread_condattr_setpshared :: (unknown0: *pthread_condattr_t, unknown1: s32) -> s32 #foreign libc;
pthread_create :: (unknown0: *pthread_t, unknown1: *pthread_attr_t, unknown2: #type (unknown0: *void) -> *void #c_call, unknown3: *void) -> s32 #foreign libc;
pthread_detach :: (unknown0: pthread_t) -> s32 #foreign libc;
pthread_equal :: (unknown0: pthread_t, unknown1: pthread_t) -> s32 #foreign libc;
pthread_exit :: (unknown0: *void) -> void #foreign libc;
pthread_getconcurrency :: () -> s32 #foreign libc;
pthread_getschedparam :: (unknown0: pthread_t, unknown1: *s32, unknown2: *sched_param) -> s32 #foreign libc;
pthread_getspecific :: (unknown0: pthread_key_t) -> *void #foreign libc;
pthread_join :: (unknown0: pthread_t, unknown1: **void) -> s32 #foreign libc;
pthread_key_create :: (unknown0: *pthread_key_t, unknown1: #type (unknown0: *void) -> void #c_call) -> s32 #foreign libc;
pthread_key_delete :: (unknown0: pthread_key_t) -> s32 #foreign libc;
pthread_mutex_destroy :: (unknown0: *pthread_mutex_t) -> s32 #foreign libc;
pthread_mutex_getprioceiling :: (unknown0: *pthread_mutex_t, unknown1: *s32) -> s32 #foreign libc;
pthread_mutex_init :: (unknown0: *pthread_mutex_t, unknown1: *pthread_mutexattr_t) -> s32 #foreign libc;
pthread_mutex_lock :: (unknown0: *pthread_mutex_t) -> s32 #foreign libc;
pthread_mutex_setprioceiling :: (unknown0: *pthread_mutex_t, unknown1: s32, unknown2: *s32) -> s32 #foreign libc;
pthread_mutex_trylock :: (unknown0: *pthread_mutex_t) -> s32 #foreign libc;
pthread_mutex_unlock :: (unknown0: *pthread_mutex_t) -> s32 #foreign libc;
pthread_mutexattr_destroy :: (unknown0: *pthread_mutexattr_t) -> s32 #foreign libc;
pthread_mutexattr_getprioceiling :: (unknown0: *pthread_mutexattr_t, unknown1: *s32) -> s32 #foreign libc;
pthread_mutexattr_getprotocol :: (unknown0: *pthread_mutexattr_t, unknown1: *s32) -> s32 #foreign libc;
pthread_mutexattr_getpshared :: (unknown0: *pthread_mutexattr_t, unknown1: *s32) -> s32 #foreign libc;
pthread_mutexattr_gettype :: (unknown0: *pthread_mutexattr_t, unknown1: *s32) -> s32 #foreign libc;
pthread_mutexattr_init :: (unknown0: *pthread_mutexattr_t) -> s32 #foreign libc;
pthread_mutexattr_setprioceiling :: (unknown0: *pthread_mutexattr_t, unknown1: s32) -> s32 #foreign libc;
pthread_mutexattr_setprotocol :: (unknown0: *pthread_mutexattr_t, unknown1: s32) -> s32 #foreign libc;
pthread_mutexattr_setpshared :: (unknown0: *pthread_mutexattr_t, unknown1: s32) -> s32 #foreign libc;
pthread_mutexattr_settype :: (unknown0: *pthread_mutexattr_t, unknown1: s32) -> s32 #foreign libc;
pthread_once :: (unknown0: *pthread_once_t, unknown1: #type () -> void #c_call) -> s32 #foreign libc;
pthread_rwlock_destroy :: (unknown0: *pthread_rwlock_t) -> s32 #foreign libc;
pthread_rwlock_init :: (unknown0: *pthread_rwlock_t, unknown1: *pthread_rwlockattr_t) -> s32 #foreign libc;
pthread_rwlock_rdlock :: (unknown0: *pthread_rwlock_t) -> s32 #foreign libc;
pthread_rwlock_tryrdlock :: (unknown0: *pthread_rwlock_t) -> s32 #foreign libc;
pthread_rwlock_trywrlock :: (unknown0: *pthread_rwlock_t) -> s32 #foreign libc;
pthread_rwlock_wrlock :: (unknown0: *pthread_rwlock_t) -> s32 #foreign libc;
pthread_rwlock_unlock :: (unknown0: *pthread_rwlock_t) -> s32 #foreign libc;
pthread_rwlockattr_destroy :: (unknown0: *pthread_rwlockattr_t) -> s32 #foreign libc;
pthread_rwlockattr_getpshared :: (unknown0: *pthread_rwlockattr_t, unknown1: *s32) -> s32 #foreign libc;
pthread_rwlockattr_init :: (unknown0: *pthread_rwlockattr_t) -> s32 #foreign libc;
pthread_rwlockattr_setpshared :: (unknown0: *pthread_rwlockattr_t, unknown1: s32) -> s32 #foreign libc;
pthread_self :: () -> pthread_t #foreign libc;
pthread_setcancelstate :: (unknown0: s32, unknown1: *s32) -> s32 #foreign libc;
pthread_setcanceltype :: (unknown0: s32, unknown1: *s32) -> s32 #foreign libc;
pthread_setconcurrency :: (unknown0: s32) -> s32 #foreign libc;
pthread_setschedparam :: (unknown0: pthread_t, unknown1: s32, unknown2: *sched_param) -> s32 #foreign libc;
pthread_setspecific :: (unknown0: pthread_key_t, unknown1: *void) -> s32 #foreign libc;
pthread_testcancel :: () -> void #foreign libc;
pthread_is_threaded_np :: () -> s32 #foreign libc;
pthread_threadid_np :: (unknown0: pthread_t, unknown1: *u64) -> s32 #foreign libc;
pthread_getname_np :: (unknown0: pthread_t, unknown1: *u8, unknown2: u64) -> s32 #foreign libc;
pthread_setname_np :: (unknown0: *u8) -> s32 #foreign libc;
pthread_main_np :: () -> s32 #foreign libc;
pthread_mach_thread_np :: (unknown0: pthread_t) -> mach_port_t #foreign libc;
pthread_get_stacksize_np :: (unknown0: pthread_t) -> u64 #foreign libc;
pthread_get_stackaddr_np :: (unknown0: pthread_t) -> *void #foreign libc;
pthread_cond_signal_thread_np :: (unknown0: *pthread_cond_t, unknown1: pthread_t) -> s32 #foreign libc;
pthread_cond_timedwait_relative_np :: (unknown0: *pthread_cond_t, unknown1: *pthread_mutex_t, unknown2: *timespec) -> s32 #foreign libc;
pthread_create_suspended_np :: (unknown0: *pthread_t, unknown1: *pthread_attr_t, unknown2: #type (unknown0: *void) -> *void #c_call, unknown3: *void) -> s32 #foreign libc;
pthread_kill :: (unknown0: pthread_t, unknown1: s32) -> s32 #foreign libc;
pthread_from_mach_thread_np :: (unknown0: mach_port_t) -> pthread_t #foreign libc;
pthread_sigmask :: (unknown0: s32, unknown1: *sigset_t, unknown2: *sigset_t) -> s32 #foreign libc;
pthread_yield_np :: () -> void #foreign libc;
jmp_buf :: [37] s32;
sigjmp_buf :: [38] s32;
setjmp :: (unknown0: *jmp_buf) -> s32 #foreign libc;
longjmp :: (unknown0: *jmp_buf, unknown1: s32) -> void #foreign libc;
_setjmp :: (unknown0: *jmp_buf) -> s32 #foreign libc;
_longjmp :: (unknown0: *jmp_buf, unknown1: s32) -> void #foreign libc;
sigsetjmp :: (unknown0: *sigjmp_buf, unknown1: s32) -> s32 #foreign libc;
siglongjmp :: (unknown0: *sigjmp_buf, unknown1: s32) -> void #foreign libc;
longjmperror :: () -> void #foreign libc;
pthread_mutexattr_setpolicy_np :: (unknown0: *pthread_mutexattr_t, unknown1: s32) -> s32 #foreign libc;
pthread_mutexattr_getpolicy_np :: (unknown0: *pthread_mutexattr_t, unknown1: *s32) -> s32 #foreign libc;
_pthread_mutex_enable_legacy_mode :: () -> void #foreign libc;
pthread_create_from_mach_thread :: (unknown0: *pthread_t, unknown1: *pthread_attr_t, unknown2: #type (unknown0: *void) -> *void #c_call, unknown3: *void) -> s32 #foreign libc;
#scope_file
libc :: #system_library "libc";
