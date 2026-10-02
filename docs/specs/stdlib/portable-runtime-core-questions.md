# Runtime core contracts needing precise review

The default instrumentation bodies/order and private temporary-storage
configuration are resolved. Ordinary core behavior now has actual shared
interpreter/native Mac O0/O2 coverage. Remaining questions are bounded to these
public APIs:

1. `runtime_support_assertion_failed`: after writing the supplied location,
   message and available stack nodes, is the callback required to return a
   particular bool, break conditionally, or terminate? The current independent
   body calls libc abort and has an unreachable false return. This is real
   termination, but cannot be credited as the unspecified return policy. No
   caller patch or assertion suppression is proposed.
2. `debug_break` and `compile_time_debug_break`: precise Unix trap/debugger and
   host compilation behavior is unprovided. Current Unix code calls abort;
   Windows delegates its native debugging operation. Please establish the public
   policy before replacing it with a guessed signal or invented intrinsic.
3. `__cast_bounds_check_fail` and `__arithmetic_overflow`: the declaration names
   flags/type_code/fatal but does not define the public encoding or exact
   nonfatal continuation/diagnostic contract. The supplied own compiler's
   separately documented private reason-code transport is not the public API
   oracle. Bounds/null helpers also need any required terminal/return policy
   distinguished from independently supported safety diagnostics.
4. `write_number` signed minimum: the reviewed page documents an overflow edge
   without specifying the resulting observable behavior. Current real code uses
   unsigned magnitude and can format that value; no reference exactness is
   claimed for an unspecified/overflowing case.

The current explicit `#code` one_time_init argument works, including native
concurrency. Bare block implicit conversion to Code is a separate language
contract question unless established in reviewed language specs; no convenience
overload or extra export is warranted.

No reference bodies or executables were accessed.
