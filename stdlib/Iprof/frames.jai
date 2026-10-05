// Frame boundaries: update() turns the tick counts gathered since the previous call into per-frame
// samples, smooths them, and (with DO_HISTORY) appends them to each zone's history ring.

// Smoothing levels, picked with set_smoothing(): 0 shows the latest frame alone, 1 a fast moving
// average (about 5 frames), 2 a slow one (about 50 frames).
SMOOTHING_LEVELS :: 3;

paused := false;          // While set, update() still closes frames but records nothing.
display_frame: s64;       // 0 = live values; n > 0 = the frame n frames ago (needs DO_HISTORY).
frames_recorded: s64;     // Frames folded in so far.

// Call once per frame. With record_data == false the frame's measurements are dropped
// (for example while loading); the call tree is kept either way.
update :: (record_data: bool) {
    if !live  return;
    busy = true;
    defer busy = false;

    charge_open_nodes(clock_ticks());

    if record_data && !paused {
        for every_node  fold_frame_into(it);
        #if DO_HISTORY  append_history(frames_recorded % NUM_FRAME_SLOTS);
        frames_recorded += 1;
    }

    for every_node {
        it.frame_hier  = 0;
        it.frame_child = 0;
        it.frame_calls = 0;
    }
}

set_smoothing :: (level: s64) {
    smoothing_level = clamp(level, 0, SMOOTHING_LEVELS - 1);
}

// Show the frame `frames_ago` frames back (0 = live). Clamped to the history that exists.
set_frame :: (frames_ago: s64) {
    #if DO_HISTORY {
        oldest := min(frames_recorded, NUM_FRAME_SLOTS) - 1;
        display_frame = clamp(frames_ago, 0, max(oldest, 0));
    }
}

move_frame :: (delta: s64) {
    set_frame(display_frame + delta);
}

#scope_module

smoothing_level := 1;

// Zones still open at the frame boundary have run part of this frame; book that part now and
// restart their stopwatch so the rest lands in the next frame.
charge_open_nodes :: (now: s64) {
    node := current;
    while node {
        part := now - node.opened_at;
        node.frame_hier += part;
        if node.parent  node.parent.frame_child += part;
        node.opened_at = now;
        node = node.parent;
    }
}

frame_sample :: (node: *Call_Node) -> Sample64 {
    s: Sample64;
    s.hier_ms = cast(float64) node.frame_hier / TICKS_PER_MS;
    s.self_ms = cast(float64) (node.frame_hier - node.frame_child) / TICKS_PER_MS;
    s.calls   = cast(float64) node.frame_calls;
    return s;
}

// Weight of the newest frame in each smoothing level's exponential moving average.
level_weight :: (level: s64) -> float64 {
    if level == 0  return 1;
    if level == 1  return 0.2;
    return 0.02;
}

fold_frame_into :: (node: *Call_Node) {
    fresh := frame_sample(node);
    for level: 0..SMOOTHING_LEVELS-1 {
        avg := *node.smooth[level];
        if !node.has_samples {
            avg.* = fresh;  // Start at the first value rather than ramping up from zero.
            continue;
        }
        w := level_weight(level);
        avg.self_ms += (fresh.self_ms - avg.self_ms) * w;
        avg.hier_ms += (fresh.hier_ms - avg.hier_ms) * w;
        avg.calls   += (fresh.calls   - avg.calls)   * w;
    }
    node.has_samples = true;
}

// Adds up a zone's nodes. Hierarchical time only comes from outermost nodes, so a recursive zone
// is not charged once per level.
sum_zone_nodes :: (level: s64) {
    for every_node  it.zone.shown = .{};
    for every_node {
        v := *it.smooth[level];
        z := *it.zone.shown;
        z.self_ms += v.self_ms;
        z.calls   += v.calls;
        if it.outermost  z.hier_ms += v.hier_ms;
    }
}

#if DO_HISTORY {
    append_history :: (slot: s64) {
        sum_zone_nodes(0);  // Level 0 was just set to this frame's raw values.
        for every_node {
            z := it.zone;
            h := *z.history[slot];
            h.self_ms = cast(float32) z.shown.self_ms;
            h.hier_ms = cast(float32) z.shown.hier_ms;
            h.calls   = cast(float32) z.shown.calls;
        }
    }

    // Index into Zone.history of the frame `frames_ago` back from the newest.
    history_slot :: (frames_ago: s64) -> s64 {
        newest := frames_recorded - 1;
        return (newest - frames_ago + NUM_FRAME_SLOTS * 2) % NUM_FRAME_SLOTS;
    }
}

#import "Basic";
#import "Math";
