# Remaining portable contract requests

Current owned inventory:4076 reviewed API rows,3574 complete-source,
455 conservatively partial,47 missing (not conformance/test totals). Exact names
and conditions are in status/implementation-remaining.json. The large missing-
module subset has32 rows; do not confuse it with the whole owned denominator.

Priority Mac surface requests, with no /Users/matthew/projects/jai-reference/source-history inputs:

- Socket.CMSG_SIZE(size:int)->u32 is the ONLY remaining missing Mac Socket row.
  Does it equal native CMSG_SPACE (aligned header plus aligned payload), or another
  size formula? Specify alignment/range if different. Existing independent actual
  C SDK vectors cover4097 sizes and can validate the reviewed formula immediately;
  signature alone must not be guessed. Other six missing Socket rows are Android
  variants, not current Mac blockers.
- Minimal_Metaprogram: specify its supported option subset/default output/import
  path and no-input/failure policy. Current page says reduced Default/no message
  interception/fewer options, without identifying the option set. Public build
  must be real; no arbitrary delegation to full Default or fake success.
- Runtime_Support.__instrumentation_first/second: specify default observable hook
  behavior and compiler injection protocol/required calls. They are not counted
  complete via empty placeholders. If empty default bodies are established, say
  so explicitly and identify how real instrumentation is attached/executed.
- PL_MPEG: buffer_no_start_code cursor/refill semantics and BLOCK_SET/PUT_PIXEL
  ambient caller bindings are still absent. Keep the existing real decoder and
  valid tests; do not guess macro-visible names from native C private algorithms.
- Hash_Table.Walk_Table(Code) macro: identify required caller names and code
  insertion scope/iteration behavior. Current declaration does not supply a table
  parameter or ambient-binding contract.

Already resolved/current dependencies: M_Plugins dynamic loading uses the reviewed
declared-placeholder/deferred-body/indirect call with compiler89560db9; actual
public initialization and shared Default loader pass. No undeclared-callee
suspension request remains. Its parser prefix edge
when starting_index>0/plugins occur remains precisely documented in dependency doc.
Default parent output uses real during-compile API; no frozen-option workaround.
Default_Allocator exact upper-limit span byte size remains unprovided (independent
64KiB validation margin/performance policies documented). Mail's numeric alphabet
index ordering needs explicit confirmation/vector, not its now-defined transform.

Retained crypto frontier: JKS positive SDK verification/parser/decryption and APK v2 signing/
verification/digest/native EVP/error routines, plus two to_hex_string overloads.
Specify exact byte/word ordering/case/lifetime for those hex-string results and
the canonical EVP provider/ownership, SHA512-vs-fixed32 digest result, framing and
supported key/signature algorithm behavior. Real POSIX direct key generation and
canonical baked formatters are implemented/tested; no JKS success is claimed from
the host's absent Java runtime. Android project/manifest/build orchestration and
entire executable_formats are transferred, excluded from this worker's gaps.
