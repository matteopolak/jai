// Independently authored scalar algorithms. No libc or reference implementations.
float64_bits :: (x: float64) -> u64 { return (cast(*u64) *x).*; }
float64_from_bits :: (bits: u64) -> float64 { return (cast(*float64) *bits).*; }
float32_bits :: (x: float32) -> u32 { return (cast(*u32) *x).*; }
float32_from_bits :: (bits: u32) -> float32 { return (cast(*float32) *bits).*; }

abs :: (x: int) -> int { if x < 0 return -x; return x; }
abs :: (x: s32) -> s32 { if x < 0 return -x; return x; }
abs :: (x: float64) -> float64 { return float64_from_bits(float64_bits(x) & 0x7fff_ffff_ffff_ffff); }
abs :: (x: float32) -> float32 { return float32_from_bits(float32_bits(x) & 0x7fff_ffff); }
is_nan_is_inf :: (x: float64) -> (isnan: bool, isinf: bool) {
    magnitude := float64_bits(x) & 0x7fff_ffff_ffff_ffff;
    return magnitude > 0x7ff0_0000_0000_0000, magnitude == 0x7ff0_0000_0000_0000;
}
is_nan_is_inf :: (x: float32) -> (isnan: bool, isinf: bool) {
    magnitude := float32_bits(x) & 0x7fff_ffff;
    return magnitude > 0x7f80_0000, magnitude == 0x7f80_0000;
}
isnan :: (x: float64) -> bool { return x != x; }
isnan :: (x: float32) -> bool { return x != x; }
isinf :: (x: float64) -> bool { return abs(x) == FLOAT64_INFINITY; }
isinf :: (x: float32) -> bool { return abs(x) == FLOAT32_INFINITY; }
is_finite :: (x: float64) -> bool { return abs(x) < FLOAT64_INFINITY; }
is_finite :: (x: float32) -> bool { return abs(x) < FLOAT32_INFINITY; }

floor :: (x: float64) -> float64 { value := x;
    bits := float64_bits(value);
    exponent := cast(s32) ((bits >> 52) & 2047) - 1023;
    if exponent >= 52 || value == 0 return value;
    negative := (bits >> 63) != 0;
    if exponent < 0 { if negative return -1; return 0; }
    mask := ((cast(u64) 1) << cast(u64) (52 - exponent)) - 1;
    if (bits & mask) == 0 return value;
    truncated := float64_from_bits(bits & ~mask);
    if negative return truncated - 1;
    return truncated;
}
ceil :: (x: float64) -> float64 { value := x; return -floor(-value); }
round :: (value: float64) -> float64 {
    if !is_finite(value) || value == 0 return value;
    if value < 0 return -floor(-value + 0.5);
    return floor(value + 0.5);
}
frac :: (x: $T) -> T { return x - floor(x); }
fmod_cycling :: (x: float64, y: float64) -> float64 {
    if y == 0 return FLOAT64_INFINITY;
    if !is_finite(x) || isnan(y) return FLOAT64_NAN;
    if isinf(y) return x;
    magnitude := abs(x);
    divisor := abs(y);
    if magnitude >= divisor {
        scaled := divisor;
        while scaled <= magnitude * 0.5 scaled *= 2;
        while scaled >= divisor {
            if magnitude >= scaled magnitude -= scaled;
            scaled *= 0.5;
        }
    }
    if x < 0 && magnitude != 0 magnitude = divisor - magnitude;
    if y < 0 { if magnitude != 0 return magnitude - divisor; }
    return magnitude;
}
frexp :: (x: float64) -> (result: float64, pow2: s32) {
    if x == 0 || !is_finite(x) return x, 0;
    bits := float64_bits(x);
    exponent := cast(s32) ((bits >> 52) & 2047);
    correction: s32 = 0;
    if exponent == 0 {
        bits = float64_bits(x * 18014398509481984.0);
        exponent = cast(s32) ((bits >> 52) & 2047);
        correction = -54;
    }
    mantissa := float64_from_bits((bits & 0x800f_ffff_ffff_ffff) | 0x3fe0_0000_0000_0000);
    return mantissa, exponent - 1022 + correction;
}
ldexp :: (x: float64, pw2: s32) -> float64 {
    if x == 0 || !is_finite(x) return x;
    result := x;
    exponent := pw2;
    while exponent > 512 {
        result *= 1.3407807929942597e154;
        exponent -= 512;
        if isinf(result) return result;
    }
    while exponent < -512 {
        result *= 7.458340731200207e-155;
        exponent += 512;
        if result == 0 return result;
    }
    if exponent >= 0 result *= float64_from_bits((cast(u64) (1023 + exponent)) << 52);
    else result *= float64_from_bits((cast(u64) (1023 + exponent)) << 52);
    return result;
}
sqrt :: (x: float64) -> float64 { value := x;
    if value == 0 || value == FLOAT64_INFINITY return value;
    if value < 0 || isnan(value) return FLOAT64_NAN;
    normalized, exponent := frexp(value);
    if (exponent & 1) != 0 { normalized *= 2; exponent -= 1; }
    estimate : float64 = 1.0;
    for 0..6 estimate = 0.5 * (estimate + normalized / estimate);
    return ldexp(estimate, exponent / 2);
}
log :: (x: float64) -> float64 { value := x;
    if isnan(value) || value < 0 return FLOAT64_NAN;
    if value == 0 return -FLOAT64_INFINITY;
    if isinf(value) return value;
    mantissa, exponent := frexp(value);
    mantissa *= 2;
    exponent -= 1;
    ratio := (mantissa - 1) / (mantissa + 1);
    term := ratio;
    total := ratio;
    ratio_squared := ratio * ratio;
    for i: 1..31 {
        term *= ratio_squared;
        total += term / cast(float64) (2 * i + 1);
    }
    return 2 * total + cast(float64) exponent * 0.69314718055994530942;
}
exp :: (x: float64) -> float64 { value := x;
    if isnan(value) return value;
    if value > 709.782712893384 return FLOAT64_INFINITY;
    if value < -745.133219101941 return 0;
    exponent := cast(s32) round(value * 1.44269504088896340736);
    residual := (value - cast(float64) exponent * 0.6931471805599453) - cast(float64) exponent * 2.3190468138462996e-17;
    term : float64 = 1.0;
    total : float64 = 1.0;
    for i: 1..20 { term *= residual / cast(float64) i; total += term; }
    return ldexp(total, exponent);
}
pow :: (x: float64, y: float64) -> float64 { base := x; exponent := y;
    if exponent == 0 || base == 1 return 1;
    if isnan(base) || isnan(exponent) return FLOAT64_NAN;
    if isinf(exponent) {
        magnitude := abs(base);
        if magnitude == 1 return 1;
        if (magnitude > 1) == (exponent > 0) return FLOAT64_INFINITY;
        return 0;
    }
    integral := floor(exponent) == exponent;
    odd := integral && fmod_cycling(abs(exponent), 2.0) == 1;
    if base == 0 {
        result : float64 = 0.0;
        if exponent < 0 result = FLOAT64_INFINITY;
        if odd && (float64_bits(base) >> 63) != 0 result = -result;
        return result;
    }
    if isinf(base) {
        result: float64 = 0;
        if exponent>0 result=FLOAT64_INFINITY;
        if base<0 && odd return -result;
        return result;
    }
    if base < 0 && !integral return FLOAT64_NAN;
    result := exp(exponent * log(abs(base)));
    if base < 0 && odd return -result;
    return result;
}
sin :: (x: float64) -> float64 { value := x;
    if !is_finite(value) return FLOAT64_NAN;
    if value == 0 return value;
    reduced := fmod_cycling(abs(value), TAU64);
    if reduced > PI64 reduced -= TAU64;
    if value < 0 reduced = -reduced;
    if reduced > PI64 * 0.5 reduced = PI64 - reduced;
    else if reduced < -PI64 * 0.5 reduced = -PI64 - reduced;
    term := reduced;
    total := reduced;
    square_x := reduced * reduced;
    for i: 1..12 {
        term *= -square_x / cast(float64) ((2 * i) * (2 * i + 1));
        total += term;
    }
    return total;
}
cos :: (x: float64) -> float64 { value := x;
    if !is_finite(value) return FLOAT64_NAN;
    reduced := fmod_cycling(abs(value), TAU64);
    if reduced > PI64 reduced -= TAU64;
    sign : float64 = 1.0;
    if abs(reduced) > PI64 * 0.5 {
        sign = -1;
        if reduced > 0 reduced = PI64 - reduced;
        else reduced = -PI64 - reduced;
    }
    term : float64 = 1.0;
    total : float64 = 1.0;
    square_x := reduced * reduced;
    for i: 1..12 {
        term *= -square_x / cast(float64) ((2 * i - 1) * (2 * i));
        total += term;
    }
    return sign * total;
}
tan :: (x: float64) -> float64 { value := x; return sin(value) / cos(value); }
cot :: (x: float64) -> float64 { value := x; return cos(value) / sin(value); }
atan :: (x: float64) -> float64 { value := x;
    if isnan(value) || value == 0 return value;
    positive := abs(value);
    reciprocal := positive > 1;
    if reciprocal positive = 1 / positive;
    reduced := positive / (1 + sqrt(1 + positive * positive));
    reduced /= 1 + sqrt(1 + reduced * reduced);
    term := reduced;
    total := reduced;
    for i: 1..18 { term *= -reduced * reduced; total += term / cast(float64) (2 * i + 1); }
    result := 4 * total;
    if reciprocal result = PI64 * 0.5 - result;
    if value < 0 result = -result;
    return result;
}
atan2 :: (y: float64, x: float64) -> float64 {
    if isnan(x) || isnan(y) return FLOAT64_NAN;
    sign_y := (float64_bits(y) >> 63) != 0;
    sign_x := (float64_bits(x) >> 63) != 0;
    if y == 0 { if sign_x { if sign_y return -PI64; return PI64; } return y; }
    if x == 0 { if sign_y return -PI64 * 0.5; return PI64 * 0.5; }
    if isinf(x) && isinf(y) { x = 1; if sign_x x = -1; y = 1; if sign_y y = -1; }
    angle := atan(y / x);
    if sign_x { if sign_y angle -= PI64; else angle += PI64; }
    return angle;
}
asin :: (x: float64) -> float64 { value := x;
    if abs(value) > 1 return FLOAT64_NAN;
    return atan2(value, sqrt((1 - value) * (1 + value)));
}
acos :: (x: float64) -> float64 { value := x;
    if abs(value) > 1 return FLOAT64_NAN;
    return atan2(sqrt((1 - value) * (1 + value)), value);
}
sin_or_cos :: (x: float64, $IS_SIN: bool) -> float64 { if IS_SIN return sin(x); return cos(x); }
floor :: (f: float32) -> float32 { return cast(float32) floor(cast(float64) f); }
ceil :: (f: float32) -> float32 { return cast(float32) ceil(cast(float64) f); }
round :: (value: float32) -> float32 { return cast(float32) round(cast(float64) value); }
sqrt :: (x: float32) -> float32 { return cast(float32) sqrt(cast(float64) x); }
log :: (x: float32) -> float32 { return cast(float32) log(cast(float64) x); }
exp :: (x: float32) -> float32 { return cast(float32) exp(cast(float64) x); }
sin :: (x: float32) -> float32 { return cast(float32) sin(cast(float64) x); }
cos :: (x: float32) -> float32 { return cast(float32) cos(cast(float64) x); }
tan :: (theta: float32) -> float32 { return cast(float32) tan(cast(float64) theta); }
cot :: (x: float32) -> float32 { return cast(float32) cot(cast(float64) x); }
atan :: (y: float32) -> float32 { return cast(float32) atan(cast(float64) y); }
asin :: (theta: float32) -> float32 { return cast(float32) asin(cast(float64) theta); }
acos :: (theta: float32) -> float32 { return cast(float32) acos(cast(float64) theta); }
atan2 :: (y: float32, x: float32) -> float32 { return cast(float32) atan2(cast(float64) y, cast(float64) x); }
pow :: (x: float32, power: float32) -> float32 { return cast(float32) pow(cast(float64) x, cast(float64) power); }
fmod_cycling :: (x: float32, divisor: float32) -> float32 { return cast(float32) fmod_cycling(cast(float64) x, cast(float64) divisor); }
half_to_float :: (h: u16) -> float {
    sign := (cast(u32) (h >> 15)) << 31;
    exponent := cast(u32) ((h >> 10) & 31);
    fraction := cast(u32) (h & 1023);
    if exponent == 31 return float32_from_bits(sign | 0x7f80_0000 | (fraction << 13));
    if exponent == 0 {
        if fraction == 0 return float32_from_bits(sign);
        power: s32 = -14;
        while (fraction & 1024) == 0 { fraction <<= 1; power -= 1; }
        return float32_from_bits(sign | ((cast(u32) (power + 127)) << 23) | ((fraction & 1023) << 13));
    }
    return float32_from_bits(sign | ((exponent + 112) << 23) | (fraction << 13));
}
