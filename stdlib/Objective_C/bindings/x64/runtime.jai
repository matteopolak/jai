// Objective-C runtime declarations for x64.
OBJC_BOOL_IS_BOOL :: 0;
OBJC_BOOL_IS_CHAR :: 1;
ARITH_SHIFT :: 32;
CLS_CLASS :: 0x1;
CLS_META :: 0x2;
CLS_INITIALIZED :: 0x4;
CLS_POSING :: 0x8;
CLS_MAPPED :: 0x10;
CLS_FLUSH_CACHE :: 0x20;
CLS_GROW_CACHE :: 0x40;
CLS_NEED_BIND :: 0x80;
CLS_METHOD_ARRAY :: 0x100;
CLS_JAVA_HYBRID :: 0x200;
CLS_JAVA_CLASS :: 0x400;
CLS_INITIALIZING :: 0x800;
CLS_FROM_BUNDLE :: 0x1000;
CLS_HAS_CXX_STRUCTORS :: 0x2000;
CLS_NO_METHOD_ARRAY :: 0x4000;
CLS_HAS_LOAD_METHOD :: 0x8000;
CLS_CONSTRUCTING :: 0x10000;
CLS_EXT :: 0x20000;
OBSOLETE_OBJC_GETCLASSES :: 1;
OBJC_NEXT_METHOD_LIST :: 1;
Class :: *objc_class;
NSObject :: struct {
    isa: Class;
}
id :: *NSObject;
objc_selector :: struct {}
SEL :: *objc_selector;
IMP :: #type (unknown0: id, unknown1: SEL, __args: ..Any) -> id #c_call;
sel_getName :: (sel: SEL) -> *u8 #foreign libobjc;
sel_registerName :: (str: *u8) -> SEL #foreign libobjc;
object_getClassName :: (obj: id) -> *u8 #foreign libobjc;
object_getIndexedIvars :: (obj: id) -> *void #foreign libobjc;
sel_isMapped :: (sel: SEL) -> BOOL #foreign libobjc;
sel_getUid :: (str: *u8) -> SEL #foreign libobjc;
objc_objectptr_t :: *void;
objc_retainedObject :: (obj: objc_objectptr_t) -> id #foreign libobjc;
objc_unretainedObject :: (obj: objc_objectptr_t) -> id #foreign libobjc;
objc_unretainedPointer :: (obj: id) -> objc_objectptr_t #foreign libobjc;
arith_t :: s64;
uarith_t :: u64;
STR :: *u8;
Method :: *objc_method;
Ivar :: *objc_ivar;
Category :: *objc_category;
objc_property :: struct {}
objc_property_t :: *objc_property;
objc_class :: struct {
    #as using super: NSObject;
    super_class: Class;
    name: *u8;
    version: s64;
    info: s64;
    instance_size: s64;
    ivars: *objc_ivar_list;
    methodLists: **objc_method_list;
    cache: *objc_cache;
    protocols: *objc_protocol_list;
}
Protocol :: NSObject;
objc_method_description :: struct {
    name: SEL;
    types: *u8;
}
objc_property_attribute_t :: struct {
    name: *u8;
    value: *u8;
}
object_copy :: (obj: id, size: u64) -> id #foreign libobjc;
object_dispose :: (obj: id) -> id #foreign libobjc;
object_getClass :: (obj: id) -> Class #foreign libobjc;
object_setClass :: (obj: id, cls: Class) -> Class #foreign libobjc;
object_isClass :: (obj: id) -> BOOL #foreign libobjc;
object_getIvar :: (obj: id, ivar: Ivar) -> id #foreign libobjc;
object_setIvar :: (obj: id, ivar: Ivar, value: id) -> void #foreign libobjc;
object_setIvarWithStrongDefault :: (obj: id, ivar: Ivar, value: id) -> void #foreign libobjc;
object_setInstanceVariable :: (obj: id, name: *u8, value: *void) -> Ivar #foreign libobjc;
object_setInstanceVariableWithStrongDefault :: (obj: id, name: *u8, value: *void) -> Ivar #foreign libobjc;
object_getInstanceVariable :: (obj: id, name: *u8, outValue: **void) -> Ivar #foreign libobjc;
objc_getClass :: (name: *u8) -> Class #foreign libobjc;
objc_getMetaClass :: (name: *u8) -> Class #foreign libobjc;
objc_lookUpClass :: (name: *u8) -> Class #foreign libobjc;
objc_getRequiredClass :: (name: *u8) -> Class #foreign libobjc;
objc_getClassList :: (buffer: *Class, bufferCount: s32) -> s32 #foreign libobjc;
objc_copyClassList :: (outCount: *u32) -> *Class #foreign libobjc;
class_getName :: (cls: Class) -> *u8 #foreign libobjc;
class_isMetaClass :: (cls: Class) -> BOOL #foreign libobjc;
class_getSuperclass :: (cls: Class) -> Class #foreign libobjc;
class_setSuperclass :: (cls: Class, newSuper: Class) -> Class #foreign libobjc;
class_getVersion :: (cls: Class) -> s32 #foreign libobjc;
class_setVersion :: (cls: Class, version: s32) -> void #foreign libobjc;
class_getInstanceSize :: (cls: Class) -> u64 #foreign libobjc;
class_getInstanceVariable :: (cls: Class, name: *u8) -> Ivar #foreign libobjc;
class_getClassVariable :: (cls: Class, name: *u8) -> Ivar #foreign libobjc;
class_copyIvarList :: (cls: Class, outCount: *u32) -> *Ivar #foreign libobjc;
class_getInstanceMethod :: (cls: Class, name: SEL) -> Method #foreign libobjc;
class_getClassMethod :: (cls: Class, name: SEL) -> Method #foreign libobjc;
class_getMethodImplementation :: (cls: Class, name: SEL) -> IMP #foreign libobjc;
class_getMethodImplementation_stret :: (cls: Class, name: SEL) -> IMP #foreign libobjc;
class_respondsToSelector :: (cls: Class, sel: SEL) -> BOOL #foreign libobjc;
class_copyMethodList :: (cls: Class, outCount: *u32) -> *Method #foreign libobjc;
class_conformsToProtocol :: (cls: Class, protocol: *Protocol) -> BOOL #foreign libobjc;
class_copyProtocolList :: (cls: Class, outCount: *u32) -> **Protocol #foreign libobjc;
class_getProperty :: (cls: Class, name: *u8) -> objc_property_t #foreign libobjc;
class_copyPropertyList :: (cls: Class, outCount: *u32) -> *objc_property_t #foreign libobjc;
class_getIvarLayout :: (cls: Class) -> *u8 #foreign libobjc;
class_getWeakIvarLayout :: (cls: Class) -> *u8 #foreign libobjc;
class_addMethod :: (cls: Class, name: SEL, imp: IMP, types: *u8) -> BOOL #foreign libobjc;
class_replaceMethod :: (cls: Class, name: SEL, imp: IMP, types: *u8) -> IMP #foreign libobjc;
class_addIvar :: (cls: Class, name: *u8, size: u64, alignment: u8, types: *u8) -> BOOL #foreign libobjc;
class_addProtocol :: (cls: Class, protocol: *Protocol) -> BOOL #foreign libobjc;
class_addProperty :: (cls: Class, name: *u8, attributes: *objc_property_attribute_t, attributeCount: u32) -> BOOL #foreign libobjc;
class_replaceProperty :: (cls: Class, name: *u8, attributes: *objc_property_attribute_t, attributeCount: u32) -> void #foreign libobjc;
class_setIvarLayout :: (cls: Class, layout: *u8) -> void #foreign libobjc;
class_setWeakIvarLayout :: (cls: Class, layout: *u8) -> void #foreign libobjc;
objc_getFutureClass :: (name: *u8) -> Class #foreign libobjc;
class_createInstance :: (cls: Class, extraBytes: u64) -> id #foreign libobjc;
objc_constructInstance :: (cls: Class, bytes: *void) -> id #foreign libobjc;
objc_destructInstance :: (obj: id) -> *void #foreign libobjc;
objc_allocateClassPair :: (superclass: Class, name: *u8, extraBytes: u64) -> Class #foreign libobjc;
objc_registerClassPair :: (cls: Class) -> void #foreign libobjc;
objc_duplicateClass :: (original: Class, name: *u8, extraBytes: u64) -> Class #foreign libobjc;
objc_disposeClassPair :: (cls: Class) -> void #foreign libobjc;
method_getName :: (m: Method) -> SEL #foreign libobjc;
method_getImplementation :: (m: Method) -> IMP #foreign libobjc;
method_getTypeEncoding :: (m: Method) -> *u8 #foreign libobjc;
method_getNumberOfArguments :: (m: Method) -> u32 #foreign libobjc;
method_copyReturnType :: (m: Method) -> *u8 #foreign libobjc;
method_copyArgumentType :: (m: Method, index: u32) -> *u8 #foreign libobjc;
method_getReturnType :: (m: Method, dst: *u8, dst_len: u64) -> void #foreign libobjc;
method_getArgumentType :: (m: Method, index: u32, dst: *u8, dst_len: u64) -> void #foreign libobjc;
method_getDescription :: (m: Method) -> *objc_method_description #foreign libobjc;
method_setImplementation :: (m: Method, imp: IMP) -> IMP #foreign libobjc;
method_exchangeImplementations :: (m1: Method, m2: Method) -> void #foreign libobjc;
ivar_getName :: (v: Ivar) -> *u8 #foreign libobjc;
ivar_getTypeEncoding :: (v: Ivar) -> *u8 #foreign libobjc;
ivar_getOffset :: (v: Ivar) -> ptrdiff_t #foreign libobjc;
property_getName :: (property: objc_property_t) -> *u8 #foreign libobjc;
property_getAttributes :: (property: objc_property_t) -> *u8 #foreign libobjc;
property_copyAttributeList :: (property: objc_property_t, outCount: *u32) -> *objc_property_attribute_t #foreign libobjc;
property_copyAttributeValue :: (property: objc_property_t, attributeName: *u8) -> *u8 #foreign libobjc;
objc_getProtocol :: (name: *u8) -> *Protocol #foreign libobjc;
objc_copyProtocolList :: (outCount: *u32) -> **Protocol #foreign libobjc;
protocol_conformsToProtocol :: (proto: *Protocol, other: *Protocol) -> BOOL #foreign libobjc;
protocol_isEqual :: (proto: *Protocol, other: *Protocol) -> BOOL #foreign libobjc;
protocol_getName :: (proto: *Protocol) -> *u8 #foreign libobjc;
protocol_getMethodDescription :: (proto: *Protocol, aSel: SEL, isRequiredMethod: BOOL, isInstanceMethod: BOOL) -> objc_method_description #foreign libobjc;
protocol_copyMethodDescriptionList :: (proto: *Protocol, isRequiredMethod: BOOL, isInstanceMethod: BOOL, outCount: *u32) -> *objc_method_description #foreign libobjc;
protocol_getProperty :: (proto: *Protocol, name: *u8, isRequiredProperty: BOOL, isInstanceProperty: BOOL) -> objc_property_t #foreign libobjc;
protocol_copyPropertyList :: (proto: *Protocol, outCount: *u32) -> *objc_property_t #foreign libobjc;
protocol_copyPropertyList2 :: (proto: *Protocol, outCount: *u32, isRequiredProperty: BOOL, isInstanceProperty: BOOL) -> *objc_property_t #foreign libobjc;
protocol_copyProtocolList :: (proto: *Protocol, outCount: *u32) -> **Protocol #foreign libobjc;
objc_allocateProtocol :: (name: *u8) -> *Protocol #foreign libobjc;
objc_registerProtocol :: (proto: *Protocol) -> void #foreign libobjc;
protocol_addMethodDescription :: (proto: *Protocol, name: SEL, types: *u8, isRequiredMethod: BOOL, isInstanceMethod: BOOL) -> void #foreign libobjc;
protocol_addProtocol :: (proto: *Protocol, addition: *Protocol) -> void #foreign libobjc;
protocol_addProperty :: (proto: *Protocol, name: *u8, attributes: *objc_property_attribute_t, attributeCount: u32, isRequiredProperty: BOOL, isInstanceProperty: BOOL) -> void #foreign libobjc;
objc_copyImageNames :: (outCount: *u32) -> **u8 #foreign libobjc;
class_getImageName :: (cls: Class) -> *u8 #foreign libobjc;
objc_copyClassNamesForImage :: (image: *u8, outCount: *u32) -> **u8 #foreign libobjc;
sel_isEqual :: (lhs: SEL, rhs: SEL) -> BOOL #foreign libobjc;
objc_enumerationMutation :: (obj: id) -> void #foreign libobjc;
objc_setEnumerationMutationHandler :: (handler: #type (unknown0: id) -> void #c_call) -> void #foreign libobjc;
objc_setForwardHandler :: (fwd: *void, fwd_stret: *void) -> void #foreign libobjc;
imp_implementationWithBlock :: (block: id) -> IMP #foreign libobjc;
imp_getBlock :: (anImp: IMP) -> id #foreign libobjc;
imp_removeBlock :: (anImp: IMP) -> BOOL #foreign libobjc;
objc_loadWeak :: (location: *id) -> id #foreign libobjc;
objc_storeWeak :: (location: *id, obj: id) -> id #foreign libobjc;
objc_AssociationPolicy :: u64;
OBJC_ASSOCIATION :: enum u32 {
    ASSIGN :: 0;
    RETAIN_NONATOMIC :: 1;
    COPY_NONATOMIC :: 3;
    RETAIN :: 769;
    COPY :: 771;
    OBJC_ASSOCIATION_ASSIGN :: ASSIGN;
    OBJC_ASSOCIATION_RETAIN_NONATOMIC :: RETAIN_NONATOMIC;
    OBJC_ASSOCIATION_COPY_NONATOMIC :: COPY_NONATOMIC;
    OBJC_ASSOCIATION_RETAIN :: RETAIN;
    OBJC_ASSOCIATION_COPY :: COPY;
}
objc_setAssociatedObject :: (object: id, key: *void, value: id, policy: objc_AssociationPolicy) -> void #foreign libobjc;
objc_getAssociatedObject :: (object: id, key: *void) -> id #foreign libobjc;
objc_removeAssociatedObjects :: (object: id) -> void #foreign libobjc;
objc_method_description_list :: struct {
    count: s32;
    list: [1] objc_method_description;
}
objc_protocol_list :: struct {
    next: *objc_protocol_list;
    count: s64;
    list: [1] *Protocol;
}
objc_category :: struct {
    category_name: *u8;
    class_name: *u8;
    instance_methods: *objc_method_list;
    class_methods: *objc_method_list;
    protocols: *objc_protocol_list;
}
objc_ivar :: struct {
    ivar_name: *u8;
    ivar_type: *u8;
    ivar_offset: s32;
    space: s32;
}
objc_ivar_list :: struct {
    ivar_count: s32;
    space: s32;
    ivar_list: [1] objc_ivar;
}
objc_method :: struct {
    method_name: SEL;
    method_types: *u8;
    method_imp: IMP;
}
objc_method_list :: struct {
    obsolete: *objc_method_list;
    method_count: s32;
    space: s32;
    method_list: [1] objc_method;
}
Symtab :: *objc_symtab;
objc_symtab :: struct {
    sel_ref_cnt: u64;
    refs: *SEL;
    cls_def_cnt: u16;
    cat_def_cnt: u16;
    defs: [1] *void;
}
Cache :: *objc_cache;
objc_cache :: struct {
    mask: u32;
    occupied: u32;
    buckets: [1] Method;
}
Module :: *objc_module;
objc_module :: struct {
    version: u64;
    size: u64;
    name: *u8;
    symtab: Symtab;
}
class_lookupMethod :: (cls: Class, sel: SEL) -> IMP #foreign libobjc;
class_respondsToMethod :: (cls: Class, sel: SEL) -> BOOL #foreign libobjc;
_objc_flush_caches :: (cls: Class) -> void #foreign libobjc;
object_copyFromZone :: (anObject: id, nBytes: u64, z: *void) -> id #foreign libobjc;
class_createInstanceFromZone :: (unknown0: Class, idxIvars: u64, z: *void) -> id #foreign libobjc;
#scope_file
libobjc :: #system_library "libobjc";
