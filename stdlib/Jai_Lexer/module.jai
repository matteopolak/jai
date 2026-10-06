// Authored scalar Jai lexer. Interface is the supplied lexer API; no maintained replacement exists.

USE_SIMD :: false;

MAX_IDENTIFIER_LENGTH :: 512;

MAX_CONCURRENT_TOKENS :: 8;

LEXER_SIMD_WIDTH :: 16;

Token_Type :: enum s16 {
    BITWISE_XOR :: #char "^";
    BITWISE_NOT :: #char "~";
    BITWISE_AND :: #char "&";
    BITWISE_OR :: #char "|";
    IDENT :: 256;
    NUMBER :: 257;
    STRING :: 258;
    PLUSEQUALS :: 259;
    MINUSEQUALS :: 260;
    TIMESEQUALS :: 261;
    DIVEQUALS :: 262;
    MODEQUALS :: 263;
    ISEQUAL :: 264;
    ISNOTEQUAL :: 265;
    LOGICAL_AND :: 266;
    LOGICAL_OR :: 267;
    LESSEQUALS :: 268;
    GREATEREQUALS :: 269;
    RIGHT_ARROW :: 270;
    DOUBLE_DOT :: 271;
    DOUBLE_DOLLAR :: 272;
    SHIFT_LEFT :: 273;
    SHIFT_RIGHT :: 274;
    ROTATE_LEFT :: 275;
    ROTATE_RIGHT :: 276;
    TRIPLE_EQUALS :: 277;
    SHIFT_LEFT_EQUALS :: 290;
    SHIFT_RIGHT_EQUALS :: 291;
    ROTATE_LEFT_EQUALS :: 292;
    ROTATE_RIGHT_EQUALS :: 293;
    BITWISE_AND_EQUALS :: 294;
    BITWISE_OR_EQUALS :: 295;
    BITWISE_XOR_EQUALS :: 296;
    LOGICAL_AND_EQUALS :: 297;
    LOGICAL_OR_EQUALS :: 298;
    POINTER_DEREFERENCE :: 310;
    POSTFIX_DEREFERENCE :: 311;
    ISEQUAL_FOR_SWITCH_STATEMENT;
    DOUBLE_MINUS;
    TRIPLE_MINUS;
    DOUBLE_COMMA;
    BEGIN_STRUCT_LITERAL;
    BEGIN_ARRAY_LITERAL;
    KEYWORD_FOR;
    __FIRST_KEYWORD :: KEYWORD_FOR;
    KEYWORD_IF;
    KEYWORD_IFX;
    KEYWORD_THEN;
    KEYWORD_ELSE;
    KEYWORD_CASE;
    KEYWORD_RETURN;
    KEYWORD_STRUCT;
    KEYWORD_WHILE;
    KEYWORD_BREAK;
    KEYWORD_CONTINUE;
    KEYWORD_REMOVE;
    KEYWORD_USING;
    KEYWORD_DEFER;
    KEYWORD_SIZE_OF;
    KEYWORD_TYPE_OF;
    KEYWORD_CODE_OF;
    KEYWORD_INITIALIZER_OF;
    KEYWORD_TYPE_INFO;
    KEYWORD_NULL;
    KEYWORD_ENUM;
    KEYWORD_TRUE;
    KEYWORD_FALSE;
    KEYWORD_INLINE;
    KEYWORD_NO_INLINE;
    KEYWORD_CAST;
    KEYWORD_AUTO_CAST;
    KEYWORD_CONTEXT;
    KEYWORD_PUSH_CONTEXT;
    KEYWORD_OPERATOR;
    KEYWORD_IS_CONSTANT;
    KEYWORD_ENUM_FLAGS;
    KEYWORD_UNION;
    KEYWORD_INTERFACE;
    __LAST_KEYWORD :: KEYWORD_INTERFACE;
    QUICK_LAMBDA;
    NOTE;
    END_OF_INPUT;
    POINTER_DEREFERENCE_OR_SHIFT_LEFT;
    OPERATOR_ARRAY_SUBSCRIPT :: 500;
    OPERATOR_ASSIGNMENT_TO_ARRAY_SUBSCRIPT :: 501;
    ERROR;
};

Note_Flags :: enum_flags u8 {
    IS_SYSTEM_LEVEL :: 0x1;
}

Table_String :: #type,isa string;

Value_Flags :: enum_flags u32 {
    HERE_STRING :: 0x1;
    NUMBER :: 0x2;
    HEX :: 0x4;
    BINARY :: 0x8;
    FLOAT :: 0x10;
    REQUIRES_FLOAT64 :: 0x10_0000;
    DEFAULTS_TO_FLOAT64 :: 0x20_0000;
    REQUIRES_FLOAT64_DUE_TO_SIGNIFICANT_DIGITS :: 0x40_0000;
    OVERFLOWED :: 0x1000_0000;
}

Token :: struct {
    type: Token_Type = .ERROR;
    l0, c0: s32;
    l1, c1: s32 = -1;
    union {
        ident_value: struct {
            name: Table_String;
            hash: u32;
        };
        integer_value: u64;
        float64_value: float64;
        string_value: string;
    };
    value_flags: Value_Flags;
    ident_is_backticked := false;
}

Lexer :: struct {
    current_line_number: s32;
    current_external_file_error_report_line_number: s32;
    current_character_index: s32;
    atom_pool: Pool;
    tokens: [MAX_CONCURRENT_TOKENS] Token;
    token_array_cursor: s32;
    num_incoming_tokens: s32;
    input: string;
    input_cursor: s64;
    should_free_input := false;
    total_lines_processed: s64;
    nonblank_lines_processed: s64;
    previous_token_line_number: s64;
    eof_token: Token;
    eof_token.type = .END_OF_INPUT;
    user_data: *void;
    scratch_buffer: [MAX_IDENTIFIER_LENGTH] u8;
    reported_error := false;
}

Hex_Digit_Type :: enum u8 {
    ASCII_8_BIT :: 0;
    UNICODE_16 :: 1;
    UNICODE_32 :: 2;
}

#load "scanner.jai";
