#scope_module
#import "POSIX";
#scope_export
Per_OS_Critical_Section_Type :: pthread_mutex_t;
Per_OS_Condition_Variable_Type :: pthread_cond_t;
Native_Thread_Handle :: pthread_t;
#if OS == .MACOS Native_Semaphore_Handle :: u32;
else Native_Semaphore_Handle :: sem_t;
