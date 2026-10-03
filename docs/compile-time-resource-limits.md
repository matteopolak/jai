# Compile-time resource limits

## What it is

Compile-time execution uses explicit fuel, recursion, allocation and storage bounds. Native CLI configuration and platform-independent compiler discovery pass the same bounds into final source resolution, rather than silently restoring defaults.

## How it works

The CLI parses optional environment values into positive integer settings before module discovery. Fuel uses `NonZeroU64`; resource counts use `NonZeroUsize`. Invalid text, zero and overflow produce a typed configuration error naming the affected setting.

`SemanticDiscoveryOptions.limits` travels with the resulting `CompilationUnit` through both synchronous discovery and retained graph jobs. Every final resolver copies those limits into its `ResolveOptions`. Artifact commands instead pass the configured limits to the workspace scheduler, which propagates them to its source jobs.

These are limits for each execution, not one shared spent-fuel counter across the entire build. Raising fuel does not raise allocation, storage or recursion bounds and does not authorize host effects. Pure source checks continue to use `NoEffects`.

Graph-owned source runs retain the same VM and journal when a checked procedure or type is not ready. The retained machine measures live frames, loop state, temporaries, backing capacities, and binding metadata before each task; this inspection work shares the fuel budget with source operations. It does not restart the run or reset spent work on resume. The earlier ordinary loop path admitted the authored `0..100` sum at 100,000 fuel, while the retained path exhausted that budget. The configured regression therefore uses 20,000,000 as its adequate budget and keeps a one-unit rejection plus the exact result `5050`. Default fuel remains 1,000,000. Borrowed literal string accounting reads the `Vec` capacity in constant time and charges one visited value, rather than charging every retained byte again before each task. The full byte capacity still contributes to storage admission and checkpoint/fork copy work. Hashing, encoding, byte reads and actual payload copies retain their separate charges; a string scan therefore does not repeatedly pay for a nonexistent full-payload inspection. Other live metadata walks remain metered.

## How to change it

Change native environment parsing in `jai-cli::compile_time_limits` and wiring in `SourceConfiguration`, `source_check` and `workspace_build`. Keep counters typed and independently configurable. A new VM limit also needs propagation in all `CompilationUnit` constructors and final resolution paths.

The driver regression executes a real compile-time loop: a small budget must reject it, and an adequate budget must produce the exact runtime result. Keep that behavioral check when changing discovery or resolver ownership. Interpreter runtime limits are a separate setting owned by the scripting host.

## Configuration

| Variable | Default | Meaning |
| --- | ---: | --- |
| `JAI_RS_CT_FUEL` | 1,000,000 | VM instruction budget |
| `JAI_RS_CT_STACK_DEPTH` | 128 | Call stack depth |
| `JAI_RS_CT_EVALUATION_DEPTH` | 256 | Expression evaluation depth |
| `JAI_RS_CT_ALLOCATIONS` | 16,384 | Allocation count |
| `JAI_RS_CT_VALUE_CELLS` | 1,000,000 | Retained value/storage budget |

For a larger independently authored hash probe:

```sh
JAI_RS_CT_FUEL=20000000 cargo run -p jai-cli -- check hash-probe.jai
```

Library callers provide `SemanticDiscoveryOptions.limits` directly. Browser hosts configure that value without reading environment variables or native files.

## Dependencies

`jai-vm::Limits`, semantic `ResolveOptions`, driver graph discovery and workspace scheduling. Parsing uses only Rust standard-library integer and OS-string types; it adds no package dependency.
