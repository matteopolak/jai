# Native build repair deviations and limits

- **Pinned source patch:** xxhash070/windows-arm64 stages four verified files and
  changes one preprocessor guard in xxh3.h. Observable effect is selecting the
  existing unsigned multiplication instead of an unavailable x86 intrinsic.
  No algorithm/export/ABI/assert/CRT changes or fake intrinsic are introduced.
  Cost is a small build-only copy; runtime performance is unbenchmarked. Hashes,
  exact one-anchor matching and a pinned revision check reject silent drift.
  Long-term retirement requires a reviewed compatible upstream pin, including
  version-specific XXH3 hashes/state ABI review.
- **Cross-host setup:** official Microsoft SDK/CRT packages were downloaded into
  this worktree and SHA-256 checked. SDK search paths were supplied via INCLUDE/
  LIB, and -fuse-ld=lld selects the local cross linker. These are tool setup for
  reproduction, not replacement headers, fake libraries or production changes.
  Package provenance is documented. No SDK downloads are added to production.
- **Verification limit:** actual ARM64 COFF/DLL/full-CRT/static/shared executable
  links and exact exports pass; Windows execution remains pending. The official
  full vector suite executes on macOS ARM64 only here. Windows x64 is an object/
  export preservation check, and Linux coverage is source-selection policy only.
  The new native runner is ready for both Windows CPUs. No genuine check was
  disabled; offline tiny-input policy tests are not native/hash evidence.
- **Scope:** existing build tool warning policy and artifact handling were not
  changed. rpmalloc artifact fixes are integrator-owned; no shared scaffolding
  was refactored or peer sources edited. All compiler/stdlib/Extensions code is
  preserved. There are no other workarounds in this narrow repair scope.
