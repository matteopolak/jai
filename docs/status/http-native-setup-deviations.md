# HTTP native setup deviations — platform-io

- No HTTP/stdlib semantic workaround, fake SDK, alternative hash/provider alias,
  assertion waiver, blanket feature/profile disable or skipped genuine failure
  is introduced. HTTP's required full TLS native closure is selected explicitly;
  SDL3 configuration and its mandatory independent native gate are unchanged.
- Archive transport now moves a verified root directory, fixing an actual T7
  AppleDouble enumeration failure. No metadata exception or ignored error was
  added. Existing source-cache completion-marker trust and existing builder
  compiler warning policy were not changed by this repair.
- Explicit caller-provided complete native directories retain the CLI's existing
  trust model: the helper checks required artifacts/license and ordering, not
  cryptographic source provenance or CPU ABI of externally supplied binaries.
  Such reuse is not called pin/native proof. Fresh CI uses the real pinned builder;
  local build/symbol receipts identify the exact verified outputs. A general
  cross-library/toolchain-attested receipt mechanism would be separate shared
  native-builder work.
- Helper-built HTTP providers have source/profile/artifact identity receipts and
  cannot silently reuse changed binaries/configuration. Whole-builder hashing is
  deliberately conservative and may rebuild TLS after unrelated builder edits;
  the performance cost is setup-only and unbenchmarked. It avoids a stale provider
  workaround without changing the public CLI trust contract for external assets.
- Preparing the default HTTP/Io/Tls profile for standalone stress can build TLS
  even when a caller selects only a custom Io test. This small setup cost avoids
  guessing transitive source imports; callers can provide a complete native
  directory. No runtime/test feature is omitted to reduce that cost.
- Verification is bounded by the active integration lease: no HTTP/Jai runtime,
  GUI or fault checks were launched. Actual macOS SDK build/symbol evidence and
  Python policy tests are separate from pending Mac/Linux normal CI/runtime
  evidence. No Linux or complete Mac conformance success is fabricated. Original
  CI and own SDK/transport failures remain retained.
- All fresh outputs/cache/scratch are under assigned T7 platform-io target. Source
  and reports are in the current shared tree. No peer-owned source was modified
  outside the explicitly listed shared HTTP/native-build scope. No Git index
  mutation, remote action, credential access or forbidden raw/reference/
  quarantined/corpus-vendor implementation access occurred. Official pinned
  native SDK inputs were used as authorized.
