// Iprof: an instrumenting profiler that measures per-frame time spent in "zones" (usually procedures).
//
// The module has two halves, picked with IMPORT_MODE:
//   .METAPROGRAM (default)  get_plugin() returns a Metaprogram_Plugin that wraps the target program's
//                           procedures in zones and prints a report when `main` returns.
//   .CLIENT                 the runtime: zone_begin/zone_end, update(), create_report(), the text/CSV
//                           writers and, with USE_GRAPHICS, a renderer-agnostic overlay (draw, draw_graph).
//
// MANUAL_MODE: no metaprogram. Name the entries of `zones` yourself, call init_runtime(), and bracket code
//              with zone_begin(index) / zone_end(). Index 0 is the root ("everything outside a zone").
// DO_HISTORY:  keep the last NUM_FRAME_SLOTS frames per zone (needed by draw_graph and set_frame).
#module_parameters(IMPORT_MODE := Import_Mode.METAPROGRAM, MANUAL_MODE := false, USE_GRAPHICS := true, DO_HISTORY := true) {
    Import_Mode :: enum u8 {
        METAPROGRAM :: 0;
        CLIENT      :: 1;
    }
};

#if IMPORT_MODE == .CLIENT {
    #load "timing.jai";
    #load "frames.jai";
    #load "report.jai";
    #if USE_GRAPHICS  #load "overlay.jai";
} else {
    #load "plugin.jai";
}
