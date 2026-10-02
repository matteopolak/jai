// Normalized API contracts; reference procedure bodies were discarded.
Android_Poll_Source :: struct {
    id: s32;
    app: *Android_App;
    process: #type (app: *Android_App, source: *Android_Poll_Source) -> void #c_call;
}
Android_App :: struct {
    userData: *void;
    onAppCmd: #type (app: *Android_App, cmd: s32) -> void #c_call;
    onInputEvent: #type (app: *Android_App, event: *AInputEvent) -> s32 #c_call;
    activity: *ANativeActivity;
    config: *AConfiguration;
    savedState: *void;
    savedStateSize: u64;
    looper: *ALooper;
    inputQueue: *AInputQueue;
    window: *ANativeWindow;
    contentRect: ARect;
    activityState: s32;
    destroyRequested: s32;
    mutex: pthread_mutex_t;
    cond: pthread_cond_t;
    msgread: s32;
    msgwrite: s32;
    thread: pthread_t;
    cmdPollSource: Android_Poll_Source;
    inputPollSource: Android_Poll_Source;
    running: s32;
    stateSaved: s32;
    destroyed: s32;
    redrawNeeded: s32;
    pendingInputQueue: *AInputQueue;
    pendingWindow: *ANativeWindow;
    pendingContentRect: ARect;
}
LOOPER_ID :: enum u32 {
    MAIN :: 1;
    INPUT :: 2;
    USER :: 3;
}
APP_CMD :: enum u32 {
    INPUT_CHANGED :: 0;
    INIT_WINDOW :: 1;
    TERM_WINDOW :: 2;
    WINDOW_RESIZED :: 3;
    WINDOW_REDRAW_NEEDED :: 4;
    CONTENT_RECT_CHANGED :: 5;
    GAINED_FOCUS :: 6;
    LOST_FOCUS :: 7;
    CONFIG_CHANGED :: 8;
    LOW_MEMORY :: 9;
    START :: 10;
    RESUME :: 11;
    SAVE_STATE :: 12;
    PAUSE :: 13;
    STOP :: 14;
    DESTROY :: 15;
}
#scope_file
#if CPU == .X64 {
} else #if CPU == .ARM64 {
}
