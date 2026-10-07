// Independently authored signed femtosecond arithmetic and calendar rendering.
// OS clock acquisition and timezone conversion are supplied by OS modules.
Apollo_Time :: struct {
    low: u64;
    high: s64;
}

APOLLO_TIME_INVALID :: Apollo_Time.{ 0, cast,no_check(s64) 0x8000_0000_0000_0000 };

Time_Zone :: enum u32 {
    UTC :: 0;
    LOCAL :: 1;
}

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
APOLLO_TIME_FOR_JAN_1_1970 :: Apollo_Time.{ low = 0xdbd87f0edb7c8000, high = 0x300 };

ConvertToApollo :: (m: s64, FACTOR: s64) #expand {
    return cast,force(Apollo_Time) (to_s128(m) * FACTOR);
}

seconds_to_apollo :: (m: s64) -> Apollo_Time {
    return cast,force(Apollo_Time) (to_s128(m) * FEMTOSECONDS);
}

milliseconds_to_apollo :: (m: s64) -> Apollo_Time {
    return cast,force(Apollo_Time) (to_s128(m) * 1_000_000_000_000);
}

microseconds_to_apollo :: (m: s64) -> Apollo_Time {
    return cast,force(Apollo_Time) (to_s128(m) * 1_000_000_000);
}

nanoseconds_to_apollo :: (m: s64) -> Apollo_Time {
    return cast,force(Apollo_Time) (to_s128(m) * 1_000_000);
}

operator == :: (a: Apollo_Time, b: Apollo_Time) -> bool {
    return a.low == b.low && a.high == b.high;
}

operator + :: (a: Apollo_Time, b: Apollo_Time) -> Apollo_Time {
    return cast,force(Apollo_Time) (cast,force(S128) a + cast,force(S128) b);
}

operator - :: (a: Apollo_Time, b: Apollo_Time) -> Apollo_Time {
    return cast,force(Apollo_Time) (cast,force(S128) a - cast,force(S128) b);
}

operator < :: (a: Apollo_Time, b: Apollo_Time) -> bool {
    return cast,force(S128) a < cast,force(S128) b;
}

operator <= :: (a: Apollo_Time, b: Apollo_Time) -> bool {
    return !(b < a);
}

operator > :: (a: Apollo_Time, b: Apollo_Time) -> bool {
    return b < a;
}

operator >= :: (a: Apollo_Time, b: Apollo_Time) -> bool {
    return !(a < b);
}

// Integer conversion truncates toward zero unless rounding is requested.
// Rounding uses the nearest integer, with exact halves away from zero.
ConvertFromApollo :: inline (t: Apollo_Time, divisor: u64, $DO_ROUNDING: bool) -> (result: s64, success: bool) {
    if t == APOLLO_TIME_INVALID || divisor == 0 return 0, false;
    quotient, remainder, error := signed_divide_with_remainder(cast,force(S128) t, to_s128(divisor));
    if error return 0, false;
    #if DO_ROUNDING {
        magnitude := to_u128(remainder);
        if remainder.high < 0 magnitude = U128.{} - magnitude;
        if magnitude >= U128.{ divisor / 2 + divisor % 2, 0 } {
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

to_float64_seconds :: (input: Apollo_Time) -> (result: float64, success: bool) {
    return to_float64_seconds_checked(input);
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
    bits := U128.{ low, high };
    if negative bits = U128.{} - bits;
    return cast,force(Apollo_Time) to_s128(bits);
}

calendar_to_string :: (ct: Calendar_Time) -> string {
    return tprint("%-%-% %:%:%.%", FormatInt.{ value = ct.year, minimum_digits = 4 },
        FormatInt.{ value = ct.month_starting_at_0 + 1, minimum_digits = 2 },
        FormatInt.{ value = ct.day_of_month_starting_at_0 + 1, minimum_digits = 2 },
        FormatInt.{ value = ct.hour, minimum_digits = 2 }, FormatInt.{ value = ct.minute, minimum_digits = 2 },
        FormatInt.{ value = ct.second, minimum_digits = 2 }, FormatInt.{ value = ct.millisecond, minimum_digits = 3 });
}

calendar_to_iso_string :: (ct: Calendar_Time) -> string {
    zone := "";
    if ct.time_zone == .UTC zone = "Z";
    return tprint("%1-%2-%3T%4:%5:%6.%7%8", FormatInt.{ value = ct.year, minimum_digits = 4 },
        FormatInt.{ value = ct.month_starting_at_0 + 1, minimum_digits = 2 },
        FormatInt.{ value = ct.day_of_month_starting_at_0 + 1, minimum_digits = 2 },
        FormatInt.{ value = ct.hour, minimum_digits = 2 }, FormatInt.{ value = ct.minute, minimum_digits = 2 },
        FormatInt.{ value = ct.second, minimum_digits = 2 }, FormatInt.{ value = ct.millisecond, minimum_digits = 3 }, zone);
}

// Calendar conversion. UTC uses the proleptic Gregorian civil-date algorithm below, so it is exact and
// identical on every OS. LOCAL asks the OS only for the UTC offset (os_local_offset_seconds).
#scope_module
civil_floor_div :: (a: s64, b: s64) -> s64 {
    q := a / b;
    if a % b != 0 && (a < 0) != (b < 0) q -= 1;
    return q;
}

// Days since 1970-01-01 of the given civil date (month is 1-12, day may be out of range and is linear).
civil_days_from_date :: (year: s64, month: s64, day: s64) -> s64 {
    y := year;
    if month <= 2 y -= 1;
    era := civil_floor_div(y, 400);
    yoe := y - era * 400;
    mp := (month + 9) % 12;
    doy := (153 * mp + 2) / 5;
    doe := yoe * 365 + yoe / 4 - yoe / 100 + doy;
    return era * 146097 + doe - 719468 + (day - 1);
}

civil_date_from_days :: (days: s64) -> (year: s64, month: s64, day: s64) {
    z := days + 719468;
    era := civil_floor_div(z, 146097);
    doe := z - era * 146097;
    yoe := (doe - doe / 1460 + doe / 36524 - doe / 146096) / 365;
    y := yoe + era * 400;
    doy := doe - (365 * yoe + yoe / 4 - yoe / 100);
    mp := (5 * doy + 2) / 153;
    d := doy - (153 * mp + 2) / 5 + 1;
    m := mp + 3;
    if m > 12 m -= 12;
    if m <= 2 y += 1;
    return y, m, d;
}

calendar_from_unix_milliseconds :: (unix_ms: s64, time_zone: Time_Zone) -> Calendar_Time {
    total_seconds := civil_floor_div(unix_ms, 1000);
    millis := unix_ms - total_seconds * 1000;
    local_seconds := total_seconds;
    if time_zone == .LOCAL local_seconds += os_local_offset_seconds(total_seconds);
    days := civil_floor_div(local_seconds, 86400);
    second_of_day := local_seconds - days * 86400;
    year, month, day := civil_date_from_days(days);
    ct: Calendar_Time;
    ct.year = cast,no_check(s32) year;
    ct.month_starting_at_0 = cast,no_check(s8) (month - 1);
    ct.day_of_month_starting_at_0 = cast,no_check(s8) (day - 1);
    ct.day_of_week_starting_at_0 = cast,no_check(s8) ((days % 7 + 11) % 7); // 1970-01-01 was a Thursday.
    ct.hour = cast,no_check(s8) (second_of_day / 3600);
    ct.minute = cast,no_check(s8) ((second_of_day % 3600) / 60);
    ct.second = cast,no_check(s8) (second_of_day % 60);
    ct.millisecond = cast,no_check(s16) millis;
    ct.time_zone = time_zone;
    return ct;
}
#scope_export

// Millisecond precision (rounded to nearest). An out-of-range input yields an all-zero Calendar_Time.
to_calendar :: (at: Apollo_Time, time_zone := Time_Zone.UTC) -> Calendar_Time {
    unix_ms, ok := to_milliseconds(at - APOLLO_TIME_FOR_JAN_1_1970, DO_ROUNDING = true);
    if !ok || at == APOLLO_TIME_INVALID return .{};
    return calendar_from_unix_milliseconds(unix_ms, time_zone);
}

// Out-of-range fields (e.g. month 12, hour 25) are normalized. Returns a zero Apollo_Time when the date overflows.
calendar_to_apollo :: (ct: Calendar_Time) -> Apollo_Time {
    month_index := cast(s64) ct.month_starting_at_0;
    year := cast(s64) ct.year + civil_floor_div(month_index, 12);
    month_index -= civil_floor_div(month_index, 12) * 12;
    days := civil_days_from_date(year, month_index + 1, cast(s64) ct.day_of_month_starting_at_0 + 1);
    seconds := days * 86400 + cast(s64) ct.hour * 3600 + cast(s64) ct.minute * 60 + cast(s64) ct.second;
    if ct.time_zone == .LOCAL {
        // Treat the fields as UTC first, then correct by the zone offset in effect at the resulting instant.
        guess := seconds - os_local_offset_seconds(seconds);
        seconds -= os_local_offset_seconds(guess);
    }
    return APOLLO_TIME_FOR_JAN_1_1970 + seconds_to_apollo(seconds) + milliseconds_to_apollo(cast(s64) ct.millisecond);
}
