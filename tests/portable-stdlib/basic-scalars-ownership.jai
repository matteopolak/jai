#import "Basic";

E :: enum s32 {
    LOW :: -1;
    HIGH :: 9;
}

Holder :: struct {
    allocator: Allocator;
}

main :: () {
    assert(IsScalar(int) && IsScalar(float64) && IsScalar(*void) && IsScalar(E));
    assert(!IsScalar(bool) && !IsScalar(string) && !IsScalar(Holder) && !IsScalar([] int));
    assert(min(7) == 7 && max(7) == 7);
    assert(min(8, 3, -1, 6) == -1 && max(8, 3, -1, 6) == 8);
    assert(min(cast(float64) 1.25, 3.0, -2.0) == -2.0);
    assert(max(E.LOW, E.HIGH, E.LOW) == .HIGH);
    assert(clamp(17, 0, 10) == 10);
    initial: [3] int = .[1, 2, 3];
    values := array_copy(initial);
    dynamic := resizable(values);

    assert(dynamic.count == 3 && dynamic.allocated == 3 && dynamic.data == values.data);
    assert(dynamic.allocator.proc == context.allocator.proc && dynamic.allocator.data == context.allocator.data);
    array_add(*dynamic, 4);
    assert(dynamic.count == 4 && dynamic[0] == 1 && dynamic[3] == 4);
    array_free(dynamic);
    detached: [0] int;
    unset := resizable(detached, set_allocators = false);
    unset.allocator = context.allocator;
    array_free(unset);
    holder: Holder;

    remember_allocators(*holder);
    assert(holder.allocator.proc == context.allocator.proc && holder.allocator.data == context.allocator.data);

    push_context {
        context.allocator = .{};
        remember_allocators(*holder);
        assert(holder.allocator.proc == context.default_allocator.proc && holder.allocator.data == context.default_allocator.data);
    }

    print("ok\n");
}
