# Vendored reference input

`jai-0.2.009/modules/Preload.jai` is the supplied Jai 0.2.009 bootstrap, preserved byte for byte with the user's explicit upload authorization. It is third-party reference input, separate from the independent Rust implementation.

Origin: local `reference/modules/Preload.jai`, from the February 2025 distribution.

SHA-256: `1d00c2ecde58c5362c8e2edf978d57eb490a39076eb6ebf7d118a9811a851904` (13,612 bytes).

Only the separately dispatched reference probe stages this file into the original compiler's expected module path. Normal Rust compiler checks do not compile it. See [bounded reference probes](../docs/reference-probes.md) for inspection, restrictions and recorded results.
