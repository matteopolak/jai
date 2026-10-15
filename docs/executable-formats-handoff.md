# Executable formats final handoff

All 508 refined reviewed rows are present; zero remain. The original 507-row
scope gained Arch_File during review. Counts include ABI declarations/constants;
supported format variants and ownership policies remain those documented in
portable-executable-formats.md and executable-text-formats.md. The scope JSON
distinguishes committed and draft declarations.

## Canonical dependency adoption

The coordinator confirmed canonical Debug_Info.Guid in independent owner commit
822da42b, verified by 9a961389, and explicitly approved snapshot 8b134bdb for this
worker. The canonical declaration is stdlib/Debug_Info/codeview-type-model.jai,
exported by its module.jai. It has data1:u32, data2:u16, data3:u16, data4:[8]u8.

The approved module's load closure contains 26 files. Thirteen differed from this
isolated snapshot; they were adopted byte-for-byte, with no owner implementation
changes, in **1432c9f4**. The dependency manifest records exact paths/hashes.
No original/reference source or history was read; only the explicitly approved
independent snapshot and reviewed contracts were used.

The final executable checkpoint is separate from dependency adoption. A clean
integrator already using 8b134bdb can retain those existing dependency files and
take the executable checkpoint on top of the earlier worker batches. No local
adoption, public-import, no-DCE, layout, strict-lint or formatter conflicts were
encountered. This reports local verification, not an unperformed shared merge.

## Final records and evidence

Coff_Raw_Codeview_Info uses Debug_Info.Guid directly. Coff_Codeview_Info retains
the reviewed using base and pdb_path string. There is no local duplicate Guid,
fallback alias or dependency-presence conditional.

tests/portable-stdlib/executable-codeview.jai imports both public modules and
checks nominal type identity, reflected member types/order, Guid size16/align4
and offsets0/4/6/8, raw CodeView size24/align4 and offsets0/4/20, and derived
size40/align8 with base/path offsets0/24 on the verified 64-bit targets.

The test consumes real CodeView data from an independently authored C object
linked to PE/PDB with LLD. It compares raw Guid/age bytes and the returned path
against an LLVM readobj oracle. Wire bytes are copied into aligned ABI storage;
the test does not assume arbitrary file offsets have native alignment.

Source tools were built with Cargo jobs=2 under the assigned T7 CARGO_TARGET_DIR.
The complete nine-suite runner verifies interpreter and native Mac arm64 O0/O2,
including all preserved object/archive/lexer/TBD tests, allocation/borrowed
lifetimes, malformed/truncated inputs, SDK tapi symbol equality, formatting and
warnings-denied lint. Canonical Debug_Info's approved module also passes strict
lint and all 13 adopted files pass formatting unchanged. Linux/Windows x64
cross type checks include CodeView; those targets were not executed.

## Review read-scope deviation

The optional final reviewer accidentally ran a broad documentation search outside
its assigned narrow file list. It reported incidental matches in this checkout's
portable executable docs, plan/inbox, developer-tools plan/deviation docs and
integration-deviations status doc; truncated output prevented a complete match
list. It reported no original/reference bodies, raw reference logs, harness/auth
data or quarantined integration source access, and no tracked edits. The worker
did not read that incidental text. Completion evidence is the worker's direct
public-import/layout/oracle/native tests; the broad search is not implementation
or compatibility evidence. This deviation is recorded for the clean integrator.
