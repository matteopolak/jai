# Exact weak-float replay encoding

## What it is

`WeakFloatKey::canonical_bytes(max_nodes, max_bytes)` exports exact immutable numeric identity for compile-time replay. It preserves unrounded decimals and expression structure while excluding diagnostic origins, process addresses, and hash fingerprints.

## How it works

The encoder traverses the key DAG iteratively in left-to-right postorder. It interns records by their exact node tag and ordered canonical child IDs; ordinary hash collisions still require structural equality. Shared and separately allocated equivalent subtrees therefore produce identical bytes. No arithmetic or conditional evaluation runs during encoding.

Version 1 begins with `WFK` and byte `1`, followed by a little-endian `u32` record count. Each record contains an explicit node tag, its typed payload, a one-byte child count, and little-endian `u32` child IDs. The final little-endian `u32` names the root record. Children always precede their parent. Decimal payloads contain a little-endian `u32` byte length and validated UTF-8 spelling. Integer literals use little-endian `i128`; typed integers retain width, signedness, and raw `u64` bits. Float constants retain width and raw bits in a zero-extended little-endian `u64`.

Tags `0..7` cover float width, decimal, constant, integer conversion, cast, negation, arithmetic, and conditional nodes. Tags `8..17` cover integer width, literal, constant, boolean conversion, float conversion, cast, negation, complement, arithmetic, and conditional nodes. Tags `18..27` cover boolean constant, numeric truthiness, float truthiness, float comparison, negation, integer comparison, boolean comparison, conjunction, disjunction, and conditional nodes. Cast and integer-check policies have explicit payload bytes. The exhaustive encoder matches define their assigned values, and a pinned byte fixture checks version stability.

Cast policy payloads assign `0` to checked, `1` to unchecked, `2` to integer truncation, `3` to equal-size `force`, and `4` to prefix `FORCE`. The two storage strengths retain separate identities; neither is an unchecked numeric conversion. Pure numeric evaluation rejects storage casts that need target-layout evidence.

`max_nodes` bounds visited physical DAG nodes, including equivalent separately allocated nodes; `max_bytes` bounds the returned byte buffer. Exceeding either returns `WeakFloatEncodingError` without publishing partial output. A 1,000-level repeated DAG encodes linearly without recursive traversal.

## How to change it

Extend the exhaustive payload matches in `jai-eval/src/floats/keys/encoding.rs` when adding semantic key nodes or policies. Preserve existing assignments or bump the format version before changing any encoded meaning. A new variant must distinguish every semantic input that can change contextual evaluation; diagnostic spans and origins remain excluded. Keep the sharing, collision, raw-bit, policy, exact-decimal, and budget tests.

Consumers must retain the returned exact bytes or compare them exactly. A digest alone does not establish semantic equality. This export is identity data, not a decoder or an executable cached result.

## Configuration

Callers supply both limits according to their replay budget. There are no environment variables or unchecked default budgets. Run focused tests with `cargo test -p jai-eval --lib`.

## Dependencies

The encoder uses the immutable key DAG in `jai-eval`, validated `jai-syntax::DecimalLiteral`, and explicit operation, width, cast, and check enums from `jai-types`. It uses only standard Rust collections and does not require LLVM or host execution.
