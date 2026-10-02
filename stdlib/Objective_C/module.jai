// Normalized API contracts; reference procedure bodies were discarded.
init_objective_c :: () {
    _sel.addItem_ = cast(Selector) sel_registerName(cast(*u8) "addItem:\0");
    _sel.alloc = cast(Selector) sel_registerName(cast(*u8) "alloc\0");
    _sel.autorelease = cast(Selector) sel_registerName(cast(*u8) "autorelease\0");
    _sel.class = cast(Selector) sel_registerName(cast(*u8) "class\0");
    _sel.init = cast(Selector) sel_registerName(cast(*u8) "init\0");
    _sel.isEqual_ = cast(Selector) sel_registerName(cast(*u8) "isEqual:\0");
    _sel.objc_copy = cast(Selector) sel_registerName(cast(*u8) "copy\0");
    _sel.release = cast(Selector) sel_registerName(cast(*u8) "release\0");
    _sel.retain = cast(Selector) sel_registerName(cast(*u8) "retain\0");
    _sel.superclass = cast(Selector) sel_registerName(cast(*u8) "superclass\0");
}
init_objective_c_selector_struct :: (selectors: *$T) {
    info := type_info(T);
    if info.type != .STRUCT || selectors == null return;
    record := cast(*Type_Info_Struct) info;
    for member: record.members {
        if (cast(u32) member.flags & 3) != 0 || member.type != type_info(Selector) continue;
        if member.offset_in_bytes < 0 || member.offset_in_bytes > info.runtime_size - size_of(Selector) continue;
        bytes := Basic.to_c_string(member.name);
        if bytes == null continue;
        for index: 0..member.name.count-1 if bytes[index] == #char "_" bytes[index] = #char ":";
        slot := cast(*Selector) (cast(*u8) selectors + member.offset_in_bytes);
        slot.* = cast(Selector) sel_registerName(bytes);
        Basic.free(bytes);
    }
}
#if OS == .MACOS {
    BOOL :: s8;
} else {
    BOOL :: bool;
}
YES: BOOL : 1;
NO: BOOL : 0;
NSUInteger :: u64;
NSUIntegerMax :: 0xFFFFFFFFFFFFFFFF;
NSInteger :: s64;
Selector :: *void;
dispatch_queue_t :: *NSObject;
dispatch_data_t :: *NSObject;
to_string :: (str: *NSString) -> string {
    if str == null return "";
    encoded := NSString.dataUsingEncoding(str, NSUTF8StringEncoding, NO);
    if encoded == null return "";
    length := NSData.length(encoded);
    if length > 0x7fff_ffff_ffff_ffff return "";
    bytes := cast(*u8) NSData.bytes(encoded);
    if length > 0 && bytes == null return "";
    return Basic.copy_string(string.{cast(s64) length, bytes});
}
objc_alloc :: (class: Class) -> id #no_context {
    invoke: (sdk_receiver: *void, sdk_selector: SEL) -> id #c_call;
    invoke = cast(type_of(invoke)) objc_msgSend;
    return invoke(cast(*void) class, sel_registerName(cast(*u8) "alloc\0"));
}
objc_copy :: (self: *$instancetype) -> *instancetype #no_context {
    invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *instancetype #c_call;
    invoke = cast(type_of(invoke)) objc_msgSend;
    return invoke(cast(*void) self, sel_registerName(cast(*u8) "copy\0"));
}
autorelease :: (self: *$instancetype) -> id #no_context {
    invoke: (sdk_receiver: *void, sdk_selector: SEL) -> id #c_call;
    invoke = cast(type_of(invoke)) objc_msgSend;
    return invoke(cast(*void) self, sel_registerName(cast(*u8) "autorelease\0"));
}
release :: (self: *$instancetype) -> id #no_context {
    invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
    invoke = cast(type_of(invoke)) objc_msgSend;
    invoke(cast(*void) self, sel_registerName(cast(*u8) "release\0"));
    return null;
}
retain :: (self: *$instancetype) -> *instancetype #no_context {
    invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *instancetype #c_call;
    invoke = cast(type_of(invoke)) objc_msgSend;
    return invoke(cast(*void) self, sel_registerName(cast(*u8) "retain\0"));
}
class :: (self: id) -> Class #no_context {
    invoke: (sdk_receiver: *void, sdk_selector: SEL) -> Class #c_call;
    invoke = cast(type_of(invoke)) objc_msgSend;
    return invoke(cast(*void) self, sel_registerName(cast(*u8) "class\0"));
}
superclass :: (self: id) -> Class #no_context {
    invoke: (sdk_receiver: *void, sdk_selector: SEL) -> Class #c_call;
    invoke = cast(type_of(invoke)) objc_msgSend;
    return invoke(cast(*void) self, sel_registerName(cast(*u8) "superclass\0"));
}
isEqual :: (self: id, object: id) -> bool #no_context {
    invoke: (sdk_receiver: *void, sdk_selector: SEL, value: id) -> BOOL #c_call;
    invoke = cast(type_of(invoke)) objc_msgSend;
    return invoke(cast(*void) self, sel_registerName(cast(*u8) "isEqual:\0"), object) != 0;
}
objc_init :: (self: *$type) -> *type #no_context {
    invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *type #c_call;
    invoke = cast(type_of(invoke)) objc_msgSend;
    return invoke(cast(*void) self, sel_registerName(cast(*u8) "init\0"));
}
objc_alloc :: ($type: Type) -> *type #no_context {
    invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *type #c_call;
    invoke = cast(type_of(invoke)) objc_msgSend;
    return invoke(cast(*void) class(type), sel_registerName(cast(*u8) "alloc\0"));
}
objc_new :: ($type: Type) -> *type #no_context {
    invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *type #c_call;
    invoke = cast(type_of(invoke)) objc_msgSend;
    return invoke(cast(*void) class(type), sel_registerName(cast(*u8) "new\0"));
}
class :: ($type: Type) -> Class #no_context {
    info := type_info(type);
    if info.type != .STRUCT return null;
    name := (cast(*Type_Info_Struct) info).name;
    // Compatibility views use SDK classes rather than a shipped custom binary.
    if name == "LightweightOpenGLView" return objc_getClass(cast(*u8) "NSOpenGLView\0");
    if name == "LightweightRenderingView" return objc_getClass(cast(*u8) "NSView\0");
    if name == "LightweightMetalView" return null;
    buffer: [1024] u8;
    length: s64 = 0;
    while length < name.count && name[length] != #char "(" {
        if length >= 1023 return null;
        buffer[length] = name[length];
        length += 1;
    }
    buffer[length] = 0;
    return objc_getClass(*buffer[0]);
}
objc_lookUpClass :: (name: string) -> Class {
    bytes := Basic.to_c_string(name);
    if bytes == null return null;
    defer Basic.free(bytes);
    return objc_lookUpClass(bytes);
}
objc_getClass :: (name: string) -> Class {
    bytes := Basic.to_c_string(name);
    if bytes == null return null;
    defer Basic.free(bytes);
    return objc_getClass(bytes);
}
objc_allocateClassPair :: (super: Class, name: string, extra_bytes: u64 = 0) -> Class {
    bytes := Basic.to_c_string(name);
    if bytes == null return null;
    defer Basic.free(bytes);
    return objc_allocateClassPair(super, bytes, extra_bytes);
}
objc_getProtocol :: (name: string) -> *Protocol {
    bytes := Basic.to_c_string(name);
    if bytes == null return null;
    defer Basic.free(bytes);
    return objc_getProtocol(bytes);
}
sel_registerName :: (name: string) -> Selector {
    bytes := Basic.to_c_string(name);
    if bytes == null return null;
    defer Basic.free(bytes);
    return cast(Selector) sel_registerName(bytes);
}
sel_getUid :: (name: string) -> Selector {
    bytes := Basic.to_c_string(name);
    if bytes == null return null;
    defer Basic.free(bytes);
    return cast(Selector) sel_getUid(bytes);
}
selector :: (sel_str: string) -> Selector {
    bytes := Basic.to_c_string(sel_str);
    if bytes == null return null;
    defer Basic.free(bytes);
    return cast(Selector) sel_registerName(bytes);
}
create_objc_class_member_stub :: (class_name: string, framework_name: string) -> string #foreign Native_Adapters "jai_stdlib_Objective_C_module_jai_create_objc_class_member_stub_dc710b8cee10";
objc_create_class :: ($type: Type, $parent: Type) -> Class #foreign Native_Adapters "jai_stdlib_Objective_C_module_jai_objc_create_class_9c415e9dc3d6";
objc_add_instance_method :: (my_class: Class, proc: Any, selector_name: string) #foreign Native_Adapters "jai_stdlib_Objective_C_module_jai_objc_add_instance_method_cfd700d565e7";
objc_add_class_method :: (my_class: Class, proc: Any, selector_name: string) #foreign Native_Adapters "jai_stdlib_Objective_C_module_jai_objc_add_class_method_0367086e2d72";
objc_finalize_class :: (my_class: Class) {
    if my_class != null objc_registerClassPair(my_class);
}
objc_type_encode :: (builder: *String_Builder, info: *Type_Info, pointer_depth := 0) #foreign Native_Adapters "jai_stdlib_Objective_C_module_jai_objc_type_encode_8d1261e0dadd";
objc_type_encode :: (info: *Type_Info) -> string #foreign Native_Adapters "jai_stdlib_Objective_C_module_jai_objc_type_encode_b0ce936c7c12";
objc_func_encode :: (ty: *Type_Info_Procedure) -> string #foreign Native_Adapters "jai_stdlib_Objective_C_module_jai_objc_func_encode_5b8f6a562470";
has_isa_member :: (ty: *Type_Info_Struct) -> bool {
    if ty == null return false;
    for member: ty.members {
        if (cast(u32) member.flags & 3) == 0 && member.name == "isa" && member.offset_in_bytes == 0 return true;
    }
    return false;
}
type_check_objc_method_type :: (ty: *Type_Info_Procedure) #foreign Native_Adapters "jai_stdlib_Objective_C_module_jai_type_check_objc_method_type_1e4ec331ee6d";
Objective_C_Block_Basic_Descriptor :: struct {
    reserved: u64;
    size: u64;
    copy_helper: (dst: *void, src: *void) #c_call;
    dispose_helper: (src: *void) #c_call;
    signature: *u8;
}
Objective_C_Block_Basic :: struct {
    isa: *void;
    flags: s32;
    reserved: s32;
    invoke: (*void, args: .. Any) -> () #c_call;
    descriptor: *Objective_C_Block_Basic_Descriptor;
}
_NSConcreteStackBlock :: () #foreign libSystem;
_NSConcreteGlobalBlock :: () #foreign libSystem;
#if CPU == .X64 {
    #load "bindings/x64/runtime.jai";
    #load "bindings/x64/message.jai";
} else {
    #load "bindings/arm64/runtime.jai";
    #load "bindings/arm64/message.jai";
    objc_msgSend_stret :: objc_msgSend;
    objc_msgSendSuper_stret :: objc_msgSendSuper;
    method_invoke_stret :: method_invoke;
    _objc_msgForward_stret :: _objc_msgForward;
    class_getMethodImplementation_stret :: class_getMethodImplementation;
}
objc_msgSend_typed :: (target: *void, selector: Selector) -> *void #no_context {
    invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *void #c_call;
    invoke = cast(type_of(invoke)) objc_msgSend;
    return invoke(target, cast(SEL) selector);
}
#load "Foundation.jai";
#scope_module
ptrdiff_t :: s64;
#import "macos";
Basic :: #import "Basic";
#import "Basic";
libobjc :: #system_library "libobjc";
libSystem :: #system_library "libSystem";
#scope_file
_Selector_Table :: struct {
    alloc: Selector;
    objc_copy: Selector;
    autorelease: Selector;
    release: Selector;
    retain: Selector;
    class: Selector;
    superclass: Selector;
    isEqual_: Selector;
    init: Selector;
    addItem_: Selector;
}
libc :: #system_library "libc";
c_free :: (memory: *void) #foreign libc "free";
libobjc :: #system_library "libobjc";
_sel: _Selector_Table;

#scope_file
Native_Adapters :: #system_library "jai-stdlib-native-adapters";
