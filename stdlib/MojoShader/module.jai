// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
#if OS == .MACOS {
    libmojoshader :: #system_library "jai_mojoshader_legacy_adapter";
}

#if OS == .LINUX {
    libmojoshader :: #system_library "jai_mojoshader_legacy_adapter";
}

#if OS == .WINDOWS {
    libmojoshader :: #system_library "jai_mojoshader_legacy_adapter";
}

MOJOSHADER_version :: () -> s32 #foreign libmojoshader;

MOJOSHADER_changeset :: () -> *u8 #foreign libmojoshader;

MOJOSHADER_malloc :: #type (a0: s32, a1: *void) -> *void #c_call;

MOJOSHADER_free :: #type (a0: *void, a1: *void) -> void #c_call;

using MOJOSHADER_shaderType :: enum u32 {
    MOJOSHADER_TYPE_UNKNOWN :: 0;
    MOJOSHADER_TYPE_PIXEL :: 1;
    MOJOSHADER_TYPE_VERTEX :: 2;
    MOJOSHADER_TYPE_GEOMETRY :: 4;
    MOJOSHADER_TYPE_ANY :: 4294967295;
}

using MOJOSHADER_attributeType :: enum s32 {
    MOJOSHADER_ATTRIBUTE_UNKNOWN :: -1;
    MOJOSHADER_ATTRIBUTE_BYTE :: 0;
    MOJOSHADER_ATTRIBUTE_UBYTE :: 1;
    MOJOSHADER_ATTRIBUTE_SHORT :: 2;
    MOJOSHADER_ATTRIBUTE_USHORT :: 3;
    MOJOSHADER_ATTRIBUTE_INT :: 4;
    MOJOSHADER_ATTRIBUTE_UINT :: 5;
    MOJOSHADER_ATTRIBUTE_FLOAT :: 6;
    MOJOSHADER_ATTRIBUTE_DOUBLE :: 7;
    MOJOSHADER_ATTRIBUTE_HALF_FLOAT :: 8;
}

using MOJOSHADER_uniformType :: enum s32 {
    MOJOSHADER_UNIFORM_UNKNOWN :: -1;
    MOJOSHADER_UNIFORM_FLOAT :: 0;
    MOJOSHADER_UNIFORM_INT :: 1;
    MOJOSHADER_UNIFORM_BOOL :: 2;
}

MOJOSHADER_uniform :: struct {
    type: MOJOSHADER_uniformType;
    index: s32;
    array_count: s32;
    constant: s32;
    name: *u8;
}

MOJOSHADER_constant :: struct {
    type: MOJOSHADER_uniformType;
    index: s32;
    value: union {
        f: [4] float32;
        i: [4] s32;
        b: s32;
    };
}

using MOJOSHADER_samplerType :: enum s32 {
    MOJOSHADER_SAMPLER_UNKNOWN :: -1;
    MOJOSHADER_SAMPLER_2D :: 0;
    MOJOSHADER_SAMPLER_CUBE :: 1;
    MOJOSHADER_SAMPLER_VOLUME :: 2;
}

MOJOSHADER_sampler :: struct {
    type: MOJOSHADER_samplerType;
    index: s32;
    name: *u8;
    texbem: s32;
}

MOJOSHADER_samplerMap :: struct {
    index: s32;
    type: MOJOSHADER_samplerType;
}

using MOJOSHADER_usage :: enum s32 {
    MOJOSHADER_USAGE_UNKNOWN :: -1;
    MOJOSHADER_USAGE_POSITION :: 0;
    MOJOSHADER_USAGE_BLENDWEIGHT :: 1;
    MOJOSHADER_USAGE_BLENDINDICES :: 2;
    MOJOSHADER_USAGE_NORMAL :: 3;
    MOJOSHADER_USAGE_POINTSIZE :: 4;
    MOJOSHADER_USAGE_TEXCOORD :: 5;
    MOJOSHADER_USAGE_TANGENT :: 6;
    MOJOSHADER_USAGE_BINORMAL :: 7;
    MOJOSHADER_USAGE_TESSFACTOR :: 8;
    MOJOSHADER_USAGE_POSITIONT :: 9;
    MOJOSHADER_USAGE_COLOR :: 10;
    MOJOSHADER_USAGE_FOG :: 11;
    MOJOSHADER_USAGE_DEPTH :: 12;
    MOJOSHADER_USAGE_SAMPLE :: 13;
    MOJOSHADER_USAGE_TOTAL :: 14;
}

MOJOSHADER_attribute :: struct {
    usage: MOJOSHADER_usage;
    index: s32;
    name: *u8;
}

MOJOSHADER_swizzle :: struct {
    usage: MOJOSHADER_usage;
    index: u32;
    swizzles: [4] u8;
}

using MOJOSHADER_symbolRegisterSet :: enum u32 {
MOJOSHADER_SYMREGSET_BOOL :: 0;
MOJOSHADER_SYMREGSET_INT4 :: 1;
MOJOSHADER_SYMREGSET_FLOAT4 :: 2;
MOJOSHADER_SYMREGSET_SAMPLER :: 3;
MOJOSHADER_SYMREGSET_TOTAL :: 4;
}

using MOJOSHADER_symbolClass :: enum u32 {
    MOJOSHADER_SYMCLASS_SCALAR :: 0;
    MOJOSHADER_SYMCLASS_VECTOR :: 1;
    MOJOSHADER_SYMCLASS_MATRIX_ROWS :: 2;
    MOJOSHADER_SYMCLASS_MATRIX_COLUMNS :: 3;
    MOJOSHADER_SYMCLASS_OBJECT :: 4;
    MOJOSHADER_SYMCLASS_STRUCT :: 5;
    MOJOSHADER_SYMCLASS_TOTAL :: 6;
}

using MOJOSHADER_symbolType :: enum u32 {
    MOJOSHADER_SYMTYPE_VOID :: 0;
    MOJOSHADER_SYMTYPE_BOOL :: 1;
    MOJOSHADER_SYMTYPE_INT :: 2;
    MOJOSHADER_SYMTYPE_FLOAT :: 3;
    MOJOSHADER_SYMTYPE_STRING :: 4;
    MOJOSHADER_SYMTYPE_TEXTURE :: 5;
    MOJOSHADER_SYMTYPE_TEXTURE1D :: 6;
    MOJOSHADER_SYMTYPE_TEXTURE2D :: 7;
    MOJOSHADER_SYMTYPE_TEXTURE3D :: 8;
    MOJOSHADER_SYMTYPE_TEXTURECUBE :: 9;
    MOJOSHADER_SYMTYPE_SAMPLER :: 10;
    MOJOSHADER_SYMTYPE_SAMPLER1D :: 11;
    MOJOSHADER_SYMTYPE_SAMPLER2D :: 12;
    MOJOSHADER_SYMTYPE_SAMPLER3D :: 13;
    MOJOSHADER_SYMTYPE_SAMPLERCUBE :: 14;
    MOJOSHADER_SYMTYPE_PIXELSHADER :: 15;
    MOJOSHADER_SYMTYPE_VERTEXSHADER :: 16;
    MOJOSHADER_SYMTYPE_PIXELFRAGMENT :: 17;
    MOJOSHADER_SYMTYPE_VERTEXFRAGMENT :: 18;
    MOJOSHADER_SYMTYPE_UNSUPPORTED :: 19;
    MOJOSHADER_SYMTYPE_TOTAL :: 20;
}

MOJOSHADER_symbolTypeInfo :: struct {
    parameter_class: MOJOSHADER_symbolClass;
    parameter_type: MOJOSHADER_symbolType;
    rows: u32;
    columns: u32;
    elements: u32;
    member_count: u32;
    members: *MOJOSHADER_symbolStructMember;
}

MOJOSHADER_symbolStructMember :: struct {
    name: *u8;
    info: MOJOSHADER_symbolTypeInfo;
}

MOJOSHADER_symbol :: struct {
    name: *u8;
    register_set: MOJOSHADER_symbolRegisterSet;
    register_index: u32;
    register_count: u32;
    info: MOJOSHADER_symbolTypeInfo;
}

MOJOSHADER_error :: struct {
    error: *u8;
    filename: *u8;
    error_position: s32;
}

using MOJOSHADER_preshaderOpcode :: enum u32 {
    MOJOSHADER_PRESHADEROP_NOP :: 0;
    MOJOSHADER_PRESHADEROP_MOV :: 1;
    MOJOSHADER_PRESHADEROP_NEG :: 2;
    MOJOSHADER_PRESHADEROP_RCP :: 3;
    MOJOSHADER_PRESHADEROP_FRC :: 4;
    MOJOSHADER_PRESHADEROP_EXP :: 5;
    MOJOSHADER_PRESHADEROP_LOG :: 6;
    MOJOSHADER_PRESHADEROP_RSQ :: 7;
    MOJOSHADER_PRESHADEROP_SIN :: 8;
    MOJOSHADER_PRESHADEROP_COS :: 9;
    MOJOSHADER_PRESHADEROP_ASIN :: 10;
    MOJOSHADER_PRESHADEROP_ACOS :: 11;
    MOJOSHADER_PRESHADEROP_ATAN :: 12;
    MOJOSHADER_PRESHADEROP_MIN :: 13;
    MOJOSHADER_PRESHADEROP_MAX :: 14;
    MOJOSHADER_PRESHADEROP_LT :: 15;
    MOJOSHADER_PRESHADEROP_GE :: 16;
    MOJOSHADER_PRESHADEROP_ADD :: 17;
    MOJOSHADER_PRESHADEROP_MUL :: 18;
    MOJOSHADER_PRESHADEROP_ATAN2 :: 19;
    MOJOSHADER_PRESHADEROP_DIV :: 20;
    MOJOSHADER_PRESHADEROP_CMP :: 21;
    MOJOSHADER_PRESHADEROP_MOVC :: 22;
    MOJOSHADER_PRESHADEROP_DOT :: 23;
    MOJOSHADER_PRESHADEROP_NOISE :: 24;
    MOJOSHADER_PRESHADEROP_SCALAR_OPS :: 25;
    MOJOSHADER_PRESHADEROP_MIN_SCALAR :: 25;
    MOJOSHADER_PRESHADEROP_MAX_SCALAR :: 26;
    MOJOSHADER_PRESHADEROP_LT_SCALAR :: 27;
    MOJOSHADER_PRESHADEROP_GE_SCALAR :: 28;
    MOJOSHADER_PRESHADEROP_ADD_SCALAR :: 29;
    MOJOSHADER_PRESHADEROP_MUL_SCALAR :: 30;
    MOJOSHADER_PRESHADEROP_ATAN2_SCALAR :: 31;
    MOJOSHADER_PRESHADEROP_DIV_SCALAR :: 32;
    MOJOSHADER_PRESHADEROP_DOT_SCALAR :: 33;
    MOJOSHADER_PRESHADEROP_NOISE_SCALAR :: 34;
}

using MOJOSHADER_preshaderOperandType :: enum u32 {
    MOJOSHADER_PRESHADEROPERAND_INPUT :: 0;
    MOJOSHADER_PRESHADEROPERAND_OUTPUT :: 1;
    MOJOSHADER_PRESHADEROPERAND_LITERAL :: 2;
    MOJOSHADER_PRESHADEROPERAND_TEMP :: 3;
}

MOJOSHADER_preshaderOperand :: struct {
    type: MOJOSHADER_preshaderOperandType;
    index: u32;
    array_register_count: u32;
    array_registers: *u32;
}

MOJOSHADER_preshaderInstruction :: struct {
    opcode: MOJOSHADER_preshaderOpcode;
    element_count: u32;
    operand_count: u32;
    operands: [4] MOJOSHADER_preshaderOperand;
}

MOJOSHADER_preshader :: struct {
    literal_count: u32;
    literals: *float64;
    temp_count: u32;
    symbol_count: u32;
    symbols: *MOJOSHADER_symbol;
    instruction_count: u32;
    instructions: *MOJOSHADER_preshaderInstruction;
    register_count: u32;
    registers: *float32;
    malloc: MOJOSHADER_malloc;
    free: MOJOSHADER_free;
    malloc_data: *void;
}

MOJOSHADER_parseData :: struct {
    error_count: s32;
    errors: *MOJOSHADER_error;
    profile: *u8;
    output: *u8;
    output_len: s32;
    instruction_count: s32;
    shader_type: MOJOSHADER_shaderType;
    major_ver: s32;
    minor_ver: s32;
    mainfn: *u8;
    uniform_count: s32;
    uniforms: *MOJOSHADER_uniform;
    constant_count: s32;
    constants: *MOJOSHADER_constant;
    sampler_count: s32;
    samplers: *MOJOSHADER_sampler;
    attribute_count: s32;
    attributes: *MOJOSHADER_attribute;
    output_count: s32;
    outputs: *MOJOSHADER_attribute;
    swizzle_count: s32;
    swizzles: *MOJOSHADER_swizzle;
    symbol_count: s32;
    symbols: *MOJOSHADER_symbol;
    preshader: *MOJOSHADER_preshader;
    malloc: MOJOSHADER_malloc;
    free: MOJOSHADER_free;
    malloc_data: *void;
}

MOJOSHADER_maxShaderModel :: (profile: *u8) -> s32 #foreign libmojoshader;

MOJOSHADER_parse :: (profile: *u8, mainfn: *u8, tokenbuf: *u8, bufsize: u32, swiz: *MOJOSHADER_swizzle, swizcount: u32, smap: *MOJOSHADER_samplerMap, smapcount: u32, m: MOJOSHADER_malloc, f: MOJOSHADER_free, d: *void) -> *MOJOSHADER_parseData #foreign libmojoshader;

MOJOSHADER_freeParseData :: (data: *MOJOSHADER_parseData) -> void #foreign libmojoshader;

MOJOSHADER_parsePreshader :: (buf: *u8, len: u32, m: MOJOSHADER_malloc, f: MOJOSHADER_free, d: *void) -> *MOJOSHADER_preshader #foreign libmojoshader;

MOJOSHADER_freePreshader :: (preshader: *MOJOSHADER_preshader) -> void #foreign libmojoshader;

MOJOSHADER_preprocessorDefine :: struct {
    identifier: *u8;
    definition: *u8;
}

using MOJOSHADER_includeType :: enum u32 {
    MOJOSHADER_INCLUDETYPE_LOCAL :: 0;
    MOJOSHADER_INCLUDETYPE_SYSTEM :: 1;
}

MOJOSHADER_preprocessData :: struct {
    error_count: s32;
    errors: *MOJOSHADER_error;
    output: *u8;
    output_len: s32;
    malloc: MOJOSHADER_malloc;
    free: MOJOSHADER_free;
    malloc_data: *void;
}

MOJOSHADER_includeOpen :: #type (a0: MOJOSHADER_includeType, a1: *u8, a2: *u8, a3: **u8, a4: *u32, a5: MOJOSHADER_malloc, a6: MOJOSHADER_free, a7: *void) -> s32 #c_call;

MOJOSHADER_includeClose :: #type (a0: *u8, a1: MOJOSHADER_malloc, a2: MOJOSHADER_free, a3: *void) -> void #c_call;

MOJOSHADER_preprocess :: (filename: *u8, source: *u8, sourcelen: u32, defines: *MOJOSHADER_preprocessorDefine, define_count: u32, include_open: MOJOSHADER_includeOpen, include_close: MOJOSHADER_includeClose, m: MOJOSHADER_malloc, f: MOJOSHADER_free, d: *void) -> *MOJOSHADER_preprocessData #foreign libmojoshader;

MOJOSHADER_freePreprocessData :: (data: *MOJOSHADER_preprocessData) -> void #foreign libmojoshader;

MOJOSHADER_assemble :: (filename: *u8, source: *u8, sourcelen: u32, comments: **u8, comment_count: u32, symbols: *MOJOSHADER_symbol, symbol_count: u32, defines: *MOJOSHADER_preprocessorDefine, define_count: u32, include_open: MOJOSHADER_includeOpen, include_close: MOJOSHADER_includeClose, m: MOJOSHADER_malloc, f: MOJOSHADER_free, d: *void) -> *MOJOSHADER_parseData #foreign libmojoshader;

using MOJOSHADER_astDataTypeType :: enum u32 {
    MOJOSHADER_AST_DATATYPE_NONE :: 0;
    MOJOSHADER_AST_DATATYPE_BOOL :: 1;
    MOJOSHADER_AST_DATATYPE_INT :: 2;
    MOJOSHADER_AST_DATATYPE_UINT :: 3;
    MOJOSHADER_AST_DATATYPE_FLOAT :: 4;
    MOJOSHADER_AST_DATATYPE_FLOAT_SNORM :: 5;
    MOJOSHADER_AST_DATATYPE_FLOAT_UNORM :: 6;
    MOJOSHADER_AST_DATATYPE_HALF :: 7;
    MOJOSHADER_AST_DATATYPE_DOUBLE :: 8;
    MOJOSHADER_AST_DATATYPE_STRING :: 9;
    MOJOSHADER_AST_DATATYPE_SAMPLER_1D :: 10;
    MOJOSHADER_AST_DATATYPE_SAMPLER_2D :: 11;
    MOJOSHADER_AST_DATATYPE_SAMPLER_3D :: 12;
    MOJOSHADER_AST_DATATYPE_SAMPLER_CUBE :: 13;
    MOJOSHADER_AST_DATATYPE_SAMPLER_STATE :: 14;
    MOJOSHADER_AST_DATATYPE_SAMPLER_COMPARISON_STATE :: 15;
    MOJOSHADER_AST_DATATYPE_STRUCT :: 16;
    MOJOSHADER_AST_DATATYPE_ARRAY :: 17;
    MOJOSHADER_AST_DATATYPE_VECTOR :: 18;
    MOJOSHADER_AST_DATATYPE_MATRIX :: 19;
    MOJOSHADER_AST_DATATYPE_BUFFER :: 20;
    MOJOSHADER_AST_DATATYPE_FUNCTION :: 21;
    MOJOSHADER_AST_DATATYPE_USER :: 22;
}

MOJOSHADER_astDataTypeStructMember :: struct {
    datatype: *MOJOSHADER_astDataType;
    identifier: *u8;
}

MOJOSHADER_astDataTypeStruct :: struct {
    type: MOJOSHADER_astDataTypeType;
    members: *MOJOSHADER_astDataTypeStructMember;
    member_count: s32;
}

MOJOSHADER_astDataTypeArray :: struct {
    type: MOJOSHADER_astDataTypeType;
    base: *MOJOSHADER_astDataType;
    elements: s32;
}

MOJOSHADER_astDataTypeVector :: MOJOSHADER_astDataTypeArray;

MOJOSHADER_astDataTypeMatrix :: struct {
    type: MOJOSHADER_astDataTypeType;
    base: *MOJOSHADER_astDataType;
    rows: s32;
    columns: s32;
}

MOJOSHADER_astDataTypeBuffer :: struct {
    type: MOJOSHADER_astDataTypeType;
    base: *MOJOSHADER_astDataType;
}

MOJOSHADER_astDataTypeFunction :: struct {
    type: MOJOSHADER_astDataTypeType;
    retval: *MOJOSHADER_astDataType;
    params: **MOJOSHADER_astDataType;
    num_params: s32;
    intrinsic: s32;
}

MOJOSHADER_astDataTypeUser :: struct {
    type: MOJOSHADER_astDataTypeType;
    details: *MOJOSHADER_astDataType;
    name: *u8;
}

MOJOSHADER_astDataType :: union {
    type: MOJOSHADER_astDataTypeType;
    array: MOJOSHADER_astDataTypeArray;
    structure: MOJOSHADER_astDataTypeStruct;
    vector: MOJOSHADER_astDataTypeVector;
    matrix: MOJOSHADER_astDataTypeMatrix;
    buffer: MOJOSHADER_astDataTypeBuffer;
    user: MOJOSHADER_astDataTypeUser;
    function: MOJOSHADER_astDataTypeFunction;
}

using MOJOSHADER_astNodeType :: enum u32 {
    MOJOSHADER_AST_OP_START_RANGE :: 0;
    MOJOSHADER_AST_OP_START_RANGE_UNARY :: 1;
    MOJOSHADER_AST_OP_PREINCREMENT :: 2;
    MOJOSHADER_AST_OP_PREDECREMENT :: 3;
    MOJOSHADER_AST_OP_NEGATE :: 4;
    MOJOSHADER_AST_OP_COMPLEMENT :: 5;
    MOJOSHADER_AST_OP_NOT :: 6;
    MOJOSHADER_AST_OP_POSTINCREMENT :: 7;
    MOJOSHADER_AST_OP_POSTDECREMENT :: 8;
    MOJOSHADER_AST_OP_CAST :: 9;
    MOJOSHADER_AST_OP_END_RANGE_UNARY :: 10;
    MOJOSHADER_AST_OP_START_RANGE_BINARY :: 11;
    MOJOSHADER_AST_OP_COMMA :: 12;
    MOJOSHADER_AST_OP_MULTIPLY :: 13;
    MOJOSHADER_AST_OP_DIVIDE :: 14;
    MOJOSHADER_AST_OP_MODULO :: 15;
    MOJOSHADER_AST_OP_ADD :: 16;
    MOJOSHADER_AST_OP_SUBTRACT :: 17;
    MOJOSHADER_AST_OP_LSHIFT :: 18;
    MOJOSHADER_AST_OP_RSHIFT :: 19;
    MOJOSHADER_AST_OP_LESSTHAN :: 20;
    MOJOSHADER_AST_OP_GREATERTHAN :: 21;
    MOJOSHADER_AST_OP_LESSTHANOREQUAL :: 22;
    MOJOSHADER_AST_OP_GREATERTHANOREQUAL :: 23;
    MOJOSHADER_AST_OP_EQUAL :: 24;
    MOJOSHADER_AST_OP_NOTEQUAL :: 25;
    MOJOSHADER_AST_OP_BINARYAND :: 26;
    MOJOSHADER_AST_OP_BINARYXOR :: 27;
    MOJOSHADER_AST_OP_BINARYOR :: 28;
    MOJOSHADER_AST_OP_LOGICALAND :: 29;
    MOJOSHADER_AST_OP_LOGICALOR :: 30;
    MOJOSHADER_AST_OP_ASSIGN :: 31;
    MOJOSHADER_AST_OP_MULASSIGN :: 32;
    MOJOSHADER_AST_OP_DIVASSIGN :: 33;
    MOJOSHADER_AST_OP_MODASSIGN :: 34;
    MOJOSHADER_AST_OP_ADDASSIGN :: 35;
    MOJOSHADER_AST_OP_SUBASSIGN :: 36;
    MOJOSHADER_AST_OP_LSHIFTASSIGN :: 37;
    MOJOSHADER_AST_OP_RSHIFTASSIGN :: 38;
    MOJOSHADER_AST_OP_ANDASSIGN :: 39;
    MOJOSHADER_AST_OP_XORASSIGN :: 40;
    MOJOSHADER_AST_OP_ORASSIGN :: 41;
    MOJOSHADER_AST_OP_DEREF_ARRAY :: 42;
    MOJOSHADER_AST_OP_END_RANGE_BINARY :: 43;
    MOJOSHADER_AST_OP_START_RANGE_TERNARY :: 44;
    MOJOSHADER_AST_OP_CONDITIONAL :: 45;
    MOJOSHADER_AST_OP_END_RANGE_TERNARY :: 46;
    MOJOSHADER_AST_OP_START_RANGE_DATA :: 47;
    MOJOSHADER_AST_OP_IDENTIFIER :: 48;
    MOJOSHADER_AST_OP_INT_LITERAL :: 49;
    MOJOSHADER_AST_OP_FLOAT_LITERAL :: 50;
    MOJOSHADER_AST_OP_STRING_LITERAL :: 51;
    MOJOSHADER_AST_OP_BOOLEAN_LITERAL :: 52;
    MOJOSHADER_AST_OP_END_RANGE_DATA :: 53;
    MOJOSHADER_AST_OP_START_RANGE_MISC :: 54;
    MOJOSHADER_AST_OP_DEREF_STRUCT :: 55;
    MOJOSHADER_AST_OP_CALLFUNC :: 56;
    MOJOSHADER_AST_OP_CONSTRUCTOR :: 57;
    MOJOSHADER_AST_OP_END_RANGE_MISC :: 58;
    MOJOSHADER_AST_OP_END_RANGE :: 59;
    MOJOSHADER_AST_COMPUNIT_START_RANGE :: 60;
    MOJOSHADER_AST_COMPUNIT_FUNCTION :: 61;
    MOJOSHADER_AST_COMPUNIT_TYPEDEF :: 62;
    MOJOSHADER_AST_COMPUNIT_STRUCT :: 63;
    MOJOSHADER_AST_COMPUNIT_VARIABLE :: 64;
    MOJOSHADER_AST_COMPUNIT_END_RANGE :: 65;
    MOJOSHADER_AST_STATEMENT_START_RANGE :: 66;
    MOJOSHADER_AST_STATEMENT_EMPTY :: 67;
    MOJOSHADER_AST_STATEMENT_BREAK :: 68;
    MOJOSHADER_AST_STATEMENT_CONTINUE :: 69;
    MOJOSHADER_AST_STATEMENT_DISCARD :: 70;
    MOJOSHADER_AST_STATEMENT_BLOCK :: 71;
    MOJOSHADER_AST_STATEMENT_EXPRESSION :: 72;
    MOJOSHADER_AST_STATEMENT_IF :: 73;
    MOJOSHADER_AST_STATEMENT_SWITCH :: 74;
    MOJOSHADER_AST_STATEMENT_FOR :: 75;
    MOJOSHADER_AST_STATEMENT_DO :: 76;
    MOJOSHADER_AST_STATEMENT_WHILE :: 77;
    MOJOSHADER_AST_STATEMENT_RETURN :: 78;
    MOJOSHADER_AST_STATEMENT_TYPEDEF :: 79;
    MOJOSHADER_AST_STATEMENT_STRUCT :: 80;
    MOJOSHADER_AST_STATEMENT_VARDECL :: 81;
    MOJOSHADER_AST_STATEMENT_END_RANGE :: 82;
    MOJOSHADER_AST_MISC_START_RANGE :: 83;
    MOJOSHADER_AST_FUNCTION_PARAMS :: 84;
    MOJOSHADER_AST_FUNCTION_SIGNATURE :: 85;
    MOJOSHADER_AST_SCALAR_OR_ARRAY :: 86;
    MOJOSHADER_AST_TYPEDEF :: 87;
    MOJOSHADER_AST_PACK_OFFSET :: 88;
    MOJOSHADER_AST_VARIABLE_LOWLEVEL :: 89;
    MOJOSHADER_AST_ANNOTATION :: 90;
    MOJOSHADER_AST_VARIABLE_DECLARATION :: 91;
    MOJOSHADER_AST_STRUCT_DECLARATION :: 92;
    MOJOSHADER_AST_STRUCT_MEMBER :: 93;
    MOJOSHADER_AST_SWITCH_CASE :: 94;
    MOJOSHADER_AST_ARGUMENTS :: 95;
    MOJOSHADER_AST_MISC_END_RANGE :: 96;
    MOJOSHADER_AST_END_RANGE :: 97;
}

MOJOSHADER_astNodeInfo :: struct {
    type: MOJOSHADER_astNodeType;
    filename: *u8;
    line: u32;
}

using MOJOSHADER_astVariableAttributes :: enum u32 {
    MOJOSHADER_AST_VARATTR_EXTERN :: 1;
    MOJOSHADER_AST_VARATTR_NOINTERPOLATION :: 2;
    MOJOSHADER_AST_VARATTR_SHARED :: 4;
    MOJOSHADER_AST_VARATTR_STATIC :: 8;
    MOJOSHADER_AST_VARATTR_UNIFORM :: 16;
    MOJOSHADER_AST_VARATTR_VOLATILE :: 32;
    MOJOSHADER_AST_VARATTR_CONST :: 64;
    MOJOSHADER_AST_VARATTR_ROWMAJOR :: 128;
    MOJOSHADER_AST_VARATTR_COLUMNMAJOR :: 256;
}

using MOJOSHADER_astIfAttributes :: enum u32 {
        MOJOSHADER_AST_IFATTR_NONE :: 0;
        MOJOSHADER_AST_IFATTR_BRANCH :: 1;
        MOJOSHADER_AST_IFATTR_FLATTEN :: 2;
        MOJOSHADER_AST_IFATTR_IFALL :: 3;
        MOJOSHADER_AST_IFATTR_IFANY :: 4;
        MOJOSHADER_AST_IFATTR_PREDICATE :: 5;
        MOJOSHADER_AST_IFATTR_PREDICATEBLOCK :: 6;
}

using MOJOSHADER_astSwitchAttributes :: enum u32 {
        MOJOSHADER_AST_SWITCHATTR_NONE :: 0;
        MOJOSHADER_AST_SWITCHATTR_FLATTEN :: 1;
        MOJOSHADER_AST_SWITCHATTR_BRANCH :: 2;
        MOJOSHADER_AST_SWITCHATTR_FORCECASE :: 3;
        MOJOSHADER_AST_SWITCHATTR_CALL :: 4;
}

MOJOSHADER_astGeneric :: struct {
    ast: MOJOSHADER_astNodeInfo;
}

MOJOSHADER_astExpression :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
}

MOJOSHADER_astArguments :: struct {
    ast: MOJOSHADER_astNodeInfo;
    argument: *MOJOSHADER_astExpression;
    next: *MOJOSHADER_astArguments;
}

MOJOSHADER_astExpressionUnary :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    operand: *MOJOSHADER_astExpression;
}

MOJOSHADER_astExpressionBinary :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    left: *MOJOSHADER_astExpression;
    right: *MOJOSHADER_astExpression;
}

MOJOSHADER_astExpressionTernary :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    left: *MOJOSHADER_astExpression;
    center: *MOJOSHADER_astExpression;
    right: *MOJOSHADER_astExpression;
}

MOJOSHADER_astExpressionIdentifier :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    identifier: *u8;
    index: s32;
}

MOJOSHADER_astExpressionIntLiteral :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    value: s32;
}

MOJOSHADER_astExpressionFloatLiteral :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    value: float64;
}

MOJOSHADER_astExpressionStringLiteral :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    _string: *u8;
}

MOJOSHADER_astExpressionBooleanLiteral :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    value: s32;
}

MOJOSHADER_astExpressionConstructor :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    args: *MOJOSHADER_astArguments;
}

MOJOSHADER_astExpressionDerefStruct :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    identifier: *MOJOSHADER_astExpression;
    member: *u8;
    isswizzle: s32;
    member_index: s32;
}

MOJOSHADER_astExpressionCallFunction :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    identifier: *MOJOSHADER_astExpressionIdentifier;
    args: *MOJOSHADER_astArguments;
}

MOJOSHADER_astExpressionCast :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    operand: *MOJOSHADER_astExpression;
}

MOJOSHADER_astCompilationUnit :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astCompilationUnit;
}

using MOJOSHADER_astFunctionStorageClass :: enum u32 {
    MOJOSHADER_AST_FNSTORECLS_NONE :: 0;
    MOJOSHADER_AST_FNSTORECLS_INLINE :: 1;
}

using MOJOSHADER_astInputModifier :: enum u32 {
    MOJOSHADER_AST_INPUTMOD_NONE :: 0;
    MOJOSHADER_AST_INPUTMOD_IN :: 1;
    MOJOSHADER_AST_INPUTMOD_OUT :: 2;
    MOJOSHADER_AST_INPUTMOD_INOUT :: 3;
    MOJOSHADER_AST_INPUTMOD_UNIFORM :: 4;
}

using MOJOSHADER_astInterpolationModifier :: enum u32 {
    MOJOSHADER_AST_INTERPMOD_NONE :: 0;
    MOJOSHADER_AST_INTERPMOD_LINEAR :: 1;
    MOJOSHADER_AST_INTERPMOD_CENTROID :: 2;
    MOJOSHADER_AST_INTERPMOD_NOINTERPOLATION :: 3;
    MOJOSHADER_AST_INTERPMOD_NOPERSPECTIVE :: 4;
    MOJOSHADER_AST_INTERPMOD_SAMPLE :: 5;
}

MOJOSHADER_astFunctionParameters :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    input_modifier: MOJOSHADER_astInputModifier;
    identifier: *u8;
    semantic: *u8;
    interpolation_modifier: MOJOSHADER_astInterpolationModifier;
    initializer: *MOJOSHADER_astExpression;
    next: *MOJOSHADER_astFunctionParameters;
}

MOJOSHADER_astFunctionSignature :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    identifier: *u8;
    params: *MOJOSHADER_astFunctionParameters;
    storage_class: MOJOSHADER_astFunctionStorageClass;
    semantic: *u8;
}

MOJOSHADER_astScalarOrArray :: struct {
    ast: MOJOSHADER_astNodeInfo;
    identifier: *u8;
    isarray: s32;
    dimension: *MOJOSHADER_astExpression;
}

MOJOSHADER_astAnnotations :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    initializer: *MOJOSHADER_astExpression;
    next: *MOJOSHADER_astAnnotations;
}

MOJOSHADER_astPackOffset :: struct {
    ast: MOJOSHADER_astNodeInfo;
    ident1: *u8;
    ident2: *u8;
}

MOJOSHADER_astVariableLowLevel :: struct {
    ast: MOJOSHADER_astNodeInfo;
    packoffset: *MOJOSHADER_astPackOffset;
    register_name: *u8;
}

MOJOSHADER_astStructMembers :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    semantic: *u8;
    details: *MOJOSHADER_astScalarOrArray;
    interpolation_mod: MOJOSHADER_astInterpolationModifier;
    next: *MOJOSHADER_astStructMembers;
}

MOJOSHADER_astStructDeclaration :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    name: *u8;
    members: *MOJOSHADER_astStructMembers;
}

MOJOSHADER_astVariableDeclaration :: struct {
    ast: MOJOSHADER_astNodeInfo;
    attributes: s32;
    datatype: *MOJOSHADER_astDataType;
    anonymous_datatype: *MOJOSHADER_astStructDeclaration;
    details: *MOJOSHADER_astScalarOrArray;
    semantic: *u8;
    annotations: *MOJOSHADER_astAnnotations;
    initializer: *MOJOSHADER_astExpression;
    lowlevel: *MOJOSHADER_astVariableLowLevel;
    next: *MOJOSHADER_astVariableDeclaration;
}

MOJOSHADER_astStatement :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astStatement;
}

MOJOSHADER_astEmptyStatement :: MOJOSHADER_astStatement;

MOJOSHADER_astBreakStatement :: MOJOSHADER_astStatement;

MOJOSHADER_astContinueStatement :: MOJOSHADER_astStatement;

MOJOSHADER_astDiscardStatement :: MOJOSHADER_astStatement;

MOJOSHADER_astBlockStatement :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astStatement;
    statements: *MOJOSHADER_astStatement;
}

MOJOSHADER_astReturnStatement :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astStatement;
    expr: *MOJOSHADER_astExpression;
}

MOJOSHADER_astExpressionStatement :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astStatement;
    expr: *MOJOSHADER_astExpression;
}

MOJOSHADER_astIfStatement :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astStatement;
    attributes: s32;
    expr: *MOJOSHADER_astExpression;
    statement: *MOJOSHADER_astStatement;
    else_statement: *MOJOSHADER_astStatement;
}

MOJOSHADER_astSwitchCases :: struct {
    ast: MOJOSHADER_astNodeInfo;
    expr: *MOJOSHADER_astExpression;
    statement: *MOJOSHADER_astStatement;
    next: *MOJOSHADER_astSwitchCases;
}

MOJOSHADER_astSwitchStatement :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astStatement;
    attributes: s32;
    expr: *MOJOSHADER_astExpression;
    cases: *MOJOSHADER_astSwitchCases;
}

MOJOSHADER_astWhileStatement :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astStatement;
    unroll: s32;
    expr: *MOJOSHADER_astExpression;
    statement: *MOJOSHADER_astStatement;
}

MOJOSHADER_astDoStatement :: MOJOSHADER_astWhileStatement;

MOJOSHADER_astForStatement :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astStatement;
    unroll: s32;
    var_decl: *MOJOSHADER_astVariableDeclaration;
    initializer: *MOJOSHADER_astExpression;
    looptest: *MOJOSHADER_astExpression;
    counter: *MOJOSHADER_astExpression;
    statement: *MOJOSHADER_astStatement;
}

MOJOSHADER_astTypedef :: struct {
    ast: MOJOSHADER_astNodeInfo;
    datatype: *MOJOSHADER_astDataType;
    isconst: s32;
    details: *MOJOSHADER_astScalarOrArray;
}

MOJOSHADER_astTypedefStatement :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astStatement;
    _type_info: *MOJOSHADER_astTypedef;
}

MOJOSHADER_astVarDeclStatement :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astStatement;
    declaration: *MOJOSHADER_astVariableDeclaration;
}

MOJOSHADER_astStructStatement :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astStatement;
    struct_info: *MOJOSHADER_astStructDeclaration;
}

MOJOSHADER_astCompilationUnitFunction :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astCompilationUnit;
    declaration: *MOJOSHADER_astFunctionSignature;
    definition: *MOJOSHADER_astStatement;
    index: s32;
}

MOJOSHADER_astCompilationUnitTypedef :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astCompilationUnit;
    _type_info: *MOJOSHADER_astTypedef;
}

MOJOSHADER_astCompilationUnitStruct :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astCompilationUnit;
    struct_info: *MOJOSHADER_astStructDeclaration;
}

MOJOSHADER_astCompilationUnitVariable :: struct {
    ast: MOJOSHADER_astNodeInfo;
    next: *MOJOSHADER_astCompilationUnit;
    declaration: *MOJOSHADER_astVariableDeclaration;
}

MOJOSHADER_astNode :: union {
    ast: MOJOSHADER_astNodeInfo;
    generic: MOJOSHADER_astGeneric;
    expression: MOJOSHADER_astExpression;
    arguments: MOJOSHADER_astArguments;
    unary: MOJOSHADER_astExpressionUnary;
    binary: MOJOSHADER_astExpressionBinary;
    ternary: MOJOSHADER_astExpressionTernary;
    identifier: MOJOSHADER_astExpressionIdentifier;
    intliteral: MOJOSHADER_astExpressionIntLiteral;
    floatliteral: MOJOSHADER_astExpressionFloatLiteral;
    stringliteral: MOJOSHADER_astExpressionStringLiteral;
    boolliteral: MOJOSHADER_astExpressionBooleanLiteral;
    constructor: MOJOSHADER_astExpressionConstructor;
    derefstruct: MOJOSHADER_astExpressionDerefStruct;
    callfunc: MOJOSHADER_astExpressionCallFunction;
    _cast: MOJOSHADER_astExpressionCast;
    compunit: MOJOSHADER_astCompilationUnit;
    params: MOJOSHADER_astFunctionParameters;
    funcsig: MOJOSHADER_astFunctionSignature;
    soa: MOJOSHADER_astScalarOrArray;
    annotations: MOJOSHADER_astAnnotations;
    packoffset: MOJOSHADER_astPackOffset;
    varlowlevel: MOJOSHADER_astVariableLowLevel;
    structmembers: MOJOSHADER_astStructMembers;
    structdecl: MOJOSHADER_astStructDeclaration;
    vardecl: MOJOSHADER_astVariableDeclaration;
    stmt: MOJOSHADER_astStatement;
    emptystmt: MOJOSHADER_astEmptyStatement;
    breakstmt: MOJOSHADER_astBreakStatement;
    contstmt: MOJOSHADER_astContinueStatement;
    discardstmt: MOJOSHADER_astDiscardStatement;
    blockstmt: MOJOSHADER_astBlockStatement;
    returnstmt: MOJOSHADER_astReturnStatement;
    exprstmt: MOJOSHADER_astExpressionStatement;
    ifstmt: MOJOSHADER_astIfStatement;
    cases: MOJOSHADER_astSwitchCases;
    switchstmt: MOJOSHADER_astSwitchStatement;
    whilestmt: MOJOSHADER_astWhileStatement;
    dostmt: MOJOSHADER_astDoStatement;
    forstmt: MOJOSHADER_astForStatement;
    typdef: MOJOSHADER_astTypedef;
    typedefstmt: MOJOSHADER_astTypedefStatement;
    vardeclstmt: MOJOSHADER_astVarDeclStatement;
    structstmt: MOJOSHADER_astStructStatement;
    funcunit: MOJOSHADER_astCompilationUnitFunction;
    typedefunit: MOJOSHADER_astCompilationUnitTypedef;
    structunit: MOJOSHADER_astCompilationUnitStruct;
    varunit: MOJOSHADER_astCompilationUnitVariable;
}

MOJOSHADER_astData :: struct {
    error_count: s32;
    errors: *MOJOSHADER_error;
    source_profile: *u8;
    ast: *MOJOSHADER_astNode;
    malloc: MOJOSHADER_malloc;
    free: MOJOSHADER_free;
    malloc_data: *void;
    opaque: *void;
}

MOJOSHADER_parseAst :: (srcprofile: *u8, filename: *u8, source: *u8, sourcelen: u32, defs: *MOJOSHADER_preprocessorDefine, define_count: u32, include_open: MOJOSHADER_includeOpen, include_close: MOJOSHADER_includeClose, m: MOJOSHADER_malloc, f: MOJOSHADER_free, d: *void) -> *MOJOSHADER_astData #foreign libmojoshader;

MOJOSHADER_freeAstData :: (data: *MOJOSHADER_astData) -> void #foreign libmojoshader;

using MOJOSHADER_irNodeType :: enum u32 {
    MOJOSHADER_IR_START_RANGE_EXPR :: 0;
    MOJOSHADER_IR_CONSTANT :: 1;
    MOJOSHADER_IR_TEMP :: 2;
    MOJOSHADER_IR_BINOP :: 3;
    MOJOSHADER_IR_MEMORY :: 4;
    MOJOSHADER_IR_CALL :: 5;
    MOJOSHADER_IR_ESEQ :: 6;
    MOJOSHADER_IR_ARRAY :: 7;
    MOJOSHADER_IR_CONVERT :: 8;
    MOJOSHADER_IR_SWIZZLE :: 9;
    MOJOSHADER_IR_CONSTRUCT :: 10;
    MOJOSHADER_IR_END_RANGE_EXPR :: 11;
    MOJOSHADER_IR_START_RANGE_STMT :: 12;
    MOJOSHADER_IR_MOVE :: 13;
    MOJOSHADER_IR_EXPR_STMT :: 14;
    MOJOSHADER_IR_JUMP :: 15;
    MOJOSHADER_IR_CJUMP :: 16;
    MOJOSHADER_IR_SEQ :: 17;
    MOJOSHADER_IR_LABEL :: 18;
    MOJOSHADER_IR_DISCARD :: 19;
    MOJOSHADER_IR_END_RANGE_STMT :: 20;
    MOJOSHADER_IR_START_RANGE_MISC :: 21;
    MOJOSHADER_IR_EXPRLIST :: 22;
    MOJOSHADER_IR_END_RANGE_MISC :: 23;
    MOJOSHADER_IR_END_RANGE :: 24;
}

MOJOSHADER_irNodeInfo :: struct {
    type: MOJOSHADER_irNodeType;
    filename: *u8;
    line: u32;
}

MOJOSHADER_irGeneric :: struct {
    ir: MOJOSHADER_irNodeInfo;
}

using MOJOSHADER_irBinOpType :: enum u32 {
    MOJOSHADER_IR_BINOP_ADD :: 0;
    MOJOSHADER_IR_BINOP_SUBTRACT :: 1;
    MOJOSHADER_IR_BINOP_MULTIPLY :: 2;
    MOJOSHADER_IR_BINOP_DIVIDE :: 3;
    MOJOSHADER_IR_BINOP_MODULO :: 4;
    MOJOSHADER_IR_BINOP_AND :: 5;
    MOJOSHADER_IR_BINOP_OR :: 6;
    MOJOSHADER_IR_BINOP_XOR :: 7;
    MOJOSHADER_IR_BINOP_LSHIFT :: 8;
    MOJOSHADER_IR_BINOP_RSHIFT :: 9;
    MOJOSHADER_IR_BINOP_UNKNOWN :: 10;
}

using MOJOSHADER_irConditionType :: enum u32 {
    MOJOSHADER_IR_COND_EQL :: 0;
    MOJOSHADER_IR_COND_NEQ :: 1;
    MOJOSHADER_IR_COND_LT :: 2;
    MOJOSHADER_IR_COND_GT :: 3;
    MOJOSHADER_IR_COND_LEQ :: 4;
    MOJOSHADER_IR_COND_GEQ :: 5;
    MOJOSHADER_IR_COND_UNKNOWN :: 6;
}

MOJOSHADER_irExprInfo :: struct {
    ir: MOJOSHADER_irNodeInfo;
    type: MOJOSHADER_astDataTypeType;
    elements: s32;
}

MOJOSHADER_irConstant :: struct {
    info: MOJOSHADER_irExprInfo;
    anon_struct_10 :: union {
        ival: [16] s32;
        fval: [16] float32;
    }
    value: anon_struct_10;
}

MOJOSHADER_irTemp :: struct {
    info: MOJOSHADER_irExprInfo;
    index: s32;
}

MOJOSHADER_irBinOp :: struct {
    info: MOJOSHADER_irExprInfo;
    op: MOJOSHADER_irBinOpType;
    left: *MOJOSHADER_irExpression;
    right: *MOJOSHADER_irExpression;
}

MOJOSHADER_irMemory :: struct {
    info: MOJOSHADER_irExprInfo;
    index: s32;
}

MOJOSHADER_irCall :: struct {
    info: MOJOSHADER_irExprInfo;
    index: s32;
    args: *MOJOSHADER_irExprList;
}

MOJOSHADER_irESeq :: struct {
    info: MOJOSHADER_irExprInfo;
    stmt: *MOJOSHADER_irStatement;
    expr: *MOJOSHADER_irExpression;
}

MOJOSHADER_irArray :: struct {
    info: MOJOSHADER_irExprInfo;
    array: *MOJOSHADER_irExpression;
    element: *MOJOSHADER_irExpression;
}

MOJOSHADER_irConvert :: struct {
    info: MOJOSHADER_irExprInfo;
    expr: *MOJOSHADER_irExpression;
}

MOJOSHADER_irSwizzle :: struct {
    info: MOJOSHADER_irExprInfo;
    expr: *MOJOSHADER_irExpression;
    channels: [4] u8;
}

MOJOSHADER_irConstruct :: struct {
    info: MOJOSHADER_irExprInfo;
    args: *MOJOSHADER_irExprList;
}

MOJOSHADER_irExpression :: union {
    ir: MOJOSHADER_irNodeInfo;
    info: MOJOSHADER_irExprInfo;
    constant: MOJOSHADER_irConstant;
    temp: MOJOSHADER_irTemp;
    binop: MOJOSHADER_irBinOp;
    memory: MOJOSHADER_irMemory;
    call: MOJOSHADER_irCall;
    eseq: MOJOSHADER_irESeq;
    array: MOJOSHADER_irArray;
    convert: MOJOSHADER_irConvert;
    swizzle: MOJOSHADER_irSwizzle;
    construct: MOJOSHADER_irConstruct;
}

MOJOSHADER_irMove :: struct {
    ir: MOJOSHADER_irNodeInfo;
    dst: *MOJOSHADER_irExpression;
    src: *MOJOSHADER_irExpression;
    writemask: s32;
}

MOJOSHADER_irExprStmt :: struct {
    ir: MOJOSHADER_irNodeInfo;
    expr: *MOJOSHADER_irExpression;
}

MOJOSHADER_irJump :: struct {
    ir: MOJOSHADER_irNodeInfo;
    label: s32;
}

MOJOSHADER_irCJump :: struct {
    ir: MOJOSHADER_irNodeInfo;
    cond: MOJOSHADER_irConditionType;
    left: *MOJOSHADER_irExpression;
    right: *MOJOSHADER_irExpression;
    iftrue: s32;
    iffalse: s32;
}

MOJOSHADER_irSeq :: struct {
    ir: MOJOSHADER_irNodeInfo;
    first: *MOJOSHADER_irStatement;
    next: *MOJOSHADER_irStatement;
}

MOJOSHADER_irLabel :: struct {
    ir: MOJOSHADER_irNodeInfo;
    index: s32;
}

MOJOSHADER_irDiscard :: MOJOSHADER_irGeneric;

MOJOSHADER_irStatement :: union {
    ir: MOJOSHADER_irNodeInfo;
    generic: MOJOSHADER_irGeneric;
    move: MOJOSHADER_irMove;
    expr: MOJOSHADER_irExprStmt;
    jump: MOJOSHADER_irJump;
    cjump: MOJOSHADER_irCJump;
    seq: MOJOSHADER_irSeq;
    label: MOJOSHADER_irLabel;
    discard: MOJOSHADER_irDiscard;
}

MOJOSHADER_irExprList :: struct {
    ir: MOJOSHADER_irNodeInfo;
    expr: *MOJOSHADER_irExpression;
    next: *MOJOSHADER_irExprList;
}

MOJOSHADER_irMisc :: union {
    ir: MOJOSHADER_irNodeInfo;
    generic: MOJOSHADER_irGeneric;
    exprlist: MOJOSHADER_irExprList;
}

MOJOSHADER_irNode :: union {
    ir: MOJOSHADER_irNodeInfo;
    generic: MOJOSHADER_irGeneric;
    expr: MOJOSHADER_irExpression;
    stmt: MOJOSHADER_irStatement;
    misc: MOJOSHADER_irMisc;
}

MOJOSHADER_compileData :: struct {
    error_count: s32;
    errors: *MOJOSHADER_error;
    warning_count: s32;
    warnings: *MOJOSHADER_error;
    source_profile: *u8;
    output: *u8;
    output_len: s32;
    symbol_count: s32;
    symbols: *MOJOSHADER_symbol;
    malloc: MOJOSHADER_malloc;
    free: MOJOSHADER_free;
    malloc_data: *void;
}

MOJOSHADER_compile :: (srcprofile: *u8, filename: *u8, source: *u8, sourcelen: u32, defs: *MOJOSHADER_preprocessorDefine, define_count: u32, include_open: MOJOSHADER_includeOpen, include_close: MOJOSHADER_includeClose, m: MOJOSHADER_malloc, f: MOJOSHADER_free, d: *void) -> *MOJOSHADER_compileData #foreign libmojoshader;

MOJOSHADER_freeCompileData :: (data: *MOJOSHADER_compileData) -> void #foreign libmojoshader;

MOJOSHADER_glGetProcAddress :: #type (a0: *u8, a1: *void) -> *void #c_call;

MOJOSHADER_glContext :: struct {
}

MOJOSHADER_glShader :: struct {
}

MOJOSHADER_glProgram :: struct {
}

MOJOSHADER_glAvailableProfiles :: (lookup: MOJOSHADER_glGetProcAddress, lookup_d: *void, profs: **u8, size: s32, m: MOJOSHADER_malloc, f: MOJOSHADER_free, malloc_d: *void) -> s32 #foreign libmojoshader;

MOJOSHADER_glBestProfile :: (lookup: MOJOSHADER_glGetProcAddress, lookup_d: *void, m: MOJOSHADER_malloc, f: MOJOSHADER_free, malloc_d: *void) -> *u8 #foreign libmojoshader;

MOJOSHADER_glCreateContext :: (profile: *u8, lookup: MOJOSHADER_glGetProcAddress, lookup_d: *void, m: MOJOSHADER_malloc, f: MOJOSHADER_free, malloc_d: *void) -> *MOJOSHADER_glContext #foreign libmojoshader;

MOJOSHADER_glMakeContextCurrent :: (ctx: *MOJOSHADER_glContext) -> void #foreign libmojoshader;

MOJOSHADER_glGetError :: () -> *u8 #foreign libmojoshader;

MOJOSHADER_glMaxUniforms :: (shader_type: MOJOSHADER_shaderType) -> s32 #foreign libmojoshader;

MOJOSHADER_glCompileShader :: (tokenbuf: *u8, bufsize: u32, swiz: *MOJOSHADER_swizzle, swizcount: u32, smap: *MOJOSHADER_samplerMap, smapcount: u32) -> *MOJOSHADER_glShader #foreign libmojoshader;

MOJOSHADER_glGetShaderParseData :: (shader: *MOJOSHADER_glShader) -> *MOJOSHADER_parseData #foreign libmojoshader;

MOJOSHADER_glLinkProgram :: (vshader: *MOJOSHADER_glShader, pshader: *MOJOSHADER_glShader) -> *MOJOSHADER_glProgram #foreign libmojoshader;

MOJOSHADER_glBindProgram :: (program: *MOJOSHADER_glProgram) -> void #foreign libmojoshader;

MOJOSHADER_glBindShaders :: (vshader: *MOJOSHADER_glShader, pshader: *MOJOSHADER_glShader) -> void #foreign libmojoshader;

MOJOSHADER_glSetVertexShaderUniformF :: (idx: u32, data: *float32, vec4count: u32) -> void #foreign libmojoshader;

MOJOSHADER_glGetVertexShaderUniformF :: (idx: u32, data: *float32, vec4count: u32) -> void #foreign libmojoshader;

MOJOSHADER_glSetVertexShaderUniformI :: (idx: u32, data: *s32, ivec4count: u32) -> void #foreign libmojoshader;

MOJOSHADER_glGetVertexShaderUniformI :: (idx: u32, data: *s32, ivec4count: u32) -> void #foreign libmojoshader;

MOJOSHADER_glSetVertexShaderUniformB :: (idx: u32, data: *s32, bcount: u32) -> void #foreign libmojoshader;

MOJOSHADER_glGetVertexShaderUniformB :: (idx: u32, data: *s32, bcount: u32) -> void #foreign libmojoshader;

MOJOSHADER_glSetPixelShaderUniformF :: (idx: u32, data: *float32, vec4count: u32) -> void #foreign libmojoshader;

MOJOSHADER_glGetPixelShaderUniformF :: (idx: u32, data: *float32, vec4count: u32) -> void #foreign libmojoshader;

MOJOSHADER_glSetPixelShaderUniformI :: (idx: u32, data: *s32, ivec4count: u32) -> void #foreign libmojoshader;

MOJOSHADER_glGetPixelShaderUniformI :: (idx: u32, data: *s32, ivec4count: u32) -> void #foreign libmojoshader;

MOJOSHADER_glSetPixelShaderUniformB :: (idx: u32, data: *s32, bcount: u32) -> void #foreign libmojoshader;

MOJOSHADER_glGetPixelShaderUniformB :: (idx: u32, data: *s32, bcount: u32) -> void #foreign libmojoshader;

MOJOSHADER_glSetLegacyBumpMapEnv :: (sampler: u32, mat00: float32, mat01: float32, mat10: float32, mat11: float32, lscale: float32, loffset: float32) -> void #foreign libmojoshader;

MOJOSHADER_glGetVertexAttribLocation :: (usage: MOJOSHADER_usage, index: s32) -> s32 #foreign libmojoshader;

MOJOSHADER_glSetVertexAttribute :: (usage: MOJOSHADER_usage, index: s32, size: u32, type: MOJOSHADER_attributeType, normalized: s32, stride: u32, ptr: *void) -> void #foreign libmojoshader;

MOJOSHADER_glSetVertexAttribDivisor :: (usage: MOJOSHADER_usage, index: s32, divisor: u32) -> void #foreign libmojoshader;

MOJOSHADER_glProgramReady :: () -> void #foreign libmojoshader;

MOJOSHADER_glDeleteProgram :: (program: *MOJOSHADER_glProgram) -> void #foreign libmojoshader;

MOJOSHADER_glDeleteShader :: (shader: *MOJOSHADER_glShader) -> void #foreign libmojoshader;

MOJOSHADER_glDestroyContext :: (ctx: *MOJOSHADER_glContext) -> void #foreign libmojoshader;

#assert size_of(*void) == 8 "This pinned native ABI contract supports 64-bit targets only.";
