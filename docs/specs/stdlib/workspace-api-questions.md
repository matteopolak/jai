# Workspace API contract questions

1. RESOLVED by coordinator's official Jai 0.2.030 observations and updated
   reviewed Compiler/Minimal contracts: `add_build_file(filename,w,loc)` anchors
   relative filenames to the source directory represented by `loc`, defaulting
   to the API call site. A helper's default call therefore selects the helper
   directory. The earlier cwd-positive premise is retired. Explicit locations
   and absolute paths provide supported alternatives. Minimal's no-cwd flow
   preserves relative strings and consequently retains its own call-site base;
   no compiler exception is appropriate. This worker consumed sanitized results,
   not original code or reference binaries.
2. Confirm ownership and lifetime of returned option strings/views and
   `user_data_pointer`. The implementation snapshots string contents independently
   and preserves the opaque pointer value with borrowed lifetime; it does not
   invent a pointee-copy protocol from `user_data_pointer_size`.
3. Confirm public default `get_build_options` values before any set when CLI
   optimization/output flags were supplied. This task fixes explicitly selected
   workspace state, without inventing a global option fallback or inheritance.
