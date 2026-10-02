// Normalized API contracts; reference procedure bodies were discarded.
USER_ADDR_NULL :: cast(user_addr_t) 0;
__mbstate_t :: union {
    __mbstate8: [128] u8;
    _mbstateL: s64;
}
register_t :: s64;
user_addr_t :: u64;
user_size_t :: u64;
user_ssize_t :: s64;
user_long_t :: s64;
user_ulong_t :: u64;
user_time_t :: s64;
user_off_t :: s64;
syscall_arg_t :: u64;
#scope_file
