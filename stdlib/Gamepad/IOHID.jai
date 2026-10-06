// Minimal reviewed IOKit HID and CoreFoundation SDK surface, not display-driver bindings.
CFIndex :: s64;
CFTypeRef :: *void;
CFAllocatorRef :: *void;
CFArrayRef :: *void;
CFSetRef :: *void;
CFDictionaryRef :: *void;
CFStringRef :: *void;
CFRunLoopRef :: *void;
IOReturn :: s32;
IOOptionBits :: u32;
Boolean :: u8;
__IOHIDManager :: struct {}
__IOHIDDevice :: struct {}
__IOHIDElement :: struct {}
__IOHIDValue :: struct {}
IOHIDManagerRef :: *__IOHIDManager;
IOHIDDeviceRef :: *__IOHIDDevice;
IOHIDElementRef :: *__IOHIDElement;
IOHIDValueRef :: *__IOHIDValue;
IOHIDManagerCreate :: (allocator: CFAllocatorRef, options: IOOptionBits) -> IOHIDManagerRef #foreign IOKit;
IOHIDManagerOpen :: (manager: IOHIDManagerRef, options: IOOptionBits) -> IOReturn #foreign IOKit;
IOHIDManagerClose :: (manager: IOHIDManagerRef, options: IOOptionBits) -> IOReturn #foreign IOKit;
IOHIDManagerSetDeviceMatching :: (manager: IOHIDManagerRef, matching: CFDictionaryRef) #foreign IOKit;
IOHIDManagerCopyDevices :: (manager: IOHIDManagerRef) -> CFSetRef #foreign IOKit;
IOHIDManagerScheduleWithRunLoop :: (manager: IOHIDManagerRef, runLoop: CFRunLoopRef, runLoopMode: CFStringRef) #foreign IOKit;
IOHIDManagerUnscheduleFromRunLoop :: (manager: IOHIDManagerRef, runLoop: CFRunLoopRef, runLoopMode: CFStringRef) #foreign IOKit;
IOHIDDeviceConformsTo :: (device: IOHIDDeviceRef, usagePage: u32, usage: u32) -> Boolean #foreign IOKit;
IOHIDDeviceCopyMatchingElements :: (device: IOHIDDeviceRef, matching: CFDictionaryRef, options: IOOptionBits) -> CFArrayRef #foreign IOKit;
IOHIDDeviceGetValue :: (device: IOHIDDeviceRef, element: IOHIDElementRef, pValue: *IOHIDValueRef) -> IOReturn #foreign IOKit;
IOHIDElementGetType :: (element: IOHIDElementRef) -> u32 #foreign IOKit;
IOHIDElementGetUsagePage :: (element: IOHIDElementRef) -> u32 #foreign IOKit;
IOHIDElementGetUsage :: (element: IOHIDElementRef) -> u32 #foreign IOKit;
IOHIDElementGetLogicalMin :: (element: IOHIDElementRef) -> CFIndex #foreign IOKit;
IOHIDElementGetLogicalMax :: (element: IOHIDElementRef) -> CFIndex #foreign IOKit;
IOHIDValueGetIntegerValue :: (value: IOHIDValueRef) -> CFIndex #foreign IOKit;
CFRelease :: (value: CFTypeRef) #foreign CoreFoundation;
CFArrayGetCount :: (array: CFArrayRef) -> CFIndex #foreign CoreFoundation;
CFArrayGetValueAtIndex :: (array: CFArrayRef, index: CFIndex) -> *void #foreign CoreFoundation;
CFSetGetCount :: (set: CFSetRef) -> CFIndex #foreign CoreFoundation;
CFSetGetValues :: (set: CFSetRef, values: **void) #foreign CoreFoundation;
CFRunLoopGetCurrent :: () -> CFRunLoopRef #foreign CoreFoundation;
CFRunLoopRunInMode :: (mode: CFStringRef, seconds: float64, returnAfterSourceHandled: Boolean) -> s32 #foreign CoreFoundation;
kCFRunLoopDefaultMode: CFStringRef #elsewhere CoreFoundation;
#scope_file
IOKit :: #system_library "IOKit";
CoreFoundation :: #system_library "CoreFoundation";
