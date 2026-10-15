# Data/resource implementation plan

Scope is exactly Ico_File, Icon, Windows_Resources, Subtitles and Simple_Package.
Public facades alias independently organized private services. Shared Basic,
File, Hash_Table, Pool and Compiler types retain their producer identity.

Build jaic/jailint and unchanged jaifmt from this worktree. Use only this
worktree's target for artifacts; never execute or mutate foundations staging.
Start with original public-call regressions, then implement tested behavior.

Private architecture:

- resource-wire: checked little-endian fields, ICO container/DIB encoding and
  validation, UTF-8/UTF-16 conversions used by native resource paths.
- windows-resources: manifest construction, transactional Win32 resource updates
  and SDK/tool discovery. Platform effects remain genuinely Windows-only.
- icon-plugin: Compiler's canonical plugin record plus independently owned state
  and lifecycle, once the host communication contract is supplied.
- subtitles: canonical records, parsed ownership/selection, text grammar and
  HTML/CSV renderers once their missing contracts are reviewed.
- simple-package: canonical records, creation lifecycle and a checked wire codec
  after magic/entry encoding are specified. No invented proprietary archive.

Verify actual file bytes through independent SDK consumers where available.
Keep native execution, Windows-target interpretation, cross checking and pending
platform effects separate in the per-public-API audit. Format owned sources with
real jaifmt, run warnings-denied lint, interpreter/native O0/O2 and supported
targets, preserve failure evidence, update docs/index, and commit stable batches.

No shared dependency manifest changes. Native stb linkage, Windows SDK libraries
and Windows CI need a concrete local build/integration plan if required.
