# Independent standard library

## What it is

`stdlib/` contains independently authored Jai library modules with the existing public module names and source contracts. Maintained newer library sources determine the default API when they differ from the supplied historical distribution. The compiler bootstrap lives in `prelude/`; `stdlib/Preload.jai` loads that bootstrap through the ordinary source graph.

## How it works

Library algorithms execute as Jai procedures through the compiler's existing typed IR, virtual machine, and native backend. Host operations use authored foreign declarations and reviewed system SDK bindings. The Rust compiler owns intrinsic validation, allocation, runtime reflection, context activation, and host capability checks. A Jai declaration receives those operations only when the actual source binder recognizes its contract; declaring an unfamiliar intrinsic does not implement it.

Module files remain ordinary source inputs. `#load` joins authored fragments into one module, while `#import` preserves the graph's independent module identities, namespace privacy, parameters, and source origins. Public record fields, parameter defaults, enum values, operator declarations, and result shapes are compatibility contracts. Internal helpers and algorithms can change independently of those contracts.

The supplied files under `reference/` and pinned upstream files under `corpus/` are read-only API and source compatibility evidence. They are not imported implementation dependencies of `stdlib/`, compile-time includes in its Rust implementation, or native objects eligible for linking. Inventory tools store contract identities and hashes; they do not execute those source trees.

Some pinned OpenJai modules have compatibility implementations and schemas that differ from the supplied library. Maintained API evidence takes priority; historical signatures remain additive where compatible or require an explicit legacy version when field layout, result shape, or algorithm semantics differ. The inventory compares those surfaces separately. An undeclared name in an alternate compiler's library, such as `Calendar`, still requires a verified declaration or language contract before nominal type identity can be implemented.

Third-party Jai libraries and applications remain unchanged acceptance inputs. Jaison, Focus, Jails, Vk, and sgpu are not rewritten as standard-library modules. Native bindings retain the existing Jai public contract; SDL2, Vulkan, FreeType, codecs, and other native runtimes remain external dependencies. A newer SDK can verify a required ABI, but unused speculative namespaces stay outside the public library until an unchanged pinned consumer requires them.

Coverage is deliberately split into four questions: whether a public contract is inventoried, whether an authored declaration is present, whether its source parses/checks, and whether behavior passed a real test. A foreign prototype establishes an interface; an empty or fixed-answer body establishes neither implementation nor behavior. Family reports in `stdlib/.coverage/` retain unfinished work rather than hiding it behind successful parsing.

`stdlib/api-coverage.json` records the compact module inventory and failed source stages. The full local contract report is compressed under `artifacts/stdlib-rewrite/`. Those receipts do not make this unfinished tree the CLI's default library: source admission, primitive binding, semantic API verification, and relevant VM/native behavior checks must be integrated separately.

## How to change it

Change the owning module and its family documentation when adding or altering functionality. Preserve public signatures, stored-field layout, enum representations, defaults, and source-backed reflection identities. Keep internal helper names private. Add a meaningful authored program that exercises the changed behavior and report source-only checks separately from VM and native execution.

When adding a host operation, first extend the actual compiler source adapter, capability policy, typed operation, VM implementation, and native lowering as required. Bind the authored Jai signature to that real implementation. Do not invent an intrinsic name, return a success sentinel, or cast a source type to an unrelated runtime registry identity to make a module appear supported.

Run `python3 tools/stdlib_api_inventory.py` after changing the module tree. Its lexical contract report is useful for spotting missing names and signature changes; it does not prove semantic export equivalence or implementation completeness. Use the frozen compiler checks and family behavior cases for those separate questions.

## Configuration

The current explicit selection from the repository root is:

```sh
JAI_RS_STDLIB="$PWD/stdlib" \
JAI_RS_PRELOAD="$PWD/stdlib/Preload.jai" \
JAI_RS_RUNTIME_SUPPORT=off \
target/debug/jai-rs check-library stdlib/Hash.jai
```

`JAI_RS_MODULE_PATH` supplies ordered application module roots. `JAI_RS_STDLIB` appends the authored library root; explicit `JAI_RS_PRELOAD` chooses its bootstrap. Runtime support must be selected explicitly with its existing entry-point, initialization, and backtrace policy flags. Source compatibility diagnostics for original libraries use the explicit `reference/modules` root and are reported independently of checks against the authored library.

## Dependencies

The library depends on its authored modules and `prelude/`. Compiler support comes from `jai-source`, `jai-modules`, `jai-syntax`, `jai-sema`, `jai-ir`, `jai-vm`, `jai-runtime`, and the LLVM backend. Native bindings depend only on declared, reviewed system SDKs or independently built dependencies with retained provenance. The API inventory uses Python's standard library and existing source-only corpus metadata utilities; it adds no package dependency.
