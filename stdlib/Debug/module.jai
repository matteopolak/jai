// Maintained Debug API; host behavior is implemented by the explicit compatibility layer.
init :: () {
    Host_Debug.init();
}
attach_to_debugger :: () {
    attached := Host_Debug.attach_to_debugger();
    if !attached Host_Debug.output("No debugger is attached; automatic debugger launch is unavailable.\n");
}
breakpoint :: () {
    Host_Debug.breakpoint();
}
#scope_module
Host_Debug :: #import,file "../legacy/Debug/module.jai"(USE_GRAPHICS=false);
