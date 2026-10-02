# Meow ancillary contracts

The reviewed page specifies the calico register API and mutable public arrays.
Current actual shared interpreter/native tests exercise the licensed native C
algorithm, real register macros, ordinary and fragmented streaming, both
finalizers, mutable array identity/read effects, and lane extraction. These do
not establish every ancillary original Jai behavior.

- `MEOW_DUMP_STATE`: exact title/lane formatting and any conditional diagnostic
  hook behavior are unprovided. Current implementation prints title followed by
  eight decimal u64 pairs; its actual output is tested as independently supported
  behavior, not asserted as reference-exact prose.
- Raw `MeowEnd`: exact post-call r1/r3 scratch values are unprovided. Current
  algorithm uses/overwrites these scratch register operands and validates the
  folded hash and independently C-derived pre-fold output.
- Both `MeowEnd` forms: Store128 writes 128 **bytes** of pre-fold state in the
  permitted native C algorithm. That behavior is implemented and compared to
  the immutable independent C-derived fixture. The reviewed Jai declaration
  gives only `*void`, without a byte extent or ownership rule; please confirm
  the ancillary writable extent rather than inferring 16 bytes from the name.

No alternate record/storage type, scalar register substitute, immutable public
table or invented diagnostic API is proposed. Native nonhost execution and new
upstream-C fixture regeneration remain separate from current shared Jai tests.
