# Typed program configuration ordering

This records the independent reduction and its general compiler repair. Basic's
reviewed empty first parameter list and five program parameters remain correct.
The repair changes module contract scheduling, with no Basic header reversal,
nominal type coalescing, runtime substitution or alias refresh.

`tests/producer-requests/typed-program-interface/basic-empty.jai` configures the
public Basic interface with four independently authored empty hooks and an empty
void entry point. Before repair, the own approved603/readiness compiler rejected the setting as
already used with another value, without checking any array operation. Numerics
separately reproduced that error on the current canonical facade before its
array changes. The obsolete advertised portable debugger-interface fixture was
absent when inspected; the compiler-semantics pending fixture was present.

The generic reduction uses only independent modules. `plain-import.jai` imports
Choice plainly to obtain its exported scalar Number alias, and also configures
Choice's program Implementation with Hooks. Hooks' procedure parameter uses that
public scalar alias. The original compiler rejected the configuration after
resolving the default. `main.jai` removes that hook dependency and passes.

The annotation controls preserve the dependency and change only the declared
program setting's annotation. Before repair, `$I` failed, as did `$I/interface Protocol`;
`Type` and the untyped declaration pass. An ordinary first-list interface
parameter control passes and asserts that its two nominal Token types remain
distinct. These were own compiler observations during reduction. The coordinator
subsequently confirmed actual official Jai0.2.030 BUILD acceptance of the exact
public Basic, plain-import and baseline controls. Input SHA256 values are
respectively f467ea6162ca7877fe1277c3042370111c7f4c536ff7974be071061a94df9f5b,
b9b257185a6aec62f9dfd32fa951ed089a137ddf353f702147715245d9461445 and
33db4c1776fc59be1b34af3a5706b237f92336e20cf385400629b735be59e926.
Only sanitized verdicts are supplied; no generated program was executed by root
for that oracle and no reference bodies or logs are supplied.

Before repair, the evidence was narrow: the ModuleParameters declaration arm
resolved polymorphic parameter constraints before load_module's final
apply_program_params. Reading an unrelated public alias through the plain
import can therefore resolve the default before the configured import finishes
evaluating its hook type. The same three functions (header arm,
note_program_params and apply_program_params) match the current clean shared
source byte for byte. This established the scheduling boundary; no genuine cycle bypass or
overwriting of resolved values is introduced.

`dependent.jai` deliberately uses the same configured import alias while
constructing its own setting. It rejects with a circular dependency and remains
exploratory, not a positive test. A first attempt at the ordinary control failed
because its generated header accidentally retained the second list; that source
and failure receipt are preserved separately. The corrected first-list control
passes.

All captures are in the worker's T7 runtime-603 namespace, located by
`scratch/typed-program-interface-current.json`. Initial source versions,
post-format sources, exact commands, diagnostics, source hashes, function
comparisons and oracle-request inputs are preserved. Pending failures are not
converted into accepted language rejections or counted as functionality passes.
No /Users/matthew/projects/jai-reference/compiler implementation, original Focus runtime body or peer binary
is read or executed.

## Implemented contract scheduling

Header registration now retains each polymorphic constraint with its parameter
entity and original file evaluation scope. It does not evaluate a default while
a hook's signature is being formed. Existing program-setting binding then applies
the written value. The module expansion scheduler validates the retained
contracts before conditional expansion and at its final module sweep, including
unused contracts. Newly discovered scopes return to normal expansion.

Each contract has Waiting, Checking, Checked or Failed state. Reentrant expansion
does not restart an active contract; actual constant-value cycles still fail in
the resolver. A failed contract retains its diagnostic for subsequent expansion.
Bindings are published only after successful matching. An explicit constant
binding cannot be replaced by a conflicting import even while its entity remains
unresolved.

Final body checking now alternates normal settlement and unreferenced-body
checking until body-only imports stop adding unsettled module/file scopes. This
driver dependency hunk received root ownership coordination approval; no
runtime-configuration or reachability function is changed. It ensures
late unused invalid contracts reject and that modules discovered by late
contracts execute their normal top-level checks. A one-shot contract-only final
pass was rejected by meaningful negative tests.

The twelve new core controls cover the official-positive topology, polymorphic
and early-condition variants, ordinary nominal separation, unused/default
contracts, conflicting settings, a genuine value cycle, repeated-error retention,
body-only imports, late-imported top-level failure, and exactly-once/idempotent
late-module execution. Existing module, interface, runtime dependency,
runtime configuration and bootstrap contract suites also
pass. The Basic hook fixture passes checking and actual interpreter execution
with current reviewed canonical array declarations. Tools remain qualified to
the own approved603/readiness compiler base plus this exact patch; no proof is
projected onto the current root compiler until integration replay.

No stdlib or application source changes belong to this compiler patch. Actual
macOS ARM64 O0/O2 builds and executions of the generic and Basic hook controls
pass; native proof is recorded separately in the T7 ready receipt. This does not
resolve or claim causality for Focus's separate custom runtime size-constant transport.

## Private runtime startup dependency

The NEW canonical private runtime initializer reads
`internal/compiler-api/runtime-config.temporary_storage_size() -> s64
#no_context` once per context. The helper calls the private
`__jaic_runtime_temporary_storage_size` intrinsic. That local supplies size and
malloc extent; original data/size, zero-size null behavior and cleanup remain
intact. Runtime_Support still has exactly three required boolean parameters.

`tests/producer-requests/runtime-startup-1048576.jai` sets the public build option
to 1048576, then checks initialized current/original extents, pointer equality,
null behavior and the allocation's last byte. Source checking, strict lint and
actual interpreter execution pass using the source-pinned reviewed Basic
snapshot. This is not a reproduction of Focus's callback-reader guard or proof
of its cause. Main compiler owns runtime_config.rs and retained callback/bake
analysis. No mutation of that code is made here, and no native program executes
while integration holds the native lease.
