# Platform I/O contract questions

These are unresolved public-contract questions for coordinator review. Do not
resolve them from old sources, old behavior, or erroneous legacy conveniences.

## File

- Which known folder does `get_path_os_program_data` denote? Current Windows
  backend uses RoamingAppData (consistent with the public CSIDL_APPDATA constant),
  not the machine-wide ProgramData folder. This is an implementation choice pending
  clarification, not inferred proof of the contract.
- Does `file_get_canonical_path` retain GetFinalPathNameByHandleW's extended volume
  prefix? Current backend retains it. Which allocation/storage lifetime is required
  for known-folder and canonical-path results? Current results are caller-owned.
- For a zero-byte file, should `map_file` succeed with an empty view and owned file
  handle? Current implementation does so because Win32 cannot create a zero-size
  mapping. No fabricated mapped memory is returned.
- Does `string_to_map_file_info` transfer ownership? Windows currently treats it as
  borrowed unless native mapping resources are present; Unix preserves its existing
  allocated-wrapper cleanup. Clarify both platform contracts.
- Required share flags, long path/UNC normalization, move destination replacement,
  and behavior when read_entire_file starts beyond EOF are unspecified.

## Process

- Resolved by refreshed reviewed process.md: Windows Process_Platform and
  Pipe_Platform fields/layout/defaults are now implemented without duplicate state.
- Does standalone `read_pipe` wait for future input, or may it return zero bytes
  with eof=false? Current Windows implementation polls and drains/cancels its
  overlapped operation before returning caller memory, consistent with the shared
  read-from-process timeout distinction. The reviewed operation table does not
  separately define the standalone call's waiting policy.
- May callers construct or replace a Pipe.overlapped allocation independently of
  init_named_pipe_pair/create_process and then use module operations? Current engine
  manages a private allocation beginning with the actual native OVERLAPPED, followed
  by pending/allocator ownership state. Its pointer is valid for native APIs, and
  API-created pipes preserve that storage across Process copies. Module operations
  require that managed allocation; foreign allocation/ownership is not specified
  by the reviewed behavior text. Clarify before claiming arbitrary external-state
  interoperability or introducing a registry/alternate ownership policy.

## System and runtime

- Narrow review requested after cc07c00 native CI: Compiler.Build_Options defaults
  backtrace_on_crash to .ON (compiler.md), whereas Runtime_Support's true enable
  parameter imports the x64-only Windows handler (runtime-support.md). How should
  untouched default ARM64 options permit ordinary startup while an explicit .ON
  request still diagnoses? set_build_options serializes the full value record,
  so an untouched .ON and an explicit assignment of the same value are identical.
  Is default ON target-best-effort, with strict explicit Runtime_Support imports,
  or is there another reviewed distinction? Do not change the public default to
  OFF or silently ignore a requested unsupported handler. Original reproducer:
  docs/platform-io-startup-regressions.md, with no crash-field assignment.

- Resolved by docs/windows-arm64-backtrace-decision.md: .ON has no provenance;
  preserve .ON/.AUTO defaults and implement independent private native ARM64
  runtime exception handling. Public x64-shaped callbacks remain rejected on
  ARM64; no ARM64 value is cast to a public x64 record. The restored original
  default-options fixture now passes ARM64 source checking. Native execution is
  outstanding. The private backend requires the documented RtlVirtualUnwind2 API
  (Windows 11/Server 2022); older Windows ARM64 reports initialization failure.
  Supporting older Windows requires a separately validated native unwinder.

- Resolved by refreshed reviewed system.md: GetLastError's distinct u32-based
  OS_Error_Code identity is preserved. x64 selects rdtsc; other Windows CPUs use
  raw QueryPerformanceCounter. No common timebase is promised.
- Resolved by refreshed reviewed runtime pages: Windows handler availability is
  x64 only, with a 1232-byte CONTEXT and AMD64 stack walking. No ARM64 layout may
  be invented. ENABLE_BACKTRACE_ON_CRASH installs the handler from system entry
  only; initialization-only imports leave it out.

## Thread / Basic assertion configuration audit requested

- Reviewed Basic lists ENABLE_ASSERT as a module parameter and changes public
  builder layout with its setting. Own sources implement distinct first-list
  instances. Reviewed Thread has no assertion/Basic-instance parameter. What
  reviewed mechanism, if any, selects ENABLE_ASSERT=false for Thread's own Basic
  dependency? A caller's Basic(false) leaves Thread's unconfigured Basic(true)
  instance distinct. Original own IR confirms SDK calls inside Thread assertions
  remain in that configuration. Please audit only public configuration syntax/
  scope, not implementation. New public windows-thread-noassert test proves the
  caller flag and lifecycle, but must not be credited as internal-disabled
  coverage. No new public parameter or root declaration leakage was invented.

## Thread DEBUG configuration (existing open question)

- How does the reviewed Thread module receive DEBUG? It is not a reviewed module
  parameter, and Basic's reviewed inventory does not supply it. A program's
  `DEBUG :: true; T :: #import "Thread";` does not make DEBUG visible inside the
  imported module under the compiler's normal module isolation. An original check
  attempting `state.mutex.initialized` then correctly reports that the selected
  non-debug Mutex has only csection. Do not invent a DEBUG module parameter, leak
  program declarations across module boundaries or claim the debug overloads work
  until the reviewed configuration mechanism is supplied. The inherited explicit
  THREAD_DEBUG/race-detector assertions remain documented limitations.
