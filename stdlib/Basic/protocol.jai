// Qualified names refer to the selected source bootstrap, preserving identity.
// These are compiler ABI aliases, not replicas of divergent upstream schemas.
#scope_file
Protocol :: #import "Preload";
Protocol_Runtime :: #import "Runtime_Support" (DEFINE_SYSTEM_ENTRY_POINT=false, DEFINE_INITIALIZATION=false, ENABLE_BACKTRACE_ON_CRASH=false);
#scope_export
Allocator_Mode :: Protocol.Allocator_Mode;
Allocator_Caps :: Protocol.Allocator_Caps;
Allocator_Proc :: Protocol.Allocator_Proc;
Allocator :: Protocol.Allocator;
Context :: #Context;
Temporary_Storage :: Protocol_Runtime.Temporary_Storage;
Type_Info_Tag :: Protocol.Type_Info_Tag;
Type_Info :: Protocol.Type_Info;
Type_Info_Integer :: Protocol.Type_Info_Integer;
Type_Info_Float :: Protocol.Type_Info_Float;
Type_Info_String :: Protocol.Type_Info_String;
Type_Info_Pointer :: Protocol.Type_Info_Pointer;
Type_Info_Array :: Protocol.Type_Info_Array;
Type_Info_Procedure :: Protocol.Type_Info_Procedure;
Type_Info_Enum :: Protocol.Type_Info_Enum;
Type_Info_Variant :: Protocol.Type_Info_Variant;
Type_Info_Variant_Flags :: Protocol.Type_Info_Variant_Flags;
Type_Info_Struct_Member :: Protocol.Type_Info_Struct_Member;
Type_Info_Tagged_Union_Binding :: Protocol.Type_Info_Tagged_Union_Binding;
Type_Info_Struct :: Protocol.Type_Info_Struct;
Struct_Status_Flags :: Protocol.Struct_Status_Flags;
Struct_Nontextual_Flags :: Protocol.Struct_Nontextual_Flags;
Struct_Textual_Flags :: Protocol.Struct_Textual_Flags;
Enum_Status_Flags :: Protocol.Enum_Status_Flags;
Enum_Type_Flags :: Protocol.Enum_Type_Flags;
Any_Struct :: Protocol.Any_Struct;
Source_Code_Location :: Protocol.Source_Code_Location;
Source_Code_Range :: Protocol.Source_Code_Range;
Log_Level :: Protocol.Log_Level;
Log_Flags :: Protocol.Log_Flags;
Log_Section :: Protocol.Log_Section;
Log_Info :: Protocol.Log_Info;
Logger :: Protocol.Logger;
Stack_Trace_Procedure_Info :: Protocol.Stack_Trace_Procedure_Info;
Stack_Trace_Node :: Protocol.Stack_Trace_Node;
Procedure_With_Data :: Protocol.Procedure_With_Data;
Newstring :: Protocol.Newstring;
Array_View_64 :: Protocol.Array_View_64;
Resizable_Array :: Protocol.Resizable_Array;
Name_Mapper :: Protocol.Name_Mapper;
For_Flags :: Protocol.For_Flags;
