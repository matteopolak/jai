// Independently authored open-addressing table with the current public layout and API.
#module_parameters (COUNT_COLLISIONS := false)();

Table :: struct(Key_Type: Type, Value_Type: Type,
                given_hash_function: (Key_Type) -> u32 = null,
                given_compare_function: (Key_Type, Key_Type) -> bool = null,
                LOAD_FACTOR_PERCENT: u32 = 70, REFILL_REMOVED := true) {
    count: int;
    allocated: int;
    slots_filled: int;
    allocator: Allocator;
    Entry :: struct {
        hash: u32;
        key: Key_Type;
        value: Value_Type;
    }
    entries: [] Entry;
    #if given_hash_function {
        hash_function :: given_hash_function;
    } else {
        hash_function :: (key: Key_Type) -> u32 {
            return Hash.get_hash(key);
        };
    }
    #if given_compare_function {
        compare_function :: given_compare_function;
    } else {
        compare_function :: (left: Key_Type, right: Key_Type) -> bool {
            return left == right;
        };
    }
    #if COUNT_COLLISIONS {
        add\_collisions: s64;
        find_collisions: s64;
    }
    SIZE_MIN :: 32;
    #assert LOAD_FACTOR_PERCENT > 0 && LOAD_FACTOR_PERCENT < 100;
}

NEVER_OCCUPIED_HASH :: 0;
REMOVED_HASH :: 1;
FIRST_VALID_HASH :: 2;

init :: (using table: *Table, slots_to_allocate: s64 = 0) {
    if !allocator.proc allocator = context.allocator;
    resize(table, slots_to_allocate);
}

resize :: (using table: *Table, slots_to_allocate: s64 = 0) {
    if !allocator.proc allocator = context.allocator;
    // An explicit size is only rounded up to a power of two (init(*t, 10) allocates 16);
    // SIZE_MIN applies when none is given.
    capacity := next_power_of_two(ifx slots_to_allocate > 0 then slots_to_allocate else SIZE_MIN);
    while count * 100 >= capacity * LOAD_FACTOR_PERCENT capacity *= 2;
    previous := entries;
    replacement, base := Basic.NewArray(capacity, Entry, true,, allocator);
    entries = replacement;
    allocated = capacity;
    count = 0;
    slots_filled = 0;
    for old: previous if old.hash >= FIRST_VALID_HASH _place_entry(table, old);
    if previous.data Basic.free(previous.data, allocator = allocator);
}

table_resize :: (table: *Table, slots_to_allocate: s64) {
    resize(table, slots_to_allocate);
}

table_reset_keeping_memory :: (table: *Table) {
    table_reset(table);
}

deinit :: (table: *Table) {
    if table.entries.data Basic.free(table.entries.data, allocator = table.allocator);
    table.entries = .{};
    table.count = 0;
    table.allocated = 0;
    table.slots_filled = 0;
}

table_reset :: (using table: *Table) {
    for *entry: entries entry.hash = NEVER_OCCUPIED_HASH;
    count = 0;
    slots_filled = 0;
    #if COUNT_COLLISIONS {
        add_collisions = 0;
        find_collisions = 0;
    }
}

table_ensure_space :: (table: *Table, items: s64) {
    Basic.assert(items >= 0);
    if table.allocated == 0 init(table);
    while (table.slots_filled + items) * 100 >= table.allocated * table.LOAD_FACTOR_PERCENT expand(table);
}

table_add :: (table: *Table, key: table.Key_Type, value: table.Value_Type) -> *table.Value_Type {
    table_ensure_space(table, 1);
    entry: table.Entry;
    entry.hash = _valid_hash(table.hash_function(key));
    entry.key = key;
    entry.value = value;
    return _place_entry(table, entry);
}

table_set :: (table: *Table, key: table.Key_Type, value: table.Value_Type) -> *table.Value_Type {
    found := table_find_pointer(table, key);
    if found {
        found.* = value;
        return found;
    }
    return table_add(table, key, value);
}

table_find_pointer :: (table: *Table, key: table.Key_Type) -> *table.Value_Type {
    index := _find_index(table, key);
    if index < 0 return null;
    return *table.entries[index].value;
}

// Success comes first: `found, value := table_find(*table, key);`
table_find :: (table: *Table, key: table.Key_Type) -> (success: bool #must,table.Value_Type) {
    pointer := table_find_pointer(table, key);
    if pointer return true, pointer.*;
    zero: table.Value_Type;
    return false, zero;
}

table_contains :: (table: *Table, key: table.Key_Type) -> bool {
    return _find_index(table, key) >= 0;
}

table_find_multiple :: (table: *Table, key: table.Key_Type) -> [] table.Value_Type {
    output: [..] table.Value_Type;
    output.allocator = Basic.temp;
    if table.allocated == 0 return output;
    hash := _valid_hash(table.hash_function(key));
    index := (cast(int) hash) & (table.allocated - 1);
    step := _probe_stride(hash);
    visited := 0;
    while visited < table.allocated {
        entry := table.entries[index];
        if entry.hash == NEVER_OCCUPIED_HASH break;
        if entry.hash == hash && table.compare_function(entry.key, key) Basic.array_add(*output, entry.value);
        else {
            #if COUNT_COLLISIONS table.find_collisions += 1;
        }
        index = (index + step) & (table.allocated - 1);
        visited += 1;
    }
    return output;
}

table_remove :: (table: *Table, key: table.Key_Type) -> (success: bool, value: table.Value_Type) {
    index := _find_index(table, key);
    zero: table.Value_Type;
    if index < 0 return false, zero;
    value = table.entries[index].value;
    table.entries[index].hash = REMOVED_HASH;
    table.count -= 1;
    return true, value;
}

find_or_add :: (table: *Table, key: table.Key_Type) -> (entry: *table.Value_Type, newly_added: bool) {
    existing := table_find_pointer(table, key);
    if existing return existing, false;
    zero: table.Value_Type;
    return table_add(table, key, zero), true;
}

for_expansion :: (table: *$T/Table, body: Code, flags: For_Flags) #expand {
    cursor := 0;
    delta := 1;
    #if flags & .REVERSE {
        cursor = table.allocated - 1;
        delta = -1;
    }
    while cursor >= 0 && cursor < table.allocated {
        index := cursor;
        cursor += delta;
        if table.entries[index].hash < FIRST_VALID_HASH continue;
        #if flags & .POINTER {
            `it := *table.entries[index].value;
        } else {
            `it := table.entries[index].value;
        }
        `it_index := table.entries[index].key;
        #insert (remove = {
            table.entries[index].hash = REMOVED_HASH;
            table.count -= 1;
        }) body;
    }
}

Walk_Table :: (code: Code) #expand {
    `hash := _valid_hash(`table.hash_function(`key));
    `index := (cast(int) hash) & (`table.allocated - 1);
    stride := _probe_stride(hash);
    remaining := `table.allocated;
    while remaining > 0 {
        `table_while_loop := `table.entries[index].hash;
        if !table_while_loop break;
        #insert code;
        index = (index + stride) & (`table.allocated - 1);
        remaining -= 1;
    }
}

expand :: (table: *Table) {
    resize(table, Basic.max(table.SIZE_MIN, table.allocated * 2));
}

next_power_of_two :: (x: int) -> int {
    n := 1;
    while n < x n *= 2;
    return n;
}

#scope_file
Basic :: #import "Basic";
Hash :: #import "Hash";

_valid_hash :: (hash: u32) -> u32 {
    if hash < FIRST_VALID_HASH return hash + FIRST_VALID_HASH;
    return hash;
}

_probe_stride :: (hash: u32) -> int {
    return cast(int) ((hash >> 16) | 1);
}

_place_entry :: (table: *Table, entry: table.Entry) -> *table.Value_Type {
    index := (cast(int) entry.hash) & (table.allocated - 1);
    stride := _probe_stride(entry.hash);
    visited := 0;
    while visited < table.allocated {
        tag := table.entries[index].hash;
        reusable := tag == NEVER_OCCUPIED_HASH;
        #if table.REFILL_REMOVED reusable = reusable || tag == REMOVED_HASH;
        if reusable {
            table.entries[index] = entry;
            table.count += 1;
            if tag == NEVER_OCCUPIED_HASH table.slots_filled += 1;
            return *table.entries[index].value;
        }
        #if COUNT_COLLISIONS table.add_collisions += 1;
        index = (index + stride) & (table.allocated - 1);
        visited += 1;
    }
    Basic.assert(false, "hash table has no available slot");
    return null;
}

_find_index :: (table: *Table, key: table.Key_Type) -> int {
    if table.allocated == 0 return -1;
    hash := _valid_hash(table.hash_function(key));
    index := (cast(int) hash) & (table.allocated - 1);
    step := _probe_stride(hash);
    visited := 0;
    while visited < table.allocated {
        entry := table.entries[index];
        if entry.hash == NEVER_OCCUPIED_HASH return -1;
        if entry.hash == hash && table.compare_function(entry.key, key) return index;
        #if COUNT_COLLISIONS table.find_collisions += 1;
        index = (index + step) & (table.allocated - 1);
        visited += 1;
    }
    return -1;
}
