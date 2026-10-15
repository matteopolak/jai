# Basic temp / exit LSP investigation and final merged verification

The reported resolution failure is partly reproduced: qualified `Basic.temp`
already typechecks and has typed hover/completion, but the unpatched current
candidate returns no definition target. Ordinary module-qualified scalar values
have the same defect. The owned fix preserves the entity chosen by actual module
lookup in the existing named-expression reference mechanism. No symbol-name
exception, Basic export, runtime behavior or bootstrap definition changes.

The intermittent `exit(1)` failure was not reproduced in these minimal documents.
Both qualified and unqualified calls resolve to `(status: s32)`. These results do
not rule out an issue in a larger project or another editor/platform setup.

## Contracts, failure classification and original reduction

The oracle is the reviewed [Basic spec](../specs/stdlib/modules/basic.md):
`temp :: Allocator.{temporary_allocator_proc, null}` and POSIX/Windows
`exit :: (status: s32)`. The
[module language contract](../specs/jai/modules-workspaces-and-examples.md) and
[core declarations/types](../specs/jai/core-syntax-and-types.md) establish named
imports, qualified lookup, immutable values, inferred declarations and file scope.
This is a genuine IDE identity/navigation defect, not an obsolete stdlib API or
an incorrect expectation that `temp` is callable.

An independent reduction needs no stdlib:

```jai
// modules/Values/module.jai
scalar :: 42;

// main.jai
Data :: #import "Values";
main :: () { value := Data.scalar; }
```

Before the fix, hover and completion have the scalar's type but go-to-definition
on `scalar` is empty. Module-member lookup resolves an entity, then the IDE
recorder retains only a generic member name. `sema/structs.rs` now retains the
chosen entity after operand resolution; `sema/ide.rs` consumes it for qualified
named expressions as it already does for identifiers. Recording after resolution
prevents a nested initializer from substituting another entity's identity.
The association also includes its exact source span. A failed expression cannot
leave a declaration identity that a different expression consumes. An independent
negative regression verifies that a string literal's builtin `count` never
navigates to an unrelated failed declaration.

Compiler ownership coordination was recorded in
[LSP progress](../status/lsp-progress.md) before compiler files changed.
The overlap is IDE-only; coordinator/compiler review remains required at merge.
The new original `qualified_values.rs` regressions cover scalar/aggregate values,
mutable globals, builtin type aliases, a module alias, nested initializers,
ordinary struct fields/procedures, distinct same-named exports in two modules,
file-private rejection, damaged documents and restoration. They do not broaden
visibility or invent replacement APIs. Independent review of these new tests
remains a coordinator handoff requirement.
The owned fix and regressions are `cf7dd80` plus required follow-up `5214e9c`.
The complete overlap is `sema/{structs,ide,expr}.rs`; consume both commits.

## Actual native candidate evidence

The source-only dependency snapshot reads explicit Rust compiler/LSP/lint package
sources and the independent production stdlib from authorized `integration-clean`.
It never reads quarantine, Git history, transcripts, corpus vendor bodies or
reference binaries. It narrows only the local build workspace's member list,
copies repository lint configuration, and source-builds `jailsp` into a
per-snapshot subdirectory of the assigned LSP T7 target. Peers are not modified.
The target path is keyed by the full local snapshot path, so copied workspaces
cannot reuse the older isolated compiler's build metadata. Non-source SDK links are not followed or
copied; the sole excluded link is the optional native libclang dylib. No Jai source
is replaced or omitted for a passing test.

The original unpatched and patched runs have the same captured input fingerprint:
`54e154044d20746ac1d12a98c485bbf966d2a09f7208e3efe6e263591f74ca27`.
With the owned IDE-only patch, effective source fingerprint is
`329c43f0dccd0df227069bf0e81ce6fc23f7c99869c519ccbfd372afbfdd5bbe`.
Final native executable hash is
`8109813e97c836043e08ff23d0f91df6008780521b2c019ec2429a7f0f62cd44`.
Per-file hashes, patch hash, source-build output, executable hash and complete
sent/received JSON messages are durable in `artifacts/lsp-basic-resolution/`.

- `candidate-20261015`: original red evidence, including both fresh qualified
  documents with missing temp definitions and 11 passing unqualified phases.
- Its `qualified-complete-red` directory: six qualified phases; temp definition
  fails throughout, while all exit queries pass.
- `candidate-span-verified-20261015`: four fresh native server processes, 38 versioned
  document phases, no failing assertions and no server stderr. Covers qualified
  and unqualified names, fresh damaged documents, UTF-16 positions after a
  supplementary-plane character, ranged partial-expression edits, repair,
  changing/restoring the exit argument, partial `tem`/`exi` completions, restoration,
  document close/reopen and clean LSP shutdown.

The initial supplementary regression replay using the shared old-worker target
failed to compile with a missing `PRELOAD_ENTRY` despite the captured candidate
source declaring it. That failure remains in `qualified-values-red.log` and is
not counted as coverage. Replaying in an isolated fresh target compiled and
reproduced all three navigation regressions; see
`candidate-20261015/qualified-values-red-isolated.log`. The patched fresh target
reproduces the passing native result, and its separately captured unit/Clippy
logs provide current-dependency source verification.

Production runtime support, stack traces, canonical preload and real Basic imports
remain enabled. Native server execution is verified on the macOS host; the Jai
documents and their `exit` calls are never executed. Protocol `shutdown`/`exit`
messages only terminate the test server normally. Expected partial-edit errors
must stay local and disappear on repair; warnings remain recorded.

The separate independent source regression uses a virtual module and disables
runtime support to avoid relying on library contracts. Its pass is not the native
candidate proof. The local compiler library's 146 tests, the selected 76 LSP
tests, scoped Rust formatting/Clippy and Python source compilation pass. The
freshly isolated patched candidate compiler's 164 library tests, four original
regressions against that candidate, and production LSP library/binary Clippy also
pass. An earlier shared-target candidate unit run executed 146 tests from the
older cached compiler and is excluded from candidate verification.
No broad legacy replaced-stdlib suite or full corpus/CI result is
claimed for this investigation.

## Run and change the checks

Generate the owned three-file IDE patch from this branch's diff before integration,
then use a new durable output directory:

```sh
python3 tools/lsp_basic_resolution.py \
  --candidate ../integration-clean \
  --output artifacts/lsp-basic-resolution/new-candidate-run \
  --target-dir /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/lsp/target \
  --ide-patch artifacts/lsp-basic-resolution/qualified-values-span-ide.patch
```

The optional patch applies only to that local source snapshot and is checked
before application. A patch conflict is a real integration blocker. Output
directories must be new, so previous evidence is not overwritten. Python standard
library, Git, Cargo/Rust and the candidate's pinned Cargo dependencies are required.
No supplied server binary or remote service is used. The runner returns nonzero
on any failed check, transport error or source-build failure.

## Mandatory final merged checklist

- Integrate/review both fix commits, the three IDE compiler files and original regressions with the
  compiler owner. Preserve current compiler/bootstrap/library integration work.
- Source-build the final merged production `jailsp` with its final independent
  production stdlib and normal configuration. Run this tool **without**
  `--ide-patch` against that final clean merged source tree; record new source and
  executable hashes. A patched local candidate pass does not satisfy this step.
- Require diagnostics, typed completion, hover and actual source definitions for
  both symbols in all fresh/incremental/repair/reopen scenarios. Keep error and
  warning evidence; no symbol-specific fallback or disabled feature is acceptable.
- Rerun the independent compiler/LSP tests and relevant integrated corpus/native
  CI checks. Test other supported hosts in their normal CI/editor environment;
  this worker's native proof covers macOS only.
- Recheck the user's original project/editor example when supplied. It is absent
  from this minimal investigation, so the intermittent exit report remains open.

The final merged check is explicitly outstanding. No version, release workflow,
remote action, publication or peer checkout mutation was performed.

## Independent integration regression evidence



An original JSON protocol regression reproduced Basic.temp hover as Allocator but returned an empty definition list before the fix. Module value lookup discarded its selected declaration entity and recorded a generic struct-member reference. The compiler now retains the successful qualified module entity only until its matching member token is recorded. This also fixes qualified globals and primitive aliases without symbol-name exceptions; procedure/type handling and private export checks remain separate.

The exact independent document is:

```jai
#import "Basic";
Basic :: #import "Basic";
main :: () {
    allocator := Basic.temp;
    assert(allocator.proc != null);
    exit(1);
    Basic.exit(1);
}
```

Source-built JSON requests verify hover/definition for Basic.temp and exit, qualified exit hover, completion after replacing temp with te, and repaired diagnostics/hover/definition after a range edit restores temp. The document has no #run and is never executed. A separate original Values module verifies constant/global/primitive-alias definition locations. All37 features and5 modules tests pass against this production stdlib; Rustfmt and workspace Clippy warnings-denied pass. The minimal exit issue did not reproduce; no exit-specific production behavior changed. Final combined workspace replay remains required after later merges.

Command: cargo test --locked -p jai-language-server --test modules --test features. Selected stdlib: this worktree/stdlib, preload/module.jai. Parent revision41e78573 plus the committed module-entity repair; exact later measurement identity is retained in status/mac-current-baseline.json.

The independent d2577883 production implementation is superseded by owner cf7dd80+5214e9c; both independent JSON/member tests are retained and must be rerun against that single owner implementation. Final production protocol verification will use the actual merged binary and actual production stdlib, without source/manifest overlays.
