# Basic core public contracts: remaining precision questions

- The reviewed S128 +/- and U128 subtraction inventory does not specify signed
  overflow policy. This independent implementation uses modular128-bit limb
  arithmetic, including carry/borrow and signed-boundary wrap. Please confirm
  any stronger overflow requirement before broad corpus certification.
- The reviewed String_Builder ABI varies with ENABLE_ASSERT while the required
  Context.print_style field must have one owner. The implemented canonical
  callback ABI uses the assert-enabled builder; other-layout printers preserve
  bytes/output through an explicit ownership-safe adapter. Please clarify any
  promised cross-configuration callback/buffer-pointer identity. No raw builder
  value interchange across configurations is claimed.
