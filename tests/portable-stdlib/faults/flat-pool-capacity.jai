#import "Basic";
F :: #import "Flat_Pool";
P :: #import "POSIX";

main :: () {
    page := P.sysconf(P._SC_PAGESIZE);

    assert(page > 0);
    mapping := P.mmap(null, cast(u64) page, P.PROT_NONE, P.MAP_PRIVATE | P.MAP_ANONYMOUS, -1, 0);

    assert(mapping != P.MAP_FAILED);
    base := cast(*u8) mapping;
    pool := F.Flat_Pool.{ current_point = base, memory_base = base,
                         first_uncommitted_page = base, address_limit = base + page };

    F.get(*pool, page + 1);
}
