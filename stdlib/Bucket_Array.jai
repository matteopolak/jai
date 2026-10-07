// Explicit legacy namespace: stable-address storage with two-part locators.
#scope_file;

#import "Basic";

#scope_export;

Bucket_Array :: struct(type: Type, items_per_bucket: int, always_iterate_by_pointer := false) {
    count: s64;
    allocator: Allocator;
    My_Bucket :: Bucket(type, items_per_bucket);
    all_buckets: [..] *My_Bucket;
    unfull_buckets: [..] *My_Bucket;
    #assert items_per_bucket > 0;
}

Bucket :: struct(type: Type, items_per_bucket: int) {
    occupied: [items_per_bucket] bool;
    data: [items_per_bucket] type = ---;
    lowest_maybe_not_occupied: s32;
    bucket_index: u32;
    count := 0;
}

Bucket_Locator :: struct {
    bucket_index: u32;
    slot_index: s32;
}

bucket_array_reset :: (array: *Bucket_Array) {
    allocator := array.allocator;
    if !allocator.proc allocator = context.allocator;
    for array.all_buckets free(it, allocator);
    array_free(array.all_buckets);
    array_free(array.unfull_buckets);
    array.all_buckets = .{};
    array.unfull_buckets = .{};
    array.count = 0;
}

bucket_array_add :: (array: *Bucket_Array, item: array.type) -> (Bucket_Locator, pointer: *array.type) {
    pointer, locator := find_and_occupy_empty_slot(array, false);
    <<pointer = item;
    return locator, pointer;
}

bucket_array_find :: (array: *Bucket_Array, locator: Bucket_Locator) -> array.type {
    assert(cast(s64) locator.bucket_index < array.all_buckets.count);
    assert(locator.slot_index >= 0 && locator.slot_index < array.items_per_bucket);
    bucket := array.all_buckets[locator.bucket_index];
    assert(bucket.occupied[locator.slot_index]);
    return bucket.data[locator.slot_index];
}

bucket_array_remove :: (array: *Bucket_Array, locator: Bucket_Locator) {
    assert(cast(s64) locator.bucket_index < array.all_buckets.count);
    assert(locator.slot_index >= 0 && locator.slot_index < array.items_per_bucket);
    bucket := array.all_buckets[locator.bucket_index];
    assert(bucket.occupied[locator.slot_index]);
    if bucket.count == array.items_per_bucket array_add(*array.unfull_buckets, bucket);
    bucket.occupied[locator.slot_index] = false;
    bucket.count -= 1;
    array.count -= 1;
    if locator.slot_index < bucket.lowest_maybe_not_occupied {
        bucket.lowest_maybe_not_occupied = locator.slot_index;
    }
}

find_and_occupy_empty_slot :: (array: *Bucket_Array, $initialize := true) -> *array.type, Bucket_Locator {
    if array.unfull_buckets.count == 0 add_bucket(array);
    bucket := array.unfull_buckets[array.unfull_buckets.count - 1];
    slot := bucket.lowest_maybe_not_occupied;
    while slot < array.items_per_bucket && bucket.occupied[slot] slot += 1;
    assert(slot < array.items_per_bucket);
    bucket.occupied[slot] = true;
    bucket.count += 1;
    bucket.lowest_maybe_not_occupied = slot + 1;
    array.count += 1;
    if bucket.count == array.items_per_bucket array.unfull_buckets.count -= 1;
    pointer := *bucket.data[slot];
    #if initialize {
        initial: array.type;
        <<pointer = initial;
    }
    locator: Bucket_Locator = .{ bucket.bucket_index, slot };
    return pointer, locator;
}

operator *[] :: (array: Bucket_Array, index: int) -> *array.type {
    assert(index >= 0);
    bucket_index := index / array.items_per_bucket;
    slot := index % array.items_per_bucket;
    assert(bucket_index < array.all_buckets.count);
    assert(array.all_buckets[bucket_index].occupied[slot]);
    return *array.all_buckets[bucket_index].data[slot];
}

for_expansion :: (array: *$T/Bucket_Array, body: Code, flags: For_Flags) #expand {
    REVERSE :: (flags & .REVERSE) != 0;
    POINTER :: ((flags & .POINTER) != 0) || array.always_iterate_by_pointer;
    physical: s64 = 0;
    stride: s64 = 1;
    `it_index: int = -1;
    #if REVERSE {
        physical = array.all_buckets.count * array.items_per_bucket - 1;
        stride = -1;
        it_index = array.count;
    }
    while physical >= 0 && physical < array.all_buckets.count * array.items_per_bucket {
        bucket := array.all_buckets[physical / array.items_per_bucket];
        slot := physical % array.items_per_bucket;
        physical += stride;
        if !bucket.occupied[slot] continue;
        #if REVERSE it_index -= 1;
        else it_index += 1;
        // `remove it` frees the slot; iteration continues with the next occupied one.
        #if POINTER {
            `it := *bucket.data[slot];
            #insert (remove = {
                bucket_array_remove(array, .{ cast(u32) ((physical - stride) / array.items_per_bucket), cast(s32) slot });
            }) body;
        } else {
            `it := bucket.data[slot];
            #insert (remove = {
                bucket_array_remove(array, .{ cast(u32) ((physical - stride) / array.items_per_bucket), cast(s32) slot });
            }) body;
        }
    }
}

#scope_file;

add_bucket :: (array: *Bucket_Array) -> *array.My_Bucket {
    if !array.allocator.proc array.allocator = context.allocator;
    array.all_buckets.allocator = array.allocator;
    array.unfull_buckets.allocator = array.allocator;
    assert(array.all_buckets.count < 0xffff_ffff);
    bucket := New(array.My_Bucket, true, array.allocator);
    assert(bucket != null);
    bucket.bucket_index = cast(u32) array.all_buckets.count;
    array_add(*array.all_buckets, bucket);
    array_add(*array.unfull_buckets, bucket);
    return bucket;
}
