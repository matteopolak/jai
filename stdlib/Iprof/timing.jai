// Zones, the call tree they form at runtime, and the begin/end hooks.
//
// Every distinct path of zones from the root gets one Call_Node. A node only counts ticks for the
// frame in progress; frames.jai folds those counts into smoothed values once per update().

NUM_FRAME_SLOTS :: 128;                        // Frames of per-zone history kept for graphs and set_frame().
MAX_PROFILING_ZONES_FOR_MANUAL_MODE :: 2048;   // Size of `zones` when MANUAL_MODE is on.
MAX_AUTOMATIC_ZONES :: 8192;                   // Instrumented procedures beyond this many are not measured.

Zone :: struct {
    name:      string;
    hash:      u64;     // Stable identity of the zone; automatic zones hash their name and file.
    filename:  string;  // Last path component of full_path.
    full_path: string;
    line:      s64;

    // Runtime state; leave these alone.
    entered:   bool;        // Ran at least once. Reports list only entered zones.
    last_node: *Call_Node;  // The node this zone used last time; usually the right one again.
    shown:     Sample64;    // Values picked by the last create_report() (or update(), for the graph).
    heat:      float64;     // 0..1, how far the latest frame strays from the long-run average.
    #if DO_HISTORY {
        history: [NUM_FRAME_SLOTS] Frame_Sample;  // Ring buffer indexed by frame number.
    }
}

#if MANUAL_MODE {
    zones: [MAX_PROFILING_ZONES_FOR_MANUAL_MODE] Zone;
} else {
    zones: [] Zone;  // Grows as instrumented procedures first run; its storage never moves.
}

Sample64 :: struct {
    self_ms: float64;
    hier_ms: float64;
    calls:   float64;
}

Frame_Sample :: struct {
    self_ms: float32;
    hier_ms: float32;
    calls:   float32;
}

Call_Node :: struct {
    zone:         *Zone;
    parent:       *Call_Node;
    first_child:  *Call_Node;
    next_sibling: *Call_Node;

    depth:     s32;
    nested:    s32;   // Open re-entries folded into this node (direct recursion, or the depth limit).
    outermost: bool;  // No ancestor has the same zone, so hierarchical time here is not counted twice.
    has_samples: bool;

    opened_at:   s64;  // Clock value at entry, moved forward when update() charges an open node.
    frame_hier:  s64;  // Ticks inside this node during the current frame, children included.
    frame_child: s64;  // Of frame_hier, ticks spent in child nodes.
    frame_calls: s64;

    smooth: [SMOOTHING_LEVELS] Sample64;
}

// Start measuring zone `zone_index` (an index into `zones`). Pair every call with zone_end().
zone_begin :: (zone_index: s64) {
    if !may_measure(zone_index)  return;
    push_zone(zone_index);
}

zone_end :: () {
    if !live || busy || context.thread_index != owner_thread  return;
    pop_zone();
}

// Inserted at the top of every procedure the plugin instruments; the zone describes itself the
// first time it runs. It tolerates being reached before init_runtime() (procedures run by #run at
// compile time) and from the profiler's own code.
Automatic_Zone :: (index: s64, name: string, full_path: string, line: s64) #expand {
    zone_was_opened := claim_zone(index, name, full_path, line);
    if zone_was_opened  push_zone(index);
    `defer if zone_was_opened  pop_zone();
}

// Every automatic zone already checks whether it may measure, so the two hooks are the same.
Automatic_Zone_Guarded :: Automatic_Zone;

// Inserted at the top of the instrumented entry point: starts the runtime and, when the entry point
// returns, closes the frame and logs (and optionally saves) a report.
Prepend_To_Main :: (csv_filename: string) #expand {
    init_runtime();
    `defer write_exit_report(csv_filename);
}

// Call once before measuring. In MANUAL_MODE, name `zones[0]` and the zones you use first.
init_runtime :: () {
    if live  return;
    #if !MANUAL_MODE {
        if !zones.count {
            zones.data  = cast(*Zone) alloc(MAX_AUTOMATIC_ZONES * size_of(Zone));
            zones.count = 1;
            memset(zones.data, 0, MAX_AUTOMATIC_ZONES * size_of(Zone));
            zones[0].name = "(global)";
        }
    }

    node_allocator = context.allocator;
    owner_thread   = context.thread_index;

    root_zone := *zones[0];
    if !root_zone.name  root_zone.name = "(root)";
    root_zone.entered = true;

    root = .{};
    root.zone      = root_zone;
    root.outermost = true;
    root.opened_at = clock_ticks();
    current = *root;
    every_node.allocator = node_allocator;
    array_add(*every_node, *root);

    live = true;
}

#scope_module

MAX_CALL_DEPTH :: 64;  // Deeper (mutually recursive) entries are charged to the node at this depth.

root:    Call_Node;
current: *Call_Node;
every_node: [..] *Call_Node;  // Root first, then in creation order.

live := false;   // init_runtime() has run.
busy := false;   // Profiler code is running; instrumented code it calls is not measured.
owner_thread: u32;
node_allocator: Allocator;

#if !MANUAL_MODE {
    claim_zone :: (index: s64, name: string, full_path: string, line: s64) -> bool {
        if !live || busy || context.thread_index != owner_thread || index <= 0 || index >= MAX_AUTOMATIC_ZONES  return false;
        if index >= zones.count  zones.count = index + 1;  // The block is preallocated and zeroed.
        z := *zones[index];
        if !z.name {
            z.name      = name;
            z.full_path = full_path;
            z.filename  = last_path_component(full_path);
            z.line      = line;
            z.hash      = fnv1a(name, fnv1a(full_path, FNV_OFFSET));
        }
        return true;
    }
} else {
    claim_zone :: (index: s64, name: string, full_path: string, line: s64) -> bool {
        return may_measure(index);
    }
}

may_measure :: inline (zone_index: s64) -> bool {
    return live && !busy && context.thread_index == owner_thread && zone_index >= 0 && zone_index < zones.count;
}

// push_zone and pop_zone hold `busy` so that instrumented module code they call (the clock, the
// allocator) does not re-enter them.
push_zone :: (zone_index: s64) {
    busy = true;
    defer busy = false;

    zone := *zones[zone_index];
    if zone == current.zone || current.depth >= MAX_CALL_DEPTH {
        current.nested += 1;
        if zone == current.zone  current.frame_calls += 1;
        return;
    }

    node := zone.last_node;
    if !node || node.parent != current  node = child_for(current, zone);
    zone.last_node = node;

    node.frame_calls += 1;
    current = node;
    node.opened_at = clock_ticks();  // Read last, so the bookkeeping above is not charged to the zone.
}

pop_zone :: () {
    busy = true;
    defer busy = false;

    stop := clock_ticks();
    node := current;
    if node.nested > 0 {
        node.nested -= 1;
        return;
    }
    if !node.parent  return;  // More ends than begins; ignore the extra one.

    spent := stop - node.opened_at;
    node.frame_hier += spent;
    node.parent.frame_child += spent;
    current = node.parent;
}

child_for :: (parent: *Call_Node, zone: *Zone) -> *Call_Node {
    child := parent.first_child;
    while child {
        if child.zone == zone  return child;
        child = child.next_sibling;
    }

    // A new path.
    child = New(Call_Node, allocator = node_allocator);
    child.zone   = zone;
    child.parent = parent;
    child.depth  = parent.depth + 1;
    child.next_sibling = parent.first_child;
    parent.first_child = child;

    child.outermost = true;
    above := parent;
    while above {
        if above.zone == zone  { child.outermost = false; break; }
        above = above.parent;
    }

    zone.entered = true;
    array_add(*every_node, child);
    return child;
}

// Nanoseconds from a monotonic clock.
clock_ticks :: inline () -> s64 {
    ns := to_nanoseconds(current_time_monotonic());
    return ns;
}

TICKS_PER_MS :: 1_000_000.0;

FNV_OFFSET :: 0xcbf2_9ce4_8422_2325;

fnv1a :: (s: string, h: u64) -> u64 {
    for 0..s.count-1 {
        h ^= s[it];
        h *= 0x100_0000_01b3;
    }
    return h;
}

last_path_component :: (path: string) -> string {
    start := 0;
    for 0..path.count-1  if path[it] == #char "/" || path[it] == #char "\\"  start = it + 1;
    result := path;
    result.data  += start;
    result.count -= start;
    return result;
}

#import "Basic";
