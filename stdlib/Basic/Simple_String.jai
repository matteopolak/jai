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
// The digits are gathered as an integer and a power of ten first and converted once at the
// end (decimal_to_float64), so "0.3" gives the double nearest 0.3 rather than 3 * 0.1.
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
    digits: Decimal_Digits;
    seen: s64 = 0;
    while position < text.count {
        if !is_digit(text[position]) break;
        take_decimal_digit(*digits, text[position] - #char "0", after_point = false);
        seen += 1;
        position += 1;
    }
    if position < text.count && text[position] == #char "." {
        position += 1;
        while position < text.count {
            if !is_digit(text[position]) break;
            take_decimal_digit(*digits, text[position] - #char "0", after_point = true);
            seen += 1;
            position += 1;
        }
    }
    if seen == 0 return 0, false, _arg;
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
            if exponent_negative digits.power_of_ten -= exponent;
            else digits.power_of_ten += exponent;
        }
    }
    value := decimal_to_float64(digits.significand, digits.power_of_ten);
    if negative value = -value;
    return cast(T) value, true, advance(text, position);
}

#scope_file
// A decimal number as significand * 10^power_of_ten, keeping at most 19 significant digits
// (all that fit in a u64). Later digits only move the exponent; the error they leave is far
// below a float64's precision.
Decimal_Digits :: struct {
    significand: u64;
    kept: s64;
    power_of_ten: s64;
}

take_decimal_digit :: (digits: *Decimal_Digits, digit: u8, after_point: bool) {
    if digits.significand == 0 && digit == 0 {
        if after_point digits.power_of_ten -= 1; // a leading zero only shifts the point
        return;
    }
    if digits.kept < 19 {
        digits.significand = digits.significand * 10 + digit;
        digits.kept += 1;
        if after_point digits.power_of_ten -= 1;
    } else if !after_point {
        digits.power_of_ten += 1; // a dropped integer digit still scales the value
    }
}

// Every power of ten up to 10^22 is exact in a float64.
EXACT_POWERS_OF_TEN :: float64.[
    1e0, 1e1, 1e2, 1e3, 1e4, 1e5, 1e6, 1e7, 1e8, 1e9, 1e10, 1e11,
    1e12, 1e13, 1e14, 1e15, 1e16, 1e17, 1e18, 1e19, 1e20, 1e21, 1e22,
];

// significand * 10^power_of_ten, rounded to the nearest float64.
decimal_to_float64 :: (significand: u64, power_of_ten: s64) -> float64 #no_aoc {
    if significand == 0 return 0;
    // Both operands exact, so one IEEE multiply or divide rounds correctly.
    if significand <= (cast(u64) 1) << 53 && power_of_ten >= -22 && power_of_ten <= 22 {
        exact := cast(float64) significand;
        if power_of_ten >= 0 return exact * EXACT_POWERS_OF_TEN[power_of_ten];
        return exact / EXACT_POWERS_OF_TEN[-power_of_ten];
    }
    infinity_bits: u64 = 0x7ff0_0000_0000_0000;
    if power_of_ten >= 310 return (cast(*float64) *infinity_bits).*;
    if power_of_ten < -343 return 0; // below half the smallest subnormal even with 19 digits

    // Otherwise scale a 64-bit binary mantissa by ten, one step at a time:
    // value = mantissa * 2^binary_exponent, with mantissa's top bit set.
    mantissa := significand;
    binary_exponent: s64 = 0;
    while (mantissa & 0x8000_0000_0000_0000) == 0 {
        mantissa <<= 1;
        binary_exponent -= 1;
    }
    low_mask: u64 = 0xffff_ffff;
    for 1..power_of_ten {
        // The 68-bit product mantissa * 10, as `top` (its bits above 64) and `bottom`.
        low_product := (mantissa & low_mask) * 10;
        high_product := (mantissa >> 32) * 10 + (low_product >> 32);
        bottom := (high_product << 32) | (low_product & low_mask);
        top := high_product >> 32;
        shift: u64 = 1;
        while (top >> shift) != 0 shift += 1;
        mantissa = (top << (64 - shift)) | (bottom >> shift);
        if (bottom >> (shift - 1)) & 1 {
            mantissa += 1;
            if mantissa == 0 {
                mantissa = 0x8000_0000_0000_0000;
                binary_exponent += 1;
            }
        }
        binary_exponent += cast(s64) shift;
    }
    for 1..-power_of_ten {
        // (mantissa * 2^64) / 10 by long division in 32-bit pieces, keeping the top 64 bits.
        pieces: [4] u64;
        pieces[0] = mantissa >> 32;
        pieces[1] = mantissa & low_mask;
        carry: u64 = 0;
        for i: 0..3 {
            current := (carry << 32) | pieces[i];
            pieces[i] = current / 10;
            carry = current % 10;
        }
        upper := (pieces[0] << 32) | pieces[1];
        lower := (pieces[2] << 32) | pieces[3];
        lead: u64 = 0;
        while ((upper << lead) & 0x8000_0000_0000_0000) == 0 lead += 1;
        mantissa = (upper << lead) | (lower >> (64 - lead));
        if (lower >> (63 - lead)) & 1 {
            mantissa += 1;
            if mantissa == 0 {
                mantissa = 0x8000_0000_0000_0000;
                binary_exponent += 1;
            }
        }
        binary_exponent -= cast(s64) lead;
    }

    // Round the 64-bit mantissa to the 53 bits (fewer when subnormal) a float64 keeps.
    exponent := binary_exponent + 63;
    if exponent > 1023 return (cast(*float64) *infinity_bits).*;
    dropped: u64 = 11;
    if exponent < -1022 dropped += cast(u64) (-1022 - exponent);
    if dropped > 64 return 0;
    kept: u64 = 0;
    rest := mantissa;
    if dropped < 64 {
        kept = mantissa >> dropped;
        rest = mantissa & (((cast(u64) 1) << dropped) - 1);
    }
    half := (cast(u64) 1) << (dropped - 1);
    if rest > half || (rest == half && (kept & 1) != 0) kept += 1;
    bits: u64;
    if exponent < -1022 {
        bits = kept; // a carry into bit 52 lands on the smallest normal exponent by itself
    } else {
        if kept == (cast(u64) 1) << 53 {
            kept >>= 1;
            exponent += 1;
            if exponent > 1023 return (cast(*float64) *infinity_bits).*;
        }
        bits = ((cast(u64) (exponent + 1023)) << 52) | (kept & 0x000f_ffff_ffff_ffff);
    }
    return (cast(*float64) *bits).*;
}
#scope_export
