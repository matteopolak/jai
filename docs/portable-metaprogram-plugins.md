# Compile-time plugin loading

All three reviewed exports are implemented: canonical Plugin_To_Create,
parse_plugin_arguments and init_plugins. The facade owns the public record and
loads independently organized parser/initialization algorithms under internal/build.
Generated definitions remain module-private; no registrar callback, source pump,
yield procedure or convenience export is added.

Initialization uses the reviewed declared placeholder, signature-available typed
procedure and indirect compile-time call. Scoped Compiler.add_build_string supplies
the inserted body. That body imports the first ordered parameterized name list,
calls real module-qualified factories, appends their actual pointers, assigns the
workspace and aggregates initializer results. Plugins without init reject options.
Later changed names/parameter suffixes fail before factories run; changed options
are passed to the same name list. Empty first initialization defines an empty body
without adding plugin entries. No pointer address is serialized into source.

Importing the module requires init_plugins to satisfy the deferred definition,
including an empty call for a parser-only program. A running native callback is
not a compiler suspension point; the helper is for compile-time build/setup only.
General compiler capability is NEW independent checkpoint89560db9, built into this
worker's assigned T7 target from compiler-plugin-evaluation source. Its exact
limits are documented by that producer in docs/compiler/plugin-registration.md;
the old undeclared-callee draft remains rejected, not required semantics.

`python3 -B tools/check_portable_metaprogram_plugins.py` passes. Parser and empty
initialization execute interpreter/native O0/O2. Real computed-name/parameterized
imports, workspace/options and changed-name rejection execute under interpreter
and normal O0/O2 compiler drivers. Additional cases cover aggregate failed then
successful initialization, no-init options, stable persistent factory identities,
empty-first-call consistency and unavailable-module/private-name diagnostics.
Full owned strict lint uses the real parser program as context to satisfy the
module's reviewed initialization obligation; all positive workflow fixtures also
pass strict lint. No stub or filtered failing body replaces that context.

Evidence target/metaprogram-plugins-active.log; the general confirmed deferred-body
probe also passes (deferred-body-valid-current.log). Immutable :: assignment still
rejects (constant-alias-deferred-compiler.log). Existing real Default build/plugin/
Check workflow was rerun against the compiler and passes
target/default-with-deferred-compiler.log. This does not claim full Focus/corpus
integration; coordinator owns that verification.

Remaining narrow parser clarification: starting_index>0 plus actual plugins retains
scanned ordinary arguments from that index; no-plugin path returns original args
as reviewed. Prefix-before-index inclusion is not separately established. Invalid
indices safely return false/original args as an independent unreviewed-edge policy.
