// Normalized API contracts; reference procedure bodies were discarded.
init_objective_c_foundation :: () {
    _sel.URLByAppendingPathComponent_ = cast(Selector) sel_registerName(cast(*u8) "URLByAppendingPathComponent:\0");
    _sel.URLByDeletingLastPathComponent = cast(Selector) sel_registerName(cast(*u8) "URLByDeletingLastPathComponent\0");
    _sel.URLForDirectory_inDomain_appropriateForURL_create_error_ = cast(Selector) sel_registerName(cast(*u8) "URLForDirectory:inDomain:appropriateForURL:create:error:\0");
    _sel.URLWithString_ = cast(Selector) sel_registerName(cast(*u8) "URLWithString:\0");
    _sel.UTF8String = cast(Selector) sel_registerName(cast(*u8) "UTF8String\0");
    _sel.activeProcessorCount = cast(Selector) sel_registerName(cast(*u8) "activeProcessorCount\0");
    _sel.addObserver_selector_name_object_ = cast(Selector) sel_registerName(cast(*u8) "addObserver:selector:name:object:\0");
    _sel.arguments = cast(Selector) sel_registerName(cast(*u8) "arguments\0");
    _sel.arrayWithObject_ = cast(Selector) sel_registerName(cast(*u8) "arrayWithObject:\0");
    _sel.arrayWithObjects_count_ = cast(Selector) sel_registerName(cast(*u8) "arrayWithObjects:count:\0");
    _sel.automaticTerminationSupportEnabled = cast(Selector) sel_registerName(cast(*u8) "automaticTerminationSupportEnabled\0");
    _sel.bytes = cast(Selector) sel_registerName(cast(*u8) "bytes\0");
    _sel.containsObject_ = cast(Selector) sel_registerName(cast(*u8) "containsObject:\0");
    _sel.count = cast(Selector) sel_registerName(cast(*u8) "count\0");
    _sel.currentHost = cast(Selector) sel_registerName(cast(*u8) "currentHost\0");
    _sel.currentRunLoop = cast(Selector) sel_registerName(cast(*u8) "currentRunLoop\0");
    _sel.dataUsingEncoding_allowLossyConversion_ = cast(Selector) sel_registerName(cast(*u8) "dataUsingEncoding:allowLossyConversion:\0");
    _sel.defaultCenter = cast(Selector) sel_registerName(cast(*u8) "defaultCenter\0");
    _sel.defaultManager = cast(Selector) sel_registerName(cast(*u8) "defaultManager\0");
    _sel.detachNewThreadSelector_toTarget_withObject_ = cast(Selector) sel_registerName(cast(*u8) "detachNewThreadSelector:toTarget:withObject:\0");
    _sel.disableAutomaticTermination_ = cast(Selector) sel_registerName(cast(*u8) "disableAutomaticTermination:\0");
    _sel.disableSuddenTermination = cast(Selector) sel_registerName(cast(*u8) "disableSuddenTermination\0");
    _sel.distantFuture = cast(Selector) sel_registerName(cast(*u8) "distantFuture\0");
    _sel.distantPast = cast(Selector) sel_registerName(cast(*u8) "distantPast\0");
    _sel.drain = cast(Selector) sel_registerName(cast(*u8) "drain\0");
    _sel.enableAutomaticTermination_ = cast(Selector) sel_registerName(cast(*u8) "enableAutomaticTermination:\0");
    _sel.enableSuddenTermination = cast(Selector) sel_registerName(cast(*u8) "enableSuddenTermination\0");
    _sel.environment = cast(Selector) sel_registerName(cast(*u8) "environment\0");
    _sel.fileURLWithPath_ = cast(Selector) sel_registerName(cast(*u8) "fileURLWithPath:\0");
    _sel.fileURLWithPath_isDirectory_ = cast(Selector) sel_registerName(cast(*u8) "fileURLWithPath:isDirectory:\0");
    _sel.globallyUniqueString = cast(Selector) sel_registerName(cast(*u8) "globallyUniqueString\0");
    _sel.hasDirectoryPath = cast(Selector) sel_registerName(cast(*u8) "hasDirectoryPath\0");
    _sel.hostName = cast(Selector) sel_registerName(cast(*u8) "hostName\0");
    _sel.initWithBytes_length_encoding_ = cast(Selector) sel_registerName(cast(*u8) "initWithBytes:length:encoding:\0");
    _sel.isMultiThreaded = cast(Selector) sel_registerName(cast(*u8) "isMultiThreaded\0");
    _sel.isOperatingSystemAtLeastVersion_ = cast(Selector) sel_registerName(cast(*u8) "isOperatingSystemAtLeastVersion:\0");
    _sel.lastPathComponent = cast(Selector) sel_registerName(cast(*u8) "lastPathComponent\0");
    _sel.length = cast(Selector) sel_registerName(cast(*u8) "length\0");
    _sel.localizedDescription = cast(Selector) sel_registerName(cast(*u8) "localizedDescription\0");
    _sel.localizedName = cast(Selector) sel_registerName(cast(*u8) "localizedName\0");
    _sel.mainBundle = cast(Selector) sel_registerName(cast(*u8) "mainBundle\0");
    _sel.object = cast(Selector) sel_registerName(cast(*u8) "object\0");
    _sel.objectAtIndex_ = cast(Selector) sel_registerName(cast(*u8) "objectAtIndex:\0");
    _sel.operatingSystem = cast(Selector) sel_registerName(cast(*u8) "operatingSystem\0");
    _sel.operatingSystemName = cast(Selector) sel_registerName(cast(*u8) "operatingSystemName\0");
    _sel.operatingSystemVersion = cast(Selector) sel_registerName(cast(*u8) "operatingSystemVersion\0");
    _sel.operatingSystemVersionString = cast(Selector) sel_registerName(cast(*u8) "operatingSystemVersionString\0");
    _sel.path = cast(Selector) sel_registerName(cast(*u8) "path\0");
    _sel.physicalMemory = cast(Selector) sel_registerName(cast(*u8) "physicalMemory\0");
    _sel.processIdentifier = cast(Selector) sel_registerName(cast(*u8) "processIdentifier\0");
    _sel.processInfo = cast(Selector) sel_registerName(cast(*u8) "processInfo\0");
    _sel.processName = cast(Selector) sel_registerName(cast(*u8) "processName\0");
    _sel.processorCount = cast(Selector) sel_registerName(cast(*u8) "processorCount\0");
    _sel.resourcePath = cast(Selector) sel_registerName(cast(*u8) "resourcePath\0");
    _sel.run = cast(Selector) sel_registerName(cast(*u8) "run\0");
    _sel.scheduledTimerWithTimeInterval_target_selector_userInfo_repeats_ = cast(Selector) sel_registerName(cast(*u8) "scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:\0");
    _sel.setAutomaticTerminationSupportEnabled_ = cast(Selector) sel_registerName(cast(*u8) "setAutomaticTerminationSupportEnabled:\0");
    _sel.setProcessName_ = cast(Selector) sel_registerName(cast(*u8) "setProcessName:\0");
    _sel.showPools = cast(Selector) sel_registerName(cast(*u8) "showPools\0");
    _sel.stringByExpandingTildeInPath = cast(Selector) sel_registerName(cast(*u8) "stringByExpandingTildeInPath\0");
    _sel.systemUptime = cast(Selector) sel_registerName(cast(*u8) "systemUptime\0");
}
NSTimeInterval :: float64;
NSFullUserName :: () -> *NSString #foreign Foundation_Framework;
NSUserName :: () -> *NSString #foreign Foundation_Framework;
NSHomeDirectory :: () -> *NSString #foreign Foundation_Framework;
NSHomeDirectoryForUser :: (username: *NSString) -> *NSString #foreign Foundation_Framework;
NSAutoreleasePool :: struct {
    using #as super: NSObject;
    drain :: (self: *NSAutoreleasePool) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "drain\0"));
    }
    showPools :: () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) objc_getClass(cast(*u8) "NSAutoreleasePool\0"), sel_registerName(cast(*u8) "showPools\0"));
    }
}
NSRange :: struct {
    location: NSUInteger;
    length: NSUInteger;
}
NSBundle :: struct {
    using #as super: NSObject;
    resourcePath :: (self: *NSBundle) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "resourcePath\0"));
    }
    mainBundle :: () -> *NSBundle {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSBundle #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSBundle\0"), sel_registerName(cast(*u8) "mainBundle\0"));
    }
}
NSDate :: struct {
    using #as super: NSObject;
    distantPast :: () -> *NSDate {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSDate #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSDate\0"), sel_registerName(cast(*u8) "distantPast\0"));
    }
    distantFuture :: () -> *NSDate {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSDate #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSDate\0"), sel_registerName(cast(*u8) "distantFuture\0"));
    }
}
NSPoint :: struct {
    x: CGFloat;
    y: CGFloat;
}
CGFloat :: float64;
CGSize :: struct {
    width : CGFloat;
    height: CGFloat;
}
NSMakePoint :: (x: CGFloat, y: CGFloat) -> NSPoint {
    return NSPoint.{x, y};
}
NSSize :: CGSize;
NSMakeSize :: (w: CGFloat, h: CGFloat) -> NSSize {
    return NSSize.{w, h};
}
NSRect :: struct {
    origin: NSPoint;
    size: NSSize;
}
NSMakeRect :: (x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) -> NSRect {
    return NSRect.{NSMakePoint(x, y), NSMakeSize(w, h)};
}
NSStringEncoding :: NSUInteger;
NSUTF8StringEncoding :: 4;
NSUTF32StringEncoding :: 0x8c000100;
NSUTF32LittleEndianStringEncoding :: 0x9c000100;
NSString :: struct {
    using #as super: NSObject;
    initWithBytes :: (self: *NSString, bytes: *void, length: NSUInteger, encoding: NSStringEncoding) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, bytes: *void, length: NSUInteger, encoding: NSStringEncoding) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "initWithBytes:length:encoding:\0"), bytes, length, encoding);
    }
    UTF8String :: (self: *NSString) -> *u8 {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *u8 #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "UTF8String\0"));
    }
    dataUsingEncoding :: (self: *NSString, encoding: NSStringEncoding, allowLossyConversion := NO) -> *NSData {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, encoding: NSStringEncoding, allowLossyConversion: BOOL) -> *NSData #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "dataUsingEncoding:allowLossyConversion:\0"), encoding, allowLossyConversion);
    }
    stringByExpandingTildeInPath :: (self: *NSString) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "stringByExpandingTildeInPath\0"));
    }
    length :: (self: *NSString) -> NSUInteger {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "length\0"));
    }
    initWithString :: (self: *NSString, str: string) -> *NSString {
        if str.count < 0 return null;
        return NSString.initWithBytes(self, str.data, cast(NSUInteger) str.count, NSUTF8StringEncoding);
    }
    getTempString :: (str: string) -> *NSString {
        value := objc_alloc(NSString);
        value = NSString.initWithString(value, str);
        return cast(*NSString) autorelease(value);
    }
}
NSRunLoopMode :: *NSString;
NSPasteboardType :: *NSString;
NSColorSpaceName :: *NSString;
NSWindowsNTOperatingSystem :: 1;
NSWindows95OperatingSystem :: 2;
NSSolarisOperatingSystem :: 3;
NSHPUXOperatingSystem :: 4;
NSMACHOperatingSystem :: 5;
NSSunOSOperatingSystem :: 6;
NSOSF1OperatingSystem :: 7;
NSOperatingSystemVersion :: struct {
    majorVersion: NSInteger;
    minorVersion: NSInteger;
    patchVersion: NSInteger;
}
NSTimer :: struct {
    using #as super: NSObject;
    scheduledTimerWithTimeInterval :: (interval: NSTimeInterval, target: id, selector: Selector, userInfo: id, repeats: BOOL) -> *NSTimer {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, interval: NSTimeInterval, target: id, selector: Selector, userInfo: id, repeats: BOOL) -> *NSTimer #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSTimer\0"), sel_registerName(cast(*u8) "scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:\0"), interval, target, selector, userInfo, repeats);
    }
}
NSRunLoop :: struct {
    using #as super: NSObject;
    currentRunLoop :: () -> *NSRunLoop {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSRunLoop #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSRunLoop\0"), sel_registerName(cast(*u8) "currentRunLoop\0"));
    }
    run :: (self: *NSRunLoop) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "run\0"));
    }
}
NSProcessInfo :: struct {
    using nsobject: NSObject;
    _environment: *NSDictionary(*NSString, *NSString);
    _arguments: *NSArray(*NSString);
    _hostName: *NSString;
    _name: *NSString;
    automaticTerminationOptOutCounter: NSInteger;
    operatingSystem :: (self: *NSProcessInfo) -> NSUInteger {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "operatingSystem\0"));
    }
    operatingSystemName :: (self: *NSProcessInfo) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "operatingSystemName\0"));
    }
    isOperatingSystemAtLeastVersion :: (self: *NSProcessInfo, version: NSOperatingSystemVersion) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, version: NSOperatingSystemVersion) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "isOperatingSystemAtLeastVersion:\0"), version);
    }
    disableSuddenTermination :: (self: *NSProcessInfo) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "disableSuddenTermination\0"));
    }
    enableSuddenTermination :: (self: *NSProcessInfo) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "enableSuddenTermination\0"));
    }
    disableAutomaticTermination :: (self: *NSProcessInfo, reason: *NSString) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, reason: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "disableAutomaticTermination:\0"), reason);
    }
    enableAutomaticTermination :: (self: *NSProcessInfo, reason: *NSString) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, reason: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "enableAutomaticTermination:\0"), reason);
    }
    processInfo :: () -> *NSProcessInfo {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSProcessInfo #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSProcessInfo\0"), sel_registerName(cast(*u8) "processInfo\0"));
    }
    environment :: (self: *NSProcessInfo) -> *NSDictionary {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSDictionary #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "environment\0"));
    }
    arguments :: (self: *NSProcessInfo) -> *NSArray(*NSString) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSArray(*NSString) #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "arguments\0"));
    }
    hostName :: (self: *NSProcessInfo) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "hostName\0"));
    }
    processName :: (self: *NSProcessInfo) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "processName\0"));
    }
    setProcessName :: (self: *NSProcessInfo, processName: *NSString) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, processName: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setProcessName:\0"), processName);
    }
    processIdentifier :: (self: *NSProcessInfo) -> s32 {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> s32 #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "processIdentifier\0"));
    }
    globallyUniqueString :: (self: *NSProcessInfo) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "globallyUniqueString\0"));
    }
    operatingSystemVersionString :: (self: *NSProcessInfo) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "operatingSystemVersionString\0"));
    }
    operatingSystemVersion :: (self: *NSProcessInfo) -> NSOperatingSystemVersion {
        #if CPU == .X64 {
            result: NSOperatingSystemVersion;
            invoke: (output: *NSOperatingSystemVersion, sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend_stret;
            invoke(*result, cast(*void) self, sel_registerName(cast(*u8) "operatingSystemVersion\0"));
            return result;
        } else {
            invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSOperatingSystemVersion #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend;
            return invoke(cast(*void) self, sel_registerName(cast(*u8) "operatingSystemVersion\0"));
        }
    }
    processorCount :: (self: *NSProcessInfo) -> NSUInteger {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "processorCount\0"));
    }
    activeProcessorCount :: (self: *NSProcessInfo) -> NSUInteger {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "activeProcessorCount\0"));
    }
    physicalMemory :: (self: *NSProcessInfo) -> u64 {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> u64 #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "physicalMemory\0"));
    }
    systemUptime :: (self: *NSProcessInfo) -> NSTimeInterval {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSTimeInterval #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "systemUptime\0"));
    }
    automaticTerminationSupportEnabled :: (self: *NSProcessInfo) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "automaticTerminationSupportEnabled\0"));
    }
    setAutomaticTerminationSupportEnabled :: (self: *NSProcessInfo, automaticTerminationSupportEnabled: BOOL) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, automaticTerminationSupportEnabled: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setAutomaticTerminationSupportEnabled:\0"), automaticTerminationSupportEnabled);
    }
}
using NSActivityOptions :: enum u64 {
    NSActivityIdleDisplaySleepDisabled :: 1099511627776;
    NSActivityIdleSystemSleepDisabled :: 1048576;
    NSActivitySuddenTerminationDisabled :: 16384;
    NSActivityAutomaticTerminationDisabled :: 32768;
    NSActivityUserInitiated :: 16777215;
    NSActivityUserInitiatedAllowingIdleSystemSleep :: 15728639;
    NSActivityBackground :: 255;
    NSActivityLatencyCritical :: 1095216660480;
}
using NSProcessInfoThermalState :: enum s64 {
    NSProcessInfoThermalStateNominal :: 0;
    NSProcessInfoThermalStateFair :: 1;
    NSProcessInfoThermalStateSerious :: 2;
    NSProcessInfoThermalStateCritical :: 3;
}
NSThread :: struct {
    _nsobject: NSObject;
    detachNewThreadSelectorToTargetWithObject :: (sel: Selector, toTarget: id, withObject: id) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, sel: Selector, toTarget: id, withObject: id) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) objc_getClass(cast(*u8) "NSThread\0"), sel_registerName(cast(*u8) "detachNewThreadSelector:toTarget:withObject:\0"), sel, toTarget, withObject);
    }
    isMultiThreaded :: () -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSThread\0"), sel_registerName(cast(*u8) "isMultiThreaded\0"));
    }
}
NSNotification :: struct {
    using #as super: NSObject;
    object :: (self: *NSNotification) -> *NSObject {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSObject #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "object\0"));
    }
}
NSNotificationCenter :: struct {
    using #as super: NSObject;
    defaultCenter :: () -> *NSNotificationCenter {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSNotificationCenter #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSNotificationCenter\0"), sel_registerName(cast(*u8) "defaultCenter\0"));
    }
    addObserver :: (self: *NSNotificationCenter, observer: id, selector: Selector, name: NSNotificationName, object: id) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, observer: id, selector: Selector, name: NSNotificationName, object: id) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "addObserver:selector:name:object:\0"), observer, selector, name, object);
    }
}
NSNotificationName :: *NSString;
NSURL :: struct {
    using #as super: NSObject;
    URLWithString :: (str: *NSString) -> *NSURL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, str: *NSString) -> *NSURL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSURL\0"), sel_registerName(cast(*u8) "URLWithString:\0"), str);
    }
    fileURLWithPath :: (path: *NSString) -> *NSURL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, path: *NSString) -> *NSURL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSURL\0"), sel_registerName(cast(*u8) "fileURLWithPath:\0"), path);
    }
    fileURLWithPath :: (path: *NSString, isDirectory: BOOL) -> *NSURL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, path: *NSString, isDirectory: BOOL) -> *NSURL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSURL\0"), sel_registerName(cast(*u8) "fileURLWithPath:isDirectory:\0"), path, isDirectory);
    }
    path :: (self: *NSURL) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "path\0"));
    }
    URLByDeletingLastPathComponent :: (self: *NSURL) -> *NSURL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSURL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "URLByDeletingLastPathComponent\0"));
    }
    hasDirectoryPath :: (self: *NSURL) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "hasDirectoryPath\0"));
    }
    URLByAppendingPathComponent :: (self: *NSURL, comp: *NSString) -> *NSURL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, comp: *NSString) -> *NSURL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "URLByAppendingPathComponent:\0"), comp);
    }
    lastPathComponent :: (self: *NSURL) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "lastPathComponent\0"));
    }
}
NSData :: struct {
    using #as super: NSObject;
    bytes :: (self: *NSData) -> *void {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "bytes\0"));
    }
    length :: (self: *NSData) -> NSUInteger {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "length\0"));
    }
}
NSDictionary :: struct (key: Type, value: Type) {
    using #as super: NSObject;
}
NSArray :: struct (Object_Type: Type) {
    using #as super: NSObject;
    arrayWithObject :: (obj: Object_Type) -> *NSArray(Object_Type) {
        #assert type_info(Object_Type).type == .POINTER;
        invoke: (sdk_receiver: *void, sdk_selector: SEL, obj: Object_Type) -> *NSArray(Object_Type) #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSArray\0"), sel_registerName(cast(*u8) "arrayWithObject:\0"), obj);
    }
    arrayWithObjects :: (objs: *Object_Type, count: NSUInteger) -> *NSArray(Object_Type) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, objs: *Object_Type, count: NSUInteger) -> *NSArray(Object_Type) #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSArray\0"), sel_registerName(cast(*u8) "arrayWithObjects:count:\0"), objs, count);
    }
    containsObject :: (self: *NSArray(Object_Type), anObject: Object_Type) -> BOOL {
        #assert type_info(Object_Type).type == .POINTER;
        invoke: (sdk_receiver: *void, sdk_selector: SEL, anObject: Object_Type) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "containsObject:\0"), anObject);
    }
    objectAtIndex :: (self: *NSArray(Object_Type), index: NSUInteger) -> Object_Type {
        #assert type_info(Object_Type).type == .POINTER;
        invoke: (sdk_receiver: *void, sdk_selector: SEL, index: NSUInteger) -> *void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return cast(Object_Type) invoke(cast(*void) self, sel_registerName(cast(*u8) "objectAtIndex:\0"), index);
    }
    count :: (self: *NSArray(Object_Type)) -> NSUInteger {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "count\0"));
    }
}
NSFileManager :: struct {
    using #as super: NSObject;
    defaultManager :: () -> *NSFileManager {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSFileManager #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSFileManager\0"), sel_registerName(cast(*u8) "defaultManager\0"));
    }
    URLForDirectory :: (self: *NSFileManager, dir: NSSearchPathDirectory, inDomain: NSSearchPathDomainMask, appropriateForURL: *NSURL, create: BOOL, error: **NSError) -> *NSURL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, dir: NSSearchPathDirectory, inDomain: NSSearchPathDomainMask, appropriateForURL: *NSURL, create: BOOL, error: **NSError) -> *NSURL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "URLForDirectory:inDomain:appropriateForURL:create:error:\0"), dir, inDomain, appropriateForURL, create, error);
    }
}
using NSSearchPathDirectory :: enum u64 {
    NSApplicationDirectory :: 1;
    NSDemoApplicationDirectory;
    NSDeveloperApplicationDirectory;
    NSAdminApplicationDirectory;
    NSLibraryDirectory;
    NSDeveloperDirectory;
    NSUserDirectory;
    NSDocumentationDirectory;
    NSDocumentDirectory;
    NSCoreServiceDirectory;
    NSAutosavedInformationDirectory :: 11;
    NSDesktopDirectory :: 12;
    NSCachesDirectory :: 13;
    NSApplicationSupportDirectory :: 14;
    NSDownloadsDirectory :: 15;
    NSInputMethodsDirectory :: 16;
    NSMoviesDirectory :: 17;
    NSMusicDirectory :: 18;
    NSPicturesDirectory :: 19;
    NSPrinterDescriptionDirectory :: 20;
    NSSharedPublicDirectory :: 21;
    NSPreferencePanesDirectory :: 22;
    NSApplicationScriptsDirectory :: 23;
    NSItemReplacementDirectory :: 99;
    NSAllApplicationsDirectory :: 100;
    NSAllLibrariesDirectory :: 101;
    NSTrashDirectory :: 102;
}
using NSSearchPathDomainMask :: enum_flags u64 {
    NSUserDomainMask :: 1;
    NSLocalDomainMask :: 2;
    NSNetworkDomainMask :: 4;
    NSSystemDomainMask :: 8;
    NSAllDomainsMask :: 0x0ffff;
}
NSError :: struct {
    using #as super: NSObject;
    localizedDescription :: (self: *NSError) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "localizedDescription\0"));
    }
}
NSHost :: struct {
    using #as super: NSObject;
    currentHost :: () -> *NSHost {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSHost #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSHost\0"), sel_registerName(cast(*u8) "currentHost\0"));
    }
    localizedName :: (self: *NSHost) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "localizedName\0"));
    }
}
CALayer :: struct {
    using nsobject: NSObject;
}
#scope_module
Foundation_Framework :: #system_library "Foundation";
#scope_file
_sel: struct {
    drain: Selector;
    showPools: Selector;
    resourcePath: Selector;
    mainBundle: Selector;
    distantPast: Selector;
    distantFuture: Selector;
    initWithBytes_length_encoding_: Selector;
    UTF8String: Selector;
    dataUsingEncoding_allowLossyConversion_: Selector;
    stringByExpandingTildeInPath: Selector;
    scheduledTimerWithTimeInterval_target_selector_userInfo_repeats_: Selector;
    currentRunLoop: Selector;
    run: Selector;
    operatingSystem: Selector;
    operatingSystemName: Selector;
    isOperatingSystemAtLeastVersion_: Selector;
    disableSuddenTermination: Selector;
    enableSuddenTermination: Selector;
    disableAutomaticTermination_: Selector;
    enableAutomaticTermination_: Selector;
    processInfo: Selector;
    environment: Selector;
    arguments: Selector;
    hostName: Selector;
    processName: Selector;
    setProcessName_: Selector;
    processIdentifier: Selector;
    globallyUniqueString: Selector;
    operatingSystemVersionString: Selector;
    operatingSystemVersion: Selector;
    processorCount: Selector;
    activeProcessorCount: Selector;
    physicalMemory: Selector;
    systemUptime: Selector;
    automaticTerminationSupportEnabled: Selector;
    setAutomaticTerminationSupportEnabled_: Selector;
    detachNewThreadSelector_toTarget_withObject_: Selector;
    isMultiThreaded: Selector;
    object: Selector;
    defaultCenter: Selector;
    addObserver_selector_name_object_: Selector;
    URLWithString_: Selector;
    fileURLWithPath_: Selector;
    fileURLWithPath_isDirectory_: Selector;
    path: Selector;
    URLByDeletingLastPathComponent: Selector;
    hasDirectoryPath: Selector;
    URLByAppendingPathComponent_: Selector;
    lastPathComponent: Selector;
    bytes: Selector;
    length: Selector;
    arrayWithObject_: Selector;
    arrayWithObjects_count_: Selector;
    containsObject_: Selector;
    objectAtIndex_: Selector;
    count: Selector;
    defaultManager: Selector;
    URLForDirectory_inDomain_appropriateForURL_create_error_: Selector;
    currentHost: Selector;
    localizedName: Selector;
    localizedDescription: Selector;
}
