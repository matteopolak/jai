# Compiler and reflection support

## What it is

This area provides independently authored compiler interfaces, runtime bootstrap source, reflection helpers, AST visitors, a scalar Jai lexer, metaprogram source, and debugging support. The [API and validation inventory](../../stdlib/.coverage/compiler-reflection.json) separates declared interfaces, authored bodies, checked source, verified VM behavior, and unavailable services.

The maintained [OpenJai Compiler interface](https://raw.githubusercontent.com/withlang-dev/open-jai/main/modules/Compiler/module.jai) is the default `stdlib/Compiler/module.jai`. Its string-tagged descriptors, integer `Code`, options records, and defaults differ from the original protocol. Original compiler, visitor, checking, and debugging contracts are isolated under `stdlib/legacy/`; a default import cannot silently adopt those layouts. Live inspection on October 2, 2026 confirmed the maintained Compiler, Check, and Debug declaration surfaces against the pinned inputs. The remote commit identity was not verified.

## How it works

### Interfaces and compiler authority

The default Compiler module retains the maintained public declarations and has an authored options-preset body. Its remaining compiler services require genuine protocol adapters. A `#compiler` or `#foreign` declaration does not supply execution, native linking, a workspace, an AST, or descriptor identity. The maintained Type_Info shape cannot be substituted for the compiler bootstrap descriptor header.

Maintained visitors and metaprograms import Basic through a namespace. Its canonical source-location record differs from the maintained Compiler record; importing both sets of exports into one scope would produce an actual declaration conflict.

`stdlib/legacy/Compiler/Compiler.jai` preserves the original message, AST, build-option, and reflection schemas. `utilities.jai` implements optimization presets, source-location and path helpers, operator spellings, inheritance queries, and literal allocation. Integer and string factories allocate actual source-defined `Code_Literal` storage. They do not invent serial numbers, source locations, workspace identities, or compiler snapshot receipts. Converting these pointers into compiler `Code` still needs declaration and memory provenance admission.

The legacy `get_runtime_info` fallback declares `runtime_catalog: Runtime_Info #elsewhere` inside the checked procedure and returns that value. Native publication must bind its actual declaration, `GlobalId`, and `ExternalDataId`; a matching variable name or hand-built descriptor is insufficient. The external value has no placeholder initializer. Selecting the legacy module requires an explicit legacy import root or a separately registered actual module identity; no `Compiler_Legacy` facade grants authority.

### Runtime and reflection

`Runtime_Support.jai` retains the three required bootstrap parameters and the canonical `Context_Base` and `Temporary_Storage` field order. It implements C-string views, strided seed duplication, integer rendering, diagnostics, synchronized output, initialization, arena cleanup, and two ordered startup callback lists. A small atomic spin lock protects complete output calls. Output forwards partial writes to installed system-library APIs; a failed or zero write stops that call rather than looping indefinitely. WASM needs its application-provided output and trap functions.

`__jai_runtime_init` initializes genuine context and temporary-storage objects. `__jai_runtime_fini` frees overflow pages through their recorded allocator and restores the original arena. The entrypoint initializes, optionally installs crash handling, invokes startup hooks and the actual entrypoint declaration, then finalizes. These native lifecycle paths have not been executed in this work.

`Reflection.jai` uses the canonical bootstrap descriptor ABI, independent of the maintained Compiler module's incompatible descriptors. Array queries distinguish inline fixed arrays from view/resizable headers. Conversions support integer bounds, booleans, unescaped quoted strings, floats, and enums; cursor changes commit only after success. Integer parsing checks magnitude before arithmetic or narrowing. Enum storage respects its underlying signedness and width. Quoted-string results borrow the supplied text; no decoded copy is created.

`Tagged_Union` keeps an actual `Type` tag and a byte buffer sized at compile time. Its optional debug check verifies that a stored type is permitted. This preserves the original byte-buffer layout, including its existing alignment limitation; it does not add a stronger aligned-storage contract.

### Visitors, lexer, and metaprograms

The default `Code_Visit` follows the maintained node projection's `subexpressions`. Its macro still requires genuine compiler `Code` insertion support; integer-shaped Code values do not acquire quote authority. The explicit legacy visitor follows owned syntax edges, excluding scope parents and resolution back-links. Legacy depth-first and preorder/postorder traversal use explicit work stacks. Both visitors append to caller-owned arrays.

`Jai_Lexer` preserves the original token and lexer records because no maintained replacement is present. A cursor and eight-slot ring implement lookahead. Scalar classification, nested comments, identifiers, escaped identifier spacing, numeric prefixes, decimal floats, strings with byte/Unicode scalar escapes, here strings, notes, and compound punctuation have authored bodies. Token text is stored in the lexer's atom pool. Pool release invalidates that text; input supplied by the string setter remains borrowed, while file input is owned. Hexadecimal floats report a real error and remain unimplemented. Full Unicode normalization and exact parity for every legacy line metric remain unverified.

Default and minimal metaprograms use the maintained options API. Their authored flows create a workspace, process the supported options, schedule files and source strings, and observe completion where interception is enabled. The default implements release/debug and backend choices, output and import paths, added source, help, verbosity, and program arguments. Complete original flag handling, current-directory switching, SDK policy, plugin dispatch, and successful compiler sessions remain pending.

`Metaprogram_Plugins` explicitly imports the original compiler protocol by file. It produces quoted import source, resolves plugin getters, writes their actual workspace, and fills the caller's result array through a real placeholder/source-insertion workflow. The newer frozen parser accepts that source; complete checking still stops in shared Basic code, and execution requires the scoped compiler service. The original plugin ABI cannot be mixed with maintained message layouts.

### Checking and debugging

The maintained Check signature has authored node-integrity checks, but its required untyped-parameter syntax is not accepted by the frozen parser. The legacy Check module implements literal format/varargs validation and warnings for fixed-array value copies and small-integer promotion differences. C++ mangled-name parsers and binding verification remain absent; `CHECK_BINDINGS` does not imply those checks exist.

The maintained Debug procedures delegate to the explicitly imported original Debug layer. POSIX debugger detection, stack capture and symbol translation, signal registration/restoration, assertion reporting, and raw stack-address reporting have authored bodies. Signal reporting uses unsynchronized output and does not read a nonexistent hidden context. The `no_assert` callback intentionally ignores failures. Automatic debugger launch, minidumps, assertion dialogs, custom crash callback dispatch, Windows/console unwinding, and non-Windows pointer-map validation remain pending. Native host behavior has not been verified.

## How to change it

Keep the maintained and original contracts distinct. Update the corresponding source and inventory together when a signature, default, field, or behavior changes. Header equality is an API observation; only mark behavior verified after a real source invocation or native run.

Compiler services belong in checked source-binding, VM, driver, and native protocols. Preserve selected module/declaration ownership, canonical descriptor registries, real graph snapshots, and readiness dependencies. Register a new protocol adapter before accepting a different descriptor shape. Do not repair an incompatible shape with a hardcoded runtime ID, copied header bytes, filename exception, or success-returning fallback.

Extend the scanner and `tests/stdlib/compiler-reflection-pure.jai` together for scalar changes. Add full token-stream assertions only when genuine Basic, Pool, and File dependencies can be checked. Runtime memory helpers have an authentic module fixture in `tests/stdlib/runtime-support-source.jai`; the separate output fixture preserves the expected source-check effect-policy rejection. Source-check and negative-control results are recorded in the inventory. The newer frozen parser's remaining syntax blockers are variadic Tagged_Union struct parameters and the maintained Check signature; the older frozen parser also rejects `#placeholder`.

## Configuration

Runtime Support requires explicit values for `DEFINE_SYSTEM_ENTRY_POINT`, `DEFINE_INITIALIZATION`, and `ENABLE_BACKTRACE_ON_CRASH`. Native initialization also consumes compiler-provided `TEMPORARY_STORAGE_SIZE`; the library does not guess it. `runtime_startup_first_hooks` and `runtime_startup_second_hooks` are ordered source callback slices. `Tagged_Union.DEBUG`, original `Debug.USE_GRAPHICS`, and original `Check.CHECK_BINDINGS` retain their API defaults, with pending behavior described above.

For a default source-library check using only authored roots:

```sh
JAI_RS_MODULE_PATH="$PWD/stdlib" \
JAI_RS_PRELOAD="$PWD/prelude/Preload.jai" \
JAI_RS_RUNTIME_SUPPORT=off \
target/standard-library-snapshots/b1b820444e2a6585cda11d8efc2bf2186c5a6623cf54312552ba403d4e64fd13/jai-rs check-library stdlib/Protocol_For_Memory_Visualization.jai
```

The authentic Runtime Support profile uses its actual source file and explicit flags:

```sh
JAI_RS_MODULE_PATH="$PWD/stdlib" \
JAI_RS_PRELOAD="$PWD/prelude/Preload.jai" \
JAI_RS_RUNTIME_SUPPORT="$PWD/stdlib/Runtime_Support.jai" \
JAI_RS_RUNTIME_ENTRY=0 JAI_RS_RUNTIME_INITIALIZATION=0 JAI_RS_RUNTIME_BACKTRACE=0 \
target/standard-library-snapshots/b1b820444e2a6585cda11d8efc2bf2186c5a6623cf54312552ba403d4e64fd13/jai-rs check-library tests/stdlib/runtime-support-source.jai
```

With this configured profile, the entire Runtime Support source and its C-string/duplication VM fixture pass; an inverted assertion fails. The scalar lexer and trace-pair VM probe also passes with a failing negative control. The output fixture is rejected because compiler effects are unavailable in the source-check execution context. Most other full modules stop at shared Basic or File dependencies. These outcomes do not establish a complete standard library or native runtime.

The inventory keeps the older `b1b82044...` and newer `9508def6...` binary observations separate. The newer frozen binary parses 19 of the 21 owned production source files; two default-profile modules and the configured runtime profile pass source checking. The source hashes stayed stable during its checks. Its `build_inputs_verified` field is false: these observations describe that binary's behavior and do not prove the current Rust source tree was built or executed.

## Dependencies

The authored prelude supplies canonical primitive, allocation, diagnostic, reflection, and storage contracts. Reflection and visitors use Basic; the lexer uses Basic, Pool, and File. Legacy checking and plugin generation need actual compiler message/source services. Runtime and debugging native paths rely on installed system libraries and the authored POSIX or Windows interfaces; WASM callbacks must be supplied by the application.

The Rust parser, semantic binder, VM, driver, and native backend validate and execute accepted protocols. Reference and pinned upstream source files are read-only API inputs. No reference compiler, bundled native object/library, original project script, or uploaded source was executed or linked. Related generator and package coverage is documented separately in [metaprogram tooling](metaprogram-tooling.md).
