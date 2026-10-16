Choice :: #import "Choice"()(Implementation = Hooks);

Hooks :: struct {
    run :: (value: s64) -> s64 {
        return value;
    }
}

#assert Choice.selected_type == Hooks;

main :: () {
    value := Choice.read();
}
