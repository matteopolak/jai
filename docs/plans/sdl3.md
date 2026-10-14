# SDL3 implementation plan

Only the new Extensions/SDL3 module and its binding/build/test/documentation integration are owned here. Existing Extensions and SDL2 stay unchanged. The requested docs/implementation-ownership.md is absent from the supplied snapshot; explicit task ownership applies.

Design: pin the official SDL3 3.4.18 release archive and license. Generate declarations from Clang's public C AST rather than regex-parsing C declarations. Evaluate object macros and ABI sizes/alignments/offsets with C probes. Keep C names, typedef identity, enum member names, callback signatures and C calling conventions. Inventory exclusions explicitly. Provide functional macro wrappers. Use a dedicated SDL3 CMake builder integrated with the existing native manifest; keep source archives in a durable hash-checked offline cache. Build static and shared artifacts and retain dependency metadata. Use platform declarations for transitive static link dependencies, and test headlessly against packaged artifacts.

- [x] Pin and verify official source, license and version; add generator tests first.
- [x] Generate complete desktop public C surface, callbacks, enums, aggregates, constants; inventory unsupported surfaces.
- [x] Verify generated Jai layouts against C and exercise callbacks, unions, event queues, memory IO, surfaces and initialization.
- [x] Integrate native manifest and reproducible CMake builds for macOS/Linux/Windows x64/arm64, offline archive validation, explicit architecture/deployment targets.
- [x] Add all-six-platform CI and release package smoke tests, preserving supplied pending edits.
- [x] Run local host build, regeneration and linked smoke tests; review and commit logical checkpoints.
- [x] Document API scope, regeneration, SDKs, link/runtime behavior and actual versus CI-pending evidence.

No approval pauses or delegation: the task explicitly authorizes autonomous inline execution. No release publishing or dispatch.

Evidence and CI-pending platform limits: [work log](sdl3-work-log.md).
