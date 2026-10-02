// OpenJai public shape: locators name reusable positions in parallel arrays.
#scope_export;
#import "Basic";

Bucket_Locator :: struct { index: int; }

Bucket_Array :: struct ($T: Type, $BUCKET_SIZE: int) {
    items: [..] T;
    occupied: [..] bool;
    count: int;
    all_buckets: [..] int;
    unfull_buckets: [..] int;
    #assert BUCKET_SIZE > 0;
}

bucket_array_add :: (array: *Bucket_Array($T, $BUCKET_SIZE), value: T) -> Bucket_Locator, *T {
    index: int = -1;
    while array.unfull_buckets.count > 0 && index < 0 {
        entry: int = 0;
        bucket := array.unfull_buckets[0];
        for array.unfull_buckets {
            if it < bucket { bucket = it; entry = it_index; }
        }
        begin := bucket * BUCKET_SIZE;
        end := begin + BUCKET_SIZE;
        if end > array.occupied.count end = array.occupied.count;
        cursor := begin;
        while cursor < end {
            if !array.occupied[cursor] { index = cursor; break; }
            cursor += 1;
        }
        if index < 0 {
            if end < begin + BUCKET_SIZE break;
            array_unordered_remove_by_index(*array.unfull_buckets, entry);
        }
    }
    if index < 0 {
        index = array.items.count;
        if index % BUCKET_SIZE == 0 array_add(*array.all_buckets, index / BUCKET_SIZE);
        array_add(*array.items, value);
        array_add(*array.occupied, true);
    } else {
        array.items[index] = value;
        array.occupied[index] = true;
    }
    array.count += 1;
    bucket := index / BUCKET_SIZE;
    bucket_end := (bucket + 1) * BUCKET_SIZE;
    has_space := bucket_end > array.occupied.count;
    if !has_space {
        for slot: bucket * BUCKET_SIZE..bucket_end - 1 {
            if !array.occupied[slot] { has_space = true; break; }
        }
    }
    listed: int = -1;
    for array.unfull_buckets if it == bucket { listed = it_index; break; }
    if has_space && listed < 0 array_add(*array.unfull_buckets, bucket);
    if !has_space && listed >= 0 array_unordered_remove_by_index(*array.unfull_buckets, listed);
    return .{index}, *array.items[index];
}

bucket_array_find :: (array: *Bucket_Array($T, $BUCKET_SIZE), locator: Bucket_Locator) -> T {
    initial: T;
    if locator.index < 0 || locator.index >= array.items.count return initial;
    if !array.occupied[locator.index] return initial;
    return array.items[locator.index];
}

bucket_array_remove :: (array: *Bucket_Array($T, $BUCKET_SIZE), locator: Bucket_Locator) {
    index := locator.index;
    if index < 0 || index >= array.occupied.count return;
    if !array.occupied[index] return;
    array.occupied[index] = false;
    array.count -= 1;
    bucket := index / BUCKET_SIZE;
    for array.unfull_buckets if it == bucket return;
    array_add(*array.unfull_buckets, bucket);
}

bucket_array_reset :: (array: *Bucket_Array($T, $BUCKET_SIZE)) {
    array_reset(*array.items);
    array_reset(*array.occupied);
    array_reset(*array.all_buckets);
    array_reset(*array.unfull_buckets);
    array.count = 0;
}

// Additional cleanup helper; reset deliberately retains backing allocation.
bucket_array_free :: (array: *Bucket_Array($T, $BUCKET_SIZE)) {
    array_free(array.items);
    array_free(array.occupied);
    array_free(array.all_buckets);
    array_free(array.unfull_buckets);
    array.items = .{};
    array.occupied = .{};
    array.all_buckets = .{};
    array.unfull_buckets = .{};
    array.count = 0;
}

operator *[] :: (array: Bucket_Array($T, $BUCKET_SIZE), index: int) -> *T {
    assert(index >= 0 && index < array.items.count && array.occupied[index]);
    return *array.items[index];
}

for_expansion :: (array: *$S/Bucket_Array, body: Code, flags: For_Flags) #expand {
    REVERSE :: (flags & .REVERSE) != 0;
    POINTER :: (flags & .POINTER) != 0;
    cursor: int = 0;
    stride: int = 1;
    `it_index: int = -1;
    #if REVERSE {
        cursor = array.items.count - 1;
        stride = -1;
        it_index = array.count;
    }
    while cursor >= 0 && cursor < array.items.count {
        index := cursor;
        cursor += stride;
        if !array.occupied[index] continue;
        #if REVERSE it_index -= 1;
        else it_index += 1;
        #if POINTER {
            `it := *array.items[index];
            #insert body;
        } else {
            `it := array.items[index];
            #insert body;
        }
    }
}
