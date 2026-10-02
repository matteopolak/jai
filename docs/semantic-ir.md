# Semantic IR

## What it is

`jai-sema` resolves syntax into an immutable `Program` whose type identities belong to one frozen `jai-types::Types` registry. Public IR definitions are split into `ir/storage.rs`, `ir/expressions.rs`, `ir/control.rs`, and the program/signature definitions in `ir/mod.rs`.

## How it works

A mutable `TypeRegistry` is created before resolving globals and signatures. Scalar syntax types are mapped to registry identities; procedure types are interned with parameter/result identities, calling convention, and context mode. Successful resolution freezes the registry into `Program`. The implemented procedures currently use the Jai convention with no implicit context; this records current behavior rather than claiming a complete Jai ABI.

Every existing local and global uses the same storage model: `LocalId` or `GlobalId`, a registry `TypeId`, and a common `Place` with a `PlaceKind::Local` or `PlaceKind::Global` root. Local identities include their owning procedure. Integer and boolean place wrappers are constructed privately after checking the registry domain. Integer widths remain an arithmetic-domain detail, not a separate storage identity scheme. Scalar expression helpers expose `type_id(&Types)` as their common registry identity view.

Code generation obtains the registry from `Program::types()`. It resolves procedure descriptors and storage descriptors before constructing LLVM types, uses one typed slot representation for globals and locals, and checks a place's type identity and local owner before loading or storing. Unsupported descriptor variants fail explicitly rather than becoming fabricated scalar layouts. Existing native tests exercise this path for all supported scalar behavior.

## How to change it

Add a new stored value domain through the common local/global/place model. Extend semantic type resolution and the backend's exhaustive descriptor lowering together. Future field/index/dereference projections should extend the common place representation rather than introducing unrelated aggregate storage IDs.

Keep public IR definitions in the focused `ir` modules and semantic builders in the resolver modules. Program storage and scalar wrapper construction are private, so callers cannot construct an invalid program through the public API. The legacy `ScalarType` and `ReturnType` syntax types remain resolver input bridges; procedure signatures and stored values already use registry identities. Multiple-result calls and aggregate storage are future behavior, not implemented by this refactor.

## Configuration

There are no runtime configuration flags. Procedure signature metadata currently records `CallingConvention::Jai` and `ContextMode::None`. Registry identities are process-local handles and must not be serialized as stable source identities.

## Dependencies

`jai-types` owns registry identities and descriptors, `jai-eval` evaluates constant initializers, `jai-syntax` provides input syntax, and Inkwell constructs typed LLVM instructions. Independently installed Clang links generated LLVM in the native regression suite.
