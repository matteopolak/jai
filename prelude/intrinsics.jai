// Declarations bind to checked compiler/VM operations; no native library import.
get_current_workspace :: () -> Workspace #compiler {
    return cast(Workspace) 0;
}

memset :: (dest: *void, value: u8, count: s64) #intrinsic;
memcpy :: (dest: *void, source: *void, count: s64) #intrinsic;
memcmp :: (a: *void, b: *void, count: s64) -> s16 #must #intrinsic;

compare_and_swap :: (pointer: *$T, old: T, new: T)
    -> (success: bool, old_value: T) #intrinsic;
