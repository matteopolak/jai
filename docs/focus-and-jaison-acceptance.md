# Focus and Jaison acceptance

## What it is

This lane checks unchanged pinned application roots with this repository's integrated Rust compiler. Reduced language fixtures and parser probes are separate evidence from compiling these actual projects.

## How it works

The pins are Focus `c6b3ead7d4174527d0138e8a31f7c3c5663badec` and Jaison `2009cdb5895d36020b5a3e6be8976db4706518a9`, recorded with source hashes in `corpus/upstreams.json`.

Focus's documented recipe is `jai first.jai - release`. Its actual `first.jai` configures compiler workspaces and plugins, adds `src/main.jai` plus generated build constants, and requests platform output. It also queries git and time, creates directories, and can invoke linking and bundling tools. Checking an arbitrary support file does not execute this recipe or establish a usable editor.

Jaison's `tests.jai` is a real test application that imports `Basic` with `MEMORY_DEBUGGER = true` and loads its actual `module.jai`. That module loads `generic.jai` and `typed.jai`, imports the checked-out `unicode_utils/module.jai`, and depends on genuine standard modules. `examples/example.jai` is a separate application root; `module.jai` is a library root.

The latest 2026-10-02 immutable integrated CLI measured here has SHA-256 `b1b820444e2a6585cda11d8efc2bf2186c5a6623cf54312552ba403d4e64fd13`. The genuine-Preload report is `artifacts/focus-jaison-b1b82044-bootstrap.json`. The separate `corpus/focus-jaison-acceptance.json` manifest checks all four actual roots with their program, metaprogram, or library classification, preserving the canonical source inventory. Real module search directories and Preload are used; Runtime Support is explicitly off in this diagnostic profile.

| Root/profile | Measured result |
| --- | --- |
| Focus `first.jai`, metaprogram root | Lexes and parses; dependency checking stops at supplied `Basic/Apollo_Time.jai:340:6`: `a caller export requires a declaration or defer`. |
| Jaison `tests.jai` and `examples/example.jai`, program roots | Both lex and parse; dependency checking reaches the same `Basic/Apollo_Time.jai:340:6` diagnostic. |
| Jaison `module.jai`, library root | Lexes and parses as the actual library root; dependency checking reaches the same `Basic/Apollo_Time.jai:340:6` diagnostic. |

The defining source is the escaped statement `` `return result; `` inside `ConvertToApollo`; it is a caller-directed macro control-flow requirement. All four genuine roots lex and parse; none reaches LLVM output, linking, or application execution. Complete Focus and Jaison project builds remain at zero.

Historical `a19b4808` evidence stopped at `Basic/Int128.jai:157:1`'s operator signature. The earlier `43b1705d` report stopped at Focus's `#run,stallable` and `Basic/String_Builder.jai`'s using declaration; its Runtime-Support-enabled direct workspace attempt exited with an empty-bootstrap-file panic and wrote no LLVM artifact. That runtime profile has not been rerun with `b1b82044`.

The feature checkpoint `artifacts/component-checkpoints/collection-source-runtime-20261002T140932Z/validation.json` separately records the complete unchanged Focus `src/utils/ring_buffer.jai` with independently authored drivers, plus original Basic removal and Vk-Engine loop excerpts. Its final bounded suite passed 12 groups with eight VM/native cases and four rejection groups. This establishes the exercised source helpers; it does not establish the complete Focus dependency closure. The instance annotation helper and implicit `ifx` integration are separately staged for the shared schema gate.

The report verifies the frozen binary hash and pinned corpus source hashes. Its `compiler.inputs` describes workspace files observed when the harness ran; those hashes are not a verified build-input manifest for the frozen binary.

## How to change it

Use the original build/application roots and preserve their source hashes. Coordinate immutable CLI publication with the corpus acceptance lane, then rerun the bounded harness. Resolve the first real diagnostic rather than replacing Preload, editing project sources, discarding directives, or counting support-file checks as project builds.

Use `emit-llvm` or `emit-object` to assess Focus's actual workspace recipe after syntax and dependencies advance. Before linking or executing any project output, establish the actual selected native dependencies and target behavior. No supplied compiler, native library, object, or upstream build script is executed by this lane.

## Configuration

```sh
python3 tools/check_corpus.py \
  --compiler target/standard-library-snapshots/b1b820444e2a6585cda11d8efc2bf2186c5a6623cf54312552ba403d4e64fd13/jai-rs \
  --manifest corpus/focus-jaison-acceptance.json \
  --bootstrap search --through check --timeout 20 \
  --report artifacts/focus-jaison-b1b82044-bootstrap.json
```

Focus's real module search order is its own `modules/` followed by `reference/modules`. Jaison uses its original relative loads/imports and `reference/modules`. An actual Runtime Support profile additionally sets `JAI_RS_RUNTIME_SUPPORT=search` and explicit `JAI_RS_RUNTIME_ENTRY`, `JAI_RS_RUNTIME_INITIALIZATION`, and `JAI_RS_RUNTIME_BACKTRACE` booleans. These are configuration facts, not evidence that the complete runtime compiles. The CLI's source-command-line handling must also be assessed before claiming Focus's `release` recipe is reproduced.

## Dependencies

The lane uses the pinned source inventory, integrated Rust CLI, actual Preload/Runtime Support source, and the staged corpus harness. Full Focus output additionally depends on compiler workspace/effect behavior and platform SDKs; full Jaison tests depend on standard-library allocation, reflection, generic parsing, and memory-debugger behavior. See [corpus acceptance](corpus-acceptance.md), [workspace artifacts](workspace-artifacts.md), and [native project dependencies](native-project-dependencies.md).
