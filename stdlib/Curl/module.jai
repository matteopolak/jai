// Independently normalized ABI contract. No reference procedure bodies or binaries.
#module_parameters ( ) ( LINUX_USE_SYSTEM_LIBRARY := false ) ;
#if OS == . WINDOWS {
    #load "windows.jai" ;
    #scope_module
    time_t :: s64 ;
    FILE :: void ;
}
else #if OS_IS_UNIX {
    #load "unix.jai" ;
    #import "POSIX" ;
}
#import "Socket" ;
#load "format.jai";
