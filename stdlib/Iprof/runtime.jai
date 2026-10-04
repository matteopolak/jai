// Iprof runtime (IMPORT_MODE == .CLIENT): zone bookkeeping, per-frame update, report generation.
//
// Every distinct (zone, parent-zone-stack) pair gets a Zone_Profiling_Data node. Nodes live in an
// open-addressed hash table keyed by (zone hash + parent pointer). Each zone-index also has a one-entry
// cache so the common "same call path as last time" case never touches the hash table.

MAX_DEPTH :: 100;

MAX_HASH_SIZE  :: 65536;  // Bounded so unbalanced zone_begin/zone_end shows up as a failed assert.
INIT_HASH_SIZE :: 256;    // Must be a power of two.

zone_hash: [..] *Zone_Profiling_Data;

zone_hash_count: s64 = 0;
zone_hash_mask:  u64 = 0;

// Not file-scoped, because renderers that sit next to Iprof want to see them.
displayed_quantity := Report_Mode.SELF_TIME;
history_index      : s64;
display_frame      : s64;
update_cursor      := false;

#if MANUAL_MODE {
    zones: [MAX_PROFILING_ZONES_FOR_MANUAL_MODE] Zone;
} else {
    zones: [] Zone;  // Allocated by init_runtime() once AUTO_INSTRUMENT_ZONE_COUNT is known.
}

caches: [] *Zone_Profiling_Data;  // One slot per zone index; allocated by init_runtime().

#if DO_HISTORY {
    Zone_History :: struct {
        values: [NUM_FRAME_SLOTS] float32;
    }
}

#scope_module
expanded_zone: *Zone;
zone_selected: *Zone;

#scope_export

Zone :: struct {
    name: string;
    hash: u64;  // Hash of the name; for auto-instrumentation this is computed at compile time.

    filename:  string;
    full_path: string;
    line:      s64;

    highlevel: *Report_Row;

    #if DO_HISTORY {
        history_self:  Zone_History;
        history_hier:  Zone_History;
        history_calls: Zone_History;
    }

    visited := false;
    initted := false;
}

Zone_Profiling_Data :: struct {
    t_self_start:     s64;
    total_self_ticks: s64;
    total_hier_ticks: s64;

    total_entry_count: u32;

    parent: *Zone_Profiling_Data;
    zone:   *Zone;
    recursion_depth: s32;
    profile_tracker_data_record: *Profile_Tracker_Data_Record;
}

stack:  *Zone_Profiling_Data;  // The currently executing zone stack.
dummy:   Zone_Profiling_Data;  // Sentinel for empty hash slots / cache entries; its parent never matches.
dummy2:  Zone_Profiling_Data;  // Sentinel for the bottom of the stack.

zone_begin :: inline (zone_index: s64) #expand {
    if !zones.count return;  // Instrumented code can run at compile time before init_runtime().
    z := *zones[zone_index];
    cache := caches[zone_index];

    if cache.parent != stack {
        cache = Stack_Push(z);
        caches[zone_index] = cache;
    }

    cache.total_entry_count += 1;
    ticks := read_timestamp();

    // Charge the elapsed time to the zone we are leaving.
    stack.total_self_ticks += ticks - stack.t_self_start;

    stack = cache;
    stack.t_self_start = ticks;
}

zone_end :: inline () {
    if !stack return;  // zone_begin() may have bailed.

    ticks := read_timestamp();
    stack.total_self_ticks += ticks - stack.t_self_start;

    stack = stack.parent;
    stack.t_self_start = ticks;
}

NUM_VALUES :: 4;
NUM_TITLE  :: 2;
NUM_HEADER :: NUM_VALUES+1;

Report_Row :: struct {
    indent:     s64;
    name:       string;
    number:     s64;
    prefix:     u8;
    value_flag: s64;

    self_time:  float64;
    hier_time:  float64;
    calls:      float64;

    #place self_time;
    array_aliased_values: [3] float64 = ---;  // Aliases self_time, hier_time, calls, for indexed access.

    heat:       float64;

    zone: *Zone;  // Internal.
}

Report :: struct {
    title:       string;
    title_right: string;

    header: [NUM_HEADER] string;

    hilit_header: s32 = 0;

    records: [..] Report_Row;
    hilight: s64;
}

Report_Mode :: enum u8 {
    SELF_TIME;
    HIERARCHICAL_TIME;
    CALL_COUNT;

    CALL_GRAPH;
}

NUM_FRAME_SLOTS :: 128;  // Frames of history kept.

MAX_PROFILING_ZONES_FOR_MANUAL_MODE :: 2048;

// Number of moving averages.
NUM_SMOOTHING_SLOTS :: 3;

// Frames ignored before the moving averages start.
NUM_THROWAWAY_UPDATES :: 3;

// A moving average of a count below this is treated as zero.
INT_ZERO_THRESHHOLD :: 0.25;

Prof_init_highlevel :: () {
    update_index = 0;
    last_update_time = 0;

    times_to_reach_90_percent[0] = 0.1;
    times_to_reach_90_percent[1] = 0.8;
    times_to_reach_90_percent[2] = 2.5;

    clear(*frame_time);
    for 0..NUM_SMOOTHING_SLOTS-1  frame_time.values[it] = FRAME_TIME_INITIAL;
}

set_report_mode :: (desired: Report_Mode) {
    displayed_quantity = desired;
}

// Call once per frame. record_data == false only resets the per-frame counters.
update :: (record_data: bool) {
    #if MANUAL_MODE  assert(zones.count <= MAX_PROFILING_ZONES_FOR_MANUAL_MODE);

    traverse(propagate_stack);

    now := seconds_since_init();
    dt: float64;
    if update_index == 0 {
        dt = FRAME_TIME_INITIAL;
    } else {
        dt = now - last_update_time;
        if dt == 0  dt = FRAME_TIME_INITIAL;
    }
    last_update_time = now;

    // Smoothing factor for each moving average: 0.1 ^ (dt / time-to-reach-90%).
    for * p, i: precomputed_factors  p.* = pow(0.1, dt / times_to_reach_90_percent[i]);
    precomputed_factors[0] = 0;  // slot 0 is the instantaneous value

    current_timestamp := read_timestamp();

    timestamp_delta: s64;
    if update_index == 0 {
        prof_sum = 0;
        traverse(sum_times);
        if prof_sum == 0  prof_sum = 1;
        timestamp_delta = prof_sum;
    } else {
        timestamp_delta = current_timestamp - last_integer_timestamp;
        if timestamp_delta == 0  timestamp_delta = 1;
    }
    last_integer_timestamp = current_timestamp;

    timestamps_per_second := cast(float64) timestamp_delta / dt;

    if update_index < NUM_THROWAWAY_UPDATES {
        eternity_set(*integer_timestamps_per_second, timestamps_per_second);
    } else {
        update(*integer_timestamps_per_second, timestamps_per_second, precomputed_factors);
    }

    {
        // A noisy timestamp rate suggests CPU frequency scaling.
        ss_slot :: 1;
        ss_val      := integer_timestamps_per_second.values[ss_slot];
        ss_variance := integer_timestamps_per_second.variances[ss_slot] - ss_val*ss_val;
        ss_stdev    := sqrt(abs(ss_variance));

        ss_ratio: float64;
        if ss_val  ss_ratio = ss_stdev / abs(ss_val);
        speedstep_warning = ss_ratio > SPEEDSTEP_DETECTION_RATIO;
    }

    if timestamps_per_second  timestamps_to_seconds = 1.0 / timestamps_per_second;
    else                      timestamps_to_seconds = 0;

    defer traverse(clear_stack);

    if !record_data return;

    #if DO_HISTORY {
        for * zones {
            it.history_self.values[history_index]  = 0;
            it.history_hier.values[history_index]  = 0;
            it.history_calls.values[history_index] = 0;
        }
        traverse(update_history);
    }

    update(*frame_time, dt, precomputed_factors);
    update_index += 1;

    #if DO_HISTORY  history_index = (history_index + 1) % NUM_FRAME_SLOTS;
}

// The report (and its records) is allocated with the temporary allocator.
create_report :: () -> *Report {
    s: s64 = 1;
    if displayed_quantity == .CALL_GRAPH  s = 3;  // three rows per zone: callers, itself, callees

    num_records := zones.count * s;

    report := New(Report,, __temporary_allocator);
    report.records.allocator = __temporary_allocator;
    array_resize(*report.records, num_records, true);

    for * z, i: zones {
        r := *report.records[i*s];
        z.highlevel = r;

        if displayed_quantity == .CALL_GRAPH {
            for k: 0..2 {
                r[k].name       = z.name;
                r[k].value_flag = 1 | 2 | 4;
                r[k].zone       = z;
                r[k].prefix     = 0;
            }
            r[0].indent = 3;
            r[1].indent = 5;
            r[2].indent = 0;
        } else {
            r.value_flag = 1 | 2 | 4;
            r.name   = z.name;
            r.zone   = z;
            r.indent = 0;
            r.prefix = 0;
        }
    }

    avg_frame_time := frame_time.values[slot];
    if avg_frame_time == 0  avg_frame_time = 0.01;
    fps := 1 / avg_frame_time;

    report.title = tprint("% ms/frame (fps: %)  ",
                          formatFloat(avg_frame_time * 1000, 3, trailing_width=3),
                          formatFloat(fps, 2, trailing_width=3));

    if display_frame {
        suffix := "";
        if display_frame > 1  suffix = "s";
        report.title_right = tprint("% frame% ago", display_frame, suffix);
    } else {
        report.title_right = "current frame";
    }

    if displayed_quantity == .CALL_GRAPH {
        r := expanded_zone.highlevel;

        traverse(propagate_expanded);
        r[2].prefix = #char "-";

        // Drop everything that was never called.
        kept: s64 = 0;
        for report.records {
            if it.calls {
                report.records[kept] = it;
                kept += 1;
            }
        }
        report.records.count = kept;

        quick_sort(report.records, report_expand_compare);

        for * report.records  if it.indent == 5  it.indent = 3;
    } else {
        traverse(propagate_to_zone);

        heat_index := 0;
        compare := #bake_arguments report_compare_slot(slot = 0);

        if displayed_quantity == .HIERARCHICAL_TIME {
            compare = #bake_arguments report_compare_slot(slot = 1);
            heat_index = 1;
        } else if displayed_quantity == .CALL_COUNT {
            compare = #bake_arguments report_compare_slot(slot = 2);
            heat_index = 2;
        }

        for * report.records  it.heat = compute_heat(it.heat, it.array_aliased_values[heat_index]);

        quick_sort(report.records, compare);
    }

    if update_cursor {
        for * report.records {
            if it.zone == expanded_zone {
                cursor = it_index;
                break;
            }
        }
        update_cursor = false;
    }

    if cursor >= 0 && cursor < report.records.count {
        zone_selected = report.records[cursor].zone;
    }

    report.header[1] = "self";
    report.header[2] = "hier";
    report.header[3] = "count";

    if displayed_quantity == .SELF_TIME              report.hilit_header = 1;
    else if displayed_quantity == .HIERARCHICAL_TIME report.hilit_header = 2;
    else if displayed_quantity == .CALL_COUNT        report.hilit_header = 3;

    if report.records {
        Clamp(*cursor, 0, report.records.count-1);
        report.hilight = cursor;
    }

    return report;
}

// Set while Iprof's own code runs, so guarded zones inside Basic & co. do not recurse into the profiler.
// Starts true so startup work (mutex init, threads) is not profiled.
#add_context already_inside_profiler_runtime := true;

// Written so a hit in the first probed slot is as cheap as possible.
Stack_Push :: (zone: *Zone) -> *Zone_Profiling_Data {
    h := hash(zone, stack);
    x := h & zone_hash_mask;
    z := zone_hash[x];

    if z.parent == stack && z.zone == zone  return z;

    // Below here we may call allocators, which may themselves be instrumented.
    context.already_inside_profiler_runtime = true;
    defer context.already_inside_profiler_runtime = false;

    if z != *dummy #no_aoc {
        // Secondary hash, forced odd so it is coprime with the power-of-two table size.
        step := ((h << 4) + (h >> 4)) | 1;
        while true {
            x = (x + step) & zone_hash_mask;
            z = zone_hash[x];
            if z.parent == stack && z.zone == zone  return z;
            if z == *dummy break;  // terminates: the table is never full
        }
    }

    // Keep the table at most half full.
    if zone_hash_count*2 > zone_hash.allocated {
        old_hash := zone_hash;
        init_zone_hash(zone_hash.allocated*2);

        for old_hash  if it != *dummy  insert_node(it);

        z := createStackNode(zone, stack);
        insert_node(z);

        free(old_hash.data,, zone_hash.allocator);
        return z;
    }

    zone_hash_count += 1;
    result := createStackNode(zone, stack);
    zone_hash[x] = result;
    return result;
}

traverse :: (func: (z: *Zone_Profiling_Data)) {
    for zone_hash  if it != *dummy  func(it);
}

move_cursor :: (num: s64) {
    cursor += num;
}

set_cursor :: (num: s64) {
    cursor = num;
}

// Expand the zone under the cursor into the call-graph view.
select :: () {
    b := create_report();

    if b.hilight < b.records.count {
        z := b.records[b.hilight].zone;
        if z {
            expanded_zone = z;
            displayed_quantity = .CALL_GRAPH;
        }
    }

    update_cursor = true;
}

select_parent :: () {
    old := expanded_zone;
    b := create_report();

    for b.records {
        if it.indent == 0 break;
        if it.zone == old continue;
        expanded_zone = cast(*Zone) it.zone;
    }

    update_cursor = true;
}

set_frame :: (num: s64) {
    Clamp(*num, 0, NUM_FRAME_SLOTS-1);
    display_frame = num;
}

move_frame :: (delta: s64) {
    // Negative delta goes into the past.
    set_frame(display_frame - delta);
}

set_smoothing :: (x: s64) {
    Clamp(*x, 0, NUM_SMOOTHING_SLOTS-1);
    slot = x;
}

init_runtime :: () {
    runtime_allocator = context.allocator;

    init(*stack_node_pool_mutex);

    #if !MANUAL_MODE  zones = NewArray(AUTO_INSTRUMENT_ZONE_COUNT, Zone);
    caches = NewArray(zones.count, *Zone_Profiling_Data);

    for * caches  it.* = *dummy;

    stack = *dummy2;

    ZONE_GLOBAL :: 0;
    global := *zones[ZONE_GLOBAL];
    global.name = "(global)";
    expanded_zone = global;

    zone_hash.allocator = context.allocator;
    init_zone_hash(INIT_HASH_SIZE);
    Prof_init_highlevel();

    context.already_inside_profiler_runtime = false;

    // The global zone is deliberately never ended; it wraps the whole run.
    caches[ZONE_GLOBAL] = *dummy;
    zone_begin(ZONE_GLOBAL);
}

hash :: (z: *Zone, s: *Zone_Profiling_Data) -> u64 {
    return cast(u64) z.hash + cast(u64) s;
}

insert_node :: (q: *Zone_Profiling_Data) #no_aoc {
    h := hash(q.zone, q.parent);
    x := h & zone_hash_mask;
    step := ((h << 4) + (h >> 4)) | 1;

    while zone_hash[x] != *dummy  x = (x + step) & zone_hash_mask;

    zone_hash[x] = q;
    zone_hash_count += 1;
}

count_recursion_depth :: (stack: *Zone_Profiling_Data, zone: *Zone) -> s32 {
    n: s32;
    while stack {
        if stack.zone == zone  n += 1;
        stack = stack.parent;
    }
    return n;
}

createStackNode :: (zone: *Zone, parent: *Zone_Profiling_Data) -> *Zone_Profiling_Data {
    lock(*stack_node_pool_mutex);
    z := New(Zone_Profiling_Data,, runtime_allocator);
    unlock(*stack_node_pool_mutex);

    z.zone = zone;
    z.parent = parent;
    z.recursion_depth = count_recursion_depth(parent, zone);
    return z;
}

init_zone_hash :: (size: s64) {
    assert(size <= MAX_HASH_SIZE);
    zone_hash_count = 0;
    zone_hash_mask  = cast(u64) size - 1;

    // Allocate raw storage (not array_reserve): Stack_Push relies on getting memory distinct from the old table.
    zone_hash.data = alloc(size_of(*Zone_Profiling_Data) * size,, zone_hash.allocator);
    zone_hash.allocated = size;
    zone_hash.count = size;

    for 0..size-1  zone_hash[it] = *dummy;
}

// Tracks one quantity over time: smoothed values, their variances, and a ring of raw samples.
History_Scalar :: struct {
    values:    [NUM_SMOOTHING_SLOTS] float64;
    variances: [NUM_SMOOTHING_SLOTS] float64;

    history: [NUM_FRAME_SLOTS] float;
}

Profile_Tracker_Data_Record :: struct {
    self_time: History_Scalar;
    hierarchical_time: History_Scalar;
    entry_count: History_Scalar;
    max_recursion: s64;
}

frame_time: History_Scalar;

times_to_reach_90_percent: [NUM_SMOOTHING_SLOTS] float64;
precomputed_factors:       [NUM_SMOOTHING_SLOTS] float64;

num_active_zones: s64;
update_index:     s64;
last_update_time: float64;

FRAME_TIME_INITIAL :: 0.001;

slot: s64 = 1;

clear :: (using s: *History_Scalar) {
    for 0..NUM_SMOOTHING_SLOTS-1 {
        values[it] = 0;
        variances[it] = 0;
    }
}

update :: (using s: *History_Scalar, new_value: float64, k_array: [] float64) {
    new_variance := new_value * new_value;

    for 0..NUM_SMOOTHING_SLOTS-1 {
        k := k_array[it];
        values[it]    = values[it]    * k + new_value    * (1 - k);
        variances[it] = variances[it] * k + new_variance * (1 - k);
    }

    history[history_index] = cast(float) new_value;
}

eternity_set :: (using s: *History_Scalar, new_value: float64) {
    new_variance := new_value * new_value;

    for 0..NUM_SMOOTHING_SLOTS-1 {
        values[it] = new_value;
        variances[it] = new_variance;
    }

    history[history_index] = cast(float) new_value;
}

get_value :: (using s: *History_Scalar) -> float64 {
    if display_frame  return history[(history_index - display_frame + NUM_FRAME_SLOTS) % NUM_FRAME_SLOTS];
    return values[slot];
}

propagate_stack :: (c: *Zone_Profiling_Data) {
    // Add self time to every ancestor's hierarchical time, counting each zone once (recursion).
    p := c;
    while p.zone {
        if !p.zone.visited {
            p.total_hier_ticks += c.total_self_ticks;
            p.zone.visited = true;
        }
        p = p.parent;
    }

    p = c;
    while p.zone {
        p.zone.visited = false;
        p = p.parent;
    }
}

clear_stack :: (using c: *Zone_Profiling_Data) {
    total_hier_ticks = 0;
    total_self_ticks = 0;
    total_entry_count = 0;
}

prof_sum: s64;
sum_times :: (c: *Zone_Profiling_Data) {
    prof_sum += c.total_self_ticks;
}

timestamps_to_seconds: float64;

update_history :: (c: *Zone_Profiling_Data) {
    record := c.profile_tracker_data_record;
    z := c.zone;

    if record == null {
        record = New(Profile_Tracker_Data_Record,, runtime_allocator);
        c.profile_tracker_data_record = record;
    }

    if c.recursion_depth > record.max_recursion  record.max_recursion = c.recursion_depth;

    self_time   := cast(float64) c.total_self_ticks * timestamps_to_seconds;
    hier_time   := cast(float64) c.total_hier_ticks * timestamps_to_seconds;
    entry_count := c.total_entry_count;

    if update_index < NUM_THROWAWAY_UPDATES {
        eternity_set(*record.entry_count,       cast(float64) entry_count);
        eternity_set(*record.self_time,         self_time);
        eternity_set(*record.hierarchical_time, hier_time);
    } else {
        update(*record.self_time,         self_time,   precomputed_factors);
        update(*record.hierarchical_time, hier_time,   precomputed_factors);
        update(*record.entry_count,       cast(float64) entry_count, precomputed_factors);
    }

    #if DO_HISTORY {
        z.history_self.values[history_index]  += cast(float) self_time;
        z.history_hier.values[history_index]  += cast(float) hier_time;
        z.history_calls.values[history_index] += cast(float) entry_count;
    }
}

SPEEDSTEP_DETECTION_RATIO : float64 : 0.08;
speedstep_warning: bool;

integer_timestamps_per_second: History_Scalar;
last_integer_timestamp: s64;

propagate_to_zone :: (c: *Zone_Profiling_Data) {
    r := c.zone.highlevel;
    d := c.profile_tracker_data_record;
    if !d return;

    r.self_time += 1000 * get_value(*d.self_time);
    r.hier_time += 1000 * get_value(*d.hierarchical_time);
    r.calls     +=        get_value(*d.entry_count);

    if get_value(*d.entry_count) > INT_ZERO_THRESHHOLD {
        if d.max_recursion > r.number  r.number = d.max_recursion;
        if c.parent.zone  c.parent.zone.highlevel.prefix = #char "+";
    }

    if display_frame return;  // no variance when looking at history

    t: float64;
    if displayed_quantity == .HIERARCHICAL_TIME  t = d.hierarchical_time.variances[slot];
    else                                         t = d.self_time.variances[slot];
    t = 1000 * 1000 * t;

    if r.heat == 0  r.heat = t;
    else            r.heat = r.heat + t + 2 * sqrt(r.heat * t);
}

propagate_expanded :: (c: *Zone_Profiling_Data) {
    d := c.profile_tracker_data_record;
    if d == null return;

    if c.parent.zone && get_value(*d.entry_count) > INT_ZERO_THRESHHOLD {
        rec := c.parent.zone.highlevel;
        rec[0].prefix = #char "+";
        rec[1].prefix = #char "+";
        rec[2].prefix = #char "+";
    }

    if c.zone == expanded_zone {
        r := expanded_zone.highlevel;
        r[2].self_time += 1000 * get_value(*d.self_time);
        r[2].hier_time += 1000 * get_value(*d.hierarchical_time);
        r[2].calls     +=        get_value(*d.entry_count);

        if d.max_recursion > r[2].number && get_value(*d.entry_count) > INT_ZERO_THRESHHOLD
            r[2].number = d.max_recursion;

        // Charge it to the caller as well.
        if c.parent.zone {
            r = c.parent.zone.highlevel;
            r[1].self_time += 1000 * get_value(*d.self_time);
            r[1].hier_time += 1000 * get_value(*d.hierarchical_time);
            r[1].calls     +=        get_value(*d.entry_count);

            d = c.parent.profile_tracker_data_record;
            if d.max_recursion > r[1].number && get_value(*d.entry_count) > INT_ZERO_THRESHHOLD
                r[1].number = d.max_recursion;
        }
    }

    if c.parent.zone == expanded_zone {
        r := c.zone.highlevel;
        r[0].self_time += 1000 * get_value(*d.self_time);
        r[0].hier_time += 1000 * get_value(*d.hierarchical_time);
        r[0].calls     +=        get_value(*d.entry_count);

        if d.max_recursion > r[0].number && get_value(*d.entry_count) > INT_ZERO_THRESHHOLD
            r[0].number = d.max_recursion;
    }
}

compute_heat :: (variance: float64, value: float64) -> float64 {
    VARIANCE_TOLERANCE_FACTOR :: 0.5;

    magnitude := abs(value);
    if magnitude < 0.000001 return 0;

    variance -= value*value;
    if variance < 0  variance = 0;

    factor := (sqrt(variance) / magnitude) * (1.0 / VARIANCE_TOLERANCE_FACTOR);
    Clamp(*factor, 0, 1);
    return factor;
}

report_compare_slot :: (p: Report_Row, q: Report_Row, slot: s64) -> s64 {
    a := p.array_aliased_values[slot];
    b := q.array_aliased_values[slot];

    EPSILON :: 0.001;
    if b < a - EPSILON return -1;
    if b > a + EPSILON return  1;

    delta := p.name.count - q.name.count;
    if delta != 0 return delta;

    return compare_strings(p.name, q.name);  // stable order for equal values, avoids flicker
}

report_expand_compare :: (a: Report_Row, b: Report_Row) -> s64 {
    if a.indent != b.indent {
        if a.indent == 5 return -1;
        if b.indent == 5 return 1;
        if a.indent == 3 return 1;
        if b.indent == 3 return -1;
        return 0;
    }

    if a.hier_time == b.hier_time return 0;

    if a.hier_time < b.hier_time {
        if a.indent == 5 return -1;
        return 1;
    }

    if a.indent == 5 return 1;
    return -1;
}

GraphLocation :: struct {
    x0, y0: float;
    sx, sy: float;
}

cursor: s64;

#scope_export

// Automatic_Zone is what auto-instrumented code calls. It is currently always the guarded flavour, because
// instrumented procedures can also run at compile time (#run) before the profiler is initialized.
#if IMPORT_MODE_IS_CLIENT {
    Automatic_Zone :: Automatic_Zone_Guarded;
} else {
    Automatic_Zone :: (index: s64) #expand {}
}

// Used inside modules like Basic that Iprof itself calls: skips profiling while we are inside the profiler.
Automatic_Zone_Guarded :: (index: s64) #expand {
    already := context.already_inside_profiler_runtime;

    if !already zone_begin(index);
    `defer if !already zone_end();
}

// Injected at the top of main by the instrumenting metaprogram.
Prepend_To_Main :: () #expand {
    init_runtime();

    // Backticked: _init_zone_names is generated into the user's program, not into Iprof.
    `_init_zone_names();

    log("%", "Starting Profiling.\n");
    update(true);  // frame-based profiler: the first update starts the clock

    `defer {
        update(true);

        report := create_report();
        log_text_report(report);

        if CSV_OUTPUT_FILENAME {
            name := CSV_OUTPUT_FILENAME;
            log("\n");
            log("Outputting the profile to csv file '%'.\n", name);
            save_csv_report(report, name);
        }
    }
}

#scope_file

#import "Sort";
#import "Basic";
#import "Math";
#import "Thread";
#import "String";

#if OS == .WINDOWS {
    Windows :: #import "Windows";
} else {
    POSIX :: #import "POSIX";
}

// Monotonic tick source (nanoseconds on POSIX, performance-counter ticks on Windows).
read_timestamp :: inline () -> s64 {
    #if OS == .WINDOWS {
        counter: s64;
        Windows.QueryPerformanceCounter(*counter);
        return counter;
    } else {
        ts: POSIX.timespec;
        POSIX.clock_gettime(.MONOTONIC_RAW, *ts);
        return cast(s64) ts.tv_sec * 1000000000 + cast(s64) ts.tv_nsec;
    }
}

#if !MANUAL_MODE {
    #import "Compiler";

    #scope_module
    #placeholder AUTO_INSTRUMENT_ZONE_COUNT;
    #placeholder CSV_OUTPUT_FILENAME;
}

#scope_file

#if USE_GRAPHICS {
    #load "draw.jai";
}

runtime_allocator: Allocator;

stack_node_pool_mutex: Mutex;
