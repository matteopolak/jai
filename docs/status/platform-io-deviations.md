# Platform I/O deviations and pending verification

Role: platform-io. Scope: owned File facade, File internals, private encoding,
original platform I/O fixtures and runner. Updated 2026-10-14.

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
5. **Remaining Windows subsystem scope.** Process/System/Thread/runtime backends
   are not yet complete at this checkpoint. Existing Unix-only implementations
   are not counted as Windows support. Process Windows public aggregate shapes
   are absent from the reviewed spec; do not invent them to satisfy test callers.

No lint suppression, disabled assertion, fake descriptor or module-name compiler
special case was introduced in the reviewed File scope. Native OS operation
failures are returned or logged; mapped resource cleanup can be retried on failure.
