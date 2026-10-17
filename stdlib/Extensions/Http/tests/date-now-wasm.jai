Http :: #import "Extensions/Http";

// A native adapter only: a WASM request must diagnose the missing export.
main :: () {
    cache: Http.Date_Cache;
    // jailint: allow(unused_variable)
    text := Http.http_date_now(*cache);
}
