# Minimal build workflow

The exact two exports in `specs/stdlib/modules/minimal-metaprogram.md` now have
bodies. Build creates the named child workspace, parses only the reviewed four
options, preserves source order, applies the limited path heuristic and cwd
policy, configures first-source output, adds actual files, and disables parent
output/added-string writing. Backend assignments alone retain the reviewed
uncommitted-options quirk. The refreshed release contract selects OPTIMIZED
(LLVM O2, machine DEFAULT), with stack traces disabled. There is no status return,
plugin dispatch, intercepted message pump or delegation to Default_Metaprogram.

The focused shared-source runner is `tools/check_portable_minimal_shared.py`.
Current receipt `minimal-shared-zv2m8cnf/results.json` records **80 passed, six
failed**. Real default, unknown/empty-option, uncommitted backend, first-source
directory, release and last-backend builds produce and execute native child
programs under parent O0/O2; the path predicate also runs interpreter/native
O0/O2. Empty-input/no-parent-output, real missing-source failures, six desktop
source contexts, strict complete-context lint and formatting are checked.

Failures are retained, not accepted as completed behavior:

- Two no-cwd relative-source builds: the unchanged relative filename is rebased
  by Compiler.add_build_file to the internal helper's source directory.
- Four child settings checks: get_build_options() in the child reports defaults
  rather than the explicitly committed O2/no-stack settings. The independent
  child-build-options-projection reduction reproduces this without Minimal.

See `specs/stdlib/portable-minimal-compiler-questions.md`. Actual child optimization
is not certified by these erroneous reflected defaults. Parent O0/O2 runs are
not a claim of inherited child settings. The required alternate X64 backend,
workspace allocation failure injection, native other hosts and cwd-based import
search still need separate verification.

Draft/test corrections are recorded separately: release was corrected from
VERY_OPTIMIZED after the precise review arrived; the observation fixture used a
nonexistent LLVM field; test entry files now reside in their own scratch case
directories because the compiler selects metaprogram cwd. AppleDouble metadata
files are excluded from the no-executable check, never counted as native output.
No caller or corpus source was patched.

Fresh-cache verification: a new empty own T7 Cargo target built current shared
Rust with locked/offline dependencies and no source drift. The rerun
`fresh-shared-source-31vxb36a/minimal-shared-4ks0z52r/results.json` independently
reproduces the same 80 passed/six failed. A new direct-versus-helper relative-file
control and the original child-options reduction reproduce the two dependency
classes without Minimal. This is current compiler evidence, not a stale-cache
diagnosis or a completed workflow claim.

## Current integration after reviewed path correction

The historical80/6 receipts above remain unchanged. The coordinator official controls settle the directory rule: add_build_file uses its explicit/default caller location. Relative helper lookup failure is expected, including Minimal -no_cwd relative external paths. No production path/cwd workaround was made. The maintained runner now supplies absolute source arguments for the no_cwd successful build and adds an exact relative-callsite rejection in both O0/O2 modes. All previous child optimization/stack assertions remain.

Current combined compiler receipt integration/import-scope-ea7f5673/minimal-shared-fhb0l09x/results.json records92passed/4failed. The four failures are O0/O2 release and backend-last child-options checks. Source hash guards, native child execution, exact callsite failure, no parent output, complete contextual lint and formats pass. This workflow remains PARTIAL until the child-workspace projection owner fixes those four checks. The two former path failures were incorrect positive premises, not compiler defects.
