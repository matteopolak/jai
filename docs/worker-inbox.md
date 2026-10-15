# executable_formats worker mailbox

2026-10-15: independent HEAD ad575d16. Worker owns facade, private files and tests. Existing archive parser preserved. Source tools building under assigned T7 CARGO_TARGET_DIR, jobs=2.

Public-contract questions; continuing independent work:

1. `Apple_Universal_Binary.files` uses absent `Arch_File`. Please provide exact fields and input/file ownership, supported fat variants.
2. `Elf_Program_Header(Size_Type)` omits `flags`. ELF64 wire headers require flags at offset 4, ELF32 at offset 24. Please clarify canonical layout; no duplicate decoded model will be introduced.
3. `relocation_info`, `scattered_relocation_info`, `dylib_reference`, `twolevel_hint` list `__bitfield` plus apparently extracted fields (and omit isym/isub_image); `nlist.n_un` is an unclosed nested struct. Please clarify physical ABI members versus synthetic fields.
4. `Coff_Raw_Codeview_Info.pdb_guid: Guid` has no reviewed declaration/import for Guid. Please provide canonical provenance/layout.
5. Please clarify ownership/deinitialization for Mach_O arrays, Coff.section_relocations and normalized ELF tables, including failure cleanup. Proposed borrowed input/header/section/symbol pointers and separately owned derived arrays use Basic's matching allocator, consistent with existing archive implementation.


## Portable spec refinement delivered

Refreshed executable-formats. Object-format public490/490 audit is spec-surface evidence, NOT implementation completion; worker501 missing rows are separate scope counting. Arch_File/ELF flags/Guid/MachO raw bitfield storage clarified. Parser lifetime/error policies genuinely unspecified: choose safe independent documented behavior instead of blocking. Android SDK defaults/project regeneration/manifest/key defaults clarified.


## Coordinator 2026-10-15 16:24 UTC

Latest reviewed executable-formats.md was copied into your checkout at16:14; Arch_File, ELF flags placement, Debug_Info.Guid and MachO raw bitfield storage clarified. Remaining lifetime/error policies are genuinely unspecified: choose safe independent documented policies rather than await unsupported historical guarantees. Continue real COFF/ELF/native validation.

## Worker 2026-10-15 follow-up

Arch_File, ELF flags and raw bitfield clarifications consumed; universal 32/64 in both byte orders, ELF64 RELA metadata, Mach-O64, COFF objects and PE32/PE32+ workflows now have real implementations. No compiler changes. Native C-derived Mach-O/ELF/COFF objects and lipo/lld-linked containers are authored independently. Interpreter tests cover every truncated prefix, borrowed buffers, malformed offsets/counts and allocation cleanup; native verification is in progress.

Remaining narrow public dependencies:

- `nlist.n_un` and `nlist_64.n_un` still appear as `struct {` with no members/closure in the refreshed spec. SDK wire shape is `n_strx: u32`; please confirm this is the reviewed nested public shape (rather than the SDK's conditional in-core pointer union).
- Reviewed provenance for Guid is resolved, but this independent checkout's `Debug_Info` module has no exported `Guid`. Please provide the canonical dependency through its owner; this worker will not fabricate an executable_formats-local substitute or edit peer files.
- `Elf_Endianness.MSB` is reviewed as 1, same as LSB, while ELF wire MSB tag is 2. Keeping the reviewed constant and supporting little endian parsing; please confirm the public numeric value.
- The remaining lexer/TBD declarations expose no keyword inventory, `has_a_big_exponent` threshold, here-string syntax, token lookahead exhaustion policy, or supported TBD schema versions/keys. Please provide reviewed behavior for these rather than expect inferred historical semantics. Object/container work continues independently.


## User reinforced root-cause policy

Do not patch isolated cases merely to turn tests green. Compare interpreter/native behavior on identical cases, verify reviewed test contracts, identify the shared cause, and refactor compiler/library architecture when warranted. No name/path/test-specific exceptions, suppressed diagnostics or weakened assertions. Small fixes are fine when they completely repair the cause; document reasoning and meaningful regression evidence. Call out any workaround explicitly. Integration catalogue has12 identical failures in both modes and one interpreter-only JSON timeout; no native-only failures in that snapshot.

## Worker verified phase ready for commit

467/508 refined reviewed declarations are present; 41 remain (4 raw ABI declarations and 37 lexer/TBD procedures). These counts include constants/types and do not claim full module completion. Source scope snapshot changes from draft to committed with the implementation commit. Exact supported variants, ownership and remaining questions are in portable-executable-formats.md and implementation-scope.json.

Fresh verification: `python3 tools/check_executable_formats.py` passes interpreter plus native Mac arm64 O0/O2 for objects, bitfields, relocations and the preserved archive suite. Strict lint and formatter pass; Linux/Windows x64 cross type checks pass, without target execution. Independent clang-produced Mach-O/ELF/COFF, lipo fat binaries, lld ELF/PE executables, SDK header layout assertions and readobj/otool oracles are used. Every real-object/PE prefix, four fat encodings, malformed overflows, borrowed storage and allocator cleanup are covered.

Read-only independent review reproduced three issues; they are fixed and retested in both execution modes: section-extent bounds shared by ELF/COFF relocation application, Arm ABS32/16 mixed signed/unsigned overflow ranges, and ignored PT_NULL fields. The reviewer confirmed the repaired blocks and independently reran relocation regressions. Diagnostics are asserted, not suppressed. No compiler edits, format-specific compiler exceptions, reference reads, peer source edits or network publication occurred. Existing archive.jai is unchanged.


## Remaining public object/TBD scope

Reviewed nlist.n_un.n_strx and ELF_Endianness source values resolved. Parser-specific unspecified policies permit independent documented design, not reject-everything placeholders. Implement meaningful lexer/TBD workflows against independently authored positive fixtures and official Apple SDK TBD format/oracles, retaining bounds/error diagnostics. Canonical Debug_Info.Guid dependency is routed to its owning worker; do not create a local duplicate. Continue remaining public names rather than ending at an unresolved-policy checkpoint.

Worker resumed: nlist/nlist_64 nested n_strx records implemented from the refreshed
reviewed spec; 12/16-byte layouts and nested field behavior pass interpreter and
native O0/O2 with the complete regression suite, format and strict lint. Public
ELF values remain unchanged as newly clarified. Scope is 469/508, 39 remaining.
Next batch implements real lexer/TBD workflows; official Xcode SDK samples and
the SDK tapi archive tool are available as independent format oracles. Guid is
still pending its canonical owner; no local substitute will be introduced.
