# Record placement layout

## What it is

The type registry can describe a record whose storage cursor rewinds to an earlier field. This is the checked layout foundation for source `#place`; source parsing and ordered partial initialization are separate integration work.

## How it works

`TypeRegistry::define_record_with_placements` accepts a reserved record, its field types, ordinary layout options, and optional anchor ordinals aligned with those fields. Empty anchors mean sequential storage. A nonempty list must match the field count. Each anchor must refer to a strictly earlier field, and placement in a union is rejected.

The registry constructs each anchor's private `FieldId` using the actual reserved record identity. `RecordLayout.field_placements` retains those identities after freezing. Supplying metadata through `define_record_with_layout` also checks the owner, so a field from another record or compilation arena cannot become an anchor. All checks happen before publication: a rejected definition remains reserved and can be corrected and retried.

The layout walker checks stored identities again. It rewinds the next-field cursor to the anchor's offset, applies that next field's effective alignment, and continues from the resulting position. A separate maximum extent retains bytes occupied before a rewind. Final size rounds that maximum extent to the whole record's alignment. For example, fields with layouts `[79]u8`, `[2]u64`, and `u64`, with the second field placed at the first, have offsets `[0, 0, 16]` and size 80 under LP64. Nested arrays use that final size as their stride.

The LLVM mapper represents placed storage with a verified zero-sized alignment carrier and a byte array covering the entire record extent. Field projections use semantic byte offsets, so whole loads, stores, and copies include overlapping and padding bytes. Constructors still return `UnsupportedPlacement` until ordered sparse writes are supported. The parser's [placement helper](record-placement-syntax.md) and [Thread acceptance fixtures](thread-placement-acceptance.md) cover the remaining source boundary; their presence does not establish source placement execution.

An explicit source field default `=---` has completed `NoWrite` readiness with its original source recipe retained. It never enters the typed ready-value map and does not stall as a pending provider. Construction requesting that default currently diagnoses missing sparse initialization support. Whole declarations `value: Record = ---` retain their existing no-store behavior. Selected override recipes over a skipped field remain retained; their effects have not been executed by this checkpoint.

## How to change it

Keep owner validation and publication in `registry.rs`, target arithmetic in `layout.rs`, and source name resolution in semantic record checking. Do not expose a free `FieldId` constructor or bind an anchor through a field-name string convention. Adding nested or indexed source anchors requires a checked projection contract rather than treating their spelling as a direct field.

The staged semantic resolver in `record_placements.rs` accepts ordered physical field names and placement targets. It binds actual interned symbols to earlier field ordinals, counts anonymous embeddings without inventing names, and reports unsupported compound targets at their original spans. It is currently test-only: the production source-member adapter must pass selected members in their original order before the parser feature is activated.

Construction must preserve declaration-order writes and skip `---` fields entirely. Storing a zero or undefined value into a skipped overlapping field would overwrite prior initialized bytes or pointer provenance. VM [storage-only snapshots](aggregate-storage-snapshots.md) retain the initialized mask when not every semantic field can be decoded. Keep the constructor rejection until the sparse write contract is implemented.

Complete overlapping constructors also require an ordered recipe. For defaults `a = 1`, an overlaid `b = 2`, and a final literal override `a = 42`, the last write must leave both aliases reading 42. A map containing only the final value of each field would incorrectly store `a = 42` before `b = 2`. The planned recipe therefore records explicit zeroed or uninitialized backing separately from ordered default and override writes. Ordinary disjoint `RecordBuild` keeps its complete zero-backed contract.

The [ordered initialization contract](ordered-record-initialization.md) also preserves canonical nested field paths, so a selected override can write an initialized leaf without reading or zeroing its skipped parent and siblings.

`crates/jai-types/tests/record_placements.rs` exercises frozen owner identity, failed-definition retries, foreign owners, target-dependent alignment, reduced field alignment, nested array stride, and growth/tail-rounding overflow. The registry stage passed all six integration tests and all 83 type library tests. Strict all-target type Clippy passed. The LLVM byte-storage parity test passed against the actual backend library, including overlapping offsets, array stride, and legal pointer storage. The VM layout-cache preflight charges placement validation and temporary ordinal storage without increasing retained root offsets; all 17 cache tests passed, including exhaustion without partial cache installation. The actual-source `NoWrite` job proof passed without calling its evaluator. Run the focused checks with the repository's usual Cargo environment:

```sh
cargo test -p jai-types --lib --test record_placements --offline --locked -j1
cargo clippy -p jai-types --all-targets --offline --locked -j1 -- -D warnings
```

## Configuration

Callers choose an explicit `LayoutPolicy`; there are no new environment variables or CLI flags. Placement composes with `packed`, per-field alignment overrides, and minimum record alignment. Native lowering requires target data; sparse placed constructors remain unsupported independently of ordinary custom layout options.

## Dependencies

The implementation uses `jai-types` nominal identities, target layout policy, and the Rust standard library. The native rejection lives in `jai-codegen`. Intended source behavior is grounded in the supplied source `#place` examples and changelog; no supplied native compiler, library, object, or executable is run or loaded.
