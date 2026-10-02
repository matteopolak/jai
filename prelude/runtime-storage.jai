// Source-visible layouts for compiler storage adapters.
Procedure_With_Data :: struct {
    proc: *void;
    data: *void;
}
Newstring :: struct {
    count: s64;
    data: *u8;
}
Array_View_64 :: struct {
    count: s64;
    data: *u8;
}
Resizable_Array :: struct {
    count: s64;
    data: *void;
    allocated: s64;
    allocator: Allocator;
}
Name_Mapper :: #type ([] string);

For_Flags :: enum_flags u8 {
    POINTER :: 0x1;
    REVERSE :: 0x2;
    TEMPORARY_V2 :: 0x4;
}

__command_line_arguments: [] *u8;
__runtime_support_disable_stack_trace: bool = false;
