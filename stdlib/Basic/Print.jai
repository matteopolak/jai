// Independently authored formatting. The format* factories return formatter
// records, as in the maintained Basic module.
Formatter :: struct {
    value: Any;
}

FormatInt :: struct {
    using #as formatter: Formatter;
    base := 10;
    minimum_digits := 1;
    padding: u8 = #char "0";
    digits_per_comma: u16 = 0;
    comma_string := "";
}

FormatFloat :: struct {
    using #as formatter: Formatter;
    width := -1;
    trailing_width := -1;
    Zero_Removal :: enum {
        YES;
        NO;
        ONE_ZERO_AFTER_DECIMAL;
    }
    zero_removal := Zero_Removal.YES;
    Mode :: enum {
        DECIMAL;
        SCIENTIFIC;
        SHORTEST;
    }
    mode := Mode.DECIMAL;
    thousand_separators := false;
    thousand_separator_character: u8 = #char ",";
    decimal_separator_character: u8 = #char ".";
    exponent_character: u8 = #char "e";
    Positive_Number_Prefix :: enum {
        NONE;
        PLUS;
        SPACE;
    }
    positive_number_prefix := Positive_Number_Prefix.NONE;
}

FormatStruct :: struct {
    using #as formatter: Formatter;
    draw_type_name := false;
    use_long_form_if_more_than_this_many_members := 5;
    separator_between_name_and_value := " = ";
    short_form_separator_between_fields := ", ";
    long_form_separator_between_fields := "; ";
    begin_string := "{";
    end_string := "}";
    indentation_width: s32 = 4;
    use_newlines_if_long_form := false;
}

FormatArray :: struct {
    using #as formatter: Formatter;
    separator := ", ";
    begin_string := "[";
    end_string := "]";
    printing_stopped_early_string := "...";
    draw_separator_after_last_element := false;
    stop_printing_after_this_many_elements := 100;
}

Print_Style :: struct {
    // Fallback settings for values passed to print without a Format* wrapper. Only the
    // knobs (base, width, separators...) are consulted; the embedded `value` is unused.
    default_format_int: FormatInt;
    default_format_float: FormatFloat;
    default_format_struct: FormatStruct;
    default_format_array: FormatArray;
    // Pointers print as hex with an underscore every 4 digits and no 0x prefix.
    default_format_absolute_pointer: FormatInt = .{ base = 16, digits_per_comma = 4, comma_string = "_" };

    struct_printer: (builder: *String_Builder, any: Any, struct_printer_data: *void) -> bool;
    struct_printer_data: *void;
    indentation_depth: s32;
    log_runtime_errors := true;
}

#add_context print_style: Print_Style;

// Several configured instances of Basic can coexist, but the context field has the type
// declared by only one of them. Copy the style member by member into this instance's types.
__default_format_int :: () -> FormatInt {
    source := context.print_style.default_format_int;
    result: FormatInt;
    result.base = source.base;
    result.minimum_digits = source.minimum_digits;
    result.padding = source.padding;
    result.digits_per_comma = source.digits_per_comma;
    result.comma_string = source.comma_string;
    return result;
}

__default_format_pointer :: () -> FormatInt {
    source := context.print_style.default_format_absolute_pointer;
    result: FormatInt;
    result.base = source.base;
    result.minimum_digits = source.minimum_digits;
    result.padding = source.padding;
    result.digits_per_comma = source.digits_per_comma;
    result.comma_string = source.comma_string;
    return result;
}

__default_format_float :: () -> FormatFloat {
    source := context.print_style.default_format_float;
    result: FormatFloat;
    result.width = source.width;
    result.trailing_width = source.trailing_width;
    result.zero_removal = cast(FormatFloat.Zero_Removal) cast(s64) source.zero_removal;
    result.mode = cast(FormatFloat.Mode) cast(s64) source.mode;
    result.thousand_separators = source.thousand_separators;
    result.thousand_separator_character = source.thousand_separator_character;
    result.decimal_separator_character = source.decimal_separator_character;
    result.exponent_character = source.exponent_character;
    result.positive_number_prefix = cast(FormatFloat.Positive_Number_Prefix) cast(s64) source.positive_number_prefix;
    return result;
}

__default_format_struct :: () -> FormatStruct {
    source := context.print_style.default_format_struct;
    result: FormatStruct;
    result.draw_type_name = source.draw_type_name;
    result.use_long_form_if_more_than_this_many_members = source.use_long_form_if_more_than_this_many_members;
    result.separator_between_name_and_value = source.separator_between_name_and_value;
    result.short_form_separator_between_fields = source.short_form_separator_between_fields;
    result.long_form_separator_between_fields = source.long_form_separator_between_fields;
    result.begin_string = source.begin_string;
    result.end_string = source.end_string;
    result.indentation_width = source.indentation_width;
    result.use_newlines_if_long_form = source.use_newlines_if_long_form;
    return result;
}

// Formatter factories. They only wrap the value; formatting happens in print.

formatInt :: (value: Any, base := 10, minimum_digits := 1, padding: u8 = #char "0", digits_per_comma: u16 = 0, comma_string := "") -> FormatInt {
    return FormatInt.{ value = value, base = base, minimum_digits = minimum_digits,
        padding = padding, digits_per_comma = digits_per_comma, comma_string = comma_string };
}

formatFloat :: (value: Any, width := -1, trailing_width := -1,
    mode := FormatFloat.Mode.DECIMAL, zero_removal := FormatFloat.Zero_Removal.YES) -> FormatFloat {
    return FormatFloat.{ value = value, width = width, trailing_width = trailing_width, mode = mode, zero_removal = zero_removal };
}

formatStruct :: (value: Any, use_long_form_if_more_than_this_many_members := 5, use_newlines_if_long_form := false) -> FormatStruct {
    return FormatStruct.{ value = value, use_long_form_if_more_than_this_many_members = use_long_form_if_more_than_this_many_members,
        use_newlines_if_long_form = use_newlines_if_long_form };
}

get_s64_from_void_pointer :: (pointer: *void, size_in_bytes: int) -> s64 {
    if size_in_bytes == 1 return (cast(*s8) pointer).*;
    if size_in_bytes == 2 return (cast(*s16) pointer).*;
    if size_in_bytes == 4 return (cast(*s32) pointer).*;
    if size_in_bytes == 8 return (cast(*s64) pointer).*;
    assert(false, "Unsupported integer storage width.");
    return 0;
}

get_u64_from_void_pointer :: (pointer: *void, size_in_bytes: int) -> u64 {
    if size_in_bytes == 1 return (cast(*u8) pointer).*;
    if size_in_bytes == 2 return (cast(*u16) pointer).*;
    if size_in_bytes == 4 return (cast(*u32) pointer).*;
    if size_in_bytes == 8 return (cast(*u64) pointer).*;
    assert(false, "Unsupported integer storage width.");
    return 0;
}

print_u64_base_n :: (builder: *String_Builder, v: u64, format: FormatInt) {
    if format.base < 2 || format.base > 36 {
        append(builder, "<invalid integer base>");
        builder.failed = true;
        return;
    }
    alphabet :: "0123456789abcdefghijklmnopqrstuvwxyz";
    digits: [64] u8;
    count: s64 = 0;
    remaining := v;
    while true {
        digits[count] = alphabet[cast(s64) (remaining % cast(u64) format.base)];
        count += 1;
        remaining /= cast(u64) format.base;
        if remaining == 0 break;
    }
    index := max(cast(s64) format.minimum_digits, count) - 1;
    while index >= 0 {
        if index >= count append(builder, format.padding);
        else append(builder, digits[index]);
        if index > 0 && format.digits_per_comma > 0 && index % format.digits_per_comma == 0 append(builder, format.comma_string);
        index -= 1;
    }
}

print_integer :: (builder: *String_Builder, format: FormatInt) {
    item := format.value;
    if !item.type || !item.value_pointer {
        append(builder, "<null formatter>");
        builder.failed = true;
        return;
    }
    info := item.type;
    while info.type == .VARIANT info = (cast(*Type_Info_Variant) info).variant_of;
    if info.type == .ENUM info = cast(*Type_Info) (cast(*Type_Info_Enum) info).internal_type;
    if info.type != .INTEGER || info.runtime_size > 8 {
        append(builder, "<non-integer>");
        builder.failed = true;
        return;
    }
    integer := cast(*Type_Info_Integer) info;
    magnitude: u64 = 0;
    if integer.signed {
        value := get_s64_from_void_pointer(item.value_pointer, info.runtime_size);
        magnitude = cast,no_check(u64) value;
        if value < 0 {
            append(builder, cast(u8) #char "-");
            magnitude = ~magnitude + 1;
        }
    } else magnitude = get_u64_from_void_pointer(item.value_pointer, info.runtime_size);
    print_u64_base_n(builder, magnitude, format);
}

// Independently authored exact binary64-to-decimal conversion. All arithmetic
// after IEEE bit decomposition is bounded integer arithmetic. 36 radix-2^32
// limbs cover binary64's denominator through 2^1076 with normalization slack.
__Float_Wide :: struct {
    words: [36] u32;
    used: s64;
}

__Float_Digits :: struct {
    digits: [344] u8;
    count: s64;
    exponent: s64;
    valid: bool;
}

__float_wide_set :: (a: *__Float_Wide, value: u64) {
    a.* = .{};
    if value == 0 return;
    a.words[0] = cast,no_check(u32) value;
    a.used = 1;
    if value >> 32 != 0 {
        a.words[1] = cast(u32) (value >> 32);
        a.used = 2;
    }
}

__float_wide_compare :: (a: *__Float_Wide, b: *__Float_Wide) -> s64 {
    if a.used < b.used return -1;
    if a.used > b.used return 1;
    i := a.used - 1;
    while i >= 0 {
        if a.words[i] < b.words[i] return -1;
        if a.words[i] > b.words[i] return 1;
        i -= 1;
    }
    return 0;
}

__float_wide_multiply :: (a: *__Float_Wide, factor: u32) -> bool {
    carry: u64 = 0;
    for i: 0..a.used - 1 {
        product := cast(u64) a.words[i] * cast(u64) factor + carry;
        a.words[i] = cast,no_check(u32) product;
        carry = product >> 32;
    }
    if carry != 0 {
        if a.used == 36 return false;
        a.words[a.used] = cast(u32) carry;
        a.used += 1;
    }
    return true;
}

__float_wide_shift :: (a: *__Float_Wide, bits: s64) -> bool {
    if a.used == 0 return true;
    words := bits / 32;
    rest := bits % 32;
    if a.used + words + 1 > 36 return false;
    i := a.used - 1;
    while i >= 0 {
        a.words[i + words] = a.words[i];
        i -= 1;
    }
    for i: 0..words - 1 a.words[i] = 0;
    a.used += words;
    if rest != 0 {
        carry: u32 = 0;
        for i: words..a.used - 1 {
            word := a.words[i];
            a.words[i] = (word << rest) | carry;
            carry = word >> (32 - rest);
        }
        if carry != 0 {
            a.words[a.used] = carry;
            a.used += 1;
        }
    }
    return true;
}

__float_wide_add :: (a: *__Float_Wide, b: *__Float_Wide) -> bool {
    count := a.used;
    if b.used > count count = b.used;
    carry: u64 = 0;
    for i: 0..count - 1 {
        left: u64 = 0;
        right: u64 = 0;
        if i < a.used left = a.words[i];
        if i < b.used right = b.words[i];
        sum := left + right + carry;
        a.words[i] = cast,no_check(u32) sum;
        carry = sum >> 32;
    }
    a.used = count;
    if carry != 0 {
        if count == 36 return false;
        a.words[count] = cast(u32) carry;
        a.used += 1;
    }
    return true;
}

__float_wide_subtract :: (a: *__Float_Wide, b: *__Float_Wide) {
    // Callers compare first. Adding 2^32 keeps every limb subtraction bounded.
    borrow: u64 = 0;
    for i: 0..a.used - 1 {
        right: u64 = 0;
        if i < b.used right = b.words[i];
        difference := cast(u64) a.words[i] + 0x1_0000_0000 - right - borrow;
        a.words[i] = cast,no_check(u32) difference;
        borrow = 1 - (difference >> 32);
    }
    while a.used > 0 && a.words[a.used - 1] == 0 a.used -= 1;
}

// The same operations on a plain u64. Most printed values (small integers, short decimals) never
// leave 64 bits, so __float_decimal_digits tries this first and redoes the work with wide limbs
// only when an operation would overflow.
__float_wide_set :: (a: *u64, value: u64) {
    a.* = value;
}

__float_wide_compare :: (a: *u64, b: *u64) -> s64 {
    if a.* < b.* return -1;
    if a.* > b.* return 1;
    return 0;
}

__float_wide_multiply :: (a: *u64, factor: u32) -> bool {
    if a.* > cast(u64) 0xffff_ffff_ffff_ffff / factor return false;
    a.* *= factor;
    return true;
}

__float_wide_add :: (a: *u64, b: *u64) -> bool {
    if a.* > cast(u64) 0xffff_ffff_ffff_ffff - b.* return false;
    a.* += b.*;
    return true;
}

__float_wide_subtract :: (a: *u64, b: *u64) {
    a.* -= b.*;
}

__float_wide_shift :: (a: *u64, bits: s64) -> bool {
    if a.* == 0 return true;
    if bits >= 64 || a.* >> cast(u64) (64 - bits) != 0 return false;
    a.* <<= cast(u64) bits;
    return true;
}

__float_round_digits :: (result: *__Float_Digits) {
    i := result.count - 1;
    while i >= 0 && result.digits[i] == 9 {
        result.digits[i] = 0;
        i -= 1;
    }
    if i >= 0 result.digits[i] += 1;
    else {
        result.digits[0] = 1;
        result.exponent += 1;
    }
}

// requested = -1 selects the least number of digits inside the nearest-even
// rounding interval. fixed_after_point supplies DECIMAL precision; otherwise
// requested is the required significant digit count.
__float_decimal_digits :: (bits: u64, requested: s64, fixed_after_point: s64 = -1) -> __Float_Digits {
    result := __float_decimal_digits_in(u64, bits, requested, fixed_after_point);
    if !result.valid result = __float_decimal_digits_in(__Float_Wide, bits, requested, fixed_after_point);
    return result;
}

// Invalid results include overflow of T; the caller then retries with __Float_Wide.
__float_decimal_digits_in :: ($T: Type, bits: u64, requested: s64, fixed_after_point: s64) -> __Float_Digits {
    result: __Float_Digits;
    fraction := bits & 0x000f_ffff_ffff_ffff;
    binary_exponent := cast(s64) ((bits >> 52) & 0x7ff);
    if binary_exponent == 0x7ff return result;
    if binary_exponent == 0 && fraction == 0 {
        result.count = 1;
        result.valid = true;
        return result;
    }
    mantissa := fraction;
    power: s64 = -1076;
    if binary_exponent > 0 {
        mantissa |= 0x0010_0000_0000_0000;
        power = binary_exponent - 1077;
    }
    r, s, below, above: T;
    __float_wide_set(*r, mantissa * 4);
    __float_wide_set(*s, 1);
    __float_wide_set(*below, 2);
    __float_wide_set(*above, 2);
    // Powers of two above the smallest normal have half-sized lower spacing.
    if fraction == 0 && binary_exponent > 1 __float_wide_set(*below, 1);
    if power >= 0 {
        if !__float_wide_shift(*r, power) || !__float_wide_shift(*below, power) || !__float_wide_shift(*above, power) return result;
    } else {
        if !__float_wide_shift(*s, -power) return result;
    }
    if __float_wide_compare(*r, *s) >= 0 {
        while true {
            next := s;
            if !__float_wide_multiply(*next, 10) return result;
            if __float_wide_compare(*r, *next) < 0 break;
            s = next;
            result.exponent += 1;
        }
    } else {
        while __float_wide_compare(*r, *s) < 0 {
            if !__float_wide_multiply(*r, 10) || !__float_wide_multiply(*below, 10) || !__float_wide_multiply(*above, 10) return result;
            result.exponent -= 1;
        }
    }
    shortest := requested == -1 && fixed_after_point < 0;
    if fixed_after_point >= 0 {
        // Like Jai's printer, fixed notation keeps at most 18 significant digits; the rest of the
        // whole part prints as zeros (5.97219e24 -> 5972189887017193070000000).
        requested = result.exponent + 1 + fixed_after_point;
        if requested > 18 requested = 18;
    }
    if !shortest && requested <= 0 {
        // At the cut before the leading digit, zero is the even candidate.
        round_up := false;
        if requested == 0 {
            twice := r;
            threshold := s;
            if !__float_wide_multiply(*twice, 2) || !__float_wide_multiply(*threshold, 10) return result;
            round_up = __float_wide_compare(*twice, *threshold) > 0;
        }
        result.count = 1;
        if round_up {
            result.digits[0] = 1;
            result.exponent = -fixed_after_point;
        } else result.exponent = 0;
        result.valid = true;
        return result;
    }
    if requested > 344 return result;
    boundary_inclusive := (mantissa & 1) == 0;
    while result.count < 344 {
        digit: u8 = 0;
        while __float_wide_compare(*r, *s) >= 0 {
            __float_wide_subtract(*r, *s);
            digit += 1;
        }
        result.digits[result.count] = digit;
        result.count += 1;
        stop := false;
        round_up := false;
        if shortest {
            low_comparison := __float_wide_compare(*r, *below);
            high := r;
            if !__float_wide_add(*high, *above) return result;
            high_comparison := __float_wide_compare(*high, *s);
            low := low_comparison < 0 || (low_comparison == 0 && boundary_inclusive);
            high_allowed := high_comparison > 0 || (high_comparison == 0 && boundary_inclusive);
            stop = low || high_allowed;
            if high_allowed && !low round_up = true;
            else if high_allowed && low {
                twice := r;
                if !__float_wide_multiply(*twice, 2) return result;
                comparison := __float_wide_compare(*twice, *s);
                round_up = comparison > 0 || (comparison == 0 && (digit & 1) != 0);
            }
        } else if result.count == requested {
            stop = true;
            twice := r;
            if !__float_wide_multiply(*twice, 2) return result;
            comparison := __float_wide_compare(*twice, *s);
            round_up = comparison > 0 || (comparison == 0 && (digit & 1) != 0);
        }
        if stop {
            if round_up __float_round_digits(*result);
            if shortest while result.count > 1 && result.digits[result.count - 1] == 0 result.count -= 1;
            result.valid = true;
            return result;
        }
        if !__float_wide_multiply(*r, 10) return result;
        if shortest {
            if !__float_wide_multiply(*below, 10) || !__float_wide_multiply(*above, 10) return result;
            // Every finite binary64 has a round-trip string with <=17 digits.
            if result.count == 17 return result;
        }
    }
    return result;
}

__float_digit_at :: (digits: *__Float_Digits, index: s64) -> u8 {
    if index < 0 || index >= digits.count return 0;
    return digits.digits[index];
}

// Exact IEEE-754 binary64 rounding is shared by the three maintained modes.
// SHORTEST is general notation with a significant-digit precision, matching
// maintained consumers; the explicit roundtrip helper selects the exact
// rounding interval rather than changing that mode's default precision.
__append_float_digits :: (builder: *String_Builder, digits: *__Float_Digits, scientific: bool, fractional: s64, format: FormatFloat) {
    whole: s64 = 1;
    if !scientific && digits.exponent >= 0 whole = digits.exponent + 1;
    for i: 0..whole - 1 {
        digit: u8 = 0;
        if scientific digit = __float_digit_at(digits, i);
        else if digits.exponent >= 0 digit = __float_digit_at(digits, i);
        append(builder, digit + #char "0");
        if !scientific && format.thousand_separators && i < whole - 1 && (whole - i - 1) % 3 == 0 append(builder, format.thousand_separator_character);
    }
    visible := fractional;
    if format.zero_removal != .NO {
        minimum: s64 = 0;
        if format.zero_removal == .ONE_ZERO_AFTER_DECIMAL && fractional > 0 minimum = 1;
        while visible > minimum {
            index := digits.exponent + visible;
            if scientific index = visible;
            if __float_digit_at(digits, index) != 0 break;
            visible -= 1;
        }
    }
    if visible > 0 {
        append(builder, format.decimal_separator_character);
        for i: 1..visible {
            index := digits.exponent + i;
            if scientific index = i;
            append(builder, __float_digit_at(digits, index) + #char "0");
        }
    }
    if scientific {
        append(builder, format.exponent_character);
        exponent := digits.exponent;
        if exponent < 0 {
            append(builder, cast(u8) #char "-");
            exponent = -exponent;
        } else append(builder, cast(u8) #char "+");
        print_u64_base_n(builder, cast(u64) exponent, FormatInt.{ minimum_digits = 2 });
    }
}

__append_float_value :: (builder: *String_Builder, value: float64, format: FormatFloat) {
    bits := cast,force(u64) value;
    magnitude := bits & 0x7fff_ffff_ffff_ffff;
    exponent_bits := magnitude >> 52;
    fraction_bits := magnitude & 0x000f_ffff_ffff_ffff;
    if exponent_bits == 0x7ff && fraction_bits != 0 {
        append(builder, "nan");
        return;
    }
    if (bits & 0x8000_0000_0000_0000) != 0 append(builder, cast(u8) #char "-");
    else if format.positive_number_prefix == .PLUS append(builder, cast(u8) #char "+");
    else if format.positive_number_prefix == .SPACE append(builder, cast(u8) #char " ");
    if exponent_bits == 0x7ff {
        append(builder, "inf");
        return;
    }
    precision := format.trailing_width;
    if precision < 0 precision = 6;
    if precision > 18 {
        append(builder, "<unsupported float precision>");
        builder.failed = true;
        return;
    }
    scientific := format.mode == .SCIENTIFIC;
    general := format.mode == .SHORTEST;
    requested := precision + 1;
    fixed: s64 = -1;
    if general {
        requested = precision;
        if requested == 0 requested = 1;
    } else if !scientific fixed = precision;
    digits := __float_decimal_digits(magnitude, requested, fixed);
    if !digits.valid {
        append(builder, "<float conversion capacity exceeded>");
        builder.failed = true;
        return;
    }
    fractional := precision;
    if general {
        scientific = digits.exponent < -4 || digits.exponent >= requested;
        fractional = requested - digits.exponent - 1;
        if scientific fractional = requested - 1;
        if fractional < 0 fractional = 0;
    }
    __append_float_digits(builder, *digits, scientific, fractional, format);
}

__append_float_roundtrip :: (builder: *String_Builder, value: float64) {
    bits := cast,force(u64) value;
    magnitude := bits & 0x7fff_ffff_ffff_ffff;
    exponent_bits := magnitude >> 52;
    fraction_bits := magnitude & 0x000f_ffff_ffff_ffff;
    if exponent_bits == 0x7ff && fraction_bits != 0 {
        append(builder, "nan");
        return;
    }
    if (bits & 0x8000_0000_0000_0000) != 0 append(builder, cast(u8) #char "-");
    if exponent_bits == 0x7ff {
        append(builder, "inf");
        return;
    }
    digits := __float_decimal_digits(magnitude, -1);
    if !digits.valid {
        append(builder, "<float conversion capacity exceeded>");
        builder.failed = true;
        return;
    }
    // Pick the shorter spelling using this module's signed, >=2-digit exponent
    // convention. Both spellings use the same least significant-digit sequence.
    fixed_length := digits.exponent + 1;
    if digits.exponent < 0 fixed_length = 1 - digits.exponent + digits.count;
    else if digits.count > fixed_length fixed_length = digits.count + 1;
    exponent := digits.exponent;
    if exponent < 0 exponent = -exponent;
    exponent_digits: s64 = 2;
    if exponent >= 100 exponent_digits = 3;
    scientific_length := digits.count + 2 + exponent_digits;
    if digits.count > 1 scientific_length += 1;
    scientific := scientific_length < fixed_length;
    fractional := digits.count - digits.exponent - 1;
    if scientific fractional = digits.count - 1;
    if fractional < 0 fractional = 0;
    __append_float_digits(builder, *digits, scientific, fractional, .{});
}

// A 16-byte float is jaic's Long_Double (module Jaic_Extensions): x87 extended precision on
// x86-64, IEEE binary128 elsewhere. It prints through float64, so precision beyond float64's
// is not shown.
__long_double_to_float64 :: (p: *void) -> float64 {
    low := (cast(*u64) p).*;
    high := (cast(*u64) p + 1).*;
    // Both formats come down to a 64-bit significand with an explicit leading bit and a
    // 15-bit biased exponent; for binary128 the dropped low bits stick to the last bit, so
    // the single rounding below (u64 to float64) is still correct.
    #if CPU == .X64 {
        negative := (high >> 15) & 1 == 1;
        exponent := cast(s64) (high & 0x7fff);
        significand := low;
        is_nan := exponent == 0x7fff && (significand << 1) != 0;
    } else {
        negative := high >> 63 == 1;
        exponent := cast(s64) ((high >> 48) & 0x7fff);
        stored := (high & 0xffff_ffff_ffff) | low;
        significand := ((high & 0xffff_ffff_ffff) << 15) | (low >> 49);
        if low & (((cast(u64) 1) << 49) - 1) significand |= 1;
        if exponent != 0 significand |= (cast(u64) 1) << 63;
        is_nan := exponent == 0x7fff && stored != 0;
    }
    result: float64;
    if is_nan {
        nan_bits: u64 = 0x7ff8_0000_0000_0000;
        result = (cast(*float64) *nan_bits).*;
    } else if exponent == 0x7fff {
        inf_bits: u64 = 0x7ff0_0000_0000_0000;
        result = (cast(*float64) *inf_bits).*;
    } else {
        result = cast(float64) significand;
        // value = significand * 2^(exponent - 16383 - 63); denormals use exponent 1.
        scale := ifx exponent == 0 then -16445 else exponent - 16446;
        while scale != 0 && result != 0 {
            step := scale;
            if step > 1000 step = 1000;
            if step < -1000 step = -1000;
            factor_bits := (cast(u64) (step + 1023)) << 52;
            result *= (cast(*float64) *factor_bits).*;
            scale -= step;
        }
    }
    if negative result = -result;
    return result;
}

print_float :: (builder: *String_Builder, format: FormatFloat) {
    item := format.value;
    if !item.type || !item.value_pointer {
        append(builder, "<null formatter>");
        builder.failed = true;
        return;
    }
    // A variant of a float (`#type,distinct float64`, or an `isa` of one) prints as the float.
    info := item.type;
    while info.type == .VARIANT info = (cast(*Type_Info_Variant) info).variant_of;
    if info.type != .FLOAT {
        append(builder, "<non-float>");
        builder.failed = true;
        return;
    }
    value: float64 = 0;
    if info.runtime_size == 4 value = cast(float64) (cast(*float32) item.value_pointer).*;
    else if info.runtime_size == 8 value = (cast(*float64) item.value_pointer).*;
    else if info.runtime_size == 16 value = __long_double_to_float64(item.value_pointer);
    else {
        append(builder, "<unsupported float width>");
        builder.failed = true;
        return;
    }
    scratch: String_Builder;
    init_string_builder(*scratch);
    __append_float_value(*scratch, value, format);
    failed := scratch.failed;
    rendered := builder_to_string(*scratch);
    // Width is a minimum total byte count, with spaces before the number.
    spaces: s64 = 0;
    if format.width > rendered.count spaces = format.width - rendered.count;
    for i: 0..spaces - 1 append(builder, cast(u8) #char " ");
    append(builder, rendered);
    free(rendered);
    free_buffers(*scratch);
    if failed builder.failed = true;
}

__append_quoted :: (builder: *String_Builder, text: string) {
    append(builder, cast(u8) #char "\"");
    for byte: text {
        if byte == #char "\"" append(builder, "\\\"");
        else if byte == #char "\\" append(builder, "\\\\");
        else if byte == 10 append(builder, "\\n");
        else if byte == 13 append(builder, "\\r");
        else if byte == 9 append(builder, "\\t");
        else if byte < 32 {
            append(builder, "\\x");
            print_u64_base_n(builder, byte, FormatInt.{ base = 16, minimum_digits = 2 });
        } else append(builder, byte);
    }
    append(builder, cast(u8) #char "\"");
}

__append_type :: (builder: *String_Builder, info: *Type_Info, depth: s64) {
    if !info {
        append(builder, "(null)");
        return;
    }
    if depth >= 16 {
        append(builder, "...");
        return;
    }
    if info.type == .STRUCT {
        __append_struct_type(builder, cast(*Type_Info_Struct) info);
        return;
    }
    if info.type == .ENUM {
        append(builder, (cast(*Type_Info_Enum) info).name);
        return;
    }
    if info.type == .VARIANT {
        append(builder, (cast(*Type_Info_Variant) info).name);
        return;
    }
    if info.type == .POINTER {
        append(builder, "*");
        __append_type(builder, (cast(*Type_Info_Pointer) info).pointer_to, depth + 1);
        return;
    }
    if info.type == .ARRAY {
        array := cast(*Type_Info_Array) info;
        if array.array_type == .VIEW append(builder, "[] ");
        else if array.array_type == .RESIZABLE append(builder, "[..] ");
        else {
            append(builder, "[");
            print_u64_base_n(builder, cast(u64) array.array_count, .{});
            append(builder, "] ");
        }
        __append_type(builder, array.element_type, depth + 1);
        return;
    }
    if info.type == .INTEGER {
        if (cast(*Type_Info_Integer) info).signed append(builder, "s");
        else append(builder, "u");
        print_u64_base_n(builder, cast(u64) (info.runtime_size * 8), .{});
        return;
    }
    if info.type == .FLOAT && info.runtime_size == 16 {
        append(builder, "Long_Double");
        return;
    }
    if info.type == .FLOAT {
        append(builder, "float");
        print_u64_base_n(builder, cast(u64) (info.runtime_size * 8), .{});
        return;
    }
    if info.type == .PROCEDURE {
        procedure := cast(*Type_Info_Procedure) info;
        append(builder, "procedure (");
        for procedure.argument_types {
            if it_index > 0 append(builder, ", ");
            __append_type(builder, it, depth + 1);
        }
        append(builder, ")");
        if procedure.return_types.count == 1 {
            append(builder, " -> ");
            __append_type(builder, procedure.return_types[0], depth + 1);
        } else if procedure.return_types.count > 1 {
            append(builder, " -> (");
            for procedure.return_types {
                if it_index > 0 append(builder, ", ");
                __append_type(builder, it, depth + 1);
            }
            append(builder, ")");
        }
        if (procedure.procedure_flags & .IS_C_CALL) != 0 append(builder, " #c_call");
        if (procedure.procedure_flags & .HAS_NO_CONTEXT) != 0 append(builder, " #no_context");
        if (procedure.procedure_flags & .IS_COMPILE_TIME_ONLY) != 0 append(builder, " #compile_time");
        return;
    }
    if info.type == .BOOL append(builder, "bool");
    else if info.type == .STRING append(builder, "string");
    else if info.type == .VOID append(builder, "void");
    else if info.type == .TYPE append(builder, "Type");
    else if info.type == .ANY append(builder, "Any");
    else {
        append(builder, "<unsupported type>");
        builder.failed = true;
    }
}

__append_struct_type :: (builder: *String_Builder, info: *Type_Info_Struct) {
    if info.name append(builder, info.name);
    else if info.textual_flags & .UNION append(builder, "(anonymous union)");
    else append(builder, "(anonymous struct)");
    if !info.polymorph_source_struct return;
    separator := "(";
    for *param: info.specified_parameters {
        append(builder, separator);
        separator = ", ";
        append(builder, param.name);
        append(builder, #char "=");
        // A negative offset means the argument has no stored value to show.
        storage_offset := param.offset_into_constant_storage;
        if storage_offset < 0 continue;
        argument: Any = ---;
        argument.type = param.type;
        argument.value_pointer = info.constant_storage.data + storage_offset;
        print_item_to_builder(builder, argument);
    }
    // A polymorph with no specified parameters still prints "()".
    if separator == "(" append(builder, "(");
    append(builder, ")");
}

print_type_to_builder :: (builder: *String_Builder, info: *Type_Info) {
    __append_type(builder, info, 0);
}

// Members that print: not constants or imports, not zero-sized, and not overlapping an
// earlier member (`#place` views and the later members of a union are skipped).
__printable_member :: (member: *Type_Info_Struct_Member, end_of_last: *s64) -> bool {
    if (member.flags & .CONSTANT) || (member.flags & .IMPORTED) return false;
    if member.offset_in_bytes < end_of_last.* return false;
    if !member.type || member.type.runtime_size == 0 return false;
    end_of_last.* = member.offset_in_bytes + member.type.runtime_size;
    return true;
}

__append_struct :: (builder: *String_Builder, info: *Type_Info_Struct, pointer: *void, format: FormatStruct, depth: s64) {
    // The contents of a union are unknowable without a tag, so only its kind is shown.
    if info.textual_flags & .UNION {
        append(builder, "(union)");
        return;
    }
    if format.draw_type_name append(builder, info.name);
    append(builder, format.begin_string);
    count: s64 = 0;
    end_of_last: s64 = -1;
    for *member: info.members if __printable_member(member, *end_of_last) count += 1;
    long_form := format.use_long_form_if_more_than_this_many_members < 0 || count > format.use_long_form_if_more_than_this_many_members;
    newlines := long_form && format.use_newlines_if_long_form;
    if newlines append(builder, "\n");
    printed := 0;
    end_of_last = -1;
    for *member: info.members {
        if !__printable_member(member, *end_of_last) continue;
        if newlines for i: 0..(depth + 1) * format.indentation_width - 1 append(builder, cast(u8) #char " ");
        if long_form {
            append(builder, member.name);
            append(builder, format.separator_between_name_and_value);
        }
        uninitialized := false;
        for note: member.notes if note == "---" uninitialized = true;
        item: Any = .{ type = member.type, value_pointer = cast(*u8) pointer + member.offset_in_bytes };
        __append_item(builder, item, true, uninitialized, depth + 1);
        printed += 1;
        if long_form append(builder, format.long_form_separator_between_fields);
        else if printed < count append(builder, format.short_form_separator_between_fields);
        if newlines append(builder, "\n");
    }
    if newlines for i: 0..depth * format.indentation_width - 1 append(builder, cast(u8) #char " ");
    append(builder, format.end_string);
}

append_struct_info :: (builder: *String_Builder, info: *Type_Info_Struct, base_pointer: *void, format: *FormatStruct = null) {
    settings: FormatStruct;
    if format settings = format.*;
    __append_struct(builder, info, base_pointer, settings, 0);
}

print_array :: (builder: *String_Builder, any: Any, info_array: *Type_Info_Array, format: FormatArray, may_be_uninitialized := false) {
    __append_array(builder, any, info_array, format, may_be_uninitialized, 0);
}

__append_array :: (builder: *String_Builder, item: Any, info: *Type_Info_Array, format: FormatArray, may_be_uninitialized: bool, depth: s64) {
    count := info.array_count;
    data := item.value_pointer;
    if info.array_type != .FIXED {
        view := cast(*Resizable_Array) item.value_pointer;
        count = view.count;
        data = view.data;
    }
    if count < 0 || (count > 0 && !data) {
        append(builder, "<invalid array>");
        builder.failed = true;
        return;
    }
    append(builder, format.begin_string);
    limit := count;
    if format.stop_printing_after_this_many_elements >= 0 limit = min(count, cast(s64) format.stop_printing_after_this_many_elements);
    for i: 0..limit - 1 {
        if i > 0 append(builder, format.separator);
        element: Any = .{ type = info.element_type, value_pointer = cast(*u8) data + i * info.element_type.runtime_size };
        __append_item(builder, element, true, may_be_uninitialized, depth + 1);
    }
    if limit < count {
        if limit > 0 append(builder, format.separator);
        append(builder, format.printing_stopped_early_string);
    } else if limit > 0 && format.draw_separator_after_last_element append(builder, format.separator);
    append(builder, format.end_string);
}

__append_item :: (builder: *String_Builder, item: Any, nested: bool, uninitialized: bool, depth: s64) {
    if depth >= 16 {
        append(builder, "...");
        return;
    }
    if uninitialized {
        append(builder, "<uninitialized>");
        return;
    }
    if item.type && item.type.type == .VOID {
        append(builder, "void");
        return;
    }
    if !item.type || !item.value_pointer {
        append(builder, "null");
        return;
    }
    if item.type == type_info(FormatInt) {
        print_integer(builder, (cast(*FormatInt) item.value_pointer).*);
        return;
    }
    if item.type == type_info(FormatFloat) {
        print_float(builder, (cast(*FormatFloat) item.value_pointer).*);
        return;
    }
    if item.type == type_info(FormatStruct) {
        format := (cast(*FormatStruct) item.value_pointer).*;
        value := format.value;
        if value.type && value.type.type == .POINTER && value.value_pointer {
            pointee := (cast(*Type_Info_Pointer) value.type).pointer_to;
            if pointee && pointee.type == .STRUCT {
                value.value_pointer = (cast(**void) value.value_pointer).*;
                value.type = pointee;
            }
        }
        if value.type && value.type.type == .STRUCT && value.value_pointer __append_struct(builder, cast(*Type_Info_Struct) value.type, value.value_pointer, format, depth);
        else {
            append(builder, "<non-struct formatter>");
            builder.failed = true;
        }
        return;
    }
    if item.type == type_info(FormatArray) {
        format := (cast(*FormatArray) item.value_pointer).*;
        if format.value.type && format.value.type.type == .ARRAY __append_array(builder, format.value, cast(*Type_Info_Array) format.value.type, format, false, depth);
        else {
            append(builder, "<non-array formatter>");
            builder.failed = true;
        }
        return;
    }
    if item.type == type_info(Formatter) {
        __append_item(builder, (cast(*Formatter) item.value_pointer).value, nested, false, depth + 1);
        return;
    }
    tag := item.type.type;
    if tag == .STRING {
        text := (cast(*string) item.value_pointer).*;
        if nested __append_quoted(builder, text);
        else append(builder, text);
    } else if tag == .BOOL {
        if (cast(*bool) item.value_pointer).* append(builder, "true");
        else append(builder, "false");
    } else if tag == .INTEGER {
        settings := __default_format_int();
        settings.value = item;
        print_integer(builder, settings);
    } else if tag == .FLOAT {
        settings := __default_format_float();
        settings.value = item;
        print_float(builder, settings);
    } else if tag == .POINTER || tag == .PROCEDURE {
        value := (cast(**void) item.value_pointer).*;
        if tag == .PROCEDURE && value append(builder, "procedure 0x");
        if !value append(builder, "null");
        else print_u64_base_n(builder, cast(u64) value, __default_format_pointer());
    } else if tag == .STRUCT {
        // A user-installed struct printer (for example Math's math_struct_printer) gets the first chance.
        printer := context.print_style.struct_printer;
        if printer && printer(builder, item, context.print_style.struct_printer_data) return;
        // A using/#as Formatter field is an explicit formatting view. Locate
        // its real byte offset rather than assuming it is the first field.
        info := cast(*Type_Info_Struct) item.type;
        formatter_member := isFormatter(info);
        if formatter_member {
            view := cast(*Formatter) (cast(*u8) item.value_pointer + formatter_member.offset_in_bytes);
            __append_item(builder, view.value, nested, false, depth + 1);
            return;
        }
        settings := __default_format_struct();
        __append_struct(builder, info, item.value_pointer, settings, depth);
    } else if tag == .ARRAY __append_array(builder, item, cast(*Type_Info_Array) item.type, .{}, false, depth);
    else if tag == .ENUM {
        info := cast(*Type_Info_Enum) item.type;
        value := get_u64_from_void_pointer(item.value_pointer, info.runtime_size);
        mask: u64 = 0xffff_ffff_ffff_ffff;
        if info.runtime_size < 8 mask = ((cast(u64) 1) << cast(u8) (8 * info.runtime_size)) - 1;
        for i: 0..info.names.count - 1 {
            if ((cast,no_check(u64) info.values[i]) & mask) == value {
                append(builder, info.names[i]);
                return;
            }
        }
        if (info.enum_type_flags & .FLAGS) != 0 {
            remainder := value;
            first := true;
            for i: 0..info.names.count - 1 {
                flag := (cast,no_check(u64) info.values[i]) & mask;
                if flag == 0 || (remainder & flag) != flag continue;
                if !first append(builder, " | ");
                append(builder, info.names[i]);
                remainder &= ~flag;
                first = false;
            }
            if remainder != 0 {
                if !first append(builder, " | ");
                append(builder, "0x");
                print_u64_base_n(builder, remainder, FormatInt.{ base = 16 });
            } else if first append(builder, "0");
            return;
        }
        print_integer(builder, FormatInt.{ value = item });
    } else if tag == .VARIANT {
        base := item;
        base.type = (cast(*Type_Info_Variant) item.type).variant_of;
        __append_item(builder, base, nested, uninitialized, depth + 1);
    } else if tag == .ANY __append_item(builder, (cast(*Any) item.value_pointer).*, nested, uninitialized, depth + 1);
    else if tag == .TYPE __append_type(builder, (cast(**Type_Info) item.value_pointer).*, depth);
    else {
        append(builder, "<unsupported value>");
        builder.failed = true;
    }
}

print_item_to_builder :: (builder: *String_Builder, item: Any, inside_struct_or_array := true, may_be_uninitialized := false) {
    __append_item(builder, item, inside_struct_or_array, may_be_uninitialized, 0);
}

my_is_digit :: (c: s64) -> bool {
    return c >= #char "0" && c <= #char "9";
}

parse_number :: (s: string, cursor: s64) -> (end_cursor: s64, sum: s64) {
    assert(cursor >= 0 && cursor <= s.count);
    position := cursor;
    value: s64 = 0;
    while position < s.count && is_digit(s[position]) {
        digit := s[position] - #char "0";
        if value > (0x7fff_ffff_ffff_ffff - digit) / 10 break;
        value = value * 10 + digit;
        position += 1;
    }
    return position, value;
}

isFormatter :: (info: *Type_Info_Struct) -> *Type_Info_Struct_Member {
    if !info return null;
    for *member: info.members {
        if (member.flags & .CONSTANT) != 0 || member.offset_in_bytes < 0 continue;
        if member.type == type_info(Formatter) && (member.flags & .AS) != 0 return member;
    }
    return null;
}

// A lone '%' (or '%0') consumes the next argument; '%N' selects argument N
// (one-based) and a following lone '%' continues after it; '%00' prints nothing. '%%' is two consecutive arguments
// (newer Jai). A literal percent is written '\%' in source, which the lexer
// turns into byte 31. Out-of-range selectors fail explicitly.
__format_to_builder :: (builder: *String_Builder, format: string, args: [] Any) -> bool {
    position: s64 = 0;
    implicit: s64 = 0;
    while position < format.count {
        byte := format[position];
        position += 1;
        if byte == 31 {
            append(builder, cast(u8) #char "%");
            continue;
        }
        if byte != #char "%" {
            append(builder, byte);
            continue;
        }
        index := implicit;
        if position + 1 < format.count && format[position] == #char "0" && format[position + 1] == #char "0" {
            position += 2;
            continue;
        }
        if position < format.count && is_digit(format[position]) && format[position] != #char "0" {
            index = 0;
            while position < format.count && is_digit(format[position]) {
                digit := format[position] - #char "0";
                if index > (0x7fff_ffff_ffff_ffff - digit) / 10 {
                    builder.failed = true;
                    return false;
                }
                index = index * 10 + digit;
                position += 1;
            }
            index -= 1;
            implicit = index + 1; // A following lone '%' continues after N.
        } else {
            if position < format.count && format[position] == #char "0" position += 1;
            implicit += 1;
        }
        if index < 0 || index >= args.count {
            append(builder, "<missing format argument>");
            builder.failed = true;
            return false;
        }
        __append_item(builder, args[index], false, false, 0);
        implicit = index + 1;
        if builder.failed return false;
    }
    return !builder.failed;
}

print_to_builder :: (builder: *String_Builder, format_string: string, args: ..Any) -> bool {
    return __format_to_builder(builder, format_string, args);
}

print :: print_to_builder;

print :: (format_string: string, args: ..Any, to_standard_error := false) -> bytes_printed: s64 {
    builder: String_Builder;
    init_string_builder(*builder);
    success := __format_to_builder(*builder, format_string, args);
    count := write_builder(*builder, to_standard_error = to_standard_error);
    free_buffers(*builder);
    if !success return -1;
    return count;
}

sprint :: (format_string: string, args: ..Any) -> string #must {
    builder: String_Builder;
    init_string_builder(*builder);
    __format_to_builder(*builder, format_string, args);
    result := builder_to_string(*builder);
    free_buffers(*builder);
    return result;
}

tprint :: (format_string: string, args: ..Any) -> string #must {
    builder: String_Builder;
    init_string_builder(*builder);
    __format_to_builder(*builder, format_string, args);
    owned := builder_to_string(*builder);
    result := copy_temporary_string(owned);
    free(owned);
    free_buffers(*builder);
    return result;
}

print_sequence_to_builder :: (builder: *String_Builder, args: ..Any) {
    for item: args __append_item(builder, item, false, false, 0);
}

print_character :: (_c: u8) {
    byte := _c;
    write_string(to_string(*byte, 1));
}

print_bytes :: (a: *void, length: int, format_string := "% ") {
    bytes := cast(*u8) a;
    for i: 0..length - 1 print(format_string, bytes[i]);
}

// Explicit independent extension: least digits that round back to binary64.
// It does not use string_to_float64, whose conversion remains approximate.
formatFloatRoundtrip :: (value: float64, width: s64 = 0) -> string {
    builder: String_Builder;
    init_string_builder(*builder);
    __append_float_roundtrip(*builder, value);
    owned := builder_to_string(*builder);
    free_buffers(*builder);
    padding: s64 = 0;
    if width > owned.count padding = width - owned.count;
    if padding == 0 {
        result := copy_temporary_string(owned);
        free(owned);
        return result;
    }
    init_string_builder(*builder);
    for i: 0..padding - 1 append(*builder, cast(u8) #char " ");
    append(*builder, owned);
    free(owned);
    rendered := builder_to_string(*builder);
    result := copy_temporary_string(rendered);
    free(rendered);
    free_buffers(*builder);
    return result;
}

type_to_string :: (type: Type) -> string {
    return type_to_string(type_info(type));
}

type_to_string :: (info: *Type_Info) -> string {
    builder: String_Builder;
    init_string_builder(*builder);
    print_type_to_builder(*builder, info);
    owned := builder_to_string(*builder);
    result := copy_temporary_string(owned);
    free(owned);
    free_buffers(*builder);
    return result;
}

log :: (format_string: string, args: ..Any, loc := #caller_location, flags := Log_Flags.NONE, user_flags: u32 = 0, section: *Log_Section = null) -> s64 {
    builder: String_Builder;
    init_string_builder(*builder);
    success := __format_to_builder(*builder, format_string, args);
    text := builder_to_string(*builder);
    info := Log_Info.{ source_identifier = context.log_source_identifier, location = loc, common_flags = flags, user_flags = user_flags, section = section };
    if context.logger context.logger(text, context.logger_data, info);
    else write_string(text, (flags & .ERROR) != 0);
    count := text.count;
    free(text);
    free_buffers(*builder);
    if !success return -1;
    return count;
}

log_error :: (format_string: string, args: ..Any, loc := #caller_location, flags := Log_Flags.NONE, user_flags: u32 = 0, section: *Log_Section = null) {
    log(format_string, ..args, loc = loc, flags = flags | .ERROR, user_flags = user_flags, section = section);
}

log :: (section: *Log_Section, format_string: string, args: ..Any, loc := #caller_location, flags := Log_Flags.NONE, user_flags: u32 = 0) -> s64 {
    return log(format_string, ..args, loc = loc, flags = flags, user_flags = user_flags, section = section);
}

log_error :: (section: *Log_Section, format_string: string, args: ..Any, loc := #caller_location, flags := Log_Flags.NONE, user_flags: u32 = 0) {
    log(format_string, ..args, loc = loc, flags = flags | .ERROR, user_flags = user_flags, section = section);
}

log_warning :: (format: string, args: ..Any, loc := #caller_location, flags := Log_Flags.NONE, user_flags: u32 = 0, section: *Log_Section = null) {
    log(format, ..args, loc = loc, flags = flags | .WARNING, user_flags = user_flags, section = section);
}

// Indent the current line of a multi-line struct print to the active nesting depth.
append_indentation :: (builder: *String_Builder, format: *FormatStruct) {
    BLANKS :: "                                ";
    owed := context.print_style.indentation_depth * format.indentation_width;
    while owed > 0 {
        piece := ifx owed < BLANKS.count then owed else BLANKS.count;
        append(builder, BLANKS.data, piece);
        owed -= piece;
    }
}
