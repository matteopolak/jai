# Newer project entrypoints

## What it is

This acceptance slice checks genuine pinned Jails, Jaison, and book entrypoints with our integrated compiler. Jails has a metaprogram build root; Jaison has an example application, and the book contains separate example programs rather than one application root.

## How it works

`artifacts/corpus-inline-project-roots.json` and `artifacts/corpus-jaison-project-root.json` select unchanged source IDs from the pinned inventory. Jails is checked as a metaprogram; Jaison and the book examples are checked as programs. `--bootstrap search` discovers the actual reference Preload and required module sources. Each report retains the compiler binary SHA, source hashes, command, stage result, and defining-source diagnostic.

The latest integrated binary snapshot measured here is `b1b820444e2a6585cda11d8efc2bf2186c5a6623cf54312552ba403d4e64fd13`. The four-entrypoint report is `artifacts/corpus-b1b82044-inline-project-roots.json`; Jaison's actual application and library roots are recorded in `artifacts/focus-jaison-b1b82044-bootstrap.json`:

| Entrypoint | Result |
| --- | --- |
| `SogoCZE/Jails:build.jai` | Lexes and parses; checking stops at `Basic/Apollo_Time.jai:340:6`'s escaped return with `a caller export requires a declaration or defer`. |
| `rluba/jaison:examples/example.jai` | Lexes and parses; checking stops at the same escaped-return diagnostic. |
| `examples/03/3.1_hello_sailor.jai` | Lexes and parses; checking stops at the same escaped-return diagnostic. |
| `examples/12/12.13_anonymous_struct.jai` | Its complete unchanged source now lexes and parses; checking stops at the same dependency diagnostic. |
| `examples/17/17.7_inlining.jai` | Checks successfully with actual Preload. |

This refresh runs through source checking only. The first dependency failure is the original `` `return result; `` in `ConvertToApollo`; its defining source span is retained by the report. The historical `a19b4808` report stopped at Basic/Int128's operator signature, while its anonymous-struct example failed during parsing. Source acceptance now reaches the common dependency frontier for that complete example. No fresh project output was emitted, linked, or executed in this refresh.

The book is pinned at revision `19cb4b7acb0de2798c769f9ad73313a4d15f4056`; Jails is pinned at `42fa76c816ad34c9f24a4bde586d145c992dc860`, and Jaison at `2009cdb5895d36020b5a3e6be8976db4706518a9`. The anonymous-storage source requirement led to [anonymous record members](anonymous-record-members.md), whose independently authored VM and native tests establish the implemented storage behavior. Jaison's original `generic.jai` defines `JSON_Value` with an unnamed union; its example application constructs values with `.{type=.NUMBER, number=3}` and `JSON_Value.{type=.STRING, str="junk"}`. [Promoted record literals](promoted-record-literals.md) now use real nested field paths and preserve original initializer evaluation order, with eleven independent positive programs passing VM and generated-native execution at O0 and O2. Those feature witnesses do not establish a complete Jaison build. Complete Jails and Jaison project builds remain at zero.

The original inlining example also passes lexing, parsing, checking, LLVM generation, trusted-system linking, and bounded native execution. Its source has only empty local procedures and calls from a void main. `artifacts/native-book-inlining-manifest.json` pins the review and expected exit `0` with empty stdout and stderr. `artifacts/native-book-inlining-a19b4808.json` records the successful stages, generated-output hashes, and emitted-call audit; all calls target definitions in our generated module. This is one standalone example's acceptance, while Jails remains blocked.

The report verifies the frozen binary hash and pinned corpus source hashes. Its `compiler.inputs` describes workspace files observed when the harness ran; those hashes are not a verified build-input manifest for the frozen binary.

## How to change it

Add or change source selections in the entrypoint manifest after verifying their pinned inventory identity and actual program/build root. Freeze a newly built integrated compiler before rerunning, and write a report named for that binary fingerprint. Keep historical reports so progress and regressions refer to exact compiler versions.

For native acceptance, review the entire unchanged source, pin its SHA and the actual Preload SHA in a separate reviewed manifest, and supply exact output and exit assertions. `tools/check_native_examples.py` rejects source drift and audits fresh emitted LLVM before building and running only our generated output. Keep support-file checks separate from program execution and project build claims.

```sh
python3 tools/check_corpus.py \
  --compiler target/standard-library-snapshots/b1b820444e2a6585cda11d8efc2bf2186c5a6623cf54312552ba403d4e64fd13/jai-rs \
  --manifest artifacts/corpus-inline-project-roots.json \
  --report artifacts/corpus-b1b82044-inline-project-roots.json \
  --through check --bootstrap search
```

## Configuration

The reports use host targets, actual Preload discovery, and disabled Runtime_Support. Checking uses `NoEffects` for compile-time execution. The reviewed native runner bounds execution with `--timeout` and verifies generated artifact hashes before launch. The separate runtime report uses the same immutable compiler snapshot.

## Dependencies

The workflow uses `corpus/upstreams.json`, `corpus/reference-inputs.json`, the integrated CLI, source discovery, checked semantic IR, LLVM generation, and trusted system clang. It reads original source and executes only our fresh generated output; supplied native corpus tools, objects, libraries, and build scripts are outside this workflow.
