// Sorting with the standard entry points: bubble_sort, quick_sort (by comparator or by
// key) and the comparators compare_floats / compare_strings. quick_sort sorts in place
// and returns the same array; it is not stable.

bubble_sort :: (array: [] $T, f: (T, T) -> s64) {
    remaining := array.count;
    while remaining > 1 {
        last_swap := 0;
        for i: 1..remaining - 1 {
            if f(array[i - 1], array[i]) > 0 {
                swap_items(array.data + i - 1, array.data + i);
                last_swap = i;
            }
        }
        remaining = last_swap;
    }
}

// `f(a, b)` is negative when a sorts before b, positive when after (any integer type).
quick_sort :: (array: [] $T, f: (T, T) -> $R) -> [] T {
    sort_range :: (data: *T, count: s64, f: (T, T) -> R) {
        while count > SMALL_RANGE {
            pivot := median_of_three(data, count, f);
            low, high := 0, count - 1;
            while low <= high {
                while f(data[low], pivot) < 0 low += 1;
                while f(data[high], pivot) > 0 high -= 1;
                if low <= high {
                    swap_items(data + low, data + high);
                    low += 1;
                    high -= 1;
                }
            }
            // Recurse into the smaller side, loop on the larger one.
            if high + 1 < count - low {
                sort_range(data, high + 1, f);
                data += low;
                count -= low;
            } else {
                sort_range(data + low, count - low, f);
                count = high + 1;
            }
        }
        for i: 1..count - 1 {
            value := data[i];
            j := i;
            while j > 0 && f(value, data[j - 1]) < 0 {
                data[j] = data[j - 1];
                j -= 1;
            }
            data[j] = value;
        }
    }

    median_of_three :: (data: *T, count: s64, f: (T, T) -> R) -> T {
        a, b, c := data[0], data[count / 2], data[count - 1];
        if f(b, a) < 0 swap_items(*a, *b);
        if f(c, b) < 0 swap_items(*b, *c);
        if f(b, a) < 0 swap_items(*a, *b);
        return b;
    }

    if array.count > 1 sort_range(array.data, array.count, f);
    return array;
}

// Sorts by the key `f(item)`, smallest first.
quick_sort :: (array: [] $T, f: (T) -> $R) -> [] T {
    sort_range :: (data: *T, count: s64, f: (T) -> R) {
        while count > SMALL_RANGE {
            a, b, c := f(data[0]), f(data[count / 2]), f(data[count - 1]);
            pivot := ifx a < b then (ifx b < c then b else ifx a < c then c else a)
                           else (ifx a < c then a else ifx b < c then c else b);
            low, high := 0, count - 1;
            while low <= high {
                while f(data[low]) < pivot low += 1;
                while pivot < f(data[high]) high -= 1;
                if low <= high {
                    swap_items(data + low, data + high);
                    low += 1;
                    high -= 1;
                }
            }
            if high + 1 < count - low {
                sort_range(data, high + 1, f);
                data += low;
                count -= low;
            } else {
                sort_range(data + low, count - low, f);
                count = high + 1;
            }
        }
        for i: 1..count - 1 {
            value := data[i];
            key := f(value);
            j := i;
            while j > 0 && key < f(data[j - 1]) {
                data[j] = data[j - 1];
                j -= 1;
            }
            data[j] = value;
        }
    }

    if array.count > 1 sort_range(array.data, array.count, f);
    return array;
}

compare_floats :: (a: float, b: float) -> s64 {
    if a < b return -1;
    if a > b return 1;
    return 0;
}

// Byte-wise ordering; a prefix sorts first.
compare_strings :: (a: string, b: string) -> s64 {
    for i: 0..min(a.count, b.count) - 1 {
        if a[i] != b[i] return ifx a[i] < b[i] then -1 else 1;
    }
    return a.count - b.count;
}

#scope_file

SMALL_RANGE :: 12;

swap_items :: inline (a: *$T, b: *T) {
    t := a.*;
    a.* = b.*;
    b.* = t;
}

min :: inline (a: s64, b: s64) -> s64 {
    return ifx a < b then a else b;
}
