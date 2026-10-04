# Source notes and compile-time assertions

## What it is

Declaration notes retain their original source and typed argument form without executing them. Compile-time assertions evaluate checked selected source operands, including messages, and fail at the original assertion location.

## How it works

A note has an interned name and original full source span. Quoted names decode Jai string escapes to UTF-8 for identity while retaining the original spelling through the span. Ordinary word and expression arguments remain distinct. A selector such as `@selector(setItem:forIndex:)` retains a bounded vector of components and its exact colon-bearing source span; it is metadata rather than a procedure call or lexical lookup.

Records retain notes before their body and after the declaration in original order. Enum declarations, inline enums and enum members have explicit note vectors; member notes after the semicolon belong to that member. Existing record/field reflection publishes the original note text after `@`, including quoted spelling and argument punctuation. Enum notes remain retained source metadata; this change does not add fields to the physical `Type_Info_Enum` descriptor. Unknown notes do not change foreign ABI or install Objective-C methods without a separate checked consumer.

`#assert condition, Message;`, `#assert condition "literal";` and `#assert(condition, Message);` share operand parsing. File, record and body assertions use the existing typed selected-source evaluation and readiness paths. A message must be a real compile-time string even when the condition is true. Inactive source selections do not evaluate their assertions.

An insertion replacement such as `#insert(remove=#assert false "removal forbidden") body;` retains both operands as a captured typed assertion statement. Its assertion executes only when that actual caller loop-control operation triggers the replacement, in the original defining scope and source. Replacement-list commas stay separators; parenthesize comma-form messages within a replacement. Failures retain the replacement diagnostic prefix and include the checked message.

Field `#align` may appear before or after the actual initializer, including `---`. Both positions reach the same existing canonical alignment/layout consumer. Duplicates reject, and selected alignment operands must still be nonzero powers of two representable as `u32`.

## How to change it

Extend `source_note_forms.rs` for quoted names/selectors and `metadata.rs` for new typed argument forms. Update both retained-metadata admission and compiler quotation budgets before adding containers or expression operands. These visitors count real selector vectors, enum/member notes and lazy assertion messages before cloning them. Preserve source order and spans through anonymous and named type wrappers.

Keep assertion operands in `statement_conditionals.rs` and their lazy captured interpretation in `metaprogram/loop_replacements.rs`. The normal wrapper owns the semicolon; insertion replacement parsing owns its list delimiter. Do not evaluate arbitrary note arguments to improve parsing. Named note arguments and arbitrary token-tree note DSLs still require their own typed producer and consumers. `using enum` declaration admission is a separate feature.

The independently authored syntax and semantic fixtures are `notes_assertion_sources` and `notes_assertion_semantics`. The source-only packet has not yet been compiled or run; tests remain pending a coordinated build slot. Corpus counts describe historical first rejections rather than new whole-file acceptance.

## Configuration

There are no new environment variables or flags. Existing source metadata depth limits, quotation work/byte budgets, target layout policy, selected compile-time context and execution-effect limits still apply. Quoted note identities must decode to UTF-8; reflection preserves the original source spelling.

## Dependencies

The Jai lexer and string decoder, `jai-source` symbols/spans, `jai-syntax` retained metadata, selected declaration and record worklists, typed compile-time evaluation, canonical field alignment checking, code capture and quotation admission. No new external package, native ABI, worker protocol or IR value carrier is introduced.

Assertion operand scanning treats the combined `.[` and `.{` literal openings like their corresponding bracket and brace. Nested literal commas remain part of the condition, including when a comma-delimited message follows the closing condition parenthesis. The unchanged nested aggregate fixture failed in broad revision005; the delimiter repair and strengthened operand-span checks are source-only until the next integration test slot.
