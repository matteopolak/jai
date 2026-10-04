# Selected standard-library protocol profiles

## What it is

A standard-library protocol profile identifies the actual canonical allocator, reflection, context, and runtime-storage declarations selected for one compilation graph. Maintained Jai projects use incompatible public shapes, so a profile must preserve their genuine nominal types and field semantics.

The current default remains the rich descriptor protocol. A private, independently authored OpenJai declaration subset and working adapter bodies are retained in `artifacts/agent-packets/basic-protocol-profiles`; its canonical compiler admission and producers are pending. This is an implementation packet, not a second admitted standard library.

## How it works

The pinned maintained inputs are the authority. Focus revision `c6b3ead7`, Vk revision `cc91b617`, and Jaison revision `2009cdb5` consume descriptor-valued member types or pointer targets. Vk also explicitly names `Type_Info_Struct_Member.Flags`. Focus's runtime stores `temporary_storage: *Temporary_Storage`. These source revisions must keep the rich canonical schema, including its nominal flags and descriptor roots.

OpenJai revision `264ba532` declares four allocator modes, with `FREE_ALL` at value 3. Its member `type` and pointer `points_to` fields are `Type`, its member flags are `s64`, its struct-member storage is resizable, and its context stores a four-field temporary arena by value. Value 3 in the rich allocator is `STARTUP`; casting between those enums would call a different operation. Reflection-tag values and widths also differ.

The finite source evidence is `evidence/pinned-consumers.json`. It records exact revisions, file hashes, selectors, and source lines without retaining reference implementation bodies. A comment-aware token scan finds `FREE_ALL` only in OpenJai's declaration among the four retained repositories. This establishes its public spelling and enum position; it supplies no observed bulk-retirement behavior. The authored allocator implements that operation through an explicit per-instance ownership ledger.

The OpenJai module is incomplete as a reflection contract. Its real runtime fixture additionally reads struct/member notes and enum members/flags that the Basic module does not declare. An older example explicitly dereferences context temporary storage even though that module declares a value field. The packet preserves those unresolved constraints. It does not invent missing record fields or claim that one declaration fragment satisfies every OpenJai fixture. Focus's nested `CONSTANT` expression at Objective_C line 315 is commented out and is excluded from active-consumer evidence; Vk's live typed flags are the retained requirement.

Source selection happens before `Nominals::reserve`, at `CompilationUnit` graph/bootstrap loading. A profile request chooses source inputs only. The graph owner must establish immutable source ownership and the designated Preload/Runtime_Support modules, then the semantic binder must validate actual declaration IDs, nominal type IDs, enum representations, fields, and procedure signatures in the same canonical arena. Names, path strings, hashes, and matching record layouts do not grant this role.

Profile selection is scoped to the actual protocol role. OpenJai's Compiler module separately declares a string-tagged `Type_Info` and a `Type_Info_Pointer` containing only `points_to: Type`, without the Basic runtime header. The default authored Compiler module already retains those independent public declarations. A graph can contain rich canonical runtime descriptors and maintained Compiler query records, provided each query producer validates its own genuine module/declaration receipt. They cannot share descriptor-header certification or be converted by copying their bytes.

The intended typed integration boundary is:

| Operation | Required input | Result |
| --- | --- | --- |
| Request a bundle | Preload/runtime source selection and requested profile | Untrusted configuration input |
| Admit canonical source roles | Genuine selected graph, source snapshots, declaration IDs, completed nominals | Owner-bound source-role receipt |
| Validate allocator protocol | Canonical allocator/mode/procedure roles and semantic operation names | Checked allocator schema plus operation map |
| Validate reflection protocol | Canonical descriptor/Type identities and exact tag/field contracts | Rich or OpenJai checked schema |
| Build/query descriptors | That checked schema and genuine represented type identity | Producer-owned header receipt and typed fields |

These are contracts for the pending migration, not newly callable Rust APIs. The existing rich path uses `allocator_schema::bind`, `AllocatorSchema::validate`, and `install_preload_schema`. A new checked variant must extend those real boundaries. `FreeAll` needs a semantic operation variant distinct from `Startup`; an operation map must read the admitted enum contract instead of using Rust enum ordinals. VM and native consumers must dispatch the checked schema variant and reject a graph carrying the other profile's receipts.

The two reflection adapters have matching helper entry points. The rich adapter obtains `Type` through the genuine exact-header `cast(Type)` inverse; the OpenJai adapter reads its actual `Type` field. The inverse must validate the original descriptor header and return the represented nominal type. It is currently pending activation in the paired compiler bundle. A copied descriptor, numeric address, interior pointer, or lookalike record cannot certify it. `find_member` borrows the first matching entry from the genuine member storage; mutations that relocate that storage invalidate the returned pointer.

The OpenJai allocator body owns separate data and bookkeeping allocations. Allocation failure frees any acquired data before publishing an entry. Resize uses the recorded allocation size, allocates and copies before publishing a replacement, and retains the old allocation on failure. A foreign heap's pointer cannot be resized or individually freed through this instance. `FREE_ALL` detaches and clears this instance's ledger, retires every owned allocation, and allows subsequent reuse. The ledger is caller-owned and requires external serialization; this profile does not advertise the rich allocator's thread capabilities. Its C leaves still require genuine checked heap-source receipts.

Those pending leaves are `bulk_malloc` and `bulk_free`. Existing heap receipts authenticate the actual selected Default_Allocator declarations `c_malloc`, `c_free`, and `c_realloc`; they do not grant arbitrary same-symbol declarations elsewhere. The new leaves need their own declaration/library/signature/target receipts, or ordinary calls through an already authenticated selected source declaration. Renaming a leaf cannot supply authority.

The four-field temporary-storage body borrows a caller-owned byte range. It aligns a real pointer within that range, checks arithmetic and capacity before changing counters, and resets only usage counters. It neither acquires overflow pages nor releases borrowed storage. The rich adapter separately reports current-page capacity and total usage through the actual richer runtime record; it does not flatten or copy that record into the OpenJai shape.

## How to change it

Keep alternate declarations under the packet's `source/open-jai-264ba5` directory until the compiler owner admits a complete selected bundle. They are canonical-role fragments to be loaded by the selected Preload/runtime graph; do not import them into Basic as replacement records. Basic must retain aliases to the selected Preload declarations, `#Context`, and the selected runtime's temporary-storage nominal.

Coordinate the source owner with allocator and reflection owners before changing schemas. Source preparation supplies nominal readiness and immutable-owner foundations; graph admission supplies the selected bootstrap/declaration receipt; allocator and reflection validation supply their sealed semantic contracts. The reflection producer and each VM/native consumer must receive the same checked variant. A profile label is a diagnostic discriminator, not proof.

OpenJai's context fragment refers to Basic's actual `Print_Style` nominal. A selected Basic loader must omit the existing separate `#add_context print_style` for that profile to avoid duplicate context members. The complete loader, source initialization and retirement paths, missing reflection contracts, builtin Any mirror, and source-bound heap receipts remain integration work. No incomplete fragment should silently replace the default.

Extend fixtures in the packet's `tests` directory when adding a field or operation. The bulk allocator fixture exercises two heaps, ownership rejection, byte preservation, idempotent bulk retirement, individual free, and reuse. The storage fixture checks padding, exhaustion, invalid requests, and unchanged counters on failure. The identity fixture assigns Basic-qualified values to selected canonical types directly. Do not replace these assignments with nominal casts.

## Configuration

No profile environment variable or new CLI flag is implemented. `profile-selection.json` describes requests and readiness; it is not a loader or authority manifest. Existing `JAI_RS_STDLIB`, `JAI_RS_MODULE_PATH`, `JAI_RS_PRELOAD`, and `JAI_RS_RUNTIME_SUPPORT` control source selection. A complete OpenJai bundle is not yet available for those selectors.

`tools/verify_profiles.py` uses the already verified owned `f5954f3d` CLI, unchanged compile-time fuel of 20,000,000, Runtime_Support bootstrap disabled, and a 30-second per-case timeout. It hashes the frozen authored source closure before and after. The current receipt reports 14/14 source parses and 477 unchanged inputs. Both rich assertion fixtures stop at existing compiler-provider gates: a suspended reflection `#run` dependency and the frozen runtime's selected-module `#compiler` gate. There is no profile behavior PASS or native execution claim.

## Dependencies

The genuine selected module graph, canonical type registry, independent Preload/runtime sources, checked allocator schema, reflection source factory, descriptor-to-Type inverse, VM/native schema consumers, and heap-source receipts. The evidence workflow depends on the retained pinned upstream source metadata and the authored comment-aware lexer. Original compilers, native objects, third-party implementations, and native runtime binaries are not execution inputs.

Pool/Flat_Pool virtual-memory modes remain separate work. Current heap receipts cover only malloc/realloc/free; no page reservation/protection receipt exists. Source adapters must obtain real reserve/commit/protect/release semantics before those modes can be claimed implemented.
