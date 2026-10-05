// Independently authored two-limb arithmetic. Operations wrap modulo 2^128;
// division reports zero divisors and the signed minimum / -1 overflow.
S128 :: struct { low: u64; high: s64; }
U128 :: struct { low: u64; high: u64; }
U128_ERROR :: U128.{0xffff_ffff_ffff_ffff, 0xffff_ffff_ffff_ffff};
S128_ERROR :: S128.{0xffff_ffff_ffff_ffff, -1};

to_s128 :: (a: $T) -> S128 {
    #if T == S128 { return a; }
    else #if T == U128 { return S128.{a.low, cast,no_check(s64) a.high}; }
    else {
        result := S128.{cast,no_check(u64) a, 0};
        if a < 0 result.high = -1;
        return result;
    }
}
to_u128 :: (a: $T) -> U128 {
    #if T == U128 { return a; }
    else #if T == S128 { return U128.{a.low, cast,no_check(u64) a.high}; }
    else {
        result := U128.{cast,no_check(u64) a, 0};
        if a < 0 result.high = 0xffff_ffff_ffff_ffff;
        return result;
    }
}

operator == :: inline (a: S128, b: S128) -> bool { return a.low == b.low && a.high == b.high; }
operator == :: inline (a: U128, b: U128) -> bool { return a.low == b.low && a.high == b.high; }
operator ! :: inline (a: S128) -> bool { return a.low == 0 && a.high == 0; }
operator ! :: inline (a: U128) -> bool { return a.low == 0 && a.high == 0; }
operator < :: (a: S128, b: S128) -> bool {
    if a.high != b.high return a.high < b.high;
    return a.low < b.low;
}
operator < :: (a: U128, b: U128) -> bool {
    if a.high != b.high return a.high < b.high;
    return a.low < b.low;
}
operator <= :: (a: S128, b: S128) -> bool { return !(b < a); }
operator > :: (a: S128, b: S128) -> bool { return b < a; }
operator >= :: (a: S128, b: S128) -> bool { return !(a < b); }
operator <= :: (a: U128, b: U128) -> bool { return !(b < a); }
operator > :: (a: U128, b: U128) -> bool { return b < a; }
operator >= :: (a: U128, b: U128) -> bool { return !(a < b); }

// Split addition into bounded 32-bit sums so wrapping is explicit even when
// the calling compiler enables arithmetic overflow checks by default.
__u128_add_limb :: (a: u64, b: u64, carry: u64 = 0) -> value: u64, carry_out: u64 {
    low := (a & 0xffff_ffff) + (b & 0xffff_ffff) + carry;
    high := (a >> 32) + (b >> 32) + (low >> 32);
    return ((high & 0xffff_ffff) << 32) | (low & 0xffff_ffff), high >> 32;
}
__u128_subtract_limb :: (a: u64, b: u64, borrow: u64 = 0) -> value: u64, borrow_out: u64 {
    value, carry := __u128_add_limb(a, ~b, 1 - borrow);
    return value, 1 - carry;
}
operator + :: (a: U128, b: U128) -> U128 {
    low, carry := __u128_add_limb(a.low, b.low);
    high, discarded := __u128_add_limb(a.high, b.high, carry);
    return U128.{low, high};
}
operator + :: (a: U128, b: u64) -> U128 { return a + U128.{b, 0}; }
operator + :: inline (a: S128, b: S128) -> S128 { return to_s128(to_u128(a) + to_u128(b)); }
operator - :: inline (a: U128, b: U128) -> U128 {
    low, borrow := __u128_subtract_limb(a.low, b.low);
    high, discarded := __u128_subtract_limb(a.high, b.high, borrow);
    return U128.{low, high};
}
operator - :: inline (a: S128, b: S128) -> S128 { return to_s128(to_u128(a) - to_u128(b)); }
operator - :: inline (a: S128) -> S128 { return to_s128(U128.{} - to_u128(a)); }

operator << :: inline (a: U128, $$x: u8) -> U128 {
    if x == 0 return a;
    if x >= 128 return U128.{};
    shift := x & 63;
    reverse_shift := (64 - shift) & 63;
    if x >= 64 return U128.{0, a.low << shift};
    return U128.{a.low << shift, (a.high << shift) | (a.low >> reverse_shift)};
}
operator << :: (a: S128, $$x: u8) -> S128 {
    bits: U128 = to_u128(a);
    shifted: U128 = bits << x;
    return to_s128(shifted);
}
operator >> :: (a: U128, $$x: u8) -> U128 {
    if x == 0 return a;
    if x >= 128 return U128.{};
    shift := x & 63;
    reverse_shift := (64 - shift) & 63;
    if x >= 64 return U128.{a.high >> shift, 0};
    return U128.{(a.low >> shift) | (a.high << reverse_shift), a.high >> shift};
}
operator >> :: (a: S128, $$x: u8) -> S128 {
    if x == 0 return a;
    sign: s64 = 0;
    if a.high < 0 sign = -1;
    if x >= 128 return S128.{cast,no_check(u64) sign, sign};
    shift := x & 63;
    reverse_shift := (64 - shift) & 63;
    if x >= 64 return S128.{cast,no_check(u64) (a.high >> shift), sign};
    return S128.{(a.low >> shift) | (cast,no_check(u64) a.high << reverse_shift), a.high >> shift};
}
logical_shift_right :: (a: S128, $$x: u8) -> S128 {
    bits: U128 = to_u128(a);
    shifted: U128 = bits >> x;
    return to_s128(shifted);
}

// Schoolbook multiplication on 32-bit halves: portable, and no 128-bit intermediate needed.
__u128_multiply_limbs :: (a: u64, b: u64) -> high: u64, low: u64 #no_aoc {
    MASK :: 0xffff_ffff;
    p00 := (a & MASK) * (b & MASK);
    p01 := (a & MASK) * (b >> 32);
    p10 := (a >> 32) * (b & MASK);
    p11 := (a >> 32) * (b >> 32);
    middle := (p00 >> 32) + (p01 & MASK) + (p10 & MASK);
    return p11 + (p01 >> 32) + (p10 >> 32) + (middle >> 32), (middle << 32) | (p00 & MASK);
}
operator * :: (_a: U128, _b: U128) -> U128 #no_aoc {
    high, low := __u128_multiply_limbs(_a.low, _b.low);
    return U128.{low, high + _a.low * _b.high + _a.high * _b.low};
}
operator * :: (_a: S128, _b: S128) -> S128 { return to_s128(to_u128(_a) * to_u128(_b)); }
operator * :: (a: S128, factor: s64) -> S128 #symmetric { return a * to_s128(factor); }
operator * :: (a: U128, b: s64) -> U128 { return a * to_u128(b); }
operator * :: (a: U128, b: u64) -> U128 { return a * U128.{b, 0}; }
multiply_64bits_with_overflow :: (a: u64, b: u64) -> (high: u64, low: u64) {
    high, low := __u128_multiply_limbs(a, b);
    return high, low;
}

// Restoring long division keeps a carry for the temporary 129th remainder bit.
unsigned_divide_with_remainder :: (u: U128, v: U128) -> quotient: U128, remainder: U128, overflow_or_divide_by_zero: bool {
    if !v return U128_ERROR, U128_ERROR, true;
    if !v.high {
        q, r := __u128_divide_by_u64(u, v.low);
        return q, r, false;
    }
    quotient: U128;
    remainder: U128;
    bit: s64 = 127;
    while bit >= 0 {
        carry := (remainder.high >> 63) != 0;
        remainder = remainder << 1;
        incoming: u64 = 0;
        if bit >= 64 incoming = (u.high >> cast(u8) (bit - 64)) & 1;
        else incoming = (u.low >> cast(u8) bit) & 1;
        remainder.low |= incoming;
        if carry || remainder >= v {
            remainder = remainder - v;
            if bit >= 64 quotient.high |= cast(u64) 1 << cast(u8) (bit - 64);
            else quotient.low |= cast(u64) 1 << cast(u8) bit;
        }
        bit -= 1;
    }
    return quotient, remainder, false;
}
// A 64-bit divisor (the common case: printing, scaling): one native division for the high limb,
// then 64 shift-subtract steps in plain u64 arithmetic instead of 128 steps of U128 operators.
__u128_divide_by_u64 :: (u: U128, d: u64) -> quotient: U128, remainder: U128 #no_aoc {
    if !u.high return U128.{low = u.low / d}, U128.{low = u.low % d};
    quotient: U128;
    quotient.high = u.high / d;
    r := u.high % d;
    bit: s64 = 63;
    while bit >= 0 {
        carry := r >> 63;
        r = (r << 1) | ((u.low >> cast(u8) bit) & 1);
        if carry || r >= d {
            r -= d;
            quotient.low |= cast(u64) 1 << cast(u8) bit;
        }
        bit -= 1;
    }
    return quotient, U128.{low = r};
}
signed_divide_with_remainder :: inline (dividend: S128, divisor: S128) -> quotient: S128, remainder: S128, overflow_or_divide_by_zero: bool {
    minimum :: S128.{0, cast,no_check(s64) 0x8000_0000_0000_0000};
    minus_one :: S128.{0xffff_ffff_ffff_ffff, -1};
    if !divisor || (dividend == minimum && divisor == minus_one) return S128_ERROR, S128_ERROR, true;
    dividend_magnitude := to_u128(dividend);
    divisor_magnitude := to_u128(divisor);
    if dividend.high < 0 dividend_magnitude = U128.{} - dividend_magnitude;
    if divisor.high < 0 divisor_magnitude = U128.{} - divisor_magnitude;
    q, r, error := unsigned_divide_with_remainder(dividend_magnitude, divisor_magnitude);
    if error return S128_ERROR, S128_ERROR, true;
    if (dividend.high < 0) != (divisor.high < 0) q = U128.{} - q;
    if dividend.high < 0 r = U128.{} - r;
    return to_s128(q), to_s128(r), false;
}
operator / :: (dividend: U128, divisor: U128) -> U128 {
    quotient, remainder, error := unsigned_divide_with_remainder(dividend, divisor);
    return quotient;
}
operator / :: (dividend: S128, divisor: S128) -> S128 {
    quotient, remainder, error := signed_divide_with_remainder(dividend, divisor);
    return quotient;
}
operator / :: inline (a: S128, factor: s64) -> S128 { return a / to_s128(factor); }
