// Both imported modules participate in this production source context.
Json :: #import "Extensions/Json";
Tls :: #import "Extensions/Tls";

Value :: struct {
    label: string;
}

main :: () {
    config: Tls.Tls_Config;
    value: Value;
    Json.free_json(*value);
    if config.roots_pem.count != 0 return;
}
