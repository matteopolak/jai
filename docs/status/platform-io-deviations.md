# Platform I/O deviations and pending verification

Role: platform-io. Scope: owned File, Windows System/Thread/runtime internals,
private encoding, original platform I/O fixtures and runner. Updated 2026-10-14.

1. **Native Windows execution unavailable on this macOS host.** Source checks for
   both CPUs and an x64 cross-linked executable are evidence of build support
   only. Runtime, filesystem and ABI behavior need the supplied runner on real
   Windows x64/arm64. Risk: native behavior may expose failures absent in checks.
   Proper fix: coordinator native CI execution, preserving any failure evidence.
2. **Local dependency/tool staging, not production integration.** This snapshot's
   compiler still expects module.jai and Basic exports a missing top-level Buffer.
   Tests use a locally source-built compiler from the permitted independent
   compiler producer and staged foundations/bindings sources. Initial compiler
   source staging hit an in-flight Option<Sym> error, then built after taking the
   corrected independent source. Risk: coordinator merge drift. Proper fix: merge
   those producers and rerun all checks on the actual integrated tree. No reference
   binary or implementation was used, and no fixture-only library was fabricated.
3. **Path length/namespace follows native Win32 policy.** The backend does not
   silently prefix every path with an extended namespace, which would change
   normalization and reserved-name behavior. Explicit extended paths work; normal
   paths may retain the OS MAX_PATH limit without long-path manifest/OS opt-in.
   Proper long-term fix: review required namespace semantics and application
   manifest policy, then test long local and UNC paths on native Windows.
4. **Known-folder and borrowed-wrapper ambiguities.** Reviewed declarations do
   not specify the folder identity behind `get_path_os_program_data`, canonical
   path prefix normalization, empty mapping behavior, or ownership of a string
   passed to `string_to_map_file_info`. Current choices are documented and sent to
   questions; they are not asserted as established compatibility behavior. Risk:
   behavior differs from a future clarified spec. Proper fix: reviewed contract
   clarification plus focused native tests, without reading old implementation.
5. **Remaining Windows Process/public crash ABI scope.** Public Process Windows
   aggregate shapes are absent from the reviewed spec. Windows crash CONTEXT is
   specified with x64 fields/size only; arm64 contract is missing. Public Windows
   Process and ENABLE_BACKTRACE_ON_CRASH integration remain incomplete. Proper fix:
   reviewed shapes, then public adapters and native validation. Existing Unix-only
   implementations are not counted as Windows support.
6. **Compiler interpreter suspended CRT-thread gap.** Windows Thread uses the
   actual CRT `_beginthreadex` with CREATE_SUSPENDED and ResumeThread, preserving
   CRT thread-local cleanup and the documented gated start. Own compiler source
   only schedules CreateThread, explicitly traps CREATE_SUSPENDED, and has no
   `_beginthreadex`/ResumeThread scheduler path. Original reproducer:
   tests/platform-io/pending/windows-crt-suspended-thread.jai. Native code builds;
   Windows interpreter behavior remains blocked until compiler owner adds generic
   suspended thread handles, resumption, and the CRT entry signature. Do not replace
   these calls with fabricated handles or run foreign callbacks unsafely.
7. **Inherited Thread DEBUG/race-detector limitations.** Existing module assertions
   reject DEBUG and DO_RACE_DETECTOR; they are retained, not suppressed. Windows
   release synchronization/lifetime is implemented; full debug tracking/order
   overloads remain unsupported and need a coherent portable implementation.
8. **Native SDK private declarations.** Missing reviewed Windows declarations for
   profile, SID/registry lookup, InitializeCriticalSectionEx, CRT `_beginthreadex`,
   command-line and low-level output operations are private ABI declarations from
   official Microsoft APIs. Fixed-width DWORD/BOOL/LSTATUS, pointer-sized handles
   and uintptr_t are used for x64/arm64. CPU records are size/bounds checked before
   variable group-mask iteration. Risk: ABI mistakes cannot be ruled out without
   native tests; long-term fix is SDK C layout probes plus native CI, and reuse of
   reviewed bindings when they contain these declarations.
9. **Runtime scope limits.** Core Windows entry/output/fatal Jai fault routines are
   implemented, but optional native exception backtraces remain blocked by public
   crash ABI review. Existing CRT abort on fatal bounds/cast/assertion failures is
   retained; no fault assertions were weakened. Unicode command-line conversion
   rejects malformed UTF-16 explicitly at startup rather than replacing characters.

No lint suppression, disabled assertion, fake descriptor or module-name compiler
special case was introduced in the reviewed File scope. Native OS operation
failures are returned or logged; mapped resource cleanup can be retried on failure.
