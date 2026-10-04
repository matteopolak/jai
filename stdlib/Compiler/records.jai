// Turning compiler records into Message_*, Code_* and Type_Info_* structs.
//
// jaic exports messages, syntax trees and type descriptors as records: a tag naming
// the struct to build and named fields (see docs/compiler-records.md). The structs are
// filled by reflection, member by member, so the layouts in nodes.jai are the only
// place that knows them. Each record is built once; pointers to the same record are
// the same pointer for the rest of the compilation.

#scope_module

REC_NONE   :: 0;
REC_INT    :: 1;
REC_STRING :: 2;
REC_REF    :: 3;
REC_LIST   :: 4;

// Built structs by record id (0 = null).
record_structs: [..] *void;

// Structs a record's tag may name where a member points to a base type (*Code_Node,
// *Type_Info, *Message). Other records are built as the member's own type.
RECORD_TYPES :: Type.[
    Message_File, Message_Import, Message_Typechecked,

    Code_Node, Code_Ident, Code_Literal, Code_Context, Code_Binary_Operator, Code_Unary_Operator,
    Code_Procedure_Call, Code_Cast, Code_If, Code_Case, Code_Type_Instantiation,
    Code_Procedure_Header, Code_Procedure_Body, Code_Block, Code_Struct, Code_Enum,
    Code_Directive_Run, Code_Directive_Code, Code_Directive_Insert, Code_Directive_Location,
    Code_Directive_Import, Code_Note, Code_Declaration, Code_While, Code_For, Code_Loop_Control,
    Code_Return, Code_Defer, Code_Using, Code_Push_Context,

    Type_Info, Type_Info_Integer, Type_Info_Float, Type_Info_String, Type_Info_Pointer,
    Type_Info_Procedure, Type_Info_Struct, Type_Info_Array, Type_Info_Enum, Type_Info_Variant,
];

record_type :: (tag: string) -> *Type_Info_Struct {
    for RECORD_TYPES {
        info := cast(*Type_Info_Struct) it;
        if info.name == tag  return info;
    }
    return null;
}

// The metaprogram's own descriptor for a primitive type of the target program.
builtin_type_info :: (name: string) -> *Type_Info {
    if name == {
        case "s8";      return type_info(s8);
        case "s16";     return type_info(s16);
        case "s32";     return type_info(s32);
        case "s64";     return type_info(s64);
        case "int";     return type_info(int);
        case "u8";      return type_info(u8);
        case "u16";     return type_info(u16);
        case "u32";     return type_info(u32);
        case "u64";     return type_info(u64);
        case "float";   return type_info(float);
        case "float32"; return type_info(float32);
        case "float64"; return type_info(float64);
        case "bool";    return type_info(bool);
        case "string";  return type_info(string);
        case "void";    return type_info(void);
        case "Any";     return type_info(Any);
        case "Type";    return type_info(Type);
        case "Code";    return type_info(Code);
    }
    return null;
}

// The struct for record `id`, built on first use. `expected` is the pointed-to type of
// the member being filled; the record's tag may name a subtype of it.
record_struct :: (id: s64, expected: *Type_Info) -> *void {
    if id <= 0  return null;
    while record_structs.count <= id  array_add(*record_structs, null);
    if record_structs[id]  return record_structs[id];

    if __jaic_rec_field(id, "__builtin") == REC_STRING {
        builtin := builtin_type_info(__jaic_rec_string(id, "__builtin"));
        if builtin {
            record_structs[id] = builtin;
            return builtin;
        }
    }

    info := record_type(__jaic_rec_tag(id));
    if !info {
        if !expected || expected.type != .STRUCT  return null;
        info = cast(*Type_Info_Struct) expected;
    }

    memory := alloc(info.runtime_size);
    memset(memory, 0, info.runtime_size);
    record_structs[id] = memory;  // Before filling: records may refer to themselves.
    fill_struct(memory, info, id);
    if info == type_info(Type_Info_Struct)  patch_constant_pointers(cast(*Type_Info_Struct) memory, id);
    return memory;
}

// `Type` parameters of a polymorphic struct instance: descriptors in constant storage.
patch_constant_pointers :: (info: *Type_Info_Struct, id: s64) {
    count := __jaic_rec_count(id, "__constant_pointers");
    k := 0;
    while k + 1 < count {
        offset := __jaic_rec_item_int(id, "__constant_pointers", k);
        target := record_struct(__jaic_rec_item_int(id, "__constant_pointers", k + 1), null);
        (cast(**void) (info.constant_storage.data + offset)).* = target;
        k += 2;
    }
}

// The record a built struct came from (0 if none).
record_of :: (pointer: *void) -> s64 {
    if !pointer  return 0;
    for record_structs  if it == pointer  return it_index;
    return 0;
}

fill_struct :: (memory: *u8, info: *Type_Info_Struct, id: s64) {
    for member: info.members {
        if member.flags & .CONSTANT  continue;
        target := memory + member.offset_in_bytes;

        // `#as using base`, `using location`, anonymous unions: same record.
        if member.type.type == .STRUCT && (member.flags & .USING || member.name == "") {
            fill_struct(target, cast(*Type_Info_Struct) member.type, id);
            continue;
        }
        if __jaic_rec_field(id, member.name) == REC_NONE  continue;
        fill_value(target, member.type, id, member.name, -1);
    }
}

// Write field `name` of record `id` (element `index` of it when index >= 0).
fill_value :: (target: *u8, type: *Type_Info, id: s64, name: string, index: s64) {
    if type.type == {
        case .INTEGER; #through;
        case .ENUM;    #through;
        case .BOOL;    #through;
        case .FLOAT;
            value := ifx index < 0 then __jaic_rec_int(id, name) else __jaic_rec_item_int(id, name, index);
            memcpy(target, *value, type.runtime_size);

        case .STRING;
            value := ifx index < 0 then __jaic_rec_string(id, name) else __jaic_rec_item_string(id, name, index);
            (cast(*string) target).* = value;

        case .POINTER;
            ref := ifx index < 0 then __jaic_rec_ref(id, name) else __jaic_rec_item_ref(id, name, index);
            pointer := cast(*Type_Info_Pointer) type;
            (cast(**void) target).* = record_struct(ref, pointer.pointer_to);

        case .STRUCT;
            // A struct held in place (array elements such as Typechecked(T), Code_Argument).
            ref := ifx index < 0 then __jaic_rec_ref(id, name) else __jaic_rec_item_ref(id, name, index);
            if ref  fill_struct(target, cast(*Type_Info_Struct) type, ref);

        case .ARRAY;
            array := cast(*Type_Info_Array) type;
            if index >= 0 || array.array_type == .FIXED  return;
            count := __jaic_rec_count(id, name);
            element := array.element_type;
            data: *u8;
            if count > 0 {
                data = alloc(count * element.runtime_size);
                memset(data, 0, count * element.runtime_size);
                for k: 0..count-1  fill_value(data + k * element.runtime_size, element, id, name, k);
            }
            view := cast(*Resizable_Array) target;
            view.count = count;
            view.data  = data;
            if array.array_type == .RESIZABLE  view.allocated = count;
    }
}

__jaic_rec_tag         :: (record: s64) -> string #compiler;
__jaic_rec_field       :: (record: s64, name: string) -> s64 #compiler;
__jaic_rec_int         :: (record: s64, name: string) -> s64 #compiler;
__jaic_rec_string      :: (record: s64, name: string) -> string #compiler;
__jaic_rec_ref         :: (record: s64, name: string) -> s64 #compiler;
__jaic_rec_count       :: (record: s64, name: string) -> s64 #compiler;
__jaic_rec_item_int    :: (record: s64, name: string, index: s64) -> s64 #compiler;
__jaic_rec_item_string :: (record: s64, name: string, index: s64) -> string #compiler;
__jaic_rec_item_ref    :: (record: s64, name: string, index: s64) -> s64 #compiler;
__jaic_code_nodes      :: (code: Code) -> s64 #compiler;
__jaic_parse_code      :: (text: string, scope_from: Code) -> Code #compiler;
__jaic_modify_procedure :: (ws: s64, body: s64, statements: *s64, count: s64) #compiler;
__jaic_workspace_add_string_to_module :: (ws: s64, source: string, message: s64) #compiler;
