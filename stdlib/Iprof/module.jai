// Iprof: a frame-based, instrumenting profiler (after Sean Barrett's iprof).
//
// Two ways to import it:
//   IMPORT_MODE == .METAPROGRAM (default): imported by a metaprogram. Provides get_plugin() which
//       instruments the target program's procedures and injects `__Iprof :: #import "Iprof"(IMPORT_MODE=.CLIENT)`.
//   IMPORT_MODE == .CLIENT: imported by the program being profiled. Provides the runtime (zones, update,
//       create_report, log_text_report, ...), and with USE_GRAPHICS the renderer-agnostic drawing code.
//
// MANUAL_MODE == true: you call zone_begin(index) / zone_end() yourself and fill in `zones`.
// DO_HISTORY keeps per-frame histories for graphing.
#module_parameters(IMPORT_MODE := Import_Mode.METAPROGRAM, MANUAL_MODE := false, USE_GRAPHICS := true, DO_HISTORY := true) {
    Import_Mode :: enum u8 {
        METAPROGRAM :: 0;
        CLIENT      :: 1;
    }
};

IMPORT_MODE_IS_CLIENT :: IMPORT_MODE == .CLIENT;

#if !IMPORT_MODE_IS_CLIENT {
    #load "instrument.jai";
    #load "options.jai";
} else {
    #load "runtime.jai";
    #load "reports.jai";
}
