# Shared Hash/Math/File corpus API handoff

## Official-oracle follow-up supersedes the earlier File premise

The prior Hash/Math production fixes remain unchanged and integrated. The
coordinator's actual official controls now prove that a top-level anonymous
#import File remains visible across #load after #scope_file; named module aliases
and ordinary declarations at that scope remain private. The earlier assertion
below that this anonymous import was correctly hidden is WRONG and superseded.
Original54receipt is retained as historical evidence, never relabeled. The active
runner expects anonymous cases to pass and retains independent named/private
negatives. Current clean compiler still fails those positives; no File export
change is made. See [Table/scope follow-up](foundations-table-scope.md) for exact
facts, passing unchanged TOML consumer and compiler-owned reductions. Historical
File discussion/receipt details below describe the pre-oracle investigation.

The foundations owner changed two production files in the actual shared tree.
No compiler, application, File implementation, scalar/time, ABI8, AppKit, model,
tool producer, Extensions, Git or index changes were made. Integration alone
stages/commits. Exact ready paths/SHA256 are in
[status/manifest](status/foundations-corpus-api.json).

## Math: public alias must follow the public overload group

Hash-verified TTWJ24.3 defines its own nominal Vector4, injects a dot_product
overload with #poke_name Math dot_product, then calls Math.dot. Reviewed math.md
declares dot :: dot_product. The facade instead pointed dot at Impl.dot, whose
private overload group cannot see injection into the public facade.

The facade now declares dot :: dot_product. This retains the existing canonical
four vector/quaternion overloads and identities and admits the injected overload.
No wrapper/convenience overload, structural vector conversion, renamed reflected
type or compiler exception was added. A pure namespace alias-injection control
already passed the current compiler; the defect was the facade's alias target.
Original red/green receipts are in the assigned T7 source-reduction directory.

The independent regression checks two different nominal Vector4 types with the
same reflected name, all four canonical overloads, the injected overload and
procedure identity. Interpreter/native Mac ARM64 O0/O2 pass. The unchanged
ACCESS-verified TTWJ source prints dot_product is:80 with the source's spacing
at interpreter and native O0/O2; no application edit was used.

## Hash: classify reflected variants by their scalar base kind

Actual admitted wait_group/module.jai defines User_Event_Id as #type,isa u64
and uses Table(User_Event_Id,...). Its explicit fd/event hasher passes ordinary
s32/cast(int) values and the default seed; those already worked. A custom struct
key with an explicit scalar-field hasher also worked. The failure was the
nominal default key reaching the scalar guard as reflected VARIANT.

The reviewed clarification in foundations-corpus-api.md specifies recursive
variant unwrapping for scalar admissibility. The private Hash implementation
now follows variant_of until reaching the base kind in both the #modify guard
and the float-vs-integer branch. It preserves T, nominal reflected identity,
the exact u32 seed/default and existing integer conversion/Knuth or byte-hash
formulas. The helper is file-private; no public export was invented. Arbitrary
records and struct-backed wrappers remain rejected. Distinct-wrapper conversion
remains the reviewer's stated unverified boundary; no new conversion rule is
introduced beyond the existing cast,no_check path.

The unchanged ACCESS-hash-verified wait-group example changed from a precise
get_hash(User_Event_Id) failure to -check exit0. Original regressions verify
nested isa, signed integers, bool, enum, pointers, float32/64 (including negative
zero), caller seed, canonical reflection identity and actual nominal-key table
insert/find/free. Existing scalar/FNV/float vectors and privacy negatives remain
unchanged and pass. Native Windows/Linux/device execution is not claimed.

Cluster's admitted main imports wait_group; the available sgpu application files
contain no direct get_hash call. Their whole configured builds are for the sole
integrator to replay with the permitted dependency/environment setup. Earlier
reference failures do not establish an obsolete API. No excluded SDK/bundled
source was inspected to guess another overload or seed.

## File: actual export works; preserve visibility

File already exports get_absolute_path(relative_path:string)->string,bool.
Qualified calls and public anonymous imports from a #loaded source work in
interpreter/native O0/O2. A file-private import correctly remains unavailable
to a different loaded file. No missing File body/signature/export was found.

The now-admitted original application loader
uniform/modules/stubborn/run.jai was verified as SHA256
0e4c47d33ae65811636379ab57d4204a5dfd2bf1b9857656424380f4bcb702ae.
Its actual File import202 follows #scope_file170. Imports at2/3 are inside
INTERNAL_PREAMBLE string text, not loader imports. Uniform first.jai itself
imports only Basic/Compiler/String under its own file scope, then uses
unqualified get_absolute_path in a #run branch. The configured case is mode run
with extra_args ['-','test'].

Independent matching #run controls demonstrate that those arguments select the
test branch, that qualified File.get_absolute_path executes successfully there,
and that the private-import unqualified call fails. The previous official
reference receipt says build passed without a default executable, not that
these tests ran. Coordinator/reviewer must compare this precise scope/argument
reduction and classify the premise before a compiler/visibility change. No
unsupported Basic/Compiler/String File re-export or private-import leak is added.
The batch is deliberately not marked fully complete while that comparison is
pending.

## Reproduce and integrate

Use source-built tools from current shared Rust, with all outputs under the
assigned foundations T7 namespace:

```sh
CARGO_TARGET_DIR=/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/shared-target cargo build --locked --offline -p jaic-cli -p jailint
python3 -B tests/portable-stdlib/foundations-corpus-api/verify.py
```

The runner builds unchanged real jaifmt, formats/checks owned sources, executes
nine positive fixtures at interpreter/native O0/O2, runs full Math module and
fixture warnings-denied lint, checks three privacy/admissibility negatives and
the exact #run argument controls, and checks watched production hashes before
and after. Assertions stay enabled. Native -no_backtrace_on_crash disables only
the optional unrelated crash-helper dependency; no ABI8 assets are modified or
mixed and no native failure is hidden.

Latest stable scoped receipt: api-family-proof-8cj3a0qd/results.json under the
assigned foundations T7 root,54 recorded commands and27 actual runtime
executions. supported_checks_complete=true; complete=false and exit1 explicitly
preserve the uniform premise comparison. The first new-Hash receipt failed its
source guard because the formatter changed whitespace; it is INVALID as a
stable proof and was rerun. Passing runtime commands alone were not counted as
a stable checkpoint.

Additional before/after, actual original consumers and old negative checks are
in shared-hash-math-file-3ptdxozc. No broad corpus pass, native-platform expansion,
remote operation or shared native build was performed. The sole integrator must
combine these exact ready files with other owners' verified work before the
next whole-corpus run.
