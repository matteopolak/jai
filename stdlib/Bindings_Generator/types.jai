// Options, declaration model and generator state.

// Stands for clang's own builtin headers in `system_include_paths`; libclang adds them itself.
GENERATOR_DEFAULT_SYSTEM_INCLUDE_PATH :: "<clang builtin headers>";

Generate_Bindings_Options :: struct #type_info_none {
    os                    := TARGET_OS;
    cpu                   := CPU;
    libnames:             [..] string;
    libpaths:             [..] string;
    system_library_names: [..] string;
    system_library_paths: [..] string;

    // Older spelling of the library lists: each entry names a library file
    // (without extension) and the identifier its `#library` declaration gets.
    libraries:            [..] Library_Reference;
    library_search_paths: [..] string;

    static_library_suffix: string;
    shared_library_suffix: string;

    system_include_paths:  [..] string;
    include_paths:         [..] string;
    source_files:          [..] string;
    extra_clang_arguments: [..] string;

    // Declarations from system headers are skipped unless their file path
    // contains one of these fragments or their name is listed.
    path_fragments_to_treat_as_non_system_paths: [..] string;
    system_types_to_include:                     [..] string;

    flatten_namespaces: [..] string;
    strip_prefixes:     [..] string;

    generate_enums_from_macros_with_prefixes: [..] string;
    convert_macro_value_to_enum_callback: #type (decl: *Declaration) -> enum_name: string;

    strip_enum_prefixes             := true;
    auto_detect_enum_prefixes       := true;
    alias_original_enum_names       := true;
    strip_enum_values_with_suffix:  string;
    strip_enum_value_prefixes:      [..][2] string;
    typedef_prefixes_to_unwrap:     [..] string;
    macro_prefixes_to_unwrap:       [..] string;

    omit_global_declarations        := false;

    strip_flags := Strip_Flags.FUNCTIONS_WITH_VALIST | .SYMBOLS_WITH_UNKNOWN_FOREIGN_LIBS;
    log_stripped_declarations       := true;

    try_to_preserve_comments        := true;

    generate_library_declarations := true;
    generated_library_path_prefix := "";

    add_generator_command           := true;

    header                          := "";
    footer                          := "";

    c_enum_emulation                      := false;
    generate_compile_time_struct_checks   := true;
    generate_printf_wrappers              := true;
    generate_c_style_api_for_vtable       := true;
    generate_vtable_helpers               := true;
    add_overloaded_const_and_ref_comments := true;
    add_placeholders_for_unresolved_types := true;

    mimic_spacing_flags             := Mimic_Spacing_Flags.ALL;

    get_func_args_for_printing: Get_Function_Arguments_For_Printing_Func = _default_get_func_args_for_printing;
    will_print_bindings: #type ();
    visitor: Declaration_Visitor;

    log_unsupported                 := false;

    // Extension: print `S_get_x` / `S_set_x` procedures for C bit fields.
    generate_bitfield_accessors     := true;

    // Extension: path of the libclang shared library (otherwise the
    // JAI_LIBCLANG environment variable and the usual install locations).
    libclang_path: string;
}

Library_Reference :: struct {
    filename:   string;
    identifier: string;
    is_system:  bool;
}

Declaration_Visit_Result :: enum {
    STOP;
    RECURSE;
}

Declaration_Visitor :: #type (decl: *Declaration, parent_decl: *Declaration) -> Declaration_Visit_Result;

Mimic_Spacing_Flags :: enum_flags {
    GLOBAL;
    STRUCT;
    ENUM;
    NAMESPACE;
    VTABLE;
    ALL :: GLOBAL | STRUCT | ENUM | NAMESPACE | VTABLE;
}

Strip_Flags :: enum_flags {
    CONSTRUCTORS;
    DESTRUCTORS;
    FUNCTIONS_WITH_VALIST;
    SYMBOLS_WITH_UNKNOWN_FOREIGN_LIBS;
    INLINED_FUNCTIONS;
}

Get_Function_Arguments_For_Printing_Func :: #type (func: *Function, type: *Function_Type, mode: Arg_Print_Mode) -> []*Declaration;

Arg_Print_Mode :: enum {
    OUTER_WRAPPER;
    FOREIGN_FUNC_DECLARATION;
    INNER_WRAPPER_CALL;
}

_default_get_func_args_for_printing :: (func: *Function, type: *Function_Type, mode: Arg_Print_Mode) -> []*Declaration {
    return type.arguments;
}

Library_Info :: struct {
    name: string;
    full_path: string;
    is_shared_library: bool;
    is_system_library: bool;
    handle: *void;               // dlopen handle of a system library found by the loader.
    symbol_names: [] string;     // Exported symbols, as read from the library file.

    symbols: Table(string, bool);
    symbols_known: bool;
}

Number_Flags :: enum_flags {
    None;
    _8BIT;
    _16BIT;
    _32BIT;
    _64BIT;

    SIGNED;
    FLOAT;
}

CType :: struct {
    hardcoded_jai_string: string;
    pointer_to: *CType;
    type_of_enum: *Enum;
    type_of_typedef: *Typedef;
    type_of_struct: *Struct;
    array_element_type: *CType;
    array_element_count := -1;
    array_element_count_ref: string;

    type_of_function: *Function_Type;

    template_instantiation_params: [..] *CType;

    number_flags: Number_Flags;
    size: s64 = -1;
    alignment: s64 = -1;   // Known when the generator cannot derive it (types referred to by name).
    flags: Flags;
    Flags :: enum_flags {
        REFERENCE;
        CONST;
        WIDE_LONG_DOUBLE;   // A 16-byte `long double`, printed as `[16] u8`.
    }

    comment: string;
}

Function_Type :: struct {
    arguments: [..] *Declaration;
    return_type: *CType;

    flags: Flags;
    Flags :: enum_flags {
        ADD_C_TYPE_DETAILS;
        INLINE;
        OBJC_METHOD;
        OBJC_CLASS_METHOD;
        VARIADIC;
        CPP_METHOD;
        CONSTRUCTOR;
        COPY_CONSTRUCTOR;
        MOVE_CONSTRUCTOR;
        DESTRUCTOR;
        RETURNS_INSTANCETYPE;
    }
}

C_Kind :: enum {
    NONE;
    DECLARATION;
    FUNCTION;
    ENUM;
    TYPEDEF;
    STRUCT;
    BITFIELD;
    NAMESPACE;
    MACRO_DEFINITION;

    LITERAL;
    UNARY_OPERATOR;
    BINARY_OPERATOR;
    STRUCT_LITERAL;
    PAREN_EXPRESSION;
}

Expression :: struct {
    kind: C_Kind;
}

Macro_Token :: struct {
    kind: s32; // CXTokenKind: 0 punctuation, 1 keyword, 2 identifier, 3 literal, 4 comment
    spelling: string;
}

Macro_Value :: struct {
    tokens: [] Macro_Token;
}

Literal_Kind :: enum s64 {
    NULL            :: 0;
    INTEGER         :: 1;
    FLOAT           :: 2;
    STRING          :: 3;
    RAW_CPP_TOKENS  :: 4;
    ENUM            :: 5;
    MACRO           :: 6;
    IDENTIFIER      :: 7;
}

Literal :: struct {
    #as using _expression: Expression;
    kind = .LITERAL;

    literal_kind: Literal_Kind;

    int_value:    s64;
    float_value:  float64;
    string_value: string;
    macro_value: Macro_Value;
    enum_type: *Enum;
    enum_value: *Enum.Enumerate;
    identifier: *Declaration;
    raw_value: string;
}

Unary_Operator :: struct {
    #as using _expression: Expression;
    kind = .UNARY_OPERATOR;
    op: string;
    child: *Expression;
}

Binary_Operator :: struct {
    #as using _expression: Expression;
    kind = .BINARY_OPERATOR;
    op: string;
    lhs: *Expression;
    rhs: *Expression;
}

Struct_Literal :: struct {
    #as using _expression: Expression;
    kind = .STRUCT_LITERAL;
    type_name: string;
    values: [] *Expression;
}

Paren_Expression :: struct {
    #as using _expression: Expression;
    kind = .PAREN_EXPRESSION;
    child: *Expression;
}

Location :: struct {
    file: s64;   // index into the generator's file names; 0 = unknown
    line: u32;
    column: u32;
}

// An anonymous enum keeps its source position: it is inserted at `index` of `scope`.
Pending_Anon_Enum :: struct {
    _enum: *Enum;
    scope: *[..] *Declaration;
    index: int;
}

Comment :: struct {
    location: Location;
    text: string;
}

prepend_comment :: (comment: *Comment, text: string) {
    comment.text = ifx comment.text then sprint("% %", text, comment.text) else text;
}

is_same_location :: (a: Location, b: Location) -> bool {
    return a.line == b.line && a.column == b.column && a.file == b.file;
}

Storage_Class :: enum s32 {
    Invalid :: 0;
    None    :: 1;
    Extern  :: 2;
    Static  :: 3;
}

Declaration :: struct {
    #as using _expression: Expression;
    kind = .DECLARATION;

    location:           Location;
    name:               string;
    output_name:        string;
    outputted_jai_name: string;
    type:               *CType;
    expression:         *Expression;
    parent:             *Declaration;
    should_unwrap:      bool;

    bitfield_width       := -1;
    bit_offset_in_parent := -1;
    macro_value_result: enum {
        NEEDS_CHECKING;
        KEEP;
        DISCARD;
    }

    storage_class: Storage_Class = .None;
    decl_flags: Declaration_Flags;
    comment: Comment;

    library: *Library_Info;
    foreign_name: string;
}

Declaration_Flags :: enum_flags {
    NEEDS_ARGUMENT_WRAPPER;
    NEEDS_PRINTF_WRAPPER;
    POINTER_TO_VALUE;
    OMIT_FROM_OUTPUT;
    NEEDS_DEFAULT_ARGUMENT_CAST;
    IS_CONST;
    IS_METADATA;
    QUALIFIER_AS;
    QUALIFIER_USING;
    TYPE_INFO_NONE;
    TYPE_INFO_PROCEDURES_ARE_VOID_POINTERS;
    NO_SPACING;
    TEMPLATE;
    PRINT_AS_RAW;   // A base class member that is the `__RAW` variant of its type.
}

Function :: struct {
    #as using declaration: Declaration;
    kind = .FUNCTION;

    deleting_foreign_name: string;
    base_foreign_name: string;

    is_virtual: bool;
    is_operator: bool;   // Printed as a Jai operator overload after its struct.
}

Typedef :: struct {
    #as using declaration: Declaration;
    kind = .TYPEDEF;
    unwrap: bool;
    flags: Typedef_Flags;

    Typedef_Flags :: enum_flags {
        ISA;
        DISTINCT;
    }
}

Enum :: struct {
    #as using declaration: Declaration;
    kind = .ENUM;

    // A value, not a declaration: visitors reorder, copy and remove them freely.
    Enumerate :: struct {
        name: string;
        output_name: string;

        unsigned_value: u64;
        signed_value: s64;
        string_value: string;
        macro_value: Macro_Value;

        location: Location;
        comment: Comment;
    }

    enumerates: [..] Enumerate;
    flags: Enum_Flags;

    Enum_Flags :: enum_flags {
        IS_ENUM_FLAGS;
        VALUES_IN_HEX;
        MIMIC_SPACING;
        ALIAS_ORIGINAL_NAMES;
    }
}

Bitfield :: struct {
    #as using declaration: Declaration;
    kind = .BITFIELD;
    members: [..] *Declaration;
    alignment_type: *CType;
    start_byte: s64;
    byte_count: s64;
}

// Tracks the bit field run being filled while a struct's members are converted.
Bitfield_Status :: struct {
    parent:     *Struct;
    bitfield:   *Bitfield;
    first_decl: *Declaration;
}

// A run with a single member is printed as that member, typed as the run's storage.
maybe_unwrap_bitfield_declaration :: (decl: *Declaration) -> *Declaration {
    if decl.kind == .BITFIELD {
        run := cast(*Bitfield) decl;
        if run.members.count == 1 {
            only := run.members[0];
            only.type = run.type;
            return only;
        }
    }
    return decl;
}

Struct :: struct {
    #as using declaration: Declaration;
    kind = .STRUCT;

    metadata:             [..] *Declaration;
    parents:              [..] *Declaration;
    // C++ `virtual` bases: in a complete object they follow the class's own members, at the
    // offset in `bit_offset_in_parent` (bits; -1 when the libclang cannot tell).
    virtual_bases:        [..] *Declaration;
    virtual_functions:    [..] *Function;
    declarations:         [..] *Declaration;
    template_type_params: [..] *Declaration;

    flags:                Flags;
    objc_filled:          bool;   // The members of an Objective-C interface or protocol were converted.

    Flags :: enum_flags {
        NONE;
        IS_ANON;
        IS_UNION;
        HAS_CONSTRUCTOR;
        HAS_COPY_CONSTRUCTOR;
        HAS_MOVE_CONSTRUCTOR;
        HAS_DESTRUCTOR;
        NO_STRUCT_CHECKS;
        MIMIC_SPACING;
        OBJC_PROTOCOL;
        OBJC_INTERFACE;
        OBJC_CATEGORY;
        IS_INCOMPLETE;
        IS_TYPE_PARAM;   // Stand-in for a template or Objective-C generic parameter.
        NEEDS_RAW;      // A derived class reuses its tail padding: print the `__RAW` variant too.
        IS_SYSTEM;      // Declared in a system header: referred to by name, never printed.
        OBJC_BLOCK;     // The header of an Objective-C block type (`Block_<result>_<args>`).
    }
}

// Per-struct vtable layout, computed lazily while printing (C++ class hierarchies).
Struct_Extra_Info :: struct {
    vtable: [..] *Function;
    vtable_name: string;
    vtable_parent: *Struct;
    vtable_parent_info: *Struct_Extra_Info;
    vtable_parent_declaration: *Declaration;
}

Namespace :: struct {
    #as using declaration: Declaration;
    kind = .NAMESPACE;
    should_flatten := false;

    declarations: [..] *Declaration;
}

// The `uuid` of a COM interface (`struct __declspec(uuid("...")) IFoo`), kept as struct metadata.
ComUuid :: struct {
    location: Location;
    uuid: string;
}

// Kept so generator scripts that mention it still compile; libclang tokens are released
// inside the bridge and never reach Jai code.
Token_Info :: struct {
    token_pointer: *void;
    num_tokens: u32;
}

Block :: struct {
    parent: *Block;
    members: [..] *Declaration;
}

#add_context generator_options: Generate_Bindings_Options;

#add_context generator: *Generator_State;

Generator_State :: struct #type_info_none {
    global_scope: Block;

    pointer_size: s64 = 8;
    anon_declarations: [..] *Declaration;

    type_def_void: *CType;
    type_def_bool: *CType;

    type_def_u8:   *CType;
    type_def_u16:  *CType;
    type_def_u32:  *CType;
    type_def_u64:  *CType;
    type_def_u128: *CType;

    type_def_s8:   *CType;
    type_def_s16:  *CType;
    type_def_s32:  *CType;
    type_def_s64:  *CType;
    type_def_s128: *CType;

    type_def_float32: *CType;
    type_def_float64: *CType;

    type_def_ptr_void: *CType;

    type_def_jai_string: *CType;
    type_def_type: *CType;

    type_def_objc_class: *CType;
    type_def_objc_selector: *CType;
    type_def_objc_block_pointer: *CType;
    type_def_objc_id: *CType;
    type_def_msvc_destructor_flags: *CType;
    unique_objc_selectors: [..] string;   // Selectors of the generated message sends, in first-use order.
    objc_selector_set: Table(string, bool);
    objc_blocks: Table(string, *CType);   // Block struct types by name, one per signature.

    declarations_by_cursor: Table(Cursor, *Declaration);
    enum_macros: [..] *Enum;
    macros_converted_to_enum_values: Table(string, *Enum);
    unwrapped_typedefs: Table(string, *Typedef);
    added_to_scope: Table(*Declaration, bool);
    known_constants: Table(string, bool);
    function_names_seen: Table(string, bool);
    known_types: Table(string, string); // C name -> output name of emitted structs, enums and typedefs

    libraries: [..] *Library_Info;
    library_ids: [..] string;

    filenames: [..] string;
    file_ids: Table(string, s64);

    extern_declarations: [..] *Declaration;   // Extern variables, deduplicated by symbol.
    com_uuids: [..] ComUuid;                  // `__declspec(uuid(...))` of COM interfaces (Windows headers).
    int128_was_referenced: bool;              // The output uses S128/U128 (from Basic).
    generated_printf_wrapper: bool;           // The output uses tprint and temp_c_string (from Basic).

    structs_to_check: [..] *Struct;
    deferred_struct_checks: [..] *Struct;   // Structs in namespaces: checked at the end of the file.
    pending_anon_enums: [..] Pending_Anon_Enum;

    extra_infos: Table(*Struct, *Struct_Extra_Info);
    template_depth := 0;
    template_params: Table(Cursor, *Struct);   // Placeholder structs standing for template parameters.

    tab_depth := 0;

    counts: struct {
        ignored_system_declarations: u32;
        stripped:                    u32;
        functions:                   u32;
        structs:                     u32;
        enums:                       u32;
    };
}

TAB_STRING :: "    ";

RESERVED_NAMES :: string.[
    "cast", "context", "false", "is_constant", "null", "remove", "true", "type_info", "xx",
    "Any", "bool", "float", "float32", "float64", "int", "s16", "s32", "s64", "s8", "string",
    "u16", "u32", "u64", "u8", "v128", "void",
    "if", "else", "then", "for", "while", "return", "case", "defer", "using", "struct", "union", "enum",
    "enum_flags", "inline", "push_context", "break", "continue", "ifx", "size_of", "type_of", "it",
];

RESERVED_TYPE_NAMES :: string.[
    "Type",
];

TYPEDEFS_TO_UNWRAP :: string.[
    "int8_t", "uint8_t", "int16_t", "uint16_t", "int32_t", "uint32_t", "int64_t", "uint64_t",
    "intptr_t", "uintptr_t", "size_t", "ssize_t", "__ssize_t", "__size_t", "off_t", "loff_t", "off64_t",
    "ptrdiff_t", "intmax_t", "uintmax_t",
    "__int8_t", "__uint8_t", "__int16_t", "__uint16_t", "__int32_t", "__uint32_t", "__int64_t", "__uint64_t",
    "u_int8_t", "u_int16_t", "u_int32_t", "u_int64_t", "u_char", "u_int", "u_short", "u_long",
    "uint", "ushort", "ulong", "uchar", "wchar_t",
    "SInt8", "SInt16", "SInt32", "SInt64", "UInt8", "UInt16", "UInt32", "UInt64",
];

TYPEDEF_PREFIXES_TO_UNWRAP :: string.[
    "__darwin_",
    "__kernel_",
];

MACROS_TO_IGNORE :: string.[
    "__GCC_HAVE_DWARF2_CFI_ASM",
    "WIN32_LEAN_AND_MEAN",
];

// Structural equality, used to tell C++ overloads apart: typedefs are looked through and a
// reference compares like the type it refers to.
is_same_type :: (a: CType, b: CType) -> bool {
    x := a;
    y := b;
    while true {
        if x.type_of_typedef { x = x.type_of_typedef.type.*; continue; }
        if y.type_of_typedef { y = y.type_of_typedef.type.*; continue; }
        if x.pointer_to && y.pointer_to {
            x = x.pointer_to.*;
            y = y.pointer_to.*;
            continue;
        }
        if x.flags & .REFERENCE { x = x.pointer_to.*; continue; }
        if y.flags & .REFERENCE { y = y.pointer_to.*; continue; }
        break;
    }

    if x.size != y.size return false;
    if x.hardcoded_jai_string && x.hardcoded_jai_string == y.hardcoded_jai_string return true;
    if x.type_of_enum   return x.type_of_enum == y.type_of_enum;
    if x.type_of_struct return x.type_of_struct == y.type_of_struct;
    if x.array_element_type {
        return x.array_element_type == y.array_element_type && x.array_element_count == y.array_element_count;
    }
    if x.type_of_function return same_signature(x.type_of_function, y.type_of_function);
    return x.number_flags == y.number_flags;
}

same_signature :: (f: *Function_Type, g: *Function_Type) -> bool {
    if !g || f.arguments.count != g.arguments.count return false;
    if (f.return_type == null) != (g.return_type == null) return false;
    if f.return_type && !is_same_type(f.return_type.*, g.return_type.*) return false;
    for f.arguments {
        if !is_same_type(it.type.*, g.arguments[it_index].type.*) return false;
    }
    return true;
}

// `is_field`: the declaration takes up room in its struct. `is_anon` is set for every nested
// struct, which only counts as a field when it is an anonymous member.
is_struct_field :: (decl: *Declaration) -> is_field: bool, is_anon: bool {
    if decl.kind == .BITFIELD return true, false;
    if decl.kind == .STRUCT {
        anonymous := ((cast(*Struct) decl).flags & .IS_ANON) != 0;
        return anonymous, true;
    }
    if decl.kind != .DECLARATION return false, false;
    // `static const int N = 4;` is a constant, not storage.
    is_constant := (decl.decl_flags & .IS_CONST) != 0 && decl.expression != null;
    return !is_constant, false;
}

visit_declarations :: (visitor: Declaration_Visitor, decl: *Declaration, parent: *Declaration = null, depth := 0) {
    if !decl return;
    result := visitor(decl, parent);
    if result != .RECURSE return;

    if decl.kind == {
        case .FUNCTION;
            func := cast(*Function) decl;
            if func.type && func.type.type_of_function {
                args := func.type.type_of_function.arguments;
                i := 0;
                while i < args.count {
                    visit_declarations(visitor, args[i], decl, depth + 1);
                    i += 1;
                }
            }
        case .STRUCT;
            // Metadata, base classes and virtual functions are visited before the members.
            s := cast(*Struct) decl;
            visit_declaration_list(visitor, *s.metadata, decl, depth + 1);
            visit_declaration_list(visitor, *s.parents, decl, depth + 1);
            visit_declaration_list(visitor, cast(*[..] *Declaration) *s.virtual_functions, decl, depth + 1);
            visit_declaration_list(visitor, *s.declarations, decl, depth + 1);
        case .NAMESPACE;
            n := cast(*Namespace) decl;
            i := 0;
            while i < n.declarations.count {
                visit_declarations(visitor, n.declarations[i], decl, depth + 1);
                i += 1;
            }
        case .BITFIELD;
            b := cast(*Bitfield) decl;
            i := 0;
            while i < b.members.count {
                visit_declarations(visitor, b.members[i], decl, depth + 1);
                i += 1;
            }
    }
}

// The count is re-read every step: a visitor may append to the list it is in.
visit_declaration_list :: (visitor: Declaration_Visitor, list: *[..] *Declaration, parent: *Declaration, depth: int) {
    i := 0;
    while i < list.count {
        visit_declarations(visitor, list.*[i], parent, depth);
        i += 1;
    }
}
