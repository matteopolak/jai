# SDL3 clean-room work log

Inputs: supplied Rust compiler, reviewed docs/specs, new independent ../compiler and ../stdlib integration sources, and official libsdl-org SDL3 public release sources only. No reference compiler, other Jai implementation, history, transcripts, credentials or subagents were accessed. Missing docs/implementation-ownership.md is recorded in the questions document. Existing SDL2 and Extensions sources remain unchanged.

The official GitHub release API returned stable release-3.4.18, published 2026-10-02T22:43:21Z. Download SHA256 matched its asset digest and the pin. The extracted source's version declarations and native runtime version agree. The original source is in the durable ignored artifacts/sdl3 cache; the binding, generator, pin, notices and regeneration process are tracked.

Implementation review found and corrected these issues before completion:

- Clang erases callback argument names in type spellings: recover names from the public preprocessed declarations while retaining AST types.
- SDL_CreateThread is a macro with an exported Runtime entry point: implement the official macro in C wrappers, not a nonexistent foreign symbol.
- SDL's internal precompiled header hides/remaps wrapper functions: exclude added wrapper translation units from that PCH and extend the official ELF symbol version map in the build directory. The pinned upstream source is not edited.
- Object macros include floating values, aliases to string constants, SDLK keycodes, and MOUSE flag values: evaluate/classify all of them; do not omit based on loose substring filters. Call-site-dependent macros are explicitly unsupported instead of freezing generator filenames/line numbers.
- C's SDL_StorageInterface.remove retains its exact canonical field name through backtick declaration syntax; no public alias or renamed field is used.
- Apple ld ignores weak-framework autolink options in object files: removed that attempted approach; append the exact weak-framework linker arguments via private own-compiler workspace primitives. Static consumers preserve SDL's optional framework availability.
- Opaque external C aliases such as XEvent cannot be sized by value: force their typedefs to resolve through pointers, while aggregate/enum layout probes cover complete public value types.

Validation checkpoints (2026-10-14):

- 11 focused Python tests passed: C pointers/arrays/callbacks/variadics, callback argument names, Windows calling-convention annotations, unknown-type rejection, all-six-target build options, explicit target architectures, offline missing/corrupt cache rejection and release file inventory.
- Generated all six target C ASTs and 1,281 aggregate/enum layout assertions per target. Jai type/layout fixtures and headless/callback fixtures type-checked for macOS/Linux/Windows x64/arm64 with the authorized source-built compiler.
- macOS arm64 native static/shared C smoke programs passed (version 3004018, headless events).
- macOS arm64 runtime symbol audits and artifact SHA256 checks passed, including every translated foreign declaration and native macro wrapper.
- macOS arm64 linked Jai ABI, headless (initialization, events, memory IO, surfaces), callbacks (qsort, event filtering, threads) and macro tests passed at an earlier checkpoint. Final post-review reruns are recorded below.
- Public checkout CI literal Rust include check passed. No full corpus/release verification was run; that belongs to the coordinator.

Cross-platform evidence: other five native builds, cross-platform packaged Jai execution, Windows SDK compatibility and oldest macOS deployment execution remain CI-pending. The new six-runner SDL3 workflow builds real static/shared libraries, tests both linkage modes in C, validates offline cache reuse and every runtime export. The existing six-target release workflow now adds packaged linked Jai SDL3 smoke tests. Neither workflow was dispatched. Hardware/display/audio/gamepad/camera/GPU device behavior has not been tested; the tests intentionally require no display/device.

Coordinator pending release/spec/AGENTS edits are preserved and excluded from worker-owned commits. No versions, tags, publishing or history were changed.
