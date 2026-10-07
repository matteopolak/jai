#module_parameters(DC_DEBUG := false, DEBUG_PRINT := false);

#import "Basic";
#import "Hash_Table";

helper_count: int;
time_total: float64;

#if DC_DEBUG {
    #add_context deep_copy_depth: int;
    #add_context deep_copy_depth_max: int;
    #add_context deep_copy_allocs: int;
}

Deep_Copy_Config :: struct {
    string_mapper_proc: (input: string, data: *void) -> (output: string);
    string_mapper_data: *void;
    follow_struct_pointers := true;
}

Pointer_Map :: struct {
    table: Table(*void, *void);
}

Deep_Copy :: (value: *$T, config: Deep_Copy_Config, preallocated_root: *void = null, pointer_map: *Pointer_Map = null, loc := #caller_location) -> *T {
    if !value return null;
    local_map: Pointer_Map;
    map := pointer_map;
    if !map map = *local_map;
    defer if !pointer_map deinit(*local_map.table);
    found, existing := table_find(*map.table, value);
    if found return cast(*T) existing;
    result := preallocated_root;
    if !result result = alloc(size_of(T));
    if !result return null;
    #if DC_DEBUG if !preallocated_root context.deep_copy_allocs += 1;
    memcpy(result, value, size_of(T));
    table_set(*map.table, value, result);
    clone_members(result, type_info(T), config, map);
    return cast(*T) result;
}

#scope_file
clone_members :: (data: *void, info: *Type_Info, config: Deep_Copy_Config, map: *Pointer_Map) {
    helper_count += 1;
    #if DC_DEBUG {
        context.deep_copy_depth += 1;
        if context.deep_copy_depth > context.deep_copy_depth_max context.deep_copy_depth_max = context.deep_copy_depth;
        defer context.deep_copy_depth -= 1;
        #if DEBUG_PRINT print("Deep_Copy visit %, depth %\n", info.type, context.deep_copy_depth);
    }
    if info.type == .VARIANT {
        clone_members(data, (cast(*Type_Info_Variant) info).variant_of, config, map);
        return;
    }
    if info.type == .STRING {
        value := cast(*string) data;
        if !value.data return;
        if config.string_mapper_proc {
            value.* = config.string_mapper_proc(value.*, config.string_mapper_data);
            return;
        }
        found, replacement := table_find(*map.table, value.data);
        if !found {
            replacement = alloc(value.count);
            if !replacement return;
            #if DC_DEBUG context.deep_copy_allocs += 1;
            memcpy(replacement, value.data, value.count);
            table_set(*map.table, value.data, replacement);
        }
        value.data = cast(*u8) replacement;
        return;
    }
    if info.type == .POINTER {
        slot := cast(**void) data;
        source := slot.*;
        if !source return;
        found, destination := table_find(*map.table, source);
        if found {
            slot.* = destination;
            return;
        }
        pointee := (cast(*Type_Info_Pointer) info).pointer_to;
        if pointee.type == .VOID || pointee.type == .PROCEDURE return;
        assert(pointee.runtime_size >= 0, "deep copy needs a known pointee layout");
        destination = alloc(pointee.runtime_size);
        if !destination return;
        #if DC_DEBUG context.deep_copy_allocs += 1;
        memcpy(destination, source, pointee.runtime_size);
        table_set(*map.table, source, destination);
        slot.* = destination;
        if config.follow_struct_pointers || pointee.type != .STRUCT clone_members(destination, pointee, config, map);
        return;
    }
    if info.type == .ARRAY {
        array := cast(*Type_Info_Array) info;
        stride := array.element_type.runtime_size;
        assert(stride >= 0, "deep copy needs a known array element layout");
        count := array.array_count;
        elements := data;
        if array.array_type != .FIXED {
            descriptor := cast(*Array_View_64) data;
            count = descriptor.count;
            elements = descriptor.data;
            if !elements return;
            found, replacement := table_find(*map.table, elements);
            if found {
                descriptor.data = cast(*u8) replacement;
                return;
            }
            replacement = alloc(stride * count);
            if !replacement return;
            #if DC_DEBUG context.deep_copy_allocs += 1;
            memcpy(replacement, elements, stride * count);
            table_set(*map.table, elements, replacement);
            descriptor.data = cast(*u8) replacement;
            elements = replacement;
            if array.array_type == .RESIZABLE {
                resizable := cast(*Resizable_Array) data;
                resizable.allocated = count;
                resizable.allocator = context.allocator;
            }
        }
        index: s64 = 0;
        while index < count {
            clone_members(elements + index * stride, array.element_type, config, map);
            index += 1;
        }
        return;
    }
    if info.type == .STRUCT {
        structure := cast(*Type_Info_Struct) info;
        for member: structure.members {
            if member.offset_in_bytes < 0 || member.flags & .CONSTANT continue;
            skip := false;
            for note: member.notes if note == "NoDeepCopy" skip = true;
            if !skip clone_members(data + member.offset_in_bytes, member.type, config, map);
        }
    }
}
