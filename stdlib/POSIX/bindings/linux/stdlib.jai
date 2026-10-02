// Normalized API contracts; reference procedure bodies were discarded.
getenv :: (__name: *u8) -> *u8 #foreign libc;
setenv :: (__name: *u8, __value: *u8, __replace: s32) -> s32 #foreign libc;
unsetenv :: (__name: *u8) -> s32 #foreign libc;
mktemp :: (__template: *u8) -> *u8 #foreign libc;
mkstemp :: (__template: *u8) -> s32 #foreign libc;
mkstemps :: (__template: *u8, __suffixlen: s32) -> s32 #foreign libc;
mkdtemp :: (__template: *u8) -> *u8 #foreign libc;
mkostemp :: (__template: *u8, __flags: s32) -> s32 #foreign libc;
mkostemps :: (__template: *u8, __suffixlen: s32, __flags: s32) -> s32 #foreign libc;
system :: (__command: *u8) -> s32 #foreign libc;
realpath :: (__name: *u8, __resolved: *u8) -> *u8 #foreign libc;
#scope_file
libc :: #system_library "libc";
