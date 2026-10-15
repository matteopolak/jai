// Reviewed rpmalloc.md option profiles and independent allocator ownership.
// Statistics-disabled behavior comes from a real separately compiled C SDK.
#import "Basic";
Default :: #import "rpmalloc";
Rewrite :: #import "rpmalloc"(ENABLE_STATISTICS = false);
Raw :: #import "rpmalloc"(USE_RAW = true, ENABLE_STATISTICS = false);

main :: () {
    assert(Default.initialize() == 0);
    assert(Rewrite.initialize() == 0);
    a := Default.rpmalloc(512);
    b := Rewrite.rpmalloc(1024);

    assert(a != null && b != null && a != b);
    (cast(*u8) a)[0] = 31;
    (cast(*u8) b)[0] = 73;
    b = Rewrite.rprealloc(b, 4096);
    assert(b != null && (cast(*u8) b)[0] == 73);
    assert((cast(*u8) a)[0] == 31);

    guarded: struct {
        before: u64 = 0x716;
        stats: Rewrite.rpmalloc_thread_statistics_t;
        after: u64 = 0x918;
    };

    Rewrite.thread_statistics(*guarded.stats);
    assert(guarded.before == 0x716 && guarded.after == 0x918);
    Rewrite.rpfree(b);
    Rewrite.finalize();
    assert(Default.is_initialized() && (cast(*u8) a)[0] == 31);
    assert(Raw.initialize() == 0);
    b = Raw.rpcalloc(32, 8);
    assert(b != null);
    for 0..255 assert((cast(*u8) b)[it] == 0);

    assert((cast(*u8) a)[0] == 31);
    Raw.rpfree(b);
    Raw.finalize();
    Default.rpfree(a);
    Default.finalize();
}
