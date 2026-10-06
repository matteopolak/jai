// Independent declaration normalization; see docs/stdlib/native-bindings.md.
#import "Basic";

#module_parameters(ENABLED := false);

#scope_export

#if !ENABLED || OS != .WINDOWS {

    ENABLE_TELEMETRY :: 0;

    telemetry_enabled :: () -> bool #expand {
        return false;
    }

    telemetry_init :: (program_name: string, build_info: string, output_file := "") #expand {}
    telemetry_shutdown :: () #expand {}
    telemetry_tick :: () #expand {}
    telemetry_enterzone :: (name: string, loc := #caller_location, is_dynamic := false) #expand {}
    telemetry_leavezone :: () #expand {}
    telemetry_plot :: (plot_name: string, plot_value: float64) #expand {}
    telemetry_message :: (message: string) #expand {}
    telemetry_setthreadname :: (name: string) #expand {}

    telemetry_start_gpuzone :: (frame_number: u32, gpu_freq: u64, cpu_freq: u64, gpu_begin: u64, cpu_begin: u64, fast_begin: u64) #expand {}
    telemetry_add_gpuzone :: (name: string, frame_number: u32, level: u32, gpu_enter: u64, gpu_leave: u64) #expand {}
    telemetry_end_gpuzone :: () #expand {}

    telemetry_start :: (frames := 0) #expand {}
    telemetry_stop :: () #expand {}

} else {

    ENABLE_TELEMETRY :: 1;

    #import "Atomics";
    #import "Math";
    #import "Machine_X64";
    W :: #import "Windows";

    TM_SDK_MAJOR_VERSION :: 3;
    TM_SDK_MINOR_VERSION :: 5;
    TM_SDK_REVISION_NUMBER :: 0;
    TM_SDK_BUILD_NUMBER :: 147;
    TM_SDK_VERSION :: "3.5.0.147";
    TmBuildVersion :: 03_5_000_147;
    TM_BUILD_YEAR :: 2022;
    TM_BUILD_MONTH :: 9;
    TM_BUILD_DAY :: 6;
    TM_BUILD_SECOND :: 53968;
    TM_BUILD_DATE :: "2022.09.06.53968";
    TmBuildDate :: 2022_09_06_53968;

    TM_API_MAJOR_VERSION :: 2022;
    TM_API_MINOR_VERSION :: 5;
    TM_API_REVISION_NUMBER :: 23;
    TM_API_BUILD_NUMBER :: 51766;
    TM_API_VERSION :: "2022.05.23.51766";

    telemetry_enabled :: () -> bool {
        return g_tm_api0 != null;
    }

    tm_program_name := "";
    tm_build_info := "";

    telemetry_init :: (program_name: string, build_info: string, output_file := "") -> int {
        if g_tm_api0 return cast(int) tm_error.TMERR_ALREADY_INITIALIZED;
        api := native_get_api(null);
        if !api return cast(int) tm_error.TMERR_NULL_API;
        result := api.tmCheckVersion(TM_API_MAJOR_VERSION, TM_API_MINOR_VERSION,
                                     TM_API_REVISION_NUMBER, TM_API_BUILD_NUMBER);
        if result != .TM_OK return cast(int) result;
        tm_arena_allocation = cast(*u8) alloc(TM_ARENA_BYTES + 4095);
        if !tm_arena_allocation return cast(int) tm_error.TMERR_OUT_OF_RESOURCES;
        aligned := cast(*u8) ((cast(u64) tm_arena_allocation + 4095) & ~cast(u64) 4095);
        result = api.tmInitialize(TM_ARENA_BYTES, aligned);
        if result != .TM_OK {
            free(tm_arena_allocation);
            tm_arena_allocation = null;
            return cast(int) result;
        }
        tm_program_name = copy_string(program_name);
        tm_build_info = copy_string(build_info);
        g_tm_api0 = api;
        g_tm_api = api;
        return telemetry_start(0, output_file);
    }

    telemetry_start :: (frames := 0, output_file := "") -> int {
        if !g_tm_api0 return cast(int) tm_error.TMERR_UNINITIALIZED;
        assert(frames >= 0);
        destination := output_file;
        connection: tm_connection_type = .TMCT_FILE;
        if destination.count == 0 {
            destination = "localhost";
            connection = .TMCT_TCP;
        }
        result := g_tm_api0.tmOpen(0, temp_c_string(tm_program_name), temp_c_string(tm_build_info),
                                   temp_c_string(destination), connection, 4719,
                                   .TMOF_INIT_NETWORKING, 1000);
        if result == .TM_OK {
            g_tm_api = g_tm_api0;
            g_run_frames = frames;
            g_tm_api.tmSetCaptureMask(U64_MAX);
        }
        return cast(int) result;
    }

    telemetry_stop :: () {
        assert(g_tm_api0);
        g_tm_api0.tmFlush();
        g_tm_api0.tmSetCaptureMask(0);
        g_tm_api0.tmClose(0);
        g_run_frames = 0;
    }

    telemetry_shutdown :: () {
        assert(g_tm_api0);
        g_tm_api0.tmFlush();
        g_tm_api0.tmClose(0);
        g_tm_api0.tmShutdown();
        g_tm_api = null;
        g_tm_api0 = null;
        free(tm_program_name.data);
        free(tm_build_info.data);
        tm_program_name = "";
        tm_build_info = "";
        free(tm_arena_allocation);
        tm_arena_allocation = null;
        g_run_frames = 0;
    }

    telemetry_tick :: () {
        assert(g_tm_api);
        g_tm_api.tmTick(U64_MAX);
        if g_run_frames > 0 {
            g_run_frames -= 1;
            if g_run_frames == 0 telemetry_stop();
        }
    }

    telemetry_enterzone :: (name: string, loc := #caller_location, is_dynamic := false) {
        assert(g_tm_api);
        zone_id := string_to_tm_id("%", name);
        file_id := string_to_tm_id("%", loc.fully_pathed_filename);
        g_tm_api.tmEnterZoneFast_Core(U64_MAX, 0, file_id, cast(u32) loc.line_number, zone_id);
    }

    telemetry_leavezone :: () {
        assert(g_tm_api);
        g_tm_api.tmLeaveZone(U64_MAX);
    }

    telemetry_plot :: (plot_name: string, plot_value: float64) {
        assert(g_tm_api);
        plot_id := string_to_tm_id("%", plot_name);
        g_tm_api.tmPlot_Core(U64_MAX, .TM_PLOT_UNITS_REAL, .TM_PLOT_DRAW_LINE,
                             plot_value, temp_c_string(plot_name), *plot_id);
    }

    telemetry_message :: (message: string) {
        assert(g_tm_api);
        file_id: u64;
        message_id := string_to_tm_id("%", message);
        g_tm_api.tmMessage_Core(U64_MAX, 0, temp_c_string(""), *file_id, 0,
                                temp_c_string(message), *message_id);
    }

    telemetry_setthreadname :: (name: string) {
        assert(g_tm_api);
        g_tm_api.tmThreadName(U64_MAX, W.GetCurrentThreadId(), temp_c_string("%s"), temp_c_string(name));
    }

    #scope_file

    tm_gpu_zone :: struct {
        name_id: u64;
        file_id: u64;
        line: u32;
        depth: u32;
    }

    gpu_start_times :: struct {
        gpu: u64;
        cpu: u64;
        fast: u64;
    }

    g_gpuinfo: struct {
        gpu_freq: u64;
        cpu_freq: u64;

        gpu_track_id: u32 = U32_MAX;
        gpu_zone: tm_gpu_zone;
        start_times: [3] gpu_start_times;
    };

    string_to_tm_id :: (format_string: string, args: ..Any) -> u64 {
        assert(g_tm_api);
        text := tprint(format_string, ..args);
        return g_tm_api.tmPrintf(temp_c_string("%s"), temp_c_string(text));
    }

    #scope_export

    telemetry_start_gpuzone :: (frame_number: u32, gpu_freq: u64, cpu_freq: u64, gpu_begin: u64, cpu_begin: u64, fast_begin: u64) {
        assert(g_tm_api);
        assert(gpu_freq > 0 && cpu_freq > 0);
        if g_gpuinfo.gpu_track_id == U32_MAX {
            g_gpuinfo.gpu_track_id = g_tm_api.tmNewTrackID();
            g_tm_api.tmTrackName(U64_MAX, g_gpuinfo.gpu_track_id, temp_c_string("GPU"));
        }
        g_gpuinfo.gpu_freq = gpu_freq;
        g_gpuinfo.cpu_freq = cpu_freq;
        g_gpuinfo.start_times[frame_number % 3] = .{ gpu_begin, cpu_begin, fast_begin };
    }

    telemetry_end_gpuzone :: () {
        assert(g_tm_api);
        g_tm_api.tmFlush();
    }

    telemetry_add_gpuzone :: (name: string, frame_number: u32, level: u32, gpu_enter: u64, gpu_leave: u64) {
        assert(g_tm_api && g_gpuinfo.gpu_freq > 0 && g_gpuinfo.cpu_freq > 0);
        assert(gpu_leave >= gpu_enter);
        reference := g_gpuinfo.start_times[frame_number % 3];
        zone: tm_gpu_zone;
        zone.name_id = string_to_tm_id("%", name);
        zone.depth = level;
        g_tm_api.tmGpuZone(*zone, g_gpuinfo.gpu_track_id, gpu_enter, gpu_leave,
                           reference.cpu, reference.fast, reference.gpu, reference.cpu, reference.fast,
                           g_gpuinfo.gpu_freq, g_gpuinfo.cpu_freq);
    }

    g_tm_api: *tm_api = null;
    g_tm_api0: *tm_api = null;

    #scope_file

    TelemetryZone :: struct {
        inited: bool = false;
        file_id: u64;
        line: u32;
        zone_id: u64;
        plot_name: *u8;
    }

    telemetry_zones: [] TelemetryZone;
    telemetry_zone_count: s32;

    get_telemetry_zone_index :: () -> s32 {
        return atomic_add(*telemetry_zone_count, 1);
    }

    tm_module: W.HMODULE = null;

    g_run_frames := 0;

    pTELEMETRY_tmGetApi :: #type (tmApi: *tm_api) -> *tm_api #c_call;

    tm_error :: enum u32 {
        TM_OK :: 0;
        TMERR_DISABLED :: 1;
        TMERR_INVALID_PARAM :: 2;
        TMERR_NULL_API :: 3;
        TMERR_OUT_OF_RESOURCES :: 4;
        TMERR_UNINITIALIZED :: 5;
        TMERR_BAD_HOSTNAME :: 6;
        TMERR_COULD_NOT_CONNECT :: 7;
        TMERR_UNKNOWN_NETWORK :: 8;
        TMERR_ALREADY_SHUTDOWN :: 9;
        TMERR_ARENA_TOO_SMALL :: 10;
        TMERR_BAD_HANDSHAKE :: 11;
        TMERR_UNALIGNED :: 12;
        TMERR_NETWORK_NOT_INITIALIZED :: 13;
        TMERR_BAD_VERSION :: 14;
        TMERR_BAD_TIMER :: 15;
        TMERR_ALREADY_OPENED :: 16;
        TMERR_ALREADY_INITIALIZED :: 17;
        TMERR_FILE_OPEN_FAILED :: 18;
        TMERR_INIT_NETWORKING_FAILED :: 19;
        TMERR_THREAD_CREATE_FAILED :: 20;
        TMERR_WRONG_PLATFORM :: 21;
        TMERR_UNKNOWN :: 0xFFFF;
    }

    tm_compression :: enum u32 {
        TMCOMPRESS_LZB :: 0;
        TMCOMPRESS_LZ4_DEPRECATED :: 1;
        TMCOMPRESS_NONE :: 2;
        TMCOMPRESS_UNKNOWN :: 0x7FFFFFFF;
    }

    tm_zone_flags :: enum u32 {
        TMZF_NONE :: 0;
        TMZF_STALL :: 1 << 1;
        TMZF_IDLE :: 1 << 2;
        TMZF_CONTEXT_SWITCH :: 1 << 3;
        TMZF_PLOT_TIME :: 1 << 4;
        TMZF_PLOT_TIME_EXPERIMENTAL :: TMZF_PLOT_TIME;
        TMZF_HAS_ACCUMULATION :: 1 << 5;
        TMZF_ACCUMULATION :: 1 << 6;
        TMZF_LOCK_HOLD :: 1 << 7;
        TMZF_LOCK_WAIT :: 1 << 8;
        TMZF_RECURSIVE :: 1 << 9;
        TMZF_NO_DURATION_LABEL :: 1 << 10;
        TMZF_KERNEL_SAMPLING_ZONE :: 1 << 11;
    }

    tm_open_flags :: enum u32 {
        TMOF_INIT_NETWORKING :: 1 << 0;
        TMOF_CAPTURE_CONTEXT_SWITCHES :: 1 << 1;
        TMOF_SAVE_PLOTS_CSV :: 1 << 3;
        TMOF_SAVE_ZONES_CSV :: 1 << 4;
        TMOF_SAVE_TIME_SPANS_CSV :: 1 << 5;
        TMOF_SAVE_MESSAGES_CSV :: 1 << 6;
        TMOF_GENERATE_HTML_REPORT :: 1 << 7;
        TMOF_BREAK_ON_MISMATCHED_ZONE :: 1 << 8;
        TMOF_SEND_ENTER_ZONE_EXPERIMENTAL :: 1 << 9;
        TMOF_SAVE_ALL_CSV :: TMOF_SAVE_PLOTS_CSV | TMOF_SAVE_ZONES_CSV | TMOF_SAVE_TIME_SPANS_CSV | TMOF_SAVE_MESSAGES_CSV;
    };

    tm_connection_type :: enum u32 {
        TMCT_TCP :: 0;
        TMCT_IPC :: 1;
        TMCT_FILE :: 2;
        TMCT_USER_PROVIDED :: 3;
    }

    tm_plot_draw_type :: enum u32 {
        TM_PLOT_DRAW_LINE :: 0;
        TM_PLOT_DRAW_POINTS :: 1;
        TM_PLOT_DRAW_STEPPED_XY :: 2;
        TM_PLOT_DRAW_STEPPED_YX :: 3;
        TM_PLOT_DRAW_COLUMN :: 4;
        TM_PLOT_DRAW_LOLLIPOP :: 5;
    }

    tm_plot_units :: enum u32 {
        TM_PLOT_UNITS_REAL :: 0;
        TM_PLOT_UNITS_MEMORY :: 1;
        TM_PLOT_UNITS_HEX :: 2;
        TM_PLOT_UNITS_INTEGER :: 3;
        TM_PLOT_UNITS_PERCENTAGE_COMPUTED :: 4;
        TM_PLOT_UNITS_PERCENTAGE_DIRECT :: 5;
        TM_PLOT_UNITS_TIME :: 6;
        TM_PLOT_UNITS_TIME_MS :: 7;
        TM_PLOT_UNITS_TIME_US :: 8;
        TM_PLOT_UNITS_TIME_CLOCKS :: 9;
        TM_PLOT_UNITS_TIME_INTERVAL :: 10;
    }

    tm_library_type :: enum u32 {
        TM_RELEASE :: 0;
        TM_DEBUG :: 1;
    }

    TM_API_NYI :: #type () -> void #c_call;

    tm_api :: struct #type_info_none {
        major_version: u32;
        minor_version: u32;
        revision_number: u32;
        build_number: u32;

        tmCheckVersion: (major_version: u32, minor_version: u32, revision_number: u32, build_number: u32) -> tm_error #c_call;
        tmInitialize: (arena_size: u32, arena_address: *u8) -> tm_error #c_call;
        tmOpen: (ctx: u32, program_name: *u8, build_info: *u8, host_or_filename: *u8,
                  connection_type: tm_connection_type, port: u16, open_flags: tm_open_flags, timeout_ms: s32) -> tm_error #c_call;
        tmClose: (ctx: u32) -> void #c_call;
        tmShutdown: () -> void #c_call;
        tmGetThreadHandle: () -> void #c_call;
        tmTick: (mask: u64) -> void #c_call;

        _tmRegisterFileCallbacks: TM_API_NYI;

        tmFlush: () -> void #c_call;

        tmMessage_Core: (mask: u64, flags: u32, filename: *u8, filename_id: *u64, line_number: u32, message: *u8, message_id: *u64) -> void #c_call;
        tmMessageV_Core: (mask: u64, flags: u32, filename: *u8, filename_id: *u64, line_number: u32, fmt: *u8, args: ..Any) -> void #c_call;

        tmString: (static_string: *u8) -> u64 #c_call;
        tmStaticString: (string_id: *u64, static_string: *u8) -> u64 #c_call;
        tmPrintf: (fmt: *u8, args: ..Any) -> u64 #c_call;

        _tmPrintfV: TM_API_NYI;

        tmCallStack: (mask: u64) -> u64 #c_call;
        tmZoneColor: (red: float, green: float, blue: float) -> void #c_call;

        _tmZoneWaitingFor: TM_API_NYI;

        tmEnterZone_Core: (mask: u64, flags: u32, file: *u8, file_id: *u64, line: u32, zone_name: *u8, zone_name_id: *u64) -> void #c_call;
        tmEnterZoneV_Core: (mask: u64, flags: u32, file: *u8, file_id: *u64, line: u32, zone_name: *u8, args: ..Any) -> void #c_call;

        tmLeaveZone: (mask: u64) -> void #c_call;

        _tmRenameZone_Core: TM_API_NYI;
        _tmRenameZoneV_Core: TM_API_NYI;
        _tmZoneAtTime_Core: TM_API_NYI;
        _tmZoneAtTimeV_Core: TM_API_NYI;
        _tmEmitAccumulationZone_Core: TM_API_NYI;
        _tmEmitAccumulationZoneV_Core: TM_API_NYI;
        _tmSetZoneFlag: TM_API_NYI;

        tmSetCaptureMask: (mask: u64) -> void #c_call;
        tmGetCaptureMask: () -> u64 #c_call;

        _tmGetSessionName: TM_API_NYI;
        _tmBeginTimeSpan_Core: TM_API_NYI;
        _tmBeginTimeSpanV_Core: TM_API_NYI;
        _tmEndTimeSpan_Core: TM_API_NYI;
        _tmSetTimeSpanName_Core: TM_API_NYI;
        _tmSetTimeSpanNameV_Core: TM_API_NYI;
        _tmStartWaitForLock_Core: TM_API_NYI;
        _tmStartWaitForLockV_Core: TM_API_NYI;
        _tmEndWaitForLock_Core: TM_API_NYI;
        _tmAcquiredLock_Core: TM_API_NYI;
        _tmAcquiredLockV_Core: TM_API_NYI;
        _tmReleasedLock_Core: TM_API_NYI;

        tmPlot_Core: (mask: u64, units: tm_plot_units, draw_type: tm_plot_draw_type, plot_value: float64, plot_name: *u8, plot_name_id: *u64) -> void #c_call;
        tmPlotAt_Core: (mask: u64, ts: u64, units: tm_plot_units, draw_type: tm_plot_draw_type, plot_value: float64, plot_name: *u8, plot_name_id: *u64) -> void #c_call;
        tmSetPlotInfo: (plot_name: u64, draw_type: tm_plot_draw_type, units: tm_plot_units) -> void #c_call;

        _tmAlloc_Core: TM_API_NYI;
        _tmAllocV_Core: TM_API_NYI;
        _tmFree_Core: TM_API_NYI;

        tmThreadName: (mask: u64, thread_id: u32, fmt: *u8, args: ..Any) -> void #c_call;
        tmEndThread: (mask: u64, thread_id: u32) -> void #c_call;

        tmTrackOrder: (mask: u64, track_id: u32, track_order: u64) -> void #c_call;
        tmTrackColor: (mask: u64, track_id: u32, r: float32, g: float32, b: float32) -> void #c_call;

        tmHash: (str: *u8, len: s32) -> u64 #c_call;
        tmHashString: (str: *u8) -> u64 #c_call;
        tmHash32: (str: *u8, len: s32) -> u32 #c_call;

        _tmSetMaxThreadCount: TM_API_NYI;
        _tmGetMaxThreadCount: TM_API_NYI;
        _tmSetMaxTimeSpanTrackCount: TM_API_NYI;
        _tmGetMaxTimeSpanTrackCount: TM_API_NYI;
        _tmSetSendBufferSize: TM_API_NYI;
        _tmGetSendBufferSize: TM_API_NYI;
        _tmSetSendBufferCount: TM_API_NYI;
        _tmGetSendBufferCount: TM_API_NYI;
        _tmGetMemoryFootprint: TM_API_NYI;

        tmRunning: () -> u32 #c_call;

        _tmSetCompression: TM_API_NYI;
        _tmSetZoneFilterThreshold: TM_API_NYI;

        tmNewTrackID: () -> u32 #c_call;

        tmTrackName: (mask: u64, track_id: u32, fmt: *u8) -> void #c_call;

        _tmThreadTrack: TM_API_NYI;
        _tmSwitchToFiber: TM_API_NYI;
        _tmEndFiber: TM_API_NYI;

        tmEnterZoneFast_Core: (mask: u64, flags: u32, file_id: u64, line: u32, zone_id: u64) -> void #c_call;
        tmGetCurrentThreadId: () -> u64 #c_call;

        _tmZoneColorSticky: TM_API_NYI;
        _tmSwitchToFiberOnTrack: TM_API_NYI;
        _tmGetZoneDepth: TM_API_NYI;

        tmSecondsToTicks: (seconds: float64) -> u64 #c_call;

        _tmBeginColoredTimeSpan_Core: TM_API_NYI;
        _tmBeginColoredTimeSpanV_Core: TM_API_NYI;
        _tmNewTimeSpanTrackID: TM_API_NYI;
        _tmScreenshot: TM_API_NYI;
        _tmTickAtTime: TM_API_NYI;
        _tmContextSwitchAtTime: TM_API_NYI;
        _tmTimeSpanAtTime_Core: TM_API_NYI;
        _tmTimeSpanAtTimeV_Core: TM_API_NYI;
        _tmMessageAtTime_Core: TM_API_NYI;
        _tmMessageAtTimeV_Core: TM_API_NYI;
        _tmMemZoneAtTime: TM_API_NYI;
        _tmAllocAtTime_Core: TM_API_NYI;
        _tmAllocAtTimeV_Core: TM_API_NYI;
        _tmFreeAtTime_Core: TM_API_NYI;

        tmProfileThread: (mask: u64, thread_id: u32, flags: u32) -> void #c_call;
        tmSetSamplingInterval: (microseconds: u32) -> void #c_call;

        tmGpuZone: (zone: *tm_gpu_zone, track: u32,
                     gpu_enter: u64, gpu_leave: u64, cpu_time: u64, fast_time: u64,
                     gpu_begin: u64, cpu_begin: u64, fast_begin: u64,
                     gpu_freq: u64, cpu_freq: u64) -> void #c_call;

        _tmBitmapRGB: TM_API_NYI;
        _tmBitmapPlanes: TM_API_NYI;
        _tmBitmapStart: TM_API_NYI;
        _tmBitmapEnd: TM_API_NYI;
        _tmBitmapSendRGB: TM_API_NYI;
        _tmBitmapSendPlane: TM_API_NYI;
        _tmSetThreadStackSize: TM_API_NYI;
        _tmGetThreadStackSize: TM_API_NYI;
        _tmSetMaxTweakCount: TM_API_NYI;
        _tmGetMaxTweakCount: TM_API_NYI;
        _tmTweakVar_Core: TM_API_NYI;
        _tmRegisterTweakCallback: TM_API_NYI;

        _tmGetZoneIDPtr: TM_API_NYI;
        _tmDependsOnPtr: TM_API_NYI;
        _tmAddDependencyPtr: TM_API_NYI;

        connected: s32;
        error: tm_error;
    }


    #scope_file
    TM_ARENA_BYTES :: 64 * 1024 * 1024;
    tm_arena_allocation: *u8;
    // Genuine SDK entry point; the returned 2022.05.23.51766 API table is version checked.
    native_get_api :: (api: *tm_api) -> *tm_api #foreign tm_sdk "tmGetApi";
    tm_sdk :: #system_library "rad_tm_win64";
}
