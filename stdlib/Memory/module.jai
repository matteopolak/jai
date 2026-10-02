// Independent portable implementation. copy has memmove semantics.
#module_parameters(with_candidates := false, with_unwraps := false);
#assert(!with_candidates && !with_unwraps, "supplementary copier experiments are not implemented");

copy :: (destination: *void, source: *void, count: s64) {
    if count <= 0 || destination == source return;
    dst := cast(*u8) destination;
    src := cast(*u8) source;
    // Equality is meaningful for native and provenance-carrying VM pointers.
    // Scan offsets instead of turning addresses into portable integer data.
    overlaps_after := false;
    overlaps_before := false;
    probe: s64 = 1;
    while probe < count {
        if dst == src + probe overlaps_after = true;
        if src == dst + probe overlaps_before = true;
        if overlaps_after || overlaps_before break;
        probe += 1;
    }
    if !overlaps_after && !overlaps_before {
        memcpy(destination, source, count);
        return;
    }
    if overlaps_after {
        offset := count;
        while offset > 0 {
            offset -= 1;
            dst[offset] = src[offset];
        }
    } else {
        offset: s64 = 0;
        while offset < count {
            dst[offset] = src[offset];
            offset += 1;
        }
    }
}
