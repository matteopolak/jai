# HTTP route storage ownership

The filtered Linux ASan receipt for job 117201498066 reports a direct 271-byte allocation from `parse_template` through dynamic-array growth. This repair addresses that logical ownership leak independently of the admitted canonical allocator alias. It does not change allocator visibility or sanitizer settings.

`parse_template` owns its segments array; segment strings borrow the supplied template. Each consumer now releases that array, including early-return paths: `router_add`, `check_template`, `param_position`, and `check_param`. The latter also releases its separately allocated parameter-name array. Borrowed strings and temporary diagnostic strings are not freed.

`router_free` releases each route's copied middleware alongside its existing name storage and clears the root after freeing its tree. `register_route` releases the same middleware when registration fails. `free_app` releases each group's middleware and each copied setup-error string. Group prefixes affect type identity, not the runtime fields used for destruction; the public control checks size/alignment for different prefixes. Public records, signatures, registration behavior, and middleware execution remain unchanged.

The retained HTTP client now calls `free_app` for its two Apps after their final servers have drained. Its diff adds only those two calls and a blank line; original route registrations, requests, assertions, timeouts, and server calls remain intact. Termination and child IO configuration are owned separately and untouched.

## Evidence

The independent nonnetwork control is [http-router-ownership.jai](../../tests/extensions/http-router-ownership.jai). Its original production baseline failed with 48 allocations / 5,696 bytes remaining after four App lifecycles. The final control additionally covers root parameter/rest nodes, nested groups with middleware, and failed registration. It obtains and destroys a genuine MemoryDebugger leak report with global-reachability filtering disabled; no custom allocator is installed.

Final formatted source passes 12 source checks (control and retained client across Mac/Linux/Windows, x64/ARM64), six strict lint contexts with no incomplete files, and the required WASM rejection for unavailable HTTP App exports. Actual Mac ARM64 interpreter, native O0, native O2, and native O2 ASan+UBSan executions each exit zero with exactly `leaks 0 bytes 0` then `ok`, and empty stderr. No network or GUI operation ran.

Durable raw receipts, source guards, tool identity, and executable hashes are recorded in [the ready manifest](../status/http-router-ownership-ready.json). Historical red receipts are retained in the same T7 namespace. The baseline predates the additional root-node assertions; it is not a byte-identical final-fixture replay.

## Required follow-up

Actual Linux replay of all eight original ASan client copies remains required, as do native Linux/Windows execution of the new lifecycle control. Mac ASan+UBSan is not Linux LeakSanitizer proof. Additional filtered allocation sites/totals were requested before attributing other client application payloads or server lifetimes to this repair. The exact new test ID must be admitted to the catalogue's existing HTTP App target policy; no whole-module skip is requested.
