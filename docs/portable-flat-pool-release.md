# Flat_Pool reservation release

Reviewed flat-pool.md requires fini to release its reserved address range.
An independent real-OS regression found that Native.release was inside optional
Basic.assert. With the STAGED default Basic ENABLE_ASSERT=false, fini cleared all
four ownership pointers while leaving the actual mapping live. This is a genuine
production defect, not an obsolete expectation. The new fixture checks with
unconditional exits, not disabled assertions.

Native.release now executes outside assert. On failure it logs an error, retains
all owner fields, asserts if enabled and returns if assertions are disabled or a
returning handler permits continuation. Retry ownership is an independent safety
policy where the reviewed contract does not define SDK release failure. Public
record layout, init parameters, defaults, OR overwrite semantics and allocator
behavior remain unchanged. Failure cannot silently discard a live reservation.

Run `python3 -B tools/check_portable_flat_pool.py` with the own source-built
CARGO_TARGET_DIR. Real C SDK probe and Jai interpreter/native Mac O0/O2 verify
that mprotect succeeds on the live range and fails after fini. Both default
assertion configurations pass; the original complete public Flat_Pool fixture
runs with assertions enabled. A real unaligned munmap failure with assertions
disabled logs, preserves all owner fields and keeps bytes live; restoring the
valid base permits a successful retry. Whole owned strict lint and format/--check
pass. Native Linux/Windows remain pending. No mocked OS or library override.

Test correction, separate from production fix: initial mincore-after-unmap
expectation was incorrect on macOS. Native C demonstrated return0/residency-128
on an unmapped range; Apple's mincore documentation promises residency reporting,
not that unmapped memory produces the Linux error. The fixture now uses the
independently checked mprotect/ENOMEM property. Official native documentation:
https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/mincore.2.html
Original failure preserved in target/flat-pool-release-red.log; corrected genuine
defect in flat-pool-release-red-corrected.log; passing evidence
flat-pool-release-final.log. The corrected test passed enabled before production
changes and failed disabled, demonstrating the configuration defect specifically.

A first post-fix test composition overlapped another runner writing the same
target-only foundation tree and failed. Both runners were rerun sequentially;
only the final isolated results are verification evidence. Shared staging must
not run concurrently. This is a test orchestration limitation, not a production
fallback or disabled assertion counted as coverage.
