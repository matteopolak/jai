#import "Basic";
F :: #import "Flat_Pool";

#assert !#exists(F.Native);

main :: () {
    assert(type_info(F.Flat_Pool).name == "Flat_Pool");
    assert(size_of(F.Flat_Pool) == 40);
    assert(type_info(F.Flat_Pool).members[0].offset_in_bytes == 0);
    assert(type_info(F.Flat_Pool).members[1].offset_in_bytes == 8);

    #if OS == .MACOS || OS == .LINUX || OS == .ANDROID {
        // Explicit native reservation fixture: public init/defaults are not
        // implemented or counted as covered by these mechanism tests.
        page := P.sysconf(P._SC_PAGESIZE);

        assert(page > 0);
        extent := page * 4;
        mapping := P.mmap(null, cast(u64) extent, P.PROT_NONE, P.MAP_PRIVATE | P.MAP_ANONYMOUS, -1, 0);

        assert(mapping != P.MAP_FAILED);
        base := cast(*u8) mapping;
        pool := F.Flat_Pool.{ current_point = base, memory_base = base,
                             first_uncommitted_page = base, address_limit = base + extent };
        first := cast(*u8) F.get(*pool, 3);

        assert(first == base && pool.first_uncommitted_page == base + page);
        first[0] = 1;
        first[1] = 2;
        first[2] = 3;
        pool.alignment = 64;
        next := cast(*u8) F.get(*pool, page + 1);

        assert((cast(u64) next & 63) == 0 && next > first);
        next[page] = 91;
        assert(next[page] == 91 && first[0] == 1 && first[2] == 3);
        committed := pool.first_uncommitted_page;
        allocator := Allocator.{ F.flat_pool_allocator_proc, *pool };
        resized := cast(*u8) allocator.proc(.RESIZE, 5, 3, first, allocator.data);

        assert(resized != first && resized[0] == 1 && resized[1] == 2 && resized[2] == 3);
        assert(first[0] == 1);
        assert(allocator.proc(.IS_THIS_YOURS, 0, 0, resized, allocator.data) != null);
        assert(allocator.proc(.IS_THIS_YOURS, 0, 0, pool.address_limit, allocator.data) == null);
        before_free := pool.current_point;

        allocator.proc(.FREE, 0, 5, resized, allocator.data);
        assert(pool.current_point == before_free);
        F.reset(*pool, true);
        assert(pool.current_point == base && pool.first_uncommitted_page == committed);
        for index: 0..before_free - base - 1 assert(base[index] == 0xcc);

        assert(allocator.proc(.IS_THIS_YOURS, 0, 0, first, allocator.data) == null);
        assert(F.get(*pool, 3) == first && first[0] == 0xcc);
        F.reset(*pool);
        assert(first[0] == 0xcc);
        F.fini(*pool);
        assert(pool.memory_base == null && pool.address_limit == null && pool.current_point == null && pool.first_uncommitted_page == null);
        F.fini(*pool);
        F.reset(*pool);
        name: string;
        flags := cast(Allocator_Caps) cast(u64) F.flat_pool_allocator_proc(.CAPS, 0, 0, *name, null);

        assert(name == F.CAPS_VERSION_STRING && flags == (.IS_THIS_YOURS | .HINT_I_AM_A_FAST_BUMP_ALLOCATOR));
        // A real failed mprotect must leave the bump and commit metadata intact.
        readonly := P.open(temp_c_string(#file), P.O_RDONLY);

        assert(readonly >= 0);
        failed_mapping := P.mmap(null, cast(u64) page, P.PROT_NONE, P.MAP_SHARED, readonly, 0);

        assert(P.close(readonly) == 0);
        assert(failed_mapping != P.MAP_FAILED);
        failed_base := cast(*u8) failed_mapping;
        failed_pool := F.Flat_Pool.{ current_point = failed_base, memory_base = failed_base,
                                    first_uncommitted_page = failed_base, address_limit = failed_base + page };

        assert(F.get(*failed_pool, 1) == null);
        assert(failed_pool.current_point == failed_base && failed_pool.first_uncommitted_page == failed_base);
        F.fini(*failed_pool);
    }

    print("ok\n");
}

#scope_file
#if OS == .MACOS || OS == .LINUX || OS == .ANDROID P :: #import "POSIX";
