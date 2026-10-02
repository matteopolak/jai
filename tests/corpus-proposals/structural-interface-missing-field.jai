Shape :: struct { value: int; }
Missing :: struct { other: int; }
read :: (item: $T/interface Shape) -> int { return item.value; }
main :: () -> int {
    item: Missing;
    item.other = 22;
    return read(item);
}
