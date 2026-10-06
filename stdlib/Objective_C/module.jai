// Objective_C: the runtime, Foundation and helpers for calling into Apple frameworks.
#assert(OS == .MACOS || OS == .IOS, "Objective_C is only supported on Apple platforms");
init_objective_c :: () {
    _sel.addItem_ = cast(Selector) sel_registerName(cast(*u8) "addItem:\0");
    _sel.alloc = cast(Selector) sel_registerName(cast(*u8) "alloc\0");
    _sel.autorelease = cast(Selector) sel_registerName(cast(*u8) "autorelease\0");
    _sel.class = cast(Selector) sel_registerName(cast(*u8) "class\0");
    _sel.init = cast(Selector) sel_registerName(cast(*u8) "init\0");
    _sel.isEqual_ = cast(Selector) sel_registerName(cast(*u8) "isEqual:\0");
    _sel.copy = cast(Selector) sel_registerName(cast(*u8) "copy\0");
    _sel.release = cast(Selector) sel_registerName(cast(*u8) "release\0");
    _sel.retain = cast(Selector) sel_registerName(cast(*u8) "retain\0");
    _sel.superclass = cast(Selector) sel_registerName(cast(*u8) "superclass\0");
}
init_objective_c_selector_struct :: (selectors: *$T) {
    info := type_info(T);
    if info.type != .STRUCT || selectors == null return;
    record := cast(*Type_Info_Struct) info;
    for member: record.members {
        if ((cast(u32) member.flags) & 3) != 0 || member.type != type_info(Selector) continue;
        if member.offset_in_bytes < 0 || member.offset_in_bytes > info.runtime_size - size_of(Selector) continue;
        bytes := Basic.to_c_string(member.name);
        if bytes == null continue;
        for index: 0..member.name.count - 1 if bytes[index] == #char "_" bytes[index] = #char ":";
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
    return Basic.copy_string(string.{ cast(s64) length, bytes });
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
    if name == "LightweightMetalView" return objc_getClass(cast(*u8) "NSView\0");
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
create_objc_class_member_stub :: (class_name: string, framework_name: string) -> string {
    Basic.assert(_sdk_objc_identifier(class_name), "Expected an Objective-C class identifier");
    Basic.assert(_sdk_objc_identifier(framework_name), "Expected a system framework identifier");
    native_class := objc_lookUpClass(class_name);
    Basic.assert(native_class != null, "Class must be loaded before introspection");
    builder: String_Builder;
    defer Basic.free_buffers(*builder);
    Basic.print_to_builder(*builder, "// Runtime API members for % from %. Instance size: % bytes.\n", class_name, framework_name, class_getInstanceSize(native_class));
    Basic.append(*builder, "// Paste inside a pointer-only SDK class record; private ivar layout is not reproduced.\n");
    for class_methods: 0..1 {
        owner := native_class;
        if class_methods == 1 owner = object_getClass(cast(id) native_class);
        count: u32;
        methods := class_copyMethodList(owner, *count);
        defer _sdk_objc_libc_free(methods);
        if methods == null continue;
        for index: 0..cast(s64) count - 1 {
            method := methods[index];
            selector_name := _sdk_objc_c_string(sel_getName(method_getName(method)));
            encoding := _sdk_objc_c_string(method_getTypeEncoding(method));
            safe_selector := true;
            for byte: selector_name {
                if byte != 58 && byte != 95 && !(byte >= 65 && byte <= 90) && !(byte >= 97 && byte <= 122) && !(byte >= 48 && byte <= 57) safe_selector = false;
            }
            if !safe_selector continue;
            result_type: [4096] u8;
            method_getReturnType(method, *result_type[0], 4096);
            result, supported := _sdk_objc_jai_type(_sdk_objc_c_string(*result_type[0]));
            if !supported {
                Basic.print_to_builder(*builder, "// Requires a reviewed aggregate declaration: % [%]\n", selector_name, encoding);
                continue;
            }
            args: String_Builder;
            defer Basic.free_buffers(*args);
            argument_count := method_getNumberOfArguments(method);
            if argument_count < 2 continue;
            supported_arguments := true;
            argument_index: u32 = 2;
            while argument_index < argument_count {
                argument_type: [4096] u8;
                method_getArgumentType(method, argument_index, *argument_type[0], 4096);
                type_name, argument_supported := _sdk_objc_jai_type(_sdk_objc_c_string(*argument_type[0]));
                if !argument_supported || type_name == "void" {
                    supported_arguments = false;
                    break;
                }
                Basic.print_to_builder(*args, ", arg%: %", argument_index - 2, type_name);
                argument_index += 1;
            }
            if !supported_arguments {
                Basic.print_to_builder(*builder, "// Requires a reviewed argument declaration: % [%]\n", selector_name, encoding);
                continue;
            }
            arg_text := Basic.builder_to_string(*args);
            defer if arg_text.count > 0 Basic.free(arg_text);
            Basic.append(*builder, "objc_");
            for byte: selector_name {
                if byte == 58 Basic.append(*builder, cast(u8) 95);
                else if (byte >= 65 && byte <= 90) || (byte >= 97 && byte <= 122) || (byte >= 48 && byte <= 57) || byte == 95 Basic.append(*builder, byte);
                else Basic.append(*builder, cast(u8) 95);
            }
            if class_methods == 1 Basic.append(*builder, "_class");
            Basic.print_to_builder(*builder, " :: (self: *void%) -> % #no_context {\n", arg_text, result);
            Basic.print_to_builder(*builder, "    invoke: (sdk_receiver: *void, sdk_selector: SEL%) -> % #c_call;\n", arg_text, result);
            Basic.append(*builder, "    invoke = cast(type_of(invoke)) objc_msgSend;\n    ");
            if result != "void" Basic.append(*builder, "return ");
            if class_methods == 1 Basic.print_to_builder(*builder, "invoke(cast(*void) objc_getClass(cast(*u8) \"%\\0\"), sel_registerName(cast(*u8) \"%\\0\")", class_name, selector_name);
            else Basic.print_to_builder(*builder, "invoke(self, sel_registerName(cast(*u8) \"%\\0\")", selector_name);
            argument_index = 2;
            while argument_index < argument_count {
                Basic.print_to_builder(*builder, ", arg%", argument_index - 2);
                argument_index += 1;
            }
            Basic.append(*builder, ");\n}\n");
        }
    }
    return Basic.builder_to_string(*builder);
}
objc_create_class :: ($type: Type, $parent: Type) -> Class {
    info := type_info(type);
    parent_info := type_info(parent);
    Basic.assert(info.type == .STRUCT && parent_info.type == .STRUCT, "Objective-C classes require concrete records");
    record := cast(*Type_Info_Struct) info;
    native_parent := class(parent);
    Basic.assert(native_parent != null, "Native parent class is unavailable");
    Basic.assert(class_getInstanceSize(native_parent) == cast(u64) parent_info.runtime_size, "Jai base record must describe the full native parent instance prefix");
    Basic.assert(info.runtime_size >= parent_info.runtime_size, "Subclass storage is smaller than its parent");
    Basic.assert(_sdk_objc_identifier(record.name), "Class name must be a concrete Objective-C identifier");
    native_class := objc_allocateClassPair(native_parent, record.name, 0);
    Basic.assert(native_class != null, "Class allocation failed or name already registered");
    complete := false;
    defer if !complete objc_disposeClassPair(native_class);
    base_found := false;
    for member: record.members {
        flags := cast(u32) member.flags;
        if (flags & 2) != 0 continue;
        if (flags & 1) != 0 {
            if member.type.type != .PROCEDURE continue;
            offset := member.offset_into_constant_storage;
            Basic.assert(offset >= 0 && offset <= record.constant_storage.count - size_of(IMP), "Procedure constant storage is unavailable");
            function := Any.{ type = member.type, value_pointer = record.constant_storage.data + offset };
            selector_builder: String_Builder;
            defer Basic.free_buffers(*selector_builder);
            leading_underscore := true;
            for character: member.name {
                if character != 95 leading_underscore = false;
                if character == 95 && !leading_underscore Basic.append(*selector_builder, cast(u8) 58);
                else Basic.append(*selector_builder, character);
            }
            selector_name := Basic.builder_to_string(*selector_builder);
            defer Basic.free(selector_name);
            for note: member.notes {
                if note.count > 14 && string.{ 14, note.data } == "objc_selector:" {
                    Basic.free(selector_name);
                    selector_name = Basic.copy_string(string.{ note.count - 14, note.data + 14 });
                }
            }
            class_method := false;
            for note: member.notes if note == "objc_class_method" class_method = true;
            if class_method objc_add_class_method(native_class, function, selector_name);
            else objc_add_instance_method(native_class, function, selector_name);
            continue;
        }
        if member.offset_in_bytes == 0 && member.type == parent_info {
            Basic.assert((flags & 16) != 0, "Native parent prefix must use #as");
            base_found = true;
            continue;
        }
        Basic.assert(member.offset_in_bytes >= parent_info.runtime_size, "Subclass field overlaps its native parent");
        Basic.assert(_sdk_objc_identifier(member.name), "Invalid native ivar name");
        alignment := _sdk_objc_alignment(member.type);
        alignment_log2: u8 = 0;
        while ((cast(s64) 1) << alignment_log2) < alignment alignment_log2 += 1;
        encoded := objc_type_encode(member.type);
        defer Basic.free(encoded);
        name_bytes := Basic.to_c_string(member.name);
        defer Basic.free(name_bytes);
        encoding_bytes := Basic.to_c_string(encoded);
        defer Basic.free(encoding_bytes);
        Basic.assert(name_bytes != null && encoding_bytes != null, "Ivar metadata allocation failed");
        Basic.assert(class_addIvar(native_class, name_bytes, cast(u64) member.type.runtime_size, alignment_log2, encoding_bytes) != 0, "Native ivar registration failed");
        ivar := class_getInstanceVariable(native_class, name_bytes);
        Basic.assert(ivar != null && ivar_getOffset(ivar) == member.offset_in_bytes, "Jai and Objective-C ivar offsets disagree");
    }
    Basic.assert(base_found, "Subclass must embed its full #as parent record at offset zero");
    native_size := class_getInstanceSize(native_class);
    Basic.assert(native_size <= cast(u64) info.runtime_size, "Native class is larger than the Jai record");
    if native_size < cast(u64) info.runtime_size {
        // The C runtime can omit a record's final alignment padding. Represent
        // that trailing storage as a real private ivar before registration.
        padding := info.runtime_size - cast(s64) native_size;
        padding_name := cast(*u8) "__jai_sdk_tail_padding\0";
        Basic.assert(class_getInstanceVariable(native_class, padding_name) == null, "Reserved tail-padding ivar name is already in use");
        padding_encoding: String_Builder;
        defer Basic.free_buffers(*padding_encoding);
        Basic.print_to_builder(*padding_encoding, "[%C]", padding);
        encoding := Basic.builder_to_string(*padding_encoding);
        defer Basic.free(encoding);
        encoded := Basic.to_c_string(encoding);
        defer Basic.free(encoded);
        Basic.assert(encoded != null && class_addIvar(native_class, padding_name, cast(u64) padding, 0, encoded) != 0, "Native trailing storage registration failed");
    }
    Basic.assert(class_getInstanceSize(native_class) == cast(u64) info.runtime_size, "Jai and native class sizes disagree");
    complete = true;
    // The caller completes any additional methods before objc_finalize_class.
    return native_class;
}
objc_add_instance_method :: (my_class: Class, proc: Any, selector_name: string) {
    Basic.assert(my_class != null && proc.type != null && proc.type.type == .PROCEDURE && proc.value_pointer != null, "Expected a native class and procedure value");
    ty := cast(*Type_Info_Procedure) proc.type;
    type_check_objc_method_type(ty);
    colons: s64 = 0;
    for byte: selector_name {
        Basic.assert(byte != 0, "Selector contains an embedded zero");
        if byte == 58 colons += 1;
    }
    Basic.assert(selector_name.count > 0 && colons == ty.argument_types.count - 2, "Selector arity differs from the C-call method");
    encoding := objc_func_encode(ty);
    defer Basic.free(encoding);
    bytes := Basic.to_c_string(encoding);
    defer Basic.free(bytes);
    Basic.assert(bytes != null, "Method encoding allocation failed");
    implementation := (cast(*IMP) proc.value_pointer).*;
    Basic.assert(implementation != null, "Null native method implementation");
    native_selector := cast(SEL) selector(selector_name);
    Basic.assert(native_selector != null && class_addMethod(my_class, native_selector, implementation, bytes) != 0, "Method registration failed or selector already exists");
}
objc_add_class_method :: (my_class: Class, proc: Any, selector_name: string) {
    Basic.assert(my_class != null, "Expected a native class");
    metaclass := object_getClass(cast(id) my_class);
    Basic.assert(metaclass != null && class_isMetaClass(metaclass) != 0, "Native metaclass is unavailable");
    objc_add_instance_method(metaclass, proc, selector_name);
}
objc_finalize_class :: (my_class: Class) {
    if my_class != null objc_registerClassPair(my_class);
}
objc_type_encode :: (builder: *String_Builder, info: *Type_Info, pointer_depth := 0) {
    Basic.assert(builder != null && info != null && pointer_depth >= 0 && pointer_depth < 64, "Invalid or recursively unbounded native type");
    if info.type == .INTEGER {
        integer := cast(*Type_Info_Integer) info;
        if info.runtime_size == 1 {
            if integer.signed Basic.append(builder, "c");
            else Basic.append(builder, "C");
        } else if info.runtime_size == 2 {
            if integer.signed Basic.append(builder, "s");
            else Basic.append(builder, "S");
        } else if info.runtime_size == 4 {
            if integer.signed Basic.append(builder, "i");
            else Basic.append(builder, "I");
        } else if info.runtime_size == 8 {
            if integer.signed Basic.append(builder, "q");
            else Basic.append(builder, "Q");
        } else Basic.assert(false, "Unsupported native integer width");
    } else if info.type == .FLOAT {
        if info.runtime_size == 4 Basic.append(builder, "f");
        else if info.runtime_size == 8 Basic.append(builder, "d");
        else if info.runtime_size == 16 Basic.append(builder, "D"); // jaic's Long_Double
        else Basic.assert(false, "Unsupported native floating width");
    } else if info.type == .BOOL Basic.append(builder, "B");
    else if info.type == .VOID Basic.append(builder, "v");
    else if info.type == .ENUM objc_type_encode(builder, cast(*Type_Info) (cast(*Type_Info_Enum) info).internal_type, pointer_depth);
    else if info.type == .VARIANT objc_type_encode(builder, (cast(*Type_Info_Variant) info).variant_of, pointer_depth);
    else if info.type == .PROCEDURE {
        procedure := cast(*Type_Info_Procedure) info;
        Basic.assert(((cast(u32) procedure.procedure_flags) & 32) != 0, "Native function pointers require #c_call");
        Basic.append(builder, "^?");
    } else if info.type == .POINTER {
        pointed := (cast(*Type_Info_Pointer) info).pointer_to;
        if info == type_info(Class) Basic.append(builder, "#");
        else if info == type_info(SEL) Basic.append(builder, ":");
        else if pointed.type == .STRUCT && has_isa_member(cast(*Type_Info_Struct) pointed) Basic.append(builder, "@");
        else {
            Basic.append(builder, "^");
            objc_type_encode(builder, pointed, pointer_depth + 1);
        }
    } else if info.type == .STRING Basic.append(builder, "{JaiString=q^C}");
    else if info.type == .ARRAY {
        array := cast(*Type_Info_Array) info;
        Basic.assert(array.array_type == .FIXED && array.array_count >= 0, "Native arrays require a fixed element count");
        Basic.print_to_builder(builder, "[%", array.array_count);
        objc_type_encode(builder, array.element_type, pointer_depth);
        Basic.append(builder, "]");
    } else if info.type == .STRUCT {
        record := cast(*Type_Info_Struct) info;
        is_union := ((cast(u32) record.textual_flags) & 2) != 0;
        if is_union Basic.append(builder, "(");
        else Basic.append(builder, "{");
        // Generic Jai names contain punctuation; anonymous native tags are valid.
        if _sdk_objc_identifier(record.name) Basic.append(builder, record.name);
        else Basic.append(builder, "?");
        if pointer_depth <= 1 {
            Basic.append(builder, "=");
            for member: record.members {
                if ((cast(u32) member.flags) & 3) != 0 continue;
                objc_type_encode(builder, member.type, pointer_depth);
            }
        }
        if is_union Basic.append(builder, ")");
        else Basic.append(builder, "}");
    } else Basic.assert(false, "Type has no Objective-C native encoding");
}
objc_type_encode :: (info: *Type_Info) -> string {
    builder: String_Builder;
    defer Basic.free_buffers(*builder);
    objc_type_encode(*builder, info);
    return Basic.builder_to_string(*builder);
}
objc_func_encode :: (ty: *Type_Info_Procedure) -> string {
    type_check_objc_method_type(ty);
    builder: String_Builder;
    defer Basic.free_buffers(*builder);
    if ty.return_types.count == 0 Basic.append(*builder, "v");
    else objc_type_encode(*builder, ty.return_types[0]);
    // Runtime method encodings accept the compact form without stack offsets.
    Basic.append(*builder, "@:");
    index: s64 = 2;
    while index < ty.argument_types.count {
        objc_type_encode(*builder, ty.argument_types[index]);
        index += 1;
    }
    return Basic.builder_to_string(*builder);
}
has_isa_member :: (ty: *Type_Info_Struct) -> bool {
    if ty == null return false;
    for member: ty.members {
        if ((cast(u32) member.flags) & 3) != 0 || member.offset_in_bytes != 0 continue;
        if member.name == "isa" && member.type == type_info(Class) return true;
        if ((cast(u32) member.flags) & 16) != 0 && member.type.type == .STRUCT {
            if has_isa_member(cast(*Type_Info_Struct) member.type) return true;
        }
    }
    return false;
}
type_check_objc_method_type :: (ty: *Type_Info_Procedure) {
    Basic.assert(ty != null && ty.type == .PROCEDURE, "Expected a procedure descriptor");
    Basic.assert(((cast(u32) ty.procedure_flags) & 32) != 0, "Objective-C methods require #c_call");
    Basic.assert(((cast(u32) ty.procedure_flags) & 6) == 0, "Objective-C methods cannot be compile-time-only or polymorphic");
    Basic.assert(ty.argument_types.count >= 2 && ty.return_types.count <= 1, "Methods require receiver/selector arguments and at most one native return");
    Basic.assert(ty.argument_types[0].type == .POINTER && ty.argument_types[1].type == .POINTER, "Receiver and selector must be pointers");
    builder: String_Builder;
    defer Basic.free_buffers(*builder);
    for argument: ty.argument_types {
        Basic.assert(argument.type != .VOID && argument.type != .ARRAY, "Native method parameters cannot be void or fixed arrays by value");
        objc_type_encode(*builder, argument);
    }
    for result: ty.return_types {
        Basic.assert(result.type != .ARRAY, "Native method cannot return a fixed array");
        objc_type_encode(*builder, result);
    }
}
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
    invoke: (*void, args: ..Any) -> () #c_call;
    descriptor: *Objective_C_Block_Basic_Descriptor;
}
_NSConcreteStackBlock :: () #foreign libSystem;
_NSConcreteGlobalBlock :: () #foreign libSystem;

// Blocks made from Jai procedures (see the `Block_X_literal` helpers that Bindings_Generator
// writes for every block type). They are global blocks: the runtime never copies or frees
// them, so they stay valid for the rest of the program.
Objective_C_Block_Literal :: struct {
    using base: Objective_C_Block_Basic;
    user_data: *void;
}
OBJC_BLOCK_IS_GLOBAL :: 1 << 28;
objc_block_literal_descriptor := Objective_C_Block_Basic_Descriptor.{ size = size_of(Objective_C_Block_Literal) };

objc_make_block :: (invoke: *void, user_data: *void = null) -> *Objective_C_Block_Literal {
    block := Basic.New(Objective_C_Block_Literal);
    block.isa = cast(*void) _NSConcreteGlobalBlock;
    block.flags = OBJC_BLOCK_IS_GLOBAL;
    // Under the interpreter a Jai procedure gets a C-callable address only when it is passed to
    // a foreign function; memmove(p, p, 0) hands that address back (and is a no-op natively).
    native_invoke := objc_block_identity(invoke, invoke, 0);
    block.invoke = cast(type_of(block.invoke)) native_invoke;
    block.descriptor = *objc_block_literal_descriptor;
    block.user_data = user_data;
    return block;
}

#scope_module
objc_block_identity :: (dst: *void, src: *void, count: u64) -> *void #foreign libSystem "memmove";
#scope_export

objc_block_user_data :: (block: *void) -> *void #no_context {
    return (cast(*Objective_C_Block_Literal) block).user_data;
}
// The per-CPU runtime bindings. The framework modules built on this one choose between
// objc_msgSend_stret and objc_msgSend with `#if CPU == .X64`; this branch is what keeps a third
// CPU from reaching their arm64 side.
#if CPU == .X64 {
    #load "bindings/x64/runtime.jai";
    #load "bindings/x64/message.jai";
} else #if CPU == .ARM64 {
    #load "bindings/arm64/runtime.jai";
    #load "bindings/arm64/message.jai";
    objc_msgSend_stret :: objc_msgSend;
    objc_msgSendSuper_stret :: objc_msgSendSuper;
    method_invoke_stret :: method_invoke;
    _objc_msgForward_stret :: _objc_msgForward;
    class_getMethodImplementation_stret :: class_getMethodImplementation;
} else {
    #assert false "Objective_C: no runtime bindings for this CPU";
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
    copy: Selector;
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
_sdk_objc_libc :: #system_library "libc";
_sdk_objc_libc_free :: (pointer: *void) #foreign _sdk_objc_libc "free";
_sdk_objc_c_string :: (pointer: *u8) -> string #no_context {
    if pointer == null return "";
    count: s64 = 0;
    while pointer[count] != 0 count += 1;
    return string.{ count, pointer };
}
_sdk_objc_identifier :: (name: string) -> bool #no_context {
    if name.count == 0 return false;
    for byte, index: name {
        if byte == 95 || (byte >= 65 && byte <= 90) || (byte >= 97 && byte <= 122) continue;
        if index > 0 && byte >= 48 && byte <= 57 continue;
        return false;
    }
    return true;
}
_sdk_objc_alignment :: (info: *Type_Info) -> s64 {
    Basic.assert(info != null && info.runtime_size >= 0, "Invalid native layout descriptor");
    if info.type == .POINTER || info.type == .PROCEDURE || info.type == .STRING return 8;
    if info.type == .BOOL return 1;
    if info.type == .INTEGER || info.type == .FLOAT {
        Basic.assert(info.runtime_size == 1 || info.runtime_size == 2 || info.runtime_size == 4 || info.runtime_size == 8, "Unreviewed native scalar alignment");
        return info.runtime_size;
    }
    if info.type == .ENUM return _sdk_objc_alignment(cast(*Type_Info) (cast(*Type_Info_Enum) info).internal_type);
    if info.type == .VARIANT return _sdk_objc_alignment((cast(*Type_Info_Variant) info).variant_of);
    if info.type == .ARRAY return _sdk_objc_alignment((cast(*Type_Info_Array) info).element_type);
    Basic.assert(info.type == .STRUCT, "Unreviewed native layout alignment");
    record := cast(*Type_Info_Struct) info;
    if ((cast(u32) record.textual_flags) & 4) != 0 return 1;
    maximum: s64 = 1;
    for member: record.members {
        if ((cast(u32) member.flags) & 3) != 0 continue;
        alignment := _sdk_objc_alignment(member.type);
        if alignment > maximum maximum = alignment;
    }
    return maximum;
}
_sdk_objc_jai_type :: (encoding: string) -> string, bool #no_context {
    if encoding.count == 0 return "", false;
    index: s64 = 0;
    while index < encoding.count {
        byte := encoding[index];
        if byte == 114 || byte == 110 || byte == 78 || byte == 111 || byte == 79 || byte == 82 || byte == 86 index += 1;
        else break;
    }
    if index == encoding.count return "", false;
    code := encoding[index];
    if code == 99 return "s8", true;
    if code == 67 return "u8", true;
    if code == 115 return "s16", true;
    if code == 83 return "u16", true;
    if code == 105 || code == 108 return "s32", true;
    if code == 73 || code == 76 return "u32", true;
    if code == 113 return "s64", true;
    if code == 81 return "u64", true;
    if code == 102 return "float", true;
    if code == 100 return "float64", true;
    if code == 66 return "bool", true;
    if code == 118 return "void", true;
    if code == 42 return "*u8", true;
    if code == 64 || code == 35 || code == 58 || code == 94 return "*void", true;
    return "", false;
}
