# Two Http App fixtures: exact target review

Owner: Linux Io/Http producer. Foundation owns the non-platform catalogue
capability function; integration alone owns Git/index and global wiring.

The preserved `Extensions/Http/module.jai` loads `app.jai`, `client.jai` and
server support only under `OS != .WASM`. WASM deliberately exports the portable
codec surface. The preserved public App GET/POST overloads take an App pointer,
baked route template and handler. No missing App implementation is indicated.

| Fixture | Intended supported expectation | WASM disposition |
| --- | --- | --- |
| `tests/extensions/http-client-overload-lint-repro.jai` | Native runnable route-registration positive and contextual lint regression. Its comment explicitly expects compile/interpreter acceptance of the App overload. | App is outside the selected public surface; mark the two WASM catalogue modes unavailable, retaining required native execution. |
| `tests/extensions/http-dependency-consumer.jai` | Native runnable enclosing App/Client consumer; keep route registration, cleanup and header count/removal assertions. | Same native-only surface requirement, already present in the current foundation metadata helper. |

Neither has a compile-only directive or a general expected-error premise.
Downgrading either solely because it failed on an unknown selected target
would hide a supported positive. The source review supports exact target
requirements, not a blanket HTTP exclusion or a fabricated App on WASM.
Native Windows remains required too; this local source matrix does not prove
its runtime/provider closure.

The only fixture edit removes the genuinely unused Basic import from the
overload lint repro. Both route bodies and cleanup calls are unchanged, as are
the dependency consumer's assertions. No Extension source was edited.

Foundation proposal, not a shared-file edit: expand the existing
`apply_foundations_capabilities` equality check for
`extensions/http-dependency-consumer` to membership of that ID and
`extensions/http-client-overload-lint-repro`. Retain the same native-only
App/Client capability and two WASM-unavailable modes. All other case IDs,
native execution requirements, expected outcomes and declared codec/termination
WASM positives stay unchanged. The exact hunk is
`http-app-target-review-_pdpduno/foundation-http-target-proposed.patch` in this
owner's T7 namespace, SHA256
`4c73aff499680ee08a925999afd7102f28680c04f42293f7bad1833609e9356f`.
Its input helper SHA256 is
`4183e6cfd418240eb60646b160fe5060ca5682b022faa34be7d5fcdf266bd60d`.
Foundation must adopt/reconcile it; no parallel catalogue provider is added.

Focused current-source receipt `final-source-receipt.json` in that same T7
directory passes ten checks: both fixtures typecheck on Mac arm64 and Linux
x64/arm64; both explicitly fail WASM source checks at their App reference;
unchanged `http-codec-roundtrip` typechecks for WASM; strict lint passes both
fixture roots with complete coverage and no incomplete/unvisited files.
The WASM rejection is a boundary control, not a conversion of the original
native-positive fixture into a generic expected negative. The codec positive
remains required. All 1,009 source hashes remained unchanged during checks.
No application interpreter/native/network/GUI/fault execution occurred.

`tests/tools/test_http_app_target_metadata.py` checks exact case selection,
preservation of native positive expectations, retained portable/WASM cases and
idempotent attachment. Shared current metadata is still RED for the missing
overload-repro entry (two other test methods pass). An isolated current-input
candidate with only the proposed hunk passes all three methods; it is not
claimed as production adoption. Ruff check/format pass. Root/integration must
rerun the test against the actual foundation adoption before claiming closure.

Retained earlier evidence includes the unused-import strict-lint error and
an initial invalid harness `-cpu wasm64` invocation. Corrected `-os wasm`
commands establish the actual App boundary; CLI misuse is not counted as a
negative pass.

The root 940 Mac job location does not identify the selected fixture target.
Request sanitized argv/OS/CPU/mode, case capabilities and capability-dispatch
identity for both reported records. The dependency consumer is already marked
native-only in current metadata; stale/unapplied selection metadata is a
possibility, not an established cause. Any actual native selected-target
failure remains required and unresolved until reproduced on the corresponding
source/compiler identity. Do not waive it based on the WASM boundary proof.

Integration should link this developer note in docs/README.md. The separate
Linux connect/backlog investigation still awaits root-admitted retained
metadata; load, copies and deadlines remain unchanged, and the original Linux
failure is required. No release/publication or Git operation is authorized here.
