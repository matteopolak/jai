// Numbers for Json: exact decimal-to-binary conversion and shortest round-trip printing of
// floats. Internal; the public pieces are in module.jai.
//
// Parsing is correctly rounded (nearest, ties to even) for float64 and float32, subnormals and
// overflow included. Most numbers take the fast path (a mantissa below 2^53 and a small power of
// ten, where one IEEE operation is exact); the rest go through big-integer division, which costs
// a few hundred operations for a 17-digit number and does not depend on any libc.

#scope_module

BIG_LIMBS :: 160; // 5120 bits: 800 digits times 10^323 fits with room for the shifts

Big :: struct {
    limbs: [BIG_LIMBS] u32;
    n: int; // limbs in use; the top one is never zero
}

big_set_small :: (b: *Big, value: u32) {
    b.n = 0;

    if value {
        b.limbs[0] = value;
        b.n = 1;
    }
}

big_mul_small :: (b: *Big, m: u32) {
    carry: u64;

    for 0..b.n - 1 {
        product := cast(u64) b.limbs[it] * cast(u64) m + carry;
        b.limbs[it] = cast,no_check(u32) product;
        carry = product >> 32;
    }

    if carry {
        b.limbs[b.n] = cast,no_check(u32) carry;
        b.n += 1;
    }
}

big_add_small :: (b: *Big, a: u32) {
    carry := cast(u64) a;
    i := 0;

    while carry && i < b.n {
        sum := cast(u64) b.limbs[i] + carry;
        b.limbs[i] = cast,no_check(u32) sum;
        carry = sum >> 32;
        i += 1;
    }

    if carry {
        b.limbs[b.n] = cast,no_check(u32) carry;
        b.n += 1;
    }
}

big_shift_left :: (b: *Big, bits: int) {
    if b.n == 0 || bits == 0 return;

    words := bits / 32;
    rest := cast(u32) (bits % 32);

    if rest {
        carry: u32;

        for 0..b.n - 1 {
            value := b.limbs[it];
            b.limbs[it] = (value << rest) | carry;
            carry = value >> (32 - rest);
        }

        if carry {
            b.limbs[b.n] = carry;
            b.n += 1;
        }
    }

    if words {
        i := b.n - 1;

        while i >= 0 {
            b.limbs[i + words] = b.limbs[i];
            i -= 1;
        }

        for 0..words - 1 b.limbs[it] = 0;

        b.n += words;
    }
}

big_shift_right_one :: (b: *Big) {
    carry: u32;
    i := b.n - 1;

    while i >= 0 {
        value := b.limbs[i];
        b.limbs[i] = (value >> 1) | carry;
        carry = value << 31;
        i -= 1;
    }

    if b.n && b.limbs[b.n - 1] == 0 b.n -= 1;
}

big_cmp :: (a: *Big, b: *Big) -> int {
    if a.n != b.n return ifx a.n < b.n then -1 else 1;

    i := a.n - 1;

    while i >= 0 {
        if a.limbs[i] != b.limbs[i] return ifx a.limbs[i] < b.limbs[i] then -1 else 1;

        i -= 1;
    }

    return 0;
}

// a -= b, where a >= b.
big_sub :: (a: *Big, b: *Big) {
    borrow: u64;

    for 0..a.n - 1 {
        subtrahend := borrow;
        if it < b.n subtrahend += b.limbs[it];

        value := cast(u64) a.limbs[it];

        if value >= subtrahend {
            a.limbs[it] = cast,no_check(u32) (value - subtrahend);
            borrow = 0;
        } else {
            a.limbs[it] = cast,no_check(u32) (value + 0x1_0000_0000 - subtrahend);
            borrow = 1;
        }
    }

    while a.n && a.limbs[a.n - 1] == 0 a.n -= 1;
}

big_bit_length :: (b: *Big) -> int {
    if b.n == 0 return 0;

    top := b.limbs[b.n - 1];
    bits := 0;

    while top {
        bits += 1;
        top >>= 1;
    }

    return (b.n - 1) * 32 + bits;
}

big_mul_pow10 :: (b: *Big, exponent: int) {
    left := exponent;

    while left >= 9 {
        big_mul_small(b, 1_000_000_000);
        left -= 9;
    }

    if left > 0 {
        power: u32 = 1;
        for 1..left power *= 10;
        big_mul_small(b, power);
    }
}

// The most significant digits kept from a number; later nonzero digits only set `truncated`.
MAX_DIGITS :: 800;

Decimal :: struct {
    negative: bool;
    digits: [MAX_DIGITS] u8; // 0..9, no leading or trailing zeros
    count: int;
    exponent: int; // the value is the digits as an integer times 10^exponent
    truncated: bool;
}

// Reads a number that already passed the JSON grammar check.
decimal_parse :: (token: string, d: *Decimal) {
    d.negative = false;
    d.count = 0;
    d.exponent = 0;
    d.truncated = false;

    i := 0;

    if i < token.count && token[i] == #char "-" {
        d.negative = true;
        i += 1;
    }

    in_fraction := false;

    while i < token.count {
        c := token[i];

        if c == #char "." {
            in_fraction = true;
        } else if c == #char "e" || c == #char "E" {
            break;
        } else {
            digit := c - #char "0";

            if d.count == 0 && digit == 0 {
                if in_fraction d.exponent -= 1;
            } else if d.count < MAX_DIGITS {
                d.digits[d.count] = digit;
                d.count += 1;
                if in_fraction d.exponent -= 1;
            } else {
                if digit != 0 d.truncated = true;
                if !in_fraction d.exponent += 1;
            }
        }

        i += 1;
    }

    if i < token.count {
        i += 1; // the e
        negative := false;

        if i < token.count && (token[i] == #char "+" || token[i] == #char "-") {
            negative = token[i] == #char "-";
            i += 1;
        }

        value := 0;

        while i < token.count {
            if value < 1_000_000 value = value * 10 + (token[i] - #char "0");

            i += 1;
        }

        d.exponent += ifx negative then -value else value;
    }

    while d.count > 0 && d.digits[d.count - 1] == 0 {
        d.count -= 1;
        d.exponent += 1;
    }
}

// The largest decimal magnitudes still worth converting, and the exact powers of ten per format.
POWERS_OF_TEN_64 :: float64.[1e0, 1e1, 1e2, 1e3, 1e4, 1e5, 1e6, 1e7, 1e8, 1e9, 1e10, 1e11, 1e12, 1e13, 1e14, 1e15, 1e16, 1e17, 1e18, 1e19, 1e20, 1e21, 1e22];
POWERS_OF_TEN_32 :: float32.[1e0, 1e1, 1e2, 1e3, 1e4, 1e5, 1e6, 1e7, 1e8, 1e9, 1e10];

// Rounds the decimal to `mantissa_bits` bits (53 or 24). Returns the mantissa and the power of
// two to scale it by, or overflow. A mantissa below 2^(mantissa_bits - 1) is a subnormal.
decimal_to_binary :: (d: *Decimal, mantissa_bits: int, min_exponent: int) -> u64, int, bool {
    if d.count == 0 return 0, 0, false;

    magnitude := d.count + d.exponent; // the value is in [10^(magnitude-1), 10^magnitude)
    limit := ifx mantissa_bits == 53 then 309 else 39;
    floor := ifx mantissa_bits == 53 then -324 else -46;

    if magnitude > limit return 0, 0, true;
    if magnitude <= floor return 0, 0, false;

    numerator: Big;
    denominator: Big;

    big_set_small(*numerator, 0);

    at := 0;

    while at < d.count {
        chunk: u32;
        power: u32 = 1;
        taken := 0;

        while at < d.count && taken < 9 {
            chunk = chunk * 10 + d.digits[at];
            power *= 10;
            at += 1;
            taken += 1;
        }

        if numerator.n == 0 big_set_small(*numerator, chunk);
        else {
            big_mul_small(*numerator, power);
            big_add_small(*numerator, chunk);
        }
    }

    exponent := d.exponent;

    if d.truncated {
        big_mul_small(*numerator, 10);
        big_add_small(*numerator, 1);
        exponent -= 1;
    }

    big_set_small(*denominator, 1);

    if exponent >= 0 big_mul_pow10(*numerator, exponent);
    else big_mul_pow10(*denominator, -exponent);

    // Scale so the quotient has mantissa_bits + 2 or + 3 bits.
    shift := mantissa_bits + 2 - (big_bit_length(*numerator) - big_bit_length(*denominator));

    if shift >= 0 big_shift_left(*numerator, shift);
    else big_shift_left(*denominator, -shift);

    top := mantissa_bits + 2;
    window := denominator;

    big_shift_left(*window, top);

    quotient: u64;
    i := top;

    while i >= 0 {
        if big_cmp(*numerator, *window) >= 0 {
            big_sub(*numerator, *window);
            quotient |= (cast(u64) 1) << cast(u64) i;
        }

        big_shift_right_one(*window);
        i -= 1;
    }

    sticky := numerator.n != 0;

    // quotient * 2^-shift, with the remainder below one unit of its last bit.
    length := 0;
    probe := quotient;

    while probe {
        length += 1;
        probe >>= 1;
    }

    leading := length - 1 - shift; // the exponent of the top bit

    precision := mantissa_bits;

    if leading < min_exponent precision = mantissa_bits - (min_exponent - leading);

    drop := length - precision;
    mantissa: u64;

    if drop > length {
        mantissa = 0;
    } else if drop == length {
        // Everything is below the lowest bit: only the half bit and the rest decide.
        half := (cast(u64) 1) << cast(u64) (drop - 1);
        mantissa = ifx quotient > half || (quotient == half && sticky) then 1 else 0;
    } else {
        mantissa = quotient >> cast(u64) drop;
        remainder := quotient & (((cast(u64) 1) << cast(u64) drop) - 1);
        half := (cast(u64) 1) << cast(u64) (drop - 1);

        if remainder > half || (remainder == half && (sticky || (mantissa & 1) == 1)) mantissa += 1;
    }

    return mantissa, drop - shift, false;
}

float64_from_decimal :: (d: *Decimal) -> float64, bool {
    value: float64;

    if d.count <= 19 && !d.truncated {
        small: u64;
        for 0..d.count - 1 small = small * 10 + d.digits[it];

        if small <= (cast(u64) 1) << 53 && d.exponent >= -22 && d.exponent <= 22 {
            value = cast(float64) small;
            value = ifx d.exponent >= 0 then value * POWERS_OF_TEN_64[d.exponent] else value / POWERS_OF_TEN_64[-d.exponent];

            return ifx d.negative then -value else value, false;
        }
    }

    mantissa, scale, overflow := decimal_to_binary(d, 53, -1022);

    if overflow return 0, true;

    bits: u64;

    if mantissa >= (cast(u64) 1) << 52 {
        exponent := scale + 52 + 1023;
        extra := mantissa;

        if extra == (cast(u64) 1) << 53 {
            extra = (cast(u64) 1) << 52;
            exponent += 1;
        }

        if exponent >= 2047 return 0, true;

        bits = (cast(u64) exponent << 52) | (extra - ((cast(u64) 1) << 52));
    } else {
        bits = mantissa; // subnormal or zero
    }

    value = cast,force(float64) bits;

    return ifx d.negative then -value else value, false;
}

float32_from_decimal :: (d: *Decimal) -> float32, bool {
    value: float32;

    if d.count <= 9 && !d.truncated {
        small: u64;
        for 0..d.count - 1 small = small * 10 + d.digits[it];

        if small <= (cast(u64) 1) << 24 && d.exponent >= -10 && d.exponent <= 10 {
            value = cast(float32) small;
            value = ifx d.exponent >= 0 then value * POWERS_OF_TEN_32[d.exponent] else value / POWERS_OF_TEN_32[-d.exponent];

            return ifx d.negative then -value else value, false;
        }
    }

    mantissa, scale, overflow := decimal_to_binary(d, 24, -126);

    if overflow return 0, true;

    bits: u32;

    if mantissa >= (cast(u64) 1) << 23 {
        exponent := scale + 23 + 127;
        extra := mantissa;

        if extra == (cast(u64) 1) << 24 {
            extra = (cast(u64) 1) << 23;
            exponent += 1;
        }

        if exponent >= 255 return 0, true;

        bits = cast,no_check(u32) ((cast(u64) exponent << 23) | (extra - ((cast(u64) 1) << 23)));
    } else {
        bits = cast,no_check(u32) mantissa;
    }

    value = cast,force(float32) bits;

    return ifx d.negative then -value else value, false;
}

// ---- printing ----

// Appends digits (no leading or trailing zeros, count >= 1) times 10^(point - count) in the
// shortest of JSON's spellings: plain for magnitudes 1e-6 up to 1e21, with a ".0" when it would
// otherwise read as an integer, and `1.5e-9` / `1e21` outside that.
append_decimal_float :: (builder: *String_Builder, negative: bool, digits: *u8, count: int, exponent10: int) {
    if negative append(builder, #char "-");

    // exponent10 is the exponent of the first digit: the value is d.ddd * 10^exponent10.
    if exponent10 < -6 || exponent10 >= 21 {
        append(builder, digits[0] + #char "0");

        if count > 1 {
            append(builder, #char ".");
            for 1..count - 1 append(builder, digits[it] + #char "0");
        }

        append(builder, #char "e");

        value := exponent10;

        if value < 0 {
            append(builder, #char "-");
            value = -value;
        }

        text: [4] u8;
        length := 0;

        if value == 0 {
            text[0] = #char "0";
            length = 1;
        } else {
            while value {
                text[length] = cast,no_check(u8) (value % 10) + #char "0";
                length += 1;
                value /= 10;
            }
        }

        i := length - 1;

        while i >= 0 {
            append(builder, text[i]);
            i -= 1;
        }

        return;
    }

    if exponent10 < 0 {
        append(builder, "0.");
        for 1..(-exponent10 - 1) append(builder, #char "0");
        for 0..count - 1 append(builder, digits[it] + #char "0");

        return;
    }

    whole := exponent10 + 1;

    for 0..whole - 1 append(builder, ifx it < count then digits[it] + #char "0" else cast(u8) #char "0");

    if count > whole {
        append(builder, #char ".");
        for whole..count - 1 append(builder, digits[it] + #char "0");
    } else {
        append(builder, ".0");
    }
}

// The fewest digits that read back as the same float64; NaN and infinities have no JSON
// spelling and are written as null.
append_float64 :: (builder: *String_Builder, value: float64) {
    bits := cast,force(u64) value;
    magnitude := bits & 0x7fff_ffff_ffff_ffff;

    if (magnitude >> 52) == 0x7ff {
        append(builder, "null");

        return;
    }

    negative := (bits >> 63) != 0;

    if magnitude == 0 {
        append(builder, ifx negative then "-0.0" else "0.0");

        return;
    }

    digits := __float_decimal_digits(magnitude, -1);

    append_decimal_float(builder, negative, digits.digits.data, digits.count, digits.exponent);
}

append_float32 :: (builder: *String_Builder, value: float32) {
    bits := cast,force(u32) value;
    magnitude := bits & 0x7fff_ffff;

    if (magnitude >> 23) == 0xff {
        append(builder, "null");

        return;
    }

    negative := (bits >> 31) != 0;

    if magnitude == 0 {
        append(builder, ifx negative then "-0.0" else "0.0");

        return;
    }

    wide := cast(float64) value;
    wide_bits := (cast,force(u64) wide) & 0x7fff_ffff_ffff_ffff;

    for precision: 1..9 {
        digits := __float_decimal_digits(wide_bits, precision);

        count := digits.count;

        while count > 1 && digits.digits[count - 1] == 0 count -= 1;

        candidate: Decimal;
        candidate.count = count;
        candidate.exponent = digits.exponent - count + 1;

        for 0..count - 1 candidate.digits[it] = digits.digits[it];

        back, overflow := float32_from_decimal(*candidate);

        if !overflow && (cast,force(u32) back) == (magnitude) {
            append_decimal_float(builder, negative, digits.digits.data, count, digits.exponent);

            return;
        }
    }

    digits := __float_decimal_digits(wide_bits, 9);

    append_decimal_float(builder, negative, digits.digits.data, digits.count, digits.exponent);
}
