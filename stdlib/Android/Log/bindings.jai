// Android log (liblog) declarations.
Log_Priority :: enum u32 {
    UNKNOWN :: 0;
    DEFAULT :: 1;
    VERBOSE :: 2;
    DEBUG :: 3;
    INFO :: 4;
    WARN :: 5;
    ERROR :: 6;
    FATAL :: 7;
    SILENT :: 8;
}
__android_log_write :: (prio: Log_Priority, tag: *u8, text: *u8) -> s32 #foreign liblog;
__android_log_print :: (prio: Log_Priority, tag: *u8, fmt: *u8, __args: ..Any) -> s32 #foreign liblog;
__android_log_assert :: (cond: *u8, tag: *u8, fmt: *u8, __args: ..Any) -> void #foreign liblog;
Log_Id :: enum u32 {
    MIN :: 0;
    MAIN :: 0;
    RADIO :: 1;
    EVENTS :: 2;
    SYSTEM :: 3;
    CRASH :: 4;
    STATS :: 5;
    SECURITY :: 6;
    KERNEL :: 7;
    MAX :: 8;
    DEFAULT :: 2147483647;
}
__android_log_buf_write :: (bufID: Log_Id, prio: Log_Priority, tag: *u8, text: *u8) -> s32 #foreign liblog;
__android_log_buf_print :: (bufID: Log_Id, prio: Log_Priority, tag: *u8, fmt: *u8, __args: ..Any) -> s32 #foreign liblog;
Log_Message :: struct {
    struct_size: u64;
    buffer_id: s32;
    priority: s32;
    tag: *u8;
    file: *u8;
    line: u32;
    message: *u8;
}
__android_logger_function :: #type (log_message: *Log_Message) -> void #c_call;
__android_aborter_function :: #type (abort_message: *u8) -> void #c_call;
__android_log_write_log_message :: (log_message: *Log_Message) -> void #foreign liblog;
__android_log_set_logger :: (logger: __android_logger_function) -> void #foreign liblog;
__android_log_logd_logger :: (log_message: *Log_Message) -> void #foreign liblog;
__android_log_stderr_logger :: (log_message: *Log_Message) -> void #foreign liblog;
__android_log_set_aborter :: (aborter: __android_aborter_function) -> void #foreign liblog;
__android_log_call_aborter :: (abort_message: *u8) -> void #foreign liblog;
__android_log_default_aborter :: (abort_message: *u8) -> void #foreign liblog;
__android_log_is_loggable :: (prio: Log_Priority, tag: *u8, default_prio: s32) -> s32 #foreign liblog;
__android_log_is_loggable_len :: (prio: Log_Priority, tag: *u8, len: u64, default_prio: s32) -> s32 #foreign liblog;
__android_log_set_minimum_priority :: (priority: Log_Priority) -> s32 #foreign liblog;
__android_log_get_minimum_priority :: () -> Log_Priority #foreign liblog;
__android_log_set_default_tag :: (tag: *u8) -> void #foreign liblog;
#scope_file
liblog :: #system_library "liblog";
