#import "Basic";
#import "Extensions/Json";

main :: () {
    values: [4] float64 = .[1.5, 5e-324, 2.2250738585072014e-308, 1.7976931348623157e308];
    for value, index: values {
        print("begin %\n", index);
        json := to_json(value);
        parsed, error := from_json(float64, json);

        assert(error.kind == .NONE && (cast(*u64) *parsed).* == (cast(*u64) *value).*);
        free(json);
        print("json % complete\n", index);
        formatted := sprint("%", FormatFloat.{ value = value, mode = .SHORTEST });
        parsed2, okay, rest := string_to_float64(formatted);

        assert(okay && rest.count == 0 && (cast(*u64) *parsed2).* == (cast(*u64) *value).*);
        free(formatted);
        print("basic % complete\n", index);
    }

    print("ok\n");
}
