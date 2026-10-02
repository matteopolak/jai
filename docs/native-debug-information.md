# Native source debug information

## What it is

The native backend emits DWARF source locations for published statements and lexical scopes, with source procedure names and supported runtime variables and source-named aggregate types. Debug metadata follows checked source provenance and actual executable IR paths.

## How it works

Semantic resolution records provenance in an optional immutable `jai-ir::DebugSources` sidecar; [emitted source provenance](emitted-source-provenance.md) describes the semantic capture sites. Entries use actual `ProcedureId`s, including sparse IDs, and existing compilation-scoped `SourceId`s. Retained source files share the original immutable parsed text through `Arc<str>` and preserve the path. Publication checks exact source allocation provenance, so records from unrelated source maps cannot pass by reusing the same numeric ID, spelling or text. `DebugSourceLocation::from_source` checks byte bounds and UTF-8 boundaries and derives one-based line and character column numbers.

Source inventory caches line starts and UTF-8 continuation-byte positions once per file; semantic collection and finalization use binary searches for coordinates rather than repeatedly scanning source prefixes.

`ProgramBuilder` validates sidecar identities against the actual procedures and prototypes and rechecks locations against its retained source inventory. Multiple specializations can refer to the same source span. Missing provenance remains valid and produces no invented file or source location.

The compile unit names the actual primary input, even when a loaded file contributes the first procedure.

With line tables enabled, `jai-codegen::debug::LineTables` uses the owned LLVM bridge and Inkwell's safe debug APIs to create a compile unit, per-procedure subprograms and instruction locations. Instruction locations follow exact published `StatementPath`s. Typed path branches distinguish blocks, conditional arms, loop bodies, case arms and subjects, pushed contexts and cleanup roots. Unannotated synthetic statements clear the current instruction location. Child bodies restore their parent location after emission. The compiler finalizes metadata before LLVM verification and optimization. LLVM emits the DWARF sections directly into native objects.

The installed Inkwell language enum has no Jai tag. Line tables use the `DW_LANG_C` compatibility encoding and identify their producer as `jai-rs`; debuggers can therefore select C expression syntax for the unit. Expression evaluation therefore follows that compatibility tag; the compiler does not claim a complete Jai debugger type model.

`DebugInformation::Variables` uses safe helpers under `jai-codegen/src/debug/variables.rs` for parameter ordinals, automatic storage declarations, nested scopes and faithful boolean, integer and floating-point type descriptors. Source-named records, unions, fixed arrays and pointers use the checked semantic registry and selected target layout; [native debug type descriptions](native-debug-types.md) explains their provenance and recursive construction. Unsupported or incompletely described types are omitted. Local records use actual checked `LocalId`s and lexical `BlockPath`s; a declaration is emitted at its published executable statement. IR parameter indices are zero based, while DWARF parameter ordinals are one based and exclude the hidden context pointer. Lexical scope and variable identities are cached, so repeated cleanup emission reuses the same variable record. A quote location in another source file receives a scope carrying its original file rather than borrowing its insertion file.

Cleanup roots retain their original declaration block as an optional checked lexical parent. Native scope creation follows that map iteratively, so deferred instructions retain visibility of captured outer variables instead of adopting a deeper invocation scope that might shadow them. Finalization rejects cyclic cleanup parent graphs; older metadata without a parent uses the procedure scope.

Top-level declarations retain provenance through the source graph. Generated and specialized procedures without published provenance remain unmapped; the backend does not infer their locations from unrelated declarations.

## How to change it

Extend `jai-ir/src/debug_sources.rs` for new immutable provenance. Keep validation at `ProgramBuilder` finalization. Statement tables use typed structural paths and validation against the IR tree; do not key them by Rust addresses or assume source statement counts match generated instructions.

Collect accurate spans at semantic lowering sites before extending `jai-codegen/src/debug.rs`. Add function type or local variable descriptions only when their language and ABI representations are known. Always finalize the debug builder before verifying or emitting an object.

Variable records point to the generated runtime storage with LLVM debug declarations. With LLVM 19 and later, debug declarations return a `DbgRecord`, not an instruction. Inkwell 0.10 casts that return into `InstructionValue` and can fail its instruction assertion even if the caller ignores the result. The compiler uses [the checked LLVM bridge](llvm-bridge.md) to insert the record directly and discard its opaque handle. The bridge constructs opaque scope and variable records itself and rejects foreign session, module, context or local storage ownership before insertion. Its session borrows the module until finalization; raw Inkwell metadata cannot be injected through its public API. Extend supported runtime type graphs in `debug/types.rs` and sealed factories in the LLVM bridge; keep unsupported types explicit until their storage and source type descriptions are faithful.

Source provenance retains text once per referenced source file so it survives the source graph's lifetime and supports validation; avoid duplicating it per procedure. If collection becomes costly, introduce a driver-controlled collection policy that preserves current identity checks.

`jai-cli/tests/debug_information.rs` covers actual source-to-object output: loaded files, shadowed primitive locals, loop variables, deferred statements, and a quote from another file rebound into caller scope. The quote regression checks the DWARF line row's file index as well as the original line, then links and executes the generated program. Keep this check when changing lexical rebinding: finding a quoted filename somewhere in metadata alone does not prove its instructions step in that file.

## Configuration

```
jai-rs build main.jai program -O0 -g
jai-rs emit-object main.jai program.o -gline-tables-only
jai-rs emit-llvm main.jai program.ll -g0
llvm-dwarfdump --debug-info --debug-line program.o
```

`-g` selects `DebugInformation::Variables`; `-gline-tables-only` retains statement locations and omits variable descriptions. `-g0` selects `Off`, the default. `JAI_RS_DEBUG=off|0|line-tables|1|variables|2` provides an environment default. The last CLI debug flag wins. Optimized builds retain LLVM's available line information, and optimization can merge or remove instructions.

Source procedures marked `#no_debug` use the typed `DebugPolicy::Suppress` sidecar policy. Their retained source provenance cannot recreate a subprogram or instruction locations. The native constructor selects only emitted body `ProcedureId`s, so unused source declarations cannot create an empty compile unit when every emitted procedure is suppressed. Marked macro bodies and their source locals are suppressed independently of caller argument initialization, which keeps its caller location.

LLVM requires calls to debug-bearing callees inside a debug-bearing function to carry a location, even when the source region is suppressed. Such a call receives an artificial line-zero, column-zero location in its actual caller scope. This is not a source line. A private module ledger retains these owned locations. After optimization, the bridge follows actual inlining location chains, reanchors imported instructions to the artificial caller location and erases only imported debug variable records belonging to that suppressed expansion. Ordinary inlining retains its callee locations and variables. The authored exported-input macro regression proves actual inlining, absence of leaked callee DWARF scopes and newly linked native result `42` at O0 and O2.


## Dependencies

The checked IR source sidecar, `jai-source` records, semantic declaration identities, LLVM 22.1 and Inkwell's safe debug builder. Native artifact tests inspect newly emitted objects with the independently installed `llvm-dwarfdump`; they never inspect by loading reference libraries or execute supplied native objects.
