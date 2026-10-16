Value :: struct {
    n: int;
}

operator - :: (a: Value, b: Value) -> Value {
    return .{ a.n - b.n };
}
