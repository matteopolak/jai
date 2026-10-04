# Reference compatibility

## What it is

The acceptance target includes the complete supplied distribution: 702 `.jai` files, including 80 tutorial files, 83 example files and 539 module files, plus [1,440 recent upstream sources](upstream-corpus.md). Compatibility includes source semantics, runtime behavior, metaprogramming and the `Compiler` API. Recent upstream programs and libraries take precedence over outdated local syntax/API assumptions.

## How it works

Track lexical, parsing, typechecking, code generation, linking and runtime results separately. Build actual entrypoints with their own build scripts, module paths and target configurations; support files are not necessarily standalone programs. For example, `examples/import_replacement/main_program.jai` intentionally requires the surrounding metaprogram to supply missing imports.

The required target families are macOS, Linux, Windows, iOS, Android and the supplied **wasm64** example. Validate target-specific branches on the proper target; an x86 assembly example is not expected to become ARM assembly automatically.

Coverage is tracked by stage in [architecture](compiler-architecture.md). The immutable `a19b4808` checkpoint lexes all 2,142 corpus files, parses 1,700, and checks 97 support files plus one intended rejection with the supplied Preload and Runtime Support disabled. None of the selected complete projects builds yet. Reviewed original programs have separate generated native evidence, including the book's inlining example; these do not establish full reference-example or standard-library acceptance.

The same checkpoint checks 253 library/example entrypoints and fixtures under two bootstrap profiles. With Preload alone, 199 parse and 42 check (36 library/example entrypoints and six fixtures). Enabling Runtime Support yields no successful checks. All recorded failures are source diagnostics rather than compiler panics. Local evidence is in `artifacts/corpus-a19b4808-bootstrap.json`, `artifacts/corpus-a19b4808-project-roots.json`, and `artifacts/standard-library-a19b4808.json`; their compiler SHA is `a19b48087e7a534920264dd670fc4bcb9e535831c574c4ae1f7d0871df592b6f`.

## How to change it

Preserve reference files. Use an explicit module/library overlay to supply genuine missing public dependencies such as OpenXR and Vulkan Memory Allocator bindings; implement behavior rather than no-op stubs. Rebuild third-party machine code from inspected source with reproducible inputs. Treat intentionally remapped imports and inactive platform branches differently from genuinely missing dependencies.

The implementation order is source/diagnostics and grammar, dependency-driven name/type resolution and polymorphism, typed IR and native ABI, compile-time VM and compiler workspaces, source insertion/reflection/hooks, complete runtime/preload integration, platform libraries and corpus builds. Tests must accompany each feature, including rejection cases.

## Configuration

Platform SDKs, module parameters, compiler build options and module/library search paths affect the acceptance matrix. Unavailable SDKs and native-only dependencies are blockers, not passes. Do not declare the full rewrite complete while these remain unverified.

## Dependencies

Recent consumer programs and library documentation refine the older local source distribution. Static binary evidence can clarify undocumented details; differential execution requires prior approval and VM isolation. Graphics/VR runtime checks require suitable hardware; email examples may be compiled but must not send real messages during testing.
