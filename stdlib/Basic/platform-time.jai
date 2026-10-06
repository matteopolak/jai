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
        ticks := ((cast(u64) stamp.dwHighDateTime) << 32) | stamp.dwLowDateTime;
        epoch_ticks :: 116444736000000000;
        if ticks < epoch_ticks return APOLLO_TIME_INVALID;
        since_epoch := ticks - epoch_ticks;
        seconds := cast(s64) (since_epoch / 10000000);
        nanoseconds := cast(s64) (since_epoch % 10000000) * 100;
        return APOLLO_TIME_FOR_JAN_1_1970 + seconds_to_apollo(seconds) + nanoseconds_to_apollo(nanoseconds);
    }
    // FILETIME ticks (100ns since 1601-01-01) for an Apollo_Time; success is false when it predates 1601 or overflows.
    to_filetime :: (at: Apollo_Time) -> (ft: Clock_Filetime, success: bool) {
        ticks, ok := to_nanoseconds(at - APOLLO_TIME_FOR_JAN_1_1970);
        ft: Clock_Filetime;
        if !ok return ft, false;
        total := ticks / 100;
        if ticks < 0 && ticks % 100 != 0 total -= 1;
        total += 116444736000000000;
        if total < 0 return ft, false;
        ft.dwLowDateTime = cast,no_check(u32) ((cast(u64) total) & 0xffff_ffff);
        ft.dwHighDateTime = cast,no_check(u32) ((cast(u64) total) >> 32);
        return ft, true;
    }
    // @Incomplete: LOCAL time zone handling is not wired to the Windows API; LOCAL behaves like UTC here.
    os_local_offset_seconds :: (utc_seconds: s64) -> s64 { return 0; }
    sleep_milliseconds :: (milliseconds: s32) {
        remaining := max(0, milliseconds);
        while remaining > 0 {
            amount := min(remaining, 0x7fff_ffff);
            clock_sleep(cast(s32) amount);
            remaining -= amount;
        }
    }
    set_working_directory :: (s: string) -> bool {
        wide := clock_utf8_to_wide(s);
        if !wide.data return false;
        return clock_set_cwd(wide.data) != 0;
    }
    // Returns a temporary-storage string, or "" on failure.
    get_working_directory :: () -> string {
        required := clock_get_cwd(0, null);
        if required == 0 return "";
        buffer := cast(*u16) alloc(cast(s64) required * 2 + 2, temp);
        written := clock_get_cwd(required, buffer);
        if written == 0 || written >= required return "";
        bytes := clock_wide_to_utf8(65001, 0, buffer, cast(s32) written, null, 0, null, null);
        if bytes <= 0 return "";
        out := cast(*u8) alloc(cast(s64) bytes, temp);
        clock_wide_to_utf8(65001, 0, buffer, cast(s32) written, out, bytes, null, null);
        return string.{cast(s64) bytes, out};
    }
    exit :: (status: s32) { clock_exit(cast,no_check(u32) status); }
    #scope_module
    clock_kernel :: #system_library "kernel32";
    Clock_Filetime :: struct { dwLowDateTime: u32; dwHighDateTime: u32; }
    clock_query_counter :: (ticks: *s64) -> s32 #foreign clock_kernel "QueryPerformanceCounter";
    clock_query_frequency :: (frequency: *s64) -> s32 #foreign clock_kernel "QueryPerformanceFrequency";
    clock_system_filetime :: (stamp: *Clock_Filetime) #foreign clock_kernel "GetSystemTimeAsFileTime";
    clock_sleep :: (milliseconds: s32) #foreign clock_kernel "Sleep";
    clock_exit :: (status: u32) #foreign clock_kernel "ExitProcess";
    clock_set_cwd :: (name: *u16) -> s32 #foreign clock_kernel "SetCurrentDirectoryW";
    clock_get_cwd :: (length: u32, buffer: *u16) -> u32 #foreign clock_kernel "GetCurrentDirectoryW";
    clock_utf8_to_wide_raw :: (code_page: u32, flags: u32, source: *u8, source_length: s32, destination: *u16, destination_length: s32) -> s32 #foreign clock_kernel "MultiByteToWideChar";
    clock_wide_to_utf8 :: (code_page: u32, flags: u32, source: *u16, source_length: s32, destination: *u8, destination_length: s32, default_char: *u8, used_default: *s32) -> s32 #foreign clock_kernel "WideCharToMultiByte";
    clock_utf8_to_wide :: (text: string) -> [] u16 {
        count := clock_utf8_to_wide_raw(65001, 0, text.data, cast(s32) text.count, null, 0);
        result: [] u16;
        if count <= 0 && text.count > 0 return result;
        buffer := cast(*u16) alloc((cast(s64) count + 1) * 2, temp);
        clock_utf8_to_wide_raw(65001, 0, text.data, cast(s32) text.count, buffer, count);
        buffer[count] = 0;
        result.data = buffer;
        result.count = count;
        return result;
    }
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
    #if OS == .LINUX || OS == .MACOS || OS == .ANDROID || OS == .WASM {
        // Seconds east of UTC in the system local zone at the given instant (includes DST), via localtime_r.
        os_local_offset_seconds :: (utc_seconds: s64) -> s64 {
            when := utc_seconds;
            parts: Clock_Tm;
            if Clock_Posix.localtime_r(*when, *parts) == null return 0;
            return parts.tm_gmtoff;
        }
        to_timespec :: (at: Apollo_Time) -> (ts: Clock_Posix.timespec, success: bool) {
            ts: Clock_Posix.timespec;
            elapsed := at - APOLLO_TIME_FOR_JAN_1_1970;
            nanoseconds_total, ok := to_nanoseconds(elapsed, DO_ROUNDING = true);
            if !ok || at == APOLLO_TIME_INVALID || nanoseconds_total < 0 return ts, false; // timespec cannot go negative
            ts.tv_sec = nanoseconds_total / 1_000_000_000;
            ts.tv_nsec = nanoseconds_total % 1_000_000_000;
            return ts, true;
        }
    } else {
        os_local_offset_seconds :: (utc_seconds: s64) -> s64 { return 0; }
    }
    sleep_milliseconds :: (milliseconds: s32) {
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
    set_working_directory :: (s: string) -> bool {
        return clock_chdir(temp_c_string(s)) == 0;
    }
    // Returns a temporary-storage string, or "" on failure.
    get_working_directory :: () -> string {
        capacity: s64 = 256;
        while capacity <= 1048576 {
            buffer := cast(*u8) alloc(capacity, temp);
            if clock_getcwd(buffer, cast(u64) capacity) return to_string(buffer);
            if clock_errno_slot().* != 34 return ""; // ERANGE
            capacity *= 2;
        }
        return "";
    }
    exit :: (status: s32) { native_time_exit(status); }
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
    clock_chdir :: (path: *u8) -> s32 #foreign native_time_libc "chdir";
    clock_getcwd :: (buffer: *u8, size: u64) -> *u8 #foreign native_time_libc "getcwd";
    #if OS == .LINUX || OS == .MACOS || OS == .ANDROID || OS == .WASM {
        Clock_Posix :: #import "POSIX";
        Clock_Tm :: Clock_Posix.tm;
    }
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

// macOS-only names exported by the reference Basic module.
#if OS == .MACOS {
    // Packs up to four characters big-endian, like a C multi-character constant ('sora' == 0x736F7261).
    store_in_integer :: (str: string) -> s32 {
        assert(str.count <= 4);
        out: s32;
        for 0..str.count - 1 {
            shift := cast(u32) ((str.count - it - 1) * 8);
            out = out | cast,no_check(s32) ((cast(u32) str[it]) << shift);
        }
        return out;
    }
    IID :: struct {};
    LPVOID :: *void;
    AbsoluteTime :: u64;
    FourCharCode :: u32;
    OSStatus :: s32;
    OSType :: FourCharCode;
    noErr :OSStatus: 0;
    _NSGetExecutablePath :: (buf: *u8, bufsize: *u32) -> s32 #foreign native_time_libc;
    NSSymbol :: *void;
    NSIsSymbolNameDefined :: (symbolName: *u8) -> bool #foreign native_time_libc #deprecated "use dlysym()";
    NSLookupAndBindSymbol :: (symbolName: *u8) -> NSSymbol #foreign native_time_libc #deprecated "use dlysym()";
    NSAddressOfSymbol :: (symbol: NSSymbol) -> *void #foreign native_time_libc #deprecated "use dlysym()";
}

#scope_module
clock_initial_nanoseconds: s64 = -1;
