// Independently authored byte-string utilities. Classification is ASCII.
to_string :: inline (s: *u8, length: s64) -> string {
    assert(length >= 0);
    return string.{ count = length, data = s };
}

to_upper :: (c: u8) -> u8 {
    if c >= #char "a" && c <= #char "z" return c - 32;
    return c;
}

to_lower :: (c: u8) -> u8 {
    if c >= #char "A" && c <= #char "Z" return c + 32;
    return c;
}

// Setting bit 5 folds ASCII upper case onto lower case; no other byte lands in a..z.
is_alpha :: (c: u8) -> bool {
    folded := c | 0x20;
    return #char "a" <= folded && folded <= #char "z";
}

is_digit :: (c: u8) -> bool {
    return #char "0" <= c && c <= #char "9";
}

// Identifier characters: letters, digits and the underscore.
is_alnum :: (c: u8) -> bool {
    if c == #char "_" return true;
    return is_digit(c) || is_alpha(c);
}

is_space :: (c: u8) -> bool {
    return c == 32 || (c >= 9 && c <= 13);
}

is_print :: (c: u8) -> bool {
    return c >= 32 && c <= 126;
}

advance :: inline (value: *string, count: s64 = 1) {
    assert(count >= 0 && count <= value.count);
    value.data += count;
    value.count -= count;
}

advance :: inline (s: string, amount: s64 = 1) -> string #must {
    result := s;
    advance(*result, amount);
    return result;
}

eat_spaces :: (_s: string) -> string {
    result := _s;
    while result.count > 0 {
        if !is_space(result[0]) break;
        advance(*result);
    }
    return result;
}

to_c_string :: (s: string) -> *u8 {
    result := cast(*u8) alloc(s.count + 1);
    if !result return null;
    if s.count > 0 memcpy(result, s.data, s.count);
    result[s.count] = 0;
    return result;
}

temp_c_string :: (s: string) -> *u8 {
    result := cast(*u8) temporary_alloc(s.count + 1);
    if !result return null;
    if s.count > 0 memcpy(result, s.data, s.count);
    result[s.count] = 0;
    return result;
}

copy_string :: (s: string) -> string {
    result := alloc_string(s.count);
    if s.count > 0 && result.data memcpy(result.data, s.data, s.count);
    return result;
}

copy_temporary_string :: inline (s: string) -> string {
    result := talloc_string(s.count);
    if s.count > 0 && result.data memcpy(result.data, s.data, s.count);
    return result;
}

to_integer :: (s: string) -> result: int, success: bool, remainder: string {
    return string_to_int(s);
}

// Base 2..36, optional leading whitespace and sign. Overflow is a failure,
// and the unconsumed suffix begins at the first byte that was not a digit.
string_to_int :: (t: string, base := 10, $T := int) -> result: T, success: bool, remainder: string {
    if base < 2 || base > 36 return 0, false, t;
    info := cast(*Type_Info_Integer) type_info(T);
    if info.type != .INTEGER || info.runtime_size > 8 return 0, false, t;
    text := eat_spaces(t);
    position: s64 = 0;
    negative := false;
    if text.count > 0 {
        if text[0] == #char "-" {
            negative = true;
            position += 1;
        } else if text[0] == #char "+" position += 1;
    }
    if negative && !info.signed return 0, false, t;
    limit: u64 = 0xffff_ffff_ffff_ffff;
    bits := info.runtime_size * 8;
    if bits < 64 limit = ((cast(u64) 1) << cast(u8) bits) - 1;
    if info.signed {
        limit >>= 1;
        if negative limit += 1;
    }
    first_digit := position;
    value: u64 = 0;
    while position < text.count {
        byte := text[position];
        digit: u64 = 36;
        if is_digit(byte) digit = byte - #char "0";
        else if is_alpha(byte) digit = to_lower(byte) - #char "a" + 10;
        if digit >= cast(u64) base break;
        if value > (limit - digit) / cast(u64) base return 0, false, t;
        value = value * cast(u64) base + digit;
        position += 1;
    }
    if position == first_digit return 0, false, t;
    if negative && value != 0 value = ~value + 1;
    return cast,no_check(T) value, true, advance(text, position);
}

string_to_float :: (arg: string) -> result: float, success: bool, remainder: string {
    return string_to_float_type_T(arg, T = float);
}

string_to_float64 :: (_s: string) -> result: float64, success: bool, remainder: string {
    return string_to_float_type_T(_s, T = float64);
}

// The same parse with the success flag first: `ok, value, rest := string_to_float64_new(s);`.
string_to_float64_new :: (text: string) -> success: bool, result: float64, remainder: string {
    value, ok, rest := string_to_float_type_T(text, T = float64);
    return ok, value, rest;
}

// Decimal significand plus an optional exponent. This intentionally does not
// recognize hexadecimal floats, NaN/Inf spellings, or locale separators.
string_to_float_type_T :: (_arg: string) -> result: $T, success: bool, remainder: string {
    text := eat_spaces(_arg);
    position: s64 = 0;
    negative := false;
    if text.count > 0 {
        if text[0] == #char "-" {
            negative = true;
            position += 1;
        } else if text[0] == #char "+" position += 1;
    }
    value: T = 0;
    digits: s64 = 0;
    while position < text.count {
        if !is_digit(text[position]) break;
        value = value * 10 + cast(T) (text[position] - #char "0");
        digits += 1;
        position += 1;
    }
    if position < text.count && text[position] == #char "." {
        position += 1;
        scale: T = 0.1;
        while position < text.count {
            if !is_digit(text[position]) break;
            value += cast(T) (text[position] - #char "0") * scale;
            scale *= 0.1;
            digits += 1;
            position += 1;
        }
    }
    if digits == 0 return 0, false, _arg;
    if position < text.count && (text[position] == #char "e" || text[position] == #char "E") {
        exponent_start := position;
        position += 1;
        exponent_negative := false;
        if position < text.count {
            if text[position] == #char "-" {
                exponent_negative = true;
                position += 1;
            } else if text[position] == #char "+" position += 1;
        }
        exponent_digits := position;
        exponent: s64 = 0;
        while position < text.count {
            if !is_digit(text[position]) break;
            if exponent > 400 return 0, false, _arg;
            exponent = exponent * 10 + text[position] - #char "0";
            position += 1;
        }
        if exponent_digits == position position = exponent_start;
        else {
            if exponent > 4000 return 0, false, _arg;
            multiplier: T = 10;
            if exponent_negative multiplier = 0.1;
            while exponent > 0 {
                value *= multiplier;
                exponent -= 1;
            }
        }
    }
    if negative value = -value;
    return value, true, advance(text, position);
}
