# Original input protection

## What it is

`OriginalInputPolicy` authenticates the repository's trusted, out-of-source inventory and installs a deny-only host policy. Original sources and binary assets remain available for explicitly granted static reads; original native bytes cannot become host programs, and original input trees cannot receive host writes.

## How it works

`OriginalInputPolicy::from_trusted_inventory(workspace)` reads the fixed corpus manifests and checks each SHA-256 against receipts compiled into the driver. The policy retains the configured `reference`, `vendor` and `corpus/upstream` trees, including their canonical targets and prospective paths when a tree is absent or a root symlink is dangling. Changing a manifest alone cannot change the compiled policy. Loading the policy reads inventory metadata, not the original native artifacts.

`apply(&mut HostIo)` validates the entire policy before installing any protection. Conflicting registered programs, existing source observations or insufficient capability/byte budgets reject without a partial installation. Fingerprints also deny identical native copies outside the protected trees. None of these records grants a filesystem root, executable, invocation, native library or linking authority. The CLI's separate reviewed native linking and path protections remain necessary.

`corpus/original-native-inputs.json` records paths, byte counts and SHA-256 values obtained by static inspection only. The generator recognizes native file suffixes and executable/archive magic, skips symlink subtrees and version-control internals, and streams hashes without executing, loading or linking anything. The inventory records absent original roots explicitly. The older native-dependency inventory contains source declaration hashes; those hashes are never substituted for native asset fingerprints.

The original trees need not exist in a clean public checkout. Their prospective paths and the retained byte receipts still protect future original inputs and copied native artifacts. A missing inventory manifest, changed receipt or unreadable manifest rejects policy construction. Static reads are governed by actual file grants, without a `.jai` suffix restriction.

## How to change it

After reviewing changes to the trusted manifests, run `python3 tools/generate_host_input_policy.py`. This updates the Rust deny receipts without inspecting native artifacts. To refresh the source-free native byte inventory from a local original checkout, run `python3 tools/generate_host_input_policy.py --refresh-native`; this performs read-only hashing and then regenerates the receipts. Never execute an original artifact to discover its identity.

Run `python3 tools/generate_host_input_policy.py --check` to check the generated receipt table. The table is intentionally not formatted separately: it must match the generator exactly. Provider tests cover changed manifests, copied inert native fixtures, atomic rejection, absent trees, dangling roots and preserved static binary reads. Actual File source fixtures construct and apply this policy before registering their explicit temporary roots.

Extend root selectors in the generator and regenerate the table together. Preserve bounded path resolution and the whole-policy installation check. New source binding or native linking code must not treat a deny receipt as positive execution authority. Concurrent external filesystem mutation remains outside the portable host provider's guarantees.

## Configuration

The workspace root is supplied by trusted Rust driver code, not Jai source. Manifest paths and expected fingerprints are compiled receipts; each manifest read is bounded to 1 MiB and streamed through an 8 KiB buffer. Root resolution is limited to 64 steps. `HostLimits.requests` and `HostLimits.bytes` additionally bound installed policy entries and metadata. No environment variable or CLI switch enables a capability.

```rust
let policy = OriginalInputPolicy::from_trusted_inventory(&workspace)?;
let mut host = HostIo::default();
policy.apply(&mut host)?;
let root = host.register_root(&temporary_directory, true)?;
```

## Dependencies

The [typed host provider](compile-time-host-io.md), maintained RustCrypto `sha2`, standard filesystem APIs, Python's standard JSON/hash libraries for generation, and the trusted corpus manifests. No original compiler, linker, library or object is executed or loaded.
