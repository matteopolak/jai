# Workspace API corrective handoff — 2026-10-16

Owned isolated producer: `codex/compiler-workspace-options`, supplied accepted
base `2d0045c6`. No old compiler patch imported. All compiler execution used the
compiler built from this checkout with the isolated
`CARGO_TARGET_DIR=/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/numerics/compiler-workspace-options`.

Confirmed option defect and corrected path classification:

- Selected child options: parent readback succeeds, child assertion
  `options.llvm_options.bitcode_optimization_setting == .O3` fails.
  Durable local evidence: `artifacts/T7numerics/projection-red.txt`.
- The old helper-relative positive premise is RETIRED. Official Jai 0.2.030
  direct addition succeeds and helper addition fails looking for helper/child.jai,
  matching the accepted clean compiler's caller-source anchoring. The earlier
  independent `artifacts/T7numerics/relative-red.txt` and all pre-correction receipts
  are preserved as historical evidence, not credited as a compiler defect.
- Restored the exact original `add_build_file` wrapper and Rust file-resolution
  behavior. Surgical production diff against accepted2d0045c6 has no path hunk.
  Local checkpoint596b2ae0 contains the withdrawn path change and MUST NOT be
  adopted alone. Only the corrected net options patch is offered for integration;
  no history was rewritten.

Final executed validation:

- Source build: `cargo build --locked --offline -p jaic-cli -p jailint --bins`.
- `cargo test --locked --offline -p jaic-cli --test cleanroom_workspace_options
  --test cleanroom_workspace_targets`: **7 tests passed**. Six owned tests cover
  selected workspace projection/ownership, real native child/grandchild output,
  corrected caller-source controls, dynamic updates/reset, invalid selections and
  cross-target host isolation. Exact supplied portable projection and relative
  controls run unchanged for -check/O0/O2. Native children validate actual allocated
  temporary storage sizes131072/65536 and boundary writes, not only print labels.
  The existing object-target test emits and checks seven real object
  formats/machines: Linux/macOS/Windows X64/ARM64 and WASM.
- `cargo test --locked --offline -p jaic --test cleanroom_host_runs`:
  **11 passed**, preserving isolation, capture rejection, result transfer and
  execution budgets.
- `cargo test --locked --offline -p jaic-cli --test cli workspace`:
  **2 passed**, preserving no-output and unwritten-output diagnostics.
- Actual source-built `jaifmt --check` on both changed compiler-api Jai files,
  the owned original projection fixture and all four unchanged supplied pending
  fixtures: **passed**.
- Actual `jailint -D warnings` on the changed API/owned projection and supplied
  pending projection/main/helper bodies: **passed**. The supplied child source is
  compiled by real child controls. Expected missing-file executions remain
  explicit negative tests, not ignored lint/compilation errors.
- `rustfmt --edition 2024 --check` on the three owned Rust files: **passed**.
- `cargo clippy --locked --offline -p jaic -p jaic-cli --lib --bins -- -D warnings`
  and `cargo clippy --locked --offline -p jaic-cli --test
  cleanroom_workspace_options -- -D warnings`: **passed**. Two initial new-code
  chunk-iteration findings were corrected without suppression.

Current corrected receipts are `artifacts/T7numerics/corrected-final.txt`,
`corrected-format.txt`, `corrected-lint.txt`, `corrected-clippy.txt` and
`corrected-clippy-tests.txt`. Historical receipts were not rewritten. Native child
execution is on this Mac host. Interpreter/O0/O2 parent modes each
delete and rebuild real child executables before checking output. Object emission
for other platforms is not native Linux/Windows or WASM execution evidence. No
full corpus, release or combined Minimal acceptance is claimed.

Remaining gates and limitations:

- Root supplied the authorized shared path and all four exact independent pending
  fixtures. Their SHA256 values still match the coordinator's list. The exact
  projection, direct positive and helper negative have now been replayed here.
  Shared Minimal production/runner are available read-only; portable/integration
  owns actual combined Minimal rerun, not this compiler worker. This is no longer
  a missing-source blocker. Shared index remains integration-owned.
- Root's sanitized official observations and updated reviewed shared contracts
  settle caller-source anchoring. Explicit-location and absolute-path positives,
  default-helper negative and helper-local positive now run through all three
  parent execution modes, with real native children. No Minimal/name/cwd
  exception remains. Import-path policy is unchanged.
- Snapshots own string/view contents. Opaque user pointers remain borrowed and
  readback backing storage lasts for the receiving compiler's lifetime. No
  arbitrary pointee copy, shared storage identity across readbacks or automatic
  workspace inheritance is invented.
- Existing unavailable backend/debugger/LLVM facilities remain explicitly
  rejected; storing another declared field does not claim its backend facility
  is implemented. CLI-before-set option projection is a separate recorded
  contract question, not a global fallback introduced by this repair.

The exact producer file hashes are in `compiler-workspace-options-sha256.txt`.
Integration/root alone should update the shared index. Extensions, callable
metadata, anonymous import/load scopes and peer checkouts were not modified.
