# Caller-owned fonts and strict Objective-C source discovery

The FreeType ABI/runtime fixture accepts exactly one caller font argument.
The runner obtains it from the provisioned `JAIC_TEST_FONT_PATH` and passes the
same path as an argument in interpreter and native modes. The fixture creates
and frees its own terminated path, and frees the argument-array storage.
There is no embedded Mac font path, environment lookup inside the program,
default/fake font, Linux skip, or runner rewrite of the fixture body.

All prior ABI sizes/offsets and reflected-name checks remain. Real FreeType
initialization, face creation, scalable/horizontal flags, pixel sizing, rendered
nonempty glyph/bitmap data, invalid-font rejection, face and library cleanup
remain required. Source checks do not establish these native effects. Current CI
provisions DejaVu on Linux and Arial on Mac; actual Windows provision/runtime is
a separate required gate. Integration owns runner argv wiring in verify.py.

The two Objective-C selector audits share strict source discovery. An independent
AppleDouble resource-fork fixture reproduced the failure class: the original
discovery includes binary metadata as Jai, and strict UTF-8 reading rejects it.
The narrow test-only filter excludes only files named `._*` with the AppleDouble
v2 signature, complete header/table and in-bounds nonempty entry extents.
The format is documented in [RFC1740 appendices A/B](https://www.rfc-editor.org/rfc/rfc1740).
The name alone never excludes a source. Ordinary invalid UTF-8, legitimate
`._` source, truncated headers and malformed metadata remain visible.
Read failures now include the exact path; decoding remains strict.

Three filesystem-only Rust regressions verify these boundaries; they invoke no
Objective-C SDK code. Argument-count and native-alias parser controls retain their
assertions. No selector, expected-missing list, public receiver contract or
production binding changed. The runtime-selector gate remains required; its
subsequent SDK result is qualified below without changing expected misses.

The current shared inventory has 1,004 Jai files, no sidecars and no UTF-8 failures.
A real independent T7 transport reproduction created two additional 4,096-byte
sidecars for two authored Jai files. Both have the AppleDouble v2 header
00051607000200004d6163204f53205820202020202020200002 and fail strict UTF-8 at
byte 37. Their exact paths, sizes and headers are preserved in an own inventory
receipt. This proves the transport/discovery failure class with actual metadata,
not only constructed records. Root subsequently supplied the matching original
failed-file evidence summarized below; no access to that capture is inferred.
The original full-suite rerun remains a separate required gate.

The focused source tool checks the FreeType fixture and complete binding lint on
six desktop configurations and guards immutable source/font hashes. Its optional
`--inventory-only CLEAN_STDLIB --output-root OWN_OUTPUT` reports all original
strict decoding failures, paths and header bytes without source excerpts or lossy
decoding. Inventory mode deliberately reports binary sidecars too, to diagnose
the original failure. It does not replace the narrower Rust discovery filter.
All captures stay in the bindings T7 namespace. No host FreeType or Objective-C
SDK execution was performed under the held root lease.

After root explicitly released the lease, the real caller Arial fixture passed
in interpreter, native O0/O2 and ASan/UBSan modes with all original ABI/glyph/
lifetime assertions. The focused C oracle uses actual FreeType 2.14.3 headers
for the same four sizes and two offsets; it substitutes no record or result.
The initially selected Homebrew static archive lacked its transitive link
closure in this harness and failed all three native links. That receipt is
preserved. The corrected harness explicitly selected the real shared SDK
provider under its canonical basename, with its target and hash recorded.
This proves the shared SDK profile, not repair of the initial static closure.

Root supplied the original failed f1 inventory: 1,003 invalid untracked sidecars,
including Adpcm/._module.jai and Android/._declarations.jai, with the same
4,096-byte AppleDouble header. The actual-copied source audit now passes on our
copy with 1,004 real sources and 1,004 sidecars. The original runtime selector
test reaches the SDK and remains RED for exactly four of 874 selector uses:
NSEvent class convertPoint:fromView: and NSEvent instance keyRepeatDelay,
keyRepeatInterval and pressedMouseButtons. These are the already recorded
reviewed receiver quirks; the expected-missing list and production receivers
remain unchanged. Their coherent forwarding contract is a separate dependency.

An initial selector harness filename collided with the original test's output
directory; no SDK child ran in that attempt. The harness path was corrected and
the real test executed once. All SDK children completed, source/font guards
matched and both bounded slots were released in finally. Mac x64 and native
Linux/Windows/normal-CI static-provider verification remain separate gates.


Integration now wires JAIC_TEST_FONT_PATH into both actual interpreter and native FreeType fixture invocations. A missing/non-file input becomes an explicit failed input row and never substitutes a platform font or reports unavailability. Three pure argument-policy tests and the four inventory tests pass. The three Rust filesystem regressions and warnings-denied Clippy pass; the original SDK selector audit remains separate from discovery. Producer's four shared-FreeType Mac modes are attributed to its ready manifest, not projected onto the integrated static-provider CI recipe.
