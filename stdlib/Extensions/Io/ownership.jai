#scope_module

// Release through Basic's bookkeeping and the allocator that owns this object,
// even when a different fiber context is active. Restore the caller on return.
release_owned :: (memory: *void, owner: Allocator) {
    push_allocator(owner);
    free(memory);
}

// Io owns the initial slab; Basic owns overflow-page allocation and reset.
prepare_scratch :: (storage: *Temporary_Storage, owner: Allocator) {
    storage.* = .{};
    paged := cast(*Temporary_Storage_Paged_Alloc) storage;
    paged.overflow_allocator = owner;

    if TEMPORARY_BYTES > 0 {
        push_allocator(owner);
        storage.data = cast(*u8) alloc(TEMPORARY_BYTES);
        assert(storage.data != null, "Io: could not allocate fiber temporary storage");
        storage.size = TEMPORARY_BYTES;
    }
}

release_scratch :: (storage: *Temporary_Storage, owner: Allocator) {
    reset_temporary_storage(storage);
    if storage.data release_owned(storage.data, owner);
    storage.* = .{};
}
