// OS clock acquisition. Apollo arithmetic is defined in Apollo_Time.jai.
#if OS == .WINDOWS {
    current_time_monotonic :: () -> Apollo_Time {
        ticks: s64;
        frequency: s64;
        if !clock_query_counter(*ticks) || !clock_query_frequency(*frequency) || frequency <= 0 return APOLLO_TIME_INVALID;
        seconds := ticks / frequency;
        fraction := ticks % frequency;
        return seconds_to_apollo(seconds) + to_apollo(cast(float64) fraction / cast(float64) frequency);
    }
    current_time_consensus :: () -> Apollo_Time {
        stamp: Clock_Filetime;
        clock_system_filetime(*stamp);
        return filetime_to_apollo(stamp);
    }
    filetime_to_apollo :: (stamp: $T) -> Apollo_Time {
        ticks := (cast(u64) stamp.dwHighDateTime << 32) | stamp.dwLowDateTime;
        epoch_ticks :: 116444736000000000;
        if ticks < epoch_ticks return APOLLO_TIME_INVALID;
        since_epoch := ticks - epoch_ticks;
        seconds := cast(s64) (since_epoch / 10000000);
        nanoseconds := cast(s64) (since_epoch % 10000000) * 100;
        return APOLLO_TIME_FOR_JAN_1_1970 + seconds_to_apollo(seconds) + nanoseconds_to_apollo(nanoseconds);
    }
    sleep_milliseconds :: (milliseconds: s64) {
        remaining := max(0, milliseconds);
        while remaining > 0 {
            amount := min(remaining, 0x7fff_ffff);
            clock_sleep(cast(s32) amount);
            remaining -= amount;
        }
    }
    exit :: (status: s64) { clock_exit(cast,no_check(u32) status); }
    #scope_module
    clock_kernel :: #system_library "kernel32";
    Clock_Filetime :: struct { dwLowDateTime: u32; dwHighDateTime: u32; }
    clock_query_counter :: (ticks: *s64) -> s32 #foreign clock_kernel "QueryPerformanceCounter";
    clock_query_frequency :: (frequency: *s64) -> s32 #foreign clock_kernel "QueryPerformanceFrequency";
    clock_system_filetime :: (stamp: *Clock_Filetime) #foreign clock_kernel "GetSystemTimeAsFileTime";
    clock_sleep :: (milliseconds: s32) #foreign clock_kernel "Sleep";
    clock_exit :: (status: u32) #foreign clock_kernel "ExitProcess";
    #scope_export
} else {
    current_time_monotonic :: () -> Apollo_Time {
        clock: s32 = 1;
        #if OS == .MACOS || OS == .IOS { clock = 6; }
        stamp: Clock_Timespec;
        if clock_get_time(clock, *stamp) != 0 return APOLLO_TIME_INVALID;
        return seconds_to_apollo(stamp.tv_sec) + nanoseconds_to_apollo(stamp.tv_nsec);
    }
    current_time_consensus :: () -> Apollo_Time {
        stamp: Clock_Timespec;
        if clock_get_time(0, *stamp) != 0 return APOLLO_TIME_INVALID;
        return timespec_to_apollo(stamp);
    }
    timespec_to_apollo :: (stamp: $T) -> Apollo_Time {
        return APOLLO_TIME_FOR_JAN_1_1970 + seconds_to_apollo(stamp.tv_sec) + nanoseconds_to_apollo(stamp.tv_nsec);
    }
    sleep_milliseconds :: (milliseconds: s64) {
        if milliseconds <= 0 return;
        requested: Clock_Timespec;
        requested.tv_sec = milliseconds / 1000;
        requested.tv_nsec = milliseconds % 1000 * 1000000;
        while true {
            remaining: Clock_Timespec;
            if clock_nanosleep(*requested, *remaining) == 0 return;
            if clock_errno_slot().* != 4 return;
            requested = remaining;
        }
    }
    exit :: (status: s64) { native_time_exit(cast,no_check(s32) status); }
    #scope_module
    native_time_libc :: #system_library "c";
    Clock_Timespec :: struct { tv_sec: s64; tv_nsec: s64; }
    clock_get_time :: (clock: s32, stamp: *Clock_Timespec) -> s32 #foreign native_time_libc "clock_gettime";
    clock_nanosleep :: (requested: *Clock_Timespec, remaining: *Clock_Timespec) -> s32 #foreign native_time_libc "nanosleep";
    #if OS == .MACOS || OS == .IOS {
        clock_errno_slot :: () -> *s32 #foreign native_time_libc "__error";
    } else {
        clock_errno_slot :: () -> *s32 #foreign native_time_libc "__errno_location";
    }
    native_time_exit :: (status: s32) #foreign native_time_libc "exit";
    #scope_export
}

get_time :: () -> float64 { return to_float64_seconds(current_time_monotonic()); }

seconds_since_init :: () -> float64 {
    now := current_time_monotonic();
    now_ns, valid := to_nanoseconds(now);
    if !valid || now_ns < 0 return 0;
    installed, origin := compare_and_swap(*clock_initial_nanoseconds, cast(s64) -1, now_ns);
    if installed origin = now_ns;
    return cast(float64) max(0, now_ns - origin) / 1000000000.0;
}

#scope_module
clock_initial_nanoseconds: s64 = -1;
