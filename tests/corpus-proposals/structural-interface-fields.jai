Shape :: struct { value: int; }
Small :: struct { padding: int; value: int; }
read :: (item: $T/interface Shape) -> int { return item.value; }
main :: () -> int {
    item: Small;
    item.padding = 7;
    item.value = 22;
    return read(item);
}
