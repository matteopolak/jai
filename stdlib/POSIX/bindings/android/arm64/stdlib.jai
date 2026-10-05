// Android arm64 declarations: <stdlib.h>.
getenv :: (__name: *u8) -> *u8 #foreign libc;
setenv :: (__name: *u8, __value: *u8, __overwrite: s32) -> s32 #foreign libc;
unsetenv :: (__name: *u8) -> s32 #foreign libc;
mkdtemp :: (__template: *u8) -> *u8 #foreign libc;
mktemp :: (__template: *u8) -> *u8 #foreign libc;
mkostemp :: (__template: *u8, __flags: s32) -> s32 #foreign libc;
mkostemps :: (__template: *u8, __suffix_length: s32, __flags: s32) -> s32 #foreign libc;
mkstemp :: (__template: *u8) -> s32 #foreign libc;
mkstemps :: (__template: *u8, __flags: s32) -> s32 #foreign libc;
realpath :: (__path: *u8, __resolved: *u8) -> *u8 #foreign libc;
system :: (__command: *u8) -> s32 #foreign libc;
#scope_file
libc :: #system_library "libc";
