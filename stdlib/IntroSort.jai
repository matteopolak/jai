// Introspective sort: quicksort that falls back to heap sort past a recursion budget,
// finished by insertion sort on short ranges. `f(a, b)` is negative when `a` sorts first.

intro_sort :: (array: [] $T, f: (T, T) -> int) {
    if array.count < 2 return;
    depth := 0;
    n := array.count;
    while n > 1 { depth += 2; n >>= 1; }
    introsort_range(array, 0, array.count, depth, f);
    insertion_sort_range(array, 0, array.count, f);
}

insertion_sort :: (array: [] $T, f: (T, T) -> int) {
    insertion_sort_range(array, 0, array.count, f);
}

#scope_file

// Ranges at most this long are left for the final insertion sort.
SMALL_RANGE :: 16;

introsort_range :: (array: [] $T, begin: int, end: int, depth: int, f: (T, T) -> int) {
    lo := begin;
    hi := end;
    budget := depth;
    while hi - lo > SMALL_RANGE {
        if budget == 0 {
            heap_sort_range(array, lo, hi, f);
            return;
        }
        budget -= 1;
        p := partition(array, lo, hi, f);
        // Recurse into the smaller side, loop on the larger one.
        if p - lo < hi - p {
            introsort_range(array, lo, p, budget, f);
            lo = p;
        } else {
            introsort_range(array, p, hi, budget, f);
            hi = p;
        }
    }
}

// Hoare partition around the median of three; returns the split point.
partition :: (array: [] $T, lo: int, hi: int, f: (T, T) -> int) -> int {
    mid := lo + (hi - lo) / 2;
    last := hi - 1;
    if f(array[mid], array[lo])   < 0  swap_items(array, mid, lo);
    if f(array[last], array[lo])  < 0  swap_items(array, last, lo);
    if f(array[last], array[mid]) < 0  swap_items(array, last, mid);
    pivot := array[mid];
    i := lo - 1;
    j := hi;
    while true {
        i += 1;
        while f(array[i], pivot) < 0  i += 1;
        j -= 1;
        while f(pivot, array[j]) < 0  j -= 1;
        if i >= j return j + 1;
        swap_items(array, i, j);
    }
    return lo;
}

heap_sort_range :: (array: [] $T, begin: int, end: int, f: (T, T) -> int) {
    count := end - begin;
    root := count / 2;
    while root > 0 {
        root -= 1;
        sift_down(array, begin, root, count, f);
    }
    last := count;
    while last > 1 {
        last -= 1;
        swap_items(array, begin, begin + last);
        sift_down(array, begin, 0, last, f);
    }
}

sift_down :: (array: [] $T, base: int, start: int, count: int, f: (T, T) -> int) {
    root := start;
    while root * 2 + 1 < count {
        child := root * 2 + 1;
        if child + 1 < count && f(array[base + child], array[base + child + 1]) < 0  child += 1;
        if f(array[base + root], array[base + child]) >= 0 return;
        swap_items(array, base + root, base + child);
        root = child;
    }
}

insertion_sort_range :: (array: [] $T, begin: int, end: int, f: (T, T) -> int) {
    for i: begin + 1 .. end - 1 {
        value := array[i];
        j := i;
        while j > begin && f(value, array[j - 1]) < 0 {
            array[j] = array[j - 1];
            j -= 1;
        }
        array[j] = value;
    }
}

swap_items :: inline (array: [] $T, a: int, b: int) {
    t := array[a];
    array[a] = array[b];
    array[b] = t;
}
