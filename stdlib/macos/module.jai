// macOS system frameworks: FSEvents, CoreFoundation, Mach and kernel declarations.
FSEventStreamRef :: *struct {};
ConstFSEventStreamRef :: FSEventStreamRef;
FSEventStreamEventFlags :: u32;
FSEventStreamCreateFlags :: u32;
FSEventStreamEventId :: u64;
kFSEventStreamEventIdSinceNow :u64: 0xFFFFFFFFFFFFFFFF;
kFSEventStreamCreateFlagUseCFTypes :: 0x00000001;
kFSEventStreamCreateFlagFileEvents :: 0x00000010;
kFSEventStreamEventFlagMustScanSubDirs :: 0x00000001;
kFSEventStreamEventFlagItemCreated :: 0x00000100;
kFSEventStreamEventFlagItemRemoved :: 0x00000200;
kFSEventStreamEventFlagItemInodeMetaMod :: 0x00000400;
kFSEventStreamEventFlagItemRenamed :: 0x00000800;
kFSEventStreamEventFlagItemModified :: 0x00001000;
kFSEventStreamEventFlagItemFinderInfoMod :: 0x00002000;
kFSEventStreamEventFlagChangeOwner :: 0x00004000;
kFSEventStreamEventFlagItemIsFile :: 0x00010000;
kFSEventStreamEventFlagItemIsDir :: 0x00020000;
kFSEventStreamEventFlagItemIsSymlink :: 0x00040000;
FSEventStreamContext :: struct { version: CFIndex; info: *void; retain: CFAllocatorRetainCallBack; release: CFAllocatorReleaseCallBack; copyDescription: CFAllocatorCopyDescriptionCallBack; }
FSEventStreamCallback :: #type (streamRef: ConstFSEventStreamRef, clientCallBackInfo: *void, numEvents: u64, eventPaths: *void, eventFlags: *FSEventStreamEventFlags, eventIds: *FSEventStreamEventId) #c_call;
FSEventStreamCreate :: (allocator: CFAllocatorRef, callback: FSEventStreamCallback, _context: *FSEventStreamContext, pathsToWatch: CFArrayRef, sinceWhen: FSEventStreamEventId, latency: CFTimeInterval, flags: FSEventStreamCreateFlags) -> FSEventStreamRef #foreign CoreServices;
FSEventStreamScheduleWithRunLoop :: (streamRef: FSEventStreamRef, runLoop: CFRunLoopRef, runLoopMode: CFStringRef) #foreign CoreServices;
FSEventStreamStart :: (streamRef: FSEventStreamRef) -> bool #foreign CoreServices;
FSEventStreamStop :: (streamRef: FSEventStreamRef) #foreign CoreServices;
FSEventStreamInvalidate :: (streamRef: FSEventStreamRef) #foreign CoreServices;
FSEventStreamUnscheduleFromRunLoop :: (streamRef: FSEventStreamRef, runLoop: CFRunLoopRef, runLoopMode: CFStringRef) #foreign CoreServices;
FSEventStreamRelease :: (streamRef: FSEventStreamRef) #foreign CoreServices;
#import "POSIX";
#load "bindings/kernel.jai";
#load "bindings/mach.jai";
#load "bindings/core_foundation.jai";
#load "kevent.jai";
#scope_module
Boolean :: bool;
LangCode :: s16;
UTF32Char :: u32;
RegionCode :: s16;
ConstStringPtr :: *u8;
StringPtr :: *u8;
ConstStr255Param :: *u8;
dispatch_queue_t :: *struct{};
Block :: *struct{};
#scope_file
CoreServices :: #system_library "CoreServices";

#scope_export
#load "string-and-vm.jai";
