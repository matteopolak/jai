# Compiler implementation version

`compiler_get_version_info` exposes this Rust implementation's Cargo package version through the checked Jai Compiler API. It does not identify the supplied native Jai compiler.

## How it works

The semantic catalog accepts the marked Jai declaration `(version_info_return: *Version_Info) -> string` with implicit context. Its nominal source struct must contain exactly `major`, `minor`, and `micro`, in that order, each `s32`, from a selected compiler API origin. An ordinary function with the same name retains its ordinary behavior.

The VM returns `CARGO_PKG_VERSION` as source string bytes. A null pointer skips the write and target-layout preparation. A non-null pointer receives the major, minor, and patch components in actual VM memory. The `micro` source field maps to Cargo's patch component. Target-layout work, memory validity, mutability, value bounds, and fuel are checked before replacing the record; failed executions use the normal VM transaction rollback.

## How to change it

The package versions in the Cargo manifests determine the reported identity. Extend the source schema in `modules/compiler_intrinsics/schema.rs` and the VM adapter in `execute/compiler_version.rs` together if the source ABI changes. Keep the memory adapter separate from host request handlers: this binding reads compiler identity and updates caller-owned VM storage, without a host side effect or a cached pointer crossing graph rebuilds.

## Configuration

There is no runtime override. Cargo supplies the version components when building `jai-vm`; source `s32` range checks reject components that cannot be represented. The normal VM fuel, allocation, and value limits apply.

## Dependencies

The implementation uses selected module provenance, the semantic nominal type registry, verified procedure signatures, and VM checked memory. It adds no external dependency and executes no supplied native code.
