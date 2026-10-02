#module_parameters (LOAD_THREAD_GROUP := true)(CACHE_LINE_SIZE: s32 = 64, DO_RACE_DETECTOR := false);
#load "primitives.jai";
#if LOAD_THREAD_GROUP #load "thread_group.jai";
Mutex_Order :: s32;
#scope_module
#import "Basic";
#import "Atomics";
DEBUG :: false;
next_thread_index: u32 = 1;
#assert !DO_RACE_DETECTOR;
