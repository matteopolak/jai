# Source placeholders

## What it is

A source `#placeholder NAME;` reserves a declaration name that later compiler insertion may fulfill. The name alone does not supply a type or value.

## How it works

The source parser retains the original interned name and the directive-through-semicolon span. It requires exactly one name and leaves the following file item unread. The supplied placeholder tutorial reserves `TRUTH`, then fulfills it through `add_build_string("TRUTH :: true;", -1)`.

The file parser emits a dedicated declaration marker. Graph registration handles that marker before allocating a `DeclarationId`, and scoped dependency discovery skips it because the marker has no body. Procedure and record placeholder contexts have no established source contract.

The graph consumer keeps a separate source reservation ledger. A marker receives a `PlaceholderId`, its actual file/module destination, visibility, and original source span. It does not receive a declaration, procedure, type, or storage identity. A later real declaration fulfills the reservation through the canonical namespace binding; an overload group retains its real member declarations. An unused marker does not require runtime materialization.

Fulfillment follows the original destination namespace. File-private reservations and unrelated modules cannot satisfy each other. The actual declaration's visibility controls access: an exported marker cannot export a later private definition. Module imports retain reservation links beside ready bindings so an available initializer or generator can be called without demanding every unfilled name in that module. Selecting an unfilled name reports that demand and identifies the original marker.

`modules/placeholder_demands` retains the actual reservation ID and demand source span. Diagnostic-only lookup adapters keep their AST source fallback, which matters when a quotation uses the caller's lookup scope. Builtin type-value fallback applies only to absent names; an unfilled reservation spelled `int` cannot turn into the builtin type. Scalar domain and value preparation also consume the exact captured `SourceCaptureValue::Scalar` from an inserted file's own publication; they do not fall through to an equal-spelled outer declaration. Captured import and checked `using` prefixes keep unresolved marker links separately from real bindings. Declaration snapshots retain those links at their original source position, and effective inner shadows take precedence when exporting an insertion capture.

Exact re-registration of the same authored source marker is idempotent. It is checked before collision validation, because a generated filler can have a different `SourceId` from the original marker. A second marker statement or namespace still conflicts.

Generated file-private fulfillment binds at the canonical insertion destination. Failed insertion restores the full reservation ledger and namespace bindings together, including links created before the failed declaration, so retries cannot retain partial fulfillment.

Generated source can also supply a type needed by a global or procedure header. That case requires a typed preparation dependency and available generator work before the next graph publication. It must not reserve a guessed global type, use an arbitrary default, or classify the marker as an ordinary constant dependency. Parameterized type preparation carries a `PendingType::Placeholder` with the genuine demand identity. Its paired scalar evaluator preserves that cause through array counts and inferred record arguments; `PendingType::RecordModifier` remains separate. Only diagnostic clients render these causes into messages. Scalar domain inference reads canonical annotations before requesting selected values, so an inactive ready type can influence the result without running its initializer. A checked `#run` constant needed by an array count retains its actual declaration ID until its real readiness job completes.

## How to change it

Keep the dedicated file declaration kind outside the real declaration inventory. Namespace discovery must retain its reservation identity, reconcile a later declaration, and diagnose unmet demand. Extend `jai-modules`' placeholder ledger and import links when changing namespace behavior. Keep unresolved placeholders distinct from ordinary constants and type aliases. Do not create a dummy type or default value to satisfy lookup.

The semantic `source-placeholders` fixtures cover static fillers, original demand spans, lexical shadowing, conditional registration, visibility, and available imported callables beside unresolved exports. The Driver fixtures cover generated constant/type fulfillment and effect replay. Run them through the coordinated integration gate before claiming combined scheduler acceptance. Keep both early header/global demands and ordinary body demands in that gate when changing preparation ordering.

## Configuration

The syntax has no options or initializer. The terminator is required. Existing `#scope_export`, `#scope_module`, and `#scope_file` directives determine the reservation destination and visibility. Generated fulfillment uses the normal source scheduler and its pass/input limits; there are no environment variables or filename exceptions.

## Dependencies

`jai-lexer`, source symbols and spans, module declaration discovery, the semantic demand adapter, and the insertion/fulfillment scheduler. The parser recognizes the exact directive spelling at the lexical boundary; unknown directives remain errors.
