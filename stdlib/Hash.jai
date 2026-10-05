// Compatibility hashes are expressed as recurrences with wrapping arithmetic.
FNV_64_PRIME: u64 : 0x100000001b3;
FNV_64_OFFSET_BIAS: u64 : 0xcbf29ce484222325;

sdbm_hash :: (data: *void, size: int, h := HASH_INIT) -> u32 #no_aoc {
    bytes := cast(*u8) data;
    offset: int = 0;
    while offset < size {
        h = h * 65599 + bytes[offset];
        offset += 1;
    }
    return h;
}

sdbm_float_hash :: inline (f: *float, count: int, h := HASH_INIT) -> u32 {
    offset: int = 0;
    while offset < count {
        sample := f[offset];
        if sample == 0 sample = 0;
        h = sdbm_hash(*sample, size_of(float), h);
        offset += 1;
    }
    return h;
}

djb2_hash :: (s: string) -> u32 #no_aoc {
    result := HASH_INIT;
    for byte: s result = result * 33 + byte;
    return result;
}

fnv1a_hash :: inline (val: u64, h := FNV_64_OFFSET_BIAS) -> u64 #no_aoc {
    return (h ^ val) * FNV_64_PRIME;
}

fnv1a_hash :: (data: *void, size: int, h := FNV_64_OFFSET_BIAS) -> u64 {
    bytes := cast(*u8) data;
    offset: int = 0;
    while offset < size {
        h = fnv1a_hash(cast(u64) bytes[offset], h);
        offset += 1;
    }
    return h;
}

knuth_hash :: inline (x: u64) -> u64 #no_aoc {
    return x * 11400714819323198485;
}

get_hash :: (x: $T, h := HASH_INIT) -> u32
#modify {
    info := cast(*Type_Info) T;
    while info.type == .VARIANT info = (cast(*Type_Info_Variant) info).variant_of;
    return info.type == .INTEGER || info.type == .BOOL || info.type == .ENUM || info.type == .POINTER || info.type == .FLOAT;
}
{
    #if T == float32 || T == float64 {
        return sdbm_hash(*x, size_of(T), h);
    } else {
        return cast,trunc(u32) (knuth_hash(cast,no_check(u64) x ^ h) >> 32);
    }
}

get_hash :: (s: string, h := HASH_INIT) -> u32 {
    return cast,trunc(u32) fnv1a_hash(s.data, s.count, cast(u64) h);
}

get_hash :: (array: [] $T, h := HASH_INIT) -> u32 {
    return sdbm_hash(array.data, array.count * size_of(T), h);
}

#scope_file
HASH_INIT: u32 : 5381;
