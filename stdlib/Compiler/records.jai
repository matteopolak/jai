// Turning compiler records into Message_*, Code_* and Type_Info_* structs.
//
// jaic exports messages, syntax trees and type descriptors as records: a tag naming
// the struct to build and named fields (see docs/metaprogramming/compiler-records.md). The structs are
// filled by reflection, member by member, so the layouts in nodes.jai are the only
// place that knows them. Each record is built once; pointers to the same record are
// the same pointer for the rest of the compilation.

#scope_module

REC_NONE :: 0;
REC_INT :: 1;
REC_STRING :: 2;
REC_REF :: 3;
REC_LIST :: 4;

// Built structs by record id (0 = null).
record_structs: [..] *void;

// Record ids by struct address, for `record_of`: open addressing over `record_structs`, 0 = empty.
// Built lazily: most metaprograms never ask, and indexing every record cost more than building it.
record_slots: [] s64;
record_slots_used: s64;
record_unindexed: [..] s64;

remember_record :: (id: s64, pointer: *void) {
    record_structs[id] = pointer;
    // array_add without the call: this runs once per built record.
    if record_unindexed.count < record_unindexed.allocated {
        record_unindexed.data[record_unindexed.count] = id;
        record_unindexed.count += 1;
    } else {
        array_add(*record_unindexed, id);
    }
}

index_pending_records :: () {
    for record_unindexed {
        if (record_slots_used + 1) * 4 >= record_slots.count * 3 {
            old := record_slots;
            record_slots = NewArray(max(64, old.count * 2), s64);
            record_slots_used = 0;
            for old if it insert_record_slot(it);
            array_free(old);
        }
        insert_record_slot(it);
    }
    record_unindexed.count = 0;
}

insert_record_slot :: (id: s64) {
    mask := record_slots.count - 1;
    slot := record_slot_hash(record_structs[id]) & mask;
    while record_slots[slot] {
        if record_structs[record_slots[slot]] == record_structs[id] return; // The first id wins.
        slot = (slot + 1) & mask;
    }
    record_slots[slot] = id;
    record_slots_used += 1;
}

record_slot_hash :: (pointer: *void) -> s64 #no_aoc {
    return cast,no_check(s64) ((cast(u64) pointer * 11400714819323198485) >> 32);
}

// Structs a record's tag may name where a member points to a base type (*Code_Node,
// *Type_Info, *Message). Other records are built as the member's own type.
RECORD_TYPES :: Type.[
    Message_File, Message_Import, Message_Typechecked,

    Code_Node, Code_Ident, Code_Literal, Code_Context, Code_Binary_Operator, Code_Unary_Operator,
    Code_Procedure_Call, Code_Cast, Code_If, Code_Case, Code_Type_Instantiation,
    Code_Procedure_Header, Code_Procedure_Body, Code_Block, Code_Struct, Code_Enum,
    Code_Directive_Run, Code_Directive_Code, Code_Directive_Insert, Code_Directive_Location,
    Code_Directive_Import, Code_Note, Code_Declaration, Code_While, Code_For, Code_Loop_Control,
    Code_Return, Code_Defer, Code_Using, Code_Push_Context, Code_Compound_Declaration,
    Code_Comma_Separated_Arguments, Code_Directive_Exists,

    Type_Info, Type_Info_Integer, Type_Info_Float, Type_Info_String, Type_Info_Pointer,
    Type_Info_Procedure, Type_Info_Struct, Type_Info_Array, Type_Info_Enum, Type_Info_Variant,
];

record_type :: (tag: string) -> *Type_Info_Struct {
    for RECORD_TYPES {
        info := cast(*Type_Info_Struct) it;
        if info.name == tag return info;
    }
    return null;
}

// record_type of a record's tag, cached by `__jaic_rec_tag_id` (UNKNOWN_TAG = not looked up yet).
record_tag_types: [..] *Type_Info_Struct;
UNKNOWN_TAG :: cast(*Type_Info_Struct) 1;

record_type_of :: (id: s64) -> *Type_Info_Struct {
    tag := __jaic_rec_tag_id(id);
    if tag < 0 return null;
    if tag >= record_tag_types.count {
        old := record_tag_types.count;
        array_resize(*record_tag_types, tag + 1, initialize = false);
        for old..tag record_tag_types[it] = UNKNOWN_TAG;
    }
    if record_tag_types[tag] == UNKNOWN_TAG record_tag_types[tag] = record_type(__jaic_rec_tag(id));
    return record_tag_types[tag];
}

// The members fill_struct writes, flattened through `using` and anonymous members, per struct type.
Record_Plan_Entry :: struct {
    offset: s64;
    kind: s64;
    size: s64;
    name: string;
    type: *Type_Info;
}
PLAN_OTHER :: 0;
PLAN_INT :: 1;
PLAN_STRING :: 2;
PLAN_POINTER :: 3;

Record_Plan :: struct {
    info: *Type_Info_Struct;
    entries: [] Record_Plan_Entry;
}
record_plans: [] Record_Plan; // Open addressing by info.
record_plans_used: s64;

last_plan_info: *Type_Info_Struct;
last_plan: [] Record_Plan_Entry;

record_plan :: (info: *Type_Info_Struct) -> [] Record_Plan_Entry {
    if info == last_plan_info return last_plan;
    last_plan_info = info;
    last_plan = find_record_plan(info);
    return last_plan;
}

find_record_plan :: (info: *Type_Info_Struct) -> [] Record_Plan_Entry {
    if record_plans.count {
        mask := record_plans.count - 1;
        slot := record_slot_hash(info) & mask;
        while record_plans[slot].info {
            if record_plans[slot].info == info return record_plans[slot].entries;
            slot = (slot + 1) & mask;
        }
    }
    flat: [..] Record_Plan_Entry;
    add_plan_entries(*flat, info, 0);
    // Members Jai fills itself first, so fill_struct's walk over the bits ends early.
    entries: [..] Record_Plan_Entry;
    for flat if it.kind == PLAN_OTHER array_add(*entries, it);
    for flat if it.kind == PLAN_POINTER array_add(*entries, it);
    for flat if it.kind == PLAN_INT || it.kind == PLAN_STRING array_add(*entries, it);
    array_free(flat);
    if (record_plans_used + 1) * 2 >= record_plans.count {
        old := record_plans;
        record_plans = NewArray(max(64, old.count * 2), Record_Plan);
        record_plans_used = 0;
        for old if it.info insert_record_plan(it);
        array_free(old);
    }
    insert_record_plan(.{ info, entries });
    return entries;
}

insert_record_plan :: (plan: Record_Plan) {
    mask := record_plans.count - 1;
    slot := record_slot_hash(plan.info) & mask;
    while record_plans[slot].info slot = (slot + 1) & mask;
    record_plans[slot] = plan;
    record_plans_used += 1;
}

add_plan_entries :: (entries: *[..] Record_Plan_Entry, info: *Type_Info_Struct, base: s64) {
    for member: info.members {
        if member.flags & .CONSTANT continue;
        offset := base + member.offset_in_bytes;
        // `#as using base`, `using location`, anonymous unions: same record.
        if member.type.type == .STRUCT && (member.flags & .USING || member.name == "") {
            add_plan_entries(entries, cast(*Type_Info_Struct) member.type, offset);
            continue;
        }
        array_add(entries, .{ offset, plan_kind(member.type), member.type.runtime_size, member.name, member.type });
    }
}

// The metaprogram's own descriptor for a primitive type of the target program.
builtin_type_info :: (name: string) -> *Type_Info {
    if name == {
        case "s8"; return type_info(s8);
        case "s16"; return type_info(s16);
        case "s32"; return type_info(s32);
        case "s64"; return type_info(s64);
        case "int"; return type_info(int);
        case "u8"; return type_info(u8);
        case "u16"; return type_info(u16);
        case "u32"; return type_info(u32);
        case "u64"; return type_info(u64);
        case "float"; return type_info(float);
        case "float32"; return type_info(float32);
        case "float64"; return type_info(float64);
        case "bool"; return type_info(bool);
        case "string"; return type_info(string);
        case "void"; return type_info(void);
        case "Any"; return type_info(Any);
        case "Type"; return type_info(Type);
        case "Code"; return type_info(Code);
    }
    return null;
}

// Zeroed memory for a built struct. Structs live for the rest of the compilation and are
// never freed (like the compiler's own nodes), so they come from big chunks instead of an
// allocation each. Array data stays separately allocated: metaprograms grow those arrays.
RECORD_CHUNK :: 256 * 1024;
record_chunk: *u8;
record_chunk_left: s64;

record_memory :: (size: s64) -> *void {
    size = (max(size, 1) + 15) & ~15;
    if size > RECORD_CHUNK / 4 {
        memory := alloc(size);
        memset(memory, 0, size);
        return memory;
    }
    if size > record_chunk_left {
        record_chunk = alloc(RECORD_CHUNK);
        memset(record_chunk, 0, RECORD_CHUNK);
        record_chunk_left = RECORD_CHUNK;
    }
    memory := record_chunk;
    record_chunk += size;
    record_chunk_left -= size;
    return memory;
}

// The struct for record `id`, built on first use. `expected` is the pointed-to type of
// the member being filled; the record's tag may name a subtype of it.
record_struct :: (id: s64, expected: *Type_Info) -> *void {
    if id <= 0 return null;
    if record_structs.count <= id {
        old := record_structs.count;
        array_resize(*record_structs, max(id + 1, old * 2), initialize = false);
        for old..record_structs.count - 1 record_structs[it] = null;
    }
    if record_structs[id] return record_structs[id];

    // A type descriptor of the program reading the records (`compiler_get_nodes` from its
    // own compile-time code): the real one.
    if __jaic_rec_field(id, "__address") == REC_INT {
        address := cast(*void) __jaic_rec_int(id, "__address");
        remember_record(id, address);
        return address;
    }
    if __jaic_rec_field(id, "__builtin") == REC_STRING {
        builtin := builtin_type_info(__jaic_rec_string(id, "__builtin"));
        if builtin {
            remember_record(id, builtin);
            return builtin;
        }
    }

    info := record_type_of(id);
    if !info {
        if !expected || expected.type != .STRUCT return null;
        info = cast(*Type_Info_Struct) expected;
    }

    memory := record_memory(info.runtime_size);
    remember_record(id, memory); // Before filling: records may refer to themselves.
    fill_struct(memory, info, id);
    if info == type_info(Type_Info_Struct) patch_constant_pointers(cast(*Type_Info_Struct) memory, id);
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
    if !pointer return 0;
    index_pending_records();
    if !record_slots.count return 0;
    mask := record_slots.count - 1;
    slot := record_slot_hash(pointer) & mask;
    while record_slots[slot] {
        if record_structs[record_slots[slot]] == pointer return record_slots[slot];
        slot = (slot + 1) & mask;
    }
    return 0;
}

// Integers, strings and pointers to built records are written natively (`__jaic_rec_fill`);
// the members it leaves (arrays, in-place structs, records not built yet) are filled here.
fill_struct :: (memory: *u8, info: *Type_Info_Struct, id: s64) {
    plan := record_plan(info);
    left := __jaic_rec_fill(id, memory, plan.data, plan.count, record_structs.data, record_structs.count);
    k := 0;
    while left {
        if left & 1 fill_value(memory + plan[k].offset, plan[k].type, id, plan[k].name, -1);
        left >>= 1;
        k += 1;
    }
    for k: 64..plan.count - 1 {
        entry := *plan[k];
        if __jaic_rec_field(id, entry.name) != REC_NONE fill_value(memory + entry.offset, entry.type, id, entry.name, -1);
    }
}

plan_kind :: (type: *Type_Info) -> s64 {
    if type.type == {
        case .INTEGER; #through;
        case .ENUM; #through;
        case .BOOL; #through;
        case .FLOAT; return PLAN_INT;
        case .STRING; return PLAN_STRING;
        case .POINTER; return PLAN_POINTER;
    }
    return PLAN_OTHER;
}

// Write field `name` of record `id` (element `index` of it when index >= 0).
fill_value :: (target: *u8, type: *Type_Info, id: s64, name: string, index: s64) {
    if type.type == {
        case .INTEGER; #through;
        case .ENUM; #through;
        case .BOOL; #through;
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
            if ref fill_struct(target, cast(*Type_Info_Struct) type, ref);

        case .ARRAY;
            array := cast(*Type_Info_Array) type;
            if index >= 0 || array.array_type == .FIXED return;
            count := __jaic_rec_count(id, name);
            element := array.element_type;
            data: *u8;
            if count > 0 {
                data = alloc(count * element.runtime_size);
                memset(data, 0, count * element.runtime_size);
                kind := plan_kind(element);
                left := count;
                if kind != PLAN_OTHER left = __jaic_rec_fill_list(id, name, data, count, kind, element.runtime_size, record_structs.data, record_structs.count);
                if left for k: 0..count - 1 {
                    target := data + k * element.runtime_size;
                    if kind == PLAN_INT || kind == PLAN_STRING continue;
                    if kind == PLAN_POINTER && (cast(**void) target).* continue;
                    fill_value(target, element, id, name, k);
                }
            }
            view := cast(*Resizable_Array) target;
            view.count = count;
            view.data = data;
            if array.array_type == .RESIZABLE view.allocated = count;
    }
}

// Whether a built node was edited in place since it was built (by a metaprogram before
// compiler_modify_procedure). Compares member by member with the record, as fill_struct
// wrote them, and follows pointers into other Code nodes, but not into what a node
// resolves to (`resolved_*`, `type`): those are other trees, not part of this one.
record_differs :: (memory: *void, id: s64) -> bool {
    differs_seen.count = 0;
    return struct_differs(memory, record_type_of(id), id);
}

#scope_file

differs_seen: [..] *void;

struct_differs :: (memory: *u8, info: *Type_Info_Struct, id: s64) -> bool {
    if !info return false;
    for differs_seen if it == memory return false; // Headers and bodies point at each other.
    array_add(*differs_seen, memory);
    plan := record_plan(info);
    for plan {
        if it.name == "type" || begins_with_resolved(it.name) continue;
        if __jaic_rec_field(id, it.name) == REC_NONE && union_member_present(plan, it, id) continue;
        if value_differs(memory + it.offset, it.type, id, it.name, -1) return true;
    }
    return false;
}

// A member of a union (`Code_Literal`'s values) whose memory holds another member the record has.
union_member_present :: (plan: [] Record_Plan_Entry, entry: Record_Plan_Entry, id: s64) -> bool {
    for plan {
        if it.offset < entry.offset + entry.size && entry.offset < it.offset + it.size && it.name != entry.name
            && __jaic_rec_field(id, it.name) != REC_NONE return true;
    }
    return false;
}

begins_with_resolved :: (name: string) -> bool {
    prefix :: "resolved_";
    if name.count < prefix.count return false;
    return memcmp(name.data, prefix.data, prefix.count) == 0;
}

is_code_struct :: (info: *Type_Info_Struct) -> bool {
    return info.name.count > 5 && memcmp(info.name.data, "Code_".data, 5) == 0;
}

value_differs :: (target: *u8, type: *Type_Info, id: s64, name: string, index: s64) -> bool {
    if type.type == {
        case .INTEGER; #through;
        case .ENUM; #through;
        case .BOOL; #through;
        case .FLOAT;
            value := ifx index < 0 then __jaic_rec_int(id, name) else __jaic_rec_item_int(id, name, index);
            return memcmp(target, *value, type.runtime_size) != 0;

        case .STRING;
            value := ifx index < 0 then __jaic_rec_string(id, name) else __jaic_rec_item_string(id, name, index);
            have := (cast(*string) target).*;
            return have.count != value.count || (have.count > 0 && memcmp(have.data, value.data, have.count) != 0);

        case .POINTER;
            ref := ifx index < 0 then __jaic_rec_ref(id, name) else __jaic_rec_item_ref(id, name, index);
            pointer := (cast(**void) target).*;
            if !ref return pointer != null;
            if record_of(pointer) != ref return true;
            info := record_type_of(ref);
            if info && is_code_struct(info) return struct_differs(pointer, info, ref);
            return false;

        case .STRUCT;
            ref := ifx index < 0 then __jaic_rec_ref(id, name) else __jaic_rec_item_ref(id, name, index);
            if !ref return false;
            return struct_differs(target, cast(*Type_Info_Struct) type, ref);

        case .ARRAY;
            array := cast(*Type_Info_Array) type;
            if index >= 0 || array.array_type == .FIXED return false;
            count := __jaic_rec_count(id, name);
            view := cast(*Resizable_Array) target;
            if view.count != count return true;
            element := array.element_type;
            for k: 0..count - 1 {
                if value_differs(view.data + k * element.runtime_size, element, id, name, k) return true;
            }
    }
    return false;
}

#scope_module

__jaic_rec_tag :: (record: s64) -> string #compiler;
__jaic_rec_field :: (record: s64, name: string) -> s64 #compiler;
__jaic_rec_int :: (record: s64, name: string) -> s64 #compiler;
__jaic_rec_string :: (record: s64, name: string) -> string #compiler;
__jaic_rec_ref :: (record: s64, name: string) -> s64 #compiler;
__jaic_rec_count :: (record: s64, name: string) -> s64 #compiler;
__jaic_rec_item_int :: (record: s64, name: string, index: s64) -> s64 #compiler;
__jaic_rec_item_string :: (record: s64, name: string, index: s64) -> string #compiler;
__jaic_rec_item_ref :: (record: s64, name: string, index: s64) -> s64 #compiler;
__jaic_rec_tag_id :: (record: s64) -> s64 #compiler;
__jaic_rec_fill_list :: (record: s64, name: string, data: *u8, count: s64, kind: s64, size: s64, built: **void, built_count: s64) -> s64 #compiler;
__jaic_rec_fill :: (record: s64, memory: *u8, plan: *Record_Plan_Entry, plan_count: s64, built: **void, built_count: s64) -> u64 #compiler;
__jaic_code_nodes :: (code: Code) -> s64 #compiler;
__jaic_parse_code :: (text: string, scope_from: Code) -> Code #compiler;
__jaic_modify_procedure :: (ws: s64, body: s64, statements: *s64, sources: *string, count: s64) #compiler;
__jaic_workspace_add_string_to_module :: (ws: s64, source: string, message: s64) #compiler;
