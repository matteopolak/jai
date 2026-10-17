Json :: #import "Extensions/Json";
// The import selects the Windows host provider; nothing in the program names it.
// jailint: allow(unused_import)
Tls :: #import "Extensions/Tls";

Value :: struct {
    label: string;
}

main :: () {
    value: Value;
    Json.free_json(*value);
}
