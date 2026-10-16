# Declared code-record discriminators

Reviewed compiler-code-records.md establishes inherited discriminator defaults for
Code_Ident, Code_If and Code_Procedure_Call. A plain Code_Node remains UNINITIALIZED.
The independent construction reduction failed because our public declarations
omitted these initializers. The independently authored Derived/Base test shows
ordinary inherited defaults already work for locals, named literals and Basic.New;
no compiler type/name special case is needed.

The actual #as using Code_Node base now carries its declared initializer for those
three reviewed records. Canonical reflected names, field order, visibility, base
storage and ABI are unchanged. Name assignment does not infer a discriminator.
Explicitly replacing the base with its plain default or resetting kind still gives
UNINITIALIZED; compiler_get_code rejects that graph rather than guessing its shape.
No default is invented for other records without reviewed evidence.

Original regressions cover local and allocated defaults, base/derived field address
identity, canonical enum type, named initialization, reflected allocation defaults,
AST reconstruction and explicit-reset rejection. Interpreter/native ARM64 O0/O2
and actual WASI pass. Compiler public records and independent fixtures pass strict
source lint; Rust formatting/clippy pass. The six hash-staged curated yield inputs
now pass check/interpreter and all12native O0/O2 executions with original assertions.
These are own-checkout subset results, not shared whole-corpus acceptance.

Integration's general workspace target routing separately passes the retained
cross-target ELF64 ET_REL machine62 assertion. The scanner signal investigation
remains unconfirmed and suspended; neither this source-level repair nor scoped
application execution establishes its cause.
