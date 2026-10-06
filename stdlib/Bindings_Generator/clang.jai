// Bridge to the host libclang. The interpreter's foreign calls cannot pass the
// by-value structs libclang uses or accept native callbacks, so jaic loads
// libclang itself and hands Jai code integer handles for cursors and types
// (see crates/jaic/src/clang.rs and docs/stdlib/bindings-generator.md).
// Equal cursors have equal handles; handle 0 is "none".

#scope_file

__jaic_clang :: (op: string, a: s64, b: s64, text: string) -> s64 #compiler;
__jaic_clang_text :: () -> string #compiler;

#scope_module

Cursor :: s64;
Clang_Type :: s64;

clang :: (op: string, a: s64 = 0, b: s64 = 0, text := "") -> s64 {
    return __jaic_clang(op, a, b, text);
}

clang_text :: () -> string {
    return copy_string(__jaic_clang_text());
}

clang_string :: (op: string, a: s64 = 0, b: s64 = 0, text := "") -> string {
    __jaic_clang(op, a, b, text);
    return clang_text();
}

// Cursor kinds (CXCursorKind) used by the generator.
Cursor_Kind :: enum s32 {
    UNEXPOSED_DECL :: 1;
    STRUCT_DECL :: 2;
    UNION_DECL :: 3;
    CLASS_DECL :: 4;
    ENUM_DECL :: 5;
    FIELD_DECL :: 6;
    ENUM_CONSTANT_DECL :: 7;
    FUNCTION_DECL :: 8;
    VAR_DECL :: 9;
    PARM_DECL :: 10;
    OBJC_INTERFACE_DECL :: 11;
    OBJC_CATEGORY_DECL :: 12;
    OBJC_PROTOCOL_DECL :: 13;
    OBJC_PROPERTY_DECL :: 14;
    OBJC_IVAR_DECL :: 15;
    OBJC_INSTANCE_METHOD_DECL :: 16;
    OBJC_CLASS_METHOD_DECL :: 17;
    OBJC_SUPER_CLASS_REF :: 40;
    OBJC_PROTOCOL_REF :: 41;
    OBJC_CLASS_REF :: 42;
    OBJC_ROOT_CLASS :: 431;
    TYPEDEF_DECL :: 20;
    CXX_METHOD :: 21;
    NAMESPACE :: 22;
    LINKAGE_SPEC :: 23;
    CONSTRUCTOR :: 24;
    DESTRUCTOR :: 25;
    CONVERSION_FUNCTION :: 26;
    TEMPLATE_TYPE_PARAMETER :: 27;
    NON_TYPE_TEMPLATE_PARAMETER :: 28;
    TEMPLATE_TEMPLATE_PARAMETER :: 29;
    FUNCTION_TEMPLATE :: 30;
    CLASS_TEMPLATE :: 31;
    CLASS_TEMPLATE_PARTIAL_SPECIALIZATION :: 32;
    CXX_ACCESS_SPEC_DECL :: 39;
    CXX_BASE_SPECIFIER :: 44;
    TYPE_ALIAS_DECL :: 36;
    TYPE_REF :: 43;
    TEMPLATE_REF :: 45;
    NAMESPACE_REF :: 46;
    DECL_REF_EXPR :: 101;
    INTEGER_LITERAL :: 106;
    FLOATING_LITERAL :: 107;
    STRING_LITERAL :: 109;
    CHARACTER_LITERAL :: 110;
    PAREN_EXPR :: 111;
    UNARY_OPERATOR :: 112;
    BINARY_OPERATOR :: 114;
    CSTYLE_CAST_EXPR :: 117;
    UNEXPOSED_EXPR :: 100;
    CALL_EXPR :: 103;
    CXX_BOOL_LITERAL :: 130;
    CXX_NULLPTR_LITERAL :: 131;
    CXX_FUNCTIONAL_CAST :: 128;
    GNU_NULL_EXPR :: 123;
    MACRO_DEFINITION :: 501;
}

// Type kinds (CXTypeKind).
T_INVALID :: 0;
T_UNEXPOSED :: 1;
T_VOID :: 2;
T_BOOL :: 3;
T_CHAR_U :: 4;
T_UCHAR :: 5;
T_CHAR16 :: 6;
T_CHAR32 :: 7;
T_USHORT :: 8;
T_UINT :: 9;
T_ULONG :: 10;
T_ULONGLONG :: 11;
T_UINT128 :: 12;
T_CHAR_S :: 13;
T_SCHAR :: 14;
T_WCHAR :: 15;
T_SHORT :: 16;
T_INT :: 17;
T_LONG :: 18;
T_LONGLONG :: 19;
T_INT128 :: 20;
T_FLOAT :: 21;
T_DOUBLE :: 22;
T_LONGDOUBLE :: 23;
T_NULLPTR :: 24;
T_ATTRIBUTED :: 163;
T_OBJCID :: 27;
T_OBJCCLASS :: 28;
T_OBJCSEL :: 29;
T_OBJCINTERFACE :: 108;
T_OBJCOBJECTPOINTER :: 109;
T_OBJCOBJECT :: 161;
T_OBJCTYPEPARAM :: 162;
T_POINTER :: 101;
T_BLOCKPOINTER :: 102;
T_LVALUEREF :: 103;
T_RVALUEREF :: 104;
T_RECORD :: 105;
T_ENUM :: 106;
T_TYPEDEF :: 107;
T_FUNCTIONNOPROTO :: 110;
T_FUNCTIONPROTO :: 111;
T_CONSTANTARRAY :: 112;
T_VECTOR :: 113;
T_INCOMPLETEARRAY :: 114;
T_VARIABLEARRAY :: 115;
T_DEPENDENTSIZEDARRAY :: 116;
T_ELABORATED :: 119;
T_AUTO :: 118;
