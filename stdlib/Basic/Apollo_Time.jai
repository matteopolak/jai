// Independently authored signed femtosecond arithmetic and calendar rendering.
// OS clock acquisition and timezone conversion are supplied by OS modules.
Apollo_Time :: struct { low: u64; high: s64; }
APOLLO_TIME_INVALID :: Apollo_Time.{0, cast,no_check(s64) 0x8000_0000_0000_0000};
Time_Zone :: enum u32 { UTC :: 0; LOCAL :: 1; }
Calendar_Time :: struct {
    year: s32;
    month_starting_at_0: s8;
    day_of_month_starting_at_0: s8;
    day_of_week_starting_at_0: s8;
    hour: s8;
    minute: s8;
    second: s8;
    millisecond: s16;
    time_zone: Time_Zone;
}
FEMTOSECONDS :: 1_000_000_000_000_000;
APOLLO_TIME_FOR_JAN_1_1970 :: Apollo_Time.{low = 0xdbd87f0edb7c8000, high = 0x300};

ConvertToApollo :: (m: s64, FACTOR: s64) #expand {
    return cast,force(Apollo_Time) (to_s128(m) * FACTOR);
}
seconds_to_apollo :: (m: s64) -> Apollo_Time { return cast,force(Apollo_Time) (to_s128(m) * FEMTOSECONDS); }
milliseconds_to_apollo :: (m: s64) -> Apollo_Time { return cast,force(Apollo_Time) (to_s128(m) * 1_000_000_000_000); }
microseconds_to_apollo :: (m: s64) -> Apollo_Time { return cast,force(Apollo_Time) (to_s128(m) * 1_000_000_000); }
nanoseconds_to_apollo :: (m: s64) -> Apollo_Time { return cast,force(Apollo_Time) (to_s128(m) * 1_000_000); }

operator == :: (a: Apollo_Time, b: Apollo_Time) -> bool { return a.low == b.low && a.high == b.high; }
operator + :: (a: Apollo_Time, b: Apollo_Time) -> Apollo_Time {
    return cast,force(Apollo_Time) (cast,force(S128) a + cast,force(S128) b);
}
operator - :: (a: Apollo_Time, b: Apollo_Time) -> Apollo_Time {
    return cast,force(Apollo_Time) (cast,force(S128) a - cast,force(S128) b);
}
operator < :: (a: Apollo_Time, b: Apollo_Time) -> bool { return cast,force(S128) a < cast,force(S128) b; }
operator <= :: (a: Apollo_Time, b: Apollo_Time) -> bool { return !(b < a); }
operator > :: (a: Apollo_Time, b: Apollo_Time) -> bool { return b < a; }
operator >= :: (a: Apollo_Time, b: Apollo_Time) -> bool { return !(a < b); }

// Integer conversion truncates toward zero unless rounding is requested.
// Rounding uses the nearest integer, with exact halves away from zero.
ConvertFromApollo :: inline (t: Apollo_Time, divisor: u64, $DO_ROUNDING: bool) -> (result: s64, success: bool) {
    if t == APOLLO_TIME_INVALID || divisor == 0 return 0, false;
    quotient, remainder, error := signed_divide_with_remainder(cast,force(S128) t, to_s128(divisor));
    if error return 0, false;
    #if DO_ROUNDING {
        magnitude := to_u128(remainder);
        if remainder.high < 0 magnitude = U128.{} - magnitude;
        if magnitude >= U128.{divisor / 2 + divisor % 2, 0} {
            if t.high < 0 quotient = quotient - to_s128(1);
            else quotient = quotient + to_s128(1);
        }
    }
    if quotient.high == 0 && quotient.low <= 0x7fff_ffff_ffff_ffff return cast(s64) quotient.low, true;
    if quotient.high == -1 && quotient.low >= 0x8000_0000_0000_0000 return cast,no_check(s64) quotient.low, true;
    return 0, false;
}
to_seconds :: (t: Apollo_Time, $DO_ROUNDING := false) -> (result: s64, success: bool) {
    return ConvertFromApollo(t, FEMTOSECONDS, DO_ROUNDING);
}
to_milliseconds :: (t: Apollo_Time, $DO_ROUNDING := false) -> (result: s64, success: bool) {
    return ConvertFromApollo(t, 1_000_000_000_000, DO_ROUNDING);
}
to_microseconds :: (t: Apollo_Time, $DO_ROUNDING := false) -> (result: s64, success: bool) {
    return ConvertFromApollo(t, 1_000_000_000, DO_ROUNDING);
}
to_nanoseconds :: (t: Apollo_Time, $DO_ROUNDING := false) -> (result: s64, success: bool) {
    return ConvertFromApollo(t, 1_000_000, DO_ROUNDING);
}
compare_apollo_times :: (a: Apollo_Time, b: Apollo_Time) -> s32 {
    if a < b return -1;
    if a > b return 1;
    return 0;
}
to_float64_seconds_checked :: (input: Apollo_Time) -> (result: float64, success: bool) {
    if input == APOLLO_TIME_INVALID return 0, false;
    magnitude := to_u128(cast,force(S128) input);
    negative := input.high < 0;
    if negative magnitude = U128.{} - magnitude;
    value := (cast(float64) magnitude.high * 18446744073709551616.0 + cast(float64) magnitude.low) / cast(float64) FEMTOSECONDS;
    if negative value = -value;
    return value, true;
}
to_float64_seconds :: (time: Apollo_Time) -> float64 {
    result, success := to_float64_seconds_checked(time);
    return result;
}
to_apollo :: (seconds: float64) -> Apollo_Time {
    if seconds != seconds return APOLLO_TIME_INVALID;
    negative := seconds < 0;
    magnitude := seconds;
    if negative magnitude = -magnitude;
    femtoseconds := magnitude * cast(float64) FEMTOSECONDS;
    // The upper bound also rejects infinity before any float-to-integer cast.
    if femtoseconds >= 170141183460469231731687303715884105728.0 return APOLLO_TIME_INVALID;
    high := cast(u64) (femtoseconds / 18446744073709551616.0);
    low := cast(u64) (femtoseconds - cast(float64) high * 18446744073709551616.0);
    bits := U128.{low, high};
    if negative bits = U128.{} - bits;
    return cast,force(Apollo_Time) to_s128(bits);
}
calendar_to_string :: (ct: Calendar_Time) -> string {
    return tprint("%-%-% %:%:%.%", FormatInt.{value = ct.year, minimum_digits = 4},
        FormatInt.{value = ct.month_starting_at_0 + 1, minimum_digits = 2},
        FormatInt.{value = ct.day_of_month_starting_at_0 + 1, minimum_digits = 2},
        FormatInt.{value = ct.hour, minimum_digits = 2}, FormatInt.{value = ct.minute, minimum_digits = 2},
        FormatInt.{value = ct.second, minimum_digits = 2}, FormatInt.{value = ct.millisecond, minimum_digits = 3});
}
calendar_to_iso_string :: (ct: Calendar_Time) -> string {
    zone := "";
    if ct.time_zone == .UTC zone = "Z";
    return tprint("%0-%1-%2T%3:%4:%5.%6%7", FormatInt.{value = ct.year, minimum_digits = 4},
        FormatInt.{value = ct.month_starting_at_0 + 1, minimum_digits = 2},
        FormatInt.{value = ct.day_of_month_starting_at_0 + 1, minimum_digits = 2},
        FormatInt.{value = ct.hour, minimum_digits = 2}, FormatInt.{value = ct.minute, minimum_digits = 2},
        FormatInt.{value = ct.second, minimum_digits = 2}, FormatInt.{value = ct.millisecond, minimum_digits = 3}, zone);
}
