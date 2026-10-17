quick_sort :: (array: [] $T, f: (T, T) -> $R) -> [] T {
    count := array.count;
    i := count / 2;

    while i > 0 {
        i -= 1;
        sift(array, i, count, f);
    }

    while count > 1 {
        count -= 1;
        swap(array.data, array.data + count);
        sift(array, 0, count, f);
    }

    return array;
}

quick_sort :: (array: [] $T, f: (T) -> $R) -> [] T {
    // The key overload uses insertion sort to avoid capturing a procedure value.
    for i: 1..array.count - 1 {
        value := array[i];
        key := f(value);
        j := i;

        while j > 0 && f(array[j - 1]) > key {
            array[j] = array[j - 1];
            j -= 1;
        }

        array[j] = value;
    }

    return array;
}

// Repeated passes that move each larger element toward the end; stops after a pass without
// exchanges. Stable, and fast only for short or nearly ordered input.
bubble_sort :: (array: [] $T, f: (T, T) -> $R) -> [] T {
    end := array.count;

    while end > 1 {
        last_exchange := 0;

        for i: 1..end - 1 {
            if f(array[i - 1], array[i]) > 0 {
                swap(array.data + i - 1, array.data + i);
                last_exchange = i;
            }
        }

        end = last_exchange;
    }

    return array;
}

bubble_sort :: (array: [] $T, f: (T) -> $R) -> [] T {
    end := array.count;

    while end > 1 {
        last_exchange := 0;

        for i: 1..end - 1 {
            if f(array[i - 1]) > f(array[i]) {
                swap(array.data + i - 1, array.data + i);
                last_exchange = i;
            }
        }

        end = last_exchange;
    }

    return array;
}

compare_floats :: (a: float, b: float) -> s64 {
    if a < b return -1;
    if a > b return 1;
    return 0;
}

compare_strings :: (a: string, b: string) -> s64 {
    return Strings.compare(a, b);
}

intro_sort :: inline (array: [] $T, f: (T, T) -> int) {
    quick_sort(array, f);
}

insertion_sort :: inline (array: [] $T, f: (T, T) -> int) {
    for i: 1..array.count - 1 {
        value := array[i];
        j := i;

        while j > 0 && f(array[j - 1], value) > 0 {
            array[j] = array[j - 1];
            j -= 1;
        }

        array[j] = value;
    }
}

#scope_file
#import "Basic";
Strings :: #import "String";

sift :: (array: [] $T, root: s64, count: s64, f: (T, T) -> $R) {
    index := root;
    while index * 2 + 1 < count {
        child := index * 2 + 1;
        if child + 1 < count && f(array[child], array[child + 1]) < 0 child += 1;
        if f(array[index], array[child]) >= 0 break;

        swap(array.data + index, array.data + child);
        index = child;
    }
}
