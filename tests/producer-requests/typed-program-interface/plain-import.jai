Public :: #import "Choice";
Custom :: #import "Choice"()(Implementation = Hooks);

Hooks :: struct {
    run :: (value: Public.Number) -> s64 {
        return value;
    }
}

#assert Custom.selected_type == Hooks;

main :: () {
    value := Custom.read();
}
