# Browser integration against the new library

The browser crate build accepts `JAIC_STDLIB` as an explicit source-library root
and tracks that environment variable. Without it, the repository's canonical
stdlib is embedded. Testing the independent overlay does not modify a peer tree.

```sh
JAIC_STDLIB="$PWD/target/cleanroom-test-stdlib" CARGO_TARGET_DIR=target RUSTC_WRAPPER= \
  cargo test --locked -p jai-wasm --lib
```

On 2026-10-14 the existing 27-test suite passed 17 and failed ten against the new
overlay. No assertions or fixtures were skipped. Remaining failures are:

- Four File/POSIX-dependent tests encounter native-platform guards for WASM:
  `standard_input_is_read_through_the_c_stream`,
  `arguments_and_fixed_input_reach_the_program`, `lines_are_read_with_file_read_line`,
  and `threads_run_cooperatively_and_files_live_in_memory`.
- `code_added_every_round_is_expanded`,
  `output_keeps_the_order_of_stdout_and_stderr_writes`, and `arguments_reach_main`
  request `tprint`, `log_error`, and `get_command_line_arguments`, respectively.
  Legacy conveniences do not authorize new public compatibility exports.
- `allocations_the_host_cannot_make_fail_without_aborting` calls `alloc(-1)` and
  encounters the independent allocator's assertion. Its expected null return
  requires reviewed justification before changing implementation or assertion.
- `exit_ends_the_program_with_its_code` requests `exit` from Basic and gets an
  unknown-identifier diagnostic. This is another legacy dependency/API mismatch.
- `expansions_inlay_hints_and_format_strings_work_in_the_bridge` expects Basic's
  source text to contain `#load`; the independent facade uses imports and aliases.
  This assertion about source organization is not a compatibility API.

A new independent browser-host regression separately passes. It materializes
Compiler AST records, registers copied data, queries compile-time snapshots and
final runtime information, and executes target assertions and output. This checks
compiler-owned browser behavior without claiming broader library integration.
LSP library/framing suites pass 25 and three tests. Deeper new-library LSP and
portable browser dependency integration remain coordinator/peer-worker work.
