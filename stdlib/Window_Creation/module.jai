// Independently normalized ABI contract. No reference procedure bodies or binaries.
#module_parameters ( DEFAULT_MSAA : s32 = 4 ) ;
#if OS == . WINDOWS {
    #load "windows.jai" ;
}
else #if OS == . LINUX {
    #load "linux.jai" ;
}
else #if OS == . MACOS {
    #load "osx.jai" ;
}
else #if OS == . PS5 {
    #load "ps5.jai" ;
}
else #if OS == . ANDROID {
    #load "android.jai" ;
}
else {
    #assert ( false ) ;
}
#scope_module
#import "Basic" ;
DEFAULT_WINDOW_CREATION_COLOR :: float .[ 0.15 , 0.15 , 0.2 ] ;
#scope_export
WT :: #import "Window_Type" ;
Window_Type :: WT . Window_Type ;
