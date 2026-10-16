#module_parameters ()(Implementation: $I/interface Protocol = Fallback) {
    Protocol :: struct {
        run :: (value: s64) -> s64 {
            return value;
        }
    }

    Fallback :: struct {
        run :: (value: s64) -> s64 {
            return value;
        }
    }
}

Number :: s64;
selected_type :: Implementation;

read :: () -> s64 {
    return Implementation.run(7);
}
