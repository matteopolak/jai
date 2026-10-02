# Thread runtime repair boundaries

- Root reports native Linux ARM64 exit -11 without native backtraces. The SDK
  storage mismatch is independently proven; whether it explains every original
  SIGSEGV remains unresolved until actual Linux CI replay. Request native
  backtrace/PC if any failures persist after both repairs.
- Interpreter scheduler handles must not reach native pthread naming APIs.
  Compiler owner has the synthetic-ID routing repair; stdlib naming signatures
  are already correct and remain enabled. No lifecycle/name suppression fix.
- Real ARM64 glibc headers establish mutex storage48/align8 and mutexattr
  storage8/align4. Old source used x64 sizes40/4. Both records corrected.
  Alignment8 for mutexattr was an incorrect initial test assumption, not a
  production requirement; the failed C receipt is preserved.
- Broader ARM64 POSIX pthread_attr_t and pthread_condattr_t storage and internal
  mutex field type audit belongs to bindings. These records are not passed by
  the inspected Thread lifecycle. Do not describe this narrow correction as
  full POSIX ABI coverage.
- Public Thread storage/allocator lifetime still extends through completion
  observation and join/deinit. Independent named native lifecycle controls
  preserve borrowed state and storage, rather than relocating/copying it.
  No supported contract has established a separate lifecycle bug in this batch.
