# Source procedure contracts

## What it is

A bare external declaration can preserve a typed Jai pack followed by defaulted formals. It describes a source callable contract; it does not supply a native implementation or authorize a library.

## How it works

The pinned OpenJai `join(values:..string, separator:="", before_first:=false, after_last:=false)->string #foreign;` mirrors the ordinary Jai signature in the original String source. Treating it as C ellipsis would erase the pack and reject its trailing defaults.

The parser preserves Jai convention and the original context only when `#foreign` has no library or explicit symbol, the pack is a retained typed formal, and every following formal is defaulted. The resolver publishes `PrototypeOrigin::SourceContract` with the checked Jai signature. Pack collection, named arguments, default binding and source argument evaluation use the ordinary call binder.

Explicit `#c_call`, a named library or an explicit foreign symbol select native foreign behavior and retain the C ellipsis-last rule. This compatibility inference depends on parsed signature structure, never filenames or special function names.

Object/library publication may emit a real typed unresolved LLVM declaration with the Jai context and descriptor-based pack ABI. The VM rejects execution without an implementation provider. Application executable reachability rejects a demanded contract without a checked provider, including retained callback addresses. Object emission does not establish successful linking or execution.

The source-contract tests cover the parsed compatibility rule, native C exclusions, canonical context and pack types, VM provider rejection, LLVM declaration shape, and the same source program succeeding as an object while failing executable reachability.

## How to change it

Keep recognition in `jai-syntax/source_contracts.rs`, semantic origin selection in the graph/local prototype binders, and canonical invariants in `jai-ir` verification. Extend the compatibility rule only with source evidence and explicit native exclusion tests. Do not weaken the native C variadic rule.

Native publication uses distinct executable and object APIs; preserve that typed distinction when adding providers. A provider must prove the actual signature and implementation before a reached application can link. Neither a symbol name nor the absence of a library binding supplies that proof.

## Configuration

There are no new flags. `emit-object` and `emit-llvm` use object publication; `build` requires executable reachability. Actual target selection still determines context and storage layout.

## Dependencies

`jai-syntax` parameter metadata, `jai-types` Jai variadic signatures, semantic call binding, checked `jai-ir` prototype origins, the VM procedure provider and LLVM native reachability/lowering. Native dependency receipts remain separate and confer no authority on a source contract.
