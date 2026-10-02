# Collection iteration source acceptance

## What it is

Collection iteration uses retained source expansions, canonical generic record origins, and captured caller code. Acceptance checks distinguish complete unchanged collection files and their real dependency closures from the smaller runtime fixtures that exercise those language mechanisms.

## How it works

`jai-syntax/tests/insertion-replacements.rs` reads the original bytes of supplied `Basic/Array.jai` and `Hash_Table.jai`, Focus's `src/utils/array.jai` and `ring_buffer.jai`, and Vk-Engine's `Modules/Hash_Map.jai`. The last completed complete-file parser gate accepted four files; supplied Hash_Table passed its constrained `*$T/Table` formal and stopped at `Walk_Table`'s caller-reference expression at byte `8475`. The pending caller-reference gate must establish a newer result. An unsupported source form is not counted as acceptance.

The collection changes add lazy statement insertion replacements and real generic expansion selection. The last completed focused run passed 13 tests in `jai-codegen/tests/loop_control_replacements.rs`: ten valid fixtures completed in the Rust VM and generated native programs, and three rejection groups checked nominal mismatches, ambiguity, invalid defining annotations, deferred transfers, and located insertion errors. That run also passed the custom iteration and builtin removal suites: 18 and 11 tests respectively, totaling 36 valid VM/native cases and six rejection groups. The staged extensions increase the three suites to 58 tests; their new results remain pending the shared build queue.

These fixtures are independently authored source programs. They establish bounded language behavior, including sparse removal, forward tail revisiting, source evaluation once, captured generic arguments, pointer adaptation ranking, nested loop shadowing, definition locations, and crossed cleanup. They do not establish execution of a complete unchanged collection library.

The local report `artifacts/collection-library-snapshot-acceptance.json` checks complete genuine roots in all three existing library profiles. Its immutable integrated CLI snapshot SHA-256 is `8a52b33b52753562e987b37ec8274548e019aa62b7b611d5c432c0f5c3e00489`, verified unchanged after checking. An earlier direct probe remains in `artifacts/collection-library-acceptance.json`: disk exhaustion prevented its snapshot, so it explicitly records `immutable_snapshot: false` and verifies its distinct built binary before each stage and after all stages. Both runs report the same first failures below.

| Complete root | Result in that report |
| --- | --- |
| Supplied `Basic/module.jai`, which loads unchanged Array | Parsing stops at the caller backtick `defer` at `181:6` in all profiles. |
| Supplied `Hash_Table.jai` | Parsing stops at the constrained formal at `151:29` in all profiles. |
| Vk-Engine `Modules/Hash_Map.jai` | Parsing passes in all profiles. Diagnostic and preload checking stop in its genuine `Common/module.jai` dependency at `316:17`, `push_context,defer_pop;`. Runtime-library checking stops in supplied `Default_Allocator/module.jai` at `83:42`, `#location()`. |

No complete root passes library checking in this report. Focus's utility arrays depend on their actual project environment, including `focus_allocator`; standalone utility parsing is not a substitute for checking that environment. No synthetic entry point, replacement dependency, empty source procedure, or function implemented by its spelling is used.

The newer integrated `artifacts/standard-library-a19b4808.json` uses immutable CLI SHA-256 `a19b48087e7a534920264dd670fc4bcb9e535831c574c4ae1f7d0871df592b6f`. Both its preload and runtime-library profiles report these results:

| Complete root | Result in the a19 snapshot |
| --- | --- |
| Supplied `Basic/module.jai` | Parsing passes. Library checking stops at `Basic/Int128.jai:157:1`, an invalid operator operand signature. |
| Supplied `Hash_Table.jai` | Parsing stops at `230:29`, the caller-reference expression in `Walk_Table`. |
| Supplied `Bit_Array.jai` | Parsing stops at `115:15`, the actual `#bake_arguments` alias. |
| Vk-Engine `Modules/Hash_Map.jai` | Parsing passes. Library checking stops in genuine `Common/module.jai:316:17`, `push_context,defer_pop;`. |

This snapshot precedes the exported-while and caller-reference implementation wave. New source fixtures retain the exact Hash_Table `for_expansion` and `Walk_Table` bytes and Vk-Engine Hash_Map's `for_expansion`, while supplying their record storage independently. The Vk-Engine iterator demands its genuine `[]map.Entry` namespace type, pointer-backed entries, reverse traversal, captured sparse removal, and value mutation. The full Focus Ring_Buffer fixture loads its original file and instantiates its actual generic methods. Their VM/native results must be recorded separately from complete module checks.

Another bounded fixture reads supplied Basic/Array's exact `array_unordered_remove_by_value` function. It demands a genuine generic pointer-to-slice call, the original baked default, an explicitly baked early exit, and count updates on the caller's descriptor. It supplies no replacement function or function-name implementation, and still does not establish checking the complete Basic dependency closure.

A source-only discovery probe with that verified historical a19 compiler also loads the complete unchanged Focus `src/utils/ring_buffer.jai` from an authored driver that demands its wrapped iteration and methods through `#run`. Checking stops in original source at `41:46`, `ring_buffer.Size`. The record instance namespace fallback addresses that missing baked-member access; the probe is a before-change observation, and completed VM/native acceptance remains a separate gate.

The later bounded own-compiler checkpoint `artifacts/component-checkpoints/collection-source-runtime-20261002T140932Z/validation.json` completes 12 tests: eight valid source/VM/native cases and four rejection groups. It executes the complete unchanged Focus Ring_Buffer source, including actual add/pop/peek methods and wrapped value/pointer iteration. The exact Basic/Array removal-function and Vk-Engine Hash_Map iterator excerpts also execute with independently supplied storage. Four String cases and canonical record-instance namespace cases pass. This establishes complete-file execution for Focus's self-contained Ring_Buffer utility and bounded excerpt execution for the other collections, rather than checking their entire module dependency closures.

The baseline Vk-Engine case rejected `entries : []map.Entry = ---;`. The checkpoint privately adds lookup of allowlisted Type members through a named storage binding's canonical record type, preserving actual field precedence and avoiding runtime loads. A separate inherited-name negative fixture initially stopped at an unrelated module-qualified type-alias descriptor conversion; its refined direct nested-type annotation reaches the intended namespace guard. The report retains both baseline failures, the three-file private delta, all 767 compiler/source input hashes, final logs, and own test executable hashes. Live activation of the annotation hook and the broader integrated gate remain pending.

The fresh source-only refresh `artifacts/collection-library-b1b82044-source.json` uses immutable integrated CLI SHA-256 `b1b820444e2a6585cda11d8efc2bf2186c5a6623cf54312552ba403d4e64fd13` and unchanged pinned source hashes. All three diagnostic, preload, and runtime-library profiles retain the same first results:

| Complete root | Result in the b1 snapshot |
| --- | --- |
| Supplied `Basic/module.jai` | Parsing passes; checking stops at `Basic/Apollo_Time.jai:340:6`, the original escaped `` `return result; ``. |
| Supplied `Hash_Table.jai` | Parsing stops at `230:29`, its actual caller-reference expression in `Walk_Table`. |
| Vk-Engine `Modules/Hash_Map.jai` | Parsing passes; checking stops in `Common/module.jai:316:17`, the original `push_context,defer_pop;`. |

No complete collection module dependency closure checks successfully in this refresh. It invokes only `parse` and `check-library`; no original native input or generated project output is linked or executed. Compiler binary and corpus hashes are verified, while `compiler.inputs_provenance = "observed-worktree"` distinguishes current workspace observations from unverified frozen-binary build inputs.

`artifacts/component-checkpoints/implicit-ifx-integration-20261002/validation.json` retains the 45-file combined implicit `ifx` and collection Type-annotation rebase, exact expected baseline/patched hashes, and formatting evidence. It is explicitly `staged-uncompiled`: the fresh rebase has not passed an integrated compile or runtime gate. Its historical private runtime evidence remains separate from that pending activation.

Bit_Array's `only_set` binds `target_value=true` on the original four-parameter expansion. Its `only_unset` body also assigns to a by-value iterator (`slot = ~slot`). The pinned modern looping tutorial at `reference/how_to/019_looping.jai:602` explicitly specifies constant references and describes mutable temporary copies as an earlier behavior. Preserve that restriction when testing the active unset branch; accepting the dormant definition does not establish execution of that conflicting statement.

The bounded syntax prototype in `artifacts/component-checkpoints/baked-collection-syntax-20261002T135906Z/validation.json` parses the complete unchanged supplied Bit_Array file with its proposed BakeArguments AST and prefix. It checks both actual Boolean bindings and preserves the original four-formal target. Its 99 staged inputs and original Bit_Array source hash are verified after the two passing tests. This is isolated parser evidence; the live compiler's source consumers, semantic binding, and runtime gates remain pending.

## How to change it

Keep the complete-file syntax assertion strict while extending source forms. The parser and canonical formal matcher must agree about an actual constrained type rather than discarding its constraint. Caller backtick statements and references, context push syntax, and source-location expressions belong to their respective semantic subsystems; recheck the real root after resolving each first blocker because later failures remain unknown. `Walk_Table` also exports its bound while-loop name and declarations that remain visible after the invocation, so parsing its backticks alone cannot establish Hash_Table body acceptance.

Use `tools/check_standard_libraries.py` to repeat source-only library checks against a newly built integrated CLI. Select the actual root identifiers listed below. The normal runner creates a content-addressed compiler snapshot and records source hashes, configured search roots, stages, and located first failures. Keep snapshot failures distinct from compiler source failures.

```sh
python3 tools/check_standard_libraries.py \
  --compiler target/debug/jai-rs \
  --profile diagnostic --profile preload --profile runtime-library \
  --select reference:modules/Basic/module.jai \
  --select reference:modules/Hash_Table.jai \
  --select ostef/Vk-Engine:Modules/Hash_Map.jai \
  --manifest /tmp/jai-collection-library-manifest.json \
  --report artifacts/collection-library-acceptance.json
```

## Configuration

The diagnostic profile disables Preload and Runtime_Support. The preload profile searches genuine supplied source Preload. The runtime-library profile also searches genuine Runtime_Support with system entry disabled, initialization enabled, and backtrace disabled. `JAI_RS_MODULE_PATH` preserves project module directories before supplied module fallback. Compiler effects retain the checking policy; these checks do not execute an upstream project executable or load an original native library.

## Dependencies

The source inventory and library runner verify pinned inputs. `jai-modules` retains declaration and namespace identities. The shared pure matcher, generic record specialization, source Code capture, insertion replacements, and checked cleanup lowering implement the language behavior. Runtime fixtures use the Rust VM, LLVM backend, and the shared trusted native tool helper to run only binaries built by this compiler.
