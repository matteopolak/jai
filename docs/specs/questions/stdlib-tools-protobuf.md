# Protobuf producer boundary requests

The tools owner read only the17 hash-listed `segcore--jai-protobuf` application
files in curated `application-corpus/ACCESS.json`. No excluded modules, reference
implementation, original checkout or quarantined input was accessed. The
application producer uses Basic/String/File and does not import
Bindings_Generator; this is not an absent binding-generator API.

Fresh source-built compiler reproduction separates two failures:

- The tests and import example insert malformed declarations beginning with a
  colon. An original schema with field `count` produces valid text at compile
  time and runtime, and its generated serializer/deserializer roundtrips. Field
  `item_count` makes the application lexer treat the underscore as an unknown
  token before Jai source insertion. The lexer delegates identifier characters
  to Basic.is_alnum. Jai should continue rejecting the resulting malformed
  declarations; permissive parser handling is not a requested repair.
- Examples01/04 have no Group/Person output because required source `.proto`
  assets are not in the authorized manifest. This does not classify the original
  applications as invalid, or establish their original complete setup outcome.

The original interior-underscore input is valid under the
[official protobuf identifier grammar](https://protobuf.dev/reference/protobuf/proto3-spec/#identifiers).
That grammar does not itself define Jai's Basic character predicates.

Coordinator/reviewer dispositions (2026-10-16):

1. **Resolved contract:** reviewed basic.md now explicitly requires underscore
   alpha=false/alnum=true, A true/true, and0 false/true. The prior false/false
   underscore observations are a canonical Basic compatibility defect. The
   stdlib owner alone repairs it; no application lexer edit, parser relaxation
   or generator-specific exception is requested. The original targeted reducer
   now asserts the reviewed table, while earlier observational receipts remain.
2. **Resolved input availability:** the coordinator admitted the original
   examples/protos/many_things.proto, importer.proto and some_things.proto into
   ACCESS with SHA256 and provenance. All three hashes verified. The earlier
   absent Group/Person setup results remain historical and must not be projected
   onto the now-complete setup. No original denied path was used, and no fake
   substitute corpus inputs were created.

Current dependency: consume the canonical Basic predicate repair, then rerun
the unchanged four application cases. Further parser/scheduling/procedure-value
failures belong to the compiler owner and require independent reductions. The
plain generated serializer/deserializer control already passes interpreter and
native Mac O0/O2; that subset is not a four-case completion claim.

Durable independent controls live in
`tests/developer-tools/compiler-requests/protobuf-format-field.jai`,
`protobuf-identifier-classification.jai` and `empty-generated-field.jai`.
`tools/check_developer_protobuf_producer.py` requires an explicit authorized
corpus path, verifies listed hashes and preserves generated output/diagnostics
under the caller's T7 target. It returns nonzero while required cases or the
underscore producer assertion fail. Passing controls and observations are not
reported as a complete corpus fix.

## Current disposition: four compile failures resolved

Shared canonical is_alnum correction consumed,29/0 protobuf-producer-xic__s84. All20 currently listed protobuf files (including3original schemas) verified by ACCESS hashes. Four original application compile checks exit0. Own plain and underscore schemas produce validJai at compile time/runtime, and generated serialization/deserialization executes interpreter/nativeMacO0/O2. Deliberate malformed declaration still rejects. Prior missing-schema and underscore observations above are historical, not currentblocks.

The original applications can print diagnostics during compile-time validation; exit0 with such output is recorded as a compile observation, not an empty-stdout oracle. Example03 still reports unavailable google well-known import in its compile-time output. Full original runtime behavior and that setup dependency remain coordinator/compiler corpus classification work; no application edits or substituteassets. Standalone current underscore-generated file without its required protobuf import fails ProtoType lookup, so that old malformed-output expectation was retired explicitly; actual imports are supplied to both real roundtrip consumers.
