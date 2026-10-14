# Remaining WASI C numeric boundaries

- Non-C locales and floating rounding modes other than nearest-even are not
  implemented. They require a reviewed runtime contract and real support,
  not host locale forwarding or accepted-but-ignored requests.
- NaN payload contents are canonicalized. No platform-specific payload mapping
  is promised.
- Underflow errno uses the documented C11 implementation-defined policy:
  only a nonzero subject rounded to zero sets ERANGE; subnormals preserve errno.
  A stronger POSIX policy requires explicit review and exact inexactness tracking.
- T7 WASM output zeroing after linker completion remains a separate unresolved
  durability defect. Diagnostic durable byte copies do not clear that failure.
- The original live833 Json timeout needs its exact source/tool/profile/argv.
  The unchanged-procedure control passes under the same 180-second bound, but
  its finite shortest-format sweep dominates execution.
