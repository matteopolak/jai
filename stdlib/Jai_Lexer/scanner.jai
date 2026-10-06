#load "classify.jai";
// Byte cursor and eight-slot lookahead ring. Token text belongs to the atom pool.
peek_next_token :: (using lexer: *Lexer) -> *Token {
    return peek_token(lexer, 0);
}
get_last_token :: (lexer: *Lexer) -> Token {
    index := (lexer.token_array_cursor + MAX_CONCURRENT_TOKENS - 1) % MAX_CONCURRENT_TOKENS;
    return lexer.tokens[index];
}


cached_make_atom :: (lexer: *Lexer, name: string, token_to_fill: *Token) {
    token_to_fill.ident_value.name = cast(Table_String) pooled_text(lexer, name);
    hash: u32;
    for byte: name hash = cast,no_check(u32) (cast(u64) hash * 65599 + byte);
    token_to_fill.ident_value.hash = hash;
}
eat_character :: (using lexer: *Lexer) {
    if input_cursor >= input.count return;
    byte := input[input_cursor];
    input_cursor += 1;
    if byte == #char "\n" {
        current_line_number += 1;
        current_character_index = 1;
        total_lines_processed += 1;
    } else {
        current_character_index += 1;
    }
}
peek_next_character :: (lexer: *Lexer) -> s16 {
    if lexer.input_cursor >= lexer.input.count return -1;
    return lexer.input[lexer.input_cursor];
}
report_parse_error :: (lexer: *Lexer, format: string, arguments: ..Any) {
    lexer.reported_error = true;
    log(format, ..arguments);
} @PrintLike
report_parse_error :: (lexer: *Lexer, token: *Token, format: string, arguments: ..Any) {
    lexer.reported_error = true;
    log("lexer at %:%: ", token.l0, token.c0);
    log(format, ..arguments);
} @PrintLike
report_detail :: (lexer: *Lexer, format: string, arguments: ..Any) {
    log(format, ..arguments);
} @PrintLike
get_hex_digit :: (lexer: *Lexer, type: Hex_Digit_Type) -> (value: u8, success: bool) {
    byte := peek_next_character(lexer);
    digit := digit_value(byte);
    if digit < 0 || digit > 15 return 0, false;
    eat_character(lexer);
    return cast(u8) digit, true;
}
get_decimal_digit :: (lexer: *Lexer) -> s32 {
    value := peek_next_character(lexer);
    if !starts_number(value) return -1;
    eat_character(lexer);
    return value - #char "0";
}
set_end_of_token :: (lexer: *Lexer, token: *Token) {
    token.l1 = lexer.current_line_number;
    token.c1 = lexer.current_character_index;
}
unwind_one_character :: (lexer: *Lexer) {
    if lexer.input_cursor == 0 return;
    lexer.input_cursor -= 1;
    if lexer.input[lexer.input_cursor] == #char "\n" {
        lexer.current_line_number -= 1;
        position := lexer.input_cursor;
        while position > 0 && lexer.input[position - 1] != #char "\n" position -= 1;
        lexer.current_character_index = cast(s32) (lexer.input_cursor - position + 1);
        lexer.total_lines_processed -= 1;
    } else {
        lexer.current_character_index -= 1;
    }
}
// Hands out the ring slot just past the pending lookahead, cleared and positioned at
// the current source location. The caller fills in type, value and end position.
get_unused_token :: (lexer: *Lexer) -> *Token {
    assert(lexer.num_incoming_tokens < MAX_CONCURRENT_TOKENS, "Jai_Lexer: token lookahead ring overflowed");
    ring_index := lexer.token_array_cursor + lexer.num_incoming_tokens;
    if ring_index >= MAX_CONCURRENT_TOKENS ring_index -= MAX_CONCURRENT_TOKENS;

    fresh: Token;
    fresh.l0 = lexer.current_line_number;
    fresh.c0 = lexer.current_character_index;
    lexer.tokens[ring_index] = fresh;
    return *lexer.tokens[ring_index];
}
parse_ident :: (lexer: *Lexer, result: *Token) -> string {
    count: s64;
    while true {
        byte := peek_next_character(lexer);
        if byte == #char "\\" {
            eat_character(lexer);
            while peek_next_character(lexer) == #char " " || peek_next_character(lexer) == #char "\t" || peek_next_character(lexer) == #char "\r" || peek_next_character(lexer) == #char "\n" eat_character(lexer);
            continue;
        }
        if !continues_identifier(byte) break;
        if count < MAX_IDENTIFIER_LENGTH lexer.scratch_buffer[count] = cast(u8) byte;
        count += 1;
        eat_character(lexer);
    }
    if count > MAX_IDENTIFIER_LENGTH {
        report_parse_error(lexer, "Identifier exceeds % bytes\n", MAX_IDENTIFIER_LENGTH);
        result.type = .ERROR;
        count = MAX_IDENTIFIER_LENGTH;
    }
    return string.{ count, lexer.scratch_buffer.data };
}
parse_note :: (lexer: *Lexer) -> string {
    begin := lexer.input_cursor;
    while continues_identifier(peek_next_character(lexer)) eat_character(lexer);
    return .{ lexer.input_cursor - begin, lexer.input.data + begin };
}
make_note :: (lexer: *Lexer) -> *Token {
    result := start_token(lexer, .NOTE);
    eat_character(lexer);
    if peek_next_character(lexer) == #char "@" {
        result.value_flags = cast(Value_Flags) Note_Flags.IS_SYSTEM_LEVEL;
        eat_character(lexer);
    }
    cached_make_atom(lexer, parse_note(lexer), result);
    set_end_of_token(lexer, result);
    return result;
}
check_for_keyword :: (token: *Token) -> Token_Type {
    for entry: keywords if token.ident_value.name == entry.text return entry.kind;
    return cast(Token_Type) 0;
}
make_ident_or_keyword :: (lexer: *Lexer) -> *Token {
    result := start_token(lexer, .IDENT);
    cached_make_atom(lexer, parse_ident(lexer, result), result);
    // Reserved words share the identifier spelling; retag them in place.
    reserved := check_for_keyword(result);
    if reserved != cast(Token_Type) 0 result.type = reserved;
    set_end_of_token(lexer, result);
    return result;
}

make_number :: (lexer: *Lexer) -> *Token {
    result := start_token(lexer, .NUMBER);
    result.value_flags = .NUMBER;
    beginning := lexer.input_cursor;
    base: u64 = 10;
    if look_byte(lexer, 0) == #char "0" {
        marker := look_byte(lexer, 1);
        if marker == #char "x" || marker == #char "X" {
            base = 16;
            result.value_flags |= .HEX;
            eat_character(lexer);
            eat_character(lexer);
        } else if marker == #char "b" || marker == #char "B" {
            base = 2;
            result.value_flags |= .BINARY;
            eat_character(lexer);
            eat_character(lexer);
        }
    }
    count: s64;
    integer: u64;
    while true {
        next := peek_next_character(lexer);
        if next == #char "_" {
            eat_character(lexer);
            continue;
        }
        digit := digit_value(next);
        if digit < 0 || cast(u64) digit >= base break;
        if integer > (0xffff_ffff_ffff_ffff - cast(u64) digit) / base result.value_flags |= .OVERFLOWED;
        integer = accumulate_digit_wrapping(integer, base, cast(u64) digit);
        count += 1;
        eat_character(lexer);
    }
    if base == 16 && (peek_next_character(lexer) == #char "." || peek_next_character(lexer) == #char "p" || peek_next_character(lexer) == #char "P") return make_hexfloat(lexer, result);
    floating := base == 10 && (peek_next_character(lexer) == #char "." && look_byte(lexer, 1) != #char "." || peek_next_character(lexer) == #char "e" || peek_next_character(lexer) == #char "E");
    if floating {
        if peek_next_character(lexer) == #char "." {
            eat_character(lexer);
            while starts_number(peek_next_character(lexer)) || peek_next_character(lexer) == #char "_" eat_character(lexer);
        }
        if peek_next_character(lexer) == #char "e" || peek_next_character(lexer) == #char "E" {
            eat_character(lexer);
            if peek_next_character(lexer) == #char "+" || peek_next_character(lexer) == #char "-" eat_character(lexer);
            exponent_start := lexer.input_cursor;
            while starts_number(peek_next_character(lexer)) || peek_next_character(lexer) == #char "_" eat_character(lexer);
            if exponent_start == lexer.input_cursor report_parse_error(lexer, "Expected exponent digits\n");
        }
        text := string.{ lexer.input_cursor - beginning, lexer.input.data + beginning };
        number, success := string_to_float64(text);
        result.float64_value = number;
        result.value_flags |= .FLOAT;
        if !success report_parse_error(lexer, "Invalid floating point literal\n");
        if has_a_big_exponent(number) result.value_flags |= .REQUIRES_FLOAT64;
    } else {
        result.integer_value = integer;
        if count == 0 report_parse_error(lexer, "Expected digits in numeric literal\n");
    }
    set_end_of_token(lexer, result);
    return result;
}
accumulate_digit_wrapping :: (value: u64, base: u64, digit: u64) -> u64 #no_aoc {
    return value * base + digit;
}
make_hexfloat :: (lexer: *Lexer, result: *Token) -> *Token {
    // Not decoded: flag the token and swallow the rest of the literal so scanning resumes cleanly.
    result.type = .ERROR;
    report_parse_error(lexer, "Hexadecimal floating point literals require a dedicated numeric adapter\n");
    while true {
        upcoming := peek_next_character(lexer);
        if upcoming != #char "." && !continues_identifier(upcoming) break;
        eat_character(lexer);
    }
    set_end_of_token(lexer, result);
    return result;
}
make_string_constant :: (lexer: *Lexer) -> *Token {
    result := start_token(lexer, .STRING);
    eat_character(lexer);
    decoded: [..] u8;
    defer array_free(decoded);
    while true {
        character := peek_next_character(lexer);
        if character < 0 || character == #char "\n" {
            report_parse_error(lexer, "Unterminated string literal\n");
            result.type = .ERROR;
            break;
        }
        eat_character(lexer);
        if character == #char "\"" break;
        if character == #char "\\" {
            character = peek_next_character(lexer);
            if character < 0 {
                result.type = .ERROR;
                break;
            }
            eat_character(lexer);
            if character == #char "n" character = #char "\n";
            else if character == #char "r" character = #char "\r";
            else if character == #char "t" character = #char "\t";
            else if character == #char "0" character = 0;
            else if character == #char "u" || character == #char "U" {
                codepoint: u32;
                wanted := ifx character == #char "u" then 4 else 8;
                valid := true;
                for index: 0..wanted - 1 {
                    digit, success := get_hex_digit(lexer, .UNICODE_32);
                    if !success {
                        valid = false;
                        break;
                    }
                    codepoint = (codepoint << 4) | digit;
                }
                if !valid || codepoint > 0x10ffff || (codepoint >= 0xd800 && codepoint <= 0xdfff) {
                    report_parse_error(lexer, "Invalid Unicode scalar escape\n");
                    result.type = .ERROR;
                    break;
                }
                if codepoint <= 0x7f array_add(*decoded, cast(u8) codepoint);
                else if codepoint <= 0x7ff {
                    array_add(*decoded, cast(u8) (0xc0 | (codepoint >> 6)));
                    array_add(*decoded, cast(u8) (0x80 | (codepoint & 0x3f)));
                } else if codepoint <= 0xffff {
                    array_add(*decoded, cast(u8) (0xe0 | (codepoint >> 12)));
                    array_add(*decoded, cast(u8) (0x80 | ((codepoint >> 6) & 0x3f)));
                    array_add(*decoded, cast(u8) (0x80 | (codepoint & 0x3f)));
                } else {
                    array_add(*decoded, cast(u8) (0xf0 | (codepoint >> 18)));
                    array_add(*decoded, cast(u8) (0x80 | ((codepoint >> 12) & 0x3f)));
                    array_add(*decoded, cast(u8) (0x80 | ((codepoint >> 6) & 0x3f)));
                    array_add(*decoded, cast(u8) (0x80 | (codepoint & 0x3f)));
                }
                continue;
            } else if character == #char "x" {
                high, high_ok := get_hex_digit(lexer, .ASCII_8_BIT);
                low, low_ok := get_hex_digit(lexer, .ASCII_8_BIT);
                if !high_ok || !low_ok {
                    report_parse_error(lexer, "Invalid byte escape\n");
                    result.type = .ERROR;
                    break;
                }
                character = ((cast(s16) high) << 4) | low;
            }
        }
        array_add(*decoded, cast(u8) character);
    }
    result.string_value = pooled_text(lexer, string.{ decoded.count, decoded.data });
    set_end_of_token(lexer, result);
    return result;
}
parse_here_string :: (lexer: *Lexer) -> *Token {
    result := start_token(lexer, .STRING);
    result.value_flags = .HERE_STRING;
    while peek_next_character(lexer) == #char " " || peek_next_character(lexer) == #char "\t" eat_character(lexer);
    delimiter_start := lexer.input_cursor;
    while continues_identifier(peek_next_character(lexer)) eat_character(lexer);
    delimiter := string.{ lexer.input_cursor - delimiter_start, lexer.input.data + delimiter_start };
    if delimiter.count == 0 {
        result.type = .ERROR;
        report_parse_error(lexer, "Expected here-string delimiter\n");
        return result;
    }
    eat_until_newline(lexer);
    if peek_next_character(lexer) == #char "\n" eat_character(lexer);
    body_start := lexer.input_cursor;
    body_end := body_start;
    found := false;
    while peek_next_character(lexer) >= 0 {
        line_start := lexer.input_cursor;
        while peek_next_character(lexer) == #char " " || peek_next_character(lexer) == #char "\t" eat_character(lexer);
        matches := true;
        for byte, index: delimiter if look_byte(lexer, index) != byte matches = false;
        if matches {
            after := look_byte(lexer, delimiter.count);
            if after == #char "\n" || after == #char "\r" || after == -1 {
                body_end = line_start;
                for byte: delimiter eat_character(lexer);
                found = true;
                break;
            }
        }
        eat_until_newline(lexer);
        if peek_next_character(lexer) == #char "\n" eat_character(lexer);
    }
    if !found {
        body_end = lexer.input_cursor;
        result.type = .ERROR;
        report_parse_error(lexer, "Missing here-string terminator\n");
    }
    result.string_value = pooled_text(lexer, string.{ body_end - body_start, lexer.input.data + body_start });
    set_end_of_token(lexer, result);
    return result;
}
// Called after the character was consumed, so the token begins one column earlier.
make_one_character_token :: (lexer: *Lexer, c: Token_Type) -> *Token {
    single := start_token(lexer, c);
    single.c0 = lexer.current_character_index - 1;
    set_end_of_token(lexer, single);
    return single;
}
count_herestring_lines :: (lexer: *Lexer, token: *Token) -> s64 {
    count := cast(s64) token.l1 - token.l0;
    if count < 0 count = 0;
    lexer.nonblank_lines_processed += count;
    return count;
}
eat_token :: (lexer: *Lexer) {
    if lexer.num_incoming_tokens <= 0 peek_next_token(lexer);
    token := *lexer.tokens[lexer.token_array_cursor];
    if token.l0 > lexer.previous_token_line_number {
        lexer.nonblank_lines_processed += 1;
        lexer.previous_token_line_number = token.l0;
    }
    lexer.num_incoming_tokens -= 1;
    lexer.token_array_cursor = (lexer.token_array_cursor + 1) % MAX_CONCURRENT_TOKENS;
}
check_for_equals :: (lexer: *Lexer, c: Token_Type, augmented: Token_Type, eat := true, subtractor: s32 = 0) -> *Token {
    if eat eat_character(lexer);
    kind := c;
    if peek_next_character(lexer) == #char "=" {
        eat_character(lexer);
        kind = augmented;
        subtractor += 1;
    }
    result := make_one_character_token(lexer, kind);
    result.c0 -= subtractor;
    return result;
}
eat_input_due_to_block_comment :: (lexer: *Lexer) {
    depth: s32 = 1;
    while depth > 0 {
        if peek_next_character(lexer) < 0 {
            report_parse_error(lexer, "Unterminated block comment\n");
            return;
        }
        if look_byte(lexer, 0) == #char "/" && look_byte(lexer, 1) == #char "*" {
            depth += 1;
            eat_character(lexer);
            eat_character(lexer);
        } else if look_byte(lexer, 0) == #char "*" && look_byte(lexer, 1) == #char "/" {
            depth -= 1;
            eat_character(lexer);
            eat_character(lexer);
        } else eat_character(lexer);
    }
}
eat_until_newline :: (lexer: *Lexer) {
    while peek_next_character(lexer) >= 0 && peek_next_character(lexer) != #char "\n" eat_character(lexer);
}
compose_new_token :: (lexer: *Lexer) -> *Token {
    while true {
        next := peek_next_character(lexer);
        if next == #char " " || next == #char "\t" || next == #char "\r" || next == #char "\n" {
            eat_character(lexer);
            continue;
        }
        if next == #char "/" && look_byte(lexer, 1) == #char "/" {
            eat_until_newline(lexer);
            continue;
        }
        if next == #char "/" && look_byte(lexer, 1) == #char "*" {
            eat_character(lexer);
            eat_character(lexer);
            eat_input_due_to_block_comment(lexer);
            continue;
        }
        if next < 0 {
            result := start_token(lexer, .END_OF_INPUT);
            set_end_of_token(lexer, result);
            return result;
        }
        if starts_identifier(cast(u8) next) return make_ident_or_keyword(lexer);
        if starts_number(next) || next == #char "." && starts_number(look_byte(lexer, 1)) return make_number(lexer);
        if next == #char "\"" return make_string_constant(lexer);
        if next == #char "@" return make_note(lexer);
        if next == #char "`" {
            eat_character(lexer);
            valid := peek_next_character(lexer) >= 0 && starts_identifier(cast(u8) peek_next_character(lexer));
            if !valid report_parse_error(lexer, "Expected an identifier after a backtick\n");
            result := make_ident_or_keyword(lexer);
            if !valid result.type = .ERROR;
            result.ident_is_backticked = true;
            result.c0 -= 1;
            return result;
        }
        if next == #char "#" && ahead_matches(lexer, "#string") && !continues_identifier(look_byte(lexer, 7)) {
            for byte: "#string" eat_character(lexer);
            return parse_here_string(lexer);
        }
        for entry: compound_tokens {
            if ahead_matches(lexer, entry.text) {
                result := start_token(lexer, entry.kind);
                for byte: entry.text eat_character(lexer);
                set_end_of_token(lexer, result);
                return result;
            }
        }
        eat_character(lexer);
        return make_one_character_token(lexer, cast(Token_Type) next);
    }
}
peek_token :: (lexer: *Lexer, lookahead_index: s32) -> *Token {
    assert(lookahead_index >= 0 && lookahead_index < MAX_CONCURRENT_TOKENS);
    while lexer.num_incoming_tokens <= lookahead_index {
        compose_new_token(lexer);
        lexer.num_incoming_tokens += 1;
    }
    slot := (lexer.token_array_cursor + lookahead_index) % MAX_CONCURRENT_TOKENS;
    return *lexer.tokens[slot];
}
// Points the lexer at new text (not copied, not owned) and rewinds all scanning state.
set_input_from_string :: (lexer: *Lexer, input: string) {
    // A buffer from set_input_from_file belongs to us; release it before dropping it.
    if lexer.should_free_input {
        free(lexer.input);
        lexer.should_free_input = false;
    }
    lexer.input, lexer.input_cursor = input, 0;

    lexer.token_array_cursor, lexer.num_incoming_tokens = 0, 0;
    lexer.reported_error = false;

    // Lines and columns count from 1; no token has been produced yet.
    lexer.previous_token_line_number = 0;
    lexer.current_line_number = 1;
    lexer.current_external_file_error_report_line_number = 1;
    lexer.current_character_index = 1;
}
set_input_from_file :: (lexer: *Lexer, file_path: string) -> bool {
    source, success := File.read_entire_file(file_path, zero_terminated = true);
    if !success return false;
    set_input_from_string(lexer, source);
    lexer.should_free_input = true;
    return true;
}


#scope_module

start_token :: (lexer: *Lexer, type: Token_Type) -> *Token {
    token := get_unused_token(lexer);
    token.type = type;
    return token;
}
#import "Basic";
Pool_Module :: #import "Pool";
Pool :: Pool_Module.Pool;
File :: #import "File";
pooled_text :: (lexer: *Lexer, text: string) -> string {
    storage := cast(*u8) Pool_Module.get(*lexer.atom_pool, text.count + 1);
    memcpy(storage, text.data, text.count);
    storage[text.count] = 0;
    return .{ text.count, storage };
}
look_byte :: (lexer: *Lexer, ahead: s64) -> s16 {
    offset := lexer.input_cursor + ahead;
    if offset < 0 || offset >= lexer.input.count return -1;
    return lexer.input[offset];
}
ahead_matches :: (lexer: *Lexer, text: string) -> bool {
    for byte, index: text if look_byte(lexer, index) != byte return false;
    return true;
}

keywords: [] struct {
    text: string;
    kind: Token_Type;
} = .[
.{ "for", .KEYWORD_FOR }, .{ "if", .KEYWORD_IF }, .{ "ifx", .KEYWORD_IFX }, .{ "then", .KEYWORD_THEN }, .{ "else", .KEYWORD_ELSE },
.{ "case", .KEYWORD_CASE }, .{ "return", .KEYWORD_RETURN }, .{ "struct", .KEYWORD_STRUCT }, .{ "while", .KEYWORD_WHILE },
.{ "break", .KEYWORD_BREAK }, .{ "continue", .KEYWORD_CONTINUE }, .{ "remove", .KEYWORD_REMOVE }, .{ "using", .KEYWORD_USING },
.{ "defer", .KEYWORD_DEFER }, .{ "size_of", .KEYWORD_SIZE_OF }, .{ "type_of", .KEYWORD_TYPE_OF }, .{ "code_of", .KEYWORD_CODE_OF },
.{ "initializer_of", .KEYWORD_INITIALIZER_OF }, .{ "type_info", .KEYWORD_TYPE_INFO }, .{ "null", .KEYWORD_NULL },
.{ "enum", .KEYWORD_ENUM }, .{ "true", .KEYWORD_TRUE }, .{ "false", .KEYWORD_FALSE }, .{ "inline", .KEYWORD_INLINE },
.{ "no_inline", .KEYWORD_NO_INLINE }, .{ "cast", .KEYWORD_CAST }, .{ "xx", .KEYWORD_AUTO_CAST }, .{ "context", .KEYWORD_CONTEXT },
.{ "push_context", .KEYWORD_PUSH_CONTEXT }, .{ "operator", .KEYWORD_OPERATOR }, .{ "is_constant", .KEYWORD_IS_CONSTANT },
.{ "enum_flags", .KEYWORD_ENUM_FLAGS }, .{ "union", .KEYWORD_UNION }, .{ "interface", .KEYWORD_INTERFACE }
];
compound_tokens: [] struct {
    text: string;
    kind: Token_Type;
} = .[
.{ "<<<=", .ROTATE_LEFT_EQUALS }, .{ ">>>=", .ROTATE_RIGHT_EQUALS }, .{ "&&=", .LOGICAL_AND_EQUALS }, .{ "||=", .LOGICAL_OR_EQUALS },
.{ "<<=", .SHIFT_LEFT_EQUALS }, .{ ">>=", .SHIFT_RIGHT_EQUALS }, .{ "===", .TRIPLE_EQUALS }, .{ "---", .TRIPLE_MINUS },
.{ "+=", .PLUSEQUALS }, .{ "-=", .MINUSEQUALS }, .{ "*=", .TIMESEQUALS }, .{ "/=", .DIVEQUALS }, .{ "%=", .MODEQUALS },
.{ "==", .ISEQUAL }, .{ "!=", .ISNOTEQUAL }, .{ "&&", .LOGICAL_AND }, .{ "||", .LOGICAL_OR }, .{ "<=", .LESSEQUALS }, .{ ">=", .GREATEREQUALS },
.{ "->", .RIGHT_ARROW }, .{ "..", .DOUBLE_DOT }, .{ "$$", .DOUBLE_DOLLAR }, .{ "<<", .POINTER_DEREFERENCE_OR_SHIFT_LEFT }, .{ ">>", .SHIFT_RIGHT },
.{ "&=", .BITWISE_AND_EQUALS }, .{ "|=", .BITWISE_OR_EQUALS }, .{ "^=", .BITWISE_XOR_EQUALS }, .{ ".*", .POSTFIX_DEREFERENCE },
.{ "--", .DOUBLE_MINUS }, .{ ",,", .DOUBLE_COMMA }, .{ ".{", .BEGIN_STRUCT_LITERAL }, .{ ".[", .BEGIN_ARRAY_LITERAL }
];
