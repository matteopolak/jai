# OpenJai source libraries

## What it is

The supplied `corpus/upstream/withlang-dev--open-jai/modules` libraries are checked as their own source dialect through the independent compiler. Their source-defined APIs remain distinct from the pinned Preload ABI; source acceptance, VM execution, and newly emitted native execution are separate evidence.

## How it works

The `jai-sema` example `source-library-check` loads unchanged files through `ModuleGraph::load_with_target` and checks their complete reachable library with `resolve_library_with_options`. It uses explicit target facts and the supplied module directory. It does not inject an unrelated Preload or Runtime_Support into these standalone library probes, rewrite source bodies, or load upstream native helpers.

```sh
RUSTC_WRAPPER= CARGO_TARGET_DIR=/private/tmp/jai-open-libraries \
  cargo run -p jai-sema --example source-library-check --offline -- \
  macos-arm64-lp64 corpus/upstream/withlang-dev--open-jai/modules \
  corpus/upstream/withlang-dev--open-jai/modules/Pool/module.jai \
  corpus/upstream/withlang-dev--open-jai/modules/Flat_Pool/module.jai
```

Each input reports either checked module/body/prototype counts or its input path followed by the original located diagnostic. A failed input does not prevent the remaining inputs from being inspected; the final line gives the number checked and failed, and any failure makes the command exit unsuccessfully. Passing this command establishes semantic library checking, without an entry procedure or runtime execution claim.

The Basic declarations for destination-returning `memcpy`/`memset` and generic `swap` have checked runtime implementations with source/VM/native fixtures. All six Pool and Flat_Pool intrinsics also have owned allocation and lifetime implementations. New source parity fixtures import the unchanged module files and exercise reset, reuse, poisoning, and release through both backends. The supplied compiler's empty helper bodies are not behavior to inherit. See [runtime intrinsics](runtime-intrinsics.md) and [pool intrinsics](pool-intrinsics.md) for the contracts and independent policy choices.

Many OpenJai Basic APIs are `#foreign` declarations. Such declarations retain foreign procedure identity and need a real external ABI/provider before execution. An ordinary procedure spelling, an integer allocator constant, or a source placeholder does not grant VM host capabilities.

The [static runtime inventory](../artifacts/open-jai-runtime-intrinsics.json) records source hashes and locations for all nine active `#intrinsic` declarations found across the supplied 47 module entries. They are Basic's `swap`, destination-returning `memcpy` and `memset`, and the six Pool/Flat_Pool operations. This inventory establishes source requirements; it does not establish semantic acceptance of the other declarations or source bodies.

The completed Linux x64 LP64 probe on 2026-10-02 checked all 47 unchanged module entries: 22 passed and 25 failed. Pool and Flat_Pool passed with three checked prototypes each; Pool also retained its ordinary `set_allocators` body. The local [result artifact](../artifacts/open-jai-library-check-linux-x64.json) records the checker executable hash, each entry's source hash, counts, and original diagnostics.

| Failed entries | First located cause |
| --- | --- |
| 18 | `Basic/module.jai:6`: importing Math conflicts with `log`. |
| 2 | `String/module.jai:21`: default allocator `temp` is unknown in the standalone graph. |
| 1 | `Check/module.jai:3`: untyped formals do not parse. |
| 1 | `Machine_X64/module.jai:32`: an empty value-returning body falls through. |
| 1 | `Sort/module.jai:10`: `compare` is absent from its standalone scope. |
| 1 | `TestModule_Params/module.jai:3`: parameter `VERBOSE` collides with the source constant. |
| 1 | `TestModule_TypedParams/module.jai:3`: required parameter `Required` was not supplied. |

These results measure this explicit standalone configuration. Missing imported globals and an unsupplied required parameter remain distinct from runtime implementations. Machine_X64's empty ordinary functions are not marked intrinsics; compiler enum categories and external helper declarations do not justify replacing arbitrary functions with those names.

All eight `runtime_intrinsics_source` parity fixtures passed with `--include-ignored` on the host target in the same session. The two corpus fixtures import unchanged Pool/Flat_Pool modules, execute them in the VM, emit new objects through LLVM, link with installed Clang, and run the resulting executables. This establishes those exercised allocation and lifetime paths, without a full-library native execution claim.

## How to change it

Extend the normal parser, scope/type resolver, or checked runtime operation corresponding to the original failure. Keep the example a thin caller of public compiler APIs. Add independently authored execution fixtures for supported contracts and preserve full unchanged-module checks alongside them. Document implementation choices when source declarations and examples leave allocation or lifetime details unspecified.

## Configuration

The example accepts `linux-x64-lp64` and `macos-arm64-lp64`, one module search root, and one or more entry source files. Both targets explicitly use little-endian LP64. Semantic compile-time work uses the normal `ResolveOptions`/VM limits and `NoEffects`; there is no implicit host I/O authorization.

## Dependencies

The probe uses `jai-modules`, `jai-sema`, `jai-types`, and `jai-vm`. The local supplied source directory is optional external data. Native parity fixtures use independently generated objects and installed Clang, with no original compiler or bundled library execution.
