// Stable metrics records only. Compiler serialization and plugins remain pending.
#module_parameters(USAGE_MODE := Usage_Mode.WRITE) {
    Usage_Mode :: enum_flags u32 {
        WRITE :: 1;
        READ :: 2;
    }
};

Metrics :: struct {
    if_points: s32 #align 1;
    maximum_if_depth: s32 #align 1;
    maximum_loop_depth: s32 #align 1;
    total_calls: s32 #align 1;
    same_file_calls: s32 #align 1;
    same_module_calls: s32 #align 1;
    nonconstant_calls: s32 #align 1;
    allocations: s32 #align 1;
    frees: s32 #align 1;
    reassignments: s32 #align 1;
    global_reads: s32 #align 1;
    global_writes: s32 #align 1;
}

Revision_Control_Type :: enum u64 {
    UNKNOWN :: 0;
    SVN :: 1;
    GIT :: 2;
    KRAMPVS :: 3;
    MERCURIAL :: 4;
    PERFORCE :: 5;
}
