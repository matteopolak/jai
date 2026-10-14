# Required runtime CI loader boundary

For review/coordinator: the current reviewed generator page distinguishes host
loading from cross-generation inspection, and requires configured libraries to
load, but does not enumerate conventional POSIX filename-prefix candidates.

1. Does `os_load_library(paths, identifier, "example", ...)` try `libexample.so`
   or `libexample.dylib` in each configured directory, preserving explicit path
   and filename spelling priority and shared-before-static fallback? Current
   compiler Jai logical-library resolution does; current provider does not.
2. Confirm that an ordinary native-host interpreter/generator call may load its
   real host generator_platform helper, independent of the requested C/C++ target.
   This does not authorize calling a target-ABI native image on a different host,
   nor granting ordinary cross-target #run arbitrary host foreign availability.

3. The required `bindings-cpp-custom.jai` fixture expects four extra
   FOREIGN_FUNC_DECLARATION and four INNER_WRAPPER_CALL printing callbacks during
   `generate_bridge`. The reviewed append_cpp_wrapper contract explicitly says
   ordinary C++ bridge arguments come from represented arguments, not the Jai
   printing callback. After real library/helper preparation the unchanged test
   fails exactly that assertion. Resolve the consumer/contract mismatch with the
   tooling owner while retaining actual customized overload/POD/reference native
   assertions. The provider owner will not insert meaningless callback calls,
   change counts to green, or extend the bridge contract without review.

Actual final diagnostic values are `inner = 0, foreign = 4`, not inferred values.
The same required assertion fails native O0/O2. The generated Jai declaration
for `make_custom_record` returns a record by value and names the original C++
mangling; the separate C bridge takes a leading out pointer. The unchanged Jai
consumer assumes the bridge signature and fails source checking. The reviewed
high-level workflows do not promise automatic inter-call foreign-symbol/ABI
rewriting. Tooling/reviewer must resolve this workflow mismatch together with the
actual callback behavior; no provider change can legitimately manufacture those
callbacks or reinterpret that signature. Real SDK O0/O2 consumers of the generated
C++ adapters pass all overload, POD result, and reference identity/mutation checks.

Concrete source-matched CI fixture setup defects proceed independently: build its
actual original native C++ input before generation, supply its output directory
through the public library search option, and prepare the real platform helper
on every required native runtime host. No fabricated library, symbol table,
loader exception, target remap, assertion weakening or reference execution.


## Reviewed resolution of question 3 (2026-10-16)

The shared bindings-generator.md contract and coordinator authorization now
resolve this question: bridge emission uses represented arguments and invokes
none of the Jai printing callbacks; ordinary declarations retain their original
ABI and symbols. Aggregate adapters require a separate out-pointer/void Jai
schema. The assigned fixture migration preserves the initial failure receipts,
asserts ordinary-phase callbacks, adds a real pointer-to-value wrapper callback
control, and requires both the correct bridge roundtrip and wrong-schema source
rejection. No generator production change or unresolved callback dependency
remains. Native Linux and separate Mac ASan preparation remain CI obligations.
