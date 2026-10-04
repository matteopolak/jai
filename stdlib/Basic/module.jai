// Independently authored Basic module; supplied distributions are API inputs only.
#module_parameters () (MEMORY_DEBUGGER := false, ENABLE_ASSERT := true, REPLACEMENT_INTERFACE: $I/interface Memory_Debugger_Interface = Memory_Debugger_Interface, VISUALIZE_MEMORY_DEBUGGER := true, TEMP_ALLOCATOR_POISON_FREED_MEMORY := false) {
    Memory_Debugger_Interface :: struct {
        check_alloc :: inline (allocator: Allocator, memory: *void, size: s64) {
            #if MEMORY_DEBUGGER _check_alloc(allocator, memory, size);
            else #assert(!MEMORY_DEBUGGER);
        }
        check_free :: inline (allocator: Allocator, memory: *void) {
            #if MEMORY_DEBUGGER _check_free(allocator, memory);
            else #assert(!MEMORY_DEBUGGER);
        }
        check_realloc :: inline (allocator: Allocator, old_memory: *void, old_size: s64, new_memory: *void, new_size: s64) {
            #if MEMORY_DEBUGGER _check_realloc(allocator, old_memory, old_size, new_memory, new_size);
            else #assert(!MEMORY_DEBUGGER);
        }
        check_create_heap :: inline (a: Allocator) {
            #if MEMORY_DEBUGGER _check_create_heap(a);
            else #assert(!MEMORY_DEBUGGER);
        }
        check_destroy_heap :: inline (a: Allocator) {
            #if MEMORY_DEBUGGER _check_destroy_heap(a);
            else #assert(!MEMORY_DEBUGGER);
        }
    }
};
#load "protocol.jai";
#load "allocation.jai";
#load "Array.jai";
#load "Simple_String.jai";
#load "String_Builder.jai";
#load "Print.jai";
#load "Int128.jai";
#load "Apollo_Time.jai";
#load "platform-time.jai";
#scope_export

#if MEMORY_DEBUGGER {
    #load "Memory_Debugger.jai";
    #if VISUALIZE_MEMORY_DEBUGGER #load "Visualize_Memory_Debugger.jai";
    #if REPLACEMENT_INTERFACE == Memory_Debugger_Interface {
        Memory_Debugger :: struct {
            check_alloc :: _check_alloc;
            check_free :: _check_free;
            check_realloc :: _check_realloc;
            check_create_heap :: _check_create_heap;
            check_destroy_heap :: _check_destroy_heap;
        }
    } else {
        Memory_Debugger :: REPLACEMENT_INTERFACE;
    }
}
#scope_export

SET_STORAGE_MARK_STAMP :: 0xda;
RESET_STORAGE_STAMP :: 0xdb;
FREE_PAGE_STAMP :: 0xdc;
write_string :: Runtime_Support.write_string;
write_strings :: Runtime_Support.write_strings;
debug_break :: Runtime_Support.debug_break;
// Leak hints have intentionally no runtime effect when tracking is disabled.
#if !MEMORY_DEBUGGER {
    make_leak_report :: () -> string { return "Memory debugging disabled\n"; }
    log_leak_report :: () { write_string(make_leak_report(), to_standard_error=true); }
    this_allocation_is_not_a_leak :: (memory:*void) #expand { #assert(!MEMORY_DEBUGGER); }
    this_allocation_leaks_todo :: (memory:*void) #expand { #assert(!MEMORY_DEBUGGER); }
    this_allocation_does_not_propagate_leak_ownership :: (memory:*void) #expand { #assert(!MEMORY_DEBUGGER); }
}
#if !MEMORY_DEBUGGER || !VISUALIZE_MEMORY_DEBUGGER {
    memory_visualizer_per_frame_update :: () #expand { #assert(!MEMORY_DEBUGGER || !VISUALIZE_MEMORY_DEBUGGER); }
}

assert_helper :: (message := "", args: .. Any, loc := #caller_location) -> bool {
    if context.handling_assertion_failure return false;
    context.handling_assertion_failure = true;
    report := tprint(message, ..args);
    result := context.assertion_failed(loc, report);
    context.handling_assertion_failure = false;
    return result;
}
assert :: (arg: bool, message := "", args: .. Any, loc := #caller_location) #expand {
    #if ENABLE_ASSERT {
        if !arg {
            if assert_helper(message, ..args, loc) Runtime_Support.debug_break();
        }
    }
}
get_command_line_arguments :: () -> [] string {
    result, base := NewArray(__command_line_arguments.count, string, true);
    for arg, index: __command_line_arguments {
        n: s64;
        while arg[n] != 0 n += 1;
        result[index] = copy_string(string.{n,arg});
    }
    return result;
}
min :: (a: $T, b: T) -> T { if b < a return b; return a; }
max :: (a: $T, b: T) -> T { if b > a return b; return a; }
min :: (a: $T, x: ..T) -> T { result := a; for value: x if value < result result=value; return result; }
max :: (a: $T, x: ..T) -> T { result := a; for value: x if value > result result=value; return result; }
Min :: min;
Max :: max;
clamp :: (x: $T, a: T, b: T) -> T { return max(a,min(x,b)); }
Swap :: (a: *$T, b: *T) { saved := a.*; a.*=b.*; b.*=saved; }
swap :: (a: $T, b: T) -> T #must, T #must { return b,a; }
swap :: (a: *$T, b: *T) { Swap(a,b); }
IsScalar :: (T: Type) -> bool #compile_time {
    info := type_info(T);
    return info.type == .INTEGER || info.type == .FLOAT || info.type == .BOOL || info.type == .ENUM;
}
get_field_with_offset :: (info: *Type_Info_Struct, name: string) -> *Type_Info_Struct_Member, offset_in_bytes: s64 {
    for *member: info.members if member.name == name return member, member.offset_in_bytes;
    return null,-1;
}
get_field :: (info:*Type_Info_Struct,name:string)->*Type_Info_Struct_Member {
    member,offset:=get_field_with_offset(info,name);
    return member;
}
enum_names :: ($t: Type) -> [] string { return (cast(*Type_Info_Enum) type_info(t)).names; }
enum_values_as_s64 :: ($T: Type) -> [] s64 { return (cast(*Type_Info_Enum) type_info(T)).values; }
enum_values_as_enum :: ($T: Type) -> [] T {
    values := enum_values_as_s64(T);
    result,base := NewArray(values.count,T,false);
    for v,i:values result[i]=cast(T)v;
    return result;
}
enum_range_given_info :: (info: *Type_Info_Enum) -> (low: s64, high: s64) {
    if info.values.count == 0 return 0,0;
    low=info.values[0]; high=low;
    for v:info.values { low=min(low,v); high=max(high,v); }
    return low,high;
}
enum_range :: ($t: Type) -> (low:s64,high:s64) { return enum_range_given_info(cast(*Type_Info_Enum)type_info(t)); }
enum_highest_value :: ($t: Type) -> s64 { low,high:=enum_range(t); return high; }
remember_allocators :: (data: *$T) {
    _remember_allocators_by_info(data,type_info(T));
}
resizable :: (a: [] $T, set_allocators := true) -> [..] T {
    result: [..]T;
    result.count=a.count; result.data=a.data; result.allocated=a.count;
    if set_allocators result.allocator=context.allocator;
    return result;
}
is_integer_type :: ($T: Type) -> (is_integer:bool,is_signed:bool,bits:u8) {
    info:=type_info(T);
    if info.type != .INTEGER return false,false,0;
    integer:=cast(*Type_Info_Integer)info;
    return true,integer.signed,cast(u8)(8*integer.runtime_size);
}
get_integer_range :: ($T: Type) -> (low:T,high:T) {
    integer,signed,bits:=is_integer_type(T);
    assert(integer);
    if signed {
        high=cast(T)((cast(u64)1 << (bits-1))-1);
        low=-high-1;
    } else { low=0; high=cast,trunc(T)~cast(u64)0; }
    return low,high;
}
clamp_to_another_integer_type :: (value:$SourceType,$TargetType:Type) -> TargetType {
    src,src_signed,src_bits:=is_integer_type(SourceType);
    dst,dst_signed,dst_bits:=is_integer_type(TargetType);
    assert(src && dst);
    low,high:=get_integer_range(TargetType);
    if src_signed && value < 0 {
        if !dst_signed return low;
        if src_bits > dst_bits && value < cast(SourceType)low return low;
    } else {
        if cast(u64)value > cast(u64)high return high;
    }
    return cast(TargetType)value;
}
pack_stack_trace :: () -> [] Stack_Trace_Node { return pack_stack_trace(context.stack_trace); }
pack_stack_trace :: (node:*Stack_Trace_Node) -> [] Stack_Trace_Node {
    count:s64; cursor:=node;
    while cursor { count+=1; cursor=cursor.next; }
    result,base:=NewArray(count,Stack_Trace_Node,true);
    cursor=node;
    for i:0..count-1 {
        result[i]=cursor.*;
        if i+1<count result[i].next=result.data+i+1;
        else result[i].next=null;
        cursor=cursor.next;
    }
    return result;
}
print_stack_trace :: (node:*Stack_Trace_Node,prefix:string="",to_standard_error:=true) {
    cursor:=node;
    while cursor {
        if cursor.info print("% %:% %\n",prefix,cursor.info.location.fully_pathed_filename,cursor.line_number,cursor.info.name,to_standard_error=to_standard_error);
        cursor=cursor.next;
    }
}
get_stack_trace_string :: (node:*Stack_Trace_Node) -> string {
    builder:String_Builder;
    cursor:=node;
    while cursor {
        if cursor.info print_to_builder(*builder,"%:% %\n",cursor.info.location.fully_pathed_filename,cursor.line_number,cursor.info.name);
        cursor=cursor.next;
    }
    return builder_to_string(*builder);
}
log_stack_trace :: (node:*Stack_Trace_Node,log_flags:=Log_Flags.ERROR,prefix:="") {
    log("%%",prefix,get_stack_trace_string(node),flags=log_flags);
}
#scope_file
Runtime_Support :: #import "Runtime_Support" (DEFINE_SYSTEM_ENTRY_POINT=false, DEFINE_INITIALIZATION=false, ENABLE_BACKTRACE_ON_CRASH=false);
_remember_allocators_by_info :: (memory:*void,info:*Type_Info) {
    if info.type==.STRUCT {
        record:=cast(*Type_Info_Struct)info;
        for member:record.members {
            if member.flags&(.CONSTANT|.IMPORTED) continue;
            address:=cast(*u8)memory+member.offset_in_bytes;
            if member.type==type_info(Allocator) {
                allocator:=cast(*Allocator)address;
                if !allocator.proc allocator.*=context.allocator;
            } else _remember_allocators_by_info(address,member.type);
        }
    } else if info.type==.ARRAY {
        array:=cast(*Type_Info_Array)info;
        count:=array.array_count; data:=cast(*u8)memory;
        if array.array_type!=.FIXED {
            view:=cast(*Array_View_64)memory;
            count=view.count; data=view.data;
            if array.array_type==.RESIZABLE {
                resizable:=cast(*Resizable_Array)memory;
                if !resizable.allocator.proc resizable.allocator=context.allocator;
            }
        }
        for i:0..count-1 _remember_allocators_by_info(data+i*array.element_type.runtime_size,array.element_type);
    }
}
