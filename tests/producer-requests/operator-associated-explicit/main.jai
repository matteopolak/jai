using #import "Facade";

check :: () -> int {
    a: Value = .{ 17 };
    b: Value = .{ 4 };
    symbolic := a - b;

    if symbolic.n != 13 return -1;

    explicit := operator -(a,b);

    return explicit.n;
}

#assert check()==13;
main :: () {}
