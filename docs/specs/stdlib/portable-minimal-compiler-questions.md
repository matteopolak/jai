# Minimal compiler dependencies

## Resolved dependency: child options projection

Reviewed Compiler get/set_build_options operate on the selected workspace. tests/portable-stdlib/pending/child-build-options-projection.jai explicitly commits O3 and stack_trace=false, asserts correct selected readback in the parent, then reads those settings inside added child source. Clean compilation fails the child assertion. Coordinator official controls build that exact independent reduction successfully. This is not an automatic-inheritance expectation.

Minimal's analogous O2/false assertions remain required. Own fresh full-source guarded capture minimal-guarded-1v1bo9e2/summary.json records 92 passed/four failed: release and backend-last child-options checks in parent O0/O2. No Rust or shared source drift occurred. Compiler worker 10222 supplied the general snapshot fix; no helper-specific result or caller patch was added. This is preserved pre-fix evidence.

## Settled and retired: relative external source positive

Compiler.add_build_file(filename, w, loc := #caller_location) resolves a relative filename against the supplied/default source location. There is no public source_relative_path flag. An ordinary helper call therefore uses its helper's directory. Authorized sanitized coordinator observations at ../producer-handoffs/current-repair-batch/official-workspace-observations.json confirm official direct PASS/helper REJECT, matching the clean compiler.

Minimal default mode rewrites relative CLI paths to absolute before adding them. -no_cwd preserves relative strings and therefore uses Minimal's implementation call-site base. The former positive expectation for an external relative file was wrong. Preserve its old red receipts as an invalid test premise; do not change Compiler's directory rule or compensate inside Minimal.

Correct controls:

- Minimal no-cwd with absolute CLI inputs: builds and executes child output.
- Minimal no-cwd with relative external input: rejects at its helper source base.
- Independent relative-add-file direct call: builds adjacent child.
- Independent helper call with default location: rejects helper/child.jai.
- Independent helper with explicitly supplied main-file location: builds child.

All controls use actual public APIs. Explicit location uses the existing loc parameter, not a new feature. Independent fixtures have complete strict lint coverage. Matching helper-relative rejection does not require a library rewrite.

## Historical evidence and resolved details

All old 80/6 receipts remain unchanged. Only their four projection failures are genuine; the two path positives were invalid. Corrected 92/4 classification supersedes the old blanket two-dependency claim.

Release tier is settled: OPTIMIZED/O2/machine DEFAULT, not VERY_OPTIMIZED. The production body already uses that tier and retains the backend commit quirk. No reference body or executable was accessed by this worker; only expressly authorized sanitized observations were read.

## Post-adoption verification

The corrected options-only compiler patch is integrated as f8c7bde301cea94124693623e279d87394f3699c. Fresh own source-matched tools and full source-set guards produce minimal-guarded-pznqwyxg/summary.json: focused96/0, no failed commands, no source drift. All four formerly failing child option checks and actual native child executions pass. The existing explicit-loc positive and required helper-relative negative also pass.

No unresolved Compiler relative-file question remains, and the projection dependency is closed for this focused shared Mac workflow. Alternate X64 backend/native other-platform validation and workspace-creation failure injection remain verification limits, not an excuse for new API/body workarounds. All old receipts remain unchanged with their true classifications.
