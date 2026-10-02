// Independently normalized ABI contract. No reference procedure bodies or binaries.
#import "X11" ;
#import "POSIX" ;
x_fib_show :: ( dpy : * Display , parent : Window , x : s32 , y : s32 ) -> s32 #foreign libsofd ;
x_fib_close :: ( dpy : * Display ) -> void #foreign libsofd ;
x_fib_handle_events :: ( dpy : * Display , event : * XEvent ) -> s32 #foreign libsofd ;
x_fib_status :: ( ) -> s32 #foreign libsofd ;
x_fib_filename :: ( ) -> * u8 #foreign libsofd ;
x_fib_configure :: ( k : s32 , v : * u8 ) -> s32 #foreign libsofd ;
x_fib_cfg_buttons :: ( k : s32 , v : s32 ) -> s32 #foreign libsofd ;
x_fib_cfg_filter_callback :: ( cb : #type ( a0 : * u8 , * void ) -> s32 #c_call , user_data : * void ) -> s32 #foreign libsofd ;
x_fib_free_recent :: ( ) -> void #foreign libsofd ;
x_fib_add_recent :: ( path : * u8 , atime : time_t ) -> s32 #foreign libsofd ;
x_fib_recent_file :: ( appname : * u8 ) -> * u8 #foreign libsofd ;
x_fib_save_recent :: ( fn : * u8 ) -> s32 #foreign libsofd ;
x_fib_load_recent :: ( fn : * u8 ) -> s32 #foreign libsofd ;
x_fib_recent_count :: ( ) -> u32 #foreign libsofd ;
x_fib_recent_at :: ( i : u32 ) -> * u8 #foreign libsofd ;
#scope_file
libsofd :: #system_library "jai-stdlib-unavailable-sofd" ;
