# Portable implementation questions

This document records unresolved public contracts and compiler integration gaps.
It is not a source of invented compatibility behavior.

## Bootstrap

- The Runtime_Support specification declares three module parameters, while the
  supplied compiler also passes `TEMPORARY_STORAGE_SIZE`. Accept that additional
  compiler configuration parameter internally, without adding a public symbol.
- Several native/runtime internal hook names are required by the compiler but
  absent from the public declaration inventory. Keep implementation hooks file
  local; verify the generated runtime separately from the public facade.

## Basic

- String_Builder.Buffer conditionally contains `ensured_count` when
  `ENABLE_ASSERT` is true. The Basic page does not declare where that setting
  comes from or its default. The current implementation includes the field only
  when that configuration name exists and is true; otherwise it uses the
  documented shape without the optional field. This is not a settled default.
- The dynamic-array prose mentions `array_pop`, but the declaration inventory
  exports `pop`. Only `pop` is implemented; no convenience alias is invented.

## Compiler integration gaps

- Passing a bare block to a Code parameter through the reexported one_time_init
  macro reports `a block used as a value must end in an expression`. Explicit
  `#code { ... }` works. Preserve macro/Code argument semantics through aliases;
  do not add public convenience overloads to bypass this general resolver gap.
- `#run get_current_workspace()` fails with `get_current_workspace is a compiler
  primitive; it runs only at compile time`, even though the call is in #run.
  Reproduce with `tests/portable-stdlib/pending/workspace-hook.jai`. No zero
  workspace fallback is fabricated. Thread currently preserves its workspace
  field; automatic population needs the reviewed runtime/compile-time contract.

File.file_seek takes `Seek_Type`, but no current reviewed page declares that
type's owner, shape, values or public visibility. Absolute seeking is supported
through file_set_position; file_seek is withheld pending that declaration.

Basic.ConvertToApollo is an expansion with no declared result. Its caller
binding convention is not specified. Duration factories and ConvertFromApollo
are implemented directly; this macro remains unresolved.

File_Utilities platform root/header and max_words formatting behavior needs
operation-level review beyond the focused public path fixture.

## Hash

- Scalar get_hash is described as the upper 32 bits of a Knuth product "after
  mixing with the seed", but the exact mix (addition, XOR, or another transform)
  is not specified. This prevents an exact scalar compatibility implementation
  and the default scalar-key Hash_Table.hash_function. Please specify the
  formula and vectors, including negative integers, pointers, bool and enums.
  Byte/string hashes and custom-hash table instances can proceed independently.
- Hash_Table.Walk_Table takes Code only; its required caller bindings and yield
  convention are not documented. Do not infer its expansion from the name.

- `Temporary_Storage_Paged_Alloc` initially failed because overlay layout checked
  only direct fields. Resolved by the compiler worker's general promoted-member
  layout fix; the
  rebuilt source compiler now passes `tests/portable-stdlib/temp-storage.jai`
  in interpreter/native mode. The exact public shape is enabled unchanged.

## Thread configurations

- The source of Thread's DEBUG and _STACK_TRACE settings is not declared in its
  module-parameter contract. Release synchronization is supported; DEBUG=true
  and DO_RACE_DETECTOR=true configurations are explicitly rejected until their
  tracking/hook contracts are implemented. Windows/iOS/console backends remain
  unfinished.
- LOAD_THREAD_GROUP=false operationally omits group loading and the worker_info
  field. The reviewed inventory does not label every group export's availability
  in that configuration; exact conditional-export review is still needed.
- Shutdown joins workers before freeing state, including queued completion
  records. Retrieve completed work before successful shutdown; work payloads
  remain caller-owned. The specification does not settle any post-shutdown
  completion-retrieval guarantee.
- The new macOS binding module currently cannot be imported because its
  CFArrayEqualCallBack references an undeclared Boolean type. Thread uses a
  narrow private Mach synchronization ABI adapter from Apple's official SDK
  headers, preserving its primitive port field types without modifying the
  bindings worker's source or exporting replacement macOS declarations.

## Native Socket declarations

- The Socket page's Windows FIONBIO expression contains an incomplete `#char`
  literal. That declaration is withheld by the generator and recorded in its
  ledger. Several Android/macOS aggregate variants are also missing; only the
  macOS in_addr shape has been supplemented from the official Apple C header.
- Unix File_Utilities.visit_files and related aliases do not include the full
  callable signatures of their posix_* targets. Preserve the alias names, but
  require the missing signature/default information before exporting wrappers.

## Process

- The boolean from get_process_result is not specified for a successful query
  that reports STILL_RUNNING. The current implementation reports query success;
  exact compatibility of that boolean needs review.
- The specification does not define run_command's stdin inheritance or deinit's
  behavior on a live child. The current run_command closes its unused stdin
  writer, and deinit closes stdin then waits/reaps. Interactive input uses the
  create_process/write_to_process interface. These choices need operation-level
  review before claiming full compatibility for interactive/live teardown cases.
- break_command_into_strings' quote character set and adjacent quoted/unquoted
  fragment behavior are not specified beyond the reviewed double-quote fixture.
  Only that limited double-quote grammar is currently supported.

## Command_Line

- The specification does not define eligible-member handling for nested using
  structures or overlays, the success boolean for help-trigger requests, or
  whether partially consumed numeric argument values are accepted. Flat scalar
  and fixed-array fields are supported; help returns false and numeric values
  must consume the whole supplied argument. Exact review of those edges remains.
- Bare versus prefixed help-trigger priority and exact help text layout are not
  specified. Notes/comments, option sorting and prefix selection are tested;
  exact reference whitespace/text is not claimed.

## Apollo duration representation

- The Basic page declares FEMTOSECONDS and conversion signatures but does not
  explicitly define Apollo_Time's numeric unit, rounding tie rule, epoch relation,
  or invalid-sentinel behavior for every conversion. Current duration functions
  assume signed integer femtoseconds and rounding away from zero at ties. Local
  arithmetic/round-trip tests verify those assumptions internally, not reference
  compatibility. Do not count these conversions as compatibility-established or
  extend native/calendar conversions without a reviewed representation contract.

## Flat_Pool defaults

- DEFAULT_VIRTUAL_MEMORY_RESERVE and OVERWRITE_ALL_POOLS_ON_RESET are referenced
  but their values, declaration scope and import-time override convention are
  absent. The default init signature cannot yet be implemented exactly without
  inventing a default reserve or an export. Explicit-reserve VM behavior is
  independently implementable; the missing defaults still require review.

## Wav_File

- Duplicate format/fact chunks are unspecified. Current parser takes the first
  format/data and last readable fact chunk. Exact duplicate-selection behavior
  needs review; extensible format tags remain rejected.
- Compiler gap: tests/portable-stdlib/pending/widened-bitwise.jai shows that
  cast(u32)low | (cast(u32)high << 8) with u8 inputs yields 64 instead of 8000
  in interpreter and native modes. Wav_File uses explicit u32 locals before
  shifts. Fix contextual type inference/lowering generally; no symbol-specific
  accommodation is requested.

## Remap_Context

- Compiler gap: pending/macro-push-context.jai preserves a failing lexical
  restoration assertion for backtick push_context,defer_pop in an expansion.
  The push ends at the macro block instead of the caller's enclosing block;
  subsequent changes reach the original context. Fix caller-scope context push
  generally. Remap_Context() is withheld; both remap_context procedures work.
- Duplicate names between foreign base and custom fields, and optional stack
  trace adjustment's activating build option/behavior, are unspecified. The
  current plan copies custom fields then base fields; duplicate destination
  names are therefore overwritten by the base. No duplicate-name guarantee or
  optional stack-trace adjustment is claimed.

## System

- Linux processor query variants currently use the documented permitted fallback
  to online logical count. Reviewed Linux physical/performance-selection details
  are absent; topology differentiation remains incomplete. CPU-counter meaning
  (including its Unix fallback timebase) is unspecified and that export is withheld.
- The current source compiler CLI accepts linux/windows/macos/wasm OS targets
  and rejects android. Android native System/POSIX paths cannot be target-checked
  through that CLI yet. macOS x64's passwd shape is missing in the new POSIX
  inventory; the current host validation is macOS arm64.

## Integration refresh21 public shape/behavior precision

- Socket inventory explicitly declares macOS addrinfo at line3014, but its shape section lists only Windows/Linux/Android variants. The earlier integration availability classification was incorrect and is corrected. Apple's installed public netdb.h:147–156 gives C fields/order (int flags/family/socktype/protocol, socklen_t addrlen, canonname/address/next pointers). Supply the exact public Jai macOS field types, especially AI/SOCK/IPPROTO versus plain integers, so reflected names/types are not inferred from another platform. Native ABI assertions remain required and failing until this real missing binding is implemented; no test is retired.
- Protocol_For_Memory_Visualization declares compare_alloc_and_free_traces returning bool but gives no comparison rule. Confirm pair equality versus ordering and null treatment. The retained original public-import regression expects pair equality; that legacy expectation alone is not authority to implement the omitted export. No guessed comparator/stub is added.
