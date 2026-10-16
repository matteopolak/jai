# Typed generic struct arguments

Every declared generic struct parameter type is applied before the argument is
bound into the instance. Previously `struct_arg_value` converted aggregate bytes
but extracted scalar and procedure values directly. A generic lambda could remain
uninstantiated despite a concrete procedure parameter type; metadata generation
then tried to serialize that generic procedure as a runtime callable. Incompatible
unused callbacks and out-of-range integer parameters could also be accepted.

The binding path now uses the existing typed constant conversion for every
declared value parameter. Procedure arguments select/specialize against the
declared signature, including dependent argument types. Scalars receive normal
implicit conversion and narrowing checks. Aggregate conversion keeps the same
implementation. Type parameters retain their established type-value handling,
and untyped parameters retain their compile-time value semantics. No new overload
selector, runtime pointer representation or module-specific rule is introduced.

The original typed callback reduction was red before this fix. It now verifies
lambda and named generic specialization, overloaded callback selection, default
versus explicit instance identity, concrete reflected argument/result types,
real callable storage and invocation through that storage. Negative tests preserve
incompatible argument/result and integer narrowing diagnostics at binding, without
invoking the supplied callback. Scalar defaults retain their canonical instance
identity and reflected types. Additional context controls cover ordinary callbacks
and Any/aggregate-result callbacks through a nested allocator override; these pass
without a context implementation change.

The unchanged authorized TOML custom-handlers application now passes source
checking. Its actual interpreter/native executions remain red at the first
serialization assertion: an underscored key is emitted quoted. Native ARM64 O0/O2
builds both succeed, and both runs fail that assertion; this is not a runtime pass.
It matches the separately reviewed Basic `is_alnum` defect assigned to the stdlib
owner. The source-check closure is not projected onto the whole corpus.

The older untyped procedure-parameter reflection reduction remains explicitly
pending. The actual Hash_Table callback parameters have declared signatures, so
that broader representation question is not required to solve this compile
blocker. No uninstantiated procedure address or absent parameter value is fabricated.
