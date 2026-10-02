# External global data

## What it is

External global declarations bind ordinary typed storage to a native data symbol. Their implementation is being integrated for genuine source forms such as `counter:s64 #elsewhere;` and `state:State #elsewhere libc "native_state";`; source parsing, checked storage, VM access, and native publication each have separate readiness gates.

## How it works

The source parser in `jai-syntax/src/external_data.rs` preserves `ExternalDataBinding`: a bare `#elsewhere` selects the program provider, while `#elsewhere libc "native_state"` retains the library path and optional decoded symbol name. Its span covers the directive and its arguments, leaving the declaration semicolon to the caller. A program binding uses the declared source name; a program-only string alias has no established source grammar and is rejected.

Global and local variables use `Declaration::External { name, ty, binding, attributes }`, retaining the original unresolved `TypeSyntax` even for scalar annotations. Storage alignment remains ordinary declaration metadata. The variant has no initializer: `counter:int #elsewhere = 42;` is a located error. The scalar compatibility parser rejects this source storage domain. Parser tests establish the original file/statement origins and library/symbol boundaries; checked storage and execution are verified separately as their integration gates close.

Symbol literals use the ordinary byte-string decoder, so escapes preserve their decoded spelling. This source metadata contract requires UTF-8 symbol names; invalid decoded bytes produce a diagnostic at the original literal. Empty names and embedded NUL remain facts for the checked native-symbol validator to reject before publication.

The exported IR data contract retains the canonical type, explicit `Program` or `Library(ForeignLibrary)` origin, resolved native symbol, and original source file/span. Its three focused constructor tests passed for real source origins, registry ownership, malformed symbols, invalid span extents, and aggregate readiness. A reserved record cannot publish external storage until its actual fields are defined; its canonical type ID remains unchanged when those fields become ready. `GlobalInitializer::External` and `Global::new_external` now publish this checked storage independently of ordinary initial values. A bare program symbol does not invent a library identity. An external declaration must never become a zero-initialized ordinary global merely because its native provider is unavailable.

File declarations retain their actual declaration ID. Local declarations retain their checked procedure ID and a typed lexical registration index; the dense `GlobalId` is a separate storage identity. Final validation checks the full canonical library descriptor and rejects duplicate declaration identities. A local inside a temporary compile-time wrapper also needs its real owner's publication proof. The separate source-owner ledger retains the checked body, source identity, complete global prefix, context, and place arena, then revalidates them at final publication. Both local external data and local foreign-library metadata consult that actual owner domain; manufacturing a runtime prototype cannot satisfy it.

Native global demand follows checked global places through fields, indexes, addresses, and called procedures. Inactive constant branches, terminated bodies, and uncalled procedures do not demand their globals. Exported globals are roots. This gives the linker the actual canonical library identities needed for data access, independently of foreign procedure demand.

The LLVM bridge emits an external declaration without an initializer and uses the checked type's target layout for ordinary accesses. Synchronous and resumable VM accesses reject unprovided external reads, writes, and addresses with the actual `GlobalId` before allocating storage; an unused external declaration may still execute unrelated code. Provider snapshots compare the complete external metadata, and preflight charges symbol/provider metadata without hydrating a value. Source mutability and provider ABI remain explicit facts, with no inference from a symbol's spelling.

Two isolated tests of the LLVM declaration helper passed against installed LLVM: compatible checked aliases share a single external symbol with no initializer; incompatible storage and collisions with an existing function fail before LLVM can silently rename the data. These helper checks do not establish source binding or native execution acceptance.

Independent fixtures under `crates/jai-codegen/tests/fixtures/external-globals-*.jai` use a fresh C provider declaring a scalar and an aggregate. `external_global_source.rs` registers the acceptance harness, which compiles that authored C into a fresh archive, compares native addresses, and makes C read back Jai writes at O0 and O2. A separate unused declaration checks that no provider is required merely to describe the symbol. Both VM execution paths also check rejection/completion and unchanged allocation counts. The C provider passed a strict installed-Clang syntax check; harness execution acceptance remains pending the coordinated compatibility gate. These fixtures contain no original source or supplied native assets.

The compiler's owned `Runtime_Info` checkpoint is a separate certified program-data mechanism. Its compile-time null global-data field does not authorize a fabricated value for arbitrary external symbols. The reviewed VMA dependency workflow has no approved data-symbol ABI; reached external data from that dependency must fail before a receipt or native build tool is executed.

An actual `#run` access reports `external global <index> has no checked compile-time data provider` at its source execution origin. It cannot silently read zero or load host data. Native publication checks both owned-before-external and external-before-owned declaration orders: an exported owned global cannot steal the same native symbol and be renamed by LLVM. These source rejection fixtures are registered in the CLI acceptance suite; their execution gate is currently pending.

## How to change it

The data representation is in `jai-ir/src/external_data.rs`; source syntax and semantic binding belong to their parser and resolver owners. Preserve full `SourceSpan` origins across imports and preserve the exact foreign-library ledger entry. Update synchronous and resumable VM accesses together, including continuation-provider compatibility checks.

Keep the unresolved type, storage alignment attributes, provider path, and original binding span together; reject initializer syntax instead of constructing an ordinary initialized variable. Extend every exhaustive declaration consumer with its actual source contract when adding a storage domain. Focused source tests run with `RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-syntax --test external-data --locked --offline -j1`; literal/provider helper tests use `--lib external_data::tests`.

Keep native demand rooted in typed IR identities. Extend the general native provider fixtures when changing scalar, aggregate, projected, or address access, and independently review any new dependency data ABI before widening a restricted native dependency workflow.

## Configuration

The staged native acceptance harness is enabled on 64-bit macOS and Linux. It creates its C object and archive in an owned temporary directory using installed Clang and `/usr/bin/ar`; Windows publication needs a platform-appropriate archive tool adapter before enabling this fixture there. These platform conditions describe availability, not an execution pass.

External declarations grant no compile-time host I/O permission. Native fixture builds use the repository LLVM toolchain and trusted installed Clang. `JAI_RS_CLANG` selects the trusted test driver; native dependency receipts retain their existing private authority and protected-source restrictions.

## Dependencies

The source graph and semantic type registry, checked IR and foreign-library metadata, native reachability, LLVM storage lowering, VM byte memory and continuations, and CLI native dependency handling. Fresh authored C providers require only installed standard headers and Clang.
