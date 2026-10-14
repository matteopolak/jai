# Canonical runner: resolved configuration questions

Owner: portable-asn1-socket. Both questions are resolved by the approved
[direct-run and macro-enum contracts](../stdlib/modules/bindings-generator.md).

1. Direct `run_generator` consumes canonical options and does not normalize
   `libnames`, `libpaths`, `system_library_names` or `system_library_paths`.
   Callers needing legacy translation explicitly invoke the tools-owned
   `normalize_options`; high-level generation drivers do that themselves.
2. A fresh macro enum has no inferred underlying CType, including equal-width
   groups. Converted members are typed as that enum and retain their original
   expressions/location/comments. Reusing an existing enum preserves its
   represented underlying type. No automatic widening or lossless mixed-sign/
   width join is promised. Visitors can supply a type explicitly. Noninteger,
   overflow and wider literal representation/emission limits remain explicit;
   successful parsing/run is no ABI or generated-compilation guarantee.

The earlier first-native-type implementation was a contract mismatch, not a
required adapter or promotion feature. Historical verification receipts remain
evidence for their recorded snapshots only. Android source/device and other
native-platform gates remain separate from this resolved configuration scope.
